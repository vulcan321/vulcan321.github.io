

方法一：  
利用CWnd本身自身支持的tooptip来实现，这种方法适用给控件增加tooltip，非常方便和简单方法如下：  
1、在窗口中增加消息映射ON\_NOTIFY\_EX(TTN\_NEEDTEXT, 0, SetTipText)  
SetTipText是个回调函数，名字叫什么无所谓，符合原型就行了，原型下面会说。  
    
2、EnableToolTips(TRUE)，使用这个方法调用这个函数是必不可少的.建议在CDialog::OnInitDialog调用。

3、在窗口中增加一个函数用于动态提供显示内容，其原型为 BOOL SetTipText(UINT id, NMHDR \*pTTTStruct, LRESULT \*pResult)，下面的代码可以根据传入的参数判定应该显示的内容。    
```cpp
BOOL CWndYour::SetTipText(UINT id, NMHDR *pTTTStruct, LRESULT *pResult)  
{  
    TOOLTIPTEXT *pTTT = (TOOLTIPTEXT *)pTTTStruct;          
    UINT nID = pTTTStruct->idFrom;   //得到相应窗口ID，有可能是HWND  

    //表明nID是否为HWND
    if (pTTT->uFlags & TTF_IDISHWND)  
    {
        //从HWND得到ID值，当然你也可以通过HWND值来判断
        nID = ::GetDlgCtrlID((HWND)nID);
        if (NULL == nID)
            return FALSE;

        switch(nID)
        {
            case(IDC_YOUR_CONTROL1)                  
            strcpy(pTTT->lpszText, your_string1);    
            break;  
            case(IDC_YOUR_CONTROL2)  
            //设置相应的显示字串  
            break;  
            default:
            break;
        }
        return TRUE;
    }  
    return FALSE;  
}  
```
4、很重要的一点，要显示的控件必须设置notify属性，否则收不到notify消息，自然也就显示不了tooltip。

  
方法二：  
使用MFC中封装好的CToolTipCtrl类，步骤如下：  
1、定义全局变量 CToolTipCtrl  m\_tooltip和CWnd\* pwnd，pwnd用来指定要显示控件的指针  
2、在窗体的OnInitDialog()中或OnShowWindow()中创建m\_tooltip。

```cpp
//创建m\_tooltip  
m_tooltip.Create(pwnd);
//将CToolTipCtrl与相应的控件对应起来  
m_tooltip.AddTool(pwnd, TTS\_ALWAYSTIP);
//设定文字的颜色  
m_tooltipSetTipTextColor(RGB(0,0,255));  
  
//设定提示文字在控件上停留的时间  
m_tooltip.SetDelayTime(150);
```

3、重载PreTranslateMessage(MSG\* pMsg)函数,增加如下代码:  

```cpp
if(m_tooltip.m_hWnd!=NULL)
  m_tooltip.RelayEvent(pMsg);
```

4、捕获主窗口的WM\_MOUSEMOVE消息,在OnMouseMove(UINT nFlags, CPoint point)函数中增加如下代码:

 //鼠标在相应的控件上移动时显示提示文字  
 m\_tooltip.UpdateTipText("怎么样",pwnd);

5、说明  
其实上面的第四步可以不要，就是在AddTool时，就可以将它的第二个参数就设置为提示文字，至于风格可以在Create的时候设置。

方法三：  
自己封装SDK中的这个控件，难度是大点，但是可控性和适用性都可以大大提高。

```cpp
// 常量定义
// tooltip
#define TTS_BALLOON  0x40
#define TTS_CLOSE  0x80
#define TTS_NOFADE  0x20

 m_tooltip.Create(this, TTS_BALLOON | TTS_ALWAYSTIP | TTS_CLOSE | TTS_NOFADE);
 m_tooltip.Activate(TRUE);
 m_tooltip.AddTool(this, DEFINE_INFO_FLOATTIP);
 m_tooltip.SetTipTextColor(RGB(0, 0, 255));
 m_tooltip.SetTipBkColor(RGB(255,0,255));
 m_tooltip.SetDelayTime(150);
 ```