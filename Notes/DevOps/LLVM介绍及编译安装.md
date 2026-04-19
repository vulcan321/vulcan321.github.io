## LLVM介绍

LLVM的命名最早起源于底层语言虚拟机（Low Level Virtual Machine）的缩写 。它是一个用于建立编译器的基础框架，以C++编写。创建此工程的目的是对于任意汇编语言，利用该基础框架，构建一个包括编译时、链接时、执行时等的语言执行器。目前官方的LLVM只支持处理C/C++，Objective-C三种语言，当然的也有的一些非官方的扩展，使其支持ActionScript、Ada、D语言、Fortran、GLSL、HaskKell、Java bytecode、Objective-C、Python、Ruby、Rust、Scala以及C#。

传统的静态编译器分为三个阶段：前端、中端（优化）、后端，LLVM 也不例外，只是 LLVM 实现了一种**与源编程语言和目标机器架构无关的通用中间表示——LLVM IR**， 这样如果支持一种新的编程语言只需重新实现一个前端，支持一种新的目标架构只需重新实现一个后端，前端和后端的链接枢纽就是**LLVM IR**

![image-01](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2021071801.jpg)



## LLVM项目编译部署

一开始我只是想使用 **Clang** 编译器，但是又不想直接通过 **apt-get** （Ubuntu 20.04）的方式安装，所以尝试编译项目源码。

源码下载地址，这里我们直接选择 [llvm-project](https://github.com/llvm/llvm-project)，因为这个项目不经包含llvm项目还有包含其他子项目（clang也在其中）。再编译之前要确保系统已经下载一下 `gcc  g++  make  cmake  python3`



- 首先 `cd  llvm-project` 

- 在当前目录执行 `cmake -S llvm -B build -G <generator> [options]`，

  `generator` 选项如下：

  - `Ninja`
  - `Unix Makefiles`
  - `Visual Studio`
  - `Xcode`

  这里我们选择 `"Unix Makefiles"`

  

	比较常用的编译选项：

  - `-DLLVM_ENABLE_PROJECTS='...'` 选择需要编译的子项目，例如：clang, clang-tools-extra, libcxx, libcxxabi, libunwind, lldb, compiler-rt, lld, polly, or cross-project-tests.
  - `-DCMAKE_INSTALL_PREFIX=directory` 项目编译好后的下载目录，默认是 `/usr/local` 
  - `-DCMAKE_BUILD_TYPE=type` 编译类型，例如  Debug, Release, RelWithDebInfo, MinSizeRel。默认是Debug模式
  - `-DLLVM_ENABLE_ASSERTIONS=On` 编译是否断言检测（Debug模式下默认开启，其他编译默认关闭）



​	我在编译的时候，命令执行如下：

```shell
cmake -S llvm -B build -G "Unix Makefiles" -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;libcxx;libcxxabi;libunwind;lldb;compiler-rt;lld;polly" -DCMAKE_INSTALL_PREFIX="/usr/local/llvm-tool" -DCMAKE_BUILD_TYPE="Release"

cmake --build build
```

编译的时间非常漫长，我碰到过最长的编译时间了。看网上博客说有可能在编译的时候出现的内存不足的问题，如果你是用虚拟机进行编译可以扩大虚拟机内存。第一次编译的时候我遇到的一个 python 的模块缺失，下载补全模块就好。

编译完成后，到 `llvm-project` 的 `build`目录，执行 `make install` 命令后，llvm 的相关工具便会部署到之前cmake 指定的目录了！



## 参考：

① http://www.nagain.com/activity/article/4/

② https://zhuanlan.zhihu.com/p/102250532

③ https://github.com/llvm/llvm-project/blob/main/README.md