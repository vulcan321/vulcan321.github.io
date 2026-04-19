The GNU Compiler Collection (GCC) is a collection of compilers and libraries for C, C++, Objective-C, Fortran, Ada, [Go](https://linuxize.com/post/how-to-install-go-on-ubuntu-20-04/) , and D programming languages. A lot of open-source projects, including the Linux kernel and GNU tools, are compiled using GCC.

This article explains how to install GCC on Ubuntu 20.04.

## Installing GCC on Ubuntu 20.04 [#](https://linuxize.com/post/how-to-install-gcc-on-ubuntu-20-04//#installing-gcc-on-ubuntu-2004)

The default Ubuntu repositories contain a meta-package named “build-essential” that includes the GNU compiler collection, GNU debugger, and other development libraries and tools required for compiling software.

To install the Development Tools packages, run the following command as root or [user with sudo privileges](https://linuxize.com/post/how-to-create-a-sudo-user-on-ubuntu/) :

```
sudo apt update
```

The command installs a lot of packages, including `gcc`, `g++` and `make`.if(typeof ez\_ad\_units != 'undefined'){ez\_ad\_units.push(\[\[728,90\],'linuxize\_com-box-3','ezslot\_2',139,'0','0'\])};\_\_ez\_fad\_position('div-gpt-ad-linuxize\_com-box-3-0');

You may also want to install the manual pages about using GNU/Linux for development:if(typeof ez\_ad\_units != 'undefined'){ez\_ad\_units.push(\[\[336,280\],'linuxize\_com-medrectangle-3','ezslot\_1',156,'0','0'\])};\_\_ez\_fad\_position('div-gpt-ad-linuxize\_com-medrectangle-3-0');

```
sudo apt-get install manpages-dev
```

Verify that the GCC compiler is successfully installed by running the following command that prints the GCC version:

```
gcc --version
```

Ubuntu 20.04 repositories provide GCC version `9.3.0`:

```output
gcc (Ubuntu 9.3.0-10ubuntu2) 9.3.0
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```

That’s it. GCC tools and libraries have been installed on your Ubuntu system.

## Compiling a Hello World Example [#](https://linuxize.com/post/how-to-install-gcc-on-ubuntu-20-04//#compiling-a-hello-world-example)

Compiling a basic C or C++ program using GCC is pretty easy. Open your [text editor](https://linuxize.com/post/how-to-install-visual-studio-code-on-ubuntu-18-04/) and create the following file:

```
nano hello.c
```

hello.c

```c
// hello.c
#include <stdio.h>
 
int main() {
    printf("Hello, world!\n");
    return 0;
}
```

Copy

Save the file and compile it into an executable:

```
gcc hello.c -o hello
```

This creates a binary file named `hello` in the same directory where you run the command.if(typeof ez\_ad\_units != 'undefined'){ez\_ad\_units.push(\[\[580,400\],'linuxize\_com-medrectangle-4','ezslot\_3',142,'0','0'\])};\_\_ez\_fad\_position('div-gpt-ad-linuxize\_com-medrectangle-4-0');

Execute the `hello` program with:

```
./hello
```

The program should print:

```output
Hello World!
```

## Installing Multiple GCC Versions [#](https://linuxize.com/post/how-to-install-gcc-on-ubuntu-20-04//#installing-multiple-gcc-versions)

This section provides instructions about how to install and use multiple versions of GCC on Ubuntu 20.04. The newer versions of the GCC compiler include new functions and optimization improvements.

At the time of writing this article, the default Ubuntu repositories include several GCC versions, from `7.x.x` to `10.x.x`.if(typeof ez\_ad\_units != 'undefined'){ez\_ad\_units.push(\[\[728,90\],'linuxize\_com-box-4','ezslot\_4',143,'0','0'\])};\_\_ez\_fad\_position('div-gpt-ad-linuxize\_com-box-4-0');

if(typeof ez\_ad\_units != 'undefined'){ez\_ad\_units.push(\[\[728,90\],'linuxize\_com-banner-1','ezslot\_6',161,'0','0'\])};\_\_ez\_fad\_position('div-gpt-ad-linuxize\_com-banner-1-0');In the following example, we will install the latest three versions of GCC and G++.

Install the desired GCC and G++ versions by typing:

```
sudo apt install gcc-8 g++-8 gcc-9 g++-9 gcc-10 g++-10
```

The commands below configures alternative for each version and associate a priority with it. The default version is the one with the highest priority, in our case that is `gcc-10`.

(adsbygoogle = window.adsbygoogle || \[\]).push({});

```
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 --slave /usr/bin/g++ g++ /usr/bin/g++-10 --slave /usr/bin/gcov gcov /usr/bin/gcov-10
```

Later if you want to change the default version use the `update-alternatives` command:

```
sudo update-alternatives --config gcc
```

```output
There are 3 choices for the alternative gcc (providing /usr/bin/gcc).

  Selection    Path            Priority   Status
------------------------------------------------------------
* 0            /usr/bin/gcc-10   100       auto mode
  1            /usr/bin/gcc-10   100       manual mode
  2            /usr/bin/gcc-8    80        manual mode
  3            /usr/bin/gcc-9    90        manual mode

Press <enter> to keep the current choice[*], or type selection number:
```

You will be presented with a list of all installed GCC versions on your Ubuntu system. Enter the number of the version you want to be used as a default and press `Enter`.if(typeof ez\_ad\_units != 'undefined'){ez\_ad\_units.push(\[\[580,400\],'linuxize\_com-large-mobile-banner-1','ezslot\_7',157,'0','0'\])};\_\_ez\_fad\_position('div-gpt-ad-linuxize\_com-large-mobile-banner-1-0');

The command will create [symbolic links](https://linuxize.com/post/how-to-create-symbolic-links-in-linux-using-the-ln-command/) to the specific versions of GCC and G++.

## Conclusion [#](https://linuxize.com/post/how-to-install-gcc-on-ubuntu-20-04//#conclusion)

We’ve shown you how to installed GCC on Ubuntu 20.04. You can now visit the official [GCC Documentation](https://gcc.gnu.org/onlinedocs/) page and learn how to use GCC and G++ to compile your C and C++ programs.

If you hit a problem or have feedback, leave a comment below.