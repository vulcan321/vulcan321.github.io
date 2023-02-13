MacOS 从10.13升级到 10.14后，原Qt项目编译运行出现以下问题：

no such sysroot directory:

'/Applications/[Xcode](https://so.csdn.net/so/search?q=Xcode&spm=1001.2101.3001.7020).app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk' \[-Wmissing-sysroot\]

【解决办法】

⁨1、 在安装目录： ▸ ⁨Qt5.11.1⁩ ▸ ⁨5.11.1⁩ ▸ ⁨clang\_64⁩ ▸ ⁨mkspecs⁩  下找到文件：qdevice.pri

打开后，把此行：

```html
QMAKE_MAC_SDK = macosx
```

改为：

```html
QMAKE_MAC_SDK = macosx10.14
```

记得保存。

2、Qt5 中清理项目、构建项目；

3、项目正常通过。