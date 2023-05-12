Attribute VB_Name = "BPBookmarksStyles"
Public ActualPageCount As Integer

Public Function OutputBookmarksFromStyles(ByVal BPStyleCollection As BPStyleCollection, ByVal OutputFile As String, suppressDialog As Boolean, Optional ByVal IsAgenda As Boolean = False) As Boolean
On Error GoTo OnError
    
    'Get the styles from pdfDocs.ini
    GetBookmarks BPStyleCollection, OutputFile, suppressDialog, IsAgenda
    OutputBookmarksFromStyles = True
OnEnd:
    Exit Function
OnError:
    If Err.Number <> 4605 Then
        MsgBox strErrorMessage & " " & Err.Number & " " & Err.Description & " " & strErrorIn & " " & Err.Source
    End If
    GoTo OnEnd
End Function

Private Function GetBookmarks(ByRef BPStyleCollection As BPStyleCollection, ByVal OutputFile As String, ByVal suppressDialog As Boolean, Optional ByVal IsAgenda As Boolean = False) As Boolean
    GetBookmarks = True
    
    'BP
    Dim BPStyle As BPStyle
    Dim BPLink As BPLink
    Dim BPLinkCollection As BPLinkCollection
    Dim BPLCSelected As BPStyleCollection
    
    'Document
    Dim Paragraph As Paragraph
    Dim Points() As Integer
    Dim BookmarkListFormat As String
    Dim BookmarkText As String
    Dim BookmarkRange As Range
    Dim BookmarkSelection As Selection
    Dim tmpRange As Range
    
    'Gathered for BPLink object
    Dim LinkType As BPLinkType
    Dim address() As String
    Dim Attributes() As String
    
    'Create Agenda
    Dim prefix As String
    
    'To help improve the speed, we'll create a style collection
    'of only the ones which were selected
    Set BPLCSelected = New BPStyleCollection
    For i = 1 To BPStyleCollection.count
        If BPStyleCollection.Item(i).Checked Then
            BPLCSelected.Add BPStyleCollection.Item(i)
        End If
    Next

On Error GoTo OnError
    Set BPLinkCollection = New BPLinkCollection
    For Each Paragraph In ActiveDocument.Paragraphs
        If Not g_Terminate Then
        
On Error GoTo OnInvalidParagraph
            Paragraph.Range.Select
            
            For i = 1 To BPLCSelected.count
                If Not Paragraph.Style Is Nothing Then
                    If (BPLCSelected.Item(i).Name = Paragraph.Style.NameLocal) Then
        
                        Set BookmarkRange = Paragraph.Range.Duplicate
                        BookmarkListFormat = Paragraph.Range.ListFormat.listString
                        
                        'Do While BookmarkRange.Paragraphs.First.PageBreakBefore = True
                        '    BookmarkRange.Start = BookmarkRange.Start + 1
                        'Loop
                        
                        BookmarkText = Application.CleanString(BookmarkRange.text)
                        BookmarkText = Replace(BookmarkText, vbCr, "")
                        
                        ' Remove trailing non-printable characters
                        If Len(BookmarkText) > 1 Then
                            Do While InStr(BookmarkText, vbCrLf) = Len(BookmarkText) Or _
                                InStr(BookmarkText, vbCr) = Len(BookmarkText) Or _
                                InStr(BookmarkText, vbLf) = Len(BookmarkText) Or _
                                InStr(BookmarkText, vbTab) = Len(BookmarkText) Or _
                                InStr(BookmarkText, vbNullChar) = Len(BookmarkText) Or _
                                InStr(BookmarkText, " ") = Len(BookmarkText)
                                
                                BookmarkText = Mid(BookmarkText, 1, Len(BookmarkText) - 1)
                            Loop
                        End If
                        
                        ' Remove leading non-printable characters
                        If Len(BookmarkText) > 1 Then
                            Do While InStr(BookmarkText, vbCrLf) = 1 Or _
                                InStr(BookmarkText, vbCr) = 1 Or _
                                InStr(BookmarkText, vbLf) = 1 Or _
                                InStr(BookmarkText, vbTab) = 1 Or _
                                InStr(BookmarkText, vbNullChar) = 1 Or _
                                InStr(BookmarkText, " ") = 1
            
                                BookmarkText = Mid(BookmarkText, 2)
                            Loop
                        End If
                        
                        BookmarkText = Application.CleanString(BookmarkRange.text)
                        BookmarkText = Replace(BookmarkText, vbCr, "")
                        
                        'PD-18839 From Create Agenda Template
                        If IsAgenda And Selection.Information(wdWithInTable) Then
                            If BookmarkRange.rows.count = 1 _
                                    And BookmarkRange.rows(1).Cells.count = 2 _
                                    And BookmarkRange.hyperLinks.count > 0 Then
                                
                                Dim cellRange As Range
                                Set cellRange = BookmarkRange.rows(1).Cells(1).Range
                            
                                prefix = Application.CleanString(cellRange.text)
                                prefix = Replace(prefix, vbCr, "")
                                
                                ' Remove trailing non-printable characters
                                If Len(prefix) > 1 Then
                                    Do While InStr(prefix, vbCrLf) = Len(prefix) Or _
                                        InStr(prefix, vbCr) = Len(prefix) Or _
                                        InStr(prefix, vbLf) = Len(prefix) Or _
                                        InStr(prefix, vbTab) = Len(prefix) Or _
                                        InStr(prefix, vbNullChar) = Len(prefix) Or _
                                        InStr(prefix, " ") = Len(prefix)
                                        
                                        prefix = Mid(prefix, 1, Len(prefix) - 1)
                                    Loop
                                End If
                                
                                ' Remove leading non-printable characters
                                If Len(prefix) > 0 Then
                                    Do While InStr(prefix, vbCrLf) = 1 Or _
                                        InStr(prefix, vbCr) = 1 Or _
                                        InStr(prefix, vbLf) = 1 Or _
                                        InStr(prefix, vbTab) = 1 Or _
                                        InStr(prefix, vbNullChar) = 1 Or _
                                        InStr(prefix, " ") = 1
                    
                                        prefix = Mid(prefix, 2)
                                    Loop
                                End If
                                
                                prefix = Trim(prefix)
                                
                                If prefix = "" And cellRange.ListParagraphs.count > 0 Then
                                    If Asc(cellRange.ListFormat.listString) <> 63 Then
                                        prefix = cellRange.ListFormat.listString
                                    End If
                                End If
                                
                                'Prepend '0' if prefix is numeric, else: just concatenate
'                                Dim num As Integer
'                                If IsNumeric(prefix) Then
'                                    num = Val(prefix)
'                                    If num < 10 Then prefix = "0" & prefix
'                                End If
                                
                                BookmarkText = prefix + " " + Trim(BookmarkText)
                            End If
                        End If
                        'End from Create Agenda Template
                        
                        If BookmarkListFormat <> "" Then
                            BookmarkText = BookmarkListFormat + " " + BookmarkText
                        End If
                        
                        If Len(BookmarkText) > 0 Then
                            Set BPLink = New BPLink
                            
                            BPSelectionHelper.GetRegion BookmarkRange, Points
                            ReDim address(0 To 2)
                            For j = LBound(Points) To 2 'We only want [PAGENO],[X-COORD],[Y-COORD]
                                address(j) = Points(j)
                            Next
                            
                            ReDim Attributes(0 To 1)
                            Attributes(0) = BPLCSelected.Item(i).Weight
                            Attributes(1) = BookmarkText
                            
                            BPLink.LinkType = BKMARK
                            BPLink.address = address
                            BPLink.Attributes = Attributes
                            BPLinkCollection.Add BPLink
                        End If
                    End If
                End If
            Next
OnInvalidParagraph:
On Error GoTo OnError
        
            If Not suppressDialog Then g_ProgressForm.SetProgress BPProgressType.BPProgressIncrement
        End If
    Next Paragraph
    
    If Not g_Terminate Then
        With BPLinkCollection
            .File = OutputFile
            .isCreatingAgenda = IsAgenda
            .WriteToFile
        End With
    End If
    
OnEnd:
    Exit Function
OnError:
    GetBookmarks = False
    GoTo OnEnd
End Function

