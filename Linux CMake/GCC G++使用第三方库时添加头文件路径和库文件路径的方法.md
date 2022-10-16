本文总结了使用第三方库函数时将其路径告诉编译器（gcc和g++同理）的2种常用方式，并举例说明了每种方式的具体用法。

 

方法一：在编译自己的项目时添加-L和-I编译选项

1）添加头文件路径：

-I   #指明头文件的路径

2）添加库文件路径：

-L   #指定目录。link的时候，去找的目录。gcc会先从-L指定的目录去找，然后才查找默认路径。（告诉gcc,-l库名最可能在这个目录下）。

-l   #指定文件（库名），linking options

注：-l紧接着就是库名，这里的库名不是真正的库文件名。比如说数学库，它的库名是m，他的库文件名是libm.so。再比如说matlab eigen库，它的库名是eng，它的库文件名是libeng.so。很容易总结得：把库文件名的头lib和尾.so去掉就是库名了。在使用时，“-leng”就告诉gcc在链接阶段引用共享函数库libeng.so。

 

方法二：将库路径添加到环境变量

1）添加头文件路径：

在/etc/profile中添加（根据语言不同，任选其一）：

```
export C_INCLUDE_PATH=C_INCLUDE_PATH:头文件路径               	#c
export CPLUS_INCLUDE_PATH=CPLUS_INCLUDE_PATH:头文件路径     		#c++
export OBJC_INCLUDE_PATH=OBJC_INCLUDE_PATH:头文件路径        	#java
```

终端重启后需执行一次source。

另有一种方法：在/etc/ld.so.conf文件中加入自定义的lib库的路径，然后执行sudo /sbin/ldconfig，这个方法对所有终端有效。

2）添加库文件路径：

```
LIBRARY_PATH   
#used by gcc before compilation to search for directories containing libraries that need to be linked to your program.

LD_LIBRARY_PATH
#used by your program to search for directories containing the libraries after it has been successfully compiled and linked.
```

例如：

```
MATLAB=/opt/MATLAB/R2012a

export LIBRARY_PATH=$LIBRARY_PATH:$MATLAB/bin/glnxa64

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MATLAB/bin/glnxa64
```

题外话，顺便提一下LIBRARY_PATH和LD_LIBRARY_PATH的区别：

我们知道Linux下有2种库：static libraries和shared libraries。如（这里）阐述的，静态库是在编译期间会被链接并拷贝到你的程序中，因此运行时不再需要该静态库。动态库在编译时并不会被拷贝到你的程序中，而是在程序运行时才被载入，因此在程序运行时还需要动态库存在，这时就会用到LD_LIBRARY_PATH指定的路径去查找这个动态库。

The libraries can be static or shared. If it is static then the code is copied over into your program and you don't need to search for the library after your program is compiled and linked. If your library is shared then it needs to be dynamically linked to your program and that's when LD_LIBRARY_PATH comes into play.

 

举例说明以上2种方法的具体用法：

假设随便一个简单的函数叫做matlab_eigen.cpp，它用到第三方库（matlab eigen函数），内容如下：

[cpp] view plain  copy

```C++
/* 
 * matlab_eigen.cpp 
 * 
 * This is an example of how to create a surface contour plot in MATLAB 
 * http://cn.mathworks.com/matlabcentral/fileexchange/35311-matlab-plot-gallery-surface-contour-plot/content/html/Surface_Contour_Plot.html 
*/  
  
#include <iostream>  
#include <math.h>  
#include "engine.h"  
  
int main() {  
  
    Engine *ep; //定义Matlab引擎指针。  
    if (!(ep=engOpen("\0"))) //测试是否启动Matlab引擎成功。  
    {  
        std::cout<< "Can't start MATLAB engine"<<std::endl;  
        return EXIT_FAILURE;  
    }  
  
    // 向matlab发送命令。在matlab内部自己去产生即将绘制的曲线上的数据。  
    // Create a grid of x and y data  
    engEvalString(ep, "y = -10:0.5:10;x = -10:0.5:10; [X, Y] = meshgrid(x, y);");  
  
    // Create the function values for Z = f(X,Y)  
    engEvalString(ep, "Z = sin(sqrt(X.^2+Y.^2)) ./ sqrt(X.^2+Y.^2);");  
  
    // Create a surface contour plor using the surfc function, Adjust the view angle  
    engEvalString(ep, "figure;surfc(X, Y, Z); view(-38, 18);");  
  
    // Add title and axis labels  
    engEvalString(ep, "title('Normal Response');xlabel('x');ylabel('y');zlabel('z')");  
  
    //Use cin.get() to make sure that we pause long enough to be able to see the plot.  
    std::cout<<"Hit any key to exit!"<<std::endl;  
    std::cin.get();  
  
    return EXIT_SUCCESS;  
}  
```

用方法一编译：

```
$ g++ matlab_eigen.cpp -o matlab_eigen -I/opt/MATLAB/R2012a/extern/include -L/opt/MATLAB/R2012a/bin/glnxa64 -leng -lmx
```

 

用方法二编译：

设置环境变量：

```
MATLAB=/opt/MATLAB/R2012a
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MATLAB/bin/glnxa64
export LIBRARY_PATH=$LIBRARY_PATH:$MATLAB/bin/glnxa64
export CPLUS_INCLUDE_PATH=CPLUS_INCLUDE_PATH:$MATLAB/extern/include
```

编译：

```
$ g++ matlab_eigen.cpp -o matlab_eigen -leng -lmx
```

 

运行及结果：(如果你编译过程遇到错误可以参考我这篇文章。)

```
./matlab_eigen
Hit any key to exit!
```

 

 

参考：

http://walkerqt.blog.51cto.com/1310630/1300119

http://stackoverflow.com/questions/4250624/ld-library-path-vs-library-path

http://blog.chinaunix.NET/uid-26980210-id-3365027.html