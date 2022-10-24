# Introduction

One of the intentions of the clipboard infrastructure in MS-Windows is to allow nearly seamless interaction between applications. However, neither Microsoft nor the reams of programming books available, seriously discuss the issue of seamless interchange of data with MS-Office products. I personally feel this is an unfortunate omission, which requires developers to spend a fair amount of time hunting for information, and/or doing trial-and-error experiments.

This article address several issues around interchanging data with MS-Office Products. The major topics addressed are:



Placing Multiple formats on the Clipboard.

Delayed Rendering.

A survey of common clipboard.

The preference of several common target applications (MS-Word, MS-Excel, and MS-PowerPoint).

Why Private Cloud and How to Build One



Register

SD-WAN 101: Ensuring Peak Performance and Service QoE



Download



This article assumes a basic understanding of using the clipboard with MFC. If you are unfamiliar with the basic use of the clipboard, please read the article Basic Copy/Paste & Drag/Drop Support



Placing Multiple Formats on the Clipboard

A fundamental issue when initiating a drag/cut/copy is that there is no way to know what target application will be the destination. This is a problem when the information you would like MS-Word to accept is different from the information you would like MS-Excel to accept.



This issue is resolved in two ways:

The application that initiates the drag/cut/copy may place more than one clipboard format on the clipboard.

The target often accepts more than one format, but has a preference (meaning a acceptance order) for the formats it accepts.

Table 6 shows the acceptance order for Cut/Copy/Paste and Drag/Drop in MS-Excel, MS-Word, and MS-PowerPoint. MS-Excel accepts the format "Csv", while neither MS-Word or MS-PowerPoint accept that format.

If you would like MS-Word to accept data that is different from what you would like to MS-Excel to accept, all you need to do is place both an RTF representation and a Csv representation on the clipboard. Since MS-Excel doesn't accept RTF it will get the Csv data, and since MS-Word doesn't accept Csv it will get the RTF data.

You can often exploit these differences to get the Cut/Copy/Paste and Drag/Drop behavior you desire.

The code example in Table 1 shows how both RTF and Csv formats can be placed on the clipboard at once. Table 2 and 3 shows the result of using this code when this data is dragged to MS-Word and MS-Excel.



Table 1 - Source for initiating RTF and Csv clipboard formats

```C++
void CClipExamView::Word2Clipboard(COleDataSource * pSource)
{
    UINT format = ::RegisterClipboardFormat(_T("Rich Text Format"));
    CSharedFile sf(GMEM_MOVEABLE|GMEM_DDESHARE|GMEM_ZEROINIT);
    CString   text = _T("{\\rtf1 {1\\tab 2\\tab 3\\par 4\\tab }{\\b\\i 5}{\\tab   6\\par}}");
    sf.Write(text, text.GetLength());
    HGLOBAL hMem = sf.Detach();
    if (!hMem) return;
    pSource->CacheGlobalData(format, hMem);
}
void CClipExamView::Excel2Clipboard(COleDataSource * pSource)
{
    UINT format = ::RegisterClipboardFormat(_T("Csv"));
    CSharedFile sf(GMEM_MOVEABLE|GMEM_DDESHARE|GMEM_ZEROINIT);
    CString   text = _T("6,5,4\n2,=1+1,1");
    sf.Write(text, text.GetLength());
    HGLOBAL hMem = sf.Detach();
    if (!hMem) return;
    pSource->CacheGlobalData(format, hMem);
}
void CClipExamView::OnEditCopy() 
{
    COleDataSource  source;
    Excel2Clipboard(&source);
    Word2Clipboard(&source);
    source.SetClipboard();
}
void CClipExamView::OnLButtonDown(UINT nFlags, CPoint point) 
{
    COleDataSource* pSource = new COleDataSource();
    Excel2Clipboard(pSource);
    Word2Clipboard(pSource);
    pSource->DoDragDrop();
} 
```

 

Table 2 - Excel as the Drop Target





Table 3 - Word as the Drop Target





It's obvious from looking at the screen shots that the text placed in Word was different than the text placed in Excel. You can exploit the clipboard format preferences of the target applications to get the behavior you wish on a drop.



Delayed Rendering

Delayed Rendering does what the name implies. It defers creating the data that goes on the clipboard until it is specifically asked from by the destination application.

The code examples shown so far have placed the entire format on the clipboard when the source application initiates the cut/copy or drag. This can needlessly consume a larger amount of shared memory and can consume time creating unused data that is placed on the clipboard.



If you plan to use the clipboard to move large amounts of data, you should use Delayed Rendering. This will make the performance of cut/copy/paste and drag/drop appear much better to the user.



Modifying COleDataSource for Delayed Rendering

To use Delayed Rendering you need to override one or more member functions in the COleDataSource class. By overriding the OnRenderGlobalData() member function you can intercept the target applications request for data and return whatever data you wish.

You check the requested format by looking at the lpFormatEtc->cfFormat item. If you find a format you accept you simply write your data to shared memory and place the handle in *phGlobal. Return TRUE if you've honored the request for data and FALSE if you didn't.



To specify the supported format when you initiate the cut/copy/drag you replace the CacheGlobalData() call with the DelayRenderData() call. This specifies the supported format without having to place the data for that format on the clipboard until requested by the target application.



Table 3 - A Derived COleDataSource class that supports Delayed Rendering

```C++
class CMyOleDataSource : public COleDataSource
{
public:
// Called when target application requests data
BOOL OnRenderGlobalData(LPFORMATETC lpFormatEtc, HGLOBAL* phGlobal)
{
    if (lpFormatEtc->cfFormat == ::RegisterClipboardFormat("Csv")) {
        // Handle Csv format
        CSharedFile sf(GMEM_MOVEABLE|GMEM_DDESHARE|GMEM_ZEROINIT);
        CString   text = _T("Excel2Clipboard\n6,5,4\n3,2,1");
        sf.Write(text, text.GetLength());
        HGLOBAL hMem = sf.Detach();
        *phGlobal = hMem;
        return (hMem != NULL);
    }
    else if (lpFormatEtc->cfFormat == ::RegisterClipboardFormat(CF_RTF)) {
        // Handle Rich Text Format
        CSharedFile sf(GMEM_MOVEABLE|GMEM_DDESHARE|GMEM_ZEROINIT);
        CString   text = _T("{\\rtf1 {Word2Clipboard\\par 1\\tab 2\\tab 3\\par    4\\tab 5\\tab 6}}");
        sf.Write(text, text.GetLength());
        HGLOBAL hMem = sf.Detach();
        *phGlobal = hMem;
        return (hMem != NULL);
    }
    return FALSE;
}
void SetClipboard()
{
    // Place available formats on the clipboard
    DelayRenderData(::RegisterClipboardFormat("Csv"));
    DelayRenderData(::RegisterClipboardFormat(CF_RTF));
    // Initiate a cut/copy to the clipboard
    COleDataSource::SetClipboard();
}
DROPEFFECT DoDragDrop(DWORD dwEffects = DROPEFFECT_COPY|DROPEFFECT_MOVE|DROPEFFECT_LINK, LPCRECT lpRectStartDrag = NULL, COleDropSource* pDropSource = NULL)
{
    // Place available formats on the clipboard
    DelayRenderData(::RegisterClipboardFormat("Csv"));
    DelayRenderData(::RegisterClipboardFormat(CF_RTF));
    // Initiate a drag to the clipboard
    return COleDataSource::DoDragDrop(dwEffects, lpRectStartDrag, pDropSource);
}
};


```

In the example in Table 2, I've chosen to override the SetClipboard() and DoDragDrop() member functions so that I can specify the supported formats. This isn't necessary, but simplifies the usage of this class. As can be seen in Table 3.

Table 3 - An example using CMyOleDataSource.



```C++
void CClipExamView::OnEditCopy()
{
    CMyOleDataSource source;
    source.SetClipboard();
}
void CClipExamView::OnLButtonDown(UINT nFlags, CPoint point)
{
    CMyOleDataSource source;
    source.DoDragDrop();
}
```

Common Clipboard Formats

This section describes several commonly used clipboard formats. This is not intended to be an exhaustive list. However, it should be enough to get you started if you are not already familiar with these formats.

CF_TEXT

The CF_TEXT format is probably the most used of the clipboard formats commonly used by developers. This format simply defines a text string that is placed on the clipboard.

See http://www.codeguru.com/clipboard/copypaste_dragdrop.shtml for a simple example of how to read and write CF_TEXT from the clipboard.



If you plan to use the format with MS-Excel, keep in mind that tabs ('\t') separate the columns and new-lines ('\n') start a new row. In MS-Word new-lines denote the beginning of a new paragraph.



Csv

The "Csv" format stands for Comma Separated Values. "Csv" files are easy to export from an application and most Spreadsheets and Databases can import this format.

When using the "Csv" format with MS-Excel remember that commas (',') separate columns and new-lines ('\n') start a new row.



The actual format value is found using the following code:



UINT csvformat = ::RegisterClipboardFormat("Csv");

Other than the special format value, this format is a text string and can be created in the same manner as the CF_TEXT format.



Rich Text Format (CF_RTF)

This Rich Text Format is intended as an interchange format for Word-processing applications. Because of that, it is a rather large and feature rich file format. Luckily, it is possible to describe a minimal RTF command set for creating simple formatted documents.

An RTF document consists of a group with the following format:



{\rtf1  document contents }

The document content is one or more groups that contain plain text and control words. There are many more control words that can be documented here, so I will hit the high points.



\par - Starts a new paragraph.

\tab - A tab.

\b - Enable Bold (scoped within a group)

\i - Enable Italics (scoped within a group)

\ul - Enable Underline (scoped within a group)

For example the RTF string:



{\rtf1 {1 \tab 2 \tab 3 \par 4 \tab {\b\i 5} \tab 6}}

Would product the following formatted text:



1  2  3 

4  5  6

That might not be terribly exciting, but it does give you more formatting options than CF_TEXT.



Don't forget that when you embed the backslash ('\') character in a C++ string you need to prepend it with another backslash.



The actual format value is found using the following code:



UINT rtfformat = ::RegisterClipboardFormat(CF_RTF);

CF_BITMAP

Randy More's article (http://www.codeguru.com/clipboard/bitmap_to_clipboard.shtml) discusses how to create and place a CF_BITMAP object the clipboard. I won't revisit that here, but the following example shows how to use the technique Randy described with Delayed Rendering.

Table 4 - Delayed Rendering a CBitmap

```C++
BOOL OnRenderData(LPFORMATETC lpFormatEtc, LPSTGMEDIUM lpStgMedium)
{
    if (lpFormatEtc->cfFormat == CF_BITMAP) {
        CBitmap bitmap;
        CClipExamView*  pView =  (CClipExamView*) ((CFrameWnd*)(AfxGetApp()->m_pMainWnd))->GetActiveView();
        TRACE("Output CF_BITMAP\r\n");
        if (pView != NULL) {
            CClientDC cdc(pView);  
            CDC dc;
            dc.CreateCompatibleDC(&cdc);   
            
            CRect bounds;
            
            pView->GetClientRect(&bounds);
            bitmap.CreateCompatibleBitmap(&cdc, bounds.Width(), bounds.Height());
            CBitmap* oldBitmap = dc.SelectObject(&bitmap);  
            CBrush fill(RGB(255, 255, 255));
            dc.FillRect(bounds, &fill); 
            dc.TextOut(0, 0, CString(_T("Bitmap")));
            pView->OnDraw(&dc); 
                
            lpStgMedium->tymed = TYMED_GDI; 
            lpStgMedium->hBitmap = HBITMAP(bitmap);
            bitmap.Detach();
            dc.SelectObject(oldBitmap);
            return TRUE;
        }
        return FALSE;
    }
    return COleDataSource::OnRenderData(lpFormatEtc, lpStgMedium);
}
```



CF_ENHMETAFILE

Randy More's article (http://www.codeguru.com/clipboard/emf_to_clipboard.shtml) discusses how to create and place a CF_ENHMETAFILE object the clipboard. I won't revisit that here, but the following code example shows how to use the technique Randy described with Delayed Rendering.

Table 5 - Delayed Rendering a Metafile

```C++
BOOL OnRenderData(LPFORMATETC lpFormatEtc, LPSTGMEDIUM lpStgMedium)
{
    if (lpFormatEtc->cfFormat == CF_ENHMETAFILE) {
        CClipExamView*  pView =  (CClipExamView*) ((CFrameWnd*)(AfxGetApp()->m_pMainWnd))->GetActiveView();
        TRACE("Output CF_ENHMETAFILE\r\n");
        if (pView != NULL) {
            CClientDC dcRef(pView);
            CMetaFileDC dcMeta;

            CRect lmbr; 
            pView->GetClientRect(lmbr);

            dcMeta.CreateEnhanced(&dcRef, NULL, NULL,"Metafile\0Copy\0\0" );
            dcMeta.SetMapMode(MM_TEXT); 

            CBrush fill(RGB(255, 255, 255));
            dcMeta.FillRect(lmbr,&fill);
            dcMeta.TextOut(0, 0, CString(_T("Metafile")));

            pView->OnDraw(&dcMeta);

            lpStgMedium->hEnhMetaFile = dcMeta.CloseEnhanced();
            lpStgMedium->tymed = TYMED_GDI;

            return TRUE;
        }
        return FALSE;
    } 
    return COleDataSource::OnRenderData(lpFormatEtc, lpStgMedium);
}
```

  

Clipboard Preference

The following table shows the preference order for the five most popular clipboard formats into MS-Office applications. Please notice that the preferences are often different between a Drag/Drop and a Cut/Copy/Paste.

Table 6 - MS-Office Clipboard Preferences

|      |      |      |
| ---- | ---- | ---- |
|      |      |      |
|      |      |      |
|      |      |      |









