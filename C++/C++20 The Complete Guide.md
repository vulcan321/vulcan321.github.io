

8.5 十六进制浮点数字面量
```cpp
#include <iostream>
#include <iomanip>
int main()
{
    // 初 始 化 浮 点 数
    std::initializer_list<double> values {
        0x1p4, // 16
        0xA, // 10
        0xAp2, // 40
        5e0, // 5
        0x1.4p+2, // 5
        1e5, // 100000
        0x1.86Ap+16, // 100000
        0xC.68p+2, // 49.625
    };
    // 分 别 以 十 进 制 和 十 六 进 制 打 印 出 值：
    for (double d : values) {
        std::cout << "dec: " << std::setw(6) << std::defaultfloat << d
        << " hex: " << std::hexfloat << d << '\n';
    }
}
```
8.6 UTF-8 字符字面量
自从 C++11 起， C++ 就已经支持以 u8 为前缀的 UTF-8 字符串字面量。
```cpp
auto c = u8'6'; // UTF‐8编 码 的 字 符6
```
在 C++17 中， u8'6'的类型是 char，在 C++20 中可能会变为 char8_t，因此这里使用 auto会更好一些。

字符和字符串字面量现在接受如下前缀：
• u8 用于单字节 US-ASCII 和 UTF-8 编码
• u 用于两字节的 UTF-16 编码
• U 用于四字节的 UTF-32 编码
• L 用于没有明确编码的宽字符，可能是两个或者四个字节


8.7 异常声明作为类型的一部分

自从C++17之后，异常处理声明变成了函数类型的一部分。也就是说，如下的两个函数的类型是不同的：
```cpp
void fMightThrow();
void fNoexcept() noexcept; //不同类型
```
重载一个签名完全相同只有异常声明不同的函数是不允许的（就像不允许重载只有返回值不同的函数一样）：
```cpp
void f3();
void f3() noexcept; // ERROR
```
能忽略基类中的noexcept声明：
```cpp
class Base {
public:
virtual void foo() noexcept;
...
};
class Derived : public Base {
public:
void foo() override; // ERROR：不能重载
...
};
```

对于标准库类型特
征std::is_function<>的定义，主模板的定义如下，该模板用于匹配T不是函数的情况：
//主模板（匹配泛型类型T不是函数的情况） ：

```cpp
template<typename T> struct is_function : std::false_type { };
```

该模板从std::false_type派生，因此is_function<T>::value对任何类型T都会返回false。
对于任何是函数的类型，存在从std::true_type派生的部分特化版，因此成员value总是返回true：

```cpp
//对所有函数类型的部分特化版

template<typename Ret, typename... Params>
struct is_function<Ret (Params...)> : std::true_type { };
template<typename Ret, typename... Params>
struct is_function<Ret (Params...) const> : std::true_type { };
template<typename Ret, typename... Params>
struct is_function<Ret (Params...) &> : std::true_type { };
template<typename Ret, typename... Params>
struct is_function<Ret (Params...) const &> : std::true_type { };
...
```

在C++17之前该特征总共有24个部分特化版本：因为函数类型可以用const和volatile修饰符修饰，另外还
可能有左值引用(&)或右值引用(&&)修饰符，还需要重载可变参数列表的版本。
现在在C++17中部分特化版本的数量变为了两倍，因为还需要为所有版本添加一个带noexcept修饰符的版
本：

```cpp

//对所有带有noexcept声明的函数类型的部分特化版本
template<typename Ret, typename... Params>
struct is_function<Ret (Params...) noexcept> : std::true_type { };
template<typename Ret, typename... Params>
struct is_function<Ret (Params...) const noexcept> : std::true_type { };
template<typename Ret, typename... Params>
struct is_function<Ret (Params...) & noexcept> : std::true_type { };

template<typename Ret, typename... Params>
struct is_function<Ret (Params...) const & noexcept> : std::true_type { };

```


那些没有实现noexcept重载的库可能在需要使用带有noexcept的函数的场景中不能通过编译了。

8.8 单参数 static_assert
自从 C++17 起，以前 static_assert()要求的用作错误信息的参数变为可选的了。

```cpp
#include <type_traits>
template<typename t>
class C {
// 自从C++11起OK
static_assert(std::is_default_constructible<T>::value,
"class C: elements must be default‐constructible");
// 自从C++17起OK
static_assert(std::is_default_constructible_v<T>);
...
};
```

不带错误信息参数的新版本静态断言的示例也使用了类型特征后缀 _v。

8.9 预处理条件__has_include
C++17扩展了预处理，增加了一个检查某个头文件是否可以被包含的宏。例如：

```cpp
#if __has_include(<filesystem>)
# include <filesystem>
# define HAS_FILESYSTEM 1
#elif __has_include(<experimental/filesystem>)
# include <experimental/filesystem>
# define HAS_FILESYSTEM 1
# define FILESYSTEM_IS_EXPERIMENTAL 1
#elif __has_include("filesystem.hpp")
# include "filesystem.hpp"
# define HAS_FILESYSTEM 1
# define FILESYSTEM_IS_EXPERIMENTAL 1
#else
# define HAS_FILESYSTEM 0
#endif
```

当相应的#include指令有效时__has_include(...)会被求值为1。  

