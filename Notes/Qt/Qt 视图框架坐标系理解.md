## Qt 视图框架坐标系理解

**Qt** 视图框架分为三个部分: 视图(**view**)、场景(**scene**)、图元(**item**)。 首先我们需要先理解这三者关系， 如果把场景(**scene**)比喻成一栋房子外的景色；那么图元(**item**)就是房子外边景色的树、小河等物体；视图(**view**) 则是我们看景色的窗户。

先让我们看一个简单的代码:

```c++
QGraphicsScene scene;
scene.addText("Hello, world!");

QGraphicsView view(&scene);
view.show();
```

这是 Qt 官方文档一个例子, 该代码只是创建了**view**、**scene** 和 一个文本的**item**。运行结果就是窗口中央显示 **Hello world**。此时你可能会产生质疑为什么 **Hello world** 为什么会显示在窗口中央？这需要了解 **view**、**scene**、**item**的坐标之间的关系。



### 一、view的坐标

**view**的坐标系和普通**QWidget** 的坐标系一样，原点都是在控件的左上角。如下图：

![image-01](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2021052301.png)



注意在 **view** 初始化的时候，**view**控件的中心(此处并非是原点！)会和 **scene** 的中心(此处也并非是原点！)重合。



### 二、Scene的坐标

**Scene**的坐标系统相比**view**就很灵活了，这取决于Scene对自己的设置坐标范围 (**QGraphicsScene::setSceneRect**)。坐标原点是否在**Scene**的中心取决于设置的区域是否是关于原点(**0，0)**对称；例如: **QGraphicsScene::setSceneRect(-400, -400, 800, 800);** 该设置就会让**Scene**的原点处于坐标区域的中心！



### 三、Item的坐标

首先我们需要讲清楚一下**Item**的在**Scene**的坐标，**item** 的**Scene**的锚点是**item**自己的坐标系的原点**(0,0)**！可以这样理解，**item**处于**Scene** 上，所以**item**上的任何点都能被**Scene**的某个点所描述，所以 **Qt** 选择让**item**自己的坐标系原点作为**Scene**描述**item**的位置。

而**item** 本身坐标系其实和**Scene**类似，原点是否处于**item**的中心取决于设置**item**坐标区域是否关于原点对称。**item**上的点坐标想要转换成**Scene**的坐标可以使用 **QGraphicsItem::mapToScene**转换。当然根据**item**的原点和**Scene**坐标关系，可以让**item** 上点坐标 + **item**的原点在**Scene**上做坐标得出 **item**上的点在**Scene**上的坐标

