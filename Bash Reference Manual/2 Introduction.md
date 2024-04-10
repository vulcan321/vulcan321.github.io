
## 1 Introduction

-   [What is Bash?](https://www.gnu.org/software/bash/manual/bash.html#What-is-Bash_003f)
-   [What is a shell?](https://www.gnu.org/software/bash/manual/bash.html#What-is-a-shell_003f)

___

### 1.1 What is Bash?

Bash is the shell, or command language interpreter, for the <small>GNU</small> operating system. The name is an acronym for the ‘Bourne-Again SHell’, a pun on Stephen Bourne, the author of the direct ancestor of the current Unix shell `sh`, which appeared in the Seventh Edition Bell Labs Research version of Unix. 
适用于 <small>GNU</small>这个名字是“Bourne-Again SHell当前的 Unix shell `sh`Bash 是 shell 或命令语言解释器， 操作系统。 ”的首字母缩写， 斯蒂芬·伯恩（Stephen Bourne）的双关语，斯蒂芬·伯恩（Stephen Bourne）是直系祖先的作者 ， 出现在贝尔实验室研究第七版中 的 Unix。

Bash is largely compatible with `sh` and incorporates useful features from the Korn shell `ksh` and the C shell `csh`. It is intended to be a conformant implementation of the <small>IEEE</small> <small>POSIX</small> Shell and Tools portion of the <small>IEEE</small> <small>POSIX</small> specification (<small>IEEE</small> Standard 1003.1). It offers functional improvements over `sh` for both interactive and programming use. 
Bash 在很大程度上与 `sh`来自 Korn shell `ksh` 和 C shell `csh`它旨在成为 <small>IEEE</small><small>POSIX</small> 的 <small>IEEE</small><small>POSIX</small>规范（<small>IEEE</small>它`sh` 兼容，并包含有用的 的功能。 Shell 和工具部分的一致性实现 标准 1003.1）。 式和 编程使用。

While the <small>GNU</small> operating system provides other shells, including a version of `csh`, Bash is the default shell. Like other <small>GNU</small> software, Bash is quite portable. It currently runs on nearly every version of Unix and a few other operating systems - independently-supported ports exist for <small>MS-DOS</small>, <small>OS/2</small>, and Windows platforms. 
虽然 <small>GNU</small>`csh`像其他 <small>GNU</small><small>MS-DOS</small>、<small>OS/2</small> 操作系统提供了其他 shell，包括 的一个版本，Bash 是默认的 shell。 软件一样，Bash 非常便携。 它目前运行 在几乎所有版本的 Unix 和其他一些操作系统上 - 、 存在独立支持的端口 和 Windows 平台。

___

### 1.2 What is a shell?

At its base, a shell is simply a macro processor that executes commands. The term macro processor means functionality where text and symbols are expanded to create larger expressions. 从根本上说，shell 只是一个执行 命令。 术语宏处理器是指文本 并且扩展符号以创建更大的表达式。

A Unix shell is both a command interpreter and a programming language. As a command interpreter, the shell provides the user interface to the rich set of <small>GNU</small> utilities. The programming language features allow these utilities to be combined. Files containing commands can be created, and become commands themselves. These new commands have the same status as system commands in directories such as /bin, allowing users or groups to establish custom environments to automate their common tasks. 与丰富的 <small>GNU</small>/binUnix shell 既是命令解释器又是编程 语言。 作为命令解释器，shell 为用户提供 实用程序集的接口。 编程 语言功能允许将这些实用程序组合在一起。 可以创建包含命令的文件，并成为 命令自己。 这些新命令的状态与 等目录中的系统命令，允许用户 或组来建立自定义环境以自动化其共同 任务。

Shells may be used interactively or non-interactively. In interactive mode, they accept input typed from the keyboard. When executing non-interactively, shells execute commands read from a file. Shell 可以交互式或非交互式使用。 在 交互模式下，它们接受从键盘键入的输入。 以非交互方式执行时，shell 执行读取的命令 从文件。

A shell allows execution of <small>GNU</small> commands, both synchronously and asynchronously. The shell waits for synchronous commands to complete before accepting more input; asynchronous commands continue to execute in parallel with the shell while it reads and executes additional commands. The _redirection_ constructs permit fine-grained control of the input and output of those commands. Moreover, the shell allows control over the contents of commands’ environments. shell 允许同步执行 <small>GNU</small>_重定向_ 命令，并且 异步。 shell 在接受之前等待同步命令完成 更多投入;异步命令继续并行执行 在读取和执行其他命令时与 shell。 构造允许 对这些命令的输入和输出进行细粒度控制。 此外，shell 允许控制命令的内容 环境。

Shells also provide a small set of built-in commands (_builtins_) implementing functionality impossible or inconvenient to obtain via separate utilities. For example, `cd`, `break`, `continue`, and `exec` cannot be implemented outside of the shell because they directly manipulate the shell itself. The `history`, `getopts`, `kill`, or `pwd` builtins, among others, could be implemented in separate utilities, but they are more convenient to use as builtin commands. All of the shell builtins are described in subsequent sections. 
无法实现功能的命令（_内置_）例如，`cd`、`break`、`continue``exec``history`、`getopts`、`kill` 或 `pwd`Shell 还提供了一小组内置 或不方便通过单独的实用程序获得。 和 不能在 shell 外部实现，因为 他们直接操纵shell本身。 内置的，除其他外，可以在单独的实用程序中实现， 但它们作为内置命令使用更方便。 所有 shell 内置函数都在 后续部分。

While executing commands is essential, most of the power (and complexity) of shells is due to their embedded programming languages. Like any high-level language, the shell provides variables, flow control constructs, quoting, and functions. 
虽然执行命令是必不可少的，但大部分功率（和 复杂度）是由于它们的嵌入式编程 语言。 与任何高级语言一样，shell 提供 变量、流控制结构、引用和函数。

Shells offer features geared specifically for interactive use rather than to augment the programming language. These interactive features include job control, command line editing, command history and aliases. Each of these features is described in this manual. 
Shell 提供专门针对 交互式使用，而不是增强编程语言。 这些交互式功能包括作业控制、命令行 编辑、命令历史记录和别名。 这些功能中的每一个都是 在本手册中描述。

___

## 2 Definitions

These definitions are used throughout the remainder of this manual. 本手册的其余部分将使用这些定义。

`POSIX`

A family of open system standards based on Unix. Bash is primarily concerned with the Shell and Utilities portion of the <small>POSIX</small> 1003.1 standard. <small>POSIX</small>基于 Unix 的开放系统标准系列。 巴什 主要关注 Shell 和 Utilities 部分 1003.1 标准。

`blank`

A space or tab character. 空格或制表符。

`builtin`

A command that is implemented internally by the shell itself, rather than by an executable program somewhere in the file system. 由 shell 本身在内部实现的命令，而不是 而不是文件系统中某处的可执行程序。

`control operator`

A `token` that performs a control function. It is a `newline` or one of the following: ‘||’, ‘&&’, ‘&’, ‘;’, ‘;;’, ‘;&’, ‘;;&’, ‘|’, ‘|&’, ‘(’, or ‘)’. 执行控制功能的`token`。 这是一个`newline`'||'， '&&'， '&'， ';'， ';'， ';;;'， ';&'， ';;&'|'、'|&'、'('或') 或以下其中一项： '， '。

`exit status`

The value returned by a command to its caller. The value is restricted to eight bits, so the maximum value is 255. 命令返回给其调用方的值。 该值受到限制 设置为 8 位，因此最大值为 255。

`field`

A unit of text that is the result of one of the shell expansions. After expansion, when executing a command, the resulting fields are used as the command name and arguments. 一个文本单元，它是其中一个 shell 扩展的结果。 后 展开，当执行命令时，生成的字段用作 命令名称和参数。

`filename`

A string of characters used to identify a file. 用于标识文件的字符串。

`job`

A set of processes comprising a pipeline, and any processes descended from it, that are all in the same process group. 由管道组成的一组进程，以及下降的任何进程 从中，它们都位于同一个进程组中。

`job control`

A mechanism by which users can selectively stop (suspend) and restart (resume) execution of processes. 用户可以选择性地停止（暂停）和重新启动的机制 （恢复）执行流程。

`metacharacter`

A character that, when unquoted, separates words. A metacharacter is a `space`, `tab`, `newline`, or one of the following characters: ‘|’, ‘&’, ‘;’, ‘(’, ‘)’, ‘<’, or ‘\>’. `space`、`tab`、`newline`'|'， '&'， ';'， '('， ')'， '<'\>一个字符，当不加引号时，分隔单词。 元字符是 或以下字符之一： ' 或 '。

`name`

A `word` consisting solely of letters, numbers, and underscores, and beginning with a letter or underscore. `Name`s are used as shell variable and function names. Also referred to as an `identifier`. 一个仅由字母、数字和下划线组成的`word`并以字母或下划线开头。 `Name`也称为`identifier`， s 用作 shell 变量和函数名称。 。

`operator`

A `control operator` or a `redirection operator`. See [Redirections](https://www.gnu.org/software/bash/manual/bash.html#Redirections), for a list of redirection operators. Operators contain at least one unquoted `metacharacter`. `control operator`或`redirection operator`有关重定向运算符的列表，请参阅[重定向](https://www.gnu.org/software/bash/manual/bash.html#Redirections)运算符至少包含一个未带引号的`metacharacter`。 。 。

`process group`

A collection of related processes each having the same process group <small>ID</small>. 组 <small>ID。</small>相关进程的集合，每个进程具有相同的进程

`process group ID`

A unique identifier that represents a `process group` during its lifetime. 表示`process group`的唯一标识符 在其生命周期内。

`reserved word`

A `word` that has a special meaning to the shell. Most reserved words introduce shell flow control constructs, such as `for` and `while`. 一个对Bash有特殊含义`word`单词引入了 shell 流控制结构，例如 `for``while`。 最保留 和 。

`return status`

A synonym for `exit status`. `exit status`的同义词。

`signal`

A mechanism by which a process may be notified by the kernel of an event occurring in the system. 内核可以通知进程的机制 系统中发生的事件。

`special builtin`

A shell builtin command that has been classified as special by the <small>POSIX</small> standard. <small>POSIX</small>已由 标准。

`token`

A sequence of characters considered a single unit by the shell. It is either a `word` or an `operator`. 它要么是`word`，要么是一个`operator`被 shell 视为单个单元的字符序列。 。

`word`

A sequence of characters treated as a unit by the shell. Words may not include unquoted `metacharacters`. 单词不得包含未加引号`metacharacters`shell 视为一个单元的字符序列。 。
