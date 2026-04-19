# [Objective C ARC 使用及原理](https://www.cnblogs.com/Lxiaolong/p/4722351.html)

-   不考虑 iOS4 的 ARC 规则

### 简单地说，ARC在编译时刻为代码在合适的位置加上retain 和 release。 复杂点，它还提供其它一些功能，还为解决一些问题，添加了一些关键字和功能，后面会说。
----
## ARC强制要求的新规则

-   不可以调用dealloc, 不可以实现或者调用retain, release, retainCount, autorelease；
-   不可以使用NSAllocateObject, NSDeallocateObject；
-   在C 结构体里不可以使用 Objective C 对象，比如下面是不允许的:
    
    ```csharp
      struct A {
          NSString *string;
      };
    ```
    
-   id 和 void \* 之间没有自然的转换
    
    id 指的是 Objective C 对象  
    void \* 指的是 C指针, CGColorRef这种东西  
    id 和 void \*之间赋值要添加 \_\_bridge 系列关键字(后面说)
    
-   不可以使用 NSAutoreleasePool 用 @autoreleasepool 替代；
    
-   不可以使用 memory zones (NSZone)。(表示没认真用过)
-   不可以给属性取new开头的名字, 除非给它起个不是new开头的getter. (原因不明)
    
    ```objectivec
      // Won't work
      @property NSString *newTitle;
      // words:
      @property (getter=theNewTitle) NSString *newTitle;
    ```
    
----
## 属性声明

### 引入了weak, strong, unsafe\_unretained, 去掉了retain, 保留了assign 其余不变。

-   strong 相当于 MRC(Manual Reference Counting) 的 retain
-   weak 相当于 MRC 的 assign 但是 在指向的对象被销毁的时候，指针会被设置成0
-   assign 属性 如果是Objective C 对象，在没有特殊处理的时候，相当于strong
    
    下面代码在 MRC 情况下是弱引用的
    
    ```objectivec
      @interface MyClass : Superclass {
          id thing; // Weak reference.
      }
      // ...
      @end
      @implementation MyClass
      - (id)thing {
          return thing;
      }           
      - (void)setThing:(id)newThing {
          thing = newThing;
      }
      // ...
      @end
    ```
    
    在 ARC 情况下， id thing; 被转换成了 id \_\_strong thing;  
    所以要把上面代码的 id thing; 改为 id \_\_weak thing; 才接近原来assign的意思。
    
-   unsafe\_unretained 和原来的 assign行为最像。
    
-   对于手动写 setter getter 又设置了修饰符的情况，我没有研究；

## 变量修饰符

下面的变量表示Objective C对象变量

-   \_\_strong
    
    默认，变量在，对象在

    ```objectivec
    NSNumber * __strong number = [NSNumber numberWithInt:13];
    ```

    将会被编译成

    ```objectivec
    NSNumber * number = [[NSNumber numberWithInt:13] retain];
    ……
    // 在 number 所在的定义域外, 或者 number = nil 的时候。
    [number release];
    ```

-   \_\_weak
    
    对象在，变量可以安全使用对象， 对象销毁，变量被设置为nil  
    

-   \_\_unsafe\_unretained
    
    对象在不在和变量无关， 变量在不在和对象无关，如果对象被销毁了，还通过变量想使用对象，会崩溃，是不安全的。(意会)
    
-   \_\_autorelease
    
    表示指向的对象是autorelease的, 例子如下
    
    ```objectivec
      // In non-ARC Programming, the save function looks like this:
      - (BOOL)save:(NSError * __autoreleasing *)myError {
          *myError = [[[NSError alloc] initWith…] autorelease]
      }
      // In ARC Programming, the save function looks like this:
      - (BOOL)save:(NSError * __autoreleasing *)myError {
          *myError = [[NSError alloc] initWith…];
      }
    ```
    
    ARC代码
    
    ```objectivec
      NSError *error;
      BOOL OK = [myObject performOperationWithError:&error];
    ```
    
    被转换成
    
    ```objectivec
      NSError * __strong error;
      NSError * __autoreleasing tmp = error;
      BOOL OK = [myObject performOperationWithError:&tmp];
      error = tmp;
    ```
    
    其实可以直接使用 NSError \* \_\_autoreleasing error; 来增加效率。

    myObject 的 performOperationWithError 使用的可能是 MRC 的代码， 也可能是 ARC的代码， 但它参数返回的肯定是一个autorelease的对象。 有了 \_\_autoreleasing 修饰， 编译器可以知道从 performOperationWithError 方法获得 tmp 后不需要处理它的内存问题。

    ```objectivec
    NSNumber * __autorelease number = [[NSNumber alloc] initWithInt:13];
    ```

    将会被编译成

    ```objectivec
    NSNumber * number = [[[NSNumber alloc] initWithInt:13] autorelease];
    ``` 

----
## (下面可能存在误导，要批判地看！)
### 防止循环引用和长时间过程中被销毁

在 MRC 中 \_\_block id x = y; block 将不会 \[x retain\]; 在block执行完之后也不会 \[x release\];

在 ARC 中 \_\_block id x = y; 应该等于 \_\_strong \_\_block id x = y; 这样会有一个retain的过程，在block被销毁的时候 \[x release\]。

从上面可以知道使用 \_\_block id x = y; 而x如果拥有block的copy, 不进行处理会造成循环引用。

于是 apple 告诉我们可以这样写:

```objectivec
MyViewController * __block myController = [[MyViewController alloc] init…];
// ...
myController.completionHandler =  ^(NSInteger result) {
    [myController dismissViewControllerAnimated:YES completion:nil];
    myController = nil;
};
```

但对于多次调用的情况，上面无法达到目的。可以用 **weak 关键字来替代** block (注意是替代，不是合在一起用，我对合在一起用没研究)

```objectivec
MyViewController *myController = [[MyViewController alloc] init…];
// ...
MyViewController * __weak weakMyViewController = myController;
    myController.completionHandler =  ^(NSInteger result) {
    [weakMyViewController dismissViewControllerAnimated:YES completion:nil];
};
```

上面还是会造成问题， 如果block的代码会执行很长时间， 在那段时间 weakMyViewController 被销毁了， 那么它就变成了 nil. 程序不是崩溃就是得到错误的结果， 这样是不行的，apple 也提供了解决方法

```objectivec
MyViewController *myController = [[MyViewController alloc] init…];
// ...
MyViewController * __weak weakMyController = myController;
myController.completionHandler =  ^(NSInteger result) {
    MyViewController *strongMyController = weakMyController;
    if (strongMyController) {
        // ...
        [strongMyController dismissViewControllerAnimated:YES completion:nil];
        // ...
    }
    else {
        // Probably nothing...
    }
};
```

## Toll-Free Bridging

-   \_\_bridge : Objective-C 和 Core Foundation 之间的转换， 拥有权不变。
-   \_\_bridge\_retained : 从 Objective-C 到 Core Foundation 的转换，由程序员负责把得到的 CFxxxRef 销毁
-   \_\_bridge\_transfer : 从 Core Foundation 到 Objective-C 的转换，由ARC负责把得到的 id 销毁

\_\_bridge\_retained 的作用等于 CFBridgingRetain  
\_\_bridge\_transfer 的作用等于 CFBridgingRelease

## Cocoa 方法返回的 CF 对象

比如 \[\[UIColor greenColor\] CGColor\]; 编译器知道返回的 CFxxxRef 是不是需要 release 的， 当需要把它在此转换成 Cocoa 对象的时候， 不必用 \_\_bridge \_\_bridge\_transfer 这样的修饰符， 但需要显式写出要转换成的类型， 比如：

UIColor \*color = (id)\[UIColor greenColor\].CGColor; // 虽然这样比较无聊。