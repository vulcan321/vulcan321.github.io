# Windows下C++三种方法获取文件缩略图并保存为图片


# 1\. 简介

在Windows文件夹中，不需要打开文件，即可以通过大图标、平铺等方面查看到不同文件的缩略图。  

# 2\. 方法一

缩略图信息文件夹的，在文件夹中显示。所以Windows提供了文件夹相关组件来获取缩略图信息。因为IShellFolder组件的方法只能用宽字符，所以接口需要使用宽字符符。此方法兼容XP系统及之后的操作系统。

```cpp
HBITMAP GetThumbnail(const std::wstring& _strFilePath)
{
std::wstring strDir;
std::wstring strFileName;
int nPos = _strFilePath.find_last_of(L"\\");
strDir = _strFilePath.substr(0,nPos);
strFileName = _strFilePath.substr(nPos+1);

CComPtr<IShellFolder> pDesktop = NULL;
HRESULT hr = SHGetDesktopFolder(&pDesktop);
if(FAILED(hr)) 
return NULL;

LPITEMIDLIST pidl = NULL;
hr = pDesktop->ParseDisplayName(NULL, NULL, (LPWSTR)strDir.c_str(), NULL, &pidl, NULL);
if(FAILED(hr)) 
return NULL;

CComPtr<IShellFolder> pSub = NULL;
hr = pDesktop->BindToObject(pidl, NULL, IID_IShellFolder, (void**)&pSub);
if(FAILED(hr)) 
return NULL;

hr = pSub->ParseDisplayName(NULL, NULL, (LPWSTR)strFileName.c_str(), NULL, &pidl, NULL);
if(FAILED(hr))
return NULL;

CComPtr<IExtractImage> pIExtract = NULL;
hr = pSub ->GetUIObjectOf(NULL, 1, (LPCITEMIDLIST *)&pidl, IID_IExtractImage, NULL, (void**)& pIExtract);
if(FAILED(hr)) 
return NULL;

SIZE size = {64, 128}; // 请求获取的图片大小
DWORD dwFlags = IEIFLAG_ORIGSIZE | IEIFLAG_QUALITY;
OLECHAR pathBuffer[MAX_PATH] = {0};
// 24为颜色深度，缩略图一般是24位颜色
hr = pIExtract->GetLocation(pathBuffer, MAX_PATH, NULL, &size, 24, &dwFlags);
if(FAILED(hr)) 
return NULL;

// Get the image
HBITMAP hThumbnail = NULL;
hr = pIExtract ->Extract(&hThumbnail);
if(FAILED(hr)) 
return NULL;

return hThumbnail;
}
```

# 3\. 方法二

随着Windows的升级，Windows针对缩略图，还提供了专组件接口，更加方便。但是只支持Win7及之后的系统。

```cpp

HBITMAP GetThumbnailEx(WCHAR* path)
{
HRESULT hr = CoInitialize(nullptr);

// Get the thumbnail
IShellItem* item = nullptr;
hr = SHCreateItemFromParsingName(path, nullptr, IID_PPV_ARGS(&item));

IThumbnailCache* cache = nullptr;
hr = CoCreateInstance(
CLSID_LocalThumbnailCache,
nullptr,
CLSCTX_INPROC,
IID_PPV_ARGS(&cache));

ISharedBitmap* shared_bitmap;
hr = cache->GetThumbnail(
item,
48*64,
WTS_EXTRACT,
&shared_bitmap,
nullptr,
nullptr);

// Retrieve thumbnail HBITMAP
HBITMAP hbitmap = NULL;
hr = shared_bitmap->GetSharedBitmap(&hbitmap);
CoUninitialize();

return hbitmap;
}
```

# 3\. 方法三

有时自定义的文档，也想让系统显示相应的缩略图，怎么办呢？Windows提供了COM组件接口，只需要实际相应的接口处理自己定义的文件，然后完成相应文档缩略图的定义即可。  
更多详细信息参考官方资料：[C++ Windows Shell thumbnail handler](https://github.com/microsoftarchive/msdn-code-gallery-microsoft/tree/21cb9b6bc0da3b234c5854ecac449cb3bd261f29/OneCodeTeam/C++%20Windows%20Shell%20thumbnail%20handler%20%28CppShellExtThumbnailHandler%29)

# 4\. 其他

# 4.1. 保存图片

```cpp

BOOL SaveBitmapToFile(HBITMAP hBitmap, const CString& szfilename)
{          
//计算位图文件每个像素所占字节数              
HDC hDC  = CreateDC("DISPLAY", NULL, NULL, NULL);  
int iBits  = GetDeviceCaps(hDC,   BITSPIXEL)*GetDeviceCaps(hDC,   PLANES);             
DeleteDC(hDC);       
//位图中每象素所占字节数
WORD wBitCount = 0;
if(iBits <=  1)                                                   
wBitCount = 1;             
else  if(iBits <=  4)                               
wBitCount  = 4;             
else if(iBits <=  8)                               
wBitCount  = 8;             
else                                                                                                                               
wBitCount  = 24;

BITMAP Bitmap = {};
GetObject(hBitmap,   sizeof(Bitmap),   (LPSTR)&Bitmap);      
BITMAPINFOHEADER bi = {};
bi.biSize= sizeof(BITMAPINFOHEADER);      
bi.biWidth = Bitmap.bmWidth;         
bi.biHeight =  Bitmap.bmHeight;         
bi.biPlanes =  1;         
bi.biBitCount = wBitCount;         
bi.biCompression= BI_RGB;                

DWORD dwBmBitsSize  = 16*((Bitmap.bmWidth *wBitCount+31) / 32)*4* Bitmap.bmHeight;         

//为位图内容分配内存              
DWORD dwPaletteSize = 0;
HANDLE hDib  = GlobalAlloc(GHND,dwBmBitsSize+dwPaletteSize+sizeof(BITMAPINFOHEADER));             
LPBITMAPINFOHEADER lpbi  = (LPBITMAPINFOHEADER)GlobalLock(hDib);             
*lpbi  = bi;             

// 处理调色板
HANDLE hOldPal = NULL; 
HANDLE hPal = GetStockObject(DEFAULT_PALETTE);             
if (hPal)             
{             
hDC  = ::GetDC(NULL);             
hOldPal = ::SelectPalette(hDC,(HPALETTE)hPal, FALSE);             
RealizePalette(hDC);             
}         

//位图文件大小写入文件字节数              
DWORD dwDIBSize=0;
DWORD dwWritten=0;      

// 获取该调色板下新的像素值              
GetDIBits(hDC,hBitmap, 0,(UINT)Bitmap.bmHeight,  
(LPSTR)lpbi+ sizeof(BITMAPINFOHEADER)+dwPaletteSize,   
(BITMAPINFO *)lpbi, DIB_RGB_COLORS);             

//恢复调色板                  
if (hOldPal)             
{             
::SelectPalette(hDC,   (HPALETTE)hOldPal,   TRUE);             
RealizePalette(hDC);             
::ReleaseDC(NULL,   hDC);             
}             

//创建位图文件                  
HANDLE fh  = CreateFile(szfilename,   GENERIC_WRITE,0,   NULL,   CREATE_ALWAYS,           
FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN,   NULL);             

if (fh == INVALID_HANDLE_VALUE)         
return FALSE;            

// 设置位图文件头              
BITMAPFILEHEADER bmfHdr = {};
bmfHdr.bfType = 0x4D42;     //"BM"              
dwDIBSize  = sizeof(BITMAPFILEHEADER)+sizeof(BITMAPINFOHEADER)+dwPaletteSize+dwBmBitsSize;                 
bmfHdr.bfSize = dwDIBSize;                       
bmfHdr.bfOffBits = (DWORD)sizeof(BITMAPFILEHEADER)+(DWORD)sizeof(BITMAPINFOHEADER)+dwPaletteSize;    

// 写入位图文件头              
WriteFile(fh, (LPSTR)&bmfHdr, sizeof(BITMAPFILEHEADER), &dwWritten, NULL);             
// 写入位图文件其余内容              
WriteFile(fh, (LPSTR)lpbi, dwDIBSize, &dwWritten, NULL);             
// 清除                  
GlobalUnlock(hDib);             
GlobalFree(hDib);             
CloseHandle(fh);             

return TRUE;         
}
```
