# QT设置引用路径问题
在Linux中添加动态库路径可以设置LD\_LIBRARY\_PATH路径。如添加`/mylib`动态库路径：

```typescript
export LD_LIBRARY_PATH=/mylib/:$LD_LIBRARY_PATH
```

除了上面方法外，我们还可以使用编译参数`-Wl,-rpath=<动态库路径>`。

`-Wl`为[gcc](https://so.csdn.net/so/search?q=gcc&spm=1001.2101.3001.7020)的参数，表示**「编译器将后面的参数传递给链接器ld」**。 `-rpath`为在运行链接时，会优先搜索-rpath的路径。

-   QMake写法1:

**QMAKE_LFLAGS**为指定传递给链接器的一组常规标志。

```bash
QMAKE_LFLAGS += -Wl,-rpath=/mylib1
```

-   QMake写法2:

**QMAKE\_RPATHDIR**为指定在链接时添加到可执行文件的库路径列表，以便在运行时优先搜索这些路径。

```bash
QMAKE_RPATHDIR += /mylib2
```

QT 中的一般用法：

```bash
QMAKE_RPATHDIR += @executable_path/../Frameworks/ 
QMAKE_RPATHDIR += @loader_path/../Frameworks/  
QMAKE_LFLAGS += -framework IOKit 
QMAKE_LFLAGS += -framework AppKit 
QMAKE_LFLAGS += -framework AVFoundation 
QMAKE_LFLAGS += -framework Foundation  
QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN\''
```

QMAKE_LFLAGS－设置链接器flag参数，会修改Makefile的LFLAGS选项。该参数包含了传递给连接器的一组通用的标记。使用指定的QMAKE_LFLAGS的好处在于，能够根据当前编译的不同配置选择不同路径下的依赖库。

如：QMAKE_LFLAGS += -Wl,-rpath=./sqlite3，这样编译生成的可执行文件依赖的sqlite库就会是./sqlite3

$ORIGIN - 是一个特殊的变量，指示实际的可执行文件名。它在运行时解析到可执行文件的位置，在设置RPATH时非常有用。

# mac osx环境下Qt中动态链接库的制作和使用方法

在shell下用gcc -shared a.c -o 命令无法通过编译，后来在第三方库的源码中有一个使用文档，说明了安装方法，也就是生成自己平台的链接库。
先将工作目录设置到源码目录，然后`./configure`，这个命令是检查安装环境的，应该是检查依赖库的，没有通过，查了一下用`./configure --without-tools`通过，然后`make`，`make install`，大功告成，在local文件夹下生成了.dylib文件，将文件复制到项目目录下，在.pro文件中添加`#LIBS+= -L"$$PWD/" -llibqrencode`提示找不到文件，查阅资料无果，使用绝对路径试试`LIBS+= "$$PWD/libqrencode.dylib"`编译通过，成功运行。

1. c++中直接调用c的方法
2. configuere的作用和使用方法
3. linux 下编译很多个文件和生成库或程序的方法
4. includepath和dependpath的区别，libs的写法
5. qt下生成动态链接库的方法