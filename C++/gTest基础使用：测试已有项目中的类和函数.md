# gtest基础使用02：测试已有项目中的类和函数


### 一、环境信息

1.Visual Studio 2019  
2.Windows 10

### 二、创建待测项目配套的Google Test项目

1.  在VS2019中创建新项目 Practice  
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210311114339625.png)  
    其中的Practice.cpp包含main()函数

```cpp
#include <iostream>
using namespace std;

int main()
{
    cout << "Hello Google Test!\n";
}
```

2.  创建 Practice 配套的 gtest项目  
    （1）文件-新建-项目，打开 创建新项目 窗口  
    （2）选择创建Google Test，然后点击下一步  
    （3）在 配置新项目 窗口，项目名称自定，解决方案选择：添加到解决方案。然后点击创建  
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210311114710816.png)

（4）选择要测试的项目后，点击OK  
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210311114751628.png)

（5）如图所示，已经创建好了 项目Practice 对应的 gtest项目practice\_gtest  
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210311115405526.png)

### 三、测试已有项目中的函数

1.  在已有项目practice中新建文件 factorial.cpp  
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210311115529274.png)  
    factorial.cpp包含函数factorial( )，用于计算正整数的阶乘。注意：这里要加 关键字 inline，否则引用factorial.cpp时会触发fatal error LNK1169: 找到一个或多个多重定义的符号

```cpp
inline int factorial(int n)  
{
if (n <= 1)
return 1;
else
return n * factorial(n - 1);
}
```

2.  在 Practice\_gtest项目—test.cpp中编写 factorial( )函数的单元测试用例。需要注意：  
    (1) #include中需要指明 factorial()所在文件的路径：…/Practice/factorial.cpp （…/ 表示上一层目录， ./ 表示当前路径），否则会找不到 factorial()函数  
    (2) TEST(a, b) 中，a表示测试用例集的名称、b表示a中的一条用例  
    (3) 对于测试用例TEST(a, b)，TEST(a, c) ， b c 命名不能相等，否则会导致测试执行失败

```cpp
#include "pch.h"
#include "../Practice/factorial.cpp"

TEST(factorialFucTest, BelowZero) 
{
EXPECT_EQ(1, factorial(-3)); //预期是1，实际结果为1
}

TEST(factorialFucTest, Zero)
{
EXPECT_FALSE(factorial(0)); //预期是0，实际结果是1 
}

TEST(factorialFucTest,BeyondZero )
{
EXPECT_EQ(2, factorial(2)); //预期是2，实际结果是2 
ASSERT_EQ(4, factorial(3)); //预期是4，实际结果是6 
EXPECT_EQ(2, factorial(4)); //预期是2，实际结果是24 
}
```

3.  运行单元测试用例：测试–测试资源管理器 或者 视图–测试资源管理器，点击 在视图中运行所有测试用例  
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210311140015808.png)  
    运行结果如下，可以看到与预期是一致的  
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210311142603577.png)  
    由于在测试用例BeyondZero 中使用了ASSERT断言，ASSERT运行失败后，同一用例中，ASSERT后的测试项没有被执行，因此这里只出现了一个报错  
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210311142620794.png)

### 四、测试项目中的类

1.新建类Calc，模拟加减乘除运算  
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210311163725848.png)  
其中：Calc.h

```cpp
class Calc
{
public:
int  Add(int a, int b);
int  Minus(int a, int b);
int  Multi(int a, int b);
float Divide(float a, float b);
};
```

其中：Calc.cpp

```cpp

#include "Calc.h"

int Calc::Add(int a, int b)
{
return a + b;
}

int Calc::Minus(int a, int b)
{
return a - b;
}

int Calc::Multi(int a, int b)
{
return a * b;
}

float Calc::Divide(float a, float b)
{
return a / b;
}
```

2.  在gtest测试工程中新建 ClassCalcTest.cpp，用于测试类Calc

```cpp
#include "pch.h"
#include "../Practice/Calc.h"

Calc calculation;

TEST(CalcClassTest, add)
{
EXPECT_EQ(3,calculation.Add(1, 2));
}

TEST(CalcClassTest, minus)
{
EXPECT_EQ(calculation.Minus(1, 2), -1);
}

TEST(CalcClassTest, multi)
{
EXPECT_EQ(calculation.Multi(1, 2), 2);
}

TEST(CalcClassTest, devide)
{
EXPECT_FLOAT_EQ(calculation.Divide(1, 2),0.5);
}
```

3.  测试类时，需要先设定好对应目标文件的地址，具体步骤如下  
    (1) 进入 测试工程Practice\_gtest的属性设定界面(右键点击项目，在弹出菜单中选择属性)  
    (2) 依次定位到链接器-输入-附加依赖项，点击下拉框，进行编辑  
    (3) 输入类Calc的目标文件 Calc.obj的地址  
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/2021031116462954.png)  
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210311164955154.png)
4.  打开测试资源管理器，执行测试  
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/2021031116534358.png)

### 五、一些疑惑和分析

1.  测试类时，为什么一定要设定目标文件的地址？另外，设定目标文件地址的方法感觉有些低效，是否有更好的办法？
2.  当测试多个类时，需要分别添加对应的obj文件，该场景下不能使用通配符 \* ，否则执行测试时会报错  
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210311170508944.png)

### 六、改进点

1.  通过设置Project之间的依赖，简化头文件的路径描述。以ClassCalcTest.cpp为例

```cpp
#include "pch.h"
//#include "../Practice/Calc.h"   //设置Project之间的依赖前
#include "Calc.h" //设置Project之间的依赖后

Calc calculation;

TEST(CalcClassTest, add)
{
EXPECT_EQ(3,calculation.Add(1, 2));
}
```

2.  设置Project依赖关系的方法  
    (1) 右键点击 Practice\_gtest，选择 属性  
    (2) 在属性页中，依次定位到：配置属性 - C/C++ - 常规 - 附加包含目录，点击下拉框后选择编辑  
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210312113331282.png)  
    (3) 在弹出的附加包含目录窗口中设定依赖关系：输入待测项目的目录地址  
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210312113536340.png)
3.  下图中的include方式需要修改：正确的做法是 include 头文件。因为需要依赖接口(.h头文件)，而不是依赖实现（.cpp文件）  
    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20210312114018238.png)  
    针对问题3的修改过程：

(1) 在 Practice项目 中新建头文件 factorial.h ，内容如下

```cpp
int factorial(int n);
```

(2) factorial.cpp也进行适当调整，包含头文件 factorial.h ，关键字inline 不再需要

```cpp
#include "factorial.h"

int factorial(int n)
{
if (n <= 1)
return 1;
else
return n * factorial(n - 1);
}
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210316100905235.png)  
（3）对应的 Practice\_gtest – test.cpp也进行调整，包含对应的头文件factorial.h

```cpp
#include "pch.h"
//#include "../Practice/factorial.cpp"
#include "factorial.h"

TEST(factorialFucTest, BelowZero) 
{
EXPECT_EQ(1, factorial(-3));
}
```

（4）依次进入Practice\_gtest-属性-链接器-输入-附加依赖项-编辑，添加对应的obj文件  
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210316101351834.png)  
（5）随后通过测试资源管理器运行测试即可  
![在这里插入图片描述](https://img-blog.csdnimg.cn/20210316101952240.png)

