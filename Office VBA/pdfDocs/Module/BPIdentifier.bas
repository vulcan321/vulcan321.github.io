Attribute VB_Name = "BPIdentifier"
Public Function OutputIdentifierFile(ByVal IdentifierAction As String, ByVal outputFileName As String, ByVal ThumbnailCollectionString As String) As Boolean
    OutputIdentifierFile = False
    
    Dim PrintLine As String
    Dim OutputFile As Integer
    Dim objFSO As Object
    Dim objFile As Object
    
On Error GoTo OnAnsiMethod
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Set objFile = objFSO.OpenTextFile(outputFileName, 8, True, -1) ' ForAppending = 8, Create, Format

OnAnsiMethod:
On Error GoTo OnError
    If objFile Is Nothing Then
        OutputFile = FreeFile
        Open outputFileName For Append As #OutputFile
    End If
    
    If objFile Is Nothing Then
        Print #OutputFile, "    " & IdentifierAction
        Print #OutputFile, "FullName=" & ActiveDocument.FullName
        Print #OutputFile, "Name=" & ActiveDocument.Name
        If ThumbnailCollectionString <> "" Then
            Print #OutputFile, "Sections=" & ThumbnailCollectionString
        End If
        
    Else
        
        objFile.WriteLine "    " & IdentifierAction
        objFile.WriteLine "FullName=" & ActiveDocument.FullName
        objFile.WriteLine "Name=" & ActiveDocument.Name
        
        If ThumbnailCollectionString <> "" Then
            objFile.WriteLine "Sections=" & ThumbnailCollectionString
        End If
        
    End If
    
    OutputIdentifierFile = True
    
OnEnd:
    If objFile Is Nothing Then
        Close #OutputFile
    Else
        objFile.Close
    End If
    Exit Function
OnError:
    MsgBox strErrorMessage & " " & Err.Number & " " & Err.Description
    GoTo OnEnd

End Function


