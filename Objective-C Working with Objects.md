# Wordking with Objects

The majority of work in an Objective-C application happens as a result of messages being sent back and forth across an ecosystem of objects.
Objective-C 应用程序中的大部分工作都是由于在对象生态系统中来回发送消息而发生的。



Before an object can be used, it must be created properly using a combination of memory allocation for its properties and any necessary initialization of its internal values. This chapter describes how to nest the method calls to allocate and initialize an object in order to ensure that it is configured correctly.  
在使用对象之前，必须使用其属性的内存分配和其内部值的任何必要初始化的组合来正确创建该对象。本章介绍如何嵌套方法调用以分配和初始化对象，以确保正确配置对象。

## Objects Send and Receive Messages  
对象发送和接收消息

Although there are several different ways to send messages between objects in Objective-C, by far the most common is the basic syntax that uses square brackets, like this:  
尽管在 Objective-C 中，有几种不同的方法可以在对象之间发送消息，但到目前为止，最常见的是使用方括号的基本语法，如下所示：

```objc
    [someObject doSomething];
```



Assuming you’ve got hold of an `XYZPerson` object, you could send it the `sayHello` message like this:  
假设你已经掌握了一个 `XYZPerson` 对象，你可以向它发送 `sayHello` 消息，如下所示：

Sending an Objective-C message is conceptually very much like calling a C function. [Figure 2-1](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW4) shows the effective program flow for the `sayHello` message.  
从概念上讲，发送 Objective-C 消息非常类似于调用 C 函数。[图 2-1](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW4) 显示了 `sayHello` 消息的有效程序流程。

**Figure 2-1**  Basic messaging program flow  
**图 2-1** 基本消息传递程序流程
![Program Flow](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Art/programflow1.png "Program Flow")

### You Can Pass Objects for Method Parameters  


```
- (void)someMethodWithValue:(SomeType)value;
```

The syntax to declare a method that takes a string object, therefore, looks like this:  
因此，声明采用字符串对象的方法的语法如下所示：

```
- (void)saySomething:(NSString *)greeting;
```

You might implement the `saySomething:` method like this:  
您可以实现 `saySomething:` 方法，如下所示：

```objc
- (void)saySomething:(NSString *)greeting {
    NSLog(@"%@", greeting);
}

```

### Methods Can Return Values

As well as passing values through method parameters, it’s possible for a method to return a value. Each method shown in this chapter so far has a return type of `void`. The C `void` keyword means a method doesn’t return anything.  
除了通过方法参数传递值外，方法还可以返回值。到目前为止，本章中显示的每个方法都有一个返回类型 `void`。C `void` 关键字表示方法不返回任何内容。

Specifying a return type of `int` means that the method returns a scalar integer value:  
指定 `int` 的返回类型意味着该方法返回标量整数值：

The implementation of the method uses a C `return` statement to indicate the value that should be passed back after the method has finished executing, like this:  
该方法的实现使用 C `return` 语句来指示在方法完成执行后应传回的值，如下所示：

```objc
- (int)magicNumber {
    return 42;  
}

```

You can return objects from methods in just the same way. The `NSString` class, for example, offers an `uppercaseString` method:  
您可以用同样的方式从方法返回对象。例如，`NSString` 类提供了一个 `uppercaseString` 方法：

```
- (NSString *)uppercaseString;
```

It’s used in the same way as a method returning a scalar value, although you need to use a pointer to keep track of the result:  
它的使用方式与返回标量值的方法相同，但需要使用指针来跟踪结果：

```objc
NSString *testString = @"Hello, world!";
NSString *revisedString = [testString uppercaseString];

```

When this method call returns, `revisedString` will point to an `NSString` object representing the characters `HELLO WORLD!`.  
当此方法调用返回时，`revisedString` 将指向表示字符 `HELLO WORLD!` 的 `NSString` 对象。

Remember that when implementing a method to return an object, like this:  
请记住，在实现返回对象的方法时，如下所示：

```objc
- (NSString *)magicString {
    NSString *stringToReturn = // create an interesting string...
    return stringToReturn;
}

```

There are some memory management considerations in this situation: a returned object (created on the heap) needs to exist long enough for it to be used by the original caller of the method, but not in perpetuity because that would create a memory leak. For the most part, the Automatic Reference Counting (ARC) feature of the Objective-C compiler takes care of these considerations for you.  
在这种情况下，有一些内存管理注意事项：返回的对象（在堆上创建）需要存在足够长的时间，以便该方法的原始调用方使用它，但不能永久使用，因为这会造成内存泄漏。在大多数情况下，Objective-C 编译器的自动引用计数 （ARC） 功能会为您处理这些注意事项。

### Objects Can Send Messages to Themselves  

Whenever you’re writing a method implementation, you have access to an important hidden value, `self`. Conceptually, `self` is a way to refer to “the object that’s received this message.” It’s a pointer, just like the `greeting` value above, and can be used to call a method on the current receiving object.  
每当您编写方法实现时，您都可以访问一个重要的隐藏值 `self`。从概念上讲，`self` 是一种指代“接收此消息的对象”的方式。它是一个指针，就像上面的`greeting`值一样，可用于调用当前接收对象上的方法。

The new implementation using `self` to call a message on the current object would look like this:  
使用 `self` 在当前对象上调用消息的新实现如下所示：

```objc
@implementation XYZPerson
- (void)sayHello {
    [self saySomething:@"Hello, world!"];
}
- (void)saySomething:(NSString *)greeting {
    NSLog(@"%@", greeting);
}
@end

```

If you sent an `XYZPerson` object the `sayHello` message for this updated implementation, the effective program flow would be as shown in [Figure 2-2](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW8).  
如果向 `XYZPerson` 对象发送了此更新实现的 `sayHello` 消息，则有效的程序流将如[图 2-2](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW8) 所示。

**Figure 2-2**  Program flow when messaging self  
**图 2-2** 消息传递自身时的程序流

![](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Art/programflow2.png)

### Objects Can Call Methods Implemented by Their Superclasses  

There’s another important keyword available to you in Objective-C, called `super`. Sending a message to `super` is a way to call through to a method implementation defined by a superclass further up the inheritance chain. The most common use of `super` is when overriding a method.  
在 Objective-C 中还有另一个重要的关键字，称为 `super`。向 `super` 发送消息是一种调用由继承链上游的超类定义的方法实现的方法。`super` 最常见的用途是重写方法。

```objc
@interface XYZShoutingPerson : XYZPerson
@end

```

```objc
@implementation XYZShoutingPerson
- (void)saySomething:(NSString *)greeting {
    NSString *uppercaseGreeting = [greeting uppercaseString];
    NSLog(@"%@", uppercaseGreeting);
}
@end

```

This example declares an extra string pointer, `uppercaseGreeting` and assigns it the value returned from sending the original `greeting` object the `uppercaseString` message. As you saw earlier, this will be a new string object built by converting each character in the original string to uppercase.  
此示例声明一个额外的字符串指针 `uppercaseGreeting`，并为其分配从向原始`greeting`发送 `uppercaseString` 消息时返回的值。如前所述，这将是一个通过将原始字符串中的每个字符转换为大写字母来构建的新字符串对象。


A better idea would be to change the `XYZShoutingPerson` version of `saySomething:` to call through to the superclass (`XYZPerson`) implementation to handle the actual greeting:  
一个更好的主意是更改 `saySomething:` 的 `XYZShoutingPerson` 版本，以调用超类 （`XYZPerson`） 实现来处理实际的问候语：

```objc
@implementation XYZShoutingPerson
- (void)saySomething:(NSString *)greeting {
    NSString *uppercaseGreeting = [greeting uppercaseString];
    [super saySomething:uppercaseGreeting];
}
@end

```

The effective program flow that now results from sending an `XYZShoutingPerson` object the `sayHello` message is shown in [Figure 2-4](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW12).  
现在通过发送 `XYZShoutingPerson` 对象 `sayHello` 消息而产生的有效程序流如[图 2-4](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW12) 所示。

**Figure 2-4**  Program flow when messaging super  
**图 2-4** 消息传递超级时的程序流

![](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Art/programflow4.png)

## Objects Are Created Dynamically  
对象是动态创建的

As described earlier in this chapter, memory is allocated dynamically for an Objective-C object. The first step in creating an object is to make sure enough memory is allocated not only for the properties defined by an object’s class, but also the properties defined on each of the superclasses in its inheritance chain.  
如本章前面所述，内存是为 Objective-C 对象动态分配的。创建对象的第一步是确保不仅为对象的类定义的属性分配足够的内存，还为其继承链中的每个超类定义的属性分配足够的内存。

The `NSObject` root class provides a class method, `alloc`, which handles this process for you:  
`NSObject` 根类提供了一个类方法 `alloc`，用于处理此过程：

Notice that the return type of this method is `id`. This is a special keyword used in Objective-C to mean “some kind of object.” It is a pointer to an object, like `(NSObject *)`, but is special in that it doesn’t use an asterisk. It’s described in more detail later in this chapter, in [Objective-C Is a Dynamic Language](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW18).  
请注意，此方法的返回类型为 `id`。这是 Objective-C 中使用的一个特殊关键字，表示“某种对象”。它是指向对象的指针，如 `(NSObject *)`但其特殊之处在于它不使用星号。本章后面的 [Objective-C is a Dynamic Language](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW18) 中对此进行了更详细的描述。

The `alloc` method has one other important task, which is to clear out the memory allocated for the object’s properties by setting them to zero. This avoids the usual problem of memory containing garbage from whatever was stored before, but is not enough to initialize an object completely.  
`alloc` 方法还有一项重要任务，即通过将对象属性设置为零来清除为对象属性分配的内存。这避免了内存包含以前存储的任何内容的垃圾的常见问题，但不足以完全初始化对象。

You need to combine a call to `alloc` with a call to `init`, another `NSObject` method:  
您需要将对 `alloc` 的调用与对 `init` 的调用（另一个 `NSObject` 方法）结合起来：

The `init` method is used by a class to make sure its properties have suitable initial values at creation, and is covered in more detail in the next chapter.  
类使用 `init` 方法来确保其属性在创建时具有合适的初始值，下一章将更详细地介绍该方法。

Note that `init` also returns an `id`.  


If one method returns an object pointer, it’s possible to nest the call to that method as the receiver in a call to another method, thereby combining multiple message calls in one statement. The correct way to allocate and initialize an object is to nest the `alloc` call _inside_ the call to `init`, like this:  
如果一个方法返回对象指针，则可以将对该方法的调用嵌套在对另一个方法的调用中作为接收方，从而将多个消息调用组合到一个语句中。分配和初始化对象的正确方法是将 `alloc` 调用嵌套在对 `init` 的调用_中_，如下所示：

```
    NSObject *newObject = [[NSObject alloc] init];
```

This example sets the `newObject` variable to point to a newly created `NSObject` instance.  
此示例将 `newObject` 变量设置为指向新创建的 `NSObject` 实例。

The innermost call is carried out first, so the `NSObject` class is sent the `alloc` method, which returns a newly allocated `NSObject` instance. This returned object is then used as the receiver of the `init` message, which itself returns the object back to be assigned to the `newObject` pointer, as shown in [Figure 2-5](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW14).  
首先执行最里面的调用，因此向 `NSObject` 类发送 `alloc` 方法，该方法返回新分配的 `NSObject` 实例。然后，将此返回的对象用作 `init` 消息的接收方，该消息本身将对象返回以分配给 `newObject` 指针，如[图 2-5](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW14) 所示。

**Figure 2-5**  Nesting the alloc and init message  
**图 2-5** 嵌套 alloc 和 init 消息

![](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Art/nestedallocinit.png)

### Initializer Methods Can Take Arguments

Some objects need to be initialized with required values. An `NSNumber` object, for example, must be created with the numeric value it needs to represent.

The `NSNumber` class defines several initializers, including:  
`NSNumber` 类定义了多个初始值设定项，包括：

```objc
- (id)initWithBool:(BOOL)value;
- (id)initWithFloat:(float)value;
- (id)initWithInt:(int)value;
- (id)initWithLong:(long)value;

```

Initialization methods with arguments are called in just the same way as plain `init` methods—an `NSNumber` object is allocated and initialized like this:  
带有参数的初始化方法的调用方式与普通`init`方法相同 — `NSNumber` 对象的分配和初始化方式如下：

```
    NSNumber *magicNumber = [[NSNumber alloc] initWithInt:42];
```

### Class Factory Methods Are an Alternative to Allocation and Initialization  

As mentioned in the previous chapter, a class can also define factory methods. Factory methods offer an alternative to the traditional `alloc] init]` process, without the need to nest two methods.  
如上一章所述，类还可以定义工厂方法。工厂方法提供了传统 `alloc] init]` 过程的替代方法，无需嵌套两个方法。

The `NSNumber` class defines several class factory methods to match its initializers, including:  
`NSNumber` 类定义了几个类工厂方法来匹配其初始值设定项，包括：

```objc
+ (NSNumber *)numberWithBool:(BOOL)value;
+ (NSNumber *)numberWithFloat:(float)value;
+ (NSNumber *)numberWithInt:(int)value;
+ (NSNumber *)numberWithLong:(long)value;

```

A factory method is used like this:  

```
    NSNumber *magicNumber = [NSNumber numberWithInt:42];
```

This is effectively the same as the previous example using `alloc] initWithInt:]`. Class factory methods usually just call straight through to `alloc` and the relevant `init` method, and are provided for convenience.

### Use new to Create an Object If No Arguments Are Needed for Initialization

It’s also possible to create an instance of a class using the `new` class method. This method is provided by `NSObject` and doesn’t need to be overridden in your own subclasses.

It’s effectively the same as calling `alloc` and `init` with no arguments:

```objc
XYZObject *object = [XYZObject new];
// is effectively the same as:
XYZObject *object = [[XYZObject alloc] init];

```

### Literals Offer a Concise Object-Creation Syntax  

Some classes allow you to use a more concise, _literal_ syntax to create instances.

You can create an `NSString` instance, for example, using a special literal notation, like this:  
例如，您可以使用特殊的文字表示法创建 `NSString` 实例，如下所示：

```
    NSString *someString = @"Hello, World!";
```

This is effectively the same as allocating and initializing an `NSString` or using one of its class factory methods:  
这实际上与分配和初始化 `NSString` 或使用其类工厂方法之一相同：

```objc
NSString *someString = [NSString stringWithCString:"Hello, World!"
                                          encoding:NSUTF8StringEncoding];

```

The `NSNumber` class also allows a variety of literals:  
`NSNumber` 类还允许各种文本：

```objc
NSNumber *myBOOL = @YES;
NSNumber *myFloat = @3.14f;
NSNumber *myInt = @42;
NSNumber *myLong = @42L;

```

Again, each of these examples is effectively the same as using the relevant initializer or a class factory method.  
同样，这些示例中的每一个实际上都与使用相关的初始值设定项或类工厂方法相同。

You can also create an `NSNumber` using a boxed expression, like this:  
您还可以使用盒装表达式创建 `NSNumber`，如下所示：

```
    NSNumber *myInt = @(84 / 2);
```

In this case, the expression is evaluated, and an `NSNumber` instance created with the result.  
在这种情况下，将计算表达式，并使用结果创建 `NSNumber` 实例。

Objective-C also supports literals to create immutable `NSArray` and `NSDictionary` objects; these are discussed further in [Values and Collections](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/FoundationTypesandCollections/FoundationTypesandCollections.html#//apple_ref/doc/uid/TP40011210-CH7-SW1).  
Objective-C 还支持文字来创建不可变的 `NSArray` 和 `NSDictionary` 对象;这些将在[值和集合](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/FoundationTypesandCollections/FoundationTypesandCollections.html#//apple_ref/doc/uid/TP40011210-CH7-SW1)中进一步讨论。

## Objective-C Is a Dynamic Language  

The `id` type defines a generic object pointer. It’s possible to use `id` when declaring a variable, but you lose _compile_\-time information about the object.  
`id` 类型定义泛型对象指针。声明变量时可以使用 `id`，但会丢失有关对象的_编译_时信息。

Consider the following code:  
请考虑以下代码：

```objc
id someObject = @"Hello, World!";
[someObject removeAllObjects];

```

In this case, `someObject` will point to an `NSString` instance, but the compiler knows nothing about that instance beyond the fact that it’s some kind of object. The `removeAllObjects` message is defined by some Cocoa or Cocoa Touch objects (such as `NSMutableArray`) so the compiler doesn’t complain, even though this code would generate an exception at runtime because an `NSString` object can’t respond to `removeAllObjects`.  
在这种情况下，`someObject` 将指向一个 `NSString` 实例，但编译器对该实例一无所知，只知道它是某种对象。`removeAllObjects` 消息由某些 Cocoa 或 Cocoa Touch 对象（如 `NSMutableArray`）定义，因此编译器不会抱怨，即使此代码会在运行时生成异常，因为 `NSString` 对象无法响应 `removeAllObjects`。

Rewriting the code to use a static type:  
重写代码以使用静态类型：

```objc
NSString *someObject = @"Hello, World!";
[someObject removeAllObjects];
```

means that the compiler will now generate an error because `removeAllObjects` is not declared in any public `NSString` interface that it knows about.  
表示编译器现在将生成错误，因为 `removeAllObjects` 未在它知道的任何公共 `NSString` 接口中声明。

Because the class of an object is determined at runtime, it makes no difference what type you assign a variable when creating or working with an instance. To use the `XYZPerson` and `XYZShoutingPerson` classes described earlier in this chapter, you might use the following code:  
由于对象的类是在运行时确定的，因此在创建或使用实例时，为变量分配哪种类型没有区别。若要使用本章前面所述的 `XYZPerson` 和 `XYZShoutingPerson` 类，可以使用以下代码：

```objc
    XYZPerson *firstPerson = [[XYZPerson alloc] init];
    XYZPerson *secondPerson = [[XYZShoutingPerson alloc] init];
    [firstPerson sayHello];
    [secondPerson sayHello];
```

Although both `firstPerson` and `secondPerson` are statically typed as `XYZPerson` objects, `secondPerson` will point, at _runtime_, to an `XYZShoutingPerson` object. When the `sayHello` method is called on each object, the correct implementations will be used; for `secondPerson`, this means the `XYZShoutingPerson` version.  
尽管 `firstPerson` 和 `secondPerson` 都静态类型化为 `XYZPerson` 对象，但 `secondPerson` 将在_运行时_指向 `XYZShoutingPerson` 对象。在每个对象上调用 `sayHello` 方法时，将使用正确的实现;对于 `secondPerson`，这意味着 `XYZShoutingPerson` 版本。

### Determining Equality of Objects  

If you need to determine whether one object is the same as another object, it’s important to remember that you’re working with pointers.  
如果需要确定一个对象是否与另一个对象相同，请务必记住您使用的是指针。


When dealing with objects, the _\==_ operator is used to test whether two separate pointers are pointing to the same object:  
处理对象时，_\==_ 运算符用于测试两个单独的指针是否指向同一个对象：

```objc
    if (firstPerson == secondPerson) {
        // firstPerson is the same object as secondPerson
    }

```

If you need to test whether two objects represent the same data, you need to call a method like `isEqual:`, available from `NSObject`:  
如果需要测试两个对象是否表示相同的数据，则需要调用类似 `isEqual:` 的方法，可从 `NSObject` 获得：

```objc
    if ([firstPerson isEqual:secondPerson]) {
        // firstPerson is identical to secondPerson
    }

```

If you need to compare whether one object represents a greater or lesser value than another object, you can’t use the standard C comparison operators `>` and `<`. Instead, the basic Foundation types, like `NSNumber`, `NSString` and `NSDate`, provide a `compare:` method:  
如果需要比较一个对象表示的值是大于还是小于另一个对象，则不能使用标准的 C 比较运算符`>`和`<`。相反，基本的 Foundation 类型（如 `NSNumber`、`NSString` 和 `NSDate`）提供了 `compare:` 方法：

```objc
    if ([someDate compare:anotherDate] == NSOrderedAscending) {
        // someDate is earlier than anotherDate
    }

```

### Working with nil


This isn’t necessary for object pointers, because the compiler will automatically set the variable to `nil` if you don’t specify any other initial value:  
这对于对象指针不是必需的，因为如果不指定任何其他初始值，编译器会自动将变量设置为 `nil`：

```objc
XYZPerson *somePerson;
// somePerson is automatically set to nil

```

A `nil` value is the safest way to initialize an object pointer if you don’t have another value to use, because it’s perfectly acceptable in Objective-C to send a message to `nil`. If you do send a message to `nil`, obviously nothing happens.  
如果没有其他值可以使用，`nil` 值是初始化对象指针的最安全方法，因为在 Objective-C 中，向 `nil` 发送消息是完全可以接受的。如果您确实向 `nil` 发送消息，显然什么也没发生。

If you need to check to make sure an object is not `nil` (that a variable points to an object in memory), you can either use the standard C inequality operator:  
如果需要检查以确保对象不是 `nil`（变量指向内存中的对象），则可以使用标准的 C 不等式运算符：

```objc
if (somePerson != nil) {
    // somePerson points to an object
    }

```

or simply supply the variable:  

```objc
if (somePerson) {
    // somePerson points to an object
    }

```

Similarly, if you need to check for a `nil` variable, you can either use the equality operator:  

```objc
if (somePerson == nil) {
    // somePerson does not point to an object
    }

```

or just use the C logical negation operator:  

```objc
if (!somePerson) {
    // somePerson does not point to an object
    }

```

## Exercises习题

1.  Open the `main.m` file in your project from the exercises at the end of the last chapter and find the `main()` function. As with any executable written in C, this function represents the starting point for your application.
    
      
    从上一章末尾的练习中打开项目中的 `main.m` 文件，然后找到 `main()` 函数。与用 C 编写的任何可执行文件一样，此函数表示应用程序的起点。
    
    Create a new `XYZPerson` instance using `alloc` and `init`, and then call the `sayHello` method.
    
      
    使用 `alloc` 和 `init` 创建新的 `XYZPerson` 实例，然后调用 `sayHello` 方法。
2.  Implement the `saySomething:` method shown earlier in this chapter, and rewrite the `sayHello` method to use it. Add a variety of other greetings and call each of them on the instance you created above.
    
      
    实现本章前面所示的 `saySomething:` 方法，并重写 `sayHello` 方法以使用它。添加各种其他问候语，并在您上面创建的实例上调用每个问候语。
3.  Create new class files for the `XYZShoutingPerson` class, set to inherit from `XYZPerson`.
    
      
    为 `XYZShoutingPerson` 类创建新的类文件，设置为继承自 `XYZPerson`。
    
    Override the `saySomething:` method to display the uppercase greeting, and test the behavior on an `XYZShoutingPerson` instance.
    
      
    重写 `saySomething:` 方法以显示大写的问候语，并在 `XYZShoutingPerson` 实例上测试行为。
4.  Implement the `XYZPerson` class `person` factory method you declared in the previous chapter, to return a correctly allocated and initialized instance of the `XYZPerson` class, then use the method in `main()` instead of your nested `alloc` and `init`.
    
      
    实现您在上一章中声明的 `XYZPerson` 类 `person` 工厂方法，以返回正确分配和初始化的 `XYZPerson` 类实例，然后在 `main()` 中使用该方法，而不是嵌套的 `alloc` 和 `init`。
5.  Create a new local `XYZPerson` pointer, but don’t include any value assignment.
    
      
    创建新的本地 `XYZPerson` 指针，但不要包含任何值赋值。
    
    Use a branch (`if` statement) to check whether the variable is automatically assigned as `nil`.
    
      
    使用分支（`if` 语句）检查变量是否自动赋值为 `nil`。
