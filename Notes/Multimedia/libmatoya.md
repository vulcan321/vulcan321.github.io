### libmatoya介绍

`libmatoya`是一个跨平台应用开发库，侧重于渲染。其渲染方式支持`opengl`、`Direct3D`、`Metal`等。我在Fedora下测试其多线程 `opengl`方式渲染，图片尺寸为2560x1440像素，平均每帧渲染耗时为16ms，非常nice



### MTY_App

`MTY_App` 是整个库核心组件，在我看来它负责了整个渲染和事件。创建、开启事件循环、销毁的代码如下：

```c
MTY_EXPORT MTY_App *
MTY_AppCreate(MTY_AppFunc appFunc, MTY_EventFunc eventFunc, void *opaque);

MTY_EXPORT void
MTY_AppRun(MTY_App *ctx);

MTY_EXPORT void
MTY_AppDestroy(MTY_App **app);
```

在使用 MTY_APP 给 MTY_Window 渲染时，涉及方法如下：

```c
MTY_EXPORT bool
MTY_WindowMakeCurrent(MTY_App *app, MTY_Window window, bool current);

MTY_EXPORT void
MTY_WindowDrawQuad(MTY_App *app, MTY_Window window, const void *image, const MTY_RenderDesc *desc);

MTY_EXPORT void
MTY_WindowPresent(MTY_App *app, MTY_Window window, uint32_t numFrames);
```

其使用流程为：`MTY_WindowMakeCurrent`指定`MTY_APP`当前要渲染的界面，假设`app`有两个窗体 A 和 B，最后一个调用 `MTY_WindowMakeCurrent` 并传参 `current=true` 的窗体才是真正要被渲染的窗体，其他的窗体的渲染将被屏蔽。`MTY_WindowDrawQuad` 和 `MTY_WindowPresent`配合使用，先将帧数据推入队列然后渲染。