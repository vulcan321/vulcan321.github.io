# ListCtrl之 OnCustomdraw函数



在MFC的ListCtrl中，每个项目都是静态的文本。可以设置整行选中，高亮，具体代码为：

```cpp
ulStyle = LVS_EX_ONECLICKACTIVATE;CListCtrl::SetExtendedStyle(ulStyle);
```

如果你想有以下效果：

1、自定义字体或者背景的颜色。

2、点击某一项的文本时，弹出一些链接操作。

或者是其他ListCtrl基本样式之外的样式，你就只能自己重画了。

常用的MFC重绘函数有DrawItem 和 OnCustomdraw。二者都是在界面有变化时（比如鼠标移动，点击，拖动）进行重画。

主要的不同在我看来就是两点：

# 一、DrawItem 与 OnCustomdraw

### 1、消息类型不同

a.DrawItem是控件类自己拥有的一个虚函数，来实现自身的重绘，对应的消息是WM\_DRAWITEM。用DrawItem，你必须在创建CTListCtrl的时候指定OWNER\_DRAW风格。

具体在程序中调用方式为：

```cpp
virtual void OnDrawItem(int nIDCtl, LPDRAWITEMSTRUCT lpDrawItemStruct);
```

b.NM\_CUSTOMDRAW是一个反射消息，NM\_CUSTOMDRAW是通过WM\_NOTIFY发送给父窗口的。Windows会为你发送NM\_CUSTOMDRAW消息，你只需要添加一个处理函数以便开始使用Customdraw。

因此首先要在对话框程序中添加一个消息映射。

```cpp
ON_NOTIFY ( NM_CUSTOMDRAW, IDC_MY_LIST, OnCustomdrawMyList )
```

函数原型为

```cpp
afx_msg void OnCustomdrawMyList ( NMHDR* pNMHDR, LRESULT* pResult );
```

  
如果在控件的扩展类中添加此函数，则需要添加以下消息映射：

```cpp
ON_NOTIFY_REFLECT ( NM_CUSTOMDRAW, OnCustomdraw ) 
```

  
函数的原型和上面一致。

### 2、**_调用的次数不同_**

假设你的列表有3行3列元素，则

a.DrawItem会对每个Item即行调用一次。总共会调用3次。

b.OnCustomdraw会对每个SubItem调用一次，总共调用9次。

# 二、OnCustomdraw函数的调用过程

OnCustomdraw将控件的绘制分为两部分：擦除和绘画。

Windows在每部分开始和结束都会发送NM\_CUSTOMDRAW消息，即总共有4个消息：  

绘画前段——一个item被画之前

绘画后段——一个item被画之后

擦除前段——一个item被擦除之前

擦除后段——一个item被擦除之后

但是实际上你的程序所收到的消息可能就只有一个或者多于四个。（不明白，我一般都是一个。参照源文档[NM\_CUSTOMEDRAW，WM\_DRAWITEM和DrawItem()的讨论](http://blog.csdn.net/oldmtn/article/details/6921192)）

每次发送消息的时段被称作一个“绘画段”。

NM\_CUSTOMDRAW消息将会给你提供以下的信息：（通过pNMHDR参数）

 ListCtrl的句柄  
 ListCtrl的ID  
 当前的“绘画段”

（pLVCD->nmcd.dwDrawStage，可以为以下几种状态：CDDS\_PREPAIN，CDDS\_ITEMPREPAINT，CDDS\_ITEMPREPAINT | CDDS\_SUBITEM）  
 绘画的DC，让你可以用它来画画  
 正在被绘制的控件、item、subitem的RECT值  
 正在被绘制的Item的Index值  
 正在被绘制的SubItem的Index值  
 正被绘制的Item的状态值（selected, grayed, 等等）  
 Item的LPARAM值，就是你使用CListCtrl::SetItemData所设的那个值  
上述所有的信息对你来说可能都很重要，这取决于你想实现什么效果，但最经常用到的就是“绘画段”、“绘画ＤＣ”、“Item Index”、“LPARAM”这几个值。  

# 三、例子

下面一个例子，我用来改变选中行的颜色：

```cpp
void CHighlightListCtrlDlg::OnCustomdrawMyList ( NMHDR* pNMHDR, LRESULT* pResult )
{
    NMLVCUSTOMDRAW* pLVCD = reinterpret_cast<NMLVCUSTOMDRAW*>( pNMHDR );
 
    // Take the default processing unless we set this to something else below.
    *pResult = CDRF_DODEFAULT;
 
    // First thing - check the draw stage. If it's the control's prepaint
    // stage, then tell Windows we want messages for every item.
	if ( CDDS_PREPAINT == pLVCD->nmcd.dwDrawStage )
	{
        *pResult = CDRF_NOTIFYITEMDRAW;
	}
    else if ( CDDS_ITEMPREPAINT == pLVCD->nmcd.dwDrawStage )
	{
        // This is the notification message for an item.  We'll request
        // notifications before each subitem's prepaint stage.
		
        *pResult = CDRF_NOTIFYSUBITEMDRAW;
	}
    else if ( (CDDS_ITEMPREPAINT | CDDS_SUBITEM) == pLVCD->nmcd.dwDrawStage )
	{
		int nRow = -1;
		POSITION pos = m_ctListCtrl.GetFirstSelectedItemPosition();
		if (pos != NULL)
		{
			nRow = m_ctListCtrl.GetNextSelectedItem(pos);
		}
		
		COLORREF clrNewTextColor, clrNewBkColor;
        
		int    nItem = static_cast<int>( pLVCD->nmcd.dwItemSpec );
		if (nItem == nRow)
		{
			clrNewTextColor = RGB(255,0,0);		//Set the text to red
			clrNewBkColor = RGB(255,255,0);		//Set the bkgrnd color to blue
		}
		else
		{
			clrNewTextColor = RGB(0,0,0);		//Leave the text black
			clrNewBkColor = RGB(255,255,255);	//leave the bkgrnd color white
		}
	
 
		pLVCD->clrText = clrNewTextColor;
		pLVCD->clrTextBk = clrNewBkColor;

        // Tell Windows to paint the control itself.
        *pResult = CDRF_DODEFAULT;
	}
}```