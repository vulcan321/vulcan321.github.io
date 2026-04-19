# VBA清除Word文档中所有图片及形状


```vba
Private Sub CommandButton2_Click()
Dim doc As Object
Dim i As Integer
Set doc = ActiveDocument
                For i = 1 To doc.InlineShapes.Count
                    doc.InlineShapes(1).Delete
                Next
                For i = 1 To doc.Shapes.Count
                    doc.Shapes(1).Delete
                Next
End Sub
```

就是循环当前文档所有Shapes 及 InlineShapes，然后删除。
