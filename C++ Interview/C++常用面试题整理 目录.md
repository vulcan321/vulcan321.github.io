c++常用面试题整理 目录
开头、学好C++需要哪些知识
第一部分、 c++ 基础
1、C和C++的区别
2、C++中指针和引用的区别
3、结构体struct和共同体union（联合）的区别
4、struct 和 class 的区别？
5、#define和const的区别
6、重载overload，覆盖（重写）override，隐藏（重定义）overwrite，这三者之间的区别
7、new 和 delete 是如何实现的，与 malloc 和 free有什么异同？
8、delete和delete[]的区别
9、const知道吗？解释一下其作用
10、关键字static的作用
11、堆和栈的区别
12、#include<file.h> #include "file.h" 的区别
13、什么是内存泄漏？面对内存泄漏和指针越界，你有哪些方法？
14、定义和声明的区别
15、C++文件编译与执行的四个阶段
16、C++的内存管理
17、 C++的四种强制转换
18、extern“C”作用
19、typdef和define区别
20、引用作为函数参数以及返回值的好处
21、什么是野指针
22、C++中内存泄漏的几种情况
23、栈溢出的原因以及解决方法
24、左值和右值
25、左值引用与右值引用
26、头文件中的 ifndef/define/endif 是干什么用的? 该用法和 program once 的区别？
27、指针数组和数组指针的区别
28、C++是不是类型安全的？
29、main函数执行之前，还会执行什么代码？
30、全局变量和局部变量有什么区别？是怎么实现的？操作系统和编译器是怎么知道的？
31、关于sizeof小结的。
32、sizeof 和 strlen 的区别？
33、说说内联函数
34、C/C++的存储期
35、流操作符重载为什么返回引用
36、全局变量和局部变量有什么区别？实怎么实现的？操作系统和编译器是怎么知道的？
第二部分、 c++ 类相关
1、什么是面向对象（OOP）？面向对象的意义？
2、解释下封装、继承和多态？
3、构造函数和析构函数的执行顺序？
4、虚函数是怎么实现的
5、 构造函数为什么一般不定义为虚函数？而析构函数一般写成虚函数的原因 ？
6、细看拷贝构造函数
7、静态绑定和动态绑定的介绍
8、深拷贝和浅拷贝的区别
9、 什么情况下会调用拷贝构造函数（三种情况）
10、类对象的大小受哪些因素影响？
11、拷贝构造函数和赋值运算符的理解
12、C++空类默认有哪些成员函数？
13、如果虚函数是有效的，那为什么不把所有函数设为虚函数？
14、构造函数和虚构函数可以是内联函数？
15、虚函数声明为inline
16、C++的空类有哪些成员函数
17、C++中的五种构造函数
第三部分、 c++11/c++14/c++17
1、C++11 中有哪些智能指针？shared_ptr 的引用计数是如何实现的？unique_ptr 的unique 是如何实现的？make_shared 和 make_unique 的作用？智能指针使用注意事项？
2、智能指针weak_ptr 能够破坏环型引用的原理（引用计数的原理）
3、C++ 的闭包
4、lambda 表达式、怎么捕获外部变量
5、C++ 的垃圾回收机制
6、vector的clear()的时间复杂度是多少？
7、C++11为什么引入enum class？
8、std::thread使用lambda做回调，有没有什么注意事项？
9、C++11的thread_local有没有使用过？
10、谈一谈你对zero overhead（零开销原则）的理解
11、了解移动语义和完美转发吗？
12、了解列表初始化吗？
第四部分、 多线程（多进程） 相关
1、线程与进程的区别
2、什么是线程不安全?
3、造成线程不安全的原因
4、C++线程中的几类锁
5、什么是死锁，解决方式
6、进程之间的通信方式
7、线程之间的通信方式
第五部分、 STL
1、STL 六大组件
2、stack 中有 pop() 和 top() 方法，为什么不直接用 pop() 实现弹出和取值的功能？
3、 STL库用过吗？常见的STL容器有哪些？算法用过几个？
4、STL中map 、set、multiset、multimap的底层原理（关联式容器）
5、map 、set、multiset、multimap的特点
6、hash_map与map的区别？什么时候用hash_map，什么时候用map？
7、STL中unordered_map和map的区别
8、STL中的vector的实现，是怎么扩容的？
9、C++中vector和list的区别
10、STL内存优化？
11、正确释放vector的内存(clear(), swap(), shrink_to_fit())
12、什么情况下用vector，什么情况下用list，什么情况下用deque
13、priority_queue的底层原理
14、 STL线程不安全的情况
15、vector 中迭代器失效的情况
16、迭代器的几种失效的情况
17、STL 是复制性还是侵入性
18、vector使用注意事项
第六部分、 网络编程
1、三次握手和四次挥手
2、 TCP 和 UDP 的区别
3、TCP 粘包 、拆包
4、TCP 丢包
5、为什么“握手”是三次，“挥手”却要四次？
6、为什么“握手”是三次，“挥手”却要四次？
7、网络的七层模型，作用、传输单位分别是什么
第七部分、 设计模式
1、设计模式
2、单例模式的线程安全问题
3、工厂方法模式
第八部分、 数据结构
1、双链表和单链表的优缺点
2、红黑树比AVL的优势，为何用红黑树
3、红黑树的高度
4、判断链表是不是环形链表
5、简述队列和栈的异同