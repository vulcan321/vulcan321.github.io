# Excel VBA实现批量创建链接


```
Sub link()
    Dim num, sheetname
    
    Worksheets(1).Select
    
    num = WorksheetFunction.CountA(Columns("c:c"))
    'MsgBox num
    
    For i = 2 To num
        '把第一个sheet中第3列第i行单元格的值赋值给sheetname，作为后面创建sheet时的名称
        sheetname = Sheets(1).Cells(i, 3)
        
        '用单元格的值作为sheet名创建sheet
        On Error Resume Next
        Worksheets.Add(after:=Worksheets(Worksheets.Count)).Name = sheetname
        
        '在新建的sheet中，给A1单元格输入“返回”字符串
        Sheets(sheetname).Cells(1, 1) = "返回"
        
        '将新建的sheet中，返回字符串所在单元格创建链接，链接地址是第一个sheet中第3列，第i行单元格
        Sheets(sheetname).Hyperlinks.Add Anchor:=Sheets(sheetname).Cells(1, 1), Address:="", SubAddress:= _
        "汇总!C" & i
        
        'MsgBox """" & sheetname & "!A2"""
        'MsgBox Sheets(1).Cells(i, 3)
        
        '在第一个sheet中第3列，第i行添加链接，链接地址是第i个sheet的A1单元格
        Sheets(1).Hyperlinks.Add Anchor:=Sheets(1).Cells(i, 3), Address:="", SubAddress:=sheetname & "!A1"
                
    Next
        
End Sub
```