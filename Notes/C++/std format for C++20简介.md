# std::format for C++20简介


C语言格式化字符串的解决方案printf系列函数(printf/sprintf/fprintf/snprintf等)性能较高，但是使用%s的时候容易崩溃，虽然现在编译器都可以给出警告，但是其它的毛病比如说浮点数格式化精度丢失(本文后面会举例)依然是不得不面对的问题。

C++相对C的最大区别之一就是尽可能地追求typesafe，所以C++从一开始就在寻找替代printf系列函数的解决方案，于是从一开始就有了各种各样的ostream。typesafe是做到了，但是性能低下。

第三方库也在努力，比如说boost很早就引入了boost::format，只可惜它也有严重的性能问题。直到一个名字叫fmtlib的第三方库的出现，这个现状才得以改变。

fmtlib的部分功能被加入到了C++20，它就是std::format。它的速度比printf系列函数平均快出35%，有时候甚至更多(对于浮点数，std::format甚至比snprintf快出10倍以上)。

除此以外，它还有更多的优点。下面随便列举几个。

## 解决浮点数精度丢失问题

直接来看例子吧

```cpp
double pi = 3.14159265358979;
printf("%f\n", pi); // 输出3.141593，后面的被四舍五入了
cout<<format("{}\n", pi); // format，输出完整的3.14159265358979

// 与snprintf函数对应的是format_to_n
char buff[50];
sprintf(buff, "%f", pi);
cout<<buff<<"\n"; // 与printf一样，输出3.141593
format_to_n(buff, sizeof(buff), "{}", pi);
cout<<buff<<"\n"; // 3.14159265358979
```

## 与STL容器完美结合

```cpp
vector<char> v;
format_to(std::back_inserter(v), "{}", "1999"); // 输出到iterator
// now v is {'1', '9', '9', '9'}
assert(v[3] == '9');
```

## 可提前算出format之后所需内存空间

format之前可以调用formated\_size函数提前算出本次format所需要的内存空间

```cpp
 auto size = std::formatted_size("{}", 42); // size == 2
 std::vector<char> buf(size); // 根据上面返回的size，将内存分配好
 std::format_to(buf.data(), "{}", 42);
```

## 支持自定义的类型扩展

通过模板特化自定义struct std::formatter<YourType>，就可以让YourType类型支持std::format。其主要就是定义两个成员函数：parse和format，这里不举例了。像std::chrono里面常见的日期时间类型相关的std::formatter都已经放进标准库了，不需要自己写了。