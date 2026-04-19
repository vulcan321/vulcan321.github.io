### meson是什么

[Meson](https://mesonbuild.com/)是一个开源构建系统，旨在构建速度快和用户友好。



### 特点

- 对多个平台支持，例如：**Linux**、**macOS**、**Windows**、**GCC**、**Clang**、**Visual Studio**等等
- 支持语言包括**C**、**C++**、**D**、**Fortran**、**Java**、**Rust**
- 在一个很好的可读性和用户友好的非图灵完备**DSL**(**domain-specific language** 特定领域的语言)中构建定义
- 可以在许多操作系统以及裸机交叉编译
- 针对极快的完整和增量构建进行了优化，而不牺牲正确性 —— （原文）**optimized for extremely fast full and incremental builds without sacrificing correctness**
- 内置的多平台依赖项提供程序，可与发行版软件包协同工作
- 比较有意思…



### 编译指令

```shell
$ cd /your-project-path/
$ meson builddir && cd builddir
$ meson compile
$ meson test
# 该命令是在工程目录下执行的，并非在工程目录下的编译目录执行的
$ DESTDIR=/your-project-path/root meson install -C ./builddir
```



VSCode配置meson构建项目





参考：

- https://mesonbuild.com/

