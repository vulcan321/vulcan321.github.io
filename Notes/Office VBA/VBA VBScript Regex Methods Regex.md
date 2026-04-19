# [VBA VBScript Regex Methods Regex](https://www.tutorialandexample.com/vba-vbscript-regex-methods-regex#)

**VBA VBScript Regex Methods Regex**

The VBA Regex supports 3 methods which are as follows:

1.  Execute
2.  Replace
3.  Text

1.  **Execute**

The execute method is used to extract a match from the given based on the defined matching Regex pattern. It returns an Object which retains all the matches, unlike an Array.

In the below program we have created a Function to collect all the matches found in the given string  which will match the regex Pattern string and will return an object holding all the matches found in the string (unlike an array). At last, we have looped through the returned object to read all the matches found.

**Syntax**

```vb
Execute (String value)
```

**Program:**

```vb
Function VBA_Regex_ExecuteMethod(regexVar As String, stringVar As String)
'***************************************************************
' Example for Execute Method of Regular Expression
'***************************************************************
Dim regex As Object
Set regex = CreateObject("VBScript.RegExp")
Dim matchedObj As Object
With regex
    .Pattern = regexVar
    .Global = True
    .IgnoreCase = True
    .MultiLine = True
End With
' The matchesObj object will store all the matches as
' returned by execute method of RegEx
Set matchedObj = rgx.Execute(stringVar)
'Loop to read all the matches found
For Each Item In allMatches
    Debug.Print Item.Value
Next
End Function
```