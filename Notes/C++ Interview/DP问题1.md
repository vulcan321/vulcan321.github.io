# 题目

## 1、线性 DP

-   最经典单串：  
    [300.最长上升子序列](https://www.cnblogs.com/bonelee/p/17078169.html#lengthOfLIS) 中等
    
-   其他单串  
    [32.最长有效括号](https://www.cnblogs.com/bonelee/p/17078169.html#longestValidParentheses) 困难  
    376.摆动序列  
    368.最大整除子集  
    410.分割数组的最大值
    
-   最经典双串：  
    [1143.最长公共子序列](https://www.cnblogs.com/bonelee/p/17078169.html#longestCommonSubsequence) 中等
    
-   其他双串  
    [97.交错字符串](https://www.cnblogs.com/bonelee/p/17078169.html#isInterleave) 中等  
    [115.不同的子序列](https://www.cnblogs.com/bonelee/p/17078169.html#numDistinct) 困难  
    583.两个字符串的删除操作
    
-   经典问题：  
    [53.最大子序和](https://www.cnblogs.com/bonelee/p/17078169.html#maxSubArray) 简单  
    [120.三角形最小路径和](https://www.cnblogs.com/bonelee/p/17078169.html#minimumTotal) 中等  
    [152.乘积最大子数组](https://www.cnblogs.com/bonelee/p/17078169.html#maxProduct) 中等  
    354.俄罗斯套娃信封问题  
    [887.鸡蛋掉落（DP+二分）](https://www.cnblogs.com/bonelee/p/17078169.html#superEggDrop) 困难
    
-   打家劫舍系列: (打家劫舍3 是树形DP)  
    [198.打家劫舍](https://www.cnblogs.com/bonelee/p/17078169.html#rob) 中等  
    [213.打家劫舍 II](https://www.cnblogs.com/bonelee/p/17078169.html#rob2) 中等
    
-   股票系列:  
    121.买卖股票的最佳时机  
    122.买卖股票的最佳时机 II  
    123.买卖股票的最佳时机 III  
    188.买卖股票的最佳时机 IV  
    309.最佳买卖股票时机含冷冻期  
    714.买卖股票的最佳时机含手续费
    
-   字符串匹配系列  
    [72.编辑距离](https://www.cnblogs.com/bonelee/p/17078169.html#distance) 困难  
    [44.通配符匹配](https://www.cnblogs.com/bonelee/p/17078169.html#isMatch) 困难  
    [10.正则表达式匹配](https://www.cnblogs.com/bonelee/p/17078169.html#isMatch2) 困难
    
-   其他  
    375.猜数字大小 II
    

## 2、区间 DP

[5.最长回文子串](https://www.cnblogs.com/bonelee/p/17078169.html#longestPalindrome) 中等  
516.最长回文子序列  
[87\. 扰乱字符串](https://www.cnblogs.com/bonelee/p/17078169.html#isScramble) 困难  
[312.戳气球](https://www.cnblogs.com/bonelee/p/17078169.html#maxCoins) 困难  
730.统计不同回文子字符串  
1039.多边形三角剖分的最低得分  
664.奇怪的打印机  
1246\. 删除回文子数组

## 3、背包 DP

[377\. 组合总和 Ⅳ](https://www.cnblogs.com/bonelee/p/17078169.html#combinationSum4)  
416.分割等和子集 (01背包-要求恰好取到背包容量)  
494.目标和 (01背包-求方案数)  
322.零钱兑换 (完全背包)  
518.零钱兑换 II (完全背包-求方案数)  
474.一和零 (二维费用背包)

## 4、树形 DP

[124.二叉树中的最大路径和](https://www.cnblogs.com/bonelee/p/17078169.html#maxPathSum) 困难  
1245.树的直径 (邻接表上的树形DP)  
[543.二叉树的直径](https://www.cnblogs.com/bonelee/p/17078169.html#diameterOfBinaryTree) 简单  
333.最大 BST 子树  
[337.打家劫舍 III](https://www.cnblogs.com/bonelee/p/17078169.html#rob3) 中等

## 5、状态压缩 DP

464.我能赢吗  
526.优美的排列  
935.骑士拨号器  
1349.参加考试的最大学生数

## 6、数位 DP

[233.数字 1 的个数](https://www.cnblogs.com/bonelee/p/17078169.html#countDigitOne) 困难  
902.最大为 N 的数字组合  
1015.可被 K 整除的最小整数

## 7、计数型 DP

计数型DP都可以以组合数学的方法写出组合数，然后dp求组合数  
[62.不同路径](https://www.cnblogs.com/bonelee/p/17078169.html#uniquePaths)  
[63.不同路径 II](https://www.cnblogs.com/bonelee/p/17078169.html#uniquePathsWithObstacles)  
[96.不同的二叉搜索树](https://www.cnblogs.com/bonelee/p/17078169.html#numTrees)  
1259.不相交的握手 (卢卡斯定理求大组合数模质数)

## 8、递推型 DP

[70.爬楼梯](https://www.cnblogs.com/bonelee/p/17078169.html#climbStairs)  
[509.斐波那契数](https://www.cnblogs.com/bonelee/p/17078169.html#fib)  
576\. 出界的路径数  
688\. “马”在棋盘上的概率  
[935.骑士拨号器](https://www.cnblogs.com/bonelee/p/17078169.html#knightDialer)  
957.N 天后的牢房  
1137.第 N 个泰波那契数

## 9、概率型 DP

求概率，求数学期望  
808.分汤  
837.新21点

## 10、博弈型 DP

策梅洛定理，SG 定理，minimax

-   翻转游戏  
    293.翻转游戏  
    294.翻转游戏 II
    
-   Nim游戏  
    292.Nim 游戏
    
-   石子游戏  
    877.石子游戏  
    1140.石子游戏 II
    
-   井字游戏  
    348.判定井字棋胜负  
    794.有效的井字游戏  
    1275.找出井字棋的获胜者
    

## 11、记忆化搜索

本质是 dfs + 记忆化，用在状态的转移方向不确定的情况  
329.矩阵中的最长递增路径  
576.出界的路径数
