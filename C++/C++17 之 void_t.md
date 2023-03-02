# C++17 之 "void\_t"


-   [使用 void\_t]
-   [void\_t 的工作原理]
-   [一个有趣的例子]

C++ 17 提供了 `void_t`, 它是一个模板别名, 定义为

```cpp
template<class...>
using void_t = void;
```

`void_t` 一般用于元编程. 从定义上看, `void_t` 的定义平淡无奇, 但利用 SFINAE 原则在元编程中却可以发挥巨大威力.  

功能：**能够检测到应用SFINAE(替换失败并不是一个错误）特性时****出现的非法类型**。换句话说，**给进来的类型 \_Types 必须是一个有效的类型，不能是一个非法类型**。

# 使用 `void_t`

例 1: 判断某类型是否有指定内嵌类型的模板定义

```cpp
// primary template handles types that have no nested ::type member:
template< class, class = std::void_t<>
struct has_type_member : std::false_type { };

// specialization recognizes types that do have a nested ::type member:
template< class T >
struct has_type_member<T, std::void_t<typename T::type>: std::true_type { };

// 此例代码来自 http://en.cppreference.com
```

根据例 1, 使用例 2 的代码进行测试.

例 2: 测试

```cpp
// 定义两个结构 A, B
struct A
{
    typedef int type;
};

struct B {};

//
std:: cout << std::boolalpha;

// 测试
std::cout << has_type_member<A>::value << '\n'; // prints true
std::cout << has_type_member<B>::value << '\n'; // prints false
```

# `void_t` 的工作原理

下面例 3 用于判断某个类型中是否含有成员 member. 并且结合这个例子说明使用  
`void_t` 的 SFINAE 替换过程.

例 3

```cpp
// 基本模板
template<class, class = void >
struct has_member : std::false_type
{ };

// 模板特化
template<class T>
struct has_member<T, std::void_t<decltype(T::member)>: std::true_type
{ };

// 定义两个用于测试的结构
struct A
{
    int member;
};

class B
{
};

// 测试
static_assert(has_member<A>::value); // (1)
static_assert(has_member<B>::value); // (2)
```

下面描述 SFINAE 替换过程.

-   对于 (1)
    
    调用 `has_member<A>` 时, 首先选用特化模板, 发现 `A::member` 存在,  
    `decltype(A::member)` 合法 (well-formed),  
    故 `std::void_t<decltype(T::member)>` 演绎为 `void`, 所以最终演绎为  
    `has_member<A, void>`, 从而选择了特化模板, 故 `has_member<A>::vlaue`  
    为 `true`, 从而通过静态断言.
    
-   对于 (2)
    
    调用 `has_member<B>` 时, 首先选用特化模板, 发现 `b::member` 不存在,  
    `decltype(A::member)` 不合法 (ill-formed), 根据 SFINAE 原则, 不会产生  
    `has_member<B, some_expression>` 模板代码. 编译器发现还有一个  
    `has_member<class, class = void>` 基本模板存在, 将产生代码为  
    `has_member<B, void>`, 而 `has_member<B, void>::value` 为 `false`, 所以第  
    2 个静态断言失败.
    

# 一个有趣的例子

这个例子来自 [http://purecpp.org/?p=1273](http://purecpp.org/?p=1273), 用于判断参数类型是否为智能指针.

```cpp
// 基本模板
template <typename T, typename = void>
struct is_smart_pointer : std::false_type
{
};

// 特化模板: 通过判断 T::-存在否和 T::get() 存在否来确定 T 是否一个智能指针
template <typename T>
struct is_smart_pointer<T,
        std::void_t<decltype(std::declval<T>().operator ->()),
                    decltype(std::declval<T>().get())>>: std::true_type
{
};

// 若对上述判断不放心, 可以再加一个条件: reset()函数. 也可以加更多的判断条件
```



【注】**泛化版本和特化版本到底编译器如何选择**

-   编译器通过一种复杂的排序规则来决定使用类模板的泛化版本还是特化版本。
-   一般来说，void跟任何其他类型比，都是最后选择的那个。所以上面的泛化版本中默认参数为 U = std::void\_t<等价于 U = void。
-   实际情景下可以通过写测试代码进行判断。