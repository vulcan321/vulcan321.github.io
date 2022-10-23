# C++之异或运算符

## 一、"异或"运算符（“∧”）

也称XOR运算符。规则：相同为0，相异为1,0∧0=0,0∧1=1,1∧0=1,1∧1=0


（1）与0相∧，保留原值

（2）交换两个值，不用临时变量 

（3）与自己XOR，值为0
```cpp
a = a^b;
b = b^a;
a = a^b;

//自己和自己异或等于0
a^a=0;
//任何数字和0异或还等于他自己
a^0=a;
//异或运算具有交换律
a^b^c=a^c^b;
```

## 二、LeetCode No268\. Missing Number

Question：

Given an array containing n distinct numbers taken from `0, 1, 2, ..., n`, find the one that is missing from the array.

For example,  
Given nums = `[0, 1, 3]` return `2`.

Algorithm：Bit Manipulation

把0-n的数异或后再与nums里的数异或，即得到Missing Number（除了Missing Number都自己与自己异或了一次）

#### Submitted Code：

```cpp
class Solution {
public:
    int missingNumber(vector<int>& nums) {
        int xor_num = 0;
        int length = nums.size();
        while(length!=0)
        {
            xor_num ^= length;
            length--;
        }
        for(int i : nums)xor_num ^= i;
        return xor_num;
    }
};
```

## 三、LeetCode No136\. Single Number

Question：

Given an array of integers, every element appears twice except for one. Find that single one.

Algorithm：Bit Manipulation

所有元素异或

#### Submitted Code：

```cpp
class Solution {
public:
    int singleNumber(vector<int>& nums) {
        int x = 0;
        for(int i=0;i<nums.size();i++)
            x = x^nums[i];
        return x;
    }
};
```

## 四、LeetCode No260\. Single Number III

Question：

Given an array of numbers `nums`, in which exactly two elements appear only once and all the other elements appear exactly twice. Find the two elements that appear only once.

For example:

Given `nums = [1, 2, 1, 3, 2, 5]`, return `[3, 5]`.

Algorithm：Bit Manipulation

1、按照Single Number的方法，对所有元素异或，那么得到的是这两个元素异或值xor\_two

2、如何将两个元素分开，由于值不同的位异或为1，所以我们不妨可以找出xor\_two的最后一个1（-xor\_two为其补码），把两个元素区别，然后再分别对两个数组异或

#### Submitted Code：

```cpp
class Solution {
public:
    vector<int> singleNumber(vector<int>& nums) {
        int xor_two = nums[0];
        int last_bit = 0;
        vector<int> result = {0,0};
        for(int i=1;i<nums.size();i++)
            xor_two = xor_two ^ nums[i];
        last_bit = xor_two & (~(xor_two-1)); 
        //相异为1，取异或的最后一个1，把两个元素区分，然后分别对两个数组异或
        for(int i=0;i<nums.size();i++)
        {
            if(nums[i] & last_bit)
                result[0] ^= nums[i];
            else
                result[1] ^= nums[i];
        }
        return result;
    }
};
```