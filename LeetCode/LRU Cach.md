# LRU Cache

# 什么是Cache

## Cache概念

**Cache**，即**高速缓存**，是介于CPU和内存之间的高速小容量存储器。在金字塔式存储体系中它位于自顶向下的第二层，仅次于CPU寄存器。其容量远小于内存，但速度却可以接近CPU的频率。

当CPU发出内存访问请求时，会先查看 Cache 内是否有请求数据。

-   如果存在（命中），则直接返回该数据
-   如果不存在（失效），再去访问内存 —— 先把内存中的相应数据载入缓存，再将其返回处理器

提供“高速缓存”的**目的**是让数据访问的速度适应CPU的处理速度，通过**`减少`访问内存的`次数`来提高数据存取的速度**。

## Cache原理

Cache 技术所依赖的原理是”程序执行与数据访问的**局部性原理**“，这种局部性表现在两个方面：

1.  **时间局部性**：如果程序中的某条指令一旦执行，不久以后该指令可能再次执行，如果某数据被访问过，不久以后该数据可能再次被访问。
2.  **空间局部性**：一旦程序访问了某个存储单元，在不久之后，其附近的存储单元也将被访问，即程序在一段时间内所访问的地址，可能集中在一定的范围之内，这是因为指令或数据通常是顺序存放的。

时间局部性是通过将近来使用的指令和数据保存到Cache中实现。  
空间局部性通常是使用较大的高速缓存，并将 预取机制 集成到高速缓存控制逻辑中来实现。

#### Cache替换策略

Cache的容量是有限的，当Cache的空间都被占满后，如果再次发生缓存失效，就必须选择一个缓存块来替换掉。常用的替换策略有以下几种：

1.  **随机算法（Rand）**：随机法是随机地确定替换的存储块。设置一个随机数产生器，依据所产生的随机数，确定替换块。这种方法简单、易于实现，但命中率比较低。
    
2.  **先进先出算法（FIFO, First In First Out）**：先进先出法是选择那个最先调入的那个块进行替换。当最先调入并被多次命中的块，很可能被优先替换，因而不符合局部性规律。这种方法的命中率比随机法好些，但还不满足要求。
    
3.  **最久未使用算法（LRU, Least Recently Used）**：LRU法是依据各块使用的情况， 总是选择那个最长时间未被使用的块替换。这种方法比较好地反映了程序局部性规律。
    
4.  **最不经常使用算法（LFU, Least Frequently Used）**：将最近一段时期内，访问次数最少的块替换出Cache。
    

## Cache概念的扩充

如今高速缓存的概念已被扩充，不仅在CPU和主内存之间有Cache，而且在内存和硬盘之间也有Cache（磁盘缓存），乃至在硬盘与网络之间也有某种意义上的Cache──称为Internet临时文件夹或网络内容缓存等。**凡是位于速度相差较大的两种硬件之间，用于协调两者数据传输速度差异的结构，均可称之为Cache。**

# LRU总览

LRU全称是`Least Recently Used`，即最近最久未使用的意思。LRU算法的设计原则是：如果一个数据在最近一段时间没有被访问到，那么在将来它被访问的可能性也很小。是缓存中一种常见的机制。

![](https://www.jianshu.com//upload-images.jianshu.io/upload_images/11861611-775535936b311a86.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/736/format/webp)

LRU

## LRU淘汰

**cache（缓存）可以帮助快速存取数据，但是容量小**

**LRU的思想来自“最近用到的数据被重用的`概率`比最早用到的数据大的多”**，是一种十分高效的cache。

他的算法就是当缓存空间满了的时候，将最近最少使用的数据从缓存空间中删除以增加可用的缓存空间来缓存新内容。是一个淘汰策略。

这个算分的内部有一个**缓存列表**。每当一个缓存数据被访问的时候，这个数据就会被提到列表头部，每次都这样的话，列表的尾部数据就是最近最不常使用的了，当缓存空间不足时，就会删除列表尾部的缓存数据。

直接用hashmap无法实现，查找复杂度接近O(1)，但是不能保证存储的是有效的数据。

## LRU分析

简单的说，就是`保证基本的get和set的功能的同时，还要保证最近访问(get或put)的节点保持在限定容量的Cache中`，如果超过容量则应该把LRU(近期最少使用)的节点删除掉。

那么我们思考一个问题：如何设计实现一个LRU Cache？  
那么，我们可能需要使用类似这样的数据结构去实现这个LRU Cache：

![](https://www.jianshu.com//upload-images.jianshu.io/upload_images/11861611-84a14b7297e20548.png?imageMogr2/auto-orient/strip|imageView2/2/w/650/format/webp)

LRU Cache

通过双向链表来保证LRU的`删除`和`更新`操作也能保证O(1)的复杂度。

# LRU实现

**原则就是：每当访问链表时都更新链表节点**

## 若只是用双向链表呢？

对一个Cache的操作无非三种：**插入(insert)、替换(replace)、查找（lookup）**

为了能够快速删除最久没有访问的数据项和插入最新的数据项，我们使用 双向链表 连接Cache中的数据项，并且保证链表维持数据项从最近访问到最旧访问的顺序。

-   插入(insert)  
    当Cache未满时，新的数据项只需插到双链表头部即可。时间复杂度为![O(1)](https://math.jianshu.com/math?formula=O(1)).
    
-   替换(replace) = insert + delete  
    当Cache已满时，将新的数据项插到双链表头部，并删除双链表的尾结点即可。时间复杂度为![O(1)](https://math.jianshu.com/math?formula=O(1)).
    
-   查找（lookup）  
    每次数据项被查询到时，都将此数据项移动到链表头部。
    

经过分析，我们知道使用双向链表可以保证插入和替换的时间复杂度是![O(1)](https://math.jianshu.com/math?formula=O(1))，但查询的时间复杂度是![O(n)](https://math.jianshu.com/math?formula=O(n))，因为需要对双链表进行遍历。为了让查找效率也达到![O(1)](https://math.jianshu.com/math?formula=O(1))，很自然的会想到使用 hash table 。

## 双向链表+HashMap

对于双向链表的使用，基于两个考虑。

-   Cache中块的命中是随机的，和Load进来的顺序无关。
-   双向链表插入、删除很快，可以灵活的调整相互间的次序，时间复杂度为O(1)。

### 1\. Node节点

新建数据类型Node节点，Key-Value值，并有指向前驱节点后后继节点的指针，构成双向链表的节点。

```csharp
class Node {
    int key;
    int value;
    Node pre;
    Node next;
 
    public Node(int key, int value) {
        this.key = key;
        this.value = value;
    }
    
    @Override
    public String toString() {
        return this.key + "-" + this.value + " ";
    }
}
```

### 2\. int get(int key)

#### 链表顺序:从最近访问到最旧访问

为了能够快速删除最久没有访问的数据项和插入最新的数据项，我们将双向链表连接Cache中的数据项，并且保证链表维持数据项从最近访问到最旧访问的顺序。

**每次数据项被查询到时，都将此数据项移动到链表头部（![O(1)](https://math.jianshu.com/math?formula=O(1))的时间复杂度）**

这样，在进行过多次查找操作后，最近被使用过的内容就向链表的头移动，而没有被使用的内容就向链表的后面移动。

当需要替换时，链表最后的位置就是最近最少被使用的数据项，我们只需要将最新的数据项放在链表头部，当Cache满时，淘汰链表最后的位置就是了。

解决了LRU的特性，现在考虑下算法的时间复杂度。为了能减少整个数据结构的时间复杂度，就要减少**查找**的时间复杂度，所以这里利用HashMap来做，这样时间复杂度就是O(1)。

所以对于本题来说：

#### 设计

1.  如果cache中不存在要get的值，返回-1
2.  如果cache中存在要找的值，**返回其值，并将其在原链表中`删除`，然后将其`插入`作为头结点**。

```csharp
public int get(int key) {
        if (map.containsKey(key)) {
            Node n = map.get(key);
            remove(n);//删除
            setHead(n);//插入头
            printNodes("get");//用于测试
            return n.value;
        }
        printNodes("get");
        return -1;
    }
```

### 3\. set(int key, int value)

set(key,value)：

1.  当set的key值已经存在，就`更新`其value， 将其在原链表中`删除`，然后将其`插入`作为头结点
2.  当set的key值不存在，就新建一个node  
    2.1 如果当前`len<capacity`,就将其加入hashmap中，并将其作为头结点，更新len长度  
    2.2 否则，删除链表最后一个node，再将其放入hashmap并作为头结点，但len不更新。

```csharp
public void set(int key, int value) {
        if (map.containsKey(key)) {
            Node old = map.get(key);
            old.value = value;
            remove(old);//删除
            setHead(old);//插入头
        } else {
            Node created = new Node(key, value);
            if (map.size() >= capacity) {
                map.remove(end.key);//map删除
                remove(end);//删除
                setHead(created);
            } else {
                setHead(created);
            }
            map.put(key, created);
        }
        printNodes("set");
    }
```

最后附上完整源代码及输出结果如下：

```csharp
public class LRUCache3 {
    class Node {
        int key;
        int value;
        Node pre;
        Node next;

        public Node(int key, int value) {
            this.key = key;
            this.value = value;
        }

        @Override
        public String toString() {
            return this.key + ":" + this.value + " ";
        }
    }

    int capacity;
    HashMap<Integer, Node> map = new HashMap<Integer, Node>();
    Node head = null;
    Node end = null;

    public LRUCache3(int capacity) {
        this.capacity = capacity;
    }

    public int get(int key) {
        if (map.containsKey(key)) {
            Node n = map.get(key);
            remove(n);
            setHead(n);
            printNodes("get");
            return n.value;
        }
        printNodes("get");
        return -1;
    }

    public void remove(Node n) {
        if (n.pre != null) {
            n.pre.next = n.next;
        } else {
            head = n.next;
        }

        if (n.next != null) {
            n.next.pre = n.pre;
        } else {
            end = n.pre;
        }

    }

    public void setHead(Node n) {
        n.next = head;
        n.pre = null;

        if (head != null)
            head.pre = n;

        head = n;

        if (end == null)
            end = head;
    }

    public void set(int key, int value) {
        if (map.containsKey(key)) {
            Node old = map.get(key);
            old.value = value;
            remove(old);
            setHead(old);
        } else {
            Node created = new Node(key, value);
            if (map.size() >= capacity) {
                map.remove(end.key);
                remove(end);
                setHead(created);

            } else {
                setHead(created);
            }

            map.put(key, created);
        }
        printNodes("set");
    }

    public void printNodes(String explain) {

        System.out.print(explain + ":" + head.toString());
        Node node = head.next;
        while (node != null) {
            System.out.print(node.toString());
            node = node.next;
        }
        System.out.println();
    }

    public static void main(String[] args) {
        LRUCache3 lruCache3 = new LRUCache3(5);
        lruCache3.set(1, 100);
        lruCache3.set(2, 200);
        lruCache3.set(3, 300);
        lruCache3.set(4, 400);
        lruCache3.set(5, 500);
        System.out.println("lruCacheTest.get(1):" + lruCache3.get(1));
        lruCache3.set(6, 600);
        System.out.println("lruCacheTest.get(2):" + lruCache3.get(2));
    }
}
```

输出：

```css
set:1:100 
set:2:200 1:100 
set:3:300 2:200 1:100 
set:4:400 3:300 2:200 1:100 
set:5:500 4:400 3:300 2:200 1:100 
get:1:100 5:500 4:400 3:300 2:200 
lruCacheTest.get(1):100
set:6:600 1:100 5:500 4:400 3:300 
get:6:600 1:100 5:500 4:400 3:300 
lruCacheTest.get(2):-1
```

## 基于LinkedHashMap的实现

缓存这个东西就是为了提高运行速度的，由于缓存是在寸土寸金的内存里面，不是在硬盘里面，所以容量是很有限的。LRU这个算法就是把最近一次使用时间离现在时间最远的数据删除掉。

LinkedHashMap默认的元素顺序是put的顺序，但是如果使用带参数的构造函数，那么LinkedHashMap会根据访问顺序来调整内部顺序。 LinkedHashMap的get()方法除了返回元素之外还可以把被访问的元素放到链表的底端，这样一来每次顶端的元素就是remove的元素。

### 构造函数

```java
public LinkedHashMap (int initialCapacity, float loadFactor, boolean accessOrder)；
```

-   initialCapacity  
    初始容量
-   loadFactor  
    加载因子，一般是 0.75f
-   accessOrder  
    false 基于插入顺序  
    true 基于访问顺序（get一个元素后，这个元素被加到最后，使用了LRU 最近最少被使用的调度算法）

### removeEldestEntry(Map.Entry<K,V> eldest)

LinkedHashMap自带的判断是否删除最老的元素方法，默认返回false，即不删除老数据  
我们要做的就是重写这个方法，当**满足一定条件时删除老数据**

```java
protected boolean removeEldestEntry(Map.Entry<K,V> eldest) {
        return false;
}
```

### 实现

```java
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 简单用LinkedHashMap来实现的LRU算法的缓存
 */
public class LRUCache2<K, V> extends LinkedHashMap<K, V> {
    private int cacheSize;

    public LRUCache2(int cacheSize) {
        super(16, (float) 0.75, true);
        this.cacheSize = cacheSize;
    }

    protected boolean removeEldestEntry(Map.Entry<K, V> eldest) {
        return size() > cacheSize;
    }

    public static void main(String[] args) {
        LRUCache2<Integer, Integer> lruCache2 = new LRUCache2<>(5);
        lruCache2.put(1, 100);
        lruCache2.put(2, 200);
        lruCache2.put(3, 300);
        lruCache2.put(4, 400);
        lruCache2.put(5, 500);
        System.out.println("LRUCache2.get(1):" + lruCache2.get(1));
        lruCache2.put(6, 600);
        System.out.println("LRUCache2.get(2):" + lruCache2.get(2));
    }
}
```

输出：

```css
LRUCache2.get(1):100
LRUCache2.get(2):null
```