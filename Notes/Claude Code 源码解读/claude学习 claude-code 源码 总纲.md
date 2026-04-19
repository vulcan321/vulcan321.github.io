---
title: claude学习claude-code源码 总纲
source:
author:
published:
created: 2026-04-18
description:
tags:
---
## **[Claude Code](https://zhida.zhihu.com/search?content_id=272317723&content_type=Article&match_order=1&q=Claude+Code&zhida_source=entity) 项目学习指南**

> 本文档面向希望深入理解 Claude Code 源码的开发者，提供从架构概览到实践路径的完整学习地图。

## **1\. 项目概览**

Claude Code 是 [Anthropic](https://zhida.zhihu.com/search?content_id=272317723&content_type=Article&match_order=1&q=Anthropic&zhida_source=entity) 官方的 **AI 编程助手 [CLI](https://zhida.zhihu.com/search?content_id=272317723&content_type=Article&match_order=1&q=CLI&zhida_source=entity) 工具**，本质是一个在终端中运行的 AI Agent 系统。用户在终端输入自然语言指令，Claude Code 自主调用工具（文件读写、Shell 命令、搜索等）完成编程任务。

### **`1.1 README.md`**

**你应该从这里确认什么**

先确认四个基本事实：

- 语言：TypeScript
- 运行时：[Bun](https://zhida.zhihu.com/search?content_id=272317723&content_type=Article&match_order=1&q=Bun&zhida_source=entity)
- UI：[React](https://zhida.zhihu.com/search?content_id=272317723&content_type=Article&match_order=1&q=React&zhida_source=entity) + [Ink](https://zhida.zhihu.com/search?content_id=272317723&content_type=Article&match_order=1&q=Ink&zhida_source=entity)
- 规模：约 1900 文件，50 万行以上

这四个事实直接决定你的阅读策略：

- 它不是普通 Node CLI，而是“终端里的 React 应用”
- 它不是单线程线性脚本，而是带状态、带 hooks、带 UI、带流式事件的系统
- 它的复杂度已经接近一个桌面应用，而不是一个工具脚本

**阅读重点**

重点看它给出的架构分块：

- Tool System
- Command System
- Service Layer
- Bridge System
- Permission System

这几个词不是 README 作者随便写的，它们和源码目录基本一一对应，是很好的导航锚点

### 1.2 \`src/main.tsx\`

`main.tsx` 是 Claude Code 的总启动入口，但它本质上不是“业务逻辑实现文件”，而是“启动编排器”。

它负责：

- 提前触发一些启动期 side effects
- 初始化全局环境
- 解析 CLI 参数
- 组装 tools 和 commands
- 执行 setup
- 决定进入 REPL、print 模式、remote 模式还是其他子流程

**第一层理解：为什么它这么大**

它有四千多行，不代表它把所有业务都写在里面，而是因为它承担了“大量启动条件组合”的路由责任：

- interactive vs non-interactive
- local vs remote
- worktree vs non-worktree
- agent mode vs normal mode
- print vs REPL
- feature flags on/off

所以阅读 `main.tsx` 时，不要试图线性看完所有分支。先抓启动主干。

## **2\. 核心架构**

### **2.1 整体数据流**

```text
用户输入（终端）
    │
    ▼
main.tsx                  ← CLI 启动编排器（4,683 行）
    │
    ├── setup.ts          ← 会话初始化
    ├── context.ts        ← 系统上下文收集（git 状态 / CLAUDE.md）
    ├── getTools()        ← 工具装配（40+ 工具）
    └── getCommands()     ← 命令装配（50+ 命令）
            │
            ▼
        REPL.tsx           ← 交互式对话界面（React/Ink 渲染）
            │
            ▼
         query.ts          ← 查询管道（权限检查 / 消息规范化 / 上下文注入）
            │
            ▼
      QueryEngine.ts       ← LLM 引擎核心（工具调用循环 / 流式响应 / 重试）
            │
       ┌────┴────┐
       ▼         ▼
  Claude API    tools/*    ← 实际工具执行（Bash / File / Search / Agent 等）
```

### **2.2 启动序列**

```text
main.tsx 启动序列：
​
1. 顶层 side-effects（性能优化）
   ├─ startMdmRawRead()       并行启动（macOS/Windows MDM 读取）
   └─ startKeychainPrefetch() 并行启动（keychain 预取，节省 ~65ms）
​
2. 模块导入（~135ms）
   ├─ Commander.js CLI 解析器
   ├─ React/Ink UI 框架
   ├─ 配置加载
   └─ lazy imports（OpenTelemetry、gRPC、分析模块）
​
3. preAction 钩子
   ├─ init()             初始化核心服务
   ├─ inline plugins     接入内联插件
   ├─ migrations         运行配置迁移
   └─ remote settings    异步加载远程设置和策略限制
​
4. 能力装配
   ├─ getTools(toolPermissionContext)
   ├─ getCommands()
   ├─ setup()            会话启动
   └─ showSetupScreens() UI 初始化
​
5. 模式分发
   ├─ REPL 交互模式      → launchRepl()
   ├─ Print 模式         → 非交互执行
   ├─ Remote 模式        → Bridge 连接
   ├─ Coordinator 模式   → 多代理编排
   └─ Assistant 模式     → KAIROS
```

### **2.3 查询处理流程**

```text
1. REPL.tsx（运行时壳层）
   ├─ 消息列表管理
   ├─ 工具权限队列
   ├─ 工具使用确认弹窗
   └─ 流式事件处理
​
2. query.ts（查询管道）
   ├─ 规范化消息格式
   ├─ 注入上下文（git status、CLAUDE.md）
   ├─ 权限预检
   └─ 调用 QueryEngine
​
3. QueryEngine.ts（LLM 引擎）
   ├─ 构建系统提示
   ├─ 工具调用循环
   │   ├─ 执行工具
   │   ├─ 权限检查
   │   ├─ 进度报告
   │   └─ 收集结果
   ├─ 思考模式（Extended Thinking）处理
   ├─ 流式响应处理
   ├─ 重试逻辑
   └─ Token 成本计算
```

### **2.4 权限系统**

```text
权限模式（PermissionMode）：
├─ "default"         提示用户确认
├─ "auto"            完全自动批准
├─ "bypassPermissions" 绕过所有权限
├─ "plan"            计划模式（只读）
├─ "plan_no_prompt"  计划模式无提示
└─ "never"           拒绝所有工具
​
权限检查流程：
useCanUseTool() → toolPermissionContext → getDenyRuleForTool()
```

## **3\. 要模块说明**

### **3.1 核心文件**

| 文件 | 行数 | 职责 |
| --- | --- | --- |
| src/main.tsx | 4,683 | CLI 启动编排器，参数解析，模式分发 |
| src/query.ts | 1,729 | 查询管道，连接 UI、工具执行、权限系统 |
| src/QueryEngine.ts | 1,295 | LLM 查询引擎，流式响应，工具循环，重试 |
| src/Tool.ts | 792 | 工具基础类型定义，输入 schema，权限模型 |
| src/commands.ts | 754 | 命令注册表，斜杠命令统一管理 |
| src/setup.ts | 477 | 会话初始化序列 |
| src/history.ts | 464 | 会话历史管理，消息持久化与恢复 |
| src/tools.ts | 389 | 工具注册表与装配 |
| src/context.ts | 189 | 系统/用户上下文收集 |
| src/cost-tracker.ts | 323 | Token 计数，USD 成本计算 |
| src/Task.ts | 125 | 任务生命周期状态机 |

### **3.2 tools/ 目录（40+ 工具）**

**基础工具：**

| 工具 | 功能 |
| --- | --- |
| BashTool | 执行系统 Shell 命令 |
| FileReadTool | 读取文件（支持图片、PDF、Jupyter） |
| FileWriteTool | 创建或覆盖文件 |
| FileEditTool | 部分文件修改（字符串替换） |
| GlobTool | 文件路径模式匹配 |
| GrepTool | ripgrep 内容搜索 |
| WebFetchTool | 获取 URL 内容并处理 |
| WebSearchTool | 网页搜索 |
| NotebookEditTool | Jupyter 笔记本编辑 |

**高级工具：**

| 工具 | 功能 |
| --- | --- |
| AgentTool | 子代理生成与控制（递归能力的关键） |
| SkillTool | 可复用工作流执行 |
| MCPTool | [MCP 服务器](https://zhida.zhihu.com/search?content_id=272317723&content_type=Article&match_order=1&q=MCP+%E6%9C%8D%E5%8A%A1%E5%99%A8&zhida_source=entity)工具调用 |
| LSPTool | 语言服务器集成 |

**任务管理工具：**

| 工具 | 功能 |
| --- | --- |
| TaskCreateTool | 创建任务 |
| TaskGetTool | 获取任务详情 |
| TaskUpdateTool | 更新任务状态 |
| TaskListTool | 列出所有任务 |
| TaskOutputTool | 获取任务输出 |
| TaskStopTool | 停止任务 |

**其他工具：**

| 工具 | 功能 |
| --- | --- |
| EnterWorktreeTool / ExitWorktreeTool | Git worktree 隔离沙箱 |
| EnterPlanModeTool / ExitPlanModeTool | 计划模式切换 |
| CronCreateTool / CronDeleteTool / CronListTool | 计划任务管理 |
| SendMessageTool | 代理间通讯 |
| TeamCreateTool / TeamDeleteTool | 多代理团队管理 |

### **3.3 commands/ 目录（50+ 命令）**

| 命令 | 用途 |
| --- | --- |
| /commit | Git 提交创建 |
| /review | 代码审查 |
| /compact | 上下文压缩 |
| /config | 设置管理 |
| /doctor | 环境诊断 |
| /login / /logout | 认证管理 |
| /memory | 持久记忆管理 |
| /mcp | MCP 服务器管理 |
| /skills | 技能管理 |
| /tasks | 任务管理 UI |
| /context | 上下文可视化 |
| /resume | 恢复历史会话 |
| /vim | Vim 模式切换 |

### **3.4 services/ 目录（业务服务层）**

| 子目录 | 功能 |
| --- | --- |
| api/ | Anthropic API 客户端、文件 API |
| mcp/ | MCP 服务器连接、配置、OAuth 认证 |
| analytics/ | GrowthBook 特性标志、事件日志、遥测 |
| oauth/ | OAuth 2.0 认证流程 |
| lsp/ | 语言服务器协议管理 |
| compact/ | 会话上下文压缩 |
| extractMemories/ | 自动记忆提取 |
| plugins/ | 插件加载器 |
| SessionMemory/ | 会话记忆管理 |

### **3.5 bridge/ 目录（IDE 集成）**

Claude Code 通过 Bridge 系统与 [VS Code](https://zhida.zhihu.com/search?content_id=272317723&content_type=Article&match_order=1&q=VS+Code&zhida_source=entity) 和 [JetBrains](https://zhida.zhihu.com/search?content_id=272317723&content_type=Article&match_order=1&q=JetBrains&zhida_source=entity) 双向通讯：

| 文件 | 功能 |
| --- | --- |
| bridgeMain.ts | 网桥主循环 |
| bridgeMessaging.ts | 消息协议实现 |
| bridgePermissionCallbacks.ts | 权限回调处理 |
| jwtUtils.ts | JWT 认证 |
| sessionRunner.ts | 会话执行管理 |
| codeSessionApi.ts | VS Code/JetBrains API |

### **3.6 代码规模分布**

```text
components/     389 files  11.0MB   UI 组件（最大）
utils/          564 files   7.8MB   通用工具库（文件数最多）
commands/       189 files   3.3MB   斜杠命令
tools/          184 files   3.2MB   代理工具
services/       130 files   2.2MB   业务服务
hooks/          104 files   1.5MB   React 钩子
bridge/          31 files 536KB    IDE 网桥
skills/          20 files 208KB    技能系统
memdir/           8 files 100KB    记忆管理
coordinator/      1 file   24KB    多代理协调器
```

  

## **4\. 学习路线图**

### **第一阶段：基础架构理解**

**目标**：建立整体骨架认知，能说出完整数据流向。

### **1.1 看懂启动流程**

- **文件**：`src/main.tsx`（前 300 行）
- **重点**：
- Commander.js CLI 参数解析
	- 并行预取优化（startMdmRawRead / startKeychainPrefetch）
	- 5 种运行模式的分发逻辑
- **目标**：能画出从 `main.tsx` 到 `launchRepl()` 的完整调用链

### **1.2 理解核心数据流**

- **文件**：`src/query.ts` → `src/QueryEngine.ts`
- **重点**：
- 消息规范化与上下文注入
	- 工具调用循环（tool\_use → tool\_result 的 back-and-forth）
	- 流式响应处理
- **目标**：能描述一次用户输入从接收到 LLM 响应的完整过程

### **1.3 认识工具系统基础**

- **文件**：`src/Tool.ts`
- **重点**：
- `Tool` 核心类型定义
	- 输入 JSON Schema
	- 权限模型接口
- **目标**：理解每个工具需要实现哪些契约

  

### **第二阶段：工具系统深入**

**目标**：理解 Agent 如何与操作系统和文件系统交互。

### **2.1 四种典型工具对比阅读**

同时阅读以下 4 个工具，它们代表不同的实现模式：

| 工具文件 | 代表的模式 |
| --- | --- |
| src/tools/BashTool/BashTool.tsx | 进程执行 + 输出流处理 |
| src/tools/FileReadTool/FileReadTool.tsx | 文件 I/O + 多格式支持 |
| src/tools/FileEditTool/FileEditTool.tsx | 精确字符串替换 + 冲突检测 |
| src/tools/GrepTool/GrepTool.tsx | 外部命令封装（ripgrep） |

**阅读每个工具时关注**：

1. `input` schema 如何定义（Zod）
2. `execute()` 如何处理输入并返回结果
3. 权限检查在哪里介入
4. 错误如何返回给 LLM

### **2.2 权限系统精读**

- **文件**：
- `src/hooks/useCanUseTool.ts`
	- `src/utils/permissions/permissions.ts`
	- `src/utils/permissions/denialTracking.ts`
- **重点**：
- 6 种权限模式的判断逻辑
	- 异步权限弹窗队列机制
	- 用户拒绝历史追踪

### **2.3 子代理工具（递归能力的关键）**

- **文件**：`src/tools/AgentTool/AgentTool.tsx`
- **重点**：
- AgentTool 如何启动一个新的查询会话
	- 子代理的工具隔离与权限继承
	- 代理间结果传递

### **第三阶段：UI 层与状态管理**

**目标**：理解终端 UI 的实现原理，能修改界面。

### **3.1 React + Ink 终端渲染**

- **目录**：`src/components/`
- **入门**：先理解 Ink 是什么（React 在终端的渲染器）
- **关键组件**：
- `MessageDisplay` — 对话消息渲染
	- `StreamingText` — 流式文字输出
	- `ToolUsePanel` — 工具调用状态展示
	- `Spinner` / `Progress` — 加载状态

  

### **3.2 应用状态管理**

- **文件**：`src/state/AppState.tsx`
- **重点**：全局状态树结构，状态更新如何触发 UI 重渲染

### **3.3 核心 React 钩子**

- **文件**：
- `src/hooks/useMessages.ts` — 消息队列管理
	- `src/hooks/useToolProgress.ts` — 工具执行进度
	- `src/hooks/usePermissionCheck.ts` — 权限弹窗状态

  

### **第四阶段：扩展机制（1-2 周）**

**目标**：掌握项目的可扩展设计，能为项目添加新能力。

### **4.1 命令系统（Slash Commands）**

- **目录**：`src/commands/`
- **入门**：先读一个简单命令，如 `/config` 或 `/memory`
- **理解**：命令注册 → 执行 → UI 反馈 完整链路
- **对比**：命令（Command）vs 工具（Tool）vs 技能（Skill）的使用场景区别

### **4.2 MCP 协议集成**

- **目录**：`src/services/mcp/`
- **背景**：MCP（Model Context Protocol）是 Anthropic 定义的工具调用标准协议
- **重点**：
- MCP 服务器连接与工具发现
	- OAuth 认证流程
	- 如何将 MCP 工具注册到 Claude Code

  

### **4.3 技能系统（Skills）**

- **目录**：`src/skills/`
- **核心文件**：`src/skills/loadSkillsDir.ts`
- **重点**：
- Markdown 格式的 skill 定义规范
	- 技能加载与动态注册
	- 技能如何变成 `/skill-name` 斜杠命令

  

### **4.4 多代理系统**

- **文件**：
- `src/tools/AgentTool/AgentTool.tsx`
	- `src/coordinator/`
- **重点**：
- 代理类型：本地 / 远程 / 同进程 / 工作流代理
	- 代理间通讯（SendMessageTool）
	- 团队管理（TeamCreateTool）
	- 协调器模式（COORDINATOR\_MODE

  

### **第五阶段：服务层与外部集成**

**目标**：理解云服务和外部系统集成。

### **5.1 Anthropic API 集成**

- **目录**：`src/services/api/`
- **重点**：
- 流式 API 调用实现
	- 文件 API（用于 PDF、图片等大内容）
	- 成本计算逻辑（`src/cost-tracker.ts`）

  

### **5.2 IDE 桥接系统**

- **目录**：`src/bridge/`
- **重点**：
- VS Code / JetBrains 双向通讯协议
	- JWT 认证机制
	- 权限回调从 IDE 侧处理

  

### **5.3 持久记忆系统**

- **目录**：`src/services/extractMemories/`、`src/memdir/`
- **重点**：
- 记忆自动提取与分类
	- CLAUDE.md 文件发现机制（从当前目录向上查找）
	- 会话记忆与跨会话记忆的区别

### **第六阶段：高级特性（选修）**

### **6.1 特性标志与编译优化**

- **背景**：Bun 支持编译时特性标志，未激活的功能代码在打包时被完全移除（dead code elimination）
- **常见标志**：
- `PROACTIVE` — 主动代理模式
	- `KAIROS` — Assistant 模式
	- `COORDINATOR_MODE` — 多代理协调
	- `VOICE_MODE` — 语音输入
	- `WEB_BROWSER_TOOL` — 网页浏览

  

### **6.2 计划任务系统**

- **文件**：`src/tools/CronCreateTool.ts`
- **重点**：Agent 触发器与后台执行，Cron 表达式解析

### **6.3 Git Worktree 隔离**

- **文件**：`src/tools/EnterWorktreeTool.ts`
- **重点**：隔离代码修改的实现原理，worktree 生命周期管理

### **6.4 插件系统**

- **文件**：`src/utils/plugins/loadPluginCommands.ts`
- **重点**：第三方插件如何注册命令和工具

  

## **5\. 关键文件速查表**

| 想了解什么 | 看哪个文件 |
| --- | --- |
| CLI 如何启动 | src/main.tsx |
| 如何调用 LLM | src/QueryEngine.ts |
| 如何执行工具 | src/query.ts |
| 工具如何定义 | src/Tool.ts |
| 权限如何工作 | src/hooks/useCanUseTool.ts |
| 如何实现命令 | src/commands/ 任意文件 |
| UI 如何渲染 | src/components/ |
| 如何连接外部工具 | src/services/mcp/ |
| 如何持久化记忆 | src/memdir/ + src/services/extractMemories/ |
| 成本如何计算 | src/cost-tracker.ts |
| 会话如何恢复 | src/history.ts |
| IDE 如何集成 | src/bridge/ |
| 技能如何加载 | src/skills/loadSkillsDir.ts |
| 插件如何注册 | src/utils/plugins/loadPluginCommands.ts |

  

## **6\. 实践项目建议**

建议按以下顺序做练习，每个练习完成后再进入下一个：

| 难度 | 项目 | 涉及模块 | 练习目标 |
| --- | --- | --- | --- |
| ★☆☆ | 添加一个 /hello 斜杠命令，输出当前时间 | src/commands/ | 理解命令注册流程 |
| ★☆☆ | 编写一个 Skill，自动统计当前目录的文件数量 | src/skills/ | 理解 Skill 格式 |
| ★★☆ | 实现一个 WordCountTool，统计文件词数 | src/tools/ + src/Tool.ts | 理解工具定义契约 |
| ★★☆ | 修改权限系统，对某类文件拒绝编辑 | src/utils/permissions/ | 理解权限判断逻辑 |
| ★★★ | 集成一个自定义 MCP 服务器 | src/services/mcp/ | 理解协议扩展机制 |
| ★★★ | 实现一个子代理编排：Master 代理分发给两个 Worker 代理并汇总结果 | src/tools/AgentTool/ | 理解多代理架构 |
| ★★★★ | 为 VS Code 添加一个新的 Bridge 消息类型 | src/bridge/ | 理解 IDE 集成全链路 |

  

  

## **7\. 学习建议**

### **先用后读**

在读代码之前，先实际使用 Claude Code 完成几个真实任务（修 bug、写代码、重构），建立用户视角的直觉，再看源码时会更有方向感。

### **沿数据流读**

不要从目录树自上而下读。要沿着数据流读：

```text
用户输入 → query.ts → QueryEngine.ts → 具体工具
```

把这条主链路读通后，再向外扩展到权限系统、UI 层、服务层。

### **一文件一上下文**

每次只专注一个文件，先搞清楚：

1. 这个文件在系统里扮演什么角色？
2. 它导出了什么，被谁调用？
3. 它依赖了哪些上游，又产生什么给下游？

然后再读实现细节。

### **对照调试**

在关键位置加 `console.log`，观察真实的数据结构。比如在 `QueryEngine.ts` 的工具调用循环里打印 `toolUseBlock`，能立刻理解 LLM 返回的工具调用格式。

### **仿写是最快的学习方式**

读懂 `GrepTool.ts` 后，立刻仿照写一个自己的工具（比如 `WordCountTool`）。动手写一遍，比读十遍代码理解得更深。