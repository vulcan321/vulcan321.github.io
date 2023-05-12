Attribute VB_Name = "BPEnvironment"
Public Const REG_OPTION_VOLATILE = 1
Public Const REG_OPTION_NON_VOLATILE = 0
Public Const SYNCHRONIZE = &H100000
Public Const READ_CONTROL = &H20000
Public Const STANDARD_RIGHTS_READ = (READ_CONTROL)
Public Const STANDARD_RIGHTS_WRITE = (READ_CONTROL)
Public Const STANDARD_RIGHTS_ALL = &H1F0000
Public Const KEY_QUERY_VALUE = &H1
Public Const KEY_SET_VALUE = &H2
Public Const KEY_CREATE_SUB_KEY = &H4
Public Const KEY_ENUMERATE_SUB_KEYS = &H8
Public Const KEY_NOTIFY = &H10
Public Const KEY_CREATE_LINK = &H20
Public Const KEY_READ = ((STANDARD_RIGHTS_READ Or KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS Or KEY_NOTIFY) And (Not SYNCHRONIZE))
Public Const KEY_WRITE = ((STANDARD_RIGHTS_WRITE Or KEY_SET_VALUE Or KEY_CREATE_SUB_KEY) And (Not SYNCHRONIZE))
Public Const KEY_EXECUTE = (KEY_READ)
Public Const KEY_ALL_ACCESS = ((STANDARD_RIGHTS_ALL Or KEY_QUERY_VALUE Or KEY_SET_VALUE Or KEY_CREATE_SUB_KEY Or KEY_ENUMERATE_SUB_KEYS Or KEY_NOTIFY Or KEY_CREATE_LINK) And (Not SYNCHRONIZE))
Public Const ERROR_MORE_DATA = 234
Public Const ERROR_NO_MORE_ITEMS = &H103
Public Const ERROR_KEY_NOT_FOUND = &H2
Public Const CSIDL_APPDATA = &H1A
Public Const MAX_PATH = 260
Public Const NOERROR = 0
Private Const FORMAT_MESSAGE_FROM_SYSTEM = &H1000
Public Const IMPORT_DIR = "DocsCorp\pdfDocs\Import\"
Public Const CONFIG_FILE = "DocsCorp\pdfDocs\Config\pdfDocsAppSettings.xml"
Public Const WORD_EXPORT_SETTINGS_FILE = "DocsCorp\pdfDocs\Config\WordExportSettings.xml"

Enum DataType
 REG_SZ = &H1
 REG_EXPAND_SZ = &H2
 REG_BINARY = &H3
 REG_DWORD = &H4
 REG_MULTI_SZ = &H7
End Enum

Enum hKey
 HKEY_CLASSES_ROOT = &H80000000
 HKEY_CURRENT_USER = &H80000001
 HKEY_LOCAL_MACHINE = &H80000002
 HKEY_USERS = &H80000003
 HKEY_PERFORMANCE_DATA = &H80000004
 HKEY_CURRENT_CONFIG = &H80000005
 HKEY_DYN_DATA = &H80000006
End Enum

Private Type SECURITY_ATTRIBUTES
        nLength As Long
        lpSecurityDescriptor As Long
        bInheritHandle As Long
End Type

Private Type FILETIME
        dwLowDateTime As Long
        dwHighDateTime As Long
End Type

Dim mvarhKeySet As Long
Dim mvarKeyRoot As String
Dim mvarSubKey As String
Dim mvarErrorMsg As String
Dim Security As SECURITY_ATTRIBUTES

Public Function GetBPUniqueFilename(OutputDirectory As String) As String
    Dim sTmpPath As String * 512
    Dim sTmpName As String * 576
    Dim nRet As Long
    Dim Exists As Integer
    
    Dim fs As Variant
    Set fs = CreateObject("Scripting.FileSystemObject")
    
    nRet = Len(OutputDirectory)
    If (nRet > 0 And nRet < 512) Then
        nRet = BPExternals.GetTempFileName(OutputDirectory, "BPW", 0, sTmpName)
        Kill (sTmpName)
        If nRet <> 0 Then
            sTmpName = Left(sTmpName, InStr(sTmpName, vbNullChar) - 1)
            GetBPUniqueFilename = Left(sTmpName, InStrRev(sTmpName, ".tmp") - 1)
        End If
    End If
End Function

Public Function GetSettingsFile() As String
    'GetSettingsFile = "C:\test.ini"
    Dim settingsFile As String
    settingsFile = GetImportDir + "importdata.ini"
    If Not FileOrDirExists(settingsFile) Then
        BPExternals.MakeSureDirectoryPathExists (settingsFile)
    End If
    GetSettingsFile = settingsFile
End Function
Public Function GetOutputBookmarksFilename(docFilename As String) As String
    Dim bookmarkFileName As String
    bookmarkFileName = GetImportDir + GetFilenameWithoutExtension(docFilename)
    If Not FileOrDirExists(settingsFile) Then
        BPExternals.MakeSureDirectoryPathExists (bookmarkFileName)
    End If
    GetOutputBookmarksFilename = bookmarkFileName
End Function

Public Function GetBPTempDirectory() As String
    ' Minters modification
    '
    ' Making the temp directory default to pdfDoc dirctory,
    ' not the users directory as the 'temp' is not created
    ' inside the roaming home directory
    '
    ' Below is the original line
    ' GetBPTempDirectory = GetBPPDFDOCSUserDirectory() & "\temp\"
    
    ' GetBPTempDirectory = GetBPPDFDOCSDirectory() & "\users\" & GetBPUsername() & "\temp\"
    
    GetBPTempDirectory = GetRegistryValue(HKEY_CURRENT_USER, "pdfdocsMon.UserTempDir", "", "Software\DocsCorp\pdfDocs")
End Function

Public Function GetBPPDFDOCSEXE() As String
    GetBPPDFDOCSEXE = GetBPPDFDOCSDirectory() & "\pdfdocs.exe"
End Function

Public Function GetBPPDFCMDEXE() As String
    GetBPPDFCMDEXE = GetBPPDFDOCSDirectory() & "\Resources\pdfDocsCMD.exe"
End Function

Public Function GetBPPDFDOCSDirectory() As String
    Dim pdfDocsDirectory As String
    Dim pdfDocsExe As String
    Dim ArgumentsValue As Variant
    
    ArgumentsValue = GetRegistryValue(HKEY_LOCAL_MACHINE, "InstallPath", "", "SOFTWARE\DocsCorp\pdfDocs")
    Dim ArgumentsValueString As String: ArgumentsValueString = CStr(ArgumentsValue)
    GetBPPDFDOCSDirectory = ArgumentsValueString
End Function

Public Function GetBPPDFDOCSUserDirectory() As String
    Dim pdfDocsDirectory As String
    Dim pdfDocsExe As String
    Dim ArgumentsValue As Variant
    Dim test As String
    If Not IsRoamingProfile() Then
        GetBPPDFDOCSUserDirectory = GetBPPDFDOCSDirectory() & "\users\" & GetBPUsername()
    Else
        ' Minters modifications
        If Not IsRoamingHome Then
            GetBPPDFDOCSUserDirectory = GetUserAppDataDirectory() & "\BP\pdfDocs"
            If dir(GetBPPDFDOCSUserDirectory, vbDirectory) = "" Then
                GetBPPDFDOCSUserDirectory = GetBPPDFDOCSDirectory() & "\DocsCorp\pdfDocs"
            End If
        Else
            test = GetRoamingHomeDirectory() & "\" & GetBPUsername()
            MsgBox test
            GetBPPDFDOCSUserDirectory = GetRoamingHomeDirectory() & "\" & GetBPUsername()
            
        End If
    End If
End Function

Public Function IsRoamingProfile() As Boolean
    Dim DataValue As Variant
    
    IsRoamingProfile = False
    DataValue = GetRegistryValue(HKEY_LOCAL_MACHINE, "RoamingProfiles", "", "SOFTWARE\Business Prophet\pdfDocs")
    If IsNumeric(DataValue) Then
        If DataValue = 1 Then
            IsRoamingProfile = True
        End If
    End If
        ' Minters modifications
    DataValue = GetRegistryValue(HKEY_LOCAL_MACHINE, "RoamingProfiles", "", "SOFTWARE\DocsCorp\pdfDocs")
    If IsNumeric(DataValue) Then
        If DataValue = 1 Then
            IsRoamingProfile = True
        End If
    End If
End Function

' Minters modifications
Public Function IsRoamingHome() As Boolean
    Dim DataValue As Variant
    
    IsRoamingHome = False
    DataValue = GetRegistryValue(HKEY_LOCAL_MACHINE, "RoamingHome", "", "SOFTWARE\Business Prophet\pdfDocs")
    If Not DataValue = "" Then
        IsRoamingHome = True
    End If
    DataValue = GetRegistryValue(HKEY_LOCAL_MACHINE, "RoamingHome", "", "SOFTWARE\DocsCorp\pdfDocs")
    If Not DataValue = "" Then
        IsRoamingHome = True
    End If
End Function

' Minders modifications
Public Function GetRoamingHomeDirectory() As String
    Dim DataValue As Variant
    DataValue = GetRegistryValue(HKEY_LOCAL_MACHINE, "RoamingHome", "", "SOFTWARE\Business Prophet\pdfDocs")
    
    If DataValue = "" Then
        DataValue = GetRegistryValue(HKEY_LOCAL_MACHINE, "RoamingHome", "", "SOFTWARE\DocsCorp\pdfDocs")
    End If
  
    GetRoamingHomeDirectory = DataValue
End Function

Public Function GetBPUsername() As String
    Dim UsernameFromAPI As String * 255
    Dim LengthOfUsername As Long
    Dim Username As String
    Username = ""
    
On Error Resume Next
    If IsWin9xMe = True Then
        Username = "System"
    Else
        LengthOfUsername = BPExternals.GetUserName(UsernameFromAPI, 255)
        LengthOfUsername = InStr(1, UsernameFromAPI, Chr(0))
        
        'TODO: Special handling for Roaming Profiles
        'As per Port Redirector -> SerializeToFile
        
        If LengthOfUsername > 0 Then
            Username = Left(UsernameFromAPI, LengthOfUsername - 1)
        Else
            Username = UsernameFromAPI
        End If
    End If
    
On Error GoTo 0
    GetBPUsername = Trim(Username)
End Function

Public Function GetUserAppDataDirectory() As String
    Dim DataValue As Variant
    DataValue = GetRegistryValue(HKEY_CURRENT_USER, "AppData", "", "Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders")

    If DataValue = "" Then
        DataValue = Environ$("APPDATA")
    End If
    
    GetUserAppDataDirectory = DataValue
End Function
Public Function GetPDFDocsSettingsFile() As String

Dim pdfDocsSettingsFile As String
pdfDocsSettingsFile = GetUserAppDataDirectory & "\" & CONFIG_FILE

GetPDFDocsSettingsFile = pdfDocsSettingsFile

End Function
Public Function GetWordExportSettingsFile() As String

Dim wordExportSettingsFile As String
wordExportSettingsFile = GetUserAppDataDirectory & "\" & WORD_EXPORT_SETTINGS_FILE

GetWordExportSettingsFile = wordExportSettingsFile

End Function

Public Function GetWordStartupDirectory() As String
    Dim dir As String
    Dim versionstring As String
    Dim manipString As String
    Dim index As Integer
    Dim Length As Integer
    Dim dirSubString As String
    
    manipString = GetRegistryValue(HKEY_CLASSES_ROOT, "", "", "Word.Application\CurVer")
    Length = Len(manipString)
    index = InStr(1, manipString, "Word.Application.")
    versionstring = Right(manipString, Length - (index + Len("Word.Application.") - 1))
    versionstring = versionstring & ".0"
    
    dir = GetRegistryValue(HKEY_CURRENT_USER, "STARTUP-PATH", "", "SOFTWARE\MICROSOFT\OFFICE\" & versionstring & "\WORD\OPTIONS", ExpandEnvVars:=False)
    If Len(dir) > 0 Then
        dirSubString = Mid(dir, Len(dir), Len(dir))
        If dirSubString = "\" Then
            dir = Mid(dir, 1, Len(dir) - 1)
        End If
    Else
        dir = GetUserAppDataDirectory & "\MicroSoft\Word\Startup"
    End If
    GetWordStartupDirectory = dir
End Function

Public Function UpgradeMacros() As Boolean

    Dim WordStartupDir As String
    Dim pdfDocsResDir As String
    Dim returnValue As Boolean
    Dim wordmodified As String
    Dim pdfDocsModified As String
    Dim wordDate As Date
    Dim resourceDate As Date
    Dim fs, f
    Set fs = CreateObject("Scripting.FileSystemObject")
    
    WordStartupDir = GetWordStartupDirectory()
    pdfDocsResDir = GetBPPDFDOCSDirectory & "\Resources"
    
    If dir(WordStartupDir & "\pdfDocs.dot") > "" Then
        Set f = fs.GetFile(WordStartupDir & "\pdfDocs.dot")
        wordDate = f.DateLastModified
    
        Set f = fs.GetFile(pdfDocsResDir & "\pdfDocs.dot")
        resourceDate = f.DateLastModified
         
        If resourceDate > wordDate Then
            UpgradeMacros = True
        Else
            UpgradeMacros = False
        End If
    Else
        UpgradeMacros = False
    End If
End Function

Public Function GetRegistryValue(ByVal hKey As hKey, ByVal ValueName As String, ByVal DefaultValue As Variant, Optional KeyPath As String, Optional ExpandEnvVars As Boolean = True) As Variant
    Dim handle As Long
    Dim resLong As Long
    Dim resString As String
    Dim TestString As String
    Dim resBinary() As Byte
    Dim Length As Long
    Dim RetVal As Long
#If Win64 Then
    Dim valueType As LongPtr
#Else
    Dim valueType As Long
#End If
    Dim RegPath As String
    Dim RegPath64 As String
    Dim registryOpenResult
    
    GetRegistryValue = IIf(IsMissing(DefaultValue), Empty, DefaultValue)
    RegPath = IIf(IsMissing(KeyPath), mvarKeyRoot & "\" & mvarSubKey, KeyPath)
       
    ' It is possible to run 32bit office on 64bit windows
    ' 64bit application accessing software key on 64bit OS
    If InStr(RegPath, "SOFTWARE\DocsCorp\pdfDocs") > 0 Then
        RegPath64 = Replace(RegPath, "SOFTWARE\DocsCorp\pdfDocs", "SOFTWARE\Wow6432Node\DocsCorp\pdfDocs")
    Else
        RegPath64 = RegPath
    End If

    registryOpenResult = RegOpenKeyEx(hKey, RegPath64, REG_OPTION_NON_VOLATILE, KEY_READ, handle)
    If registryOpenResult Then
        registryOpenResult = RegOpenKeyEx(hKey, RegPath, REG_OPTION_NON_VOLATILE, KEY_READ, handle)
        If registryOpenResult Then
            Exit Function
        End If
    End If
    
    Length = 1024
    ReDim resBinary(0 To Length - 1) As Byte
    
    RetVal = BPExternals.RegQueryValueEx(handle, ValueName, 0, valueType, resBinary(0), Length)
    If RetVal = ERROR_MORE_DATA Then
        ReDim resBinary(0 To Length - 1) As Byte
        RetVal = BPExternals.RegQueryValueEx(handle, ValueName, 0, valueType, resBinary(0), Length)
    End If
    
    If RetVal = ERROR_KEY_NOT_FOUND Then
        BPExternals.RegCloseKey (handle)
        Exit Function
    End If
    
    Select Case valueType
        Case REG_DWORD
            BPExternals.CopyMemory resLong, resBinary(0), 4
            GetRegistryValue = resLong
        
        Case REG_SZ
            If Length <> 0 Then
                resString = Space$(Length - 1)
                BPExternals.CopyMemory ByVal resString, resBinary(0), Length - 1
                GetRegistryValue = resString
            End If
        
        Case REG_EXPAND_SZ
        If Length <> 0 Then
            resString = Space$(Length - 1)
            BPExternals.CopyMemory ByVal resString, resBinary(0), Length - 1
            resString = Trim(resString)
            If ExpandEnvVars And (Not Len(dir$(resString + "\*.*", vbDirectory)) > 0 Or InStr(resString, "%") = 1) Then
                    Dim envVar As String
                    Dim envVarIndx As Integer
                    Dim resStringExpanded As String
                    envVarIndx = InStr(2, resString, "%")
                    If (envVarIndx > 2) Then
                        envVar = Left(resString, envVarIndx)
                        resStringExpanded = Space$(1024)
                        Length = BPExternals.ExpandEnvironmentStrings(envVar, resStringExpanded, 1024)
                        'The length returned by ExpandEnvironmentStrings includes the null terminator so must avoid it
                        resString = Left$(resStringExpanded, Length - 1) & Mid$(resString, envVarIndx + 1)
                    End If
                End If
            GetRegistryValue = resString
                        
        End If
        
        Case REG_BINARY
            If Length <> UBound(resBinary) + 1 Then
                ReDim Preserve resBinary(0 To Length - 1) As Byte
            End If
            GetRegistryValue = resBinary()
        
        Case REG_MULTI_SZ
            resString = Space$(Length - 2)
            BPExternals.CopyMemory ByVal resString, resBinary(0), Length - 2
            TestString = resString
            If Len(Trim(TestString)) > 0 Then GetRegistryValue = resString
        
        Case Else
    End Select
    
    BPExternals.RegCloseKey (handle)
End Function

Public Function GetWordVersion() As Double
    GetWordVersion = CDbl(Application.version)
End Function

Public Function GetMaxFolderNameNumber(dir As String) As Long
    ' Returns the maximum number of THE folder name existing in the directory. The method looks for numerical
    ' named folders and will return the number of the highest numbered folder. i.e. 2.

    Dim maxFolder As Long
    maxFolder = 0
    Dim folderNumber As Long
    Dim fso As Object
    Dim fld As Object
    Dim sf As Object
    Set fso = CreateObject("Scripting.FileSystemObject")

    Set fld = fso.GetFolder(dir)

    For Each sf In fld.SUBFOLDERS
        On Error Resume Next
        folderNumber = CLng(sf.Name)
        If folderNumber > maxFolder Then
            maxFolder = folderNumber
        End If
    Next

    GetMaxFolderNameNumber = maxFolder
End Function

Public Function GetTempDir() As String
    Dim sBuffer As String
    Dim lRetVal As Long

    sBuffer = String(255, vbNullChar)

    lRetVal = GetTempPath(Len(sBuffer), sBuffer)

    If lRetVal Then
        GetTempDir = Left$(sBuffer, lRetVal)
    End If
End Function

Public Function GetNewTempDir() As String
    Dim newImportDir As Long
    Dim newPath As String
    
    newPath = GetTempDir & IMPORT_DIR
    
    If Not FileOrDirExists(newPath) Then
        BPExternals.MakeSureDirectoryPathExists (newPath)
    End If
    
    newImportDir = GetMaxFolderNameNumber(newPath) + 1
    
    newPath = newPath & newImportDir & "\"

    If Not FileOrDirExists(newPath) Then
        BPExternals.MakeSureDirectoryPathExists newPath
    End If
    
    GetNewTempDir = newPath
    
End Function

Function FileOrDirExists(ByVal PathName As String) As Boolean
    Dim tmp As Integer

On Error Resume Next
    tmp = GetAttr(PathName)

    Select Case Err.Number
        Case Is = 0
            FileOrDirExists = True
        Case Else
            FileOrDirExists = False
    End Select

End Function

Function GetFileName(ByVal fileName As String) As String
    Dim pos As Integer
    Dim fName As String

    pos = 0
    For i = 1 To Len(fileName)
        If (Mid(fileName, i, 1) = "\") Then pos = i
    Next
    
    'Remove path
    fName = Right(fileName, Len(fileName) - pos)
    
    GetFileName = fName
End Function

Function GetFilenameWithoutExtension(ByVal fileName As String) As String
    Dim newFileName As String
    Dim temp() As String
    
    temp = Split(fileName, ".")
    newFileName = ""
    
    For i = 0 To UBound(temp) - 1
        newFileName = newFileName + temp(i) + "."
    Next
    
    If newFileName <> "" Then
        GetFilenameWithoutExtension = Mid(newFileName, 1, Len(newFileName) - 1)
    Else
        GetFilenameWithoutExtension = ""
    End If
End Function

' Get Filename without extension
' Returns the current Filename if it doesn't have an extension
Function GetDefaultFilenameWithoutExtension(ByVal fileName As String) As String
    Dim newFileName As String
    
    newFileName = GetFilenameWithoutExtension(fileName)
    
    If newFileName = "" Then
        newFileName = fileName
    End If
    
    GetDefaultFilenameWithoutExtension = newFileName
End Function

Function GetDirectory(ByVal path As String) As String
   GetDirectory = Left(path, InStrRev(path, "\") - 1)
End Function

Function GetFileExtension(ByVal fileName As String) As String
    GetFileExtension = Right(fileName, Len(fileName) - InStrRev(fileName, ".") + 1)
End Function

Function FileExists(ByVal fileName As String) As Boolean
   FileExists = (dir(fileName) <> "")
End Function

Public Sub FileDelete(ByVal FileToDelete As String)
   If FileExists(FileToDelete) Then
      SetAttr FileToDelete, vbNormal
      Kill FileToDelete
   End If
End Sub


Public Function GetImportDir()
    GetImportDir = GetTempDir & IMPORT_DIR
End Function

Public Function GetPDSettings(ByVal settingsName As String) As String
    
    Dim xmlPath As String
    Dim xmlDoc As MSXML2.DOMDocument
    Dim bookmarkSettingsElement As MSXML2.IXMLDOMElement
    Dim mainNode As MSXML2.IXMLDOMElement
    
    Dim settingsValue As String
    
    On Error GoTo exitPoint
    
    Set xmlDoc = New MSXML2.DOMDocument
    xmlPath = GetPDFDocsSettingsFile
    
    If Not FileOrDirExists(xmlPath) Then
        Exit Function
    End If
    
    If xmlDoc.Load(xmlPath) Then
        Dim settingsNode As MSXML2.IXMLDOMNode
        For Each settingsNode In xmlDoc.ChildNodes(1).ChildNodes
            ' lower case
            If LCase(settingsNode.nodeName) = LCase(settingsName) Then
                settingsValue = settingsNode.text
                Exit For
            End If
        Next

    End If
    GetPDSettings = settingsValue
exitPoint:
    Set xmlDoc = Nothing
End Function

Public Function ReplaceIllegalCharInFileName(ByVal fileName As String) As String
    fileName = Application.CleanString(fileName)
    fileName = Trim(fileName)
    For Each v In Array("/", "\", "|", ":", "*", "?", "<", ">", """", "#", "”", Chr(44), vbTab, vbNullChar, vbCr, vbLf, vbCrLf)
    If v = vbTab Or v = vbNullChar Or v = vbCr Or v = vbLf Or v = vbCrLf Then
        fileName = Replace(fileName, v, "")
    Else
        fileName = Replace(fileName, v, "_")
    End If
    Next
    ReplaceIllegalCharInFileName = fileName
End Function

Public Function IsInvalidTextCharacters(ByVal text As String) As Boolean
    Dim c As String
    Dim returnValue As Boolean
    returnValue = False
    For i = 1 To Len(text)
           c = Mid(text, i, 1)
'           If AscW(c) > 255 Or AscW(c) < 0 Then _
'                returnValue = True
            If Asc(c) > 255 Then _
                returnValue = True
                
            If c = "?" Then _
                returnValue = True
    Next
    
    IsInvalidTextCharacters = returnValue
End Function

Public Sub LogError(ByVal logFileName As String, ByVal docNameOnDisk As String, ByVal docNameInAgenda As String, ByVal path As String)
    Dim fileNum As Integer
    Dim logDir As String
    
    logDir = GetDirectory(logFileName)
    
    If Not FileOrDirExists(logDir) Then _
        MkDir logDir
    
    'file number
    fileNum = FreeFile
    
    'logFileName should include the full file name (including the path)
    'will create the file if it doesn't exist
    Open logFileName For Append As #fileNum
    
    If docNameOnDisk = "" Then docNameOnDisk = "Hyperlink document not available"
    If docNameInAgenda = "" Then docNameInAgenda = "Document in Agenda not available"
    If path = "" Then path = "N/A"
    
    Print #fileNum, "FileName: Source Document Name on disk [" + docNameOnDisk + "], Document Name in agenda [" + docNameInAgenda + "] - Path: [" + path + "]"
    
    'Close the file
    Close #fileNum
End Sub

Public Sub FinalizeAgendaLogErrors(ByVal outputLogFile, ByVal tempLogFile)
    Dim tempLogNum As Integer
    Dim outLogNum As Integer
    Dim errorCount As Integer
    Dim temp As String
    Dim outputLogs As String
    
    tempLogNum = FreeFile
    Open tempLogFile For Input As #tempLogNum
    
    outLogNum = FreeFile
    Open outputLogFile For Append As #outLogNum
    
    Do While Not EOF(tempLogNum)
        Line Input #tempLogNum, temp
        outputLogs = outputLogs + vbCrLf + temp
        errorCount = errorCount + 1
    Loop
    
    Print #outLogNum, "Hint 1:"
    Print #outLogNum, "This log file contains a list of documents that failed to convert to PDF or failed to have its associated hyperlink created correctly. This could be due to (but not limited to) a corrupt document; a file type that pdfDocs Desktop does not support, or issues with the original file type. You could attempt to open the original source document and printing to the DocsCorp printer."
    Print #outLogNum, ""
    Print #outLogNum, "Hint 2:"
    Print #outLogNum, "Hyperlinks must not contain invalid characters."
    Print #outLogNum, "Some of the invalid characters for hyperlinks and the target filenames are \ / : * ? " + Chr(34) + " < > | , # @"
    Print #outLogNum, "If found, some of these characters will be automatically replaced by underscore character (_)."
    Print #outLogNum, "Other language Unicode characters are also not supported for hyperlinks and the target file names."
    
    Print #outLogNum, ""
    Print #outLogNum, "Total number of documents failed : " & errorCount
    Print #outLogNum, outputLogs
    
    Close #tempLogNum
    Close #outLogNum
End Sub

Public Function URLDecode(sEncodedURL As String) As String

On Error GoTo Catch

Dim iLoop   As Integer
Dim sRtn    As String
Dim sTmp    As String

If Len(sEncodedURL) > 0 Then
    ' Loop through each char
    For iLoop = 1 To Len(sEncodedURL)
        sTmp = Mid(sEncodedURL, iLoop, 1)
        'sTmp = Replace(sTmp, "+", " ")
        ' If char is % then get next two chars
        ' and convert from HEX to decimal
        If sTmp = "%" And Len(sEncodedURL) + 1 > iLoop + 2 Then
            sTmp = Mid(sEncodedURL, iLoop + 1, 2)
            sTmp = Chr(CDec("&H" & sTmp))
            ' Increment loop by 2
            iLoop = iLoop + 2
        End If
        sRtn = sRtn & sTmp
    Next
    URLDecode = sRtn
End If

Finally:
    Exit Function
Catch:
    URLDecode = ""
    Resume Finally
End Function


