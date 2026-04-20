---
title: pytorch skills总结
source: 
author:
published:
created: 2026-04-19
description: https://github.com/pytorch/pytorch/tree/main/.claude/skills1. 概述PyTorch 仓库中共有 12 个 Claude Skills，分布在 .claude/skills/ 目录下：Skill 名称 类别 主要用途 docstring 文档 编写符合 PyTorch 规范…
tags:
  - clippings
---
[https://github.com/pytorch/pytorch/tree/main/.claude/skills](https://github.com/pytorch/pytorch/tree/main/.claude/skills)

# # 1\. 概述

PyTorch 仓库中共有 **12 个 Claude Skills**，分布在 `.claude/skills/` 目录下：

| Skill 名称 | 类别 | 主要用途 |
| --- | --- | --- |
| docstring | 文档 | 编写符合 PyTorch 规范的文档字符串 |
| document-public-apis | 文档 | 为公共 API 添加 Sphinx 文档 |
| triaging-issues | Issue 管理 | GitHub issue 分类和路由 |
| scrub-issue | Issue 管理 | Issue 复现和最小化 |
| pr-review | 代码审查 | Pull Request 质量审查 |
| pt2-bug-basher | 调试 | PT2 编译器栈调试 |
| aoti-debug | 调试 | AOTInductor 错误诊断 |
| at-dispatch-v2 | 代码迁移 | AT\_DISPATCH 宏转换 |
| add-uint-support | 功能添加 | 无符号整数类型支持 |
| metal-kernel | 平台支持 | Metal/MPS 内核开发 |
| pyrefly-type-coverage | 类型安全 | 类型注解改进 |
| skill-writer | 元技能 | 创建新的 Claude Skills |

**代码开发类 (5个)**

| Skill | 功能描述 |
| --- | --- |
| add-uint-support | 为算子添加无符号整数类型支持 (uint16/32/64) |
| at-dispatch-v2 | 将 AT\_DISPATCH 宏转换为新的 V2 格式 |
| docstring | 编写符合 PyTorch 规范的文档字符串 |
| metal-kernel | 实现 Metal/MPS 内核的完整指南 |
| document-public-apis | 自动文档化公共 API |

**质量保障类 (3个)**

| Skill | 功能描述 |
| --- | --- |
| aoti-debug | 调试 AOTInductor 错误和崩溃 |
| pt2-bug-basher | 调试 PyTorch 2.0 编译器相关问题 |
| pyrefly-type-coverage | 类型安全 | 使用 Pyrefly 进行严格类型检查 |

**项目管理类 (3个)**

| Skill | 功能描述 |
| --- | --- |
| pr-review | PR 代码审查（关注 CI 无法检查的内容） |
| scrub-issue | 分析、复现和最小化 GitHub Issue |
| triaging-issues | Issue 分类和路由管理 |

**工具类 (1个)**

| Skill | 功能描述 |
| --- | --- |
| skill-writer | 创建 Claude Code Agent Skills 的指南 |