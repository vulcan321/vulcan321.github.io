

> 该篇为我学习GLib 和 GTK 的笔记，只是记录一些知识点和写法，若碰巧浏览此篇，尽量不要以此篇为准！

## GLib相关介绍

### GObject

------



#### GObject简单声明定义

GObject实现中， 类是两个结构体的组合，一个是**实例结构体**（保存所有对象私有数据），另一个是**类结构体**（保存所有对象共享的数据），其结构关系图如下：

![image-01](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2021080601.png)

#### GObject 构造和析构大致过程

构造过程：

- 注册 **GObject** 类型到类型系统，此操作是在执行 **main** 函数之前，**glib**初始化过程中完成的
- 分配内存给 **GObjectClass** 和 **GObject  structure**
- 初始化 **GObjectClass** 结构体内存，这块内存是对象的类（类似C++类中的函数和静态变量）
- 初始化 **GObject structure** 内存， 这块内存属于实例

注意：初始化流程是在第一次调用 **g_object_new** 函数时进行的。在第二次后续调用 **g_object_new**时，它只执行两步：

① 给 **GObject structure** 分配内存

② 初始化内存

析构过程：销毁 **GObject** 实例，内存释放，但是不会销毁 **GObjectClass**，即使所有**GObject**实例被回收，**GObjectClass**仍然存在



样例声明如下：

```c
// dlist.h 实现一个列表类
#include <glib-object.h>

#define PM_TYPE_DLIST (pm_dlist_get_type())

typedef struct _PMDListNode PMDListNode;
struct  _PMDListNode {
        PMDListNode *prev;
        PMDListNode *next;
        void *data;
};

typedef struct _PMDList PMDList;
struct  _PMDList {
        GObject parent_instance;	// 实例的结构体第一个成员必须是 父类的实例结构体 !!!
        PMDListNode *head;
        PMDListNode *tail;
};

typedef struct _PMDListClass PMDListClass;

struct _PMDListClass {
        GObjectClass parent_class;	// 类的结构体第一个成员必须是 父类的类结构体 !!!
};

GType pm_dlist_get_type (void);
```

```c
// dlist.cpp
#include "dlist.h"
// 对 pm_dlist_get_type 生成实现，返回类对象
// #arg_1: 类名 	#arg_2: 成员函数命名前缀	#arg_3: 父类型
G_DEFINE_TYPE (PMDList, pm_dlist, G_TYPE_OBJECT);
static void pm_dlist_init (PMDList *self)
{
        g_printf ("\t实例结构体初始化！\n");
        self->head = NULL;
        self->tail = NULL;
}

static void pm_dlist_class_init (PMDListClass *klass)
{
        g_printf ("类结构体初始化!\n");
}
```

GObject具有功能：

- 基于引用计数的内存管理 —— 结合 **g_object_ref** 和 **g_object_unref** 两个函数对引用计数进行加减

  ```c
  #define g_object_ref(Obj) ((glib_typeof (Obj)) (g_object_ref) (Obj))
  void g_object_unref (gpointer object);
  ```

- 对象的构造函数与析构函数

- 可设置对象属性的 set/get 函数

- 易于使用的信号机制



继承GObject基类的实例化代码：

```c
PMDList *dlist; /* 类的实例化，产生对象 */
dlist = g_object_new (PM_TYPE_DLIST, NULL); /* 创建对象的一个实例 并将其引用计数 +1 */
g_object_unref (dlist); /* 将对象的实例引用计数 -1，并检测对象的实例的引用计数是否为 0，若为 0，那么便释放对象的实例的存储空间。 */
dlist = g_object_new (PM_TYPE_DLIST, NULL); /* 再创建对象的一个实例 */
```



GObject子类化完整的过程：

> ① 在 .h 文件中包含 glib-object.h；
> ② 在 .h 文件中构建实例结构体与类结构体，并分别将 GObject 类的实例结构体与类结构体置于成员之首；
> ③ 在 .h 文件中定义 P_TYPE_T 宏，并声明 p_t_get_type 函数；
> ④ 在 .c 文件中调用 G_DEFINE_TYPE 宏产生类型注册代码。

声明的简单范例，参考地址： https://blog.csdn.net/knowledgebao/article/details/82418046

https://github.com/ToshioCP/Gobject-tutorial/blob/main/gfm/sec2.md



 GTypeInfo 相关实现：

```c
typedef struct _GTypeInfo  GTypeInfo;

struct _GTypeInfo
{
  /* interface types, classed types, instantiated types */
  guint16                class_size;

  GBaseInitFunc          base_init;
  GBaseFinalizeFunc      base_finalize;

  /* interface types, classed types, instantiated types */
  GClassInitFunc         class_init;	// 初始化 class 的静态成员，存储的是用户定义的类初始化函数
  GClassFinalizeFunc     class_finalize;
  gconstpointer          class_data;

  /* instantiated types */
  guint16                instance_size;	// sizeof(instance)	实例结构体大小
  guint16                n_preallocs;
  GInstanceInitFunc      instance_init;	// 初始化 实例结构体的成员

  /* value handling */
  const GTypeValueTable  *value_table;
};
```



#### GObject 的属性信号

在设置属性时, GObject会发出通知信号. 当要连接这个信号时, 可以指定属性名称, 使用分割符 **"::"** 将详细信息添加到信号名称中

```c
g_signal_connect (G_OBJECT (d1), "notify::value", G_CALLBACK (notify_cb), NULL);
```



#### GObject 的继承

```c
// kb-Son.h
#include "kb-Parent.h"

typedef struct _KbSon KbSon;
struct _KbSon {
        KbParent parent;	// 继承父实例属性
};

typedef struct _KbSonClass KbSonClass;
struct _KParentClass {
        KbParentClass parent_class;	// 继承父类属性
};
```

```c
// kb-Son.c
...
G_DEFINE_TYPE(KbSon, kb_son, KB_TYPE_Parent);	// GType 设置成父类 其他代码一样
...
```



```c
// 抽象类宏
// Declaration of t_number_init () function.
// Declaration of t_number_class_init () function.
// Definition of t_number_get_type () function.
// Definition of t_number_parent_class static variable that points the parent class.
#define G_DEFINE_ABSTRACT_TYPE(TN, t_n, T_P)		    G_DEFINE_TYPE_EXTENDED (TN, t_n, T_P, G_TYPE_FLAG_ABSTRACT, {})

// 可派生宏，例如：  G_DECLARE_DERIVABLE_TYPE (TNumber, t_number, T, NUMBER, GObject)
// 1.声明 t_number_get_type() 函数，这个函数必须定义在.c文件。定义通常使用 G_DEFINE_TYPE 或其系列宏完成。
// 2.定义只有 GObject 成员的实例结构体
// 3.声明 TNumberClass，它应该之后在.h声明
// 4.定义了 T_NUMBER（转换为实例）、T_NUMBER_CLASS（转换为类）、T_IS_NUMBER（实例检查）、T_IS_NUMBER_CLASS（类检查）和 T_NUMBER_GET_CLASS。
// 5.g_autoptr() 支持
#define G_DECLARE_DERIVABLE_TYPE(ModuleObjName, module_obj_name, MODULE, OBJ_NAME, ParentName) \
  GType module_obj_name##_get_type (void);                                                               \
  G_GNUC_BEGIN_IGNORE_DEPRECATIONS                                                                       \
  typedef struct _##ModuleObjName ModuleObjName;                                                         \
  typedef struct _##ModuleObjName##Class ModuleObjName##Class;                                           \
  struct _##ModuleObjName { ParentName parent_instance; };                                               \
                                                                                                         \
  _GLIB_DEFINE_AUTOPTR_CHAINUP (ModuleObjName, ParentName)                                               \
  G_DEFINE_AUTOPTR_CLEANUP_FUNC (ModuleObjName##Class, g_type_class_unref)                               \
                                                                                                         \
  G_GNUC_UNUSED static inline ModuleObjName * MODULE##_##OBJ_NAME (gpointer ptr) {                       \
    return G_TYPE_CHECK_INSTANCE_CAST (ptr, module_obj_name##_get_type (), ModuleObjName); }             \
  G_GNUC_UNUSED static inline ModuleObjName##Class * MODULE##_##OBJ_NAME##_CLASS (gpointer ptr) {        \
    return G_TYPE_CHECK_CLASS_CAST (ptr, module_obj_name##_get_type (), ModuleObjName##Class); }         \
  G_GNUC_UNUSED static inline gboolean MODULE##_IS_##OBJ_NAME (gpointer ptr) {                           \
    return G_TYPE_CHECK_INSTANCE_TYPE (ptr, module_obj_name##_get_type ()); }                            \
  G_GNUC_UNUSED static inline gboolean MODULE##_IS_##OBJ_NAME##_CLASS (gpointer ptr) {                   \
    return G_TYPE_CHECK_CLASS_TYPE (ptr, module_obj_name##_get_type ()); }                               \
  G_GNUC_UNUSED static inline ModuleObjName##Class * MODULE##_##OBJ_NAME##_GET_CLASS (gpointer ptr) {    \
    return G_TYPE_INSTANCE_GET_CLASS (ptr, module_obj_name##_get_type (), ModuleObjName##Class); }       \
  G_GNUC_END_IGNORE_DEPRECATIONS

```



继承常用的宏（其中P表示项目名称 	T表示类名称	PTPrivate表示私有数据结构体）：

```c
#define P_TYPE_T (p_t_get_type())	// 仅在使用 g_object_new 进行对象实例化的时候使用一次，用于向 GObject 库的类型系统注册 PT 类
#define P_T(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), P_TYPE_T, PT))	// 用于将 obj 对象的类型强制转换为 P_T 类的实例结构体类型
#define P_IS_T(obj) G_TYPE_CHECK_INSTANCE_TYPE((obj), P_TYPE_T)) // 用于判断 obj 对象的类型是否为 P_T 类的实例结构体类型
#define P_T_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), P_TYPE_T, PTClass))// 用于将 kclass 类结构体得类型强制转换为 P_T 类的类结构体类型
#define P_IS_T_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), P_TYPE_T))	// 用于判断 klass 类结构体的类型是否为 P_T 类的类结构体类型
#define P_T_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS((obj), P_TYPE_T, PTClass))	// 获取 obj 对象对应的类结构体类型
#define P_T_GET_PRIVATE(obj) (G_TYPE_INSTANCE_GET_PRIVATE((obj), P_TYPE_T, PTPrivate))	// 获取 obj 对象对应的私有数据
```



接口常用的宏（其中 P 表示项目名称	T表示类名称	I是接口的缩写）

```c
#define P_TYPE_IT (p_t_get_type())	// 仅在接口实现时使用一次，用于向 GObject 库的类型系统注册 PIT 接口
#define P_IT(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj), P_TYPE_IT, P_IT))	// 用于将 obj 对象的类型强制转换为 P_IT 接口的实例结构体类型
#define P_IS_IT(obj) (G_TYPE_CHECK_INSTANCE_TYPE((obj), P_TYPE_IT))	// 用于判断 obj 对象是否为 P_IT接口的实例结构体类型
#define P_IT_GET_INTERFACE(obj) (G_TYPE_INSTANCE_GET_INTERFACE ((obj), P_TYPE_IT, P_IT))	// 获取 obj 对象对应的 P_IT 接口的类结构体类型
```



#### GObject 的信号使用

```c
// 新建信号
guint g_signal_new (const gchar		*signal_name,
                    GType				   itype,
                    GSignalFlags	signal_flags,
                    guint           class_offset,
                    GSignalAccumulator	 		accumulator,
                    gpointer		 			accu_data,
                    GSignalCMarshaller  		c_marshaller,
                    GType               		return_type,
                    guint               		n_params,
                    ...);

// 连接信号和回调函数
#define g_signal_connect(instance, detailed_signal, c_handler, data) \
    g_signal_connect_data ((instance), (detailed_signal), (c_handler), (data), NULL, (GConnectFlags) 0)
gulong g_signal_connect_data (gpointer	instance, const gchar	*detailed_signal,
                              GCallback	  			c_handler,
                              gpointer		  			 data,
                              GClosureNotify	 destroy_data,
                              GConnectFlags	  	 connect_flags);

// 发射信号
void g_signal_emit_by_name (gpointer	instance, const gchar	*detailed_signal, ...);
```

信号编程步骤如下：

- 注册信号，信号是依附于对象的，所以注册信号是在 class_init 函数中完成的
- 编写槽函数，在信号发出时调用该槽函数
- 通过 `g_connnect_signal` 连接信号和槽
- 发射信号



信号处理函数（槽函数）有两个参数：

- 信号所属的实例
- 指向信号连接时给出用户数据指针



### GCoroutine

`GCoroutine` 并非是GLib里的一部分，它是在 `spice-gtk` 中实现的！



## GTK

##### GTK组件：

GTK —— 图形界面的工具包

GDK —— 窗口系统的底层抽象

GSK —— 底层场景图和3D渲染API

Pango —— 支持Unicode国际文本渲染

Cairo —— 基于矢量的高质量2D图形渲染

ATK —— 复制工具包，用于实现对屏幕阅读器和其他工具的支持（仅限GTK3）

原文如下：

> - [GTK](https://docs.gtk.org/gtk4/) — Widget toolkit for graphical interfaces
> - [GDK](https://docs.gtk.org/gdk4/) — Low-level abstraction for the windowing system
> - [GSK](https://docs.gtk.org/gsk4/) — Low-level scene graph and 3D rendering API
> - [Pango](https://docs.gtk.org/Pango/) — International text rendering with full Unicode support
> - [Cairo](https://www.cairographics.org/manual/) — 2D, vector-based drawing for high-quality graphics
> - [ATK](https://docs.gtk.org/atk/) — Accessibility toolkit to implement support for screen readers and other tools (GTK3 only)





**GtkApplication**

用于处理GTK+初始化、应用程序唯一性、会话管理，通过导出操作和菜单提供一些基本的脚本能力和桌面shell集成，并管理一个顶级窗口列表，其生命周期自动绑定到应用程序的生命周期。



**GtkWindow**

一个 **GtkWindow** 是一个可以包含其他控件的顶级窗口，窗口通常在桌面系统下具有样式。并且允许用户放缩、移动或者关闭窗体等操作。



```c
// 显示窗体
void gtk_window_present (GtkWindow* window)
```









