VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BPLinkCollection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'BPLinkCollection is a strongly typed collection of BPLink objects

'It also posesses the power to write the collection to file, in a format
'which pdfDOCS will understand. The format goes something like this:
'
'[TYPE],[[ADDRESS+0],[ADDRESS+1],[ADDRESS+2]],[[POINT+0],[POINT+1],[POINT+2],[POINT+N]]
'

Private m_LinkFile As String
Private m_IsCreatingAgenda As Boolean
Private m_BPLinkCollection As Collection

Private Sub Class_Initialize()
    Set m_BPLinkCollection = New Collection
End Sub

Public Property Let File(ByVal File As String)
    m_LinkFile = File
End Property

Public Property Let isCreatingAgenda(ByVal isCreatingAgenda As Boolean)
    m_IsCreatingAgenda = isCreatingAgenda
End Property

Public Property Get count() As Long
    count = m_BPLinkCollection.count
End Property

Public Sub Add(ByVal BPLink As BPLink)
    m_BPLinkCollection.Add BPLink
End Sub

Public Sub Remove(ByVal BPLink As BPLink)
    m_BPLinkCollection.Remove BPLink
End Sub

Public Sub WriteToFile()
    Dim BPLink As BPLink
    Dim PrintLine As String
    Dim OutputFile As Integer
    Dim objFSO As Object
    Dim objFile As Object
    
On Error GoTo OnAnsiMethod
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Set objFile = objFSO.OpenTextFile(m_LinkFile, 8, True) ' ForAppending = 8, Create, Format

OnAnsiMethod:
On Error GoTo OnError
    If objFile Is Nothing Then
        OutputFile = FreeFile
        Open m_LinkFile For Append As #OutputFile
    End If
    
    For Each BPLink In m_BPLinkCollection
        On Error Resume Next 'Should Proceed on the next loop if failed in writing an invalid serialized output (invalid characters, etc.)
        If objFile Is Nothing Then
            Print #OutputFile, BPLink.Serialized
        Else
            objFile.WriteLine BPLink.Serialized
        End If
    Next BPLink

OnEnd:
    If objFile Is Nothing Then
        Close #OutputFile
    Else
        objFile.Close
    End If
    Exit Sub
    
OnError:
    If Not m_IsCreatingAgenda Then _
        MsgBox strErrorMessage & " " & Err.Number & " " & Err.Description
    GoTo OnEnd
End Sub

Public Sub WriteToFile2()
    Dim BPLink As BPLink
    Dim PrintLine As String
    Dim OutputFile As Integer
    Dim objFSO As Object
    Dim objFile As Object
    
On Error GoTo OnAnsiMethod
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Set objFile = objFSO.OpenTextFile(m_LinkFile, 8, True) ' ForAppending = 8, Create, Format

OnAnsiMethod:
On Error GoTo OnError
    If objFile Is Nothing Then
        OutputFile = FreeFile
        Open m_LinkFile For Append As #OutputFile
    End If
    
       
    For Each BPLink In m_BPLinkCollection
        If objFile Is Nothing Then
            Print #OutputFile, BPLink.Serialized2
        Else
            objFile.WriteLine BPLink.Serialized2

        End If
    Next BPLink
    
OnEnd:
    If objFile Is Nothing Then
        Close #OutputFile
    Else
        objFile.Close
    End If
    Exit Sub
    
OnError:
    MsgBox strErrorMessage & " " & Err.Number & " " & Err.Description
    GoTo OnEnd
End Sub





