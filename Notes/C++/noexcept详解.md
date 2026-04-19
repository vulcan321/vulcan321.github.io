# noexcept详解


相比于断言适用于排除逻辑上不可能存在的状态，异常通常是用于逻辑上可能发生的错误。

在C++98中，我们看到了一套完整的不同于C的异常处理系统。通过这套异常处理系统，C++拥有了远比C强大的异常处理功能。

在异常处理的代码中，程序员有可能看到过如下的异常声明表达形式：void excpt_func() throw(int, double) { ... }   

在excpt\_func函数声明之后，我们定义了一个动态异常声明throw(int, double)，该声明指出了excpt\_func可能抛出的异常的类型。事实上，该特性很少被使用，因此在C++11中被弃用了（参见附录B），而表示函数不会抛出异常的动态异常声明throw()也被新的noexcept异常声明所取代。

  

noexcept形如其名地，表示其修饰的函数不会抛出异常。不过与throw()动态异常声明不同的是，在C++11中如果noexcept修饰的函数抛出了异常，编译器可以选择直接调用std::terminate()函数来终止程序的运行，这比基于异常机制的throw()在效率上会高一些。这是因为异常机制会带来一些额外开销，比如函数抛出异常，会导致函数栈被依次地展开（unwind），并依帧调用在本帧中已构造的自动变量的析构函数等。


从语法上讲，noexcept修饰符有两种形式，一种就是简单地在函数声明后加上noexcept关键字。比如：void excpt\_func() noexcept; 

另外一种则可以接受一个常量表达式作为参数，如下所示：void excpt\_func() noexcept (常量表达式); 

常量表达式的结果会被转换成一个bool类型的值。该值为true，表示函数不会抛出异常，反之，则有可能抛出异常。

这里，不带常量表达式的noexcept相当于声明了noexcept(true)，即不会抛出异常。

在通常情况下，在C++11中使用noexcept可以有效地阻止异常的传播与扩散。我们可以看看下面这个例子，如下代码：

```cpp
#include <iostream> 
using namespace std;  
void Throw() { throw 1; }  
void NoBlockThrow() { Throw(); }  
void BlockThrow() noexcept { Throw(); }  
 
int main() {  
    try {  
        Throw();  
    }  
    catch(...) {  
        cout << "Found throw." << endl;     // Found throw.  
    }  
    try {  
        NoBlockThrow();  
    }  
    catch(...) {  
        cout << "Throw is not blocked." << endl;    // Throw is not blocked.  
    }  
 
    try {  
        BlockThrow();   // terminate called after throwing an instance of 'int'  
    }  
    catch(...) {  
        cout << "Found throw 1." << endl;  
    }  
}  
```


在代码中，我们定义了Throw函数，该函数的唯一作用是抛出一个异常。而NoBlockThrow是一个调用Throw的普通函数，BlockThrow则是一个noexcept修饰的函数。从main的运行中我们可以看到，NoBlockThrow会让Throw函数抛出的异常继续抛出，直到main中的catch语句将其捕捉。而BlockThrow则会直接调用std::terminate中断程序的执行，从而阻止了异常的继续传播。从使用效果上看，这与C++98中的throw()是一样的。


而noexcept作为一个操作符时，通常可以用于模板。比如：  

```cpp
template <class T> 
  void fun() noexcept(noexcept(T())) {} 
```



  

这里，fun函数是否是一个noexcept的函数，将由T()表达式是否会抛出异常所决定。这里的第二个noexcept就是一个noexcept操作符。当其参数是一个有可能抛出异常的表达式的时候，其返回值为false，反之为true（实际noexcept参数返回false还包括一些情况，这里就不展开讲了）。这样一来，我们就可以使模板函数根据条件实现noexcept修饰的版本或无noexcept修饰的版本。从泛型编程的角度看来，这样的设计保证了关于“函数是否抛出异常”这样的问题可以通过表达式进行推导。因此这也可以视作C++11为了更好地支持泛型编程而引入的特性。  

虽然noexcept修饰的函数通过std::terminate的调用来结束程序的执行的方式可能会带来很多问题，比如无法保证对象的析构函数的正常调用，无法保证栈的自动释放等，但很多时候，“暴力”地终止整个程序确实是很简单有效的做法。事实上，noexcept被广泛地、系统地应用在C++11的标准库中，用于提高标准库的性能，以及满足一些阻止异常扩散的需求。  


比如在C++98中，存在着使用throw()来声明不抛出异常的函数。

```cpp
template<class T> class A {  
  public:  
    static constexpr T min() throw() { return T(); }
    static constexpr T max() throw() { return T(); }
    static constexpr T lowest() throw() { return T(); }
...
```

而在C++11中，则使用noexcept来替换throw()。

```cpp
template<class T> class A {  
  public:  
    static constexpr T min() noexcept { return T(); }
    static constexpr T max() noexcept { return T(); }
    static constexpr T lowest() noexcept { return T(); }
... 
```


又比如，在C++98中，new可能会包含一些抛出的std::bad\_alloc异常。  

```cpp
void* operator new(std::size_t) throw(std::bad_alloc);    
void* operator new[](std::size_t) throw(std::bad_alloc); 
```

而在C++11中，则使用noexcept(false)来进行替代。  

```cpp
void* [operator] new(std::size_t) noexcept(false);    
void* operator new[](std::size_t) noexcept(false); 
```

当然，noexcept更大的作用是保证应用程序的安全。比如一个类析构函数不应该抛出异常，那么对于常被析构函数调用的delete函数来说，C++11默认将delete函数设置成noexcept，就可以提高应用程序的安全性。  

```cpp
void operator delete(void*) noexcept;    
void operator delete[](void*) noexcept; 
```

而同样出于安全考虑，C++11标准中让类的析构函数默认也是noexcept(true)的。

当然，如果程序员显式地为析构函数指定了noexcept，或者类的基类或成员有noexcept(false)的析构函数，析构函数就不会再保持默认值。我们可以看看下面的例子，如下代码：  

```cpp
#include <iostream> 
using namespace std;  
 
struct A {  
    ~A() { throw 1; }  
};  
 
struct B {  
    ~B() noexcept(false) { throw 2; }  
};  
 
struct C {  
    B b;  
};  
 
int funA() { A a; }  
int funB() { B b; }  
int funC() { C c; }  
 
int main() {  
    try {  
        funB();  
    }  
    catch(...){  
        cout << "caught funB." << endl; // caught funB.  
    }  
 
    try {  
        funC();  
    }  
    catch(...){  
        cout << "caught funC." << endl; // caught funC.  
    }  
 
    try {  
        funA(); // terminate called after throwing an instance of 'int'  
    }  
    catch(...){  
        cout << "caught funA." << endl;  
    }  
}
```


在代码中，无论是析构函数声明为noexcept(false)的类B，还是包含了B类型成员的类C，其析构函数都是可以抛出异常的。只有什么都没有声明的类A，其析构函数被默认为noexcept(true)，从而阻止了异常的扩散。这在实际的使用中，应该引起程序员的注意。