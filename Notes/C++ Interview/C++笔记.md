C++ 的核心究竟是什么？学到什么程度才算精通？

C++03：主要是c，虚函数，继承，stl的容器。不需要懂实现；
C
C++11：RAII、构造函数、auto、右值引用、lambda、template；
C
C++17：代数类型、pmr分配器，掌握oop常用的设计模式；
C
C++20：concept、模版元编程、预编译处理器元编程。至此学完c++同步编程；
C
C++23：executors、coroutine。至此学完c++异步编程；

然后简历上可以写熟悉c++。

第七章
7.1 对象模型

一个强大的无缝对象通信机制一一信号和槽(signals and slots)；
可查询和可设计的对象属性系统 (object properties)；
强大的事件和事件过滤器(events and event filters)；
通过上下文进行国际化的字符串翻译机制(string translation for internationalization)；
完善的定时器(timers)驱动，使得可以在一个事件驱动的GUI中处理多个任务；
分层结构的、可查询的对象树(object trees)，它使用一种很自然的方式来组织对象拥有(object ownership)；
守卫指针即QPointer，它在引用对象被销毁时自动将其设置为0；
动态的对象转换机制(dynamic cast)。

Qt 的这些特性都是在遵循标准 C++规范内实现的，使用这些特性都必须继承自QObject类。其中对象通信机制和动态属性系统还需要元对象系统(Meta-Object System)的支持。关于对象模型,可以在帮助中查看 Obiect Model 关键字。

7.1.1 信号和槽(signals and slots)

声明一个信号要使用 signals 关键字，在 signals前面不能使用public private和protected 等限定符,因为只有定义该信号的类及其子类才可以发射该信号。而且信号只用声明,不需要也不能对它进行定义实现。还要注意,信号没有返回值,只能是 void类型的。
只有 QObject 类及其子类派生的类才能使用信号和槽机制，这里的MyDialog类继承自QDialog 类,QDialog 类又继承自QWidget 类,QWidget 类是QObject 类的子类,所以这里可以使用信号和槽。
不过,使用信号和槽还必须在类声明的最开始处添加QOBJECT宏,在这个程序中,类的声明是自动生成的,已经添加了这个宏。
```cpp
void MyDialog::on_pushButton_clcked()//确定按钮
{
    int value =ui->spinBox->value();    //获取输入的数值
    emit dlqReturn(value);              //发射信号

    //关闭对话框
    close();
}
```
单击“确定”按钮便获取 spinBox部件中的数值，然后使用自定义的信号将其作为参数发射出去。发射一个信号要使用emit 关键字例如程序中发射了dlgReturn()信号。
```cpp
private slots:
void showValue(int value);
```
声明一个槽需要使用slots 关键字。一个槽可以是 private public或者protected类型的,槽也可以声明为虚函数,这与普通的成员函数是一样的,也可以像调用一个普通函数一样来调用槽。槽的最大特点就是可以和信号关联。
```cpp
MyDialog* dlg = new MyDialog(this);
//将对话框中的自定义信号与主界面中的自定义槽进行关联
connect(dlg,SIGNAL(dlgReturn(int)),this,SLOT(showValue(int)));
dlg->show();
```
这里创建了一个MyDialog,并且使用Widget作为父部件。然后将MyDialog类的dlgReturn()信号与 Widget类的showValue()槽进行关联。信号和槽进行关联使用的是QObject类的 connect(函数，这个函数的原型如下:
```cpp
bool QObject::connect( const Object * sender, const char * signal, const QObject * receiver, const char * method, Qt::ConnectionType type = t::AutoConnection )
```

第一个参数为发送信号的对象,例如这里的 dlg；
第二个参数是要发送的信号,这里是SIGNAL(dlgReturn(int))；
第三个参数是接收信号的对象，这里是 this,表明是本部件，即 Widget,当这个参数为 this 时,也可以将这个参数省略掉因为 connect()函数还有另外一个重载形式,该参数默认为 this；
第四个参数是要执行的槽,这里是SLOT(showValue(int))。
对于信号和槽,必须使用SIGNAL()和SLOT()宏，它们可以将其参数转化为 const char* 类型。connect()函数的返回值为 bool类型,当关联成功时返回 true。还要注意,在调用这个函数时信号和槽的参数只能有类型,不能有变量,例如写成SLOT(showValue(int value))是不对的。
对于信号和槽的参数问题,基本原则是信号中的参数类型要和槽中的参数类型相对应，而且信号中的参数可以多于槽中的参数,但是不能反过来；如果信号中有多余的参数,那么它们将被忽略。
最后一个参数表明了关联的方式,默认值是 Qt::AutoConnection,这里还有其他几个选择,具体功能如表7-1所列。编程中一般使用默认值,例如这里在MyDialog类中使用emit发射了信号之后就会执行槽只有等槽执行完了才会执行emit语句后面的代码。也可以将这个参数改为Qt::QueuedConnection,这样在执行完emit语句后便立即执行其后面的代码,而不管槽是否已经执行。不再使用这个关联时,还可以使用 disconnect()函数来断开关联。

QSignalMapper类

7.1.2 属性系统
Qt 提供了强大的基于元对象系统的属性系统,可以在能够运行 Qt 的平台上支持任意的标准 C++编译器。要声明一个属性,那么该类必须继承自 QObject类而且还要在声明前使用QPROPERTY()宏。
```cpp
QPROPERTY(type name
READ getFunction
[WRITE setFunction]
[RESET resetFunction]
[NOTIFY notifySignal]
[DESIGNABLE bool]
[SCRIPTABLE boo1]
[STORED bool]
[USER bool]
[CONSTANT]
[FINAL])
```

其中 type 表示属性的类型,它可以是QVariant 支持的类型或者是用户自定义的类型。而如果是枚举类型,还需要使用QENUMS()宏在元对象系统中进行注册，这样以后才可以使用QObject::setProperty()函数来使用该属性。name 就是属性的名称。READ后面是读取该属性的函数，这个函数是必须有的,而后面带有“[]”号的选项表示这些函数是可选的。一个属性类似于一个数据成员,不过它添加了一些可以通过元对象系统访问的附加功能:
一个读(READ)访问函数。该函数是必须有的,用来读取属性的取值。这个函数一般是 const 类型的,返回值类型必须是该属性的类型,或者是该属性类型的指针或者引用。
一个可选的写(WRITE)访问函数,用来设置属性的值。这个函数必须只有一个参数而且它的返回值必须为空 void。
一个可选的重置(RESET)函数,用来将属性恢复到一个默认的值。这个函数不能有参数，而且返回值必须为空 void。
一个可选的通知(NOTIFY)信号。如果使用该选项，那么每当属性的值改变时都要发射一个指定的信号。
可选的DESIGNABLE 表明这个属性在GUI设计器(例如Qt Designer)的属性编辑器中是否可见。大多数属性的该值为true,即可见。
可选的SCRIPTABLE表明这个属性是否可以被脚本引警(scripting engine)访问,默认值为 true。
可选的 STORED 表明是否在当对象的状态被存储时也必须存储这个属性的值,大部分属性的该值为 true。
可选的 USER 表明这个属性是否被设计为该类的面向用户或者用户可编辑的属性。一般,每一个类中只有一个USER属性默认值为 false。
可选的 CONSTANT 表明这个属性的值是一个常量。对于给定的一个对象实例每一次使用常量属性的 READ方法都必须返回相同的值,但对于不同的实例,这个常量可以不同。一个常量属性不可以有 WRITE 方法和 NOTIFY信号。
可选的 FINAL表明这个属性不能被派生类重写。
其中的READWRITE和RESET函数可以被继承,也可以是虚的(virtual),当在多继承时,它们必须继承自第一个父类。

```cpp
public class MyClass： public Object
{
    QOBJECT
    Q PROPERTY(QString userName READ getUserName WRITE setUserName 
                        NOTIFY userNameChanged);    //注册属性userName
public:

    explicit MyClass(QObject * parent = 0);
    QString getUserName() const
    {return m userName;}
    //实现READ读函数
    void setUserName(OString userName)//实现WRITE写函数
    {
        m_userName = userName;
        emit userNameChanged(userName);//当属性值改变时发射该信号
    }

    signals:
    void userNameChanged(QString);  //声明NOTIFY通知消息
private:
    OString m_userName;             //私有变量存放userName属性的值
}

```
7.1.4 元对象系统
Qt中的元对象系统(Meta-Object System)提供了对象间通信的信号和槽机制、运行时类型信息和动态属性系统。元对象系统是基于以下3 个条件的:
该类必须继承自QObject类;
必须在类的私有声明区声明QOBJECT宏(在类定义时,如果没有指定 public或者private，则默认为private);
元对象编译器Meta-Object Compiler(moc,为QObject 的子类实现元对象特性提供必要的代码。

其中,moc工具读取二个C++源文件,如果它发现一个或者多个类的声明中包含有QOBJECT宏便会另外创建一个C++源文件(就是在项目目录中的debug目录下看到的以 moc 开头的C++源文件),其中包含了为每一个类生成的元对象代码这些产生的源文件或者被包含进类的源文件中,或者和类的实现同时进行编译和链接。

元对象系统主要是为了实现信号和槽机制才被引入的,不过除了信号和槽机制以外,元对象系统还提供了其他一些特性:
QObject::metaObject()函数可以返回一个类的元对象,它是QMetaObject 类的对象;
QMetaObject::className()可以在运行时以字符串形式返回类名,而不需要 C++编辑器原生的运行时类型信息(RTTI的支持;QObject:;inherits()函数返回一个对象是否是QObject 继承树上一个类的实例的信息;
QObject::tr()和QObject::trUtf8()进行字符串翻译来实现国际化;
QObject::setProperty()和 QObject::property()通过名字来动态设置或者获取对象属性;
QMetaObject::newInstance()构造该类的一个新实例除了这些特性,还可以使用qobject_cast()函数来对QObject 类进行动态类型转换，这个函数的功能类似于标准 C++中的 dynamic_cast()函数，它不再需要 RTTI的支持。


7.2 容器类
QList QLinkedList QVector QStack QQueue
QMap QMultiMap QHash QMultiHash QSet

7.2.4 QString
隐式共享
Qt中主要的隐式共享类有QByteArray、QCursor,QFont, QPixmap、QString、QUrl,QVariant 和所有的容器类等。

在QString类中一个 null字符和一个空字符并不是完全一样的。一个null字符串是使用QString 的默认构造函数或者在构造函数中传递了0来初始化的字符串;而一个空字符串是指大小为0的字符串。一般 null 字符串都是空字符串但一个空字符串不一定是一个 null 字符串，在实际编中一般使用isEmpty()来判断一个字符串是否为空。

7.2.5 QByteArray QVariant
QVariant类像是最常见的Qt的数据类型的一个共用体(union)。一个QVariant对象在一个时间只保存一个单一类型的单一值(有些类型可能是多值的,比如字符串列表)。可以使用toT()(T代表一种数据类型)函数来将QVariant 对象转换为T类型并且获取它的值。
这里toT()函数会复制以前的QVariant对象然后对其进行转换，所以以前的QVariant对象并不会改变。QVariant是Qt中一个很重要的类，比如前面讲解属性系统时提到的QObject::property()返回的就是QVariant类型的对象。

8 样式表Style Sheets
1 样式规则
样式表包含了一系列的样式规则，一个样式规则由一个选择符(selector)和声明(declaration)组成。选择符指定了受该规则影响的部件，声明指定了这个部件上要设置的属性。例如：
```cpp
QPushButton(color;red)
```
在这个样式规则中,QPushButton 是选择符，{color:red)是声明而color 是属性red 是值。这个规则指定了 QPushButton 和它的子类应该使用红色作为它们的前景色。Qt样式表中一般不区分大小写,例如 color,Color,COLOR和 COloR 表示相同的属性。只有类名,对象名和 Qt 属性名是区分大小写的。一些选择符可以指定相同的声明，只需要使用逗号隔开,例如:
```cpp
OPushButton,QLineEdit,OComboBox(color;red)
```
一个样式规则的声明部分是一些属性:值对组成的列表它们包含在大括号中使用分号隔开。例如:
```cpp
OPushButton(color:red;background - color:white)
```
可以在Qt Style Sheets Reference关键字对应的文档中的 List of Properties一项中查看 Qt样式表所支持的所有属性。

2.选择符类型
Qt样式表支持在 CSS2 中定义的所有选择符。表8-3列出了最常用的选择符类型。

国际化

Qt Linguist Manual
在Qt 中编写代码时要对需要显示的字符串调用 tr()函数,完成代码编写后对这个应用程序的翻译主要包含 3步:
1 运行 Linguist 工具从 C十十源代码中提取要翻译的文本,这时会生成一个ts 文件,这个文件是 XML格式的。
2 在 Qt Linguist 中打开ts 文件,并完成翻译工作。
3 运行 lrelease 工具从.ts 文件中获得,qm 文件,它是一个二进制文件。这里的.ts文件是供翻译人员使用的,而在程序运行时只需要使用. gm 文件，这两个文件都是与平台无关的。

第一步,编写源码。

第二步,更改项目文件。要在项目文件中指定生成的.ts 文件,每一种翻译语言对应一个.ts 文件。打开myI18N.pro 文件，在最后面添加如下一行代码;
TRANSLATIONS = myI18N_zh_CN.ts
这表明后面生成的ts文件的文件名为“myI18N_zh_CN.ts”,对于ts的名称可以随意编写,不过一般是以区域代码来结尾,这样可以更好地区分,例如这里使用了“zh_CN”来表示简体中文。最后按下Ctrl+S 保存该文件。

第三步,使用lupdate生成ts 文件。要进行翻译工作时,先要使用lupdate工具来提取源代码中的翻译文本,生成.ts 文件。在项目文件列表的 y18N pro 文件上右击,在弹出的菜单中选择“在此打开命令行控制台”。这时打开的命令行控制台中已经自动切换到了项目目录下,这时输入下面一行代码，并按下回车键:
lupdate myI18N.pro

该步也可以通过“工具一>外部一>Qt 语言家一>更新翻译(lupdate)”菜单项来快速完成,注意在使用该菜单项之前先保存所有修改过的文件。

第四步，使用Qt Linguist 完成翻译。

第五步,使用 lrelease 生成.qm 文件。在命令行输人如下一行代码,并按下回车键:
lrelease myI18N.pro
这样就成功生成了.qm 文件。
也可以在 Qt Linguist 中使用“文件一发布”和“文件>另外发布为”这两个菜单项来生成当前已打开的.ts 文件对应的.qm 文件。该步还可以通过 Qt Creator 的“工具一外部-Qt 语言家一发布翻译(lrelease)”菜单项来快速完成。

第六步,使用.qm 文件。下面在项目中添加代码使用qm 文件来更改界面的语言。
进入main.cpp文件,添加头文件#include<QTranslator>,然后在“QApplicationa(argc，argv);”代码下添加如下代码:
```
OTranslator translator;
translator.load("../myI18N/myI18N zh CNqm");

a.installTranslator(translator);
```
这里先加载了.qm文件(使用了相对路径),然后为QApplication 对象安装了翻译。注意,这几行代码一定要放到创建部件的代码之前，比如这里放到了“MainWin-dow w;”一行代码之前,这样才能对该部件进行翻译。另外,有时可能因为部件的大小问题使得翻译后的文本无法完全显示，较好地解决方法就是使用布局管理器。


如果引用的文本没有在QObject 子类的成员函数中那么可以使用一个合适的类的 tr()函数，或者直接使用QCoreApplication::translate()函数。例如:
```cpp
void some_global_function(LoginWidget* logwid)
{
    QLabel* label=new QLabel(
        LoginWidget::tr("Password:")，logwid);
}
void same_global_function(LoginWidget*logwid)
{
    QLabel*label=new QLabel(
        gApp->translate("LoginWidget", "Password:")，logwid);
}
```

如果要在不同的函数中使用要翻译的文本，那么可以使用QT_TR_NOOP()宏和 QT_TRANSLATE_NOOP()宏它们仅仅对该文本进行标记来方便lupdate 具进行提取。使用QT_TRANSLATE_NOOP()的例子:


11.1 Graphics View Framework
要实现自定义的图形项，那么首先要创建一个QGraphicsItem 的子类，然后重新实现它的两个纯虚公共函数:boundingRect()和paint(),前者用来返回要绘制图形项的矩形区域，后者用来执行实际的绘图操作。
其中,boundingRect()函数将图形项的外部边界定义为一个矩形,所有的绘图操作都必须限制在图形项的边界矩形之中。而且，QGraphicsView 要使用这个矩形来别除那些不可见的图形项，还要使用它来确定当绘制交叉Item时哪些区域需要进行重新构建。另外QGraphicsItem的碰撞检测机制也需要使用到这个边界矩形。如果图形绘制了一个轮廓，那么在边界矩形中包含一半画笔的宽度是很重要的,尽管对于抗锯齿绘图并不需要这些补偿。
对于绘图函数 paint(),它的原型如下:
```cpp
void QGraphicsItem::paint(QPainter* painter, const QStyleOptionGraphicsItem* option，QWidget* widget=0)



```


Animation Framework

动画框架中提供了QPropertyAnimation类，继承自QVariantAnimation,用来执行Qt属性的动画。这个类使用缓和曲线(easing curve)来对属性进行插值。如果要对一个值使用动画就可以创建继承自QObject 的类，然后在类中将该值定义为一个属性当然属性动画为已经存在的窗口部件以及其他 QObject 子类提供了非常灵活的动画控制。

Qt 现在支持的可以进行插值的 QVariant 类型有 int,double float, QLine, QLineF,QPoint,QPointF,QSize QSizeF,QRect,QRecF 和QColor 等。如果要实现复杂的动画,可以通过动画组 QAnimationGroup类实现，它的功能是作为其他动画类的容器，一个动画组中还可以包含另外的动画组。
