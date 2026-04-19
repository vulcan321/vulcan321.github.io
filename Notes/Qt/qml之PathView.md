## **QML之PathView使用和理解**

通过学习委托，涉及到 **ListView**、**GridView**、**PathView**等等；其中 **PathView** 的画风明显和 **ListView** 和 **GridView** 不一样，它的使用方式比较复杂，当然实现的效果真的很棒。那什么是 **PathView** 呢？



## PathView的定义

首先先看 **Qt** 对**PathView**的描述如下：

```English
// 摘自 Qt Quick 5.12.2
A PathView displays data from models created from built-in QML types like ListModel and XmlListModel, or custom model classes defined in C++ that inherit from QAbstractListModel.
The view has a model, which defines the data to be displayed, and a delegate, which defines how the data should be displayed. The delegate is instantiated for each item on the path. The items may be flicked to move them along the path.
```

这段描述比较轻描淡写，但它得作用类似 **ListView** 和 **GridView** 都是给 **item** 进行布局，但是不同于 **ListView** 列表形式的布局和 **GirdView** 栅格布局这种有规律描述布局，**PathView** 是根据用户提供路径， 将**item**按这个路径进行排布，比如：实现**item** 按照规则的曲线排布，这种排布方式是无规则的并不能通过一个统一的公式计算出**item**的分布。但**PathView** 可以实现类似的效果！通过自定义自己的路线组，让**item**按自定义的路径进行分布！



## PathView的使用

代码如下：

```qml
Component {
	id: delegate_1
	Column {
		id: wrapper
		opacity: PathView.isCurrentItem ? 1 : 0.5
		Text {
			id: nameText
			text: name
			font.pointSize: 16
		}
	}
}

ListModel {
	id: list_model
	ListElement {
		name: "Bill Jones"
	}
	ListElement {
		name: "Jane Doe"
	}
	ListElement {
		name: "John Smith"
	}
	ListElement {
		name: "John Smith"
	}
}

PathView {
	anchors.fill: parent
	model: list_model
	delegate: delegate_1
	// PathView 通过给予 path 属性自定义路径, 让 item 按 Path{} 定义路径分布
	path: Path{
		startX: 200; startY: 100	// 路径得起点 (200, 100)
		PathLine { relativeX: 200; relativeY: 200 }	// 从起点到 (200 + relativeX, 100, relativeY) 的直线
		PathPercent { value: 0.5 }	// 设置前一个路径上可以分布多少比例的item 数量
		PathLine { relativeX: 200; relativeY: -200 } // 以上一条路径的终点为起点开始的一条路径
	}
}
```

可以看到，**PathView** 通过给予 **path** 属性自定义路径, 让 **item** 按 **Path{}** 定义路径分布。Path{} 提供了多个描述路径对象，如下图：

![image-01](https://raw.githubusercontent.com/mingxingren/Notes/master/resource/photo/image-2021062701.png)



#### PathLine使用

**PathLine** 顾名思义描述一条直线路径，其起点是上一条路径终点。
