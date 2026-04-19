# vector中resize()和reserve()区别

先看看《C++ Primer》中对resize()函数两种用法的介绍：

1、resize(n) 

调整容器的长度大小，使其能容纳n个元素。

如果n小于容器的当前的size，则删除多出来的元素。

否则，添加采用值初始化的元素。

2、 resize(n，t)

多一个参数t，将所有新添加的元素初始化为t。

  

而reserver()的用法只有一种

reserve(n)

预分配n个元素的存储空间。

  

了解这两个函数的区别，首先要搞清楚容器的capacity（容量）与size（长度）的区别。

size指容器当前拥有的元素个数；

而capacity则指容器在必须分配新存储空间之前可以存储的元素总数。

也可以说是预分配存储空间的大小。

  

resize()函数和容器的size息息相关。调用resize(n)后，容器的size即为n。  

至于是否影响capacity，取决于调整后的容器的size是否大于capacity。

  

reserve()函数和容器的capacity息息相关。

调用reserve(n)后，若容器的capacity<n，则重新分配内存空间，从而使得capacity等于n。  

如果capacity>=n呢？capacity无变化。

  

从两个函数的用途可以发现，容器调用resize()函数后，所有的空间都已经初始化了，所以可以直接访问。

而reserve()函数预分配出的空间没有被初始化，所以不可访问。


一个简单的测试用例：

```cpp
vector<int> a;
a.reserve(100);
a.resize(50);
cout<<a.size()<<"  "<<a.capacity()<<endl;
a.resize(150);
cout<<a.size()<<"  "<<a.capacity()<<endl;
a.reserve(50);
cout<<a.size()<<"  "<<a.capacity()<<endl;
a.resize(50);
cout<<a.size()<<"  "<<a.capacity()<<endl;
```
