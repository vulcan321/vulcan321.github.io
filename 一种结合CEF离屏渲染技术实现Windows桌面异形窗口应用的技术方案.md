# 一种结合CEF离屏渲染技术实现Windows桌面异形窗口应用的技术方案

  

# 1\. 缩略语和关键术语定义

异形窗口应用：由用户自定义窗口形状、颜色、透明度的桌面应用

像素：图像元素，表示图像中最小的可视化单元。

位图 (bitmap)：由像素组成的图片

RGBA：表示色彩空间的一种编码格式，RGBA分别代表Red（[红色](http://baike.baidu.com/view/23521.htm)） Green（[绿色](http://baike.baidu.com/view/23550.htm)） Blue（[蓝色](http://baike.baidu.com/view/23418.htm)）和 Alpha(不透明度），一个RGBA值表示了一个像素的可视属性。

Alpha值：位图中表示像素不透明度参数

API: 应用开发接口

CEF（Chromium Embedded Framework）：基于chromium开发的嵌入式浏览器框架。目前有CEF1和CEF3两个版本，CEF3基于chromium content api开发。CEF遵从BSDL开源协议。

Chromium content api：是chromium团队为chrome及其它嵌入式框架开发者提供的稳定的接口，content api隐藏了content内部的复杂逻辑。

GDI/GDI+：GDI是Graphics Device Interface的缩写，含义是图形设备接口，它的主要任务是负责系统与绘图程序之间的信息交换，处理所有Windows程序的图形输出。GDI+是GDI功能扩展。

离屏渲染（Off Screen Rendering）：浏览器引擎将html/css/js内容渲染成位图并输出到内存的过程。

屏幕渲染（Screen Rendering）：浏览器引擎将html/css/js内容渲染后直接输出到屏幕过程。

# 2. 相关技术背景

## 2.1 相关技术点一：

微软Windows系统上现有异形窗口应用，以往比较常见有媒体播放器，时钟，杀毒软件图标等（如下图），底层都基于Layered windows技术实现的，该技术是微软公司在Windows 2000及后续版本上提供的一种实现异形窗口的技术方案，主要由SetLayeredWindowAttributes , UpdateLayeredWindow两个api提供支持。 

  ![](https://nos.netease.com/cloud-website-bucket/20181026111122b9aa2df6-c096-4737-8124-d30656ff2eb3.jpg)

  

![](https://nos.netease.com/cloud-website-bucket/20181026111122a0e70688-1966-4d93-97b8-95a9ded78c56.png)

  

![](https://nos.netease.com/cloud-website-bucket/20181026111123fb900f8c-7915-433c-a134-e208b005d10d.png)

Layered windows技术的主要特点：

1. 允许窗口像素点的alpha值与屏幕像素点alpha值混合。

2. 窗口像素点alpha值为0（全透明）时，鼠标可以穿越当前窗口被下一层窗口捕获。

正是这两个特性为开发形态丰富的异形窗口提供了可能。 

Layered windows实现异形窗口的两个关键步骤：

1. 创建（CreateWindowEx）或更改窗口（SetWindowLongPtr）使其扩展属性包含WS\_EX\_LAYERED；

2. 根据窗口外观需求选择API（UpdateLayeredWindow或SetLayeredWindowAttributes）并完成窗口绘制，基本流程如下图：

![](https://nos.netease.com/cloud-website-bucket/20181026111142cfe7b45b-cc17-413f-9b7d-dd160b094d66.jpg)  

1）

```
BOOL WINAPI SetLayeredWindowAttributes(
  _In_  HWND hwnd,
  _In_  COLORREF crKey,
  _In_  BYTE bAlpha,
  _In_  DWORD dwFlags
);
```

通过该API，用户可以绘制产生以下三种外观窗口：

  

1. 窗口像素集只有一个alpha值；（贴图）

2. 窗口像素集有两个alpha值，0（全透明），255（不透明）；（贴图）  

3. 窗口像素集有三个alpha值；（贴图）

  

2）

```
BOOL WINAPI UpdateLayeredWindow(
  _In_    HWND hwnd,
  _In_opt_  HDC hdcDst,
  _In_opt_  POINT *pptDst,
  _In_opt_  SIZE *psize,
  _In_opt_  HDC hdcSrc,
  _In_opt_  POINT *pptSrc,
  _In_      COLORREF crKey,
  _In_opt_  BLENDFUNCTION *pblend,
  _In_      DWORD dwFlags
);
```

该API可以由位图产生相应外观的窗口，窗口每个像素点跟位图一样可以有各自的Alpha值。（贴图）

在具体应用实现中，根据要实现异形窗口的不同，可以选择采用以上其中之一API实现，在下面的“现有技术”一章中将有详细描述。

  

## 2.2 相关技术点二： 

本方案依赖的第二项关键技术是提供了离屏渲染能力的嵌入式浏览器开发框架CEF。CEF提供两种渲染方案，屏幕渲染时，它会将html/css/js+data内容渲染并直接输出到窗口，同时也能接收鼠标、键盘等事件；离屏渲染时，它可以将html/css/js+data渲染成位图并输出到内存，且提供了接收鼠标/键盘等事件的接口，窗口程序程序可以将捕获事件通过这些接口转发给CEF来触发页面响应鼠标/键盘事件行为。

本方案将以上两项技术方案结合，由CEF离屏渲染技术绘制位图，由layered windows异形窗口方案实现输出，并将layered windows捕获的鼠标、键盘事件经过处理后交给CEF处理，实现外观复杂、动态的异形窗口应用。

## 2.3 与异形窗口相关的现有技术方案及其缺点

### 2.3.1 技术方案一

现有外观复杂的异形窗口应用，一般都是创建Layered windows窗口，然后由UpdateLayeredWindow API将位图输出到屏幕生成的，这个方案中关键是位图的获取。传统的获取位图方式有两种：

1. 如果该应用只有固定一种或几种外观（比如媒体播放器、杀毒软件图标等），一般在在程序生成前通过绘图工具（如photoshop等）绘制获得，程序运行时直接加载或者根据用户操作加载位图即可。

2. 如果该应用外观跟实时数据相关（比如电子时钟、股票实时走势、天气预报等），或者该应用有复杂用户操作响应模式，则需要在程序运行时通过GDI/GDI+/Direct3D等图形绘制接口绘制成位图后加载。

上述方案的缺点

上述技术方案中生成位图的两种方法对程序开发和维护来说均存在较多缺点：

1. 程序生成前绘制位图的方法显然存在如下问题：

1). 位图数量始终有限，交互形式单一。一般只适合于界面单一，对视觉和交互要求不高的桌面应用。比如上面提到的传统的播放器面板，杀毒软件桌面图标等。

2). 无法根据实时数据生成位图，比如曲线图、柱状图、饼图等统计类型图片

3). 窗口外观一般只能由本地程序控制

2. 程序运行时由程序绘制，遇到如下问题：

1). 绘制过程非常复杂。

2). 程序绘图模型在程序生成后无法新增或者变更，除非升级程序。

3). 相比html/js/css，缺乏成熟的开源的数据可视化解决方案。

4). 窗口外观一般只能由本地程序控制。

### 2.3.2 技术方案二

采用CEF屏幕渲染的模式将html/css/js+data渲染生成的内容直接输出到Layered windows窗口，并通过SetLayeredWindowAttributes API实现异形窗口输出。

上述方案的缺点

上述方案受限于SetLayeredWindowAttributes API能力，存在如下问题：

1. 当要产生不规则形状时，必须有一种颜色用于识别色，html/css/html开发受到限制。

2. 窗口像素点最多只能有三个alpha值，无法展现透明度渐变效果（比如阴影），表现形式受限。

3. 当需要输出形状极其复杂的窗口时（比如直接输出文字），边缘锯齿残留非常明显，表现效果差。(贴图)

# 3\. 本技术方案的详细阐述

## 3.1 针对上述两项现有技术方案能解决的问题

1. 针对现有方案一，我们通过CEF离屏渲染技术，由html/css/js+data渲染生成位图。窗口程序不再负责位图绘制过程，解决位图生成问题。

1). 根据内容生成位图（比如生成数据曲线图、柱状图、饼图），位图数量不受限，并能确保数据实时性。

2). 根据用户操作生成位图（html/css/js天然属性），交互形式丰富。

3). CEF支持html5，有丰富的数据可视化方案(如Flotr,chartjs等), 大大降低数据可视化技术难度。

4). 可以将html/css/js+data部署到http服务器端，采用典型BS架构，完全由http服务器端控制本地应用的外观。

2. 针对现有方案二的三个问题，属于SetLayeredWindowAttributes接口的能力问题，改用UpdateLayerWindow方案可以解决。

## 3.2 技术方案介绍

1\. CEF离屏渲染生成屏幕异形窗口的原理图：

![](https://nos.netease.com/cloud-website-bucket/201810261111596dd0f7cb-50fc-4d75-82b3-94e8568cb261.png)  

2. 异形窗口输出的数据流图：

![](https://nos.netease.com/cloud-website-bucket/2018102611120944d48d81-b236-484c-871b-31ab816dfc3e.png)

html/css/js+data即可以存放在本地，也可以放到远端http server上（或者可将html/css/js保存在本地，data则从远端获取，通过这种灵活部署方案，产生以往异形窗口应用达不到的视觉和交互效果），通过CEF解析和渲染后生成位图数据输出到内存，然后根据位图数据生成位图，再交由Layered windows输出。Layered windows程序则捕获用户输入事件，我们对事件进行预处理后转发给CEF，形成一个响应循环。具体的实现步骤请参考3.2.2章节。

### 3.2.1技术方案实现效果

1. 可以生成任意外观的和复杂交互效果的窗口应用，比如下面这个桌面歌词窗口，有如下特点

1）桌面显示纯文字且有有动画效果

2）鼠标移动文字上时，窗口出现透明背景，窗口边缘有渐变阴影，按住鼠标可拖动窗口。

![](https://nos.netease.com/cloud-website-bucket/2018102611122213a7cd47-9215-4e00-ba8a-0becdade2b61.gif)

其实这里所有的显示效果均有网页端实现，如下附件解压出来的html可以直接在chrome浏览器中打开运行，通过本文所述方案加载该页面形成如上应用效果。

[lrc demo.rar](http://nos.netease.com/knowledge/95e7f190-8008-4d95-a317-8a28e5305b79?download=lrc%20demo.rar)

2. 根据内容或用户操作产生异形窗口，比如下述曲线图，柱状图，饼图等, 用户操作鼠标和键盘时，异形窗口区域能像普通窗口正常响应。 

![](https://nos.netease.com/cloud-website-bucket/20181026111235d5571080-c513-445c-89c5-46518af32f6e.png)

  

![](https://nos.netease.com/cloud-website-bucket/201810261112469aed5344-86f2-4e52-80ae-625097080699.png)

  

![](https://nos.netease.com/cloud-website-bucket/20181026111301d6c2d0f2-4803-4741-aa34-9b2f7c04b6f9.png)

  

![](https://nos.netease.com/cloud-website-bucket/201810261113014818b860-579f-434b-adde-99f0a69f06f4.png)

3. 由服务器控制客户端窗口形状

CEF通过http请求从http server加载html/css/js+data方式,可以将窗口外观部署在服务器端。

### 3.2.2 如何实现本技术方案

通过CEF生成异形窗口的实现流程如下：

1. 初始化CEF

2\. OsrBrowser::Create创建实例，并创建Layeredwindow和OsrClientHandler两个实例，并已这两个实例为参数，通过调用CefBrowserHost::CreateBrowser（CefBrowserHost::CreateBrowserSync）创建离屏渲染浏览器

3\. CEF回调CefRenderHanlder：：OnPaint接口，输出由html/css/js渲染生成的位图数据，OsrClientHandler重载OnPaint并实现如下两个功能：

1） 调用OsrBitmap::GetHBITMAP根据位图数据生成位图并返回位图的HBITMAP

2） 调用LayeredWindow实例updateWindow方法将位图输出到屏幕

4\. LayeredWindow通过注册的WndProc回调函数捕获鼠标/键盘事件，并通过CefBrowserHost实例的[SendKeyEvent](http://magpcss.org/ceforum/apidocs3/projects/(default)/CefBrowserHost.html#SendKeyEvent(constCefKeyEvent&))，[SendMouseClickEvent](http://magpcss.org/ceforum/apidocs3/projects/(default)/CefBrowserHost.html#SendMouseClickEvent(constCefMouseEvent&,MouseButtonType,bool,int))等方法将事件通知给CEF

5\. CEF对事件进行响应后回调CefRenderHanlder：：OnPaint接口输出新位图（即返回第3步） 

下面是该方案实现的关键类图：

![](https://nos.netease.com/cloud-website-bucket/20181026111329bef1e97c-a68d-420a-a204-207722740204.png)  

## 3.3 本技术方案带来的有益效果

1. 丰富了windows窗口应用的外观和交互形态。

2. 可以将应用数据或外观同时部署在远端服务器上。

3. 大幅提高异形窗口应用的开发效率并显著降低开发成本。

# 4. 方案关键技术总结

1\. CEF离屏渲染技术和Layered windows异形窗口技术的组合产生异形窗口的方案。具体描述为：CEF浏览器在离屏渲染模式下将html/css/js渲染生成位图，再将位图通过Layered windows（UpdateLayeredWindow API）技术输出到屏幕实现异形窗口技术方案。

2\. Layered Windows窗口将捕获的鼠标/键盘等事件经处理后（识别和过滤）通过转发给CEF开放的API以响应用户操作的过程。

# 5. 附件：

参考文献（如专利/论文/标准等）

[http://msdn.microsoft.com/en-us/library/ms997507.aspx](http://msdn.microsoft.com/en-us/library/ms997507.aspx)

[https://code.google.com/p/chromiumembedded/wiki/GeneralUsage](https://code.google.com/p/chromiumembedded/wiki/GeneralUsage)