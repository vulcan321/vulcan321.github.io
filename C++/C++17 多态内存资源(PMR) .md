## C++17 多态内存资源(PMR)

自从C++98起，标准库就支持配置类管理自己内部（堆）内存的方式。 因此，标准库中几乎所有会分配内存的类型都有一个分配器参数。 这允许你配置容器、字符串和其他需要栈以外的内存的类型分配内存的方式。

默认分配内存的方式是从堆上分配。然而，出于下列原因你可能会想修改默认的行为：

-   你可以使用自己的方式分配内存来减少系统调用。
-   你可以确保分配的内存是连续的来受益于CPU缓存。
-   你可以把容器和元素放在可以被多个进程访问的共享内存中。
-   你甚至可以重定向这些堆内存调用来复用之前在栈上分配的内存。

因此，修改默认的行为可能会带来性能和功能上的改进。

然而，直到C++17，（正确地）使用分配器在许多方面都即困难又笨拙 （因为一些语言的缺陷、太过复杂、要考虑向后的兼容性更改）。

C++17现在提供了一种相当容易使用的方法来支持预定义的和用户定义的内存分配方式， 这对标准类型和用户自定义类型都很有用。

因此，这一章将讨论：

-   使用标准库提供的标准内存资源
-   定义自定义内存资源
-   为自定义类型提供内存资源支持

这一章的完成离不开Pablo Halpern、Arthur O'Dwyer、David Sankel、Jonathan Wakely的帮助。

### 29.1 使用标准内存资源

这一节介绍了标准内存资源和使用它们的方法。

### 29.1.1 示例

让我们首先比较一下使用和不使用标准内存资源的内存消耗。

### 为容器和字符串分配内存

假设你的程序中有一个string的vector，并且你用了很多很长的string来初始化这个vector：

```cpp
#include <iostream>
#include <string>
#include <vector>
#include "../lang/tracknew.hpp"

int main()
{
    TrackNew::reset();

    std::vector<std::string> coll;
    for (int i = 0; i < 1000; ++i) {
        coll.emplace_back("just a non-SSO string");
    }

    TrackNew::status();
}
```

注意我们使用了追踪所有`::new`调用的类来在下列循环中 追踪内存分配的情况：

```cpp
std::vector<std::string> coll;
for (int i = 0; i < 1000; ++i) {
    coll.emplace_back("just a non-SSO string");
}
```

这个过程中会发生很多次内存分配，因为vector使用堆内存来存储元素。 另外，字符串本身也可能在堆上分配空间来存储值 （如果实现使用了短字符串优化，那么通常当字符串超过15个字符时会在堆上分配空间）。

程序的输出可能会像下面这样：

```text
1018 allocations for 134,730 bytes
```

这意味着除了每个string要分配一次内存之外，vector内部还分配了18（或者更多）次内存来存储元素。

这样的行为可能会导致很严重的问题，因为内存（重新）分配在一些环境中需要很长时间（例如嵌入式系统）， 完全在堆上分配内存可能会导致性能问题。

我们可以事先要求vector预留充足的内存，但一般来说，重新分配内存是不可避免的，除非你事先知道要存储的元素的数量。 如果你不知道具体要处理多少数据，你就必须在避免重新分配和不想浪费太多内存之间权衡。 并且这个例子中至少需要1001次分配（一次分配用来存储vector中的元素，每一个没有使用短字符串优化的string还要分配一次）。

### 不为容器分配内存

我们可以通过使用多态分配器来改进这种情况。 首先，我们可以使用`std::pmr::vector`，并且允许vector在栈上分配自己的内存：

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <array>
#include <cstdlib>  // for std::byte
#include <memory_resource>
#include "../lang/tracknew.hpp"

int main()
{
    TrackNew::reset();

    // 在栈上分配一些内存：
    std::array<std::byte, 200000> buf;

    // 将它用作vector的初始内存池：
    std::pmr::monotonic_buffer_resource pool{buf.data(), buf.size()};
    std::pmr::vector<std::string> coll{&pool};

    for (int i = 0; i < 1000; ++i) {
        coll.emplace_back("just a non-SSO string");
    }

    TrackNew::status();
}
```

首先，我们在栈上分配了自己的内存（使用了新类型`std::byte`）：

```text
// 在栈上分配一些内存：
std::array<std::byte, 200000> buf;
```

你也可以使用`char`来代替`std::byte` 。

之后，我们用这些内存初始化了一个`monotonic_buffer_resource`， 传递这些内存的地址和大小作为参数：

```text
std::pmr::monotonic_buffer_resource pool{buf.data(), buf.size()};
```

最后，我们使用了一个`std::pmr::vector`，它将使用传入的内存资源来分配内存：

```text
std::pmr::vector<std::string> coll{&pool};
```

这个声明是下面声明的缩写：

```cpp
std::vector<std::string, std::pmr::polymorphic_allocator<std::string>> coll{&pool};
```

也就是说，我们声明了一个使用 _多态分配器_ 的vector，多态分配器可以在运行时在不同的 _内存资源_ 之间切换。 类`monotonic_buffer_resource`派生自类`memory_resource`，因此可以 用作多态分配器的内存资源。 最后，通过传递我们的内存资源的地址，可以确保vector的多态分配器使用我们的内存资源。

如果我们测试这个程序中内存分配的次数，输出将是：

```text
1000 allocations for 32000 bytes
```

vector的18次内存分配将不会再发生在堆上，而是在我们初始化的`buf`里发生。

如果分配的200,000字节不够用，vector将会继续在堆上分配更多的内存。 这是因为`monotonic_memory_resource`使用了默认的分配器， 它会把使用`new`分配内存作为备选项。

### 一次也不分配内存

我们甚至可以通过把`std::pmr::vector`的元素类型改为`std::pmr::string`来避免任何内存分配：

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <array>
#include <cstdlib>  // for std::byte
#include <memory_resource>
#include "../lang/tracknew.hpp"

int main()
{
    TrackNew::reset();

    // 在栈上分配一些内存：
    std::array<std::byte, 200000> buf;

    // 将它用作vector和strings的初始内存池：
    std::pmr::monotonic_buffer_resource pool{buf.data(), buf.size()};
    std::pmr::vector<std::pmr::string> coll{&pool};

    for (int i = 0; i < 1000; ++i) {
        coll.emplace_back("just a non-SSO string");
    }

    TrackNew::status();
}
```

因为下面的vector的声明：

```cpp
std::pmr::vector<std::pmr::string> coll{&pool};
```

程序的输出将变为：

```text
0 allocations for 0 bytes
```

这是因为一个pmr vector尝试把它的分配器传播给它的元素， 当元素并不使用多态分配器（也就是类型为`std::string`）时这会失败。 然而，`std::pmr::string` 类型会使用多态分配器，因此传播不会失败。

重复一下，当缓冲区没有足够的内存时还会在堆上分配新的内存。 例如，做了如下修改之后就有可能发生这种情况：

```cpp
for (int i = 0; i < 50000; ++i) {
    coll.emplace_back("just a non-SSO string");
}
```

输出可能会变为：

```text
8 allocations for 14777448 bytes
```

### 复用内存池

我们甚至可以复用栈内存池。例如：

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <array>
#include <cstdlib>  // for std::byte
#include <memory_resource>
#include "../lang/tracknew.hpp"

int main()
{
    // 在栈上分配一些内存：
    std::array<std::byte, 200000> buf;

    for (int num : {1000, 2000, 500, 2000, 3000, 50000, 1000}) {
        std::cout << "-- check with " << num << " elements:\n";
        TrackNew::reset();

        std::pmr::monotonic_buffer_resource pool{buf.data(), buf.size()};
        std::pmr::vector<std::pmr::string> coll{&pool};
        for (int i = 0; i < num; ++i) {
            coll.empalce_back("just a non-SSO string");
        }

        TrackNew::status();
    }
}
```

这里，在栈上分配了200,000字节之后，我们可以多次使用这块内存来初始化vector和它的元素的内存池。

输出可能会变为：

```text
-- check with 1000 elements:
0 allocations for 0 bytes
-- check with 2000 elements:
1 allocations for 300000 bytes
-- check with 500 elements:
0 allocations for 0 bytes
-- check with 2000 elements:
1 allocations for 300000 bytes
-- check with 3000 elements:
2 allocations for 750000 bytes
-- check with 50000 elements:
8 allocations for 14777448 bytes
-- check with 1000 elements:
0 allocations for 0 bytes
```

当200,000字节足够时，将不需要任何额外的内存分配（这里不到1000个元素的情况就是这样）。 当内存池被销毁之后这200,000字节被重新使用并用于下一次迭代。

每一次内存超限时，就会在堆里分配额外的内存，当内存池销毁时这些内存也会被释放。

通过这种方式，你可以轻易的使用内存池，你可以在只分配一次（可以在栈上也可以在堆上） 然后在每一个新任务里（服务请求、事件、处理数据文件等等）都复用这块内存。

### 29.1.2 标准内存资源

为了支持多态分配器，C++标准库提供了表标准内存资源中列出的内存资源。

| 内存资源 | 行为 |
| --- | --- |
| new\_delete\_resource() | 返回一个调用new和delete的内存资源的指针 |
| synchronized\_pool\_resource | 创建更少碎片化的、线程安全的内存资源的类 |
| unsynchronized\_pool\_resource | 创建更少碎片化的、线程不安全的内存资源的类 |
| monotonic\_buffer\_resource | 创建从不释放、可以传递一个可选的缓冲区、线程不安全的类 |
| null\_memory\_resource() | 返回一个每次分配都会失败的内存资源的指针 |

`new_delete_resource()`和`null_memory_resource()`函数 会返回指向单例全局内存资源的指针。其他三个内存资源都是类，你必须创建对象并把指针传递给这些对象的多态分配器。 一些用法如下：

```cpp
    std::pmr::string s1{"my string", std::pmr::new_delete_resource()};

    std::pmr::synchronized_pool_resource pool1;
    std::pmr::string s2{"my string", &pool1};

    std::pmr::monotonic_buffer_resource pool2{...};
    std::pmr::string s3{"my string", &pool2};
```

一般情况下，内存资源都以指针的形式传递。 因此，你必须保证指针指向的资源对象直到最后释放内存之前都一直有效 （如果你到处move对象并且内存资源可互换的话最后释放内存的时机可能比你想的要晚）。

### 默认内存资源

如果没有传递内存资源的话多态分配器会有一个默认的内存资源。 表默认内存资源的操作列出了它的所有操作。

| 内存资源 | 行为 |
| --- | --- |
| get\_default\_resource() | 返回一个指向当前默认内存资源的指针 |
| set\_default\_resource(memresPtr) | 设置默认内存资源（传递一个指针）并返回之前的内存资源的指针 |

你可以使用`std::pmr::get_default_resource()`获取当前的默认资源， 然后传递它来初始化一个多态分配器。你也可以使用`std::set_default_resource()` 来全局地设置一个不同的默认内存资源。这个资源将在任何作用域中用作默认资源，直到 下一次调用`std::pmr::set_default_resource()`。例如：

```cpp
static std::pmr::synchronized_pool_resource myPool;

// 设置myPool为新的默认内存资源：
std::pmr::memory_resource* old = std::pmr::set_default_resource(&myPool);
...
// 恢复旧的默认内存资源：
std::pmr::set_default_resource(old);
```

如果你在程序中设置了自定义内存资源并且把它用作默认资源， 那么直接在`main()`中首先将它创建为`static`对象将是一个好方法：

```cpp
int main()
{
    static std::pmr::synchronized_pool_resource myPool;
    ...
}
```

或者，提供一个返回静态资源的全局函数：

```cpp
memory_resource* myResource()
{
    static std::pmr::synchronized_pool_resource myPool;
    return &myPool;
}
```

返回类型`memory_resource`是任何内存资源的基类。

注意之前的默认内存资源可能仍然会被使用，即使它已经被替换掉。 除非你知道（并且确信）不会发生这种情况，也就是没有使用该内存资源创建静态对象， 否则你应该确保你的资源的生命周期尽可能的长 （再提醒一次，可以在`main()`开始处创建它，这样它会在程序的最后才会被销毁）。

### 29.1.3 详解标准内存资源

让我们仔细讨论不同的标准内存资源。

### new\_delete\_resource()

`new_delete_resource()`是默认的内存资源， 也是`get_default_resource()` 的返回值， 除非你调用`set_default_resource()` 设置了新的不同的默认内存资源。 这个资源处理内存分配的方式和普通的分配器一样：

-   每次分配内存会调用new
-   每次释放内存会调用delete

然而，注意持有这种内存资源的多态分配器不能和默认的分配器互换，因为它们的类型不同。因此：

```cpp
std::string s{"my string with some value"};
std::pmr::string ps{std::move(s), std::pmr::new_delete_resource()}; // 拷贝
```

将不会发生move（直接把`s` 分配的内存转让给`ps`）， 而是把`s`的内存拷贝到`ps`内部用`new`分配的新的内存中。

### (un)synchronized\_poo\_resource

`synchronized_pool_resource`和`unsynchronized_pool_resource`是 尝试在相邻位置分配所有内存的内存资源类。因此，使用它们可以尽可能的减小内存碎片。

它们的不同在于`synchronized_pool_resource` 是线程安全的（性能会差一些）， 而`unsynchronized_pool_resource` 不是。 因此，如果你知道这个池里的内存只会 被单个线程访问（或者分配和释放操作都是同步的），那么使用`unsynchronized_pool_resource`将是更好的选择。

这两个类都使用底层的内存资源来进行实际的分配和释放操作。它们只是保证内存分配更加密集的包装。因此，

```cpp
std::pmr::synchronized_pool_resource myPool;
```

等价于

```cpp
std::pmr::synchronized_pool_resource myPool{std::pmr::get_default_resource()};
```

另外，当池被销毁时它们会释放所有内存。

这些池的另一个应用是保证以节点为单位的容器里的元素能相邻排列。 这也许能显著提高容器的性能，因为CPU会把相邻的元素一起读入缓存行中。 当你访问了一个元素之后，再访问其他的元素有可能会很快速，因为它们已经在缓存里了。 然而，你需要实际测试，因为实际的性能依赖于内存资源的实现。例如，如果内存资源使用了 互斥量来同步内存访问，性能可能会变得非常差。

让我们用一个简单的例子来看一下效果。下面的程序创建了一个`map`把整数映射为字符串。

```cpp
#include <iostream>
#include <string>
#include <map>

int main()
{
    std::map<long, std::string> coll;

    for (int i = 0; i < 10; ++i) {
        std::string s{"Customer" + std::to_string(i)};
        coll.emplace(i, s);
    }

    // 打印出元素的距离：
    for (const auto& elem : coll) {
        static long long lastVal = 0;
        long long val = reinterpret_cast<long long>(&elem);
        std::cout << "diff: " << (val-lastVal) << '\n';
        lastVal = val;
    }
}
```

`map` 的数据结构是一颗平衡二叉树，它的每一个节点都要自己分配内存来存储一个元素。 因此，对于每一个元素都需要分配一次内存，并且默认情况下是在堆上分配内存（使用标准默认分配器）。

为了看到效果，程序会在迭代元素时打印出不同元素地址的差值。 输出可能类似于如下：

```text
diff: 1777277585312
diff: -320
diff: 60816
diff: 1120
diff: -400
diff: 80
diff: -2080
diff: -1120
diff: 2720
diff: -3040
```

元素并不是相邻存储的，10个24字节的元素之间的距离能达到60,000字节。 如果在分配这些元素期间还有其他内存分配，那么这种碎片化可能会变得更糟糕。

现在让我们使用`synchronized_pool_resource` 和多态分配器来运行程序：

```cpp
#include <iostream>
#include <string>
#include <map>
#include <memory_resource>

int main()
{
    std::pmr::synchronized_pool_resource pool;
    std::pmr::map<long, std::pmr::string> coll{&pool};

    for (int i = 0; i < 10; ++i) {
        std::string s{"Customer" + std::to_string(i)};
        coll.emplace(i, s);
    }

    // 打印出元素的距离：
    for (const auto& elem : coll) {
        static long long lastVal = 0;
        long long val = reinterpret_cast<long long>(&elem);
        std::cout << "diff: " << (val-lastVal) << '\n';
        lastVal = val;
    }
}
```

如你所见，我们简单的创建了资源并作为参数传递给了容器的构造函数：

```cpp
std::pmr::synchronized_pool_resource pool;
std::pmr::map<long, std::pmr::string> coll{&pool};
```

输出现在看起来可能如下：

```text
diff: 2548552461600
diff: 128
diff: 128
diff: 105216
diff: 128
diff: 128
diff: 128
diff: 128
diff: 128
diff: 128
```

如你所见，现在元素是相邻存储的。然而，它们仍然不是在同一个内存块中。 当池发现第一个块不足以存放下所有的元素时，它会分配一个更大的块来存储剩余的元素。 因此，我们分配了越多的内存，内存块就越大，相邻存储的元素就越多。 这些算法的细节是实现特定的。

当然，这个输出是很特殊的，因为我们是按照容器内排好序的顺序创建元素。 因此，在实践中，如果你以随机的值创建对象，元素可能不会（在不同的内存块中）按顺序相邻存放。 然而，它们存放的位置仍然会邻近彼此，在处理这样的容器时性能会很好。

另外，注意我们并没有看到string的值的内存是怎么分布的。这里，短字符串优化的使用 会导致string没有分配任何内存。然而，如果我们增大string的长度，池也会尝试将它们相邻排布。 注意池管理了按照分配大小划分的若干内存块，一般来说，元素会相邻存储，长度相同的string的值也会被相邻存储。

### monotonic\_buffer\_resource

类

```text
monotonic_buffer_resource
```

也提供把所有分配的内存放在一个大内存块中的功能。 然而，它还有下列两个能力：

-   你可以传递一个缓冲区用作内存。特别的，这被用来在栈上分配内存。
-   内存资源从来不会释放直到整个资源作为整体被一起释放。

因此，这种内存资源非常快速，因为释放操作实际上什么也不做，所以不需要为了复用而追踪被释放的内存。 当有分配内存的请求时，它会返回下一块剩余的内存，直到所有的内存都被消耗光。

如果你既没有delete操作又有足够的内存来浪费（因为不会重用之前被使用过的内存所以比较浪费内存） 那么推荐使用这种资源。

我们已经在第一个示例中看到了

```text
monotonic_buffer_resource
```

的应用， 在这个例子中我们向池传递了在栈上分配的内存：

```cpp
std::array<std::byte, 200000> buf;
std::pmr::monotonic_buffer_resource pool{buf.data(), buf.size()};
```

你也可以使用这个池来让所有的内存资源跳过释放操作（初始大小参数是可选的）。 默认构造时会作用于默认内存资源，默认情况下是

```text
new_delete_resource()
```

的返回值。 如下代码：

```cpp
// 使用默认的内存资源但是在池销毁之前跳过释放操作：
{
    std::pmr::monotonic_buffer_resource pool;

    std::pmr::vector<std::pmr::string> coll{&pool};
    for (int i = 0; i < 100; ++i) {
        coll.emplace_back("just a non-SSO string");
    }
    coll.clear();   // 销毁元素但不会释放内存
}   // 释放所有分配的内存
```

语句块内每一次循环都会为vector和它的元素分配内存。因为我们使用了池，所以所有的内存 都是按块分配的，这可能导致整个过程只需要14次分配。 如果先调用

```text
coll.reserve(100)
```

，那么可能会变成只需要两次分配。

如同之前所述，池的生命周期内不会释放内存。因此，如果在循环内不停地创建并使用vector， 池里被分配的内存会持续增多。

```text
monotonic_buffer_resource
```

还允许我们传递一个初始的大小，它将被用作第一次 内存分配的最小值（当第一次请求内存之后会发生）。 另外，你可以指定这个资源使用哪种底层内存资源来进行分配操作。 这允许我们 _串联_ 不同的内存资源来提供更多复杂的内存资源。

考虑下面的例子：

```cpp
{
    // 创建不会释放内存、按照块分配内存的池（初始大小为10k）
    std::pmr::monotonic_buffer_resource keepAllocatedPool{10000};
    std::pmr::synchronized_pool_resource pool{&keepAllocatedPool};

    for (int j = 0; j < 100; ++j) {
        std::pmr::vector<std::pmr::string> coll{&pool};
        for (int i = 0; i < 100; ++i) {
            coll.emplace_back("just a non-SSO string");
        }
    }   // 底层的池收到了释放操作，但不会释放内存
    // 到此没有释放任何内存
}   // 释放所有内存
```

这段代码中，我们首先为所有的内存创建了一个起始大小为10,000字节的池 （这些内存是使用默认的内存资源分配的），在它被销毁之前将不会释放任何内存：

```text
std::pmr::monotonic_buffer_resource keepAllocatedPool{10000};
```

之后，我们创建了另一个使用这个不释放内存的池来按块分配内存的池：

```cpp
std::pmr::synchronized_pool_resource pool{&keepAllocatedPool};
```

组合之后的效果是我们有了这样一个池：它第一次分配内存时会分配10,000字节， 如果必要的话会以很小的内存碎片来分配内存，并且可以被所有使用`pool` 的pmr对象使用。

分配的内存包括一开始的10,000字节加上后来分配的更大的内存块， 将会在`keepAllocatedPool`离开作用域时销毁。

这里发生的精确行为将在之后嵌套池

### null\_memory\_resource()

```text
null_memory_resource()
```

会对分配操作进行处理，让每一次分配都抛出`bad_alloc` 异常。

它最主要的应用是确保使用在栈上分配的内存的池不会突然在堆上分配额外的内存。 考虑下面的例子：

```cpp
#include <iostream>
#include <string>
#include <unordered_map>
#include <array>
#include <cstddef>  // for std::byte
#include <memory_resource>

int main()
{
    // 使用栈上的内存并且不用堆作为备选项：
    std::array<std::byte, 200000> buf;
    std::pmr::monotonic_buffer_resource pool{buf.data(), buf.size(),
                                             std::pmr::null_memory_resource()};

    // 然后分配过量的内存
    sdt::pmr::unordered_map<long, std::pmr::string> coll{&poll};
    try {
        for (int i = 0; i < buf.size(); ++i) {
            std::string s{"Customer" + std::to_string(i)};
            coll.emplace(i, s);
        }
    }
    catch (const std::bad_alloc& e) {
        std::cerr << "BAD ALLOC EXCEPTION: " << e.what() << '\n';
    }
    std::cout << "size: " << coll.size() << '\n';
}
```

我们在栈上分配了内存，并把它作为内存资源传递给了一个monotonic缓冲区：

```cpp
std::array<std::byte, 200000> buf;
std::pmr::monotonic_buffer_resource pool{buf.data(), buf.size(),
                                         std::pmr::null_memory_resource()};
```

通过传递`null_memory_resource()`作为备选内存资源，我们可以确保任何尝试分配 更多内存的行为都会抛出异常而不是在堆上分配内存。

效果就是程序早晚会结束，并带有类似于下面的输出：

```text
BAD ALLOC EXCEPTION: bad allocation
size: 2048
```

当不想在堆上分配内存时，这样可以帮助你获得有意义的反馈，而不是陷入想要避免的行为。

### 29.2 定义自定义内存资源

你现在可以提供自定义内存资源。要想这么做，你需要：

-   从std::pmr::memory\_resource  
    派生
-   实现下列私有函数
-   do\_allocate()  
    来分配内存
-   do\_deallocate()  
    来释放内存
-   do\_is\_equal()  
    来定义什么情况下何时你的类型可以和其他内存资源对象交换分配的内存

这里有一个让我们可以追踪所有内存资源的分配和释放操作的完整示例：

```cpp
#include <iostream>
#include <string>
#include <memory_resource>

class Tracker : public std::pmr::memory_resource
{
private:
    std::pmr::memory_resource *upstream;    // 被包装的内存资源
    std::string prefix{};
public:
    // 包装传入的或者默认的资源：
    explicit Tracker(std::pmr::memory_resource *us
            = std::pmr::get_default_resource()) : upstream{us} {
    }

    explicit Tracker(std::string p, std::pmr::memory_resource *us
            = std::pmr::get_default_resource()) : prefix{std::move(p)}, upstream{us} {
    }
private:
    void* do_allocate(size_t bytes, size_t alignment) override {
        std::cout << prefix << "allocate " << bytes << " Bytes\n";
        void* ret = upstream->allocate(bytes, alignment);
        return ret;
    }
    void do_deallocate(void* ptr, size_t bytes, size_t alignment) override {
        std::cout << prefix << "deallocate " << bytes << " Bytes\n";
        upstream->deallocate(ptr, bytes, alignment);
    }
    bool do_is_equal(const std::pmr::memory_resource& other) const noexcept override {
        // 是同一个对象？
        if (this == &other)
            return true;
        // 是相同的类型并且prefix和upstream都相等？
        auto op = dynamic_cast<const Tracker*>(&other);
        return op != nullptr && op->prefix == prefix && upstream->is_equal(other);
    }
};
```

就像通常的智能内存资源一样，我们支持传递另一个内存资源（通常叫做`upstream`） 来包装它或者将它用作备选项。另外，我们可以传递一个可选的前缀。 每一次输出分配或释放操作信息时都会先输出这个可选的前缀。

我们唯一需要实现的其他函数是`do_is_equal()` ，它定义了何时两个内存资源可以交换 （即一个多态内存资源对象是否以及何时可以释放另一个多态内存资源对象分配的内存）。 在这里，我们简单的认为,只要前缀相同，这种类型的对象都可以释放另一个该类型对象分配的内存：

```cpp
bool do_is_equal(const std::pmr::memory_resource& other) const noexcept override {
    // 是同一个对象？
    if (this == &other)
        return true;
    // 是相同的类型并且prefix和upstream都相等？
    auto op = dynamic_cast<const Tracker*>(&other);
    return op != nullptr && op->prefix == prefix && upstream->is_equal(other);
}
```

第一个比较是为了跳过随后的开销更大的比较。如果不是在比较同一个追踪器， 那么另一个内存资源也必须是拥有相同前缀（值相等意义上的相同）的追踪器， 并且底层资源类型要可以交换时我们才认为两个追踪器可交换。 否则，如果我们使用了底层内存资源不同的追踪器， 程序会假设释放另一个完全不同的内存资源分配的内存是OK的。

让我们使用这个追踪器来理解之前展示的嵌套池在 不释放内存的情况下按块分配内存的行为：

```cpp
#include "tracker.hpp"
#include <iostream>
#include <string>
#include <vector>
#include <memory_resource>

int main()
{
    {
        // 追踪不会释放内存、按照块分配内存的池（初始大小为10k）的内存分配情况：
        Tracker track1{"keeppool:"};
        std::pmr::monotonic_buffer_resource keeppool{10000, &track1};
        {
            Tracker track2{"  syncpool:", &keeppool};
            std::pmr::synchronized_pool_resource pool{&track2};

            for (int j = 0; j < 100; ++j) {
                std::pmr::vector<std::pmr::string> coll{&pool};
                coll.reserve(100);
                for (int i = 0; i < 100; ++i) {
                    coll.emplace_back("just a non-SSO string");
                }
                if (j == 2)
                    std::cout << "--- third iteration done\n";
            }   // 底层的池收到了释放操作，但不会释放内存
            // 到此没有释放任何内存
            std::cout << "--- leave scope of pool\n";
        }
        std::cout << "--- leave scope of keeppool\n";
    }   // 释放所有内存
}
```

输出可能类似于如下：

```text
  syncpool:allocate 48 Bytes
keeppool:allocate 10000 Bytes
  syncpool:allocate 16440 Bytes
keeppool:allocate 16464 Bytes
  syncpool:allocate 96 Bytes
keeppool:allocate 24696 Bytes
  syncpool:deallocate 48 Bytes
  syncpool:allocate 312 Bytes
  syncpool:allocate 568 Bytes
  syncpool:allocate 1080 Bytes
  syncpool:allocate 2104 Bytes
  syncpool:allocate 4152 Bytes
  syncpool:deallocate 312 Bytes
  syncpool:deallocate 568 Bytes
  syncpool:deallocate 1080 Bytes
  syncpool:deallocate 2104 Bytes
  syncpool:allocate 8248 Bytes
  syncpool:deallocate 4152 Bytes
--- third iteration done
--- leave scope of pool
  syncpool:deallocate 8248 Bytes
  syncpool:deallocate 16440 Bytes
  syncpool:deallocate 96 Bytes
--- leave scope of keeppool
keeppool:deallocate 24696 Bytes
keeppool:deallocate 16464 Bytes
keeppool:deallocate 10000 Bytes
```

这些输出展示了如下过程：

-   第一次为对象分配内存时，syncpool  
    要分配48个字节， 这触发了keeppool  
    分配初始的10,000个字节。 这10,000个字节使用keeppool  
    初始化时get\_defalut\_resource()  
    返回的资源在堆上分配。
-   之后的对象不停地分配和释放内存，导致syncpool  
    偶尔会分配更多的内存块， 也会释放内存块。如果syncpool  
    分配的内存超过了keeppool  
    分配的， 那么keeppool  
    将会从堆上分配更多的内存。因此，只有keeppool  
    分配内 存时会调用（开销很大的）系统调用。
-   通过在第三次迭代结束时的额外追踪，你可以看到所有的分配操作都发生在前三次迭代。 之后（重新）使用的内存数量就处于稳定状态。因此，剩余的97次迭代不会从操作系统分配任何内存。
-   keeppool  
    不会释放任何内存，即使syncpool  
    已经释放了它的内存。
-   只有当keeppool  
    销毁时3个分配的内存块才会真正的调用::delete  
    （ 或者keeppool  
    初始化之前用set\_default\_resource()  
    设置的默认资源 释放内存的方式）释放。

如果我们在这个程序中引入第3个追踪器，我们还可以追踪对象什么时候从`synpool` 中 分配和释放内存：

```cpp
// 追踪所有sync pool和mono pool中的调用：
Tracker track1{"keeppool1:"};
std::pmr::monotonic_buffer_resource keepAllocatedPool{10000, &track1};
Tracker track2{"  syncpool:", &keepAllocatedPool};
std::pmr::synchronized_pool_resource syncPool{&track2};
Tracker track3{"    objects", &syncPool};
...
std::pmr::vector<std::pmr::string> coll{&track3};
```

### 29.2.1 内存资源的等价性

让我们简要的讨论`do_is_equal()`，这个函数定义了两个内存资源何时是可交换的。 这个函数可能比一开始想的更加复杂。

在我们的追踪器里，我们定义了如果两个资源都是`Tracker`类型并且前缀相同时分配器可交换：

```cpp
bool do_is_equal(const std::pmr::memory_resource& other) const noexcept override {
    // 是同一个对象？
    if (this == &other)
        return true;
    // 是相同的类型并且prefix和upstream都相等？
    auto op = dynamic_cast<const Tracker*>(&other);
    return op != nullptr && op->prefix == prefix && upstream->is_equal(other);
}
```

这会有如下效果：

```cpp
Tracker track1{"track1:"};
Tracker track2{"track2:"};

std::pmr::string s1{"more than 15 chars", &track1}; // 用track1分配
std::pmr::string s2{std::move(s1), &track1};        // move（同一个追踪器）
std::pmr::string s3{std::move(s2), &track2};        // 拷贝（前缀不同）
std::pmr::string s4{std::move(s3)};                 // move（分配器被拷贝）
std::string s5{std::move(s4)};                      // 拷贝（其他的分配器）
```

这是因为，只有当源对象和目的对象的分配器可交换时才会发生move。 这也是多态分配器类型调用移动构造函数的条件（新的对象会拷贝分配器）。 然而，如果使用了不可交换的分配器（例如这里前缀不同的追踪器）或者类型不同的分配器 （这里`std::string`的分配器是默认分配器），那么内存会被拷贝。 因此，是否可交换会影响move的性能。

如果我们改成只检查类型来允许所有`Tracker`类型的内存资源都可交换：

```cpp
bool do_is_equal(const std::pmr::memory_resource& other) const noexcept override {
    // 只要类型相同，所有的Tracker都可交换：
    return this == &other || dynamic_cast<const Tracker*>(&other) != nullptr;
}
```

我们会得到如下结果：

```cpp
Tracker track1{"track1:"};
Tracker track2{"track2:"};

std::pmr::string s1{"more than 15 chars", &track1}; // 用track1分配
std::pmr::string s2{std::move(s1), &track1};        // move（分配器类型相同）
std::pmr::string s3{std::move(s2), &track2};        // move（分配器类型相同）
std::pmr::string s4{std::move(s3)};                 // move（分配器被拷贝）
std::string s5{std::move(s4)};                      // 拷贝（其他的分配器）
```

可以看到，这样做的效果是`track1`分配的内存将会传递给`s3`再传递 给`s4`，后两者都使用了`track2`，因此我们得到：

```cpp
track1:allocate 32 Bytes
track2:deallocate 32 Bytes
```

如果我们的内存资源不会有不同的状态（即没有前缀）这将是一个很好的实现，因为这样可以提高move的性能。

因此，让内存资源可交换是值得的，因为可以减少拷贝。然而，你不应该让它们在需求之外的场景可交换。

### 29.3 为自定义类型提供内存资源支持

现在我们已经介绍了标准内存资源和用户自定义的内存资源，只剩最后一个问题了： 我们怎么保证自己的自定义类型支持多态分配器来保证它们能像`pmr::string`一样 作为一个pmr容器的元素？

### 29.3.1 定义PMR类型

想要支持多态分配器出乎意料的简单， 你只需要：

-   定义一个public成员allocator\_type  
    作为一个多态分配器
-   为所有构造函数添加一个接受分配器作为额外参数的重载（包括拷贝和移动构造函数）
-   给初始化用的构造函数的分配器参数添加一个默认的allocator\_type  
    类型的值 （ _不_ 包括拷贝和移动构造函数）

这里有一个例子：

```cpp
#include <string>
#include <memeory_resource>

// 支持多态分配器的顾客类型
// 分配器存储在字符串成员中
class PmrCustomer
{
private:
    std::pmr::string name;  // 也可以用来存储分配器
public:
    using allocator_type = std::pmr::polymorphic_allocator<char>;

    // 初始化构造函数：
    PmrCustomer(std::pmr::string n, allocator_type alloc = {}) : name{std::move(n), alloc} {
    }

    // 带有分配器的移动，构造函数：
    PmrCustomer(const PmrCustomer& c, allocator_type alloc) : name{c.name, alloc} {
    }
    PmrCustomer(PmrCustomer&& c, allocator_type alloc) : name{std::move(c.name), alloc} {
    }

    // setter/getter：
    void setName(std::pmr::string s) {
        name = std::move(s);
    }
    std::pmr::string getName() const {
        return name;
    }
    std::string getNameAsString() const {
        return std::string{name};
    }
};
```

首先要注意的是我们使用了一个pmr字符串作为成员。它不仅存储值（这里是顾客的名字）， 还存储当前使用的分配器：

```cpp
std::pmr::string name;  // 也可以用来存储分配器
```

之后，我们必须指明这个类型支持多态分配器，只需要提供类型`allocator_type` 的声明即可：

```cpp
using allocator_type = std::pmr::polymorphic_allocator<char>;
```

传递给`polymorphic_allocator`的模板参数无关紧要 （当使用它时分配器会自动回弹到需要的类型）。例如，你也可以在这里使用`std::byte`。

或者，你也可以使用pmr string成员的`allocator_type`：

```cpp
using allocator_type = decltype(name)::allocator_type;
```

接下来我们定义了有一个可选的分配器参数的普通构造函数：

```cpp
PmrCustomer(std::pmr::string n, allocator_type alloc = {}) : name{std::move(n), alloc} {
}
```

你可能会想把这个构造函数声明为`explicit` 。 至少，如果你有默认构造函数时，你应该这么做来避免分配器隐式转换成顾客类型：

```cpp
explicit PmrCustomer(allocator_type alloc = {}) : name{alloc} {
}
```

之后，我们还需要提供需要一个特定分配器的拷贝和移动构造函数。这是pmr容器保证 它们的元素也使用容器的分配器的关键接口：

```cpp
PmrCustomer(const PmrCustomer& c, allocator_type alloc) : name{c.name, alloc} {
}
PmrCustomer(PmrCustomer&& c, allocator_type alloc) : name{std::move(c.name), alloc} {
}
```

注意这两个函数都没有`noexcept` 声明，因为如果分配器`alloc`不可互换的话即使是 移动构造函数也需要拷贝传递的顾客类型。

最后，我们实现了必须的setter和getter，通常是这样：

```cpp
void setName(std::pmr::string s) {
    name = std::move(s);
}
std::pmr::string getName() const {
    return name;
}
```

我们还实现了另一个getter `getNameAsString()`，它会以较小的代价把name作为`std::string`返回。 我们在下文讨论它。现在你可以不用考虑这个。

### 29.3.2 使用PMR类型

有了之前的`PmrCustomer` 类的定义，我们可以在pmr容器中使用这个类。例如：

```cpp
#include "pmrcustomer.hpp"
#include "tracker.hpp"
#include <vector>

int main()
{
    Tracker tracker;
    std::pmr::vector<PmrCustomer> coll(&tracker);
    coll.reserve(100);                      // 使用tracker分配

    PmrCustomer c1{"Peter, Paul & Mary"};   // 使用get_default_resource()分配
    coll.push_back(c1);                     // 使用vector的分配器(tracker)分配
    coll.push_back(std::move(c1));          // 拷贝（分配器不可交换）

    for (const auto& cust : coll) {
        std::cout << cust.getName() << '\n';
    }
}
```

为了让过程更清楚，我们使用了Tracker来追踪所有分配和释放操作：

```cpp
Tracker tracker;
std::pmr::vector<PmrCustomer> coll(&tracker);
```

当我们预先分配100个元素的内存时，vector会使用我们的追踪器分配必须的内存：

```cpp
coll.reserve(100);      // 使用tracker分配
```

当我们创建一个顾客对象时不会使用追踪器：

```cpp
PmrCustomer c1{"Peter, Paul & Mary"};   // 使用get_default_resource()分配
```

然而，当我们把这个顾客对象拷贝到vector中时，vector会保证所有的元素都使用它的分配器。 因此，会调用`PmrCustomer`的扩展的拷贝构造函数，vector会把自己的分配器作为第二个参数 传入，所以元素的分配器也会初始化为追踪器。

```text
std::pmr::vector<PmrCustomer> coll(&tracker);
...
PmrCustomer c1{"Peter, Paul & Mary"};   // 使用get_default_resource()分配
coll.push_back(c1);                     // 使用vector的分配器(tracker)分配
```

如果我们把元素move进容器时也会发生同样的过程，因为vecotr的分配器（tracker）和顾客类的 分配器（使用默认资源）是不可交换的：

```cpp
std::pmr::vector<PmrCustomer> coll(&tracker);
...
PmrCustomer c1{"Peter, Paul & Mary"};   // 使用get_default_resource()分配
...
coll.push_back(std::move(c1));          // 拷贝（分配器不可交换）
```

如果我们把顾客对象的分配器也初始化为追踪器，move将会生效：

```cpp
std:pmr::vector<PmrCustomer> coll(&tracker);
...
PmrCustoemr c1{"Peter, Paul & Mary", &tracker); // 使用tracker分配
...
coll.push_back(std::move(c1));                  // move（分配器相同）
```

如果我们完全不使用任何追踪器也可以move：

```cpp
std::pmr::vector<PmrCustomer> coll;             // 用默认资源分配
...
PmrCustomer c1{"Peter, Paul & Mary"};           // 用默认资源分配
...
coll.push_back(std::move(c1));                  // move（分配器相同）
```

### 29.3.3 处理不同的类型

虽然使用pmr类型的`PmrCustomer` 很舒服，但也有一个问题： 一般来说，程序员会使用`std::string`类型的字符串。 所以难道我们需要同时处理`std::string`和`std::pmr::string`？

首先，这两个类型之间有显式的转换，但没有隐式的转换：

```text
std::string s;
std::pmr::string t1{s};     // OK
std::pmr::string t2 = s;    // ERROR
s = t1;                     // ERROR
s = std::string(t1);        // OK
```

支持显式转换是因为所有的字符串都可以隐式转换为字符串视图，它又可以显式 转换为任何字符串类型。前者开销很小，但后者需要分配内存（如果有短字符串优化可能不需要分配）。

在我们的例子中，这意味着：

```cpp
std::string s{"Paul Kalkbrenner"};
PmrCustomer c1 = s;                     // ERROR：没有隐式转换
PmrCustomer c2{s};                      // ERROR：没有隐式转换
PmrCustomer c3{std::pmr::string{s}};    // OK（隐式转换为string_view）
```

我们可能想提供额外的构造函数，但不提供它们的一个好处是程序员需要显式的进行这种开销较大的转换。 另外，如果你为不同的字符串类型进行重载（`std::string`和`std::pmr::string`）， 当以`string_view`或者字符串字面量作为实参时可能会产生歧义，这就需要更多的重载。

任何情况下，一个getter只能返回一个类型（因为我们不能只靠返回值类型不同来重载）。 因此，我们可以只提供一个getter，它应该返回API“原生”的类型（这里是`std::pmr::string` ）。 这意味着如果我们返回了一个`std::pmr::string` ，然而我们实际上需要`string` 类型， 那么我们还需要一个显式的转换：

```cpp
PmrCustoemr c4{"Mr. Paul Kalkbrenner"};     // OK：用默认资源分配
std::string s1 = c4.getName();              // ERROR：没有隐式转换
std::string s2 = std::string{c4.getName()}; // OOPS：两次分配内存
```

这样做不仅更不方便，性能也有问题，因为最后一条语句至少要分配两次内存：

-   第一次为返回值分配内存
-   第二次std::pmr::string  
    转换为std::string  
    时也需要分配内存

因此，提供额外的getter `getNameAsString()` 来直接 创建并返回字符串类型是个好主意：

```cpp
std::string s3 = c4.getNameAsString();      // OK：因此分配内存
```

发布于 2022-06-11 11:23