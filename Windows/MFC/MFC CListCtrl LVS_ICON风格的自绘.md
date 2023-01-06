# MFC CListCtrl LVS\_ICON风格的自绘


1.对CListCtrl的自绘，就要在NM\_CUSTOMDRAW自绘

CListCtrlEx.h

```cpp
class CListCtrlEx : public CListCtrl
{
    DECLARE_DYNAMIC(CListCtrlEx)

public:
    CListCtrlEx();
    virtual ~CListCtrlEx();

protected:
    DECLARE_MESSAGE_MAP()
public:
    afx_msg void OnNMCustomdraw(NMHDR *pNMHDR, LRESULT *pResult);
    afx_msg void OnEnable(BOOL bEnable);

private:
    BOOL m_bEnable;
};
```

CListCtrlEx.cpp

```cpp
// CListCtrlEx

IMPLEMENT_DYNAMIC(CListCtrlEx, CListCtrl)

CListCtrlEx::CListCtrlEx()
    :m_bEnable(TRUE)
{

}

CListCtrlEx::~CListCtrlEx()
{
}


BEGIN_MESSAGE_MAP(CListCtrlEx, CListCtrl)
    ON_NOTIFY_REFLECT(NM_CUSTOMDRAW, &CListCtrlEx::OnNMCustomdraw)
    ON_WM_ENABLE()
END_MESSAGE_MAP()



// CListCtrlEx 消息处理程序




void CListCtrlEx::OnNMCustomdraw(NMHDR *pNMHDR, LRESULT *pResult)
{
    NMLVCUSTOMDRAW* pLVCD = reinterpret_cast<NMLVCUSTOMDRAW*>(pNMHDR);
    // TODO: 在此添加控件通知处理程序代码
    *pResult = 0;

    if (CDDS_PREPAINT == pLVCD->nmcd.dwDrawStage)
    {
        *pResult = CDRF_NOTIFYITEMDRAW;
    }
    else if (CDDS_ITEMPREPAINT == pLVCD->nmcd.dwDrawStage)
    {
        // This is the beginning of an item's paint cycle.
        LVITEM rItem;
        int nItem = static_cast<int>(pLVCD->nmcd.dwItemSpec);//当前项
        CDC* pDC = CDC::FromHandle(pLVCD->nmcd.hdc);
        COLORREF crBkgnd;
        BOOL bListHasFocus;
        CRect rcItem;
        CRect rcText;
        CString sText;
        UINT uFormat;

        POSITION pos = GetFirstSelectedItemPosition();
        int index = GetNextSelectedItem(pos);

        bListHasFocus = nItem == index;//有item选中

        // Get the image index and selected/focused state of the
        // item being drawn.
        ZeroMemory(&rItem, sizeof(LVITEM));
        rItem.mask = LVIF_IMAGE | LVIF_STATE;
        rItem.iItem = nItem;
        rItem.stateMask = LVIS_SELECTED | LVIS_FOCUSED;
        GetItem(&rItem);

        // Get the rect that holds the item's icon.
        GetItemRect(nItem, &rcItem, LVIR_ICON);

        // Draw the icon.
        uFormat = ILD_TRANSPARENT;

        if ((rItem.state & LVIS_SELECTED) && bListHasFocus)
            uFormat |= ILD_FOCUS;//item图片有焦点，图片是选中状态

        GetImageList(LVSIL_NORMAL)->Draw(pDC, rItem.iImage, rcItem.TopLeft(), uFormat);//绘制图片


        // Get the rect that bounds the text label.
        GetItemRect(nItem, rcItem, LVIR_LABEL); //获取文字区域


        // Draw the background of the list item. Colors are selected
        // according to the item's state.
        if (m_bEnable)//控件可用
        {
            if (bListHasFocus)
            {
                crBkgnd = GetSysColor(COLOR_HIGHLIGHT);
                pDC->SetTextColor(GetSysColor(COLOR_HIGHLIGHTTEXT));
            }
            else
            {
                crBkgnd = GetSysColor(COLOR_BTNFACE);
                pDC->SetTextColor(GetSysColor(COLOR_BTNTEXT));
            }

            // Draw a focus rect around the item if necessary.
            if (bListHasFocus)
            {
                pDC->DrawFocusRect(rcItem);
            }
        }
        else//控件禁用
        {
            crBkgnd = GetSysColor(COLOR_WINDOW);
            pDC->SetTextColor(GetSysColor(COLOR_GRAYTEXT));
        }

        // Draw the background & prep the DC for the text drawing. Note
        // that the entire item RECT is filled in, so this emulates the full-
        // row selection style of normal lists.
        pDC->FillSolidRect(rcItem, crBkgnd);
        pDC->SetBkMode(TRANSPARENT);


        // Tweak the rect a bit for nicer-looking text alignment.
        rcText = rcItem;
        // Draw the text.
        sText = GetItemText(nItem, 0);

        pDC->DrawText(sText, CRect::CRect(rcText.left , rcText.top, rcText.right, rcText.bottom ), DT_CENTER);//绘制文字

    

        *pResult = CDRF_SKIPDEFAULT; // We've painted everything. 完全自绘，屏蔽系统
    }
}


void CListCtrlEx::OnEnable(BOOL bEnable)
{
    CListCtrl::OnEnable(bEnable);

    // TODO: 在此处添加消息处理程序代码
    m_bEnable = bEnable;//控件禁用False;可用True
}
```
