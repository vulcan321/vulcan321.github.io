# MFC\_CCreateContext

1、CCreateContext，这个结构没有继承任何结构或者类。

2、当程序创建一个框架和视图类窗口，并且将这个视图类窗口，框架窗口和文档窗口进行关联的时候，使用这个结构。

3、

```cpp

struct CCreateContext  
{
    CRuntimeClass* m_pNewViewClass; //新建视图的动态创建类
    CDocument* m_pCurrentDoc;//当前的文档类，这文档类将和m_pNewViewClass动态创建类创建的视图类关联
    CDocTemplate* m_pNewDocTemplate;//和框架窗口关联的文档模版
    CView* m_pLastView;//原先的视图类，通常在切分窗口的视图类中使用（splitterWnd）
    CFrameWnd* m_pCurrentFrame;//当前框架窗口
    CCreateContext();
};
```

4、注意：这些类成员是可选的，都可以是null。

5、通常使用这个结构的函数如下：

```cpp
CFrameWnd::Create(...);
CFrameWnd::LoadFrame(...);
```

6、在LoadFrame()函数中，系统如何利用CCreateContext的数据，来创建视图类？

　　LoadFrame()-->CFrame::Create()-->CFrameWnd::CreateEx()-->CreateWindowEx创建CFrameWnd窗口。

　　CreateWindowEx()函数的最后一个参数lpParam,将CCreateContext的指针，转递给lpParam

7、在上面的函数调用过程中我们没有发现有创建CMyView的代码。

8、CreateWindowEx函数会发出一个ON\_WM\_CREATE消息,CFrameWnd::OnCreate函数响应这个消息，并创建CMyView：

　　OnCreate()函数的参数是一个CREATESTRUCT结构指针，这个结构的第一个参数lpCreateParamer是一个void\*类型的指针，

　　这个指针其实就是指向我们的CCreateContext结构的指针；在OnCreate()函数中，通过下面的语句，获得我们提供的CCreateContext结构的指针：

　　CCreateContext \*pContext = (CCreateContext\*)lpcs->lpCreateParams;

　　OnCreate --> CFrameWnd::OnCreateHelper --> CFrameWnd::OnCreateClient() --> CFrameWnd::CreateView

9、在CFrameWnd::CreateView()函数中，用下面的语句创建视图类：

　　CWnd \*pView = (CWnd\*)pContext->m\_pNewViewClass->CreateObject();

　　然后用下面一句话，创建视图窗口：

　　pView->Create(NULL, NULL, AFX\_WS\_DEFAULT\_VIEW, CRect(0, 0, 0, 0), this, nID, pContext);

10、通过这个结构，我们可以让系统，给我们自动创建视图类，并且附加到框架窗口上。