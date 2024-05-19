
## 5 Shell Variables5 Shell 变量

This chapter describes the shell variables that Bash uses. Bash automatically assigns default values to a number of variables. 
本章介绍 Bash 使用的 shell 变量。 Bash 会自动将默认值分配给多个变量。

-   [Bourne Shell VariablesBourne Shell 变量](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Variables)
-   [Bash VariablesBash 变量](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables)

___

### 5.1 Bourne Shell Variables5.1 Bourne Shell 变量

Bash uses certain shell variables in the same way as the Bourne shell. In some cases, Bash assigns a default value to the variable. Bash 使用某些 shell 变量的方式与 Bourne shell 相同。 在某些情况下，Bash 会为变量分配默认值。

`CDPATH`

A colon-separated list of directories used as a search path for the `cd` builtin command. `cd`用作搜索路径的目录的冒号分隔列表 builtin 命令。

`HOME`

The current user’s home directory; the default for the `cd` builtin command. The value of this variable is also used by tilde expansion (see [Tilde Expansion](https://www.gnu.org/software/bash/manual/bash.html#Tilde-Expansion)). 当前用户的主目录;`cd`（请参阅[波浪号扩展](https://www.gnu.org/software/bash/manual/bash.html#Tilde-Expansion) 的默认值 命令。 此变量的值也用于波浪号扩展 ）。

`IFS`

A list of characters that separate fields; used when the shell splits words as part of expansion. 分隔字段的字符列表;在shell分裂时使用 单词作为扩展的一部分。

`MAIL`

If this parameter is set to a filename or directory name and the `MAILPATH` variable is not set, Bash informs the user of the arrival of mail in the specified file or Maildir-format directory. 和 `MAILPATH`如果此参数设置为文件名或目录名 变量 未设置，Bash 通知用户邮件的到达 指定的文件或 Maildir-format 目录。

`MAILPATH`

A colon-separated list of filenames which the shell periodically checks for new mail. Each list entry can specify the message that is printed when new mail arrives in the mail file by separating the filename from the message with a ‘?’. When used in the text of the message, `$_` expands to the name of the current mail file. 一个“?在消息文本中使用时，`$_`以冒号分隔的文件名列表，shell 会定期检查 对于新邮件。 每个列表条目都可以指定新邮件时打印的邮件 通过将文件名与邮件分开而到达邮件文件 ”。 将扩展为 当前邮件文件。

`OPTARG`

The value of the last option argument processed by the `getopts` builtin. 由 `getopts` 内置处理的最后一个选项参数的值。

`OPTIND`

The index of the last option argument processed by the `getopts` builtin. 由 `getopts` 内置处理的最后一个选项参数的索引。

`PATH`

A colon-separated list of directories in which the shell looks for commands. A zero-length (null) directory name in the value of `PATH` indicates the current directory. A null directory name may appear as two adjacent colons, or as an initial or trailing colon. `PATH`以冒号分隔的目录列表，shell 在其中查找 命令。 值中的零长度 （null） 目录名称表示 当前目录。 空目录名称可能显示为两个相邻的冒号，也可能显示为首字母 或尾随冒号。

`PS1`

The primary prompt string. The default value is ‘\\s-\\v\\$ ’. See [Controlling the Prompt](https://www.gnu.org/software/bash/manual/bash.html#Controlling-the-Prompt), for the complete list of escape sequences that are expanded before `PS1` is displayed. 主提示字符串。 默认值为 '\\s-\\v\\$ 有关转义的完整列表，请参阅[控制提示](https://www.gnu.org/software/bash/manual/bash.html#Controlling-the-Prompt)在显示 `PS1`'。 符 之前展开的序列。

`PS2`

The secondary prompt string. The default value is ‘\> ’. `PS2` is expanded in the same way as `PS1` before being displayed. 辅助提示字符串。 默认值为“\> `PS2` 的扩展方式与 `PS1`”。 相同 显示。

___

### 5.2 Bash Variables5.2 Bash 变量

These variables are set or used by Bash, but other shells do not normally treat them specially. 这些变量由 Bash 设置或使用，但其他 shell 通常不要特别对待它们。

A few variables used by Bash are described in different chapters: variables for controlling the job control facilities (see [Job Control Variables](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Variables)). （请参阅[作业控制变量](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Variables)Bash 使用的一些变量在不同的章节中进行了介绍： 用于控制作业控制设施的变量 ）。

`_`

($\_, an underscore.) At shell startup, set to the pathname used to invoke the shell or shell script being executed as passed in the environment or argument list. Subsequently, expands to the last argument to the previous simple command executed in the foreground, after expansion. Also set to the full pathname used to invoke each command executed and placed in the environment exported to that command. When checking mail, this parameter holds the name of the mail file. （$\_，下划线。 在 shell 启动时，设置为用于调用 在环境中传递的 shell 或 shell 脚本 或参数列表。 随后，将最后一个参数扩展到前面的简单参数 扩展后在前台执行的命令。 还设置为用于调用执行的每个命令的完整路径名 并放置在导出到该命令的环境中。 检查邮件时，此参数保存邮件文件的名称。

`BASH`

The full pathname used to execute the current instance of Bash. 用于执行当前 Bash 实例的完整路径名。

`BASHOPTS`

A colon-separated list of enabled shell options. Each word in the list is a valid argument for the \-s option to the `shopt` builtin command (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)). The options appearing in `BASHOPTS` are those reported as ‘on’ by ‘shopt’. If this variable is in the environment when Bash starts up, each shell option in the list will be enabled before reading any startup files. This variable is readonly. 该列表是 \-s`shopt` builtin 命令（请参阅 [shopt builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)`BASHOPTS`与“shopt”的“on以冒号分隔的已启用 shell 选项列表。 每个单词 选项的有效参数 ）。 中出现的选项是报告的选项 ”相同。 如果此变量在环境中，则 Bash 启动后，列表中的每个 shell 选项都会在之前启用 读取任何启动文件。 此变量是只读的。

`BASHPID`

Expands to the process ID of the current Bash process. This differs from `$$` under certain circumstances, such as subshells that do not require Bash to be re-initialized. Assignments to `BASHPID` have no effect. If `BASHPID` is unset, it loses its special properties, even if it is subsequently reset. 在某些情况下，这与 `$$`对 `BASHPID`如果 `BASHPID`展开为当前 Bash 进程的进程 ID。 不同，例如子壳 不需要重新初始化 Bash。 的分配无效。 未设置，即使它失去了它的特殊属性，即使它是 随后重置。

`BASH_ALIASES`

An associative array variable whose members correspond to the internal list of aliases as maintained by the `alias` builtin. (see [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)). Elements added to this array appear in the alias list; however, unsetting array elements currently does not cause aliases to be removed from the alias list. If `BASH_ALIASES` is unset, it loses its special properties, even if it is subsequently reset. 由内置`alias`（请参阅 [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)如果`BASH_ALIASES`一个关联数组变量，其成员对应于内部 维护的别名列表。 ）。 添加到此数组的元素将显示在别名列表中;然而 取消设置数组元素当前不会导致删除别名 从别名列表中。 未设置，即使它失去了它的特殊属性，即使它是 随后重置。

`BASH_ARGC`

An array variable whose values are the number of parameters in each frame of the current bash execution call stack. The number of parameters to the current subroutine (shell function or script executed with `.` or `source`) is at the top of the stack. When a subroutine is executed, the number of parameters passed is pushed onto `BASH_ARGC`. The shell sets `BASH_ARGC` only when in extended debugging mode (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin) for a description of the `extdebug` option to the `shopt` builtin). Setting `extdebug` after the shell has started to execute a script, or referencing this variable when `extdebug` is not set, may result in inconsistent values. with `.` 或 `source``BASH_ARGC`shell 仅在扩展调试模式下设置`BASH_ARGC`（参见 [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)有关 `shopt` 的 `extdebug`在 shell 开始执行脚本后设置 `extdebug`或在未设置 `extdebug`一个数组变量，其值是每个变量中的参数数 当前 bash 执行调用堆栈的帧。 数量 参数添加到当前子例程（shell 函数或脚本执行 ） 位于堆栈的顶部。 当一个 执行子程序，传递的参数数被推送到 。 选项的说明 内置）。 ， 时引用此变量， 可能会导致值不一致。

`BASH_ARGV`

An array variable containing all of the parameters in the current bash execution call stack. The final parameter of the last subroutine call is at the top of the stack; the first parameter of the initial call is at the bottom. When a subroutine is executed, the parameters supplied are pushed onto `BASH_ARGV`. The shell sets `BASH_ARGV` only when in extended debugging mode (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin) for a description of the `extdebug` option to the `shopt` builtin). Setting `extdebug` after the shell has started to execute a script, or referencing this variable when `extdebug` is not set, may result in inconsistent values. 被推到`BASH_ARGV`shell 仅在扩展调试模式下设置`BASH_ARGV`（参见 [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)有关 `shopt` 的 `extdebug`在 shell 开始执行脚本后设置 `extdebug`或在未设置 `extdebug`一个数组变量，包含当前 bash 中的所有参数 执行调用堆栈。 最后一个子例程调用的最后一个参数 位于堆栈的顶部;初始调用的第一个参数是 在底部。 执行子例程时，提供的参数 上。 选项的说明 内置）。 ， 时引用此变量， 可能会导致值不一致。

`BASH_ARGV0`

When referenced, this variable expands to the name of the shell or shell script (identical to `$0`; See [Special Parameters](https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters), for the description of special parameter 0). Assignment to `BASH_ARGV0` causes the value assigned to also be assigned to `$0`. If `BASH_ARGV0` is unset, it loses its special properties, even if it is subsequently reset. 脚本（等同于 `$0`;参见[特殊参数](https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters)分配给`BASH_ARGV0`使赋值也赋值为 `$0`如果`BASH_ARGV0`引用时，此变量将扩展为 shell 或 shell 的名称 ， 用于特殊参数 0 的描述）。 。 未设置，即使它失去了它的特殊属性，即使它是 随后重置。

`BASH_CMDS`

An associative array variable whose members correspond to the internal hash table of commands as maintained by the `hash` builtin (see [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)). Elements added to this array appear in the hash table; however, unsetting array elements currently does not cause command names to be removed from the hash table. If `BASH_CMDS` is unset, it loses its special properties, even if it is subsequently reset. 由内置`hash`（请参阅 [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)如果`BASH_CMDS`一个关联数组变量，其成员对应于内部 维护的命令的哈希表 ）。 添加到此数组的元素将显示在哈希表中;然而 当前取消设置数组元素不会导致删除命令名称 从哈希表。 未设置，即使它失去了它的特殊属性，即使它是 随后重置。

`BASH_COMMAND`

The command currently being executed or about to be executed, unless the shell is executing a command as the result of a trap, in which case it is the command executing at the time of the trap. If `BASH_COMMAND` is unset, it loses its special properties, even if it is subsequently reset. 如果`BASH_COMMAND`当前正在执行或即将执行的命令，除非 shell 正在执行命令作为陷阱的结果， 在这种情况下，它是在陷阱时执行的命令。 未设置，即使它失去了它的特殊属性，即使它是 随后重置。

`BASH_COMPAT`

The value is used to set the shell’s compatibility level. See [Shell Compatibility Mode](https://www.gnu.org/software/bash/manual/bash.html#Shell-Compatibility-Mode), for a description of the various compatibility levels and their effects. The value may be a decimal number (e.g., 4.2) or an integer (e.g., 42) corresponding to the desired compatibility level. If `BASH_COMPAT` is unset or set to the empty string, the compatibility level is set to the default for the current version. If `BASH_COMPAT` is set to a value that is not one of the valid compatibility levels, the shell prints an error message and sets the compatibility level to the default for the current version. The valid values correspond to the compatibility levels described below (see [Shell Compatibility Mode](https://www.gnu.org/software/bash/manual/bash.html#Shell-Compatibility-Mode)). For example, 4.2 and 42 are valid values that correspond to the `compat42` `shopt` option and set the compatibility level to 42. The current version is also a valid value. 请参阅 [Shell 兼容模式](https://www.gnu.org/software/bash/manual/bash.html#Shell-Compatibility-Mode)如果`BASH_COMPAT`如果 `BASH_COMPAT`下面介绍（请参阅 [Shell 兼容模式](https://www.gnu.org/software/bash/manual/bash.html#Shell-Compatibility-Mode)前往 `compat42``shopt`该值用于设置 shell 的兼容性级别。 ，了解各种 兼容性级别及其影响。 该值可以是十进制数（例如，4.2）或整数（例如，42） 对应于所需的兼容级别。 未设置或设置为空字符串，则兼容性 级别设置为当前版本的默认值。 设置为一个值，该值不是有效的值之一 兼容级别，shell 会打印错误消息并设置 兼容级别为当前版本的默认级别。 有效值对应于兼容级别 ）。 例如，4.2 和 42 是对应的有效值 选项 并将兼容级别设置为 42。 当前版本也是一个有效值。

`BASH_ENV`

If this variable is set when Bash is invoked to execute a shell script, its value is expanded and used as the name of a startup file to read before executing the script. See [Bash Startup Files](https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files). 在执行脚本之前阅读。 请参阅 [Bash 启动文件](https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files)如果在调用 Bash 以执行 shell 时设置了此变量 脚本，其值被展开并用作启动文件的名称 。

`BASH_EXECUTION_STRING`

The command argument to the \-c invocation option. \-c 调用选项的命令参数。

`BASH_LINENO`

An array variable whose members are the line numbers in source files where each corresponding member of `FUNCNAME` was invoked. `${BASH_LINENO[$i]}` is the line number in the source file (`${BASH_SOURCE[$i+1]}`) where `${FUNCNAME[$i]}` was called (or `${BASH_LINENO[$i-1]}` if referenced within another shell function). Use `LINENO` to obtain the current line number. 其中调用`FUNCNAME``${BASH_LINENO[$i]}`（`${BASH_SOURCE[$i+1]}``${FUNCNAME[$i]}` 被调用（或 `${BASH_LINENO[$i-1]}`使用 `LINENO`一个数组变量，其成员是源文件中的行号 的每个相应成员。 是源文件中的行号 其中 如果 在另一个 shell 函数中引用）。 获取当前行号。

`BASH_LOADABLES_PATH`

A colon-separated list of directories in which the shell looks for dynamically loadable builtins specified by the `enable` command. `enable`以冒号分隔的目录列表，shell 在其中查找 可动态加载的内置项由 命令。

`BASH_REMATCH`

An array variable whose members are assigned by the ‘\=~’ binary operator to the `[[` conditional command (see [Conditional Constructs](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)). The element with index 0 is the portion of the string matching the entire regular expression. The element with index n is the portion of the string matching the nth parenthesized subexpression. 一个数组变量，其成员由 '\=~运算符设置为 `[[`（请参阅[条件结构](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)索引n与第 n' 二进制文件赋值 conditional 命令 ）。 索引为 0 的元素是字符串的一部分 匹配整个正则表达式。 的元素是 个带括号的子表达式匹配的字符串。

`BASH_SOURCE`

An array variable whose members are the source filenames where the corresponding shell function names in the `FUNCNAME` array variable are defined. The shell function `${FUNCNAME[$i]}` is defined in the file `${BASH_SOURCE[$i]}` and called from `${BASH_SOURCE[$i+1]}``FUNCNAME`shell 函数 `${FUNCNAME[$i]}``${BASH_SOURCE[$i]}` 并从 `${BASH_SOURCE[$i+1]}`一个数组变量，其成员是源文件名，其中 数组中的相应 shell 函数名称 变量被定义。 在文件中定义 调用

`BASH_SUBSHELL`

Incremented by one within each subshell or subshell environment when the shell begins executing in that environment. The initial value is 0. If `BASH_SUBSHELL` is unset, it loses its special properties, even if it is subsequently reset. 如果`BASH_SUBSHELL`在以下情况下，在每个子壳或子壳环境中递增 1 shell 开始在该环境中执行。 初始值为 0。 未设置，即使它失去了它的特殊属性，即使它是 随后重置。

`BASH_VERSINFO`

A readonly array variable (see [Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)) whose members hold version information for this instance of Bash. The values assigned to the array members are as follows: 只读数组变量（请参阅[数组](https://www.gnu.org/software/bash/manual/bash.html#Arrays)） 其成员保存此 Bash 实例的版本信息。 分配给数组成员的值如下所示：

`BASH_VERSINFO[0]`

The major version number (the _release_). 主版本号（_版本_）。

`BASH_VERSINFO[1]`

The minor version number (the _version_). 次要版本号（_版本_）。

`BASH_VERSINFO[2]`

The patch level. 补丁级别。

`BASH_VERSINFO[3]`

The build version. 生成版本。

`BASH_VERSINFO[4]`

The release status (e.g., `beta1`). 发布状态（例如 `beta1`）。

`BASH_VERSINFO[5]`

The value of `MACHTYPE`. `MACHTYPE` 的值。

`BASH_VERSION`

The version number of the current instance of Bash. 当前 Bash 实例的版本号。

`BASH_XTRACEFD`

If set to an integer corresponding to a valid file descriptor, Bash will write the trace output generated when ‘set -x’ is enabled to that file descriptor. This allows tracing output to be separated from diagnostic and error messages. The file descriptor is closed when `BASH_XTRACEFD` is unset or assigned a new value. Unsetting `BASH_XTRACEFD` or assigning it the empty string causes the trace output to be sent to the standard error. Note that setting `BASH_XTRACEFD` to 2 (the standard error file descriptor) and then unsetting it will result in the standard error being closed. 将写入 'set -x当文件描述符被取消设置或分配时`BASH_XTRACEFD`取消`BASH_XTRACEFD`请注意，将 `BASH_XTRACEFD`如果设置为与有效文件描述符相对应的整数，则 Bash ' 时生成的跟踪输出 已启用该文件描述符。 这允许将跟踪输出与诊断和错误分开 消息。 将关闭 一个新值。 或为其分配空字符串会导致 要发送到标准错误的跟踪输出。 设置为 2（标准错误文件 descriptor），然后取消设置将导致标准错误 被关闭。

`CHILD_MAX`

Set the number of exited child status values for the shell to remember. Bash will not allow this value to be decreased below a <small>POSIX</small>\-mandated minimum, and there is a maximum value (currently 8192) that this may not exceed. The minimum value is system-dependent. Bash 不允许此值降低到 <small>POSIX</small>设置要记住的 shell 的退出子状态值的数量。 规定的值以下 最小值，并且有一个最大值（当前为 8192），这可能 不超过。 最小值取决于系统。

`COLUMNS`

Used by the `select` command to determine the terminal width when printing selection lists. Automatically set if the `checkwinsize` option is enabled (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)), or in an interactive shell upon receipt of a `SIGWINCH`. `select`如果启用`checkwinsize`（参见 [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)`SIGWINCH` 命令用于确定端子宽度 打印选择列表时。 选项，则自动设置 ），或在收到 。

`COMP_CWORD`

An index into `${COMP_WORDS}` of the word containing the current cursor position. This variable is available only in shell functions invoked by the programmable completion facilities (see [Programmable Completion](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion)). 包含当前单词的 `${COMP_WORDS}`可编程完成设施（参见[可编程完成](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion) 的索引 光标位置。 此变量仅在 ）。

`COMP_LINE`

The current command line. This variable is available only in shell functions and external commands invoked by the programmable completion facilities (see [Programmable Completion](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion)). 可编程完成设施（参见[可编程完成](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion)当前命令行。 此变量仅在 shell 函数和外部 调用的命令 ）。

`COMP_POINT`

The index of the current cursor position relative to the beginning of the current command. If the current cursor position is at the end of the current command, the value of this variable is equal to `${#COMP_LINE}`. This variable is available only in shell functions and external commands invoked by the programmable completion facilities (see [Programmable Completion](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion)). 此变量的值等于 `${#COMP_LINE}`可编程完成设施（参见[可编程完成](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion)当前光标位置相对于 的开头的索引 当前命令。 如果当前光标位置位于当前命令的末尾， 。 此变量仅在 shell 函数和外部 调用的命令 ）。

`COMP_TYPE`

Set to an integer value corresponding to the type of completion attempted that caused a completion function to be called: TAB, for normal completion, ‘?’, for listing completions after successive tabs, ‘!’, for listing alternatives on partial word completion, ‘@’, to list completions if the word is not unmodified, or ‘%’, for menu completion. This variable is available only in shell functions and external commands invoked by the programmable completion facilities (see [Programmable Completion](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion)). TAB'?'!'@'%可编程完成设施（参见[可编程完成](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion)设置为与尝试完成的类型相对应的整数值 这导致调用完成函数： 表，用于正常完成， '，用于在连续选项卡后列出补全， '，用于列出部分单词完成的备选方案， '，如果单词未被修改，则列出补全， 或 '，用于菜单补全。 此变量仅在 shell 函数和外部 调用的命令 ）。

`COMP_KEY`

The key (or final key of a key sequence) used to invoke the current completion function. 用于调用当前 完成函数。

`COMP_WORDBREAKS`

The set of characters that the Readline library treats as word separators when performing word completion. If `COMP_WORDBREAKS` is unset, it loses its special properties, even if it is subsequently reset. 如果`COMP_WORDBREAKS`Readline 库视为单词的字符集 执行单词补全时的分隔符。 未设置，它失去了它的特殊属性， 即使它随后被重置。

`COMP_WORDS`

An array variable consisting of the individual words in the current command line. The line is split into words as Readline would split it, using `COMP_WORDBREAKS` as described above. This variable is available only in shell functions invoked by the programmable completion facilities (see [Programmable Completion](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion)). `COMP_WORDBREAKS`可编程完成设施（参见[可编程完成](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion)由单个 当前命令行中的单词。 该行被拆分为单词，因为 Readline 会拆分它，使用 如上所述。 此变量仅在 ）。

`COMPREPLY`

An array variable from which Bash reads the possible completions generated by a shell function invoked by the programmable completion facility (see [Programmable Completion](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion)). Each array element contains one possible completion. 设施（参见[可编程完成](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion)一个数组变量，Bash 从中读取可能的补全 由可编程完成调用的 shell 函数生成 ）。 每个数组元素都包含一个可能的完成。

`COPROC`

An array variable created to hold the file descriptors for output from and input to an unnamed coprocess (see [Coprocesses](https://www.gnu.org/software/bash/manual/bash.html#Coprocesses)). 用于从未命名的协进程的输出和输入（请参阅[协进程](https://www.gnu.org/software/bash/manual/bash.html#Coprocesses)为保存文件描述符而创建的数组变量 ）。

`DIRSTACK`

An array variable containing the current contents of the directory stack. Directories appear in the stack in the order they are displayed by the `dirs` builtin. Assigning to members of this array variable may be used to modify directories already in the stack, but the `pushd` and `popd` builtins must be used to add and remove directories. Assignment to this variable will not change the current directory. If `DIRSTACK` is unset, it loses its special properties, even if it is subsequently reset. `dirs`目录已在堆栈中，但 `pushd` 和 `popd`如果 `DIRSTACK`一个数组变量，包含目录堆栈的当前内容。 目录在堆栈中显示的顺序是 内置。 分配给此数组变量的成员可用于修改 必须使用 builtins 来添加和删除目录。 赋值到此变量不会更改当前目录。 未设置，即使 随后将其重置。

`EMACS`

If Bash finds this variable in the environment when the shell starts with value ‘t’, it assumes that the shell is running in an Emacs shell buffer and disables line editing. 以值 't如果 Bash 在环境中找到这个变量时，shell ' 开头，它假定 shell 在 Emacs shell 缓冲区并禁用行编辑。

`ENV`

Expanded and executed similarly to `BASH_ENV` (see [Bash Startup Files](https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files)) when an interactive shell is invoked in <small>POSIX</small> Mode (see [Bash POSIX Mode](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)). 扩展和执行方式与`BASH_ENV`（请参阅 [Bash 启动文件](https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files)<small>POSIX系列</small>模式（请参阅 [Bash POSIX 模式](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)类似 ） 当在 ）。

`EPOCHREALTIME`

Each time this parameter is referenced, it expands to the number of seconds since the Unix Epoch as a floating point value with micro-second granularity (see the documentation for the C library function `time` for the definition of Epoch). Assignments to `EPOCHREALTIME` are ignored. If `EPOCHREALTIME` is unset, it loses its special properties, even if it is subsequently reset. （请参阅 C 库函数`time`对 `EPOCHREALTIME`如果`EPOCHREALTIME`每次引用此参数时，它都会扩展到秒数 自 Unix 时代以来，作为具有微秒粒度的浮点值 的文档 纪元的定义）。 的赋值将被忽略。 未设置，即使 随后将其重置。

`EPOCHSECONDS`

Each time this parameter is referenced, it expands to the number of seconds since the Unix Epoch (see the documentation for the C library function `time` for the definition of Epoch). Assignments to `EPOCHSECONDS` are ignored. If `EPOCHSECONDS` is unset, it loses its special properties, even if it is subsequently reset. `time`对 `EPOCHSECONDS`如果 `EPOCHSECONDS`每次引用此参数时，它都会扩展到秒数 自 Unix 时代以来（参见 C 库函数的文档 定义纪元了）。 的赋值将被忽略。 未设置，即使 随后将其重置。

`EUID`

The numeric effective user id of the current user. This variable is readonly. 当前用户的数字有效用户 ID。 此变量 是只读的。

`EXECIGNORE`

A colon-separated list of shell patterns (see [Pattern Matching](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)) defining the list of filenames to be ignored by command search using `PATH`. Files whose full pathnames match one of these patterns are not considered executable files for the purposes of completion and command execution via `PATH` lookup. This does not affect the behavior of the `[`, `test`, and `[[` commands. Full pathnames in the command hash table are not subject to `EXECIGNORE`. Use this variable to ignore shared library files that have the executable bit set, but are not executable files. The pattern matching honors the setting of the `extglob` shell option. 以冒号分隔的 shell 模式列表（请参阅[模式匹配](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)`PATH`通过`PATH`这不会影响 `[`、`test` 和 `[[`命令哈希表中的完整路径名不受 `EXECIGNORE`模式匹配遵循 `extglob`） 定义命令搜索要忽略的文件名列表 。 不考虑完整路径名与这些模式之一匹配的文件 用于完成和命令执行的可执行文件 查找。 命令。 的约束。 使用此变量可忽略具有可执行文件的共享库文件 位设置，但不是可执行文件。 shell 的设置 选择。

`FCEDIT`

The editor used as a default by the \-e option to the `fc` builtin command. 编辑器由 `fc` \-e 选项用作默认值 内置命令。

`FIGNORE`

A colon-separated list of suffixes to ignore when performing filename completion. A filename whose suffix matches one of the entries in `FIGNORE` is excluded from the list of matched filenames. A sample value is ‘.o:~’ `FIGNORE`值为 '.o:~执行时要忽略的冒号分隔的后缀列表 文件名完成。 后缀与 从匹配的文件名列表中排除。 样品 '

`FUNCNAME`

An array variable containing the names of all shell functions currently in the execution call stack. The element with index 0 is the name of any currently-executing shell function. The bottom-most element (the one with the highest index) is `"main"`. This variable exists only when a shell function is executing. Assignments to `FUNCNAME` have no effect. If `FUNCNAME` is unset, it loses its special properties, even if it is subsequently reset. 是`"main"`对 `FUNCNAME`如果 `FUNCNAME`包含所有 shell 函数名称的数组变量 当前在执行调用堆栈中。 索引为 0 的元素是当前正在执行的任何元素的名称 shell 函数。 最底部的元素（索引最高的元素） 。 此变量仅在执行 shell 函数时存在。 的赋值不起作用。 未设置，即使 随后将其重置。

This variable can be used with `BASH_LINENO` and `BASH_SOURCE`. Each element of `FUNCNAME` has corresponding elements in `BASH_LINENO` and `BASH_SOURCE` to describe the call stack. For instance, `${FUNCNAME[$i]}` was called from the file `${BASH_SOURCE[$i+1]}` at line number `${BASH_LINENO[$i]}`. The `caller` builtin displays the current call stack using this information. 此变量可用于 `BASH_LINENO` 和 `BASH_SOURCE``FUNCNAME``BASH_LINENO`和`BASH_SOURCE`例如，$`${FUNCNAME[$i]}``${BASH_SOURCE[$i+1]}` 在行号 `${BASH_LINENO[$i]}`内置`caller`。 的每个元素在 来描述调用堆栈。 是从文件中调用的 。 使用以下命令显示当前调用堆栈 信息。

`FUNCNEST`

If set to a numeric value greater than 0, defines a maximum function nesting level. Function invocations that exceed this nesting level will cause the current command to abort. 如果设置为大于 0 的数值，则定义最大函数 嵌套级别。 超过此嵌套级别的函数调用 将导致当前命令中止。

`GLOBIGNORE`

A colon-separated list of patterns defining the set of file names to be ignored by filename expansion. If a file name matched by a filename expansion pattern also matches one of the patterns in `GLOBIGNORE`, it is removed from the list of matches. The pattern matching honors the setting of the `extglob` shell option. `GLOBIGNORE`模式匹配遵循 `extglob`以冒号分隔的模式列表，将文件名集定义为 被文件名扩展忽略。 如果与文件名扩展模式匹配的文件名也与文件名扩展模式匹配 中的模式，它将从列表中删除 的比赛。 shell 的设置 选择。

`GROUPS`

An array variable containing the list of groups of which the current user is a member. Assignments to `GROUPS` have no effect. If `GROUPS` is unset, it loses its special properties, even if it is subsequently reset. 分配给 `GROUPS`如果`GROUPS`一个数组变量，包含当前 用户是会员。 不起作用。 未设置，即使它失去了它的特殊属性，即使它是 随后重置。

`histchars`

Up to three characters which control history expansion, quick substitution, and tokenization (see [History Expansion](https://www.gnu.org/software/bash/manual/bash.html#History-Interaction)). The first character is the _history expansion_ character, that is, the character which signifies the start of a history expansion, normally ‘!’. The second character is the character which signifies ‘quick substitution’ when seen as the first character on a line, normally ‘^’. The optional third character is the character which indicates that the remainder of the line is a comment when found as the first character of a word, usually ‘#’. The history comment character causes history substitution to be skipped for the remaining words on the line. It does not necessarily cause the shell parser to treat the rest of the line as a comment. 替换和标记化（请参阅[历史扩展](https://www.gnu.org/software/bash/manual/bash.html#History-Interaction)_历史扩展_历史扩展的开始，通常为 '!一行上的字符，通常为“^作为单词的第一个字符找到，通常是“#最多三个字符，控制历史扩展，快速 ）。 第一个字符是 字符，即表示 '。 第二个字符是 字符，当被视为第一个时表示“快速替换” ”。 可选的第三个字符是 字符，表示该行的其余部分是注释，当 ”。 历史 注释字符导致跳过历史替换 行上的剩余单词。 它不一定会导致shell 解析器将行的其余部分视为注释。

`HISTCMD`

The history number, or index in the history list, of the current command. Assignments to `HISTCMD` are ignored. If `HISTCMD` is unset, it loses its special properties, even if it is subsequently reset. 对 `HISTCMD`如果 `HISTCMD`当前历史记录列表中的历史记录编号或索引 命令。 的赋值将被忽略。 未设置，它失去了它的特殊属性， 即使它随后被重置。

`HISTCONTROL`

A colon-separated list of values controlling how commands are saved on the history list. If the list of values includes ‘ignorespace’, lines which begin with a space character are not saved in the history list. A value of ‘ignoredups’ causes lines which match the previous history entry to not be saved. A value of ‘ignoreboth’ is shorthand for ‘ignorespace’ and ‘ignoredups’. A value of ‘erasedups’ causes all previous lines matching the current line to be removed from the history list before that line is saved. Any value not in the above list is ignored. If `HISTCONTROL` is unset, or does not include a valid value, all lines read by the shell parser are saved on the history list, subject to the value of `HISTIGNORE`. The second and subsequent lines of a multi-line compound command are not tested, and are added to the history regardless of the value of `HISTCONTROL`. 如果值列表包含“ignorespace值“ignoredups值“ignoreboth'ignorespace' 和 'ignoredups值“erasedups如果 `HISTCONTROL`以 `HISTIGNORE``HISTCONTROL`以冒号分隔的值列表，用于控制命令的保存方式 历史记录列表。 ”，则以 带有空格的字符不会保存在历史记录列表中。 ”会导致与前一行匹配的行 不保存的历史记录条目。 ”是 '。 ”会导致前面的所有行都匹配 要从该行之前的历史记录列表中删除的当前行 已保存。 任何不在上面列表中的值都将被忽略。 未设置或不包含有效值， shell 解析器读取的所有行都保存在历史记录列表中， 的值为准。 多行复合命令的第二行和后续行是 未经测试，并且无论 的。

`HISTFILE`

The name of the file to which the command history is saved. The default value is ~/.bash\_history. 默认值为 ~/.bash\_history保存命令历史记录的文件的名称。 这 。

`HISTFILESIZE`

The maximum number of lines contained in the history file. When this variable is assigned a value, the history file is truncated, if necessary, to contain no more than that number of lines by removing the oldest entries. The history file is also truncated to this size after writing it when a shell exits. If the value is 0, the history file is truncated to zero size. Non-numeric values and numeric values less than zero inhibit truncation. The shell sets the default value to the value of `HISTSIZE` after reading any startup files. shell 将默认值设置为 `HISTSIZE`历史记录文件中包含的最大行数。 当为这个变量赋值时，历史记录文件将被截断， 如有必要，包含不超过该行数 通过删除最旧的条目。 历史记录文件也会被截断为此大小 当 shell 退出时写入它。 如果值为 0，则历史记录文件的大小将截断为零。 非数值和小于零的数值会抑制截断。 的值 读取任何启动文件后。

`HISTIGNORE`

A colon-separated list of patterns used to decide which command lines should be saved on the history list. Each pattern is anchored at the beginning of the line and must match the complete line (no implicit ‘\*’ is appended). Each pattern is tested against the line after the checks specified by `HISTCONTROL` are applied. In addition to the normal shell pattern matching characters, ‘&’ matches the previous history line. ‘&’ may be escaped using a backslash; the backslash is removed before attempting a match. The second and subsequent lines of a multi-line compound command are not tested, and are added to the history regardless of the value of `HISTIGNORE`. The pattern matching honors the setting of the `extglob` shell option. 行（不附加隐式“\*在 `HISTCONTROL`字符，“&”与上一行历史记录匹配。 '&`HISTIGNORE`模式匹配遵循 `extglob`用于决定哪个命令的以冒号分隔的模式列表 行应保存在历史记录列表中。 每个模式是 锚定在行的开头，并且必须与完整的 ”）。 每种模式都经过测试 指定的检查之后的行 应用。 除了正常的shell图案匹配 ' 可以使用反斜杠进行转义;反斜杠被删除 在尝试匹配之前。 多行复合命令的第二行和后续行是 未经测试，并且无论 。 shell 的设置 选择。

`HISTIGNORE` subsumes the function of `HISTCONTROL`. A pattern of ‘&’ is identical to `ignoredups`, and a pattern of ‘\[ \]\*’ is identical to `ignorespace`. Combining these two patterns, separating them with a colon, provides the functionality of `ignoreboth`. `HISTIGNORE` 包含 `HISTCONTROL`“&”的模式与 `ignoredups`“\[ \[ \]\*' 的模式与 `ignorespace`提供 `ignoreboth` 的功能。 一个 相同，并且 相同。 结合这两种模式，用冒号将它们分开， 的功能。

`HISTSIZE`

The maximum number of commands to remember on the history list. If the value is 0, commands are not saved in the history list. Numeric values less than zero result in every command being saved on the history list (there is no limit). The shell sets the default value to 500 after reading any startup files. 历史记录列表中要记住的最大命令数。 如果值为 0，则命令不会保存在历史记录列表中。 数值小于零会导致保存每个命令 在历史记录列表中（没有限制）。 shell 在读取任何启动文件后将默认值设置为 500。

`HISTTIMEFORMAT`

If this variable is set and not null, its value is used as a format string for `strftime` to print the time stamp associated with each history entry displayed by the `history` builtin. If this variable is set, time stamps are written to the history file so they may be preserved across shell sessions. This uses the history comment character to distinguish timestamps from other history lines. 让 `strftime`内置`history`如果设置了此变量且不为 null，则其值将用作格式字符串 打印与每个历史记录关联的时间戳 显示的条目。 如果设置了此变量，则时间戳将写入历史记录文件，因此 它们可以跨 shell 会话保留。 这使用历史注释字符来区分时间戳 其他历史线。

`HOSTFILE`

Contains the name of a file in the same format as /etc/hosts that should be read when the shell needs to complete a hostname. The list of possible hostname completions may be changed while the shell is running; the next time hostname completion is attempted after the value is changed, Bash adds the contents of the new file to the existing list. If `HOSTFILE` is set, but has no value, or does not name a readable file, Bash attempts to read /etc/hosts to obtain the list of possible hostname completions. When `HOSTFILE` is unset, the hostname list is cleared. 包含与 /etc/hosts如果设置`HOSTFILE`/etc/hosts当 `HOSTFILE` 格式相同的文件名 当 shell 需要完成主机名时，应读取该版本。 可能的主机名完成列表可能会在 shell 时更改 正在运行; 下次尝试完成主机名时，请在 值更改后，Bash 将新文件的内容添加到 现有列表。 ，但没有值，或者没有命名可读文件， Bash 尝试读取 获取可能的主机名完成列表。 未设置时，将清除主机名列表。

`HOSTNAME`

The name of the current host. 当前主机的名称。

`HOSTTYPE`

A string describing the machine Bash is running on. 描述运行 Bash 的计算机的字符串。

`IGNOREEOF`

Controls the action of the shell on receipt of an `EOF` character as the sole input. If set, the value denotes the number of consecutive `EOF` characters that can be read as the first character on an input line before the shell will exit. If the variable exists but does not have a numeric value, or has no value, then the default is 10. If the variable does not exist, then `EOF` signifies the end of input to the shell. This is only in effect for interactive shells. 控制 shell 在接收到 `EOF``EOF`如果变量不存在，`EOF` 字符时的操作 作为唯一的输入。 如果设置，则该值表示数字 为 输入行上的第一个字符 在 shell 退出之前。 如果变量存在但不存在 有数值，或者没有值，则默认值为 10。 表示 输入到 shell。 这仅对交互式 shell 有效。

`INPUTRC`

The name of the Readline initialization file, overriding the default of ~/.inputrc. ~/.inputrcReadline 初始化文件的名称，覆盖缺省值 。

`INSIDE_EMACS`

If Bash finds this variable in the environment when the shell starts, it assumes that the shell is running in an Emacs shell buffer and may disable line editing depending on the value of `TERM`. 并可能根据 `TERM`如果 Bash 在环境中找到这个变量时，shell starts，它假设 shell 正在 Emacs shell 缓冲区中运行 的值禁用行编辑。

`LANG`

Used to determine the locale category for any category not specifically selected with a variable starting with `LC_`. 选择以 `LC_`用于确定任何非特定类别的区域设置类别 开头的变量。

`LC_ALL`

This variable overrides the value of `LANG` and any other `LC_` variable specifying a locale category. 此变量将覆盖 `LANG``LC_` 和任何其他变量的值 指定区域设置类别的变量。

`LC_COLLATE`

This variable determines the collation order used when sorting the results of filename expansion, and determines the behavior of range expressions, equivalence classes, and collating sequences within filename expansion and pattern matching (see [Filename Expansion](https://www.gnu.org/software/bash/manual/bash.html#Filename-Expansion)). （请参阅[文件名扩展](https://www.gnu.org/software/bash/manual/bash.html#Filename-Expansion)此变量确定对 文件名扩展的结果，以及 确定范围表达式、等价类的行为、 以及整理文件名扩展和模式匹配中的序列 ）。

`LC_CTYPE`

This variable determines the interpretation of characters and the behavior of character classes within filename expansion and pattern matching (see [Filename Expansion](https://www.gnu.org/software/bash/manual/bash.html#Filename-Expansion)). 匹配（请参阅[文件名扩展](https://www.gnu.org/software/bash/manual/bash.html#Filename-Expansion)这个变量决定了字符的解释和 文件名扩展和模式中字符类的行为 ）。

`LC_MESSAGES`

This variable determines the locale used to translate double-quoted strings preceded by a ‘$’ (see [Locale-Specific Translation](https://www.gnu.org/software/bash/manual/bash.html#Locale-Translation)). 前面带有“$”的字符串（请参阅[特定于区域设置的翻译](https://www.gnu.org/software/bash/manual/bash.html#Locale-Translation)此变量确定用于翻译双引号的区域设置 ）。

`LC_NUMERIC`

This variable determines the locale category used for number formatting. 此变量确定用于数字格式设置的区域设置类别。

`LC_TIME`

This variable determines the locale category used for data and time formatting. 此变量确定用于数据和时间的区域设置类别 格式。

`LINENO`

The line number in the script or shell function currently executing. If `LINENO` is unset, it loses its special properties, even if it is subsequently reset. 如果 `LINENO`当前正在执行的脚本或 shell 函数中的行号。 未设置，即使它失去了它的特殊属性，即使它是 随后重置。

`LINES`

Used by the `select` command to determine the column length for printing selection lists. Automatically set if the `checkwinsize` option is enabled (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)), or in an interactive shell upon receipt of a `SIGWINCH`. `select`如果启用`checkwinsize`（参见 [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)`SIGWINCH` 命令用于确定列长度 用于打印选择列表。 选项，则自动设置 ），或在收到 。

`MACHTYPE`

A string that fully describes the system type on which Bash is executing, in the standard <small>GNU</small> cpu-company-system format. 正在执行，以标准的 cpu-company-system 格式执行。一个字符串，它完全描述了 Bash 所在的系统类型

`MAILCHECK`

How often (in seconds) that the shell should check for mail in the files specified in the `MAILPATH` or `MAIL` variables. The default is 60 seconds. When it is time to check for mail, the shell does so before displaying the primary prompt. If this variable is unset, or set to a value that is not a number greater than or equal to zero, the shell disables mail checking. `MAILPATH` 或 `MAIL`shell 应检查邮件的频率（以秒为单位） 变量中指定的文件。 默认值为 60 秒。 什么时候该检查了 对于邮件，命令行管理程序会在显示主提示之前执行此操作。 如果此变量未设置，或设置为非数字的值 大于或等于零，shell 禁用邮件检查。

`MAPFILE`

An array variable created to hold the text read by the `mapfile` builtin when no variable name is supplied. `mapfile`为保存 内置，当未提供变量名称时。

`OLDPWD`

The previous working directory as set by the `cd` builtin. 由 `cd` 内置设置的上一个工作目录。

`OPTERR`

If set to the value 1, Bash displays error messages generated by the `getopts` builtin command. 由 `getopts`如果设置为值 1，Bash 将显示错误消息 builtin 命令生成。

`OSTYPE`

A string describing the operating system Bash is running on. 描述运行 Bash 的操作系统的字符串。

`PIPESTATUS`

An array variable (see [Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)) containing a list of exit status values from the processes in the most-recently-executed foreground pipeline (which may contain only a single command). 数组变量（请参阅[数组](https://www.gnu.org/software/bash/manual/bash.html#Arrays)） 包含进程中的退出状态值列表 在最近执行的前台管道中（可能 仅包含单个命令）。

`POSIXLY_CORRECT`

If this variable is in the environment when Bash starts, the shell enters <small>POSIX</small> mode (see [Bash POSIX Mode](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)) before reading the startup files, as if the \--posix invocation option had been supplied. If it is set while the shell is running, Bash enables <small>POSIX</small> mode, as if the command 进入 <small>POSIX</small> 模式（参见 [Bash POSIX 模式](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)启动文件，就好像提供了 \--posix如果在 shell 运行时设置，则 Bash 将启用 <small>POSIX</small>如果此变量在 Bash 启动时位于环境中，则 shell ），然后读取 调用选项一样。 模式， 仿佛命令

had been executed. When the shell enters <small>POSIX</small> mode, it sets this variable if it was not already set. 当 shell 进入 <small>POSIX</small>已被处决。 模式时，它会设置此变量（如果是 尚未设置。

`PPID`

The process <small>ID</small> of the shell’s parent process. This variable is readonly. shell 的父进程的进程 <small>ID</small>。 此变量 是只读的。

`PROMPT_COMMAND`

If this variable is set, and is an array, the value of each set element is interpreted as a command to execute before printing the primary prompt (`$PS1`). If this is set but not an array variable, its value is used as a command to execute instead. 在打印主提示 （`$PS1`如果设置了此变量，并且是一个数组， 每个 set 元素的值被解释为要执行的命令 ） 之前。 如果设置了此值，但不是数组变量， 它的值用作要执行的命令。

`PROMPT_DIRTRIM`

If set to a number greater than zero, the value is used as the number of trailing directory components to retain when expanding the `\w` and `\W` prompt string escapes (see [Controlling the Prompt](https://www.gnu.org/software/bash/manual/bash.html#Controlling-the-Prompt)). Characters removed are replaced with an ellipsis. 展开 `\w``\W` 提示符字符串转义（请参阅[控制提示](https://www.gnu.org/software/bash/manual/bash.html#Controlling-the-Prompt)如果设置为大于零的数字，则该值用作 和 符）。 删除的字符将替换为省略号。

`PS0`

The value of this parameter is expanded like `PS1` and displayed by interactive shells after reading a command and before the command is executed. 此参数的值像 `PS1` 一样扩展 并在读取命令后由交互式 shell 显示 在执行命令之前。

`PS3`

The value of this variable is used as the prompt for the `select` command. If this variable is not set, the `select` command prompts with ‘#? ’ `select``select`带有“#? 此变量的值用作 命令。 如果未设置此变量，则

`PS4`

The value of this parameter is expanded like `PS1` and the expanded value is the prompt printed before the command line is echoed when the \-x option is set (see [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)). The first character of the expanded value is replicated multiple times, as necessary, to indicate multiple levels of indirection. The default is ‘\+ ’. 此参数的值像 `PS1`在设置 \-x 选项时回显（请参阅[设置内置）。](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)默认值为 '\+ 一样扩展 展开的值是在命令行之前打印的提示符 扩展值的第一个字符被复制多次， 必要时，指示多个间接级别。 '。

`PWD`

The current working directory as set by the `cd` builtin. 由 `cd` 内置设置的当前工作目录。

`RANDOM`

Each time this parameter is referenced, it expands to a random integer between 0 and 32767. Assigning a value to this variable seeds the random number generator. If `RANDOM` is unset, it loses its special properties, even if it is subsequently reset. 如果 `RANDOM`每次引用此参数时，它都会扩展为随机整数 介于 0 和 32767 之间。为此赋值 变量为随机数生成器提供种子。 未设置，即使它失去了它的特殊属性，即使它是 随后重置。

`READLINE_ARGUMENT`

Any numeric argument given to a Readline command that was defined using ‘bind -x’ (see [Bash Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins) when it was invoked. 'bind -x' （参见 [Bash 内置命令](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)提供给 Readline 命令的任何数值参数，该参数是使用 当它被调用时。

`READLINE_LINE`

The contents of the Readline line buffer, for use with ‘bind -x’ (see [Bash Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)). 替换为 'bind -x'（请参阅 [Bash 内置命令](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)Readline 行缓冲区的内容，供使用 ）。

`READLINE_MARK`

The position of the _mark_ (saved insertion point) in the Readline line buffer, for use with ‘bind -x’ (see [Bash Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)). The characters between the insertion point and the mark are often called the _region_. _标记_替换为 'bind -x'（请参阅 [Bash 内置命令](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)称为_区域_（保存的插入点）在 Readline 线缓冲器，供使用 ）。 插入点和标记之间的字符通常为 。

`READLINE_POINT`

The position of the insertion point in the Readline line buffer, for use with ‘bind -x’ (see [Bash Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)). 替换为 'bind -x'（请参阅 [Bash 内置命令](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)插入点在 Readline 行缓冲区中的位置，以供使用 ）。

`REPLY`

The default variable for the `read` builtin. `read`内置的默认变量。

`SECONDS`

This variable expands to the number of seconds since the shell was started. Assignment to this variable resets the count to the value assigned, and the expanded value becomes the value assigned plus the number of seconds since the assignment. The number of seconds at shell invocation and the current time are always determined by querying the system clock. If `SECONDS` is unset, it loses its special properties, even if it is subsequently reset. 如果 `SECONDS`此变量扩展为自 shell 启动以来的秒数。 赋值到此变量会将计数重置为赋值，并且 扩展值变为分配的值加上秒数 自分配以来。 shell 调用时的秒数和当前时间始终为 通过查询系统时钟确定。 未设置，它失去了它的特殊属性， 即使它随后被重置。

`SHELL`

This environment variable expands to the full pathname to the shell. If it is not set when the shell starts, Bash assigns to it the full pathname of the current user’s login shell. 此环境变量将扩展为 shell 的完整路径名。 如果在 shell 启动时未设置， Bash 为其分配当前用户登录 shell 的完整路径名。

`SHELLOPTS`

A colon-separated list of enabled shell options. Each word in the list is a valid argument for the \-o option to the `set` builtin command (see [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)). The options appearing in `SHELLOPTS` are those reported as ‘on’ by ‘set -o’. If this variable is in the environment when Bash starts up, each shell option in the list will be enabled before reading any startup files. This variable is readonly. 该列表是 \-o`set` builtin 命令（请参阅 [Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)`SHELLOPTS`作为 'on' by 'set -o以冒号分隔的已启用 shell 选项列表。 每个单词 选项的有效参数 ）。 中出现的选项是报告的选项 '。 如果此变量在环境中，则 Bash 启动后，列表中的每个 shell 选项都会在之前启用 读取任何启动文件。 此变量是只读的。

`SHLVL`

Incremented by one each time a new instance of Bash is started. This is intended to be a count of how deeply your Bash shells are nested. 每次启动新的 Bash 实例时，都会递增 1。 这是 旨在计算 Bash shell 的嵌套深度。

`SRANDOM`

This variable expands to a 32-bit pseudo-random number each time it is referenced. The random number generator is not linear on systems that support /dev/urandom or `arc4random`, so each returned number has no relationship to the numbers preceding it. The random number generator cannot be seeded, so assignments to this variable have no effect. If `SRANDOM` is unset, it loses its special properties, even if it is subsequently reset. 支持 /dev/urandom 或 `arc4random`如果 `SRANDOM`此变量每次扩展为 32 位伪随机数 引用。随机数生成器在以下系统上不是线性的 ，所以每个返回的数字 与前面的数字没有关系。 随机数生成器不能被设定种子，所以赋值给这个 变量没有效果。 未设置，它失去了它的特殊属性， 即使它随后被重置。

`TIMEFORMAT`

The value of this parameter is used as a format string specifying how the timing information for pipelines prefixed with the `time` reserved word should be displayed. The ‘%’ character introduces an escape sequence that is expanded to a time value or other information. The escape sequences and their meanings are as follows; the braces denote optional portions. 管道的计时信息如何以`time`“%此参数的值用作指定 为前缀 应显示保留字。 ”字符引入了 扩展为时间值或其他值的转义序列 信息。 转义序列及其含义如下 遵循;大括号表示可选部分。

`%%`

A literal ‘%’. 文字 '%'。

`%[p][l]R`%\[p\]\[l\]R

The elapsed time in seconds. 经过的时间（以秒为单位）。

`%[p][l]U`%\[p\]\[l\]U

The number of CPU seconds spent in user mode. 在用户模式下花费的 CPU 秒数。

`%[p][l]S`%\[p\]\[l\]S

The number of CPU seconds spent in system mode. 在系统模式下花费的 CPU 秒数。

`%P`

The CPU percentage, computed as (%U + %S) / %R. CPU 百分比，计算公式为 （%U + %S） / %R。

The optional p is a digit specifying the precision, the number of fractional digits after a decimal point. A value of 0 causes no decimal point or fraction to be output. At most three places after the decimal point may be specified; values of p greater than 3 are changed to 3. If p is not specified, the value 3 is used. 可选的 p大于 3 p如果未指定 p 是一个数字，指定精度，即 小数点后的小数数字。 值为 0 时，不会输出小数点或小数。 小数点后最多可以指定三位;值 更改为 3。 ，则使用值 3。

The optional `l` specifies a longer format, including minutes, of the form MMmSS.FFs. The value of p determines whether or not the fraction is included. 可选的 `l`MMmSSFFp 指定更长的格式，包括分钟，为 的。 的值决定了是否包含分数。

If this variable is not set, Bash acts as if it had the value 如果未设置此变量，则 Bash 将充当具有该值的变量

```
$'\nreal\t%3lR\nuser\t%3lU\nsys\t%3lS'
```

If the value is null, no timing information is displayed. A trailing newline is added when the format string is displayed. 如果该值为 null，则不显示计时信息。 显示格式字符串时，将添加尾随换行符。

`TMOUT`

If set to a value greater than zero, `TMOUT` is treated as the default timeout for the `read` builtin (see [Bash Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)). The `select` command (see [Conditional Constructs](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)) terminates if input does not arrive after `TMOUT` seconds when input is coming from a terminal. 如果设置为大于零的值，`TMOUT``read`内置的默认超时（请参阅 [Bash 内置命令](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)`select` 命令（请参阅[条件构造](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)如果输入在输入到来时`TMOUT` 被视为 ）。 ）终止 秒后未到达 从终端。

In an interactive shell, the value is interpreted as the number of seconds to wait for a line of input after issuing the primary prompt. Bash terminates after waiting for that number of seconds if a complete line of input does not arrive. 在交互式 shell 中，该值被解释为 发出后等待输入行的秒数 主要提示。 巴什 在等待该秒数后终止，如果完成 输入行未到达。

`TMPDIR`

If set, Bash uses its value as the name of a directory in which Bash creates temporary files for the shell’s use. 如果设置，Bash 将使用其值作为目录的名称，其中 Bash 创建临时文件供 shell 使用。

`UID`

The numeric real user id of the current user. This variable is readonly. 当前用户的数字真实用户 ID。 此变量是只读的。
