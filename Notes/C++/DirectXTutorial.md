## DirectX11 Tutorial

### 渲染Yuv纹理流程

```flow
start=>start: 开始
op1=>operation: 创建 D3D11Device
op2=>operation: 创建 D3D11Swapchain
op3=>operation: 创建纹理 D3D11Texture
op4=>operation: 创建 ID3D11ShaderResourceView
op5=>operation: 创建渲染目标视图 CreateRenderTargetView
op6=>operation: 将渲染目标视图绑定到渲染管线 OMSetRenderTargets
op7=>operation: 创建 shader 字节码
op8=>operation: 创建 Vertex shader 对象 CreateVertexShader
op9=>operation: 创建 输入布局 CreateInputLayout
op10=>operation: 创建 Pixel shader 对象 CreatePixelShader
end=>end: 结束

start->op1->op2->op3->op4->op5->op6->op7->op9->op10->end
```





### 1. Direct3D初始化: 创建ID3D11Device、ID3D11DeviceContext、IDXGISwapChain

```中文
ID3D11Device: 显示适配器, 用于创建资源, 常用资源有: 资源类(ID3D11Resource 包括纹理和缓冲区), 视图类以及着色器. 还可以检测系统环境对功能支持

ID3D11DeviceContext: D3D设备上下文, 可以看做是一个渲染管线. 渲染管线主要负责渲染和计算工作, 它需要绑定来自与它关联的ID3D11Device所创建的各种资源、视图和着色器才能正常运转, 初次之外，它还能够负责对资源的直接读写操作

IDXGISwapChain: DXGI交换链, 缓存一个或多个表面(2D纹理), 它们都可以称为后备缓冲(backbuffer)的离屏纹理. 前台缓冲区(front buffer)为当前显示在屏幕上的帧.后备缓冲区是我们主要进行渲染的场所. 这些后备缓冲区通过合适的手段成为渲染管线的输出对象. 呈现(Present)有两种方法:
① BitBlt Model(位块传输模型): 将后备缓冲区的数据进行BitBlt(位块传输, 即内容上的拷贝), 传入到DWM(桌面窗口管理器)与DX共享的后备缓冲, 然后进行翻转以显示其内容. 使用这种模型至少需要一个后备缓冲区。这时Win32应用程序最常用使用的方式, 在进行呈现后, 渲染管线仍然是对同一个后备缓冲区进行输出(支持Windows7 及 更高版本)
② Flip Model(翻转模型): 该模型可以避免上一种方式多余复制, 后备缓冲区表面可以直接与DWM内的前台缓冲区进行翻转. 但是需要创建至少两个后备缓冲区, 并且每次完成呈现后通过代码切换到另一个后备缓冲区进行渲染. 该模型可以用于Win32应用程序已经UWP应用程序(需要DX1.2, 支持Window8 及 更高版本)
```



```C++
// 创建显示适配器和用于渲染的IDXGISwapChain
/**
  * param pAdapter 视频适配器指针, 传递NULL以使用默认适配器(为IDXGIFactory1::EnumAdapters枚举的第一个适配器)
  * param DriverType 需要什么类型的驱动设备, 一般指 D3D_DRIVER_TYPE_HARDWARE 
  * param Software 用于支持软件光栅化设备, 参数总是设定为NULL, 因为我们使用 D3D_DRIVER_TYPE_HARDWARE 类型即硬件渲染, 若使用此功能需要安装一个软件光栅化设备
  * param Flags 设备创建标志, 当以release模式生成程序时，该参数通常设为0（无附加标志值）；当以debug模式生成程序时，该参数应设为：D3D11_CREATE_DEVICE_DEBUG用以激活调试层
  * param pFeatureLevels 指向 D3D_FEATURE_LEVEL 数组的指针, 默认为NULL
  * param FeatureLevels pFeatureLevels数组长度
  * param SDKVersion SDK版本, 为 D3D11_SDK_VERSION
  * param pSwapChainDesc 初始化交换链参数
  * param ppSwapChain out
  * param ppDevice out
  * param pFeatureLevel 返回设备功能支持数组中第一个元素
  * param ppImmediateContext out
 **/
HRESULT D3D11CreateDeviceAndSwapChain(
  [in, optional]  IDXGIAdapter               *pAdapter,
                  D3D_DRIVER_TYPE            DriverType,
                  HMODULE                    Software,
                  UINT                       Flags,
  [in, optional]  const D3D_FEATURE_LEVEL    *pFeatureLevels,
                  UINT                       FeatureLevels,
                  UINT                       SDKVersion,
  [in, optional]  const DXGI_SWAP_CHAIN_DESC *pSwapChainDesc,
  [out, optional] IDXGISwapChain             **ppSwapChain,
  [out, optional] ID3D11Device               **ppDevice,
  [out, optional] D3D_FEATURE_LEVEL          *pFeatureLevel,
  [out, optional] ID3D11DeviceContext        **ppImmediateContext
);
```



#### DXGI交换链与Direct3D设备的交互

① 获取交换链后备缓冲区 **ID3D11Texture2D** 接口对象

② 为后备缓冲区创建一个**ID3D11RenderTargetView**

③ 通过**ID3D11Device**创建一个**ID3D11Texture2D**用作深度/模板缓冲区, 要求与后备缓冲区等宽高

④ 创建深度/模板视图 **ID3D11DepthStrenilView**, 绑定上步创建的2D纹理

⑤ 通过**ID3D11DeviceContext**, 在渲染管线的输出合并阶段设置渲染目标

⑥ 在渲染管线的光栅化阶段设置好渲染的视图区域

![image-01](https://github.com/mingxingren/Notes/raw/master/resource/photo/image-2022031601.png)



### 2. IDXGISwapChain 创建 ID3D11Texture2D

```C++
/**
 * 返回交换链得后台缓冲
 * param Buffer 从零开始缓冲区, 缓冲区数量由 DXGI_SWAP_CHAIN_DESC.BufferCount 指定
 * param riid in
 * param ppSurface out
**/
HRESULT GetBuffer(
        UINT   Buffer,
  [in]  REFIID riid,
  [out] void   **ppSurface
);
```



### 3.ID3D11Device::CreateRenderTargetView 创建渲染目标视图

```cpp
/**
 * 创建用于访问资源数据的渲染目标视图
 * param ID3D12Resource 指定了将要作为渲染目标的资源
 * param pDesc 
 * param ppRTView out
**/
HRESULT CreateRenderTargetView(
  [in]            ID3D11Resource                      *pResource,
  [in, optional]  const D3D11_RENDER_TARGET_VIEW_DESC *pDesc,
  [out, optional] ID3D11RenderTargetView              **ppRTView
);
```



### 参考

[DirectX11 With Windows SDK -- 01 DirectX初始化](https://www.cnblogs.com/X-Jun/p/9069608.html)

