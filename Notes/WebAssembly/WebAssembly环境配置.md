## WebAssembly 介绍

WebAssembly（缩写为 Wasm）是一种用于基于堆栈的虚拟机的二进制指令格式。 Wasm 被设计为编程语言的可移植编译目标，支持在 Web 上部署客户端和服务器应用程序。简单来说就是可以将C/C++/Rust等语言编写的程序运行在浏览器上，这种技术有些类似于以前ActiveX等各种浏览器插件技术，所不同是 Wasm 被现在各种浏览器厂商所支持！



## Windows环境下，Qt配置WebAssembly

目前 **Qt5.15.2** 版本支持 **WebAssembly** 编译！但在我配置的时候遇到了一些问题，步骤如下：

- 首先在下载**Qt**时，选择版本 **5.15.2**，需要勾选 **WebAssembly**编译器，如下图：

  ![image-01](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2021071401.png)



- 当然因为缺少 [emscriptem][https://emscripten.org/]  导致 **Qt**的 **WebAssembly** 不可用。[emscriptem][https://emscripten.org/] 是一个WebAssembly编译器工具链，它是使用LLVM，注重速度、大小和web平台。通过**git** 或者直接访问**github**下载源码，在配置之前我们需要下载 **python** 来运行**emscripten**配置脚本。然后根据   [emscripten download][https://emscripten.org/docs/getting_started/downloads.html] 下载说明进行配置。 注意 Qt 5.15.2的 **WebAssembly**编译器是需要下载 emsdk 1.39.8，

  如下图：

  ![image-02](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2021071402.png)

- 配置好**emscriptem**后，打开**QtCreator**发现 **Qt 5.15.2 WebAssembly**依然是**error**状态如图:

![image-03](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2021071403.png)

​	之前浏览别人博客，有人说要把**emsdk** 文件中 **.emscripten** 文件替换到用户目录下，以便**QtCreator** 可以找到**emsdk**的编译器。但 是我试过之后没有效果。后面询问过朋友之后，发现通过在设备中添加 **emsdk** 的路径可以解决这个问题（朋友万岁！！！），如图：

![image-04](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2021071404.png)

配置好设备之后重启一下**QtCreator**，应该就可以使用 **Qt 5.15.2 WebAssembly** 编译器了。



## 跑在浏览器上的C++ Qt 程序

使用 **Qt WebAssembly** 进行编译后默认使用IE浏览器呈现效果，但是IE并不支持 **WebAssembly** ，可以用**Chrome**、**Edge**等浏览器查看效果！



## 参考

> 1. https://cloud.tencent.com/developer/news/690454
> 2. https://blog.csdn.net/feiyangqingyun/article/details/112986837