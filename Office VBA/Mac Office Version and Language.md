### Mac Excel Version and Mac Office Language settings

It can be useful to know what the Excel version and the Excel language is of the Excel application that opens your workbook so your code can do different things depending of the version/language.  
  
**Note**: Read also this page [Test if it is a Mac or a Windows Machine](https://macexcel.com/examples/setupinfo/versionlanguage//../../../examples/setupinfo/testmacwin/ "Test Mac or Windows")

\_\_

#### Excel version number

You can use Application.Version to get the version number of Excel as a string. We can use the Val function in Excel to make it numeric so we can test the number. Note that Win Excel give you a whole number 16 and Mac Excel will give you also the update number like 16.65 for example.  
  
The macro below will display a msgbox with the Excel version, working in Excel for Windows also, you can replace the msgbox line with your code or a Macro call.
```vb
Sub TestMacOrWindowsOfficeVersion()
'Test the conditional compiler constants
    #If MAC_OFFICE_VERSION >= 15 Then
        MsgBox "Excel 2016 or higher for the Mac, version: " & _
            Val(Application.Version)
        Exit Sub
    #End If
    
    #If Mac Then
        If Val(Application.Version) < 15 Then
            MsgBox "Excel 2011 or earlier for the Mac, version: " & _
                Val(Application.Version)
        End If
    #Else
        MsgBox "Excel for Windows, version: " & _
            Val(Application.Version)
    #End If
End Sub
```
**  
More Information**  
  
In Mac Office 2016 they add a new conditional compiler constant named MAC\_OFFICE\_VERSION. In most cases you can test the Application.Version(>=15) if you want, but in the macro above I use it for testing if it is a Mac and Excel 2016 or higher in one step.  
  
But if you want to avoid compile errors with for example ribbon macro callbacks in **Excel 2011**(this not compile for example in 2011: control As IRibbonControl) or use VBA functions that are new in 2016 like AppleScriptTask and GrantAccessToMultipleFiles, you can add the ribbon macro callbacks or the new VBA functions in between the two code lines below in your code module.  
  
#If MAC\_OFFICE\_VERSION >= 15 Then  
  
Put your macro callbacks or code here  
  
#End If  
  
**Note** : Excel 2019 and Excel 365 on the Mac or Windows also use number 16  
  
**Note**: Mac Excel will not give you a whole number like Win Excel but also give you the update number.  
  
**Note**: You see that Mac Excel 2016 can be version number 15.? or 16.?, but if you are up to date with Mac Excel 2016 you always have version 16.  
  
If you also want to test on the whole number on your Mac you can use this :  
  
Int(Val(Application.Version))  
  
**Test macro for Excel 2016, 2019 and 365 in Windows or Mac**  
  
Because 2016, 2019 and 365 all give you the answer 16 I build this test macro to get the real version, I not really like it but so far it is the only thing i can get to work. Will update the code when needed.
```vb
Sub TestExcelVersion_2016_2019_365()
    'Testcode for Excel 2016, 2019 and 365 in Win and Mac Excel
    'Application.version will display 16 for all versions
    Dim Answ As String
 
    If Int(Val(Application.Version)) = 16 Then
 
        On Error Resume Next
        'Test the xmatch function NEW in Excel 365
        Answ = Application.Evaluate("=XMATCH(5,{5,4,3,2,1})")
        If Err = 0 Then
            MsgBox "You run Excel 365"
        Else
            Err.Clear
            'Test the concat function NEW in Excel 2019
            Answ = Application.Evaluate("=CONCAT(""A"",""B"")")
            If Err = 0 Then
                MsgBox "You run Excel 2019"
            Else
                MsgBox "You run Excel 2016"
            End If
        End If
        
    End If
End Sub
```
#### Laguage ID of Excel

f you want to know the exact language of the userinterface of Excel you can use this to return the language ID number in Excel for Windows and in Excel 2016 for the Mac version 16 or higher but it is not working on a Mac in the older Excel versions <16 :  
Application.LanguageSettings.LanguageID(msoLanguageIDUI)  
  
But I found this when I was looking in the VBE editor and it seems to give the same result in Mac Office 2011 and in version 15 of Excel 2016.  
  
Application.LocalizedLanguage  
  
To find the ID for every language visit :[Language Identifier List](https://docs.microsoft.com/en-us/deployoffice/office2016/language-identifiers-and-optionstate-id-values-in-office-2016)  
  
You can use Select Case now to run different code for each language, for example to display the captions of your buttons in the correct language or something else.  
  
The Example below will work in Mac Excel 2011 and higher  
  
**Note** that I replace **msoLanguageIDUI** for **2** in the code below so it compile in version 15

```vb
Sub Test()
    If Val(Application.Version) >= 16 Then
    ' You use Mac Excel version 16 or higher
        Select Case Application.LanguageSettings.LanguageID(2)
            Case 1031: MsgBox "Run code for German"
            Case 1034: MsgBox "Run code for Spanish"
            Case 1036: MsgBox "Run code for French"
            Case 1043: MsgBox "Run code for Dutch"
            Case 1049: MsgBox "Run code for Russian"
            Case Else: MsgBox "Run code for English US(default 1033)"
        End Select
    Else
        ' You use Mac Excel version 15 or lower
        Select Case Application.LocalizedLanguage
            Case 1031: MsgBox "Run code for German"
            Case 1034: MsgBox "Run code for Spanish"
            Case 1036: MsgBox "Run code for French"
            Case 1043: MsgBox "Run code for Dutch"
            Case 1049: MsgBox "Run code for Russian"
            Case Else: MsgBox "Run code for English US(default 1033)"
        End Select
    End If
End Sub
```
10/3/22