如果你有一些C++代码或库，你想在Objective-C项目使用它，这就是我们要研究的问题。 

通常，C++代码中会定义你要使用的一些类(class), 你可以简单的把.m文件扩展名改为.mm就可以改为Objective-C++编译，然后就可以很容易地混合使用C++和Objective-C的代码。这是一个简单的做法，但两个世界确实很不一样，如此这样的深度混合有时会变地很棘手。

  

你可能会想使用等价的Objective-C类型和函数将C++代码封装(wrap)起来。比方说，你有一个名为CppObject的C++类(CppObject.h)：

```cpp

#include <string>
class CppObject
{
public:
  void ExampleMethod(const std::string& str);
  // constructor, destructor, other members, etc.
};
```

  

在Objectiv-C类允许定义C++类的成员变量，所以可以首先尝试定义一个ObjcObject封装类(ObjcObject.h):

```cpp

#import <Foundation/Foundation.h>
#import "CppObject.h"
 
 
@interface ObjcObject : NSObject {
  CppObject wrapped;
}
- (void)exampleMethodWithString:(NSString*)str;
// other wrapped methods and properties
@end
```

  
然后在ObjcObject.mm中实现这些方法。不过，此时会在两个头文件(ObjcObject.h&CppObject.h)中得到一个预处理和编译错误。问题出在#include和#import上。对于预处理器而言，它只做文本的替换操作。所以#include和#import本质上就是递归地复制和粘贴引用文件的内容。这个例子中，使用#import "ObjcObject.h"等价于插入如下代码：

```cpp

// [首先是大量Foundation/Foundation.h中的代码]
// [无法包含<string>]，因为它仅存在于C++模式的include path中
class CppObject
{
public:
  void ExampleMethod(const std::string& str);
  // constructor, destructor, other members, etc.
};
 
 
@interface ObjcObject : NSObject {
  CppObject wrapped;
}
- (void)exampleMethodWithString:(NSString*)str;
// other wrapped methods and properties
@end

```

  

因为class CppObject根本不是有效的Objective-C语法, 所以编译器就被搞糊涂了。 错误通常是这样的：

_Unknown type name 'class'; did you mean 'Class'?_

正是因为Objective-C中没有class这个关键字. 所以要与Objective-C兼容，Objective-C++类的头文件必须仅包含Objective-C代码，绝对没有C++的代码 - 这主要是影响类型定义（就像例中的CppObject类）。

  

**保持简洁的头文件**

之前的文章已经提到一些解决方案.其中最好的一个是PIMPL，它也适用于现在的情况。这里还有一个适用于clang的新方法，可以将C++代码从Objective-C中隔开，这就是[class extensions](http://developer.apple.com/library/ios/#documentation/cocoa/conceptual/objectivec/Chapters/ocCategories.html#//apple_ref/doc/uid/TP30001163-CH20-SW1)中ivars的。 

  

Class extensions (不要同categories弄混) 已经存在一段时间了: 它们允许你在class的接口外的扩展部分定义在@implementation段前，而不是在公共头文件中。 这个例子就可以声明在ObjcObject.mm中:

```cpp

#import "ObjcObject.h"
@interface ObjcObject () // note the empty parentheses
- (void)methodWeDontWantInTheHeaderFile;
@end
@implementation ObjcObject
// etc.


```

  
GCC也支持这个操作。不过clang还支持添加ivar块，也就是你还可以声明C++类型的实例变量，既可以在class extension中，也可以在@implementation开始的位置。本例中的ObjcObject.h可以被精简为：

```cpp

#import <Foundation/Foundation.h>
 
 
@interface ObjcObject : NSObject
- (void)exampleMethodWithString:(NSString*)str;
// other wrapped methods and properties
@end

```

去掉的部分都移到实现文件的class extension中 (ObjcObject.mm):

```cpp

#import "ObjcObject.h"
#import "CppObject.h"
@interface ObjcObject () {
  CppObject wrapped;
}
@end
 
 
@implementation ObjcObject
- (void)exampleMethodWithString:(NSString*)str
{
  // NOTE: str为nil会建立一个空字串，而不是引用一个指向UTF8String空指针. 
  std::string cpp_str([str UTF8String], [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
  wrapped.ExampleMethod(cpp_str);
}
```

  
如果我们不需要interface extension来声明额外的属性和方法，ivar块仍然可以放在@implementation开始位置:

```cpp

#import "ObjcObject.h"
#import "CppObject.h"
 
 
@implementation ObjcObject {
  CppObject wrapped;
}
 
 
- (void)exampleMethodWithString:(NSString*)str
{
  // NOTE: str为nil会建立一个空字串，而不是引用一个指向UTF8String空指针.
  std::string cpp_str([str UTF8String], [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
  wrapped.ExampleMethod(cpp_str);
}
```

定义的CppObject实例wrapped在ObjcObject创建时，CppObject的缺省建构函数会被调用，而在ObjcObject被调用dealloc析构时，ObjcObject的析构函数也会被调用。如果ObjcObject没有提供缺省的建构函数，编译就会失败。

  

**管理被封装C++对象的生命周期**

解决方案是透过new关键字掌握建构过程, 比如:

```cpp
@interface ObjcObject () {
  CppObject* wrapped; // 指针!会在alloc时初始为NULL.
}
@end
@implementation ObjcObject
- (id)initWithSize:(int)size
{
  self = [super init];
  if (self)
  {
    wrapped = new CppObject(size);
    if (!wrapped) self = nil;
  }
  return self;
}
//...
```

  
如果是使用C++异常, 也可以使用 try {...} catch {...}把创建过程封装起来. 相应地，还要显式地释放封闭对象:

```cpp
- (void)dealloc
{
  delete wrapped;
  [super dealloc]; // 如果使用了ARC,这句就要略去
}

```

  
作者接着提到了另一个方法，显示分配一块内存，然后在它的基础上调用new来创建对象。首先声明char wrapped\_mem\[sizeof(CppObject)\]; 再使用wrapped = new(wrapped\_mem) CppObject();创建了实例wrapped。释放时if (wrapped) wrapped->~CppObject();  这样虽然可行，但不建议使用。

  

 **总结**

 一定要确保封装的方法仅返回和使用C或Objective-C类型的返回值及参数。同时不要忘记C++中不存在nil, 而NUL是不可用于解引用的。

  

**反向:在C++代码中使用Objective-C类**

这个问题同样存在于头文件中。你不能因为引入Objective-C类型而污染了C++头文件，或无法被纯C++代码所引用。比方说，我们想封装的Objective-C类ABCWidget ，在ABCWidget.h声明为:

```objc
#import <Foundation/Foundation.h>
@interface ABCWidget
- (void)init;
- (void)reticulate;
// etc.
@end

```

  
这样的类定义在Objective-C++中是没有问题的，但在纯C++的代码是不允许的:

```cpp

namespace abc
{
  struct WidgetImpl;
  class Widget
  {
    WidgetImpl* impl;
  public:
    Widget();
    ~Widget();
    void Reticulate();
  };
}
```

  
一个纯粹的C++编译器在Foundation.h中的代码和ABCWidget声明位置出错。

  

**永恒的PIMPL**

有没有这样的东西作为一类扩展C + +，这样的把戏将无法正常工作。 另一方面，PIMPL，工作得很好，实际上是比较常用的纯C + +了。 在我们的例子中，我们减少到最低限度：C + +类

  

C++并没有之前提到的class extension，但是却有另一种较为常用的方式:PIMPL (Private Implementation, 私有实现)。这里，将C++ class的定义精简为:

```cpp

#include "Widget.hpp"
#import "ABCWidget.h"
namespace abc
{
  struct WidgetImpl
  {
    ABCWidget* wrapped;
  };
  Widget::Widget() :
    impl(new WidgetImpl)
  {
    impl->wrapped = [[ABCWidget alloc] init];
  }
  Widget::~Widget()
  {
    if (impl)
      [impl->wrapped release];
    delete impl;
  }
  void Widget::Reticulate()
  {
    [impl->wrapped reticulate];
  }
} 

```

  
然后在Widget.mm中:

```cpp
#include "Widget.hpp"#import "ABCWidget.h"namespace abc{  struct WidgetImpl  {    ABCWidget* wrapped;  };  Widget::Widget() :    impl(new WidgetImpl)  {    impl->wrapped = [[ABCWidget alloc] init];  }  Widget::~Widget()  {    if (impl)      [impl->wrapped release];    delete impl;  }  void Widget::Reticulate()  {    [impl->wrapped reticulate];  }} 
```

  

它的工作原理是，前置声明。声明这样的结构或类对象的指针成员变量、结构或类就足够了。

  

需要注意的是封装的对象会在析构函数中释放。即便对于使用了ARC的项目，我还是建议你对这样的对C++/Objective-C重引用的文件屏蔽掉它。不要让C++代码依赖于ARC。在XCode中可以针对个别文件屏蔽掉ARC。Target properties->Build phase页签，展开'Compile Sources', 为特定文件添加编译选项-fno-objc-arc。

  

**C++中封装Objective-C类的捷径**

您可能已经注意到，PIMPL解决方案使用两个级别的间接引用。 如果包装的目标类像本例中的一样简单，就可能会增大了复杂性。 虽然Objective-C的类型一般不能使用在纯C++中，不过有一些在C中实际已经定义了。id类型就是其中之一，它的声明在<objc/objc-runtime.h>头文件中。虽然会失去一些Objective-C的安全性，你还是可以把你的对象直接传到C++类中：

```cpp
#include <objc/objc-runtime.h>
namespace abc
{
  class Widget
  {
    id /* ABCWidget* */ wrapped;
  public:
    Widget();
    ~Widget();
    void Reticulate();
  };
}

```

  
不建议向id对象直接发送消息。这样你会失去很多编译器的检查机制，特别是对于不同类中有着相同selector名字的不同方法时。所以:

```cpp
#include "Widget.hpp"
#import "ABCWidget.h"
namespace abc
{
  Widget::Widget() :
    wrapped([[ABCWidget alloc] init])
  {
  }
  Widget::~Widget()
  {
    [(ABCWidget*)impl release];
  }
  void Widget::Reticulate()
  {
    [(ABCWidget*)impl reticulate];
  }
}
```

  
像这样的类型转换很容易在代码中隐藏错误，再尝试一个更好的方式。在头文件中:

```cpp
#ifdef __OBJC__
@class ABCWidget;
#else
typedef struct objc_object ABCWidget;
#endif
 
 
namespace abc
{
  class Widget
  {
    ABCWidget* wrapped;
  public:
    Widget();
    ~Widget();
    void Reticulate();
  };
} 
```

  
如果这个头文件被一个mm文件引用，编译器可以充分识别到正确的类。 如果是在纯C++模式中引用，ABCWidget\*是一个等价的id类型：定义为typedef struct objc\_object\* id; 。 #ifdef块还可以被进一步放到一个可重用的宏中:

```cpp
#ifdef __OBJC__
#define OBJC_CLASS(name) @class name
#else
#define OBJC_CLASS(name) typedef struct objc_object name
#endif
```

  

现在，我们可以前置声明在头文件中一行就可以适用于所有4种语言:

  OBJC\_CLASS(ABCWidget);