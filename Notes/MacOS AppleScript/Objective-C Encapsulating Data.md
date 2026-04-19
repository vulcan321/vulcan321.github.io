# Encapsulating Data

### Declare Public Properties for Exposed Data  

Objective-C properties offer a way to define the information that a class is intended to encapsulate. property declarations are included in the interface for a class, like this:  
Objective-C 属性提供了一种定义类要封装的信息的方法。属性声明包含在类的接口中，如下所示：

```objective-c
@interface XYZPerson : NSObject
@property NSString *firstName;
@property NSString *lastName;
@end
```

### Use Accessor Methods to Get or Set Property Values  

You access or set an object’s properties via accessor methods:  
您可以通过访问器方法访问或设置对象的属性：

```objective-c
NSString *firstName = [somePerson firstName];
[somePerson setFirstName:@"Johnny"];
```

By default, these accessor methods are synthesized automatically for you by the compiler, so you don’t need to do anything other than declare the property using `@property` in the class interface.  
默认情况下，这些访问器方法由编译器自动合成，因此除了在类接口中使用 `@property` 声明属性外，无需执行任何操作。

The synthesized methods follow specific naming conventions:  
合成方法遵循特定的命名约定：

- The method used to access the value (the _getter_ method) has the same name as the property.

    用于访问值的方法（_getter_ 方法）与属性同名。

    The getter method for a property called `firstName` will also be called `firstName`.  
    名为 `firstName` 的属性的 getter 方法也将称为 `firstName`。

- The method used to set the value (the _setter_ method) starts with the word “set” and then uses the capitalized property name.

    用于设置值的方法（_setter_ 方法）以单词“set”开头，然后使用大写的属性名称。

    The setter method for a property called `firstName` will be called `setFirstName:`.

    名为 `firstName` 的属性的 setter 方法将称为 `setFirstName:`。

If you don’t want to allow a property to be changed via a setter method, you can add an attribute to a property declaration to specify that it should be `readonly`:  
如果不想允许通过 setter 方法更改属性，可以向属性声明添加属性以指定它应为`readonly`：

```objective-c
@property (readonly) NSString *fullName;
```

As well as showing other objects how they are supposed to interact with the property, attributes also tell the compiler how to synthesize the relevant accessor methods.  
除了向其他对象显示它们应该如何与属互外，特性还告诉编译器如何合成相关的访问器方法。

In this case, the compiler will synthesize a `fullName` getter method, but not a `setFullName:` method.  
在这种情况下，编译器将合成 `fullName` getter 方法，但不会合成 `setFullName:` 方法。

**Note:** The opposite of `readonly` is `readwrite`. There’s no need to specify the `readwrite` attribute explicitly, because it is the default.  

If you want to use a different name for an accessor method, it’s possible to specify a custom name by adding attributes to the property. In the case of Boolean properties (properties that have a `YES` or `NO` value), it’s customary for the getter method to start with the word “is.” The getter method for a property called `finished`, for example, should be called `isFinished`.  
如果要对访问器方法使用不同的名称，可以通过向属性添加属性来指定自定义名称。对于布尔属性（具有 YES 或 NO 值的属性），getter 方法通常以单词“is”开头。例如，名为 `finished` 的属性的 getter 方法应称为 `isFinished`。

Again, it’s possible to add an attribute on the property:  
同样，可以在属性上添加属性：

<table><tbody><tr><td scope="row"><pre>@property (getter=isFinished) BOOL finished;<span></span></pre></td></tr></tbody></table>

If you need to specify multiple attributes, simply include them as a comma-separated list, like this:  
如果需要指定多个属性，只需将它们作为逗号分隔的列表包含在内，如下所示：

<table><tbody><tr><td scope="row"><pre>@property (readonly, getter=isFinished) BOOL finished;<span></span></pre></td></tr></tbody></table>

In this case, the compiler will synthesize only an `isFinished` method, but not a `setFinished:` method.  
在这种情况下，编译器将仅合成 `isFinished` 方法，而不会合成 `setFinished:` 方法。

**Note:** In general, property accessor methods should be Key-Value Coding (KVC) compliant, which means that they follow explicit naming conventions.  
**注意：**通常，属性访问器方法应符合键值编码 （KVC），这意味着它们遵循显式命名约定。

See _[Key-Value Coding Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../../KeyValueCoding/index.html#//apple_ref/doc/uid/10000107i)_ for more information.  

### Dot Syntax Is a Concise Alternative to Accessor Method Calls  

As well as making explicit accessor method calls, Objective-C offers an alternative dot syntax to access an object’s properties.  
除了进行显式访问器方法调用外，Objective-C 还提供了另一种点语法来访问对象的属性。

Dot syntax allows you to access properties like this:  
点语法允许您访问如下属性：

```objective-c
NSString *firstName = somePerson.firstName;
somePerson.firstName = @"Johnny";
```

Dot syntax is purely a convenient wrapper around accessor method calls. When you use dot syntax, the property is still accessed or changed using the getter and setter methods mentioned above:  
点语法纯粹是访问器方法调用的方便包装器。使用点语法时，仍使用上面提到的 getter 和 setter 方法访问或更改该属性：

- Getting a value using `somePerson.firstName` is the same as using `[somePerson firstName]`

- Setting a value using `somePerson.firstName = @"Johnny"` is the same as using `[somePerson setFirstName:@"Johnny"]`

### Most Properties Are Backed by Instance Variables  

By default, a `readwrite` property will be backed by an instance variable, which will again be synthesized automatically by the compiler.  
默认情况下，`readwrite` 属性将由实例变量支持，该变量将再次由编译器自动合成。

An instance variable is a variable that exists and holds its value for the life of the object. The memory used for instance variables is allocated when the object is first created (through `alloc`), and freed when the object is deallocated.  
实例变量是在对象的生命周期内存在并保持其值的变量。用于实例变量的内存在首次创建对象时分配（通过 `alloc`），并在解除分配对象时释放。

Unless you specify otherwise, the synthesized instance variable has the same name as the property, but with an underscore prefix. For a property called `firstName`, for example, the synthesized instance variable will be called `_firstName`.  
除非另行指定，否则合成的实例变量与属性同名，但带有下划线前缀。例如，对于名为 `firstName` 的属性，合成的实例变量将称为 `_firstName`。

Although it’s best practice for an object to access its own properties using accessor methods or dot syntax, it’s possible to access the instance variable directly from any of the instance methods in a class implementation. The underscore prefix makes it clear that you’re accessing an instance variable rather than, for example, a local variable:  
尽管最佳做法是对象使用访问器方法或点语法访问其自己的属性，但可以直接从类实现中的任何实例方法访问实例变量。下划线前缀清楚地表明您正在访问实例变量，而不是局部变量：

```objective-c
- (void)someMethod {
    NSString *myString = @"An interesting string";
    _someString = myString;
}
```

In this example, it’s clear that `myString` is a local variable and `_someString` is an instance variable.  
在此示例中，很明显 `myString` 是局部变量，`_someString` 是实例变量。

In general, you should use accessor methods or dot syntax for property access even if you’re accessing an object’s properties from within its own implementation, in which case you should use `self`:  
通常，即使从对象自己的实现中访问对象的属性，也应使用访问器方法或点语法进行属性访问，在这种情况下，应使用 `self`：

```objective-c
- (void)someMethod {
    NSString *myString = @"An interesting string";
    self.someString = myString;
    // or
    [self setSomeString:myString];
}
```

The exception to this rule is when writing initialization, deallocation or custom accessor methods, as described later in this section.  
此规则的例外情况是在编写初始化、解除分配或自定义访问器方法时，如本节后面所述。

#### You Can Customize Synthesized Instance Variable Names  

As mentioned earlier, the default behavior for a writeable property is to use an instance variable called `_propertyName`.  
如前所述，可写属性的默认行为是使用名为 `_propertyName` 的实例变量。

If you wish to use a different name for the instance variable, you need to direct the compiler to synthesize the variable using the following syntax in your implementation:  
如果希望对实例变量使用不同的名称，则需要指示编译器在实现中使用以下语法合成变量：

```objective-c
@implementation YourClass
@synthesize propertyName = instanceVariableName;
...
@end
```

For example:例如：

```objective-c
@synthesize firstName = ivar_firstName;
```

In this case, the property will still be called `firstName`, and be accessible through `firstName` and `setFirstName:` accessor methods or dot syntax, but it will be backed by an instance variable called `ivar_firstName`.  
在这种情况下，该属性仍将称为 `firstName`，并且可以通过 `firstName` 和 `setFirstName:` 访问器方法或点语法进行访问，但它将由名为 `ivar_firstName` 的实例变量提供支持。

**Important:** If you use `@synthesize` without specifying an instance variable name, like this:  
**重要：**如果在未指定实例变量名称的情况下使用 `@synthesize`，如下所示：

```objective-c
@synthesize firstName;
```

the instance variable will bear the same name as the property.  
实例变量将与属性同名。

In this example, the instance variable will also be called `firstName`, without an underscore.  
在此示例中，实例变量也将称为 `firstName`，不带下划线。

#### You Can Define Instance Variables without Properties  

It’s best practice to use a property on an object any time you need to keep track of a value or another object.  
最佳做法是在需要跟踪值或其他对象时对对象使用属性。

If you do need to define your own instance variables without declaring a property, you can add them inside braces at the top of the class interface or implementation, like this:  
如果您确实需要在不声明属性的情况下定义自己的实例变量，则可以将它们添加到类接口或实现顶部的大括号内，如下所示：
```objective-c
@interface SomeClass : NSObject {
    NSString *_myNonPropertyInstanceVariable;
}
...
@end

@implementation SomeClass {
    NSString *_anotherCustomInstanceVariable;
}
...
@end
```

**Note:** You can also add instance variables at the top of a class extension, as described in [Class Extensions Extend the Internal Implementation](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../CustomizingExistingClasses/CustomizingExistingClasses.html#//apple_ref/doc/uid/TP40011210-CH6-SW3).  
**注意：** 还可以在类扩展的顶部添加实例变量，如[类扩展扩展内部实现](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../CustomizingExistingClasses/CustomizingExistingClasses.html#//apple_ref/doc/uid/TP40011210-CH6-SW3)中所述。

### Access Instance Variables Directly from Initializer Methods  

直接从初始值设定项方法访问实例变量

Setter methods can have additional side-effects. They may trigger KVC notifications, or perform further tasks if you write your own custom methods.  
Setter 方法可能会产生额外的副作用。如果您编写自己的自定义方法，它们可能会触发 KVC 通知或执行其他任务。

You should always access the instance variables directly from within an initialization method because at the time a property is set, the rest of the object may not yet be completely initialized. Even if you don’t provide custom accessor methods or know of any side effects from within your own class, a future subclass may very well override the behavior.  
应始终直接从初始化方法中访问实例变量，因为在设置属性时，对象的其余部分可能尚未完全初始化。即使您没有提供自定义访问器方法或知道您自己的类中的任何副作用，将来的子类也很可能会覆盖该行为。

A typical `init` method looks like this:  
典型的 `init` 方法如下所示：

```objective-c
- (id)init {
    self = [super init];
    if (self) {
        // initialize instance variables here
    }
    return self;
}
```

An `init` method should assign `self` to the result of calling the superclass’s initialization method before doing its own initialization. A superclass may fail to initialize the object correctly and return `nil` so you should always check to make sure `self` is not `nil` before performing your own initialization.  
`init` 方法在执行自己的初始化之前，应将 `self` 分配给调用超类的初始化方法的结果。超类可能无法正确初始化对象并返回 `nil`，因此在执行自己的初始化之前，应始终检查以确保 `self` 不是 `nil`。

By calling `[super init]` as the first line in the method, an object is initialized from its root class down through each subclass `init` implementation in order. [Figure 3-1](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1#//apple_ref/doc/uid/TP40011210-CH5-SW12) shows the process for initializing an `XYZShoutingPerson` object.  
通过调用 `[super init]` 作为方法中的第一行，对象从其根类向下按顺序初始化到每个子类 `init` 实现。[图 3-1](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1#//apple_ref/doc/uid/TP40011210-CH5-SW12) 显示了初始化 `XYZShoutingPerson` 对象的过程。

**Figure 3-1**  The initialization process  
**图 3-1** 初始化过程

![](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../Art/initflow.png)![](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../Art/initflow.png)

As you saw in the previous chapter, an object is initialized either by calling `init`, or by calling a method that initializes the object with specific values.  
正如您在上一章中看到的，对象是通过调用 `init` 或调用使用特定值初始化对象的方法来初始化的。

In the case of the `XYZPerson` class, it would make sense to offer an initialization method that set the person’s initial first and last names:  
对于 `XYZPerson` 类，提供一种初始化方法来设置人的初始名字和姓氏是有意义的：

```objective-c
- (id)initWithFirstName:(NSString *)aFirstName lastName:(NSString *)aLastName;
```

You’d implement the method like this:  
您可以像这样实现该方法：

```objective-c
- (id)initWithFirstName:(NSString *)aFirstName lastName:(NSString *)aLastName {
    self = [super init];
    if (self) {
        _firstName = aFirstName;
        _lastName = aLastName;
    }
    return self;
}
```

#### The Designated Initializer is the Primary Initialization Method  

指定的初始值设定项是主要初始化方法

If an object declares one or more initialization methods, you should decide which method is the _designated initializer_. This is often the method that offers the most options for initialization (such as the method with the most arguments), and is called by other methods you write for convenience. You should also typically override `init` to call your designated initializer with suitable default values.  
如果对象声明了一个或多个初始化方法，则应确定哪个方法是_指定的初始值设定项_。这通常是提供最多初始化选项的方法（例如具有最多参数的方法），并且为方便起见，由您编写的其他方法调用。通常还应重写 `init`，以使用合适的默认值调用指定的初始值设定项。

If an `XYZPerson` also had a property for a date of birth, the designated initializer might be:  
如果 `XYZPerson` 还具有出生日期的属性，则指定的初始值设定项可能是：

```objective-c
- (id)initWithFirstName:(NSString *)aFirstName lastName:(NSString *)aLastName dateOfBirth:(NSDate *)aDOB;
```

This method would set the relevant instance variables, as shown above. If you still wished to provide a convenience initializer for just first and last names, you would implement the method to call the designated initializer, like this:  
此方法将设置相关的实例变量，如上所示。如果您仍然希望仅为名字和姓氏提供方便的初始值设定项，则可以实现调用指定初始值设定项的方法，如下所示：

```objective-c
- (id)initWithFirstName:(NSString *)aFirstName lastName:(NSString *)aLastName {
    return [self initWithFirstName:aFirstName lastName:aLastName dateOfBirth:nil];
}
```

You might also implement a standard `init` method to provide suitable defaults:  
还可以实现标准的 `init` 方法来提供合适的默认值：

```objective-c
- (id)init {
    return [self initWithFirstName:@"John" lastName:@"Doe" dateOfBirth:nil];
}
```

If you need to write an initialization method when subclassing a class that uses multiple `init` methods, you should either override the superclass’s designated initializer to perform your own initialization, or add your own additional initializer. Either way, you should call the superclass’s designated initializer (in place of `[super init];`) before doing any of your own initialization.  
如果在对使用多个 `init` 方法的类进行子类化时需要编写初始化方法，则应重写超类的指定初始值设定项以执行自己的初始化，或者添加自己的附加初始值设定项。无论哪种方式，您都应该在执行任何自己的初始化之前调用超类的指定初始值设定项（代替 `[super init];`）。

### You Can Implement Custom Accessor Methods  

您可以实现自定义访问器方法

Properties don’t always have to be backed by their own instance variables.  
属性并不总是必须由其自己的实例变量提供支持。

As an example, the `XYZPerson` class might define a read-only property for a person’s full name:  
例如，`XYZPerson` 类可能为一个人的全名定义一个只读属性：

```objective-c
@property (readonly) NSString *fullName;
```

Rather than having to update the `fullName` property every time the first or last name changed, it would be easier just to write a custom accessor method to build the full name string on request:  
不必在每次更改名字或姓氏时都更新 `fullName` 属性，只需编写一个自定义访问器方法来根据请求生成全名字符串会更容易：

```objective-c
- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}
```


If you need to write a custom accessor method for a property that does use an instance variable, you must access that instance variable directly from within the method. For example, it’s common to delay the initialization of a property until it’s first requested, using a “lazy accessor,” like this:  
如果需要为使用实例变量的属性编写自定义访问器方法，则必须直接从该方法中访问该实例变量。例如，通常使用“惰性访问器”将属性的初始化延迟到首次请求，如下所示：

```objective-c
- (XYZObject *)someImportantObject {
    if (!_someImportantObject) {
        _someImportantObject = [[XYZObject alloc] init];
    }
    return _someImportantObject;
}
```

Before returning the value, this method first checks whether the `_someImportantObject` instance variable is `nil`; if it is, it allocates an object.  
在返回值之前，该方法首先检查`_someImportantObject`实例变量是否为 `nil`;如果是，则分配一个对象。

**Note:** The compiler will automatically synthesize an instance variable in all situations where it’s also synthesizing at least one accessor method. If you implement both a getter and a setter for a `readwrite` property, or a getter for a `readonly` property, the compiler will assume that you are taking control over the property implementation and won’t synthesize an instance variable automatically.  
**注意：**编译器将在同时合成至少一个访问器方法的所有情况下自动合成实例变量。如果同时实现 `readwrite` 属性的 getter 和 setter，或者为 `readonly` 属性实现 getter，则编译器将假定你正在控制属性实现，并且不会自动合成实例变量。

If you still need an instance variable, you’ll need to request that one be synthesized:  
如果仍需要实例变量，则需要请求合成一个实例变量：

```objective-c
@synthesize property = _property;
```

### Properties Are Atomic by Default  

默认情况下，属性是原子的

By default, an Objective-C property is _atomic_:  
默认情况下，Objective-C 属性是_原子_的：

```objective-c
@interface XYZObject : NSObject
@property NSObject *implicitAtomicObject;          // atomic by default
@property (atomic) NSObject *explicitAtomicObject; // explicitly marked atomic
@end
```

This means that the synthesized accessors ensure that a value is always fully retrieved by the getter method or fully set via the setter method, even if the accessors are called simultaneously from different threads.  
这意味着，合成的访问器可确保始终通过 getter 方法完全检索值或通过 setter 方法完全设置值，即使访问器是从不同的线程同时调用的。

Because the internal implementation and synchronization of atomic accessor methods is private, it’s not possible to combine a synthesized accessor with an accessor method that you implement yourself. You’ll get a compiler warning if you try, for example, to provide a custom setter for an `atomic`, `readwrite` property but leave the compiler to synthesize the getter.  
由于原子访问器方法的内部实现和同步是私有的，因此无法将合成的访问器与你自己实现的访问器方法组合在一起。例如，如果您尝试为`atomic``readwrite`属性提供自定义 setter，但让编译器合成 getter，则会收到编译器警告。

You can use the `nonatomic` property attribute to specify that synthesized accessors simply set or return a value directly, with no guarantees about what happens if that same value is accessed simultaneously from different threads. For this reason, it’s faster to access a `nonatomic` property than an `atomic` one, and it’s fine to combine a synthesized setter, for example, with your own getter implementation:  
可以使用`nonatomic`属性属性来指定合成访问器只需直接设置或返回一个值，而不能保证如果从不同的线程同时访问相同的值会发生什么情况。出于这个原因，访问`nonatomic`属性比访问`atomic`属性更快，并且可以将合成的 setter 组合在一起，例如，与您自己的 getter 实现相结合：

```objective-c
@interface XYZObject : NSObject
    @property (nonatomic) NSObject *nonatomicObject;
@end

@implementation XYZObject
- (NSObject *)nonatomicObject {
    return _nonatomicObject;
}
// setter will be synthesized automatically
@end

```

**Note:** Property atomicity is not synonymous with an object’s _thread safety_.  
**注意：**属性原子性并不等同于对象的_线程安全_。


This example is quite simple, but the problem of thread safety becomes much more complex when considered across a network of related objects. Thread safety is covered in more detail in _[Concurrency Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../../../../General/Conceptual/ConcurrencyProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008091)_.  
这个例子非常简单，但是当跨相关对象网络考虑时，线程安全问题变得更加复杂。线程安全在_[并发编程指南](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../../../../General/Conceptual/ConcurrencyProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008091)_中有更详细的介绍。

## Manage the Object Graph through Ownership and Responsibility  

通过所有权和责任管理对象图

When one object relies on other objects in this way, effectively taking ownership of those other objects, the first object is said to have _strong references_ to the other objects. In Objective-C, an object is kept alive as long as it has at least one strong reference to it from another object. The relationships between the `XYZPerson` instance and the two `NSString` objects is shown in [Figure 3-2](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1#//apple_ref/doc/uid/TP40011210-CH5-SW14).  
当一个对象以这种方式依赖其他对象，有效地获得这些其他对象的所有权时，第一个对象被称为对其他对象具有_很强的引用_。在 Objective-C 中，只要一个对象至少有一个来自另一个对象的强引用，它就会保持活动状态。`XYZPerson` 实例和两个 `NSString` 对象之间的关系如[图 3-2](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1#//apple_ref/doc/uid/TP40011210-CH5-SW14) 所示。

By default, both Objective-C properties and variables maintain strong references to their objects. This is fine for many situations, but it does cause a potential problem with strong reference cycles.  
默认情况下，Objective-C 属性和变量都保持对其对象的强引用。这在许多情况下都很好，但它确实会导致强参考周期的潜在问题。

### Avoid Strong Reference Cycles  

避免强参考周期

Although strong references work well for one-way relationships between objects, you need to be careful when working with groups of interconnected objects. If a group of objects is connected by a circle of strong relationships, they keep each other alive even if there are no strong references from outside the group.  
尽管强引用适用于对象之间的单向关系，但在处理相互关联的对象组时需要小心。如果一组对象通过一个强关系的圈子连接起来，即使没有来自组外的强引用，它们也会保持彼此的活力。

One obvious example of a potential reference cycle exists between a table view object (`UITableView` for iOS and `NSTableView` for OS X) and its delegate. In order for a generic table view class to be useful in multiple situations, it delegates some decisions to external objects. This means it relies on another object to decide what content it displays, or what to do if the user interacts with a specific entry in the table view.  
表视图对象（适用于 iOS 的 `UITableView` 和适用于 OS X 的 `NSTableView`）与其委托之间存在潜在引用周期的一个明显示例。为了使泛型表视图类在多种情况下有用，它将一些决策委托给外部对象。这意味着它依赖于另一个对象来决定它显示的内容，或者如果用户与表视图中的特定条目交互时要执行的操作。

A common scenario is that the table view has a reference to its delegate and the delegate has a reference back to the table view, as shown in [Figure 3-7](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1#//apple_ref/doc/uid/TP40011210-CH5-SW25).  
一种常见的情况是，表视图具有对其委托的引用，而委托具有对表视图的引用，如[图 3-7](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1#//apple_ref/doc/uid/TP40011210-CH5-SW25) 所示。

**Figure 3-7**  Strong references between a table view and its delegate  
**图 3-7** 表视图与其委托之间的强引用

![](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../Art/strongreferencecycle1.png)

A problem occurs if the other objects give up their strong relationships to the table view and delegate, as shown in [Figure 3-8](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1#//apple_ref/doc/uid/TP40011210-CH5-SW26).  
如果其他对象放弃了与表视图和委托的强关系，则会出现问题，如[图 3-8](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1#//apple_ref/doc/uid/TP40011210-CH5-SW26) 所示。

**Figure 3-8**  A strong reference cycle  
**图 3-8** 强大的参考周期

![](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../Art/strongreferencecycle2.png)

Even though there is no need for the objects to be kept in memory—there are no strong relationships to the table view or delegate other than the relationships between the two objects—the two remaining strong relationships keep the two objects alive. This is known as a _strong reference cycle_.  
即使不需要将对象保留在内存中（除了两个对象之间的关系之外，与表视图或委托没有强关系），但剩下的两个强关系会使两个对象保持活动状态。这被称为_强参考周期_。

The way to solve this problem is to substitute one of the strong references for a _weak reference_. A weak reference does not imply ownership or responsibility between two objects, and does not keep an object alive.  
解决此问题的方法是用强引用之一代替_弱引用_。弱引用并不意味着两个对象之间的所有权或责任，也不会使对象保持活动状态。

If the table view is modified to use a weak relationship to its delegate (which is how `UITableView` and `NSTableView` solve this problem), the initial object graph now looks like [Figure 3-9](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1#//apple_ref/doc/uid/TP40011210-CH5-SW27).  
如果将表视图修改为使用与其委托的弱关系（`UITableView` 和 `NSTableView` 解决此问题的方式），则初始对象图现在如[图 3-9](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1#//apple_ref/doc/uid/TP40011210-CH5-SW27) 所示。

**Figure 3-9**  The correct relationship between a table view and its delegate  
**图 3-9** 表视图与其委托之间的正确关系

![](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../Art/strongreferencecycle3.png)

When the other objects in the graph give up their strong relationships to the table view and delegate this time, there are no strong references left to the delegate object, as shown in [Figure 3-10](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1#//apple_ref/doc/uid/TP40011210-CH5-SW28).  
当图中的其他对象放弃其与表视图的强关系并委托时，没有对委托对象留下强引用，如[图 3-10](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1#//apple_ref/doc/uid/TP40011210-CH5-SW28) 所示。

**Figure 3-10**  Avoiding a strong reference cycle  
**图 3-10** 避免强参考周期

![](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../Art/strongreferencecycle4.png)

This means that the delegate object will be deallocated, thereby releasing the strong reference on the table view, as shown in [Figure 3-11](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1#//apple_ref/doc/uid/TP40011210-CH5-SW29).  
这意味着委托对象将被解除分配，从而在表视图上释放强引用，如[图 3-11](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1#//apple_ref/doc/uid/TP40011210-CH5-SW29) 所示。

**Figure 3-11**  Deallocating the delegate  
**图 3-11** 解除分配委托

![](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../Art/strongreferencecycle5.png)

Once the delegate is deallocated, there are no longer any strong references to the table view, so it too is deallocated.  
解除分配委托后，不再有任何对表视图的强引用，因此它也会被释放。

### Use Strong and Weak Declarations to Manage Ownership  

使用强声明和弱声明管理所有权

By default, object properties declared like this:  
默认情况下，对象属性声明如下：

<table><tbody><tr><td scope="row"><pre>@property id delegate;<span></span></pre></td></tr></tbody></table>

use strong references for their synthesized instance variables. To declare a weak reference, add an attribute to the property, like this:  
对其合成的实例变量使用强引用。若要声明弱引用，请向属性添加一个属性，如下所示：

<table><tbody><tr><td scope="row"><pre>@property (weak) id delegate;<span></span></pre></td></tr></tbody></table>

**Note:** The opposite to `weak` is `strong`. There’s no need to specify the `strong` attribute explicitly, because it is the default.  
**注意：**`weak`的反义词是`strong`的。无需显式指定`strong`属性，因为它是默认值。

Local variables (and non-property instance variables) also maintain strong references to objects by default. This means that the following code will work exactly as you expect:  
默认情况下，局部变量（和非属性实例变量）也保持对对象的强引用。这意味着以下代码将完全按照您的预期工作：

<table><tbody><tr><td scope="row"><pre>    NSDate *originalDate = self.lastModificationDate;<span></span></pre></td></tr><tr><td scope="row"><pre>    self.lastModificationDate = [NSDate date];<span></span></pre></td></tr><tr><td scope="row"><pre>    NSLog(@"Last modification date changed from %@ to %@",<span></span></pre></td></tr><tr><td scope="row"><pre>                        originalDate, self.lastModificationDate);<span></span></pre></td></tr></tbody></table>

In this example, the local variable `originalDate` maintains a strong reference to the initial `lastModificationDate` object. When the `lastModificationDate` property is changed, the property no longer keeps a strong reference to the original date, but that date is still kept alive by the `originalDate` strong variable.  
在此示例中，局部变量 `originalDate` 维护对初始 `lastModificationDate` 对象的强引用。当 `lastModificationDate` 属性发生更改时，该属性将不再保留对原始日期的强引用，但该日期仍由 `originalDate` 强变量保持活动状态。

**Note:** A variable maintains a strong reference to an object only as long as that variable is in scope, or until it is reassigned to another object or `nil`.  
**注意：**只有当某个对象在作用域中时，或者直到它被重新分配给另一个对象或 `nil`，变量才会保持对该对象的强引用。

If you don’t want a variable to maintain a strong reference, you can declare it as `__weak`, like this:  
如果不希望变量保持强引用，可以将其声明为`__weak`，如下所示：

<table><tbody><tr><td scope="row"><pre>    NSObject * __weak weakVariable;<span></span></pre></td></tr></tbody></table>

Because a weak reference doesn’t keep an object alive, it’s possible for the referenced object to be deallocated while the reference is still in use. To avoid a dangerous dangling pointer to the memory originally occupied by the now deallocated object, a weak reference is automatically set to `nil` when its object is deallocated.  
由于弱引用不会使对象保持活动状态，因此当引用仍在使用时，可能会解除分配引用的对象。为了避免指向现在已解除分配的对象最初占用的内存的危险悬空指针，当弱引用的对象被解除分配时，弱引用会自动设置为 `nil`。

This means that if you use a weak variable in the previous date example:  
这意味着，如果在上一个日期示例中使用弱变量：

<table><tbody><tr><td scope="row"><pre>    NSDate * __weak originalDate = self.lastModificationDate;<span></span></pre></td></tr><tr><td scope="row"><pre>    self.lastModificationDate = [NSDate date];<span></span></pre></td></tr></tbody></table>

the `originalDate` variable may potentially be set to `nil`. When `self.lastModificationDate` is reassigned, the property no longer maintains a strong reference to the original date. If there are no other strong references to it, the original date will be deallocated and `originalDate` set to `nil`.  
`originalDate` 变量可能设置为 `nil`。重新分配 `self.lastModificationDate` 时，该属性将不再保持对原始日期的强引用。如果没有其他强引用，则将取消分配原始日期，并将 `originalDate` 设置为 `nil`。

Weak variables can be a source of confusion, particularly in code like this:  
弱变量可能会造成混淆，尤其是在这样的代码中：

<table><tbody><tr><td scope="row"><pre>    NSObject * __weak someObject = [[NSObject alloc] init];<span></span></pre></td></tr></tbody></table>

In this example, the newly allocated object has no strong references to it, so it is immediately deallocated and `someObject` is set to `nil`.  
在此示例中，新分配的对象没有对它的强引用，因此会立即解除分配该对象，并将 `someObject` 设置为 `nil`。

**Note:** The opposite to `__weak` is `__strong`. Again, you don’t need to specify `__strong` explicitly, because it is the default.  
**注意：**与`__weak`相反的是`__strong`。同样，您不需要显式指定`__strong`，因为它是默认值。

It’s also important to consider the implications of a method that needs to access a weak property several times, like this:  
同样重要的是要考虑需要多次访问弱属性的方法的含义，如下所示：

<table><tbody><tr><td scope="row"><pre>- (void)someMethod {<span></span></pre></td></tr><tr><td scope="row"><pre>    [self.weakProperty doSomething];<span></span></pre></td></tr><tr><td scope="row"><pre>    ...<span></span></pre></td></tr><tr><td scope="row"><pre>    [self.weakProperty doSomethingElse];<span></span></pre></td></tr><tr><td scope="row"><pre>}<span></span></pre></td></tr></tbody></table>

In situations like this, you might want to cache the weak property in a strong variable to ensure that it is kept in memory as long as you need to use it:  
在这种情况下，您可能希望将 weak 属性缓存在强变量中，以确保只要您需要使用它，它就会保留在内存中：

<table><tbody><tr><td scope="row"><pre>- (void)someMethod {<span></span></pre></td></tr><tr><td scope="row"><pre>    NSObject *cachedObject = self.weakProperty;<span></span></pre></td></tr><tr><td scope="row"><pre>    [cachedObject doSomething];<span></span></pre></td></tr><tr><td scope="row"><pre>    ...<span></span></pre></td></tr><tr><td scope="row"><pre>    [cachedObject doSomethingElse];<span></span></pre></td></tr><tr><td scope="row"><pre>}<span></span></pre></td></tr></tbody></table>

In this example, the `cachedObject` variable maintains a strong reference to the original weak property value so that it can’t be deallocated as long as `cachedObject` is still in scope (and hasn’t been reassigned another value).  
在此示例中，`cachedObject` 变量维护对原始弱属性值的强引用，以便只要 `cachedObject` 仍在范围内（并且尚未重新分配其他值），就无法解除分配该值。

It’s particularly important to keep this in mind if you need to make sure a weak property is not `nil` before using it. It’s not enough just to test it, like this:  
如果您需要在使用弱属性之前确保它不是零，那么记住这一点尤为`nil`。仅仅测试是不够的，就像这样：

<table><tbody><tr><td scope="row"><pre>    if (self.someWeakProperty) {<span></span></pre></td></tr><tr><td scope="row"><pre>        [someObject doSomethingImportantWith:self.someWeakProperty];<span></span></pre></td></tr><tr><td scope="row"><pre>    }<span></span></pre></td></tr></tbody></table>

because in a multi-threaded application, the property may be deallocated between the test and the method call, rendering the test useless. Instead, you need to declare a strong local variable to cache the value, like this:  
因为在多线程应用程序中，该属性可能会在 test 和方法调用之间解除分配，从而使测试变得无用。相反，您需要声明一个强局部变量来缓存该值，如下所示：

<table><tbody><tr><td scope="row"><pre>    NSObject *cachedObject = self.someWeakProperty;           // 1<span></span></pre></td></tr><tr><td scope="row"><pre>    if (cachedObject) {                                       // 2<span></span></pre></td></tr><tr><td scope="row"><pre>        [someObject doSomethingImportantWith:cachedObject];   // 3<span></span></pre></td></tr><tr><td scope="row"><pre>    }                                                         // 4<span></span></pre></td></tr><tr><td scope="row"><pre>    cachedObject = nil;                                       // 5<span></span></pre></td></tr></tbody></table>

In this example, the strong reference is created in line 1, meaning that the object is guaranteed to be alive for the test and method call. In line 5, `cachedObject` is set to `nil`, thereby giving up the strong reference. If the original object has no other strong references to it at this point, it will be deallocated and `someWeakProperty` will be set to `nil`.  
在此示例中，在第 1 行中创建了强引用，这意味着保证对象对于测试和方法调用处于活动状态。在第 5 行中，`cachedObject` 设置为 `nil`，从而放弃强引用。如果此时原始对象没有其他强引用，则将解除分配，并且 `someWeakProperty` 将设置为 `nil`。

### Use Unsafe Unretained References for Some Classes  

对某些类使用不安全的未保留引用

There are a few classes in Cocoa and Cocoa Touch that don’t yet support weak references, which means you can’t declare a weak property or weak local variable to keep track of them. These classes include `NSTextView`, `NSFont` and `NSColorSpace`; for the full list, see _[Transitioning to ARC Release Notes](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../../../../../releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html#//apple_ref/doc/uid/TP40011226)_.  
Cocoa 和 Cocoa Touch 中有一些类尚不支持弱引用，这意味着您无法声明弱属性或弱局部变量来跟踪它们。这些类包括 `NSTextView`、`NSFont` 和 `NSColorSpace`;有关完整列表，请参阅_[过渡到 ARC 发行说明](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../../../../../releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html#//apple_ref/doc/uid/TP40011226)_。

If you need to use a weak reference to one of these classes, you must use an unsafe reference. For a property, this means using the `unsafe_unretained` attribute:  
如果需要使用对其中一个类的弱引用，则必须使用不安全的引用。对于属性，这意味着使用 `unsafe_unretained` 属性：

<table><tbody><tr><td scope="row"><pre>@property (unsafe_unretained) NSObject *unsafeProperty;<span></span></pre></td></tr></tbody></table>

For variables, you need to use `__unsafe_unretained`:  
对于变量，您需要使用`__unsafe_unretained`：

<table><tbody><tr><td scope="row"><pre>    NSObject * __unsafe_unretained unsafeReference;<span></span></pre></td></tr></tbody></table>

An unsafe reference is similar to a weak reference in that it doesn’t keep its related object alive, but it won’t be set to `nil` if the destination object is deallocated. This means that you’ll be left with a dangling pointer to the memory originally occupied by the now deallocated object, hence the term “unsafe.” Sending a message to a dangling pointer will result in a crash.  
不安全引用类似于弱引用，因为它不会使其相关对象保持活动状态，但如果目标对象已解除分配，则不会将其设置为 `nil`。这意味着您将留下一个悬空的指针，指向最初由现在已解除分配的对象占用的内存，因此称为“不安全”。向悬空指针发送消息将导致崩溃。

### Copy Properties Maintain Their Own Copies  

复制属性维护自己的副本

In some circumstances, an object may wish to keep its own copy of any objects that are set for its properties.  
在某些情况下，对象可能希望保留为其属性设置的任何对象的自己的副本。

As an example, the class interface for the `XYZBadgeView` class shown earlier in [Figure 3-4](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1#//apple_ref/doc/uid/TP40011210-CH5-SW19) might look like this:  
例如，前面图 [3-4](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1#//apple_ref/doc/uid/TP40011210-CH5-SW19) 中所示的 `XYZBadgeView` 类的类接口可能如下所示：

<table><tbody><tr><td scope="row"><pre>@interface XYZBadgeView : NSView<span></span></pre></td></tr><tr><td scope="row"><pre>@property NSString *firstName;<span></span></pre></td></tr><tr><td scope="row"><pre>@property NSString *lastName;<span></span></pre></td></tr><tr><td scope="row"><pre>@end<span></span></pre></td></tr></tbody></table>

Two `NSString` properties are declared, which both maintain implicit strong references to their objects.  
声明了两个 `NSString` 属性，这两个属性都保持对其对象的隐式强引用。

Consider what happens if another object creates a string to set as one of the badge view’s properties, like this:  
考虑如果另一个对象创建一个字符串以设置为锁屏提醒视图的属性之一，会发生什么情况，如下所示：

<table><tbody><tr><td scope="row"><pre>    NSMutableString *nameString = [NSMutableString stringWithString:@"John"];<span></span></pre></td></tr><tr><td scope="row"><pre>    self.badgeView.firstName = nameString;<span></span></pre></td></tr></tbody></table>

This is perfectly valid, because `NSMutableString` is a subclass of `NSString`. Although the badge view thinks it’s dealing with an `NSString` instance, it’s actually dealing with an `NSMutableString`.  
这是完全有效的，因为 `NSMutableString` 是 `NSString` 的子类。尽管锁屏提醒视图认为它正在处理 `NSString` 实例，但它实际上正在处理 `NSMutableString`。

This means that the string can change:  
这意味着字符串可以更改：

<table><tbody><tr><td scope="row"><pre>    [nameString appendString:@"ny"];<span></span></pre></td></tr></tbody></table>

In this case, although the name was “John” at the time it was originally set for the badge view’s `firstName` property, it’s now “Johnny” because the mutable string was changed.  
在本例中，尽管在最初为锁屏提醒视图的 `firstName` 属性设置名称时名称为“John”，但现在名称为“Johnny”，因为可变字符串已更改。

You might choose that the badge view should maintain its own copies of any strings set for its `firstName` and `lastName` properties, so that it effectively captures the strings at the time that the properties are set. By adding a `copy` attribute to the two property declarations:  
您可以选择锁屏提醒视图应保留为其 `firstName` 和 `lastName` 属性设置的任何字符串的自己的副本，以便在设置属性时有效地捕获字符串。通过向两个属性声明添加 `copy` 属性：

<table><tbody><tr><td scope="row"><pre>@interface XYZBadgeView : NSView<span></span></pre></td></tr><tr><td scope="row"><pre>@property (copy) NSString *firstName;<span></span></pre></td></tr><tr><td scope="row"><pre>@property (copy) NSString *lastName;<span></span></pre></td></tr><tr><td scope="row"><pre>@end<span></span></pre></td></tr></tbody></table>

the view now maintains its own copies of the two strings. Even if a mutable string is set and subsequently changed, the badge view captures whatever value it has at the time it is set. For example:  
视图现在维护其自己的两个字符串的副本。即使设置了可变字符串并随后进行了更改，锁屏提醒视图也会捕获它在设置时具有的任何值。例如：

<table><tbody><tr><td scope="row"><pre>    NSMutableString *nameString = [NSMutableString stringWithString:@"John"];<span></span></pre></td></tr><tr><td scope="row"><pre>    self.badgeView.firstName = nameString;<span></span></pre></td></tr><tr><td scope="row"><pre>    [nameString appendString:@"ny"];<span></span></pre></td></tr></tbody></table>

This time, the `firstName` held by the badge view will be an unaffected copy of the original “John” string.  
这一次，锁屏提醒视图持有的 `firstName` 将是原始“John”字符串的不受影响的副本。

The `copy` attribute means that the property will use a strong reference, because it must hold on to the new object it creates.  
`copy` 属性意味着该属性将使用强引用，因为它必须保留它创建的新对象。

**Note:** Any object that you wish to set for a `copy` property must support `NSCopying`, which means that it should conform to the `NSCopying` protocol.  
**注意：**要为 `copy` 属性设置的任何对象都必须支持 `NSCopying`，这意味着它应符合 `NSCopying` 协议。

Protocols are described in [Protocols Define Messaging Contracts](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../WorkingwithProtocols/WorkingwithProtocols.html#//apple_ref/doc/uid/TP40011210-CH11-SW2). For more information on `NSCopying`, see `[NSCopying](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../../../../LegacyTechnologies/WebObjects/WebObjects_3.5/Reference/Frameworks/ObjC/Foundation/Protocols/NSCopying/Description.html#//apple_ref/occ/intf/NSCopying)` or the _[Advanced Memory Management Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../../MemoryMgmt/Articles/MemoryMgmt.html#//apple_ref/doc/uid/10000011i)_.  
协议[定义消息传递协定](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../WorkingwithProtocols/WorkingwithProtocols.html#//apple_ref/doc/uid/TP40011210-CH11-SW2)中介绍了协议。有关 `NSCopying` 的详细信息，请参阅 `[NSCopying](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../../../../LegacyTechnologies/WebObjects/WebObjects_3.5/Reference/Frameworks/ObjC/Foundation/Protocols/NSCopying/Description.html#//apple_ref/occ/intf/NSCopying)` 或_[高级内存管理编程指南](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../../MemoryMgmt/Articles/MemoryMgmt.html#//apple_ref/doc/uid/10000011i)_。

If you need to set a `copy` property’s instance variable directly, for example in an initializer method, don’t forget to set a copy of the original object:  
如果需要直接设置`copy`属性的实例变量，例如在初始值设定项方法中，请不要忘记设置原始对象的副本：

<table><tbody><tr><td scope="row"><pre>- (id)initWithSomeOriginalString:(NSString *)aString {<span></span></pre></td></tr><tr><td scope="row"><pre>    self = [super init];<span></span></pre></td></tr><tr><td scope="row"><pre>    if (self) {<span></span></pre></td></tr><tr><td scope="row"><pre>        _instanceVariableForCopyProperty = [aString copy];<span></span></pre></td></tr><tr><td scope="row"><pre>    }<span></span></pre></td></tr><tr><td scope="row"><pre>    return self;<span></span></pre></td></tr><tr><td scope="row"><pre>}<span></span></pre></td></tr></tbody></table>

## Exercises习题

1. Modify the `sayHello` method from the `XYZPerson` class to log a greeting using the person’s first name and last name.

    修改 `XYZPerson` 类中的 `sayHello` 方法，以使用此人的名字和姓氏记录问候语。
2. Declare and implement a new designated initializer used to create an `XYZPerson` using a specified first name, last name and date of birth, along with a suitable class factory method.

    声明并实现一个新的指定初始值设定项，用于使用指定的名字、姓氏和出生日期以及合适的类工厂方法创建 `XYZPerson`。

    Don’t forget to override `init` to call the designated initializer.

    不要忘记重写 `init` 以调用指定的初始值设定项。
3. Test what happens if you set a mutable string as the person’s first name, then mutate that string before calling your modified `sayHello` method. Change the `NSString` property declarations by adding the `copy` attribute and test again.

    测试如果将可变字符串设置为人员的名字，然后在调用修改后的 `sayHello` 方法之前更改该字符串，会发生什么情况。通过添加 `copy` 属性来更改 `NSString` 属性声明，然后再次测试。
4. Try creating `XYZPerson` objects using a variety of strong and weak variables in the `main()` function. Verify that the strong variables keep the `XYZPerson` objects alive at least as long as you expect.

    尝试在 `main()` 函数中使用各种强变量和弱变量创建 `XYZPerson` 对象。验证强变量是否至少使 `XYZPerson` 对象保持活动时间与预期一样长。

    In order to help verify when an `XYZPerson` object is deallocated, you might want to tie into the object lifecycle by providing a `dealloc` method in the `XYZPerson` implementation. This method is called automatically when an Objective-C object is deallocated from memory, and is normally used to release any memory you allocated manually, such as through the C `malloc()` function, as described in _[Advanced Memory Management Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../../MemoryMgmt/Articles/MemoryMgmt.html#//apple_ref/doc/uid/10000011i)_.

    为了帮助验证何时解除分配 `XYZPerson` 对象，您可能希望通过在 `XYZPerson` 实现中提供 `dealloc` 方法来绑定对象生命周期。当 Objective-C 对象从内存中解除分配时，会自动调用此方法，并且通常用于释放手动分配的任何内存，例如通过 C `malloc()` 函数，如_[高级内存管理编程指南](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../../MemoryMgmt/Articles/MemoryMgmt.html#//apple_ref/doc/uid/10000011i)_中所述。

    For the purposes of this exercise, override the `dealloc` method in `XYZPerson` to log a message, like this:

    在本练习中，重写 `XYZPerson` 中的 `dealloc` 方法以记录消息，如下所示：

    <table><tbody><tr><td scope="row"><pre>- (void)dealloc {<span></span></pre></td></tr><tr><td scope="row"><pre>    NSLog(@"XYZPerson is being deallocated");<span></span></pre></td></tr><tr><td scope="row"><pre>}<span></span></pre></td></tr></tbody></table>

    Try setting each `XYZPerson` pointer variable to `nil` to verify that the objects are deallocated when you expect them to be.

    尝试将每个 `XYZPerson` 指针变量设置为 `nil`，以验证对象是否在预期时解除分配。

    **Note:** The Xcode project template for a Command Line Tool use an `@autoreleasepool { }` block inside the `main()` function. In order to use the Automatic Retain Count feature of the compiler to handle memory management for you, it’s important that any code you write in `main()` goes inside this autorelease pool block.  
    **注意：**命令行工具的 Xcode 项目模板在 `main()` 函数中使用 `@autoreleasepool { }` 块。为了使用编译器的自动保留计数功能来为您处理内存管理，您在 `main()` 中编写的任何代码都必须进入此自动释放池块。

    Autorelease pools are outside the scope of this document, but are covered in detail in _[Advanced Memory Management Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../../MemoryMgmt/Articles/MemoryMgmt.html#//apple_ref/doc/uid/10000011i)_.  
    自动释放池不在本文档的讨论范围之内，但在_[《高级内存管理编程指南](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW1../../MemoryMgmt/Articles/MemoryMgmt.html#//apple_ref/doc/uid/10000011i)_》中有详细介绍。

    When you’re writing a Cocoa or Cocoa Touch application rather than a command line tool, you won’t usually need to worry about creating your own autorelease pools, because you’re tying into a framework of objects that will ensure one is already in place.  
    当您编写 Cocoa 或 Cocoa Touch 应用程序而不是命令行工具时，您通常不需要担心创建自己的自动发布池，因为您正在绑定到一个对象框架中，该框架将确保一个已经到位。

5. Modify the `XYZPerson` class description so that you can keep track of a spouse or partner.

    修改 `XYZPerson` 类说明，以便您可以跟踪配偶或伴侣。

    You’ll need to decide how best to model the relationship, thinking carefully about object graph management.  
    您需要决定如何最好地对这种关系进行建模，并仔细考虑对象图管理。
