# Could not resolve SDK --show-sdk-path for 'macosx'


mac 上安装QT后加载项目只能看到.pro的文件，看QT上的“问题”栏提示 “Could not resolve SDK --show-sdk-path for 'macosx'”。

在网上查了好多文章都不能解决，网上主要的解决方法如下：

1\. 进入到如下目录/Users/apple/Qt5.9.9/5.9.9/clang\_64/mkspecs 找到 qdevice.pri 文件，添加 !host\_build:QMAKE\_MAC\_SDK = macosx11.1 即可，其中 “macosx11.1”是系统的版本号。【实测添加后部分用户可能会正常】

2.在终端执行：sudo xcode-select -s /Applications/Xcode.app/Contents/Developer 【实测对部分用户可行】

3.卸载QT重新安装【出这种方法的人不太适合编程，12个G的程序重新安装，只为这一个配置异常，想想也不可能，乔帮主设计的系统怎么可能这么智障】

以上两种方法都没有解决我的问题，结合上述两种方法，再根据我的mac目前的情况，发现我的qdevice.pri文件中少内容

细心的同学可能已经发现问题了，第三行GCC\_MACHINE\_DUMP = 后面没有内容，可能原因是我先安装的QT才安装的Xcode 导致其安装过程中的一些常量信息无法获取到，它就空在那里了。所以我猜测把第三行的信息补全后应该就正常了，第三行完整信息：GCC\_MACHINE\_DUMP = x86\_64-apple-darwin12.5.0

补完之后保存，再执行sudo xcode-select -s /Applications/Xcode.app/Contents/Developer ，OK 一切正常了。

最后把完整的qdevice.pri 内容贴出来供大家参考

QMAKE\_APPLE\_DEVICE\_ARCHS = x86\_64

QMAKE\_MAC\_SDK = macosx

GCC\_MACHINE\_DUMP = x86\_64-apple-darwin12.5.0

!host\_build:QMAKE\_MAC\_SDK = macosx11.1

  

关于macosx11.1 哪里获取的问题，我建议大家在终端里获取，因为终端获取到的信息是确保真实可用的，终端执行：xcodebuild -showsdks