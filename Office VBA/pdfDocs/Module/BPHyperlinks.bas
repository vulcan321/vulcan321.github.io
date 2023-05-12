Attribute VB_Name = "BPHyperlinks"
Public Sub OutputWebLinks(ByVal OutputFile As String, suppressDialog As Boolean, Optional ByVal isCreatingAgenda As Boolean)
On Error GoTo OnError
    ActiveDocument.Range 0, 0
    ActiveDocument.Select
    
    GetWebLinks OutputFile, suppressDialog, isCreatingAgenda
    
OnEnd:
    Exit Sub
OnError:
    MsgBox strErrorMessage & " " & Err.Number & " " & Err.Description
    GoTo OnEnd
End Sub

Public Sub OutputReferenceLinks(ByVal OutputFile As String, suppressDialog As Boolean)
On Error GoTo OnError
    ActiveDocument.Range 0, 0
    ActiveDocument.Select
    
    GetReferenceLinks OutputFile, suppressDialog
    
OnEnd:
    Exit Sub
OnError:
    MsgBox strErrorMessage & " " & Err.Number & " " & Err.Description
    GoTo OnEnd
End Sub

Private Function GetWebLinks(ByVal OutputFile As String, ByVal suppressDialog As Boolean, Optional ByVal isCreatingAgenda As Boolean) As Boolean
   Dim isFile As Boolean
    GetLinks = True
    
    'BP
    Dim BPLink As BPLink
    Dim BPLinkCollection As BPLinkCollection
    Dim BPRegion As BPRegion
    Dim BPRegionCollection As BPRegionCollection
    
    'Document
    Dim Field As Field
    Dim Hyperlink As Hyperlink
    Dim Bookmark As Bookmark
    
    'Flow
    Dim BookmarkName As String
    Dim Points() As Integer
    Dim i As Integer
    
    'Gathered for BPLink object
    Dim LinkType As BPLinkType
    Dim address() As String
    Dim Region() As String
    
On Error GoTo OnError
    Set BPLinkCollection = New BPLinkCollection
    
    'HyperLinks
    For Each Hyperlink In ActiveDocument.hyperLinks
        If Not g_Terminate Then
            Set BPRegion = Nothing
            Set BPRegionCollection = Nothing
            
On Error GoTo OnInvalidHyperlink
            If (Len(Hyperlink.address) > 0) Then 'Web
                LinkType = URL
                
                ReDim address(2)
                address(0) = Hyperlink.address
                
                Dim prefix As String
                Dim colon As Integer
                prefix = ""
                colon = -1
                colon = InStr(address(0), ":")
                
                If colon > 0 Then
                    prefix = Mid(address(0), 1, colon - 1)
                End If
                
                isFile = False
                If Not prefix = "mailto" Then
                    ' Add current directory for local address
                    If InStr(address(0), "/") = 0 Then
                        If InStr(address(0), "\") = 0 Then
                            'address(0) = Hyperlink.Parent.Path + "\" + address(0)
                            isFile = True
                        End If
                    End If
                
                  ' Add current directory to resolve relative directory
                  If InStr(address(0), "../") > 0 Then
                        'address(0) = Hyperlink.Parent.Path + "\" + address(0)
                        isFile = True
                  End If
                  
                  If Not isFile And InStr(Hyperlink.address, ":/") = 0 And Not InStr(Hyperlink.address, ":\\") > 0 Then
                      isFile = True
                  End If
    
                  If isFile Then
                    address(0) = "file:///" + address(0)
                  End If
                  
                End If
                
                
                Hyperlink.Range.Select
                BPSelectionHelper.GetRegionCollection Hyperlink.Range, BPRegionCollection
                
                For i = 1 To BPRegionCollection.count
                    Set BPLink = New BPLink
                    
                    Set BPRegion = BPRegionCollection.Item(i)
                    BPRegion.GetPoints Points
                    ReDim Region(UBound(Points) - 1)
                    For j = LBound(Points) To UBound(Points) - 1
                        Region(j) = Points(j)
                    Next
                    BPLink.Attributes = Region
                    BPLink.address = address
                    BPLink.LinkType = LinkType
                    BPLinkCollection.Add BPLink
                Next
            End If
OnInvalidHyperlink:
On Error GoTo OnError

        If Not suppressDialog Then g_ProgressForm.SetProgress BPProgressType.BPProgressIncrement, strFormProgressExternalHyperlinks
        End If
    Next Hyperlink
    
    'Shapes
    Dim shape As shape
    For Each shape In ActiveDocument.Shapes
        If Not shape Is Nothing Then
            Set BPLinkCollection = GetShapeHyperlinks(shape, BPLinkCollection, False)
        End If
    Next shape
    
    'GET ENDNOTES OF THE DOCUMENT
    'If (ActiveDocument.Sections.count > 0) Then
        'Set BPLinkCollection = GetEndNotes(BPLinkCollection)
    'End If
    
    'GET FOOTNOTES OF THE DOCUMENT
    If (ActiveDocument.Sections.count > 0) Then
        Set BPLinkCollection = GetFootNotes(BPLinkCollection)
    End If
    
    If Not g_Terminate Then
        With BPLinkCollection
            .File = OutputFile
            .isCreatingAgenda = isCreatingAgenda
            .WriteToFile
        End With
    End If

OnEnd:
    Exit Function
OnError:
    MsgBox strErrorMessage & " " & Err.Number & " " & Err.Description
    GetLinks = False
    GoTo OnEnd
End Function
Private Function GetEndNotes(ByVal BPLinkCollection As BPLinkCollection) As BPLinkCollection
    Dim Points() As Integer
    
    Dim LinkType As BPLinkType
    Dim address() As String
    Dim Region() As String
    
    Dim BPLink As BPLink
    Dim BPRegion As BPRegion
    Dim BPRegionCollection As BPRegionCollection
    

    Dim LastSection As Integer
    Dim LastEndnoteSection As Integer
    Dim EndnoteStartPageNo As Integer
    Dim DocumentHasEndnotes As Boolean
    Dim y3Value As Integer 'Track the y3 co-ordinate value when it decreases increment page number
    Dim ptY1 As Integer 'Current node y co-ordinate value
   
   
   If (ActiveDocument.Sections.count > 0) Then
        LastSection = ActiveDocument.Sections.count
        Dim i As Integer
        For i = 1 To ActiveDocument.Sections.count
          If (ActiveDocument.Sections(i).Range.Endnotes.count > 0) Then
             LastEndnoteSection = i
             DocumentHasEndnotes = True
          End If
        Next i
    End If
    
    
    
If (DocumentHasEndnotes) Then
    ActiveDocument.Sections(LastSection).Range.Select
    EndnoteStartPageNo = Selection.Range.Information(wdActiveEndPageNumber)
               
        For Each note In ActiveDocument.Sections(LastEndnoteSection).Range.Endnotes
        
             note.Range.Select
             ptY1 = ActiveDocument.ActiveWindow.Selection.Information(wdVerticalPositionRelativeToPage)
                
            'HR: Need to adjust pagenumber according to endnote sections as we can't determine with current page number of the note
             If (y3Value < ptY1) Then
                y3Value = ptY1
                
             ElseIf (y3Value > ptY1) Then
                 y3Value = ptY1
                 EndnoteStartPageNo = EndnoteStartPageNo + 1
             End If
                    
            If (note.Range.hyperLinks.count > 0) Then
               
                'HyperLinks
                For Each Hyperlink In note.Range.hyperLinks
                If Not g_Terminate Then
                    Set BPRegion = Nothing
                    Set BPRegionCollection = Nothing
            
On Error GoTo OnInvalidHyperlink
            '<VBA_INSPECTOR>
            '   <CHANGE>
            '       <MESSAGE>Potentially contains changed items in the object model</MESSAGE>
            '       <ITEM>[wrd]Hyperlink.Address</ITEM>
            '       <URL>http://go.microsoft.com/fwlink/?LinkID=174832</URL>
            '   </CHANGE>
            '</VBA_INSPECTOR>
            If (Len(Hyperlink.address) > 0) Then 'Web
                LinkType = URL
                
                ReDim address(2)
                '<VBA_INSPECTOR>
                '   <CHANGE>
                '       <MESSAGE>Potentially contains changed items in the object model</MESSAGE>
                '       <ITEM>[wrd]Hyperlink.Address</ITEM>
                '       <URL>http://go.microsoft.com/fwlink/?LinkID=174832</URL>
                '   </CHANGE>
                '</VBA_INSPECTOR>
                address(0) = Hyperlink.address
                
                Dim prefix As String
                Dim colon As Integer
                prefix = ""
                colon = -1
                colon = InStr(address(0), ":")
                
                If colon > 0 Then
                    prefix = Mid(address(0), 1, colon - 1)
                End If
                
                If Not prefix = "mailto" Then
                
                    ' Add current directory for local address
                    If InStr(address(0), "/") = 0 Then
                        If InStr(address(0), "\") = 0 Then
                            address(0) = Hyperlink.Parent.path + "\" + address(0)
                        End If
                    End If
                
                  ' Add current directory to resolve relative directory
                  If InStr(address(0), "../") > 0 Then
                            address(0) = Hyperlink.Parent.path + "\" + address(0)
                    End If
                End If
                
                
                Hyperlink.Range.Select
                BPSelectionHelper.GetRegionCollection Hyperlink.Range, BPRegionCollection
                                
                For i = 1 To BPRegionCollection.count
                    Set BPLink = New BPLink
                    
                    Set BPRegion = BPRegionCollection.Item(i)
                    BPRegion.GetPoints Points
                    ReDim Region(UBound(Points) - 1)
                    For j = LBound(Points) To UBound(Points) - 1
                        Region(j) = Points(j)
                    Next
                    

                    'HR: Update with correct pagenumber
                    Region(0) = EndnoteStartPageNo
                    
                    BPLink.Attributes = Region
                    BPLink.address = address
                    BPLink.LinkType = LinkType
                    BPLinkCollection.Add BPLink
                Next
            End If
OnInvalidHyperlink:
On Error GoTo OnError

            g_ProgressForm.SetProgress BPProgressType.BPProgressIncrement, strFormProgressExternalHyperlinks
        End If
                
                Next Hyperlink
            End If
            
        Next note
        
      End If
   
    Set GetEndNotes = BPLinkCollection
OnError:
    Exit Function
End Function
Private Function GetFootNotes(ByVal BPLinkCollection As BPLinkCollection) As BPLinkCollection
    Dim Points() As Integer
    
    Dim LinkType As BPLinkType
    Dim address() As String
    Dim Region() As String
    
    Dim BPLink As BPLink
    Dim BPRegion As BPRegion
    Dim BPRegionCollection As BPRegionCollection
    
    Dim ActiveDocSection As Section
    Dim Hyperlink As Hyperlink
    
On Error GoTo OnError
    
    For Each ActiveDocSection In ActiveDocument.Sections
      If (ActiveDocSection.Range.Footnotes.count > 0) Then
        Dim note As Footnote
        
        For Each note In ActiveDocSection.Range.Footnotes
            If (note.Range.hyperLinks.count > 0) Then
               
                'HyperLinks
                For Each Hyperlink In note.Range.hyperLinks
                If Not g_Terminate Then
                    Set BPRegion = Nothing
                    Set BPRegionCollection = Nothing
            
On Error GoTo OnInvalidHyperlink
            If (Len(Hyperlink.address) > 0) Then 'Web
                LinkType = URL
                
                ReDim address(2)
                address(0) = Hyperlink.address
                
                Dim prefix As String
                Dim colon As Integer
                prefix = ""
                colon = -1
                colon = InStr(address(0), ":")
                
                If colon > 0 Then
                    prefix = Mid(address(0), 1, colon - 1)
                End If
                
                If Not prefix = "mailto" Then
                
                    ' Add current directory for local address
                    If InStr(address(0), "/") = 0 Then
                        If InStr(address(0), "\") = 0 Then
                            address(0) = Hyperlink.Parent.path + "\" + address(0)
                        End If
                    End If
                
                  ' Add current directory to resolve relative directory
                  If InStr(address(0), "../") > 0 Then
                            address(0) = Hyperlink.Parent.path + "\" + address(0)
                    End If
                End If
                
                
                Hyperlink.Range.Select
                BPSelectionHelper.GetRegionCollection Hyperlink.Range, BPRegionCollection
                                
                For i = 1 To BPRegionCollection.count
                    Set BPLink = New BPLink
                    
                    Set BPRegion = BPRegionCollection.Item(i)
                    BPRegion.GetPoints Points
                    ReDim Region(UBound(Points) - 1)
                    For j = LBound(Points) To UBound(Points) - 1
                        Region(j) = Points(j)
                    Next
                    
                    BPLink.Attributes = Region
                    BPLink.address = address
                    BPLink.LinkType = LinkType
                    BPLinkCollection.Add BPLink
                Next
            End If
OnInvalidHyperlink:
On Error GoTo OnError

            g_ProgressForm.SetProgress BPProgressType.BPProgressIncrement, strFormProgressExternalHyperlinks
        End If
                
                Next Hyperlink
            End If
            
        Next note
        
      End If
   Next ActiveDocSection
    Set GetFootNotes = BPLinkCollection
OnError:
    Exit Function
End Function
Private Function GetShapeHyperlinks(ByVal s As shape, ByVal BPLinkCollection As BPLinkCollection, ByVal canvasItems As Boolean) As BPLinkCollection
    Dim Points() As Integer
    
    Dim LinkType As BPLinkType
    Dim address() As String
    Dim Region() As String
    
    Dim BPLink As BPLink
    Dim BPRegion As BPRegion
    Dim BPRegionCollection As BPRegionCollection
 On Error GoTo OnResumeFromShapeerror
    Set GetShapeHyperlinks = BPRegionCollection
    If Not s.TextFrame.HasText = 0 Then
    
        For Each Hyperlink In s.TextFrame.TextRange.hyperLinks
            If Not g_Terminate Then
                Set BPRegion = Nothing
                Set BPRegionCollection = Nothing
            
On Error GoTo OnInvalidHyperlink2
                If (Len(Hyperlink.address) > 0) Then 'Web
                    LinkType = URL
                
                    ReDim address(2)
                    address(0) = Hyperlink.address
                
                    prefix = ""
                    colon = -1
                    colon = InStr(address(0), ":")
                
                    If colon > 0 Then
                        prefix = Mid(address(0), 1, colon - 1)
                    End If
                
                    If Not prefix = "mailto" Then
                
                        ' Add current directory for local address
                        If InStr(address(0), "/") = 0 Then
                            If InStr(address(0), "\") = 0 Then
                                address(0) = Hyperlink.Parent.path + "\" + address(0)
                            End If
                        End If
                
                        ' Add current directory to resolve relative directory
                        If InStr(address(0), "../") > 0 Then
                            address(0) = Hyperlink.Parent.path + "\" + address(0)
                        End If
                    End If
                
                
                    Hyperlink.Range.Select
                    BPSelectionHelper.GetRegionCollection Hyperlink.Range, BPRegionCollection
                
                    For i = 1 To BPRegionCollection.count
                        Set BPLink = New BPLink
                    
                        Set BPRegion = BPRegionCollection.Item(i)
                        BPRegion.GetPoints Points
                        ReDim Region(UBound(Points) - 1)
                        For j = LBound(Points) To UBound(Points) - 1
                            Region(j) = Points(j)
                        Next
                        BPLink.Attributes = Region
                        BPLink.address = address
                        BPLink.LinkType = LinkType
                        BPLinkCollection.Add BPLink
                    Next
                End If
                g_ProgressForm.SetProgress BPProgressType.BPProgressIncrement, strFormProgressExternalHyperlinks
            End If
        Next Hyperlink
    End If
    
    On Error GoTo OnResumeFromCanvaserror
    If Not canvasItems Then
 
            For Each shape In s.canvasItems
                Set BPLinkCollection = GetShapeHyperlinks(shape, BPLinkCollection, True)
            Next
OnResumeFromCanvaserror:
OnResumeFromShapeerror:
    End If
    Set GetShapeHyperlinks = BPLinkCollection
    Exit Function
OnInvalidHyperlink2:
End Function


Private Function GetReferenceLinks(ByVal OutputFile As String, ByVal suppressDialog As Boolean) As Boolean
    GetLinks = True
    
    'BP
    Dim BPLink As BPLink
    Dim BPLinkCollection As BPLinkCollection
    Dim BPRegion As BPRegion
    Dim BPRegionCollection As BPRegionCollection
    
    'Document
    Dim Field As Field
    Dim Hyperlink As Hyperlink
    Dim Bookmark As Bookmark
    Dim Paragraph As Paragraph
    
    'Flow
    Dim BookmarkName As String
    Dim Points() As Integer
    Dim i As Integer
    Dim StartofRef As Integer
    Dim EndofRef As Integer
    Dim RefRange As Range
    
    'Gathered for BPLink object
    Dim LinkType As BPLinkType
    Dim address() As String
    Dim Region() As String
    
    Dim UserBookmarksShowHidden As Boolean
                
On Error GoTo OnError
    Set BPLinkCollection = New BPLinkCollection
    UserBookmarksShowHidden = ActiveDocument.bookMarks.ShowHidden
    ActiveDocument.bookMarks.ShowHidden = True
    
    'Cross References
    For Each Field In ActiveDocument.Fields
        If Not g_Terminate Then
            Set BPLink = New BPLink
            BookmarkName = ""
            
            If (Field.Type = WdFieldType.wdFieldRef Or _
                Field.Type = WdFieldType.wdFieldPageRef Or _
                Field.Type = WdFieldType.wdFieldFootnoteRef Or _
                Field.Type = WdFieldType.wdFieldNoteRef Or _
                Field.Type = WdFieldType.wdFieldStyleRef) Then
                
                LinkType = JUMP
                                
                Field.Result.Select
                Set BPRegion = Nothing
                Set BPRegionCollection = Nothing
                BPSelectionHelper.GetRegionCollection Field.Result, BPRegionCollection
                
                'Code Text is in the format of "REF <BOOKMARK> \h"
                'where <BOOKMARK> is the 3rd word, with a trailing space
                'BookmarkName = Field.Code.Words(3).Text
On Error GoTo OnInvalidField

' Formats observed are :
'REF _Ref246146662 \r \h
'REF _Ref246146795 \r \h  \* MERGEFORMAT
'HYPERLINK  \l "SourcesofInformation"

' So for REFS we get need to get the 2nd word
' and for HYPERLINKS we need to get the 3rd word

            Dim fieldCode As String
             fieldCode = Trim(Field.Code.text)
             
             ' HACK - must remove sets of spaces and collapse to one space, or the Split function misbehaves
             ' Have looked for other alternatives (ie a real Split method) but to no avail in short time
             ' this is a quick hack to get the client running again
             ' Best solution is a split method that treats consecutive delimiters as just one delimiter
             ' - problem is consecutive delimiters currently return empty string, messing with out indexing
             fieldCode = Replace(fieldCode, "     ", " ")
             fieldCode = Replace(fieldCode, "    ", " ")
             fieldCode = Replace(fieldCode, "   ", " ")
             fieldCode = Replace(fieldCode, "  ", " ")
            Dim index As Integer
             index = 2 ' default
             
            If InStr(fieldCode, "REF") = 1 Then
                'for REF types, look at the 1th position (2nd item)
                index = 1
            ElseIf InStr(fieldCode, "HYPERLINK") = 1 Then
                'for HYPERLINK types, look at the 2th position (3rd item)
                index = 2
            ElseIf InStr(fieldCode, "PAGEREF") = 1 Then
                'for HYPERLINK types, look at the 2th position (3rd item)
                index = 1
            End If
            
            Dim splitString
            'splitString = SplitEx(fieldCode, " ", vbNullString, True) ' Split(fieldCode, " ")
            splitString = Split(fieldCode, " ")
            
                BookmarkName = splitString(index)
                For Each Bookmark In ActiveDocument.bookMarks
                    If Bookmark.Name = Trim(BookmarkName) Then
                        Bookmark.Select
                    End If
                Next Bookmark

                
                BPSelectionHelper.GetRegion ActiveDocument.ActiveWindow.Selection.Range, Points
                ReDim address(2)
                For i = LBound(Points) To 2 'We only want [PAGENO],[X-COORD],[Y-COORD]
                    address(i) = Points(i)
                Next
    
                For i = 1 To BPRegionCollection.count
                    Set BPLink = New BPLink
                    
                    Set BPRegion = BPRegionCollection.Item(i)
                    BPRegion.GetPoints Points
                    ReDim Region(UBound(Points) - 1)
                    For j = LBound(Points) To UBound(Points) - 1
                        Region(j) = Points(j)
                    Next
                    BPLink.Attributes = Region
                    BPLink.address = address
                    BPLink.LinkType = LinkType
                    BPLinkCollection.Add BPLink
                Next
            End If
            
OnInvalidField:
On Error GoTo OnError

            If Not suppressDialog Then
                g_ProgressForm.SetProgress BPProgressType.BPProgressIncrement, strFormProgressCrossReferences
            End If
        End If
    Next Field
    
    'HyperLinks (Jumps)
    For Each Hyperlink In ActiveDocument.hyperLinks
        If Not g_Terminate Then
            Set BPRegion = Nothing
            Set BPRegionCollection = Nothing
            
On Error GoTo OnInvalidHyperlink
            If (Len(Hyperlink.address) <= 0) Then 'Jump
                LinkType = JUMP
                
                BPSelectionHelper.GetRegionCollection Hyperlink.Range, BPRegionCollection
                If Trim(Hyperlink.address) = "" And Not Trim(Hyperlink.SubAddress) = "" Then
                    For Each Bookmark In ActiveDocument.bookMarks
                        If Trim(Bookmark.Name) = Trim(Hyperlink.SubAddress) Then
                            Bookmark.Range.Select
                        End If
                    Next
                Else
                    Hyperlink.Follow
                End If
                
                'Hyperlink.Follow
                BPSelectionHelper.GetRegion ActiveDocument.ActiveWindow.Selection.Range, Points
                
                ReDim address(2)
                For i = LBound(Points) To 2 'We only want [PAGENO],[X-COORD],[Y-COORD]
                    address(i) = Points(i)
                Next
                
                
                For i = 1 To BPRegionCollection.count
                    Set BPLink = New BPLink
                    
                    Set BPRegion = BPRegionCollection.Item(i)
                    BPRegion.GetPoints Points
                    ReDim Region(UBound(Points) - 1)
                    For j = LBound(Points) To UBound(Points) - 1
                        Region(j) = Points(j)
                    Next
                    BPLink.Attributes = Region
                    BPLink.address = address
                    BPLink.LinkType = LinkType
                    BPLinkCollection.Add BPLink
                Next
            End If
            
OnInvalidHyperlink:
On Error GoTo OnError

            If Not suppressDialog Then
                g_ProgressForm.SetProgress BPProgressType.BPProgressIncrement, strFormProgressInternalLinks
            End If
        End If
    Next Hyperlink
    
    For k = 1 To ActiveDocument.Footnotes.count
        ActiveDocument.Footnotes(k).Reference.Select
        
        LinkType = JUMP
        BPSelectionHelper.GetRegionCollection ActiveDocument.ActiveWindow.Selection.Range, BPRegionCollection
        
        ActiveDocument.Footnotes(k).Range.Select
        BPSelectionHelper.GetRegion ActiveDocument.ActiveWindow.Selection.Range, Points
        ReDim address(2)
        For i = LBound(Points) To 2 'We only want [PAGENO],[X-COORD],[Y-COORD]
            address(i) = Points(i)
        Next
        
        For i = 1 To BPRegionCollection.count
            Set BPLink = New BPLink
            
            Set BPRegion = BPRegionCollection.Item(i)
            BPRegion.GetPoints Points
            ReDim Region(UBound(Points) - 1)
            For j = LBound(Points) To UBound(Points) - 1
                Region(j) = Points(j)
            Next
            BPLink.Attributes = Region
            BPLink.address = address
            BPLink.LinkType = LinkType
            BPLinkCollection.Add BPLink
        Next
        
        If Not suppressDialog Then
            g_ProgressForm.SetProgress BPProgressType.BPProgressIncrement, strFormProgressFootnotes
        End If
    Next

    For k = 1 To ActiveDocument.Endnotes.count
        LinkType = JUMP
        BPSelectionHelper.GetRegionCollection ActiveDocument.Endnotes(k).Reference, BPRegionCollection
        
        If ActiveDocument.Endnotes.Location = wdEndOfSection Then
            BPSelectionHelper.GetRegion ActiveDocument.Endnotes(k).Range, Points
            ReDim address(2)
            For i = LBound(Points) To 2 'We only want [PAGENO],[X-COORD],[Y-COORD]
                address(i) = Points(i)
            Next
        Else
            BPSelectionHelper.GetRegion ActiveDocument.Endnotes(k).Range, Points
            ReDim address(2)
            For i = LBound(Points) + 1 To 2 'We only want [PAGENO],[X-COORD],[Y-COORD]
                address(i) = Points(i)
            Next
            'For EndNotes where EndOfDocument location is selected, they are always located on the last
            'page of the document. For some strange reason, the Selection.Information used in GetRegion
            'does not pick up the correct page number.
            address(0) = ActiveDocument.BuiltInDocumentProperties(wdPropertyPages)
        End If
        
        For i = 1 To BPRegionCollection.count
            Set BPLink = New BPLink
            
            Set BPRegion = BPRegionCollection.Item(i)
            BPRegion.GetPoints Points
            ReDim Region(UBound(Points) - 1)
            For j = LBound(Points) To UBound(Points) - 1
                Region(j) = Points(j)
            Next
            BPLink.Attributes = Region
            BPLink.address = address
            BPLink.LinkType = LinkType
            BPLinkCollection.Add BPLink
        Next
        
        If Not suppressDialog Then
            g_ProgressForm.SetProgress BPProgressType.BPProgressIncrement, strFormProgressEndnotes
        End If
    Next

    If Not g_Terminate Then
        With BPLinkCollection
            .File = OutputFile
            .WriteToFile
        End With
    End If

OnEnd:
    ActiveDocument.bookMarks.ShowHidden = UserBookmarksShowHidden
    Exit Function
OnError:
    GetLinks = False
    GoTo OnEnd
End Function

Public Function GetBinderLinks(ByVal OutputFile As String) As Boolean
    GetBinderLinks = True
    
    'BP
    Dim BPLink As BPLink
    Dim BPLinkCollection As BPLinkCollection
    Dim BPRegion As BPRegion
    Dim BPRegionCollection As BPRegionCollection
    
    'Document
    Dim Field As Field
    Dim Hyperlink As Hyperlink
    Dim Bookmark As Bookmark
    Dim Paragraph As Paragraph
    
    'Flow
    Dim BookmarkName As String
    Dim Points() As Integer
    Dim i As Integer
    Dim StartofRef As Integer
    Dim EndofRef As Integer
    Dim RefRange As Range
    
    'Gathered for BPLink object
    Dim LinkType As BPLinkType
    Dim address() As String
    Dim Region() As String
    
    Set BPLinkCollection = New BPLinkCollection
    
    'HyperLinks (Jumps)
    For Each Hyperlink In ActiveDocument.hyperLinks
        If Not g_Terminate Then
            Set BPRegion = Nothing
            Set BPRegionCollection = Nothing
            
            If (Len(Hyperlink.address) <= 0) Then 'Jump
                LinkType = JUMP
                
                BPSelectionHelper.GetRegionCollection Hyperlink.Range, BPRegionCollection
                If Trim(Hyperlink.address) = "" And Not Trim(Hyperlink.SubAddress) = "" Then
                    For Each Bookmark In ActiveDocument.bookMarks
                        If Trim(Bookmark.Name) = Trim(Hyperlink.SubAddress) Then
                            Bookmark.Range.Select
                        End If
                    Next
                Else
                    Hyperlink.Follow
                End If
                
                'Hyperlink.Follow
                BPSelectionHelper.GetRegion ActiveDocument.ActiveWindow.Selection.Range, Points
                
                ReDim address(2)
                For i = LBound(Points) To 2 'We only want [PAGENO],[X-COORD],[Y-COORD]
                    address(i) = Points(i)
                Next
                
                
                For i = 1 To BPRegionCollection.count
                    Set BPLink = New BPLink
                    
                    Set BPRegion = BPRegionCollection.Item(i)
                    BPRegion.GetPoints Points
                    ReDim Region(UBound(Points) - 1)
                    For j = LBound(Points) To UBound(Points) - 1
                        Region(j) = Points(j)
                    Next
                    BPLink.Attributes = Region
                    BPLink.address = address
                    BPLink.LinkType = LinkType
                    BPLink.SubAddress = Hyperlink.SubAddress
                    BPLinkCollection.Add BPLink
                Next
            End If
          End If
    Next Hyperlink
    
    If Not g_Terminate Then
        With BPLinkCollection
            .File = OutputFile
            .WriteToFile2
        End With
    End If

OnEnd:
    Exit Function
OnError:
    GetBinderLinks = False
    GoTo OnEnd
End Function
