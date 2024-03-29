# [C++11 带来的新特性 （3）—— 关键字noexcept](https://www.cnblogs.com/sword03/p/10020344.html)

## 1 关键字noexcept

从C++11开始，我们能看到很多代码当中都有关键字noexcept。比如下面就是std::initializer\_list的默认构造函数，其中使用了noexcept。

```cpp
      constexpr initializer_list() noexcept
      : _M_array(0), _M_len(0) { }
```

该关键字告诉编译器，函数中不会发生异常,这有利于编译器对程序做更多的优化。  
如果在运行时，noexecpt函数向外抛出了异常（如果函数内部捕捉了异常并完成处理，这种情况不算抛出异常），程序会直接终止，调用std::terminate()函数，该函数内部会调用std::abort()终止程序。

## 2 C++的异常处理

C++中的异常处理是在运行时而不是编译时检测的。为了实现运行时检测，编译器创建额外的代码，然而这会妨碍程序优化。  
在实践中，一般两种异常抛出方式是常用的：

-   一个操作或者函数可能会抛出一个异常;
-   一个操作或者函数不可能抛出任何异常。

后面这一种方式中在以往的C++版本中常用throw()表示，在C++ 11中已经被noexcept代替。

```scss
    void swap(Type& x, Type& y) throw()   //C++11之前
    {
        x.swap(y);
    }
    void swap(Type& x, Type& y) noexcept  //C++11
    {
        x.swap(y);
    }
```

## 3 有条件的noexcecpt

在第2节中单独使用noexcept，表示其所限定的swap函数绝对不发生异常。然而，使用方式可以更加灵活，表明在一定条件下不发生异常。

```scss
    void swap(Type& x, Type& y) noexcept(noexcept(x.swap(y)))    //C++11
    {
        x.swap(y);
    }
```

它表示，如果操作x.swap(y)不发生异常，那么函数swap(Type& x, Type& y)一定不发生异常。

一个更好的示例是std::pair中的移动分配函数（move assignment），它表明，如果类型T1和T2的移动分配（move assign）过程中不发生异常，那么该移动构造函数就不会发生异常。

```cpp
    pair& operator=(pair&& __p)
    noexcept(__and_<is_nothrow_move_assignable<_T1>,
                    is_nothrow_move_assignable<_T2>>::value)
    {
        first = std::forward<first_type>(__p.first);
        second = std::forward<second_type>(__p.second);
        return *this;
    }
```

## 4 什么时候该使用noexcept？

使用noexcept表明函数或操作不会发生异常，会给编译器更大的优化空间。然而，并不是加上noexcept就能提高效率，步子迈大了也容易扯着蛋。  
以下情形鼓励使用noexcept：

-   移动构造函数（move constructor）
-   移动分配函数（move assignment）
-   析构函数（destructor）。这里提一句，在新版本的编译器中，析构函数是默认加上关键字noexcept的。下面代码可以检测编译器是否给析构函数加上关键字noexcept。





```scss
    struct X
    {
        ~X() { };
    };
    
    int main()
    {
        X x;
    
        // This will not fire even in GCC 4.7.2 if the destructor is
        // explicitly marked as noexcept(true)
        static_assert(noexcept(x.~X()), "Ouch!");
    }
```

-   叶子函数（Leaf Function）。叶子函数是指在函数内部不分配栈空间，也不调用其它函数，也不存储非易失性寄存器，也不处理异常。

最后强调一句，在不是以上情况或者没把握的情况下，不要轻易使用noexception。

## noexcept operator 

The `noexcept` operator performs a compile-time check that returns true if an expression is declared to not throw any exceptions.

It can be used within a function template's [`noexcept` specifier](https://en.cppreference.com/w/cpp/language/noexcept_spec) to declare that the function will throw exceptions for some types but not others.

### Syntax

`**noexcept(**` *expression* `**)**`

### Returns 

a [prvalue](https://en.cppreference.com/w/cpp/language/value_category) of type bool.

### Explanation

The `noexcept` operator does not evaluate *expression*.

The result is true if the set of [*potential exceptions*](https://en.cppreference.com/w/cpp/language/except_spec) of the *expression* is empty (until C++17)*expression* is [*non-throwing*](https://en.cppreference.com/w/cpp/language/noexcept_spec) (since C++17), and false otherwise.



```cpp
#include <iostream>
#include <utility>
#include <vector>
 
void may_throw();
void no_throw() noexcept;
auto lmay_throw = []{};
auto lno_throw = []() noexcept {};
 
class T
{
public:
    ~T(){} // dtor prevents move ctor
           // copy ctor is noexcept
};
 
class U
{
public:
    ~U(){} // dtor prevents move ctor
           // copy ctor is noexcept(false)
    std::vector<int> v;
};
 
class V
{
public:
    std::vector<int> v;
};
 
int main()
{
    T t;
    U u;
    V v;
 
    std::cout << std::boolalpha
        << "Is may_throw() noexcept? " << noexcept(may_throw()) << '\n'
        << "Is no_throw() noexcept? " << noexcept(no_throw()) << '\n'
        << "Is lmay_throw() noexcept? " << noexcept(lmay_throw()) << '\n'
        << "Is lno_throw() noexcept? " << noexcept(lno_throw()) << '\n'
        << "Is ~T() noexcept? " << noexcept(std::declval<T>().~T()) << '\n'
        // note: the following tests also require that ~T() is noexcept because
        // the expression within noexcept constructs and destroys a temporary
        << "Is T(rvalue T) noexcept? " << noexcept(T(std::declval<T>())) << '\n'
        << "Is T(lvalue T) noexcept? " << noexcept(T(t)) << '\n'
        << "Is U(rvalue U) noexcept? " << noexcept(U(std::declval<U>())) << '\n'
        << "Is U(lvalue U) noexcept? " << noexcept(U(u)) << '\n'  
        << "Is V(rvalue V) noexcept? " << noexcept(V(std::declval<V>())) << '\n'
        << "Is V(lvalue V) noexcept? " << noexcept(V(v)) << '\n';  
}
```

```
Is may_throw() noexcept? false
Is no_throw() noexcept? true
Is lmay_throw() noexcept? false
Is lno_throw() noexcept? true
Is ~T() noexcept? true
Is T(rvalue T) noexcept? true
Is T(lvalue T) noexcept? true
Is U(rvalue U) noexcept? false
Is U(lvalue U) noexcept? false
Is V(rvalue V) noexcept? true
Is V(lvalue V) noexcept? false
```

