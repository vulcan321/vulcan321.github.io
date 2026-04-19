## 一面

**基础**

-   虚拟内存相关详细讲一下
-   讲讲左值和右值
-   什么时候使用右值
-   完美转发
-   假如 a 是 T 的左值引用，T 是 int&& 类型的，那么 a 实际上是什么
-   讲一下智能指针
-   shared\_ptr 和 unique\_ptr 区别，以及性能对比
-   weak\_ptr 及其作用
-   shared\_ptr 是线程安全的吗
-   lambda 表达式有哪些捕获类型
-   讲讲多态及实现机制
-   虚基类
-   多继承的时候，虚函数表指针怎么存
-   using std::cin 和 在using namespace std 后使用cin有什么区别
-   元编程

**项目**

-   详细介绍MSRA实习项目

-   对交易预测输入和输出需要存储，这个空间消耗大概多大

**思考题**

一个有环链表，两个速度不一样的指针移动，起始位置也不一定一样，它们一定相遇吗

**Coding**

数据中最小的k个数

```cpp
class Solution {
private:
    int randInRange(int l, int r) {
        srand(time(0));
        return rand() % (r - l + 1) + l;
    }
    int partition(vector<int> &input, int l, int r) {
        if (l >= r)    return l;
        int idx = randInRange(l, r);
        swap(input[idx], input[r]);
        int large = l - 1;
        for (int i = l; i < r; ++ i) {
            if (input[i] < input[r]) 
                swap(input[++ large], input[i]);
        }
        swap(input[++ large], input[r]);
        return large;
    }
public:
    vector<int> GetLeastNumbers_Solution(vector<int> input, int k) {
        int n = input.size();
        int l = 0, r = n - 1;
        vector<int> res;
        while (l <= r) {
            int idx = partition(input, l, r);
            if (idx + 1 == k) {
                res.assign(input.begin(), input.begin() + k);
                return res;
            } else if (idx + 1 < k)
                l = idx + 1;
            else 
                r = idx - 1;
        }
        return res;
    }
};
```

## 二面

**基础**

-   首先介绍了自动驾驶系统涉及的研发方向，问我对哪个感兴趣
-   自我介绍
-   发现性能瓶颈使用过什么方法
-   如何发现死锁
-   在开发时制定什么样的规则可以避免死锁
-   如何调试内存泄露
-   如何调试 core dump
-   虚拟内存介绍
-   每个进程的虚拟内存有多大
-   如果物理内存大于 4G，可以不使用虚拟内存吗（安全性）
-   线程切换要进入内核态吗
-   一个很大的二维数组存在内存中，是按行读取快还是按列读取快（CPU cache，局部性原理）
-   map 和 unordered\_map区别
-   unordered\_map 使用什么方法解决 hash 冲突

**Coding**

LRU，要求自己实现双向链表

```cpp
#include <bits/stdc++.h>
using namespace std;

struct Node {
    int key;
    int value;
    Node *left;
    Node *right;
    Node(int k, int v): key(k), value(v) {
        left = nullptr;
        right = nullptr;
    }
    Node(int k, int v, Node *l, Node *r): key(k), value(v), left(l), right(r) {} 
};

struct BiList {
    Node *head;
    Node *tail;
    BiList() { 
        head = new Node(0, 0); 
        tail = head;
    }
    void insert_front(Node *node) {
        auto first = head->right;
        node->right = first;
        head->right = node;
        node->left = head;
        if (first) {
            first->left = node;
        }
        if (tail == head)
            tail = head->right;
    }
    pair<int, int> erase_end() {
        if (tail == head)
            return {-1, -1};
        Node *tmp = tail;
        tmp->left->right = nullptr;
        tail = tmp->left;
        int key = tmp->key, val = tmp->value;
        delete tmp;
        return {key, val};
    }
    void erase(Node *node) {
        if (node == tail)
            tail = node->left;
        auto left = node->left;
        auto right = node->right;
        left->right = right;
        if (right)
            right->left = left;
        delete node;
    }
    Node *first() {
        return head->right;
    }
    ~BiList() {
        Node *ptr = head;
        while (ptr) {
            Node *tmp = ptr->right;
            delete ptr;
            ptr = tmp;
        }
    }
};

class LRUcache {
private:
    int cap;
    BiList *lst;
    unordered_map<int, Node*> mp;
public:
    LRUcache(int k): cap(k) {
        lst = new BiList();
    }
    void set(int key, int value) {
        if (mp.find(key) == mp.end()) {
            if (mp.size() == cap) {    //evict
                auto p = lst->erase_end();
                int rm_key = p.first;
                mp.erase(rm_key);
            }
        } else {
            auto node = mp[key];
            lst->erase(node);
        }
        lst->insert_front(new Node(key, value));
        mp[key] = lst->first();
    }
    
    int get(int key) {
        if (mp.find(key) == mp.end())
            return -1;
        auto node = mp[key];
        int value = node->value;
        lst->erase(node);
        lst->insert_front(new Node(key, value));
        mp[key] = lst->first();
        return value;
    }
    ~LRUcache() {
        delete lst;
    }
};

int main() {
    int n, k;
    cin >> n >> k;
    LRUcache cache(k);
    vector<int> res;
    for (int i = 0; i < n; ++ i) {
        int opt;
        cin >> opt;
        if (opt == 1) {
            int x, y;
            cin >> x >> y;
            cache.set(x, y);
        } else {
            int x;
            cin >> x;
            res.push_back(cache.get(x));
        }
    }
    for (int num : res) 
        cout << num << " ";
    return 0;
}
```

## 总结

LRU 出现频率真的好高。。