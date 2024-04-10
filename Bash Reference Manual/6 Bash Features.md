
## 6 Bash Features6 Bash 功能

This chapter describes features unique to Bash. 本章介绍 Bash 独有的功能。

-   [Invoking Bash调用 Bash](https://www.gnu.org/software/bash/manual/bash.html#Invoking-Bash)
-   [Bash Startup FilesBash 启动文件](https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files)
-   [Interactive Shells交互式 Shell](https://www.gnu.org/software/bash/manual/bash.html#Interactive-Shells)
-   [Bash Conditional ExpressionsBash 条件表达式](https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions)
-   [Shell Arithmetic壳牌算术](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)
-   [Aliases别名](https://www.gnu.org/software/bash/manual/bash.html#Aliases)
-   [Arrays阵 列](https://www.gnu.org/software/bash/manual/bash.html#Arrays)
-   [The Directory Stack目录堆栈](https://www.gnu.org/software/bash/manual/bash.html#The-Directory-Stack)
-   [Controlling the Prompt控制提示](https://www.gnu.org/software/bash/manual/bash.html#Controlling-the-Prompt)
-   [The Restricted Shell受限shell](https://www.gnu.org/software/bash/manual/bash.html#The-Restricted-Shell)
-   [Bash POSIX ModeBash POSIX 模式](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)
-   [Shell Compatibility ModeShell 兼容模式](https://www.gnu.org/software/bash/manual/bash.html#Shell-Compatibility-Mode)

___

### 6.1 Invoking Bash6.1 调用 Bash

```
bash [long-opt] [-ir] [-abefhkmnptuvxdBCDHP] [-o option]
    [-O shopt_option] [argument …]
bash [long-opt] [-abefhkmnptuvxdBCDHP] [-o option]
    [-O shopt_option] -c string [argument …]
bash [long-opt] -s [-abefhkmnptuvxdBCDHP] [-o option]
    [-O shopt_option] [argument …]
```

All of the single-character options used with the `set` builtin (see [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)) can be used as options when the shell is invoked. In addition, there are several multi-character options that you can use. These options must appear on the command line before the single-character options to be recognized. 与内置`set`（请参阅 [Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)一起使用的所有单字符选项 ）可以在调用 shell 时用作选项。 此外，还有几个多字符 您可以使用的选项。 这些选项必须显示在命令上 行前要识别的单字符选项。

`--debugger`

Arrange for the debugger profile to be executed before the shell starts. Turns on extended debugging mode (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin) for a description of the `extdebug` option to the `shopt` builtin). 开始。 打开扩展调试模式（请参阅 [Shopt 内置](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)有关 `shopt` 的 `extdebug`安排在 shell 之前执行调试器配置文件 选项的说明 内置）。

`--dump-po-strings`

A list of all double-quoted strings preceded by ‘$’ is printed on the standard output in the <small>GNU</small> `gettext` PO (portable object) file format. Equivalent to \-D except for the output format. 前面以“$<small>采用 GNU</small>`gettext`等效于 \-D”开头的所有双引号字符串的列表 印在标准输出上 PO（可移植对象）文件格式。 ，但输出格式除外。

`--dump-strings`

Equivalent to \-D. 等价于 \-D。

`--help`

Display a usage message on standard output and exit successfully. 在标准输出上显示使用消息并成功退出。

`--init-file filename`\--init-file filename

`--rcfile filename`\--rcfile filename

Execute commands from filename (instead of ~/.bashrc) in an interactive shell. 从 filename（而不是 ~/.bashrc）执行命令 在交互式 shell 中。

`--login`

Equivalent to \-l. 等价于 \-l。

`--noediting`

Do not use the <small>GNU</small> Readline library (see [Command Line Editing](https://www.gnu.org/software/bash/manual/bash.html#Command-Line-Editing)) to read command lines when the shell is interactive. 不要使用 <small>GNU</small> Readline 库（参见[命令行编辑](https://www.gnu.org/software/bash/manual/bash.html#Command-Line-Editing)） 在 shell 交互时读取命令行。

`--noprofile`

Don’t load the system-wide startup file /etc/profile or any of the personal initialization files ~/.bash\_profile, ~/.bash\_login, or ~/.profile when Bash is invoked as a login shell. 不要加载系统范围的启动文件 /etc/profile~/.bash\_profile、~/.bash\_login 或 ~/.profile 或任何个人初始化文件 当 Bash 作为登录 shell 调用时。

`--norc`

Don’t read the ~/.bashrc initialization file in an interactive shell. This is on by default if the shell is invoked as `sh`. 不要读取 ~/.bashrc调用为 `sh` 初始化文件 交互式 shell。 如果 shell 是 。

`--posix`

Change the behavior of Bash where the default operation differs from the <small>POSIX</small> standard to match the standard. This is intended to make Bash behave as a strict superset of that standard. See [Bash POSIX Mode](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode), for a description of the Bash <small>POSIX</small> mode. 从<small>POSIX</small>标准。 有关 Bash 的说明，请参阅 [Bash POSIX 模式](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)<small>POSIX</small>更改默认操作不同的 Bash 行为 标准到匹配标准。 这 旨在使 Bash 表现为严格的超集 模式。

`--restricted`

Make the shell a restricted shell (see [The Restricted Shell](https://www.gnu.org/software/bash/manual/bash.html#The-Restricted-Shell)). 使 shell 成为受限 shell（请参阅[受限 shell](https://www.gnu.org/software/bash/manual/bash.html#The-Restricted-Shell)）。

`--verbose`

Equivalent to \-v. Print shell input lines as they’re read. 等效于 \-v。 在读取 shell 输入行时打印它们。

`--version`

Show version information for this instance of Bash on the standard output and exit successfully. 显示此实例的版本信息 重击标准输出并成功退出。

There are several single-character options that may be supplied at invocation which are not available with the `set` builtin. 调用，这些调用在 `set`有几个单字符选项可以在 内置中不可用。

`-c`

Read and execute commands from the first non-option argument command\_string, then exit. If there are arguments after the command\_string, the first argument is assigned to `$0` and any remaining arguments are assigned to the positional parameters. The assignment to `$0` sets the name of the shell, which is used in warning and error messages.

`-i`

Force the shell to run interactively. Interactive shells are described in [Interactive Shells](https://www.gnu.org/software/bash/manual/bash.html#Interactive-Shells). [在交互式 Shell](https://www.gnu.org/software/bash/manual/bash.html#Interactive-Shells)强制 shell 以交互方式运行。 交互式 shell 是 中描述。

`-l`

Make this shell act as if it had been directly invoked by login. When the shell is interactive, this is equivalent to starting a login shell with ‘exec -l bash’. When the shell is not interactive, the login shell startup files will be executed. ‘exec bash -l’ or ‘exec bash --login’ will replace the current shell with a Bash login shell. See [Bash Startup Files](https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files), for a description of the special behavior of a login shell. 带有“exec -l bash'exec bash -l' 或 'exec bash --login有关特殊行为的说明，请参阅 [Bash 启动文件](https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files)使此 shell 的行为就像它已通过登录直接调用一样。 当 shell 是交互式的时，这相当于启动一个 ”的登录 shell。 当 shell 不交互时，登录 shell 启动文件将 伏法。 ' 将当前 shell 替换为 Bash 登录 shell。 登录 shell。

`-r`

Make the shell a restricted shell (see [The Restricted Shell](https://www.gnu.org/software/bash/manual/bash.html#The-Restricted-Shell)). 使 shell 成为受限 shell（请参阅[受限 shell](https://www.gnu.org/software/bash/manual/bash.html#The-Restricted-Shell)）。

`-s`

If this option is present, or if no arguments remain after option processing, then commands are read from the standard input. This option allows the positional parameters to be set when invoking an interactive shell or when reading input through a pipe. 如果此选项存在，或者选项后没有参数保留 处理，然后从标准输入中读取命令。 此选项允许设置位置参数 调用交互式 shell 或读取输入时 通过管道。

`-D`

A list of all double-quoted strings preceded by ‘$’ is printed on the standard output. These are the strings that are subject to language translation when the current locale is not `C` or `POSIX` (see [Locale-Specific Translation](https://www.gnu.org/software/bash/manual/bash.html#Locale-Translation)). This implies the \-n option; no commands will be executed. 前面以“$不是 `C` 或 `POSIX`（请参阅[特定于区域设置的翻译](https://www.gnu.org/software/bash/manual/bash.html#Locale-Translation)这意味着 \-n”开头的所有双引号字符串的列表 打印在标准输出上。 这些是 当前语言环境时需要进行语言翻译 ）。 选项;不会执行任何命令。

`[-+]O [shopt_option]`\[-+\]O \[shopt\_option\]

shopt\_option is one of the shell options accepted by the `shopt` builtin (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)). If shopt\_option is present, \-O sets the value of that option; +O unsets it. If shopt\_option is not supplied, the names and values of the shell options accepted by `shopt` are printed on the standard output. If the invocation option is +O, the output is displayed in a format that may be reused as input. shopt\_option`shopt` builtin（请参阅 [shopt builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)如果存在shopt\_option，\-O+O如果未提供shopt\_option`shopt`如果调用选项为 +O 是 ）。 设置该选项的值; 取消设置它。 ，则 shell 的名称和值 接受的选项打印在标准输出上。 ，则输出将按以下格式显示 可以重复用作输入。

`--`

A `--` signals the end of options and disables further option processing. Any arguments after the `--` are treated as filenames and arguments. A `--``--` 表示选项结束并禁用其他选项 加工。 之后的任何参数都被视为文件名和参数。

A _login_ shell is one whose first character of argument zero is ‘\-’, or one invoked with the \--login option. _登录_'\-'，或使用 \--login shell 是参数 0 的第一个字符为 选项调用的选项。

An _interactive_ shell is one started without non-option arguments, unless \-s is specified, without specifying the \-c option, and whose input and output are both connected to terminals (as determined by `isatty(3)`), or one started with the \-i option. See [Interactive Shells](https://www.gnu.org/software/bash/manual/bash.html#Interactive-Shells), for more information. _交互式_除非指定\-s没有指定 \-c连接到终端（由 `isatty(3)`从 \-i 选项开始。 有关详细信息，请参阅[交互式 Shell](https://www.gnu.org/software/bash/manual/bash.html#Interactive-Shells) shell 是没有非选项参数的启动， ， 选项，并且其输入和输出都是 确定），或一个 信息。

If arguments remain after option processing, and neither the \-c nor the \-s option has been supplied, the first argument is assumed to be the name of a file containing shell commands (see [Shell Scripts](https://www.gnu.org/software/bash/manual/bash.html#Shell-Scripts)). When Bash is invoked in this fashion, `$0` is set to the name of the file, and the positional parameters are set to the remaining arguments. Bash reads and executes commands from this file, then exits. Bash’s exit status is the exit status of the last command executed in the script. If no commands are executed, the exit status is 0. \-c 和 \-s是包含 shell 命令的文件的名称（请参阅 [shell 脚本](https://www.gnu.org/software/bash/manual/bash.html#Shell-Scripts)当以这种方式调用 Bash 时，`$0`如果参数在选项处理后仍然存在，并且 选项已提供，则假定第一个参数为 ）。 设置为文件名和位置参数 设置为其余参数。 Bash 从此文件读取并执行命令，然后退出。 Bash 的退出状态是上次执行的命令的退出状态 在脚本中。 如果未执行任何命令，则退出状态为 0。

___

### 6.2 Bash Startup Files6.2 Bash 启动文件

This section describes how Bash executes its startup files. If any of the files exist but cannot be read, Bash reports an error. Tildes are expanded in filenames as described above under Tilde Expansion (see [Tilde Expansion](https://www.gnu.org/software/bash/manual/bash.html#Tilde-Expansion)). 波浪号扩展（请参阅[波浪号扩展](https://www.gnu.org/software/bash/manual/bash.html#Tilde-Expansion)本节介绍 Bash 如何执行其启动文件。 如果存在任何文件但无法读取，Bash 会报告错误。 波浪号在文件名中展开，如上所述 ）。

Interactive shells are described in [Interactive Shells](https://www.gnu.org/software/bash/manual/bash.html#Interactive-Shells). [交互式 shell](https://www.gnu.org/software/bash/manual/bash.html#Interactive-Shells) 中介绍了交互式 shell。

#### Invoked as an interactive login shell, or with \--login作为交互式登录 shell 调用，或使用 \--login 调用

When Bash is invoked as an interactive login shell, or as a non-interactive shell with the \--login option, it first reads and executes commands from the file /etc/profile, if that file exists. After reading that file, it looks for ~/.bash\_profile, ~/.bash\_login, and ~/.profile, in that order, and reads and executes commands from the first one that exists and is readable. The \--noprofile option may be used when the shell is started to inhibit this behavior. 带有 \--login执行文件 /etc/profile读取该文件后，它会查找 ~/.bash\_profile~/.bash\_login 和 ~/.profile当 shell 启动时，可以使用 \--noprofile当 Bash 作为交互式登录 shell 或作为 选项的非交互式 shell，它首先读取 和 （如果该文件存在）中的命令。 ， ，按此顺序，并读取 并从第一个存在且可读的命令执行命令。 选项来执行以下操作： 抑制此行为。

When an interactive login shell exits, or a non-interactive login shell executes the `exit` builtin command, Bash reads and executes commands from the file ~/.bash\_logout, if it exists. 或者非交互式登录 shell 执行 `exit`文件 ~/.bash\_logout当交互式登录 shell 退出时， builtin 命令， Bash 读取和执行来自以下位置的命令 （如果存在）。

#### Invoked as an interactive non-login shell作为交互式非登录 shell 调用

When an interactive shell that is not a login shell is started, Bash reads and executes commands from ~/.bashrc, if that file exists. This may be inhibited by using the \--norc option. The \--rcfile file option will force Bash to read and execute commands from file instead of ~/.bashrc. 读取并执行来自 ~/.bashrc这可以通过使用 \--norc\--rcfile file从file而不是 ~/.bashrc当启动不是登录 shell 的交互式 shell 时，Bash 的命令（如果该文件存在）。 选项来抑制。 将强制 Bash 读取和 执行命令。

So, typically, your ~/.bash\_profile contains the line 因此，通常，您的 ~/.bash\_profile 包含以下行

```
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
```

after (or before) any login-specific initializations. 在（或之前）任何特定于登录名的初始化。

#### Invoked non-interactively以非交互方式调用

When Bash is started non-interactively, to run a shell script, for example, it looks for the variable `BASH_ENV` in the environment, expands its value if it appears there, and uses the expanded value as the name of a file to read and execute. Bash behaves as if the following command were executed: 例如，它在环境中查找变量`BASH_ENV`当 Bash 以非交互方式启动时，要运行 shell 脚本， ， 如果它出现在那里，则扩展其值，并将扩展后的值用作 要读取和执行的文件的名称。 Bash 的行为就像 执行以下命令：

```
if [ -n "$BASH_ENV" ]; then . "$BASH_ENV"; fi
```

but the value of the `PATH` variable is not used to search for the filename. 但 `PATH` 变量的值不用于搜索 文件名。

As noted above, if a non-interactive shell is invoked with the \--login option, Bash attempts to read and execute commands from the login shell startup files. \--login如上所述，如果使用 选项，Bash 尝试从 登录 shell 启动文件。

#### Invoked with name `sh`使用名称 `sh` 调用

If Bash is invoked with the name `sh`, it tries to mimic the startup behavior of historical versions of `sh` as closely as possible, while conforming to the <small>POSIX</small> standard as well. 如果使用名称 `sh``sh`可能，同时也符合 <small>POSIX</small> 调用 Bash，它会尝试模仿 历史版本的启动行为与 标准。

When invoked as an interactive login shell, or as a non-interactive shell with the \--login option, it first attempts to read and execute commands from /etc/profile and ~/.profile, in that order. The \--noprofile option may be used to inhibit this behavior. When invoked as an interactive shell with the name `sh`, Bash looks for the variable `ENV`, expands its value if it is defined, and uses the expanded value as the name of a file to read and execute. Since a shell invoked as `sh` does not attempt to read and execute commands from any other startup files, the \--rcfile option has no effect. A non-interactive shell invoked with the name `sh` does not attempt to read any other startup files. shell 和 \--login并执行来自 /etc/profile 和 ~/.profile\--noprofile当作为名为 `sh`查找变量 `ENV`由于作为 `sh`来自任何其他启动文件的命令，\--rcfile使用名称 `sh`作为交互式登录 shell 或非交互式登录 shell 调用时 选项，它首先尝试读取 的命令，在 那个顺序。 选项可用于禁止此行为。 的交互式 shell 调用时，Bash ，如果定义了，则扩展其值， 并使用扩展值作为要读取和执行的文件的名称。 调用的 shell 不会尝试读取和执行 选项具有 没有效果。 调用的非交互式 shell 不会尝试 读取任何其他启动文件。

When invoked as `sh`, Bash enters <small>POSIX</small> mode after the startup files are read. 当作为 `sh` 调用时，Bash 在 将读取启动文件。

#### Invoked in <small>POSIX</small> mode在 <small>POSIX</small> 模式下调用

When Bash is started in <small>POSIX</small> mode, as with the \--posix command line option, it follows the <small>POSIX</small> standard for startup files. In this mode, interactive shells expand the `ENV` variable and commands are read and executed from the file whose name is the expanded value. No other startup files are read. 当 Bash 在 <small>POSIX</small>\--posix 命令行选项，它遵循 <small>POSIX</small>在此模式下，交互式 shell 会扩展 `ENV` 模式下启动时，就像 标准 用于启动文件。 变量 命令是从名称为 扩展值。 不会读取其他启动文件。

#### Invoked by remote shell daemon由远程 shell 守护程序调用

Bash attempts to determine when it is being run with its standard input connected to a network connection, as when executed by the historical remote shell daemon, usually `rshd`, or the secure shell daemon `sshd`. If Bash determines it is being run non-interactively in this fashion, it reads and executes commands from ~/.bashrc, if that file exists and is readable. It will not do this if invoked as `sh`. The \--norc option may be used to inhibit this behavior, and the \--rcfile option may be used to force another file to be read, but neither `rshd` nor `sshd` generally invoke the shell with those options or allow them to be specified. 历史上的远程 Shell 守护进程，通常是 `rshd`或安全 shell 守护程序 `sshd`它读取并执行来自 ~/.bashrc如果作为 `sh`\--norc\--rcfile`rshd` 和 `sshd`Bash 尝试确定何时使用其标准输入运行它 连接到网络连接，如执行时 ， 。 如果 Bash 确定它以这种方式以非交互方式运行， 的命令，如果那样的话 文件存在并且可读。 调用，则不会执行此操作。 选项可用于抑制此行为，并且 选项可用于强制读取另一个文件，但 通常都不会使用这些 选项或允许指定它们。

#### Invoked with unequal effective and real <small>UID/GID</small>s使用不相等的有效和真实 <small>UID/GID</small>调用

If Bash is started with the effective user (group) id not equal to the real user (group) id, and the \-p option is not supplied, no startup files are read, shell functions are not inherited from the environment, the `SHELLOPTS`, `BASHOPTS`, `CDPATH`, and `GLOBIGNORE` variables, if they appear in the environment, are ignored, and the effective user id is set to the real user id. If the \-p option is supplied at invocation, the startup behavior is the same, but the effective user id is not reset. 真实用户（组）ID，且未提供 \-p`SHELLOPTS`、`BASHOPTS``CDPATH` 和 `GLOBIGNORE`如果在调用时提供 \-p如果 Bash 的有效用户（组）ID 不等于 选项，不启动 文件是读取的，shell 函数不是从环境中继承的， 变量，如果它们出现在环境中，则被忽略，并且有效的 用户 ID 设置为真实用户 ID。 选项，则启动行为为 相同，但不会重置有效用户 ID。

___

### 6.3 Interactive Shells6.3 交互式shell

-   [What is an Interactive Shell?什么是交互式 Shell？](https://www.gnu.org/software/bash/manual/bash.html#What-is-an-Interactive-Shell_003f)
-   [Is this Shell Interactive?这是 Shell 交互式的吗？](https://www.gnu.org/software/bash/manual/bash.html#Is-this-Shell-Interactive_003f)
-   [Interactive Shell Behavior交互式 Shell 行为](https://www.gnu.org/software/bash/manual/bash.html#Interactive-Shell-Behavior)

___

#### 6.3.1 What is an Interactive Shell?6.3.1 什么是交互式 Shell？

An interactive shell is one started without non-option arguments (unless \-s is specified) and without specifying the \-c option, whose input and error output are both connected to terminals (as determined by `isatty(3)`), or one started with the \-i option. （除非指定\-s并且在不指定 \-c连接到终端（由 `isatty(3)`或者以 \-i交互式shell 是一个没有非选项参数的开始 ） 选项的情况下， 其输入和错误输出都是 确定）， 选项开头。

An interactive shell generally reads from and writes to a user’s terminal. 交互式 shell 通常读取和写入用户的 终端。

The \-s invocation option may be used to set the positional parameters when an interactive shell is started. \-s 调用选项可用于设置位置参数 当交互式 shell 启动时。

___

#### 6.3.2 Is this Shell Interactive?6.3.2 这个 Shell 是交互式的吗？

To determine within a startup script whether or not Bash is running interactively, test the value of the ‘\-’ special parameter. It contains `i` when the shell is interactive. For example: 测试“\-当 shell 是交互式的时，它包含 `i`在启动脚本中确定 Bash 是否是 交互式运行， ”特殊参数的值。 。 例如：

```
case "$-" in
*i*)echo This shell is interactive ;;
*)echo This shell is not interactive ;;
esac
```

Alternatively, startup scripts may examine the variable `PS1`; it is unset in non-interactive shells, and set in interactive shells. Thus: `PS1`或者，启动脚本可以检查变量 ;它在非交互式 shell 中未设置，并设置在 交互式 shell。 因此：

```
if [ -z "$PS1" ]; then
        echo This shell is not interactive
else
        echo This shell is interactive
fi
```

___

#### 6.3.3 Interactive Shell Behavior6.3.3 交互式 Shell 行为

When the shell is running interactively, it changes its behavior in several ways. 当 shell 以交互方式运行时，它会在 几种方式。

1.  Startup files are read and executed as described in [Bash Startup Files](https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files). 按照 [Bash 启动文件中](https://www.gnu.org/software/bash/manual/bash.html#Bash-Startup-Files)的说明读取和执行启动文件。
2.  Job Control (see [Job Control](https://www.gnu.org/software/bash/manual/bash.html#Job-Control)) is enabled by default. When job control is in effect, Bash ignores the keyboard-generated job control signals `SIGTTIN`, `SIGTTOU`, and `SIGTSTP`. 默认情况下，作业控制（请参阅[作业控制](https://www.gnu.org/software/bash/manual/bash.html#Job-Control)`SIGTTIN``SIGTTOU` 和 `SIGTSTP`）处于启用状态。 当工作 控件生效，Bash 忽略键盘生成的作业控件 。
3.  Bash expands and displays `PS1` before reading the first line of a command, and expands and displays `PS2` before reading the second and subsequent lines of a multi-line command. Bash expands and displays `PS0` after it reads a command but before executing it. See [Controlling the Prompt](https://www.gnu.org/software/bash/manual/bash.html#Controlling-the-Prompt), for a complete list of prompt string escape sequences. Bash 在读取第一行之前展开并显示 `PS1`的命令`PS2`Bash 在读取命令后但在读取命令之前展开并显示 `PS0`有关提示的完整列表，请参阅[控制提示](https://www.gnu.org/software/bash/manual/bash.html#Controlling-the-Prompt) 多行命令的第二行和后续行。 执行它。 字符串转义序列。
4.  Bash executes the values of the set elements of the `PROMPT_COMMAND` array variable as commands before printing the primary prompt, `$PS1` (see [Bash Variables](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables)). Bash 执行 `PROMPT_COMMAND`数组变量作为打印主提示符之前的命令，`$PS1`（请参阅 [Bash 变量](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables) 的 set 元素的值 ）。
5.  Readline (see [Command Line Editing](https://www.gnu.org/software/bash/manual/bash.html#Command-Line-Editing)) is used to read commands from the user’s terminal. Readline（请参阅[命令行编辑](https://www.gnu.org/software/bash/manual/bash.html#Command-Line-Editing)）用于从中读取命令 用户的终端。
6.  Bash inspects the value of the `ignoreeof` option to `set -o` instead of exiting immediately when it receives an `EOF` on its standard input when reading a command (see [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)). Bash 检查 `ignoreeof` 选项的值以`set -o`而不是在其上收到 `EOF`读取命令时的标准输入（请参阅[内置设置](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin) 时立即退出 ）。
7.  Command history (see [Bash History Facilities](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Facilities)) and history expansion (see [History Expansion](https://www.gnu.org/software/bash/manual/bash.html#History-Interaction)) are enabled by default. Bash will save the command history to the file named by `$HISTFILE` when a shell with history enabled exits. 命令历史记录（请参阅 [Bash 历史记录工具](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Facilities)和历史扩展（请参阅[历史扩展](https://www.gnu.org/software/bash/manual/bash.html#History-Interaction)Bash 会将命令历史记录保存到 `$HISTFILE`） ） 默认情况下处于启用状态。 命名的文件中 当启用了历史记录的 shell 退出时。
8.  Alias expansion (see [Aliases](https://www.gnu.org/software/bash/manual/bash.html#Aliases)) is performed by default. 默认情况下执行别名扩展（请参阅[别名](https://www.gnu.org/software/bash/manual/bash.html#Aliases)）。
9.  In the absence of any traps, Bash ignores `SIGTERM` (see [Signals](https://www.gnu.org/software/bash/manual/bash.html#Signals)). 在没有任何陷阱的情况下，Bash 会忽略 `SIGTERM`（见[信号](https://www.gnu.org/software/bash/manual/bash.html#Signals) ）。
10.  In the absence of any traps, `SIGINT` is caught and handled (see [Signals](https://www.gnu.org/software/bash/manual/bash.html#Signals)). `SIGINT` will interrupt some shell builtins. 在没有任何陷阱的情况下，`SIGINT`（见[信号](https://www.gnu.org/software/bash/manual/bash.html#Signals)`SIGINT` 被捕获并处理 ）。 将中断某些 shell 内置函数。
11.  An interactive login shell sends a `SIGHUP` to all jobs on exit if the `huponexit` shell option has been enabled (see [Signals](https://www.gnu.org/software/bash/manual/bash.html#Signals)). 交互式登录 shell 在退出时向所有作业发送 `SIGHUP`如果已启用 `huponexit` shell 选项（请参阅[信号](https://www.gnu.org/software/bash/manual/bash.html#Signals) ）。
12.  The \-n invocation option is ignored, and ‘set -n’ has no effect (see [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)). \-n 调用选项，并且 'set -n没有效果（参见[内置套装](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)' 具有 ）。
13.  Bash will check for mail periodically, depending on the values of the `MAIL`, `MAILPATH`, and `MAILCHECK` shell variables (see [Bash Variables](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables)). `MAIL``MAILPATH` 和 `MAILCHECK`（请参阅 [Bash 变量](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables)Bash 将定期检查邮件，具体取决于 shell 变量 ）。
14.  Expansion errors due to references to unbound shell variables after ‘set -u’ has been enabled will not cause the shell to exit (see [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)). 已启用“set -u（请参阅[内置设置](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)由于引用未绑定的 shell 变量而导致的扩展错误 ”不会导致 shell 退出 ）。
15.  The shell will not exit on expansion errors caused by var being unset or null in `${var:?word}` expansions (see [Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)). 由于 var或 ${var：？word（请参阅 [Shell 参数扩展](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion) 未设置导致的扩展错误，shell 不会退出 } 扩展 ）。
16.  Redirection errors encountered by shell builtins will not cause the shell to exit. shell 内置遇到重定向错误不会导致 shell 退出。
17.  When running in <small>POSIX</small> mode, a special builtin returning an error status will not cause the shell to exit (see [Bash POSIX Mode](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)). 在 <small>POSIX</small>status 不会导致 shell 退出（请参阅 [Bash POSIX 模式](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode) 模式下运行时，特殊的内置函数返回错误 ）。
18.  A failed `exec` will not cause the shell to exit (see [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)). 失败的 `exec`（请参阅 [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins) 不会导致 shell 退出 ）。
19.  Parser syntax errors will not cause the shell to exit. 解析器语法错误不会导致 shell 退出。
20.  If the `cdspell` shell option is enabled, the shell will attempt simple spelling correction for directory arguments to the `cd` builtin (see the description of the `cdspell` option to the `shopt` builtin in [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)). The `cdspell` option is only effective in interactive shells. 如果启用了 `cdspell``cd`内置（参见 `cdspell`[选项到 The Shopt Builtin 中的 shopt builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)）。`cdspell` shell 选项，则 shell 将尝试 的目录参数进行简单拼写更正 的说明 选项仅在交互式 shell 中有效。
21.  The shell will check the value of the `TMOUT` variable and exit if a command is not read within the specified number of seconds after printing `$PS1` (see [Bash Variables](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables)). shell 将检查 `TMOUT`打印 `$PS1`（请参阅 [Bash 变量](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables) 变量的值并退出 如果命令在指定的秒数内未读取 ）。

___

### 6.4 Bash Conditional Expressions6.4 Bash 条件表达式

Conditional expressions are used by the `[[` compound command (see [Conditional Constructs](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)) and the `test` and `[` builtin commands (see [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)). The `test` and `[` commands determine their behavior based on the number of arguments; see the descriptions of those commands for any other command-specific actions. 条件表达式由 `[[`（请参阅[条件结构](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)以及 `test` 和 `[`（请参阅 [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)`test``[` compound 命令使用 ） 内置命令 ）。 命令根据数字确定其行为 的论点;有关任何其他命令，请参阅这些命令的说明 特定于命令的操作。

Expressions may be unary or binary, and are formed from the following primaries. Unary expressions are often used to examine the status of a file. There are string operators and numeric comparison operators as well. Bash handles several filenames specially when they are used in expressions. If the operating system on which Bash is running provides these special files, Bash will use them; otherwise it will emulate them internally with this behavior: If the file argument to one of the primaries is of the form /dev/fd/N, then file descriptor N is checked. If the file argument to one of the primaries is one of /dev/stdin, /dev/stdout, or /dev/stderr, file descriptor 0, 1, or 2, respectively, is checked. 如果其中一个主节点file/dev/fd/N，则选中文件描述符 N如果其中一个主节点file/dev/stdin、/dev/stdout 或 /dev/stderr表达式可以是一元的，也可以是二元的， 并由以下初选组成。 一元表达式通常用于检查文件的状态。 还有字符串运算符和数值比较运算符。 Bash 专门处理多个文件名，当它们在 表达 式。 如果运行 Bash 的操作系统提供以下 特殊文件，Bash 会使用它们;否则它会模仿它们 在内部具有以下行为： 参数的格式为 。 参数是 文件 分别检查描述符 0、1 或 2。

When used with `[[`, the ‘<’ and ‘\>’ operators sort lexicographically using the current locale. The `test` command uses ASCII ordering. 当与 `[[` 一起使用时，“<”和“\>`test`”运算符排序 使用当前区域设置的词典。 命令使用 ASCII 排序。

Unless otherwise specified, primaries that operate on files follow symbolic links and operate on the target of the link, rather than the link itself. 除非另有说明，否则对文件进行操作的主数据库遵循符号 链接，并在链接的目标上进行操作，而不是对链接本身进行操作。

`-a file`\-file

True if file exists. 如果file存在，则为 True。

`-b file`\-b file

True if file exists and is a block special file. 如果 file 存在并且是块特殊文件，则为 true。

`-c file`\-c file

True if file exists and is a character special file. 如果 file 存在并且是字符特殊文件，则为 true。

`-d file`\-d file

True if file exists and is a directory. 如果 file 存在并且是目录，则为 true。

`-e file`\-e file

True if file exists. 如果file存在，则为 True。

`-f file`\-f file

True if file exists and is a regular file. 如果file存在并且是常规文件，则为 True。

`-g file`\-g file

True if file exists and its set-group-id bit is set. 如果file存在且设置了其 set-group-id 位，则为 true。

`-h file`\-h file

True if file exists and is a symbolic link. 如果file存在并且是符号链接，则为 True。

`-k file`\-k file

True if file exists and its "sticky" bit is set. 如果file存在并且设置了其“粘性”位，则为 True。

`-p file`\-p file

True if file exists and is a named pipe (FIFO). 如果file存在并且是命名管道 （FIFO），则为 True。

`-r file`\-r file

True if file exists and is readable. 如果file存在且可读，则为 True。

`-s file`\-s file

True if file exists and has a size greater than zero. 如果file存在且大小大于零，则为 True。

`-t fd`\-t fd

True if file descriptor fd is open and refers to a terminal. 如果文件描述符 fd 处于打开状态并引用终端，则为 true。

`-u file`\-u file

True if file exists and its set-user-id bit is set. 如果file存在且设置了其 set-user-id 位，则为 true。

`-w file`\-w file

True if file exists and is writable. 如果file存在且可写，则为 True。

`-x file`\-x file

True if file exists and is executable. 如果文件存在且可执行file则为 True。

`-G file`\-G file

True if file exists and is owned by the effective group id. 如果file存在且由有效组 ID 拥有，则为 True。

`-L file`\-L file

True if file exists and is a symbolic link. 如果file存在并且是符号链接，则为 True。

`-N file`\-N file

True if file exists and has been modified since it was last read. 如果file存在并且自上次读取以来已被修改，则为 True。

`-O file`\-O file

True if file exists and is owned by the effective user id. 如果file存在且由有效用户 ID 拥有，则为 True。

`-S file`\-S file

True if file exists and is a socket. 如果 file 存在并且是套接字，则为 true。

`file1 -ef file2`file1 -ef file2

True if file1 and file2 refer to the same device and inode numbers. 如果 file1 和 file2 引用同一设备，并且 inode 编号。

`file1 -nt file2`file1 -nt file2

True if file1 is newer (according to modification date) than file2, or if file1 exists and file2 does not. 如果 file1比 file2，或者如果 file1 存在而 file2 较新（根据修改日期），则为 True（根据修改日期） 不存在。

`file1 -ot file2`file1 -ot file2

True if file1 is older than file2, or if file2 exists and file1 does not. 如果 file1 早于 file2或者如果 file2 存在而 file1，则为 true， 不存在。

`-o optname`\-o optname

True if the shell option optname is enabled. The list of options appears in the description of the \-o option to the `set` builtin (see [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)). 如果启用了 shell 选项 optname选项列表显示在 \-o选项设置为内置`set`（请参阅[内置设置](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)，则为 True。 的描述中 ）。

`-v varname`\-v varname

True if the shell variable varname is set (has been assigned a value). 如果设置了 shell 变量 varname（已分配值），则为 true。

`-R varname`\-R varname

True if the shell variable varname is set and is a name reference. 如果设置了 shell 变量 varname 并且是名称引用，则为 true。

`-z string`\-z string

True if the length of string is zero. 如果string的长度为零，则为 true。

`-n string`\-n string

`string`

True if the length of string is non-zero. 如果string的长度不为零，则为 True。

`string1 == string2`string1 == string2

`string1 = string2`string1 = string2

True if the strings are equal. When used with the `[[` command, this performs pattern matching as described above (see [Conditional Constructs](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)). 当与 `[[`如上所述（参见[条件结构](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)如果字符串相等，则为 True。 命令一起使用时，这会将模式匹配执行为 ）。

‘\=’ should be used with the `test` command for <small>POSIX</small> conformance. '\=' 应与 <small>POSIX</small> 一致性`test`命令一起使用。

`string1 != string2`string1 ！= string2

True if the strings are not equal. 如果字符串不相等，则为 True。

`string1 < string2`string1 < string2

True if string1 sorts before string2 lexicographically. 如果 string1 按字典顺序排序在 string2 之前，则为 true。

`string1 > string2`string1 > string2

True if string1 sorts after string2 lexicographically. 如果 string1 按字典顺序排序在 string2 之后，则为 true。

`arg1 OP arg2`arg1在 arg2

`OP` is one of ‘\-eq’, ‘\-ne’, ‘\-lt’, ‘\-le’, ‘\-gt’, or ‘\-ge’. These arithmetic binary operators return true if arg1 is equal to, not equal to, less than, less than or equal to, greater than, or greater than or equal to arg2, respectively. Arg1 and arg2 may be positive or negative integers. When used with the `[[` command, Arg1 and Arg2 are evaluated as arithmetic expressions (see [Shell Arithmetic](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)). `OP`'\-eq'、'\-ne'、'\-lt'、'\-le'、'\-gt' 或 '\-ge如果 arg1大于或大于或等arg2分别。 Arg1 和 arg2当与 `[[` 命令一起使用时，Arg1 和 Arg2计算为算术表达式（请参阅[壳牌算术](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic) 是其中之一 '。 则这些算术二进制运算符返回 true 等于、不等于、小于、小于或等于 ， 可以是正整数或负整数。 ）。

___

### 6.5 Shell Arithmetic6.5 壳牌算术

The shell allows arithmetic expressions to be evaluated, as one of the shell expansions or by using the `((` compound command, the `let` builtin, or the \-i option to the `declare` builtin. shell 扩展或使用 `((``let` builtin，或`declare` builtin 的 \-ishell 允许计算算术表达式，作为 复合命令， 选项。

Evaluation is done in fixed-width integers with no check for overflow, though division by 0 is trapped and flagged as an error. The operators and their precedence, associativity, and values are the same as in the C language. The following list of operators is grouped into levels of equal-precedence operators. The levels are listed in order of decreasing precedence. 评估以固定宽度的整数完成，不检查溢出， 尽管除以 0 被捕获并标记为错误。 运算符及其优先级、关联性和值 与 C 语言相同。 以下运算符列表分为以下级别 等优先级运算符。 这些级别按优先级递减的顺序列出。

`id++ id--`id++ id\--

variable post-increment and post-decrement 可变后递增和后递减

`++id --id`++id --id

variable pre-increment and pre-decrement 可变的预增量和预递减量

`- +`

unary minus and plus 一元减号和加号

`! ~`

logical and bitwise negation 逻辑和按位否定

`**`

exponentiation 幂

`* / %`

multiplication, division, remainder 乘法、除法、余数

`+ -`

addition, subtraction 加法、减法

`<< >>`

left and right bitwise shifts 左移位和右位移

`<= >= < >`

comparison 比较

`== !=`

equality and inequality 平等与不平等

`&`

bitwise AND 按位和

`^`

bitwise exclusive OR 按位独占 OR

`|`

bitwise OR 按位或

`&&`

logical AND 逻辑和

`||`

logical OR 逻辑 OR

`expr ? expr : expr`

conditional operator 条件运算符

`= *= /= %= += -= <<= >>= &= ^= |=`

assignment 分配

`expr1 , expr2`

comma 逗点

Shell variables are allowed as operands; parameter expansion is performed before the expression is evaluated. Within an expression, shell variables may also be referenced by name without using the parameter expansion syntax. A shell variable that is null or unset evaluates to 0 when referenced by name without using the parameter expansion syntax. The value of a variable is evaluated as an arithmetic expression when it is referenced, or when a variable which has been given the `integer` attribute using ‘declare -i’ is assigned a value. A null value evaluates to 0. A shell variable need not have its `integer` attribute turned on to be used in an expression. 使用 'declare -i' 的`integer`shell 变量不需要打开其`integer`允许将 shell 变量用作操作数;参数扩展为 在计算表达式之前执行。 在表达式中，也可以按名称引用 shell 变量 不使用参数扩展语法。 引用时为 null 或未设置的 shell 变量的计算结果为 0 按名称，而不使用参数扩展语法。 变量的值计算为算术表达式 当它被引用时，或者当一个变量被赋予 属性被分配一个值。 null 值的计算结果为 0。 属性 用于表达式。

Integer constants follow the C language definition, without suffixes or character constants. Constants with a leading 0 are interpreted as octal numbers. A leading ‘0x’ or ‘0X’ denotes hexadecimal. Otherwise, numbers take the form \[base`#`\]n, where the optional base is a decimal number between 2 and 64 representing the arithmetic base, and n is a number in that base. If base`#` is omitted, then base 10 is used. When specifying n, if a non-digit is required, the digits greater than 9 are represented by the lowercase letters, the uppercase letters, ‘@’, and ‘\_’, in that order. If base is less than or equal to 36, lowercase and uppercase letters may be used interchangeably to represent numbers between 10 and 35. 前导“0x”或“0X数字采用 \[base`#`\]n 的形式，其中可选basen如果省略 base`#`指定 n大写字母“@”和“\_如果 base整数常量遵循 C 语言定义，不带后缀或 字符常量。 前导为 0 的常量被解释为八进制数。 ”表示十六进制。 否则 是介于 2 和 64 之间的十进制数，表示算术 是该基数中的数字。 ，则使用 base 10。 时， 如果需要非数字， 大于 9 的数字用小写字母表示， ”按此顺序排列。 小于或等于 36，则小写和大写 字母可以互换使用来表示 10 之间的数字 和 35.

Operators are evaluated in order of precedence. Sub-expressions in parentheses are evaluated first and may override the precedence rules above. 运算符按优先级顺序进行评估。 中的子表达式 括号首先计算，并可能覆盖优先级 上面的规则。

___

### 6.6 Aliases6.6 别名

_Aliases_ allow a string to be substituted for a word when it is used as the first word of a simple command. The shell maintains a list of aliases that may be set and unset with the `alias` and `unalias` builtin commands. _别名_`alias` 和 `unalias`允许在使用字符串时替换单词 作为简单命令的第一个单词。 shell 维护一个可以设置和取消设置的别名列表 内置命令。

The first word of each simple command, if unquoted, is checked to see if it has an alias. If so, that word is replaced by the text of the alias. The characters ‘/’, ‘$’, ‘\`’, ‘\=’ and any of the shell metacharacters or quoting characters listed above may not appear in an alias name. The replacement text may contain any valid shell input, including shell metacharacters. The first word of the replacement text is tested for aliases, but a word that is identical to an alias being expanded is not expanded a second time. This means that one may alias `ls` to `"ls -F"`, for instance, and Bash does not try to recursively expand the replacement text. If the last character of the alias value is a `blank`, then the next command word following the alias is also checked for alias expansion. 字符 '/'、'$'、'\`'、'\=这意味着可以将 `ls` 别名为`"ls -F"``blank`每个简单命令的第一个单词（如果未加引号）将进行检查以查看 如果它有别名。 如果是这样，则该单词将替换为别名的文本。 ' 和任何 上面列出的 shell 元字符或引用字符可能不会出现 在别名中。 替换文本可包含任何有效的 shell 输入，包括 shell 元字符。 测试替换文本的第一个单词 别名，但与正在扩展的别名相同的单词 不会第二次扩展。 ， 例如，Bash 不会尝试递归地扩展 替换文本。 如果别名值的最后一个字符是 ，然后是 还会检查别名的别名扩展。

Aliases are created and listed with the `alias` command, and removed with the `unalias` command. 将创建别名并与`alias`命令，并使用 `unalias`一起列出 命令删除。

There is no mechanism for using arguments in the replacement text, as in `csh`. If arguments are needed, use a shell function (see [Shell Functions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Functions)). 就像`csh`（请参阅 [Shell 函数](https://www.gnu.org/software/bash/manual/bash.html#Shell-Functions)没有在替换文本中使用参数的机制， 中一样。 如果需要参数，请使用 shell 函数 ）。

Aliases are not expanded when the shell is not interactive, unless the `expand_aliases` shell option is set using `shopt` (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)). 除非使用 `expand_aliases``shopt`（参见 [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)当 shell 不是交互式的时，别名不会展开， shell 选项设置 ）。

The rules concerning the definition and use of aliases are somewhat confusing. Bash always reads at least one complete line of input, and all lines that make up a compound command, before executing any of the commands on that line or the compound command. Aliases are expanded when a command is read, not when it is executed. Therefore, an alias definition appearing on the same line as another command does not take effect until the next line of input is read. The commands following the alias definition on that line are not affected by the new alias. This behavior is also an issue when functions are executed. Aliases are expanded when a function definition is read, not when the function is executed, because a function definition is itself a command. As a consequence, aliases defined in a function are not available until after that function is executed. To be safe, always put alias definitions on a separate line, and do not use `alias` in compound commands. 别名定义在单独的行上，并且不要使用`alias`有关别名定义和使用的规则是 有点令人困惑。巴什 始终读取至少一行完整的输入， 以及构成复合命令的所有行， 在执行该行上的任何命令或复合命令之前。 当 命令是读取的，而不是在执行时读取的。 因此，一个 别名定义与另一个别名定义出现在同一行 命令在读取下一行输入之前不会生效。 别名定义后面的命令 在该行上不受新别名的影响。 执行函数时，此行为也是一个问题。 读取函数定义时，别名会展开， 不是在执行函数时，因为函数定义 本身就是一个命令。 因此，别名 在函数中定义，直到之后才可用 函数被执行。 为了安全起见，始终把 在复合命令中。

For almost every purpose, shell functions are preferred over aliases. 对于几乎所有用途，shell 函数都比别名更受欢迎。

___

### 6.7 Arrays6.7 数组

Bash provides one-dimensional indexed and associative array variables. Any variable may be used as an indexed array; the `declare` builtin will explicitly declare an array. There is no maximum limit on the size of an array, nor any requirement that members be indexed or assigned contiguously. Indexed arrays are referenced using integers (including arithmetic expressions (see [Shell Arithmetic](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic))) and are zero-based; associative arrays use arbitrary strings. Unless otherwise noted, indexed array indices must be non-negative integers. `declare`表达式（参见 [Shell 算术](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)Bash 提供一维索引和关联数组变量。 任何变量都可以用作索引数组; builtin 将显式声明一个数组。 没有最大值 对数组大小的限制，也不要求成员 被索引或连续分配。 索引数组使用整数（包括算术）引用 ）），并且从零开始; 关联数组使用任意字符串。 除非另有说明，否则索引数组索引必须是非负整数。

An indexed array is created automatically if any variable is assigned to using the syntax 如果将任何变量分配给 使用语法

The subscript is treated as an arithmetic expression that must evaluate to a number. To explicitly declare an array, use subscript 被视为必须计算为数字的算术表达式。 若要显式声明数组，请使用

The syntax 语法

```
declare -a name[subscript]
```

is also accepted; the subscript is ignored. 也被接受;subscript将被忽略。

Associative arrays are created using 关联数组是使用

Attributes may be specified for an array variable using the `declare` and `readonly` builtins. Each attribute applies to all members of an array. 使用 `declare``readonly`属性可以是 和 内置。 每个属性都适用于 一个数组。

Arrays are assigned to using compound assignments of the form 数组被赋值为使用以下形式的复合赋值

where each value may be of the form `[subscript]=`string. Indexed array assignments do not require anything but string. When assigning to indexed arrays, if the optional subscript is supplied, that index is assigned to; otherwise the index of the element assigned is the last index assigned to by the statement plus one. Indexing starts at zero. value 的格式可以是 \[subscript\]=string索引数组赋值除了string其中每个 。 外不需要任何内容。 分配给索引数组时，如果 提供可选的下标，该索引被分配给; 否则，分配的元素的索引是上次分配的索引 到语句加一。 索引从零开始。

Each value in the list undergoes all the shell expansions described above (see [Shell Expansions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Expansions)). 列表中的每个value如上所述（请参阅 [Shell 扩展](https://www.gnu.org/software/bash/manual/bash.html#Shell-Expansions)都会经历所有 shell 扩展 ）。

When assigning to an associative array, the words in a compound assignment may be either assignment statements, for which the subscript is required, or a list of words that is interpreted as a sequence of alternating keys and values: name\=(key1 value1 key2 value2 … ). These are treated identically to name\=( \[key1\]=value1 \[key2\]=value2 … ). The first word in the list determines how the remaining words are interpreted; all assignments in a list must be of the same type. When using key/value pairs, the keys may not be missing or empty; a final missing value is treated like the empty string. name\=（key1value1key2value2name\=（ \[key1\]=value1 \[key2\]=value2赋值到关联数组时，复合赋值中的单词 可以是赋值语句，其中下标是必需的， 或被解释为交替键序列的单词列表 和价值观： ... ）。 这些的处理方式与 ... ）。 列表中的第一个单词决定了其余单词的处理方式 被解释;列表中的所有分配必须属于同一类型。 使用键/值对时，键可能不会丢失或为空; 最终缺失值被视为空字符串。

This syntax is also accepted by the `declare` builtin. Individual array elements may be assigned to using the `name[subscript]=value` syntax introduced above. 此语法也被`declare`name\[subscript\]=上面介绍value接受 内置。 单个数组元素可以分配给使用 语法。

When assigning to an indexed array, if name is subscripted by a negative number, that number is interpreted as relative to one greater than the maximum index of name, so negative indices count back from the end of the array, and an index of -1 references the last element. 分配给索引数组时，如果namename 由负数下标，该数字为 解释为相对于大于 1 的最大索引 ，因此负索引从末尾开始计数 数组，索引 -1 引用最后一个元素。

The ‘+=’ operator will append to an array variable when assigning using the compound assignment syntax; see [Shell Parameters](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameters) above. 赋值时，“+=使用复合赋值语法;请参阅上面[的 Shell 参数](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameters)”运算符将追加到数组变量 。

Any element of an array may be referenced using `${name[subscript]}`. The braces are required to avoid conflicts with the shell’s filename expansion operators. If the subscript is ‘@’ or ‘\*’, the word expands to all members of the array name. These subscripts differ only when the word appears within double quotes. If the word is double-quoted, `${name[*]}` expands to a single word with the value of each array member separated by the first character of the `IFS` variable, and `${name[@]}` expands each element of name to a separate word. When there are no array members, `${name[@]}` expands to nothing. If the double-quoted expansion occurs within a word, the expansion of the first parameter is joined with the beginning part of the original word, and the expansion of the last parameter is joined with the last part of the original word. This is analogous to the expansion of the special parameters ‘@’ and ‘\*’. `${#name[subscript]}` expands to the length of `${name[subscript]}`. If subscript is ‘@’ or ‘\*’, the expansion is the number of elements in the array. If the subscript used to reference an element of an indexed array evaluates to a number less than zero, it is interpreted as relative to one greater than the maximum index of the array, so negative indices count back from the end of the array, and an index of -1 refers to the last element. ${name\[subscriptsubscript为“@”或“\*数组name${name`IFS` 变量，${namename${name特殊参数“@”和“\*${#name\[subscript${name\[subscript如果subscript为“@'\*如果subscript数组的任何元素都可以使用 \]}。 需要避免使用牙套 与 shell 的文件名扩展运算符冲突。 如果 ”，该词扩展到所有成员 。 这些下标仅在单词 显示在双引号内。 如果单词是双引号， \[\*\]} 扩展为单个单词 每个数组成员的值，用 \[@\]} 扩展 添加到单独的单词中。 当没有数组成员时， \[@\]} 展开为无。 如果双引号展开发生在一个单词内，则 第一个参数与原始参数的开头部分连接 word，最后一个参数的扩展与最后一个参数连接 原词的一部分。 这类似于 ”的扩展。 \]} 扩展为 \]}。 ”或 '，展开是数组中的元素数。 用于引用索引数组的元素 计算结果为小于零的数字，它是 解释为相对于大于数组最大索引的 1， 所以负索引从数组的末尾开始计数， 索引 -1 表示最后一个元素。

Referencing an array variable without a subscript is equivalent to referencing with a subscript of 0. Any reference to a variable using a valid subscript is legal, and `bash` will create an array if necessary. 如有必要，`bash`引用没有下标的数组变量等效于 引用下标为 0。 使用有效下标对变量的任何引用都是合法的，并且 将创建一个数组。

An array variable is considered set if a subscript has been assigned a value. The null string is a valid value. 如果已为下标分配了 价值。 null 字符串是有效值。

It is possible to obtain the keys (indices) of an array as well as the values. ${!name\[@\]} and ${!name\[\*\]} expand to the indices assigned in array variable name. The treatment when in double quotes is similar to the expansion of the special parameters ‘@’ and ‘\*’ within double quotes. ${!name\[@\]} 和 ${！name在数组变量name双引号内的特殊参数“@”和“\*可以获取数组的键（索引）以及值。 \[\*\]} 展开到索引 中分配。 双引号中的处理类似于 ”。

The `unset` builtin is used to destroy arrays. `unset name[subscript]` destroys the array element at index subscript. Negative subscripts to indexed arrays are interpreted as described above. Unsetting the last element of an array variable does not unset the variable. `unset name`, where name is an array, removes the entire array. `unset name[subscript]` behaves differently depending on the array type when given a subscript of ‘\*’ or ‘@’. When name is an associative array, it removes the element with key ‘\*’ or ‘@’. If name is an indexed array, `unset` removes all of the elements, but does not remove the array itself. `unset`unset name\[subscript销毁索引subscriptunset name，其中 nameunset name\[subscript'\*' 或 @当 name'\*' 或 '@如果 name 是索引数组，`unset`的内置用于销毁数组。 \] 处的数组元素。 索引数组的负下标解释如上所述。 取消设置数组变量的最后一个元素不会取消设置该变量。 是一个数组，删除 整个数组。 \] 行为不同 取决于数组类型，当给定 ' 的下标。 是关联数组时，它会删除带有键的元素 '。 会删除所有元素， 但不会删除数组本身。

When using a variable name with a subscript as an argument to a command, such as with `unset`, without using the word expansion syntax described above, the argument is subject to the shell’s filename expansion. If filename expansion is not desired, the argument should be quoted. 例如`unset`使用带有下标的变量名称作为命令的参数时， ，而不使用单词 expansion 语法 如上所述，该参数受制于 shell 的文件名扩展。 如果不需要文件名扩展，则应引用该参数。

The `declare`, `local`, and `readonly` builtins each accept a \-a option to specify an indexed array and a \-A option to specify an associative array. If both options are supplied, \-A takes precedence. The `read` builtin accepts a \-a option to assign a list of words read from the standard input to an array, and can read values from the standard input into individual array elements. The `set` and `declare` builtins display array values in a way that allows them to be reused as input. `declare`、`local` 和 `readonly`每个内置函数都接受一个 \-aarray 和 \-A如果同时提供这两个选项，\-A`read`内置接受 \-a单个数组元素。 `set` 和 `declare` 选项来指定索引 选项来指定关联数组。 优先。 用于分配从标准输入中读取的单词列表的选项 添加到数组中，并且可以将值从标准输入中读取到 内置函数以允许它们的方式显示数组值 重用为输入。

___

### 6.8 The Directory Stack6.8 目录堆栈

The directory stack is a list of recently-visited directories. The `pushd` builtin adds directories to the stack as it changes the current directory, and the `popd` builtin removes specified directories from the stack and changes the current directory to the directory removed. The `dirs` builtin displays the contents of the directory stack. The current directory is always the "top" of the directory stack. `pushd`当前目录，`popd`目录已删除。 内置`dirs`目录堆栈是最近访问的目录的列表。 这 builtin 在堆栈更改时将目录添加到堆栈中 内置删除指定的目录 目录，并将当前目录更改为 显示内容 目录堆栈。 当前目录始终是“顶部” 目录堆栈。

The contents of the directory stack are also visible as the value of the `DIRSTACK` shell variable. 作为 `DIRSTACK`目录堆栈的内容也是可见的 shell 变量的值。

-   [Directory Stack Builtins内置目录堆栈](https://www.gnu.org/software/bash/manual/bash.html#Directory-Stack-Builtins)

___

#### 6.8.1 Directory Stack Builtins6.8.1 内置目录堆栈

`dirs`

Display the list of currently remembered directories. Directories are added to the list with the `pushd` command; the `popd` command removes directories from the list. The current directory is always the first directory in the stack. 使用 `pushd``popd`显示当前记住的目录列表。 目录 命令添加到列表中;这 命令从列表中删除目录。 当前目录始终是堆栈中的第一个目录。

`-c`

Clears the directory stack by deleting all of the elements. 通过删除所有元素来清除目录堆栈。

`-l`

Produces a listing using full pathnames; the default listing format uses a tilde to denote the home directory. 使用完整路径名生成列表; 默认列表格式使用波浪号来表示主目录。

`-p`

Causes `dirs` to print the directory stack with one entry per line. 导致`dirs`打印目录堆栈，每个目录堆栈只有一个条目 线。

`-v`

Causes `dirs` to print the directory stack with one entry per line, prefixing each entry with its index in the stack. 导致`dirs`打印目录堆栈，每个目录堆栈只有一个条目 行，在堆栈中为每个条目添加索引的前缀。

`+N`+N

Displays the Nth directory (counting from the left of the list printed by `dirs` when invoked without options), starting with zero. 显示N在没有选项的情况下调用`dirs`个目录（从 打印的列表），开始 为零。

`-N`\-N

Displays the Nth directory (counting from the right of the list printed by `dirs` when invoked without options), starting with zero. 显示N在没有选项的情况下调用`dirs`个目录（从右侧开始计数 打印的列表），开始 为零。

`popd`

Removes elements from the directory stack. The elements are numbered from 0 starting at the first directory listed by `dirs`; that is, `popd` is equivalent to `popd +0`. 按`dirs`也就是说，`popd` 等价于 `popd +0`从目录堆栈中删除元素。 元素从第一个目录开始编号从 0 开始 列出; 。

When no arguments are given, `popd` removes the top directory from the stack and changes to the new top directory. 当没有给出参数时，`popd` 从堆栈中删除顶部目录并更改为 新的顶级目录。

Arguments, if supplied, have the following meanings: 如果提供参数，则具有以下含义：

`-n`

Suppresses the normal change of directory when removing directories from the stack, so that only the stack is manipulated. 禁止删除目录时目录的正常更改 从堆栈中，以便仅操作堆栈。

`+N`+N

Removes the Nth directory (counting from the left of the list printed by `dirs`), starting with zero, from the stack. 删除第 N由 `dirs`个目录（从 打印的列表），从堆栈中从零开始。

`-N`\-N

Removes the Nth directory (counting from the right of the list printed by `dirs`), starting with zero, from the stack. 删除第 N由 `dirs`个目录（从右侧计数 打印的列表），从堆栈中从零开始。

If the top element of the directory stack is modified, and the \-n option was not supplied, `popd` uses the `cd` builtin to change to the directory at the top of the stack. If the `cd` fails, `popd` returns a non-zero value. 未提供 \-n 选项，`popd` 使用 `cd`如果 `cd` 失败，`popd`如果修改了目录堆栈的 top 元素，并且 内置以更改为堆栈顶部的目录。 将返回一个非零值。

Otherwise, `popd` returns an unsuccessful status if an invalid option is encountered, the directory stack is empty, or a non-existent directory stack entry is specified. 否则，如果 `popd` 返回不成功状态，则 遇到无效选项，目录堆栈 为空，或者指定了不存在的目录堆栈条目。

If the `popd` command is successful, Bash runs `dirs` to show the final contents of the directory stack, and the return status is 0. 如果 `popd`Bash 运行`dirs` 命令成功， 来显示目录堆栈的最终内容， 返回状态为 0。

`pushd`

```
pushd [-n] [+N | -N | dir]
```

Adds a directory to the top of the directory stack, or rotates the stack, making the new top of the stack the current working directory. With no arguments, `pushd` exchanges the top two elements of the directory stack. 在没有参数的情况下，`pushd`将目录添加到目录堆栈的顶部，或轮换 堆栈，使堆栈的新顶部当前工作 目录。 交换了前两个元素 目录堆栈。

Arguments, if supplied, have the following meanings: 如果提供参数，则具有以下含义：

`-n`

Suppresses the normal change of directory when rotating or adding directories to the stack, so that only the stack is manipulated. 禁止在旋转或 将目录添加到堆栈中，以便仅操作堆栈。

`+N`+N

Brings the Nth directory (counting from the left of the list printed by `dirs`, starting with zero) to the top of the list by rotating the stack. 带来N`dirs`个目录（从 打印的列表，从零开始）到顶部 通过旋转堆栈来列出。

`-N`\-N

Brings the Nth directory (counting from the right of the list printed by `dirs`, starting with zero) to the top of the list by rotating the stack. 带来N`dirs`个目录（从 打印的列表，从零开始）到顶部 通过旋转堆栈来列出。

`dir`

Makes dir be the top of the stack. 使 dir 成为堆栈的顶部。

After the stack has been modified, if the \-n option was not supplied, `pushd` uses the `cd` builtin to change to the directory at the top of the stack. If the `cd` fails, `pushd` returns a non-zero value. 修改堆栈后，如果 \-n提供时，`pushd` 使用内置`cd`如果 `cd` 失败，`pushd` 选项不是 更改为 目录。 将返回一个非零值。

Otherwise, if no arguments are supplied, `pushd` returns 0 unless the directory stack is empty. When rotating the directory stack, `pushd` returns 0 unless the directory stack is empty or a non-existent directory stack element is specified. 否则，如果未提供任何参数，`pushd`轮换目录堆栈时，`pushd` 返回 0，除非 目录堆栈为空。 返回 0，除非 目录堆栈为空或目录堆栈元素不存在 被指定。

If the `pushd` command is successful, Bash runs `dirs` to show the final contents of the directory stack. 如果 `pushd`Bash 运行`dirs` 命令成功， 以显示目录堆栈的最终内容。

___

### 6.9 Controlling the Prompt6.9 控制提示

Bash examines the value of the array variable `PROMPT_COMMAND` just before printing each primary prompt. If any elements in `PROMPT_COMMAND` are set and non-null, Bash executes each value, in numeric order, just as if it had been typed on the command line. Bash 检查数组变量的值 `PROMPT_COMMAND`如果 `PROMPT_COMMAND` 之前 打印每个主要提示。 中的任何元素已设置且非 null，则 Bash 按数字顺序执行每个值， 就像在命令行上键入一样。

In addition, the following table describes the special characters which can appear in the prompt variables `PS0`, `PS1`, `PS2`, and `PS4`: 可以出现在提示变量 `PS0`、`PS1`、`PS2``PS4`此外，下表还描述了特殊字符 和 的：

`\a`

A bell character. 铃铛字符。

`\d`

The date, in "Weekday Month Date" format (e.g., "Tue May 26"). 日期，采用“工作日月份日期”格式（例如，“5 月 26 日星期二”）。

`\D{format}`\\D{format}

The format is passed to `strftime`(3) and the result is inserted into the prompt string; an empty format results in a locale-specific time representation. The braces are required. format传递给 `strftime`添加到提示字符串中;空format（3） 并插入结果 会导致特定于区域设置的格式 时间表示。 大括号是必需的。

`\e`

An escape character. 一个逃脱角色。

`\h`

The hostname, up to the first ‘.’. 主机名，直到第一个“.”。

`\H`

The hostname. 主机名。

`\j`

The number of jobs currently managed by the shell. 当前由 shell 管理的作业数。

`\l`

The basename of the shell’s terminal device name. shell 终端设备名称的基名。

`\n`

A newline. 换行符。

`\r`

A carriage return. 回车。

`\s`

The name of the shell, the basename of `$0` (the portion following the final slash). shell 的名称，`$0`（部分 在最后一个斜杠之后）。

`\t`

The time, in 24-hour HH:MM:SS format. 时间，采用 24 小时 HH：MM：SS 格式。

`\T`

The time, in 12-hour HH:MM:SS format. 时间，采用 12 小时 HH：MM：SS 格式。

`\@`

The time, in 12-hour am/pm format. 时间，采用上午 12 小时/下午 格式。

`\A`

The time, in 24-hour HH:MM format. 时间，采用 24 小时 HH：MM 格式。

`\u`

The username of the current user. 当前用户的用户名。

`\v`

The version of Bash (e.g., 2.00) Bash 版本（例如 2.00）

`\V`

The release of Bash, version + patchlevel (e.g., 2.00.0) Bash 版本 + 补丁级别（例如 2.00.0）的发布

`\w`

The value of the `PWD` shell variable (`$PWD`), with `$HOME` abbreviated with a tilde (uses the `$PROMPT_DIRTRIM` variable). `PWD` shell 变量 （`$PWD`用波浪号缩`$HOME`（使用 `$PROMPT_DIRTRIM`） 的值， 变量）。

`\W`

The basename of `$PWD`, with `$HOME` abbreviated with a tilde. `$PWD` 的基本名称，`$HOME`用波浪号缩写。

`\!`

The history number of this command. 此命令的历史记录编号。

`\#`

The command number of this command. 此命令的命令编号。

`\$`

If the effective uid is 0, `#`, otherwise `$`. 如果有效 uid 为 0，`#`，否则`$`。

`\nnn`

The character whose ASCII code is the octal value nnn. 其 ASCII 代码为八进制值 nnn 的字符。

`\\`

A backslash. 反斜杠。

`\[`

Begin a sequence of non-printing characters. This could be used to embed a terminal control sequence into the prompt. 开始一系列非打印字符。 这可用于 将终端控制序列嵌入到提示符中。

`\]`

End a sequence of non-printing characters. 结束一系列非打印字符。

The command number and the history number are usually different: the history number of a command is its position in the history list, which may include commands restored from the history file (see [Bash History Facilities](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Facilities)), while the command number is the position in the sequence of commands executed during the current shell session.

After the string is decoded, it is expanded via parameter expansion, command substitution, arithmetic expansion, and quote removal, subject to the value of the `promptvars` shell option (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)). This can have unwanted side effects if escaped portions of the string appear within command substitution or contain characters special to word expansion. `promptvars` shell 选项（参见 [Shopt 内置）。](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)字符串解码后，通过 参数扩展、命令替换、算术 扩展和报价删除，取决于 如果字符串的转义部分，这可能会产生不必要的副作用 出现在命令替换中或包含特殊于 词扩展。

___

### 6.10 The Restricted Shell6.10 受限shell

If Bash is started with the name `rbash`, or the \--restricted or \-r option is supplied at invocation, the shell becomes restricted. A restricted shell is used to set up an environment more controlled than the standard shell. A restricted shell behaves identically to `bash` with the exception that the following are disallowed or not performed: 如果 Bash 以名称 `rbash`\--restricted\-r受限制的 shell 的行为与 `bash` 开头，或者 或 选项在调用时提供，shell 将受到限制。 受限shell用于 设置一个比标准 shell 更受控的环境。 相同 不允许或不执行以下操作的除外：

-   Changing directories with the `cd` builtin. 使用内置 `cd` 更改目录。
-   Setting or unsetting the values of the `SHELL`, `PATH`, `HISTFILE`, `ENV`, or `BASH_ENV` variables. 设置或取消设置 `SHELL``PATH``HISTFILE``ENV` 或`BASH_ENV` ， 变量。
-   Specifying command names containing slashes. 指定包含斜杠的命令名称。
-   Specifying a filename containing a slash as an argument to the `.` builtin command. 指定包含斜杠的文件名作为 `.` 内置命令。
-   Specifying a filename containing a slash as an argument to the `history` builtin command. 指定包含斜杠的文件名作为`history`的参数 内置命令。
-   Specifying a filename containing a slash as an argument to the \-p option to the `hash` builtin command. 指定包含斜杠的文件名作为 \-p`hash` 的参数 builtin 命令中。
-   Importing function definitions from the shell environment at startup. 在启动时从 shell 环境导入函数定义。
-   Parsing the value of `SHELLOPTS` from the shell environment at startup. 在启动时从 shell 环境中解析 `SHELLOPTS` 的值。
-   Redirecting output using the ‘\>’, ‘\>|’, ‘<>’, ‘\>&’, ‘&>’, and ‘\>>’ redirection operators. 使用 '\>'、'\>|'、'<>'、'\>&“&>”和“\>>'、 ”重定向运算符。
-   Using the `exec` builtin to replace the shell with another command.
-   Adding or deleting builtin commands with the \-f and \-d options to the `enable` builtin. \-f 和 \-d 选项设置为`enable`使用 内置。
-   Using the `enable` builtin command to enable disabled shell builtins. 使用 `enable` builtin 命令启用已禁用的 shell builtins。
-   Specifying the \-p option to the `command` builtin. 指定内置`command`的 \-p 选项。
-   Turning off restricted mode with ‘set +r’ or ‘shopt -u restricted\_shell’. 使用“set +r”或“shopt -u restricted\_shell”关闭受限模式。

These restrictions are enforced after any startup files are read. 读取任何启动文件后，将强制执行这些限制。

When a command that is found to be a shell script is executed (see [Shell Scripts](https://www.gnu.org/software/bash/manual/bash.html#Shell-Scripts)), `rbash` turns off any restrictions in the shell spawned to execute the script. （请参阅 [Shell 脚本](https://www.gnu.org/software/bash/manual/bash.html#Shell-Scripts)），`rbash`当发现是 shell 脚本的命令被执行时 关闭了 生成的 shell 用于执行脚本。

The restricted shell mode is only one component of a useful restricted environment. It should be accompanied by setting `PATH` to a value that allows execution of only a few verified commands (commands that allow shell escapes are particularly vulnerable), changing the current directory to a non-writable directory other than `$HOME` after login, not allowing the restricted shell to execute shell scripts, and cleaning the environment of variables that cause some commands to modify their behavior (e.g., `VISUAL` or `PAGER`). 环境。它应同时将 `PATH`目录添加到登录后`$HOME`行为（例如，`VISUAL` 或 `PAGER`受限 shell 模式只是有用的受限模式的一个组件 设置为一个值 只允许执行几个经过验证的命令（命令 允许炮弹逃逸特别容易受到攻击），改变电流 之外的不可写目录， 不允许受限制的 shell 执行 shell 脚本，并清理 导致某些命令修改其

Modern systems provide more secure ways to implement a restricted environment, such as `jails`, `zones`, or `containers`. 例如`jails`、`zones`或`containers`现代系统提供了更安全的方法来实施受限环境， 。

___

### 6.11 Bash POSIX Mode6.11 Bash POSIX 模式

Starting Bash with the \--posix command-line option or executing ‘set -o posix’ while Bash is running will cause Bash to conform more closely to the <small>POSIX</small> standard by changing the behavior to match that specified by <small>POSIX</small> in areas where the Bash default differs. 使用 \--posixBash 运行时的 'set -o posix通过将行为匹配 <small>POSIX</small> 命令行选项启动 Bash 或执行 ' 将导致 Bash 更加符合 更改为 在 Bash 默认值不同的区域中指定的匹配。

When invoked as `sh`, Bash enters <small>POSIX</small> mode after reading the startup files. 当作为 `sh` 调用时，Bash 在读取 启动文件。

The following list is what’s changed when ‘<small>POSIX</small> mode’ is in effect: 以下列表是“<small>POSIX</small> 模式”生效时的更改内容：

1.  Bash ensures that the `POSIXLY_CORRECT` variable is set.
2.  When a command in the hash table no longer exists, Bash will re-search `$PATH` to find the new location. This is also available with ‘shopt -s checkhash’. `$PATH`'shopt -s checkhash当哈希表中的命令不再存在时，Bash 将重新搜索 找到新位置。 这也可用于 '。
3.  Bash will not insert a command without the execute bit set into the command hash table, even if it returns it as a (last-ditch) result from a `$PATH` search. 从`$PATH`Bash 不会在未将执行位设置到命令中插入命令 命令哈希表，即使它作为（最后）结果返回 搜索。
4.  The message printed by the job control code and builtins when a job exits with a non-zero status is ‘Done(status)’. 作业控制代码和内置作业时打印的消息 非零状态的退出为“Done（status）”。
5.  The message printed by the job control code and builtins when a job is stopped is ‘Stopped(signame)’, where signame is, for example, `SIGTSTP`. is stopped 是 'Stopped（signame）'，其中 signame例如，`SIGTSTP`作业控制代码和内置作业时打印的消息 是，用于 。
6.  Alias expansion is always enabled, even in non-interactive shells. 别名扩展始终处于启用状态，即使在非交互式 shell 中也是如此。
7.  Reserved words appearing in a context where reserved words are recognized do not undergo alias expansion. 在识别保留字的上下文中出现的保留字 不要进行别名扩展。
8.  Alias expansion is performed when initially parsing a command substitution. The default mode generally defers it, when enabled, until the command substitution is executed. This means that command substitution will not expand aliases that are defined after the command substitution is initially parsed (e.g., as part of a function definition). 在最初分析命令替换时执行别名扩展。 默认模式通常会在启用时将其推迟到命令 执行替换。这意味着命令替换不会 展开在命令替换初始后定义的别名 解析（例如，作为函数定义的一部分）。
9.  The <small>POSIX</small> `PS1` and `PS2` expansions of ‘!’ to the history number and ‘!!’ to ‘!’ are enabled, and parameter expansion is performed on the values of `PS1` and `PS2` regardless of the setting of the `promptvars` option. <small>POSIX</small>`PS1` 和 `PS2` 扩展的 '!启用历史记录编号和“!!到“!并对 `PS1``PS2` 与 `promptvars`' 到 ， 和 选项的设置无关。
10.  The <small>POSIX</small> startup files are executed (`$ENV`) rather than the normal Bash files. <small>POSIX</small> 启动文件被执行 （`$ENV`） 而不是 普通的 Bash 文件。
11.  Tilde expansion is only performed on assignments preceding a command name, rather than on all assignment statements on the line. 波浪号扩展仅在命令之前的赋值上执行 name，而不是在行上的所有赋值语句上。
12.  The default history file is ~/.sh\_history (this is the default value of `$HISTFILE`). 默认历史文件是 ~/.sh\_history默认值为 `$HISTFILE`（这是 ）。
13.  Redirection operators do not perform filename expansion on the word in the redirection unless the shell is interactive. 重定向运算符不对单词执行文件名扩展 在重定向中，除非 shell 是交互式的。
14.  Redirection operators do not perform word splitting on the word in the redirection. 重定向运算符不会对 重定向。
15.  Function names must be valid shell `name`s. That is, they may not contain characters other than letters, digits, and underscores, and may not start with a digit. Declaring a function with an invalid name causes a fatal syntax error in non-interactive shells. 函数名称必须是有效的 shell `name`s。 也就是说，他们可能不会 包含字母、数字和下划线以外的字符，以及 不能以数字开头。 声明名称无效的函数 导致非交互式 shell 中出现致命的语法错误。
16.  Function names may not be the same as one of the <small>POSIX</small> special builtins. 函数名称可能与 <small>POSIX</small> 特殊名称之一不同 内置。
17.  <small>POSIX</small> special builtins are found before shell functions during command lookup. 在 shell 函数之前找到 <small>POSIX</small> 特殊内置函数 在命令查找期间。
18.  When printing shell function definitions (e.g., by `type`), Bash does not print the `function` keyword. 在打印 shell 函数定义（例如，按`type`不打印 `function`）时，Bash 可以 关键字。
19.  Literal tildes that appear as the first character in elements of the `PATH` variable are not expanded as described above under [Tilde Expansion](https://www.gnu.org/software/bash/manual/bash.html#Tilde-Expansion). `PATH`在[波浪号扩展](https://www.gnu.org/software/bash/manual/bash.html#Tilde-Expansion)在元素中作为第一个字符出现的文字波浪号 变量未如上所述展开 下。
20.  The `time` reserved word may be used by itself as a command. When used in this way, it displays timing statistics for the shell and its completed children. The `TIMEFORMAT` variable controls the format of the timing information. `time`完成的孩子。 `TIMEFORMAT`的字可以单独用作命令。 什么时候 以这种方式使用，它显示 shell 及其 变量控制格式 的计时信息。
21.  When parsing and expanding a ${…} expansion that appears within double quotes, single quotes are no longer special and cannot be used to quote a closing brace or other special character, unless the operator is one of those defined to perform pattern removal. In this case, they do not have to appear as matched pairs. 解析和展开 ${...} 扩展时，显示在 双引号、单引号不再是特殊，不能用于 引用右大括号或其他特殊字符，除非运算符是 定义为执行模式删除的其中之一。 在这种情况下，他们这样做 不必显示为匹配的对。
22.  The parser does not recognize `time` as a reserved word if the next token begins with a ‘\-’. 如果下一个令牌以“\- ”开头。
23.  The ‘!’ character does not introduce history expansion within a double-quoted string, even if the `histexpand` option is enabled. “!双引号字符串，即使启用了 `histexpand`字符不会在 选项。
24.  If a <small>POSIX</small> special builtin returns an error status, a non-interactive shell exits. The fatal errors are those listed in the <small>POSIX</small> standard, and include things like passing incorrect options, redirection errors, variable assignment errors for assignments preceding the command name, and so on. 如果 <small>POSIX</small><small>POSIX</small> 特殊内置函数返回错误状态，则 非交互式 shell 退出。 致命错误是 标准，并包括传递不正确的选项等内容， 重定向错误，前面分配的变量分配错误 命令名称，依此类推。
25.  A non-interactive shell exits with an error status if a variable assignment error occurs when no command name follows the assignment statements. A variable assignment error occurs, for example, when trying to assign a value to a readonly variable. 如果变量 当赋值后没有命令名称时，会发生赋值错误 语句。 例如，在尝试赋值时，会发生变量赋值错误 readonly 变量的值。
26.  A non-interactive shell exits with an error status if a variable assignment error occurs in an assignment statement preceding a special builtin, but not with any other simple command. For any other simple command, the shell aborts execution of that command, and execution continues at the top level ("the shell shall not perform any further processing of the command in which the error occurred"). 如果变量 赋值错误发生在特殊赋值语句之前 内置，但不使用任何其他简单命令。对于任何其他简单的 命令，shell 将中止该命令的执行，并继续执行 在顶层（“shell不得对 发生错误的命令“）。
27.  A non-interactive shell exits with an error status if the iteration variable in a `for` statement or the selection variable in a `select` statement is a readonly variable. `for``select`如果迭代 语句中的变量或 for 语句中的选择变量 语句是只读变量。
28.  Non-interactive shells exit if filename in `.` filename is not found. 如果 filename 在 `.`则非交互式 shell 退出。filename 未找到。
29.  Non-interactive shells exit if a syntax error in an arithmetic expansion results in an invalid expression. 如果算术扩展中的语法错误，则非交互式 shell 将退出 导致表达式无效。
30.  Non-interactive shells exit if a parameter expansion error occurs. 如果发生参数扩展错误，非交互式 shell 将退出。
31.  Non-interactive shells exit if there is a syntax error in a script read with the `.` or `source` builtins, or in a string processed by the `eval` builtin. 使用 `.` 或 `source`内置`eval`如果读取的脚本中存在语法错误，则非交互式 shell 将退出 内置，或在 函数。
32.  While variable indirection is available, it may not be applied to the ‘#’ and ‘?’ special parameters. '#' 和 '?虽然变量间接可用，但它可能不适用于 ' 特殊参数。
33.  Expanding the ‘\*’ special parameter in a pattern context where the expansion is double-quoted does not treat the `$*` as if it were double-quoted. 在模式上下文中扩展 '\*扩展是双引号，不会将 `$*`' 特殊参数，其中 视为 双引号。
34.  Assignment statements preceding <small>POSIX</small> special builtins persist in the shell environment after the builtin completes. <small>POSIX</small> 特殊内置项前面的赋值语句 内置完成后保留在 shell 环境中。
35.  The `command` builtin does not prevent builtins that take assignment statements as arguments from expanding them as assignment statements; when not in <small>POSIX</small> mode, assignment builtins lose their assignment statement expansion properties when preceded by `command`. 内置`command`当不在 <small>POSIX</small>语句扩展属性（当前面是`command`不会阻止接受赋值的内置函数 语句作为参数，将它们扩展为赋值语句; 模式下时，赋值内置项会丢失其赋值 时）。
36.  The `bg` builtin uses the required format to describe each job placed in the background, which does not include an indication of whether the job is the current or previous job. 内置`bg` 使用所需的格式来描述每个放置的工作 在后台，其中不包括作业是否 是当前或以前的作业。
37.  The output of ‘kill -l’ prints all the signal names on a single line, separated by spaces, without the ‘SIG’ prefix. 'kill -l用空格分隔，不带“SIG' 的输出在一行上打印所有信号名称， ”前缀。
38.  The `kill` builtin does not accept signal names with a ‘SIG’ prefix. `kill`不接受带有“SIG”的信号名称 前缀。
39.  The `export` and `readonly` builtin commands display their output in the format required by <small>POSIX</small>. `export` 和 `readonly`以 <small>POSIX</small> 内置命令显示其 要求的格式输出。
40.  The `trap` builtin displays signal names without the leading `SIG`. 内置`trap``SIG`显示信号名称，不带前导 的。
41.  The `trap` builtin doesn’t check the first argument for a possible signal specification and revert the signal handling to the original disposition if it is, unless that argument consists solely of digits and is a valid signal number. If users want to reset the handler for a given signal to the original disposition, they should use ‘\-’ as the first argument. 内置`trap`向原始处置发出信号，他们应该使用“\-不会检查第一个参数是否存在可能的 信号规范，并将信号处理恢复到原来的状态 如果是，则处置，除非该参数仅由数字和 是有效的信号编号。 如果用户想要重置给定的处理程序 ”作为 第一个参数。
42.  `trap -p` displays signals whose dispositions are set to SIG\_DFL and those that were ignored when the shell started. `trap -p` 显示配置设置为 SIG\_DFL 和 那些在 shell 启动时被忽略的。
43.  The `.` and `source` builtins do not search the current directory for the filename argument if it is not found by searching `PATH`. `.` 和 `source`如果通过搜索 `PATH` 内置函数不搜索当前目录 找不到 filename 参数。
44.  Enabling <small>POSIX</small> mode has the effect of setting the `inherit_errexit` option, so subshells spawned to execute command substitutions inherit the value of the \-e option from the parent shell. When the `inherit_errexit` option is not enabled, Bash clears the \-e option in such subshells. 启用 <small>POSIX</small>`inherit_errexit`父 shell 中的 \-e如果未启用`inherit_errexit`Bash 清除此类子 shell 中的 \-e 模式的效果是将 选项，所以 为执行命令替换而生成的子 shell 继承了 选项。 选项， 选项。
45.  Enabling <small>POSIX</small> mode has the effect of setting the `shift_verbose` option, so numeric arguments to `shift` that exceed the number of positional parameters will result in an error message. 启用 <small>POSIX</small>`shift_verbose`选项，所以要`shift` 模式的效果是将 数字参数 超过位置参数的数量将导致 错误信息。
46.  When the `alias` builtin displays alias definitions, it does not display them with a leading ‘alias ’ unless the \-p option is supplied. 当内置`alias`使用前导“alias ”显示它们，除非 \-p显示别名定义时，它不会 选项 已提供。
47.  When the `set` builtin is invoked without options, it does not display shell function names and definitions. 当调用不带选项`set` 内置时，它不会显示 shell 函数名称和定义。
48.  When the `set` builtin is invoked without options, it displays variable values without quotes, unless they contain shell metacharacters, even if the result contains nonprinting characters. 当调用 `set` builtin 而不带选项时，它会显示 不带引号的变量值，除非它们包含 shell 元字符， 即使结果包含非打印字符。
49.  When the `cd` builtin is invoked in logical mode, and the pathname constructed from `$PWD` and the directory name supplied as an argument does not refer to an existing directory, `cd` will fail instead of falling back to physical mode. 当 `cd`由 `$PWD`不引用现有目录，`cd` builtin 在逻辑模式下调用时，路径名 构造，并作为参数提供的目录名称 将失败而不是 回退到物理模式。
50.  When the `cd` builtin cannot change a directory because the length of the pathname constructed from `$PWD` and the directory name supplied as an argument exceeds `PATH_MAX` when all symbolic links are expanded, `cd` will fail instead of attempting to use only the supplied directory name. 当 `cd`由 `$PWD`超过`PATH_MAX` 当所有符号链接都展开时，`cd` builtin 无法更改目录时，因为 路径名的长度 构造，并作为参数提供的目录名称 将 失败，而不是尝试仅使用提供的目录名称。
51.  The `pwd` builtin verifies that the value it prints is the same as the current directory, even if it is not asked to check the file system with the \-P option. `pwd`\-P 内置验证它打印的值是否与 当前目录，即使没有要求它使用 选项。
52.  When listing the history, the `fc` builtin does not include an indication of whether or not a history entry has been modified. 列出历史记录时，`fc` 内置不包含 指示历史记录条目是否已被修改。
53.  The default editor used by `fc` is `ed`. `fc` 使用的默认编辑器是 `ed`。
54.  The `type` and `command` builtins will not report a non-executable file as having been found, though the shell will attempt to execute such a file if it is the only so-named file found in `$PATH`. `type`和`command`文件，如果它是在`$PATH`内置不会报告不可执行文件 文件，尽管 shell 将尝试执行这样的 中找到的唯一同名文件。
55.  The `vi` editing mode will invoke the `vi` editor directly when the ‘v’ command is run, instead of checking `$VISUAL` and `$EDITOR`. `vi` 编辑模式将在以下情况下直接调用 `vi`运行“v”命令，而不是检查 `$VISUAL``$EDITOR` 编辑器 和 。
56.  When the `xpg_echo` option is enabled, Bash does not attempt to interpret any arguments to `echo` as options. Each argument is displayed, after escape characters are converted.
57.  The `ulimit` builtin uses a block size of 512 bytes for the \-c and \-f options. `ulimit` 内置的 \-c和 \-f 使用 512 字节的块大小 选项。
58.  The arrival of `SIGCHLD` when a trap is set on `SIGCHLD` does not interrupt the `wait` builtin and cause it to return immediately. The trap command is run once for each child that exits. 当在 `SIGCHLD` 上设置陷阱时，`SIGCHLD`不要中断内置`wait` 的到来确实 并使其立即返回。 trap 命令对每个退出的子级运行一次。
59.  The `read` builtin may be interrupted by a signal for which a trap has been set. If Bash receives a trapped signal while executing `read`, the trap handler executes and `read` returns an exit status greater than 128. `read`如果 Bash 在执行`read`处理程序执行并`read`内置可以被信号打断，该信号的陷阱 已设置。 时收到捕获信号，则 trap 返回大于 128 的退出状态。
60.  The `printf` builtin uses `double` (via `strtod`) to convert arguments corresponding to floating point conversion specifiers, instead of `long double` if it’s available. The ‘L’ length modifier forces `printf` to use `long double` if it’s available. `printf` builtin 使用 `double`（通过 `strtod``long double`。“L`printf` 使用 `long double`）进行转换 对应于浮点转换说明符的参数，而不是 ”长度修正力 （如果可用）。
61.  Bash removes an exited background process’s status from the list of such statuses after the `wait` builtin is used to obtain it. 使用 `wait`Bash 会从此类列表中删除已退出的后台进程的状态 内置来获取它之后的状态。

There is other <small>POSIX</small> behavior that Bash does not implement by default even when in <small>POSIX</small> mode. Specifically: Bash 没有实现其他 <small>POSIX</small>即使在 <small>POSIX</small> 行为 模式下也默认。 具体说来：

1.  The `fc` builtin checks `$EDITOR` as a program to edit history entries if `FCEDIT` is unset, rather than defaulting directly to `ed`. `fc` uses `ed` if `EDITOR` is unset. `fc` 内置检查`$EDITOR`如果 `FCEDIT``ed`。 如果未设置 `EDITOR` 使用 `ed`。作为程序来编辑历史记录 未设置，则条目，而不是直接默认为
2.  As noted above, Bash requires the `xpg_echo` option to be enabled for the `echo` builtin to be fully conformant. 如上所述，Bash 需要启用 `xpg_echo`内置`echo` 选项 完全符合要求。

Bash can be configured to be <small>POSIX</small>\-conformant by default, by specifying the \--enable-strict-posix-default to `configure` when building (see [Optional Features](https://www.gnu.org/software/bash/manual/bash.html#Optional-Features)). 默认情况下，可以通过指定构建时`configure`的 \--enable-strict-posix-default（请参阅[可选功能](https://www.gnu.org/software/bash/manual/bash.html#Optional-Features) ）。

___

### 6.12 Shell Compatibility Mode6.12 Shell兼容模式

Bash-4.0 introduced the concept of a _shell compatibility level_, specified as a set of options to the shopt builtin (`compat31`, `compat32`, `compat40`, `compat41`, and so on). There is only one current compatibility level – each option is mutually exclusive. The compatibility level is intended to allow users to select behavior from previous versions that is incompatible with newer versions while they migrate scripts to use current features and behavior. It’s intended to be a temporary solution. Bash-4.0 引入了 _shell 兼容级别_（`compat31``compat32``compat40``compat41`的概念， 指定为 shopt 内置的一组选项 ， ， ， ， 等等）。 只有一个电流 兼容级别 – 每个选项都是互斥的。 兼容级别旨在允许用户选择行为 与较新版本不兼容的先前版本 当他们迁移脚本以使用当前功能时，以及 行为。它旨在成为一种临时解决方案。

This section does not mention behavior that is standard for a particular version (e.g., setting `compat32` means that quoting the rhs of the regexp matching operator quotes special regexp characters in the word, which is default behavior in bash-3.2 and subsequent versions). 版本（例如，设置 `compat32`本节不提及特定行为的标准行为 意味着引用正则表达式的 RHS 匹配运算符在单词中引用特殊的正则表达式字符，即 bash-3.2 及更高版本中的默认行为）。

If a user enables, say, `compat32`, it may affect the behavior of other compatibility levels up to and including the current compatibility level. The idea is that each compatibility level controls behavior that changed in that version of Bash, but that behavior may have been present in earlier versions. For instance, the change to use locale-based comparisons with the `[[` command came in bash-4.1, and earlier versions used ASCII-based comparisons, so enabling `compat32` will enable ASCII-based comparisons as well. That granularity may not be sufficient for all uses, and as a result users should employ compatibility levels carefully. Read the documentation for a particular feature to find out the current behavior. 如果用户启用了 `compat32`例如，使用基于语言环境的比较与 `[[`因此，启用 `compat32`，它可能会影响其他用户的行为 兼容级别，最高可达（包括当前兼容级别）。 这个想法是每个兼容级别都控制更改的行为 在那个版本的 Bash 中， 但这种行为可能在早期版本中已经存在。 命令出现在 bash-4.1 中，早期版本使用基于 ASCII 的比较， 也将启用基于 ASCII 的比较。 这种粒度可能不足以满足 所有用途，因此用户应谨慎使用兼容性级别。 阅读特定功能的文档，了解 当前行为。

Bash-4.3 introduced a new shell variable: `BASH_COMPAT`. The value assigned to this variable (a decimal version number like 4.2, or an integer corresponding to the `compat`NN option, like 42) determines the compatibility level. Bash-4.3 引入了一个新的 shell 变量：`BASH_COMPAT`对应于 `compat`NN。 分配的值 添加到此变量（十进制版本号，如 4.2 或整数 选项，如 42） 确定 兼容级别。

Starting with bash-4.4, Bash has begun deprecating older compatibility levels. Eventually, the options will be removed in favor of `BASH_COMPAT`. 最终，这些选项将被删除，取而代之的是`BASH_COMPAT`从 bash-4.4 开始，Bash 已开始弃用较旧的兼容性 水平。 。

Bash-5.0 is the final version for which there will be an individual shopt option for the previous version. Users should use `BASH_COMPAT` on bash-5.0 and later versions. 选项。用户应使用 `BASH_COMPAT`Bash-5.0 是最终版本，将有一个单独的商店 在 bash-5.0 及更高版本上。

The following table describes the behavior changes controlled by each compatibility level setting. The `compat`NN tag is used as shorthand for setting the compatibility level to NN using one of the following mechanisms. For versions prior to bash-5.0, the compatibility level may be set using the corresponding `compat`NN shopt option. For bash-4.3 and later versions, the `BASH_COMPAT` variable is preferred, and it is required for bash-5.1 and later versions. `compat`NN使用以下机制之一进行 NN相应的 `compat`NN对于 bash-4.3 及更高版本，`BASH_COMPAT`下表描述了每个 兼容级别设置。 标签用作设置 兼容级别 。 对于 bash-5.0 之前的版本，可以使用 shopt 选项。 变量， bash-5.1 及更高版本需要它。

`compat31`

-   quoting the rhs of the `[[` command’s regexp matching operator (=~) has no special effect 引用 `[[` 命令的正则表达式匹配运算符 （=~） 的 RHS 没有特殊效果

`compat32`

-   interrupting a command list such as "a ; b ; c" causes the execution of the next command in the list (in bash-4.0 and later versions, the shell acts as if it received the interrupt, so interrupting one command in a list aborts the execution of the entire list) 中断命令列表，例如“a ;b ;c“导致执行 列表中的下一个命令（在 bash-4.0 及更高版本中， shell 的行为就好像它接收了中断一样，所以 中断列表中的一个命令将中止执行 整个列表）

`compat40`

-   the ‘<’ and ‘\>’ operators to the `[[` command do not consider the current locale when comparing strings; they use ASCII ordering. Bash versions prior to bash-4.1 use ASCII collation and strcmp(3); bash-4.1 and later use the current locale’s collation sequence and strcoll(3). `[[` 命令的 '<' 和 '\>' 运算符不 比较字符串时考虑当前区域设置;他们使用 ASCII 订购。 bash-4.1 之前的 bash 版本使用 ASCII 排序规则和 strcmp（3）; bash-4.1 及更高版本使用当前语言环境的排序规则序列和 strcoll（3）。

`compat41`

-   in posix mode, `time` may be followed by options and still be recognized as a reserved word (this is <small>POSIX</small> interpretation 267) 在 POSIX 模式下，`time`被识别为保留字（这是<small>POSIX</small>后面可能是选项，并且仍然是 解释267）
-   in posix mode, the parser requires that an even number of single quotes occur in the word portion of a double-quoted ${…} parameter expansion and treats them specially, so that characters within the single quotes are considered quoted (this is <small>POSIX</small> interpretation 221) 引号出现在双引号 ${...} 的word（这是<small>POSIX</small>在 POSIX 模式下，解析器要求偶数个 部分 参数扩展并特殊处理它们，以便字符内 单引号被视为引号 解释221）

`compat42`

-   the replacement string in double-quoted pattern substitution does not undergo quote removal, as it does in versions after bash-4.2 双引号模式替换中的替换字符串不 进行引号删除，就像在 bash-4.2 之后的版本中一样
-   in posix mode, single quotes are considered special when expanding the word portion of a double-quoted ${…} parameter expansion and can be used to quote a closing brace or other special character (this is part of <small>POSIX</small> interpretation 221); in later versions, single quotes are not special within double-quoted word expansions 双引号 ${...} 参数扩展的word（这是<small>POSIX</small>在 POSIX 模式下，单引号在扩展时被认为是特殊的 部分 并可用于引用右大括号或其他特殊字符 解释221的一部分）; 在以后的版本中，单引号 在双引号的单词扩展中并不特别

`compat43`

-   the shell does not print a warning message if an attempt is made to use a quoted compound assignment as an argument to declare (e.g., declare -a foo=’(1 2)’). Later versions warn that this usage is deprecated 如果尝试 使用带引号的复合赋值作为参数进行声明 （例如，声明 -a foo='（1 2）'）。更高版本警告说，这种用法是 荒废的
-   word expansion errors are considered non-fatal errors that cause the current command to fail, even in posix mode (the default behavior is to make them fatal errors that cause the shell to exit) 字扩展错误被视为非致命错误，会导致 当前命令失败，即使在 POSIX 模式下也是如此 （默认行为是使它们成为导致 shell 的致命错误 退出）
-   when executing a shell function, the loop state (while/until/etc.) is not reset, so `break` or `continue` in that function will break or continue loops in the calling context. Bash-4.4 and later reset the loop state to prevent this 没有重置，所以`break`或`continue`执行 shell 函数时，循环状态（while/until/etc.） 该函数会中断 或在调用上下文中继续循环。Bash-4.4 及更高版本重置 防止这种情况的循环状态

`compat44`

-   the shell sets up the values used by `BASH_ARGV` and `BASH_ARGC` so they can expand to the shell’s positional parameters even if extended debugging mode is not enabled shell 设置 `BASH_ARGV` 和 `BASH_ARGC` 使用的值 因此，即使扩展，它们也可以扩展到壳的位置参数 未启用调试模式
-   a subshell inherits loops from its parent context, so `break` or `continue` will cause the subshell to exit. Bash-5.0 and later reset the loop state to prevent the exit 子 shell 从其父上下文继承循环，因此`break`或`continue` 将导致子 shell 退出。 Bash-5.0 及更高版本重置循环状态以防止退出
-   variable assignments preceding builtins like `export` and `readonly` that set attributes continue to affect variables with the same name in the calling environment even if the shell is not in posix mode 内置函数（如 `export` 和 `readonly`）之前的变量赋值 该集合属性继续影响具有相同属性的变量 调用环境中的名称，即使 shell 不在 POSIX 中 模式

`compat50 (set using BASH_COMPAT)`

-   Bash-5.1 changed the way `$RANDOM` is generated to introduce slightly more randomness. If the shell compatibility level is set to 50 or lower, it reverts to the method from bash-5.0 and previous versions, so seeding the random number generator by assigning a value to `RANDOM` will produce the same sequence as in bash-5.0 Bash-5.1 更改了`$RANDOM``RANDOM`的生成方式，略微引入了 更多的随机性。如果 shell 兼容级别设置为 50 或 较低时，它恢复到 bash-5.0 和以前版本中的方法， 因此，通过将值分配给随机数生成器来播种随机数生成器 将产生与 bash-5.0 相同的序列
-   If the command hash table is empty, Bash versions prior to bash-5.1 printed an informational message to that effect, even when producing output that can be reused as input. Bash-5.1 suppresses that message when the \-l option is supplied. 当提供 \-l如果命令哈希表为空，则 bash-5.1 之前的 Bash 版本 打印出一条信息性信息，大意是这样的，即使在生产时也是如此 可重用作输入的输出。Bash-5.1 禁止显示该消息 选项时。

`compat51 (set using BASH_COMPAT)`

-   The `unset` builtin will unset the array `a` given an argument like ‘a\[@\]’. Bash-5.2 will unset an element with key ‘@’ (associative arrays) or remove all the elements without unsetting the array (indexed arrays) `unset` 内置将取消设置`a`'a\[@\]Bash-5.2 将取消设置具有键“@一个参数，例如 '。 ”的元素（关联数组） 或者删除所有元素而不取消设置数组（索引数组）
-   arithmetic commands ( ((...)) ) and the expressions in an arithmetic for statement can be expanded more than once 算术命令 （ （（...）） ） 和算术中的表达式 语句可以多次展开
-   expressions used as arguments to arithmetic operators in the `[[` conditional command can be expanded more than once 用作 `[[` 条件命令可以多次扩展
-   the expressions in substring parameter brace expansion can be expanded more than once 子字符串参数大括号扩展中的表达式可以是 扩展不止一次
-   the expressions in the $(( ... )) word expansion can be expanded more than once $（（ ... ）） 字扩展中的表达式可以展开 不止一次
-   arithmetic expressions used as indexed array subscripts can be expanded more than once 用作索引数组下标的算术表达式可以是 扩展不止一次
-   `test -v`, when given an argument of ‘A\[@\]’, where A is an existing associative array, will return true if the array has any set elements. Bash-5.2 will look for and report on a key named ‘@’ `test -v`，当给定参数 'A\[@\]' 时，ABash-5.2 将查找并报告一个名为“@ 是 现有的关联数组，如果该数组有任何设置，则将返回 true 元素。 ”的键
-   the ${parameter\[:\]=value} word expansion will return value, before any variable-specific transformations have been performed (e.g., converting to lowercase). Bash-5.2 will return the final value assigned to the variable. ${parameter\[：\]=valuevalue} 字扩展将返回 ，在任何特定于变量的转换之前 执行（例如，转换为小写）。 Bash-5.2 将返回分配给变量的最终值。
-   Parsing command substitutions will behave as if extended glob (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)) is enabled, so that parsing a command substitution containing an extglob pattern (say, as part of a shell function) will not fail. This assumes the intent is to enable extglob before the command is executed and word expansions are performed. It will fail at word expansion time if extglob hasn’t been enabled by the time the command is executed. （参见 [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)解析命令替换的行为类似于扩展 glob ） 启用，以便解析包含 extglob 的命令替换 模式（例如，作为 shell 函数的一部分）不会失败。 这假定目的是在执行命令之前启用 extglob 并执行单词扩展。 如果 extglob 没有，它将在单词扩展时失败 在执行命令时启用。
