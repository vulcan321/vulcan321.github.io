---
title: OpenClaw 快速上手 | 菜鸟教程
source: https://www.runoob.com/ai-agent/openclaw-quickstart.html
author:
published:
created: 2026-03-29
description:
tags:
  - clippings
---
使用以下命令一键安装。

**macOS/Linux：**

- **鉴权配置**：设置 Gateway Token 或 Password，保护你的 API 接口
- **模型提供商配置**：选择并配置你的 LLM（如 Anthropic API Key）
- **渠道配置（可选）**：连接 Telegram Bot、WhatsApp 等聊天渠道
- **安装系统服务**：`--install-daemon` 参数让 Gateway 开机自启

# # Gateway 基础操作

Gateway 是 OpenClaw 的核心进程，所有功能都依赖它运行：

## # 查看 Gateway 状态

openclaw gateway status

## # 在前台运行（适合调试）

openclaw gateway --port 18789

## # 详细日志模式

openclaw gateway --port 18789 --verbose

## # 强制占用端口并启动（解决端口冲突）

openclaw gateway --force

## # 重启 Gateway

openclaw gateway restart

## # 停止 Gateway

openclaw gateway stop

## # 查看实时日志

openclaw logs --follow

# # 访问 Control UI

Control UI 是 OpenClaw 的可视化管理界面：

### # 打开 Control UI（自动在浏览器中打开）  

openclaw dashboard

或者直接访问: [http://127.0.0.1:18789/](http://127.0.0.1:18789/)


Control UI 的主要功能：

- **聊天界面**：不需要配置任何渠道，直接在浏览器里和 AI 对话
- **状态监控**：查看 Gateway 健康状态、渠道连接情况
- **会话管理**：查看和管理不同渠道的对话历史

> 🚀 **最快体验路径**  
> 打开 Control UI 后直接开始聊天——不需要配置任何Channel！这是最快验证 OpenClaw 正常工作的方式。

## # 关键命令速查

| 命令 | 说明 |
| --- | --- |
| `openclaw doctor` | 全面健康检查并尝试修复配置问题 |
| `openclaw health` | 快速健康检查 |
| `openclaw status` | 查看 Gateway 和渠道整体状态 |
| `openclaw gateway status` | 查看 Gateway 进程状态 |
| `openclaw gateway status --deep` | 深度状态检查（包含 RPC 探针） |
| `openclaw gateway run` | 前台运行 Gateway |
| `openclaw gateway start` | 后台启动 Gateway 服务 |
| `openclaw gateway stop` | 停止 Gateway 服务 |
| `openclaw gateway restart` | 重启 Gateway 服务 |
| `openclaw gateway probe` | 检测 Gateway 连通性和状态 |
| `openclaw gateway discover` | 发现局域网或远程 Gateway |
| `openclaw gateway call health` | 调用 Gateway 健康检查接口 |
| `openclaw channels status --probe` | 检查所有渠道连接状态 |
| `openclaw dashboard` | 打开浏览器控制面板 |
| `openclaw logs --follow` | 实时跟踪日志输出 |
| `openclaw onboard` | 重新运行初始化配置向导 |
| `openclaw secrets reload` | 热重载 Secrets 配置 |

## # Gateway 热重载机制

OpenClaw 支持配置热重载，默认为 `hybrid` 模式：

| `gateway.reload.mode` | 行为说明 |
| --- | --- |
| `off` | 不自动重载，需手动重启 |
| `hot` | 仅应用安全变更（不中断连接） |
| `restart` | 任何变更都重启 Gateway |
| `hybrid`（默认） | 能热应用的热应用，需要重启的自动重启 |

---

# # TUI：终端聊天界面

除了浏览器 Control UI，OpenClaw 还提供了一个完全在终端里运行的交互界面——**TUI（Terminal UI）**，无需浏览器，SSH 连进服务器也能直接聊天。

## # 快速启动

## # 第一步：确保 Gateway 已运行

openclaw gateway

## # 第二步：打开 TUI

openclaw tui

连接远程 Gateway：  

```
openclaw tui --url ws://<host>:<port> --token <gateway-token>
```

## # 如果 Gateway 使用密码鉴权

```
openclaw tui --url ws://<host>:<port> --password <password>
```

## # 界面布局

TUI 启动后你会看到四个区域：

| 区域 | 内容 |
| --- | --- |
| **Header（顶栏）** | 连接 URL、当前 Agent、当前 Session |
| **Chat log（消息区）** | 用户消息、AI 回复、系统通知、工具调用卡片 |
| **Status line（状态行）** | 连接 / 运行状态（connecting / running / streaming / idle / error） |
| **Footer（底栏）** | 连接状态 + Agent + Session + 模型 + Token 计数 |


## # 键盘快捷键

| 快捷键 | 功能 |
| --- | --- |
| `Enter` | 发送消息 |
| `Esc` | 中止当前运行 |
| `Ctrl+C` | 清空输入（连按两次退出） |
| `Ctrl+D` | 退出 TUI |
| `Ctrl+L` | 打开模型选择器 |
| `Ctrl+G` | 打开 Agent 选择器 |
| `Ctrl+P` | 打开 Session 选择器 |
| `Ctrl+O` | 切换工具输出展开 / 折叠 |
| `Ctrl+T` | 切换 Thinking 显示（会重新加载历史） |

## # 常用斜杠命令

使用 / 调出命令：

常用命令：

```
/help    # 查看帮助
/status  # 查看连接状态
/agent <id>                    # 切换 Agent
/session <key>                 # 切换 Session
/model <provider/model>        # 切换模型（如 /model anthropic/claude-sonnet-4-6）
/think <off|minimal|low|medium|high>   # 设置思考深度
/deliver <on|off>             # 开启/关闭消息投递到 Provider
/new                           # 重置当前 Session
/abort                         # 中止当前运行
/exit                          # 退出 TUI
```

## # 本地 Shell 命令

在输入框以 `!` 开头，可以直接执行本地 shell 命令：

```
!ls -la          # 列出当前目录
!cat log.txt      # 查看文件内容
```

> ⚠️ TUI 会在每次会话中首次使用 `!` 时提示确认授权，拒绝后本次会话内 `!` 将不可用。

## # 启动选项

| 参数 | 说明 | 默认值 |
| --- | --- | --- |
| `--url <url>` | Gateway WebSocket 地址 | 读取配置或 `ws://127.0.0.1:<port>` |
| `--token <token>` | Gateway Token 鉴权 | — |
| `--password <password>` | Gateway 密码鉴权 | — |
| `--session <key>` | 指定 Session | `main` |
| `--deliver` | 启动时开启消息投递 | 默认关闭 |
| `--thinking <level>` | 覆盖思考级别 | — |
| `--history-limit <n>` | 加载历史条数 | 200 |
| `--timeout-ms <ms>` | Agent 超时时间 | 读取 agents.defaults.timeoutSeconds |

## # 第一步：安装 ClawHub CLI

```
npm i -g clawhub
clawhub --version
```

## # 第二步：搜索并安装 Skill

### # 搜索 Skill（支持自然语言）

```bash
clawhub search "send emails automatically"
```

### # 安装 Skill

```
clawhub install <slug>
```

默认情况下，CLI 会把 Skill 安装到当前工作目录下的 ./skills 文件夹。

如果配置了 OpenClaw workspace，clawhub 会回退到该 workspace，除非你通过 --workdir 参数或 CLAWHUB_WORKDIR 环境变量覆盖路径。

OpenClaw 会从 `<workspace>/skills` 加载 Skill，并在下一个 Session 中生效。

## # 第三步：重启 OpenClaw Session

```
openclaw chat
# 新 Session 启动后，Skill 自动加载生效
```

更新 Skill:

```
clawhub sync     # 更新当前 workdir 下的所有 Skill
```

在终端中执行以下命令，即可安装 SkillHub CLI，并且优先采用 SkillHub 加速安装技能：

```
curl -fsSL https://skillhub-1388575217.cos.ap-guangzhou.myqcloud.com/install/install.sh | bash
```

比如我们安装搜索功能：

```
skillhub install tavily-search
```

---

# # 常用 Skills

如果你刚上手OpenClaw，强烈建议的安装顺序是：

- 先装 Skill Vetter 保底安全
- 再装 self-improving-agent 或其变种，让AI开始长记性
- 根据需求补 Summarize / Agent Browser / Gog / Github / Multi Search Engine 这几个万金油

安装方式超级简单：

1. 先安装 clawhub CLI

```
npm i -g clawhub
```

2. 然后安装这些 Skills：

```
clawhub install self-improving-agent
clawhub install summarize
```

### # 批量更新全部

```
clawhub update --all
```

常用的 Skills 列表如下：

| # | Skill | 说明 | 适用场景 | 安装 |
| --- | --- | --- | --- | --- |
| 1 | self-improving-agent | 记录失败与纠正并复盘优化 | 失败复盘 / 多次出错 / 用户纠正 | `clawhub install self-improving-agent` |
| 2 | summarize | 多格式内容总结（网页/PDF/视频等） | 长文阅读 / 文档提炼 | `clawhub install summarize` |
| 3 | agent-browser | 自动浏览器操作（点/输/抓） | 爬取 / 表单 / 自动化 | `clawhub install agent-browser` |
| 4 | skill-vetter | 安装前安全检测 | 检测权限 / 风险插件 | `clawhub install skill-vetter` |
| 5 | github | 通过 gh 操作 GitHub | PR / Issue / CI | `clawhub install github` |
| 6 | gog | Google Workspace 集成 | 邮件 / 文档 / 表格 | `clawhub install gog` |
| 7 | ontology | 结构化知识图谱记忆 | 项目 / 多任务管理 | `clawhub install ontology` |
| 8 | proactive-agent | 主动执行与调度 | 定时任务 / 自动执行 | `clawhub install proactive-agent` |
| 9 | multi-search-engine | 多引擎搜索聚合 | 调研 / 对比 | `clawhub install multi-search-engine` |
| 10 | humanizer | 优化文本更自然 | 文案 / 润色 | `clawhub install humanizer` |
| 11 | nano-pdf | 自然语言编辑 PDF | 合同 / 文档修改 | `clawhub install nano-pdf` |
| 12 | notion | 管理页面与数据库 | 笔记 / 知识库 | `clawhub install notion` |
| 13 | obsidian | Markdown 笔记自动化 | 整理 / 沉淀 | `clawhub install obsidian` |
| 14 | api-gateway | 连接 100+ API | 系统集成 | `clawhub install api-gateway` |
| 15 | auto-updater | 自动更新 Skills | 长期运行 | `clawhub install auto-updater` |
| 16 | openai-whisper | 本地语音转文字 | 会议记录 | `clawhub install openai-whisper` |
| 17 | nano-banana-pro | 图像生成与编辑 | 海报 / 图片 | `clawhub install nano-banana-pro` |
| 18 | stock-analysis | 股票与加密分析 | 趋势 / 分析 | `clawhub install stock-analysis` |
| 19 | weather | 天气查询与预测 | 日常查询 | `clawhub install weather` |

---

# # 制作自己的 Skill

下面是一个最简单的 SKILL.md 示例：

```
---
name: my-skill
description: Does a thing with an API.
---

# My Skill

# # Rules
- Always confirm with the user before making destructive changes.
- Use the credentials from environment variable MY*API*KEY.

# # Usage
When the user asks to "do the thing", call the API endpoint at
https://api.example.com/action with the provided payload.
```

写好后，执行发布命令：

```
clawhub publish ~/.openclaw/skills/my-skill \
  --slug my-skill \
  --name "My Skill" \
  --version 1.0.0 \
  --tags latest
```

发布需要一个至少注册满一周的 GitHub 账号。--slug 是 Skill 在 ClawHub 上的唯一标识符，在整个注册表中必须唯一。