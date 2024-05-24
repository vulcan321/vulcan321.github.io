# Defining Classes

## Classes Are Blueprints for Objects  

### Mutability Determines Whether a Represented Value Can Be Changed  

Some classes define objects that are _immutable_. This means that the internal contents must be set when an object is created, and cannot subsequently be changed by other objects. In Objective-C, all basic `NSString` and `NSNumber` objects are immutable. If you need to represent a different number, you must use a new `NSNumber` instance.  
某些类定义_不可变_的对象。这意味着必须在创建对象时设置内部内容，并且随后不能由其他对象更改。在 Objective-C 中，所有基本的 `NSString` 和 `NSNumber` 对象都是不可变的。如果需要表示不同的数字，则必须使用新的 `NSNumber` 实例。

Some immutable classes also offer a _mutable_ version. If you specifically need to change the contents of a string at runtime, for example by appending characters as they are received over a network connection, you can use an instance of the `NSMutableString` class. Instances of this class behave just like `NSString` objects, except that they also offer functionality to change the characters that the object represents.  
一些不可变类也提供_可变_版本。如果特别需要在运行时更改字符串的内容，例如，在通过网络连接接收字符时追加字符，则可以使用 `NSMutableString` 类的实例。此类的实例的行为与 `NSString` 对象类似，只是它们还提供更改对象所表示的字符的功能。

Although `NSString` and `NSMutableString` are different classes, they have many similarities. Rather than writing two completely separate classes from scratch that just happen to have some similar behavior, it makes sense to make use of inheritance.  
尽管 `NSString` 和 `NSMutableString` 是不同的类，但它们有许多相似之处。与其从头开始编写两个完全独立的类，它们恰好具有一些相似的行为，不如使用继承是有意义的。

### The Root Class Provides Base Functionality  

When an Objective-C object needs to work with an instance of another class, it is expected that the other class offers certain basic characteristics and behavior. For this reason, Objective-C defines a root class from which the vast majority of other classes inherit, called `NSObject`. When one object encounters another object, it expects to be able to interact using at least the basic behavior defined by the `NSObject` class description.  
当 Objective-C 对象需要使用另一个类的实例时，预计另一个类提供某些基本特征和行为。出于这个原因，Objective-C 定义了一个根类，绝大多数其他类都从该根类继承，称为 `NSObject`。当一个对象遇到另一个对象时，它希望至少能够使用 `NSObject` 类描述定义的基本行为进行交互。

## The Interface for a Class Defines Expected Interactions  

One of the many benefits of object-oriented programming is the idea mentioned earlier—all you need to know in order to use a class is how to interact with its instances. More specifically, an object should be designed to hide the details of its internal implementation.  
面向对象编程的众多好处之一就是前面提到的思想——为了使用一个类，你需要知道的就是如何与它的实例进行交互。更具体地说，对象应该被设计为隐藏其内部实现的细节。

### Basic Syntax基本语法

The Objective-C syntax used to declare a class interface looks like this:  
用于声明类接口的 Objective-C 语法如下所示：

```objc
@interface SimpleClass : NSObject
 
@end
```

This example declares a class named `SimpleClass`, which inherits from `NSObject`.  
此示例声明一个名为 `SimpleClass` 的类，该类继承自 `NSObject`。

The public properties and behavior are defined inside the `@interface` declaration. In this example, nothing is specified beyond the superclass, so the only functionality expected to be available on instances of `SimpleClass` is the functionality inherited from `NSObject`.  
公共属性和行为在 `@interface` 声明中定义。在此示例中，除了超类之外，未指定任何内容，因此 `SimpleClass` 实例上唯一可用的功能是从 `NSObject` 继承的功能。

### Properties Control Access to an Object’s Values  

Objects often have properties intended for public access. If you define a class to represent a human being in a record-keeping app, for example, you might decide you need properties for strings representing a person’s first and last names.  
对象通常具有用于公共访问的属性。例如，如果在记录保存应用中定义一个类来表示一个人，你可能会决定需要表示一个人的名字和姓氏的字符串的属性。

Declarations for these properties should be added inside the interface, like this:  
这些属性的声明应添加到接口中，如下所示：

```objc
@interface SimpleClass : NSObject

@property NSString *firstName;
@property NSString *lastName;

@property NSNumber *yearOfBirth;
@property int yearOfBirth;
@end
```
In this example, the `Person` class declares two public properties, both of which are instances of the `NSString` class.  
在此示例中，`Person` 类声明了两个公共属性，这两个属性都是 `NSString` 类的实例。

Both these properties are for Objective-C objects, so they use an _asterisk_ to indicate that they are C pointers. They are also statements just like any other variable declaration in C, and therefore require a semi-colon at the end.  
这两个属性都用于 Objective-C 对象，因此它们使用_星号_来指示它们是 C 指针。它们也是语句，就像 C 中的任何其他变量声明一样，因此需要在末尾使用分号。
```objc
@interface SimpleClass : NSObject

@property NSString *firstName;
@property NSString *lastName;

@property NSNumber *yearOfBirth;
@end
```

but this might be considered overkill just to store a simple numeric value. One alternative would be to use one of the primitive types provided by C, which hold scalar values, such as an integer:  
但这可能被认为是矫枉过正，只是为了存储一个简单的数值。一种替代方法是使用 C 提供的基元类型之一，该基元类型包含标量值，例如整数：

```objc
@interface SimpleClass : NSObject

@property NSString *firstName;
@property NSString *lastName;

@property int yearOfBirth;
@end
```

#### Property Attributes Indicate Data Accessibility and Storage Considerations  

```objc
@interface SimpleClass : NSObject

@property (readonly) NSString *firstName;
@property (readonly) NSString *lastName;

@end
```

Property attributes are specified inside parentheses after the `@property` keyword, and are described fully in [Declare Public Properties for Exposed Data](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/DefiningClasses/DefiningClasses.html#//apple_ref/doc/uid/TP40011210-CH3-SW1../EncapsulatingData/EncapsulatingData.html#//apple_ref/doc/uid/TP40011210-CH5-SW4).  

### Method Declarations Indicate the Messages an Object Can Receive  

Given that Objective-C software is built from a large network of objects, it’s important to note that those objects can interact with each other by sending messages. In Objective-C terms, one object sends a message to another object by calling a method on that object.  
鉴于 Objective-C 软件是由大型对象网络构建的，因此需要注意的是，这些对象可以通过发送消息来相互交互。在 Objective-C 术语中，一个对象通过调用该对象上的方法将消息发送到另一个对象。


The equivalent Objective-C method declaration looks like this:  
等效的 Objective-C 方法声明如下所示：

```objc
- (void)someMethod;
```

The minus sign (`-`) at the front of the method name indicates that it is an instance method, which can be called on any instance of the class. This differentiates it from class methods, which can be called on the class itself, as described in [Objective-C Classes Are also Objects](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/DefiningClasses/DefiningClasses.html#//apple_ref/doc/uid/TP40011210-CH3-SW1#//apple_ref/doc/uid/TP40011210-CH3-SW18).  
方法名称前面的减号 （`-`） 表示它是一个实例方法，可以在类的任何实例上调用它。这使它与类方法不同，类方法可以在类本身上调用，如 [Objective-C 类也是对象](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/DefiningClasses/DefiningClasses.html#//apple_ref/doc/uid/TP40011210-CH3-SW1#//apple_ref/doc/uid/TP40011210-CH3-SW18)中所述。

#### Methods Can Take Parameters  

An Objective-C method declaration includes the parameters as part of its name, using colons, like this:  
Objective-C 方法声明包含参数作为其名称的一部分，使用冒号，如下所示：

```objc
- (void)someMethodWithValue:(SomeType)value;
```

Multiple parameters to a C function are specified inside the parentheses, separated by commas; in Objective-C, the declaration for a method taking two parameters looks like this:  
在 Objective-C 中，采用两个参数的方法的声明如下所示：

```objc
- (void)someMethodWithFirstValue:(SomeType)value1 secondValue:(AnotherType)value2;
```

In this example, `value1` and `value2` are the names used in the implementation to access the values supplied when the method is called, as if they were variables.  
在此示例中，`value1` 和 `value2` 是实现中用于访问调用方法时提供的值的名称，就好像它们是变量一样。

The order of the parameters in a method call must match the method declaration, and in fact the `secondValue:` portion of the method declaration is part of the name of the method:  
方法调用中参数的顺序必须与方法声明匹配，实际上，方法声明的 `secondValue:` 部分是方法名称的一部分：

```objc
someMethodWithFirstValue:secondValue:
```

This is one of the features that helps make Objective-C such a readable language, because the values passed by a method call are specified _inline_, next to the relevant portion of the method name, as described in [You Can Pass Objects for Method Parameters](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/DefiningClasses/DefiningClasses.html#//apple_ref/doc/uid/TP40011210-CH3-SW1../WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW13).  
这是有助于使 Objective-C 成为一种可读语言的功能之一，因为方法调用传递的值是_内联_指定的，位于方法名称的相关部分旁边，如[您可以传递方法参数的对象](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/DefiningClasses/DefiningClasses.html#//apple_ref/doc/uid/TP40011210-CH3-SW1../WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW13)中所述。

**Note:** The `value1` and `value2` value names used above aren’t strictly part of the method declaration, which means it’s not necessary to use exactly the same value names in the declaration as you do in the implementation. The only requirement is that the signature matches, which means you must keep the name of the method as well as the parameter and return types exactly the same.  
**注意：**上面使用的 `value1` 和 `value2` 值名称严格来说不是方法声明的一部分，这意味着不必在声明中使用与在实现中完全相同的值名称。唯一的要求是签名匹配，这意味着必须保持方法的名称以及参数和返回类型完全相同。

As an example, this method has the same signature as the one shown above:  
例如，此方法具有与上面所示的签名相同的签名：

```objc
- (void)someMethodWithFirstValue:(SomeType)info1 secondValue:(AnotherType)info2;
```

These methods have different signatures to the one above:  
这些方法与上述方法具有不同的签名：

```objc
- (void)someMethodWithFirstValue:(SomeType)info1 anotherValue:(AnotherType)info2;
- (void)someMethodWithFirstValue:(SomeType)info1 secondValue:(YetAnotherType)info2;
```

### Class Names Must Be Unique  


For this reason, it’s advisable to prefix the names of any classes you define, using three or more letters. These letters might relate to the app you’re currently writing, or to the name of a framework of reusable code, or perhaps just your initials.  
因此，建议使用三个或更多字母作为您定义的任何类名称的前缀。这些字母可能与你当前正在编写的应用有关，或者与可重用代码框架的名称有关，或者可能只是与你的首字母有关。

All examples given in the rest of this document use class name prefixes, like this:  
本文档其余部分给出的所有示例都使用类名前缀，如下所示：

```objc
@interface XYZPerson : NSObject@property (readonly) NSString *firstName;@property (readonly) NSString *lastName;@end
```

Further naming conventions and suggestions are given in [Conventions](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/DefiningClasses/DefiningClasses.html#//apple_ref/doc/uid/TP40011210-CH3-SW1../Conventions/Conventions.html#//apple_ref/doc/uid/TP40011210-CH10-SW1).  
进一步的命名约定和建议在[公约](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/DefiningClasses/DefiningClasses.html#//apple_ref/doc/uid/TP40011210-CH3-SW1../Conventions/Conventions.html#//apple_ref/doc/uid/TP40011210-CH10-SW1)中给出。

## The Implementation of a Class Provides Its Internal Behavior  

As stated earlier, the interface for a class is usually placed inside a dedicated file, often referred to as a _header file_, which generally has the filename extension `.h`. You write the implementation for an Objective-C class inside a source code file with the extension `.m`.  
如前所述，类的接口通常放置在专用文件中，通常称为_头文件_，其文件扩展名通常为 `.h`。您可以在扩展名为 `.m` 的源代码文件中编写 Objective-C 类的实现。

Whenever the interface is defined in a header file, you’ll need to tell the compiler to read it before trying to compile the implementation in the source code file. Objective-C provides a preprocessor directive, `#import`, for this purpose. It’s similar to the C `#include` directive, but makes sure that a file is only included once during compilation.  
每当在头文件中定义接口时，都需要告诉编译器读取它，然后再尝试在源代码文件中编译实现。为此，Objective-C 提供了一个预处理器指令 `#import`。它类似于 C `#include` 指令，但确保文件在编译过程中只包含一次。

Note that preprocessor directives are different from traditional C statements and do not use a terminating semi-colon.  
请注意，预处理器指令不同于传统的 C 语句，并且不使用终止分号。

### Basic Syntax

The basic syntax to provide the implementation for a class looks like this:  
为类提供实现的基本语法如下所示：

```objc
#import "XYZPerson.h" 
@implementation XYZPerson 

@end
```

If you declare any methods in the class interface, you’ll need to implement them inside this file.  
如果在类接口中声明任何方法，则需要在此文件中实现它们。

### Implementing Methods实现方法

For a simple class interface with one method, like this:  
对于具有一种方法的简单类接口，如下所示：

```objc
@interface XYZPerson : NSObject
- (void)sayHello;
@end
```

the implementation might look like this:  
实现可能如下所示：

```objc
#import "XYZPerson.h" 
@implementation XYZPerson
- (void)sayHello {    
    NSLog(@"Hello, World!");
    }
@end
```

This example uses the `NSLog()` function to log a message to the console. It’s similar to the standard C library `printf()` function, and takes a variable number of parameters, the first of which must be an Objective-C string.  
此示例使用 `NSLog()` 函数将消息记录到控制台。它类似于标准的 `printf()` 函数，并采用可变数量的参数，其中第一个参数必须是 Objective-C 字符串。

In general, method names should begin with a lowercase letter. The Objective-C convention is to use more descriptive names for methods than you might see used for typical C functions. If a method name involves multiple words, use camel case (capitalizing the first letter of each new word) to make them easy to read.  
通常，方法名称应以小写字母开头。Objective-C 约定是，对方法使用的描述性名称比典型 C 函数使用的描述性名称要多。如果方法名称涉及多个单词，请使用驼峰大小写（将每个新单词的第一个字母大写）以使其易于阅读。

Note also that whitespace is flexible in Objective-C. It’s customary to indent each line inside any block of code using either tabs or spaces, and you’ll often see the opening left brace on a separate line, like this:  
另请注意，空格在 Objective-C 中是灵活的。习惯上使用制表符或空格缩进任何代码块中的每一行，并且您经常会在单独的行上看到左大括号，如下所示：

```objc
- (void)sayHello{    
    NSLog(@"Hello, World!");
}
```

Xcode, Apple’s integrated development environment (IDE) for creating OS X and iOS software, will automatically indent your code based on a set of customizable user preferences. See [Changing the Indent and Tab Width](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/DefiningClasses/DefiningClasses.html#//apple_ref/doc/uid/TP40011210-CH3-SW1../../../../DeveloperTools/Conceptual/XcodeWorkspace/100-The_Text_Editor/text_editor.html#//apple_ref/doc/uid/TP40002679-SW41) in _[Xcode Workspace Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/DefiningClasses/DefiningClasses.html#//apple_ref/doc/uid/TP40011210-CH3-SW1../../../../DeveloperTools/Conceptual/XcodeWorkspace/000-Introduction/Introduction.html#//apple_ref/doc/uid/TP40006920)_ for more information.  


You’ll see many more examples of method implementations in the next chapter, [Working with Objects](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/DefiningClasses/DefiningClasses.html#//apple_ref/doc/uid/TP40011210-CH3-SW1../WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW1).  


## Objective-C Classes Are also Objects  

In Objective-C, a class is itself an object with an opaque type called `Class`. Classes can’t have properties defined using the declaration syntax shown earlier for instances, but they can receive messages.  
在 Objective-C 中，类本身就是一个具有不透明类型的对象，称为 `Class`。类不能使用前面为实例显示的声明语法定义属性，但它们可以接收消息。

The typical use for a class method is as a _factory method_, which is an alternative to the object allocation and initialization procedure described in [Objects Are Created Dynamically](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/DefiningClasses/DefiningClasses.html#//apple_ref/doc/uid/TP40011210-CH3-SW1../WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW7). The `NSString` class, for example, has a variety of factory methods available to create either an empty string object, or a string object initialized with specific characters, including:  
类方法的典型用途是作为_工厂方法_，它是[动态创建对象](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/DefiningClasses/DefiningClasses.html#//apple_ref/doc/uid/TP40011210-CH3-SW1../WorkingwithObjects/WorkingwithObjects.html#//apple_ref/doc/uid/TP40011210-CH4-SW7)中描述的对象分配和初始化过程的替代方法。例如，`NSString` 类具有多种工厂方法，可用于创建空字符串对象或使用特定字符初始化的字符串对象，包括：

```objc
+ (id)string;
+ (id)stringWithString:(NSString *)aString;
+ (id)stringWithFormat:(NSString *)format, …;
+ (id)stringWithContentsOfFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)error;
+ (id)stringWithCString:(const char *)cString encoding:(NSStringEncoding)enc;
```

As shown in these examples, class methods are denoted by the use of a `+` sign, which differentiates them from instance methods using a `-` sign.  
如这些示例所示，类方法通过使用 `+` 号表示，这将它们与使用 `-` 符号的实例方法区分开来。

Class method prototypes may be included in a class interface, just like instance method prototypes. Class methods are implemented in the same way as instance methods, inside the `@implementation` block for the class.  
类方法原型可以包含在类接口中，就像实例方法原型一样。类方法的实现方式与实例方法相同，在类的 `@implementation` 块内。

## Exercises

**Note:** In order to follow the exercises given at the end of each chapter, you may wish to create an Xcode project. This will allow you to make sure that your code compiles without errors.  
**注意：**为了遵循每章末尾给出的练习，您可能希望创建一个 Xcode 项目。这将使你能够确保你的代码编译时没有错误。

Use Xcode’s New Project template window to create a _Command Line Tool_ from the available OS X Application project templates. When prompted, specify the project’s Type as _Foundation_.  
使用 Xcode 的“新建项目”模板窗口，从可用的 OS X 应用程序项目模板创建_命令行工具_。出现提示时，将项目的“类型”指定为_“基础_”。

1.  Use Xcode’s New File template window to create the interface and implementation files for an Objective-C class called `XYZPerson`, which inherits from `NSObject`.
    
      
    使用 Xcode 的“新建文件”模板窗口为名为 `XYZPerson` 的 Objective-C 类创建接口和实现文件，该类继承自 `NSObject`。
2.  Add properties for a person’s first name, last name and date of birth (dates are represented by the `NSDate` class) to the `XYZPerson` class interface.
    
      
    将某人的名字、姓氏和出生日期（日期由 `NSDate` 类表示）的属性添加到 `XYZPerson` 类接口。
3.  Declare the `sayHello` method and implement it as shown earlier in the chapter.
    
      
    声明 `sayHello` 方法并实现它，如本章前面所示。
4.  Add a declaration for a class factory method, called “`person`”. Don’t worry about implementing this method until you’ve read the next chapter.
    
      
    为名为“`person`”的类工厂方法添加声明。在阅读下一章之前，不要担心实现此方法。
    
    **Note:** If you’re compiling the code, you’ll get a warning about an “Incomplete implementation” due to this missing implementation.  
    **注意：**如果正在编译代码，则由于缺少实现，您将收到有关“未完成实现”的警告。