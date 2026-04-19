# LRU算法四种实现方式介绍


分类专栏： [算法](https://blog.csdn.net/elricboa/category_7304330.html) 文章标签： [java](https://so.csdn.net/so/search/s.do?q=java&t=all&o=vip&s=&l=&f=&viparticle=) [算法](https://so.csdn.net/so/search/s.do?q=%E7%AE%97%E6%B3%95&t=all&o=vip&s=&l=&f=&viparticle=)


本文链接：[https://blog.csdn.net/elricboa/article/details/78847305](https://blog.csdn.net/elricboa/article/details/78847305)

LRU全称是Least Recently Used，即最近最久未使用的意思。

# LRU算法的设计原则是：**如果一个数据在最近一段时间没有被访问到，那么在将来它被访问的可能性也很小**。也就是说，当限定的空间已存满数据时，应当把最久没有被访问到的数据淘汰。

# 实现LRU

1\. 用一个数组来存储数据，给每一个数据项标记一个访问时间戳，每次插入新数据项的时候，先把数组中存在的数据项的时间戳自增，并将新数据项的时间戳置为0并插入到数组中。每次访问数组中的数据项的时候，将被访问的数据项的时间戳置为0。当数组空间已满时，将时间戳最大的数据项淘汰。

  

2.利用一个链表来实现，每次新插入数据的时候将新数据插到链表的头部；每次缓存命中（即数据被访问），则将数据移到链表头部；那么当链表满的时候，就将链表尾部的数据丢弃。

  

3\. 利用链表和hashmap。当需要插入新的数据项的时候，如果新数据项在链表中存在（一般称为命中），则把该节点移到链表头部，如果不存在，则新建一个节点，放到链表头部，若缓存满了，则把链表最后一个节点删除即可。在访问数据的时候，如果数据项在链表中存在，则把该节点移到链表头部，否则返回-1。这样一来在链表尾部的节点就是最近最久未访问的数据项。

  

对于第一种方法， 需要不停地维护数据项的访问时间戳，另外，在插入数据、删除数据以及访问数据时，时间复杂度都是O(n)。对于第二种方法，链表在定位数据的时候时间复杂度为O(n)。所以在一般使用第三种方式来是实现LRU算法。

# 实现方案

  

使用LinkedHashMap实现

     LinkedHashMap底层就是用的HashMap加双链表实现的，而且本身已经实现了按照访问顺序的存储。此外，LinkedHashMap中本身就实现了一个方法removeEldestEntry用于判断是否需要移除最不常读取的数，方法默认是直接返回false，不会移除元素，所以需要重写该方法。即当缓存满后就移除最不常用的数。

```java

public class LRU<K,V> {
 
  private static final float hashLoadFactory = 0.75f;
  private LinkedHashMap<K,V> map;
  private int cacheSize;
 
  public LRU(int cacheSize) {
    this.cacheSize = cacheSize;
    int capacity = (int)Math.ceil(cacheSize / hashLoadFactory) + 1;
    map = new LinkedHashMap<K,V>(capacity, hashLoadFactory, true){
      private static final long serialVersionUID = 1;
 
      @Override
      protected boolean removeEldestEntry(Map.Entry eldest) {
        return size() > LRU.this.cacheSize;
      }
    };
  }
 
  public synchronized V get(K key) {
    return map.get(key);
  }
 
  public synchronized void put(K key, V value) {
    map.put(key, value);
  }
 
  public synchronized void clear() {
    map.clear();
  }
 
  public synchronized int usedSize() {
    return map.size();
  }
 
  public void print() {
    for (Map.Entry<K, V> entry : map.entrySet()) {
      System.out.print(entry.getValue() + "--");
    }
    System.out.println();
  }
}

```

  
  

当存在热点数据时，LRU的效率很好，但偶发性的、周期性的批量操作会导致LRU命中率急剧下降，缓存污染情况比较严重。

# 扩展

## 1.LRU-K

LRU-K中的K代表最近使用的次数，因此LRU可以认为是LRU-1。LRU-K的主要目的是为了解决LRU算法“缓存污染”的问题，其核心思想是将“最近使用过1次”的判断标准扩展为“最近使用过K次”。

相比LRU，LRU-K需要多维护一个队列，用于记录所有缓存数据被访问的历史。只有当数据的访问次数达到K次的时候，才将数据放入缓存。当需要淘汰数据时，LRU-K会淘汰第K次访问时间距当前时间最大的数据。

![](https://wiki.sankuai.com/download/attachments/545354395/646360C1-9F15-42FF-9FA0-47274CBD2B08.png?version=1&modificationDate=1468224185000&api=v2)

数据第一次被访问时，加入到历史访问列表，如果书籍在访问历史列表中没有达到K次访问，则按照一定的规则（FIFO,LRU）淘汰；当访问历史队列中的数据访问次数达到K次后，将数据索引从历史队列中删除，将数据移到缓存队列中，并缓存数据，缓存队列重新按照时间排序；缓存数据队列中被再次访问后，重新排序，需要淘汰数据时，淘汰缓存队列中排在末尾的数据，即“淘汰倒数K次访问离现在最久的数据”。

LRU-K具有LRU的优点，同时还能避免LRU的缺点，实际应用中LRU-2是综合最优的选择。由于LRU-K还需要记录那些被访问过、但还没有放入缓存的对象，因此内存消耗会比LRU要多。

## 2.two queue

Two queues（以下使用2Q代替）算法类似于LRU-2，不同点在于2Q将LRU-2算法中的访问历史队列（注意这不是缓存数据的）改为一个FIFO缓存队列，即：2Q算法有两个缓存队列，一个是FIFO队列，一个是LRU队列。 当数据第一次访问时，2Q算法将数据缓存在FIFO队列里面，当数据第二次被访问时，则将数据从FIFO队列移到LRU队列里面，两个队列各自按照自己的方法淘汰数据。

![](https://wiki.sankuai.com/download/attachments/545354395/13AD8FF5-DFEE-4C02-9A0E-EB71079360CA.png?version=1&modificationDate=1468224185000&api=v2)

新访问的数据插入到FIFO队列中，如果数据在FIFO队列中一直没有被再次访问，则最终按照FIFO规则淘汰；如果数据在FIFO队列中再次被访问到，则将数据移到LRU队列头部，如果数据在LRU队列中再次被访问，则将数据移动LRU队列头部，LRU队列淘汰末尾的数据。

## 3.Multi Queue(MQ)

      MQ算法根据访问频率将数据划分为多个队列，不同的队列具有不同的访问优先级，其核心思想是：优先缓存访问次数多的数据。 详细的算法结构图如下，Q0，Q1....Qk代表不同的优先级队列，Q-history代表从缓存中淘汰数据，但记录了数据的索引和引用次数的队列：

![](https://wiki.sankuai.com/download/attachments/545354395/EA270B97-BA68-4086-8D68-46A2FF09D5FE.png?version=1&modificationDate=1468224185000&api=v2)

新插入的数据放入Q0，每个队列按照LRU进行管理，当数据的访问次数达到一定次数，需要提升优先级时，将数据从当前队列中删除，加入到高一级队列的头部；为了防止高优先级数据永远不会被淘汰，当数据在指定的时间里没有被访问时，需要降低优先级，将数据从当前队列删除，加入到低一级的队列头部；需要淘汰数据时，从最低一级队列开始按照LRU淘汰，每个队列淘汰数据时，将数据从缓存中删除，将数据索引加入Q-history头部。如果数据在Q-history中被重新访问，则重新计算其优先级，移到目标队列头部。 Q-history按照LRU淘汰数据的索引。

  

MQ需要维护多个队列，且需要维护每个数据的访问时间，复杂度比LRU高。

# LRU算法对比

<table class="confluenceTable  " style="border-collapse:collapse; margin:0px; overflow-x:auto"><colgroup><col><col></colgroup><tbody><tr><td class="confluenceTd" style="border:1px solid rgb(221,221,221); padding:7px 10px; vertical-align:top; min-width:8px"><p style="margin-top:0px; margin-bottom:0px; padding-top:0px; padding-bottom:0px">对比点</p></td><td class="confluenceTd" style="border:1px solid rgb(221,221,221); padding:7px 10px; vertical-align:top; min-width:8px"><p style="margin-top:0px; margin-bottom:0px; padding-top:0px; padding-bottom:0px">对比</p></td></tr><tr><td class="confluenceTd" style="border:1px solid rgb(221,221,221); padding:7px 10px; vertical-align:top; min-width:8px"><p style="margin-top:0px; margin-bottom:0px; padding-top:0px; padding-bottom:0px">命中率</p></td><td class="confluenceTd" style="border:1px solid rgb(221,221,221); padding:7px 10px; vertical-align:top; min-width:8px"><p style="margin-top:0px; margin-bottom:0px; padding-top:0px; padding-bottom:0px">LRU-2&nbsp;&gt;&nbsp;MQ(2)&nbsp;&gt;&nbsp;2Q&nbsp;&gt;&nbsp;LRU</p></td></tr><tr><td class="confluenceTd" style="border:1px solid rgb(221,221,221); padding:7px 10px; vertical-align:top; min-width:8px"><p style="margin-top:0px; margin-bottom:0px; padding-top:0px; padding-bottom:0px">复杂度</p></td><td class="confluenceTd" style="border:1px solid rgb(221,221,221); padding:7px 10px; vertical-align:top; min-width:8px"><p style="margin-top:0px; margin-bottom:0px; padding-top:0px; padding-bottom:0px">LRU-2&nbsp;&gt;&nbsp;MQ(2)&nbsp;&gt;&nbsp;2Q&nbsp;&gt;&nbsp;LRU</p></td></tr><tr><td class="confluenceTd" style="border:1px solid rgb(221,221,221); padding:7px 10px; vertical-align:top; min-width:8px"><p style="margin-top:0px; margin-bottom:0px; padding-top:0px; padding-bottom:0px">代价</p></td><td class="confluenceTd" style="border:1px solid rgb(221,221,221); padding:7px 10px; vertical-align:top; min-width:8px"><p style="margin-top:0px; margin-bottom:0px; padding-top:0px; padding-bottom:0px">LRU-2&nbsp;&nbsp;&gt;&nbsp;MQ(2)&nbsp;&gt;&nbsp;2Q&nbsp;&gt;&nbsp;LRU</p></td></tr></tbody></table>