# [gcc/g++实战之动态链接库与静态链接库编写](https://www.cnblogs.com/zjiaxing/p/5557629.html)

函数库一般分为静态库和动态库两种。

# **静态库:**

是指编译链接时，把库文件的代码全部加入到可执行文件中，因此生成的文件比较大，但在运行时也就不再需要库文件了。其后缀名一般为”.a”。

**动态库:**

与之相反，在编译链接时并没有把库文件的代码加入到可执行文件中，而是在程序执行时由运行时链接文件加载库，这样可以节省系统的开销。动态库一般后缀名为”.so”，gcc/g++在编译时默认使用动态库。无论静态库，还是动态库，都是由.o文件创建的。

# **动态库的编译:**

下面通过一个例子来介绍如何生成一个动态库。建一个头文件：dynamic.h，三个.cpp文件：dynamic\_a.cpp、dynamic\_b.cpp、dynamic\_c.cpp，我们将这几个文件编译成一个动态库：libdynamic.so。

//dynamic.h

[![复制代码](https://www.cnblogs.com//common.cnblogs.com/images/copycode.gif)](javascript:void(0); "复制代码")

```
#ifndef __DYNAMIC_H_
#define __DYNAMIC_H_
#include <iostream>
void dynamic_a();
void dynamic_b();
void dynamic_c();#endif
```

[![复制代码](https://www.cnblogs.com//common.cnblogs.com/images/copycode.gif)](javascript:void(0); "复制代码")

//dynamic\_a.cpp：

```
#include"dynamic.h"
void dynamic_a()
{
  cout<<"this is in dynamic_a "<<endl;
}
```

//dynamic\_b.cpp：

[![复制代码](https://www.cnblogs.com//common.cnblogs.com/images/copycode.gif)](javascript:void(0); "复制代码")

```
#include"dynamic.h"
void dynamic_b()
{
  cout<<"this is in dynamic_b "<<endl;
}
 
```

[![复制代码](https://www.cnblogs.com//common.cnblogs.com/images/copycode.gif)](javascript:void(0); "复制代码")

//dynamic\_c.cpp：

```
#include"dynamic.h"
void dynamic_c()
{
  cout<<"this is in dynamic_c "<<endl;
}
```

将这几个文件编译成动态库libdynamic.so。编译命令如下：

 

```
g++ dynamic_a.cpp dynamic_b.cpp dynamic_c.cpp -fPIC -shared -o libdynamic.so
```

# **参数说明：**

\-shared：该选项指定生成动态连接库

\-fPIC：表示编译为位置独立的代码，不用此选项的话编译后的代码是位置相关的所以动态载入时是通过代码拷贝的方式来满足不同进程的需要，而不能达到真正代码段共享的目的。

在上面的部分，我们已经生成了一个libdynamic.so的动态链接库，现在我们用一个程序来调用这个动态链接库。文件名为：main.cpp

//main.cpp：

[![复制代码](https://www.cnblogs.com//common.cnblogs.com/images/copycode.gif)](javascript:void(0); "复制代码")

```
#include"dynamic.h"
int main()
{
  dynamic_c();
  dynamic_c();
  dynamic_c();
  return 0;
}
```

[![复制代码](https://www.cnblogs.com//common.cnblogs.com/images/copycode.gif)](javascript:void(0); "复制代码")

将main.cpp与libdynamic.so链接成一个可执行文件main。命令如下：

```
g++ main.cpp -L. -ldynamic -o main
```

# **参数说明：**

\-L.：表示要连接的库在当前目录中

\-ldynamic：编译器查找动态连接库时有隐含的命名规则，即在给出的名字前面加上lib，后面加上.so来确定库的名称

测试可执行程序main是否已经链接的动态库libdynamic.so，如果列出了libdynamic.so，那么就说明正常链接了。可以执行以下命令：

```
ldd main
```

![](https://images2015.cnblogs.com/blog/966989/201606/966989-20160603205721117-1980980135.png)

如果运行：

```
./main
```

出现错误： **error while loading shared libraries: libdynamic.so: cannot open shared object file: No such file or directory**

# **错误原因**：

ld提示找不到库文件，而库文件就在当前目录中。

链接器ld默认的目录是/lib和/usr/lib，如果放在其他路径也可以，需要让ld知道库文件在哪里。

# **解决方法：**

## **方法1：**

编辑/etc/ld.so.conf文件，在新的一行中加入库文件所在目录；比如笔者应添加：

/home/neu/code/Dynamic\_library

运行：

```
sudo ldconfig
```

目的是用ldconfig加载，以更新/etc/ld.so.cache文件；

## **方法2：**

在/etc/ld.so.conf.d/目录下新建任何以.conf为后缀的文件，在该文件中加入库文件所在的目录；

运行：

```
sudo ldconfig
```

以更新/etc/ld.so.cache文件；

ld.so.cache的更新是递增式的，就像PATH系统环境变量一样，不是从头重新建立，而是向上累加。除非重新开机，才是从零开始建立ld.so.cache文件。

## **方法3：**

在bashrc或profile文件里用LD\_LIBRARY\_PATH定义，然后用source加载。

## **方法4：**

你可以直接采用在编译链接的时候告诉系统你的库在什么地方

执行main可以看看main是否调用了动态链接库中的函数。

```
./main
```

![](https://images2015.cnblogs.com/blog/966989/201606/966989-20160603210351367-714431487.png)

# **静态库的编译:**

读者可以自己创建代码，笔者比较懒，就以以上代码演示，最好把生成的动态库的东西全部删掉。

**1.编译静态库:**  

```
g++ -c dynamic_a.cpp dynamic_b.cpp dynamic_c.cpp  
```

 **2.使用ar命令创建静态库文件（把目标文档归档）**

```
ar cr libstatic.a dynamic_a.o dynamic_b.o dynamic_c.o  //cr标志告诉ar将object文件封装(archive)
```

**参数说明：**

          d 从指定的静态库文件中删除文件   
          m 把文件移动到指定的静态库文件中   
          p 把静态库文件中指定的文件输出到标准输出   
          q 快速地把文件追加到静态库文件中   
          r 把文件插入到静态库文件中   
          t 显示静态库文件中文件的列表   
          x 从静态库文件中提取文件   
          a 把新的目标文件(\*.o)添加到静态库文件中现有文件之后 

使用nm -s 命令来查看.a文件的内容

```
nm -s libstatic.a 
```

![](https://images2015.cnblogs.com/blog/966989/201606/966989-20160603211303383-591019221.png)

**3.链接静态库**  

```
g++ main.cpp -lstatic -L. -static -o main//这里的-static选项是告诉编译器,hello是静态库也可以用　　　　　　　　　　　　　　　　　　　　　　　　//g++ main.cpp -lstatic -L.  -o main 
```

**执行以下命令，因为笔者还是用的动态库的代码，所以结果一样**

```
./main
```

![](https://images2015.cnblogs.com/blog/966989/201606/966989-20160603211334242-81528379.png)