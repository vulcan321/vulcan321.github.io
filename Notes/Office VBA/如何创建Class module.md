### **如何定义Class module**

首先，小珂珂创建了一个新的类模块(Class module)。

![](https://pic2.zhimg.com/v2-e25b3b3a9d11d6f6f5531b6f107c2fa5_b.jpg)

![](https://pic2.zhimg.com/80/v2-e25b3b3a9d11d6f6f5531b6f107c2fa5_720w.jpg)

并把它的名字在属性窗口中改成了：factor

![](https://pic4.zhimg.com/v2-137bb4362e160894bd2207f4f9e9c5fb_b.jpg)

![](https://pic4.zhimg.com/80/v2-137bb4362e160894bd2207f4f9e9c5fb_720w.jpg)

注意，这个名字十分重要，它决定了我们要如何在普通模块中创建对象。

这里要解释一下没有用中文写属性名称的原因：因为在VBA编辑器中较难设定中文编码，在分发Excel文件的时候容易出现乱码问题。当然，如果您有更好的解决方案，欢迎留言。

### **如何创建属性**

小珂珂想要创建两个属性，一个是死亡率，一个是利息率。 这样的话，对于任何一个假设，都都可以轻易获得这些数据。 所以她打开了名为factor的类模块(Class model)，开始写属性啦~

定义变量。getmordata 是死亡数据表，getinsrate是利率。 好的编程习惯是一定要把Option Explicit加上哦，这样可以让代码更不容易出错，跑的更快。

```text
Option Explicit
Private getmordata As Variant
Private getinsrate As Single
```

对于某种属性，小珂珂都想要做两件事。

-   首先，要给这个属性赋值，
-   其次，要能够获取这个属性的值。

注意，这里面的变量getmordata，getinsrate 是这个类模块(Class model)里面的局域变量（private variable)，我们在调取属性的时候，并不需要用它们。

这个属性要通过下面定义的mortable()来获取。赋值在VBA中使用Let来表示的，代码如下：

```text
Property Let mortable(rData As Variant)
'这里可以定义一下如何验证属性rData的值
    '比如死亡率是否在0和1之间
    getmordata = rData
End Property
```

rData是我们给getmordata 赋值的时候用的参数。我们把rData的值赋给了mortable这个属性。注意，最后我们把值赋给了区域变量，而不是mortable。

假设小珂珂把mortable赋好值啦，那么该如何获取这个值呢？ 那么就涉及到Get啦~

```text
Property Get mortable() As Variant
        mortable = getmordata
End Property
```

可以把它想象成一个函数，因为VBA中利用函数时，返回值是通过给函数自身赋值得到的，所以我们要把地方变量getmordata的值赋予mortable。

利率的属性也是通过相同方法得到的，大家可以自己试一试哦。

-   这里最容易迷惑的点在于getmordata和mortable到底有什么区别？他俩看起来很相似呀，为什么要一个等于另一个呢？

可以这么想：getmordata是在类模块(Class model)中用来称呼死亡率表的名字，它不能在这个类模块(Class model)之外使用，而mortable是用来在类模块(Class model)外部称呼这个属性的。

### **如何创建方法**

接下来，小珂珂就要定义方法啦。方法就太简单啦。方法就是函数而已，不同之处在于，它可以直接调用一些定义好的属性。 下面的代码就是小珂珂计算A的过程

```text
Function bigavalue(lowerlimit As Integer, duration As Integer):
bigavalue = 0
Dim i As Integer
For i = lowerlimit To duration + lowerlimit
    bigavalue = bigavalue + getmordata(lowerlimit, 2) / (1 + insrate) ^ (0.05 + i - lowerlimit)
Next i
End Function
```

希望她还没有把精算数学还给老师。getmordata是死亡率的表，insrate是定义好的利率。通过一个循环算好A~ a的计算相似，大家可以想一想哦。

### **调用类模块(Class model)**

大家还记得小珂珂把定义的类模块(Class model)叫做factor了吗？想要定义新的对象，她是这样做滴：

```text
'Declare class variable
   Dim factorA As factor
   Dim factorB As factor
   
   Set factorA = New factor
   Set factorB = New factor
```

另一种方法是

```text
'Declare class variable
   Dim factorA As new factor
   Dim factorB As new factor
```

但是要记住，_最好使用第一种Dim/Set方法_。这两种方法最大的区别在于，第一种方法中，factor这个对象在set的时候就创造好了，第二种方法中，factor这个对象是在用它的时候创造的。而且第二种方法跑的更慢。

factorA和factorB都是新的factor，小珂珂不禁觉得，太简单啦。 然后小珂珂把这种假设的属性设置好。

-   Atable和Btable都是事先读取了Table1和Table2值的array数组。
-   rateA和rateB是两种假设下的利率。
-   bigavalue是用来计算A的方法。

注意Debug.Print的内容可以在即时窗口(immediate window)中显示出来。调用即时窗口(immediate window)的快捷键是Ctrl + G

```text
factorA.mortable = Atable
   factorB.mortable = Btable
   
   factorA.insrate = Range("rateA").Value
   factorB.insrate = Range("rateB").Value
   
'Calculations
   Debug.Print (factorA.bigavalue(10, 10))
   Debug.Print (factorA.smlavalue(10, 10))
   Debug.Print (factorB.bigavalue(10, 10))
   Debug.Print (factorB.smlavalue(10, 10))
```

### **集合(Collections)**

小珂珂此时想到，如果我能把所有假设放在一起就好啦。这样我能轻易找到自己一共定义了几个假设，调用或遍历起来也方便。

这个时候就要用到一个叫做集合(Collections)的东西。

像这样可以定义一个叫做Assumptions的集合:

```text
Dim Assumptions As Collection
Set Assumptions = New Collection
```

把我们刚刚定义好的对象加入进去：

```text
Assumptions.Add factorA
Assumptions.Add factorB
```

试着使用一下！

```text
For Each fac In Assumptions
    Debug.Print fac.insrate
Next fac
```

这样，把所有的factor对象都放到一个集合(Collections)中，遍历和管理就方便多啦。