
## 10 Installing Bash10 安装 Bash

This chapter provides basic instructions for installing Bash on the various supported platforms. The distribution supports the <small>GNU</small> operating systems, nearly every version of Unix, and several non-Unix systems such as BeOS and Interix. Other independent ports exist for <small>MS-DOS</small>, <small>OS/2</small>, and Windows platforms. <small>GNU</small><small>MS-DOS</small>、<small>OS/2</small>本章提供了在 各种支持的平台。 该发行版支持 操作系统，几乎所有的 Unix 版本，以及几个 非 Unix 系统，例如 BeOS 和 Interix。 存在其他独立端口 和 Windows 平台。

-   [Basic Installation基本安装](https://www.gnu.org/software/bash/manual/bash.html#Basic-Installation)
-   [Compilers and Options编译器和选项](https://www.gnu.org/software/bash/manual/bash.html#Compilers-and-Options)
-   [Compiling For Multiple Architectures针对多种架构进行编译](https://www.gnu.org/software/bash/manual/bash.html#Compiling-For-Multiple-Architectures)
-   [Installation Names安装名称](https://www.gnu.org/software/bash/manual/bash.html#Installation-Names)
-   [Specifying the System Type指定系统类型](https://www.gnu.org/software/bash/manual/bash.html#Specifying-the-System-Type)
-   [Sharing Defaults共享默认值](https://www.gnu.org/software/bash/manual/bash.html#Sharing-Defaults)
-   [Operation Controls操作控制](https://www.gnu.org/software/bash/manual/bash.html#Operation-Controls)
-   [Optional Features可选功能](https://www.gnu.org/software/bash/manual/bash.html#Optional-Features)

___

### 10.1 Basic Installation10.1 基本安装

These are installation instructions for Bash. 这些是 Bash 的安装说明。

The simplest way to compile Bash is: 编译 Bash 的最简单方法是：

1.  `cd` to the directory containing the source code and type ‘./configure’ to configure Bash for your system. If you’re using `csh` on an old version of System V, you might need to type ‘sh ./configure’ instead to prevent `csh` from trying to execute `configure` itself. `cd`'./configure在旧版本的 System V 上使用 `csh`键入“sh ./configure”以防止 `csh`执行 `configure` 添加到包含源代码的目录下，然后键入 ' 为您的系统配置 Bash。 如果你是 ，您可能需要 尝试 本身。
    
    Running `configure` takes some time. While running, it prints messages telling which features it is checking for. 运行`configure`需要一些时间。 在运行时，它会打印消息，告诉它是什么功能 检查。
    
2.  Type ‘make’ to compile Bash and build the `bashbug` bug reporting script. 键入 'make' 编译 Bash 并构建 `bashbug` bug 报告脚本。
3.  Optionally, type ‘make tests’ to run the Bash test suite.
4.  Type ‘make install’ to install `bash` and `bashbug`. This will also install the manual pages and Info file, message translation files, some supplemental documentation, a number of example loadable builtin commands, and a set of header files for developing loadable builtins. You may need additional privileges to install `bash` to your desired destination, so ‘sudo make install’ might be required. More information about controlling the locations where `bash` and other files are installed is below (see [Installation Names](https://www.gnu.org/software/bash/manual/bash.html#Installation-Names)). 键入“make install”以安装 `bash` 和 `bashbug`您可能需要额外的权限才能将 `bash`所需的目标，因此可能需要“sudo make install有关控制 `bash`安装的其他文件如下（请参阅[安装名称](https://www.gnu.org/software/bash/manual/bash.html#Installation-Names)。 这也将安装手册页和信息文件，消息翻译 文件，一些补充文档，一些可加载的示例 内置命令，以及一组用于开发可加载的头文件 内置。 安装到您的 ”。 和 ）。

The `configure` shell script attempts to guess correct values for various system-dependent variables used during compilation. It uses those values to create a Makefile in each directory of the package (the top directory, the builtins, doc, po, and support directories, each directory under lib, and several others). It also creates a config.h file containing system-dependent definitions. Finally, it creates a shell script named `config.status` that you can run in the future to recreate the current configuration, a file config.cache that saves the results of its tests to speed up reconfiguring, and a file config.log containing compiler output (useful mainly for debugging `configure`). If at some point config.cache contains results you don’t want to keep, you may remove or edit it. `configure`汇编。 它使用这些Makefilebuiltinsdoc、posupportlibconfig.h最后，它创建一个名为 `config.status`文件 config.cache加快重新配置速度，并且文件config.log编译器输出（主要用于调试`configure`config.cache shell 脚本尝试猜测正确 期间使用的各种系统相关变量的值 包的每个目录（顶部目录、 ， 下的每个目录，以及其他几个目录）。 它还创建了一个 文件，其中包含与系统相关的定义。 的 shell 脚本，您可以 可以在将来运行以重新创建当前配置，一个 ，用于保存其测试结果 包含 ）。 如果在某个时候 包含您不想保留的结果，您 可以删除或编辑它。

To find out more about the options and arguments that the `configure` script understands, type `configure`要了解有关选项和参数的更多信息，请 脚本理解，键入

```
bash-4.2$ ./configure --help
```

at the Bash prompt in your Bash source directory. 在 Bash 源目录中的 Bash 提示符下。

If you want to build Bash in a directory separate from the source directory – to build for multiple architectures, for example – just use the full path to the configure script. The following commands will build bash in a directory under /usr/local/build from the source code in /usr/local/src/bash-4.4: 将在 /usr/local/build/usr/local/src/bash-4.4如果要在与源代码不同的目录中构建 Bash 目录 – 为多个架构构建，例如 – 只需使用配置脚本的完整路径即可。以下命令 下的目录中构建 bash 中的源代码：

```
mkdir /usr/local/build/bash-4.4
cd /usr/local/build/bash-4.4
bash /usr/local/src/bash-4.4/configure
make
```

See [Compiling For Multiple Architectures](https://www.gnu.org/software/bash/manual/bash.html#Compiling-For-Multiple-Architectures) for more information about building in a directory separate from the source. 有关更多信息，请参见[针对多个体系结构进行编译](https://www.gnu.org/software/bash/manual/bash.html#Compiling-For-Multiple-Architectures) 关于在与源代码分开的目录中构建。

If you need to do unusual things to compile Bash, please try to figure out how `configure` could check whether or not to do them, and mail diffs or instructions to [bash-maintainers@gnu.org](mailto:bash-maintainers@gnu.org) so they can be considered for the next release. 尝试弄清楚`configure`[bash-maintainers@gnu.org](mailto:bash-maintainers@gnu.org)如果你需要做一些不寻常的事情来编译 Bash，请 如何检查是否 来做这些事情，并将差异或说明邮寄给 这样他们就可以了 考虑用于下一个版本。

The file configure.ac is used to create `configure` by a program called Autoconf. You only need configure.ac if you want to change it or regenerate `configure` using a newer version of Autoconf. If you do this, make sure you are using Autoconf version 2.69 or newer. 文件 configure.ac 用于创建`configure`只有当你想改变它或再生它时，你才需要 configure.ac使用较新版本的 Autoconf `configure` 通过一个名为 Autoconf 的程序。 。 如果执行此操作，请确保使用的是 Autoconf 版本 2.69 或 新。

You can remove the program binaries and object files from the source code directory by typing ‘make clean’. To also remove the files that `configure` created (so you can compile Bash for a different kind of computer), type ‘make distclean’. 源代码目录，键入“make clean`configure`不同类型的计算机），键入“make distclean您可以从 ”。 要同时删除 created （以便您可以编译 Bash ”。

___

### 10.2 Compilers and Options10.2 编译器和选项

Some systems require unusual options for compilation or linking that the `configure` script does not know about. You can give `configure` initial values for variables by setting them in the environment. Using a Bourne-compatible shell, you can do that on the command line like this: `configure`通过设置 `configure`某些系统需要不寻常的编译或链接选项 脚本不知道。 您可以 变量的初始值 他们在环境中。 使用兼容 Bourne 的 shell，您可以 可以在命令行上执行此操作，如下所示：

```
CC=c89 CFLAGS=-O2 LIBS=-lposix ./configure
```

On systems that have the `env` program, you can do it like this: 在具有 `env` 程序的系统上，您可以像这样执行操作：

```
env CPPFLAGS=-I/usr/local/include LDFLAGS=-s ./configure
```

The configuration process uses GCC to build Bash if it is available. 配置过程使用 GCC 来构建 Bash，如果它 可用。

___

### 10.3 Compiling For Multiple Architectures10.3 针对多种架构进行编译

You can compile Bash for more than one kind of computer at the same time, by placing the object files for each architecture in their own directory. To do this, you must use a version of `make` that supports the `VPATH` variable, such as GNU `make`. `cd` to the directory where you want the object files and executables to go and run the `configure` script from the source directory (see [Basic Installation](https://www.gnu.org/software/bash/manual/bash.html#Basic-Installation)). You may need to supply the \--srcdir=PATH argument to tell `configure` where the source files are. `configure` automatically checks for the source code in the directory that `configure` is in and in ‘..’. 自己的目录。 为此，您必须使用 `make`支持 `VPATH` 变量，例如 GNU `make``cd`源目录中的 `configure`（请参阅[基本安装](https://www.gnu.org/software/bash/manual/bash.html#Basic-Installation)提供 \--srcdir=PATH 参数以告诉`configure`源文件是。 `configure``configure`您可以在 同时，通过将每个架构的目标文件放在 that 的版本 。 到 要运行目标文件和可执行文件的目录 脚本 ）。 您可能需要 自动检查 目录中的源代码位于 '..' 和 '..' 中。

If you have to use a `make` that does not support the `VPATH` variable, you can compile Bash for one architecture at a time in the source code directory. After you have installed Bash for one architecture, use ‘make distclean’ before reconfiguring for another architecture. 如果必须使用不支持 `VPATH` 的`make`Bash 对于一个架构，之前使用“make distclean 变量，您可以在 时间在源代码目录中。 安装后 ” 为另一个体系结构重新配置。

Alternatively, if your system supports symbolic links, you can use the support/mkclone script to create a build tree which has symbolic links back to each file in the source directory. Here’s an example that creates a build directory in the current directory from a source directory /usr/gnu/src/bash-2.0: support/mkclone源目录 /usr/gnu/src/bash-2.0或者，如果您的系统支持符号链接，则可以使用 脚本创建一个构建树，该树具有 符号链接返回到源目录中的每个文件。 这是一个 在当前目录中从 ：

```
bash /usr/gnu/src/bash-2.0/support/mkclone -s /usr/gnu/src/bash-2.0 .
```

The `mkclone` script requires Bash, so you must have already built Bash for at least one architecture before you can create build directories for other architectures. `mkclone` 脚本需要 Bash，因此您必须已经构建了 在创建构建之前，至少对一个体系结构进行 Bash 其他体系结构的目录。

___

### 10.4 Installation Names10.4 安装名称

By default, ‘make install’ will install into /usr/local/bin, /usr/local/man, etc.; that is, the _installation prefix_ defaults to /usr/local. You can specify an installation prefix other than /usr/local by giving `configure` the option \--prefix=PATH, or by specifying a value for the `prefix` ‘make’ variable when running ‘make install’ (e.g., ‘make install prefix=PATH’). The `prefix` variable provides a default for `exec_prefix` and other variables used when installing bash. 默认情况下，“make install/usr/local/bin、/usr/local/man也就是说，_安装前缀_默认为 /usr/local您可以通过以下方式指定/usr/local给出`configure`选项 --prefix=PATH或者通过指定`prefix`“make运行“make install（例如，“make install prefix=PATH`prefix` 变量为 `exec_prefix`”将安装到 等; 。 之外的安装前缀 ， ”的值 ”时的变量 ”）。 和 安装 Bash 时使用的其他变量。

You can specify separate installation prefixes for architecture-specific files and architecture-independent files. If you give `configure` the option \--exec-prefix=PATH, ‘make install’ will use PATH as the prefix for installing programs and libraries. Documentation and other data files will still use the regular prefix. 如果您给 `configure`\--exec-prefix=PATH'make installPATH您可以为 特定于体系结构的文件和与体系结构无关的文件。 选项 ' 将使用 作为安装程序和库的前缀。 文档和其他数据文件仍将使用常规前缀。

If you would like to change the installation locations for a single run, you can specify these variables as arguments to `make`: ‘make install exec\_prefix=/’ will install `bash` and `bashbug` into /bin instead of the default /usr/local/bin. 您可以将这些变量指定为`make`'make install exec\_prefix=/' 将安装 `bash``bashbug` 放入 /bin 中，而不是默认的 /usr/local/bin如果要更改单次运行的安装位置， 的参数： 和 。

If you want to see the files bash will install and where it will install them without changing anything on your system, specify the variable `DESTDIR` as an argument to `make`. Its value should be the absolute directory path you’d like to use as the root of your sample installation tree. For example, `DESTDIR` 作为`make`如果您想查看 bash 将安装的文件以及安装位置 在不更改系统上的任何内容的情况下，指定变量 论据。其值应为 要用作示例根目录的绝对目录路径 安装树。例如

```
mkdir /fs1/bash-install
make install DESTDIR=/fs1/bash-install
```

will install `bash` into /fs1/bash-install/usr/local/bin/bash, the documentation into directories within /fs1/bash-install/usr/local/share, the example loadable builtins into /fs1/bash-install/usr/local/lib/bash, and so on. You can use the usual `exec_prefix` and `prefix` variables to alter the directory paths beneath the value of `DESTDIR`. 将 `bash` 安装到 /fs1/bash-install/usr/local/bin/bash/fs1/bash-install/usr/local/share/fs1/bash-install/usr/local/lib/bash您可以使用常用的 `exec_prefix` 和`prefix``DESTDIR` 中， 将文档放入目录中 ，示例可加载内置到 等。 变量来更改 值下的目录路径。

The GNU Makefile standards provide a more complete description of these variables and their effects. GNU Makefile 标准提供了更完整的描述 变量及其影响。

___

### 10.5 Specifying the System Type10.5 指定系统类型

There may be some features `configure` can not figure out automatically, but needs to determine by the type of host Bash will run on. Usually `configure` can figure that out, but if it prints a message saying it can not guess the host type, give it the \--host=TYPE option. ‘TYPE’ can either be a short name for the system type, such as ‘sun4’, or a canonical name with three fields: ‘CPU-COMPANY-SYSTEM’ (e.g., ‘i386-unknown-freebsd4.2’). 可能有些功能`configure`将继续运行。 通常`configure`type，给它 \--host=TYPE 选项。 'TYPE可以是系统类型的简称，例如“sun4或包含三个字段的规范名称：“CPU-COMPANY-SYSTEM（例如，'i386-unknown-freebsd4.2不懂 自动，但需要根据主机 Bash 的类型确定 可以弄清楚 出来，但如果它打印一条消息说它无法猜到主机 '可以 ”， '）。

See the file support/config.sub for the possible values of each field. 请参阅文件 support/config.sub 了解可能 每个字段的值。

___

### 10.6 Sharing Defaults10.6 共享默认值

If you want to set default values for `configure` scripts to share, you can create a site shell script called `config.site` that gives default values for variables like `CC`, `cache_file`, and `prefix`. `configure` looks for PREFIX/share/config.site if it exists, then PREFIX/etc/config.site if it exists. Or, you can set the `CONFIG_SITE` environment variable to the location of the site script. A warning: the Bash `configure` looks for a site script, but not all `configure` scripts do. 如果要将 `configure``config.site``CC``cache_file` 和`prefix`。 `configure`如果存在，请查找 PREFIX/share/config.sitePREFIX/etc/config.site`CONFIG_SITE`脚本。 警告：Bash `configure`但并非所有`configure` 脚本的默认值设置为 共享时，可以创建一个名为 ，它给出了变量的默认值，例如 ，然后 （如果存在）。 或者，您可以将 环境变量到站点的位置 查找站点脚本， 脚本都这样做。

___

### 10.7 Operation Controls10.7 操作控制

`configure` recognizes the following options to control how it operates. `configure` 可识别以下选项来控制其 经营。

`--cache-file=file`\--cache-file=file

Use and save the results of the tests in file instead of ./config.cache. Set file to /dev/null to disable caching, for debugging `configure`. file，而不是 ./config.cache。 file/dev/null`configure`使用并保存测试结果 设置为 禁用缓存，用于调试 。

`--help`

Print a summary of the options to `configure`, and exit. 打印要`configure`和退出的选项的摘要。

`--quiet`

`--silent`

`-q`

Do not print messages saying which checks are being made. 不要打印消息，说明正在进行哪些检查。

`--srcdir=dir`

Look for the Bash source code in directory dir. Usually `configure` can determine that directory automatically.

`--version`

Print the version of Autoconf used to generate the `configure` script, and exit. 打印用于生成`configure`的 Autoconf 版本 脚本，然后退出。

`configure` also accepts some other, not widely used, boilerplate options. ‘configure --help’ prints the complete list. `configure`选项。 'configure --help 还接受其他一些未广泛使用的样板 ' 打印完整列表。

___

### 10.8 Optional Features10.8 可选功能

The Bash `configure` has a number of \--enable-feature options, where feature indicates an optional part of Bash. There are also several \--with-package options, where package is something like ‘bash-malloc’ or ‘purify’. To turn off the default use of a package, use \--without-package. To configure Bash without a feature that is enabled by default, use \--disable-feature. Bash `configure`有许多 --enable-feature选项，其中 feature还有几个 --package其中 package 类似于“bash-malloc”或“purify\--package默认情况下启用，请使用 --disable-feature 表示 Bash 的可选部分。 选项， ”。 若要关闭包的默认使用，请使用 。 配置没有功能的 Bash 。

Here is a complete list of the \--enable- and \--with- options that the Bash `configure` recognizes. 以下是 \--enable-\--\--with- Bash `configure` 和 识别的选项。

`--with-afs`

Define if you are using the Andrew File System from Transarc. 定义是否使用 Transarc 中的 Andrew 文件系统。

`--with-bash-malloc`

Use the Bash version of `malloc` in the directory lib/malloc. This is not the same `malloc` that appears in <small>GNU</small> libc, but an older version originally derived from the 4.2 <small>BSD</small> `malloc`. This `malloc` is very fast, but wastes some space on each allocation. This option is enabled by default. The NOTES file contains a list of systems for which this should be turned off, and `configure` disables this option automatically for a number of systems. `malloc` 在目录 lib/malloc出现在 <small>GNU</small> libc 中的 `malloc`最初源自 4.2 <small>BSD</small>`malloc`。 这个 `malloc`NOTES这应该关闭，并`configure`使用 Bash 版本 中。 这是不一样的 ，但版本较旧 速度非常快，但在每次分配上都会浪费一些空间。 默认情况下，此选项处于启用状态。 文件包含以下系统列表 禁用它 自动为多个系统提供选项。

`--with-curses`

Use the curses library instead of the termcap library. This should be supplied if your system has an inadequate or incomplete termcap database. 使用 curses 库而不是 termcap 库。 这应该 如果您的系统具有不充分或不完整的术语上限，则提供 数据库。

`--with-gnu-malloc`

A synonym for `--with-bash-malloc`. `--with-bash-malloc` 的同义词。

`--with-installed-readline[=PREFIX]`\--with-installed-readline\[=PREFIX

Define this to make Bash link with a locally-installed version of Readline rather than the version in lib/readline. This works only with Readline 5.0 and later versions. If PREFIX is `yes` or not supplied, `configure` uses the values of the make variables `includedir` and `libdir`, which are subdirectories of `prefix` by default, to find the installed version of Readline if it is not in the standard system include and library directories. If PREFIX is `no`, Bash links with the version in lib/readline. If PREFIX is set to any other value, `configure` treats it as a directory pathname and looks for the installed version of Readline in subdirectories of that directory (include files in PREFIX/`include` and the library in PREFIX/`lib`). 而不是 lib/readlineReadline 5.0 及更高版本。 如果 PREFIX `yes`提供的 `configure``includedir` 和 `libdir`，它们是`prefix`如果 PREFIX `no`lib/readline如果 PREFIX 设置为任何其他值，`configure`（将文件包含在 PREFIX/`include`PREFIX`lib`定义此项以使 Bash 与本地安装的 Readline 版本链接 中的版本。 这仅适用于 不是 使用 make 变量的值 的子目录 默认情况下，查找已安装的 Readline 版本（如果它不在 标准系统包括 和 库目录。 ，则 Bash 链接到 。 将其视为 目录路径名并查找 该目录的子目录中已安装的 Readline 版本 中，将库包含在 ）。

`--with-libintl-prefix[=PREFIX]`\--with-libintl-prefix\[=PREFIX

Define this to make Bash link with a locally-installed version of the libintl library instead of the version in lib/intl. libintl 库，而不是 lib/intl定义此项以使 Bash 与本地安装的 中的版本。

`--with-libiconv-prefix[=PREFIX]`\--with-libiconv-prefix\[=PREFIX

Define this to make Bash look for libiconv in PREFIX instead of the standard system locations. There is no version included with Bash. 定义它以使 Bash 在 PREFIX 中查找 libiconv，而不是 标准系统位置。Bash 不包含任何版本。

`--enable-minimal-config`

This produces a shell with minimal features, close to the historical Bourne shell. 这会产生一个具有最小特征的shell，接近历史 伯恩Bash。

There are several \--enable- options that alter how Bash is compiled, linked, and installed, rather than changing run-time features. 有几个 \--enable- 选项可以改变 Bash 的方式 编译、链接和安装，而不是更改运行时功能。

`--enable-largefile`

Enable support for [large files](http://www.unix.org/version2/whatsnew/lfs20mar.html) if the operating system requires special compiler options to build programs which can access large files. This is enabled by default, if the operating system provides large file support. 如果操作系统需要特殊的编译器选项，则启用[对大文件](http://www.unix.org/version2/whatsnew/lfs20mar.html)的支持 构建可以访问大文件的程序。 这是通过以下方式实现的 默认值（如果操作系统提供大文件支持）。

`--enable-profiling`

This builds a Bash binary that produces profiling information to be processed by `gprof` each time it is executed. 每次执行时都由 `gprof`这将构建一个 Bash 二进制文件，该二进制文件生成要 处理。

`--enable-separate-helpfiles`

Use external files for the documentation displayed by the `help` builtin instead of storing the text internally. 使用外部文件获取内置`help`显示的文档 而不是在内部存储文本。

`--enable-static-link`

This causes Bash to be linked statically, if `gcc` is being used. This could be used to build a version to use as root’s shell. 这会导致 Bash 静态链接（如果正在使用 `gcc`）。 这可以用来构建一个版本，用作 root 的 shell。

The ‘minimal-config’ option can be used to disable all of the following options, but it is processed first, so individual options may be enabled using ‘enable-feature’. “minimal-config可以使用“enable-feature”启用选项”选项可用于禁用所有 以下选项，但它是先处理的，所以单独 。

All of the following options except for ‘alt-array-implementation’, ‘disabled-builtins’, ‘direxpand-default’, ‘strict-posix-default’, and ‘xpg-echo-default’ are enabled by default, unless the operating system does not provide the necessary support. 'alt-array-implementation'disabled-builtins'direxpand-default'strict-posix-default'xpg-echo-default以下所有选项，但 '， '， '， '， 和 ' 是 默认情况下启用，除非操作系统不提供 必要的支持。

`--enable-alias`

Allow alias expansion and include the `alias` and `unalias` builtins (see [Aliases](https://www.gnu.org/software/bash/manual/bash.html#Aliases)). 允许别名扩展并包含`alias`和`unalias`builtins（请参阅[别名](https://www.gnu.org/software/bash/manual/bash.html#Aliases) ）。

`--enable-alt-array-implementation`

This builds bash using an alternate implementation of arrays (see [Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)) that provides faster access at the expense of using more memory (sometimes many times more, depending on how sparse an array is). （请参阅[数组](https://www.gnu.org/software/bash/manual/bash.html#Arrays)这将使用数组的替代实现来构建 bash ），以使用 更多的内存（有时是数倍，具体取决于数组的稀疏程度）。

`--enable-arith-for-command`

Include support for the alternate form of the `for` command that behaves like the C language `for` statement (see [Looping Constructs](https://www.gnu.org/software/bash/manual/bash.html#Looping-Constructs)). 包括对 `for`其行为类似于`for`（请参阅[循环构造](https://www.gnu.org/software/bash/manual/bash.html#Looping-Constructs) 命令的替代形式的支持 句的 C 语言 ）。

`--enable-array-variables`

Include support for one-dimensional array shell variables (see [Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)). （请参阅[数组](https://www.gnu.org/software/bash/manual/bash.html#Arrays)包括对一维数组 shell 变量的支持 ）。

`--enable-bang-history`

Include support for `csh`\-like history substitution (see [History Expansion](https://www.gnu.org/software/bash/manual/bash.html#History-Interaction)). 包括对类似 `csh`（请参阅[历史扩展](https://www.gnu.org/software/bash/manual/bash.html#History-Interaction) 的历史记录替换的支持 ）。

`--enable-brace-expansion`

Include `csh`\-like brace expansion ( `b{a,b}c` → `bac bbc` ). See [Brace Expansion](https://www.gnu.org/software/bash/manual/bash.html#Brace-Expansion), for a complete description. 包括类似 `csh`（ `b{a,b}c` → `bac bbc`有关完整说明，请参阅[大括号扩展](https://www.gnu.org/software/bash/manual/bash.html#Brace-Expansion) 的支撑扩展 ）。 。

`--enable-casemod-attributes`

Include support for case-modifying attributes in the `declare` builtin and assignment statements. Variables with the `uppercase` attribute, for example, will have their values converted to uppercase upon assignment. 在 `declare`和赋值语句。 具有`uppercase` 内置中包含对大小写修改属性的支持 属性的变量， 例如，将在分配时将其值转换为大写。

`--enable-casemod-expansion`

Include support for case-modifying word expansions. 包括对大小写修改单词扩展的支持。

`--enable-command-timing`

Include support for recognizing `time` as a reserved word and for displaying timing statistics for the pipeline following `time` (see [Pipelines](https://www.gnu.org/software/bash/manual/bash.html#Pipelines)). This allows pipelines as well as shell builtins and functions to be timed. 包括对`time``time`（请参阅[管道](https://www.gnu.org/software/bash/manual/bash.html#Pipelines)识别为保留词和 for 的支持 水线的计时统计信息 ）。 这允许对管道以及 shell 内置函数和函数进行计时。

`--enable-cond-command`

Include support for the `[[` conditional command. (see [Conditional Constructs](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)). 包括对 `[[`（请参阅[条件结构](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs) conditional 命令的支持。 ）。

`--enable-cond-regexp`

Include support for matching <small>POSIX</small> regular expressions using the ‘\=~’ binary operator in the `[[` conditional command. (see [Conditional Constructs](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)). 包括对使用`[[`\=~（请参阅[条件结构](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs) ' 二进制运算符。 ）。

`--enable-coprocesses`

Include support for coprocesses and the `coproc` reserved word (see [Pipelines](https://www.gnu.org/software/bash/manual/bash.html#Pipelines)). 包括对 `coproc`（请参阅[管道](https://www.gnu.org/software/bash/manual/bash.html#Pipelines) 保留字的支持 ）。

`--enable-debugger`

Include support for the bash debugger (distributed separately). 包括对 bash 调试器（单独分发）的支持。

`--enable-dev-fd-stat-broken`

If calling `stat` on /dev/fd/N returns different results than calling `fstat` on file descriptor N, supply this option to enable a workaround. This has implications for conditional commands that test file attributes. 如果在 /dev/fd/N 上调用 `stat`在文件描述符 N 上调用 `fstat` 返回的结果与 ，将此选项提供给 启用变通办法。 这对测试文件属性的条件命令有影响。

`--enable-direxpand-default`

Cause the `direxpand` shell option (see [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)) to be enabled by default when the shell starts. It is normally disabled by default. 导致 `direxpand` shell 选项（参见 [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin)） 默认情况下，在 shell 启动时启用。 默认情况下，它通常处于禁用状态。

`--enable-directory-stack`

Include support for a `csh`\-like directory stack and the `pushd`, `popd`, and `dirs` builtins (see [The Directory Stack](https://www.gnu.org/software/bash/manual/bash.html#The-Directory-Stack)). 包括对类似 `csh``pushd`、`popd` 和 `dirs`（请参阅[目录堆栈](https://www.gnu.org/software/bash/manual/bash.html#The-Directory-Stack) 的目录堆栈的支持，以及 内置 ）。

`--enable-disabled-builtins`

Allow builtin commands to be invoked via ‘builtin xxx’ even after `xxx` has been disabled using ‘enable -n xxx’. See [Bash Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins), for details of the `builtin` and `enable` builtin commands. 允许通过“builtin xxx即使在使用“enable -n xxx”禁用 `xxx`请参阅 [Bash 内置命令](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)，了解`builtin``enable`”调用内置命令 之后。 命令和 内置命令。

`--enable-dparen-arithmetic`

Include support for the `((…))` command (see [Conditional Constructs](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)). 包括对 `((…))`（请参阅[条件结构](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs) 命令的支持 ）。

`--enable-extended-glob`

Include support for the extended pattern matching features described above under [Pattern Matching](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching). 上面的[模式匹配](https://www.gnu.org/software/bash/manual/bash.html#Pattern-Matching)包括对所描述的扩展模式匹配功能的支持 。

`--enable-extended-glob-default`

Set the default value of the `extglob` shell option described above under [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin) to be enabled. 设置所描述的 `extglob`上面在要启用[的 The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin) shell 选项的默认值 下。

`--enable-function-import`

Include support for importing function definitions exported by another instance of the shell from the environment. This option is enabled by default. 包括对导入由另一个导出的函数定义的支持 环境中的 shell 实例。 此选项由 违约。

`--enable-glob-asciirange-default`

Set the default value of the `globasciiranges` shell option described above under [The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin) to be enabled. This controls the behavior of character ranges when used in pattern matching bracket expressions. 设置所描述的 `globasciiranges`上面在要启用[的 The Shopt Builtin](https://www.gnu.org/software/bash/manual/bash.html#The-Shopt-Builtin) shell 选项的默认值 下。 这控制了在模式匹配中使用时字符范围的行为 括号表达式。

`--enable-help-builtin`

Include the `help` builtin, which displays help on shell builtins and variables (see [Bash Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)). 包括内置`help`变量（请参阅 [Bash 内置命令](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)，它显示 shell 内置的帮助和 ）。

`--enable-history`

Include command history and the `fc` and `history` builtin commands (see [Bash History Facilities](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Facilities)). 包括命令历史记录以及 `fc` 和`history`内置命令（请参阅 [Bash 历史记录工具](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Facilities) ）。

`--enable-job-control`

This enables the job control features (see [Job Control](https://www.gnu.org/software/bash/manual/bash.html#Job-Control)), if the operating system supports them. 这将启用作业控制功能（请参阅[作业控制](https://www.gnu.org/software/bash/manual/bash.html#Job-Control)）， 如果操作系统支持它们。

`--enable-multibyte`

This enables support for multibyte characters if the operating system provides the necessary support. 这允许支持多字节字符，如果操作 系统提供必要的支持。

`--enable-net-redirections`

This enables the special handling of filenames of the form `/dev/tcp/host/port` and `/dev/udp/host/port` when used in redirections (see [Redirections](https://www.gnu.org/software/bash/manual/bash.html#Redirections)). /dev/tcp/host/port/dev/udp/host/port在重定向中使用时（请参阅[重定向](https://www.gnu.org/software/bash/manual/bash.html#Redirections)这样就可以对表单的文件名进行特殊处理 和 ）。

`--enable-process-substitution`

This enables process substitution (see [Process Substitution](https://www.gnu.org/software/bash/manual/bash.html#Process-Substitution)) if the operating system provides the necessary support. 如果出现以下情况，这将启用进程替换（请参阅[进程替换](https://www.gnu.org/software/bash/manual/bash.html#Process-Substitution)） 操作系统提供了必要的支持。

`--enable-progcomp`

Enable the programmable completion facilities (see [Programmable Completion](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion)). If Readline is not enabled, this option has no effect. （请参阅[可编程完成](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion)启用可编程完井设施 ）。 如果未启用 Readline，则此选项无效。

`--enable-prompt-string-decoding`

Turn on the interpretation of a number of backslash-escaped characters in the `$PS0`, `$PS1`, `$PS2`, and `$PS4` prompt strings. See [Controlling the Prompt](https://www.gnu.org/software/bash/manual/bash.html#Controlling-the-Prompt), for a complete list of prompt string escape sequences. `$PS0`、`$PS1`、`$PS2` 和 `$PS4`字符串。 有关提示的完整列表，请参阅[控制提示](https://www.gnu.org/software/bash/manual/bash.html#Controlling-the-Prompt)打开多个反斜杠转义字符的解释 提示符中 字符串转义序列。

`--enable-readline`

Include support for command-line editing and history with the Bash version of the Readline library (see [Command Line Editing](https://www.gnu.org/software/bash/manual/bash.html#Command-Line-Editing)). Readline 库的版本（请参阅[命令行编辑](https://www.gnu.org/software/bash/manual/bash.html#Command-Line-Editing)包括 Bash 对命令行编辑和历史记录的支持 ）。

`--enable-restricted`

Include support for a _restricted shell_. If this is enabled, Bash, when called as `rbash`, enters a restricted mode. See [The Restricted Shell](https://www.gnu.org/software/bash/manual/bash.html#The-Restricted-Shell), for a description of restricted mode. 包括对_受限 shell_当作为 `rbash`[受限 Shell](https://www.gnu.org/software/bash/manual/bash.html#The-Restricted-Shell) 的支持。 如果启用此功能，则 Bash、 调用时，进入受限模式。 看 ，用于描述受限模式。

`--enable-select`

Include the `select` compound command, which allows the generation of simple menus (see [Conditional Constructs](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs)). 包括 `select`简单的菜单（参见[条件结构](https://www.gnu.org/software/bash/manual/bash.html#Conditional-Constructs) compound 命令，该命令允许生成 ）。

`--enable-single-help-strings`

Store the text displayed by the `help` builtin as a single string for each help topic. This aids in translating the text to different languages. You may need to disable this if your compiler cannot handle very long string literals. 将`help`显示的文本存储为单个字符串 每个帮助主题。 这有助于将文本翻译成不同的语言。 如果您的编译器无法处理很长的字符串，则可能需要禁用此功能 文字。

`--enable-strict-posix-default`

Make Bash <small>POSIX</small>\-conformant by default (see [Bash POSIX Mode](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)). 默认情况下，使 Bash <small>符合 POSIX（</small>请参阅 [Bash POSIX 模式](https://www.gnu.org/software/bash/manual/bash.html#Bash-POSIX-Mode)）。

`--enable-translatable-strings`

Enable support for `$"string"` translatable strings (see [Locale-Specific Translation](https://www.gnu.org/software/bash/manual/bash.html#Locale-Translation)). 启用对 $“string（请参阅[特定于区域设置的翻译](https://www.gnu.org/software/bash/manual/bash.html#Locale-Translation)” 可翻译字符串的支持 ）。

`--enable-usg-echo-default`

A synonym for `--enable-xpg-echo-default`. `--enable-xpg-echo-default` 的同义词。

`--enable-xpg-echo-default`

Make the `echo` builtin expand backslash-escaped characters by default, without requiring the \-e option. This sets the default value of the `xpg_echo` shell option to `on`, which makes the Bash `echo` behave more like the version specified in the Single Unix Specification, version 3. See [Bash Builtin Commands](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins), for a description of the escape sequences that `echo` recognizes. 默认情况下，使 `echo`不需要 \-e这会将 `xpg_echo` shell 选项的默认值设置为 `on`这使得 Bash `echo`请参阅 [Bash 内置命令](https://www.gnu.org/software/bash/manual/bash.html#Bash-Builtins)`echo` builtin expand 反斜杠转义字符， 选项。 ， 的行为更像 单一 Unix 规范，版本 3。 ，了解以下转义序列的说明 识别。

The file config-top.h contains C Preprocessor ‘#define’ statements for options which are not settable from `configure`. Some of these are not meant to be changed; beware of the consequences if you do. Read the comments associated with each definition for more information about its effect. config-top.h“#define`configure` 包含 C 预处理器 ”语句，用于无法从中设置的选项 。 其中一些并不意味着要改变;如果出现以下情况，请小心后果 是吗。 阅读与每个定义相关的注释，了解更多信息 有关其效果的信息。
