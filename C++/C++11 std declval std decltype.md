# C++11: std::declval/std::decltype


#### std::declval:

声明：

```cpp
template<class T>
typename std::add_rvalue_reference<T>::type declval() noexcept;
```

将任何一个类型T转换成引用类型，令在decltype表达式中不必经过构造函数就能使用成员函数。

-   **add\_rvalue\_reference**：是C++标准库中的类模板，它的能力是**给进来一个类型，他能够返回该类型的右值引用类型**。比如：
    -   a)给进来一个int类型,返回的就是int &&
    -   b)给进来一个int &类型，返回的还是int &类型。这里用到了引用折叠。
    -   c)给进来一个int &&类型，返回的还是int &&类型。这里依旧用到了引用折叠知识。
-   **std::declval的功能**：**返回某个类型T的右值引用，不管该类型是否有默认构造函数或者该类型是否可以创建对象。**
-   返回某个类型T的右值引用 这个动作是在**编译时完成**的，所以很多人把std::declval也称为**编译时工具**。

### **std::declval的作用**

> -   a)从**类型转换的角度**来讲，**将任意一个类型转换成右值引用类型**。
> -   b)从**假想创建出某类型对象**的角度来说，配合decltype，令**在decltype表达式**中，不必经过该类型的构造函数就能使用该类型的成员函数。
> -   注意，**std::declval不能被调用，也不能创建任何对象**。
>     -   但std::declval能在**不创建对象的情况下，达到创建了一个该类型对象的效果或者说可以假定创建出了一个该类型对象**。

```cpp
#include <utility>
#include <iostream>

struct Default { int foo() const { return 1; } };

struct NonDefault
{
    NonDefault(const NonDefault&) { }
    int foo() const { return 1; }
};

int main()
{
    decltype(Default().foo()) n1 = 1;                   // type of n1 is int
//  decltype(NonDefault().foo()) n2 = n1;               // error: no default constructor
    decltype(std::declval<NonDefault>().foo()) n2 = n1; // type of n2 is int
    std::cout<< "n1 = " << n1 << '\n'
    std::cout<< "n2 = " << n2 << '\n';
}
```

#### decltype:

给定一个变量或表达式，decltype能够推导出他的类型。最重要的是能够不需要计算表达式就可以推导出表达式所得值的类型。

如何在模板中使用std::decltype?

在如上的例子中，

```cpp
decltype(NonDefault().foo()) n2 = n1;               // error: no default constructor
```

decltype在推导一个成员函数的返回值类型时，会报出无默认构造函数的错误。decltype需要一个实例？

再看如下模板中，推导一个函数的返回值：

```ruby
#include<utility>
#include<iostream>

int test(int a,int b){
    int c = a+b;
    std::cout<<"Run Test"<<c<<std::endl;
    return c;
}

/* 无法通过编译
template<typename Fn, typename... Args>
decltype(Fn(Args...)) test_decltype3(Fn f, Args... args) {
    std::cout<<"Run Test_Decltype3"<<std::endl;
    auto res = f(args...);
    return res;
}
*/

template<typename Fn, typename... Args>
auto test_decltype2(Fn f, Args... args) -> decltype(f(args...)){
    std::cout<<"Run Test_Decltype2"<<std::endl;
    auto res = f(args...);
    return res;
}

template<typename Fn,typename... Args>
decltype(std::declval<Fn>()(std::declval<Args>()...)) test_decltype1(Fn f,Args... args){
    std::cout<<"Run Test_Decltype1"<<std::endl;
    auto res = f(args...);
    return res;
}

int main(int agrc,char *argv[]){

    auto res0 = test_decltype1(test,1,2);
    auto res1 = test_decltype2(test,1,3);
    std::cout<<"Main Res0: "<<res0<<std::endl;
    std::cout<<"Main Res1: "<<res1<<std::endl;

    return 0;

}
```

如上看出std::declval 与decltype的用法，在test\_decltype1通过std::declval右值引用函数类型及参数类型，完成类型推导。在test\_decltype2中通过函数实例及参数实例完成返回值的类型推导。  
但是在test\_decltype3中，其无法通过编译，decltype需要一个可实例的函子，但是利用std::declval可以避免构造的要求。

# std::declval为什么返回右值引用类型  

自己实现类似于declval的函数

```cpp

template <typename T>
T mydeclval() noexcept;
```

-   调用

```cpp

using boost::typeindex::type_id_with_cvr;
cout << "mydeclval<A>()的返回类型=" <<  type_id_with_cvr<decltype(_mydeclval<A>() )>().pretty_name() << endl;
cout << "mydeclval<A>().myfunc()的返回类型=" << type_id_with_cvr<decltype(mydeclval<A>().myfunc())>().pretty_name() << endl;

```

-   输出

![](https://img-blog.csdnimg.cn/20201114181648315.png)

**在A类中增加析构函数，引出问题**

```cpp
class A
{
public:
	A(int i) //构造函数
	{
		printf("A::A()函数执行了,this=%p\n", this);
	}
 
	double myfunc() //普通成员函数
	{
		printf("A::myfunc()函数执行了,this=%p\n", this);
		return 12.1;
	}
 
private:
	~A() {}
};
```

-   再次编译，报错

![](https://img-blog.csdnimg.cn/20201114183358448.png)

-   注释掉decltype(mydeclval<A>().myfunc())所在行代码，则编译不报错。
    -   因为要遵循语义限制，mydeclval<A>().myfunc()语义上要创建一个临时对象（虽然实际上没有创建，是假象创建对象的），然后由这个假象的对象去调用myfunc函数。
-   mydeclval函数返回一个原类型在这种情况下的就会产生语义错误。
-   下面代码也会报同样的错误

```cpp
cout << "sizeof(mydeclval<A>())=" << sizeof(mydeclval<_nmsp1::A>()) << endl;
```

![](https://img-blog.csdnimg.cn/20201114183358448.png)

-   **返回类型本身是不好的**
    -   因为返回类型本身，导致**为了遵循语义限制，编译器内部创建了临时的A类对象**。
    -   **为了绕开语义限制，在设计mydeclval函数模板时，就不要返回类型T了，可以返回T&，也可以返回T&&**，这样从遵循语义限制方面来说，就不会创建临时的A类对象了。这就是返回T&或者T&&的好处。