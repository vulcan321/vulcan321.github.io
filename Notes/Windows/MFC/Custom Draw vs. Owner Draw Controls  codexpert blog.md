# Custom Draw vs. Owner Draw Controls

2013.02.22 by [Ovidiu Cucu](https://codexpert.ro/blog/author/ovidiu-cucu/ "View all posts by Ovidiu Cucu")

While most of Windows developers heard about and eventually used **owner-draw controls**, fewer know about **custom-draw controls**. Both types of controls allow customization but they are pretty different. So let’s have a quick look at each one.

# Owner Draw Controls

An **owner-draw control** is a common Windows control that have a special owner-draw style set.

-   **BS\_OWNERDRAW** for button controls;
-   **LBS\*OWNERDRAWFIXED** or **LBS\*OWNERDRAWVARIABLE** for listbox controls;
-   **LVS\_OWNERDRAWFIXED** for listview controls;
-   and so on…

Once the owner-draw style is set, the “owner” has the whole drawing responsibility. For that purpose, have to handle **WM\*DRAWITEM** notification (sent to parent window) and perform drawing. In **MFC**, can also handle **WM\*DRAWITEM** reflected message in the control’s MFC class or override **DrawItem** virtual function, if available.  
Additionally, in some cases can handle **WM\*MEASUREITEM**, to modify the size of control items. See also **WM\*COMPAREITEM** and **WM\_DELETEITEM** which also can be useful when developing  **owner-draw** controls.  
You can see how owner-draw controls are made by having a look, for example, in the implementation of **CBitmapButton** and **CCheckListBox** MFC classes.

# Custom Draw Controls

Custom-draw controls have no special style. We say that a control is **custom-draw** if handles the **NM\*CUSTOMDRAW** notification (sent via **WM\*NOTIFY** message). This case, there is no necessary for the “owner” to perform the whole drawing, but can change some defaults. For example, can tell the system to fill an item with some custom color or perform some additional drawing after the default drawing has been done.  
Here is an example of **custom-draw** listvew control, having alternate item colors and a selection rectangle around a particular subitem.

[![Custom-Draw Listview Control](https://codexpert.ro/blog/wp-content/uploads/2013/02/Custom-Draw-Listview-Control.jpg)](https://codexpert.ro/blog/wp-content/uploads/2013/02/Custom-Draw-Listview-Control.jpg)

Custom-Draw Listview Control

```
// CustomListCtrl.h

class CCustomListCtrl : public CListCtrl
{
   // ...
   DECLARE*MESSAGE*MAP()
   afx_msg void OnNMCustomdraw(NMHDR *pNMHDR, LRESULT *pResult);
private:
   void _HandleSubitemPrePaint(LPNMLVCUSTOMDRAW pNMCD);
   void _HandleSubitemPostPaint(LPNMLVCUSTOMDRAW pNMCD);
};
```

```
// CustomListCtrl.cpp
   // ...
   ON*NOTIFY*REFLECT(NM_CUSTOMDRAW, &CCustomListCtrl::OnNMCustomdraw)
END*MESSAGE*MAP()

void CCustomListCtrl::OnNMCustomdraw(NMHDR *pNMHDR, LRESULT *pResult)
{
   LPNMLVCUSTOMDRAW pNMCD = (LPNMLVCUSTOMDRAW)pNMHDR;
   *pResult = CDRF_DODEFAULT;

   switch(pNMCD->nmcd.dwDrawStage)
   {
   case CDDS_PREPAINT:
      *pResult |= CDRF_NOTIFYITEMDRAW; // request item draw notify 
      break;
   case CDDS_ITEMPREPAINT:
      *pResult |= CDRF_NOTIFYSUBITEMDRAW; // request sub-item draw notify
      break;
   case CDDS*ITEMPREPAINT|CDDS*SUBITEM: // subitem pre-paint
      _HandleSubitemPrePaint(pNMCD);
      *pResult |= CDRF_NOTIFYPOSTPAINT; // request post-paint notify
      break;
   case CDDS*ITEMPOSTPAINT|CDDS*SUBITEM: // subitem post-paint
      _HandleSubitemPostPaint(pNMCD);
      break;
   }
}

void CCustomListCtrl::_HandleSubitemPrePaint(LPNMLVCUSTOMDRAW pNMCD)
{
   // Note: for a listview, nmcd.dwItemSpec keeps the item index 
   const int nItem = (int)pNMCD->nmcd.dwItemSpec;
   if((nItem % 2) == 0)
   {
      // use custom colors
      pNMCD->clrText = RGB(255,255,255);
      pNMCD->clrTextBk = RGB(128,128,255);
   }
   else
   {
      // use default colors
      pNMCD->clrText = CLR_DEFAULT;
      pNMCD->clrTextBk = CLR_DEFAULT;
   }
}

void CCustomListCtrl::_HandleSubitemPostPaint(LPNMLVCUSTOMDRAW pNMCD)
{
   const int nItem = (int)pNMCD->nmcd.dwItemSpec; 
   const int nSubItem = pNMCD->iSubItem;
   // Note: hard-coded values, just for the demo purpose
   if((22 == nItem) && (3 == nSubItem))
   {
      // Draw rectangle around subitem
      CRect rcSubItem;
      GetSubItemRect(nItem, pNMCD->iSubItem, LVIR_LABEL, rcSubItem);
      CDC* pDC = CDC::FromHandle(pNMCD->nmcd.hdc);
      CBrush* pOldBrush = (CBrush*)pDC->SelectStockObject(HOLLOW_BRUSH);
      CPen pen(PS_SOLID, 2, RGB(0,0,128));
      CPen* pOldPen = (CPen*)pDC->SelectObject(&pen);
      pDC->Rectangle(rcSubItem);
      pDC->SelectObject(pOldPen);
      pDC->SelectObject(pOldBrush);
   }
}
```

# Resources

-   MSDN: [\[TN014\] Custom Controls](http://msdn.microsoft.com/en-US/library/bk2h3c6w(v=VS.80).aspx "[TN014] Custom Controls")
-   MSDN: [Developing Custom Draw Controls in Visual C++](http://msdn.microsoft.com/en-us/library/ms364048(v=vs.80).aspx "Developing Custom Draw Controls in Visual C++")
-   MSDN: [WM\*DRAWITEM Message](http://msdn.microsoft.com/en-us/library/bb775923(VS.85).aspx "WM*DRAWITEM Message")
-   MSDN: [NM\*CUSTOMDRAW Message](http://msdn.microsoft.com/en-us/library/bb775487(VS.85).aspx "NM*CUSTOMDRAW Message")