# 在Objective-C中使用C++

> 原文链接：[web.archive.org/web/2010120…](http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjectiveC/Articles/ocCPlusPlus.html)
> 

苹果的Objective-C编译器允许你在同一个源文件中自由混合C++和Objective-C代码。这种Objective-C/C++混合语言被称为Objective-C++。有了它，你可以从你的Objective-C应用程序中使用现有的C++库。

## 混合Objective-C和C++语言的特点

在Objective-C++中，你可以在C++代码和Objective-C方法中调用任一语言的方法。在两种语言中指向对象的指针都只是指针，因此可以在任何地方使用。例如，你可以把指向Objective-C对象的指针作为C++类的数据成员，你也可以把指向C++对象的指针作为Objective-C类的实例变量。清单14-1说明了这一点。

> 注意：Xcode要求文件名有一个".mm "的扩展名，以便编译器启用Objective-C++的扩展。

**清单14-1** 使用C++和Objective-C实例作为实例变量

```objc
/* Hello.mm
 * Compile with: g++ -x objective-c++ -framework Foundation Hello.mm  -o hello
 */
 
#import <Foundation/Foundation.h>
class Hello {
    private:
        id greeting_text;  // holds an NSString
    public:
        Hello() {
            greeting_text = @"Hello, world!";
        }
        Hello(const char* initial_greeting_text) {
            greeting_text = [[NSString alloc] initWithUTF8String:initial_greeting_text];
        }
        void say_hello() {
            printf("%s\n", [greeting_text UTF8String]);
        }
};
 
@interface Greeting : NSObject {
    @private
        Hello *hello;
}
- (id)init;
- (void)dealloc;
- (void)sayGreeting;
- (void)sayGreeting:(Hello*)greeting;
@end
 
@implementation Greeting
- (id)init {
    self = [super init];
    if (self) {
        hello = new Hello();
    }
    return self;
}
- (void)dealloc {
    delete hello;
    [super dealloc];
}
- (void)sayGreeting {
    hello->say_hello();
}
- (void)sayGreeting:(Hello*)greeting {
    greeting->say_hello();
}
@end
 
int main() {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
 
    Greeting *greeting = [[Greeting alloc] init];
    [greeting sayGreeting];                         // > Hello,  world!
 
    Hello *hello = new Hello("Bonjour, monde!");
    [greeting sayGreeting:hello];                   // > Bonjour,  monde!
 
    delete hello;
    [greeting release];
    [pool release];
    return 0;
}
复制代码
```

正如你可以在Objective-C接口中声明C结构，你也可以在Objective-C接口中声明C++类。与C结构一样，在Objective-C接口中定义的C++类是全局范围的，而不是嵌套在Objective-C类中。(这与标准C语言--尽管不是C++--促进嵌套结构定义到文件范围的方式一致）。

为了允许你根据语言的变体来确定你的代码，Objective-C++编译器定义了`__cplusplus`和`__OBJC__`这两个预处理器常量，分别由C++和Objective-C语言标准指定。

如前所述，Objective-C++不允许你从Objective-C对象继承C++类，也不允许你从C++对象继承Objective-C类。

```objc
class Base { /* ... */ };
@interface ObjCClass: Base ... @end // ERROR!
class Derived: public ObjCClass ... // ERROR!
复制代码
```

与Objective-C不同，C++中的对象是静态类型的，运行时的多态性是一种例外情况。因此这两种语言的对象模型并不直接兼容。更根本的是，Objective-C和C++对象在内存中的布局是相互不兼容的，这意味着通常不可能创建一个从两种语言的角度都有效的对象实例。因此，这两种类型层次不能混用。

你可以在Objective-C的类声明中声明一个C++类。编译器将这些类看作是在全局命名空间中声明的，如下所示。

```objc
@interface Foo {
 class Bar { ... } // OK
}
@end
 
Bar *barPtr; // OK
复制代码
```

Objective-C允许C结构（无论是否在Objective-C声明中声明）作为实例变量使用。

```objc
@interface Foo {
   struct CStruct { ... };
   struct CStruct bigIvar; // OK
} ... @end
复制代码
```

在Mac OS X 10.4和更高版本中，如果你设置了`fobjc-call-cxx-cdtors`编译器标志，你可以使用包含虚拟函数和非实质性的用户定义的零参数构造器和析构器的C++类实例作为实例变量。(在gcc-4.2中默认设置了`fobjc-call-cxx-cdtors`编译器标志。) 构造函数在alloc方法中被调用（特别是在[class\_createInstance](http://developer.apple.com/library/mac/documentation/Cocoa/Reference/ObjCRuntimeRef/Reference/reference.html#//apple_ref/c/func/class_createInstance)里面），在它们作为成员的Objective-C对象被分配后立即按照声明顺序调用。使用的构造器是 "公共无参数就地构造器"。解构器在dealloc方法中被调用（特别是在[object\_dispose](http://developer.apple.com/library/mac/documentation/Cocoa/Reference/ObjCRuntimeRef/Reference/reference.html#//apple_ref/c/func/object_dispose)里面），在它们作为成员的Objective-C对象被取消分配之前，以相反的声明顺序进行。

> Mac OS X v10.3和更早的版本。下面的注意事项只适用于Mac OS X v10.3和更早的版本。
> 
> Objective-C++同样努力允许C++类实例充当实例变量。只要有关的C++类（连同它的所有超类）没有定义任何虚拟成员函数，这就是可能的。如果有任何虚拟成员函数，C++类就不能作为Objective-C实例变量。

```objc
#import <Cocoa/Cocoa.h>
 
struct Class0 { void foo(); };
struct Class1 { virtual void foo(); };
struct Class2 { Class2(int i, int j); };
 
@interface Foo : NSObject {
    Class0 class0;      // OK
    Class1 class1;      // ERROR!
    Class1 *ptr;        // OK—call 'ptr = new Class1()' from Foo's init,
                        // 'delete ptr' from Foo's dealloc
    Class2 class2;      // WARNING - constructor not called!
...
@end
复制代码
```

> C++要求每个包含虚拟函数的类的实例包含一个合适的虚拟函数表指针。然而，Objective-C运行时不能初始化虚拟函数表指针，因为它不熟悉C++的对象模型。同样地，Objective-C运行时也不能为这些对象调度对C++构造函数或析构函数的调用。如果一个C++类有任何用户定义的构造函数或析构函数，它们不会被调用。在这种情况下，编译器会发出一个警告。

Objective-C没有一个嵌套命名空间的概念。你不能在C++命名空间中声明Objective-C类，也不能在Objective-C类中声明命名空间。

Objective-C类、协议和类别不能在C++模板内声明，C++模板也不能在Objective-C接口、协议或类别的范围内声明。

然而，Objective-C类可以作为C++模板的参数。在Objective-C消息表达式中，C++模板参数也可以作为接收器或参数（尽管不是选择器）使用。

## C++词汇的歧义和冲突

有几个标识符被定义在Objective-C头文件中，每个Objective-C程序都必须包括。这些标识符是`id`, `Class`, `SEL`, `IMP`, 和`BOOL`。

在Objective-C方法中，编译器预先声明了标识符`self`和`super`，类似于C++中的关键字`this`。然而，与C++的this关键字不同，self和super是上下文敏感的；它们可以作为Objective-C方法之外的普通标识符使用。

在一个协议中的方法的参数列表中，还有五个上下文敏感的关键字（`oneway`, `in`, `out`, `inout`, and `bycopy`）。这些不是其他上下文中的关键词。

从Objective-C程序员的角度来看，C++增加了相当多的新关键字。你仍然可以使用C++关键字作为Objective-C选择器的一部分，所以影响不是很严重，但是你不能使用它们来命名Objective-C类或实例变量。例如，即使`class`是一个C++关键字，你仍然可以使用`NSObject`方法`class`。

```objc
[foo class]; // OK
复制代码
```

然而，由于它是一个关键字，你不能用class作为变量的名字。

```objc
NSObject *class; // Error
复制代码
```

在Objective-C中，类和类别的名字生活在不同的命名空间中。也就是说，`@interface foo`和`@interface(foo)`都可以存在于同一个源代码中。在Objective-C++中，你也可以有一个类别，其名称与C++的类或结构相匹配。

协议和模板指定器为不同的目的使用相同的语法。

```objc
id<someProtocolName> foo;
TemplateType<SomeTypeName> bar;
复制代码
```

为了避免这种歧义，编译器不允许`id`作为模板名称使用。

最后，在C++中，当一个标签后面有一个提到全局名称的表达式时，会有一个词法上的歧义，比如说

```objc
label: ::global_name = 3;
复制代码
```

第一个冒号后面的空格是必须的。Objective-C++增加了一个类似的情况，也需要一个空格。

```objc
receiver selector: ::global_c++_name;
复制代码
```

## 限制

Objective-C++不给Objective-C类添加C++特性，也不给C++类添加Objective-C特性。例如，你不能使用Objective-C语法来调用C++对象，你不能给Objective-C对象添加构造函数或析构函数，你也不能交替使用关键字`this`和`self`。类的层次是分开的；一个C++类不能继承于一个Objective-C类，一个Objective-C类也不能继承于一个C++类。此外，不支持多语言的异常处理。也就是说，在Objective-C代码中抛出的异常不能被C++代码捕获，反之，在C++代码中抛出的异常不能被Objective-C代码捕获。关于Objective-C中异常的更多信息，请看 ["异常处理"](http://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjectiveC/Articles/ocExceptionHandling.html#//apple_ref/doc/uid/TP30001163-CH13-SW1)。