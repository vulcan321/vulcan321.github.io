# VC++技术内幕(第四版)笔记--SetWindowExt和SetViewportExt


```c++
CRect rectClient;
GetClientRect(rectClient);
pDC->SetMapMode(MM\_ANISOTROPIC);
pDC->SetWindowExt(CSize(1000,1000));
pDC->SetViewportExt(rectClient.right,-rectClient.bottom);
pDC->SetViewportOrg(rectClient.right/2,rectClient.bottom/2);
pDC->Ellipse(-500,-500,500,500);
```
可变比例映射模式，看到这一段的时候，一开始就把我的弄糊涂了。我一直没弄明白中间加红的几行代码是什么意思。把其注释掉，又没有原先的效果。在网上百度了半天。得出以下注释说明：

//SetWindowExe设定窗口尺寸，SetViewportExt设定视口尺寸。

//窗口尺寸以逻辑单位计算，视口尺寸以物理单位计算。
```c++
CRect rectClient;

GetClientRect(rectClient);//取窗口物理尺寸（单位：像素）

pDC->SetMapMode(MM\_ANISOTROPIC);

//窗口逻辑大小：1000\*1000,
pDC->SetWindowExt(1000, 1000);

//改变Y坐标方向\--viewport使用物理大小
pDC->SetViewportExt(rectClient.right, -rectClient.bottom);

//设置窗口中心点为坐标系原点\--Viewport使用物理大小
pDC->SetViewportOrg(rectClient.right / 2, rectClient.bottom / 2);
  
//以逻辑单位画图\---普通GDI API使用逻辑单位
pDC->Ellipse(CRect(-500, -500, 500, 500));

//默认方式下，物理/逻辑值是1：1关系，可换用。但使用SetWindowExt/SetViewportExt后两者不可混用。
```
以上红色部分，我的解释是以物理的原点为坐标系，以逻辑的大小为单位画圆。后面的代码中会说明这一问题。

后来经过自己的捉摸，我想我终于搞清楚是怎么一回事情了。

所谓映射就是物理和逻辑的映射。使用GetClientRect方法后，获取到窗口的物理大小；然后再使用SetWindowExt，设置了窗口的逻辑大小，与之相对应的是SetViewportExt，也就是说在这里作了一个映射。SetWindowExt中的第一个参数

cx Specifies the x-extent (in logical units) of the window.

X宽度（可以这么理解吗？）与 SetViewportExt中的第一个参数

Cx Specifies the x-extent of the viewport (in device units).

相对应起来。好像中学的比例一样。逻辑宽度和物理宽度映射，逻辑高度和物理高度映射。这样，一旦映射关系确立之后，再使用后面的方法进一步的操作。

一开始的代码是在窗口中显示一个与之限定的圆，并且会随着窗口大小的改变亦会跟着改变。

我现在稍稍把其中的参数改变一下。
```c++
CRect rectClient;
GetClientRect(rectClient);
pDC->SetMapMode(MM\_ANISOTROPIC);
pDC->SetWindowExt(CSize(800,800));
pDC->SetViewportExt(rectClient.right,-rectClient.bottom);
pDC->SetViewportOrg(rectClient.right/2,rectClient.bottom/2);
pDC->Ellipse(-500,-500,500,500);
```
注意上面红色突出显示的代码。我现在将逻辑大小变小了一些。现在注意一下实际在画图的代码中（绿色显示），我并没有修改其参数。现在将其编译运行。会发现，实现中的圆的轨迹会超出窗口。

只是把物理与逻辑之前的映射调整了一下。
```c++
CRect rectClient;
GetClientRect(rectClient);
pDC->SetMapMode(MM\_ANISOTROPIC);
pDC->SetWindowExt(CSize(1000,1000));
pDC->SetViewportExt(rectClient.right,-rectClient.bottom);
pDC->SetViewportOrg(rectClient.right/2,rectClient.bottom/2);
pDC->Ellipse(0,0,500,500);
```
再调整一下参数，画出来的图你会发现，真正的成了二维坐标图。

经过以上一番测试，我想我应该明白每行代码的意思了。转换成自己的注释，应该更容易理解和记忆些。
```c++
CRect rectClient;
GetClientRect(rectClient); //获取物理设备大小
pDC->SetMapMode(MM\_ANISOTROPIC); //设置映射模式
pDC->SetWindowExt(CSize(1000,1000));    //设备逻辑窗口大小（可能与物理窗口大小不一样）
pDC->SetViewportExt(rectClient.right,-rectClient.bottom); //设置物理设备范围，为设定圆点作准备
pDC->SetViewportOrg(rectClient.right/2,rectClient.bottom/2); //设置物理设备坐标原点，当然是在上一行代码的基础之上
pDC->Ellipse(-500,-500,500,500); //以物理设置坐标原点为基础，以逻辑为单位，画圆。
```
 

可以改造一下，原来的代码，使之后容易理解一些：
```c++
CRect rectClient;
GetClientRect(rectClient);
pDC->SetMapMode(MM\_ANISOTROPIC);
pDC->SetWindowExt(CSize(1000,1000));
pDC->SetViewportExt(rectClient.right,-rectClient.bottom);
pDC->SetViewportOrg(rectClient.left,rectClient.bottom); //设置窗口左下角为原点坐标
pDC->Ellipse(0,0,1000,1000);
```