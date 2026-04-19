# LeetCode算法题高频整理(精华篇)


## 1\. 写在前面

之前刷题的时候，尝试把自己刷过的[LeetCode](https://so.csdn.net/so/search?q=LeetCode&spm=1001.2101.3001.7020)算法题分类整理成了一个专栏[算法刷题笔记](https://blog.csdn.net/wuzhongqiang/category_9550353.html)，大约用14篇文章把算法题进行分类整理概括及总结，目前大约400道题目，本来想着秋招面试准备就反复刷这些就好，基本上能拿下80%的面试题。 但是发现400道量还是太多了，有很多刷过还总是忘，特别是数字找规律的那种， 并且我通过准备发现， 其实最常考和必会的并没有这么多。

所以这篇博客是上面的专栏笔记里面400道里面拿出高频的精华题目，建议闭着眼都能默写过了。

___

## 2\. 树篇(19)

### 2.1 [二叉树的 前中后层序 遍历的写法总结](https://blog.csdn.net/wuzhongqiang/article/details/112762729?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522162899283016780264091932%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fblog.%2522%257D&request_id=162899283016780264091932&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_v2~rank_v29-11-112762729.pc_v2_rank_blog_default&utm_term=%E7%AE%97%E6%B3%95%E5%88%B7%E9%A2%98%E9%87%8D%E6%B8%A9&spm=1018.2226.3001.4450)

#### 2.1.1 前序遍历

-   [LeetCode257: 二叉树的所有路径](https://leetcode-cn.com/problems/binary-tree-paths/)
-   [LeetCode 129: 求根到叶子节点数字之和](https://leetcode-cn.com/problems/sum-root-to-leaf-numbers/)
-   [LeetCode113：路径总和II](https://leetcode-cn.com/problems/path-sum-ii/)

#### 2.1.2 中序遍历

-   [LeetCode98: 验证二叉搜索树](https://leetcode-cn.com/problems/validate-binary-search-tree/)
-   [剑指 Offer 54. 二叉搜索树的第k大节点](https://leetcode-cn.com/problems/er-cha-sou-suo-shu-de-di-kda-jie-dian-lcof/)
-   [剑指offer36: 二叉搜索树与双向链表](https://leetcode-cn.com/problems/er-cha-sou-suo-shu-yu-shuang-xiang-lian-biao-lcof/)

#### 2.1.3 后序遍历

-   [leetcode 236: 二叉树的最近公共祖先](https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree/) – 递归和非递归
-   [Leetcode110. 判断是否平衡二叉树](https://leetcode-cn.com/problems/balanced-binary-tree/)
-   [LeetCode543: 二叉树的直径](https://leetcode-cn.com/problems/diameter-of-binary-tree/)
-   [LeetCode124: 二叉树中的最大路径和](https://leetcode-cn.com/problems/binary-tree-maximum-path-sum/)

#### 2.1.4 层序遍历

-   [LeetCode103: 之字形层序遍历](https://leetcode-cn.com/problems/binary-tree-zigzag-level-order-traversal/)
-   [LeetCode199：二叉树的右视图](https://leetcode-cn.com/problems/binary-tree-right-side-view/)
-   [牛客: 判断一棵树是否是完全二叉树](https://www.nowcoder.com/practice/f31fc6d3caf24e7f8b4deb5cd9b5fa97?tpId=117&&tqId=35077&rp=1&ru=/activity/oj&qru=/ta/job-code-high/question-ranking)

### 2.2 [二叉树的修改构造与递归思维框架](https://zhongqiang.blog.csdn.net/article/details/113173249)

-   [Leecode 105: 从前序和中序遍历构造二叉树](https://leetcode-cn.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/)
-   [Leetcode 297: 二叉树的序列化与反序列化](https://leetcode-cn.com/problems/serialize-and-deserialize-binary-tree/)
-   [LeetCode101: 对称二叉树](https://leetcode-cn.com/problems/symmetric-tree/)
-   [LeetCode572: 另一个树的子树](https://leetcode-cn.com/problems/subtree-of-another-tree/)

### 2.3 [二叉搜索树](https://zhongqiang.blog.csdn.net/article/details/113312028)

-   [LeetCode235: 二叉搜索树的最近公共祖先](https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-search-tree/submissions/)
-   [剑指offer33: 二叉搜索树的后序遍历序列](https://leetcode-cn.com/problems/er-cha-sou-suo-shu-de-hou-xu-bian-li-xu-lie-lcof/)

___

## 3\. [回溯篇(5)](https://zhongqiang.blog.csdn.net/article/details/113536658)

-   [LeetCode40: 组合总和II](https://leetcode-cn.com/problems/combination-sum-ii/)
-   [LeetCode93: 复原IP地址](https://leetcode-cn.com/problems/restore-ip-addresses/)
-   [LeetCode90：子集II](https://leetcode-cn.com/problems/subsets-ii/)
-   [LeetCode491: 递增子序列](https://leetcode-cn.com/problems/increasing-subsequences/)
-   [LeetCode47: 全排列II](https://leetcode-cn.com/problems/permutations-ii/)

___

## 4\. [贪心篇(7)](https://zhongqiang.blog.csdn.net/article/details/113822189)

-   [LeetCode376: 摆动序列](https://leetcode-cn.com/problems/wiggle-subsequence/)
-   [LeetCode738: 单调递增的数字](https://leetcode-cn.com/problems/monotone-increasing-digits/)
-   [LeetCode53: 最大子序列和](https://leetcode-cn.com/problems/maximum-subarray/)
-   [LeetCode55: 跳跃游戏](https://leetcode-cn.com/problems/jump-game/)
-   [LeetCode45: 跳跃游戏II](https://leetcode-cn.com/problems/jump-game-ii/)
-   [LeetCode452: 用最少数量的箭引爆气球](https://leetcode-cn.com/problems/minimum-number-of-arrows-to-burst-balloons/)
-   [LeetCode56: 合并区间](https://leetcode-cn.com/problems/merge-intervals/)

___

## 5\. [DFS和BFS篇(2)](https://zhongqiang.blog.csdn.net/article/details/114382110)

-   [LeetCode200: 岛屿数量](https://leetcode-cn.com/problems/number-of-islands/)
-   [LeetCode695: 岛屿的最大面积](https://leetcode-cn.com/problems/max-area-of-island/)

___

## 6\. [二分查找篇(6)](https://zhongqiang.blog.csdn.net/article/details/114519435)

-   [LeetCode34: 在排序数组中查找元素的第一个和最后一个位置](https://leetcode-cn.com/problems/find-first-and-last-position-of-element-in-sorted-array/)
-   [LeetCode69: x的平方根](https://leetcode-cn.com/problems/sqrtx/)
-   [LeetCode74: 搜索二维矩阵](https://leetcode-cn.com/problems/search-a-2d-matrix/)
-   [LeetCode240: 搜索二维矩阵II](https://leetcode-cn.com/problems/search-a-2d-matrix-ii/)
-   [LeetCode33: 搜索旋转排序数组](https://leetcode-cn.com/problems/search-in-rotated-sorted-array/)
-   [LeetCode153: 搜索旋转数组的最小值](https://leetcode-cn.com/problems/find-minimum-in-rotated-sorted-array/)

___

## 7\. [动态规划篇(24)](https://zhongqiang.blog.csdn.net/article/details/114726919)

-   [LeetCode343:整数拆分](https://leetcode-cn.com/problems/integer-break/)
-   [剑指offer 62: 圆圈中最后剩下的数字](https://leetcode-cn.com/problems/yuan-quan-zhong-zui-hou-sheng-xia-de-shu-zi-lcof/)
-   [LeetCode63: 不同路径II](https://leetcode-cn.com/problems/unique-paths-ii/)
-   [LeetCode64: 最小路径和](https://leetcode-cn.com/problems/minimum-path-sum/)
-   [LeetCode416: 分割等和子集](https://leetcode-cn.com/problems/partition-equal-subset-sum/)
-   [LeetCode494: 目标和](https://leetcode-cn.com/problems/target-sum/submissions/)
-   [LeetCode518: 零钱兑换II](https://leetcode-cn.com/problems/coin-change-2/)
-   [LeetCode322: 零钱兑换](https://leetcode-cn.com/problems/coin-change/)
-   [LeetCode213: 打家劫舍II](https://leetcode-cn.com/problems/house-robber-ii/)
-   [LeetCode714: 买卖股票的最佳时机含手续费](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-with-transaction-fee/) — 这个包含了I II
-   [LeetCode188: 买卖股票的最佳时机IV](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-iv/) — 这个包含了III
-   [LeetCode309: 最佳买卖股票时机含冷冻期](https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock-with-cooldown/comments/)
-   [LeetCode300: 最长递增子序列](https://leetcode-cn.com/problems/longest-increasing-subsequence/)
-   [LeetCode674:最长连续递增子序列](https://leetcode-cn.com/problems/longest-continuous-increasing-subsequence/)
-   [LeetCode53: 最大子序和](https://leetcode-cn.com/problems/maximum-subarray/):
-   [LeetCode152: 乘积最大子数组](https://leetcode-cn.com/problems/maximum-product-subarray/description/)
-   [LeetCode1143: 最长公共子序列](https://leetcode-cn.com/problems/longest-common-subsequence/)
-   [LeetCode718: 最长重复子数组](https://leetcode-cn.com/problems/maximum-length-of-repeated-subarray/)
-   [LeetCode516: 最长回文子序列](https://leetcode-cn.com/problems/longest-palindromic-subsequence/)
-   [LeetCode5: 最长回文子串](https://leetcode-cn.com/problems/longest-palindromic-substring/)
-   [牛客Top200高频：最小编辑代码](https://www.nowcoder.com/practice/05fed41805ae4394ab6607d0d745c8e4?tpId=117&tags=&title=&diffculty=0&judgeStatus=0&rp=1&tab=answerKey)
-   [LeetCode583: 两个字符串的删除操作](https://leetcode-cn.com/problems/delete-operation-for-two-strings/)
-   [LeetCode32: 最长有效括号](https://leetcode-cn.com/problems/longest-valid-parentheses/)
-   [圆形回原点](https://zhongqiang.blog.csdn.net/article/details/114726919)

___

## 8\. [排序篇(3)](https://zhongqiang.blog.csdn.net/article/details/115319669)

-   [LeetCode215: 数组中的第K个最大元素](https://leetcode-cn.com/problems/kth-largest-element-in-an-array/)
-   [LeetCode179: 最大数](https://leetcode-cn.com/problems/largest-number/)
-   [面试题17.14： 最小的K个数](https://leetcode-cn.com/problems/smallest-k-lcci/)
-   堆排序手撕
-   快排手撕
-   归并手撕

___

## 9\. [数组和哈希表(18)](https://zhongqiang.blog.csdn.net/article/details/114970237)

-   [LeetCode283: 移动零](https://leetcode-cn.com/problems/move-zeroes/)
-   [剑指offer21: 调整数组顺序使奇数位于偶数前面](https://leetcode-cn.com/problems/diao-zheng-shu-zu-shun-xu-shi-qi-shu-wei-yu-ou-shu-qian-mian-lcof/)
-   [LeetCode15: 三数之和](https://leetcode-cn.com/problems/3sum/)
-   [LeetCode88：合并两个有序数组](https://leetcode-cn.com/problems/merge-sorted-array/)
-   [LeetCode4: 寻找两个正序数组的中位数](https://leetcode-cn.com/problems/median-of-two-sorted-arrays/)
-   [LeetCode59: 螺旋矩阵II](https://leetcode-cn.com/problems/spiral-matrix-ii/)
-   [LeetCode498: 对角线遍历](https://leetcode-cn.com/problems/diagonal-traverse/)
-   [剑指offer39: 数组中出现次数超过一半的数字](https://leetcode-cn.com/problems/shu-zu-zhong-chu-xian-ci-shu-chao-guo-yi-ban-de-shu-zi-lcof/)
-   [LeetCode31: 下一个排列](https://leetcode-cn.com/problems/next-permutation/)
-   [牛客Top200高频: 将字符串转化为整数](https://www.nowcoder.com/practice/44d8c152c38f43a1b10e168018dcc13f?tpId=117&tqId=37754&rp=1&ru=%2Factivity%2Foj&qru=%2Fta%2Fjob-code-high%2Fquestion-ranking&tab=answerKey)
-   [用Rand7()实现Rand10()](https://leetcode-cn.com/problems/implement-rand10-using-rand7/)
-   [LeetCode209:长度最小的子数组](https://leetcode-cn.com/problems/minimum-size-subarray-sum/)
-   [LeetCode1: 两数之和](https://leetcode-cn.com/problems/two-sum/)
-   [LeetCode128: 最长连续序列](https://leetcode-cn.com/problems/longest-consecutive-sequence/)
-   [LeetCode41: 缺失的第一个正数](https://leetcode-cn.com/problems/first-missing-positive/)
-   [剑指offer03: 数组中重复的数字](https://leetcode-cn.com/problems/shu-zu-zhong-zhong-fu-de-shu-zi-lcof/)
-   [LeetCode14: 最长公共前缀](https://leetcode-cn.com/problems/longest-common-prefix/)
-   [LeetCode162: 寻找峰值](https://leetcode-cn.com/problems/find-peak-element/)

___

## 10\. [链表篇(13)](https://zhongqiang.blog.csdn.net/article/details/115266111)

-   [LeetCode19: 删除链表的第K个节点](https://leetcode-cn.com/problems/remove-nth-node-from-end-of-list/)
-   [牛客Top200高频: 删除有序链表中重复出现的元素](https://www.nowcoder.com/practice/71cef9f8b5564579bf7ed93fbe0b2024?tpId=117&tqId=37729&rp=1&ru=%2Factivity%2Foj&qru=%2Fta%2Fjob-code-high%2Fquestion-ranking&tab=answerKey)
-   [LeetCode25: K个一组翻转链表](https://leetcode-cn.com/problems/reverse-nodes-in-k-group/)
-   [两两交换链表中的节点](https://leetcode-cn.com/problems/swap-nodes-in-pairs/)
-   [LeetCode142: 环形链表II](https://leetcode-cn.com/problems/two-sum/)
-   [LeetCode160: 相交链表](https://leetcode-cn.com/problems/intersection-of-two-linked-lists/)
-   [LeetCode234: 回文链表](https://leetcode-cn.com/problems/palindrome-linked-list/)
-   [LeetCode445: 两数相加II](https://leetcode-cn.com/problems/add-two-numbers-ii/)
-   [LeetCode21: 合并两个有序链表](https://leetcode-cn.com/problems/merge-two-sorted-lists/)
-   [LeetCode23: 合并K个排序链表](https://leetcode-cn.com/problems/merge-k-sorted-lists/)
-   [LeetCode148: 排序链表](https://leetcode-cn.com/problems/sort-list/)
-   [LeetCode143: 重排链表](https://leetcode-cn.com/problems/reorder-list/)
-   [面试题16.25: LRU缓存](https://leetcode-cn.com/problems/lru-cache-lcci/)

___

## 11\. [栈和队列(6)](https://zhongqiang.blog.csdn.net/article/details/115293314)

-   [LeetCode20: 有效的括号](https://leetcode-cn.com/problems/valid-parentheses/description/)
-   [LeetCode84: 柱状图中的最大矩形](https://leetcode-cn.com/problems/largest-rectangle-in-histogram/)
-   [LeetCode42: 接雨水](https://leetcode-cn.com/problems/trapping-rain-water/)
-   [LeetCode155: 最小栈](https://leetcode-cn.com/problems/min-stack/)
-   [LeetCode232: 用栈实现队列](https://leetcode-cn.com/problems/implement-queue-using-stacks/)
-   [剑指offer59 - I: 滑动窗口最大值](https://leetcode-cn.com/problems/hua-dong-chuang-kou-de-zui-da-zhi-lcof/)

___

## 12\. [字符串(3)](https://zhongqiang.blog.csdn.net/article/details/115223777)

-   [剑指offer 67: 把字符串转换成整数](https://leetcode-cn.com/problems/ba-zi-fu-chuan-zhuan-huan-cheng-zheng-shu-lcof/)
-   [LeetCode76: 最小覆盖子串](https://leetcode-cn.com/problems/minimum-window-substring/)
-   [LeetCode3: 无重复字符的最长子串](https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/)

___

## 13\. [位运算&递归(2)](https://zhongqiang.blog.csdn.net/article/details/116291896)

-   [LeetCode136: 只出现一次的数字](https://leetcode-cn.com/problems/single-number/)
-   [LeetCode22: 括号生成](https://leetcode-cn.com/problems/generate-parentheses/)

___

另外， 再推荐一个刷题网站[https://codetop.cc/home](https://codetop.cc/home)， 这个网站非常适合最后检验自己刷题掌握情况， 如果感觉时间非常紧， 建议把这个网站的前100道题目刷到烂熟的程度， 运气不错的时候，也能够度过难关， 加油 😉