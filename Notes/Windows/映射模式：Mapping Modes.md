# 映射模式：Mapping Modes


映射模式

在此篇之前我们已经学会了在窗口显示图形，更准确的说是在窗口指定位置显示图形或文字，我们使用的坐标单位是象素，称之为设备坐标。看下面语句：

pDC->Rectangle(CRect(0,0,200,200));

画一个高和宽均为200个象素的方块，因为采用的是默认的MM_TEXT映射模式，所以在设备环境不一样时，画的方块大小也不一样，在1024\*768的显示器上看到的方块会比640\*480的显示器上的小（在不同分辨率下的屏幕象素，在WINDOWS程序设计一书中有示例程序可以获得，或者可以用GetClientRect函数获得客户区的矩形大小。在这里就不说了，大家只要知道就行了），在输出到打印机时也会有类似的情况发生。如何做才能保证在不同设备上得到大小一致的方块或者图形、文字呢？就需要我们进行选择模式映射，来转换设备坐标和逻辑坐标。

Windows提供了以下几种映射模式：

MM_TEXT   
MM_LOENGLISH   
MM_HIENGLISH   
MM_LOMETRIC   
MM_HIMETRIC   
MM_TWIPS   
MM_ISOTROPIC   
MM_ANISOTROPIC

下面分别讲讲这几种映射模式：

MM_TEXT：

默认的映射模式，把设备坐标被映射到象素。x值向右方向递增；y值向下方向递增。坐标原点是屏幕左上角（0，0）。但我们可以通过调用CDC的SetViewprotOrg和SetWindowOrg函数来改变坐标原点的位置看下面两个例子：

```cpp
// 例子6-1   
void CMyView::OnDraw(CDC \* pDC)   
{   
    //全部采用默认画一个宽和高为200象素的方块   
    pDC->Rectangle(CRect(0,0,200,200));
}
```
```cpp
// 例子6-2   
void CMyView::OnDraw(CDC \* pDC)   
{   
    //设定映射模式为MM_TEXT 
    pDC->SetMapMode(MM_TEXT);  
    //设定逻辑坐标原点为（100，100）   
    pDC->SetWindowOrg(CPoint(100,100));
    //画一个宽和高为200象素的方块   
    pDC->Rectangle(CRect(100,100,300,300));
}
```
这两个例子显示出来的图形是一样的，都是从屏幕左上角开始的宽和高为200象素的方块，可以看出例子2将逻辑坐标（100，100）映射到了设备坐标（0，0）处，这样做有什么用？滚动窗口使用的就是这种变换。

## 固定比例映射模式：

MM_LOENGLISH、MM_HIENGLISH、MM_LOMETRIC、MM_HIMETRIC、MM_TWIPS这一组是Windows提供的重要的固定比例映射模式。

它们都是x值向右方向递增，y值向下递减，并且无法改变。它们之间的区别在于比例因子见下：（我想书上P53页肯定是印错了，因为通过程序实验x值向右方向也是递增的）
```cpp
MM_LOENGLISH 0.01英寸   
MM_HIENGLISH 0.001英寸   
MM_LOMETRIC 0.1mm   
MM_HIMETRIC 0.01mm   
MM_TWIPS 1/1440英寸 //应用于打印机，一个twip相当于1/20磅，一磅又相当于1/72英寸。
```
看例3
```cpp
 
// 例子6-3   
void CMyView::OnDraw(CDC \* pDC)   
{   
    //设定映射模式为MM_HIMETRIC   
    pDC->SetMapMode(MM_HIMETRIC);
    //画一个宽和高为4厘米的方块   
    pDC->Rectangle(CRect(0,0,4000,-4000));
}
```
## 可变比例映射模式
还有一种是可变比例映射模式，MM_ISOTROPIC、MM_ANISOTROPIC。用这种映射模式可以做到当窗口大小发生变化时图形的大小也会相应的发生改变，同样当翻转某个轴的伸展方向时图象也会以另外一个轴为轴心进行翻转，并且我们还可以定义任意的比例因子，怎么样很有用吧。   
MM_ISOTROPIC、MM_ANISOTROPIC两种映射模式的区别在于MM_ISOTROPIC模式下无论比例因子如何变化纵横比是1：1而M_ANISOTROPIC模式则可以纵横比独立变化。

```cpp
// 例子6-4   
void CMy002View::OnDraw(CDC\* pDC)   
{   
    CRect rectClient; //   
    //返回客户区矩形的大小 
    GetClientRect(rectClient);  
    //设定映射模式为MM_ANISOTROPIC   
    pDC->SetMapMode(MM_ANISOTROPIC);
    pDC->SetWindowExt(1000,1000);   
    //用SetWindowExt和SetViewportExt函数设定窗口为1000逻辑单位高和1000逻辑单位宽   
    pDC->SetViewportExt (rectClient.right ,-rectClient.bottom );

    //设定逻辑坐标原点为窗口中心   
    pDC->SetViewportOrg(rectClient.right/2,rectClient.bottom/2 );
    //画一个撑满窗口的椭圆。
    pDC->Ellipse(CRect(-500,-500,500,500));   
    // TODO: add draw code for native data here   
}
```
怎么样，屏幕上有一个能跟随窗口大小改变而改变的椭圆。把 pDC->SetMapMode(MM_ANISOTROPIC)；这句改为pDC->SetMapMode(MM_ISOTROPIC)会怎样？大家可以试试。

```
Dx = ((Lx - WOx) * VEx / WEx) + VOx 

Dx     x value in device units 
Lx     x value in logical units (also known as page space units) 

WOx     window x origin 
VOx     viewport x origin 

WEx     window x-extent 
VEx     viewport x-extent 
```

LPtoDP 和 DPtoLP 函数可用于分别从逻辑点到设备点和从设备点到逻辑点的转换。

很多MFC库函数尤其是CRect的成员函数只能工作在设备坐标下。   
还有我们有时需要利用物理坐标，物理坐标的概念就是现实世界的实际尺寸。   
设备坐标-逻辑坐标-物理坐标之间如何进行转换便成为我们要考虑的一个问题，物理坐标和逻辑坐标是完全要我们自己来做的，但WINDOWS提供了函数来帮助我们转换逻辑坐标和设备坐标。

CDC的LPtoDP函数可以将逻辑坐标转换成设备坐标  
CDC的DPtoLP函数可以将设备坐标转换成逻辑坐标  

下面列出我们应该在什么时候使用什么样的坐标系一定要记住：

◎CDC的所有成员函数都以逻辑坐标为参数   
◎CWnd的所有成员函数都以设备坐标为参数   
◎区域的定义采用设备坐标   
◎所有的选中测试操作应考虑使用设备坐标。   
◎需要长时间使用的值用逻辑坐标或物理坐标来保存。因设备坐标会因窗口的滚动变化而改变。   
用书上的例子作为以前几篇的复习，如果你能够独立完成它说明前面的内容已经掌握。另外有些东西是新的，我会比较详细的做出说明，例如客户区、滚动窗口等。

下面我们来一步步完成例子6-5：

■第一步：用AppWizard创建MyApp6。除了Setp 1 选择单文档视图和Setp 6 选择基类为CScrollView外其余均为确省。

■第二步：在CMyApp6View类中增加m_rectEllipse和m_nColor两个私有数据成员。你可以手工在myapp6View.h添加，不过雷神建议这样做，在ClassView中选中CMyApp6View类，击右键选择Add Member Variable插入它们。

```cpp
// myapp6View.h   
private:   
int m_nColor; //存放椭圆颜色值   
CRect m_rectEllipse; //存放椭圆外接矩形
```

#### 问题1： 
CRect是什么？   
CRect是类，是从RECT结构派生的，和它类似的还有从POINT结构派生的CPoint、从SIZE派生的CSize。因此它们继承了结构中定义的公有整数数据成员，并且由于三个类的一些操作符被重载所以可以直接在三个类之间进行类的运算。
```cpp
//重载operator +   
CRect operator +( POINT point ) const;   
CRect operator +( LPCRECT lpRect ) const;   
CRect operator +( SIZE size ) const;   
//重载operator -   
CRect operator -( POINT point ) const;   
CRect operator -( SIZE size ) const;   
CRect operator -( LPCRECT lpRect ) const;   
......   
```
更多的请在MSDN中查看

■第三步：修改由AppWizard生成的OnIntitalUpdate函数
```cpp
void CMyApp6View::OnInitialUpdate()   
{   
    CScrollView::OnInitialUpdate();   
    CSize sizeTotal(20000,30000);   
    CSize sizePage(sizeTotal.cx /2,sizeTotal.cy /2);   
    CSize sizeLine(sizeTotal.cx /50,sizeTotal.cy/50);
    
    //设置滚动视图的逻辑尺寸和映射模式  
    SetScrollSizes(MM_HIMETRIC,sizeTotal,sizePage,sizeLine); 
}
```
#### 问题2： 
关于void CMyApp6View::OnInitialUpdate()

函数OnInitialUpdate()是一个非常重要的虚函数，在视图窗口完全建立后框架用的第一个函数，框架在第一次调用OnDraw前会调用它。因此这个函数是设置滚动视图的逻辑尺寸和映射模式的最佳地点。

■第四步：编辑CMyApp6View构造函数和OnDraw函数

```cpp
// CMyApp6View构造函数   
//椭圆矩形为4\*4厘米。   
CMyApp6View::CMyApp6View():
    m_rectEllipse(0,0,4000,-4000)
{   
    m_nColor=GRAY_BRUSH;//设定刷子颜色   
}
```