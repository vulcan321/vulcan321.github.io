
## 4 Shell Builtin Commands

Builtin commands are contained within the shell itself. When the name of a builtin command is used as the first word of a simple command (see [Simple Commands](https://www.gnu.org/software/bash/manual/bash.html#Simple-Commands)), the shell executes the command directly, without invoking another program. Builtin commands are necessary to implement functionality impossible or inconvenient to obtain with separate utilities. 一个简单的命令（参见[简单命令](https://www.gnu.org/software/bash/manual/bash.html#Simple-Commands)内置命令包含在 shell 本身中。 当内置命令的名称用作 ），shell 执行 直接命令，而无需调用其他程序。 内置命令是实现不可能实现的功能所必需的 或不方便使用单独的实用程序获得。

This section briefly describes the builtins which Bash inherits from the Bourne Shell, as well as the builtin commands which are unique to or have been extended in Bash.

Several builtin commands are described in other chapters: builtin commands which provide the Bash interface to the job control facilities (see [Job Control Builtins](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Builtins)), the directory stack (see [Directory Stack Builtins](https://www.gnu.org/software/bash/manual/bash.html#Directory-Stack-Builtins)), the command history (see [Bash History Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Builtins)), and the programmable completion facilities (see [Programmable Completion Builtins](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion-Builtins)). facilities（参见 [Job Control Builtins](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Builtins)（请参阅 [Directory Stack Builtins](https://www.gnu.org/software/bash/manual/bash.html#Directory-Stack-Builtins)（请参阅 [Bash History Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Builtins)设施（参见[可编程完成内置）。](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion-Builtins)其他章节中介绍了几个内置命令： 内置 为作业控件提供 Bash 接口的命令 ）、目录堆栈 ），命令历史记录 ）和可编程完成

Many of the builtins have been extended by <small>POSIX</small> or Bash. 许多内置函数已由 <small>POSIX</small> 或 Bash 扩展。

Unless otherwise noted, each builtin command documented as accepting options preceded by ‘\-’ accepts ‘\--’ to signify the end of the options. The `:`, `true`, `false`, and `test`/`[` builtins do not accept options and do not treat ‘\--’ specially. The `exit`, `logout`, `return`, `break`, `continue`, `let`, and `shift` builtins accept and process arguments beginning with ‘\-’ without requiring ‘\--’. Other builtins that accept arguments but are not specified as accepting options interpret arguments beginning with ‘\-’ as invalid options and require ‘\--’ to prevent this interpretation.

-   [Bourne Shell BuiltinsBourne Shell 内置](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)
-   [Bash Builtin CommandsBash 内置命令](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)
-   [Modifying Shell Behavior修改 Shell 行为](https://www.gnu.org/software/bash/manual/bash.html#Modifying-Shell-Behavior)
-   [Special Builtins特殊内置](https://www.gnu.org/software/bash/manual/bash.html#Special-Builtins)

___

### 4.1 Bourne Shell Builtins4.1 Bourne Shell 内置

The following shell builtin commands are inherited from the Bourne Shell. These commands are implemented as specified by the <small>POSIX</small> standard. 这些命令按照 <small>POSIX</small>以下 shell 内置命令继承自 Bourne Shell。 标准的规定实现。

`: (a colon)`：（冒号）

Do nothing beyond expanding arguments and performing redirections. The return status is zero. 除了扩展arguments和执行重定向外，什么都不做。 返回状态为零。

`. (a period)`. （句点）

Read and execute commands from the filename argument in the current shell context. If filename does not contain a slash, the `PATH` variable is used to find filename, but filename does not need to be executable. When Bash is not in <small>POSIX</small> mode, it searches the current directory if filename is not found in `$PATH`. If any arguments are supplied, they become the positional parameters when filename is executed. Otherwise the positional parameters are unchanged. If the \-T option is enabled, `.` inherits any trap on `DEBUG`; if it is not, any `DEBUG` trap string is saved and restored around the call to `.`, and `.` unsets the `DEBUG` trap while it executes. If \-T is not set, and the sourced file changes the `DEBUG` trap, the new value is retained when `.` completes. The return status is the exit status of the last command executed, or zero if no commands are executed. If filename is not found, or cannot be read, the return status is non-zero. This builtin is equivalent to `source`. 从 filename当前 shell 上下文。 如果 filename`PATH` 变量用于查找filename但 filename当 Bash 不在 <small>POSIX</small>如果在 `$PATH` 中找不到 filename如果提供了任何arguments执行 filename如果启用了 \-T 选项，`.``DEBUG`;如果不是，则保存任何 `DEBUG`在调用 `.` 和 `.``DEBUG`如果未设置 \-T`DEBUG` 陷阱，则新值在 `.`如果未执行任何命令，则为零。 如果找不到filename此内置插件等同于`source` 参数中读取和执行命令 不包含斜杠， ， 不需要是可执行的。 模式下时，它会搜索当前目录 。 ，它们将成为位置 时的参数。 否则位置 参数保持不变。 继承了 陷阱字符串，并 周围恢复 陷阱。 ，并且源文件发生更改 完成时保留。 返回状态是上次执行的命令的退出状态，或者 ，或者 无法读取，则返回状态为非零。 代码。

`break`

Exit from a `for`, `while`, `until`, or `select` loop. If n is supplied, the nth enclosing loop is exited. n must be greater than or equal to 1. The return status is zero unless n is not greater than or equal to 1. 退出 `for`、`while`、`until` 或 `select`如果提供 n，则退出nn除非 n 循环。 个封闭循环。 必须大于或等于 1。 不大于或等于 1，否则返回状态为零。

`cd`

```
cd [-L|[-P [-e]] [-@] [directory]
```

Change the current working directory to directory. If directory is not supplied, the value of the `HOME` shell variable is used. If the shell variable `CDPATH` exists, it is used as a search path: each directory name in `CDPATH` is searched for directory, with alternative directory names in `CDPATH` separated by a colon (‘:’). If directory begins with a slash, `CDPATH` is not used. 将当前工作目录更改为directory如果未提供directory，则 `HOME``CDPATH``CDPATH`directory，`CDPATH`用冒号 （':如果directory以斜杠开头，则不使用 `CDPATH`。 的值 使用 shell 变量。 如果 shell 变量 存在，它用作搜索路径： 中的每个目录名称 中使用备用目录名称 '） 分隔。 。

The \-P option means to not follow symbolic links: symbolic links are resolved while `cd` is traversing directory and before processing an instance of ‘..’ in directory. \-P在 `cd` 遍历directory处理directory中“.. 选项表示不遵循符号链接：符号链接 时和之前解析 ”的实例。

By default, or when the \-L option is supplied, symbolic links in directory are resolved after `cd` processes an instance of ‘..’ in directory. 默认情况下，或者当提供 \-L在 `cd` 处理实例后解析directory目录directory.. 选项时，符号链接 ”。

If ‘..’ appears in directory, it is processed by removing the immediately preceding pathname component, back to a slash or the beginning of directory. 如果directory中出现“..directory”，则通过删除 紧挨着 pathname 组件，回到斜杠或开头 。

If the \-e option is supplied with \-P and the current working directory cannot be successfully determined after a successful directory change, `cd` will return an unsuccessful status. 如果 \-e 选项随 \-P目录更改成功后，`cd` 一起提供 并且无法成功确定当前工作目录 将返回 地位。

On systems that support it, the \-@ option presents the extended attributes associated with a file as a directory. 在支持它的系统上，\-@ 选项显示扩展的 与文件关联为目录的属性。

If directory is ‘\-’, it is converted to `$OLDPWD` before the directory change is attempted. 如果directory为“\-”，则将其转换为`$OLDPWD` 在尝试更改目录之前。

If a non-empty directory name from `CDPATH` is used, or if ‘\-’ is the first argument, and the directory change is successful, the absolute pathname of the new working directory is written to the standard output. 如果使用 `CDPATH`'\- 中的非空目录名称，或者如果 ' 是第一个参数，目录更改是 成功，则新工作目录的绝对路径名为 写入标准输出。

If the directory change is successful, `cd` sets the value of the `PWD` environment variable to the new directory name, and sets the `OLDPWD` environment variable to the value of the current working directory before the change. 如果目录更改成功，`cd``PWD``OLDPWD` 将设置 环境变量设置为新的目录名称，并将 环境变量设置为当前工作的值 更改前的目录。

The return status is zero if the directory is successfully changed, non-zero otherwise. 如果目录更改成功，则返回状态为零， 否则为非零。

`continue`

Resume the next iteration of an enclosing `for`, `while`, `until`, or `select` loop. If n is supplied, the execution of the nth enclosing loop is resumed. n must be greater than or equal to 1. The return status is zero unless n is not greater than or equal to 1. 继续`for`下一次迭代，`while``until`，或`select`如果提供 n，则执行第 nn除非 n， 循环。 个封闭循环 已恢复。 必须大于或等于 1。 不大于或等于 1，否则返回状态为零。

`eval`

The arguments are concatenated together into a single command, which is then read and executed, and its exit status returned as the exit status of `eval`. If there are no arguments or only empty arguments, the return status is zero. `eval`这些参数连接在一起形成一个命令，该命令是 然后读取并执行，其退出状态作为退出状态返回 。 如果没有参数或只有空参数，则返回状态为 零。

`exec`

```
exec [-cl] [-a name] [command [arguments]]
```

If command is supplied, it replaces the shell without creating a new process. If the \-l option is supplied, the shell places a dash at the beginning of the zeroth argument passed to command. This is what the `login` program does. The \-c option causes command to be executed with an empty environment. If \-a is supplied, the shell passes name as the zeroth argument to command. If command cannot be executed for some reason, a non-interactive shell exits, unless the `execfail` shell option is enabled. In that case, it returns failure. An interactive shell returns failure if the file cannot be executed. A subshell exits unconditionally if `exec` fails. If no command is specified, redirections may be used to affect the current shell environment. If there are no redirection errors, the return status is zero; otherwise the return status is non-zero. If command如果提供了 \-l传递给command这就是`login`\-c command如果提供了 \-a，则 shell 将 name参数到commandIf command除非 `execfail`如果 `exec`如果未指定command ，它将替换 shell，而无需创建新进程。 选项，则 shell 会在 的第 0 个参数的开头。 程序的作用。 执行时为空 环境。 作为第 0 个传递 。 由于某种原因无法执行，非交互式 shell 退出， shell 选项 已启用。 在这种情况下，它将返回失败。 如果文件无法执行，则交互式 shell 将返回失败。 失败，则子 shell 将无条件退出。 ，则重定向可能会影响 当前 shell 环境。 如果没有重定向错误，则 返回状态为零;否则，返回状态为非零。

`exit`

Exit the shell, returning a status of n to the shell’s parent. If n is omitted, the exit status is that of the last command executed. Any trap on `EXIT` is executed before the shell terminates. 退出 shell，将状态 n如果省略 n`EXIT` 返回给 shell 的父级。 ，则退出状态为上次执行的命令的退出状态。 上的任何陷阱都在 shell 终止之前执行。

`export`

```
export [-fn] [-p] [name[=value]]
```

Mark each name to be passed to child processes in the environment. If the \-f option is supplied, the names refer to shell functions; otherwise the names refer to shell variables. The \-n option means to no longer mark each name for export. If no names are supplied, or if the \-p option is given, a list of names of all exported variables is displayed. The \-p option displays output in a form that may be reused as input. If a variable name is followed by =value, the value of the variable is set to value. 标记要传递给子进程的每个name在环境中。 如果提供了 \-f 选项，name\-n 选项表示不再标记每个要导出name如果未提供names，或者给定了 \-p\-p如果变量名称后跟 =value变量设置为 value s 参考 shell 函数;否则，名称引用 shell 变量。 。 选项，则 将显示所有导出变量的名称列表。 选项以可重用为输入的形式显示输出。 ，则 。

The return status is zero unless an invalid option is supplied, one of the names is not a valid shell variable name, or \-f is supplied with a name that is not a shell function. 这些名称不是有效的 shell 变量名称，或者提供了 \-f返回状态为零，除非提供了无效选项，否则返回状态为 使用不是 shell 函数的名称。

`getopts`

```
getopts optstring name [arg …]
```

`getopts` is used by shell scripts to parse positional parameters. optstring contains the option characters to be recognized; if a character is followed by a colon, the option is expected to have an argument, which should be separated from it by whitespace. The colon (‘:’) and question mark (‘?’) may not be used as option characters. Each time it is invoked, `getopts` places the next option in the shell variable name, initializing name if it does not exist, and the index of the next argument to be processed into the variable `OPTIND`. `OPTIND` is initialized to 1 each time the shell or a shell script is invoked. When an option requires an argument, `getopts` places that argument into the variable `OPTARG`. The shell does not reset `OPTIND` automatically; it must be manually reset between multiple calls to `getopts` within the same shell invocation if a new set of parameters is to be used. `getopts`optstring冒号 （':'） 和问号 （'?每次调用它时，`getopts`将下一个选项放在 shell 变量namename变量 `OPTIND`每次 shell 或 shell 脚本时`OPTIND``getopts` 将该参数放入变量 `OPTARG`shell 不会自动重置 `OPTIND`在同一 shell 中对 `getopts` 由 shell 脚本用于解析位置参数。 包含要识别的选项字符;如果 字符后跟冒号，该选项应具有 参数，它应该用空格分隔。 '） 可能不是 用作选项字符。 中，初始化 （如果不存在）， 以及要处理的下一个参数的索引 。 都初始化为 1 被调用。 当一个选项需要参数时， 中。 ;它必须是手动的 的多次调用之间重置 如果要使用一组新参数，则调用。

When the end of options is encountered, `getopts` exits with a return value greater than zero. `OPTIND` is set to the index of the first non-option argument, and name is set to ‘?’. 当遇到选项的末尾时，`getopts``OPTIND`name设置为“? 退出并带有 返回值大于零。 设置为第一个非选项参数的索引， 。

`getopts` normally parses the positional parameters, but if more arguments are supplied as arg values, `getopts` parses those instead. `getopts`作为 arg 值提供，`getopts` 通常解析位置参数，但如果更多的参数是 会解析这些值。

`getopts` can report errors in two ways. If the first character of optstring is a colon, silent error reporting is used. In normal operation, diagnostic messages are printed when invalid options or missing option arguments are encountered. If the variable `OPTERR` is set to 0, no error messages will be displayed, even if the first character of `optstring` is not a colon.

If an invalid option is seen, `getopts` places ‘?’ into name and, if not silent, prints an error message and unsets `OPTARG`. If `getopts` is silent, the option character found is placed in `OPTARG` and no diagnostic message is printed. `getopts` 将 '?' 放在 name打印错误消息并取消`OPTARG`如果 `getopts``OPTARG`如果看到无效选项， 中，如果不是静默的， 。 是静默的，则找到的选项字符将放在 ，并且不打印诊断消息。

If a required argument is not found, and `getopts` is not silent, a question mark (‘?’) is placed in name, `OPTARG` is unset, and a diagnostic message is printed. If `getopts` is silent, then a colon (‘:’) is placed in name and `OPTARG` is set to the option character found. 如果未找到必需的参数，则 `getopts`不是沉默的，name里放了一个问号（'?`OPTARG`如果 `getopts` 是静默的，则冒号 （':name 和 `OPTARG` '）， 未设置，并打印诊断消息。 '） 被放置在 设置为找到的选项字符。

`hash`

```
hash [-r] [-p filename] [-dt] [name]
```

Each time `hash` is invoked, it remembers the full pathnames of the commands specified as name arguments, so they need not be searched for on subsequent invocations. The commands are found by searching through the directories listed in `$PATH`. Any previously-remembered pathname is discarded. The \-p option inhibits the path search, and filename is used as the location of name. The \-r option causes the shell to forget all remembered locations. The \-d option causes the shell to forget the remembered location of each name. If the \-t option is supplied, the full pathname to which each name corresponds is printed. If multiple name arguments are supplied with \-t, the name is printed before the hashed full pathname. The \-l option causes output to be displayed in a format that may be reused as input. If no arguments are given, or if only \-l is supplied, information about remembered commands is printed. The return status is zero unless a name is not found or an invalid option is supplied. 每次调用`hash`指定为name`$PATH`\-p 选项禁止路径搜索，filename用作name\-r\-d每个name如果提供了 \-tname对应。 如果多个name随 \-t 一起提供，name\-l如果没有给出参数，或者只提供了 \-l返回状态为零，除非找不到name时，它都会记住 参数的命令， 因此，无需在后续调用时搜索它们。 通过搜索 。 任何以前记住的路径名都将被丢弃。 为 的位置。 选项会导致 shell 忘记所有记住的位置。 选项会导致 shell 忘记记住的位置 。 选项，则每个 参数是 在哈希之前打印 完整路径名。 选项使输出以某种格式显示 可以重复用作输入。 ， 将打印有关记住的命令的信息。 无效 选项。

`pwd`

Print the absolute pathname of the current working directory. If the \-P option is supplied, the pathname printed will not contain symbolic links. If the \-L option is supplied, the pathname printed may contain symbolic links. The return status is zero unless an error is encountered while determining the name of the current directory or an invalid option is supplied. 如果提供了 \-P如果提供了 \-L打印当前工作目录的绝对路径名。 选项，则打印的路径名不会 包含符号链接。 选项，则打印的路径名可能包含 符号链接。 返回状态为零，除非在 确定当前目录的名称或无效选项 已提供。

`readonly`

```
readonly [-aAf] [-p] [name[=value]] …
```

Mark each name as readonly. The values of these names may not be changed by subsequent assignment. If the \-f option is supplied, each name refers to a shell function. The \-a option means each name refers to an indexed array variable; the \-A option means each name refers to an associative array variable. If both options are supplied, \-A takes precedence. If no name arguments are given, or if the \-p option is supplied, a list of all readonly names is printed. The other options may be used to restrict the output to a subset of the set of readonly names. The \-p option causes output to be displayed in a format that may be reused as input. If a variable name is followed by =value, the value of the variable is set to value. The return status is zero unless an invalid option is supplied, one of the name arguments is not a valid shell variable or function name, or the \-f option is supplied with a name that is not a shell function.

`return`

Cause a shell function to stop executing and return the value n to its caller. If n is not supplied, the return value is the exit status of the last command executed in the function. If `return` is executed by a trap handler, the last command used to determine the status is the last command executed before the trap handler. If `return` is executed during a `DEBUG` trap, the last command used to determine the status is the last command executed by the trap handler before `return` was invoked. `return` may also be used to terminate execution of a script being executed with the `.` (`source`) builtin, returning either n or the exit status of the last command executed within the script as the exit status of the script. If n is supplied, the return value is its least significant 8 bits. Any command associated with the `RETURN` trap is executed before execution resumes after the function or script. The return status is non-zero if `return` is supplied a non-numeric argument or is used outside a function and not during the execution of a script by `.` or `source`. 导致 shell 函数停止执行并返回值 n如果未提供 n如果 `return`如果在 `DEBUG` 陷阱期间执行 `return`调用 `return``return`使用 `.` （`source`返回 n如果提供 n执行与 `RETURN`如果`return`而不是在 `.` 或 `source` 给它的调用者。 ，则返回值是 在函数中执行的最后一个命令。 由陷阱处理程序执行，则最后一个命令用于 确定状态是在陷阱处理程序之前执行的最后一个命令。 ，则最后一个命令 用于确定状态的是陷阱执行的最后一个命令 。 也可用于终止脚本的执行 ） 内置执行， 或 在脚本中执行的最后一个命令的退出状态为退出 脚本的状态。 ，则返回值是其最低有效值 8 位。 陷阱关联的任何命令 在函数或脚本之后恢复执行之前。 提供非数字，则返回状态为非零 参数或在函数外部使用 执行脚本期间。

`shift`

Shift the positional parameters to the left by n. The positional parameters from n+1 … `$#` are renamed to `$1` … `$#`\-n. Parameters represented by the numbers `$#` down to `$#`\-n+1 are unset. n must be a non-negative number less than or equal to `$#`. If n is zero or greater than `$#`, the positional parameters are not changed. If n is not supplied, it is assumed to be 1. The return status is zero unless n is greater than `$#` or less than zero, non-zero otherwise. 将位置参数向左移动 n位置参数从 n+1 ...`$#`重命名为 `$1`......`$#`\-n由数字 `$#` 表示的参数，降至 `$#`\-nn 必须是小于或等于 `$#`如果 n 为零或大于 `$#`如果未提供 n返回状态为零，除非 n 大于 `$#`。 是 。 +1 未设置。 的非负数。 ，则位置参数 没有改变。 ，则假定它为 1。 或 小于零，否则为非零。

`test`

`[`

Evaluate a conditional expression expr and return a status of 0 (true) or 1 (false). Each operator and operand must be a separate argument. Expressions are composed of the primaries described below in [Bash Conditional Expressions](https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions). `test` does not accept any options, nor does it accept and ignore an argument of \-- as signifying the end of options. 计算条件表达式 expr[Bash 条件表达式](https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions)`test`\-- 并返回状态 0 （true） 或 1 （false）。 每个运算符和操作数必须是一个单独的参数。 表达式由下面描述的原语组成 。 不接受任何选项，也不接受和忽略 表示期权的结束。

When the `[` form is used, the last argument to the command must be a `]`. 使用 `[`是 `]` 形式时，命令的最后一个参数必须 。

Expressions may be combined using the following operators, listed in decreasing order of precedence. The evaluation depends on the number of arguments; see below. Operator precedence is used when there are five or more arguments. 表达式可以使用以下运算符组合，列在 优先级递减顺序。 评估取决于参数的数量;见下文。 当有五个或更多参数时，使用运算符优先级。

`! expr`!expr

True if expr is false. 如果 expr 为 false，则为 true。

`( expr )`（ expr ）

Returns the value of expr. This may be used to override the normal precedence of operators. 返回 expr 的值。 这可用于覆盖运算符的正常优先级。

`expr1 -a expr2`expr1 -a expr2

True if both expr1 and expr2 are true. 如果 expr1 和 expr2 都为 true，则为 true。

`expr1 -o expr2`expr1 -o expr2

True if either expr1 or expr2 is true. 如果 expr1 或 expr2 为 true，则为 true。

The `test` and `[` builtins evaluate conditional expressions using a set of rules based on the number of arguments. `test`和 `[` 内置函数评估条件 使用一组基于参数数量的规则的表达式。

0 arguments0 参数

The expression is false. 表达式为 false。

1 argument1 参数

The expression is true if, and only if, the argument is not null. 当且仅当参数不为 null 时，表达式为 true。

2 arguments2 参数

If the first argument is ‘!’, the expression is true if and only if the second argument is null. If the first argument is one of the unary conditional operators (see [Bash Conditional Expressions](https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions)), the expression is true if the unary test is true. If the first argument is not a valid unary operator, the expression is false. 如果第一个参数是 '!（请参阅 [Bash 条件表达式](https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions)'，则表达式为 true，如果 仅当第二个参数为 null 时。 如果第一个参数是一元条件运算符之一 ），表达式 如果一元检验为真，则为真。 如果第一个参数不是有效的一元运算符，则表达式为 假。

3 arguments3 参数

The following conditions are applied in the order listed. 以下条件按列出的顺序应用。

1.  If the second argument is one of the binary conditional operators (see [Bash Conditional Expressions](https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions)), the result of the expression is the result of the binary test using the first and third arguments as operands. The ‘\-a’ and ‘\-o’ operators are considered binary operators when there are three arguments. 运算符（参见 [Bash 条件表达式](https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions)“\-a”和“\-o如果第二个参数是二进制条件之一 ）， 表达式的结果是使用 第一个和第三个参数作为操作数。 ”运算符被视为二进制运算符 当有三个参数时。
2.  If the first argument is ‘!’, the value is the negation of the two-argument test using the second and third arguments. 如果第一个参数是 '!'，则该值是 使用第二个和第三个参数的双参数测试。
3.  If the first argument is exactly ‘(’ and the third argument is exactly ‘)’, the result is the one-argument test of the second argument. 如果第一个参数正好是 '(正好是 ')'，第三个参数是 '，结果是第二个的单参数检验 论点。
4.  Otherwise, the expression is false. 否则，表达式为 false。

4 arguments4 参数

The following conditions are applied in the order listed. 以下条件按列出的顺序应用。

1.  If the first argument is ‘!’, the result is the negation of the three-argument expression composed of the remaining arguments. 如果第一个参数是 '!'，则结果是 由其余参数组成的三参数表达式。
2.  If the first argument is exactly ‘(’ and the fourth argument is exactly ‘)’, the result is the two-argument test of the second and third arguments. 如果第一个参数正好是 '(正好是 ')'，而第四个参数是 '，结果是第二个的双参数检验 和第三个论点。
3.  Otherwise, the expression is parsed and evaluated according to precedence using the rules listed above.

5 or more arguments5 个或更多参数

The expression is parsed and evaluated according to precedence using the rules listed above. 根据优先级对表达式进行解析和计算 使用上面列出的规则。

When used with `test` or ‘\[’, the ‘<’ and ‘\>’ operators sort lexicographically using ASCII ordering. 当与 `test` 或 '\['、'<' 和 '\>' 一起使用时 运算符使用 ASCII 排序按字典方式排序。

`times`

Print out the user and system times used by the shell and its children. The return status is zero.

`trap`

```
trap [-lp] [arg] [sigspec …]
```

The commands in arg are to be read and executed when the shell receives signal sigspec. If arg is absent (and there is a single sigspec) or equal to ‘\-’, each specified signal’s disposition is reset to the value it had when the shell was started. If arg is the null string, then the signal specified by each sigspec is ignored by the shell and commands it invokes. If arg is not present and \-p has been supplied, the shell displays the trap commands associated with each sigspec. If no arguments are supplied, or only \-p is given, `trap` prints the list of commands associated with each signal number in a form that may be reused as shell input. The \-l option causes the shell to print a list of signal names and their corresponding numbers. Each sigspec is either a signal name or a signal number. Signal names are case insensitive and the `SIG` prefix is optional. argshell 接收信号 sigspec。 如果 arg有一个 sigspec等于 \-如果 arg每个 sigspec如果 arg 不存在并且提供了 \-pshell 显示与每个 sigspec只给出 \-p 打印命令列表 \-l每个 sigspec信号名称不区分大小写，`SIG` 中的命令将在以下情况下读取和执行 不存在（并且 ）或 '，则每个指定信号的配置被复位 设置为启动 shell 时的值。 是 null 字符串，则 都会被 shell 及其调用的命令忽略。 ， 关联的 trap 命令。 如果未提供任何参数，或者 以可重复使用的形式与每个信号编号相关联 shell 输入。 选项使 shell 打印信号名称列表 及其相应的数字。 要么是信号名称，要么是信号编号。 前缀是可选的。

If a sigspec is `0` or `EXIT`, arg is executed when the shell exits. If a sigspec is `DEBUG`, the command arg is executed before every simple command, `for` command, `case` command, `select` command, every arithmetic `for` command, and before the first command executes in a shell function. Refer to the description of the `extdebug` option to the `shopt` builtin (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)) for details of its effect on the `DEBUG` trap. If a sigspec is `RETURN`, the command arg is executed each time a shell function or a script executed with the `.` or `source` builtins finishes executing. 如果 sigspec为 `0` 或 `EXIT`时，则在 shell 退出时执行 arg如果 sigspec 为 `DEBUG`则执行命令 arg在每个简单命令之前，`for`命令，`case``select`命令`for`请参阅 `extdebug``shopt` builtin（参见 [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)对 `DEBUG`如果 sigspec 为 `RETURN`则执行命令 arg每次使用 `.``source` 。 命令， 算术以及之前 第一个命令在 shell 函数中执行。 选项的说明，了解 ）了解其详细信息 陷阱的影响。 或 内置完成执行。

If a sigspec is `ERR`, the command arg is executed whenever a pipeline (which may consist of a single simple command), a list, or a compound command returns a non-zero exit status, subject to the following conditions. The `ERR` trap is not executed if the failed command is part of the command list immediately following an `until` or `while` keyword, part of the test following the `if` or `elif` reserved words, part of a command executed in a `&&` or `||` list except the command following the final `&&` or `||`, any command in a pipeline but the last, or if the command’s return status is being inverted using `!`. These are the same conditions obeyed by the `errexit` (\-e) option. 如果 sigspec 为 `ERR`，则命令 arg如果命令列表紧跟在 `until` 或 `while``if`或`elif`在 `&&` 或 `||`除了最后的 `&&` 或 `||`状态正在使用 `!`这些是 `errexit` （\-e 每当 管道（可以由单个简单的管道组成 命令）、列表或复合命令返回 非零退出状态， 受以下条件的约束。 失败的命令是 关键字后面， 保留词之后进行的部分测试， 列表中执行的命令的一部分 的命令， 管道中除最后一个命令外的任何命令， 或者如果命令返回 . ） 所遵循的相同条件 选择。

Signals ignored upon entry to the shell cannot be trapped or reset. Trapped signals that are not being ignored are reset to their original values in a subshell or subshell environment when one is created. 进入shell时忽略的信号不能被捕获或重置。 未被忽略的捕获信号被重置为原始信号 创建子 shell 或子 shell 环境中的值。

The return status is zero unless a sigspec does not specify a valid signal. 返回状态为零，除非 sigspec 未指定 有效信号。

`umask`

Set the shell process’s file creation mask to mode. If mode begins with a digit, it is interpreted as an octal number; if not, it is interpreted as a symbolic mode mask similar to that accepted by the `chmod` command. If mode is omitted, the current value of the mask is printed. If the \-S option is supplied without a mode argument, the mask is printed in a symbolic format. If the \-p option is supplied, and mode is omitted, the output is in a form that may be reused as input. The return status is zero if the mode is successfully changed or if no mode argument is supplied, and non-zero otherwise. 将 shell 进程的文件创建掩码设置为modemode到 `chmod` 命令接受的。 如果mode省略后，将打印掩码的当前值。 如果 \-S提供 option 时不带 mode如果提供了 \-p 选项，并且mode不提供 mode。 如果 以数字开头，它被解释为八进制数; 如果不是，则将其解释为类似于的符号模式掩码 是 参数，打印掩码 以符号格式。 则输出的形式可以作为输入重用。 如果模式更改成功，或者如果 参数，否则不提供非零。

Note that when the mode is interpreted as an octal number, each number of the umask is subtracted from `7`. Thus, a umask of `022` results in permissions of `755`. 从 `7` 中减去 umask。 因此，`022`导致权限为 `755`请注意，当模式被解释为八进制数时，每个数字 的 umask 。

`unset`

Remove each variable or function name. If the \-v option is given, each name refers to a shell variable and that variable is removed. If the \-f option is given, the names refer to shell functions, and the function definition is removed. If the \-n option is supplied, and name is a variable with the `nameref` attribute, name will be unset rather than the variable it references. \-n has no effect if the \-f option is supplied. If no options are supplied, each name refers to a variable; if there is no variable by that name, a function with that name, if any, is unset. Readonly variables and functions may not be unset. Some shell variables lose their special behavior if they are unset; such behavior is noted in the description of the individual variables. The return status is zero unless a name is readonly or may not be unset. 删除每个变量或函数name如果给定 \-vname如果给定 \-f 选项，name如果提供了 \-n 选项，并且 name`nameref` 属性，name如果提供了 \-f 选项，\-n如果未提供任何选项，则每个name返回状态为零，除非name。 选项，则每个 引用一个 shell 变量，该变量将被删除。 s 引用 shell 函数，并删除函数定义。 是具有 将被取消设置，而不是 它引用的变量。 不起作用。 都引用一个变量;如果 没有该名称的变量，具有该名称的函数（如果有）是 未凝固的。 Readonly 变量和函数不能取消设置。 如果未设置某些 shell 变量，它们将失去其特殊行为;这样 行为在各个变量的描述中注明。 是只读的或可能未取消设置。

___

### 4.2 Bash Builtin Commands

This section describes builtin commands which are unique to or have been extended in Bash. Some of these commands are specified in the <small>POSIX</small> standard.

`alias`

```
alias [-p] [name[=value] …]
```

Without arguments or with the \-p option, `alias` prints the list of aliases on the standard output in a form that allows them to be reused as input. If arguments are supplied, an alias is defined for each name whose value is given. If no value is given, the name and value of the alias is printed. Aliases are described in [Aliases](https://www.gnu.org/software/bash/manual/bash.html#Aliases). 没有参数或带有 \-p 选项，`alias`如果提供了参数，则为每个name其value被给出。 如果未给出value别名在[别名](https://www.gnu.org/software/bash/manual/bash.html#Aliases)打印 标准输出上的别名列表，其形式允许 它们将作为输入重用。 定义别名 ，则名称 并打印别名的值。 中进行了描述。

`bind`

```
bind [-m keymap] [-lpsvPSVX]
bind [-m keymap] [-q function] [-u function] [-r keyseq]
bind [-m keymap] -f filename
bind [-m keymap] -x keyseq:shell-command
bind [-m keymap] keyseq:function-name
bind [-m keymap] keyseq:readline-command
bind readline-command-line
```

Display current Readline (see [Command Line Editing](https://www.gnu.org/software/bash/manual/bash.html#Command-Line-Editing)) key and function bindings, bind a key sequence to a Readline function or macro, or set a Readline variable. Each non-option argument is a command as it would appear in a Readline initialization file (see [Readline Init File](https://www.gnu.org/software/bash/manual/bash.html#Readline-Init-File)), but each binding or command must be passed as a separate argument; e.g., ‘"\\C-x\\C-r":re-read-init-file’. 显示当前 Readline（请参阅[命令行编辑](https://www.gnu.org/software/bash/manual/bash.html#Command-Line-Editing)Readline 初始化文件（参见 [Readline 初始化文件](https://www.gnu.org/software/bash/manual/bash.html#Readline-Init-File)'"\\C-x\\C-r":re-read-init-file） 键和函数绑定， 将键序列绑定到 Readline 函数或宏， 或设置 Readline 变量。 每个非选项参数都是一个命令，因为它会出现在 ）， 但每个绑定或命令必须作为单独的参数传递; 例如， '。

Options, if supplied, have the following meanings: 选项（如果提供）具有以下含义：

`-m keymap`\-m keymap

Use keymap as the keymap to be affected by the subsequent bindings. Acceptable keymap names are `emacs`, `emacs-standard`, `emacs-meta`, `emacs-ctlx`, `vi`, `vi-move`, `vi-command`, and `vi-insert`. `vi` is equivalent to `vi-command` (`vi-move` is also a synonym); `emacs` is equivalent to `emacs-standard`. 使用keymap后续绑定。 可接受的keymap`emacs``emacs-standard``emacs-meta``emacs-ctlx``vi``vi-move``vi-command``vi-insert``vi` 等价于 `vi-command`（`vi-move`同义词）;`emacs` 等同于 `emacs-standard`作为要影响的键盘映射 名称是 ， ， ， ， ， ， 和 。 也是 。

`-l`

List the names of all Readline functions. 列出所有 Readline 函数的名称。

`-p`

Display Readline function names and bindings in such a way that they can be used as input or in a Readline initialization file. 显示 Readline 函数名称和绑定的方式如下： 可以用作输入或在 Readline 初始化文件中使用。

`-P`

List current Readline function names and bindings. 列出当前的 Readline 函数名称和绑定。

`-v`

Display Readline variable names and values in such a way that they can be used as input or in a Readline initialization file. 显示 Readline 变量名称和值的方式如下： 可以用作输入或在 Readline 初始化文件中使用。

`-V`

List current Readline variable names and values. 列出当前的 Readline 变量名称和值。

`-s`

Display Readline key sequences bound to macros and the strings they output in such a way that they can be used as input or in a Readline initialization file. 显示绑定到宏的 Readline 键序列及其输出的字符串 以这样一种方式，它们可以用作输入或在 Readline 中 初始化文件。

`-S`

Display Readline key sequences bound to macros and the strings they output. 显示绑定到宏的 Readline 键序列及其输出的字符串。

`-f filename`\-f filename

Read key bindings from filename. 从filename中读取键绑定。

`-q function`\-q function

Query about which keys invoke the named function. 查询哪些键调用命名function。

`-u function`\-u function

Unbind all keys bound to the named function. 解绑绑定到命名function的所有键。

`-r keyseq`\-r keyseq

Remove any current binding for keyseq. 删除 keyseq 的任何当前绑定。

`-x keyseq:shell-command`\-x keyseq:shell-command

Cause shell-command to be executed whenever keyseq is entered. When shell-command is executed, the shell sets the `READLINE_LINE` variable to the contents of the Readline line buffer and the `READLINE_POINT` and `READLINE_MARK` variables to the current location of the insertion point and the saved insertion point (the mark), respectively. The shell assigns any numeric argument the user supplied to the `READLINE_ARGUMENT` variable. If there was no argument, that variable is not set. If the executed command changes the value of any of `READLINE_LINE`, `READLINE_POINT`, or `READLINE_MARK`, those new values will be reflected in the editing state. 每当 keyseq 出现时，就会执行 shell-command执行 shell-command`READLINE_LINE`buffer 以及 `READLINE_POINT` 和 `READLINE_MARK`点（mark`READLINE_ARGUMENT`如果执行的命令更改`READLINE_LINE``READLINE_POINT`或`READLINE_MARK` 进入。 时，shell 将 Readline 行内容的变量 变量 到插入点的当前位置和保存的插入点 ）。 shell 将用户提供给 变量。 如果没有参数，则未设置该变量。 中的任何一个的值， ，这些新值将是 反映在编辑状态中。

`-X`

List all key sequences bound to shell commands and the associated commands in a format that can be reused as input. 列出绑定到 shell 命令和关联命令的所有键序列 以可重复用作输入的格式。

The return status is zero unless an invalid option is supplied or an error occurs. 返回状态为零，除非提供了无效选项或 发生错误。

`builtin`

```
builtin [shell-builtin [args]]
```

Run a shell builtin, passing it args, and return its exit status. This is useful when defining a shell function with the same name as a shell builtin, retaining the functionality of the builtin within the function. The return status is non-zero if shell-builtin is not a shell builtin command. 运行一个内置的 shell，传递它 args如果 shell-builtin，并返回其退出状态。 这在定义具有相同 名称为内置 shell，保留内置 函数。 不是 shell，则返回状态为非零 内置命令。

`caller`

Returns the context of any active subroutine call (a shell function or a script executed with the `.` or `source` builtins). 使用 `.` 或 `source`返回任何活动子例程调用（shell 函数或 builtins） 执行的脚本。

Without expr, `caller` displays the line number and source filename of the current subroutine call. If a non-negative integer is supplied as expr, `caller` displays the line number, subroutine name, and source file corresponding to that position in the current execution call stack. This extra information may be used, for example, to print a stack trace. The current frame is frame 0. 如果没有 expr，`caller`如果以 expr 的形式提供非负整数，`caller`将显示线路号和来源 当前子例程调用的文件名。 显示对应的行号、子例程名称和源文件 到当前执行调用堆栈中的该位置。 这个额外的 例如，可以使用信息来打印堆栈跟踪。 这 当前帧为帧 0。

The return value is 0 unless the shell is not executing a subroutine call or expr does not correspond to a valid position in the call stack. call 或 expr返回值为 0，除非 shell 未执行子例程 不对应于 调用堆栈。

`command`

```
command [-pVv] command [arguments …]
```

Runs command with arguments ignoring any shell function named command. Only shell builtin commands or commands found by searching the `PATH` are executed. If there is a shell function named `ls`, running ‘command ls’ within the function will execute the external command `ls` instead of calling the function recursively. The \-p option means to use a default value for `PATH` that is guaranteed to find all of the standard utilities. The return status in this case is 127 if command cannot be found or an error occurred, and the exit status of command otherwise. commandarguments命名command`PATH`如果有名为 `ls` 的 shell 函数，请运行“command ls在函数中将执行外部命令 `ls`\-p 选项表示对 `PATH`在这种情况下，如果command发现或发生错误，command，忽略任何 shell 函数 。 只有 shell 内置命令或通过搜索 。 ” 而不是以递归方式调用函数。 使用默认值 这保证可以找到所有标准实用程序。 不能为 退出状态 否则。

If either the \-V or \-v option is supplied, a description of command is printed. The \-v option causes a single word indicating the command or file name used to invoke command to be displayed; the \-V option produces a more verbose description. In this case, the return status is zero if command is found, and non-zero if not. 如果提供了 \-V 或 \-v打印command说明。 \-v调用要显示command;\-V如果command 选项，则 选项 导致一个单词指示用于的命令或文件名 选项产生 更冗长的描述。 在这种情况下，返回状态为 ，则为零，如果没有，则为非零。

`declare`

```
declare [-aAfFgiIlnrtux] [-p] [name[=value] …]
```

Declare variables and give them attributes. If no names are given, then display the values of variables instead. 声明变量并为其提供属性。 如果没有names ，然后显示变量的值。

The \-p option will display the attributes and values of each name. When \-p is used with name arguments, additional options, other than \-f and \-F, are ignored. \-pname当 \-p 与 name除 \-f 和 \-F 选项将显示每个 。 参数一起使用时，其他选项、 外，将被忽略。

When \-p is supplied without name arguments, `declare` will display the attributes and values of all variables having the attributes specified by the additional options. If no other options are supplied with \-p, `declare` will display the attributes and values of all shell variables. The \-f option will restrict the display to shell functions. 当提供 \-p 时不name 参数时，`declare`如果 \-p 未提供其他选项，`declare`显示所有 shell 变量的属性和值。 \-f 将显示所有变量的属性和值，这些变量具有 由其他选项指定的属性。 将 选项会将显示限制为 shell 功能。

The \-F option inhibits the display of function definitions; only the function name and attributes are printed. If the `extdebug` shell option is enabled using `shopt` (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)), the source file name and line number where each name is defined are displayed as well. \-F implies \-f. \-F如果使用 `shopt` 启用`extdebug`（请参阅 [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)每个name\-F 表示 \-f 选项禁止显示函数定义; 仅打印函数名称和属性。 shell 选项 ），源文件名和行号，其中 也会显示出来。 。

The \-g option forces variables to be created or modified at the global scope, even when `declare` is executed in a shell function. It is ignored in all other cases. \-g全局作用域，即使 `declare` 选项强制在以下位置创建或修改变量 是在 shell 函数中执行的。 在所有其他情况下，它都会被忽略。

The \-I option causes local variables to inherit the attributes (except the `nameref` attribute) and value of any existing variable with the same name at a surrounding scope. If there is no existing variable, the local variable is initially unset. \-I（`nameref`name 选项使局部变量继承属性 属性除外） 和具有相同值的任何现有变量的值 在周围范围内。 如果没有现有变量，则初始取消设置局部变量。

The following options can be used to restrict output to variables with the specified attributes or to give variables attributes: 以下选项可用于将输出限制为具有 指定的属性或给变量属性：

`-a`

Each name is an indexed array variable (see [Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)). 每个name都是一个索引数组变量（请参阅[数组](https://www.gnu.org/software/bash/manual/bash.html#Arrays)）。

`-A`

Each name is an associative array variable (see [Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)). 每个name都是一个关联数组变量（请参阅[数组](https://www.gnu.org/software/bash/manual/bash.html#Arrays)）。

`-f`

Use function names only. 仅使用函数名称。

`-i`

The variable is to be treated as an integer; arithmetic evaluation (see [Shell Arithmetic](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)) is performed when the variable is assigned a value. 整数;算术计算（参见 [Shell 算术](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)该变量将被视为 ）是 在为变量赋值时执行。

`-l`

When the variable is assigned a value, all upper-case characters are converted to lower-case. The upper-case attribute is disabled. 当变量被赋值时，所有大写字符都为 转换为小写。 大写属性处于禁用状态。

`-n`

Give each name the `nameref` attribute, making it a name reference to another variable. That other variable is defined by the value of name. All references, assignments, and attribute modifications to name, except for those using or changing the \-n attribute itself, are performed on the variable referenced by name’s value. The nameref attribute cannot be applied to array variables. 为每个name指定 `nameref`另一个变量由 namename\-nname 属性，使 它是对另一个变量的名称引用。 的值定义。 所有引用、赋值和属性修改 ，但使用或更改 属性本身，对 的值。 nameref 属性不能应用于数组变量。

`-r`

Make names readonly. These names cannot then be assigned values by subsequent assignment statements or unset. 将name设为只读。 然后，无法为这些名称赋值 通过后续赋值语句或未设置。

`-t`

Give each name the `trace` attribute. Traced functions inherit the `DEBUG` and `RETURN` traps from the calling shell. The trace attribute has no special meaning for variables. 为每个name指定 `trace`跟踪函数继承 `DEBUG` 和 `RETURN` 属性。 陷阱 调用 shell。 trace 属性对变量没有特殊含义。

`-u`

When the variable is assigned a value, all lower-case characters are converted to upper-case. The lower-case attribute is disabled. 为变量赋值时，所有小写字符都为 转换为大写。 小写属性处于禁用状态。

`-x`

Mark each name for export to subsequent commands via the environment. 标记每个name以导出到后续命令 环境。

Using ‘+’ instead of ‘\-’ turns off the attribute instead, with the exceptions that ‘+a’ and ‘+A’ may not be used to destroy array variables and ‘+r’ will not remove the readonly attribute. When used in a function, `declare` makes each name local, as with the `local` command, unless the \-g option is used. If a variable name is followed by =value, the value of the variable is set to value. 使用“+”而不是“\-“+a”和“+A不能用于销毁数组变量，而 +r在函数中使用时，`declare` 使每个name与`local`命令一样，除非使用 \-g如果变量名称后跟 =value设置为 value”会关闭属性， ”除外 ' 不会 删除 readonly 属性。 都本地化， 选项。 ，则变量的值 。

When using \-a or \-A and the compound assignment syntax to create array variables, additional attributes do not take effect until subsequent assignments. 当使用 \-a 或 \-A 以及复合赋值语法时 创建数组变量，其他属性直到 后续任务。

The return status is zero unless an invalid option is encountered, an attempt is made to define a function using ‘\-f foo=bar’, an attempt is made to assign a value to a readonly variable, an attempt is made to assign a value to an array variable without using the compound assignment syntax (see [Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)), one of the names is not a valid shell variable name, an attempt is made to turn off readonly status for a readonly variable, an attempt is made to turn off array status for an array variable, or an attempt is made to display a non-existent function with \-f. 尝试使用 '\-f foo=bar使用复合赋值语法（参见[数组](https://www.gnu.org/software/bash/manual/bash.html#Arrays)其中一个name或者尝试使用 \-f返回状态为零，除非遇到无效选项， ' 定义函数， 尝试将值分配给 readonly 变量， 尝试将值分配给数组变量，而不 ）， S 不是有效的 shell 变量名称， 尝试关闭 readonly 变量的 readonly 状态， 尝试关闭数组变量的数组状态， 显示不存在的函数。

`echo`

Output the args, separated by spaces, terminated with a newline. The return status is 0 unless a write error occurs. If \-n is specified, the trailing newline is suppressed. If the \-e option is given, interpretation of the following backslash-escaped characters is enabled. The \-E option disables the interpretation of these escape characters, even on systems where they are interpreted by default. The `xpg_echo` shell option may be used to dynamically determine whether or not `echo` expands these escape characters by default. `echo` does not interpret \-- to mean the end of options. 输出 arg如果指定了 \-n如果给出\-e\-E`xpg_echo`动态确定 `echo``echo` 不解释 \--s，用空格分隔，以 换行符。 除非发生写入错误，否则返回状态为 0。 ，则禁止显示尾随换行符。 选项，则解释以下内容 反斜杠转义字符已启用。 选项禁用对这些转义字符的解释， 即使在默认解释它们的系统上也是如此。 shell 选项可用于 是否扩展这些内容 默认情况下转义字符。 意味着期权的结束。

`echo` interprets the following escape sequences: `echo` 解释以下转义序列：

`\a`

alert (bell) 警报（铃铛）

`\b`

backspace 退格键

`\c`

suppress further output 抑制进一步输出

`\e`

`\E`

escape

`\f`

form feed 表单提要

`\n`

new line 新线

`\r`

carriage return 回车

`\t`

horizontal tab 水平选项卡

`\v`

vertical tab 垂直选项卡

`\\`

backslash 反斜線

`\0nnn`

the eight-bit character whose value is the octal value nnn (zero to three octal digits) 值为八进制值 nnn 的八位字符 （零到三个八进制数字）

`\xHH`\\xHH

the eight-bit character whose value is the hexadecimal value HH (one or two hex digits) 值为十六进制值 HH 的八位字符 （一个或两个十六进制数字）

`\uHHHH`\\uHHHH

the Unicode (ISO/IEC 10646) character whose value is the hexadecimal value HHHH (one to four hex digits) HHHHUnicode （ISO/IEC 10646） 字符，其值为十六进制值 （一到四个十六进制数字）

`\UHHHHHHHH`\\uHHHHHHHH

the Unicode (ISO/IEC 10646) character whose value is the hexadecimal value HHHHHHHH (one to eight hex digits) HHHHHHHHUnicode （ISO/IEC 10646） 字符，其值为十六进制值 一到八个十六进制数字）

`enable`

```
enable [-a] [-dnps] [-f filename] [name …]
```

Enable and disable builtin shell commands. Disabling a builtin allows a disk command which has the same name as a shell builtin to be executed without specifying a full pathname, even though the shell normally searches for builtins before disk commands. If \-n is used, the names become disabled. Otherwise names are enabled. For example, to use the `test` binary found via `$PATH` instead of the shell builtin version, type ‘enable -n test’. 如果使用 \-n，namenameS 已启用。 例如，使用 `test`通过 `$PATH`'enable -n test启用和禁用内置 shell 命令。 禁用内置命令允许具有相同名称的磁盘命令 作为内置的 shell，无需指定完整路径名即可执行， 即使 shell 通常在磁盘命令之前搜索内置项。 s 将被禁用。 否则 二进制文件 而不是 shell 内置版本找到，键入 '。

If the \-p option is supplied, or no name arguments appear, a list of shell builtins is printed. With no other arguments, the list consists of all enabled shell builtins. The \-a option means to list each builtin with an indication of whether or not it is enabled. 如果提供了 \-p 选项，或者没有name\-a 参数， 将打印 shell 内置项列表。 没有其他参数，列表 由所有已启用的 shell 内置函数组成。 选项表示列出 每个内置都带有是否启用的指示。

The \-f option means to load the new builtin command name from shared object filename, on systems that support dynamic loading. Bash will use the value of the `BASH_LOADABLES_PATH` variable as a colon-separated list of directories in which to search for filename. The default is system-dependent. The \-d option will delete a builtin loaded with \-f. \-f 选项表示加载新的内置命令name从共享对象filenameBash 将使用 `BASH_LOADABLES_PATH`要在其中搜索filename\-d 选项将删除加载了 \-f ，在支持动态加载的系统上。 变量的值作为 的目录的冒号分隔列表。 默认值与系统相关。 的内置插件。

If there are no options, a list of the shell builtins is displayed. The \-s option restricts `enable` to the <small>POSIX</small> special builtins. If \-s is used with \-f, the new builtin becomes a special builtin (see [Special Builtins](https://www.gnu.org/software/bash/manual/bash.html#Special-Builtins)). \-s 选项将`enable`限制为 <small>POSIX</small>内置。 如果 \-s 与 \-f特殊内置（请参阅[特殊内置）。](https://www.gnu.org/software/bash/manual/bash.html#Special-Builtins)如果没有选项，则显示 shell 内置项列表。 特殊 一起使用，则新的内置函数变为

If no options are supplied and a name is not a shell builtin, `enable` will attempt to load name from a shared object named name, as if the command were ‘enable -f name name’. 如果未提供任何选项，并且name`enable` 将namename'enable -f namename不是内置的 shell， ，就好像命令是 '。

The return status is zero unless a name is not a shell builtin or there is an error loading a new builtin from a shared object. 返回状态为零，除非name不是内置的 shell 或者从共享对象加载新的内置函数时出错。

`help`

Display helpful information about builtin commands. If pattern is specified, `help` gives detailed help on all commands matching pattern, otherwise a list of the builtins is printed. 如果指定pattern，`help`在所有命令上匹配pattern显示有关内置命令的有用信息。 提供详细的帮助 ，否则 内置函数被打印出来。

Options, if supplied, have the following meanings: 选项（如果提供）具有以下含义：

`-d`

Display a short description of each pattern显示每个pattern的简短说明

`-m`

Display the description of each pattern in a manpage-like format 以类似手册页的格式显示每个pattern的描述

`-s`

Display only a short usage synopsis for each pattern仅显示每个pattern的简短用法概要

The return status is zero unless no command matches pattern. 返回状态为零，除非没有与pattern匹配的命令。

`let`

```
let expression [expression …]
```

The `let` builtin allows arithmetic to be performed on shell variables. Each expression is evaluated according to the rules given below in [Shell Arithmetic](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic). If the last expression evaluates to 0, `let` returns 1; otherwise 0 is returned. `let`变量。 每个expression[壳牌算术](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)最后一个expression计算结果为 `let` 内置允许在 shell 上执行算术 都根据 中给出的规则如下。 如果 返回 1; 否则返回 0。

`local`

```
local [option] name[=value] …
```

For each argument, a local variable named name is created, and assigned value. The option can be any of the options accepted by `declare`. `local` can only be used within a function; it makes the variable name have a visible scope restricted to that function and its children. If name is ‘\-’, the set of shell options is made local to the function in which `local` is invoked: shell options changed using the `set` builtin inside the function are restored to their original values when the function returns. The restore is effected as if a series of `set` commands were executed to restore the values that were in place before the function. The return status is zero unless `local` is used outside a function, an invalid name is supplied, or name is a readonly variable. 对于每个参数，都会创建一个名为 name和valueoption可以是`declare``local`name如果name为 \-调用 `local`函数内部内置`set`恢复就像执行了一系列`set`返回状态为零，除非在外部使用`local`函数，提供无效name，或者name 的局部变量， 。 接受的任何选项。 只能在函数中使用;它使变量 具有限制为该函数的可见范围及其 孩子。 '，则 shell 选项集将设为 的函数：使用 将恢复到原来的状态 函数返回时的值。 命令一样 以还原函数之前存在的值。 为 readonly 变量。

`logout`

Exit a login shell, returning a status of n to the shell’s parent. 退出登录 shell，将状态 n 返回到 shell 的 父母。

`mapfile`

```
mapfile [-d delim] [-n count] [-O origin] [-s count]
    [-t] [-u fd] [-C callback] [-c quantum] [array]
```

Read lines from the standard input into the indexed array variable array, or from file descriptor fd if the \-u option is supplied. The variable `MAPFILE` is the default array. Options, if supplied, have the following meanings: 从标准输入读取行到索引数组变量array或从文件描述符 fd如果提供了 \-u变量 `MAPFILE` 是默认array中， 选项。 。 选项（如果提供）具有以下含义：

`-d`

The first character of delim is used to terminate each input line, rather than newline. If delim is the empty string, `mapfile` will terminate a line when it reads a NUL character. delim如果 delim 为空字符串，`mapfile` 的第一个字符用于终止每条输入行， 而不是换行符。 将终止一行 当它读取 NUL 字符时。

`-n`

Copy at most count lines. If count is 0, all lines are copied. 最多复制count行。 如果 count 为 0，则复制所有行。

`-O`

Begin assigning to array at index origin. The default index is 0. 开始在索引origin点处分配给array。 默认索引为 0。

`-s`

Discard the first count lines read. 丢弃读取的第一行count。

`-t`

Remove a trailing delim (default newline) from each line read. 从每行读取中删除尾随 delim（默认换行符）。

`-u`

Read lines from file descriptor fd instead of the standard input. 从文件描述符 fd 而不是标准输入中读取行。

`-C`

Evaluate callback each time quantum lines are read. The \-c option specifies quantum. 每次读取quantum线时评估callback\-c 选项指定quantum。 。

`-c`

Specify the number of lines read between each call to callback. 指定每次调用回callback之间读取的行数。

If \-C is specified without \-c, the default quantum is 5000. When callback is evaluated, it is supplied the index of the next array element to be assigned and the line to be assigned to that element as additional arguments. callback is evaluated after the line is read but before the array element is assigned. 如果指定 \-C 而不\-c当评估callbackcallback， 默认量程为 5000。 时，会向它提供下一个的索引 要赋值的数组元素和要赋给该元素的行 作为附加参数。 在读取行之后但在 数组元素被分配。

If not supplied with an explicit origin, `mapfile` will clear array before assigning to it.

`mapfile` returns successfully unless an invalid option or option argument is supplied, array is invalid or unassignable, or array is not an indexed array.

`printf`

```
printf [-v var] format [arguments]
```

Write the formatted arguments to the standard output under the control of the format. The \-v option causes the output to be assigned to the variable var rather than being printed to the standard output. 将格式化的argumentsformat\-vvar写入标准输出中，在 控制。 选项使输出分配给变量 而不是打印到标准输出。

The format is a character string which contains three types of objects: plain characters, which are simply copied to standard output, character escape sequences, which are converted and copied to the standard output, and format specifications, each of which causes printing of the next successive argument. In addition to the standard `printf(1)` formats, `printf` interprets the following extensions: formatargument除了标准的 `printf(1)` 格式之外，`printf`是一个字符串，其中包含三种类型的对象： 纯字符，只需复制到标准输出，字符 转义序列，这些序列被转换并复制到标准输出，以及 格式规范，每个规范都会导致下一个连续的打印 。 解释以下扩展：

`%b`

Causes `printf` to expand backslash escape sequences in the corresponding argument in the same way as `echo -e` (see [Bash Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)). 使 `printf`以与 `echo -e` 相同的方式对应argument（请参阅 [Bash 内置命令](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins) 展开 ）。

`%q`

Causes `printf` to output the corresponding argument in a format that can be reused as shell input. 使 `printf`相应的argument 输出 ，其格式可以重用作 shell 输入。

`%Q`

like `%q`, but applies any supplied precision to the argument before quoting it. 与 `%q` 类似，但将任何提供的精度应用于argument 在引用它之前。

`%(datefmt)T`%（datefmt）T

Causes `printf` to output the date-time string resulting from using datefmt as a format string for `strftime`(3). The corresponding argument is an integer representing the number of seconds since the epoch. Two special argument values may be used: -1 represents the current time, and -2 represents the time the shell was invoked. If no argument is specified, conversion behaves as if -1 had been given. This is an exception to the usual `printf` behavior. 使 `printf`datefmt 作为 `strftime`相应的argument这是通常的 `printf` 输出由 using （3） 的格式字符串。 是一个整数，表示 自纪元以来的秒数。 可以使用两个特殊的参数值：-1 表示当前 time，-2 表示调用 shell 的时间。 如果未指定参数，则转换的行为就像给定了 -1 一样。 行为的例外。

The %b, %q, and %T directives all use the field width and precision arguments from the format specification and write that many bytes from (or use that wide a field for) the expanded argument, which usually contains more characters than the original. %b、%q 和 %T 指令都使用字段宽度和精度 参数，并从中写入许多字节 （或使用宽字段）扩展参数，通常 包含比原始字符更多的字符。

Arguments to non-string format specifiers are treated as C language constants, except that a leading plus or minus sign is allowed, and if the leading character is a single or double quote, the value is the ASCII value of the following character. 非字符串格式说明符的参数被视为 C 语言常量， 除了允许使用前导加号或减号，并且如果前导 character 是单引号或双引号，该值是 以下字符。

The format is reused as necessary to consume all of the arguments. If the format requires more arguments than are supplied, the extra format specifications behave as if a zero value or null string, as appropriate, had been supplied. The return value is zero on success, non-zero on failure. 根据需要重用该format以使用所有arguments如果format需要的参数多于提供的arguments。 ，则 额外的格式规范的行为类似于零值或空字符串，如 适当的，已经提供。 成功时返回值为零， 失败时为非零。

`read`

```
read [-ers] [-a aname] [-d delim] [-i text] [-n nchars]
    [-N nchars] [-p prompt] [-t timeout] [-u fd] [name …]
```

One line is read from the standard input, or from the file descriptor fd supplied as an argument to the \-u option, split into words as described above in [Word Splitting](https://www.gnu.org/software/bash/manual/bash.html#Word-Splitting), and the first word is assigned to the first name, the second word to the second name, and so on. If there are more words than names, the remaining words and their intervening delimiters are assigned to the last name. If there are fewer words read from the input stream than names, the remaining names are assigned empty values. The characters in the value of the `IFS` variable are used to split the line into words using the same rules the shell uses for expansion (described above in [Word Splitting](https://www.gnu.org/software/bash/manual/bash.html#Word-Splitting)). The backslash character ‘\\’ may be used to remove any special meaning for the next character read and for line continuation. fd 作为 \-u拆分为单词，如上文 [Word Splitting](https://www.gnu.org/software/bash/manual/bash.html#Word-Splitting)分配给第一个name，第二个单词分配给第二个name到name`IFS`用于扩展（如上文[的单词拆分](https://www.gnu.org/software/bash/manual/bash.html#Word-Splitting)反斜杠字符“\\从标准输入或文件描述符中读取一行 选项的参数提供， 中所述， 和第一个词 ， 等等。 如果单词多于名称， 分配剩余的单词及其中间的分隔符 如果从输入流中读取的单词少于名称， 其余名称被分配为空值。 变量值中的字符 用于使用与shell相同的规则将行拆分为单词 中所述）。 ”可用于删除任何特殊字符 表示下一个字符读取和行延续。

Options, if supplied, have the following meanings: 选项（如果提供）具有以下含义：

`-a aname`\-a aname

The words are assigned to sequential indices of the array variable aname, starting at 0. All elements are removed from aname before the assignment. Other name arguments are ignored. aname在赋值之前，所有元素都会从aname其他name这些单词被分配给数组变量的顺序索引 ，从 0 开始。 中删除。 参数将被忽略。

`-d delim`\-d delim

The first character of delim is used to terminate the input line, rather than newline. If delim is the empty string, `read` will terminate a line when it reads a NUL character. delim如果 delim 是空字符串，`read` 的第一个字符用于终止输入行， 而不是换行符。 将终止一行 当它读取 NUL 字符时。

`-e`

Readline (see [Command Line Editing](https://www.gnu.org/software/bash/manual/bash.html#Command-Line-Editing)) is used to obtain the line. Readline uses the current (or default, if line editing was not previously active) editing settings, but uses Readline’s default filename completion. Readline（请参阅[命令行编辑](https://www.gnu.org/software/bash/manual/bash.html#Command-Line-Editing)）用于获取该行。 Readline 使用当前（或默认，如果以前没有进行行编辑 active） 编辑设置，但使用 Readline 的默认文件名补全。

`-i text`\-i text

If Readline is being used to read the line, text is placed into the editing buffer before editing begins. 如果使用 Readline 读取行，text放入 编辑开始前的编辑缓冲区。

`-n nchars`\-n nchars

`read` returns after reading nchars characters rather than waiting for a complete line of input, but honors a delimiter if fewer than nchars characters are read before the delimiter. `read` nchars在分隔符之前读取 nchars 字符后返回 等待完整的输入行，但如果更少，则遵循分隔符 字符。

`-N nchars`\-N nchars

`read` returns after reading exactly nchars characters rather than waiting for a complete line of input, unless EOF is encountered or `read` times out. Delimiter characters encountered in the input are not treated specially and do not cause `read` to return until nchars characters are read. The result is not split on the characters in `IFS`; the intent is that the variable is assigned exactly the characters read (with the exception of backslash; see the \-r option below). `read`在读取 nchars`read`未经特殊处理，直到读取 nchars结果不会在 `IFS`（反斜杠除外;请参阅下面的 \-r 字符后返回 而不是等待完整的输入行，除非遇到 EOF 或 超时。 输入中遇到的分隔符字符是 字符。 中的字符上拆分;目的是 变量被分配的字符完全是读取的 选项）。

`-p prompt`\-p prompt符

Display prompt, without a trailing newline, before attempting to read any input. The prompt is displayed only if input is coming from a terminal. 在尝试之前显示prompt符，不带尾随换行符 读取任何输入。 仅当输入来自终端时，才会显示提示。

`-r`

If this option is given, backslash does not act as an escape character. The backslash is considered to be part of the line. In particular, a backslash-newline pair may not then be used as a line continuation. 如果提供此选项，则反斜杠不会充当转义字符。 反斜杠被视为行的一部分。 特别是，反斜杠-换行符对可能不会用作一行 延续。

`-s`

Silent mode. If input is coming from a terminal, characters are not echoed. 静音模式。 如果输入来自终端，则字符为 没有回声。

`-t timeout`\-t timeout

Cause `read` to time out and return failure if a complete line of input (or a specified number of characters) is not read within timeout seconds. timeout may be a decimal number with a fractional portion following the decimal point. This option is only effective if `read` is reading input from a terminal, pipe, or other special file; it has no effect when reading from regular files. If `read` times out, `read` saves any partial input read into the specified variable name. If timeout is 0, `read` returns immediately, without trying to read any data. The exit status is 0 if input is available on the specified file descriptor, or the read will return EOF, non-zero otherwise. The exit status is greater than 128 if the timeout is exceeded. `read`在timeouttimeout仅当 `read`如果`read`超时，`read`指定的变量name如果timeout为 0，`read`行 输入（或指定数量的字符） 秒内未读取。 可以是十进制数，后面跟着小数部分 小数点。 是从 端子、管道或其他特殊文件;阅读时没有效果 从常规文件。 将保存读取到的任何部分输入 。 ，而不尝试 读取任何数据。 如果输入在指定的文件描述符上可用，则退出状态为 0， 或者读取将返回 EOF， 否则为非零。 如果超过超时，则退出状态大于 128。

`-u fd`\-u fd

Read input from file descriptor fd. 从文件描述符 fd 读取输入。

If no names are supplied, the line read, without the ending delimiter but otherwise unmodified, is assigned to the variable `REPLY`. The exit status is zero, unless end-of-file is encountered, `read` times out (in which case the status is greater than 128), a variable assignment error (such as assigning to a readonly variable) occurs, or an invalid file descriptor is supplied as the argument to \-u. 如果未提供name变量 `REPLY`退出状态为零，除非遇到文件结束，`read`或者提供无效的文件描述符作为 \-us，则该行为 没有结束分隔符，但未修改， 分配给 超时（在这种情况下，状态大于 128）， 发生变量赋值错误（例如赋值给只读变量）， 的参数。

`readarray`

```
readarray [-d delim] [-n count] [-O origin] [-s count]
    [-t] [-u fd] [-C callback] [-c quantum] [array]
```

Read lines from the standard input into the indexed array variable array, or from file descriptor fd if the \-u option is supplied. 从标准输入读取行到索引数组变量array或从文件描述符 fd如果提供了 \-u中， 选项。

A synonym for `mapfile`. `mapfile` 的同义词。

`source`

A synonym for `.` (see [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)). 的同义词`.` （请参阅 [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)）。

`type`

For each name, indicate how it would be interpreted if used as a command name. 对于每个name，请指出如果将其用作 命令名称。

If the \-t option is used, `type` prints a single word which is one of ‘alias’, ‘function’, ‘builtin’, ‘file’ or ‘keyword’, if name is an alias, shell function, shell builtin, disk file, or shell reserved word, respectively. If the name is not found, then nothing is printed, and `type` returns a failure status. 如果使用 \-t 选项，`type`它是“alias”、“function”、“builtin'file' 或 'keyword如果 name如果未找到name`type`打印单个单词 ”之一， '， 是别名、shell 函数、shell builtin、 磁盘文件或 shell 保留字。 ，则不打印任何内容，并且 返回失败状态。

If the \-p option is used, `type` either returns the name of the disk file that would be executed, or nothing if \-t would not return ‘file’. 如果使用 \-p 选项，`type`将要执行的磁盘文件，或者如果 \-t不会返回“file任一将返回名称 则什么都不执行 ”。

The \-P option forces a path search for each name, even if \-t would not return ‘file’. \-P 选项强制对每个name\-t 不会返回 'file进行路径搜索，即使 '。

If a command is hashed, \-p and \-P print the hashed value, which is not necessarily the file that appears first in `$PATH`. 如果命令是哈希的，\-p 和 \-P这不一定是`$PATH` 打印哈希值， 中首先出现的文件。

If the \-a option is used, `type` returns all of the places that contain an executable named file. This includes aliases and functions, if and only if the \-p option is not also used. 如果使用 \-a 选项，`type`包含可执行文件命名file这包括别名和函数，当且仅当 \-p 将返回所有位置 。 选项 不使用。

If the \-f option is used, `type` does not attempt to find shell functions, as with the `command` builtin. 如果使用 \-f 选项，`type`shell 功能，与内置`command`不会尝试查找 一样。

The return status is zero if all of the names are found, non-zero if any are not found. 如果找到所有names，则返回状态为零，非零 如果找不到。

`typeset`

```
typeset [-afFgrxilnrtux] [-p] [name[=value] …]
```

The `typeset` command is supplied for compatibility with the Korn shell. It is a synonym for the `declare` builtin command. 提供 `typeset`它是 `declare` 命令是为了与 Korn 兼容 壳。 builtin 命令的同义词。

`ulimit`

```
ulimit [-HS] -a
ulimit [-HS] [-bcdefiklmnpqrstuvxPRT] [limit]
```

`ulimit` provides control over the resources available to processes started by the shell, on systems that allow such control. If an option is given, it is interpreted as follows: `ulimit` 提供对进程可用资源的控制 由壳牌启动，在允许此类控制的系统上。 如果 选项给出，解释如下：

`-S`

Change and report the soft limit associated with a resource. 更改并报告与资源关联的软限制。

`-H`

Change and report the hard limit associated with a resource. 更改并报告与资源关联的硬限制。

`-a`

All current limits are reported; no limits are set. 报告所有电流限制;没有设置任何限制。

`-b`

The maximum socket buffer size. 最大套接字缓冲区大小。

`-c`

The maximum size of core files created. 创建的核心文件的最大大小。

`-d`

The maximum size of a process’s data segment. 进程数据段的最大大小。

`-e`

The maximum scheduling priority ("nice"). 最大调度优先级（“nice”）。

`-f`

The maximum size of files written by the shell and its children. shell 及其子级写入的文件的最大大小。

`-i`

The maximum number of pending signals. 挂起信号的最大数量。

`-k`

The maximum number of kqueues that may be allocated. 可以分配的最大 kqueue 数。

`-l`

The maximum size that may be locked into memory. 可以锁定到内存中的最大大小。

`-m`

The maximum resident set size (many systems do not honor this limit). 最大驻留集大小（许多系统不遵守此限制）。

`-n`

The maximum number of open file descriptors (most systems do not allow this value to be set). 打开文件描述符的最大数量（大多数系统不这样做 允许设置此值）。

`-p`

The pipe buffer size. 管道缓冲区大小。

`-q`

The maximum number of bytes in <small>POSIX</small> message queues. <small>POSIX</small> 消息队列中的最大字节数。

`-r`

The maximum real-time scheduling priority. 最大实时调度优先级。

`-s`

The maximum stack size. 最大堆栈大小。

`-t`

The maximum amount of cpu time in seconds. 最大 CPU 时间（以秒为单位）。

`-u`

The maximum number of processes available to a single user. 单个用户可用的最大进程数。

`-v`

The maximum amount of virtual memory available to the shell, and, on some systems, to its children. shell 可用的最大虚拟内存量，并且 一些系统，给它的子。

`-x`

The maximum number of file locks. 文件锁定的最大数量。

`-P`

The maximum number of pseudoterminals. 伪终端的最大数量。

`-R`

The maximum time a real-time process can run before blocking, in microseconds. 实时进程在阻塞之前可以运行的最长时间，以微秒为单位。

`-T`

The maximum number of threads. 最大线程数。

If limit is given, and the \-a option is not used, limit is the new value of the specified resource. The special limit values `hard`, `soft`, and `unlimited` stand for the current hard limit, the current soft limit, and no limit, respectively. A hard limit cannot be increased by a non-root user once it is set; a soft limit may be increased up to the value of the hard limit. Otherwise, the current value of the soft limit for the specified resource is printed, unless the \-H option is supplied. When more than one resource is specified, the limit name and unit, if appropriate, are printed before the value. When setting new limits, if neither \-H nor \-S is supplied, both the hard and soft limits are set. If no option is given, then \-f is assumed. Values are in 1024-byte increments, except for \-t, which is in seconds; \-R, which is in microseconds; \-p, which is in units of 512-byte blocks; \-P, \-T, \-b, \-k, \-n and \-u, which are unscaled values; and, when in <small>POSIX</small> Mode (see [Bash POSIX Mode](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)), \-c and \-f, which are in 512-byte increments. 如果给出limit，并且未使用 \-alimit特殊limit值`hard`、`soft``unlimited`打印，除非提供 \-H设置新限制时，如果既没有提供 \-H 也没有\-S如果没有给出选项，则假定为 \-f\-t\-R\-p\-P\-T\-b\-k\-n 和 \-u并且，当处于 <small>POSIX</small> 模式（请参阅 [Bash POSIX 模式](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)\-c 和 \-f 选项， 是指定资源的新值。 和 代表当前硬限制、当前软限制、 和没有限制。 硬限制一旦设置，非 root 用户就无法增加; 软限制可以增加到硬限制的值。 否则，指定资源的软限制的当前值 选项。 当多个 指定资源，限制名称和单位（如果适用）， 打印在值之前。 ， 设置了硬限制和软限制。 。 值以 1024 字节为单位 增量，但 ，以秒为单位; ，以微秒为单位; ，以 512 字节块为单位; ， ， ， ， ，它们是未缩放的值; ）时， ，以 512 字节为增量。

The return status is zero unless an invalid option or argument is supplied, or an error occurs while setting a new limit. 返回状态为零，除非提供了无效的选项或参数， 或者在设置新限制时发生错误。

`unalias`

Remove each name from the list of aliases. If \-a is supplied, all aliases are removed. Aliases are described in [Aliases](https://www.gnu.org/software/bash/manual/bash.html#Aliases). 从别名列表中删除每个name。 如果 \-a别名在[别名](https://www.gnu.org/software/bash/manual/bash.html#Aliases) 是 提供时，将删除所有别名。 中进行了描述。

___

### 4.3 Modifying Shell Behavior4.3 修改 Shell 行为

-   [The Set Builtin内置套装](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)
-   [The Shopt BuiltinThe Shopt 内置](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)

___

#### 4.3.1 The Set Builtin4.3.1 内置套装

This builtin is so complicated that it deserves its own section. `set` allows you to change the values of shell options and set the positional parameters, or to display the names and values of shell variables. 这个内置函数非常复杂，值得拥有自己的部分。 `set` 允许您更改 shell 选项的值并设置位置 参数，或显示 shell 变量的名称和值。

`set`

```
set [-abefhkmnptuvxBCEHPT] [-o option-name] [--] [-] [argument …]
set [+abefhkmnptuvxBCEHPT] [+o option-name] [--] [-] [argument …]
```

If no options or arguments are supplied, `set` displays the names and values of all shell variables and functions, sorted according to the current locale, in a format that may be reused as input for setting or resetting the currently-set variables. Read-only variables cannot be reset. In <small>POSIX</small> mode, only shell variables are listed. 如果未提供任何选项或参数，`set`在 <small>POSIX</small> 将显示名称 以及所有 shell 变量和函数的值，根据 当前语言环境，采用可重复用作输入的格式 用于设置或重置当前设置的变量。 无法重置只读变量。 模式下，仅列出 shell 变量。

When options are supplied, they set or unset shell attributes. Options, if specified, have the following meanings: 提供选项时，它们会设置或取消设置 shell 属性。 如果指定了选项，则具有以下含义：

`-a`

Each variable or function that is created or modified is given the export attribute and marked for export to the environment of subsequent commands. 创建或修改的每个变量或函数都具有 export 属性并标记为导出到环境 后续命令。

`-b`

Cause the status of terminated background jobs to be reported immediately, rather than before printing the next primary prompt. 导致报告已终止的后台作业的状态 立即，而不是在打印下一个主要提示之前。

`-e`

Exit immediately if a pipeline (see [Pipelines](https://www.gnu.org/software/bash/manual/bash.html#Pipelines)), which may consist of a single simple command (see [Simple Commands](https://www.gnu.org/software/bash/manual/bash.html#Simple-Commands)), a list (see [Lists of Commands](https://www.gnu.org/software/bash/manual/bash.html#Lists)), or a compound command (see [Compound Commands](https://www.gnu.org/software/bash/manual/bash.html#Compound-Commands)) returns a non-zero status. The shell does not exit if the command that fails is part of the command list immediately following a `while` or `until` keyword, part of the test in an `if` statement, part of any command executed in a `&&` or `||` list except the command following the final `&&` or `||`, any command in a pipeline but the last, or if the command’s return status is being inverted with `!`. If a compound command other than a subshell returns a non-zero status because a command failed while \-e was being ignored, the shell does not exit. A trap on `ERR`, if set, is executed before the shell exits. 管道（请参阅[管道](https://www.gnu.org/software/bash/manual/bash.html#Pipelines)（请参阅[简单命令](https://www.gnu.org/software/bash/manual/bash.html#Simple-Commands)一个列表（参见[命令列表](https://www.gnu.org/software/bash/manual/bash.html#Lists)或复合命令（请参阅[复合命令](https://www.gnu.org/software/bash/manual/bash.html#Compound-Commands)命令列表紧跟在`while`或`until``if`在 `&&` 或 `||`最后一个 `&&` 或 `||`或者，如果命令的返回状态被反转`!`当 \-e如果设置了 ERR，则在 shell 退出之前执行 `ERR`如果出现以下情况，请立即退出 ），它可能由单个简单命令组成 ）， ）， ） 返回非零状态。 如果失败的命令是 关键字之后， 语句中测试的一部分， 列表中执行的任何命令的一部分，但 后面的命令 管道中除最后一个命令外的任何命令， 。 如果子壳以外的复合命令 返回非零状态，因为命令失败 被忽略时，shell 不会退出。 。

This option applies to the shell environment and each subshell environment separately (see [Command Execution Environment](https://www.gnu.org/software/bash/manual/bash.html#Command-Execution-Environment)), and may cause subshells to exit before executing all the commands in the subshell. 单独（请参阅[命令执行环境](https://www.gnu.org/software/bash/manual/bash.html#Command-Execution-Environment)此选项适用于 shell 环境和每个子 shell 环境 ），并可能导致 subshell，在执行 subshell 中的所有命令之前退出。

If a compound command or shell function executes in a context where \-e is being ignored, none of the commands executed within the compound command or function body will be affected by the \-e setting, even if \-e is set and a command returns a failure status. If a compound command or shell function sets \-e while executing in a context where \-e is ignored, that setting will not have any effect until the compound command or the command containing the function call completes. \-e将受到 \-e 设置的影响，即使设置\-e如果复合命令或 shell 函数在执行时设置\-e忽略 \-e如果复合命令或 shell 函数在以下上下文中执行 被忽略， 在复合命令或函数体中执行的任何命令都没有 命令返回失败状态。 的上下文，则该设置将没有任何 直到复合命令或包含函数的命令为止 呼叫完成。

`-f`

Disable filename expansion (globbing). 禁用文件名扩展（通配）。

`-h`

Locate and remember (hash) commands as they are looked up for execution. This option is enabled by default. 查找并记住 （hash） 命令，因为这些命令被查找以供执行。 默认情况下，此选项处于启用状态。

`-k`

All arguments in the form of assignment statements are placed in the environment for a command, not just those that precede the command name. 所有参数都以赋值语句的形式放置 在命令的环境中，而不仅仅是命令之前的命令 命令名称。

`-m`

Job control is enabled (see [Job Control](https://www.gnu.org/software/bash/manual/bash.html#Job-Control)). All processes run in a separate process group. When a background job completes, the shell prints a line containing its exit status. 作业控制已启用（请参阅[作业控制](https://www.gnu.org/software/bash/manual/bash.html#Job-Control)）。 所有进程都在单独的进程组中运行。 后台作业完成后，shell 会打印一行 包含其退出状态。

`-n`

Read commands but do not execute them. This may be used to check a script for syntax errors. This option is ignored by interactive shells. 读取命令，但不执行它们。 这可用于检查脚本是否存在语法错误。 交互式 shell 将忽略此选项。

`-o option-name`\- option-name

Set the option corresponding to option-name: 设置 option-name 对应的选项：

`allexport`

Same as `-a`. 与 `-a` 相同。

`braceexpand`

Same as `-B`. 与 `-B` 相同。

`emacs`

Use an `emacs`\-style line editing interface (see [Command Line Editing](https://www.gnu.org/software/bash/manual/bash.html#Command-Line-Editing)). This also affects the editing interface used for `read -e`. 使用 `emacs` 样式的行编辑界面（请参阅[命令行编辑](https://www.gnu.org/software/bash/manual/bash.html#Command-Line-Editing)这也会影响用于`read -e`）。 的编辑界面。

`errexit`

Same as `-e`. 与 `-e` 相同。

`errtrace`

Same as `-E`. 与 `-E` 相同。

`functrace`

Same as `-T`. 与 `-T` 相同。

`hashall`

Same as `-h`. 与 `-h` 相同。

`histexpand`

Same as `-H`. 与 `-H` 相同。

`history`

Enable command history, as described in [Bash History Facilities](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Facilities). This option is on by default in interactive shells. 启用命令历史记录，如 [Bash 历史记录工具](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Facilities)中所述。 默认情况下，此选项在交互式 shell 中处于打开状态。

`ignoreeof`

An interactive shell will not exit upon reading EOF. 交互式 shell 在读取 EOF 时不会退出。

`keyword`

Same as `-k`. 与 `-k` 相同。

`monitor`

Same as `-m`. 与 `-m` 相同。

`noclobber`

Same as `-C`. 与 `-C` 相同。

`noexec`

Same as `-n`. 如果 `-n`.

`noglob`

Same as `-f`. 与 `-f` 相同。

`nolog`

Currently ignored. 目前已忽略。

`notify`

Same as `-b`. 与 `-b` 相同。

`nounset`

Same as `-u`. 与 `-u` 相同。

`onecmd`

Same as `-t`. 与 `-t` 相同。

`physical`

Same as `-P`. 与 `-P` 相同。

`pipefail`

If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands in the pipeline exit successfully. This option is disabled by default. 如果设置，则管道的返回值是最后一个的值 （最右边）命令以非零状态退出，如果全部退出，则为零 管道中的命令成功退出。 默认情况下，此选项处于禁用状态。

`posix`

Change the behavior of Bash where the default operation differs from the <small>POSIX</small> standard to match the standard (see [Bash POSIX Mode](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)). This is intended to make Bash behave as a strict superset of that standard. 从<small>POSIX</small>（请参阅 [Bash POSIX 模式](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)更改默认操作不同的 Bash 行为 标准到匹配标准 ）。 这是为了使 Bash 表现为严格的超集 标准。

`privileged`

Same as `-p`. 与 `-p` 相同。

`verbose`

Same as `-v`. 与 `-v` 相同。

`vi`

Use a `vi`\-style line editing interface. This also affects the editing interface used for `read -e`. 使用 `vi`这也会影响用于`read -e` 样式的行编辑界面。 的编辑界面。

`xtrace`

Same as `-x`. 与 `-x` 相同。

`-p`

Turn on privileged mode. In this mode, the `$BASH_ENV` and `$ENV` files are not processed, shell functions are not inherited from the environment, and the `SHELLOPTS`, `BASHOPTS`, `CDPATH` and `GLOBIGNORE` variables, if they appear in the environment, are ignored. If the shell is started with the effective user (group) id not equal to the real user (group) id, and the \-p option is not supplied, these actions are taken and the effective user id is set to the real user id. If the \-p option is supplied at startup, the effective user id is not reset. Turning this option off causes the effective user and group ids to be set to the real user and group ids. 在此模式下，`$BASH_ENV` 和 `$ENV`以及 `SHELLOPTS`、`BASHOPTS``CDPATH` 和 `GLOBIGNORE`真实用户（组）ID，并且未提供 \-p如果在启动时提供 \-p打开特权模式。 文件不是 处理后，shell 函数不会从环境中继承， 如果变量出现在环境中，则忽略它们。 如果 shell 启动时有效用户（组）ID 不等于 选项，这些操作 ，并将有效用户 ID 设置为真实用户 ID。 选项，则有效用户 ID 为 不重置。 关闭此选项会导致有效用户 以及要设置为真实用户和组 ID 的组 ID。

`-r`

Enable restricted shell mode. This option cannot be unset once it has been set. 启用受限 shell 模式。 此选项一旦设置，就无法撤消。

`-t`

Exit after reading and executing one command. 读取并执行一个命令后退出。

`-u`

Treat unset variables and parameters other than the special parameters ‘@’ or ‘\*’, or array variables subscripted with ‘@’ or ‘\*’, as an error when performing parameter expansion. An error message will be written to the standard error, and a non-interactive shell will exit. '@' 或 \*或以 @' 或 \*处理未设置的变量和特殊参数以外的参数 '， ' 下标的数组变量， 作为执行参数扩展时的错误。 错误消息将写入标准错误，以及非交互式 shell 将退出。

`-v`

Print shell input lines as they are read. 在读取时打印 shell 输入行。

`-x`

Print a trace of simple commands, `for` commands, `case` commands, `select` commands, and arithmetic `for` commands and their arguments or associated word lists after they are expanded and before they are executed. The value of the `PS4` variable is expanded and the resultant value is printed before the command and its expanded arguments. 打印简单命令的跟踪，`for`命令，`case`命令、`select`命令和命令`for`展开，然后执行。 `PS4` 算术 以及它们的论点或相关的单词列表 的价值 变量展开，结果值在之前打印 命令及其扩展参数。

`-B`

The shell will perform brace expansion (see [Brace Expansion](https://www.gnu.org/software/bash/manual/bash.html#Brace-Expansion)). This option is on by default. shell 将执行大括号扩展（请参阅[大括号扩展](https://www.gnu.org/software/bash/manual/bash.html#Brace-Expansion)）。 默认情况下，此选项处于打开状态。

`-C`

Prevent output redirection using ‘\>’, ‘\>&’, and ‘<>’ from overwriting existing files. 防止使用“\>”、“\>&”和“<>”进行输出重定向 覆盖现有文件。

`-E`

If set, any trap on `ERR` is inherited by shell functions, command substitutions, and commands executed in a subshell environment. The `ERR` trap is normally not inherited in such cases. 如果设置，`ERR`在这种情况下，`ERR` 上的任何陷阱都由 shell 函数、命令继承 替换，以及在 subshell 环境中执行的命令。 陷阱通常不会遗传。

`-H`

Enable ‘!’ style history substitution (see [History Expansion](https://www.gnu.org/software/bash/manual/bash.html#History-Interaction)). This option is on by default for interactive shells. 启用 '!' 样式的历史记录替换（请参阅[历史记录扩展](https://www.gnu.org/software/bash/manual/bash.html#History-Interaction)）。 默认情况下，此选项对于交互式 shell 处于打开状态。

`-P`

If set, do not resolve symbolic links when performing commands such as `cd` which change the current directory. The physical directory is used instead. By default, Bash follows the logical chain of directories when performing commands which change the current directory. `cd`如果设置，则在执行命令时不要解析符号链接，例如 更改当前目录。 物理目录 改用。 默认情况下，Bash 遵循 执行命令时目录的逻辑链 更改当前目录。

For example, if /usr/sys is a symbolic link to /usr/local/sys then: 例如，如果 /usr/sys 是指向 /usr/local/sys 的符号链接 然后：

```
$ cd /usr/sys; echo $PWD
/usr/sys
$ cd ..; pwd
/usr
```

If `set -P` is on, then: 如果 `set -P` 处于打开状态，则：

```
$ cd /usr/sys; echo $PWD
/usr/local/sys
$ cd ..; pwd
/usr/local
```

`-T`

If set, any trap on `DEBUG` and `RETURN` are inherited by shell functions, command substitutions, and commands executed in a subshell environment. The `DEBUG` and `RETURN` traps are normally not inherited in such cases. 如果设置，`DEBUG` 和 `RETURN``DEBUG` 和 `RETURN` 上的任何陷阱都继承如下 shell 函数、命令替换和执行的命令 在 subshell 环境中。 陷阱通常不会被继承 在这种情况下。

`--`

If no arguments follow this option, then the positional parameters are unset. Otherwise, the positional parameters are set to the arguments, even if some of them begin with a ‘\-’.

`-`

Signal the end of options, cause all remaining arguments to be assigned to the positional parameters. The \-x and \-v options are turned off. If there are no arguments, the positional parameters remain unchanged. 发出选项结束的信号，导致所有剩余arguments分配给位置参数。 \-x\-v 选项处于关闭状态。 如果没有参数，则位置参数保持不变。

Using ‘+’ rather than ‘\-’ causes these options to be turned off. The options can also be used upon invocation of the shell. The current set of options may be found in `$-`. 使用“+”而不是“\-壳。 当前的选项集可以在 `$-`”会导致这些选项成为 关闭。 这些选项也可以在调用 中找到。

The remaining N arguments are positional parameters and are assigned, in order, to `$1`, `$2`, … `$N`. The special parameter `#` is set to N. 其余 N arguments按顺序分配给 `$1`、`$2`...... `$N`特殊参数 `#`是位置参数，分别为 。 设置为 N。

The return status is always zero unless an invalid option is supplied. 除非提供了无效选项，否则返回状态始终为零。

___

#### 4.3.2 The Shopt Builtin4.3.2 Shopt 内置

This builtin allows you to change additional shell optional behavior. 此内置函数允许您更改其他 shell 可选行为。

`shopt`

```
shopt [-pqsu] [-o] [optname …]
```

Toggle the values of settings controlling optional shell behavior. The settings can be either those listed below, or, if the \-o option is used, those available with the \-o option to the `set` builtin command (see [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)). With no options, or with the \-p option, a list of all settable options is displayed, with an indication of whether or not each is set; if optnames are supplied, the output is restricted to those options. The \-p option causes output to be displayed in a form that may be reused as input. Other options have the following meanings: 使用 \-o 选项，使用 \-o`set` builtin 命令的选项（请参阅 [Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)没有选项，或者有 \-p如果提供了 optname\-p切换控制可选 shell 行为的设置值。 这些设置可以是下面列出的设置，或者，如果 选项 ）。 选项，所有可设置的列表 显示选项，并指示是否设置了每个选项; s，则输出仅限于这些选项。 选项使输出以 可以作为输入重复使用。 其他选项具有以下含义：

`-s`

Enable (set) each optname. 启用（设置）每个 optname。

`-u`

Disable (unset) each optname. 禁用（取消设置）每个 optname。

`-q`

Suppresses normal output; the return status indicates whether the optname is set or unset. If multiple optname arguments are given with \-q, the return status is zero if all optnames are enabled; non-zero otherwise. 指示 optname如果使用 \-q 给出多个 optname如果启用了所有 optname抑制正常输出;退货状态 是设置还是未设置。 参数， s，则返回状态为零; 否则为非零。

`-o`

Restricts the values of optname to be those defined for the \-o option to the `set` builtin (see [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)). optname 是为 \-o`set` builtin（参见 [Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)限制 选项定义的那些 ）。

If either \-s or \-u is used with no optname arguments, `shopt` shows only those options which are set or unset, respectively. 如果 \-s 或 \-u不带 optname 参数使用，`shopt` 仅显示 分别设置或未设置的选项。

Unless otherwise noted, the `shopt` options are disabled (off) by default. 除非另有说明，`shopt` 选项处于禁用状态（关闭） 默认情况下。

The return status when listing options is zero if all optnames are enabled, non-zero otherwise. When setting or unsetting options, the return status is zero unless an optname is not a valid shell option. 列出选项时的返回状态为零，如果所有 optname返回状态为零，除非 optnames 启用，否则为非零。 设置或取消设置选项时， 不是有效的 shell 选择。

The list of `shopt` options is: `shopt` 选项列表如下：

`assoc_expand_once`

If set, the shell suppresses multiple evaluation of associative array subscripts during arithmetic expression evaluation, while executing builtins that can perform variable assignments, and while executing builtins that perform array dereferencing. 如果设置，shell 将抑制关联数组的多重计算 算术表达式计算期间的下标，同时执行 可以执行变量赋值的内置函数， 并在执行执行数组取消引用的内置函数时。

`autocd`

If set, a command name that is the name of a directory is executed as if it were the argument to the `cd` command. This option is only used by interactive shells. 这是 `cd`如果设置了，则执行作为目录名称的命令名称，就像 命令的参数。 此选项仅由交互式 shell 使用。

`cdable_vars`

If this is set, an argument to the `cd` builtin command that is not a directory is assumed to be the name of a variable whose value is the directory to change to. 如果设置了此参数，`cd` builtin 命令的参数 不是 directory 假定为其变量的名称 value 是要更改到的目录。

`cdspell`

If set, minor errors in the spelling of a directory component in a `cd` command will be corrected. The errors checked for are transposed characters, a missing character, and a character too many. If a correction is found, the corrected path is printed, and the command proceeds. This option is only used by interactive shells. `cd`如果设置，则目录组件的拼写中的小错误 命令将被更正。 检查的错误是转置字符， 一个缺失的角色，一个角色太多。 如果找到更正，则打印更正后的路径， 命令继续。 此选项仅由交互式 shell 使用。

`checkhash`

If this is set, Bash checks that a command found in the hash table exists before trying to execute it. If a hashed command no longer exists, a normal path search is performed. 如果设置了此值，Bash 会检查是否在哈希中找到命令 表在尝试执行它之前就存在。 如果哈希命令没有 存在的时间越长，则执行正常路径搜索。

`checkjobs`

If set, Bash lists the status of any stopped and running jobs before exiting an interactive shell. If any jobs are running, this causes the exit to be deferred until a second exit is attempted without an intervening command (see [Job Control](https://www.gnu.org/software/bash/manual/bash.html#Job-Control)). The shell always postpones exiting if any jobs are stopped. 干预命令（请参阅[作业控制](https://www.gnu.org/software/bash/manual/bash.html#Job-Control)如果设置，Bash 会列出之前任何已停止和正在运行的作业的状态 退出交互式 shell。 如果任何作业正在运行，这会导致 要推迟到尝试第二个退出而没有 ）。 如果任何作业停止，shell 始终会推迟退出。

`checkwinsize`

If set, Bash checks the window size after each external (non-builtin) command and, if necessary, updates the values of `LINES` and `COLUMNS`. This option is enabled by default. `LINES`和`COLUMNS`如果设置，Bash 会在每个外部（非内置）之后检查窗口大小 命令，并在必要时更新 。 默认情况下，此选项处于启用状态。

`cmdhist`

If set, Bash attempts to save all lines of a multiple-line command in the same history entry. This allows easy re-editing of multi-line commands. This option is enabled by default, but only has an effect if command history is enabled (see [Bash History Facilities](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Facilities)). 历史记录已启用（请参阅 [Bash 历史记录工具](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Facilities)如果设置，则 Bash 尝试保存多行的所有行 命令。 这允许 轻松重新编辑多行命令。 默认情况下，此选项处于启用状态，但仅在 if 命令中起作用 ）。

`compat31`

`compat32`

`compat40`

`compat41`

`compat42`

`compat43`

`compat44`

These control aspects of the shell’s compatibility mode (see [Shell Compatibility Mode](https://www.gnu.org/software/bash/manual/bash.html#Shell-Compatibility-Mode)). （请参阅 [Shell 兼容模式](https://www.gnu.org/software/bash/manual/bash.html#Shell-Compatibility-Mode)这些控制方面是 shell 的兼容模式 ）。

`complete_fullquote`

If set, Bash quotes all shell metacharacters in filenames and directory names when performing completion. If not set, Bash removes metacharacters such as the dollar sign from the set of characters that will be quoted in completed filenames when these metacharacters appear in shell variable references in words to be completed. This means that dollar signs in variable names that expand to directories will not be quoted; however, any dollar signs appearing in filenames will not be quoted, either. This is active only when bash is using backslashes to quote completed filenames. This variable is set by default, which is the default Bash behavior in versions through 4.2. 如果设置，则 Bash 在文件名和目录名称中引用所有 shell 元字符 执行完成。 如果未设置，则 Bash 从 将在完整的文件名中引用的字符 当这些元字符出现在 shell 变量中时，引用单词为 完成。 这意味着扩展到目录的变量名称中的美元符号 不会被引用; 但是，文件名中出现的任何美元符号也不会被引用。 仅当 bash 使用反斜杠引用 completed 时，此功能才有效 文件名。 默认情况下设置此变量，这是 4.2 及以下版本。

`direxpand`

If set, Bash replaces directory names with the results of word expansion when performing filename completion. This changes the contents of the Readline editing buffer. If not set, Bash attempts to preserve what the user typed. 如果设置，则 Bash 执行时将目录名称替换为单词扩展的结果 文件名完成。 这将更改 Readline 编辑的内容 缓冲区。 如果未设置，Bash 将尝试保留用户键入的内容。

`dirspell`

If set, Bash attempts spelling correction on directory names during word completion if the directory name initially supplied does not exist. 如果设置，则 Bash 在 Word 完成过程中尝试对目录名称进行拼写更正 如果最初提供的目录名称不存在。

`dotglob`

If set, Bash includes filenames beginning with a ‘.’ in the results of filename expansion. The filenames ‘.’ and ‘..’ must always be matched explicitly, even if `dotglob` is set. 文件名 '.' 和 '..即使设置`dotglob`如果设置，Bash 将包含以 '.' 开头的文件名 文件名扩展的结果。 ' 必须始终显式匹配， 。

`execfail`

If this is set, a non-interactive shell will not exit if it cannot execute the file specified as an argument to the `exec` builtin command. An interactive shell does not exit if `exec` fails. 它无法执行指定为 `exec`内置命令。 如果 `exec`如果设置了此项，则在以下情况下，非交互式 shell 将不会退出 参数的文件 失败。

`expand_aliases`

If set, aliases are expanded as described below under Aliases, [Aliases](https://www.gnu.org/software/bash/manual/bash.html#Aliases). This option is enabled by default for interactive shells. [别名](https://www.gnu.org/software/bash/manual/bash.html#Aliases)如果设置了别名，则别名将展开，如下文“别名”下所述。 。 默认情况下，交互式 shell 启用此选项。

`extdebug`

If set at shell invocation, or in a shell startup file, arrange to execute the debugger profile before the shell starts, identical to the \--debugger option. If set after invocation, behavior intended for use by debuggers is enabled: 在 shell 启动之前，与 \--debugger如果在 shell 调用时设置， 或在 shell 启动文件中， 安排执行调试器配置文件 选项相同。 如果在调用后设置，则启用旨在由调试器使用的行为：

1.  The \-F option to the `declare` builtin (see [Bash Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)) displays the source file name and line number corresponding to each function name supplied as an argument. `declare`内置的 \-F 选项（请参阅 [Bash 内置命令](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)） 显示每个函数对应的源文件名和行号 name 作为参数提供。
2.  If the command run by the `DEBUG` trap returns a non-zero value, the next command is skipped and not executed. 如果 `DEBUG` 陷阱运行的命令返回非零值，则 下一个命令将跳过且不执行。
3.  If the command run by the `DEBUG` trap returns a value of 2, and the shell is executing in a subroutine (a shell function or a shell script executed by the `.` or `source` builtins), the shell simulates a call to `return`. 如果 `DEBUG`由 `.` 或 `source``return` trap 运行的命令返回值 2，并且 shell 在子例程（shell 函数或 shell 脚本）中执行 builtins执行），shell 模拟 的电话。
4.  `BASH_ARGC` and `BASH_ARGV` are updated as described in their descriptions (see [Bash Variables](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables)). `BASH_ARGC` 和 `BASH_ARGV`说明（请参阅 [Bash 变量](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables) 按照其 ）。
5.  Function tracing is enabled: command substitution, shell functions, and subshells invoked with `( command )` inherit the `DEBUG` and `RETURN` traps. 使用 （ command`DEBUG` 和 `RETURN`启用函数跟踪：命令替换、shell 函数和 ） 调用的 subshell 继承了 陷阱。
6.  Error tracing is enabled: command substitution, shell functions, and subshells invoked with `( command )` inherit the `ERR` trap. 使用 （ command`ERR`启用错误跟踪：命令替换、shell 函数和 ） 调用的 subshell 继承了 陷阱。

`extglob`

If set, the extended pattern matching features described above (see [Pattern Matching](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)) are enabled. （请参阅[模式匹配](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)如果设置，则扩展图案匹配上述功能 ）已启用。

`extquote`

If set, `$'string'` and `$"string"` quoting is performed within `${parameter}` expansions enclosed in double quotes. This option is enabled by default. 如果设置，则 $'string' 和 $“string在 ${parameter” 引号为 } 扩展中执行 用双引号括起来。 默认情况下，此选项处于启用状态。

`failglob`

If set, patterns which fail to match filenames during filename expansion result in an expansion error. 如果设置，则在文件名扩展期间无法匹配文件名的模式 导致扩展错误。

`force_fignore`

If set, the suffixes specified by the `FIGNORE` shell variable cause words to be ignored when performing word completion even if the ignored words are the only possible completions. See [Bash Variables](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables), for a description of `FIGNORE`. This option is enabled by default. 如果设置，则 `FIGNORE`有关 `FIGNORE` 的说明，请参阅 [Bash 变量](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables) shell 变量指定的后缀 导致在执行单词完成时忽略单词，即使 被忽略的单词是唯一可能的完成。 。 默认情况下，此选项处于启用状态。

`globasciiranges`

If set, range expressions used in pattern matching bracket expressions (see [Pattern Matching](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)) behave as if in the traditional C locale when performing comparisons. That is, the current locale’s collating sequence is not taken into account, so ‘b’ will not collate between ‘A’ and ‘B’, and upper-case and lower-case ASCII characters will collate together. （请参阅[模式匹配](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)'b' 不会在 'A' 和 'B如果设置，则模式匹配括号表达式中使用的范围表达式 ） 执行时的行为就像在传统的 C 语言环境中一样 比较。 也就是说，当前区域设置的排序规则序列 没有考虑在内，所以 ' 之间进行整理， 大写和小写 ASCII 字符将一起整理。

`globskipdots`

If set, filename expansion will never match the filenames ‘.’ and ‘..’, even if the pattern begins with a ‘.’. This option is enabled by default.

`globstar`

If set, the pattern ‘\*\*’ used in a filename expansion context will match all files and zero or more directories and subdirectories. If the pattern is followed by a ‘/’, only directories and subdirectories match. 如果设置，则文件名扩展上下文中使用的模式“\*\*如果模式后面跟着 '/”将 匹配所有文件以及零个或多个目录和子目录。 '，则只有目录和 子目录匹配。

`gnu_errfmt`

If set, shell error messages are written in the standard <small>GNU</small> error message format. 如果设置，则 shell 错误消息将写入标准 <small>GNU</small> 错误中 消息格式。

`histappend`

If set, the history list is appended to the file named by the value of the `HISTFILE` variable when the shell exits, rather than overwriting the file. `HISTFILE`如果设置，则历史记录列表将追加到由值命名的文件中 变量，而不是覆盖文件。

`histreedit`

If set, and Readline is being used, a user is given the opportunity to re-edit a failed history substitution. 如果设置，和 Readline 正在使用时，用户有机会重新编辑 失败的历史替换。

`histverify`

If set, and Readline is being used, the results of history substitution are not immediately passed to the shell parser. Instead, the resulting line is loaded into the Readline editing buffer, allowing further modification. 如果设置，和 Readline 正在使用中，历史替换的结果不会立即出现 传递给 shell 解析器。 相反，生成的行被加载到 Readline 编辑缓冲区，允许进一步修改。

`hostcomplete`

If set, and Readline is being used, Bash will attempt to perform hostname completion when a word containing a ‘@’ is being completed (see [Letting Readline Type For You](https://www.gnu.org/software/bash/manual/bash.html#Commands-For-Completion)). This option is enabled by default. 主机名补全时包含“@已完成（请参阅[为您输入 Readline](https://www.gnu.org/software/bash/manual/bash.html#Commands-For-Completion)如果设置了 Readline 并且正在使用 Readline，Bash 将尝试执行 ”的单词 ）。 此选项已启用 默认情况下。

`huponexit`

If set, Bash will send `SIGHUP` to all jobs when an interactive login shell exits (see [Signals](https://www.gnu.org/software/bash/manual/bash.html#Signals)). 如果设置，Bash 将在交互式时向所有作业发送 `SIGHUP`登录 shell 退出（请参阅[信号](https://www.gnu.org/software/bash/manual/bash.html#Signals) ）。

`inherit_errexit`

If set, command substitution inherits the value of the `errexit` option, instead of unsetting it in the subshell environment. This option is enabled when <small>POSIX</small> mode is enabled. 如果设置，则命令替换将继承 `errexit`启用 <small>POSIX</small> 选项的值， 而不是在 subshell 环境中取消设置它。 模式时，将启用此选项。

`interactive_comments`

Allow a word beginning with ‘#’ to cause that word and all remaining characters on that line to be ignored in an interactive shell. This option is enabled by default. 允许以“#”开头的单词 导致该单词和该单词上的所有剩余字符 在交互式 shell 中要忽略的行。 默认情况下，此选项处于启用状态。

`lastpipe`

If set, and job control is not active, the shell runs the last command of a pipeline not executed in the background in the current shell environment. 如果设置了，并且作业控制未处于活动状态，则 shell 将运行 当前 shell 环境下未在后台执行的流水线。

`lithist`

If enabled, and the `cmdhist` option is enabled, multi-line commands are saved to the history with embedded newlines rather than using semicolon separators where possible. 如果启用，`cmdhist` 选项启用后，多行命令将保存到历史记录中 嵌入换行符，而不是尽可能使用分号分隔符。

`localvar_inherit`

If set, local variables inherit the value and attributes of a variable of the same name that exists at a previous scope before any new value is assigned. The `nameref` attribute is not inherited. 分配。 `nameref`如果设置，局部变量将继承 在上一个作用域中存在的相同名称，在任何新值之前 属性不会被继承。

`localvar_unset`

If set, calling `unset` on local variables in previous function scopes marks them so subsequent lookups find them unset until that function returns. This is identical to the behavior of unsetting local variables at the current function scope. 如果设置，则对先前函数作用域中的局部变量调用 `unset` 标记它们，以便后续查找发现它们在该函数之前未设置 返回。这与取消设置局部变量的行为相同 在当前函数范围内。

`login_shell`

The shell sets this option if it is started as a login shell (see [Invoking Bash](https://www.gnu.org/software/bash/manual/bash.html#Invoking-Bash)). The value may not be changed. （请参阅[调用 Bash](https://www.gnu.org/software/bash/manual/bash.html#Invoking-Bash)如果作为登录 shell 启动，则 shell 将设置此选项 ）。 该值不得更改。

`mailwarn`

If set, and a file that Bash is checking for mail has been accessed since the last time it was checked, the message `"The mail in mailfile has been read"` is displayed. 显示“mailfile如果设置，并且 Bash 正在检查邮件的文件已 自上次检查以来访问的消息 的邮件已被读取”。

`no_empty_cmd_completion`

If set, and Readline is being used, Bash will not attempt to search the `PATH` for possible completions when completion is attempted on an empty line. 尝试完成时可能完成的 `PATH`如果设置了 Readline，并且正在使用 Readline，则 Bash 不会尝试搜索 在一行空行上。

`nocaseglob`

If set, Bash matches filenames in a case-insensitive fashion when performing filename expansion. 如果设置，则 Bash 在以下情况下以不区分大小写的方式匹配文件名 执行文件名扩展。

`nocasematch`

If set, Bash matches patterns in a case-insensitive fashion when performing matching while executing `case` or `[[` conditional commands (see [Conditional Constructs](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs), when performing pattern substitution word expansions, or when filtering possible completions as part of programmable completion. 在执行 `case` 或 `[[`条件命令（参见[条件构造](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)如果设置，则 Bash 在以下情况下以不区分大小写的方式匹配模式 ， 执行模式替换词扩展时， 或者在可编程完成过程中过滤可能的完成时。

`noexpand_translation`

If set, Bash encloses the translated results of $"..." quoting in single quotes instead of double quotes. If the string is not translated, this has no effect.

`nullglob`

If set, Bash allows filename patterns which match no files to expand to a null string, rather than themselves. 如果设置，Bash 允许与否匹配的文件名模式 文件展开为 null 字符串，而不是其本身。

`patsub_replacement`

If set, Bash expands occurrences of ‘&’ in the replacement string of pattern substitution to the text matched by the pattern, as described above (see [Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)). This option is enabled by default. 展开 pattern 替换字符串中出现的 '&以上（请参阅 [Shell 参数扩展](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)如果设置，则 Bash ' 替换与模式匹配的文本，如上所述 ）。 默认情况下，此选项处于启用状态。

`progcomp`

If set, the programmable completion facilities (see [Programmable Completion](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion)) are enabled. This option is enabled by default. （请参阅[可编程完成](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion)如果设置，可编程完成设施 ）已启用。 默认情况下，此选项处于启用状态。

`progcomp_alias`

If set, and programmable completion is enabled, Bash treats a command name that doesn’t have any completions as a possible alias and attempts alias expansion. If it has an alias, Bash attempts programmable completion using the command word resulting from the expanded alias. 如果设置并启用了可编程完成，则 Bash 将处理命令 没有任何补全作为可能的别名和尝试的名称 别名扩展。如果它有别名，则 Bash 会尝试可编程 使用扩展别名生成的命令字完成。

`promptvars`

If set, prompt strings undergo parameter expansion, command substitution, arithmetic expansion, and quote removal after being expanded as described below (see [Controlling the Prompt](https://www.gnu.org/software/bash/manual/bash.html#Controlling-the-Prompt)). This option is enabled by default. 如下所述（请参阅[控制提示](https://www.gnu.org/software/bash/manual/bash.html#Controlling-the-Prompt)如果设置，提示字符串将经历 参数扩展、命令替换、算术 扩展，以及扩展后的引号删除 符）。 默认情况下，此选项处于启用状态。

`restricted_shell`

The shell sets this option if it is started in restricted mode (see [The Restricted Shell](https://www.gnu.org/software/bash/manual/bash.html#The-Restricted-Shell)). The value may not be changed. This is not reset when the startup files are executed, allowing the startup files to discover whether or not a shell is restricted. （参见 [The Restricted Shell](https://www.gnu.org/software/bash/manual/bash.html#The-Restricted-Shell)如果 shell 在受限模式下启动，则 shell 将设置此选项 ）。 该值不得更改。 执行启动文件时不会重置，允许 用于发现 shell 是否受到限制的启动文件。

`shift_verbose`

If this is set, the `shift` builtin prints an error message when the shift count exceeds the number of positional parameters. 如果设置了此值，`shift` 内置在移位计数超过 位置参数的数量。

`sourcepath`

If set, the `.` (`source`) builtin uses the value of `PATH` to find the directory containing the file supplied as an argument. This option is enabled by default. 如果设置，则 `.` （`source`） 内置使用 `PATH` 的值 查找包含作为参数提供的文件的目录。 默认情况下，此选项处于启用状态。

`varredir_close`

If set, the shell automatically closes file descriptors assigned using the `{varname}` redirection syntax (see [Redirections](https://www.gnu.org/software/bash/manual/bash.html#Redirections)) instead of leaving them open when the command completes. `{varname}` 重定向语法（请参阅[重定向](https://www.gnu.org/software/bash/manual/bash.html#Redirections)如果设置，shell 会自动关闭使用 ）而不是 命令完成时，使它们保持打开状态。

`xpg_echo`

If set, the `echo` builtin expands backslash-escape sequences by default. 如果设置，则内置`echo` 会扩展反斜杠转义序列 默认情况下。

___

### 4.4 Special Builtins4.4 特殊内置

For historical reasons, the <small>POSIX</small> standard has classified several builtin commands as _special_. When Bash is executing in <small>POSIX</small> mode, the special builtins differ from other builtin commands in three respects: 由于历史原因，<small>POSIX</small>几个_内置命令作为特殊_当 Bash 在 <small>POSIX</small> 标准已将 命令。 模式下执行时，特殊的内置函数 与其他内置命令在三个方面有所不同：

1.  Special builtins are found before shell functions during command lookup. 在命令查找期间，在 shell 函数之前可以找到特殊的内置函数。
2.  If a special builtin returns an error status, a non-interactive shell exits. 如果一个特殊的内置函数返回错误状态，则非交互式 shell 将退出。
3.  Assignment statements preceding the command stay in effect in the shell environment after the command completes. 命令前面的赋值语句在 shell 中保持有效 命令完成后的环境。

When Bash is not executing in <small>POSIX</small> mode, these builtins behave no differently than the rest of the Bash builtin commands. The Bash <small>POSIX</small> mode is described in [Bash POSIX Mode](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode). 当 Bash 不在 <small>POSIX</small>Bash <small>POSIX</small> 模式在 [Bash POSIX 模式](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode) 模式下执行时，这些内置项的行为为 no 与其他 Bash 内置命令不同。 中进行了描述。

These are the <small>POSIX</small> special builtins: 这些是 <small>POSIX</small> 特殊内置函数：

```
break : . continue eval exec exit export readonly return set<!-- /@w -->
shift trap unset<!-- /@w -->
```