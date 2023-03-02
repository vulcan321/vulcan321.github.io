# 缓存淘汰算法--LRU算法



一个用hash表作为底层结构的数据库，当然少不了缓存淘汰算法。

LRU（Least recently used，最近最少使用）算法根据数据的历史访问记录来进行淘汰数据，其核心思想是“如果数据最近被访问过，那么将来被访问的几率也更高”。

![](https://pic4.zhimg.com/80/v2-71b21233c615b1ce899cd4bd3122cbab_720w.webp)

1.  新数据插入到链表头部；
2.  每当缓存命中（即缓存数据被访问），则将数据移到链表头部；
3.  当链表满的时候，将链表尾部的数据丢弃。

过程如下：

![](https://pic3.zhimg.com/80/v2-998b52e7534278b364e439bbeaf61d5e_720w.webp)

1.  最开始时，内存空间是空的，因此依次进入A、B、C是没有问题的
2.  当加入D时，就出现了问题，内存空间不够了，因此根据LRU算法，内存空间中A待的时间最为久远，选择A,将其淘汰
3.  当再次引用B时，内存空间中的B又处于活跃状态，而C则变成了内存空间中，近段时间最久未使用的
4.  当再次向内存空间加入E时，这时内存空间又不足了，选择在内存空间中待的最久的C将其淘汰出内存，这时的内存空间存放的对象就是E->B->D

附上：golang算法

```go
package lru

import "container/list"

type LRUCache struct {
capacity int
cache    map[int]*list.Element
list     *list.List
}
type Pair struct {
key   int
value int
}

func Constructor(capacity int) LRUCache {
return LRUCache{
capacity: capacity,
list:     list.New(),
cache:    make(map[int]*list.Element),
}
}

func (this *LRUCache) Get(key int) int {
if elem, ok := this.cache[key]; ok {
this.list.MoveToFront(elem)
return elem.Value.(Pair).value
}
return -1
}

func (this *LRUCache) Put(key int, value int) {
if elem, ok := this.cache[key]; ok {
this.list.MoveToFront(elem)
elem.Value = Pair{key, value}
} else {
if this.list.Len() >= this.capacity {
delete(this.cache,this.list.Back().Value.(Pair).key)
this.list.Remove(this.list.Back())
}
this.list.PushFront(Pair{key, value})
this.cache[key] = this.list.Front()
}
}
```

LRU其实还可以再优化，用过redis的都知道可以过期时间，在LRUCache数据结构里面设置TTL过期时间也是可以的，详细的自己慢慢实现吧。