#### 方法一：折半搜索

**思路与算法**

设数组 nums\\textit{nums}nums 的长度为 nnn，假设我们移动了 kkk 个元素到数组 AAA 中，移动了 n−kn-kn−k 个元素到数组 BBB 中，此时两个数组的平均值相等。设 sum(A),sum(B),sum(nums)\\textit{sum}(A), \\textit{sum}(B), \\textit{sum}(\\textit{nums})sum(A),sum(B),sum(nums) 分别表示数组 A,B,numsA,B,\\textit{nums}A,B,nums 的元素和，由于数组 A,BA,BA,B 的平均值相等，则有 sum(A)k\=sum(B)n−k\\dfrac{\\textit{sum}(A)}{k} = \\dfrac{\\textit{sum}(B)}{n - k}ksum(A)\=n−ksum(B)，上述等式可以进行变换为如下：

sum(A)×(n−k)\=sum(B)×k⇔ sum(A)×n\=(sum(A)+sum(B))×k⇔ sum(A)×n\=(sum(nums))×k⇔ sum(A)k\=sum(nums)n\\begin{aligned} & \\textit{sum}(A) \\times (n - k) = \\textit{sum}(B) \\times k \\\\ \\Leftrightarrow~ & \\textit{sum}(A) \\times n = (\\textit{sum}(A) + \\textit{sum}(B)) \\times k \\\\ \\Leftrightarrow~ & \\textit{sum}(A) \\times n = (\\textit{sum}(\\textit{nums})) \\times k \\\\ \\Leftrightarrow~ & \\dfrac{\\textit{sum}(A)}{k} = \\dfrac{\\textit{sum}(\\textit{nums})}{n} \\end{aligned} ⇔ ⇔ ⇔ sum(A)×(n−k)\=sum(B)×ksum(A)×n\=(sum(A)+sum(B))×ksum(A)×n\=(sum(nums))×kksum(A)\=nsum(nums)

即数组 AAA 的平均值与数组 nums\\textit{nums}nums 的平均值相等。此时我们可以将数组 nums\\textit{nums}nums 中的每个元素减去 nums\\textit{nums}nums 的平均值，这样数组 nums\\textit{nums}nums 的平均值则变为 000。此时题目中的问题则可以住准变为：从 nums\\textit{nums}nums 中找出若干个元素组成集合 AAA，使得 AAA 的元素之和为 000，剩下的元素组成集合 BBB，它们的和也同样为 000。

比较容易想到的思路是，从 nnn 个元素中取出若干个元素形成不同的子集，则此时一共有 2n2^n2n 种方法（即每个元素取或不取），我们依次判断每种方法选出的元素之和是否为 000。但题目中的 nnn 可以达到 303030，此时 230\=1,073,741,8242^{30} = 1,073,741,824230\=1,073,741,824，组合的数据非常大。  
因此我们考虑将数组平均分成两部分 A0A\_0A0 和 B0B\_0B0，它们均含有 n2\\dfrac{n}{2}2n 个元素（不失一般性，这里假设 nnn 为偶数。如果 nnn 为奇数，在 A0A\_0A0 中多放一个元素即可），此时这两个数组分别有 2n22^{\\frac{n}{2}}22n 种不同的子集选择的方法。设 A0A\_0A0 中所有选择的方法得到的不同子集的元素之和的集合为 left\\textit{left}left，B0B\_0B0 中所有选择的方法得到的不同子集的元素之和的集合为 right\\textit{right}right，那么我们只需要在 left\\textit{left}left 中找出一个子集 A0′A\_0^{'}A0′ 的元素之和为 xxx，同时在 right\\textit{right}right 中包含一个子集 B0′B\_0^{'}B0′ 的元素之和为 −x\-x−x，则子集 A0′,B0′A\_0^{'},B\_0^{'}A0′,B0′ 构成的集合的元素之和为 000，此时则找到了一种和为 000 的方法。

-   需要注意的是，我们不能同时选择 A0A\_0A0 和 A1A\_1A1 中的所有元素，这样数组 BBB 就为空了。

此外，将数组 nums\\textit{nums}nums 中每个元素减去它们的平均值，这一步会引入浮点数，可能会导致判断的时候出现误差。一种解决方案是使用分数代替浮点数，但这样代码编写起来较为麻烦。更好的解决方案是先将 nums\\textit{nums}nums 中的每个元素乘以 nums\\textit{nums}nums 的长度，则此时每个元素 nums\[i\]\\textit{nums}\[i\]nums\[i\] 变为 n×nums\[i\]n \\times \\textit{nums}\[i\]n×nums\[i\]，这样数组 nums\\textit{nums}nums 的平均值一定为整数，同时也不影响题目中的平均值相等的要求。

**代码**

-   Python3
-   C++
-   Java
-   C#
-   C
-   JavaScript
-   Golang

```
class Solution:
    def splitArraySameAverage(self, nums: List[int]) -> bool:
        n = len(nums)
        if n == 1:
            return False

        s = sum(nums)
        for i in range(n):
            nums[i] = nums[i] * n - s

        m = n // 2
        left = set()
        for i in range(1, 1 << m):
            tot = sum(x for j, x in enumerate(nums[:m]) if i >> j & 1)
            if tot == 0:
                return True
            left.add(tot)

        rsum = sum(nums[m:])
        for i in range(1, 1 << (n - m)):
            tot = sum(x for j, x in enumerate(nums[m:]) if i >> j & 1)
            if tot == 0 or rsum != tot and -tot in left:
                return True
        return False

```

```
class Solution {
public:
    bool splitArraySameAverage(vector<int> &nums) {
        int n = nums.size(), m = n / 2;
        if (n == 1) {
            return false;
        }

        int sum = accumulate(nums.begin(), nums.end(), 0);
        for (int &x : nums) {
            x = x * n - sum;
        }

        unordered_set<int> left;
        for (int i = 1; i < (1 << m); i++) {
            int tot = 0;
            for (int j = 0; j < m; j++) {
                if (i & (1 << j)) {
                    tot += nums[j];
                }
            }
            if (tot == 0) {
                return true;
            }
            left.emplace(tot);
        }

        int rsum = accumulate(nums.begin() + m, nums.end(), 0);
        for (int i = 1; i < (1 << (n - m)); i++) {
            int tot = 0;
            for (int j = m; j < n; j++) {
                if (i & (1 << (j - m))) {
                    tot += nums[j];
                }
            }
            if (tot == 0 || (rsum != tot && left.count(-tot))) {
                return true;
            }
        }
        return false;
    }
};

```

```
class Solution {
    public boolean splitArraySameAverage(int[] nums) {
        if (nums.length == 1) {
            return false;
        }
        int n = nums.length, m = n / 2;
        int sum = 0;
        for (int num : nums) {
            sum += num;
        }
        for (int i = 0; i < n; i++) {
            nums[i] = nums[i] * n - sum;
        }

        Set<Integer> left = new HashSet<Integer>();
        for (int i = 1; i < (1 << m); i++) {
            int tot = 0;
            for (int j = 0; j < m; j++) {
                if ((i & (1 << j)) != 0) {
                    tot += nums[j];
                }
            }
            if (tot == 0) {
                return true;
            }
            left.add(tot);
        }
        int rsum = 0;
        for (int i = m; i < n; i++) {
            rsum += nums[i];
        }
        for (int i = 1; i < (1 << (n - m)); i++) {
            int tot = 0;
            for (int j = m; j < n; j++) {
                if ((i & (1 << (j - m))) != 0) {
                    tot += nums[j];
                }
            }
            if (tot == 0 || (rsum != tot && left.contains(-tot))) {
                return true;
            }
        }
        return false;
    }
}

```

```
public class Solution {
    public bool SplitArraySameAverage(int[] nums) {
        if (nums.Length == 1) {
            return false;
        }
        int n = nums.Length, m = n / 2;
        int sum = 0;
        foreach (int num in nums) {
            sum += num;
        }
        for (int i = 0; i < n; i++) {
            nums[i] = nums[i] * n - sum;
        }

        ISet<int> left = new HashSet<int>();
        for (int i = 1; i < (1 << m); i++) {
            int tot = 0;
            for (int j = 0; j < m; j++) {
                if ((i & (1 << j)) != 0) {
                    tot += nums[j];
                }
            }
            if (tot == 0) {
                return true;
            }
            left.Add(tot);
        }
        int rsum = 0;
        for (int i = m; i < n; i++) {
            rsum += nums[i];
        }
        for (int i = 1; i < (1 << (n - m)); i++) {
            int tot = 0;
            for (int j = m; j < n; j++) {
                if ((i & (1 << (j - m))) != 0) {
                    tot += nums[j];
                }
            }
            if (tot == 0 || (rsum != tot && left.Contains(-tot))) {
                return true;
            }
        }
        return false;
    }
}

```

```
typedef struct {
    int key;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);             
    }
}

bool splitArraySameAverage(int* nums, int numsSize) {
    if (numsSize == 1) {
        return false;
    }
    int n = numsSize, m = n / 2;
    int sum = 0;
    for (int i = 0; i < n; i++) {
        sum += nums[i];
    }
    for (int i = 0; i < n; i++) {
        nums[i] = nums[i] * n - sum;
    }
    HashItem *left = NULL;
    for (int i = 1; i < (1 << m); i++) {
        int tot = 0;
        for (int j = 0; j < m; j++) {
            if (i & (1 << j)) {
                tot += nums[j];
            }
        }
        if (tot == 0) {
            return true;
        }
        hashAddItem(&left, tot);
    }
    int rsum = 0;
    for (int i = m; i < n; i++) {
        rsum += nums[i];
    }
    for (int i = 1; i < (1 << (n - m)); i++) {
        int tot = 0;
        for (int j = m; j < n; j++) {
            if (i & (1 << (j - m))) {
                tot += nums[j];
            }
        }
        if (tot == 0 || (tot != rsum && hashFindItem(&left, -tot))) {
            return true;
        }
    }
    hashFree(&left);
    return false;
}

```

```
var splitArraySameAverage = function(nums) {
    if (nums.length === 1) {
        return false;
    }
    const n = nums.length, m = Math.floor(n / 2);
    let sum = 0;
    for (const num of nums) {
        sum += num;
    }
    for (let i = 0; i < n; i++) {
        nums[i] = nums[i] * n - sum;
    }

    const left = new Set();
    for (let i = 1; i < (1 << m); i++) {
        let tot = 0;
        for (let j = 0; j < m; j++) {
            if ((i & (1 << j)) !== 0) {
                tot += nums[j];
            }
        }
        if (tot === 0) {
            return true;
        }
        left.add(tot);
    }
    let rsum = 0;
    for (let i = m; i < n; i++) {
        rsum += nums[i];
    }
    for (let i = 1; i < (1 << (n - m)); i++) {
        let tot = 0;
        for (let j = m; j < n; j++) {
            if ((i & (1 << (j - m))) != 0) {
                tot += nums[j];
            }
        }
        if (tot === 0 || (rsum !== tot && left.has(-tot))) {
            return true;
        }
    }
    return false;
};

```

```
func splitArraySameAverage(nums []int) bool {
    n := len(nums)
    if n == 1 {
        return false
    }

    sum := 0
    for _, x := range nums {
        sum += x
    }
    for i := range nums {
        nums[i] = nums[i]*n - sum
    }

    m := n / 2
    left := map[int]bool{}
    for i := 1; i < 1<<m; i++ {
        tot := 0
        for j, x := range nums[:m] {
            if i>>j&1 > 0 {
                tot += x
            }
        }
        if tot == 0 {
            return true
        }
        left[tot] = true
    }

    rsum := 0
    for _, x := range nums[m:] {
        rsum += x
    }
    for i := 1; i < 1<<(n-m); i++ {
        tot := 0
        for j, x := range nums[m:] {
            if i>>j&1 > 0 {
                tot += x
            }
        }
        if tot == 0 || rsum != tot && left[-tot] {
            return true
        }
    }
    return false
}

```

**复杂度分析**

-   时间复杂度：O(n×2n2)O(n \\times 2^{\\frac{n}{2}})O(n×22n)，其中 nnn 表示数组的长度。我们需要求出每个子集的元素之和，数组的长度为 nnn，一共有 2×2n22 \\times 2^{\\frac{n}{2}}2×22n 个子集，求每个子集的元素之和需要的时间为 O(n)O(n)O(n)，因此总的时间复杂度为 O(n×2n2)O(n \\times 2^{\\frac{n}{2}})O(n×22n)。
    
-   空间复杂度：O(2n2)O(2^{\\frac{n}{2}})O(22n)。一共有 2n22^{\\frac{n}{2}}22n 个子集的元素之和需要保存，因此需要的空间为 O(2n2)O(2^{\\frac{n}{2}})O(22n)。
    

#### [](https://leetcode.cn/problems/split-array-with-same-average/solution/shu-zu-de-jun-zhi-fen-ge-by-leetcode-sol-f630//#方法二：动态规划)方法二：动态规划

**思路与算法**

根据方法一的结论，设数组 nums\\textit{nums}nums 的平均数为 avg\=numsn\\textit{avg} = \\dfrac{\\textit{nums}}{n}avg\=nnums，我们移动了 kkk 个元素到数组 AAA 中，则此时已经数组 AAA 的平均数也为 avg\\textit{avg}avg，则此时数组 AAA 的元素之和为 sum(A)\=k×avg\\textit{sum}(A) = k \\times \\textit{avg}sum(A)\=k×avg，则该问题可以等价于在数组中取 kkk 个数，使得其和为 k×avgk \\times \\textit{avg}k×avg。对应的「[0-1背包问题](https://leetcode.cn/link/?target=https://oi-wiki.org/dp/knapsack/)」则为是否可以取 kkk 件物品使得背包的重量为 k×avgk \\times \\textit{avg}k×avg。我们设 dp\[i\]\[x\]\\textit{dp}\[i\]\[x\]dp\[i\]\[x\] 表示当前已从数组 nums\\textit{nums}nums 取出 iii 个元素构成的和为 xxx 的可能性：

-   如果 dp\[i\]\[x\]\=true\\textit{dp}\[i\]\[x\] = \\text{true}dp\[i\]\[x\]\=true，表示当前已经遍历过的元素中可以取出 iii 个元素构成的和为 xxx；
-   如果 dp\[i\]\[x\]\=false\\textit{dp}\[i\]\[x\] = \\text{false}dp\[i\]\[x\]\=false，表示当前已经遍历过的元素中不存在取出 iii 个元素的和等于 xxx；

假设前 j−1j - 1j−1 个元素中存在长度为 iii 的子集且子集的和为 xxx，则此时 dp\[i\]\[x\]\=true\\textit{dp}\[i\]\[x\] = \\text{true}dp\[i\]\[x\]\=true，我们当前遍历 nums\[j\]\\textit{nums}\[j\]nums\[j\] 时，则可以推出一定存在长度为 i+1i + 1i+1 的子集且满足子集的和为 x+nums\[j\]x + \\textit{nums}\[j\]x+nums\[j\]，可以得到状态转移方程为：

dp\[i+1\]\[x+nums\[j\]\]\=dp\[i\]\[x\]\\textit{dp}\[i + 1\]\[x + \\textit{nums}\[j\]\] = dp\[i\]\[x\] dp\[i+1\]\[x+nums\[j\]\]\=dp\[i\]\[x\]

根据题意可知：sum(A)k\=sum(nums)n\\dfrac{\\textit{sum}(A)}{k} = \\dfrac{\\textit{sum}(\\textit{nums})}{n}ksum(A)\=nsum(nums)，可以变换为: sum(A)×n\=sum(nums)×k\\textit{sum}(A) \\times n = \\textit{sum}(\\textit{nums}) \\times ksum(A)×n\=sum(nums)×k，所以我们只需要找到一个元素个数为 kkk 的子集 AAA 满足上述条件即可，因此我们利用上述递推公式求出所有可能长度的子集和组合即可，此时需要的时间复杂度约为 n2×sum(nums)n^2 \\times \\textit{sum}(\\textit{nums})n2×sum(nums)，按照题目给定的测试用例可能会超时，所以需要一些减枝技巧，具体的减枝技巧如下:

-   根据题意可以推出 sum(A)\=sum(nums)×kn\\textit{sum}(A) = \\dfrac{\\textit{sum}(\\textit{nums}) \\times k}{n}sum(A)\=nsum(nums)×k，则此时如果满足题目要求，则一定存在整数 k∈\[1,n\]k \\in \[1,n\]k∈\[1,n\]，使得 \[sum(nums)×k\] mod n\=0\\big\[\\textit{sum}(\\textit{nums}) \\times k\\big\] \\bmod n = 0\[sum(nums)×k\]modn\=0，因此我们可以提前是否存在 kkk 满足上述要求，如果不存在则可以提前终止。
-   根据题目要求可以划分为两个子数组 A,BA,BA,B，则可以知道两个子数组中一定存在一个数组的长度小于等于 n2\\dfrac{n}{2}2n，因此我们只需检测数组长度小于等于 n2\\dfrac{n}{2}2n 的子数组中是否存在其和满足 subsum×n\=nums×k\\textit{subsum} \\times n = \\textit{nums} \\times ksubsum×n\=nums×k 即可。

**代码**

-   Python3
-   C++
-   Java
-   C#
-   C
-   JavaScript
-   Golang

```
class Solution:
    def splitArraySameAverage(self, nums: List[int]) -> bool:
        n = len(nums)
        m = n // 2
        s = sum(nums)
        if all(s * i % n for i in range(1, m + 1)):
            return False

        dp = [set() for _ in range(m + 1)]
        dp[0].add(0)
        for num in nums:
            for i in range(m, 0, -1):
                for x in dp[i - 1]:
                    curr = x + num
                    if curr * n == s * i:
                        return True
                    dp[i].add(curr)
        return False

```

```
class Solution {
public:
    bool splitArraySameAverage(vector<int>& nums) {
        int n = nums.size(), m = n / 2;
        int sum = accumulate(nums.begin(), nums.end(), 0);
        bool isPossible = false;
        for (int i = 1; i <= m; i++) {
            if (sum * i % n == 0) {
                isPossible = true;
                break;
            }
        }  
        if (!isPossible) {
            return false;
        }
        vector<unordered_set<int>> dp(m + 1);
        dp[0].insert(0);
        for (int num: nums) {
            for (int i = m; i >= 1; i--) {
                for (int x: dp[i - 1]) {
                    int curr = x + num;
                    if (curr * n == sum * i) {
                        return true;
                    }
                    dp[i].emplace(curr);
                } 
            }
        }
        return false;
    }
};

```

```
class Solution {
    public boolean splitArraySameAverage(int[] nums) {
        if (nums.length == 1) {
            return false;
        }
        int n = nums.length, m = n / 2;
        int sum = 0;
        for (int num : nums) {
            sum += num;
        }
        boolean isPossible = false;
        for (int i = 1; i <= m; i++) {
            if (sum * i % n == 0) {
                isPossible = true;
                break;
            }
        }  
        if (!isPossible) {
            return false;
        }
        Set<Integer>[] dp = new Set[m + 1];
        for (int i = 0; i <= m; i++) {
            dp[i] = new HashSet<Integer>();
        }
        dp[0].add(0);
        for (int num : nums) {
            for (int i = m; i >= 1; i--) {
                for (int x : dp[i - 1]) {
                    int curr = x + num;
                    if (curr * n == sum * i) {
                        return true;
                    }
                    dp[i].add(curr);
                } 
            }
        }
        return false;
    }
}

```

```
public class Solution {
    public bool SplitArraySameAverage(int[] nums) {
        if (nums.Length == 1) {
            return false;
        }
        int n = nums.Length, m = n / 2;
        int sum = 0;
        foreach (int num in nums) {
            sum += num;
        }
        bool isPossible = false;
        for (int i = 1; i <= m; i++) {
            if (sum * i % n == 0) {
                isPossible = true;
                break;
            }
        }  
        if (!isPossible) {
            return false;
        }
        ISet<int>[] dp = new ISet<int>[m + 1];
        for (int i = 0; i <= m; i++) {
            dp[i] = new HashSet<int>();
        }
        dp[0].Add(0);
        foreach (int num in nums) {
            for (int i = m; i >= 1; i--) {
                foreach (int x in dp[i - 1]) {
                    int curr = x + num;
                    if (curr * n == sum * i) {
                        return true;
                    }
                    dp[i].Add(curr);
                } 
            }
        }
        return false;
    }
}

```

```
typedef struct {
    int key;
    UT_hash_handle hh;
} HashItem; 

HashItem *hashFindItem(HashItem **obj, int key) {
    HashItem *pEntry = NULL;
    HASH_FIND_INT(*obj, &key, pEntry);
    return pEntry;
}

bool hashAddItem(HashItem **obj, int key) {
    if (hashFindItem(obj, key)) {
        return false;
    }
    HashItem *pEntry = (HashItem *)malloc(sizeof(HashItem));
    pEntry->key = key;
    HASH_ADD_INT(*obj, key, pEntry);
    return true;
}

void hashFree(HashItem **obj) {
    HashItem *curr = NULL, *tmp = NULL;
    HASH_ITER(hh, *obj, curr, tmp) {
        HASH_DEL(*obj, curr);  
        free(curr);             
    }
}

bool splitArraySameAverage(int* nums, int numsSize) {
    int n = numsSize, m = n / 2;
    int sum = 0;
    for (int i = 0; i < numsSize; i++) {
        sum += nums[i];
    }
    bool isPossible = false;
    for (int i = 1; i <= m; i++) {
        if (sum * i % n == 0) {
            isPossible = true;
            break;
        }
    }  
    if (!isPossible) {
        return false;
    }
    HashItem *dp[m + 1];
    for (int i = 0; i <= m; i++) {
        dp[i] = NULL;
    }
    hashAddItem(&dp[0], 0);
    for (int j = 0; j < numsSize; j++) {
        for (int i = m; i >= 1; i--) {
            for (HashItem *pEntry = dp[i - 1]; pEntry != NULL; pEntry = pEntry->hh.next) {
                int curr = pEntry->key + nums[j];
                if (curr * n == sum * i) {
                    return true;
                }
                hashAddItem(&dp[i], curr);
            } 
        }
    }
    for (int i = 0; i <= m; i++) {
        hashFree(&dp[i]);
    }
    return false;
}

```

```
var splitArraySameAverage = function(nums) {
    if (nums.length === 1) {
        return false;
    }
    const n = nums.length, m = Math.floor(n / 2);
    let sum = 0;
    for (const num of nums) {
        sum += num;
    }
    let isPossible = false;
    for (let i = 1; i <= m; i++) {
        if (sum * i % n === 0) {
            isPossible = true;
            break;
        }
    }  
    if (!isPossible) {
        return false;
    }
    const dp = new Array(m + 1).fill(0).map(() => new Set());
    dp[0].add(0);
    for (const num of nums) {
        for (let i = m; i >= 1; i--) {
            for (const x of dp[i - 1]) {
                let curr = x + num;
                if (curr * n === sum * i) {
                    return true;
                }
                dp[i].add(curr);
            } 
        }
    }
    return false;
};

```

```
func splitArraySameAverage(nums []int) bool {
    sum := 0
    for _, x := range nums {
        sum += x
    }

    n := len(nums)
    m := n / 2
    isPossible := false
    for i := 1; i <= m; i++ {
        if sum*i%n == 0 {
            isPossible = true
            break
        }
    }
    if !isPossible {
        return false
    }

    dp := make([]map[int]bool, m+1)
    for i := range dp {
        dp[i] = map[int]bool{}
    }
    dp[0][0] = true
    for _, num := range nums {
        for i := m; i >= 1; i-- {
            for x := range dp[i-1] {
                curr := x + num
                if curr*n == sum*i {
                    return true
                }
                dp[i][curr] = true
            }
        }
    }
    return false
}

```

**复杂度分析**

-   时间复杂度：O(n2×sum(nums)))O(n^2 \\times \\textit{sum}(\\textit{nums})))O(n2×sum(nums)))，其中 nnn 表示数组的长度，sum(nums)\\textit{sum}(\\textit{nums})sum(nums) 表示数组 nums\\textit{nums}nums 的和。我们需要求出给定长度下所有可能的子集元素之和，数组的长度为 nnn，每种长度下子集的和最多有 sum(nums)\\textit{sum}(\\textit{nums})sum(nums) 个，因此总的时间复杂度为 O(n2×sum(nums))O(n^2 \\times \\textit{sum}(\\textit{nums}))O(n2×sum(nums))。
    
-   空间复杂度：O(n×sum(nums)))O(n \\times \\textit{sum}(\\textit{nums})))O(n×sum(nums)))。一共有 nnn 种长度的子集，每种长度的子集和最多有 sum(nums)\\textit{sum}(\\textit{nums})sum(nums) 个，因此需要的空间为 O(n×sum(nums)))O(n \\times \\textit{sum}(\\textit{nums})))O(n×sum(nums)))。