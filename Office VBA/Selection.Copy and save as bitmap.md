The code from Stephen Bullen comes with a userform. I got rid of the userform and used the code from the "Save" button for non-userform related code. Before you run the code you have to select "the area to be pictured" first.  
  
I guess that the code from module 1 can be made more efficient for my purpose.  
  
It turned out that the code has to be placed in two seperate modules as in one module it did not work...  
  
_**Module 1:**_  
  
Option Explicit  
Option Compare Text  
  
''' User-Defined Types for API Calls  
  
'Declare a UDT to store a GUID for the IPicture OLE Interface  
Private Type GUID  
Data1 As Long  
Data2 As Integer  
Data3 As Integer  
Data4(0 To 7) As Byte  
End Type  
  
'Declare a UDT to store the bitmap information  
Private Type uPicDesc  
Size As Long  
Type As Long  
hPic As Long  
hPal As Long  
End Type  
  
'''Windows API Function Declarations  
  
'Does the clipboard contain a bitmap/metafile?  
Private Declare Function IsClipboardFormatAvailable Lib "user32" (ByVal wFormat As Integer) As Long  
  
'Open the clipboard to read  
Private Declare Function OpenClipboard Lib "user32" (ByVal hwnd As Long) As Long  
  
'Get a pointer to the bitmap/metafile  
Private Declare Function GetClipboardData Lib "user32" (ByVal wFormat As Integer) As Long  
  
'Close the clipboard  
Private Declare Function CloseClipboard Lib "user32" () As Long  
  
'Convert the handle into an OLE IPicture interface.  
Private Declare Function OleCreatePictureIndirect Lib "olepro32.dll" (PicDesc As uPicDesc, RefIID As GUID, ByVal fPictureOwnsHandle As Long, IPic As IPicture) As Long  
  
'Create our own copy of the metafile, so it doesn't get wiped out by subsequent clipboard updates.  
Declare Function CopyEnhMetaFile Lib "gdi32" Alias "CopyEnhMetaFileA" (ByVal hemfSrc As Long, ByVal lpszFile As String) As Long  
  
'Create our own copy of the bitmap, so it doesn't get wiped out by subsequent clipboard updates.  
Declare Function CopyImage Lib "user32" (ByVal handle As Long, ByVal un1 As Long, ByVal n1 As Long, ByVal n2 As Long, ByVal un2 As Long) As Long  
  
'The API format types we're interested in  
Const CF\_BITMAP = 2  
Const CF\_PALETTE = 9  
Const CF\_ENHMETAFILE = 14  
Const IMAGE\_BITMAP = 0  
Const LR\_COPYRETURNORG = &H4  
  
Function PastePicture(Optional lXlPicType As Long = xlPicture) As IPicture  
  
'Some pointers  
Dim h As Long, hPicAvail As Long, hPtr As Long, hPal As Long, lPicType As Long, hCopy As Long  
  
'Convert the type of picture requested from the xl constant to the API constant  
lPicType = IIf(lXlPicType = xlBitmap, CF\_BITMAP, CF\_ENHMETAFILE)  
  
'Check if the clipboard contains the required format  
hPicAvail = IsClipboardFormatAvailable(lPicType)  
  
If hPicAvail <> 0 Then  
'Get access to the clipboard  
h = OpenClipboard(0&)  
  
If h > 0 Then  
'Get a handle to the image data  
hPtr = GetClipboardData(lPicType)  
  
'Create our own copy of the image on the clipboard, in the appropriate format.  
If lPicType = CF\_BITMAP Then  
hCopy = CopyImage(hPtr, IMAGE\_BITMAP, 0, 0, LR\_COPYRETURNORG)  
Else  
hCopy = CopyEnhMetaFile(hPtr, vbNullString)  
End If  
  
'Release the clipboard to other programs  
h = CloseClipboard  
  
'If we got a handle to the image, convert it into a Picture object and return it  
If hPtr <> 0 Then Set PastePicture = CreatePicture(hCopy, 0, lPicType)  
End If  
End If  
  
End Function  
  
Private Function CreatePicture(ByVal hPic As Long, ByVal hPal As Long, ByVal lPicType) As IPicture  
  
' IPicture requires a reference to "OLE Automation"  
Dim r As Long, uPicInfo As uPicDesc, IID\_IDispatch As GUID, IPic As IPicture  
  
'OLE Picture types  
Const PICTYPE\_BITMAP = 1  
Const PICTYPE\_ENHMETAFILE = 4  
  
' Create the Interface GUID (for the IPicture interface)  
With IID\_IDispatch  
.Data1 = &H7BF80980  
.Data2 = &HBF32  
.Data3 = &H101A  
.Data4(0) = &H8B  
.Data4(1) = &HBB  
.Data4(2) = &H0  
.Data4(3) = &HAA  
.Data4(4) = &H0  
.Data4(5) = &H30  
.Data4(6) = &HC  
.Data4(7) = &HAB  
End With  
  
' Fill uPicInfo with necessary parts.  
With uPicInfo  
.Size = Len(uPicInfo) ' Length of structure.  
.Type = IIf(lPicType = CF\_BITMAP, PICTYPE\_BITMAP, PICTYPE\_ENHMETAFILE) ' Type of Picture  
.hPic = hPic ' Handle to image.  
.hPal = IIf(lPicType = CF\_BITMAP, hPal, 0) ' Handle to palette (if bitmap).  
End With  
  
' Create the Picture object.  
r = OleCreatePictureIndirect(uPicInfo, IID\_IDispatch, True, IPic)  
  
' If an error occured, show the description  
If r <> 0 Then Debug.Print "Create Picture: " & fnOLEError(r)  
  
' Return the new Picture object.  
Set CreatePicture = IPic  
  
End Function  
  
Private Function fnOLEError(lErrNum As Long) As String  
  
'OLECreatePictureIndirect return values  
Const E\_ABORT = &H80004004  
Const E\_ACCESSDENIED = &H80070005  
Const E\_FAIL = &H80004005  
Const E\_HANDLE = &H80070006  
Const E\_INVALIDARG = &H80070057  
Const E\_NOINTERFACE = &H80004002  
Const E\_NOTIMPL = &H80004001  
Const E\_OUTOFMEMORY = &H8007000E  
Const E\_POINTER = &H80004003  
Const E\_UNEXPECTED = &H8000FFFF  
Const S\_OK = &H0  
  
Select Case lErrNum  
Case E\_ABORT  
fnOLEError = " Aborted"  
Case E\_ACCESSDENIED  
fnOLEError = " Access Denied"  
Case E\_FAIL  
fnOLEError = " General Failure"  
Case E\_HANDLE  
fnOLEError = " Bad/Missing Handle"  
Case E\_INVALIDARG  
fnOLEError = " Invalid Argument"  
Case E\_NOINTERFACE  
fnOLEError = " No Interface"  
Case E\_NOTIMPL  
fnOLEError = " Not Implemented"  
Case E\_OUTOFMEMORY  
fnOLEError = " Out of Memory"  
Case E\_POINTER  
fnOLEError = " Invalid Pointer"  
Case E\_UNEXPECTED  
fnOLEError = " Unknown Error"  
Case S\_OK  
fnOLEError = " Success!"  
End Select  
  
End Function  
  
_**And module 2:**_  
  
Sub Bitmap\_Exporteren2()  
  
Dim vFile As Variant, sFilter As String, lPicType As Long, oPic As IPictureDisp  
  
'Create an appropriate filter, based on the bitmap/picture option in the dialog  
sFilter = IIf(obMetafile, "Windows Metafile (\*.emf),\*.emf", "Windows Bitmap (\*.bmp),\*.bmp")  
  
'Get the filename to save the bitmap to  
vFile = ThisWorkbook.path & "\\Exporteren\\" & "FNE Bitmap2 " & Format(Date, "dd-mm-yy") + "\_" + Format(Time, "hh-mm") & ".bmp "  
If vFile <> False Then  
'Get the type of bitmap  
lPicType = IIf(obMetafile, xlPicture, xlBitmap)  
  
'Copy a picture to the clipboard  
Selection.CopyPicture Appearance:=xlScreen, Format:=xlBitmap  
'Retrieve the picture from the clipboard...  
Set oPic = PastePicture(lPicType)  
  
'... and save it to the file  
SavePicture oPic, vFile  
  
End If  
  
End Sub