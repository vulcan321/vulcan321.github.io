
## 7 Job Control7 作业控制

This chapter discusses what job control is, how it works, and how Bash allows you to access its facilities. 本章讨论什么是作业控制，它是如何工作的，以及如何 Bash 允许您访问其功能。

-   [Job Control Basics作业控制基础知识](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Basics)
-   [Job Control Builtins作业控制内置](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Builtins)
-   [Job Control Variables作业控制变量](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Variables)

___

### 7.1 Job Control Basics7.1 作业控制基础

Job control refers to the ability to selectively stop (suspend) the execution of processes and continue (resume) their execution at a later point. A user typically employs this facility via an interactive interface supplied jointly by the operating system kernel’s terminal driver and Bash. 作业控制 指选择性停止（暂停）的能力 流程的执行和继续（恢复） 他们在以后执行。 用户通常使用 该设施通过共同提供的交互式界面 由操作系统内核的终端驱动程序和 Bash 提供。

The shell associates a job with each pipeline. It keeps a table of currently executing jobs, which may be listed with the `jobs` command. When Bash starts a job asynchronously, it prints a line that looks like: shell 将job`jobs`与每个管道相关联。 它保持一个 当前正在执行的作业表，可以与 命令。 当 Bash 启动作业时 异步地，它打印一行看起来 喜欢：

indicating that this job is job number 1 and that the process <small>ID</small> of the last process in the pipeline associated with this job is 25647. All of the processes in a single pipeline are members of the same job. Bash uses the job abstraction as the basis for job control. 指示此作业是作业编号 1，并且进程 <small>ID</small>同样的工作。 Bash 使用job 与此作业关联的管道中的最后一个进程是 25647. 单个管道中的所有进程都是 抽象作为 工作控制的基础。

To facilitate the implementation of the user interface to job control, the operating system maintains the notion of a current terminal process group <small>ID</small>. Members of this process group (processes whose process group <small>ID</small> is equal to the current terminal process group <small>ID</small>) receive keyboard-generated signals such as `SIGINT`. These processes are said to be in the foreground. Background processes are those whose process group <small>ID</small> differs from the terminal’s; such processes are immune to keyboard-generated signals. Only foreground processes are allowed to read from or, if the user so specifies with `stty tostop`, write to the terminal. Background processes which attempt to read from (write to when `stty tostop` is in effect) the terminal are sent a `SIGTTIN` (`SIGTTOU`) signal by the kernel’s terminal driver, which, unless caught, suspends the process. 进程组 <small>ID。</small>进程组 <small>ID</small><small>ID</small>） 接收键盘生成的信号，例如 `SIGINT`进程是进程组 <small>ID</small>用户如此指定使用 `stty tostop`从（写入 `stty tostop`终端发送`SIGTTIN`（`SIGTTOU`为了便于实现作业的用户界面 控制，操作系统保持当前终端的概念 此进程组的成员（其进程 等于当前终端进程组 。 据说这些过程在前台。 背景 不同于 终端的;此类进程不受键盘生成的影响 信号。 只允许前台进程读取 or 如果 ，写入终端。 尝试 生效时）读取 ） 内核终端驱动程序发出的信号， 除非被抓到，否则会暂停该过程。

If the operating system on which Bash is running supports job control, Bash contains facilities to use it. Typing the _suspend_ character (typically ‘^Z’, Control-Z) while a process is running causes that process to be stopped and returns control to Bash. Typing the _delayed suspend_ character (typically ‘^Y’, Control-Y) causes the process to be stopped when it attempts to read input from the terminal, and control to be returned to Bash. The user then manipulates the state of this job, using the `bg` command to continue it in the background, the `fg` command to continue it in the foreground, or the `kill` command to kill it. A ‘^Z’ takes effect immediately, and has the additional side effect of causing pending output and typeahead to be discarded.

There are a number of ways to refer to a job in the shell. The character ‘%’ introduces a job specification (_jobspec_). 字符“%”引入了作业规范 （_jobspec_有多种方法可以引用 shell 中的作业。 这 ）。

Job number `n` may be referred to as ‘%n’. The symbols ‘%%’ and ‘%+’ refer to the shell’s notion of the current job, which is the last job stopped while it was in the foreground or started in the background. A single ‘%’ (with no accompanying job specification) also refers to the current job. The previous job may be referenced using ‘%-’. If there is only a single job, ‘%+’ and ‘%-’ can both be used to refer to that job. In output pertaining to jobs (e.g., the output of the `jobs` command), the current job is always flagged with a ‘+’, and the previous job with a ‘\-’. 作业编号 `n` 可以称为“%n符号 '%%' 和 '%+单个“%可以使用“%-如果只有一个作业，则可以同时使用 '%+' 和 '%-在与作业有关的输出中（例如，`jobs`命令），当前作业始终用“+以前的工作带有“\-”。 ' 指的是 shell 的 当前作业，这是在前台停止的最后一个作业 或在后台启动。 ”（没有随附的工作规范）也是指 到当前工作。 ”引用上一个作业。 ' 来指代该工作。 的输出 ”标记，并且 ”。

A job may also be referred to using a prefix of the name used to start it, or using a substring that appears in its command line. For example, ‘%ce’ refers to a stopped job whose command name begins with ‘ce’. Using ‘%?ce’, on the other hand, refers to any job containing the string ‘ce’ in its command line. If the prefix or substring matches more than one job, Bash reports an error. 出现在其命令行中。 例如，“%ce到命令名称以“ce使用 '%?ce另一方面，指任何包含字符串“ce也可以参考工作 使用用于启动它的名称的前缀，或使用子字符串 ”是指 ”开头的已停止作业。 '，在 ”的作业 它的命令行。 如果前缀或子字符串与多个作业匹配， Bash 报告错误。

Simply naming a job can be used to bring it into the foreground: ‘%1’ is a synonym for ‘fg %1’, bringing job 1 from the background into the foreground. Similarly, ‘%1 &’ resumes job 1 in the background, equivalent to ‘bg %1’ '%1' 是 'fg %1背景到前景。 同样，“%1 &作业 1 在后台，相当于“bg %1只需命名作业即可将其置于前台： ' 的同义词，将作业 1 从 ”恢复 ”

The shell learns immediately whenever a job changes state. Normally, Bash waits until it is about to print a prompt before reporting changes in a job’s status so as to not interrupt any other output. If the \-b option to the `set` builtin is enabled, Bash reports such changes immediately (see [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)). Any trap on `SIGCHLD` is executed for each child process that exits. 如果启用`set` builtin 的 \-bBash 会立即报告此类更改（请参阅 [The Set Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)`SIGCHLD`每当作业更改状态时，shell 都会立即学习。 通常，Bash 会等到即将打印提示时再进行 在报告作业状态更改之前，以免中断 任何其他输出。 选项， ）。 上的任何陷阱都会针对每个子进程执行 退出。

If an attempt to exit Bash is made while jobs are stopped, (or running, if the `checkjobs` option is enabled – see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)), the shell prints a warning message, and if the `checkjobs` option is enabled, lists the jobs and their statuses. The `jobs` command may then be used to inspect their status. If a second attempt to exit is made without an intervening command, Bash does not print another warning, and any stopped jobs are terminated. `checkjobs` 选项已启用 – 请参阅 [Shopt 内置），](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)shell 打印警告消息，如果 `checkjobs`然后，`jobs`如果在作业停止时尝试退出 Bash，（或正在运行，如果 然后 选项是 已启用，列出作业及其状态。 命令来检查其状态。 如果在没有干预命令的情况下第二次尝试退出， Bash 不会打印另一个警告，并且任何已停止的作业都将终止。

When the shell is waiting for a job or process using the `wait` builtin, and job control is enabled, `wait` will return when the job changes state. The \-f option causes `wait` to wait until the job or process terminates before returning. 当 shell 正在等待作业或进程时，使用 `wait`内置，并且启用了作业控制，`wait`作业更改状态。\-f 选项会导致`wait` 将在 等待 直到作业或进程终止，然后再返回。

___

### 7.2 Job Control Builtins7.2 作业控制内置

`bg`

Resume each suspended job jobspec in the background, as if it had been started with ‘&’. If jobspec is not supplied, the current job is used. The return status is zero unless it is run when job control is not enabled, or, when run with job control enabled, any jobspec was not found or specifies a job that was started without job control. 在后台恢复每个暂停的作业jobspec以“&如果未提供 jobspec未找到 jobspec，就好像它 ”开头。 ，则使用当前作业。 返回状态为零，除非在作业控制不运行时运行 enabled，或者，在启用作业控制的情况下运行时，任何 或指定作业 这是在没有工作控制的情况下开始的。

`fg`

Resume the job jobspec in the foreground and make it the current job. If jobspec is not supplied, the current job is used. The return status is that of the command placed into the foreground, or non-zero if run when job control is disabled or, when run with job control enabled, jobspec does not specify a valid job or jobspec specifies a job that was started without job control. 在前台恢复作业 jobspec如果未提供 jobspec启用作业控制，jobspecjobspec 并使其成为当前作业。 ，则使用当前作业。 返回状态是放置在前台的命令的状态， 或非零，如果在作业控制被禁用时运行，或者在运行时与 未指定有效作业或 指定在没有作业控制的情况下启动的作业。

`jobs`

```
jobs [-lnprs] [jobspec]
jobs -x command [arguments]
```

The first form lists the active jobs. The options have the following meanings: 第一个窗体列出了活动作业。 这些选项具有 含义如下：

`-l`

List process <small>ID</small>s in addition to the normal information. 除正常信息外，还列出进程 <small>ID</small>。

`-n`

Display information only about jobs that have changed status since the user was last notified of their status. 仅显示自此以来状态已更改的作业的信息 用户上次收到有关其状态的通知。

`-p`

List only the process <small>ID</small> of the job’s process group leader. 仅列出作业的进程组负责人的进程 <small>ID</small>。

`-r`

Display only running jobs. 仅显示正在运行的作业。

`-s`

Display only stopped jobs.

If jobspec is given, output is restricted to information about that job. If jobspec is not supplied, the status of all jobs is listed. 如果给出jobspec如果未提供 jobspec， 输出仅限于有关该作业的信息。 ，则所有作业的状态为 上市。

If the \-x option is supplied, `jobs` replaces any jobspec found in command or arguments with the corresponding process group <small>ID</small>, and executes command, passing it arguments, returning its exit status. 如果提供了 \-x 选项，`jobs`在command或arguments中找到的 jobspec对应的进程组 <small>ID，</small>并执行command传递argument 将替换任何 ， s，返回其退出状态。

`kill`

```
kill [-s sigspec] [-n signum] [-sigspec] jobspec or pid
kill -l|-L [exit_status]
```

Send a signal specified by sigspec or signum to the process named by job specification jobspec or process <small>ID</small> pid. sigspec is either a case-insensitive signal name such as `SIGINT` (with or without the `SIG` prefix) or a signal number; signum is a signal number. If sigspec and signum are not present, `SIGTERM` is used. The \-l option lists the signal names. If any arguments are supplied when \-l is given, the names of the signals corresponding to the arguments are listed, and the return status is zero. exit\_status is a number specifying a signal number or the exit status of a process terminated by a signal. The \-L option is equivalent to \-l. The return status is zero if at least one signal was successfully sent, or non-zero if an error occurs or an invalid option is encountered. 向进程发送 sigspec 或 signum由作业规范 jobspec 或进程 <small>ID</small>pidsigspec`SIGINT`（带或不带 `SIG`或信号编号;signum如果 sigspec 和 signum 不存在，则使用 `SIGTERM`\-l如果在给定 \-lexit\_status\-L 选项等效于 \-l 指定的信号 命名。 是不区分大小写的信号名称，例如 前缀） 是一个信号数字。 。 选项列出信号名称。 时提供了任何参数，则 列出与参数对应的信号，并返回状态 为零。 是一个数字，指定信号编号或出口 由信号终止的进程的状态。 。 如果至少成功发送了一个信号，则返回状态为零， 如果发生错误或遇到无效选项，则为非零。

`wait`

```
wait [-fn] [-p varname] [jobspec or pid …]
```

Wait until the child process specified by each process <small>ID</small> pid or job specification jobspec exits and return the exit status of the last command waited for. If a job spec is given, all processes in the job are waited for. If no arguments are given, `wait` waits for all running background jobs and the last-executed process substitution, if its process id is the same as $!, and the return status is zero. If the \-n option is supplied, `wait` waits for a single job from the list of pids or jobspecs or, if no arguments are supplied, any job, to complete and returns its exit status. If none of the supplied arguments is a child of the shell, or if no arguments are supplied and the shell has no unwaited-for children, the exit status is 127. If the \-p option is supplied, the process or job identifier of the job for which the exit status is returned is assigned to the variable varname named by the option argument. The variable will be unset initially, before any assignment. This is useful only when the \-n option is supplied. Supplying the \-f option, when job control is enabled, forces `wait` to wait for each pid or jobspec to terminate before returning its status, instead of returning when it changes status. If neither jobspec nor pid specifies an active child process of the shell, the return status is 127. If `wait` is interrupted by a signal, the return status will be greater than 128, as described above (see [Signals](https://www.gnu.org/software/bash/manual/bash.html#Signals)). Otherwise, the return status is the exit status of the last process or job waited for. 等到每个进程 <small>ID</small>pid或作业规范 jobspec`wait`$!如果提供了 \-n 选项，`wait`从 pids 或 jobspec如果提供了 \-p由 option 参数命名varname这仅在提供 \-n提供 \-f强制`wait`等待每个 pid 或 jobspec如果 jobspec 和 pid如果`wait`如上所述，大于 128（参见[信号](https://www.gnu.org/software/bash/manual/bash.html#Signals) 指定的子进程 退出并返回 等待的最后一个命令。 如果给出了作业规范，则会等待作业中的所有进程。 如果没有给出参数， 所有正在运行的后台作业，以及 上次执行的进程替换，如果其进程 ID 与 ， 返回状态为零。 等待单个作业 s 的列表中，或者，如果没有参数 提供，任何工作， 完成并返回其退出状态。 如果提供的参数都不是 shell 的子级，或者没有参数 提供并且 shell 没有未等待的子项，退出状态 是 127。 选项，则为作业的进程或作业标识符 返回退出状态的变量将分配给变量 。 在进行任何赋值之前，该变量最初将被取消设置。 选项时才有用。 选项，当启用作业控制时， 在返回其状态之前终止，而不是在更改时返回 地位。 都没有指定活动的子进程 shell，返回状态为 127。 被信号打断，则返回状态会更大 ）。 否则，返回状态为退出状态 等待的最后一个进程或作业。

`disown`

```
disown [-ar] [-h] [jobspec … | pid … ]
```

Without options, remove each jobspec from the table of active jobs. If the \-h option is given, the job is not removed from the table, but is marked so that `SIGHUP` is not sent to the job if the shell receives a `SIGHUP`. If jobspec is not present, and neither the \-a nor the \-r option is supplied, the current job is used. If no jobspec is supplied, the \-a option means to remove or mark all jobs; the \-r option without a jobspec argument restricts operation to running jobs. 如果没有选项jobspec如果给定 \-h但被标记，以便 `SIGHUP`收到`SIGHUP`如果 jobspec 不存在，\-a\-r如果未提供 jobspec，\-a标记所有作业;没有 jobspec 的 \-r 活动作业。 选项，则作业不会从表中删除， 不会发送到作业，如果 shell 。 和 选项，则使用当前作业。 选项表示删除 选项 参数将操作限制为正在运行的作业。

`suspend`

Suspend the execution of this shell until it receives a `SIGCONT` signal. A login shell, or a shell without job control enabled, cannot be suspended; the \-f option can be used to override this and force the suspension. The return status is 0 unless the shell is a login shell or job control is not enabled and \-f is not supplied. `SIGCONT`不能暂停;\-f\-f暂停此 shell 的执行，直到它收到 信号。 登录 shell， 或未启用作业控制的 shell， 选项可用于覆盖此选项并强制暂停。 返回状态为 0，除非 shell 是登录 shell 或未启用作业控制 和 未提供。

When job control is not active, the `kill` and `wait` builtins do not accept jobspec arguments. They must be supplied process <small>ID</small>s. 当作业控制未处于活动状态时，`kill`并`wait`内置函数不接受 jobspec提供的进程 <small>ID</small> 参数。 他们必须是 s。

___

### 7.3 Job Control Variables7.3 作业控制变量

`auto_resume`

This variable controls how the shell interacts with the user and job control. If this variable exists then single word simple commands without redirections are treated as candidates for resumption of an existing job. There is no ambiguity allowed; if there is more than one job beginning with the string typed, then the most recently accessed job will be selected. The name of a stopped job, in this context, is the command line used to start it. If this variable is set to the value ‘exact’, the string supplied must match the name of a stopped job exactly; if set to ‘substring’, the string supplied needs to match a substring of the name of a stopped job. The ‘substring’ value provides functionality analogous to the ‘%?’ job <small>ID</small> (see [Job Control Basics](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Basics)). If set to any other value, the supplied string must be a prefix of a stopped job’s name; this provides functionality analogous to the ‘%’ job <small>ID</small>. 用来启动它。 如果此变量设置为值“exact如果设置为“substring停止作业。 “substring类似于“%?作业 <small>ID</small>（请参阅[作业控制基础知识](https://www.gnu.org/software/bash/manual/bash.html#Job-Control-Basics)类似于“%”作业 <small>ID。</small>此变量控制 shell 与用户和 作业控制。 如果此变量存在，则单个单词简单 没有重定向的命令被视为恢复的候选项 现有作业。 不允许含糊不清;如果有 多个作业以键入的字符串开头，然后 将选择最近访问的作业。 在此上下文中，已停止作业的名称是命令行 ”， 提供的字符串必须与已停止作业的名称完全匹配; ”， 提供的字符串需要与 ”值提供功能 ）。 如果设置为任何其他值，则提供的字符串必须 是已停止作业名称的前缀;这提供了功能

___