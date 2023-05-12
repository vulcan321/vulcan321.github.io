Attribute VB_Name = "BPSelectionHelper"
Public Function GetRegion(ByRef inRange As Range, ByRef Points() As Integer)

    'Extensible array of points defining the region for
    'which this link will lay over. Generally it is a rectangle, but may include any number
    'of points. Note, the first number is the Page Numer, for example:
    '[PAGENO],[X-COORD],[Y-COORD],[X-COORD],[Y-COORD],[X-COORD],[Y-COORD],[X-COORD],[Y-COORD]
    
    Dim ptX1 As Integer
    Dim ptY1 As Integer
    Dim ptX2 As Integer
    Dim ptY2 As Integer
    Dim ptP1 As Integer
    
    Dim rgEnd As Range
    Dim InLineShape As InLineShape
    Dim IsInLineShape As Boolean
    Dim tmpRange As Range
    
    Set tmpRange = inRange.Duplicate
    tmpRange.start = inRange.start
    tmpRange.End = inRange.start
    tmpRange.Select
    
    'check if our range starts with page break (nonprinting chars)
    tmpRange.End = tmpRange.End + 1
    If tmpRange.text <> Application.CleanString(tmpRange.text) Then
        tmpRange.start = inRange.start + 1
        tmpRange.End = inRange.start + 1
    End If
    
    tmpRange.Select
    
    ptP1 = ActiveDocument.ActiveWindow.Selection.Information(wdActiveEndPageNumber)
    ptX1 = ActiveDocument.ActiveWindow.Selection.Information(wdHorizontalPositionRelativeToPage)
    ptY1 = ActiveDocument.ActiveWindow.Selection.Information(wdVerticalPositionRelativeToPage)
    
    'Determine the type of object contained within that range.
    'Test for the following: InLineShape
    For Each InLineShape In ActiveDocument.InlineShapes
        If ((InLineShape.Range.start >= inRange.start) And _
            (InLineShape.Range.start <= inRange.End) Or _
            (InLineShape.Range.End >= inRange.start) And _
            (InLineShape.Range.End <= inRange.End)) Then
            
            ptX2 = ptX1 + InLineShape.Width
            ptY2 = ptY1 + InLineShape.Height
            
            IsInLineShape = True
        End If
    Next InLineShape

    If IsInLineShape Then
        ReDim Points(0 To 9)
        Points(0) = ptP1   'Page
        
        Points(1) = ptX1   'Point Top,Left
        Points(2) = ptY1
        
        Points(3) = ptX2   'Point Top,Right
        Points(4) = ptY1
        
        Points(5) = ptX2   'Point Bottom,Right
        Points(6) = ptY2
        
        Points(7) = ptX1   'Point Bottom,Left
        Points(8) = ptY2
        
    Else
        Set rgEnd = inRange
        rgEnd.start = inRange.End
        rgEnd.End = inRange.End
        
        rgEnd.Select
        ptX2 = ActiveDocument.ActiveWindow.Selection.Information(wdHorizontalPositionRelativeToPage)
        ptY2 = ActiveDocument.ActiveWindow.Selection.Information(wdVerticalPositionRelativeToPage)
        
        ptY2 = ptY2 + Selection.Font.Size   'We use the font size to determine the bottom right
                                            'corner of the boundary
                                  
        ReDim Points(0 To 9)
        Points(0) = ptP1   'Page
        
        Points(1) = ptX1   'Point Top,Left
        Points(2) = ptY1
        
        Points(3) = ptX2   'Point Top,Right
        Points(4) = ptY1
        
        Points(5) = ptX2   'Point Bottom,Right
        Points(6) = ptY2
        
        Points(7) = ptX1   'Point Bottom,Left
        Points(8) = ptY2
    End If
    
    'Dim arrayPoly(1 To 5, 0 To 1) As Single
    'arrayPoly(1, 0) = Points(1)
    'arrayPoly(1, 1) = Points(2)
    'arrayPoly(2, 0) = Points(3)
    'arrayPoly(2, 1) = Points(4)
    'arrayPoly(3, 0) = Points(5)
    'arrayPoly(3, 1) = Points(6)
    'arrayPoly(4, 0) = Points(7)
    'arrayPoly(4, 1) = Points(8)
    'arrayPoly(5, 0) = Points(1)
    'arrayPoly(5, 1) = Points(2)
    'ActiveDocument.Shapes.AddPolyline arrayPoly
    
End Function

Public Function GetRegionCollection(ByVal inRange As Range, ByRef BPRegionCollection As BPRegionCollection)
    Dim BPRegion As BPRegion

    'Extensible array of points defining the region for
    'which this link will lay over. Generally it is a rectangle, but may include any number
    'of points. Note, the first number is the Page Numer, for example:
    '[PAGENO],[X-COORD],[Y-COORD],[X-COORD],[Y-COORD],[X-COORD],[Y-COORD],[X-COORD],[Y-COORD]
    
    Dim NewLine As Boolean
    Dim arrayPoly(1 To 5, 0 To 1) As Single
    Dim ActiveSelection As Selection
    Dim ptX1 As Integer 'From
    Dim ptY1 As Integer 'From
    Dim ptX2 As Integer 'To
    Dim ptY2 As Integer 'To
    Dim ptYP As Integer 'Peek
    Dim ptP1 As Integer 'Page
    
    Dim rgStart As Range
    Dim rgEnd As Range
    Dim rgPeek As Range
    Dim tmpRange As Range
    Dim InLineShape As InLineShape
    Dim IsInLineShape As Boolean
    Dim Points() As Integer
        
    Set BPRegionCollection = New BPRegionCollection
    
    ' JSL-0703027: Support for NESTED TABLES
    ' When retrieving the Selection.Information for a Range in a nested table,
    ' the result is returned relative to the parent table. To solve this problem
    ' we will try to find the nested table's position, and add that to all selection
    ' requests we perform.
    
    Dim ptPadX1 As Integer ' Left Padding
    Dim ptPadY1 As Integer ' Top Padding
    
    Dim runBack As Integer
    Dim lastNestLevel As Integer
    'lastNestLevel = ActiveDocument.ActiveWindow.Selection.Tables.NestingLevel
    
    Dim startPageNo As Integer: startPageNo = Selection.Information(wdActiveEndPageNumber)
                    
    '----------------------------------------
    ' [SB 3-Aug-11] Only do this code if we are in tables
    If ActiveDocument.ActiveWindow.Selection.Tables.count >= 1 Then
        
        Dim tbl As Table
        Set tbl = ActiveDocument.ActiveWindow.Selection.Tables.Item(1)
        lastNestLevel = tbl.NestingLevel
        'get the nesting level we are at
    
        If lastNestLevel > 1 Then

            Dim topMostParentCellY As Integer
            Dim topMostTableStart As Integer
            Dim rngTemp As Range: Set rngTemp = tbl.Range
                        
            Selection.Select
            
            ' JSL If this is a nested cell, then the value is relative to the Outer Most Cell
            ' This could be on a different page! We handle this later via 'Goto startPageNo'
            ptPadY1 = Selection.Information(wdVerticalPositionRelativeToPage)
                        
            ' JSL Select the Outer Most Cell, because this gives the coordinates relative to Page
            Do While rngTemp.Tables(1).NestingLevel > 1
                ' Expand the range one character beyond the nested table
                rngTemp.MoveEnd wdCharacter, 1
                rngTemp.Cells(1).Select
            Loop
            topMostParentCellY = Selection.Information(wdVerticalPositionRelativeToPage)
            ptPadY1 = ptPadY1 + topMostParentCellY
                                    
            topMostTableStart = rngTemp.Tables(1).Range.start
        
            ' Detect/Handle the topMostParentCell spanning more than 1 page
            Selection.GoTo What:=wdGoToPage, Which:=wdGoToAbsolute, count:=startPageNo
            Selection.Select
            
            Dim rngTemp2 As Range: Set rngTemp2 = Selection.Range
        
            If Selection.Information(wdWithInTable) Then
            
                Set rngTemp = Selection.Tables(1).Range
                Do While rngTemp.Tables(1).NestingLevel > 1
                    ' Expand the range one character beyond the nested table
                    rngTemp.MoveEnd wdCharacter, 1
                    rngTemp.Select
                Loop
                
                Set rngTemp = rngTemp.Tables(1).Range
                rngTemp.Select
                
                If (rngTemp.start = topMostTableStart) Then
                
                    rngTemp2.Select
                    
                    If Selection.Tables(1).NestingLevel = 1 Then
                    
                        ' Hyperlink in a Spanning Cell (not within a nested cell)
                        ptPadY1 = ptPadY1 + Selection.Information(wdVerticalPositionRelativeToPage) - topMostParentCellY
                    
                    Else
                    
                        ' Hyperlink in a Spanning Cell (nested cell)
                    
                        ' [SB 3-Aug-11] We do not get proper Vert position as we are still in a nest
                        ' A rough approximation based on the text in the next table level up. This can be wrong
                        ptPadY1 = ptPadY1 + ActiveDocument.GridOriginVertical - topMostParentCellY
                    
                    End If
                Else
                
                    ' [SB 3-Aug-11] We are on the page where the top most parent table starts.
                    'ptPadY1 = ptPadY1 - topMostParentCellY
                    
                End If
            Else
            
                ' NOOP - No further adjustment needed if no longer in a table.
                'ptPadY1 = ptPadY1 - topMostParentCellY + Selection.Information(wdVerticalPositionRelativeToPage)
            
            End If
        Else
            'noop
        End If
    End If
    
    '----------------------------------------
                    
'    Do While (ActiveDocument.ActiveWindow.Selection.Tables.NestingLevel > 1) And _
'       (Selection.Start >= 0) And _
'       (startPageNo = Selection.Information(wdActiveEndPageNumber))

'       ' Go back 1 step
'       Selection.SetRange inRange.Start - runBack, inRange.Start - runBack + 1

'     If ActiveDocument.ActiveWindow.Selection.Tables.NestingLevel < lastNestLevel Then

'                        Selection.SelectCell

'                      'ptPadY1 = ptPadY1 + ActiveDocument.ActiveWindow.Selection.Information(wdVerticalPositionRelativeToPage)
'                      'ptPadY1 = ptPadY1 + ActiveDocument.GridOriginVertical ***ORIGINAL CODE
'
'                    ptPadY1 = ptPadY1 + ActiveDocument.ActiveWindow.Selection.Information(wdVerticalPositionRelativeToPage)
'
'                     lastNestLevel = ActiveDocument.ActiveWindow.Selection.Tables.NestingLevel
'
'                      Selection.SetRange inRange.Start - runBack, inRange.Start - runBack + 1
'                End If
'                runBack = runBack + 1
'           Loop
'
'       ' JSL-070327: This case here handles the specific scenario of a table nested within a cell,
'        ' that spans to a 2nd or further page. It is because the offset is no longer the position of
'        ' the parent cell, but rather the visible margin. (ActiveDocument.PageSetup.TopMargin gives us
'        ' an incorrect value too).
'              If lastNestLevel > 1 Then
'                 'ptPadY1 = ActiveDocument.ActiveWindow.Top
'                 'ptPadY1 = ActiveDocument.GridOriginVertical  ***THIS IS THE LIVE CODE
'                myPageNo = Selection.Information(wdActiveEndPageNumber)
'               Selection.GoTo What:=wdGoToPage, Which:=wdGoToAbsolute, count:=myPageNo
'              ptPadY1 = Selection.Information(wdVerticalPositionRelativeToPage)


'           'ptPadY1 = ActiveDocument.ActiveWindow.Selection.Information (wdVerticalPositionRelativeToPage)

'     End If

' JSL-0703027: Now that we have determined the necessary offsets, we can continue with the
' usual code of determining the start and end of the range selected. Notice when we add the
' range to the array, we apply the offsets.
                    
    Set tmpRange = inRange.Duplicate
    tmpRange.start = inRange.start
    tmpRange.End = inRange.start
    tmpRange.Select
    
    If ptPadY1 > 0 Then
        ptPadY1 = ptPadY1 - ActiveDocument.ActiveWindow.Selection.Information(wdVerticalPositionRelativeToPage)
    Else
        'NOOP
    End If
         
    ptP1 = ActiveDocument.ActiveWindow.Selection.Information(wdActiveEndPageNumber)
    ptX1 = ActiveDocument.ActiveWindow.Selection.Information(wdHorizontalPositionRelativeToPage)
    ptY1 = ActiveDocument.ActiveWindow.Selection.Information(wdVerticalPositionRelativeToPage)
    
    inRange.Select
    Set ActiveSelection = ActiveDocument.ActiveWindow.Selection
    
    'Determine the type of object contained within that range.
    'Test for the following: InLineShape
    For Each InLineShape In ActiveDocument.InlineShapes
        If ((InLineShape.Range.start >= inRange.start) And _
            (InLineShape.Range.start <= inRange.End) Or _
            (InLineShape.Range.End >= inRange.start) And _
            (InLineShape.Range.End <= inRange.End)) Then
            
            ptX2 = ptX1 + InLineShape.Width
            ptY2 = ptY1 + InLineShape.Height
            
            IsInLineShape = True
        End If
    Next InLineShape

    If IsInLineShape Then
        ReDim Points(0 To 9)
        Points(0) = ptP1   'Page
        
        Points(1) = ptPadX1 + ptX1   'Point Top,Left
        Points(2) = ptPadY1 + ptY1
        
        Points(3) = ptPadX1 + ptX2   'Point Top,Right
        Points(4) = ptPadY1 + ptY1
        
        Points(5) = ptPadX1 + ptX2   'Point Bottom,Right
        Points(6) = ptPadY1 + ptY2
        
        Points(7) = ptPadX1 + ptX1   'Point Bottom,Left
        Points(8) = ptPadY1 + ptY2
        
        Set BPRegion = New BPRegion
        BPRegion.Points = Points
        BPRegionCollection.Add BPRegion
    Else
        Set rgStart = inRange.Duplicate
        Set rgEnd = inRange.Duplicate
        rgEnd.start = inRange.End
        rgEnd.End = inRange.End
        rgEnd.Select
        
        Set ActiveSelection = ActiveDocument.ActiveWindow.Selection
        ptX2 = ActiveSelection.Information(wdHorizontalPositionRelativeToPage)
        ptY2 = ActiveSelection.Information(wdVerticalPositionRelativeToPage)
        
        If ptY1 = ptY2 Then 'Single Line
            ptY2 = ptY2 + Selection.Font.Size   'We use the font size to determine the bottom right
                                                'corner of the boundary
            ReDim Points(0 To 9)
            Points(0) = ptP1   'Page
            
            Points(1) = ptPadX1 + ptX1   'Point Top,Left
            Points(2) = ptPadY1 + ptY1
            
            Points(3) = ptPadX1 + ptX2   'Point Top,Right
            Points(4) = ptPadY1 + ptY1
            
            Points(5) = ptPadX1 + ptX2   'Point Bottom,Right
            Points(6) = ptPadY1 + ptY2
            
            Points(7) = ptPadX1 + ptX1   'Point Bottom,Left
            Points(8) = ptPadY1 + ptY2
            
            Set BPRegion = New BPRegion
            BPRegion.Points = Points
            BPRegionCollection.Add BPRegion
            
        Else 'Multiple Lines
            NewLine = True
            For i = 1 To inRange.Characters.count
                Set rgStart = inRange.Characters(i).Duplicate
                rgStart.Select
                Set ActiveSelection = ActiveDocument.ActiveWindow.Selection
                If NewLine Then
                    ptP1 = ActiveSelection.Information(wdActiveEndPageNumber)
                    ptX1 = ActiveSelection.Information(wdHorizontalPositionRelativeToPage)
                    ptY1 = ActiveSelection.Information(wdVerticalPositionRelativeToPage)
                    NewLine = False
                End If
                                
                'The painful part is here. We need to have a peek of one character ahead
                'then determine if the Y coord has changed. If it has, then we want to gen
                'the region based on the current Y coord, not one ahead
                Set rgPeek = rgStart.Duplicate
                rgPeek.start = rgStart.End + 1
                rgPeek.End = rgStart.End + 1
                rgPeek.Select
                Set ActiveSelection = ActiveDocument.ActiveWindow.Selection
                ptYP = ActiveSelection.Information(wdVerticalPositionRelativeToPage)
                
                'Trigger for starting a new line is based on the Y coord changing
                'when we peek one character ahead
                If rgStart.text = vbCr Then
                    NewLine = True
                Else
                    If ptY1 < ptYP Or i = inRange.Characters.count Then
                        Set rgEnd = rgStart.Duplicate
                        rgEnd.start = rgStart.End - 1
                        rgEnd.End = rgStart.End - 1
                        rgEnd.Select
                        Set ActiveSelection = ActiveDocument.ActiveWindow.Selection
                        ptX2 = ActiveSelection.Information(wdHorizontalPositionRelativeToPage)
                        If inRange.Characters(i).text = " " Then
                            ptX1 = ptX1 - inRange.Characters(i - 1).CharacterWidth
                        End If
                        If Not i = inRange.Characters.count Then
                            ptX2 = ptX2 + inRange.Characters(i).CharacterWidth
                        End If
                        ptY2 = ActiveSelection.Information(wdVerticalPositionRelativeToPage)
                        ptY2 = ptY2 + Selection.Font.Size   'We use the font size to determine the bottom right
                                                            'corner of the boundary
                        ReDim Points(0 To 9)
                        Points(0) = ptP1   'Page
                        
                        Points(1) = ptPadX1 + ptX1   'Point Top,Left
                        Points(2) = ptPadY1 + ptY1
                        
                        Points(3) = ptPadX1 + ptX2   'Point Top,Right
                        Points(4) = ptPadY1 + ptY1
                        
                        Points(5) = ptPadX1 + ptX2   'Point Bottom,Right
                        Points(6) = ptPadY1 + ptY2
                        
                        Points(7) = ptPadX1 + ptX1   'Point Bottom,Left
                        Points(8) = ptPadY1 + ptY2
                        
                        Set BPRegion = New BPRegion
                        BPRegion.Points = Points
                        BPRegionCollection.Add BPRegion
                                        
                        'arrayPoly(1, 0) = Points(1)
                        'arrayPoly(1, 1) = Points(2)
                        'arrayPoly(2, 0) = Points(3)
                        'arrayPoly(2, 1) = Points(4)
                        'arrayPoly(3, 0) = Points(5)
                        'arrayPoly(3, 1) = Points(6)
                        'arrayPoly(4, 0) = Points(7)
                        'arrayPoly(4, 1) = Points(8)
                        'arrayPoly(5, 0) = Points(1)
                        'arrayPoly(5, 1) = Points(2)
                        'ActiveDocument.Shapes.AddPolyline arrayPoly
                    
                        NewLine = True
                    End If
                End If
            Next
        End If
    End If
End Function

Private Sub SelectionUpEnd()
    ActiveDocument.ActiveWindow.Selection.MoveUp Unit:=wdLine, count:=1, Extend:=wdExtend
    ActiveDocument.ActiveWindow.Selection.EndKey Unit:=wdLine, Extend:=wdExtend
End Sub
