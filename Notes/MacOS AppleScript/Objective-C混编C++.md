# Objective-C 混编C++


在ios 开发过程中, 可能个别的功能, 库等用C++实现会更好,性能更高,内存开销更少.下面我们来看看OC中怎么调用C++.

-   首先, C++是没有mrc/arc的概念的, 所以C++的内存自己管理.
-   C++与OC混编的OC代码需要mrc/arc? 这个看你喜欢,个人建议用mrc 会好点.
-   设置mrc/arc 的环境 或单个文件mrc/arc 的情况
-   在Build Setting中找到Objective-C Automatic reference counting 设置为YES，整个项目为ARC模式，如果某些文件不使用ARC，可以在Build pyases中的compile source中找到文件设置参数-fno-objc-arc为非ARC模式，反之-fobjc-arc为ARC模式。
-   如果要两者混编, 需要把.m 文件改成 .mm ,这个OC调用C++, 如果是C++调用OC把.cpp 改成.mm
-   注意.h 中不能混编的,因为.h一般是拷贝.我们可以在.h中定义一个struct, 请往下看.

#### 开始吧

首先我的结构是

-   注意 C++_Class.cpp , 要改成C++_Class.mm , 因为里面用到OC.

#### OC_Class.h

```objc
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OC_Class : NSObject
- (void)OCEat;
- (void)CPPEat;
@end

NS_ASSUME_NONNULL_END

```

#### OC_Class.mm

```objc
#import "OC_Class.h"
#import "C++_Class.hpp"
@interface OC_Class() {
    CPP_Class *cppClass;
}

@end

@implementation OC_Class
-(id)init
{
    self = [super init];
    if (self) {
        cppClass = new CPP_Class();
    }
    return self;
}

-(void)dealloc
{
    NSLog(@"oc class dealloc");
    delete cppClass;
}
- (void)OCEat {
    NSLog(@"call OCEat");
}
- (void)CPPEat {
    NSLog(@"call CPPEat");
    cppClass->CPPEat();
}
@end
```

#### C++_Class.hpp

```c++
#ifndef C___Class_hpp
#define C___Class_hpp

#include <stdio.h>
#include <string>

struct OCStruct;
class CPP_Class {
    OCStruct *ocStruct;
public:
    CPP_Class();
    ~CPP_Class();
    void CPPEat();
    void OCEat();
private:
    void initOcStruct();
};

#endif 
```

#### C++_Class.mm

```c++
#include "C++_Class.hpp"
#import "OC_Class.h"
#include <iostream>

struct OCStruct {
    OC_Class* ocClass;
};
CPP_Class::CPP_Class() {
   
};

CPP_Class::~CPP_Class() {
    std::cout << "C++class ~~ deinit " << std::endl;
    if (ocStruct) {
        //[ocStruct->ocClass relase];  //arc的话，忽略它
    }
    delete ocStruct;
};
void CPP_Class::initOcStruct() {
    if (!ocStruct) {
        OC_Class* oc = [[OC_Class alloc]init];
        ocStruct = new OCStruct;
        ocStruct->ocClass = oc;
    }
};
void CPP_Class::CPPEat() {
    std::cout << "CPPEat////" << std::endl;
    
    this->initOcStruct();
    [this->ocStruct->ocClass OCEat];
};
void CPP_Class::OCEat() {
    
    this->initOcStruct();
    [this->ocStruct->ocClass OCEat];
    
};
```

#### 使用

```objc
#import "OC_Class.h"
OC_Class * oc = [[OC_Class alloc]init];
[oc CPPEat];
```
# [C++、Objective-C 混合编程](https://www.cnblogs.com/zsychanpin/p/6747110.html)

在XCODE中想使用C++代码，你须要把文件的扩展名从.m改成.mm。这样才会启动g++编译器。

我们来看个測试代码：

```cpp
class TestC {  
private:  
    NSString *str_;//C++类能够使用OC对象作为成员变量  
public:  
   TestC() {  
       str_ = @"hi mc0066.";//构造函数内能够使用OC对象来赋值  
   }  
   TestC(NSString *str) {//函数能够接收OC对象（通过函数參数）  
        str_ = str;  
    }  
    TestC(NSInteger num) {  
        str_ = [NSString stringWithFormat:@"%d",num];//C++函数能够调用OC方法
    }  
    void show() {  
        printf("%s\\n",[str_ UTF8String]);  
        NSLog(@"str_ is:%@\\n",str_);  
    }  
};  
```
这是我写的C++类，类内部使用了OC的代码。依据測试能够确定下面几点：

1. C++函数内能够调用OC方法、能够创建OC对象、函数參数能够为OC对象。

2. C++类的成员变量能够是OC对象。

事实上，在混编时，OC和C++的对象都是单纯的指针。所以能够随意的彼此调用对方的方法、使用对方的内部数据。

  

再来看看OC中是怎样使用C++代码的：
```objc
@interface TestOC : NSObject  
{  
    TestC *c;//能够使用C++对象作为參数  
}
- (id)initTestOC;  
- (void)testC;  
@end  
@implementation TestOC  
- (id)initTestOC{  
    if ((self = [super init])) {  
        c = new TestC();//以C++语法调用构造函数  
    }  
    return self;  
}  
- (void)testC{  
    c->show();//调用C++类的内部函数  
}  
- (void)dealloc{  
    delete c;//用完 记得删除C++对象，避免内存泄露  
    [super dealloc];  
}  
@end  
```
和之前分析c++类没啥差别，毅然是能够使用c++的语法 能够使用c++的方法和成员。
另一点要注意，OC类无法继承C++类，C++也一样。
由于oc类的结构和c++类结构不同，所以才导致该问题。