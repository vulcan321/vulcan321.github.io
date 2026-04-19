宏定义 ’**#**‘ 和 ’**##**‘ 的使用说明: '**#**' 用于将代码转换成字符串; '**##**' 用于拼接代码; 使用范例:

```c++
#include <iostream>

#define PrintCode(x) #x
#define INT_TYPE(x) int##x##_t

int main(int argc, char *argv[])
{
    std::cout << PrintCode(int) << std::endl;    // 输出: int
    INT_TYPE(64) a;
    std::cout << sizeof(a) << std::endl;    // 输出 8 因为 a是 int64_t
    return 0;
}
```

2. 预处理指令

```c
#if FALSE    // 相当于 C语言中 if

#elif TRUE    // 相当于 C语言中 else if

#else        // 相当于 C语言中 else

#endif
```

3. C/C++ 不使用结构体字节对齐

```C++
/*减小内存占用的空间；结构体默认进行对齐，占用的空间比结构体内部成员变量字节加起来大，如果取消字节对齐，可以减小一部分空间。见下面具体例子。

直接将结构体作为通信协议（在低带宽下通讯）；在不同的平台下，保证结构体内基本数据的长度相同，同时取消结构体的对齐，就可以将定义的数据格式结构体直接作为数据通信协议使用。*/
#pragma pack (n)  // 编译器将按照n个字节对齐；
#pragma pack()   // 恢复先前的pack设置,取消设置的字节对齐方式
#pragma  pack(pop)// 恢复先前的pack设置,取消设置的字节对齐方式
#pragma  pack(1)  // 按1字节进行对齐 即：不行进行对齐
```

4. GUN C 允许声明长度为0的数组，零长度数组可用作结构的最后一个元素，该结构实际上是可变长度对象的标头，内存分配如下：

```c
struct line {
  int length;
  char contents[0];
};

struct line *thisline = (struct line *)malloc (sizeof (struct line) + this_length * sizeof(char));
thisline->length = this_length;
```

5. typedef 的前置声明：

```cpp
// a.h
class object
{
    ...
};
struct myStruct
{
    ...
};
typedef object defMyObject;
typedef myStruct defMyStruct;
```

```cpp
// b.h
typedef class object defMyObject;
typedef struct myStruct defMyStruct;
```

或者：

```cpp
// b.h
class object;
typedef object defMyObject;
struct myStruct;
typedef myStruct defMyStruct;
```

6. 将文件内容全部读出（包括回车符）

```c++
std::string Read_Image(const std::string &_csImagePath)
{
    std::ifstream file(_csImagePath.c_str(), std::ios::in);
    int iBufSize = 0;
    std::string sFileContent = "";
    char letter;
    if (file.is_open())
    {
        std::string sContent;
        while (file.get(letter))
        {
            iBufSize += 1;
            sFileContent += letter;
        }
    }
    return sFileContent;
}
```

7. Windows平台`运行时库`各选项说明

```text
/MD    使此应用程序使用特定于多线程和 DLL 的运行库版本。 定义 _MT 和 _DLL，并使编译器将库名 MSVCRT.lib 放入 .obj 文件中。
    用此选项编译的应用程序静态链接到 MSVCRT.lib。 此库提供使链接器能够解析外部引用的代码的层。 实际工作代码包含在 
    MSVCR versionnumber.DLL，该代码必须可运行时提供给与 MSVCRT.lib 链接的应用程序。


/MDd    定义 _DEBUG、_MT 和 _DLL，并使此应用程序使用特定于多线程和 DLL 的调试版本的运行库。 它还会让编译器将库 
        MSVCRTD.lib 放入 .obj 文件中。


/MT    使此应用程序使用运行库的多线程的静态版本。 定义 _MT，并使编译器将库名 LIBCMT.lib 放入 .obj 文件中，以便链接器                 LIBCMT.lib 解析外部符号。


/MTd    定义 _DEBUG 和 _MT。 此选项还会让编译器将库名称 LIBCMTD.lib 放置到 .obj 文件中，以便链接器将使用 LIBCMTD.lib 来            解析外部符号。

/LD    创建一个 DLL。将 /DLL 选项传递给链接器。 链接器查找 DllMain 函数，但并不需要该函数。 如果没有编写 DllMain 函数，则链接      器将插入返回 TRUE 的 DllMain 函数。链接 DLL 启动代码。如果未在命令行上指定导出 (.exp) 文件，则创建导入库 (.lib)。 将导       入库链接到调用 DLL 的应用程序。将 /Fe (NAME EXE) 解释为命名 DLL，而不是.exe文件。 默认情况下，程序名称变
    basename.dll 而不是 basename.exe。
    表示 /MT， 除非显式指定 /MD。

/LDd    创建调试 DLL。 定义 _MT 和 _DEBUG。
```

Windows平台的单线程和多线程运行库的区别在于，以前系统库有分只能用于单线程应用程序的库和可以跑在多线程模式下的库，所以在连接的时候需要指定单线程还是多线程。目前单线程选项已经弃用。

8. **虽然C++的编译器对变量有默认的初始化（默认都是初始化0），但是在声明变量的时候一定要显式地赋值，这并不代表不赋值会造成编译或者运行错误，而是这是一个良好的习惯，帮助你注意到每一个变量，注意结构体中每一个成员变量！！！**

9. `lambda`按值默认捕获 `[=]` 变量捕获只能针对于在创建`lambda`式的作用域内可见的非静态局部变量（包括形参）；静态变量对与lambda本身就是不用捕获就可以访问，所以如果只是想捕获其当前值，需要明确写出拷贝并且按值捕获这个拷贝，代码如下：

```cpp
// C++11
static int g_state = 1;
auto iState = g_state;
filters.emplace_back([iState](int value) {
    return value % g_state;
});

// C++14 起的写法
static int g_state = 1;
filters.emplace_back([g_state = g_state](int value) {
    return value % g_state;
});
```

10. `lambda` 使用初始化捕获将对象移入闭包

```cpp
// C++11 此处将局部变量使用移动构造，移入到匿名函数中，节省了拷贝开销, 实际上 C++14 中lambda可以全面替代std::bind
std::vector<int> data = { ... };
auto func = std::bind([](const std::vector<int>& data) { ... }, std::move(data));

// C++14起
std::vector<int> data = { ... };
auto func = [data = std::move(data)]() {
        ...
};
```

11. **SDL**库中**SDL_Event**是一个很精妙的联合结构（**union**）, 众所周知，**union**（联合）同时只能初始化一个成员。但是在使用过程中，我们却可以同时访问它的 **type** 成员 和 其他一个事件结构体。代码如下：

```c
SDL_Event user_event;

user_event.type = SDL_USEREVENT;
user_event.user.code = 2;
user_event.user.data1 = NULL;
user_event.user.data2 = NULL;
SDL_PushEvent(&user_event);
```

​    可以这样做的原因是因为 **SDL_Event** 其他事件结构体都统一的将第一个成员声明为 **Uint32 type** ,  这样直接访问 **SDL_Event.type** 就可以访问到对应事件结构体的 **type** 成员。其他的事件结构体例如：

```c
/**
 *  \brief Keyboard button event structure (event.key.*)
 */
typedef struct SDL_KeyboardEvent
{
    Uint32 type;        /**< ::SDL_KEYDOWN or ::SDL_KEYUP */
    Uint32 timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    Uint32 windowID;    /**< The window with keyboard focus, if any */
    Uint8 state;        /**< ::SDL_PRESSED or ::SDL_RELEASED */
    Uint8 repeat;       /**< Non-zero if this is a key repeat */
    Uint8 padding2;
    Uint8 padding3;
    SDL_Keysym keysym;  /**< The key that was pressed or released */
} SDL_KeyboardEvent;

/**
 *  \brief Mouse motion event structure (event.motion.*)
 */
typedef struct SDL_MouseMotionEvent
{
    Uint32 type;        /**< ::SDL_MOUSEMOTION */
    Uint32 timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    Uint32 windowID;    /**< The window with mouse focus, if any */
    Uint32 which;       /**< The mouse instance id, or SDL_TOUCH_MOUSEID */
    Uint32 state;       /**< The current button state */
    Sint32 x;           /**< X coordinate, relative to window */
    Sint32 y;           /**< Y coordinate, relative to window */
    Sint32 xrel;        /**< The relative motion in the X direction */
    Sint32 yrel;        /**< The relative motion in the Y direction */
} SDL_MouseMotionEvent;

// SDL_Event 结构如下
typedef union SDL_Event
{
    Uint32 type;                            /**< Event type, shared with all events */
    SDL_CommonEvent common;                 /**< Common event data */
    SDL_DisplayEvent display;               /**< Display event data */
    ...;
    Uint8 padding[sizeof(void *) <= 8 ? 56 : sizeof(void *) == 16 ? 64 : 3 * sizeof(void *)];
} SDL_Event;
```

12. ​    MinGW 编译windows 静态库参数：

```shell
-static -static-libgcc -static-libstdc++
```

13. MSVC 编译器编译的程序 依赖 MSVCXXX.dll 等 Windows 系统运行库.  如果不想依赖, `代码生成` 选项使用 `\MT`.  CMake 构建下添加如下脚本:

```cmake
set_property(TARGET d3d9_render PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
```

14. std::string 与 std::wstring 相互转换.   [参考链接](https://docs.microsoft.com/en-us/cpp/text/how-to-convert-between-various-string-types?redirectedfrom=MSDN&view=msvc-170)

15. `CMake` 在使用 `MSVC`编译器时, 使用 `utf-8`编码格式

```cmake
if (MSVC)
    add_compile_options("$<$<C_COMPILER_ID:MSVC>:/source-charset:utf-8>")
    add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/source-charset:utf-8>")
endif()
```

 

16. Linux 编译链接三方库时，需要警惕系统库里是否同样有这个库，如果存在可能会导致在程序编译的时候真正链接的是系统路径的库而不是那我们真正想要的库。比较直接的链接方式是：使用 ldd 命令查看程序依赖那些动态库
    
    

 17. CMake 添加 WinMain 作为程序入口, 需要在 add_executable 命令中加入 WIN32 命令



18.  windows 系统下使用命令行 `cmd` 启动 `win32` 程序， 可以使用以下代码使程序的输入输出重定向到父程序也就是 `cmd` 的输入输出.

```cpp
AttachConsole(ATTACH_PARENT_PROCESS); // 将当前程序附着到父进程上，因为是从控制台启动的，所以当前程序的父进程就是那个控制台。 
freopen("CONIN$", "r+t", stdin); // 重定向 STDIN 
freopen("CONOUT$", "w+t", stdout); // 重定向STDOUT
```
