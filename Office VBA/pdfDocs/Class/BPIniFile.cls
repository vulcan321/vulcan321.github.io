VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BPIniFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private iFilename As String, iSection As String, iKey As String, _
 iErrCode As Long, iErrVar(1 To 2) As String

Public Property Let Key(ByVal Key As String)
    iKey = Key
End Property

Public Property Get Key() As String
    Key = iKey
End Property

Public Property Let Section(ByVal Section As String)
    iSection = Section
End Property

Public Property Get Section() As String
    Section = iSection
End Property

Public Property Let fileName(ByVal fileName As String)
    iFilename = fileName
End Property

Public Property Get fileName() As String
    fileName = iFilename
End Property

Public Function CheckIniFile(Optional fileName As String) As Boolean
    Dim tFilename As String
    CheckIniFile = False
    tFilename = GetFileName(fileName)
    
    If Len(tFilename) = 0 Then
        Exit Function
    End If
    
    If Len(dir(tFilename)) = 0 Then
        Exit Function
    End If
    
    CheckIniFile = True
End Function

Public Function GetAllSectionsFromInifile(Optional ByVal fileName As String, Optional Sorted As Boolean = False) As Collection
    Dim tFilename As String, i As Long, j As Long, nBuffer As String, _
        res As Long, tStr As String, nItems() As String
    
    Const kBufferSize = 32767
    tFilename = GetFileName(fileName)
    
    If CheckIniFile(tFilename) = True Then
        Set GetAllSectionsFromInifile = New Collection
        nBuffer = Space$(kBufferSize)
        res = BPExternals.GetPrivateProfileSectionNames(nBuffer, kBufferSize, tFilename & vbNullString)
        If res = 0 Then
            Exit Function
        End If
        
        nItems = Split(Left$(nBuffer, res), Chr$(0))
        If Sorted = True Then
            For i = LBound(nItems) To UBound(nItems) - 1
                For j = i To UBound(nItems)
                    If StrComp(nItems(i), nItems(j), vbTextCompare) = 1 Then
                        tStr = nItems(i): nItems(i) = nItems(j): nItems(j) = tStr
                    End If
                Next j
            Next i
        End If
        
        For i = 0 To UBound(nItems)
            If Trim$(nItems(i)) <> "" Then
                GetAllSectionsFromInifile.Add nItems(i)
            End If
        Next i
    End If
End Function

Public Function CheckSection(Optional Section As String, Optional fileName As String) As Boolean
    Dim tFilename As String, tSection As String, i As Long, tColl As Collection
    CheckSection = False
    tFilename = GetFileName(fileName)
    tSection = GetSectionname(Section)
    Set tColl = GetAllSectionsFromInifile(tFilename)
    
    If Not tColl Is Nothing Then
        For i = 1 To tColl.count
            If UCase$(tSection) = UCase$(tColl.Item(i)) Then
                CheckSection = True
                Set tColl = Nothing
                Exit Function
            End If
        Next i
    End If
    
    Set tColl = Nothing
End Function

Public Function GetAllKeysFromSection(Optional Section As String, Optional fileName As String, Optional WithComments As Boolean = False, Optional Sorted As Boolean = False) As Collection
    Const kBufferSize = 32767
    Dim tFilename As String, tSection As String, nBuffer As String, res As Long, _
        nItems() As String, nItem() As String, i As Long, tColl As Collection, _
        ts(1) As String, j As Long, tStr As String
    
    tFilename = GetFileName(fileName)
    tSection = GetSectionname(Section)
    
    Set tColl = New Collection
    Set GetAllKeysFromSection = tColl
    If CheckSection(tSection, tFilename) = True Then
        nBuffer = Space$(kBufferSize)
        res = BPExternals.GetPrivateProfileSection(tSection, nBuffer, kBufferSize, tFilename)
        If res = 0 Then
            Exit Function
        End If
        
        nItems = Split(Left$(nBuffer, res), Chr$(0))
        If Sorted = True Then
            For i = LBound(nItems) To UBound(nItems) - 1
                For j = i To UBound(nItems)
                    If StrComp(nItems(i), nItems(j), vbTextCompare) = 1 Then
                        tStr = nItems(i): nItems(i) = nItems(j): nItems(j) = tStr
                    End If
                Next j
            Next i
        End If
        
        For i = LBound(nItems) To UBound(nItems)
            If Len(Trim$(nItems(i))) > 0 Then
                If WithComments = True Then
                    If InStr(nItems(i), "=") > 0 Then
                        nItem = Split(nItems(i), "=")
                        ts(0) = nItem(0): ts(1) = nItem(1)
                        tColl.Add ts
                    Else
                        ts(0) = nItems(i): ts(1) = vbNullString
                        tColl.Add ts
                    End If
                Else
                    If InStr(Trim$(nItems(i)), ";") <> 1 Then
                        If InStr(nItems(i), "=") > 0 Then
                            nItem = Split(nItems(i), "=")
                            ts(0) = nItem(0): ts(1) = nItem(1)
                            tColl.Add ts
                        Else
                            ts(0) = nItems(i): ts(1) = vbNullString
                            tColl.Add ts
                        End If
                    End If
                End If
            End If
        Next i
        Set GetAllKeysFromSection = tColl
    End If
End Function

Public Function CheckKey(Optional Key As String, Optional Section As String, Optional fileName As String) As Boolean
    Dim tFilename As String, tSection As String, tKey As String, _
        i As Long, tColl As Collection
    CheckKey = False
    tFilename = GetFileName(fileName)
    tSection = GetSectionname(Section)
    tKey = GetKeyname(Key)
    
    Set tColl = GetAllKeysFromSection(tSection, tFilename)
    For i = 1 To tColl.count
        If UCase$(tKey) = UCase$(tColl.Item(i)(0)) Then
            CheckKey = True
            Set tColl = Nothing
            Exit Function
        End If
    Next i
End Function

Public Function GetKeyFromSection(Optional Key As String, Optional Section As String, Optional fileName As String) As String
    Const kBufferSize = 1024
    Dim nBuffer As String, tKey As String, tSection As String, tFilename As String, _
        tColl As Collection, i As Long, res As Long
    tFilename = GetFileName(fileName)
    tSection = GetSectionname(Section)
    tKey = GetKeyname(Key)

    GetKeyFromSection = vbNullString
    If CheckSection(tSection, tFilename) = True Then
        Set tColl = GetAllKeysFromSection(tSection, tFilename)
        For i = 1 To tColl.count
            If UCase$(tKey) = UCase$(tColl.Item(i)(0)) Then
                GetKeyFromSection = tColl.Item(i)(1)
                Set tColl = Nothing
                Exit Function
            End If
        Next i
    End If
End Function

Public Sub DeleteIniFile(Optional fileName As String)
    Dim tFilename As String
    tFilename = GetFileName(fileName)
    If dir(tFilename) <> "" Then
        Kill tFilename
    End If
End Sub

Public Sub CreateIniFile(Optional fileName As String)
    Dim tFilename As String, fn As Long
    tFilename = GetFileName(fileName)
    
    fn = FreeFile
    Open tFilename For Output As #fn
    Close #fn
    FlushInifile
End Sub

Public Sub CreateSection(Optional Section As String, Optional fileName As String)
    Dim tFilename As String, tSection As String, res As Long, fn As Long
    
    tFilename = GetFileName(fileName)
    tSection = GetSectionname(Section)

    If CheckSection(tSection, tFilename) = False Then
        fn = FreeFile
        Open tFilename For Append As #fn
        Print #fn, "[" & tSection & "]"
        Close #fn
    End If
    FlushInifile
End Sub

Public Sub DeleteAllSectionFromInifile(Optional fileName As String)
    Dim tKey As String, tSection As String, tFilename As String, res As Long, _
        i As Long, tColl As Collection
    
    tFilename = GetFileName(fileName)
    
    If CheckIniFile(tFilename) = True Then
        res = BPExternals.WritePrivateProfileString(vbNullString, vbNullString, vbNullString, tFilename)
    End If
End Sub

Public Sub DeleteSectionFromInifile(Optional Section As String, Optional fileName As String)
    Dim tKey As String, tSection As String, tFilename As String, res As Long, _
        i As Long, tColl As Collection
    
    tFilename = GetFileName(fileName)
    tSection = GetSectionname(Section)
    
    If CheckSection(tSection, tFilename) = True Then
        res = BPExternals.WritePrivateProfileString(tSection, vbNullString, vbNullString, tFilename)
    End If
End Sub

Public Sub DeleteKeyFromSection(Optional Key As String, Optional Section As String, Optional fileName As String)
    Dim tKey As String, tSection As String, tFilename As String, res As Long
    
    tFilename = GetFileName(fileName)
    tSection = GetSectionname(Section)
    tKey = GetKeyname(Key)
    
    If CheckKey(tKey, tSection, tFilename) = True Then
        res = BPExternals.WritePrivateProfileString(tSection, tKey, vbNullString, tFilename)
    End If
End Sub

Public Function SaveKey(Value As String, Optional Key As String, Optional Section As String, Optional fileName As String) As Boolean
    Dim tKey As String, tSection As String, tFilename As String, res As Long
    
    tFilename = GetFileName(fileName)
    tSection = GetSectionname(Section)
    tKey = GetKeyname(Key)
    
    res = BPExternals.WritePrivateProfileString(tSection & vbNullString, tKey & vbNullString, _
        Value & vbNullString, tFilename & vbNullString)
    FlushInifile
End Function
Public Sub FlushInifile(Optional fileName As String)
    Dim res As Long, tFilename As String
    tFilename = GetFileName(fileName)
    res = BPExternals.WritePrivateProfileString(vbNullString, vbNullString, vbNullString, tFilename & vbNullString)
End Sub

Private Function GetFileName(ByVal fileName As String) As String
    fileName = Trim$(fileName)
    If Len(fileName) = 0 Then
        GetFileName = iFilename
    Else
        GetFileName = fileName
    End If
End Function

Private Function GetSectionname(ByVal Sectionname As String) As String
    Sectionname = Trim$(Sectionname)
    If Len(Sectionname) = 0 Then
        GetSectionname = iSection
    Else
        GetSectionname = Sectionname
    End If
End Function

Private Function GetKeyname(ByVal Keyname As String) As String
    Keyname = Trim$(Keyname)
    If Len(Keyname) = 0 Then
        GetKeyname = iKey
    Else
        GetKeyname = Keyname
    End If
End Function

