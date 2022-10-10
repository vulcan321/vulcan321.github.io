### QT加载静态链接库（.Lib，.a，.os）,以及关于LIBS +=的用法

-   -   [.pro 文件中写入](https://blog.csdn.net/weixin_42156552/article/details/121871417#pro__4)
    -   -   -   [在前面加上 Release： 或 Debug: 的区别](https://blog.csdn.net/weixin_42156552/article/details/121871417#__Release___Debug__18)
            -   [LIBS+= 与 LIBPATH +=](https://blog.csdn.net/weixin_42156552/article/details/121871417#LIBS____LIBPATH__26)
        -   [库路径](https://blog.csdn.net/weixin_42156552/article/details/121871417#_35)
        -   -   [QT内的特殊表示](https://blog.csdn.net/weixin_42156552/article/details/121871417#QT_45)
            -   [不同操作系统下的静态库](https://blog.csdn.net/weixin_42156552/article/details/121871417#_75)
        -   [库文件](https://blog.csdn.net/weixin_42156552/article/details/121871417#_86)
    -   [添加.h文件进入项目](https://blog.csdn.net/weixin_42156552/article/details/121871417#h_130)
    -   -   -   [添加头文件（或者直接通过右键添加现有文件就好了）](https://blog.csdn.net/weixin_42156552/article/details/121871417#_133)

以下内容由本人收集资料重新编辑的内容

## .pro 文件中写入

_**需要在项目的 .pro 文件中写入加载lib，并且要添加相应的 .h文件进入项目,并引用**_

核心是 _LIBS+=_

书写格式：LIBS+= -L直接打地址（库路径） -l库文件（去除后缀）

代码如下（示例）：

```javascript
// 需要在项目的 .pro 文件中写入 加载lib,有多种写法
 LIBS += -L. -limm32 -luser32
 LIBS += -L$$PWD/./ -limm32 -luser32    
```

#### 在前面加上 Release： 或 Debug: 的区别

分别让程序在不同的情况下调用不同的DLL  
代码如下（示例）：

```javascript
Release：LIBS+=-L  folderPath // release 版引入的lib文件路径
Debug:   LIBS+= -L folderPath // Debug 版引入的lib文件路径
```

#### LIBS+= 与 LIBPATH +=

看到网上有人说另外一种用法

_**LIBS+=**_ 指明lib文件的名称，  
_**LIBPATH +=**_ 指明lib文件的路径。最后还要把DLL文件复制到exe所在路径(或者system32)

___

### 库路径

\-L. - - -**表示 .pro所在目录**

\-L$$_PRO\_FILE\_PWD_/ - - -**表示 .pro所在目录**

\-L$$PWD/ - - - **表示 .pro所在目录**

\-LC:/abc/ - - -**表示C:/abc/**

#### QT内的特殊表示

**PWD**  
指的是当前正在解析的.pro文件的目录的完整路径。 在编写支持影子构建的项目文件时，PWD很有用。  
代码如下（示例）：

```cpp
LIBS += -L$$PWD/.......
```

**OUT\_PWD**  
指的是qmake生成的Makefile的目录的完整路径。即构建目录，例如build-??-Desktop\_Qt\_5\_12\_8\_MSVC2017\_64bit-Debug

```cpp
LIBS += -L$$OUT_PWD/.......
```

**_PRO\_FILE_**  
正在使用的项目文件的路径。

```cpp
LIBS += -L$$_PRO_FILE_/......
```

**_PRO\_FILE\_PWD_**  
包含目录的路径，该目录包含正在使用的项目文件。

```cpp
LIBS += -L$$_PRO_FILE_PWD_/....
```

#### 不同操作系统下的静态库

linux：LIBS += your\_lib\_path/your\_lib动态库  
linux：LIBS += -L your\_lib\_path -lyour\_lib//经过测试了  
win32：LIBS += your\_lib\_path/your\_lib  
例如：  
LIBS += -L lib/pcsc/ -lpcsclite  
LIBS += lib/pcsc/libpcsclite.a

___

### 库文件

需要另外加库的程序最好单独建一个文件夹放置

**1\. 不加-l时，需要写库文件全名(不推荐)**  
代码如下（示例）：

```javascript
LIBS += -L$$PWD/lib VideoDecoder.lib

LIBS += -L$$PWD/lib libVideoDecoder.a
```

**2\. 加 -l 时，可以将不同编译器库文件名差异屏蔽掉**

```javascript
假设链接msvc库，则只需要去掉文件后缀（一般是.lib）：
LIBS += -L$$PWD/lib -lVideoDecoder
假设链接mingw/gcc库，则需要去掉文件前缀"lib"，和后缀（一般是.a）：
LIBS += -L$$PWD/lib -lVideoDecoder
```

这样不管在哪个编译器下，都能保证命令一致。

注意：  
请牢记msvc库只去后缀  
mingw库去前缀和后缀。  
因为我遇到一个问题，使用msvc编译工程，工程中调用了boost线程库，boost使用msvc编译为静态库，这个静态线程库的名字比较坑“libboost\_thread-vc141-mt-gd-x64-1\_71.lib”，按照我们一贯的想法，肯定是去掉前lib，去掉后缀.lib，像这样：  
**LIBS += -LC:/Boost\_msvc\_static/lib/ -lboost\_thread-vc141-mt-gd-x64-1\_71**  
死活编译不过，找不到库文件。此时，你只要想起来链接msvc库只去后缀，像这样：  
**LIBS += -LC:/Boost\_msvc\_static/lib/ -llibboost\_thread-vc141-mt-gd-x64-1\_71**  
编译就通过了。

**附《msvc、mingw分别编译动态库与静态库文件名区别》：**

msvc动态库：test.dll，test.lib

msvc静态库：test.lib

[mingw](https://so.csdn.net/so/search?q=mingw&spm=1001.2101.3001.7020)动态库：test.dll、libtest.a

mingw静态库：libtest.a

___

## 添加.h文件进入项目

这点应该没什么说的  
添加所对应的 **.h** 文件进入项目，并且在想调用的类里面进行 **#include** （检查是否“ ”与< >错用了）

#### 添加头文件（或者直接通过右键添加现有文件就好了）

INCLUDEPATH += your\_include\_path例如：  
INCLUDEPATH += . /usr/local/include（点号后面有空格）