## How Flutter?

#### 运行机制

Flutter 应用运行在一个用 C++ 写的引擎中，Flutter 应用可以看做是一个游戏 App，代码都是在引擎中运行。

###### Android

-   引擎的C或C++代码是由Android NDK编译的，而框架的主要代码和应用的代码由Dart compiler编译成native code执行的。
    
-   对于Android应用来说，Flutter框架在引擎中实现了一个继承于SurfaceView的 FlutterView。用户所看到的UI都是在这个SurfaceView中显示。如果要和原生平台功能交互，则可以在Activity中使用FlutterView，并通过Flutter提供的消息API和原生平台收发消息。
    

###### ios

-   引擎的C或C++代码是由LLVM编译的，而所有Dart的代码会被AOT编译成native code，整个APP运行时使用的是机器指令（并不是拦截器）。

#### 系统架构

![](https://www.jianshu.com//upload-images.jianshu.io/upload_images/1216032-3490b45f2a8683af.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

层次结构.png

-   Flutter Framework: 这是一个纯 Dart实现的 SDK，类似于 React在 JavaScript中的作用。它实现了一套基础库， 用于处理动画、绘图和手势。并且基于绘图封装了一套 UI组件库，然后根据 Material 和Cupertino两种视觉风格区分开来。这个纯 Dart实现的 SDK被封装为了一个叫作 dart:ui的 Dart库。我们在使用 Flutter写 App的时候，直接导入这个库即可使用组件等功能。
    
-   Flutter Engine: 这是一个纯 C++实现的 SDK，其中囊括了 Skia引擎、Dart运行时、文字排版引擎等。不过说白了，它就是 Dart的一个运行时，它可以以 JIT、JIT Snapshot 或者 AOT的模式运行 Dart代码。在代码调用 dart:ui库时，提供 dart:ui库中 Native Binding 实现。 不过别忘了，这个运行时还控制着 VSync信号的传递、GPU数据的填充等，并且还负责把客户端的事件传递到运行时中的代码。
    
      
    
    ![](https://www.jianshu.com//upload-images.jianshu.io/upload_images/1216032-060d5326a50f34db.png?imageMogr2/auto-orient/strip|imageView2/2/w/975/format/webp)
    
    Flutter图形管道.png
    
-   整个 Flutter Engine可以粗略地划分为三个部分：Dart UI、Runtime、Shell
    
      
    
    ![](https://www.jianshu.com//upload-images.jianshu.io/upload_images/1216032-a8bd1142db3d7335.png?imageMogr2/auto-orient/strip|imageView2/2/w/1080/format/webp)
    
    Runtime.png
    

![](https://www.jianshu.com//upload-images.jianshu.io/upload_images/1216032-601901453d9d59c9.png?imageMogr2/auto-orient/strip|imageView2/2/w/982/format/webp)

Flutter渲染管道.png

  

![](https://www.jianshu.com//upload-images.jianshu.io/upload_images/1216032-8af06f4f06af1aa1.png?imageMogr2/auto-orient/strip|imageView2/2/w/892/format/webp)

控件生命周期.png

  

![](https://www.jianshu.com//upload-images.jianshu.io/upload_images/1216032-e6eb3715a0c148f0.png?imageMogr2/auto-orient/strip|imageView2/2/w/894/format/webp)

状态生命周期.png

#### 绘制流程

###### 入口

-   界面的布局和绘制在每一帧都在发生着，甚至界面没有变化，它也会存在；可以想象每一帧里面，引擎都像流水线的一样重复着几个过程：build（构建控件树），layout（布局）, paint（绘制）和 composite（合成），周而复始。驱动整个流水线的入口是WidgetBinding.drawFrame方法。

```java
 void drawFrame() {
    ...
    try {
      if (renderViewElement != null)
        buildOwner.buildScope(renderViewElement);
      super.drawFrame();
      buildOwner.finalizeTree();
    } finally {
     ...
    }
    ...
  } 
```

###### 布局约束

-   根据parent给予的约束条件来计算size，而设置size只能在performResize或者performLayout中进行，如果设置sizedByParent为true，则只能在performResize中进行，否则就只能在performLayout中与child的布局同时进行。

###### Layer层

![](https://www.jianshu.com//upload-images.jianshu.io/upload_images/1216032-5df13f5b4a74d07b.png?imageMogr2/auto-orient/strip|imageView2/2/w/800/format/webp)

Flutter Layer.png

## Read More

-   [Flutter官网](https://flutter.io/)
-   [Dart官网](https://www.dartlang.org/)
-   [安装Flutter](https://7449.github.io/2018/03/19/Android_Flutter_2)
-   [LittleKernel GitHub](https://github.com/littlekernel/lk)
-   [Fuchsia GitHub](https://github.com/fuchsia-mirror)
-   [Flutter中文网](https://flutterchina.club/)