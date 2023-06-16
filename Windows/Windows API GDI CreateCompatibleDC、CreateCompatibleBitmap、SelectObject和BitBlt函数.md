# Windows API GDI(2) CreateCompatibleDC、CreateCompatibleBitmap、SelectObject和BitBlt


## CreateCompatibleDC

**说明：**

1.  The CreateCompatibleDC function creates a memory device context(DC) compatible with thespecified device.
2.  “设备上下文”、“设备环境”是The Device Context的翻译。
3.  设备上下文是一种包含有关某个设备（如显示器或打印机）的绘制属性信息的 Windows 数据结构。所有绘制调用都通过设备上下文对象进行，这些对象封装了用于绘制线条、形状和文本的 Windows API。  
    设备上下文是设备无关的，所以它既可以用于绘制屏幕，也可以用于绘制打印机甚至元文件。设备上下文在内存中创建，而内存经常受到扰动，所以它的地址是不固定的。因此，一个设备上下文句柄不是直接指向设备上下文对象，而是指向另外一个跟踪设备上下文地址的指针。
4.  Windows不允许程序员直接访问硬件，它对屏幕的操作是通过环境设备,也就是DC来完成的。屏幕上的每一个窗口都对应一个DC,可以把DC想象成一个视频缓冲区，对这这个缓冲区的操作，会表现在这个缓冲区对应的屏幕窗口上。 在窗口的DC之外，可以建立自己的DC，就是说它不对应窗口，这个方法就是CreateCompatibleDC，这个DC就是一个内存缓冲区，通过这个DC你可以把和它兼容的窗口DC保存到这个DC中，就是说你可以通过它在不同的DC之间拷贝数据。例如：你先在这个DC中建立好数据，然后在拷贝到窗口的DC就是完成了这个窗口的刷新。
5.  CreateCompatibleDC创建一个与指定设备兼容的内存设备上下文环境（memory DC）。

**函数声明:**：

```cpp
HDC CreateCompatibleDC( 
HDC hdc
 );
```

**参数：**  
_hdc:_ 现有设备上下文环境的句柄，如果该句柄为NULL，该函数创建一个与应用程序的当前显示器兼容的内存设备上下文环境。

**返回值：**

1.  成功，返回内存设备上下文环境的句柄；
2.  失败，返回Null；

**备注：**

1.  memory DC创建之初，只有1\*1像素的尺寸。用memory DC进行描画操作之前，需要CreateCompatibleBitmap创建一个与屏幕显示兼容的位图，再用SelectObject将位图选入到内存显示设备中。
2.  一个memory DC被创建时，所有属性都被设置为正常的默认值。memory DC可以正常使用，也可以设置属性，Get当前属性设置、选择pens, brushes,and regions…
3.  只适用于支持光栅操作的设备，应用程序可以通过调用GetDeviceCaps函数来确定一个设备是否支持这些操作。
4.  不需要memory DC时，调用DeleteDc删除它。

## CreateCompatibleBitmap

**说明：**  
该函数创建与指定的设备环境相关的设备兼容的位图。

**函数声明：**

```cpp
HBITMAP CreateCompatibleBitmap( 
HDC hdc, 
int cx, 
int cy 
);
```

**参数：**  
_hdc:_ 现有设备上下文环境的句柄，如果该句柄为NULL，该函数创建一个与应用程序的当前显示器兼容的内存设备上下文环境。  
_cx:_ 指定位图的宽度，单位为像素。  
_cy：_ 指定位图的高度，单位为像素。

**返回值：**

1.  成功，返回的句柄（DDB)）；
2.  失败，返回Null；  
    \*这里涉及到一个概念：设备相关位图（DDB），设备无关位图（DIB）

**备注：**

1.  由CreateCompatibleBitmap创建的位图的颜色格式与由参数hdc标识的设备的颜色格式匹配。该位图可以选入任意一个与原设备兼容的memory DC中。
2.  由于memory DC允许彩色和单色两种位图。因此当指定的设备环境是memory DC时，由CreateCompatibleBitmap函数返回的位图格式不一定相同。然而为nonmemory DC创建的兼容位图通常拥有相同的颜色格式，并且使用与指定的设备环境一样的色彩调色板。  
    \*CreateCompatilbeBitmap参数中可以选择的hdc可以是memory DC或者物理设备环境，而选择的hdc会决定你所创建bitmap的颜色格式，如果你选择memory DC，若是是单色的，所创建的bitmap也是单色的；如果是彩色的，也是彩色的。选择物理设备环境，则是彩色的。
3.  x、y传入参数为0，CreateCompatibleBitmap返回1\*1像素，单色位图。
4.  If a DIB section, which is a bitmap created by the CreateDIBSection function, is selected into the devicecontext identified by the hdc parameter, CreateCompatibleBitmap creates a DIB section.
5.  不需要位图时，调用DeleteObject删除。

**小结：**

> 通常使用CreateCompatibleBitmap时候都会用到CreateCompatibleDC。而用CreateCompatibleDC的目的不是为CreateCompatibleBitmap而产生，它更多为了建立内存设备环境起一个绘图操作与显示设备之间的缓冲作用，而CreateCompatibleBitmap是为扩展内存设备环境的图像空间，值得注意的是这样创建出来的内存设备环境的图像空间尺寸是很小的，通常是1\*1像素大小，而且还是单色的，因此需要调用SelectObject函数来加载位图[bitmap](https://so.csdn.net/so/search?q=bitmap&spm=1001.2101.3001.7020)，这样加载的位图尺寸大小就相当于了内存设备环境尺寸大小。接下来才可以进行一系列绘图操作。  
> 对于CreateCompatibleBitmap函数，是为了创建与指定的设备环境相关的设备兼容的位图。有时候会觉得直接从资源里加载位图资源即可，何必直接创建呢?但有时是必要的，比如你想直接对屏幕操作，又想避免闪烁。这时候就可以Create一个内存DC，使用CreateCompatibleBitmap产生一个bitmap，然后内存DC使用SelectObject加载bitmap，这样内存中才有一个固定大小的图像空间，其次再使用bitblt把屏幕copy到内存DC中，这样子你可以在内存dc中进行各种绘图操作。当然你也可以用在内存缓冲中完成对一张图片的操作（如缩放、透明等）,也有必要create一个bitmap

## SelectObject

**说明：**  
每个设备场景都可能有选入其中的图形对象。其中包括位图、刷子、字体、画笔以及区域等等。一次选入设备场景的只能有一个对象。选定的对象会在设备场景的绘图操作中使用。例如，当前选定的画笔决定了在设备场景中描绘的线段颜色及样式

**函数声明：**

```cpp
HGDIOBJ SelectObject( 
HDC hdc, 
HGDIOBJ h 
);
```

**参数：**  
_hdc：_ 要载入的设备描述表句柄。  
_h：_ 选择要载入的对象的句柄。

> 以下函数创建有效：  
> ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201222100929464.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3pqeTExNzUwNDQyMzI=,size_16,color_FFFFFF,t_70#pic_center)

**返回值：**  
如果选择对象不是区域并且函数执行成功，那么返回值是被取代的对象的句柄，零表示出错。如选定的对象是一个区域（Region），结果就是下列常数之一：SIMPLEREGION， COMPLEXREGION 或 NULLREGION 对区域进行描述， GDI\_ERROR 表示出错

> ![在这里插入图片描述](https://img-blog.csdnimg.cn/20201222101114471.png#pic_center)

## BitBlt

**说明：**  
将一幅位图从一个设备场景复制到另一个。源和目标DC相互间必须兼容。

**函数声明：**

```cpp
BOOL BitBlt( 
HDC hdc, 
int x, 
int y, 
int cx, 
int cy, 
HDC hdcSrc, 
int x1, 
int y1, 
DWORD rop 
);
```

**参数：**  
_hdc：_ 目标设备场景  
_x,y：_ 对目标DC中目标矩形左上角位置进行描述的那个点。用目标DC的逻辑坐标表示  
_cx,cy：_ 欲传输图象的宽度和高度  
_hdcSrc：_ 源设备场景。如光栅运算未指定源，则应设为0  
_x1,y1：_ 对源DC中源矩形左上角位置进行描述的那个点。用源DC的逻辑坐标表示  
_rop：_ 传输过程要执行的光栅运算

> 下面列出了一些常见的光栅操作代码：  
> BLACKNESS：表示使用与物理调色板的索引0相关的色彩来填充目标矩形区域，（对缺省的物理调色板而言，该颜色为黑色）。  
> DSTINVERT：表示使目标矩形区域颜色取反。  
> MERGECOPY：表示使用布尔型的AND（与）操作符将源矩形区域的颜色与特定模式组合一起。  
> MERGEPAINT：通过使用布尔型的OR（或）操作符将反向的源矩形区域的颜色与目标矩形区域的颜色合并。  
> NOTSRCCOPY：将源矩形区域颜色取反，于拷贝到目标矩形区域。  
> NOTSRCERASE：使用布尔类型的OR（或）操作符组合源和目标矩形区域的颜色值，然后将合成的颜色取反。  
> PATCOPY：将特定的模式拷贝到目标位图上。  
> PATPAINT：通过使用布尔OR（或）操作符将源矩形区域取反后的颜色值与特定模式的颜色合并。然后使用OR（或）操作符将该操作的结果与目标矩形区域内的颜色合并。  
> PATINVERT：通过使用XOR（异或）操作符将源和目标矩形区域内的颜色合并。  
> SRCAND：通过使用AND（与）操作符来将源和目标矩形区域内的颜色合并。  
> SRCCOPY：将源矩形区域直接拷贝到目标矩形区域。  
> SRCERASE：通过使用AND（与）操作符将目标矩形区域颜色取反后与源矩形区域的颜色值合并。  
> SRCINVERT：通过使用布尔型的XOR（异或）操作符将源和目标矩形区域的颜色合并。  
> SRCPAINT：通过使用布尔型的OR（或）操作符将源和目标矩形区域的颜色合并。  
> WHITENESS：使用与物理调色板中索引1有关的颜色填充目标矩形区域。（对于缺省物理调色板来说，这个颜色就是白色）。

**返回值：**  
非零表示成功，零表示失败。会设置GetLastError

## 代码示例：

```cpp
void OnDraw（HDC pDC）

{
PAINTSTRUCT ps;
HDC hdc; 
hdc= BeginPaint(pDC, &ps);

HDC hMemDC = Null;// 定义一个显示设备对象
hMemDC = CreateCompatibleDC(hDC);//创建一个与屏幕显示兼容的内存DC
//注：这时还不能进行画图，因为还没有地方用来画图

//下面建立一个与屏幕显示兼容的位图，至于位图的大小嘛，可以用窗口的大小，也可以自己定义（如：有滚动条时就要大于当前窗口的大小，在BitBlt时决定拷贝内存的哪部分到屏幕上）
HBITMAP hMemBitMap;//定义一个位图对象
hMemBitMap= CreateCompatibleBitmap(hDC, nWinth, nHeight);//这里可以自己创建自定义的位图，也可以通过LoadBitMap函数从资源中加载现成的位图。
SelectObject(hMemDC, hMemBitMap);// 将与屏幕兼容的位图加载到内存DC中，这样内存DC 中就有地方用来画图了。

/********* 绘图 start *********/

/********* 绘图 end *********/

BitBlt(hDC, 0, 0, nWinth, nHeight, hMemDC, 0, 0, SRCCOPY);//将位图从内存DC中拷贝到屏幕上

//最后记得将创建的GDI对象删除

DeleteObject(hMemBitmap);

DeleteDC(hMemDC);

EndPaint(pDC, &ps);

}
```

 

$(function() { setTimeout(function () { var mathcodeList = document.querySelectorAll('.htmledit\_views img.mathcode'); if (mathcodeList.length > 0) { for (let i = 0; i < mathcodeList.length; i++) { if (mathcodeList\[i\].naturalWidth === 0 || mathcodeList\[i\].naturalHeight === 0) { var alt = mathcodeList\[i\].alt; alt = '\\\\(' + alt + '\\\\)'; var curSpan = $('<span class="img-codecogs"></span>'); curSpan.text(alt); $(mathcodeList\[i\]).before(curSpan); $(mathcodeList\[i\]).remove(); } } MathJax.Hub.Queue(\["Typeset",MathJax.Hub\]); } }, 1000) });

 [![](https://profile-avatar.csdnimg.cn/1d280a0b0d9840359313bd72a2e0b1cf_zjy1175044232.jpg!1) Zhninu](https://blog.csdn.net/zjy1175044232)

[关注](javascript:;) 关注

-    ![](https://csdnimg.cn/release/blogv2/dist/pc/img/tobarThumbUpactive.png) ![](https://csdnimg.cn/release/blogv2/dist/pc/img/newHeart2021Active.png)