
## 3 Basic Shell Features

Bash is an acronym for ‘Bourne-Again SHell’. The Bourne shell is the traditional Unix shell originally written by Stephen Bourne. All of the Bourne shell builtin commands are available in Bash, The rules for evaluation and quoting are taken from the <small>POSIX</small> specification for the 'standard' Unix shell. Bash 是“Bourne-Again SHell评估和报价的规则取自 <small>POSIX</small>”的首字母缩写。 Bourne shell是 传统的 Unix shell 最初由 Stephen Bourne 编写。 所有 Bourne shell 内置命令都可以在 Bash 中使用， "标准"Unix shell 的规范。

This chapter briefly summarizes the shell’s ‘building blocks’: commands, control structures, shell functions, shell _parameters_, shell expansions, _redirections_, which are a way to direct input and output from and to named files, and how the shell executes commands. 命令、控制结构、shell 函数、shell _参数__重定向_本章简要总结了 shell 的“构建块”： 、 壳膨胀， ，这是一种将输入和输出定向到以下位置的方法 和命名文件，以及 shell 如何执行命令。

-   [Shell Syntax](https://www.gnu.org/software/bash/manual/bash.html#Shell-Syntax)
-   [Shell Commands](https://www.gnu.org/software/bash/manual/bash.html#Shell-Commands)
-   [Shell Functions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Functions)
-   [Shell Parameters](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameters)
-   [Shell Expansions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Expansions)
-   [Redirections](https://www.gnu.org/software/bash/manual/bash.html#Redirections)
-   [Executing Commands](https://www.gnu.org/software/bash/manual/bash.html#Executing-Commands)
-   [Shell Scripts](https://www.gnu.org/software/bash/manual/bash.html#Shell-Scripts)

___

### 3.1 Shell Syntax 语法

When the shell reads input, it proceeds through a sequence of operations. If the input indicates the beginning of a comment, the shell ignores the comment symbol (`#`), and the rest of that line. 
当Shell读取输入时，它按顺序执行一系列操作。如果输入表明是注释的开始，则Shell会忽略注释符号（`#`），以及该行的其余部分。

Otherwise, roughly speaking, the shell reads its input and divides the input into words and operators, employing the quoting rules to select which meanings to assign various words and characters. 
否则，大致来说，shell 会读取它的输入并将输入分成单词和操作符，利用引用规则来选择为各种单词和字符分配什么含义。

The shell then parses these tokens into commands and other constructs, removes the special meaning of certain words or characters, expands others, redirects input and output as needed, executes the specified command, waits for the command’s exit status, and makes that exit status available for further inspection or processing. 
然后，Shell将这些标记解析为命令和其他结构，移除特定单词或字符的特殊含义，扩展其他单词或字符，根据需要重定向输入和输出，执行指定的命令，等待命令的退出状态，并使该退出状态可用于进一步检查或处理。

-   [Shell Operation](https://www.gnu.org/software/bash/manual/bash.html#Shell-Operation)
-   [Quoting 引用](https://www.gnu.org/software/bash/manual/bash.html#Quoting)
-   [Comments](https://www.gnu.org/software/bash/manual/bash.html#Comments)

___

#### 3.1.1 Shell Operation

The following is a brief description of the shell’s operation when it reads and executes a command. Basically, the shell does the following: 
下面是当shell读取和执行命令时的简要描述。基本上，shell会执行以下操作：




1.  Reads its input from a file (see [Shell Scripts](https://www.gnu.org/software/bash/manual/bash.html#Shell-Scripts)), from a string supplied as an argument to the \-c invocation option (see [Invoking Bash](https://www.gnu.org/software/bash/manual/bash.html#Invoking-Bash)), or from the user’s terminal. 从文件中读取输入（参见Shell脚本），从作为-c调用选项参数提供的字符串（参见调用Bash），或者从用户的终端读取输入。  
2.  Breaks the input into words and operators, obeying the quoting rules described in [Quoting](https://www.gnu.org/software/bash/manual/bash.html#Quoting). These tokens are separated by `metacharacters`. Alias expansion is performed by this step (see [Aliases](https://www.gnu.org/software/bash/manual/bash.html#Aliases)). 根据引用规则将输入分解为单词和运算符，这些标记由元字符分隔。在这一步骤中执行别名扩展（参见别名）。
3.  Parses the tokens into simple and compound commands (see [Shell Commands](https://www.gnu.org/software/bash/manual/bash.html#Shell-Commands)). 将标记解析为简单和复合命令（参见Shell命令）。
4.  Performs the various shell expansions (see [Shell Expansions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Expansions)), breaking the expanded tokens into lists of filenames (see [Filename Expansion](https://www.gnu.org/software/bash/manual/bash.html#Filename-Expansion)) and commands and arguments.  执行各种shell扩展（参见Shell扩展），将扩展后的标记分解为文件名列表（参见文件名扩展）和命令以及参数。
5.  Performs any necessary redirections (see [Redirections](https://www.gnu.org/software/bash/manual/bash.html#Redirections)) and removes the redirection operators and their operands from the argument list. 执行任何必要的重定向（参见重定向），并从参数列表中删除重定向运算符及其操作数。
6.  Executes the command (see [Executing Commands](https://www.gnu.org/software/bash/manual/bash.html#Executing-Commands)). 执行命令（参见执行命令）。 
7.  Optionally waits for the command to complete and collects its exit status (see [Exit Status](https://www.gnu.org/software/bash/manual/bash.html#Exit-Status)). 可选择等待命令完成并收集其退出状态（参见退出状态）。

___

#### 3.1.2 Quoting 引用

Quoting is used to remove the special meaning of certain characters or words to the shell. Quoting can be used to disable special treatment for special characters, to prevent reserved words from being recognized as such, and to prevent parameter expansion. 
引用用于删除某些的特殊含义 字符或单词到shell。 引用可用于 禁用特殊字符的特殊处理，以防止 保留词不被识别为保留词，并防止 参数扩展。

Each of the shell metacharacters (see [Definitions](https://www.gnu.org/software/bash/manual/bash.html#Definitions)) has special meaning to the shell and must be quoted if it is to represent itself. When the command history expansion facilities are being used (see [History Expansion](https://www.gnu.org/software/bash/manual/bash.html#History-Interaction)), the _history expansion_ character, usually `!`, must be quoted to prevent history expansion. See [Bash History Facilities](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Facilities), for more details concerning history expansion. 每个 shell 元字符（请参阅[定义](https://www.gnu.org/software/bash/manual/bash.html#Definitions)（见[历史扩展](https://www.gnu.org/software/bash/manual/bash.html#History-Interaction)_历史扩展_字符，通常为“!以防止历史记录扩展。 请参阅 [Bash 历史记录工具](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Facilities)） 对shell有特殊意义，如果要引用 代表自己。 使用命令历史记录扩展工具时 ），则 ，必须引用 ，了解 有关历史扩展的更多详细信息。

There are three quoting mechanisms: the _escape character_, single quotes, and double quotes.  
_转义字符_有三种引用机制： 、单引号和双引号。

-   [Escape Character](https://www.gnu.org/software/bash/manual/bash.html#Escape-Character)
-   [Single Quotes](https://www.gnu.org/software/bash/manual/bash.html#Single-Quotes)
-   [Double Quotes](https://www.gnu.org/software/bash/manual/bash.html#Double-Quotes)
-   [ANSI-C Quoting](https://www.gnu.org/software/bash/manual/bash.html#ANSI_002dC-Quoting)
-   [Locale-Specific Translation](https://www.gnu.org/software/bash/manual/bash.html#Locale-Translation)

___

#### 3.1.2.1 Escape Character 转义字符

A non-quoted backslash `\\` is the Bash escape character. It preserves the literal value of the next character that follows, with the exception of `newline`. If a `\newline` pair appears, and the backslash itself is not quoted, the `\newline` is treated as a line continuation (that is, it is removed from the input stream and effectively ignored). 

不带引号的反斜杠\\换`newline`除外。 如果 `\newline`出现，并且反斜杠本身没有引号，`\newline`是 Bash 转义字符。 它保留了后面下一个字符的文字值， 对 被视为行延续（即，它从 输入流并被有效忽略）。

___

#### 3.1.2.2 Single Quotes 单引号

Enclosing characters in single quotes (`'`) preserves the literal value of each character within the quotes. A single quote may not occur between single quotes, even when preceded by a backslash. 

将字符括在单引号 （`'`） 中可保留文本值 引号内的每个字符。

___

#### 3.1.2.3 Double Quotes 双引号

Enclosing characters in double quotes (`"`) preserves the literal value of all characters within the quotes, with the exception of `\$`, `\``, `\\`, and, when history expansion is enabled, `!`. When the shell is in <small>POSIX</small> mode (see [Bash POSIX Mode](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)), the `!` has no special meaning within double quotes, even when history expansion is enabled. The characters `\$` and `\`` retain their special meaning within double quotes (see [Shell Expansions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Expansions)). The backslash retains its special meaning only when followed by one of the following characters: '$`, `\``, `"`, `\\', or `newline`. Within double quotes, backslashes that are followed by one of these characters are removed. Backslashes preceding characters without a special meaning are left unmodified. A double quote may be quoted within double quotes by preceding it with a backslash. If enabled, history expansion will be performed unless an `!` appearing in double quotes is escaped using a backslash. The backslash preceding the `!` is not removed. 

双引号(`"`)中包含的字符保留引号中所有字符的字面值，除了`\$`、`\``、`\\`，以及`!`(在启用历史扩展时)。当shell处于POSIX模式(参见Bash POSIX模式)时，`!`在双引号中没有特殊含义，即使启用了历史扩展。
字符`\$`和`\``在双引号中保留其特殊含义(参见Shell扩展)。

只有当反斜杠后面跟着下列字符之一时，它才保留其特殊含义:`\$`、`\``、`"`、`\\`或newline。在双引号中，后面跟着其中一个字符的反斜杠将被删除。前面没有特殊含义的反斜杠不作修改。双引号可以在双引号中加上反斜杠。如果启用，将执行历史扩展，除非使用`!`出现在双引号中使用反斜杠进行转义。反斜杠在`!`不会被移除。

The special parameters `\*` and `@` have special meaning when in double quotes (see [Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)). 

特殊参数`\*`和@当在双引号中时（请参阅 [Shell 参数扩展](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)”具有特殊含义 ）。

___

#### 3.1.2.4 ANSI-C Quoting

Character sequences of the form $’string’ are treated as a special kind of single quotes. The sequence expands to string, with backslash-escaped characters in string replaced as specified by the ANSI C standard. Backslash escape sequences, if present, are decoded as follows: 
`$`string序列扩展为string替换为 ANSI C 标准指定的string' 形式的字符序列被视为特殊字符序列 有点单引号。 ，带有反斜杠转义字符 。 反斜杠转义序列（如果存在）按如下方式解码：

`\a`

alert (bell) 警报（铃铛）

`\b`

backspace 退格键

`\e`

`\E`

an escape character (not ANSI C) 

`\f`

form feed

`\n`

newline

`\r`

carriage return

`\t`

horizontal tab

`\v`

vertical tab

`\\`

backslash

`\'`

single quote

`\"`

double quote

`\?`

question mark

`\nnn`

the eight-bit character whose value is the octal value nnn (one to three octal digits) 值为八进制值 nnn 的八位字符 （一到三个八进制数字）

`\xHH`

the eight-bit character whose value is the hexadecimal value HH (one or two hex digits) 值为十六进制值 HH 的八位字符 （一个或两个十六进制数字）

`\uHHHH`

the Unicode (ISO/IEC 10646) character whose value is the hexadecimal value HHHH (one to four hex digits) HHHHUnicode （ISO/IEC 10646） 字符，其值为十六进制值 （一到四个十六进制数字）

`\UHHHHHHHH`

the Unicode (ISO/IEC 10646) character whose value is the hexadecimal value HHHHHHHH (one to eight hex digits) HHHHHHHHUnicode （ISO/IEC 10646） 字符，其值为十六进制值 一到八个十六进制数字）

`\cx`

a control-x character

The expanded result is single-quoted, as if the dollar sign had not been present.

___

#### 3.1.2.5 Locale-Specific Translation 特定于语言环境的翻译

Prefixing a double-quoted string with a dollar sign (`\$`), such as \$"hello, world", will cause the string to be translated according to the current locale. The `gettext` infrastructure performs the lookup and translation, using the `LC_MESSAGES`, `TEXTDOMAINDIR`, and `TEXTDOMAIN` shell variables, as explained below. See the gettext documentation for additional details not covered here. If the current locale is `C` or `POSIX`, if there are no translations available, of if the string is not translated, the dollar sign is ignored. 

Since this is a form of double quoting, the string remains double-quoted by default, whether or not it is translated and replaced. If the `noexpand_translation` option is enabled using the `shopt` builtin (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)), translated strings are single-quoted instead of double-quoted. 

在双引号字符串前面加上 ``$`` $"hello, world" `gettext`翻译，使用 `LC_MESSAGES` `TEXTDOMAINDIR`和 `TEXTDOMAIN`如果当前语言环境是 `C` 或 `POSIX`如果启用`noexpand_translation`使用 `shopt` builtin（参见 [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)'），例如 ， 将导致根据当前区域设置翻译字符串。 基础结构执行查找和 shell 变量，如下所述。 

如果没有可用的翻译， 如果字符串未翻译， ``$``将被忽略。 由于这是一种双引号形式，因此字符串保持双引号 默认情况下，无论它是否被翻译和替换。 选项 ）， 翻译的字符串是单引号而不是双引号。

The rest of this section is a brief overview of how you use gettext to create translations for strings in a shell script named scriptname. There are more details in the gettext documentation. 
在名为 scriptname本节的其余部分简要概述了如何使用 gettext 来执行以下操作 的 shell 脚本中为字符串创建翻译。 gettext 文档中有更多详细信息。

___

#### Creating Internationalized Scripts 创建国际化脚本

Once you’ve marked the strings in your script that you want to translate using $"...", you create a gettext "template" file using the command 在脚本中标记字符串后 你想用$"..."翻译， 使用命令创建 gettext"template"文件

```bash
bash --dump-po-strings scriptname > domain.pot
```

The domain is your _message domain_. It’s just an arbitrary string that’s used to identify the files gettext needs, like a package or script name. It needs to be unique among all the message domains on systems where you install the translations, so gettext knows which translations correspond to your script. You’ll use the template file to create translations for each target language. The template file conventionally has the suffix `.pot`. 

domain是_您的消息域_模板文件通常具有后缀“.pot。 它只是一个用于标识文件 gettext 的任意字符串 需求，例如包或脚本名称。 它需要在所有产品中独一无二 安装翻译的系统上的消息域，因此 gettext 知道哪些翻译与您的脚本相对应。 您将使用模板文件为每种目标语言创建翻译。 ”。

You copy this template file to a separate file for each target language you want to support (called "PO" files, which use the suffix `.po`). PO files use various naming conventions, but when you are working to translate a template file into a particular language, you first copy the template file to a file whose name is the language you want to target, with the `.po` suffix. For instance, the Spanish translations of your strings would be in a file named `es.po`, and to get started using a message domain named "example," you would run

```bash
cp example.pot es.po
```

您要支持（称为"PO"文件，使用后缀“.po要定位的语言，后缀为`.po`在名为`es.po`将此模板文件复制到每种目标语言的单独文件中 ”）。 PO 文件使用各种命名约定，但 当您努力将模板文件转换为特定的 语言，则首先将模板文件复制到名称为 ”。 例如，您的字符串的西班牙语翻译将是 ”的文件中，并开始使用消息 域名为“example”，您将运行

Ultimately, PO files are often named domain.po and installed in directories that contain multiple translation files for a particular language. 
最终，PO 文件通常被命名为 domain 并安装在 包含特定语言的多个翻译文件的目录。

Whichever naming convention you choose, you will need to translate the strings in the PO files into the appropriate languages. This has to be done manually. 

无论您选择哪种命名约定，您都需要翻译 将 PO 文件中的字符串转换为适当的语言。 这必须手动完成。

When you have the translations and PO files complete, you’ll use the gettext tools to produce what are called "MO" files, which are compiled versions of the PO files the gettext tools use to look up translations efficiently. MO files are also called "message catalog" files. You use the `msgfmt` program to do this. For instance, if you had a file with Spanish translations, you could run

 ```bash
 msgfmt -o es.mo es.po
 ```
to produce the corresponding MO file. 
 您可以使用 `msgfmt`完成翻译和 PO 文件后，您将使用 gettext 工具来生成所谓的"MO"文件，这些文件被编译 gettext 工具用于查找翻译的 PO 文件的版本 有效。 MO文件也称为“消息目录”文件。 程序来执行此操作。 例如，如果你有一个带有西班牙语翻译的文件，你可以运行
 
 ```bash
 msgfmt -o es.mo es.po
 ```

 生成相应的 MO 文件。

Once you have the MO files, you decide where to install them and use the `TEXTDOMAINDIR` shell variable to tell the gettext tools where they are. Make sure to use the same message domain to name the MO files as you did for the PO files when you install them. 
获得 MO 文件后，您可以决定在哪里安装它们并使用 shell 变量`TEXTDOMAINDIR`告诉 gettext 工具它们的位置。 请确保使用相同的消息域来命名 MO 文件 就像您在安装 PO 文件时对它们所做的那样。

Your users will use the `LANG` or `LC_MESSAGES` shell variables to select the desired language. 

用户将使用 `LANG` 或 `LC_MESSAGES` shell 变量选择所需的语言。

You set the `TEXTDOMAIN` variable to the script’s message domain. As above, you use the message domain to name your translation files. 
将 `TEXTDOMAIN` 变量设置为脚本的消息域。 如上所述，您可以使用消息域来命名翻译文件。

You, or possibly your users, set the `TEXTDOMAINDIR` variable to the name of a directory where the message catalog files are stored. If you install the message files into the system’s standard message catalog directory, you don’t need to worry about this variable. 

您（也可能是您的用户）将 `TEXTDOMAINDIR` 变量设置为 存储邮件目录文件的目录的名称。 如果将消息文件安装到系统的标准消息目录中 目录，你不需要担心这个变量。

The directory where the message catalog files are stored varies between systems. Some use the message catalog selected by the `LC_MESSAGES` shell variable. Others create the name of the message catalog from the value of the `TEXTDOMAIN` shell variable, possibly adding the `.mo` suffix. If you use the `TEXTDOMAIN` variable, you may need to set the `TEXTDOMAINDIR` variable to the location of the message catalog files, as above. 
存储message catalog文件的目录因系统而异。有些人使用由`LC_MESSAGES` shell变量。其他人从`TEXTDOMAIN` shell变量的值，可能还会添加`.mo` 后缀。如果你使用`TEXTDOMAIN`变量，你可能需要将`TEXTDOMAINDIR`变量设置为message catalog文件的位置，如上所示。

It’s common to use both variables in this fashion: `$TEXTDOMAINDIR`/`$LC_MESSAGES`/`LC_MESSAGES`/`$TEXTDOMAIN`.mo. 


If you used that last convention, and you wanted to store the message catalog files with Spanish (es) and Esperanto (eo) translations into a local directory you use for custom translation files, you could run 

```bash
TEXTDOMAIN=example
TEXTDOMAINDIR=/usr/local/share/locale

cp es.mo ${TEXTDOMAINDIR}/es/LC_MESSAGES/${TEXTDOMAIN}.mo
cp eo.mo ${TEXTDOMAINDIR}/eo/LC_MESSAGES/${TEXTDOMAIN}.mo
```

When all of this is done, and the message catalog files containing the compiled translations are installed in the correct location, your users will be able to see translated strings in any of the supported languages by setting the `LANG` or `LC_MESSAGES` environment variables before running your script. 

在任何支持的语言中，通过设置 `LANG`在运行脚本之前`LC_MESSAGES`完成所有这些操作后，包含 编译后的翻译安装在正确的位置， 您的用户将能够看到翻译后的字符串 或 环境变量。

___

### 3.2 Shell Commands

A simple shell command such as `echo a b c` consists of the command itself followed by arguments, separated by spaces. 
一个简单的 shell 命令（如 `echo a b c`）由以下命令组成： 本身后跟参数，用空格分隔。

More complex shell commands are composed of simple commands arranged together in a variety of ways: in a pipeline in which the output of one command becomes the input of a second, in a loop or conditional construct, or in some other grouping. 
更复杂的 shell 命令由排列在一起的简单命令组成 以多种方式：在一个管道中，一个命令的输出 成为秒的输入，在循环或条件结构中，或在 其他一些分组。

-   [Reserved Words](https://www.gnu.org/software/bash/manual/bash.html#Reserved-Words)
-   [Simple Commands](https://www.gnu.org/software/bash/manual/bash.html#Simple-Commands)
-   [Pipelines](https://www.gnu.org/software/bash/manual/bash.html#Pipelines)
-   [Lists of Commands](https://www.gnu.org/software/bash/manual/bash.html#Lists)
-   [Compound Commands](https://www.gnu.org/software/bash/manual/bash.html#Compound-Commands)
-   [Coprocesses](https://www.gnu.org/software/bash/manual/bash.html#Coprocesses)
-   [GNU Parallel](https://www.gnu.org/software/bash/manual/bash.html#GNU-Parallel)

___

#### 3.2.1 Reserved Words 保留字

Reserved words are words that have special meaning to the shell. They are used to begin and end the shell’s compound commands. 
保留词是对shell具有特殊含义的词。 它们用于开始和结束 shell 的复合命令。

The following words are recognized as reserved when unquoted and the first word of a command (see below for exceptions): 以下词语在未加引号时被识别为保留词，并且 命令的第一个单词（有关例外情况，请参见下文）：

<table><tbody><tr><td><code>if</code></td><td><code>then</code></td><td><code>elif</code></td><td><code>else</code></td><td><code>fi</code></td><td><code>time</code></td></tr><tr><td><code>for</code></td><td><code>in</code></td><td><code>until</code></td><td><code>while</code></td><td><code>do</code></td><td><code>done</code></td></tr><tr><td><code>case</code></td><td><code>esac</code></td><td><code>coproc</code></td><td><code>select</code></td><td><code>function</code></td></tr><tr><td><code>{</code></td><td><code>}</code></td><td><code>[[</code></td><td><code>]]</code></td><td><code>!</code></td></tr></tbody></table>

`in` is recognized as a reserved word if it is the third word of a `case` or `select` command. `in` and `do` are recognized as reserved words if they are the third word in a `for` command. 

`in``case` 或 `select``in` 和 `do`单词，如果它们是 `for` 是 a 的第三个单词，则将其识别为保留字 命令。 被识别为保留 命令中的第三个单词。

___

#### 3.2.2 Simple Commands 简单命令

A simple command is the kind of command encountered most often. It’s just a sequence of words separated by `blank`s, terminated by one of the shell’s control operators (see [Definitions](https://www.gnu.org/software/bash/manual/bash.html#Definitions)). The first word generally specifies a command to be executed, with the rest of the words being that command’s arguments. 

简单命令是最常遇到的命令。它只是一个由空格分隔的单词序列，由shell的一个控制操作符终止(参见定义)。第一个单词通常指定要执行的命令，其余的单词是该命令的参数。

The return status (see [Exit Status](https://www.gnu.org/software/bash/manual/bash.html#Exit-Status)) of a simple command is its exit status as provided by the <small>POSIX</small> 1003.1 `waitpid` function, or 128+n if the command was terminated by signal n. 

简单命令的返回状态(参见退出状态)是由`POSIX 1003.1` `waitpid`函数提供的退出状态，如果命令被信号n终止，则返回128+n。

___

#### 3.2.3 Pipelines 管道

A `pipeline` is a sequence of one or more commands separated by one of the control operators `|` or `|&`. 

`pipeline`是一个或多个命令的序列 由 控制运算符 `|` 或 `|&` 分隔。

The format for a pipeline is

```bash
[time [-p]] [!] command1 [ | or |& command2 ] …
```

The output of each command in the pipeline is connected via a pipe to the input of the next command. That is, each command reads the previous command’s output. This connection is performed before any redirections specified by command1. 
管道中每个命令的输出通过管道连接到下一个命令的输入。也就是说，每个命令都会读取前一个命令的输出。此连接在command1指定的任何重定向之前执行。

If `|&` is used, command1’s standard error, in addition to its standard output, is connected to command2’s standard input through the pipe; it is shorthand for `2>&1 |`. This implicit redirection of the standard error to the standard output is performed after any redirections specified by command1. 

如果使用`|&`，则除了其标准输出外，command1的标准错误还通过管道连接到command2的标准输入;它是v`2>&1 |`v的缩写。在command1指定的任何重定向之后，将标准错误隐式重定向到标准输出。

The reserved word `time` causes timing statistics to be printed for the pipeline once it finishes. The statistics currently consist of elapsed (wall-clock) time and user and system time consumed by the command’s execution.
 The \-p option changes the output format to that specified by <small>POSIX</small>. When the shell is in <small>POSIX</small> mode (see [Bash POSIX Mode](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)), it does not recognize `time` as a reserved word if the next token begins with a `\-`. The `TIMEFORMAT` variable may be set to a format string that specifies how the timing information should be displayed. See [Bash Variables](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables), for a description of the available formats. 
 
 The use of `time` as a reserved word permits the timing of shell builtins, shell functions, and pipelines. An external `time` command cannot time these easily. 

保留字time会在流水线完成时打印出统计数据。当前的统计数据包括运行时间(墙上时钟)以及执行命令所消耗的用户和系统时间。-p选项将输出格式改为POSIX指定的格式。当shell处于POSIX模式(参见Bash POSIX模式)时，如果下一个令牌以`-`开头，它不会将时间识别为保留字。TIMEFORMAT变量可以设置为一个格式字符串，指定如何显示时间信息。有关可用格式的描述，请参阅Bash变量。使用time作为保留字，可以对shell内建程序、shell函数和管道进行计时。外部时间命令不能轻松地对这些进行计时。

When the shell is in <small>POSIX</small> mode (see [Bash POSIX Mode](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)), `time` may be followed by a newline. In this case, the shell displays the total user and system time consumed by the shell and its children. The `TIMEFORMAT` variable may be used to specify the format of the time information. 

当 shell 处于 <small>POSIX</small> 模式（参见 [Bash POSIX 模式](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)）时，`time``TIMEFORMAT` 后面可能跟一个换行符。 在本例中，shell 显示 shell 及其子级消耗的用户和系统总时间。 变量可用于指定 时间信息。

If the pipeline is not executed asynchronously (see [Lists of Commands](https://www.gnu.org/software/bash/manual/bash.html#Lists)), the shell waits for all commands in the pipeline to complete. 

如果管道不是异步执行的（请参阅[命令列表](https://www.gnu.org/software/bash/manual/bash.html#Lists)），则 shell 等待管道中的所有命令完成。

Each command in a multi-command pipeline, where pipes are created, is executed in its own _subshell_, which is a separate process (see [Command Execution Environment](https://www.gnu.org/software/bash/manual/bash.html#Command-Execution-Environment)). If the `lastpipe` option is enabled using the `shopt` builtin (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)), the last element of a pipeline may be run by the shell process when job control is not active. 

在创建管道的多命令管道中，每个命令都在自己的子 shell 中执行，子 shell 是一个独立的进程（见命令执行环境）。如果启用了 lastpipe 选项（见 The Shopt Builtin），则当没有激活作业控制时，管道的最后一个元素可能由 shell 进程执行。

The exit status of a pipeline is the exit status of the last command in the pipeline, unless the `pipefail` option is enabled (see [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)). If `pipefail` is enabled, the pipeline’s return status is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands exit successfully. 
If the reserved word `!` precedes the pipeline, the exit status is the logical negation of the exit status as described above. The shell waits for all commands in the pipeline to terminate before returning a value. 

管道的退出状态是管道中最后一个命令的退出状态，除非启用了“pipefail”选项（有关“set”内置命令的详细信息，请参见“set”内置命令）。如果启用了“pipefail”选项，则管道的返回状态是最后一个（最右侧）退出时返回非零状态的命令的值，或者如果所有命令都成功退出，则为零。
如果用"!"保留字作为管道的前缀，则退出状态为上述描述的退出状态的逻辑否定。shell会在所有管道中的命令都终止后才返回一个值。

___

#### 3.2.4 Lists of Commands 命令列表

A `list` is a sequence of one or more pipelines separated by one of the operators ';`, `&`, `&&', or `||`, and optionally terminated by one of ';`, `&', or a `newline`. 

一个 `list` 是一个由分隔符 `;`、`&`、`&&` 或 `||` 分隔的一或多个管道的序列，并且可以由分隔符 `;`、`&` 或`newline`终止。

Of these list operators, `&&` and `||` have equal precedence, followed by `;` and `&`, which have equal precedence. 
在这些列表运算符中，"&&"和`||`具有相等的优先级，后跟 `;` 和 `&`， 它们具有同等的优先级。

A sequence of one or more newlines may appear in a `list` to delimit commands, equivalent to a semicolon. 

`list`可能会出现一个或多个换行符的序列 分隔命令，相当于分号。

If a command is terminated by the control operator `&`, the shell executes the command asynchronously in a subshell. This is known as executing the command in the _background_, and these are referred to as _asynchronous_ commands. The shell does not wait for the command to finish, and the return status is 0 (true). When job control is not active (see [Job Control](https://www.gnu.org/software/bash/manual/bash.html#Job-Control)), the standard input for asynchronous commands, in the absence of any explicit redirections, is redirected from `/dev/null`. 

如果命令被控制运算符`&`终止，shell会在子shell中异步执行该命令。这被称为在* *后台* *执行命令，这些被称为* *异步* *命令。shell不会等待命令执行完毕，返回状态为0 (true)。当作业控制未激活时(请参阅[作业控制](https://www.gnu.org/software/bash/manual/bash.html#Job-Control))，异步命令的标准输入，在没有任何显式重定向的情况下，将从`/dev/null`重定向。

Commands separated by a `;` are executed sequentially; the shell waits for each command to terminate in turn. The return status is the exit status of the last command executed. 

以`;`分隔的命令按顺序执行;shell会等待每个命令依次结束。返回状态是最后一条命令的退出状态。

<small>AND</small> and <small>OR</small> lists are sequences of one or more pipelines separated by the control operators `&&` and `||`, respectively. <small>AND</small> and <small>OR</small> lists are executed with left associativity. 

<small>AND</small>和<small>OR</small>列表是一个或多个管道的序列，分别由控制操作符`&&`和`||`分隔。<small>AND</small>、<small>OR</small>列表按左结合性执行。

An <small>AND</small> list has the form 

```bash
command1 && command2
```
command2 is executed if, and only if, command1 returns an exit status of zero (success). 
当且仅当command1返回0(成功)退出状态时，将执行Command2。

An <small>OR</small> list has the form

```bash
command1 || command2
```

command2 is executed if, and only if, command1 returns a non-zero exit status. 当且仅当command1返回非零退出状态时，将执行Command2。

The return status of <small>AND</small> and <small>OR</small> lists is the exit status of the last command executed in the list. 

<small>AND</small> and <small>OR</small>列表的返回状态是列表中最后一个命令的退出状态。

___

#### 3.2.5 Compound Commands 复合命令

Compound commands are the shell programming language constructs. Each construct begins with a reserved word or control operator and is terminated by a corresponding reserved word or operator. Any redirections (see [Redirections](https://www.gnu.org/software/bash/manual/bash.html#Redirections)) associated with a compound command apply to all commands within that compound command unless explicitly overridden. 与复合命令关联的任何重定向[（请参阅重定向](https://www.gnu.org/software/bash/manual/bash.html#Redirections)复合命令是 shell 编程语言结构。 每个结构都以保留字或控制运算符开头，并且是 由相应的保留字或运算符终止。 ） 应用于该复合命令中的所有命令，除非显式覆盖。

In most cases a list of commands in a compound command’s description may be separated from the rest of the command by one or more newlines, and may be followed by a newline in place of a semicolon. 在大多数情况下，复合命令描述中的命令列表可能是 用一个或多个换行符与命令的其余部分分隔，并且可以 后跟一个换行符代替分号。

Bash provides looping constructs, conditional commands, and mechanisms to group commands and execute them as a unit. Bash 提供循环构造、条件命令和机制 对命令进行分组并将它们作为一个单元执行。

-   [Looping Constructs](https://www.gnu.org/software/bash/manual/bash.html#Looping-Constructs)
-   [Conditional Constructs](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)
-   [Grouping Commands](https://www.gnu.org/software/bash/manual/bash.html#Command-Grouping)

___

#### 3.2.5.1 Looping Constructs

Bash supports the following looping constructs. 

Note that wherever a `;` appears in the description of a command’s syntax, it may be replaced with one or more newlines. 
请注意，无论在描述中出现 ";" 的位置 命令的语法，可以替换为一个或多个换行符。

`until`

The syntax of the `until` command is: 

```bash
until test-commands; do consequent-commands; done
```

Execute consequent-commands as long as test-commands has an exit status which is not zero. The return status is the exit status of the last command executed in consequent-commands, or zero if none was executed. 

执行consequent-commandstest-commands在consequent-commands，只要 的退出状态不为零。 返回状态是上次执行的命令的退出状态 中，如果未执行任何命令，则为零。

`while`

The syntax of the `while` command is:  

```bash
while test-commands; do consequent-commands; done
```

Execute consequent-commands as long as test-commands has an exit status of zero. The return status is the exit status of the last command executed in consequent-commands, or zero if none was executed. 

执行consequent-commandstest-commands在consequent-commands，只要 的退出状态为零。 返回状态是上次执行的命令的退出状态 中，如果未执行任何命令，则为零。

`for`

The syntax of the `for` command is: 

```bash
for name [ [in [words …] ] ; ] do commands; done
```

Expand words (see [Shell Expansions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Expansions)), and execute commands once for each member in the resultant list, with name bound to the current member. If 'in words' is not present, the `for` command executes the commands once for each positional parameter that is set, as if 'in "$@"' had been specified (see [Special Parameters](https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters)). 

展开words词（请参阅 [Shell 扩展](https://www.gnu.org/software/bash/manual/bash.html#Shell-Expansions)），并执行commands在结果列表中，name如果“words”不存在，`for`对每个位置参数执行一次commands设置，就好像指定了in "$@"（请参阅[特殊参数](https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters) 每个成员一次 绑定到当前成员。 命令 ，即 一样 ）。

The return status is the exit status of the last command that executes. If there are no items in the expansion of words, no commands are executed, and the return status is zero. 

如果words返回状态是执行的最后一个命令的退出状态。 扩展中没有项目，则没有命令 已执行，返回状态为零。

An alternate form of the `for` command is also supported: 

```bash
for (( expr1 ; expr2 ; expr3 )) ; do commands ; done
```

First, the arithmetic expression expr1 is evaluated according to the rules described below (see [Shell Arithmetic](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)). The arithmetic expression expr2 is then evaluated repeatedly until it evaluates to zero. Each time expr2 evaluates to a non-zero value, commands are executed and the arithmetic expression expr3 is evaluated. If any expression is omitted, it behaves as if it evaluates to 1. The return value is the exit status of the last command in commands that is executed, or false if any of the expressions is invalid. 

首先，计算算术表达式 expr1到下面描述的规则（参见 [Shell 算术](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)然后重复计算算术表达式 expr2每次 expr2 计算结果为非零值时，commands执行并计算算术表达式 expr3返回值是commands ）。 直到它的计算结果为零。 是 。 如果省略任何表达式，则其行为就像它的计算结果为 1 一样。 中最后一个命令的退出状态 如果任何表达式无效，则执行 false。

The `break` and `continue` builtins (see [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)) may be used to control loop execution. 

`break``continue`（参见 [Bourne Shell 内置）](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins) 可用于控制循环执行。

___

#### 3.2.5.2 Conditional Constructs

`if`

The syntax of the `if` command is:

```bash
if test-commands; then
  consequent-commands;
[elif more-test-commands; then
  more-consequents;]
[else alternate-consequents;]
fi
```

The test-commands list is executed, and if its return status is zero, the consequent-commands list is executed. If test-commands returns a non-zero status, each `elif` list is executed in turn, and if its exit status is zero, the corresponding more-consequents is executed and the command completes. If ‘else alternate-consequents’ is present, and the final command in the final `if` or `elif` clause has a non-zero exit status, then alternate-consequents is executed. The return status is the exit status of the last command executed, or zero if no condition tested true. 

test-commands列表会被执行，如果它的返回状态为零，那么result-commands列表会被执行。如果test-commands返回非零状态，则依次执行每个`elif`列表，如果其退出状态为零，则执行相应的more-consequences，并完成命令。如果` else alternative-consequences `存在，并且最后一个` if `或`elif`子句中的最后一个命令具有非零退出状态，则执行` alternative - consequences `。返回状态是最后一个命令的退出状态，如果没有测试条件为真，则返回0。

`case`

The syntax of the `case` command is:

```bash
case word in
    [ [(] pattern [| pattern]…) command-list ;;]…
esac
```

`case` will selectively execute the command-list corresponding to the first pattern that matches word. The match is performed according to the rules described below in [Pattern Matching](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching). If the `nocasematch` shell option (see the description of `shopt` in [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)) is enabled, the match is performed without regard to the case of alphabetic characters. The `|` is used to separate multiple patterns, and the `)` operator terminates a pattern list. A list of patterns and an associated command-list is known as a clause. 

`case`将有选择地执行与第一个匹配word的模式相对应的命令列表。根据[模式匹配](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)中描述的规则执行匹配。如果启用了`nocasematch` shell选项(参见[the shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)中`shopt`的描述)，则将执行匹配，而不考虑字母字符的大小写。`|` 用于分离多个模式，`)`操作符终止模式列表。模式的列表和相关联的命令列表称为子句(clause)。

Each clause must be terminated with `;;`, `;&`, or `;;&`. The word undergoes tilde expansion, parameter expansion, command substitution, arithmetic expansion, and quote removal (see [Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)) before matching is attempted. Each pattern undergoes tilde expansion, parameter expansion, command substitution, arithmetic expansion, process substitution, and quote removal. 

每个子句必须以`;;`、`;&`或`;;&`结尾。在尝试匹配之前，单词会经历波浪号扩展、参数扩展、命令替换、算术扩展和引号删除(参见[Shell参数扩展](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion))。每个模式都要经历波浪号扩展、参数扩展、命令替换、算术扩展、进程替换和引用删除。

There may be an arbitrary number of `case` clauses, each terminated by a `;;`, `;&`, or `;;&`. The first pattern that matches determines the command-list that is executed. It’s a common idiom to use ``\*`` as the final pattern to define the default case, since that pattern will always match. 

可以有任意数量的`case`子句，每个子句都以`;;`、`;& `或`;;& `结尾。第一个匹配的模式决定了要执行的命令列表。使用" \*` `作为定义default分支的最后一个模式是一种常见的习惯用法，因为这个模式总是匹配。

Here is an example using `case` in a script that could be used to describe one interesting feature of an animal: 

```shell
echo -n "Enter the name of an animal: "
read ANIMAL
echo -n "The $ANIMAL has "
case $ANIMAL in
  horse | dog | cat) echo -n "four";;
  man | kangaroo ) echo -n "two";;
  *) echo -n "an unknown number of";;
esac
echo " legs."
```

If the `;;` operator is used, no subsequent matches are attempted after the first pattern match. Using `;&` in place of `;;` causes execution to continue with the command-list associated with the next clause, if any. Using `;;&` in place of `;;` causes the shell to test the patterns in the next clause, if any, and execute any associated command-list on a successful match, continuing the case statement execution as if the pattern list had not matched. 

如果使用了 `;;` 操作符，那么在第一个模式匹配成功后，就不会再尝试后续的匹配。若将 `;&` 替换 `;;`，则在第一个模式匹配后，如果存在下一个子句，执行流程将继续与下一个子句关联的命令列表。而使用 `;;&` 来替换 `;;`，会让shell去检验下一个子句中（如果存在的话）的模式，一旦匹配成功，就执行相应的命令列表，并且继续执行case语句，就像模式列表未曾匹配成功一样。

The return status is zero if no pattern is matched. Otherwise, the return status is the exit status of the command-list executed. 

如果没有匹配patternreturn status 是执行command-list，则返回状态为零。 否则， 的退出状态。

`select`

The `select` construct allows the easy generation of menus. It has almost the same syntax as the `for` command: 

```shell
select name [in words …]; do commands; done
```

The list of words following `in` is expanded, generating a list of items, and the set of expanded words is printed on the standard error output stream, each preceded by a number. If the 'in words' is omitted, the positional parameters are printed, as if 'in "$@"' had been specified. `select` then displays the `PS3` prompt and reads a line from the standard input. If the line consists of a number corresponding to one of the displayed words, then the value of name is set to that word. If the line is empty, the words and prompt are displayed again. If `EOF` is read, the `select` command completes and returns 1. Any other value read causes name to be set to null. The line read is saved in the variable `REPLY`. 

跟随在 `in` 后面的单词列表会被展开，生成一系列项目，并将这些展开后的词项打印到标准错误输出流上，每个词项前都带有编号。如果省略了 `in words` 部分，就相当于默认使用了 `in "$@"`，即将位置参数打印出来。接着，`select` 会显示 `PS3` 提示符，并从标准输入读取一行输入。
如果输入的行是一个数字，且这个数字对应于已显示的某个单词，那么变量 `name` 的值就会被设置为那个单词。如果输入的行是空的，那么单词列表和提示符将会再次显示。如果读取到了 `EOF`（通常通过按下 Ctrl+D 键产生），`select` 命令就会完成，并返回 1。读取到的任何其他值会使变量 `name` 被设置为空值。所读取的行会被保存在变量 `REPLY` 中。

The commands are executed after each selection until a `break` command is executed, at which point the `select` command completes. 
每次选择后都会执行commands`break`指向 `select`，直到 命令，此时 命令完成。

Here is an example that allows the user to pick a filename from the current directory, and displays the name and index of the file selected. 

```shell
select fname in *;
do
  echo you picked $fname \($REPLY\)
  break;
done
```

```bash
#!/bin/bash

PS3='Please enter your choice: '
options=("Option 1" "Another Option" "The Last One")

select opt in "${options[@]}"; do
    case $opt in
        "Option 1")
            echo "You chose option 1"
            # Add more commands here for option 1 if needed
            ;;
        "Another Option")
            echo "You decided on another option"
            # More commands for option 2
            ;;
        "The Last One")
            echo "The final option was selected"
            break  # Exit the select loop
            ;;
        *) echo "Invalid option";;
    esac
done

echo "Select command has ended."
```

`((…))`

The arithmetic expression is evaluated according to the rules described below (see [Shell Arithmetic](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)). The expression undergoes the same expansions as if it were within double quotes, but double quote characters in expression are not treated specially are removed. If the value of the expression is non-zero, the return status is 0; otherwise the return status is 1. 

算术表达式根据下面描述的规则进行求值（参见[Shell Arithmetic](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)）。表达式会经历与它被双引号包围时相同的扩展过程，但表达式中的双引号字符不被特殊对待并被移除。如果表达式的值非零，则返回状态为0；否则，返回状态为1。

`[[…]]`

Return a status of 0 or 1 depending on the evaluation of the conditional expression expression. Expressions are composed of the primaries described below in [Bash Conditional Expressions](https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions). The words between the `[[` and `]]` do not undergo word splitting and filename expansion. The shell performs tilde expansion, parameter and variable expansion, arithmetic expansion, command substitution, process substitution, and quote removal on those words (the expansions that would occur if the words were enclosed in double quotes). Conditional operators such as `-f` must be unquoted to be recognized as primaries. 

根据条件表达式 `expression` 的求值结果，返回0或1的状态。表达式由下方[Bash条件表达式](https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions)中描述的基本元素构成。位于 `[[` 和 `]]` 之间的词不会进行单词分割和文件名扩展。Shell会对这些词执行波浪线扩展、参数和变量扩展、算术扩展、命令替换、进程替换以及去除引号（如果这些词被双引号包围时将发生的扩展）。诸如 `-f` 这样的条件操作符必须不加引号才能被识别为基本元素。

When used with `[[`, the `<` and `>` operators sort lexicographically using the current locale. 
当与 `[[` 一起使用时，"<"和">"运算符使用当前区域设置的进行词典序排序 。

When the `==` and `!=` operators are used, the string to the right of the operator is considered a pattern and matched according to the rules described below in [Pattern Matching](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching), as if the `extglob` shell option were enabled. The `=` operator is identical to `==`. If the `nocasematch` shell option (see the description of `shopt` in [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)) is enabled, the match is performed without regard to the case of alphabetic characters. The return value is 0 if the string matches (`==`) or does not match (`!=`) the pattern, and 1 otherwise. 

当使用 `==` 和 `!=` 操作符时，操作符右侧的字符串被视为模式，并根据下方[模式匹配](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)中描述的规则进行匹配，就好似启用了 `extglob` shell层选项一样。`=` 操作符与 `==` 完全相同。如果启用了 `nocasematch` 壳层选项（参见[内置命令shopt的描述](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)），则匹配时不区分字母的大小写。如果字符串符合（`==`）或不符合（`!=`）该模式，则返回值为0；否则，返回值为1。

If you quote any part of the pattern, using any of the shell’s quoting mechanisms, the quoted portion is matched literally. This means every character in the quoted portion matches itself, instead of having any special pattern matching meaning. 

如果您使用shell的任何引用机制对模式的任何部分进行引用，那么被引用的部分将被字面匹配。这意味着被引用部分中的每个字符都将匹配自身，而不具备任何特殊的模式匹配含义。

An additional binary operator, `=~`, is available, with the same precedence as `==` and `!=`. When you use `=~`, the string to the right of the operator is considered a <small>POSIX</small> extended regular expression pattern and matched accordingly (using the <small>POSIX</small> `regcomp` and `regexec` interfaces usually described in _regex_(3)). The return value is 0 if the string matches the pattern, and 1 if it does not. If the regular expression is syntactically incorrect, the conditional expression returns 2. If the `nocasematch` shell option (see the description of `shopt` in [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)) is enabled, the match is performed without regard to the case of alphabetic characters. 

还有一个额外的二元运算符`=~`，其优先级与`==`和`!=`相同。当你使用`=~`时，操作符右侧的字符串被视为一个POSIX扩展正则表达式模式，并据此进行匹配（使用通常在_regex_(3)中描述的POSIX `regcomp`和`regexec`接口）。如果字符串匹配该模式，则返回值为0；如果不匹配，则返回值为1。如果正则表达式语法错误，条件表达式将返回2。如果启用了`nocasematch`shell选项（参见[内置命令shopt的描述](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)），则匹配时忽略字母的大小写。

You can quote any part of the pattern to force the quoted portion to be matched literally instead of as a regular expression (see above). If the pattern is stored in a shell variable, quoting the variable expansion forces the entire pattern to be matched literally. 

您能引用模式的任意部分，强制被引用的内容按字面意思匹配而非作为正则表达式处理（见上文）。如果模式保存在一个shell变量里，对变量扩展进行引用会使得整个模式都按字面意义进行匹配。

The pattern will match if it matches any part of the string. If you want to force the pattern to match the entire string, anchor the pattern using the `^` and `$` regular expression operators. 

如果模式与字符串的任何部分匹配，则模式匹配成功。如果你想强制模式匹配整个字符串，可以使用正则表达式的定位符`^`（表示字符串的开始）和`$`（表示字符串的结束）来固定模式。

For example, the following will match a line (stored in the shell variable `line`) if there is a sequence of characters anywhere in the value consisting of any number, including zero, of characters in the `space` character class, immediately followed by zero or one instances of `a`, then a `b`: 

例如，下面的表达式将会匹配一行内容（存储在shell变量`line`中），如果该行内容中任何位置存在这样一个字符序列：由任意数量（包括零个）的空白字符类字符组成，紧接着是零个或一个`a`字符，然后是一个`b`字符：

```shell
[[ $line =~ [[:space:]]*(a)?b ]]
```

That means values for line like ‘aab’, ‘ aaaaaab’, ‘xaby’, and ‘ ab’ will all match, as will a line containing a ‘b’ anywhere in its value.

这意味着对于line变量中的值，如‘aab’、‘ aaaaaab’、‘xaby’以及‘ ab’，都会匹配成功，同样，只要值中任意位置包含‘b’的行也会匹配成功。

If you want to match a character that’s special to the regular expression grammar (`'^$|\[\]()\.*+?'`), it has to be quoted to remove its special meaning. This means that in the pattern 'xxx.txt', the `.` matches any character in the string (its usual regular expression meaning), but in the pattern '"xxx.txt"', it can only match a literal `.`. 

如果你想匹配正则表达式语法中具有特殊意义的字符(`'^$|\[\]()\.*+?'`)，就需要对其进行转义以去除其特殊含义。也就是说，在模式‘xxx.txt’中，‘.’会匹配字符串中的任意字符（这是它在正则表达式中的常规意义），但在模式‘"xxx.txt"’中，它只能匹配字面上的‘.’字符。

Likewise, if you want to include a character in your pattern that has a special meaning to the regular expression grammar, you must make sure it’s not quoted. If you want to anchor a pattern at the beginning or end of the string, for instance, you cannot quote the `^` or `$` characters using any form of shell quoting. 

同样地，如果你想在模式中包含对正则表达式语法有特殊意义的字符，就必须确保它没有被引用。例如，如果你想在字符串的开头或结尾固定模式，就不能使用任何形式的shell引用对‘^’或‘$’字符进行引用。

If you want to match ‘initial string’ at the start of a line, the following will work: 
如果你想在行首匹配‘initial string’，以下这种方式是可行的：

```shell
[[ $line =~ ^"initial string" ]]
```

but this will not: 

```shell
[[ $line =~ "^initial string" ]]
```

because in the second example the `^` is quoted and doesn’t have its usual special meaning. 

It is sometimes difficult to specify a regular expression properly without using quotes, or to keep track of the quoting used by regular expressions while paying attention to shell quoting and the shell’s quote removal. Storing the regular expression in a shell variable is often a useful way to avoid problems with quoting characters that are special to the shell. For example, the following is equivalent to the pattern used above: 

有时候，如果不使用引号恰当地指定正则表达式，或者在关注shell引用规则及shell去除引号行为的同时，跟踪正则表达式所用的引号，可能会比较困难。将正则表达式存储在shell变量中，往往是避免因引用shell中特殊字符而导致问题的一种有用方法。例如，下面的代码与上述模式等效：

```shell
pattern='[[:space:]]*(a)?b'
[[ $line =~ $pattern ]]
```

Shell programmers should take special care with backslashes, since backslashes are used by both the shell and regular expressions to remove the special meaning from the following character. This means that after the shell’s word expansions complete (see [Shell Expansions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Expansions)), any backslashes remaining in parts of the pattern that were originally not quoted can remove the special meaning of pattern characters. If any part of the pattern is quoted, the shell does its best to ensure that the regular expression treats those remaining backslashes as literal, if they appeared in a quoted portion. 

Shell程序员应当特别注意反斜杠的使用，因为不论是shell还是正则表达式，都使用反斜杠来去除紧跟其后字符的特殊含义。这意味着，在shell完成单词扩展（参见[Shell Expansions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Expansions)）之后，模式中原本未被引用的部分里残余的任何反斜杠都可能消除模式字符的特殊意义。如果模式的任何部分被引用了，shell会尽量确保正则表达式将那些出现在引用部分中的剩余反斜杠视为文本字符处理。

The following two sets of commands are _not_ equivalent: 

```shell
pattern=`\.`

[[ . =~ $pattern ]]
[[ . =~ \. ]]

[[ . =~ "$pattern" ]]
[[ . =~ `\.` ]]
```

The first two matches will succeed, but the second two will not, because in the second two the backslash will be part of the pattern to be matched. In the first two examples, the pattern passed to the regular expression parser is `\.`. The backslash removes the special meaning from `.`, so the literal `.` matches. In the second two examples, the pattern passed to the regular expression parser has the backslash quoted (e.g., '\.'), which will not match the string, since it does not contain a backslash. If the string in the first examples were anything other than `.`, say `a`, the pattern would not match, because the quoted `.` in the pattern loses its special meaning of matching any single character. 

前两组匹配将会成功，但后两组不会成功，因为在后两组中，反斜杠（\）会成为需要匹配的模式的一部分。在前两个例子中，传递给正则表达式解析器的模式是‘.’。这里的反斜杠去除了‘.’的特殊含义，使得字面意义上的‘.’得到了匹配。而在后两个例子中，传递给正则表达式解析器的模式中的反斜杠被引用了（例如，‘\.’），这样就不会匹配字符串，因为它并不包含反斜杠。如果第一个例子中的字符串不是‘.’，比如说‘a’，那么模式就不会匹配，因为模式中被引用的‘.’失去了匹配任何单个字符的特殊意义。



Bracket expressions in regular expressions can be sources of errors as well, since characters that are normally special in regular expressions lose their special meanings between brackets. However, you can use bracket expressions to match special pattern characters without quoting them, so they are sometimes useful for this purpose. 

在正则表达式中，括号表达式也可能成为错误的来源，因为通常在正则表达式中具有特殊意义的字符在括号内会失去它们的特殊含义。然而，你可以利用括号表达式来匹配特殊模式字符而不必对它们进行转义，因此在某些情况下它们还是很有用的。



Though it might seem like a strange way to write it, the following pattern will match a `.` in the string: 
尽管看起来写法可能有些奇怪，但以下模式将用于在字符串中匹配‘.’：

```shell
[[ . =~ [.] ]]
```

The shell performs any word expansions before passing the pattern to the regular expression functions, so you can assume that the shell’s quoting takes precedence. As noted above, the regular expression parser will interpret any unquoted backslashes remaining in the pattern after shell expansion according to its own rules. The intention is to avoid making shell programmers quote things twice as much as possible, so shell quoting should be sufficient to quote special pattern characters where that’s necessary. 

Shell会在将模式传递给正则表达式函数之前执行任何单词扩展，因此你可以认为shell的引用规则优先。如上所述，正则表达式解析器将根据其自身的规则解释在shell扩展后模式中剩余的任何未被引用的反斜杠。目的是尽可能避免让shell程序员对内容进行双重引用，所以在必要时，仅使用shell的引用就应该足够来引用特殊模式字符。

The array variable `BASH_REMATCH` records which parts of the string matched the pattern. The element of `BASH_REMATCH` with index 0 contains the portion of the string matching the entire regular expression. Substrings matched by parenthesized subexpressions within the regular expression are saved in the remaining `BASH_REMATCH` indices. The element of `BASH_REMATCH` with index n is the portion of the string matching the nth parenthesized subexpression. 

数组变量`BASH_REMATCH`记录了字符串中哪些部分与模式匹配。`BASH_REMATCH`中索引为0的元素包含了与整个正则表达式匹配的字符串部分。正则表达式中由括号子表达式匹配的子串被保存在`BASH_REMATCH`的其余索引中。`BASH_REMATCH`中索引为n的元素是与第n个括号子表达式匹配的字符串部分。

Bash sets `BASH_REMATCH` in the global scope; declaring it as a local variable will lead to unexpected results. 

Bash在全球作用域中设置`BASH_REMATCH`；将其声明为局部变量将会导致意外的结果。

Expressions may be combined using the following operators, listed in decreasing order of precedence:

`( expression )`

Returns the value of expression. This may be used to override the normal precedence of operators. 

`! expression`

True if expression is false.

`expression1 && expression2`

True if both expression1 and expression2 are true.

`expression1 || expression2`

True if either expression1 or expression2 is true.

The `&&` and `||` operators do not evaluate expression2 if the value of expression1 is sufficient to determine the return value of the entire conditional expression.

___

#### 3.2.5.3 Grouping Commands

Bash provides two ways to group a list of commands to be executed as a unit. When commands are grouped, redirections may be applied to the entire command list. For example, the output of all the commands in the list may be redirected to a single stream. 

Bash 提供了两种方法来对要执行的命令列表进行分组 作为一个整体。 对命令进行分组后，可能会应用重定向 到整个命令列表。 例如，所有 列表中的命令可以重定向到单个流。

`()`

Placing a list of commands between parentheses forces the shell to create a subshell (see [Command Execution Environment](https://www.gnu.org/software/bash/manual/bash.html#Command-Execution-Environment)), and each of the commands in list is executed in that subshell environment. Since the list is executed in a subshell, variable assignments do not remain in effect after the subshell completes. 

将一系列命令置于圆括号内会促使系统生成一个subshell环境（参阅[命令执行环境](https://www.gnu.org/software/bash/manual/bash.html#Command-Execution-Environment)）。列表中的每条命令都会在这个新创建的subshell环境中执行。由于这些命令在subshell中执行，所以当subshell结束时，其中的变量赋值将不再保持有效。


`{}`

Placing a list of commands between curly braces causes the list to be executed in the current shell context. No subshell is created. The semicolon (or newline) following list is required. 

将一系列命令放在花括号之间会导致这些命令在当前的shell环境中执行，不会创建新的子shell。在命令列表之后必须有一个分号（或换行符）。

In addition to the creation of a subshell, there is a subtle difference between these two constructs due to historical reasons. The braces are reserved words, so they must be separated from the list by `blank`s or other shell metacharacters. The parentheses are operators, and are recognized as separate tokens by the shell even if they are not separated from the list by whitespace. 

除了创建 subshell 这一区别外，由于历史原因，这两种结构之间还存在一个细微的差别。花括号是保留字，因此它们必须与命令列表之间用`blank`或其他 shell 元字符隔开。而圆括号则是操作符，即使它们与命令列表之间没有空格分隔，shell也能识别它们为独立的符号。

The exit status of both of these constructs is the exit status of list. 

___

#### 3.2.6 Coprocesses

A `coprocess` is a shell command preceded by the `coproc` reserved word. A coprocess is executed asynchronously in a subshell, as if the command had been terminated with the `&` control operator, with a two-way pipe established between the executing shell and the coprocess. 

`协程（Coprocess）`是一种由保留字`coproc`引导的shell命令。协程会在子shell中异步执行，就如同该命令使用`&`控制操作符终止一样，并且在执行shell与协程之间建立了一个双向管道。

The syntax for a coprocess is: 

```shell
coproc [NAME] command [redirections]
```

This creates a coprocess named NAME. command may be either a simple command (see [Simple Commands](https://www.gnu.org/software/bash/manual/bash.html#Simple-Commands)) or a compound command (see [Compound Commands](https://www.gnu.org/software/bash/manual/bash.html#Compound-Commands)). NAME is a shell variable name. If NAME is not supplied, the default name is `COPROC`. 

这将创建一个名为 NAMEcommand可以是简单命令（请参阅[简单命令](https://www.gnu.org/software/bash/manual/bash.html#Simple-Commands)或复合命令（请参阅[复合命令](https://www.gnu.org/software/bash/manual/bash.html#Compound-Commands)NAME如果未提供 NAME，则默认名称为 `COPROC` 的协同进程。 ） ）。 是 shell 变量名称。 。

The recommended form to use for a coprocess is

This form is recommended because simple commands result in the coprocess always being named `COPROC`, and it is simpler to use and more complete than the other compound commands. 始终被命名为 `COPROC`建议使用此表单，因为简单的命令会导致协同处理 ，它更易于使用且更完整 比其他复合命令。

There are other forms of coprocesses: 还有其他形式的协同过程：

```shell
coproc NAME compound-command
coproc compound-command
coproc simple-command
```

If command is a compound command, NAME is optional. The word following `coproc` determines whether that word is interpreted as a variable name: it is interpreted as NAME if it is not a reserved word that introduces a compound command. If command is a simple command, NAME is not allowed; this is to avoid confusion between NAME and the first word of the simple command. 如果 command 是复合命令，NAME`coproc`作为变量名称NAME如果 command 是简单命令，则不允许 NAME是为了避免NAME 是可选的。这 后面的单词确定是否解释该单词 引入复合命令的保留字。 ;这 和简单的第一个词混淆 命令。

When the coprocess is executed, the shell creates an array variable (see [Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)) named NAME in the context of the executing shell. The standard output of command is connected via a pipe to a file descriptor in the executing shell, and that file descriptor is assigned to NAME\[0\]. The standard input of command is connected via a pipe to a file descriptor in the executing shell, and that file descriptor is assigned to NAME\[1\]. This pipe is established before any redirections specified by the command (see [Redirections](https://www.gnu.org/software/bash/manual/bash.html#Redirections)). The file descriptors can be utilized as arguments to shell commands and redirections using standard word expansions. Other than those created to execute command and process substitutions, the file descriptors are not available in subshells. （请参阅[数组](https://www.gnu.org/software/bash/manual/bash.html#Arrays)在执行 shell 的上下文中命名为 NAMEcommand并将该文件描述符分配给 NAMEcommand并且该文件描述符被分配给 NAME命令（请参阅[重定向](https://www.gnu.org/software/bash/manual/bash.html#Redirections)执行协进程时，shell 会创建一个数组变量 ） 。 的标准输出 通过管道连接到执行 shell 中的文件描述符， 的标准输入 通过管道连接到执行 shell 中的文件描述符， 此管道是在 ）。 文件描述符可用作 shell 命令的参数 以及使用标准单词扩展的重定向。 除了为执行命令和进程替换而创建的那些之外， 文件描述符在子 shell 中不可用。

The process ID of the shell spawned to execute the coprocess is available as the value of the variable `NAME_PID`. The `wait` builtin command may be used to wait for the coprocess to terminate. 可用作变量 NAME`wait`为执行协进程而生成的 shell 的进程 ID 为 的值。 内置命令可用于等待协进程终止。

Since the coprocess is created as an asynchronous command, the `coproc` command always returns success. The return status of a coprocess is the exit status of command. `coproc`协进程的返回状态是command由于协进程是作为异步命令创建的， 命令始终返回 success。 的退出状态。

___

#### 3.2.7 GNU Parallel

There are ways to run commands in parallel that are not built into Bash. GNU Parallel is a tool to do just that.
有一些方法可以并行运行命令，而这些方法不是内置在Bash中的。GNU Parallel就是一个可以做到这一点的工具。

GNU Parallel, as its name suggests, can be used to build and run commands in parallel. You may run the same command with different arguments, whether they are filenames, usernames, hostnames, or lines read from files. GNU Parallel provides shorthand references to many of the most common operations (input lines, various portions of the input line, different ways to specify the input source, and so on). Parallel can replace `xargs` or feed commands from its input sources to several different instances of Bash.
GNU Parallel，顾名思义，可以用来并行构建和运行命令。你可以使用不同的参数运行同一个命令，无论是文件名、用户名、主机名还是从文件中读取的行。GNU Parallel提供了许多最常见操作的简写引用(输入行、输入行的不同部分、指定输入源的不同方法，等等)。Parallel可以取代`xargs`或者从它的输入源提供命令到多个不同的Bash实例。

For a complete description, refer to the GNU Parallel documentation, which is available at [https://www.gnu.org/software/parallel/parallel\_tutorial.html](https://www.gnu.org/software/parallel/parallel_tutorial.html).

___

### 3.3 Shell Functions3.3 Shell函数

Shell functions are a way to group commands for later execution using a single name for the group. They are executed just like a "regular" command. When the name of a shell function is used as a simple command name, the list of commands associated with that function name is executed. Shell functions are executed in the current shell context; no new process is created to interpret them. 
Shell 函数是一种对命令进行分组以供以后执行的方法 对组使用单个名称。 它们的执行方式就像 "常规"命令。 当 shell 函数的名称用作简单命令名称时， 将执行与该函数名称关联的命令列表。 Shell 函数在当前 壳上下文;不会创建任何新进程来解释它们。

Functions are declared using this syntax:

```bash
fname () compound-command [ redirections ]

function fname [()] compound-command [ redirections ]
```

This defines a shell function named fname. The reserved word `function` is optional. If the `function` reserved word is supplied, the parentheses are optional. The _body_ of the function is the compound command compound-command (see [Compound Commands](https://www.gnu.org/software/bash/manual/bash.html#Compound-Commands)). That command is usually a list enclosed between { and }, but may be any compound command listed above. If the `function` reserved word is used, but the parentheses are not supplied, the braces are recommended. compound-command is executed whenever fname is specified as the name of a simple command. When the shell is in <small>POSIX</small> mode (see [Bash POSIX Mode](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)), fname must be a valid shell name and may not be the same as one of the special builtins (see [Special Builtins](https://www.gnu.org/software/bash/manual/bash.html#Special-Builtins)). In default mode, a function name can be any unquoted shell word that does not contain `$`. Any redirections (see [Redirections](https://www.gnu.org/software/bash/manual/bash.html#Redirections)) associated with the shell function are performed when the function is executed. A function definition may be deleted using the \-f option to the `unset` builtin (see [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)). 

这段文本定义了一个名为fname的shell函数。其中，保留字function是可选的。若提供了function保留字，则相应的括号也是可选的。函数的主体是复合命令compound-command（请参阅Compound Commands）。此命令通常表现为一对花括号{}之间的命令列表，但也可以是前述列表中的任何一种复合命令形式。若使用了function保留字但未提供括号，则建议使用花括号{}。只要fname被指定为一个简单命令的名称，compound-command就会被执行。当shell处于<small>POSIX</small>模式（请参阅Bash POSIX Mode）时，fname必须是有效的shell名称，并且不得与任何特殊内建命令（参见Special Builtins）相同。在默认模式下，函数名可以是任何不包含字符$的未引用shell单词。与shell函数相关的所有重定向操作（参见Redirections）会在函数执行时完成。通过向unset内建命令添加-f选项，可以删除函数定义（参见Bourne Shell Builtins）。

The exit status of a function definition is zero unless a syntax error occurs or a readonly function with the same name already exists. When executed, the exit status of a function is the exit status of the last command executed in the body. 
函数定义的退出状态为0，除非出现语法错误或存在同名的只读函数。当函数被调用执行时，其退出状态即为函数主体中最后执行的命令的退出状态。

Note that for historical reasons, in the most common usage the curly braces that surround the body of the function must be separated from the body by `blank`s or newlines. This is because the braces are reserved words and are only recognized as such when they are separated from the command list by whitespace or another shell metacharacter. Also, when using the braces, the list must be terminated by a semicolon, a `&`, or a newline. 
请注意，由于历史原因，在最常见的用法中，包围函数主体的花括号必须与主体之间用`blank`或换行符分隔。这是因为花括号是保留字，只有当它们与命令列表之间以空格或其他shell元字符隔开时，才会被识别为保留字。此外，使用花括号时，命令列表必须以分号`;`、`&`或换行符结尾。

When a function is executed, the arguments to the function become the positional parameters during its execution (see [Positional Parameters](https://www.gnu.org/software/bash/manual/bash.html#Positional-Parameters)). The special parameter `#` that expands to the number of positional parameters is updated to reflect the change. Special parameter `0` is unchanged. The first element of the `FUNCNAME` variable is set to the name of the function while the function is executing. 
当执行一个函数时，传递给该函数的参数在其执行期间会成为位置参数（请参阅[Positional Parameters](https://www.gnu.org/software/bash/manual/bash.html#Positional-Parameters)）。表示位置参数数量的特殊参数`#`会相应更新以反映这一变化。特殊参数`0`保持不变。函数执行期间，变量`FUNCNAME`的第一个元素会被设置为该函数的名称。


All other aspects of the shell execution environment are identical between a function and its caller with these exceptions: the `DEBUG` and `RETURN` traps are not inherited unless the function has been given the `trace` attribute using the `declare` builtin or the `-o functrace` option has been enabled with the `set` builtin, (in which case all functions inherit the `DEBUG` and `RETURN` traps), and the `ERR` trap is not inherited unless the `-o errtrace` shell option has been enabled. See [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins), for the description of the `trap` builtin. 
函数与其调用者之间的shell执行环境的所有其他方面都是相同的，除了以下几个例外：
除非使用`declare`内置函数给函数赋予了`trace`属性，或者使用`set`内置函数启用了`-o functrace`选项（在这种情况下，所有函数都会继承`DEBUG`和`RETURN`陷阱），否则`DEBUG`和`RETURN`陷阱不会被继承；
除非启用了`-o errtrace` shell选项，否则`ERR`陷阱不会被继承。
请参阅[Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)，了解trap内置函数的描述。

The `FUNCNEST` variable, if set to a numeric value greater than 0, defines a maximum function nesting level. Function invocations that exceed the limit cause the entire command to abort.
`FUNCNEST` 变量被设置为大于0的数值时，它定义了一个最大函数嵌套级别。超出此限制的函数调用会导致整个命令终止执行。

If the builtin command `return` is executed in a function, the function completes and execution resumes with the next command after the function call. Any command associated with the `RETURN` trap is executed before execution resumes. When a function completes, the values of the positional parameters and the special parameter `#` are restored to the values they had prior to the function’s execution. If a numeric argument is given to `return`, that is the function’s return status; otherwise the function’s return status is the exit status of the last command executed before the `return`. 
如果在函数中执行内置命令`return`，函数将完成执行，并且继续执行函数调用后的下一个命令。与`RETURN`陷阱关联的任何命令将在执行恢复前执行。当函数完成时，位置参数和特殊参数`#`的值将恢复到函数执行前的值。如果向`return`提供一个数值参数，该数值将成为函数的返回状态；否则，函数的返回状态将是`return`之前所执行的最后一个命令的退出状态。

Variables local to the function may be declared with the `local` builtin (_local variables_). Ordinarily, variables and their values are shared between a function and its caller. These variables are visible only to the function and the commands it invokes. This is particularly important when a shell function calls other functions. 
函数内部的变量可以通过使用`local`内建命令声明为局部变量。通常情况下，变量及其值会在函数与其调用者之间共享。这些变量仅对函数本身及其调用的命令可见。当shell函数调用其他函数时，这一点尤为重要。

In the following description, the _current scope_ is a currently- executing function. Previous scopes consist of that function’s caller and so on, back to the "global" scope, where the shell is not executing any shell function. Consequently, a local variable at the current local scope is a variable declared using the `local` or `declare` builtins in the function that is currently executing. 
在下面的描述中，_当前范围_使用`local` 声明 或 `declare`是当前 执行功能。 以前的作用域由该函数的调用方等组成， 回到"全局"作用域，shell 未执行 任何 shell 函数。 因此，当前局部作用域的局部变量是变量 内置 当前正在执行的函数。

Local variables "shadow" variables with the same name declared at previous scopes. For instance, a local variable declared in a function hides a global variable of the same name: references and assignments refer to the local variable, leaving the global variable unmodified. When the function returns, the global variable is once again visible. 
局部变量 “shadow” 变量，其名称在 以前的范围。 例如，在函数中声明的局部变量 隐藏同名的全局变量：引用和赋值 引用局部变量，保持全局变量不被修改。 当函数返回时，全局变量将再次可见。

The shell uses _dynamic scoping_ to control a variable’s visibility within functions. With dynamic scoping, visible variables and their values are a result of the sequence of function calls that caused execution to reach the current function. The value of a variable that a function sees depends on its value within its caller, if any, whether that caller is the "global" scope or another shell function. This is also the value that a local variable declaration "shadows", and the value that is restored when the function returns. 
shell 使用_动态范围_来控制变量的可见性 在函数中。 通过动态范围、可见变量及其值 是导致执行的函数调用序列的结果 以达到当前函数。 函数看到的变量的值取决于 关于其调用方中的值（如果有），该调用方是否是 "全局"作用域或其他 shell 函数。 这也是局部变量的值 声明 “shadows”，以及函数时恢复的值 返回。

For example, if a variable `var` is declared as local in function `func1`, and `func1` calls another function `func2`, references to `var` made from within `func2` will resolve to the local variable `var` from `func1`, shadowing any global variable named `var`. 
例如，如果变量 `var``func1` 和 `func1` 调用另一个函数 `func2`从 `func2` 中对 `var``func1` 的局部变量 `var`命名为 `var` 在函数中声明为本地变量 ， 的引用将解析为 ，遮蔽任何全局变量 。

The following script demonstrates this behavior. When executed, the script displays 

```bash
In func2, var = func1 local
```

```bash
func1()
{
    local var='func1 local'
    func2
}

func2()
{
    echo "In func2, var = $var"
}

var=global
func1
```

The `unset` builtin also acts using the same dynamic scope: if a variable is local to the current scope, `unset` will unset it; otherwise the unset will refer to the variable found in any calling scope as described above. If a variable at the current local scope is unset, it will remain so (appearing as unset) until it is reset in that scope or until the function returns. Once the function returns, any instance of the variable at a previous scope will become visible. If the unset acts on a variable at a previous scope, any instance of a variable with that name that had been shadowed will become visible (see below how `localvar_unset`shell option changes this behavior).
`unset`内建命令同样遵循动态作用域规则：若变量为当前作用域内的局部变量，则`unset`将取消其设置；否则，取消设置将作用于上述描述中在任何调用者作用域中找到的变量。如果当前局部作用域内的变量被取消设置，它将保持未设置状态（表现为未设置）直至在该作用域内重新设置，或直至函数返回。一旦函数返回，该变量在先前作用域中的任一实例都将变得可见。如果取消设置作用于先前作用域中的变量，则任何曾被遮蔽的同名变量实例都将变得可见（请参阅下文关于`localvar_unset` shell选项如何改变这种行为）。

Function names and definitions may be listed with the \-f option to the `declare` (`typeset`) builtin command (see [Bash Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)). The \-F option to `declare` or `typeset` will list the function names only (and optionally the source file and line number, if the `extdebug` shell option is enabled). Functions may be exported so that child shell processes (those created when executing a separate shell invocation) automatically have them defined with the \-f option to the `export` builtin (see [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)).
函数名及其定义可通过在`declare`（或`typeset`）内建命令中使用`-f`选项列出（参见[Bash内建命令](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)）。在`declare`或`typeset`命令中使用`-F`选项仅会列出函数名（如果启用了`extdebug` shell选项，还可选地列出源文件和行号）。通过在`export`内建命令中使用`-f`选项，可将函数导出，以便子shell进程（在执行单独的shell调用时创建）能自动定义这些函数（参见[Bourne Shell内建命令](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)）。

Functions may be recursive. The `FUNCNEST` variable may be used to limit the depth of the function call stack and restrict the number of function invocations. By default, no limit is placed on the number of recursive calls.
函数可以是递归的。可以使用`FUNCNEST`变量来限制函数调用堆栈的深度和限制函数调用次数。默认情况下，对递归调用的次数不做限制。

___

### 3.4 Shell Parameters

A _parameter_ is an entity that stores values. It can be a `name`, a number, or one of the special characters listed below. A _variable_ is a parameter denoted by a `name`. A variable has a `value` and zero or more `attributes`. Attributes are assigned using the `declare` builtin command (see the description of the `declare` builtin in [Bash Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)). 

参数是用于存储值的实体。它可以是一个`name`（名称）、一个数字，或者是下列列出的特殊字符之一。变量是由`name`标识的参数。变量具有一个`value`（值）和零个或多个`attributes`（属性）。属性是通过使用`declare`内建命令来分配的（请参阅[Bash内建命令](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)中对`declare`内建命令的描述）。

A parameter is set if it has been assigned a value. The null string is a valid value. Once a variable is set, it may be unset only by using the `unset` builtin command. 
当参数被赋予一个值时，称其已被设置。空字符串是有效的值。一旦变量被设置，只能通过使用`unset`内建命令将其取消设置。

A variable may be assigned to by a statement of the form

```bash
name=[value]
```

If value is not given, the variable is assigned the null string. All values undergo tilde expansion, parameter and variable expansion, command substitution, arithmetic expansion, and quote removal (see [Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)). If the variable has its `integer` attribute set, then value is evaluated as an arithmetic expression even if the `$((…))` expansion is not used (see [Arithmetic Expansion](https://www.gnu.org/software/bash/manual/bash.html#Arithmetic-Expansion)). Word splitting and filename expansion are not performed. Assignment statements may also appear as arguments to the `alias`, `declare`, `typeset`, `export`, `readonly`, and `local` builtin commands (_declaration_ commands). When in <small>POSIX</small> mode (see [Bash POSIX Mode](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)), these builtins may appear in a command after one or more instances of the `command` builtin and retain these assignment statement properties. 
如果未给出值，变量将被赋予空字符串。所有值都要经过波浪线扩展（tilde expansion）、参数和变量扩展（parameter and variable expansion）、命令替换（command substitution）、算术扩展（arithmetic expansion）以及引号去除（quote removal）（请参阅[Shell参数扩展](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)）。如果变量设置了`integer`属性，即使不使用`$((…))`扩展形式，其值也将作为算术表达式进行求值（请参阅[算术扩展](https://www.gnu.org/software/bash/manual/bash.html#Arithmetic-Expansion)）。此时不会进行词分割（word splitting）和文件名扩展（filename expansion）。赋值语句也可以作为`alias`、`declare`、`typeset`、`export`、`readonly`和`local`等内建命令（即声明命令）的参数出现。当处于<small>POSIX</small>模式（参见[Bash POSIX模式](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)）时，这些内建命令可以在一个命令中跟随一个或多个`command`内建命令实例，并保留这些赋值语句特性。

In the context where an assignment statement is assigning a value to a shell variable or array index (see [Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)), the `+=` operator can be used to append to or add to the variable’s previous value. This includes arguments to builtin commands such as `declare` that accept assignment statements (declaration commands). When `+=` is applied to a variable for which the `integer` attribute has been set, value is evaluated as an arithmetic expression and added to the variable’s current value, which is also evaluated. When `+=` is applied to an array variable using compound assignment (see [Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)), the variable’s value is not unset (as it is when using `=`), and new values are appended to the array beginning at one greater than the array’s maximum index (for indexed arrays), or added as additional key-value pairs in an associative array. When applied to a string-valued variable, value is expanded and appended to the variable’s value. 

在赋值语句给shell变量或数组索引（参见[数组](https://www.gnu.org/software/bash/manual/bash.html#Arrays)）赋值的上下文中，可以使用`+=`运算符来追加或增加变量的先前值。这包括接受赋值语句（声明命令）的内建命令（如`declare`）的参数。当`+=`应用于已设置`integer`属性的变量时，值将被解释为一个算术表达式并与变量当前值（同样被解释）相加。当使用复合赋值（参见[数组](https://www.gnu.org/software/bash/manual/bash.html#Arrays)）将`+=`应用于数组变量时，变量的值不会被取消设置（如使用`=`时那样），而是将新值从数组的最大索引加1处开始追加到数组中（对于索引数组），或者作为额外的键值对添加到关联数组中。当应用于字符串值变量时，值将被扩展并追加到变量的值之后。

A variable can be assigned the `nameref` attribute using the \-n option to the `declare` or `local` builtin commands (see [Bash Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)) to create a _nameref_, or a reference to another variable. This allows variables to be manipulated indirectly. Whenever the nameref variable is referenced, assigned to, unset, or has its attributes modified (other than using or changing the nameref attribute itself), the operation is actually performed on the variable specified by the nameref variable’s value. A nameref is commonly used within shell functions to refer to a variable whose name is passed as an argument to the function. For instance, if a variable name is passed to a shell function as its first argument, running

```bash
declare -n ref=$1
```

可以使用`declare`或`local`内建命令的`-n`选项为变量分配`nameref`属性（参见[Bash内建命令](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)），以创建一个_nameref_（即对另一个变量的引用）。这允许间接操作变量。每当引用、赋值、取消设置nameref变量，或修改其属性（除了使用或更改nameref属性本身）时，实际操作的是由nameref变量的值所指定的变量。通常在shell函数内部使用nameref来引用其名称作为函数参数传递的变量。例如，如果将一个变量名作为第一个参数传递给shell函数，运行

```bash
declare -n ref=$1
```

inside the function creates a nameref variable `ref` whose value is the variable name passed as the first argument. References and assignments to `ref`, and changes to its attributes, are treated as references, assignments, and attribute modifications to the variable whose name was passed as `$1`. 

在函数内部会创建一个名为`ref`的nameref变量，其值为作为第一个参数传递的变量名。对`ref`的引用和赋值，以及对其属性的更改，被视为对作为`$1`传递的变量名所指代的变量的引用、赋值和属性更改。

If the control variable in a `for` loop has the nameref attribute, the list of words can be a list of shell variables, and a name reference will be established for each word in the list, in turn, when the loop is executed. Array variables cannot be given the nameref attribute. However, nameref variables can reference array variables and subscripted array variables. Namerefs can be unset using the \-n option to the `unset` builtin (see [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)). Otherwise, if `unset` is executed with the name of a nameref variable as an argument, the variable referenced by the nameref variable will be unset.

如果`for`循环中的控制变量具有nameref属性，单词列表可以是shell变量列表，并且在循环执行时，将依次为列表中的每个单词建立名称引用。数组变量不能赋予nameref属性。然而，nameref变量可以引用数组变量和下标数组变量。可以使用`unset`内建命令的`-n`选项取消设置nameref（参见[Bourne Shell内建命令](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)）。否则，如果使用nameref变量名作为参数执行`unset`，则将取消设置由nameref变量引用的变量。

-   [Positional Parameters](https://www.gnu.org/software/bash/manual/bash.html#Positional-Parameters)
-   [Special Parameters](https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters)

___

#### 3.4.1 Positional Parameters

A _positional parameter_ is a parameter denoted by one or more digits, other than the single digit `0`. Positional parameters are assigned from the shell’s arguments when it is invoked, and may be reassigned using the `set` builtin command. Positional parameter `N` may be referenced as `${N}`, or as `$N` when `N` consists of a single digit. Positional parameters may not be assigned to with assignment statements. The `set` and `shift` builtins are used to set and unset them (see [Shell Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Shell-Builtin-Commands)). The positional parameters are temporarily replaced when a shell function is executed (see [Shell Functions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Functions)). 

_positional parameter_（位置参数）是指由一个或多个非单数`0`的数字表示的参数。位置参数在shell被调用时由其参数赋予，并可通过使用`set`内建命令重新赋值。可使用`${N}`或当`N`仅由一个数字组成时使用`$N`来引用位置参数`N`。不能使用赋值语句来为位置参数赋值。使用`set`和`shift`内建命令来设置和取消设置它们（参见[Shell内建命令](https://www.gnu.org/software/bash/manual/bash.html#Shell-Builtin-Commands)）。当执行shell函数时，位置参数会暂时被替换（参见[Shell函数](https://www.gnu.org/software/bash/manual/bash.html#Shell-Functions)）。

When a positional parameter consisting of more than a single digit is expanded, it must be enclosed in braces. 
当扩展由多于一个数字组成的位置参数时，必须将其置于花括号内。

___

#### 3.4.2 Special Parameters

The shell treats several parameters specially. These parameters may only be referenced; assignment to them is not allowed. shell 专门处理几个参数。 这些参数可能 仅被引用;不允许分配给他们。

`*`

`($\*)` Expands to the positional parameters, starting from one. When the expansion is not within double quotes, each positional parameter expands to a separate word. In contexts where it is performed, those words are subject to further word splitting and filename expansion. When the expansion occurs within double quotes, it expands to a single word with the value of each parameter separated by the first character of the `IFS` special variable. That is, `"$*"` is equivalent to `"$1c$2c…"`, where c is the first character of the value of the `IFS` variable. If `IFS` is unset, the parameters are separated by spaces. If `IFS` is null, the parameters are joined without intervening separators. 

`($\*)` 展开为从 1 开始的位置参数。 当扩展不在双引号内时，每个位置参数 扩展为一个单独的单词。 在执行它的上下文中，这些词 需要进一步拆分单词和文件名扩展。 当扩展发生在双引号内时，它会扩展为单个单词 每个参数的值用 `IFS` 特殊变量的第一个字符分隔。 即 `"$*"` 等价于 `"$1c$2c..."`，其中 c 是 `IFS` 变量值的第一个字符。 如果 `IFS` 未设置，参数之间用空格分隔。 如果 `IFS` 为 null，则在不进行干预的情况下连接参数 分隔符。

`@`

`($@)` Expands to the positional parameters, starting from one. In contexts where word splitting is performed, this expands each positional parameter to a separate word; if not within double quotes, these words are subject to word splitting. In contexts where word splitting is not performed, this expands to a single word with each positional parameter separated by a space. When the expansion occurs within double quotes, and word splitting is performed, each parameter expands to a separate word. That is, `"$@"` is equivalent to `"$1" "$2" …`. If the double-quoted expansion occurs within a word, the expansion of the first parameter is joined with the beginning part of the original word, and the expansion of the last parameter is joined with the last part of the original word. When there are no positional parameters, `"$@"` and `$@` expand to nothing (i.e., they are removed). 

`($@)` 展开为从 1 开始的位置参数。 在执行词分割的上下文中，此扩展将每个位置参数扩展为一个单独的词；如果不处于双引号内，这些词将受词分割影响。在不执行词分割的上下文中，此扩展为单个词，每个位置参数由空格分隔。当扩展位于双引号内且执行词分割时，每个参数扩展为一个单独的词。即 `"$@"` 等价于 `"$1" "$2" ...`。如果双引号内的扩展位于一个词内，第一个参数的扩展与原始词的开头部分相连，最后一个参数的扩展与原始词的结尾部分相连。当没有位置参数时，`"$@"` 和 `$@` 展开为空（即被移除）。

`#`

`($#)` Expands to the number of positional parameters in decimal. 
`($#)` 展开为十进制形式的位置参数数量。

`?`

`($?)` Expands to the exit status of the most recently executed foreground pipeline.
`($?)` 展开为最近执行的前台管道的退出状态。

`-`

(`$-`, a hyphen.) Expands to the current option flags as specified upon invocation, by the `set` builtin command, or those set by the shell itself (such as the \-i option).
(`$-`, 即一个连字符) 展开为启动时指定的当前选项标志，由 `set` 内置命令设置，或者由 shell 自身设置（如 \-i 选项）。

`$`

`($$)` Expands to the process <small>ID</small> of the shell. In a subshell, it expands to the process <small>ID</small> of the invoking shell, not the subshell. 
`($$)` 展开为 shell 的进程 <small>ID</small>。在子 shell 中，它展开为调用 shell（而非子 shell）的进程 <small>ID</small>。

`!`

`($!)` Expands to the process <small>ID</small> of the job most recently placed into the background, whether executed as an asynchronous command or using the `bg` builtin (see [Job Control Builtins](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Builtins)). 
`($!)` 展开为最近放入后台的作业的进程 <small>ID</small>，无论它是作为异步命令执行还是使用 `bg` 内建命令（参见 [作业控制内建命令](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Builtins)）。

`0`

`($0)` Expands to the name of the shell or shell script. This is set at shell initialization. If Bash is invoked with a file of commands (see [Shell Scripts](https://www.gnu.org/software/bash/manual/bash.html#Shell-Scripts)), `$0` is set to the name of that file. If Bash is started with the \-c option (see [Invoking Bash](https://www.gnu.org/software/bash/manual/bash.html#Invoking-Bash)), then `$0` is set to the first argument after the string to be executed, if one is present. Otherwise, it is set to the filename used to invoke Bash, as given by argument zero. 
`($0)` 展开为 shell 或 shell 脚本的名称。这是在 shell 初始化时设置的。如果使用包含命令的文件调用 Bash（参见 [Shell 脚本](https://www.gnu.org/software/bash/manual/bash.html#Shell-Scripts)），则将 `$0` 设置为该文件的名称。如果使用 \-c 选项启动 Bash（参见 [调用 Bash](https://www.gnu.org/software/bash/manual/bash.html#Invoking-Bash)），那么如果有参数存在，在待执行字符串后的第一个参数将被用于设置 `$0`。否则，它将被设置为用于调用 Bash 的文件名，即参数零所给出的。

___

### 3.5 Shell Expansions

Expansion is performed on the command line after it has been split into `token`s. There are seven kinds of expansion performed: 

命令行在被分割成 `token` 后进行扩展。执行以下七种扩展：

1. 大括号扩展（brace expansion）
2. 波浪线扩展（tilde expansion）
3. 参数与变量扩展（parameter and variable expansion）
4. 命令替换（command substitution）
5. 算术扩展（arithmetic expansion）
6. 词（字）分割（word splitting）
7. 文件名扩展（filename expansion）
  
The order of expansions is: brace expansion; tilde expansion, parameter and variable expansion, arithmetic expansion, and command substitution (done in a left-to-right fashion); word splitting; and filename expansion. 

扩展的顺序如下：大括号扩展；波浪线扩展，参数与变量扩展，算术扩展，以及命令替换（以上均按从左至右的顺序进行）；词（字）分割；以及文件名扩展。

On systems that can support it, there is an additional expansion available: _process substitution_. This is performed at the same time as tilde, parameter, variable, and arithmetic expansion and command substitution. 
在支持的系统上，还有一种额外的扩展可用：_进程替换_。这种扩展与波浪线、参数、变量、算术扩展以及命令替换同时进行。

After these expansions are performed, quote characters present in the original word are removed unless they have been quoted themselves (_quote removal_). 
完成上述扩展后，除非原始词中的引号字符自身也被引用（_引号去除_），否则将被移除。

Only brace expansion, word splitting, and filename expansion can increase the number of words of the expansion; other expansions expand a single word to a single word. The only exceptions to this are the expansions of `"$@"` and `$*` (see [Special Parameters](https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters)), and `"${name[@]}"` and `${name[*]}` (see [Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)). 

只有大括号扩展、词（字）分割以及文件名扩展能够增加扩展后的词（字）数；其他扩展均将一个词（字）扩展为一个词（字）。唯一的例外是 `"$@"` 和 `$*`（参见 [特殊参数](https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters)）以及 `"${name[@]}"` 和 `${name[*]}`（参见 [数组](https://www.gnu.org/software/bash/manual/bash.html#Arrays)）的扩展。


After all expansions, `quote removal` (see [Quote Removal](https://www.gnu.org/software/bash/manual/bash.html#Quote-Removal)) is performed. 
所有扩展完成后，执行 [引号去除](https://www.gnu.org/software/bash/manual/bash.html#Quote-Removal)。

-   [Brace Expansion 大括号扩展](https://www.gnu.org/software/bash/manual/bash.html#Brace-Expansion)
-   [Tilde Expansion 波浪线扩展](https://www.gnu.org/software/bash/manual/bash.html#Tilde-Expansion)
-   [Shell Parameter Expansion Shell参数扩展](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)
-   [Command Substitution 命令替换](https://www.gnu.org/software/bash/manual/bash.html#Command-Substitution)
-   [Arithmetic Expansion 算术扩展](https://www.gnu.org/software/bash/manual/bash.html#Arithmetic-Expansion)
-   [Process Substitution 进程替换](https://www.gnu.org/software/bash/manual/bash.html#Process-Substitution)
-   [Word Splitting 词（字）分割](https://www.gnu.org/software/bash/manual/bash.html#Word-Splitting)
-   [Filename Expansion 文件名扩展](https://www.gnu.org/software/bash/manual/bash.html#Filename-Expansion)
-   [Quote Removal 引号去除](https://www.gnu.org/software/bash/manual/bash.html#Quote-Removal)

___

#### 3.5.1 Brace Expansion

Brace expansion is a mechanism by which arbitrary strings may be generated. This mechanism is similar to _filename expansion_ (see [Filename Expansion](https://www.gnu.org/software/bash/manual/bash.html#Filename-Expansion)), but the filenames generated need not exist. Patterns to be brace expanded take the form of an optional preamble, followed by either a series of comma-separated strings or a sequence expression between a pair of braces, followed by an optional postscript. The preamble is prefixed to each string contained within the braces, and the postscript is then appended to each resulting string, expanding left to right.

大括号扩展是一种生成任意字符串的机制。该机制类似于 _文件名扩展_（参见 [文件名扩展](https://www.gnu.org/software/bash/manual/bash.html#Filename-Expansion)），但生成的文件名无需实际存在。待大括号扩展的模式形如可选的前缀，后面跟着一对大括号内的一系列以逗号分隔的字符串或序列表达式，再跟一个可选的后缀。前缀会被添加到大括号内的每个字符串之前，而每个结果字符串之后会追加后缀，自左向右进行扩展。

Brace expansions may be nested. The results of each expanded string are not sorted; left to right order is preserved. For example,

大括号扩展可以嵌套。每个扩展字符串的结果不会进行排序；保留自左至右的顺序。例如，

```
bash$ echo a{d,c,b}e
ade ace abe
```

A sequence expression takes the form `{x..y[..incr]}`, where x and y are either integers or letters, and incr, an optional increment, is an integer. When integers are supplied, the expression expands to each number between x and y, inclusive. Supplied integers may be prefixed with `0` to force each term to have the same width. When either x or y begins with a zero, the shell attempts to force all generated terms to contain the same number of digits, zero-padding where necessary. When letters are supplied, the expression expands to each character lexicographically between x and y, inclusive, using the default C locale. Note that both x and y must be of the same type (integer or letter). When the increment is supplied, it is used as the difference between each term. The default increment is 1 or -1 as appropriate.

序列表达式采用形如 `{x..y[..incr]}` 的形式，其中 x 和 y 既可以是整数也可以是字母，而可选的增量 incr 是一个整数。当提供整数时，表达式扩展为 x 和 y 之间的每个数字（包括两者）。提供的整数可以以 `0` 为前缀，以强制每个项具有相同的宽度。当 x 或 y 以零开头时，shell 会尝试通过必要的零填充使生成的所有项包含相同位数的数字。当提供字母时，表达式根据默认 C 语言环境扩展为 x 和 y 之间（包括两者）的每个字符。注意 x 和 y 必须是同一类型（整数或字母）。当提供增量时，它被用作各项之间的差。默认增量为 1 或 -1（视情况而定）。

Brace expansion is performed before any other expansions, and any characters special to other expansions are preserved in the result. It is strictly textual. Bash does not apply any syntactic interpretation to the context of the expansion or the text between the braces. 

大括号扩展在任何其他扩展之前执行，并且结果中保留对其他扩展具有特殊意义的任何字符。它是严格文本性的。Bash 不对扩展的上下文或大括号之间的文本进行任何语法解释。

A correctly-formed brace expansion must contain unquoted opening and closing braces, and at least one unquoted comma or a valid sequence expression. Any incorrectly formed brace expansion is left unchanged. 

正确构成的大括号扩展必须包含未引用的开闭大括号，以及至少一个未引用的逗号或有效的序列表达式。任何格式错误的大括号扩展保持不变。

A `{` or `,` may be quoted with a backslash to prevent its being considered part of a brace expression. To avoid conflicts with parameter expansion, the string `${` is not considered eligible for brace expansion, and inhibits brace expansion until the closing ``}``.

可以用反斜杠引用 `{` 或 `,` 以防止它们被视为大括号表达式的一部分。为了避免与参数扩展冲突，字符串 ``${`` 不被认为是适合大括号扩展的，并且会抑制直到遇到闭合 `}` 为止的大括号扩展。

This construct is typically used as shorthand when the common prefix of the strings to be generated is longer than in the above example: 

通常在要生成的字符串的公共前缀比上面示例更长时使用这种构造作为简写：
```
mkdir /usr/local/src/bash/{old,new,dist,bugs}
```

or

```
chown root /usr/{ucb/{ex,edit},lib/{ex?.?*,how_ex}}
```

___

#### 3.5.2 Tilde Expansion

If a word begins with an unquoted tilde character (`~`), all of the characters up to the first unquoted slash (or all characters, if there is no unquoted slash) are considered a _tilde-prefix_. If none of the characters in the tilde-prefix are quoted, the characters in the tilde-prefix following the tilde are treated as a possible _login name_. If this login name is the null string, the tilde is replaced with the value of the `HOME` shell variable. If `HOME` is unset, the home directory of the user executing the shell is substituted instead. Otherwise, the tilde-prefix is replaced with the home directory associated with the specified login name.

如果一个词以未引用的波浪线字符（`~`）开头，则直到第一个未引用的斜杠（如果没有未引用的斜杠，则为所有字符）的所有字符都被视为 _波浪线前缀_ 。如果波浪线前缀中的任何字符都没有被引用，则波浪线后的波浪线前缀字符被视为可能的 _登录名_ 。如果这个登录名是空字符串，则用 `HOME` shell 变量的值替换波浪线。如果 `HOME` 未设置，则替换为执行 shell 的用户的主目录。否则，用与指定登录名关联的主目录替换波浪线前缀。

If the tilde-prefix is `~+`, the value of the shell variable `PWD` replaces the tilde-prefix. If the tilde-prefix is `~-`, the value of the shell variable `OLDPWD`, if it is set, is substituted.

如果波浪线前缀是 ``~~+`` ，则用 shell 变量 `PWD` 的值替换波浪线前缀。如果波浪线前缀是 `~~-` ，并且已设置了 shell 变量 `OLDPWD` ，则用其值替换。

If the characters following the tilde in the tilde-prefix consist of a number N, optionally prefixed by a `+` or a `\-`, the tilde-prefix is replaced with the corresponding element from the directory stack, as it would be displayed by the `dirs` builtin invoked with the characters following tilde in the tilde-prefix as an argument (see [The Directory Stack](https://www.gnu.org/software/bash/manual/bash.html#The-Directory-Stack)). If the tilde-prefix, sans the tilde, consists of a number without a leading `+` or `\-`, `+` is assumed. 

如果波浪线前缀中波浪线后面的字符由一个数字 N 组成，该数字可选地由 `+` 或 `-` 前缀，波浪线前缀将被替换为从目录堆栈中相应的元素，就像用波浪线前缀中波浪线后面的字符作为参数调用 `dirs` 内建命令时所显示的那样（参见 [目录堆栈](https://www.gnu.org/software/bash/manual/bash.html#The-Directory-Stack)）。如果除去波浪线的波浪线前缀仅由无前导 `+` 或 `-` 的数字组成，则假定为 `+` 。

If the login name is invalid, or the tilde expansion fails, the word is left unchanged.
如果登录名无效，或波浪线扩展失败，词保持不变。

Each variable assignment is checked for unquoted tilde-prefixes immediately following a `:` or the first `=`. In these cases, tilde expansion is also performed. Consequently, one may use filenames with tildes in assignments to `PATH`, `MAILPATH`, and `CDPATH`, and the shell assigns the expanded value.

对每个变量赋值检查紧跟在 `:` 或第一个 `=` 后面的未引用波浪线前缀。在这种情况下，也会执行波浪线扩展。因此，可以在对 `PATH` 、 `MAILPATH` 和 `CDPATH` 的赋值中使用带有波浪线的文件名，shell 将分配扩展后的值。

The following table shows how Bash treats unquoted tilde-prefixes:
下表显示了 Bash 如何处理未引用的波浪线前缀：

`~`

The value of `$HOME`

`~/foo`

`$HOME/foo`

`~fred/foo`

The subdirectory `foo` of the home directory of the user

`~+/foo`

`$PWD/foo`

`~-/foo`

`${OLDPWD-`~-`}/foo`

`~N`

The string that would be displayed by '`dirs +N`'

`~+N`

The string that would be displayed by '`dirs +N`'

`~-N`

The string that would be displayed by '`dirs -N`'

Bash also performs tilde expansion on words satisfying the conditions of variable assignments (see [Shell Parameters](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameters)) when they appear as arguments to simple commands. Bash does not do this, except for the declaration commands listed above, when in <small>POSIX</small> mode. 
当满足变量赋值条件的词（参见 [Shell 参数](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameters)）作为简单命令的参数出现时，Bash 也会进行波浪线扩展。在 <small>POSIX</small> 模式下，除了上述声明命令外，Bash 不进行此操作。
___

#### 3.5.3 Shell Parameter Expansion

The ``$`` character introduces parameter expansion, command substitution, or arithmetic expansion. The parameter name or symbol to be expanded may be enclosed in braces, which are optional but serve to protect the variable to be expanded from characters immediately following it which could be interpreted as part of the name.

字符 ``$`` 引入参数扩展、命令替换或算术扩展。要扩展的参数名或符号可以放在花括号内，这是可选的，但有助于保护要扩展的变量不受其后可能被解释为其名称一部分的字符的影响。

When braces are used, the matching ending brace is the first ``}`` not escaped by a backslash or within a quoted string, and not within an embedded arithmetic expansion, command substitution, or parameter expansion.

使用花括号时，匹配的结束花括号是第一个非反斜杠转义的、不在引用字符串内、也不在嵌套的算术扩展、命令替换或参数扩展内的 `}`。

The basic form of parameter expansion is ${parameter}. The value of parameter is substituted. The parameter is a shell parameter as described above (see [Shell Parameters](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameters)) or an array reference (see [Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)). The braces are required when parameter is a positional parameter with more than one digit, or when parameter is followed by a character that is not to be interpreted as part of its name.

参数扩展的基本形式为 `${parameter}`。参数的值被替换。参数是一个如上所述的 shell 参数（参见 [Shell 参数](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameters)）或一个数组引用（参见 [数组](https://www.gnu.org/software/bash/manual/bash.html#Arrays)）。当参数是一个多于一位的定位参数，或参数后面跟随的字符不应被解释为其名称的一部分时，需要使用花括号。


If the first character of parameter is an exclamation point (!), and parameter is not a nameref, it introduces a level of indirection. Bash uses the value formed by expanding the rest of parameter as the new parameter; this is then expanded and that value is used in the rest of the expansion, rather than the expansion of the original parameter. This is known as `indirect expansion`. The value is subject to tilde expansion, parameter expansion, command substitution, and arithmetic expansion. If parameter is a nameref, this expands to the name of the variable referenced by parameter instead of performing the complete indirect expansion. The exceptions to this are the expansions of `${!prefix\*}` and `${!name\[@\]}` described below. The exclamation point must immediately follow the left brace in order to introduce indirection.

如果参数的第一个字符是感叹号 `(!)`，且参数不是 `nameref`，它引入了一层间接性。Bash 使用通过扩展参数剩余部分形成的值作为新的参数；然后扩展这个新值，并在其余扩展中使用这个扩展值，而不是使用原始参数的扩展值。这被称为 `间接扩展`。这个值受波浪线扩展、参数扩展、命令替换和算术扩展影响。如果参数是 `nameref`，这将扩展为由参数引用的变量的名称，而非执行完整的间接扩展。以下描述的 `${!prefix\*}` 和 `${!name\[@\]}` 扩展是例外。感叹号必须紧随左花括号以引入间接性。

In each of the cases below, word is subject to tilde expansion, parameter expansion, command substitution, and arithmetic expansion.
在以下每种情况下，word 都受波浪线扩展、参数扩展、命令替换和算术扩展影响。

When not performing substring expansion, using the form described below (e.g., ``:-``), Bash tests for a parameter that is unset or null. Omitting the colon results in a test only for a parameter that is unset. Put another way, if the colon is included, the operator tests for both parameter’s existence and that its value is not null; if the colon is omitted, the operator tests only for existence.
在不执行子串扩展（使用下面描述的形式，如 ``:-``）时，Bash 测试参数是否未设置或为空。省略冒号只测试参数是否未设置。换句话说，如果包含冒号，操作符测试参数是否存在及其值是否不为空；如果省略冒号，操作符仅测试是否存在。

`${parameter:-word}`

If parameter is unset or null, the expansion of word is substituted. Otherwise, the value of parameter is substituted.
如果参数未设置或为空，则替换 word 的扩展。否则，替换参数的值。

```bash
$ v=123
$ echo ${v-unset}
123
```

`${parameter:=word}`

If parameter is unset or null, the expansion of word is assigned to parameter. The value of parameter is then substituted. Positional parameters and special parameters may not be assigned to in this way. 
如果参数未设置或为空，则将 word 的扩展赋值给参数。随后替换参数的值。不能以这种方式为位置参数和特殊参数赋值。

```bash
$ var=
$ : ${var:=DEFAULT}
$ echo $var
DEFAULT
```

`${parameter:?word}`

If parameter is null or unset, the expansion sof word (or a message to that effect if word is not present) is written to the standard error and the shell, if it is not interactive, exits. Otherwise, the value of parameter is substituted.
如果参数为空或未设置，则将 word（或如果未提供 word，则为相应消息）写入标准错误，并且（如果 shell 不是交互式的）退出 shell。否则，替换参数的值。

```bash
$ var=
$ : ${var:?var is unset or null}
bash: var: var is unset or null
```

`${parameter:+word}`

If parameter is null or unset, nothing is substituted, otherwise the expansion of word is substituted.
如果参数为空或未设置，则不进行替换，否则替换 word 的扩展。

```bash
$ var=123
$ echo ${var:+var is set and not null}
var is set and not null
```

`${parameter:offset}`

`${parameter:offset:length}`

This is referred to as Substring Expansion. It expands to up to length characters of the value of parameter starting at the character specified by offset. If parameter is ``@`` or ``\*``, an indexed array subscripted by ``@`` or ``\*``, or an associative array name, the results differ as described below. If length is omitted, it expands to the substring of the value of parameter starting at the character specified by offset and extending to the end of the value. length and offset are arithmetic expressions (see [Shell Arithmetic](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)).
这称为子串扩展。它扩展为参数值从由 offset 指定的字符开始的最多 length 个字符。如果参数是 ``@`` 或 `*`，或者是由 ``@`` 或 `*` 下标索引的索引数组，或关联数组名，结果如下面所述有所不同。如果省略 length，则扩展为参数值从由 offset 指定的字符开始到值的结尾的子串。length 和 offset 是算术表达式（参见 [Shell 算术](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)）。

If offset evaluates to a number less than zero, the value is used as an offset in characters from the end of the value of parameter. If length evaluates to a number less than zero, it is interpreted as an offset in characters from the end of the value of parameter rather than a number of characters, and the expansion is the characters between offset and that result. Note that a negative offset must be separated from the colon by at least one space to avoid being confused with the ``:-`` expansion.
如果 offset 计算结果为小于零的数，则该值作为从参数值结尾起的字符偏移量使用。如果 length 计算结果为小于零的数，它被解释为从参数值结尾起的字符偏移量而非字符数，扩展结果为 offset 和该结果之间的字符。请注意，负偏移必须与冒号至少间隔一个空格，以避免与 ``:-`` 扩展混淆。

Here are some examples illustrating substring expansion on parameters and subscripted arrays:
以下是关于参数和下标数组的子串扩展的一些示例：

```bash
$ string=01234567890abcdefgh
$ echo ${string:7}
7890abcdefgh
$ echo ${string:7:0}

$ echo ${string:7:2}
78
$ echo ${string:7:-2}
7890abcdef
$ echo ${string: -7}
bcdefgh
$ echo ${string: -7:0}

$ echo ${string: -7:2}
bc
$ echo ${string: -7:-2}
bcdef
$ set -- 01234567890abcdefgh
$ echo ${1:7}
7890abcdefgh
$ echo ${1:7:0}

$ echo ${1:7:2}
78
$ echo ${1:7:-2}
7890abcdef
$ echo ${1: -7}
bcdefgh
$ echo ${1: -7:0}

$ echo ${1: -7:2}
bc
$ echo ${1: -7:-2}
bcdef
$ array[0]=01234567890abcdefgh
$ echo ${array[0]:7}
7890abcdefgh
$ echo ${array[0]:7:0}

$ echo ${array[0]:7:2}
78
$ echo ${array[0]:7:-2}
7890abcdef
$ echo ${array[0]: -7}
bcdefgh
$ echo ${array[0]: -7:0}

$ echo ${array[0]: -7:2}
bc
$ echo ${array[0]: -7:-2}
bcdef
```

If parameter is ``@`` or ``\*``, the result is length positional parameters beginning at offset. A negative offset is taken relative to one greater than the greatest positional parameter, so an offset of -1 evaluates to the last positional parameter. It is an expansion error if length evaluates to a number less than zero. 
如果参数是 ``@`` 或 ``\*``，结果是从 offset 开始的长度为 length 的位置参数。负偏移相对于大于最大位置参数的值计算，因此偏移 -1 评估为最后一个位置参数。如果 length 计算结果为小于零的数，则为扩展错误。

The following examples illustrate substring expansion using positional parameters: 
以下示例展示了使用位置参数的子串扩展：

```bash
$ set -- 1 2 3 4 5 6 7 8 9 0 a b c d e f g h
$ echo ${@:7}
7 8 9 0 a b c d e f g h
$ echo ${@:7:0}

$ echo ${@:7:2}
7 8
$ echo ${@:7:-2}
bash: -2: substring expression &lt; 0
$ echo ${@: -7:2}
b c
$ echo ${@:0}
./bash 1 2 3 4 5 6 7 8 9 0 a b c d e f g h
$ echo ${@:0:2}
./bash 1
$ echo ${@: -7:0}

```

If parameter is an indexed array name subscripted by ``@`` or ``\*``, the result is the length members of the array beginning with `${parameter[offset]}`. A negative offset is taken relative to one greater than the maximum index of the specified array. It is an expansion error if length evaluates to a number less than zero.
如果参数是由 ``@`` 或 ``\*`` 下标的索引数组名，结果是从 `${parameter[offset]}` 开始的数组的 length 个成员。负偏移相对于指定数组的最大索引值加一计算。如果 length 计算结果为小于零的数，则为扩展错误。


These examples show how you can use substring expansion with indexed arrays:
以下示例展示了如何使用子串扩展与索引数组：

```bash
$ array=(0 1 2 3 4 5 6 7 8 9 0 a b c d e f g h)
$ echo ${array[@]:7}
7 8 9 0 a b c d e f g h
$ echo ${array[@]:7:2}
7 8
$ echo ${array[@]: -7:2}
b c
$ echo ${array[@]: -7:-2}
bash: -2: substring expression &lt; 0
$ echo ${array[@]:0}
0 1 2 3 4 5 6 7 8 9 0 a b c d e f g h
$ echo ${array[@]:0:2}
0 1
$ echo ${array[@]: -7:0}

```

Substring expansion applied to an associative array produces undefined results.

Substring indexing is zero-based unless the positional parameters are used, in which case the indexing starts at 1 by default. If offset is 0, and the positional parameters are used, `$0` is prefixed to the list.

`${!prefix*}`${!prefix\*}

`${!prefix@}`${!prefix@}

Expands to the names of variables whose names begin with prefix, separated by the first character of the `IFS` special variable. When ``@`` is used and the expansion appears within double quotes, each variable name expands to a separate word. 展开为名称以前prefix用 `IFS`当使用“@开头的变量的名称， 特殊变量的第一个字符分隔。 ”并且扩展显示在双引号内时，每个 变量名称扩展为单独的单词。

`${!name[@]}`${!name\[@\]}

`${!name[*]}`${!name\[\*\]}

If name is an array variable, expands to the list of array indices (keys) assigned in name. If name is not an array, expands to 0 if name is set and null otherwise. When ``@`` is used and the expansion appears within double quotes, each key expands to a separate word. 如果 name（密钥）name如果 name 不是数组，则如果 name当使用“@ 是数组变量，则展开到数组索引列表 分配。 设置为 null，则扩展为 0 否则。 ”并且扩展显示在双引号内时，每个 键扩展为一个单独的单词。

`${#parameter}`${#parameter}

The length in characters of the expanded value of parameter is substituted. If parameter is ``\*`` or ``@``, the value substituted is the number of positional parameters. If parameter is an array name subscripted by ``\*`` or ``@``, the value substituted is the number of elements in the array. If parameter is an indexed array name subscripted by a negative number, that number is interpreted as relative to one greater than the maximum index of parameter, so negative indices count back from the end of the array, and an index of -1 references the last element. parameter如果parameter为 `\*` 或 '@如果 parameter 是以 `\*` 或 @If parameterparameter扩展值的字符长度为 取代。 '，则将值替换为 是位置参数的数量。 ' 下标的数组名称， 替换的值是数组中的元素数。 是以负数下标的索引数组名称，该数字是 解释为相对于大于 1 的最大索引 ，因此负索引从末尾开始计数 数组，索引 -1 引用最后一个元素。

`${parameter#word}`${parameter#word}

`${parameter##word}`${parameter#word}

The word is expanded to produce a pattern and matched according to the rules described below (see [Pattern Matching](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)). If the pattern matches the beginning of the expanded value of parameter, then the result of the expansion is the expanded value of parameter with the shortest matching pattern (the `#` case) or the longest matching pattern (the `##` case) deleted. If parameter is ``@`` or ``\*``, the pattern removal operation is applied to each positional parameter in turn, and the expansion is the resultant list. If parameter is an array variable subscripted with ``@`` or ``\*``, the pattern removal operation is applied to each member of the array in turn, and the expansion is the resultant list. word如下所述（请参阅[模式匹配](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)parameter则展开的结果是parameter具有最短匹配模式（“#删除了最长的匹配模式（“##如果parameter为``@``或“\*如果 parameter``@`` 或 \* 展开以产生图案并根据规则进行匹配 ）。 如果模式匹配 扩展值的开头， 的扩展值 ”大小写）或 ”大小写）。 ”， 模式去除操作应用于每个位置 参数，展开是结果列表。 是下标的数组变量 '， 模式删除操作应用于 数组，扩展是结果列表。

`${parameter%word}`${parameter%word}

`${parameter%%word}`${parameter%word}

The word is expanded to produce a pattern and matched according to the rules described below (see [Pattern Matching](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)). If the pattern matches a trailing portion of the expanded value of parameter, then the result of the expansion is the value of parameter with the shortest matching pattern (the `%` case) or the longest matching pattern (the `%%` case) deleted. If parameter is ``@`` or ``\*``, the pattern removal operation is applied to each positional parameter in turn, and the expansion is the resultant list. If parameter is an array variable subscripted with ``@`` or ``\*``, the pattern removal operation is applied to each member of the array in turn, and the expansion is the resultant list. word如下所述（请参阅[模式匹配](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)parameter具有最短匹配模式的parameter（“%或删除最长的匹配模式（“%%如果parameter为``@``或“\*If parameter是以 @' 或 \* 展开以产生图案并根据规则进行匹配 ）。 如果模式与展开值的尾随部分匹配 ，则展开的结果是 ”大小写） ”大小写）。 ”， 模式去除操作应用于每个位置 参数，展开是结果列表。 ' 下标的数组变量， 模式删除操作应用于 数组，扩展是结果列表。

`${parameter/pattern/string}`${parameter/pattern/string}

`${parameter//pattern/string}`${parameter//pattern/string}

`${parameter/#pattern/string}`${parameter/#pattern/string}

`${parameter/%pattern/string}`${parameter/%pattern/string}

The pattern is expanded to produce a pattern just as in filename expansion. Parameter is expanded and the longest match of pattern against its value is replaced with string. string undergoes tilde expansion, parameter and variable expansion, arithmetic expansion, command and process substitution, and quote removal. The match is performed according to the rules described below (see [Pattern Matching](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)). patternParameter展开，patternagainst 其值替换为stringstring（请参阅[模式匹配](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)被扩展以产生一个模式，就像在 文件名扩展。 。 经历波浪号展开、参数和变量展开， 算术扩展、命令和进程替换以及引号删除。 比赛根据下述规则进行 ）。

In the first form above, only the first match is replaced. If there are two slashes separating parameter and pattern (the second form above), all matches of pattern are replaced with string. If pattern is preceded by `#` (the third form above), it must match at the beginning of the expanded value of parameter. If pattern is preceded by `%` (the fourth form above), it must match at the end of the expanded value of parameter. If the expansion of string is null, matches of pattern are deleted. If string is null, matches of pattern are deleted and the `/` following pattern may be omitted. 如果有两个斜杠分隔parameter和pattern（上面的第二种形式），pattern替换为string如果pattern前面有“#它必须与parameter如果pattern前面有“%它必须与parameter如果stringpattern如果stringpattern并且可以省略以下pattern的“/在上面的第一种形式中，只替换了第一场比赛。 都是 。 ”（上面的第三种形式）， 的扩展值的开头匹配。 ”（上面的第四种形式）， 的扩展值的末尾匹配。 的扩展为 null， 的匹配项将被删除。 为 null， 的匹配项 ”。

If the `patsub_replacement` shell option is enabled using `shopt`, any unquoted instances of `&` in string are replaced with the matching portion of pattern. This is intended to duplicate a common `sed` idiom. 如果使用 `shopt` 启用`patsub_replacement`string中任何不带引号的 '&pattern这是为了复制一个常见的 `sed` shell 选项， ' 实例都替换为 的匹配部分。 习语。

Quoting any part of string inhibits replacement in the expansion of the quoted portion, including replacement strings stored in shell variables. Backslash will escape `&` in string; the backslash is removed in order to permit a literal `&` in the replacement string. Users should take care if string is double-quoted to avoid unwanted interactions between the backslash and double-quoting, since backslash has special meaning within double quotes. Pattern substitution performs the check for unquoted `&` after expanding string, so users should ensure to properly quote any occurrences of `&` they want to be taken literally in the replacement and ensure any instances of `&` they want to be replaced are unquoted. 引用string反斜杠将转string中的“&为了允许在替换字符串中使用文字“&如果string模式替换对未加引号的“&扩展string因此，用户应确保正确引用任何出现的“&并确保要替换的任何“&的任何部分都会禁止替换 扩展引用部分，包括存储的替换字符串 在 shell 变量中。 ”;反斜杠被删除 ”。 是双引号的，用户应注意避免 反斜杠和双引号之间不需要的交互，因为 反斜杠在双引号中具有特殊含义。 ”执行检查 ， ” 他们希望从字面上被取代 ”实例均不带引号。

For instance, 例如

```
var=abcdef
rep='&amp; '
echo ${var/abc/&amp; }
echo "${var/abc/&amp; }"
echo ${var/abc/$rep}
echo "${var/abc/$rep}"
```

will display four lines of "abc def", while 将显示四行“ABC Def”，而

```
var=abcdef
rep='&amp; '
echo ${var/abc/\&amp; }
echo "${var/abc/\&amp; }"
echo ${var/abc/"&amp; "}
echo ${var/abc/"$rep"}
```

will display four lines of "& def". Like the pattern removal operators, double quotes surrounding the replacement string quote the expanded characters, while double quotes enclosing the entire parameter substitution do not, since the expansion is performed in a context that doesn’t take any enclosing double quotes into account. 将显示四行“&def”。 与模式去除运算符一样，双引号将 替换字符串引用扩展字符，而双引号 将整个参数替换括起来不要，因为 扩展是在 不考虑任何括起来的双引号的上下文。

Since backslash can escape `&`, it can also escape a backslash in the replacement string. This means that `\\\\` will insert a literal backslash into the replacement, so these two `echo` commands 由于反斜杠可以转义“&这意味着 '\\\\反斜杠到替换中，所以这两个 `echo`”，因此它也可以转义 替换字符串。 ' 将插入一个文本 命令

```
var=abcdef
rep='\\&amp;xyz'
echo ${var/abc/\\&amp;xyz}
echo ${var/abc/$rep}
```

will both output '\\abcxyzdef'. 将输出 '\\abcxyzdef'。

It should rarely be necessary to enclose only string in double quotes. 很少需要将string括成双倍 引号。

If the `nocasematch` shell option (see the description of `shopt` in [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)) is enabled, the match is performed without regard to the case of alphabetic characters. If parameter is ``@`` or ``\*``, the substitution operation is applied to each positional parameter in turn, and the expansion is the resultant list. If parameter is an array variable subscripted with ``@`` or ``\*``, the substitution operation is applied to each member of the array in turn, and the expansion is the resultant list. 如果 `nocasematch`（参见 [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin) 中`shopt`如果parameter为``@``或“\*If parameter是以 @' 或 \* shell 选项 的描述） 启用，则在不考虑情况的情况下执行匹配 的字母字符。 ”， 替换操作应用于每个位置 参数，展开是结果列表。 ' 下标的数组变量， 替换操作应用于 数组，扩展是结果列表。

`${parameter^pattern}`{{parameter^pattern}

`${parameter^^pattern}`${parameter^^pattern}

`${parameter,pattern}`${parameter，pattern}

`${parameter,,pattern}`${parameter，pattern}

This expansion modifies the case of alphabetic characters in parameter. The pattern is expanded to produce a pattern just as in filename expansion. Each character in the expanded value of parameter is tested against pattern, and, if it matches the pattern, its case is converted. The pattern should not attempt to match more than one character. 此扩展修改parameterpatternparameterpattern中字母字符的大小写。 被扩展以产生一个模式，就像在 文件名扩展。 扩展值中的每个字符都经过测试 ，如果它与模式匹配，则转换其大小写。 该模式不应尝试匹配多个字符。

The `^` operator converts lowercase letters matching pattern to uppercase; the `,` operator converts matching uppercase letters to lowercase. The `^^` and `,,` expansions convert each matched character in the expanded value; the `^` and `,` expansions match and convert only the first character in the expanded value. If pattern is omitted, it is treated like a `?`, which matches every character. `^` 运算符转换小写字母匹配pattern改为大写;“,"^^"和“,,扩大价值;"^"和“,如果省略 pattern，则将其视为匹配的"? "运算符转换匹配的大写字母 改为小写。 扩展将转换 ”扩展仅匹配并转换 扩展值中的第一个字符。 ” 每个角色。

If parameter is ``@`` or ``\*``, the case modification operation is applied to each positional parameter in turn, and the expansion is the resultant list. If parameter is an array variable subscripted with ``@`` or ``\*``, the case modification operation is applied to each member of the array in turn, and the expansion is the resultant list. 如果parameter为``@``或“\*If parameter是以 @' 或 \*”， 案例修改操作应用于每个位置 参数，展开是结果列表。 ' 下标的数组变量， 案例修改操作应用于 数组，扩展是结果列表。

`${parameter@operator}`${parameter@operator}

The expansion is either a transformation of the value of parameter or information about parameter itself, depending on the value of operator. Each operator is a single letter: 扩展是parameter或有关parameteroperator。 每个operator值的变换 本身的信息，具体取决于 都是一个字母：

`U`

The expansion is a string that is the value of parameter with lowercase alphabetic characters converted to uppercase. 扩展是一个字符串，它是小写的parameter的值 转换为大写的字母字符。

`u`

The expansion is a string that is the value of parameter with the first character converted to uppercase, if it is alphabetic. 扩展是一个字符串，它是参数的值，第一个 如果字符是字母，则转换为大写。

`L`

The expansion is a string that is the value of parameter with uppercase alphabetic characters converted to lowercase. 扩展是一个字符串，它是大写的parameter的值 转换为小写的字母字符。

`Q`

The expansion is a string that is the value of parameter quoted in a format that can be reused as input. 扩展是一个字符串，它是用 可重用为输入的格式。

`E`

The expansion is a string that is the value of parameter with backslash escape sequences expanded as with the `$`…`` quoting mechanism. 扩展是一个字符串，它是带反斜杠的parameter转义序列扩展为 `$`…``的值 引用机制。

`P`

The expansion is a string that is the result of expanding the value of parameter as if it were a prompt string (see [Controlling the Prompt](https://www.gnu.org/software/bash/manual/bash.html#Controlling-the-Prompt)). parameter，就好像它是一个提示字符串（请参阅[控制提示](https://www.gnu.org/software/bash/manual/bash.html#Controlling-the-Prompt)扩展是一个字符串，它是扩展 符）。

`A`

The expansion is a string in the form of an assignment statement or `declare` command that, if evaluated, will recreate parameter with its attributes and value. 赋值语句或`declare`evaluated，将重新创建具有其属性和值的parameter扩展是 命令，如果 。

`K`

Produces a possibly-quoted version of the value of parameter, except that it prints the values of indexed and associative arrays as a sequence of quoted key-value pairs (see [Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)). 生成parameter（请参阅[数组](https://www.gnu.org/software/bash/manual/bash.html#Arrays)值的可能引用版本， 除了它打印的值 索引数组和关联数组作为带引号的键值对序列 ）。

`a`

The expansion is a string consisting of flag values representing parameter’s attributes. parameter扩展是一个字符串，由表示 的属性。

`k`

Like the `K` transformation, but expands the keys and values of indexed and associative arrays to separate words after word splitting. 与"K"变换类似，但扩展了 索引数组和关联数组，用于在拆分单词后分隔单词。

If parameter is ``@`` or ``\*``, the operation is applied to each positional parameter in turn, and the expansion is the resultant list. If parameter is an array variable subscripted with ``@`` or ``\*``, the operation is applied to each member of the array in turn, and the expansion is the resultant list. 如果parameter为``@``或“\*If parameter是以 @' 或 \*”， 该操作应用于每个位置 参数，展开是结果列表。 ' 下标的数组变量， 该操作应用于 数组，扩展是结果列表。

The result of the expansion is subject to word splitting and filename expansion as described below. 扩展的结果受单词拆分和文件名的影响 扩展如下所述。

___

#### 3.5.4 Command Substitution3.5.4 命令替换

Command substitution allows the output of a command to replace the command itself. Command substitution occurs when a command is enclosed as follows: 命令替换允许命令的输出替换 命令本身。 当命令被封装时，将发生命令替换，如下所示：

or 或

Bash performs the expansion by executing command in a subshell environment and replacing the command substitution with the standard output of the command, with any trailing newlines deleted. Embedded newlines are not deleted, but they may be removed during word splitting. The command substitution `$(cat file)` can be replaced by the equivalent but faster `$(< file)`. Bash 通过在 subshell 环境中执行command命令 substitution $（cat file替换为等效但速度更快的 $（< file来执行扩展 并将命令替换替换为 命令，删除所有尾随换行符。 嵌入的换行符不会被删除，但可能会在 单词拆分。 ） 可以是 ）。

When the old-style backquote form of substitution is used, backslash retains its literal meaning except when followed by '$`, `\`', or `\\`. The first backquote not preceded by a backslash terminates the command substitution. When using the `$(command)` form, all characters between the parentheses make up the command; none are treated specially. `$`、`\`` 或 '\\使用 $（command当使用旧式的反引号替换形式时， 反斜杠保留其字面含义，除非后面跟着 '。 第一个不带反斜杠的反引号终止 命令替换。 ） 表单时，所有字符 括号组成命令;没有一个受到特殊对待。

Command substitutions may be nested. To nest when using the backquoted form, escape the inner backquotes with backslashes. 命令替换可以嵌套。 使用反引号时嵌套 形式，用反斜杠转义内部反引号。

If the substitution appears within double quotes, word splitting and filename expansion are not performed on the results. 如果替换出现在双引号内，则拆分单词和 不对结果执行文件名扩展。

___

#### 3.5.5 Arithmetic Expansion3.5.5 算术扩展

Arithmetic expansion allows the evaluation of an arithmetic expression and the substitution of the result. The format for arithmetic expansion is: 算术扩展允许计算算术表达式 以及结果的替换。 算术扩展的格式为：

The expression undergoes the same expansions as if it were within double quotes, but double quote characters in expression are not treated specially and are removed. All tokens in the expression undergo parameter and variable expansion, command substitution, and quote removal. The result is treated as the arithmetic expression to be evaluated. Arithmetic expansions may be nested. expression但是expression经历相同的扩展 好像它在双引号内， 式中的双引号字符没有特殊处理 并被删除。 表达式中的所有标记都经过参数和变量扩展， 命令替换和引号删除。 结果被视为要计算的算术表达式。 算术扩展可以嵌套。

The evaluation is performed according to the rules listed below (see [Shell Arithmetic](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)). If the expression is invalid, Bash prints a message indicating failure to the standard error and no substitution occurs. （请参阅[壳牌算术](https://www.gnu.org/software/bash/manual/bash.html#Shell-Arithmetic)评估根据下列规则进行 ）。 如果表达式无效，Bash 会打印一条消息，指示 不符合标准错误，并且不会发生替换。

___

#### 3.5.6 Process Substitution3.5.6 进程替代

Process substitution allows a process’s input or output to be referred to using a filename. It takes the form of 流程替换允许流程的输入或输出 指使用文件名。 它的形式是

or 或

The process list is run asynchronously, and its input or output appears as a filename. This filename is passed as an argument to the current command as the result of the expansion. If the `>(list)` form is used, writing to the file will provide input for list. If the `<(list)` form is used, the file passed as an argument should be read to obtain the output of list. Note that no space may appear between the `<` or `>` and the left parenthesis, otherwise the construct would be interpreted as a redirection. Process substitution is supported on systems that support named pipes (<small>FIFO</small>s) or the /dev/fd method of naming open files. 进程list如果使用 >（list该文件将为list<（list应读取参数以获取 list请注意，`<`或`>`管道 （<small>FIFO</small>s） 或命名打开文件的 /dev/fd异步运行，其输入或输出 显示为文件名。 此文件名是 作为参数传递给当前命令，作为 扩张。 ） 表单，则写入 提供输入。 如果 ）使用表单，文件作为 的输出。 之间不得出现空格 和左括号，否则将解释该结构 作为重定向。 支持进程替换的系统支持 方法。

When available, process substitution is performed simultaneously with parameter and variable expansion, command substitution, and arithmetic expansion. 如果可用，则同时执行过程替换 参数和变量扩展、命令替换和算术 扩张。

___

#### 3.5.7 Word Splitting3.5.7 拆分单词

The shell scans the results of parameter expansion, command substitution, and arithmetic expansion that did not occur within double quotes for word splitting. shell 扫描参数扩展、命令替换、 和双引号内未发生的算术扩展 单词拆分。

The shell treats each character of `$IFS` as a delimiter, and splits the results of the other expansions into words using these characters as field terminators. If `IFS` is unset, or its value is exactly `<space><tab><newline>`, the default, then sequences of `<space>`, `<tab>`, and `<newline>` at the beginning and end of the results of the previous expansions are ignored, and any sequence of `IFS` characters not at the beginning or end serves to delimit words. If `IFS` has a value other than the default, then sequences of the whitespace characters `space`, `tab`, and `newline` are ignored at the beginning and end of the word, as long as the whitespace character is in the value of `IFS` (an `IFS` whitespace character). Any character in `IFS` that is not `IFS` whitespace, along with any adjacent `IFS` whitespace characters, delimits a field. A sequence of `IFS` whitespace characters is also treated as a delimiter. If the value of `IFS` is null, no word splitting occurs. shell 将 `$IFS`如果 `IFS` 未设置，或者其值正好`<space><tab><newline>` `<space>`、 `<tab>`和`<newline>`扩展将被忽略，`IFS`如果 `IFS`空格字符`space`、`tab`和`newline``IFS` 的值（`IFS``IFS` 中非 `IFS`空格，以及任何相邻`IFS`空格字符，分隔字段。 `IFS`如果 `IFS` 的每个字符视为分隔符，并拆分 使用这些字符将其他扩展为单词的结果 作为现场终结者。 为 ， 默认值，则 在上一个结果的开头和结尾 的任何序列都将被忽略 不在开头或结尾的字符用于分隔单词。 的值不是默认值，则 在开头和结尾被忽略 word，只要空格字符在 空格字符）。 的任何字符 序列 空格字符也被视为分隔符。 的值为 null，则不会发生单词拆分。

Explicit null arguments (`""` or `''`) are retained and passed to commands as empty strings. Unquoted implicit null arguments, resulting from the expansion of parameters that have no values, are removed. If a parameter with no value is expanded within double quotes, a null argument results and is retained and passed to a command as an empty string. When a quoted null argument appears as part of a word whose expansion is non-null, the null argument is removed. That is, the word `-d''` becomes `-d` after word splitting and null argument removal. 保留显式 null 参数（`""`或`'```-d`'` 在拆分单词后变`-d` 并作为空字符串传递给命令。 未加引号的隐式 null 参数，由 没有值的参数将被删除。 如果在双引号内展开没有值的参数，则 null 参数结果并保留 并作为空字符串传递给命令。 当带引号的 null 参数作为扩展为 non-null，则删除 null 参数。 也就是说，这个词 ，并且 null 参数删除。

Note that if no expansion occurs, no splitting is performed. 请注意，如果没有发生扩展，则不会进行拆分 执行。

___

#### 3.5.8 Filename Expansion3.5.8 文件名扩展

After word splitting, unless the \-f option has been set (see [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)), Bash scans each word for the characters ``\*``, `?`, and `\[`. If one of these characters appears, and is not quoted, then the word is regarded as a pattern, and replaced with an alphabetically sorted list of filenames matching the pattern (see [Pattern Matching](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)). If no matching filenames are found, and the shell option `nullglob` is disabled, the word is left unchanged. If the `nullglob` option is set, and no matches are found, the word is removed. If the `failglob` shell option is set, and no matches are found, an error message is printed and the command is not executed. If the shell option `nocaseglob` is enabled, the match is performed without regard to the case of alphabetic characters. 拆分单词后，除非设置了 \-f（参见 [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)`\*`、`?` 和 '\[被视为一种pattern与模式匹配的文件名（请参阅[模式匹配](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)并且 shell 选项 `nullglob`如果设置了 `nullglob`如果设置了 `failglob`如果启用了 shell 选项 `nocaseglob` 选项 ），Bash 会扫描每个单词的字符 '。 如果出现这些字符之一，并且没有引用，则该单词是 ， 并替换为按字母顺序排序的列表 ）。 如果未找到匹配的文件名， 被禁用，单词被留下 变。 选项，并且未找到匹配项，则单词 被删除。 shell 选项，但未找到匹配项， 打印错误消息，但未执行命令。 ，则执行匹配 不考虑字母字符的情况。

When a pattern is used for filename expansion, the character `.` at the start of a filename or immediately following a slash must be matched explicitly, unless the shell option `dotglob` is set. In order to match the filenames `.` and `..`, the pattern must begin with `.` (for example, `.?`), even if `dotglob` is set. If the `globskipdots` shell option is enabled, the filenames `.` and `..` are never matched, even if the pattern begins with a `.`. When not matching filenames, the `.` character is not treated specially. 当模式用于文件名扩展时，字符“.必须显式匹配，除非设置了 shell 选项 `dotglob`为了匹配文件名"."和“..模式必须以"."开头（例如，“.?即使设置`dotglob`如果启用了 `globskipdots`'.`和 `..带有“.当文件名不匹配时，"." 在文件名的开头或紧跟在斜杠之后 。 ”， ）， 。 shell 选项，则文件名 ' 永远不会匹配，即使模式开始 ”。 ”字符不会受到特殊处理。

When matching a filename, the slash character must always be matched explicitly by a slash in the pattern, but in other matching contexts it can be matched by a special pattern character as described below (see [Pattern Matching](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)). 下面（请参阅[模式匹配](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)匹配文件名时，斜杠字符必须始终为 在模式中用斜杠显式匹配，但在其他匹配中 上下文 它可以通过描述的特殊模式字符进行匹配 ）。

See the description of `shopt` in [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin), for a description of the `nocaseglob`, `nullglob`, `globskipdots`, `failglob`, and `dotglob` options. 请参阅 [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin) 中`shopt`对于 `nocaseglob`、`nullglob``globskipdots``failglob` 和 `dotglob` 的描述， 、 ， 选项。

The `GLOBIGNORE` shell variable may be used to restrict the set of file names matching a pattern. If `GLOBIGNORE` is set, each matching file name that also matches one of the patterns in `GLOBIGNORE` is removed from the list of matches. If the `nocaseglob` option is set, the matching against the patterns in `GLOBIGNORE` is performed without regard to case. The filenames . and .. are always ignored when `GLOBIGNORE` is set and not null. However, setting `GLOBIGNORE` to a non-null value has the effect of enabling the `dotglob` shell option, so all other filenames beginning with a `.` will match. To get the old behavior of ignoring filenames beginning with a `.`, make `.\*` one of the patterns in `GLOBIGNORE`. The `dotglob` option is disabled when `GLOBIGNORE` is unset. `GLOBIGNORE`模式。 如果 `GLOBIGNORE``GLOBIGNORE`如果设置了 `nocaseglob``GLOBIGNORE`.和 ..`GLOBIGNORE`但是，将 `GLOBIGNORE`启用 `dotglob``.`.`，使 `.\*' 成为 `GLOBIGNORE``GLOBIGNORE` 时禁用 `dotglob`公司 shell 变量可用于限制与 ，则每个匹配的文件名也匹配 将从匹配项列表中删除。 选项，则与 的执行不考虑大小写。 文件名 时，总是被忽略 设置为 AT 且不为 null。 设置为非 null 值的效果为 shell 选项，因此所有其他文件名都以 '将匹配。 获取忽略以 中的模式之一。 选项 未设置。

-   [Pattern Matching模式匹配](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)

___

#### 3.5.8.1 Pattern Matching 模式匹配

Any character that appears in a pattern, other than the special pattern characters described below, matches itself. The <small>NUL</small> character may not occur in a pattern. A backslash escapes the following character; the escaping backslash is discarded when matching. The special pattern characters must be quoted if they are to be matched literally. <small>NUL</small>出现在图案中的任何字符，而不是特殊图案 下面描述的字符，与自身匹配。 字符可能不会出现在模式中。 反斜杠转义以下字符;这 匹配时，转义反斜杠将被丢弃。 如果要匹配特殊图案字符，则必须引用它们 按照字面。

The special pattern characters have the following meanings: 特殊图案字符具有以下含义：

`*`

Matches any string, including the null string. When the `globstar` shell option is enabled, and ``\*`` is used in a filename expansion context, two adjacent ``\*``s used as a single pattern will match all files and zero or more directories and subdirectories. If followed by a `/`, two adjacent ``\*``s will match only directories and subdirectories. 当启用 `globstar` shell 选项时，并且文件名扩展上下文，两个相邻的“\*如果后跟 `/`，则两个相邻的 '\*匹配任何字符串，包括 null 字符串。 ”用作单个 pattern 将匹配所有文件和零个或多个目录，并且 子。 ' 将仅匹配 目录和子目录。

`?`

Matches any single character. 匹配任何单个字符。

`[…]`

Matches any one of the enclosed characters. A pair of characters separated by a hyphen denotes a range expression; any character that falls between those two characters, inclusive, using the current locale’s collating sequence and character set, is matched. If the first character following the `\[` is a `!` or a `^` then any character not enclosed is matched. A `\-` may be matched by including it as the first or last character in the set. A `\]` may be matched by including it as the first character in the set. The sorting order of characters in range expressions, and the characters included in the range, are determined by the current locale and the values of the `LC_COLLATE` and `LC_ALL` shell variables, if set. 用连字符分隔表示range expression`\[` 是 `!` 或“^然后匹配任何未括起来的字符。 一个“\-在集合中。 “\]`LC_COLLATE` 和 `LC_ALL`匹配任何一个括起来的字符。 一对角色 式; 介于这两个字符之间的任何字符，包括 使用当前区域设置的排序顺序和字符集， 匹配。 如果 ” ” 可以通过将其作为第一个或最后一个字符来匹配 ”可以通过将其作为第一个来匹配 集合中的角色。 范围表达式中字符的排序顺序， 以及范围中包含的字符， 由下式决定 当前区域设置和 shell 变量（如果已设置）。

For example, in the default C locale, '\[a-dx-z\]' is equivalent to '\[abcdxyz\]'. Many locales sort characters in dictionary order, and in these locales '\[a-dx-z\]' is typically not equivalent to '\[abcdxyz\]'; it might be equivalent to ‘\[aBbCcDdxYyZz\]’, for example. To obtain the traditional interpretation of ranges in bracket expressions, you can force the use of the C locale by setting the `LC_COLLATE` or `LC_ALL` environment variable to the value `C`, or enable the `globasciiranges` shell option. 例如，在默认的 C 语言环境中，“\[a-dx-z\]'\[abcdxyz\]这些区域设置“\[a-dx-z\]”通常不等同于“\[\[abcdxyz\]例如，它可能等同于“\[\[aBbCcDdxYyZz\]通过设置 `LC_COLLATE``LC_ALL`环境变量设置为值 'C`globasciiranges`”等效于 '。 许多区域设置按字典顺序对字符进行排序，并且在 ”; ”。 要获取 括号表达式中范围的传统解释，可以 或 '，或启用 壳选项。

Within `\[` and `\]`, _character classes_ can be specified using the syntax `[:`class`:]`, where class is one of the following classes defined in the <small>POSIX</small> standard: 在\[和"\]"中，可以指定_字符类_`[:`class`:]`，其中 class<small>POSIX</small> 使用语法 是 标准中定义的以下类：

```
alnum   alpha   ascii   blank   cntrl   digit   graph   lower
print   punct   space   upper   word    xdigit
```

A character class matches any character belonging to that class. The `word` character class matches letters, digits, and the character `\_`. `word`'\_字符类与属于该类的任何字符匹配。 字符类匹配字母、数字和字符 '。

Within `\[` and `\]`, an _equivalence class_ can be specified using the syntax `[=`c`=]`, which matches all characters with the same collation weight (as defined by the current locale) as the character c. 在 `\[` 和 `\]` 中，_等价类_使用语法 `[=`c`=]`按当前区域设置）作为字符 c可以是 指定，其中 匹配具有相同排序规则权重（如定义）的所有字符 。

Within `\[` and `\]`, the syntax `[.`symbol`.]` matches the collating symbol symbol. 在 `\[` 和 \]' 中，语法 `[.`symbol`.]`与归类符号符号symbol

If the `extglob` shell option is enabled using the `shopt` builtin, the shell recognizes several extended pattern matching operators. In the following description, a pattern-list is a list of one or more patterns separated by a `|`. When matching filenames, the `dotglob` shell option determines the set of filenames that are tested, as described above. Composite patterns may be formed using one or more of the following sub-patterns: 如果使用 `shopt` 启用`extglob`在下面的描述中，pattern-list或以“|匹配文件名时，`dotglob` shell 选项 Shell 内置，可识别多个扩展模式匹配运算符。 是一个列表 ”分隔的多个模式。 shell 选项确定 测试的文件名集，如上所述。 可以使用以下一种或多种方式形成复合图案 子模式：

`?(pattern-list)`?（pattern-list）

Matches zero or one occurrence of the given patterns. 匹配给定模式的零次或一次匹配。

`*(pattern-list)`\*（pattern-list）

Matches zero or more occurrences of the given patterns. 匹配给定模式的零次或多次匹配项。

`+(pattern-list)`+（pattern-list）

Matches one or more occurrences of the given patterns. 匹配给定模式的一个或多个匹配项。

`@(pattern-list)`

Matches one of the given patterns. 匹配给定模式之一。

`!(pattern-list)`!（pattern-list）

Matches anything except one of the given patterns. 匹配除给定模式之一之外的任何内容。

The `extglob` option changes the behavior of the parser, since the parentheses are normally treated as operators with syntactic meaning. To ensure that extended matching patterns are parsed correctly, make sure that `extglob` is enabled before parsing constructs containing the patterns, including shell functions and command substitutions. `extglob`在 选项会更改解析器的行为，因为 括号通常被视为具有句法意义的运算符。 若要确保正确分析扩展匹配模式，请确保 解析包含 模式，包括 shell 函数和命令替换。

When matching filenames, the `dotglob` shell option determines the set of filenames that are tested: when `dotglob` is enabled, the set of filenames includes all files beginning with `.`, but the filenames `.` and `..` must be matched by a pattern or sub-pattern that begins with a dot; when it is disabled, the set does not include any filenames beginning with "." unless the pattern or sub-pattern begins with a `.`. As above, `.` only has a special meaning when matching filenames. 匹配文件名时，`dotglob`启用 `dotglob`以“.`.`并且 ..或子模式以“.如上所述，“. shell 选项确定 测试的文件名集： 后，文件名集将包括所有文件 ”开头，但文件名 ' 必须与 以点开头的图案或子图案; 当它被禁用时，该集不会 包括任何以"."开头的文件名，除非模式 ”开头。 ”仅在匹配文件名时才具有特殊含义。

Complicated extended pattern matching against long strings is slow, especially when the patterns contain alternations and the strings contain multiple matches. Using separate matches against shorter strings, or using arrays of strings instead of a single long string, may be faster. 针对长字符串的复杂扩展模式匹配速度很慢， 尤其是当模式包含交替和字符串时 包含多个匹配项。 对较短的字符串使用单独的匹配项，或使用 字符串而不是单个长字符串，可能会更快。

___

#### 3.5.9 Quote Removal 引用删除

After the preceding expansions, all unquoted occurrences of the characters `\\`, `‘`, and `"` that did not result from one of the above expansions are removed. 字符 `\\`、'' 和 "在前面的扩展之后，所有未加引号的 ' 没有 上述扩展之一的结果将被删除。

___

### 3.6 Redirections 重定向

Before a command is executed, its input and output may be _redirected_ using a special notation interpreted by the shell. _Redirection_ allows commands’ file handles to be duplicated, opened, closed, made to refer to different files, and can change the files the command reads from and writes to. Redirection may also be used to modify file handles in the current shell execution environment. The following redirection operators may precede or appear anywhere within a simple command or may follow a command. Redirections are processed in the order they appear, from left to right. 可能会被_重定向__重定向_在执行命令之前，其输入和输出 使用由 shell 解释的特殊符号。 允许命令的文件句柄为 复制、打开、关闭、 用于引用不同的文件， 并且可以更改命令读取和写入的文件。 重定向还可用于修改 当前 shell 执行环境。 以下重定向 运算符可能位于或出现在 简单的命令或可以遵循命令。 重定向按其出现的顺序进行处理，从 从左到右。

Each redirection that may be preceded by a file descriptor number may instead be preceded by a word of the form {varname}. In this case, for each redirection operator except >&- and <&-, the shell will allocate a file descriptor greater than 10 and assign it to {varname}. If >&- or <&- is preceded by {varname}, the value of varname defines the file descriptor to close. If {varname} is supplied, the redirection persists beyond the scope of the command, allowing the shell programmer to manage the file descriptor’s lifetime manually. The `varredir_close` shell option manages this behavior (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)). 可以改为前面有一个 {varname\>&- 和 <&-，shell 将分配一个大于 10 的文件描述符并将其分配给 {varname}。 如果 >&- 或 <&- 前面有 {varname}，varname如果提供了 {varname`varredir_close`（参见 [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)每个重定向前面可能有一个文件描述符编号 } 形式的单词。 在这种情况下，对于每个重定向运算符，除了 的值定义文件 要关闭的描述符。 }，则重定向将持续存在 命令的作用域，允许 shell 程序员管理 手动文件描述符的生存期。 shell 选项管理此行为 ）。

In the following descriptions, if the file descriptor number is omitted, and the first character of the redirection operator is `<`, the redirection refers to the standard input (file descriptor 0). If the first character of the redirection operator is `\>`, the redirection refers to the standard output (file descriptor 1). '<为“\>在以下说明中，如果文件描述符编号为 省略，重定向运算符的第一个字符为 '，重定向是指标准输入（文件 描述符 0）。 如果重定向运算符的第一个字符 ”，重定向是指标准输出（文件 描述符 1）。

The word following the redirection operator in the following descriptions, unless otherwise noted, is subjected to brace expansion, tilde expansion, parameter expansion, command substitution, arithmetic expansion, quote removal, filename expansion, and word splitting. If it expands to more than one word, Bash reports an error. 以下重定向运算符后面的单词 除非另有说明，否则描述会受到大括号扩展的影响， 波浪号展开、参数扩展、命令替换、算术 扩展、删除引号、文件名扩展和拆分单词。 如果它扩展到多个单词，Bash 会报告错误。

Note that the order of redirections is significant. For example, the command 请注意，重定向的顺序很重要。 例如 命令

directs both standard output (file descriptor 1) and standard error (file descriptor 2) to the file dirlist, while the command （文件描述符 2）添加到文件dirlist指示标准输出（文件描述符 1）和标准错误 ，而命令

directs only the standard output to file dirlist, because the standard error was made a copy of the standard output before the standard output was redirected to dirlist. 仅将标准输出定向到文件dirlist在标准输出重定向到 dirlist 因为标准错误是标准输出的副本 之前。

Bash handles several filenames specially when they are used in redirections, as described in the following table. If the operating system on which Bash is running provides these special files, bash will use them; otherwise it will emulate them internally with the behavior described below. Bash 专门处理多个文件名，当它们在 重定向，如下表所述。 如果运行 Bash 的操作系统提供以下 特殊文件，bash 会使用它们;否则它会模仿它们 内部具有下述行为。

`/dev/fd/fd`/dev/fd/fd

If fd is a valid integer, file descriptor fd is duplicated. 如果 fd 是有效的整数，则文件描述符 fd 是重复的。

`/dev/stdin`

File descriptor 0 is duplicated. 文件描述符 0 重复。

`/dev/stdout`

File descriptor 1 is duplicated. 文件描述符 1 重复。

`/dev/stderr`

File descriptor 2 is duplicated. 文件描述符 2 重复。

`/dev/tcp/host/port`/dev/tcp/host/port

If host is a valid hostname or Internet address, and port is an integer port number or service name, Bash attempts to open the corresponding TCP socket. 如果 host 是有效的主机名或 Internet 地址，以及port 是一个整数端口号或服务名称，Bash 尝试打开 相应的 TCP 套接字。

`/dev/udp/host/port`/dev/udp/host/port

If host is a valid hostname or Internet address, and port is an integer port number or service name, Bash attempts to open the corresponding UDP socket. 如果 host 是有效的主机名或 Internet 地址，以及port 是一个整数端口号或服务名称，Bash 尝试打开 相应的 UDP 套接字。

A failure to open or create a file causes the redirection to fail. 无法打开或创建文件会导致重定向失败。

Redirections using file descriptors greater than 9 should be used with care, as they may conflict with file descriptors the shell uses internally. 使用大于 9 的文件描述符的重定向应与 小心，因为它们可能与 shell 使用的文件描述符冲突 内部。

-   [Redirecting Input重定向输入](https://www.gnu.org/software/bash/manual/bash.html#Redirecting-Input)
-   [Redirecting Output重定向输出](https://www.gnu.org/software/bash/manual/bash.html#Redirecting-Output)
-   [Appending Redirected Output追加重定向的输出](https://www.gnu.org/software/bash/manual/bash.html#Appending-Redirected-Output)
-   [Redirecting Standard Output and Standard Error重定向标准输出和标准错误](https://www.gnu.org/software/bash/manual/bash.html#Redirecting-Standard-Output-and-Standard-Error)
-   [Appending Standard Output and Standard Error附加标准输出和标准误差](https://www.gnu.org/software/bash/manual/bash.html#Appending-Standard-Output-and-Standard-Error)
-   [Here Documents这里文件](https://www.gnu.org/software/bash/manual/bash.html#Here-Documents)
-   [Here Strings这里字符串](https://www.gnu.org/software/bash/manual/bash.html#Here-Strings)
-   [Duplicating File Descriptors复制文件描述符](https://www.gnu.org/software/bash/manual/bash.html#Duplicating-File-Descriptors)
-   [Moving File Descriptors移动文件描述符](https://www.gnu.org/software/bash/manual/bash.html#Moving-File-Descriptors)
-   [Opening File Descriptors for Reading and Writing打开文件描述符进行读取和写入](https://www.gnu.org/software/bash/manual/bash.html#Opening-File-Descriptors-for-Reading-and-Writing)

#### 3.6.1 Redirecting Input 重定向输入

Redirection of input causes the file whose name results from the expansion of word to be opened for reading on file descriptor `n`, or the standard input (file descriptor 0) if `n` is not specified. word在文件描述符 `n`或标准输入（文件描述符 0），如果 `n`输入的重定向会导致其名称生成的文件 的扩展 上打开以供读取， 未指定。

The general format for redirecting input is: 重定向输入的一般格式为：

#### 3.6.2 Redirecting Output 重定向输出

Redirection of output causes the file whose name results from the expansion of word to be opened for writing on file descriptor n, or the standard output (file descriptor 1) if n is not specified. If the file does not exist it is created; if it does exist it is truncated to zero size. word在文件描述符 n或标准输出（文件描述符 1），如果 n输出重定向会导致其名称生成的文件 的扩展 上打开以进行写入， 未指定。 如果文件不存在，则创建该文件; 如果它确实存在，它将被截断为零大小。

The general format for redirecting output is: 重定向输出的一般格式为：

If the redirection operator is `\>`, and the `noclobber` option to the `set` builtin has been enabled, the redirection will fail if the file whose name results from the expansion of word exists and is a regular file. If the redirection operator is `\>|`, or the redirection operator is `\>` and the `noclobber` option is not enabled, the redirection is attempted even if the file named by word exists. 如果重定向运算符为"\>"，并且 `noclobber`选项已启用`set`word如果重定向运算符为“\>|"\>"并且未启用 `noclobber`即使存在以 word 内置，重定向 如果其名称因扩展而产生的文件将失败 存在，并且是常规文件。 ”，或者重定向运算符为 选项，重定向 命名的文件，也会尝试这样做。

#### 3.6.3 Appending Redirected Output 追加重定向输出

Redirection of output in this fashion causes the file whose name results from the expansion of word to be opened for appending on file descriptor n, or the standard output (file descriptor 1) if n is not specified. If the file does not exist it is created. word要打开以追加在文件描述符 n或标准输出（文件描述符 1），如果 n以这种方式重定向输出 导致其名称生成的文件 的扩展 上， 未指定。 如果文件不存在，则创建该文件。

The general format for appending output is: 追加输出的一般格式为：

#### 3.6.4 Redirecting Standard Output and Standard Error 重定向标准输出和标准错误

This construct allows both the standard output (file descriptor 1) and the standard error output (file descriptor 2) to be redirected to the file whose name is the expansion of word. word此结构允许 标准输出（文件描述符 1）和 标准错误输出（文件描述符 2） 重定向到其名称为 的扩展。

There are two formats for redirecting standard output and standard error: 有两种格式用于重定向标准输出和 标准误差：

and 和

Of the two forms, the first is preferred. This is semantically equivalent to 在这两种形式中，第一种是优选的。 这在语义上等价于

When using the second form, word may not expand to a number or `\-`. If it does, other redirection operators apply (see Duplicating File Descriptors below) for compatibility reasons. 使用第二种形式时，word'\-可能不会扩展为数字或 '。 如果是这样，则应用其他重定向运算符 （请参阅下面的复制文件描述符）出于兼容性原因。

#### 3.6.5 Appending Standard Output and Standard Error3.6.5 附加标准输出和标准误差

This construct allows both the standard output (file descriptor 1) and the standard error output (file descriptor 2) to be appended to the file whose name is the expansion of word. word此结构允许 标准输出（文件描述符 1）和 标准错误输出（文件描述符 2） 追加到其名称为 的扩展。

The format for appending standard output and standard error is: 附加标准输出和标准误差的格式为：

This is semantically equivalent to 这在语义上等价于

(see Duplicating File Descriptors below). （请参阅下面的复制文件描述符）。

#### 3.6.6 Here Documents

This type of redirection instructs the shell to read input from the current source until a line containing only word (with no trailing blanks) is seen. All of the lines read up to that point are then used as the standard input (or file descriptor n if n is specified) for a command. 当前源直到仅包含word输入（如果指定n，则为文件描述符 n这种类型的重定向指示 shell 从 的行 （没有尾随空白）被看到。 所有 然后，读取到该点的行将用作标准 ）。

The format of here-documents is: here-documents 的格式为：

```
[n]&lt;&lt;[-]word
        here-document
delimiter
```

No parameter and variable expansion, command substitution, arithmetic expansion, or filename expansion is performed on word. If any part of word is quoted, the delimiter is the result of quote removal on word, and the lines in the here-document are not expanded. If word is unquoted, all lines of the here-document are subjected to parameter expansion, command substitution, and arithmetic expansion, the character sequence `\newline` is ignored, and `\\` must be used to quote the characters `\\`, `$`, and `\``. word。 如果worddelimiter是 word如果word字符序列 `\newline` 将被忽略，并且 `\\`\\`、$` 和 '\`无参数和变量扩展，命令替换， 算术扩展或文件名扩展在 的任何部分， 上删除引号的结果， 并且 here-document 中的行未展开。 未加引号， here-document 的所有行都受制于 参数扩展、命令替换和算术扩展， ' 必须用于引用字符 '。

If the redirection operator is `<<-`, then all leading tab characters are stripped from input lines and the line containing delimiter. This allows here-documents within shell scripts to be indented in a natural fashion. 如果重定向运算符为“<<-包含delimiter”， 然后从输入行中剥离所有前导制表符，并且 的行。 这允许 shell 脚本中的 here-documents 缩进 自然时尚。

#### 3.6.7 Here Strings

A variant of here documents, the format is:

The word undergoes tilde expansion, parameter and variable expansion, command substitution, arithmetic expansion, and quote removal. Filename expansion and word splitting are not performed. The result is supplied as a single string, with a newline appended, to the command on its standard input (or file descriptor n if n is specified). word标准输入（如果指定了 n，则为文件描述符 n经历了 波浪展开、参数和变量展开， 命令替换、算术扩展和引号删除。 不执行文件名扩展和单词拆分。 结果以单个字符串的形式提供， 附加换行符， 到其 ）。

#### 3.6.8 Duplicating File Descriptors

The redirection operator 重定向运算符

is used to duplicate input file descriptors. If word expands to one or more digits, the file descriptor denoted by n is made to be a copy of that file descriptor. If the digits in word do not specify a file descriptor open for input, a redirection error occurs. If word evaluates to `\-`, file descriptor n is closed. If n is not specified, the standard input (file descriptor 0) is used. 如果word扩展为一个或多个数字，文件描述符由 n如果 word如果word计算结果为 \-'，则文件描述符 n如果未指定 n用于复制输入文件描述符。 表示 是该文件描述符的副本。 中的数字未指定打开的文件描述符 输入时，发生重定向错误。 已关闭。 ，则使用标准输入（文件描述符 0）。

The operator 运算符

is used similarly to duplicate output file descriptors. If n is not specified, the standard output (file descriptor 1) is used. If the digits in word do not specify a file descriptor open for output, a redirection error occurs. If word evaluates to `\-`, file descriptor n is closed. As a special case, if n is omitted, and word does not expand to one or more digits or `\-`, the standard output and standard error are redirected as described previously. 未指定 n如果 word如果word计算结果为 \-'，则文件描述符 n作为特例，如果省略n，而word展开为一个或多个数字或“\-用于复制输出文件描述符。 如果 ，则使用标准输出（文件描述符 1）。 中的数字未指定打开的文件描述符 输出时，发生重定向错误。 已关闭。 没有 ”，标准输出和标准 错误被重定向，如前所述。

#### 3.6.9 Moving File Descriptors

The redirection operator 重定向运算符

moves the file descriptor digit to file descriptor n, or the standard input (file descriptor 0) if n is not specified. digit is closed after being duplicated to n. 将文件描述符digit移动到文件描述符 n或标准输入（文件描述符 0），如果未指定 ndigit在复制到 n， 。 后关闭。

Similarly, the redirection operator 同样，重定向运算符

moves the file descriptor digit to file descriptor n, or the standard output (file descriptor 1) if n is not specified. 将文件描述符digit移动到文件描述符 n或标准输出（文件描述符 1，如果未指定 n， ）。

#### 3.6.10 Opening File Descriptors for Reading and Writing3.6.10 打开文件描述符进行读取和写入

The redirection operator 重定向运算符

causes the file whose name is the expansion of word to be opened for both reading and writing on file descriptor n, or on file descriptor 0 if n is not specified. If the file does not exist, it is created. 导致文件名称为 wordn 或文件描述符 0 如果 n 的扩展 打开以在文件描述符上读取和写入 未指定。 如果文件不存在，则创建该文件。

___

### 3.7 Executing Commands

-   [Simple Command Expansion简单的命令扩展](https://www.gnu.org/software/bash/manual/bash.html#Simple-Command-Expansion)
-   [Command Search and Execution命令搜索和执行](https://www.gnu.org/software/bash/manual/bash.html#Command-Search-and-Execution)
-   [Command Execution Environment命令执行环境](https://www.gnu.org/software/bash/manual/bash.html#Command-Execution-Environment)
-   [Environment环境](https://www.gnu.org/software/bash/manual/bash.html#Environment)
-   [Exit Status退出状态](https://www.gnu.org/software/bash/manual/bash.html#Exit-Status)
-   [Signals信号](https://www.gnu.org/software/bash/manual/bash.html#Signals)

___

#### 3.7.1 Simple Command Expansion

When a simple command is executed, the shell performs the following expansions, assignments, and redirections, from left to right, in the following order. 执行简单命令时，shell 将执行以下操作 展开、分配和重定向，从左到右，在 按以下顺序。

1.  The words that the parser has marked as variable assignments (those preceding the command name) and redirections are saved for later processing. 解析器标记为变量赋值的单词（那些 在命令名称之前）和重定向被保存以备后用 加工。
2.  The words that are not variable assignments or redirections are expanded (see [Shell Expansions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Expansions)). If any words remain after expansion, the first word is taken to be the name of the command and the remaining words are the arguments.
3.  Redirections are performed as described above (see [Redirections](https://www.gnu.org/software/bash/manual/bash.html#Redirections)).
4.  The text after the `=` in each variable assignment undergoes tilde expansion, parameter expansion, command substitution, arithmetic expansion, and quote removal before being assigned to the variable. 每个变量赋值中"="后面的文本都经过波浪号 展开、参数扩展、命令替换、算术扩展、 并在分配给变量之前删除引号。

If no command name results, the variable assignments affect the current shell environment. In the case of such a command (one that consists only of assignment statements and redirections), assignment statements are performed before redirections. Otherwise, the variables are added to the environment of the executed command and do not affect the current shell environment. If any of the assignments attempts to assign a value to a readonly variable, an error occurs, and the command exits with a non-zero status. 如果没有生成命令名称，则变量赋值会影响当前 shell 环境。 对于这样的命令（仅包含赋值的命令 语句和重定向），赋值语句在 重 定向。 否则，变量将添加到环境中 并且不会影响当前的 shell 环境。 如果任何赋值尝试将值赋给只读变量， 发生错误，命令以非零状态退出。

If no command name results, redirections are performed, but do not affect the current shell environment. A redirection error causes the command to exit with a non-zero status. 如果没有结果命令名称，则执行重定向，但不执行 影响当前 shell 环境。 重定向错误会导致 命令以非零状态退出。

If there is a command name left after expansion, execution proceeds as described below. Otherwise, the command exits. If one of the expansions contained a command substitution, the exit status of the command is the exit status of the last command substitution performed. If there were no command substitutions, the command exits with a status of zero. 如果扩展后还剩下命令名称，则执行为 如下所述。 否则，该命令将退出。 如果其中一个扩展 包含命令替换，命令的退出状态为 上次执行的命令替换的退出状态。 如果有 如果没有命令替换，则命令退出，状态为零。

___

#### 3.7.2 Command Search and Execution

After a command has been split into words, if it results in a simple command and an optional list of arguments, the following actions are taken. 将命令拆分为单词后，如果它导致 简单命令和可选的参数列表，如下所示 采取行动。

1.  If the command name contains no slashes, the shell attempts to locate it. If there exists a shell function by that name, that function is invoked as described in [Shell Functions](https://www.gnu.org/software/bash/manual/bash.html#Shell-Functions). 函数按照 [Shell 函数](https://www.gnu.org/software/bash/manual/bash.html#Shell-Functions)如果命令名称不包含斜杠，则 shell 会尝试执行 找到它。 如果存在该名称的 shell 函数，则 中所述进行调用。
2.  If the name does not match a function, the shell searches for it in the list of shell builtins. If a match is found, that builtin is invoked. 如果名称与函数不匹配，shell 将搜索 它在 shell 内置列表中。 如果找到匹配项，则 内置。
3.  If the name is neither a shell function nor a builtin, and contains no slashes, Bash searches each element of `$PATH` for a directory containing an executable file by that name. Bash uses a hash table to remember the full pathnames of executable files to avoid multiple `PATH` searches (see the description of `hash` in [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)). A full search of the directories in `$PATH` is performed only if the command is not found in the hash table. If the search is unsuccessful, the shell searches for a defined shell function named `command_not_found_handle`. If that function exists, it is invoked in a separate execution environment with the original command and the original command’s arguments as its arguments, and the function’s exit status becomes the exit status of that subshell. If that function is not defined, the shell prints an error message and returns an exit status of 127. `$PATH`可执行文件的路径名，以避免多次 `PATH`（请参阅 [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins) 中`hash`完整搜索 `$PATH`名为 `command_not_found_handle`如果名称既不是 shell 函数也不是内置函数， 并且不包含斜杠，Bash 搜索 包含可执行文件的目录 以这个名字。 Bash 使用哈希表来记住完整的 搜索 的描述）。 中的目录 仅当在哈希表中找不到该命令时才执行。 如果搜索不成功，shell 将搜索定义的 shell 的函数。 如果该函数存在，则在单独的执行环境中调用该函数 使用原始命令和 原始命令的参数作为其参数，以及函数的 exit status 成为该子 shell 的退出状态。 如果未定义该函数，shell 将打印错误 消息并返回退出状态 127。
4.  If the search is successful, or if the command name contains one or more slashes, the shell executes the named program in a separate execution environment. Argument 0 is set to the name given, and the remaining arguments to the command are set to the arguments supplied, if any. 如果搜索成功，或者命令名称包含 一个或多个斜杠，shell 执行 单独的执行环境。 参数 0 设置为给定的名称，其余参数 将命令设置为提供的参数（如果有）。
5.  If this execution fails because the file is not in executable format, and the file is not a directory, it is assumed to be a _shell script_ and the shell executes it as described in [Shell Scripts](https://www.gnu.org/software/bash/manual/bash.html#Shell-Scripts). _shell 脚本_[Shell 脚本](https://www.gnu.org/software/bash/manual/bash.html#Shell-Scripts)如果此执行失败，因为文件不在可执行文件中 格式，并且文件不是目录，则假定它是一个 ，shell 执行它，如 。
6.  If the command was not begun asynchronously, the shell waits for the command to complete and collects its exit status. 如果命令未异步启动，则 shell 将等待 要完成并收集其退出状态的命令。

___

#### 3.7.3 Command Execution Environment

The shell has an _execution environment_, which consists of the following: shell 有一个_执行环境_，它由 以后：

-   open files inherited by the shell at invocation, as modified by redirections supplied to the `exec` builtin 提供给 `exec`打开 shell 在调用时继承的文件，修改者 内置的重定向
-   the current working directory as set by `cd`, `pushd`, or `popd`, or inherited by the shell at invocation `cd`、`pushd``popd` 或 ，或在调用时由 shell 继承
-   the file creation mode mask as set by `umask` or inherited from the shell’s parent `umask` 设置或继承的文件创建模式掩码 shell 的父级
-   current traps set by `trap`由`trap`设置的电流陷阱
-   shell parameters that are set by variable assignment or with `set` or inherited from the shell’s parent in the environment 通过变量赋值或`set`的 shell 参数 或从环境中的 shell 父级继承
-   shell functions defined during execution or inherited from the shell’s parent in the environment shell 函数在执行期间定义或继承自 shell 的 环境中的父级
-   options enabled at invocation (either by default or with command-line arguments) or by `set`参数）或`set`调用时启用的选项（默认情况下或通过命令行启用）
-   options enabled by `shopt` (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)) `shopt` 启用的选项（请参阅 [Shopt 内置）](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)
-   shell aliases defined with `alias` (see [Aliases](https://www.gnu.org/software/bash/manual/bash.html#Aliases)) 使用`alias` shell 别名（请参阅[别名](https://www.gnu.org/software/bash/manual/bash.html#Aliases)）
-   various process <small>ID</small>s, including those of background jobs (see [Lists of Commands](https://www.gnu.org/software/bash/manual/bash.html#Lists)), the value of `$$`, and the value of `$PPID`各种进程 ID，包括后台作业的<small>进程 ID</small>（请参阅[命令列表](https://www.gnu.org/software/bash/manual/bash.html#Lists)）、`$$``$PPID` 的值和

When a simple command other than a builtin or shell function is to be executed, it is invoked in a separate execution environment that consists of the following. Unless otherwise noted, the values are inherited from the shell. 当内置或 shell 函数以外的简单命令时 是要执行的，它 在单独的执行环境中调用，该环境包括 以下。 除非另有说明，否则这些值将被继承 从shell。

-   the shell’s open files, plus any modifications and additions specified by redirections to the command 命令行管理程序的打开文件，以及指定的任何修改和添加 通过重定向到命令
-   the current working directory 当前工作目录
-   the file creation mode mask 文件创建模式掩码
-   shell variables and functions marked for export, along with variables exported for the command, passed in the environment (see [Environment](https://www.gnu.org/software/bash/manual/bash.html#Environment)) 为命令导出，在环境中传递（请参阅[环境](https://www.gnu.org/software/bash/manual/bash.html#Environment)标记为导出的 shell 变量和函数，以及变量 ）
-   traps caught by the shell are reset to the values inherited from the shell’s parent, and traps ignored by the shell are ignored shell 捕获的陷阱将重置为继承自 shell 的父级，shell 忽略的陷阱将被忽略

A command invoked in this separate environment cannot affect the shell’s execution environment. 在此单独环境中调用的命令不会影响 shell 的执行环境。

A _subshell_ is a copy of the shell process. _子 shell_ 是 shell 进程的副本。

Command substitution, commands grouped with parentheses, and asynchronous commands are invoked in a subshell environment that is a duplicate of the shell environment, except that traps caught by the shell are reset to the values that the shell inherited from its parent at invocation. Builtin commands that are invoked as part of a pipeline are also executed in a subshell environment. Changes made to the subshell environment cannot affect the shell’s execution environment. 命令替换，用括号分组的命令， 并且异步命令在 subshell 环境，即 shell 环境的副本， 除了 shell 捕获的陷阱被重置为值 shell 在调用时继承自其父级。 内置 作为管道的一部分调用的命令也会被执行 在 subshell 环境中。 对 subshell 环境所做的更改 不能影响 shell 的执行环境。

Subshells spawned to execute command substitutions inherit the value of the \-e option from the parent shell. When not in <small>POSIX</small> mode, Bash clears the \-e option in such subshells. 父 shell 中的 \-e 选项。 当不在<small>POSIX</small>Bash 清除此类子 shell 中的 \-e为执行命令替换而生成的子 shell 继承了 模式下时， 选项。

If a command is followed by a `&` and job control is not active, the default standard input for the command is the empty file /dev/null. Otherwise, the invoked command inherits the file descriptors of the calling shell as modified by redirections. 如果命令后跟“&该命令的默认标准输入是空文件 /dev/null”，并且作业控件未处于活动状态，则 。 否则，调用的命令将继承调用的文件描述符 由重定向修改的 shell。

___

#### 3.7.4 Environment

When a program is invoked it is given an array of strings called the _environment_. This is a list of name-value pairs, of the form `name=value`. 称为_环境_这是名称-值对的列表，格式为 `name=value`当一个程序被调用时，它被赋予一个字符串数组 。 。

Bash provides several ways to manipulate the environment. On invocation, the shell scans its own environment and creates a parameter for each name found, automatically marking it for `export` to child processes. Executed commands inherit the environment. The `export` and 'declare -x' commands allow parameters and functions to be added to and deleted from the environment. If the value of a parameter in the environment is modified, the new value becomes part of the environment, replacing the old. The environment inherited by any executed command consists of the shell’s initial environment, whose values may be modified in the shell, less any pairs removed by the `unset` and 'export -n' commands, plus any additions via the `export` and 'declare -x' commands. 用于`export``export` 和 'declare -x减去`unset`和export -n命令，以及通过`export`'declare -xBash 提供了多种操作环境的方法。 调用时，shell 会扫描自己的环境，并 为找到的每个名称创建一个参数，自动标记 的 IT 到子进程。 执行的命令将继承环境。 ' 命令允许将参数和函数添加到 和 已从环境中删除。 如果参数的值 在环境中被修改，新值成为一部分 环境，取代旧环境。 环境 由任何执行的命令继承，由 shell 的 初始环境，其值可以在 shell 中修改， ”删除的任何对 和 ' 命令。

The environment for any simple command or function may be augmented temporarily by prefixing it with parameter assignments, as described in [Shell Parameters](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameters). These assignment statements affect only the environment seen by that command. 参数分配，如 [Shell 参数](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameters)任何简单命令的环境 或者可以通过在它前面加上 中所述。 这些赋值语句仅影响所看到的环境 通过该命令。

If the \-k option is set (see [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)), then all parameter assignments are placed in the environment for a command, not just those that precede the command name. 如果设置了 \-k 选项（请参阅 [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)），则全部 参数赋值放置在命令的环境中， 而不仅仅是命令名称前面的那些。

When Bash invokes an external command, the variable `$\_` is set to the full pathname of the command and passed to that command in its environment. 当 Bash 调用外部命令时，变量 `$\_` 设置为命令的完整路径名并传递给该命令 命令。

___

#### 3.7.5 Exit Status

The exit status of an executed command is the value returned by the `waitpid` system call or equivalent function. Exit statuses fall between 0 and 255, though, as explained below, the shell may use values above 125 specially. Exit statuses from shell builtins and compound commands are also limited to this range. Under certain circumstances, the shell will use special values to indicate specific failure modes. `waitpid`已执行命令的退出状态是 系统调用或等效函数。 退出状态 落在 0 到 255 之间，但如下所述，shell 可能 特别使用 125 以上的值。 从 shell 内置项和 复合命令也限制在此范围内。 在某些情况下 情况下，shell 会使用特殊值来指示特定 故障模式。

For the shell’s purposes, a command which exits with a zero exit status has succeeded. A non-zero exit status indicates failure. This seemingly counter-intuitive scheme is used so there is one well-defined way to indicate success and a variety of ways to indicate various failure modes. When a command terminates on a fatal signal whose number is N, Bash uses the value 128+N as the exit status. 当命令在编号NBash 使用值 128+N出于 shell 的目的，以 零退出状态已成功。 非零退出状态表示失败。 这种看似违反直觉的方案被用于 是一种明确定义的方式来表示成功和各种 指示各种故障模式的方法。 的致命信号上终止时， 作为退出状态。

If a command is not found, the child process created to execute it returns a status of 127. If a command is found but is not executable, the return status is 126. 如果未找到命令，则创建的子进程将 execute 它返回状态 127。 如果找到命令 但不可执行，返回状态为 126。

If a command fails because of an error during expansion or redirection, the exit status is greater than zero. 如果命令因扩展或重定向期间的错误而失败， 退出状态大于零。

The exit status is used by the Bash conditional commands (see [Conditional Constructs](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)) and some of the list constructs (see [Lists of Commands](https://www.gnu.org/software/bash/manual/bash.html#Lists)). （参见[条件结构](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)构造（请参阅[命令列表](https://www.gnu.org/software/bash/manual/bash.html#Lists)退出状态由 Bash 条件命令使用 ）和一些列表 ）。

All of the Bash builtins return an exit status of zero if they succeed and a non-zero status on failure, so they may be used by the conditional and list constructs. All builtins return an exit status of 2 to indicate incorrect usage, generally invalid options or missing arguments. 如果成功，所有 Bash 内置函数都会返回退出状态为零 以及失败时的非零状态，因此它们可以被 条件和列表构造。 所有内置函数都返回退出状态 2 以指示不正确的用法， 通常选项无效或缺少参数。

The exit status of the last command is available in the special parameter $? (see [Special Parameters](https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters)). 参数 $？（请参阅[特殊参数](https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters)最后一个命令的退出状态在特殊 ）。

___

#### 3.7.6 Signals

When Bash is interactive, in the absence of any traps, it ignores `SIGTERM` (so that 'kill 0' does not kill an interactive shell), and `SIGINT` is caught and handled (so that the `wait` builtin is interruptible). When Bash receives a `SIGINT`, it breaks out of any executing loops. In all cases, Bash ignores `SIGQUIT`. If job control is in effect (see [Job Control](https://www.gnu.org/software/bash/manual/bash.html#Job-Control)), Bash ignores `SIGTTIN`, `SIGTTOU`, and `SIGTSTP`. `SIGTERM`（因此“kill 0和 `SIGINT`被捕获和处理（以便内置`wait`当 Bash 收到 `SIGINT`在所有情况下，Bash 都会忽略 `SIGQUIT`如果作业控制有效（请参阅[作业控制](https://www.gnu.org/software/bash/manual/bash.html#Job-Control)忽略 `SIGTTIN``SIGTTOU` 和 `SIGTSTP`当 Bash 是交互式的时，在没有任何陷阱的情况下，它会忽略 ”不会杀死交互式 shell）， 是可中断的）。 时，它会中断任何执行循环。 ），则 Bash 。

Non-builtin commands started by Bash have signal handlers set to the values inherited by the shell from its parent. When job control is not in effect, asynchronous commands ignore `SIGINT` and `SIGQUIT` in addition to these inherited handlers. Commands run as a result of command substitution ignore the keyboard-generated job control signals `SIGTTIN`, `SIGTTOU`, and `SIGTSTP`.

The shell exits by default upon receipt of a `SIGHUP`. Before exiting, an interactive shell resends the `SIGHUP` to all jobs, running or stopped. Stopped jobs are sent `SIGCONT` to ensure that they receive the `SIGHUP`. To prevent the shell from sending the `SIGHUP` signal to a particular job, it should be removed from the jobs table with the `disown` builtin (see [Job Control Builtins](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Builtins)) or marked to not receive `SIGHUP` using `disown -h`. 默认情况下，shell 在收到 `SIGHUP`在退出之前，交互式 shell 会将 `SIGHUP`停止的作业被发送到 `SIGCONT``SIGHUP`防止 shell 将 `SIGHUP`从具有 `disown`builtin（请参阅 [Job Control Builtins](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Builtins)使用 `disown -h` 不接收 `SIGHUP` 时退出。 重新发送到 所有作业，正在运行或已停止。 以确保它们收到 声叹气。 信号发送到 特定的工作，它应该被删除 的 jobs 表中 ）或标记 。

If the `huponexit` shell option has been set with `shopt` (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)), Bash sends a `SIGHUP` to all jobs when an interactive login shell exits. 如果 `huponexit` shell 选项已使用 `shopt`（参见 [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)），Bash 在以下情况下向所有作业发送 `SIGHUP` 设置 交互式登录 shell 将退出。

If Bash is waiting for a command to complete and receives a signal for which a trap has been set, the trap will not be executed until the command completes. When Bash is waiting for an asynchronous command via the `wait` builtin, the reception of a signal for which a trap has been set will cause the `wait` builtin to return immediately with an exit status greater than 128, immediately after which the trap is executed. 命令通过内置`wait`设置陷阱`wait`如果 Bash 正在等待命令完成并接收到信号 已设置陷阱的，则在 命令完成。 当 Bash 等待异步时 ，接收到的信号为 返回 退出状态大于 128 时立即在 执行陷阱。

When job control is not enabled, and Bash is waiting for a foreground command to complete, the shell receives keyboard-generated signals such as `SIGINT` (usually generated by `^C`) that users commonly intend to send to that command. This happens because the shell and the command are in the same process group as the terminal, and `^C` sends `SIGINT` to all processes in that process group. See [Job Control](https://www.gnu.org/software/bash/manual/bash.html#Job-Control), for a more in-depth discussion of process groups.

When Bash is running without job control enabled and receives `SIGINT` while waiting for a foreground command, it waits until that foreground command terminates and then decides what to do about the `SIGINT`: 当 Bash 在未启用作业控制的情况下运行并接收 `SIGINT`命令终止，然后决定如何处理 `SIGINT` 时 在等待前台命令时，它会一直等到该前台 ：

1.  If the command terminates due to the `SIGINT`, Bash concludes that the user meant to end the entire script, and acts on the `SIGINT` (e.g., by running a `SIGINT` trap or exiting itself); 如果命令因 `SIGINT``SIGINT`（例如，通过运行 `SIGINT` 而终止，则 Bash 将得出结论 用户打算结束整个脚本，并对 陷阱或退出自身）;
2.  If the pipeline does not terminate due to `SIGINT`, the program handled the `SIGINT` itself and did not treat it as a fatal signal. In that case, Bash does not treat `SIGINT` as a fatal signal, either, instead assuming that the `SIGINT` was used as part of the program’s normal operation (e.g., `emacs` uses it to abort editing commands) or deliberately discarded. However, Bash will run any trap set on `SIGINT`, as it does with any other trapped signal it receives while it is waiting for the foreground command to complete, for compatibility. 如果管道未因 `SIGINT`处理了 `SIGINT`在这种情况下，Bash 不会将 `SIGINT`或者，而是假设 `SIGINT`程序的正常操作（例如，`emacs`在 `SIGINT` 而终止，则程序 本身，并没有将其视为致命信号。 视为致命信号， 被用作 使用它来中止编辑 命令）或故意丢弃。但是，Bash 将运行任何 上设置陷阱，就像它对任何其他被捕获信号所做的那样 在等待前台命令时接收到 完成，以实现兼容性。

___

### 3.8 Shell Scripts

A shell script is a text file containing shell commands. When such a file is used as the first non-option argument when invoking Bash, and neither the \-c nor \-s option is supplied (see [Invoking Bash](https://www.gnu.org/software/bash/manual/bash.html#Invoking-Bash)), Bash reads and executes commands from the file, then exits. This mode of operation creates a non-interactive shell. The shell first searches for the file in the current directory, and looks in the directories in `$PATH` if not found there. 并且 \-c 和 \-s（请参阅[调用 Bash](https://www.gnu.org/software/bash/manual/bash.html#Invoking-Bash)目录，如果在那里找不到，则在`$PATH`shell 脚本是包含 shell 命令的文本文件。 当这样的 调用 Bash 时，将文件用作第一个非选项参数， 选项均未提供 ）、 Bash 从文件中读取并执行命令，然后退出。 这 操作模式创建非交互式 shell。 首先是shell 在当前目录中搜索文件，并在 中。

When Bash runs a shell script, it sets the special parameter `0` to the name of the file, rather than the name of the shell, and the positional parameters are set to the remaining arguments, if any are given. If no additional arguments are supplied, the positional parameters are unset. 一个 shell 脚本，它将特殊参数 `0`当 Bash 运行时 设置为名称 的文件，而不是 shell 的名称，以及 参数设置为其余参数（如果给出任何参数）。 如果未提供其他参数，则位置参数 未设置。

A shell script may be made executable by using the `chmod` command to turn on the execute bit. When Bash finds such a file while searching the `$PATH` for a command, it creates a new instance of itself to execute it. In other words, executing 可以使用 `chmod`在`$PATH` 命令使 shell 脚本可执行 打开执行位。 当 Bash 找到这样的文件时 中搜索命令，它会创建一个 自身的新实例 来执行它。 换言之，执行

is equivalent to executing 等同于执行

if `filename` is an executable shell script. This subshell reinitializes itself, so that the effect is as if a new shell had been invoked to interpret the script, with the exception that the locations of commands remembered by the parent (see the description of `hash` in [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins)) are retained by the child. 如果 `filename`（参见 [Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Builtins) 中`hash` 是可执行的 shell 脚本。 此子 shell 会重新初始化自身，因此效果就好像 已调用 new shell 来解释脚本，其中 父级记住的命令的位置异常 的描述） 由孩子保留。

Most versions of Unix make this a part of the operating system’s command execution mechanism. If the first line of a script begins with the two characters `#!`, the remainder of the line specifies an interpreter for the program and, depending on the operating system, one or more optional arguments for that interpreter. Thus, you can specify Bash, `awk`, Perl, or some other interpreter and write the rest of the script file in that language. 两个字符 #!因此，您可以指定 Bash、`awk`大多数版本的 Unix 都将其作为操作系统命令的一部分 执行机制。 如果脚本的第一行以 '，该行的其余部分指定 程序的解释器，根据操作系统的不同，一个 或该解释器的更多可选参数。 、Perl 或其他一些 解释器，并用该语言编写脚本文件的其余部分。

The arguments to the interpreter consist of one or more optional arguments following the interpreter name on the first line of the script file, followed by the name of the script file, followed by the rest of the arguments supplied to the script. The details of how the interpreter line is split into an interpreter name and a set of arguments vary across systems. Bash will perform this action on operating systems that do not handle it themselves. Note that some older versions of Unix limit the interpreter name and a single argument to a maximum of 32 characters, so it’s not portable to assume that using more than one argument will work. 解释器的参数 由解释器后面的一个或多个可选参数组成 name 在脚本文件的第一行，后跟 name 脚本文件，后跟提供给 脚本。 如何将解释器行拆分为解释器名称的详细信息 一组参数因系统而异。 Bash 将在不处理此操作的操作系统上执行此操作 他们自己。 请注意，一些旧版本的 Unix 限制了解释器 name 和单个参数最多 32 个字符，所以它不是 可移植假定使用多个参数将起作用。

Bash scripts often begin with `#! /bin/bash` (assuming that Bash has been installed in /bin), since this ensures that Bash will be used to interpret the script, even if it is executed under another shell. It’s a common idiom to use `env` to find `bash` even if it’s been installed in another directory: `#!/usr/bin/env bash` will find the first occurrence of `bash` in `$PATH`. Bash 脚本通常以 `#! /bin/bash`Bash 已安装在 /bin在另一个shell下。使用 `env``bash``#!/usr/bin/env bash` 会找到 `bash`在`$PATH` 开头（假设 中，因为这可确保 Bash 将用于解释脚本，即使它被执行 查找是一个常见的成语 ，即使它已安装在另一个目录中： 的第一个出现 。
