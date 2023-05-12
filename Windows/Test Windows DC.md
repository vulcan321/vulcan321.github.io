void MultipleFilesThumbnailView::OnPaint()
{
	CString csLog;
	
	CPaintDC dc(this); // device context for painting
	CClientDC dcClient(this);
	CWindowDC dcWindow(this);
	
	CRect rect;
	GetClientRect(&rect);
	if (rect.IsRectEmpty())
		return;
	CRect rectClip;
	::GetClipBox(dc.m_hDC, &rectClip);
	if (rectClip.IsRectEmpty())
		return;
	
	////////////////////////////////TEST BEGIN////////////////////////////////////////
	auto pDC = &dc;
	auto pDC1 = GetDC();
	CUtilities::Log((LPCWSTR)csLog);
	CBrush brush1;
	brush1.CreateSolidBrush(RGB(255, 0, 0));
	CBrush brush2;
	brush2.CreateSolidBrush(RGB(0, 255, 0));

	POINT aptPentagon[6] = { 50,2, 98,35, 79,90, 21,90, 2,35, 50,2 };
	POINT aptHexagon[7] = { 50,2, 93,25, 93,75, 50,98, 7,75, 7,25, 50,2 };
	POINT *ppt = aptPentagon;
	int cpt = 6;
	////////////////////////////////TEST END//////////////////////////////////////////
	HDC hMemDC = ::CreateCompatibleDC(dc.m_hDC); //[create compatible DC]
	CDC* pMemDC = CDC::FromHandle(hMemDC);
	
	CRect rcClipBox;
	
	dcClient.GetClipBox(rcClipBox);
	csLog.Format(L"[Client DC] ClipBox 0: %d, %d, %d, %d", rcClipBox.left, rcClipBox.top, rcClipBox.Width(), rcClipBox.Height());
	CUtilities::Log((LPCWSTR)csLog);
	dcWindow.GetClipBox(rcClipBox);
	csLog.Format(L"[Window DC] ClipBox 0: %d, %d, %d, %d", rcClipBox.left, rcClipBox.top, rcClipBox.Width(), rcClipBox.Height());
	CUtilities::Log((LPCWSTR)csLog);
	
	pMemDC->GetClipBox(rcClipBox);
	csLog.Format(L"[MemDC] ClipBox 1: %d, %d, %d, %d", rcClipBox.left, rcClipBox.top, rcClipBox.Width(), rcClipBox.Height());
	CUtilities::Log((LPCWSTR)csLog);
	
	HBITMAP hBmp = CreateCompatibleBitmap(dc.m_hDC, rect.Width(), rect.Height());
	HBITMAP hOldBmp = (HBITMAP)::SelectObject(hMemDC, hBmp);
	////////////////////////////////TEST BEGIN////////////////////////////////////////
	int nMapMode = dc.GetMapMode();
	CSize szWindowOld = dc.GetWindowExt();
	CPoint ptWindowOld = dc.GetWindowOrg();
	CPoint ptViewport;
	/*CString csLog;
	csLog.Format(L"MultipleFilesThumbnailView->OnPaint CRect: %d, %d, %d, %d\n", rect.left, rect.top, rect.Width(), rect.Height());
	OutputDebugString(csLog);*/

	/* ???TEST: Paint
	CString csLog;
	csLog.Format(L"CRect: %d, %d, %d, %d\n", rect.left, rect.top, rect.Width(), rect.Height());
	OutputDebugString(csLog);
	csLog.Format(L"CalcScrollPos Position: %d, %d\n", m_nScrollPosX, m_nScrollPosY);
	OutputDebugString(csLog);*/
	
	pMemDC->GetClipBox(rcClipBox);
	csLog.Format(L"[MemDC] ClipBox 1: %d, %d, %d, %d", rcClipBox.left , rcClipBox.top, rcClipBox.Width(), rcClipBox.Height());
	CUtilities::Log((LPCWSTR)csLog);
	
	::IntersectClipRect(hMemDC, rectClip.left, rectClip.top, rectClip.right, rectClip.bottom);

	pMemDC->FillRect(rect, &brush1);

	pMemDC->SetMapMode(MM_TEXT);//设定映射模式为MM_TEXT 
	pMemDC->SetWindowOrg(CPoint(100, 100));//设定逻辑坐标原点为（100，100） 
	pMemDC->Rectangle(CRect(100, 100, 300, 300));//画一个宽和高为200象素的方块


	pMemDC->GetClipBox(rcClipBox);
	csLog.Format(L"[MemDC] ClipBox 2: %d, %d, %d, %d", rcClipBox.left, rcClipBox.top, rcClipBox.Width(), rcClipBox.Height());
	CUtilities::Log((LPCWSTR)csLog);

	XFORM xfrom = { 0 };
	pMemDC->SetGraphicsMode(GM_ADVANCED);
	pMemDC->GetWorldTransform(&xfrom);
	
	pMemDC->SetMapMode(MM_ANISOTROPIC); // MM_ISOTROPIC MM_ANISOTROPIC
	pMemDC->SetWindowExt(2000, 2000);
	pMemDC->SetViewportExt(500, 500);
	
	pMemDC->GetWorldTransform(&xfrom);
	xfrom.eDx += 1000;
	
	pMemDC->SetWorldTransform(&xfrom);
	
	nMapMode = pMemDC->GetMapMode();
	szWindowOld = pMemDC->GetWindowExt();
	ptWindowOld = pMemDC->GetWindowOrg();
	ptViewport = pMemDC->GetViewportOrg();
	csLog.Format(L"[MemDC] MapMode: %d; Window Ext: %d, %d; Window Org: %d, %d; Viewport Org：%d, %d;", 
		nMapMode, szWindowOld.cx, szWindowOld.cy, ptWindowOld.x, ptWindowOld.y, ptViewport.x, ptViewport.y);
	CUtilities::Log((LPCWSTR)csLog);

	pMemDC->GetClipBox(rcClipBox);
	csLog.Format(L"[MemDC] ClipBox 3: %d, %d, %d, %d", rcClipBox.left, rcClipBox.top, rcClipBox.Width(), rcClipBox.Height());
	CUtilities::Log((LPCWSTR)csLog);
	xfrom.eM11 = 0.5;
	xfrom.eM22 = 0.5;
	pMemDC->GetClipBox(rcClipBox);
	csLog.Format(L"[MemDC] ClipBox 3: %d, %d, %d, %d", rcClipBox.left, rcClipBox.top, rcClipBox.Width(), rcClipBox.Height());
	CUtilities::Log((LPCWSTR)csLog);

	xfrom.eDx = 1000;
	xfrom.eDy = 1000;
	pMemDC->SetWorldTransform(&xfrom);
	pMemDC->Polyline(ppt, cpt);
	xfrom.eDx += 500;
	xfrom.eDy += 500;
	pMemDC->SetWorldTransform(&xfrom);
	
	pMemDC->FillRect(rect, &brush2);
	
	pMemDC->GetClipBox(rcClipBox);
	StretchBlt(dc.m_hDC, rectClip.left, rectClip.top, rectClip.Width(), rectClip.Height(), hMemDC, rcClipBox.left, rcClipBox.top, rcClipBox.Width(), rcClipBox.Height(), SRCCOPY);
	pMemDC->ModifyWorldTransform(NULL, MWT_IDENTITY);
	
	return;
	////////////////////////////////TEST END//////////////////////////////////////////
	
	CBrush brush;
	COLORREF clrBrush = RGB(255, 255, 255);
	if (reader::App()->CheckIfHighContrastModeTheme())
	{
		reader::App()->GetBackgroundColor(clrBrush);
	}
	brush.CreateSolidBrush(clrBrush);
	pMemDC->FillRect(&rect, &brush);

	/************************************************************************/
	/*									Draw PDF Page                       */
	/************************************************************************/
	CRect rectVisible = rect;
	CPoint ptOffset(m_nScrollPosX, m_nScrollPosY);
	rectVisible.MoveToXY(ptOffset);
	//CUtilities::LogElapseTime([&]()
	//{
		for (const auto pItem : m_vItems)
		{
			if (pItem == nullptr)
				continue;
			if (pItem->Intersect(rectVisible))
			{
				// ???TODO: Visible Or Not
				if (auto it = m_vItemsSelected.find(pItem); it != m_vItemsSelected.end())
					pItem->m_bSelected = true;
				else
					pItem->m_bSelected = false;
				
				pItem->Draw(pMemDC, ptOffset);
			}
		}
	//}, L"Draw Items");
	

	
	//CFX_DIBitmap* pDIBitmap = nullptr;
	//if (IReader_App* pApp = reader::App(); pApp->IsDisplayPermit())
	//{
	//	// get render data from PDF
	//	
	//	if (nullptr == m_pFXBitmap)
	//		m_pFXBitmap = std::make_unique<CFX_DIBitmap>();
	//	if (m_pFXBitmap)
	//	{
	//		m_pFXBitmap->Copy(pDIBitmap);
	//	}
	//}
	//else
	//{
	//	if (m_pFXBitmap)
	//	{
	//		pDIBitmap = m_pFXBitmap.get();
	//	}
	//}
	//
	//if (pDIBitmap)
	//{
	//	CFX_WindowsDevice wdc(hMemDC);
	//	wdc.SetDIBits(pDIBitmap, 0, 0);
	//}
	OnPaintPreviewButtons(pMemDC);
	BitBlt(dc.m_hDC, rectClip.left, rectClip.top, rectClip.Width(), rectClip.Height(), hMemDC, rectClip.left, rectClip.top, SRCCOPY);

	if (m_bRebuildView == true)
		m_bRebuildView = false;

	SelectObject(hMemDC, hOldBmp);
	DeleteObject(hBmp);
	DeleteDC(hMemDC);

	// Do not call CWnd::OnPaint() for painting messages
}
