您可以使用 MFC 中的CDrawingManager类来绘制带有阴影的矩形。以下是一个示例代码，用于绘制一个带有阴影的矩形：

```cpp
void CMyWnd::OnPaint()
{
    CPaintDC dc(this);
    // 创建一个 CDC 对象
    CDC memDC;
    memDC.CreateCompatibleDC(&dc);
    // 创建一个兼容位图
    CBitmap memBitmap;
    memBitmap.CreateCompatibleBitmap(&dc, m_nWndWidth, m_nWndHeight);
    memDC.SelectObject(&memBitmap);
    // 绘制带有阴影的矩形
    CRect rect(10, 10, 100, 100);
    CDrawingManager dm(memDC);
    dm.DrawShadow(rect, 5, 10, RGB(128, 128, 128));
    dm.DrawRect(rect, RGB(255, 0, 0), RGB(255, 255, 255));
    // 将位图复制到窗口 DC 中
    dc.BitBlt(0, 0, m_nWndWidth, m_nWndHeight, &memDC, 0, 0, SRCCOPY);
}
```
在此示例中，我们在窗口的OnPaint函数中创建了一个兼容 DC 和位图，然后使用CDrawingManager类在兼容 DC 上绘制带有阴影的矩形。最后，我们将兼容位图复制到窗口的 DC 中。
请注意，这只是一个简单的示例，您需要根据自己的需求进行修改和优化。