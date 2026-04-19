
## 9 Using History Interactively9 以交互方式使用历史记录

This chapter describes how to use the <small>GNU</small> History Library interactively, from a user’s standpoint. It should be considered a user’s guide. For information on using the <small>GNU</small> History Library in other programs, see the <small>GNU</small> Readline Library Manual. 本章介绍如何使用 <small>GNU</small>有关在其他程序中使用 <small>GNU</small>参见 <small>GNU</small> 历史库 从用户的角度来看，以交互方式进行。 它应该被视为用户指南。 历史库的信息， Readline 库手册。

-   [Bash History FacilitiesBash 历史设施](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Facilities)
-   [Bash History Builtins内置 Bash 历史记录](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Builtins)
-   [History Expansion历史扩展](https://www.gnu.org/software/bash/manual/bash.html#History-Interaction)

___

### 9.1 Bash History Facilities

When the \-o history option to the `set` builtin is enabled (see [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)), the shell provides access to the _command history_, the list of commands previously typed. The value of the `HISTSIZE` shell variable is used as the number of commands to save in a history list. The text of the last `$HISTSIZE` commands (default 500) is saved. The shell stores each command in the history list prior to parameter and variable expansion but after history expansion is performed, subject to the values of the shell variables `HISTIGNORE` and `HISTCONTROL`. 当 \-o history 选项`set`已启用（请参阅[内置设置](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)shell 提供对_命令历史记录_`HISTSIZE`最后`$HISTSIZE``HISTIGNORE` 和 `HISTCONTROL` ）， 的访问， 以前键入的命令列表。 shell 变量的值用作 要保存在历史记录列表中的命令数。 的文本 保存命令（默认为 500）。 shell 将每个命令存储在历史记录列表中，然后 参数和变量扩展 但在执行历史扩展后，受制于 shell 变量的值

When the shell starts up, the history is initialized from the file named by the `HISTFILE` variable (default ~/.bash\_history). The file named by the value of `HISTFILE` is truncated, if necessary, to contain no more than the number of lines specified by the value of the `HISTFILESIZE` variable. When a shell with history enabled exits, the last `$HISTSIZE` lines are copied from the history list to the file named by `$HISTFILE`. If the `histappend` shell option is set (see [Bash Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)), the lines are appended to the history file, otherwise the history file is overwritten. If `HISTFILE` is unset, or if the history file is unwritable, the history is not saved. After saving the history, the history file is truncated to contain no more than `$HISTFILESIZE` lines. If `HISTFILESIZE` is unset, or set to null, a non-numeric value, or a numeric value less than zero, the history file is not truncated. 由 `HISTFILE` 变量命名的文件（默认~/.bash\_history如果 `HISTFILE``HISTFILESIZE``$HISTSIZE`由`$HISTFILE`如果设置了 `histappend` shell 选项（请参阅 [Bash 内置命令](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)如果 `HISTFILE`包含不超过 `$HISTFILESIZE`如果 `HISTFILESIZE`当 shell 启动时，历史记录将从 ）。 的值命名的文件被截断，则 必需的，包含不超过 变量的值。 当启用了历史记录的 shell 退出时，最后一个 行从历史记录列表复制到文件中 命名。 ）， 这些行将附加到历史记录文件中， 否则，历史记录文件将被覆盖。 未设置，或者如果历史记录文件不可写，则不会保存历史记录。 保存历史记录后，历史记录文件将被截断 行。 未设置或设置为 null，则为非数值，或者 如果数值小于零，则历史记录文件不会被截断。

If the `HISTTIMEFORMAT` is set, the time stamp information associated with each history entry is written to the history file, marked with the history comment character. When the history file is read, lines beginning with the history comment character followed immediately by a digit are interpreted as timestamps for the following history entry. 如果设置了 `HISTTIMEFORMAT`，则时间戳信息 与每个历史记录条目关联的条目被写入历史记录文件， 标有历史注释字符。 读取历史记录文件时，以历史记录开头的行 注释字符后跟一个数字被解释 作为以下历史记录条目的时间戳。

The builtin command `fc` may be used to list or edit and re-execute a portion of the history list. The `history` builtin may be used to display or modify the history list and manipulate the history file. When using command-line editing, search commands are available in each editing mode that provide access to the history list (see [Commands For Manipulating The History](https://www.gnu.org/software/bash/manual/bash.html#Commands-For-History)). 内置命令 `fc`内置`history`历史记录列表（请参阅[操作历史记录的命令](https://www.gnu.org/software/bash/manual/bash.html#Commands-For-History) 可用于列出或编辑并重新执行 历史记录列表的一部分。 可用于显示或修改历史记录 列出并操作历史记录文件。 使用命令行编辑时，搜索命令 在每种编辑模式中都可用，这些模式提供对 ）。

The shell allows control over which commands are saved on the history list. The `HISTCONTROL` and `HISTIGNORE` variables may be set to cause the shell to save only a subset of the commands entered. The `cmdhist` shell option, if enabled, causes the shell to attempt to save each line of a multi-line command in the same history entry, adding semicolons where necessary to preserve syntactic correctness. The `lithist` shell option causes the shell to save the command with embedded newlines instead of semicolons. The `shopt` builtin is used to set these options. See [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin), for a description of `shopt`. 列表。 `HISTCONTROL` 和 `HISTIGNORE``cmdhist``lithist``shopt`有关 `shopt` 的描述，请参阅 [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)shell 允许控制哪些命令保存在历史记录中 变量可以设置为使 shell 仅保存 输入的命令。 shell 选项（如果启用），则会导致 shell 尝试保存每个 同一历史记录条目中的多行命令的行，添加 必要时使用分号以保持句法正确性。 shell 选项使 shell 保存带有嵌入换行符的命令 而不是分号。 内置用于设置这些选项。 。

___

### 9.2 Bash History Builtins9.2 内置 Bash 历史记录

Bash provides two builtin commands which manipulate the history list and history file. Bash 提供了两个内置命令，用于操作 历史记录列表和历史记录文件。

`fc`

```
fc [-e ename] [-lnr] [first] [last]
```

The first form selects a range of commands from first to last from the history list and displays or edits and re-executes them. Both first and last may be specified as a string (to locate the most recent command beginning with that string) or as a number (an index into the history list, where a negative number is used as an offset from the current command number). 第一种形式选择从firstlastfirstlast到 记录列表中的最后一个，并显示或编辑并重新执行 他们。 和 可以指定为字符串（以查找最新的 命令以该字符串开头）或作为数字（索引到 历史列表，其中负数用作 当前命令编号）。

When listing, a first or last of 0 is equivalent to -1 and -0 is equivalent to the current command (usually the `fc` command); otherwise 0 is equivalent to -1 and -0 is invalid. 列出时，first或last\-0 等价于当前命令（通常是 `fc` 0 等于 -1 命令）; 否则，0 等于 -1，-0 无效。

If last is not specified, it is set to first. If first is not specified, it is set to the previous command for editing and -16 for listing. If the \-l flag is given, the commands are listed on standard output. The \-n flag suppresses the command numbers when listing. The \-r flag reverses the order of the listing. Otherwise, the editor given by ename is invoked on a file containing those commands. If ename is not given, the value of the following variable expansion is used: `${FCEDIT:-${EDITOR:-vi}}`. This says to use the value of the `FCEDIT` variable if set, or the value of the `EDITOR` variable if that is set, or `vi` if neither is set. When editing is complete, the edited commands are echoed and executed. 如果未指定 lastfirst。 如果未指定 first命令用于编辑，-16 用于列表。 如果 \-l给定时，命令列在标准输出中。 \-n列出时禁止显示命令编号。 \-renameename使用：`${FCEDIT:-${EDITOR:-vi}}`如果设置了 `FCEDIT``EDITOR`设置了 EDITOR 变量，则为 `vi`，则将其设置为 ，则将其设置为 previous 标志是 标志 标志 颠倒列表的顺序。 否则，编辑器由 在包含这些命令的文件上调用。 如果 未给出，以下变量扩展的值 。 这说要使用 变量的值，或者 ，如果两者都未设置。 编辑完成后，将回显并执行编辑后的命令。

In the second form, command is re-executed after each instance of pat in the selected command is replaced by rep. command is interpreted the same as first above. 在第二种command所选命令中的 pat 替换为 repcommand的解释与上面first命令在每个实例之后重新执行 。 相同。

A useful alias to use with the `fc` command is `r='fc -s'`, so that typing ‘r cc’ runs the last command beginning with `cc` and typing ‘r’ re-executes the last command (see [Aliases](https://www.gnu.org/software/bash/manual/bash.html#Aliases)). 与 `fc` 命令一起使用的有用别名是 `r='fc -s'`键入“r cc”将运行以 `cc`键入“r”将重新执行最后一个命令（请参阅[别名](https://www.gnu.org/software/bash/manual/bash.html#Aliases)，所以 开头的最后一个命令 ）。

`history`

```
history [n]
history -c
history -d offset
history -d start-end
history [-anrw] [filename]
history -ps arg
```

With no options, display the history list with line numbers. Lines prefixed with a ‘\*’ have been modified. An argument of n lists only the last n lines. If the shell variable `HISTTIMEFORMAT` is set and not null, it is used as a format string for strftime to display the time stamp associated with each displayed history entry. No intervening blank is printed between the formatted time stamp and the history line. 修改了以“\*n 的参数仅列出最后 n如果设置了 shell 变量 `HISTTIMEFORMAT`它用作 strftime如果不带任何选项，则显示带有行号的历史记录列表。 ”为前缀的行。 行。 且不为 null， 显示的格式字符串 与每个显示的历史记录条目关联的时间戳。 格式化的时间戳之间不会打印任何空白 和历史线。

Options, if supplied, have the following meanings: 选项（如果提供）具有以下含义：

`-c`

Clear the history list. This may be combined with the other options to replace the history list completely. 清除历史记录列表。 这可以结合起来 使用其他选项完全替换历史记录列表。

`-d offset`\-d offset

Delete the history entry at position offset. If offset is positive, it should be specified as it appears when the history is displayed. If offset is negative, it is interpreted as relative to one greater than the last history position, so negative indices count back from the end of the history, and an index of ‘\-1’ refers to the current `history -d` command. 删除位置offset如果offset如果offset历史记录的末尾，索引“\-1`history -d`处的历史记录条目。 为正，则应指定为以下情况下的显示值 将显示历史记录。 为负数，则将其解释为相对于较大的偏移量 比上一个历史位置，因此负指数从 ”表示当前 命令。

`-d start-end`\-d start\-end

Delete the range of history entries between positions start and end, inclusive. Positive and negative values for start and end are interpreted as described above. 删除仓startendstart和end和 ，包括在内。 的正值和负值 解释如上所述。

`-a`

Append the new history lines to the history file. These are history lines entered since the beginning of the current Bash session, but not already appended to the history file. 将新的历史记录行追加到历史记录文件中。 这些是自当前开始以来输入的历史线 Bash 会话，但尚未追加到历史记录文件中。

`-n`

Append the history lines not already read from the history file to the current history list. These are lines appended to the history file since the beginning of the current Bash session. 附加尚未从历史记录文件中读取的历史记录行 到当前历史记录列表。 这些是附加到历史记录中的行 文件，因为当前 Bash 会话开始。

`-r`

Read the history file and append its contents to the history list. 读取历史记录文件并将其内容附加到 历史记录列表。

`-w`

Write out the current history list to the history file. 将当前历史记录列表写入历史记录文件。

`-p`

Perform history substitution on the args and display the result on the standard output, without storing the results in the history list. 对 args 执行历史替换并显示结果 在标准输出中，而不将结果存储在历史记录列表中。

`-s`

The args are added to the end of the history list as a single entry. args 被添加到 历史记录列表作为单个条目。

If a filename argument is supplied when any of the \-w, \-r, \-a, or \-n options is used, Bash uses filename as the history file. If not, then the value of the `HISTFILE` variable is used. 如果提供了 filename\-w、\-r、\-a 或 \-n，Bash 使用 filename如果没有，则使用 `HISTFILE` 参数 选项中的任何一个 作为历史文件。 变量的值。

The return value is 0 unless an invalid option is encountered, an error occurs while reading or writing the history file, an invalid offset or range is supplied as an argument to \-d, or the history expansion supplied as an argument to \-p fails. offset 或 range 作为 \-d作为 \-p返回值为 0，除非遇到无效选项，否则返回值为 读取或写入历史记录文件时发生错误，无效 的参数提供，或者 参数提供的历史扩展失败。

___

### 9.3 History Expansion9.3 历史扩展

The History library provides a history expansion feature that is similar to the history expansion provided by `csh`. This section describes the syntax used to manipulate the history information. 到 `csh`历史记录库提供了类似的历史记录扩展功能 提供的历史扩展。 本节 描述用于操作历史记录信息的语法。

History expansions introduce words from the history list into the input stream, making it easy to repeat commands, insert the arguments to a previous command into the current input line, or fix errors in previous commands quickly. 历史扩展将历史列表中的单词引入 输入流，便于重复命令，插入 将上一个命令的参数输入到当前输入行中，或者 快速修复以前命令中的错误。

History expansion is performed immediately after a complete line is read, before the shell breaks it into words, and is performed on each line individually. Bash attempts to inform the history expansion functions about quoting still in effect from previous lines. 在完成一行之后立即执行历史记录扩展 在 shell 将其分解成单词之前被读取，并被执行 分别在每一行上。 Bash 尝试告知历史记录 关于引用的扩展函数仍然有效。

History expansion takes place in two parts. The first is to determine which line from the history list should be used during substitution. The second is to select portions of that line for inclusion into the current one. The line selected from the history is called the _event_, and the portions of that line that are acted upon are called _words_. Various _modifiers_ are available to manipulate the selected words. The line is broken into words in the same fashion that Bash does, so that several words surrounded by quotes are considered one word. History expansions are introduced by the appearance of the history expansion character, which is ‘!’ by default. _事件_称为_单词_。 可以使用各种_修饰符_历史扩展字符，默认为 '!历史扩展分为两部分。 首先是确定 在替换过程中应使用历史记录列表中的哪一行。 第二种是选择该行的部分内容以包含在 当前一个。 从历史记录中选择的行称为 ，并且该行中执行的部分是 进行操作 所选单词。 该行以相同的方式分解为单词 Bash 做到了，所以几个字 用引号括起来被认为是一个词。 历史扩展是通过 '。

History expansion implements shell-like quoting conventions: a backslash can be used to remove the special handling for the next character; single quotes enclose verbatim sequences of characters, and can be used to inhibit history expansion; and characters enclosed within double quotes may be subject to history expansion, since backslash can escape the history expansion character, but single quotes may not, since they are not treated specially within double quotes. 历史扩展实现了类似 shell 的引用约定： 可以使用反斜杠来删除下一个字符的特殊处理; 单引号将字符的逐字序列括起来，可用于 抑制历史扩展; 括在双引号内的字符可能受历史记录的约束 扩展，因为反斜杠可以转义历史扩展字符， 但单引号可能不会，因为它们在内部没有特殊处理 双引号。

When using the shell, only ‘\\’ and ‘'’ may be used to escape the history expansion character, but the history expansion character is also treated as quoted if it immediately precedes the closing double quote in a double-quoted string. 使用 shell 时，只能使用 '\\' 和 ''' 来转义 历史扩展字符，但历史扩展字符是 如果它紧接在结束双引号之前，也被视为引号 在双引号字符串中。

Several shell options settable with the `shopt` builtin (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)) may be used to tailor the behavior of history expansion. If the `histverify` shell option is enabled, and Readline is being used, history substitutions are not immediately passed to the shell parser. Instead, the expanded line is reloaded into the Readline editing buffer for further modification. If Readline is being used, and the `histreedit` shell option is enabled, a failed history expansion will be reloaded into the Readline editing buffer for correction. The \-p option to the `history` builtin command may be used to see what a history expansion will do before using it. The \-s option to the `history` builtin may be used to add commands to the end of the history list without actually executing them, so that they are available for subsequent recall. This is most useful in conjunction with Readline. 可通过`shopt`builtin（参见 [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)`histverify`如果正在使用 Readline，并且 `histreedit``history` 内置命令的 \-p内置`history`的 \-s设置多个shell选项 ）可用于定制 历史扩展的行为。 如果 shell 选项已启用，并且 Readline 正在使用中，历史替换不会立即传递给 shell 解析器。 相反，扩展的行将重新加载到 Readline 中 编辑缓冲区以进行进一步修改。 启用 shell 选项，失败的历史记录扩展将是 重新加载到 Readline 编辑缓冲区进行校正。 选项 可用于在使用历史扩展之前查看它的作用。 选项可用于 将命令添加到历史记录列表的末尾，而无需实际执行 它们，以便它们可用于后续召回。 这与 Readline 结合使用最有用。

The shell allows control of the various characters used by the history expansion mechanism with the `histchars` variable, as explained above (see [Bash Variables](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables)). The shell uses the history comment character to mark history timestamps when writing the history file. 具有 `histchars`如上所述（请参阅 [Bash 变量](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables)shell 允许控制 变量的历史扩展机制， ）。 shell 使用 历史注释字符在以下情况下标记历史时间戳 写入历史记录文件。

-   [Event Designators事件指示符](https://www.gnu.org/software/bash/manual/bash.html#Event-Designators)
-   [Word Designators单词指示符](https://www.gnu.org/software/bash/manual/bash.html#Word-Designators)
-   [Modifiers修饰 符](https://www.gnu.org/software/bash/manual/bash.html#Modifiers)

___

#### 9.3.1 Event Designators9.3.1 事件指示符

An event designator is a reference to a command line entry in the history list. Unless the reference is absolute, events are relative to the current position in the history list. 事件指示符是对 历史记录列表。 除非引用是绝对的，否则事件是相对于当前事件的 在历史记录列表中的位置。

`!`

Start a history substitution, except when followed by a space, tab, the end of the line, ‘\=’ or ‘(’ (when the `extglob` shell option is enabled using the `shopt` builtin). 行尾 '\=' 或 '(`extglob` shell 选项是使用 `shopt`开始历史记录替换，后面跟着空格、制表符、 ' （当 内置的）启用的。

`!n`!n

Refer to command line n. 请参阅命令行 n。

`!-n`！-n

Refer to the command n lines back. 请参阅命令 n 行。

`!!`

Refer to the previous command. This is a synonym for ‘!-1’. 请参阅上一个命令。 这是 '!-1' 的同义词。

`!string`!string

Refer to the most recent command preceding the current position in the history list starting with string. 从string请参阅最新的命令 在历史记录列表中的当前位置之前 开始。

`!?string[?]`!?string\[？\]

Refer to the most recent command preceding the current position in the history list containing string. The trailing ‘?’ may be omitted if the string is followed immediately by a newline. If string is missing, the string from the most recent search is used; it is an error if there is no previous search string. 包含string“?如果string如果缺少string请参阅最新的命令 在历史记录列表中的当前位置之前 。 尾随 后面紧跟着 换行符。 ，则使用最近搜索中的字符串; 如果没有以前的搜索字符串，则为错误。

`^string1^string2^`^string1^string2^

Quick Substitution. Repeat the last command, replacing string1 with string2. Equivalent to `!!:s^string1^string2^`. 快速替换。 重复最后一个命令，替换 string1使用 string2！！：s^string1^string2 。 等效于 ^。

`!#`

The entire command line typed so far. 到目前为止，整个命令行都已键入。

___

#### 9.3.2 Word Designators9.3.2 字指示符

Word designators are used to select desired words from the event. A ‘:’ separates the event specification from the word designator. It may be omitted if the word designator begins with a ‘^’, ‘$’, ‘\*’, ‘\-’, or ‘%’. Words are numbered from the beginning of the line, with the first word being denoted by 0 (zero). Words are inserted into the current line separated by single spaces. “:如果指示符一词以 '^'、'$'\*'、'\-' 或 '%单词指示符用于从事件中选择所需的单词。 将事件规范与单词指示符分开。 它 ' 开头，则可以省略， '。 单词从头开始编号 ，第一个单词用 0（零）表示。 单词是 插入到由单个空格分隔的当前行中。

For example, 例如

`!!`

designates the preceding command. When you type this, the preceding command is repeated in toto. 指定前面的命令。 键入此内容时，前面的 命令重复。

`!!:$`

designates the last argument of the preceding command. This may be shortened to `!$`. 缩写为 `!$`指定上述命令的最后一个参数。 这可能是 。

`!fi:2`

designates the second argument of the most recent command starting with the letters `fi`. 字母 `fi`指定以 .

Here are the word designators: 以下是单词指示符：

`0 (zero)`

The `0`th word. For many applications, this is the command word. 第 `0`个单词。 对于许多应用程序，这是命令词。

`n`

The nth word. 第 n个单词。

`^`

The first argument; that is, word 1. 第一个论点;即单词 1。

`$`

The last argument. 最后一个参数。

`%`

The first word matched by the most recent ‘?string?’ search, if the search string begins with a character that is part of a word. 第一个单词与最近的“？string？搜索 如果搜索字符串以属于单词的字符开头。

`x-y`x

A range of words; ‘\-y’ abbreviates ‘0-y’. 一系列单词;'-y' 缩写 'y'。

`*`

All of the words, except the `0`th. This is a synonym for ‘1-$’. It is not an error to use ‘\*’ if there is just one word in the event; the empty string is returned in that case. 所有单词，除了`0`个。 这是“1-$如果事件中只有一个单词，则使用“\*”的同义词。 ”不是错误; 在这种情况下，将返回空字符串。

`x*`x\*

Abbreviates ‘x\-$’ 缩写 x\-$'

`x-`x\-

Abbreviates ‘x\-$’ like ‘x\*’, but omits the last word. If ‘x’ is missing, it defaults to 0. 缩写“x\-$”，如“x如果缺少“x\*”，但省略最后一个单词。 ”，则默认为 0。

If a word designator is supplied without an event specification, the previous command is used as the event. 如果提供的字指示符没有事件规范，则 上一个命令用作事件。

___

#### 9.3.3 Modifiers9.3.3 修订

After the optional word designator, you can add a sequence of one or more of the following modifiers, each preceded by a ‘:’. These modify, or edit, the word or words selected from the history event. 在以下修饰符中，每个修饰符前面都有一个 ':在可选的单词指示符之后，可以添加一个或多个序列 '。 它们修改或编辑从历史事件中选择的一个或多个单词。

`h`

Remove a trailing pathname component, leaving only the head. 删除尾随路径名组件，仅保留头部。

`t`

Remove all leading pathname components, leaving the tail. 删除所有前导路径名组件，保留尾部。

`r`

Remove a trailing suffix of the form ‘.suffix’, leaving the basename. 删除 ' 形式的尾随后缀。suffix'，离开 基名。

`e`

Remove all but the trailing suffix. 删除除尾随后缀之外的所有后缀。

`p`

Print the new command but do not execute it. 打印新命令，但不要执行它。

`q`

Quote the substituted words, escaping further substitutions. 引用被替换的词语，避免进一步的替换。

`x`

Quote the substituted words as with ‘q’, but break into words at spaces, tabs, and newlines. The ‘q’ and ‘x’ modifiers are mutually exclusive; the last one supplied is used. 引用替换的单词，如“q“q”和“x”， 但在空格、制表符和换行符处折入单词。 ”修饰符是互斥的;最后一个 提供。

`s/old/new/`s/old/new/

Substitute new for the first occurrence of old in the event line. Any character may be used as the delimiter in place of ‘/’. The delimiter may be quoted in old and new with a single backslash. If ‘&’ appears in new, it is replaced by old. A single backslash will quote the ‘&’. If old is null, it is set to the last old substituted, or, if no previous history substitutions took place, the last string in a !?string`[?]` search. If new is null, each matching old is deleted. The final delimiter is optional if it is the last character on the input line. 用 new 代替任何字符都可以用作分隔符来代替“/分隔符可以用new和新使用单个反斜杠。 如果 '&' 出现在 new它被old“&如果 old 为 null，则将其设置为最后一个 old最后一个string在！？string`[?]`如果 new 为 null，则删除每个匹配old 事件行。 ”。 引用 中， 取代。 单个反斜杠将引用 ”。 替换，或者，如果没有发生以前的历史替换， 搜索。 。 如果最后一个分隔符是可选的，则最后一个分隔符是可选的 输入行上的字符。

`&`

Repeat the previous substitution. 重复前面的替换。

`g`

`a`

Cause changes to be applied over the entire event line. Used in conjunction with ‘s’, as in `gs/old/new/`, or with ‘&’. 与 's' 连词，如 gs/old/new或带有“&使更改应用于整个事件行。 用于 / 中， ”。

`G`

Apply the following ‘s’ or ‘&’ modifier once to each word in the event. 对每个单词应用以下“s”或“&”修饰符一次 在事件中。
