# VBA : Copy text from one word document to another


This tutorial explains how you can copy content from one word document and paste it to another word document with VBA. This is one of the most common ask from stakeholder when you need to create a new MS word document daily or weekly which is a subset of the master document. If you do it manually, it's a tedious task and chances of having error would be high.

In the automated world we aim to automate our repetitive tasks as much as possible. As a request it looks easy but it's a bit complex as you need to handle MS word from Excel and need to give instructions to system via VBA about the changes and interactivity you want to implement.

___

## Copy all headings to another document

The program below copies each text which is formatted in `Heading 1` style and paste to a **new word document**. You need to make changes in the lines of code highlighted in **red**.

```vba
Sub CopyfromWord()
    
   ' Objects
    Dim wrdApp, objWord As Object
    Dim wrdDoc, newwrdDoc As Object
    Dim myPath As String, myPath1 As String
    Dim numberStart As Long
    Dim Rng, srchRng As Word.Range

   ' Close MS Word if it's already opened
    On Error Resume Next
     Set objWord = GetObject(, "Word.Application")
     If Not objWord Is Nothing Then
            objWord.Quit SaveChanges:=0
            Set objWord = Nothing
    End If
    
    'Open MS Word
    Set wrdApp = CreateObject("Word.Application")
        wrdApp.Visible = True
        
    ' Folder Location
    myPath = "C:\Users\DELL\Documents\Test\" 
    
    ' Input File
    Set wrdDoc = wrdApp.Documents.Open(myPath & "PD Calibration.docx")
    
    ' Output File
    Set newwrdDoc = wrdApp.Documents.Add
    myPath1 = myPath & "\newdoc1.docx"

    ' Text you want to search
    Dim FindWord As String
    Dim result As String
    FindWord = ""
    
    'Style
    mystyle = "Heading 1"
    
    'Defines selection for Word's find function
    wrdDoc.SelectAllEditableRanges
    
    ' Find Functionality in MS Word
    With wrdDoc.ActiveWindow.Selection.Find
        .Text = FindWord
        .Replacement.Text = ""
        .Forward = True
        .Wrap = 1
        .Format = False
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
        If mystyle <> "" Then
        .Style = mystyle
        End If
    End With
    
    ' Execute find method
    wrdDoc.ActiveWindow.Selection.Find.Execute
    
    ' Store Selected text
    result = wrdDoc.ActiveWindow.Selection.Text
    
    ' Check if result contains non-blank text
    If Len(result) > 1 Then
    
    ' -------------------------------------------------------------
    ' Loop through multiple find content (Find All functionality)
    ' -------------------------------------------------------------

    While wrdDoc.ActiveWindow.Selection.Find.Found
    wrdDoc.ActiveWindow.Selection.Copy
    
    'Activate the new document
    newwrdDoc.Activate
    
    'New Word Doc
    Set Rng = newwrdDoc.Content
    Rng.Collapse Direction:=wdCollapseEnd
    Rng.Paste
   
   'Word Document
   wrdDoc.Activate
   wrdDoc.ActiveWindow.Selection.Find.Execute
   
   Wend
   
   ' If style not found
    Else
        MsgBox "Text Not Found"
    End If
   
    'Close and don't save application
    wrdDoc.Close SaveChanges:=False
    
    'Save As New Word Document
    newwrdDoc.SaveAs myPath1
    newwrdDoc.Close SaveChanges:=False
    
    'Close all word documents
    wrdApp.Quit SaveChanges:=0
    
    'Message when done
    MsgBox "Task Accomplished"
End Sub

```

How to use the above program

1.  Open Excel Workbook
2.  Press **ALT + F11** shortcut key to open visual basic editor (VBE)
3.  To insert a module, go to **Insert > Module**
4.  Paste the complete VBA script below
5.  Specify the path of folder in `myPath` variable. It is the folder location where your input word document file is stored. Make sure to mention backward slash at the end.  
    `myPath = "C:\Users\DELL\Documents\Test\"`
6.  Specify file name of your input MS Word document  
    `Set wrdDoc = wrdApp.Documents.Open(myPath & "PD Calibration.docx")`
7.  File name you wish to have in your output file. New word doc will be saved with this name.  
    `myPath1 = myPath & "\newdoc1.docx"`
8.  Type word(s) you want to seach in Find box. **Keep it blank if you want to search by style only.** `FindWord = ""`.
9.  Specify style specific to your word document in `mystyle = "Heading 1"`.

How this program works

In this section we broken down the code into multiple snippets to make you understand how it works.

1\. First we are closing word documents if any of them is already opened. It is to avoid conflict interacting Excel with Word. This is a useful technique in terms of error handling in the code as sometimes code may crash because of multiple word documents being opened at the same time.

```
    On Error Resume Next
     Set objWord = GetObject(, "Word.Application")
     If Not objWord Is Nothing Then
            objWord.Quit SaveChanges:=0
            Set objWord = Nothing
    End If

```

2\. In this section of code we are opening the input word document.

```
    'Open MS Word
    Set wrdApp = CreateObject("Word.Application")
        wrdApp.Visible = True
        
    ' Folder Location
    myPath = "C:\Users\DELL\Documents\Test\"
    
    ' Input File
    Set wrdDoc = wrdApp.Documents.Open(myPath & "PD Calibration.docx")

```

3\. Here we are adding a new word document in which we want to copy the content.

```
    Set newwrdDoc = wrdApp.Documents.Add
    myPath1 = myPath & "\newdoc1.docx"

```

4\. User need to mention the word or style he/she wants MS Word to look for.

```
    ' Text you want to search
    Dim FindWord As String
    Dim result As String
    FindWord = ""
    
    'Style
    mystyle = "Heading 1"

```

5\. This part of the VBA code refers to Find feature in MS Word. Many of us enable this functionality by hitting **CTRL + F** shortcut key. `While ... Wend` is an alternative of Do While Loop. Here it is used to find all the words which are formatted as 'Heading 1' style. It is to find all the searched results in iterative manner. After copying the text it goes to the last filled content in the output doc and then paste the content after that.

```
    With wrdDoc.ActiveWindow.Selection.Find
        .Text = FindWord
        .Replacement.Text = ""
        .Forward = True
        .Wrap = 1
        .Format = False
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
        If mystyle <> "" Then
        .Style = mystyle
        End If
    End With
    
    ' Execute find method selects the found text if found
    wrdDoc.ActiveWindow.Selection.Find.Execute
    
    While wrdDoc.ActiveWindow.Selection.Find.Found
    wrdDoc.ActiveWindow.Selection.Copy
    
    'Activate the new document
    newwrdDoc.Activate
    
    'New Word Doc
    Set Rng = newwrdDoc.Content
    Rng.Collapse Direction:=wdCollapseEnd
    Rng.Paste
   
   'Word Document
   wrdDoc.Activate
   wrdDoc.ActiveWindow.Selection.Find.Execute
   
   Wend

```

6\. Last thing which is extremely important is to save the files and close MS Word application. We are closing the input file without saving any changes but the output file is saved with all the changes we made.

```
    'Close and don't save application
    wrdDoc.Close SaveChanges:=False
    
    'Save As New Word Document
    newwrdDoc.SaveAs myPath1
    newwrdDoc.Close SaveChanges:=False
    
    'Close all word documents
    wrdApp.Quit SaveChanges:=0

```

Copy text from one word document to already created word document

Suppose you don't want to create a new word document. Instead you wish to save it in the existing word doc you have. Assuming name of the output file is **newdoc1.docx**.  
  
Replace this line of code `Set newwrdDoc = wrdApp.Documents.Add` with the code below.

```
    Set newwrdDoc = wrdApp.Documents.Open(myPath & "newdoc1.docx")

```

_If you wish to save the file with the new name you can change in this line of code._

```
myPath1 = myPath & "\newdoc1_updated.docx"
```

## Find specific text and then copy the next 3 words or characters

Specify the word(s) you want to find in `FindWord = "Text you wish to search"` and make style blank in  
`mystyle = ""`  
  
Replace this line of code `wrdDoc.ActiveWindow.Selection.Copy` with the code below.

Next 3 words

```
    lngStart = wrdDoc.ActiveWindow.Selection.End
    wrdDoc.ActiveWindow.Selection.MoveRight Unit:=wdWord, Count:=3, Extend:=wdExtend
    wrdDoc.ActiveWindow.Selection.Collapse Direction:=wdCollapseEnd
    lngEnd = wrdDoc.ActiveWindow.Selection.Start
    wrdDoc.Range(lngStart, lngEnd).Copy
    wrdDoc.ActiveWindow.Selection.EndOf 

```

Next 3 Characters

```
   lngStart = wrdDoc.ActiveWindow.Selection.End
    wrdDoc.Range(lngStart, lngStart + 3).Copy

```

> If there are some **spaces** you may find the code extracts only 2 characters (or words) rather than 3 so you can increase the number from 3 to 4 in the code above

## Copy text between two words

Suppose you wish to pull all the text between two words (or headings). In the code below you can specify the words in `FindWord1` and `FindWord2` variables.

```
Sub CopyBetweenTexts()
    
   ' Objects
    Dim wrdApp, objWord As Object
    Dim wrdDoc, newwrdDoc As Object
    Dim myPath As String, myPath1 As String
    Dim numberStart As Long
    Dim Rng, srchRng As Word.Range

   ' Close MS Word if it's already opened
    On Error Resume Next
     Set objWord = GetObject(, "Word.Application")
     If Not objWord Is Nothing Then
            objWord.Quit SaveChanges:=0
            Set objWord = Nothing
    End If
    
    'Open MS Word
    Set wrdApp = CreateObject("Word.Application")
        wrdApp.Visible = True
        
    ' Folder Location
    myPath = "C:\Users\DELL\Documents\Test\"
    
    ' Input File
    Set wrdDoc = wrdApp.Documents.Open(myPath & "PD Calibration.docx")
    
    ' Output File
    Set newwrdDoc = wrdApp.Documents.Add
    myPath1 = myPath & "\newdoc1.docx"

    ' Text you want to search
    Dim FindWord1, FindWord2 As String
    Dim result As String
    FindWord1 = "Steps : PD Calibration"
    FindWord2 = "Test2 Steps : PD Calibration"
    
    'Style
    mystyle = ""

    'Defines selection for Word's find function
    wrdDoc.SelectAllEditableRanges
    
     ' Move your cursor to the start of the document
    wrdDoc.ActiveWindow.Selection.HomeKey unit:=wdStory

    'Find Functionality in MS Word
    With wrdDoc.ActiveWindow.Selection.Find
        .Text = FindWord1
        .Replacement.Text = ""
        .Forward = True
        .Wrap = 1
        .Format = False
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
        If mystyle <> "" Then
        .Style = mystyle
        End If
             If .Execute = False Then
            MsgBox "'Text' not found.", vbExclamation
            Exit Sub
        End If
        
        ' Locate after the ending paragraph mark (beginning of the next paragraph)
        ' wrdDoc.ActiveWindow.Selection.Collapse Direction:=wdCollapseEnd
        
        ' Starting character position of a selection
        lngStart = wrdDoc.ActiveWindow.Selection.End 'Set Selection.Start to include searched word
        .Text = FindWord2
        .Replacement.Text = ""
        .Forward = True
        .Wrap = 1
        .Format = False
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
        .Style = mystyle
        If .Execute = False Then
            MsgBox "'Text2' not found.", vbExclamation
            Exit Sub
        End If
        lngEnd = wrdDoc.ActiveWindow.Selection.Start 'Set Selection.End to include searched word
    End With
    
  'Copy Selection
  wrdDoc.Range(lngStart, lngEnd).Copy
    
    'Activate the new document
    newwrdDoc.Activate
    
    'New Word Doc
    Set Rng = newwrdDoc.Content
    Rng.Collapse Direction:=wdCollapseEnd
    Rng.Paste
   
   'Word Document
   wrdDoc.Activate
   wrdDoc.ActiveWindow.Selection.Find.Execute
   
    'Close and don't save application
    wrdDoc.Close SaveChanges:=False
    
    'Save As New Word Document
    newwrdDoc.SaveAs myPath1
    newwrdDoc.Close SaveChanges:=False
    
    'Close all word documents
    wrdApp.Quit SaveChanges:=0
    
    'Message when done
    MsgBox "Task Accomplished"
    
End Sub

```

## Find multiple different texts and copy in loop

If you wish to extract content between a couple of texts in iterative manner and then copy them one by one in another word document.  
Here we assume texts are stored in column B starting from cell B3. See the image below.


```
Sub CopyBetweenTexts2()
    
   ' Objects
    Dim wrdApp, objWord As Object
    Dim wrdDoc, newwrdDoc As Object
    Dim myPath As String, myPath1 As String
    Dim numberStart As Long
    Dim Rng, srchRng As Word.Range

   ' Close MS Word if it's already opened
    On Error Resume Next
     Set objWord = GetObject(, "Word.Application")
     If Not objWord Is Nothing Then
            objWord.Quit SaveChanges:=0
            Set objWord = Nothing
    End If
    
    'Open MS Word
    Set wrdApp = CreateObject("Word.Application")
        wrdApp.Visible = True
        
    ' Folder Location
    myPath = "C:\Users\DELL\Documents\Test\"
    
    ' Input File
    Set wrdDoc = wrdApp.Documents.Open(myPath & "PD Calibration.docx")
    
    ' Output File
    Set newwrdDoc = wrdApp.Documents.Add
    myPath1 = myPath & "\newdoc1.docx"

    ' Text you want to search
    Dim FindWord1, FindWord2 As String
    Dim result As String
    
    ' Find last used cell in column B
    Dim last As Double
    With ActiveSheet
        last = .Cells(.Rows.Count, "B").End(xlUp).Row
    End With

    ' Loop through column B
    j = last - 2
    For i = 1 To j
    
    FindWord1 = Cells(2 + i, 2).Value
    FindWord2 = Cells(3 + i, 2).Value
    
    'Style
    mystyle = ""

    'Defines selection for Word's find function
    wrdDoc.SelectAllEditableRanges
    
     ' Move your cursor to the start of the document
    wrdDoc.ActiveWindow.Selection.HomeKey unit:=wdStory

    'Find Functionality in MS Word
    With wrdDoc.ActiveWindow.Selection.Find
        .Text = FindWord1
        .Replacement.Text = ""
        .Forward = True
        .Wrap = 1
        .Format = False
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
        If mystyle <> "" Then
        .Style = mystyle
        End If
             If .Execute = False Then
            MsgBox "'Text' not found.", vbExclamation
            Exit Sub
        End If
        
        ' Locate after the ending paragraph mark (beginning of the next paragraph)
        ' wrdDoc.ActiveWindow.Selection.Collapse Direction:=wdCollapseEnd
        
        ' Starting character position of a selection
        lngStart = wrdDoc.ActiveWindow.Selection.End 'Set Selection.Start to include searched word
        .Text = FindWord2
        .Replacement.Text = ""
        .Forward = True
        .Wrap = 1
        .Format = False
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
        .Style = mystyle
        If .Execute = False Then
            MsgBox "'Text2' not found.", vbExclamation
            Exit Sub
        End If
        lngEnd = wrdDoc.ActiveWindow.Selection.Start 'Set Selection.End to include searched word
    End With
    
  If (i = j) Then
  wrdDoc.ActiveWindow.Selection.EndOf
  wrdDoc.ActiveWindow.Selection.EndKey unit:=wdStory
  lngEnd = wrdDoc.ActiveWindow.Selection.End
  End If
    
  'Copy Selection
  wrdDoc.Range(lngStart, lngEnd).Copy
    
    'Activate the new document
    newwrdDoc.Activate
    
    'New Word Doc
    Set Rng = newwrdDoc.Content
    Rng.Collapse Direction:=wdCollapseEnd
    Rng.Paste
    Next i
    
   'Word Document
   wrdDoc.Activate
   wrdDoc.ActiveWindow.Selection.Find.Execute
   
    'Close and don't save application
    wrdDoc.Close SaveChanges:=False
    
    'Save As New Word Document
    newwrdDoc.SaveAs myPath1
    newwrdDoc.Close SaveChanges:=False
    
    'Close all word documents
    wrdApp.Quit SaveChanges:=0
    
    'Message when done
    MsgBox "Task Accomplished"
    
End Sub

```

## Find Text and Replace All

Suppose you want to find a specific text and replace it with some text. If a text has more than 1 occurence, it should be dealt with. In other words, _Replace All_ functionality should be enabled. Here we are replacing it in the output document after copying from input word document. **Add the code below after line** `Next i` . Specify text in **.Text =** and **.Replacement.Text =**

```
   'Replace All Name
    newwrdDoc.Activate
    With newwrdDoc.ActiveWindow.Selection.Find
        .Text = "Text 1"
        .Replacement.Text = "Text 2"
        .Forward = True
        .Wrap = 1
        .Format = False
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
    End With
    newwrdDoc.ActiveWindow.Selection.Find.Execute Replace:=wdReplaceAll
```