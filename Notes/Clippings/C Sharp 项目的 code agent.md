---
title: C Sharp 项目的 code agent
source:
author:
published:
created: 2026-04-19
description:
tags:
  - clippings
---
提取 Public 接口、类、方法等作为知识库（KB）的推荐方法你的私有 C# 项目最可靠、最完整的提取方式是使用 Roslyn（.NET Compiler Platform）。它能完整解析解决方案（.sln），获取语义信息（符号、访问修饰符、文档注释），并精确过滤 Public 部分。避免用反射（Reflection）——反射只能拿到编译后的元数据，无法获取源代码级文档注释和完整签名。1\. 准备环境（.NET 8+ 项目）新建一个 Console/App 项目，安装 NuGet 包（最新稳定版）：
- Microsoft.CodeAnalysis.CSharp.Workspaces
- Microsoft.CodeAnalysis.Workspaces.MSBuild
- Microsoft.Build.Locator
2\. 核心提取代码（完整示例）

csharp

```csharp
using Microsoft.Build.Locator;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.MSBuild;
using System.Text.Json;
using System.Xml.Linq;

MSBuildLocator.RegisterDefaults(); // 必须先调用，让 Roslyn 找到 MSBuild

var workspace = MSBuildWorkspace.Create();
workspace.WorkspaceFailed += (s, e) => Console.WriteLine(e.Diagnostic); // 忽略警告

var solution = await workspace.OpenSolutionAsync("你的项目.sln");

var kb = new List<PublicApiItem>(); // 自定义的 KB 结构

foreach (var project in solution.Projects)
{
    if (!project.SupportsCompilation) continue;

    var compilation = await project.GetCompilationAsync();
    if (compilation == null) continue;

    foreach (var syntaxTree in compilation.SyntaxTrees)
    {
        var semanticModel = compilation.GetSemanticModel(syntaxTree);
        var root = await syntaxTree.GetRootAsync();

        // 遍历所有类型声明（class, interface, struct, record 等）
        foreach (var typeDecl in root.DescendantNodes().OfType<TypeDeclarationSyntax>())
        {
            var symbol = semanticModel.GetDeclaredSymbol(typeDecl) as INamedTypeSymbol;
            if (symbol == null || symbol.DeclaredAccessibility != Accessibility.Public) continue;

            var item = new PublicApiItem
            {
                Namespace = symbol.ContainingNamespace.ToDisplayString(),
                TypeName = symbol.Name,
                TypeKind = symbol.TypeKind.ToString(), // Class / Interface
                FullSignature = symbol.ToDisplayString(SymbolDisplayFormat.MinimallyQualifiedFormat),
                Documentation = symbol.GetDocumentationCommentXml() ?? "", // 提取 XML 文档
                Members = new List<MemberItem>()
            };

            // 提取 Public 方法、属性等
            foreach (var member in symbol.GetMembers())
            {
                if (member.DeclaredAccessibility != Accessibility.Public || member.IsImplicitlyDeclared) continue;

                item.Members.Add(new MemberItem
                {
                    Name = member.Name,
                    Kind = member.Kind.ToString(),
                    Signature = member.ToDisplayString(SymbolDisplayFormat.MinimallyQualifiedFormat),
                    Documentation = member.GetDocumentationCommentXml() ?? ""
                });
            }

            kb.Add(item);
        }
    }
}

// 保存为结构化 KB（JSON 或分块 Markdown）
var json = JsonSerializer.Serialize(kb, new JsonSerializerOptions { WriteIndented = true });
File.WriteAllText("kb.json", json);
```

自定义结构示例（PublicApiItem 和 MemberItem）：
- Namespace + TypeName + FullSignature + Documentation
- 每个 Member：方法/属性签名 + 文档
输出建议：
- 每条记录作为一个 chunk（一个类或一个方法），便于后续向量检索。
- 可额外生成 Markdown 格式（便于 LLM 阅读）：
	```text
	## Namespace.ClassName (Interface)
	**签名**：public interface IUserService { ... }
	**文档**：xxx
	### 方法
	- \`Task<User> GetUserAsync(int id)\`：xxx
	```
这样提取出的 KB 就是你项目的“公共 API 知识库”，干净且只包含 Public 部分。其他可选方案（不推荐作为主力）：
- DocFX / Sandcastle 生成静态文档 → 再解析 HTML（丢失部分语义）。
- 直接用 dotnet build + XML 文档文件，但信息不全。

---

开发 Code Agent 的整体架构（结合 KB + C# 知识生成可编译代码）推荐使用 Microsoft Semantic Kernel (SK)（.NET 原生、官方维护），它天然支持 Agent + RAG + Tool Calling，非常适合你的场景。核心流程（RAG + Progressive Disclosure）
1. 用户提示 → 嵌入（Embedding） → 向量检索（只取最相关的 KB chunk）。
2. 检索结果 + 通用 C# 知识 → 组装成最终 Prompt。
3. LLM 生成代码 → （可选）用 Roslyn 编译验证 → 修复循环（Agent 循环）。
为什么能生成可编译代码？
- KB 提供精确的签名 + 文档 → LLM 不会“猜”你的私有 API。
- 加入通用 C# 知识（最佳实践、命名规范、依赖注入等）。
- 后置 Roslyn 编译检查（compilation.GetDiagnostics()），让 Agent 自动修复错误。

---

重新组织 Prompts 时，如何实现「渐进式披露」（Progressive Disclosure）？核心原则：绝不把整个 KB 塞进 Prompt（会浪费 token、降低质量、产生幻觉）。只把用户输入真正需要的知识逐步注入。实现方式（推荐 Semantic Kernel 的 Agentic RAG）：方式 1：标准 RAG（最简单，推荐入门）
- 把 KB 的每个类/方法存入向量数据库（推荐 Qdrant、Chroma、或 Azure AI Search，本地用 InMemoryVectorStore 也行）。
- 使用 SK 的 TextSearchProvider 或 VectorStore：
	csharp
	```csharp
	// 注册向量存储和嵌入模型（Azure OpenAI / OpenAI / Ollama 均可）
	kernel.Services.AddSingleton<ITextEmbeddingGenerationService>(...);
	// 创建检索 Provider
	var textSearchProvider = new TextSearchProvider(yourVectorStore);
	agentThread.AIContextProviders.Add(textSearchProvider); // 自动检索并注入
	```
- Prompt 模板（System Prompt）：
	```text
	你是 C# 专家。用户会要求生成代码。
	1. 根据用户输入，检索项目公共 API（已为你提供相关片段）。
	2. 仅使用下面提供的「相关知识库」和标准 C# 最佳实践生成代码。
	3. 必须可编译、无未定义类型。
	[相关知识库]
	{retrieved_chunks}
	```
- 检索逻辑：用户 Prompt 嵌入后，自动 cosine 相似度 Top-5~10，只注入这部分。无关知识完全不出现 → 这就是渐进式披露。
方式 2：Agentic RAG（更高级，真正「渐进」）
- 使用 SK 的 ChatCompletionAgent + Tool Calling。
- 给 Agent 提供一个 “KB 查询工具”（Function Calling）：
	- SearchApiByName(string name)：精确查找类/方法。
		- SemanticSearch(string query)：语义搜索。
- Agent 工作流（多步推理）：
	1. 第一步：LLM 分析用户需求 → “我需要 UserService 和 OrderRepository”。
		2. 调用工具 → 只拉取这两个类的完整信息。
		3. 第二步：把仅这两条知识 + 用户 Prompt 组成最终 Prompt 生成代码。
- 这样完全动态，甚至可以多轮：生成代码 → 编译失败 → Agent 再调用工具补充缺失 API → 重新生成。
Semantic Kernel 示例代码（简要）：

csharp

```csharp
var agent = new ChatCompletionAgent
{
    Name = "CodeAgent",
    Instructions = "你是一个严格的 C# 代码生成器...",
    Kernel = kernel
};

// 添加检索工具或 ContextProvider
agentThread.AIContextProviders.Add(textSearchProvider);
var response = await agentThread.InvokeAsync(userPrompt);
```

---

完整实现建议（最小可用版本）
1. 提取阶段（一次性运行）：用上面 Roslyn 代码生成 kb.json 或直接导入向量库。
2. Agent 阶段：
	- 用 Semantic Kernel 搭建 Agent。
		- 向量库选择：本地开发用 InMemoryVectorStore 或 Qdrant；生产用 Azure AI Search。
		- 嵌入模型：Azure OpenAI text-embedding-3-large（效果最好）。
3. 渐进式披露关键技巧：
	- Chunk 粒度：一个 Public 方法 = 一个 chunk（最精准）。
		- 检索时加入元数据过滤（e.g. namespace:MyProject.Services）。
		- Prompt 中明确写：“只使用下面提供的知识，不要添加任何未提及的 API”。
		- 可选：Agent 先输出“本次将使用的 API 列表”，用户/系统确认后再生成代码（可解释性更强）。
额外提升可编译性：
- 在 Agent 中增加一个 CompileTool：生成代码后，用 Roslyn 编译，错误信息返回给 LLM 继续修复（通常 1-2 轮就能通过）。
这样你就拥有了一个只注入必要知识、绝不污染 Prompt 的 Code Agent，完全符合「渐进式披露」的要求。如果你需要我提供：
- 完整的 Roslyn 提取工具 GitHub 风格代码
- Semantic Kernel + Qdrant 的 Agent 完整模板
- 向量数据库导入脚本
随时告诉我，我可以直接给你可运行的仓库结构！