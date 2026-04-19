
# PMR  

从 C++17 开始，标准库增加了一个名为 Polymorphic Memory Resources 的特性，缩写为 PMR。这个特性提供了一种新的内存分配策略，允许开发者更灵活地控制内存的分配与回收。基于此特性，std::pmr 命名空间被引入，其中包含了一系列使用多态分配器的容器，std::pmr::unordered_map 就是这些容器之一。std::pmr::unordered_map 本质上是 std::unordered_map 的一个特化版本，它使用了多态分配器 (std::pmr::polymorphic_allocator)。这个多态分配器使得容器能够在运行时更改其内存分配策略，而无需重新编写容器类型或改变其接口。主要特点内存资源的抽象：std::pmr::polymorphic_allocator 是基于 std::pmr::memory_resource 抽象基类的，后者定义了一个接口，用于内存的分配和回收。这允许开发者实现自定义的内存资源，并将其传递给容器使用。运行时灵活性：当你想要在不同的内存资源之间动态切换，或者想要使用特定的内存分配策略（例如，用于缓冲区管理、内存池或者共享内存场景）时，std::pmr::unordered_map 可以使用外部提供的任意 std::pmr::memory_resource 实例。易于切换分配器：与标准的 std::allocator 不同，std::pmr::polymorphic_allocator 能够在不同的容器实例之间传递，即使这些容器的类型不同。这种多态性允许开发者自定义内存分配策略，例如：使用特殊内存区域（如 NUMA 节点）；跟踪和分析内存使用；提供预分配的内存池；实现垃圾回收机制；提供线程本地存储以优化并发。

```cpp
#include <memory_resource>
#include <unordered_map>

int main() {
    // 创建一个特定的内存资源，例如 monotonic_buffer_resource，它可以从预分配的内存中快速分配。
    std::pmr::monotonic_buffer_resource pool(1024); 
    // 分配一个带有 1024 字节的初始内存池

    // 创建一个 unordered_map，使用上面创建的内存资源进行分配。
    std::pmr::unordered_map<int, std::string> myMap(&pool);

    // 使用 unordered_map，分配的内存来自 pool。
    myMap[1] = "one";
    myMap[2] = "two";
    myMap[3] = "three";

    // 其他操作...
}
```

在这个例子中，std::pmr::unordered_map 使用了 monotonic_buffer_resource，这是一个简单且高效的内存资源，它从一个固定大小的缓冲区分配内存，并且不能被单独回收，只有当整个资源被销毁时，所有的内存才会一起释放。这对于生命周期预知的用例特别有用，它可以减少分配和释放操作，从而提高性能。而上面的demo中用到了std::pmr::monotonic_buffer_resource std::pmr::monotonic_buffer_resource 是 C++17 引入的一种内存资源（memory resource），它属于多态分配器库 (<memory_resource> header)。它的工作原理是在一个单调增长的内存块上进行内存分配。这意味着它只会一直向上分配内存，而不会单独释放单个对象，不过你可以一次性释放所有资源。在实际场景中，当你有大量的对象需要分配，且它们具有相似的生命周期时，使用 std::pmr::monotonic_buffer_resource 可以提高内存分配和释放的效率。下面是如何定义和使用 std::pmr::monotonic_buffer_resource 的一个基本示例：

```cpp
#include <memory_resource>
#include <vector>
int main() {
    // 创建一个缓冲区
    char buffer[1024];

    // 使用缓冲区创建 monotonic_buffer_resource
    std::pmr::monotonic_buffer_resource resource(buffer, sizeof(buffer));

    // 创建一个 vector，使用刚才创建的 memory resource 进行分配
    std::pmr::vector<int> vec(&resource);

    // 添加元素到 vector
    vec.push_back(1);
    vec.push_back(2);
    vec.push_back(3);

    // resource 会在超出范围时自动释放分配的所有内存
    // 注意：由于使用了 stack 上的缓冲区，无需手动释放内存
}
```

在上面的代码中，我们首先创建了一个堆栈上的缓冲区 buffer。然后，使用这个缓冲区创建了 std::pmr::monotonic_buffer_resource。之后，我们创建了一个 std::pmr::vector，它使用这个内存资源进行内存分配。当 std::pmr::monotonic_buffer_resource 超出作用域时，所有通过它分配的内存都会被释放。关于线程池的问题，std::pmr::monotonic_buffer_resource 不是线程安全的，因此如果你在多线程环境中使用它，你需要确保对它的访问是同步的。在使用线程池或并发场景时，你可能需要为每个线程分配一个单独的 monotonic_buffer_resource，或者使用锁或其他同步机制来保证线程安全。当然这也是一个简单使用层面的demo；本章主要记录下std::pmr::monotonic_buffer_resource的使用，后面再详细分析原理。
