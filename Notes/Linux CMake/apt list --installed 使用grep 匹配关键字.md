要使用 `apt list --installed` 命令结合 `grep` 匹配关键字，您可以按照以下步骤进行操作：

1.  打开终端。
    
2.  输入以下命令：
    

```bash
apt list --installed | grep "cmake\|nasm\|mingw-w64\|mingw-w64-tools"
```

这个命令将列出已安装的软件包，并使用 `grep` 过滤出包含关键字 "cmake"、"nasm"、"mingw-w64" 或 "mingw-w64-tools" 的行。

请注意，在 `grep` 命令中，我们使用了管道符 `|` 来将 `apt list --installed` 的输出传递给 `grep` 命令。同时，我们使用了正则表达式 `\|` 来匹配多个关键字，因为管道符 `|` 在正则表达式中有特殊的意义，所以我们需要使用反斜杠 `\` 对其进行转义。

执行上述命令后，您将看到与关键字匹配的已安装软件包的列表。