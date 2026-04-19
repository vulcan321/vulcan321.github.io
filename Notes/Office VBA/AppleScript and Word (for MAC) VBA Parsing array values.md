
The Applescript equivalent of an array is a list variable. It stores values like so `{val1, val2, val3}` and gets passed back as a string. 
What you want to do is then use the VBA method `Split` to parse these into an array. 
The following example demonstrates this.

```vbnet
Sub TestAppleScript()
    Dim MyScript As String, iNoTimes As Integer, MyArray As Variant
    Dim arrStr() As String

    iNoTimes = 2

     MyScript = "set ArrayReturn to {}" & vbNewLine
     MyScript = MyScript & "repeat with i from 1 to " & iNoTimes & vbNewLine
     MyScript = MyScript & "   set end of ArrayReturn to """"" & vbNewLine
     MyScript = MyScript & "   set item i of ArrayReturn to i" & vbNewLine
     MyScript = MyScript & "end repeat" & vbNewLine
     MyScript = MyScript & "return ArrayReturn"

    MyArray = MacScript(MyScript)

    If MyArray <> "" Then arrStr = Split(MyArray, ",")
End Sub
```