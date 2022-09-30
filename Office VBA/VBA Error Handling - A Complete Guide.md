# VBA Error Handling – A Complete Guide

by [Paul Kelly](https://excelmacromastery.com/author/admin/ "Posts by Paul Kelly") | | [Dealing with Errors](https://excelmacromastery.com/category/vba-error/), [Most Popular](https://excelmacromastery.com/category/most-popular/) | [116 comments](https://excelmacromastery.com/vba-error-handling/#respond)

**“Abort, Retry, Fail?” – MS-DOS error message circa 1986**

This post provides a complete guide to VBA Error Handing. If you are looking for a **quick summary** then check out the [quick guide table](https://excelmacromastery.com/vba-error-handling//#A_Quick_Guide_to_Error_Handing) in the first section.

If you are looking for a particular topic on VBA Error Handing then check out the table of contents below(if it’s not visible click on the post header).

If you are **new to VBA Error Handling**, then you can read the post from start to finish as it is laid out in logical order.

Contents \[[hide](https://excelmacromastery.com/vba-error-handling//#)\]

-   [1 A Quick Guide to Error Handing](https://excelmacromastery.com/vba-error-handling//#A_Quick_Guide_to_Error_Handing)
-   [2 The Webinar](https://excelmacromastery.com/vba-error-handling//#The_Webinar)
-   [3 Download the Error Handling Library](https://excelmacromastery.com/vba-error-handling//#Download_the_Error_Handling_Library)
-   [4 Introduction](https://excelmacromastery.com/vba-error-handling//#Introduction)
-   [5 VBA Errors](https://excelmacromastery.com/vba-error-handling//#VBA_Errors)
    -   [5.1 Syntax Errors](https://excelmacromastery.com/vba-error-handling//#Syntax_Errors)
    -   [5.2 Compilation Errors](https://excelmacromastery.com/vba-error-handling//#Compilation_Errors)
        -   [5.2.1 Using Debug->Compile](https://excelmacromastery.com/vba-error-handling//#Using_Debug-gtCompile)
        -   [5.2.2 Debug->Compile Error Summary](https://excelmacromastery.com/vba-error-handling//#Debug-gtCompile_Error_Summary)
        -   [5.2.3 Debug->Compile Usage](https://excelmacromastery.com/vba-error-handling//#Debug-gtCompile_Usage)
    -   [5.3 Runtime Errors](https://excelmacromastery.com/vba-error-handling//#Runtime_Errors)
        -   [5.3.1 Expected Versus Unexpected Errors](https://excelmacromastery.com/vba-error-handling//#Expected_Versus_Unexpected_Errors)
    -   [5.4 Runtime Errors that are not VBA Errors](https://excelmacromastery.com/vba-error-handling//#Runtime_Errors_that_are_not_VBA_Errors)
-   [6 The On Error Statement](https://excelmacromastery.com/vba-error-handling//#The_On_Error_Statement)
    -   [6.1 On Error GoTo 0](https://excelmacromastery.com/vba-error-handling//#On_Error_GoTo_0)
    -   [6.2 On Error Resume Next](https://excelmacromastery.com/vba-error-handling//#On_Error_Resume_Next)
    -   [6.3 On Error GoTo \[label\]](https://excelmacromastery.com/vba-error-handling//#On_Error_GoTo_label)
    -   [6.4 On Error GoTo -1](https://excelmacromastery.com/vba-error-handling//#On_Error_GoTo_-1)
    -   [6.5 Using On Error](https://excelmacromastery.com/vba-error-handling//#Using_On_Error)
-   [7 Resume Next](https://excelmacromastery.com/vba-error-handling//#Resume_Next)
-   [8 The Err Object](https://excelmacromastery.com/vba-error-handling//#The_Err_Object)
    -   [8.1 Getting the Line Number](https://excelmacromastery.com/vba-error-handling//#Getting_the_Line_Number)
    -   [8.2 Using Err.Raise](https://excelmacromastery.com/vba-error-handling//#Using_ErrRaise)
    -   [8.3 Using Err.Clear](https://excelmacromastery.com/vba-error-handling//#Using_ErrClear)
-   [9 Logging](https://excelmacromastery.com/vba-error-handling//#Logging)
-   [10 Other Error Related Items](https://excelmacromastery.com/vba-error-handling//#Other_Error_Related_Items)
    -   [10.1 Error Function](https://excelmacromastery.com/vba-error-handling//#Error_Function)
    -   [10.2 Error Statement](https://excelmacromastery.com/vba-error-handling//#Error_Statement)
-   [11 A Simple Error Handling Strategy](https://excelmacromastery.com/vba-error-handling//#A_Simple_Error_Handling_Strategy)
    -   [11.1 The Basic Implementation](https://excelmacromastery.com/vba-error-handling//#The_Basic_Implementation)
-   [12 A Complete Error Handling Strategy](https://excelmacromastery.com/vba-error-handling//#A_Complete_Error_Handling_Strategy)
    -   [12.1 An Example of using this strategy](https://excelmacromastery.com/vba-error-handling//#An_Example_of_using_this_strategy)
-   [13 Error Handling in a Nutshell](https://excelmacromastery.com/vba-error-handling//#Error_Handling_in_a_Nutshell)
-   [14 What’s Next?](https://excelmacromastery.com/vba-error-handling//#What8217s_Next)

## A Quick Guide to Error Handing

| Item | Description |
| --- | --- |
| On Error Goto 0 | When error occurs, the code stops and displays the error. |
| On Error Goto -1 | Clears the current error setting and reverts to the default. |
| On Error Resume Next | Ignores the error and continues on. |
| On Error Goto \[Label\] | Goes to a specific label when an error occurs.  
This allows us to handle the error. |
| Err Object | When an error occurs the error information is stored here. |
| Err.Number | The number of the error.  
(Only useful if you need to check a specific error occurred.) |
| Err.Description | Contains the error text. |
| Err.Source | You can populate this when you use Err.Raise. |
| Err.Raise | A function that allows you to generate your own error. |
| Error Function | Returns the error text from an error number.  
Obsolete. |
| Error Statement | Simulates an error. Use Err.Raise instead. |

## The Webinar

Members of the [Webinar Archives](https://excelmacromastery.com/excel-vba-webinars/) can access the webinar for this article by clicking on the image below.


## Download the Error Handling Library

(function(d,u,ac){var s=d.createElement('script');s.type='text/javascript';s.src='https://a.omappapi.com/app/js/api.min.js';s.async=true;s.dataset.user=u;s.dataset.campaign=ac;d.getElementsByTagName('head')\[0\].appendChild(s);})(document,69949,'prrlxthgr0celobmybq9');

## Introduction

Error Handling refers to code that is written to handle errors which occur when your application is running. These errors are normally caused by something outside your control like a missing file, database being unavailable, data being invalid etc.

If we think an error is likely to occur at some point, it is good practice to write specific code to handle the error if it occurs and deal with it.

For all other errors, we use generic code to deal with them. This is where the VBA error handling statement comes into play. They allow our application to deal gracefully with any errors we weren’t expecting.

To understand error handling we must first understand the different types of errors in VBA.

![VBA Error Handling](https://excelmacromastery.com/wp-content/uploads/2016/11/bigstock-Error-supercomputer-63984064.jpg)

## VBA Errors

There are three types of errors in VBA:

1.  Syntax
2.  Compilation
3.  Runtime

We use error handling to deal with runtime errors. Let’s have a look at each of these error types so that it is clear what a runtime error is.

### Syntax Errors

If you have used VBA for any length of time you will have seen a syntax error. When you type a line and press return, VBA will evaluate the syntax and if it is not correct it will display an error message.

For example if you type **If** and forget the **Then** keyword, VBA will display the following error message

![VBA Error Handling](https://excelmacromastery.com/wp-content/uploads/2016/10/Compiler-Error.png)

Some examples of syntax errors are

```
' then is missing
If a > b

' equals is missing after i
For i 2 To 7

' missing right parenthesis
b = left("ABCD",1

```

Syntax errors relate to one line only. They occur when the syntax of one line is incorrect.

**Note:** You can turn off the Syntax error dialog by going to Tools->Options and checking off “Auto Syntax Check”. The line will still appear red if there is an error but the dialog will not appear.

### Compilation Errors

Compilation errors occur over more than one line. The syntax is correct on a single line but is incorrect when all the project code is taken into account.

Examples of compilation errors are:

-   **If** statement without corresponding **End If** statement
-   **For** without **Next**
-   **Select** without **End Select**
-   Calling a Sub or Function that does not exist
-   Calling a Sub or Function with the wrong parameters
-   Giving a Sub or Function the same name as a module
-   Variables not declared(**Option Explicit** must be present at the top of the module)

The following screenshot shows a compilation error that occurs when a **For** loop has no matching **Next** statement.

![VBA Error Handling](https://excelmacromastery.com/wp-content/uploads/2016/10/Compiler-Error-For-B.png)

#### Using Debug->Compile

To find compilation errors, we use **Debug->Compile VBA Project** from the Visual Basic menu.

When you select _Debug->Compile_, VBA displays the first error it comes across.

When this error is fixed, you can run Compile again and VBA will then find the next error.

_Debug->Compile_ will also include syntax errors in it’s search which is very useful.

If there are no errors left and you run _Debug->Compile_ , it may appear that nothing happened. However, “Compile” will be grayed out in the Debug menu. This means your application has no compilation errors at the current time.

#### Debug->Compile Error Summary

-   Debug->Compile finds compilation(project wide) errors.
-   It will also find syntax errors.
-   It finds one error each time you use it.
-   When there are no compilation errors left the Compile option will appear grayed out in the menu.

#### Debug->Compile Usage

You should always use _Debug->Compile_ before you run your code. This ensures that your code has no compilation errors when you run it.

If you do not run _Debug->Compile_ then VBA may find compile errors when it runs. These should not be confused with Runtime errors.

### Runtime Errors

Runtime errors occur when your application is running. They are normally outside of your control but can be caused by errors in your code.

For example, imagine your application reads from an external workbook. If this file gets deleted then VBA will display an error when your code tries to open it.

Other examples of runtime errors are

-   a database not being available
-   the user entering invalid data
-   a cell containing text instead of a number

As we have seen, the purpose of error handling is to deal with runtime errors when they occur.

#### Expected Versus Unexpected Errors

When we think a runtime error could occur we put code in place to handle it. For example, we would normally put code in place to deal with a file not being found.

The following code checks if the file exists before it tries to open it. If the file does not exist then a user friendly message is displayed and the code exits the sub.

```
' https://excelmacromastery.com/
Sub OpenFile()
    
    Dim sFile As String
    sFile = "C:\docs\data.xlsx"
    
    ' Use Dir to check if file exists
    If Dir(sFile) = "" Then
        ' if file does not exist display message
        MsgBox "Could not find the file " & sFile
        Exit Sub
    End If
    
    ' Code will only reach here if file exists
    Workbooks.Open sFile
    
End Sub

```

When we think an error is likely to occur at some point, it is good practice to add code to handle the situation. We normally refer to these errors as _expected_ errors.

If we don’t have specific code to handle an error it is considered an _unexpected_ error. We use the VBA error handling statements to handle the unexpected errors.

### Runtime Errors that are not VBA Errors

Before we look at the VBA Handling there is one type of error we must mention. Some runtime errors are not considered errors by VBA but only by the user.

Let me explain this with an example. Imagine you have an application that requires you to add the values in the variables **a** and **b**

```
result = a + b

```

Let’s say you mistakenly use an asterisk instead of the plus sign

```
result = a * b

```

This is not a VBA error. Your code syntax is perfectly legal. However, from your requirements point of view it is an error.

These errors cannot be dealt with using error handling as they obviously won’t generate any error. You can deal with these errors using Unit Testing and Assertions. I have an in-depth post about using VBA assertions – see [How to Make Your Code BulletProof](https://excelmacromastery.com/bulletproof-vba-code/).

## The On Error Statement

As we have seen there are two ways to treat runtime errors

1.  Expected errors – write specific code to handle them.
2.  Unexpected errors – use VBA error handling statements to handle them.

The VBA **On Error** statement is used for error handling. This statement performs some action when an error occurs during runtime.

There are four different ways to use this statement

1.  **On Error GoTo 0** – the code stops at the line with the error and displays a message.
2.  **On Error Resume Next** – the code moves to next line. No error message is displayed.
3.  **On Error GoTo \[label\]** – the code moves to a specific line or label. No error message is displayed. This is the one we use for error handling.
4.  **On Error GoTo -1** – clears the current error.

Let’s look at each of these statements in turn.

### On Error GoTo 0

This is the default behavior of VBA. In other words, if you don’t use **On Error** then this is the behavior you will see.

When an error occurs, VBA stops on the line with the error and displays the error message. The application requires user intervention with the code before it can continue. This could be fixing the error or restarting the application. In this scenario no error handling takes place.

Let’s look at an example. In the following code, we have not used any **On Error** line so VBA will use the **On Error GoTo 0** behavior by default.

```
' https://excelmacromastery.com/
Sub UsingDefault()

    Dim x As Long, y As Long
    
    x = 6
    y = 6 / 0
    x = 7

End Sub

```

The second assignment line results in a divide by zero error. When we run this code we will get the error message shown in the screenshot below

![VBA Error Handling](https://excelmacromastery.com/wp-content/uploads/2016/10/divide-by-zero-error-handling.png)

When the error appears you can choose **End** or **Debug**

If you select **End** then the application simply stops.  
If you select **Debug** the application stops on the error line as the screenshot below shows

![VBA Error Handling](https://excelmacromastery.com/wp-content/uploads/2016/10/divide-by-zero-code-stop.png)

This behaviour is fine when you are writing VBA code as it shows you the exact line with the error.

This behavior is unsuitable for an application that you are given to a user. These errors look unprofessional and they make the application look unstable.

An error like this is essentially the application crashing. The user cannot continue on without restarting the application. They may not use it at all until you fix the error for them.

By using **On Error GoTo \[label\]** we can give the user a more controlled error message. It also prevents the application stopping. We can get the application to perform in a predefined manner.

### On Error Resume Next

Using **On Error Resume Next** tells VBA to ignore the error and continue on.

There are specific occasions when this is useful. Most of the time you should avoid using it.

If we add **Resume Next** to our example Sub then VBA will ignore the divide by zero error

```
' https://excelmacromastery.com/
Sub UsingResumeNext()

    On Error Resume Next
    
    Dim x As Long, y As Long
    
    x = 6
    y = 6 / 0
    x = 7

End Sub

```

It is not a good idea to do this. If you ignore the error, then the behavior can be unpredictable. The error can affect the application in multiple ways.You could end up with invalid data. The problem is that you aren’t aware that something went wrong because you have suppressed the error.

The code below is an example of where using **Resume Next** is valid

```
' https://excelmacromastery.com/
Sub SendMail()

   On Error Resume Next
   
    ' Requires Reference:
    ' Microsoft Outlook 15.0 Object Library
    Dim Outlook As Outlook.Application
    Set Outlook = New Outlook.Application

    If Outlook Is Nothing Then
        MsgBox "Cannot create Microsoft Outlook session." _
                   & " The email will not be sent."
        Exit Sub
    End If
    
End Sub

```

In this code we are checking to see if Microsoft Outlook is available on a computer. All we want to know is if it is available or not. We are not interested in the specific error.

In the code above, we continue on if there is an error. Then in the next line we check the value of the **Outlook** variable. If there has been an error then the value of this variable will be set to **Nothing**.

This is an example of when **Resume** could be useful. The point is that even though we use **Resume** we are still checking for the error. The vast majority of the time you will not need to use **Resume**.

### On Error GoTo \[label\]

This is how we use Error Handling in VBA. It is the equivalent of the **Try** and **Catch** functionality you see in languages such as C# and Java.

When an error occurs you send the error to a specific label. It is normally at the bottom of the sub.

Let’s apply this to the sub we have been using

```
' https://excelmacromastery.com/
Sub UsingGotoLine()

    On Error GoTo eh
    
    Dim x As Long, y As Long
    
    x = 6
    y = 6 / 0
    x = 7
    
Done:
    Exit Sub
eh:
    MsgBox "The following error occurred: " & Err.Description
End Sub

```

The screenshot below shows what happens when an error occurs

![VBA Error Handling](https://excelmacromastery.com/wp-content/uploads/2016/10/error-goto.png)

VBA jumps to the **eh** label because we specified this in the **On Error Goto** line.

**Note 1:** The label we use in the On…GoTo statement, must be in the current Sub/Function. If not you will get a compilation error.

**Note 2:** When an error occurs when using _On Error GoTo \[label\]_, the error handling returns to the default behaviour i.e. The code will stop on the line with the error and display the error message. See the next section for more information about this.

### On Error GoTo -1

This statement is different than the other three. It is used to clear the current error rather than setting a particular behaviour.

When an error occurs using _On Error GoTo \[label\]_, the error handling behaviour returns to the default behaviour i.e. “On Error GoTo 0”. That means that if another error occurs the code will stop on the current line.

This behaviour only applies to the current sub. Once we exit the sub, the error will be cleared automatically.

Take a look at the code below. The first error will cause the code to jump to the _eh_ label. The second error will stop on the line with the 1034 error.

```
' https://excelmacromastery.com/
Sub TwoErrors()

    On Error Goto eh
        
    ' generate "Type mismatch" error
    Error (13)

Done:
    Exit Sub
eh:
    ' generate "Application-defined" error
    Error (1034)
End Sub

```

If we add further error handling it will not work as the error trap has not been cleared.

In the code below we have added the line

```
On Error Goto eh_other

```

after we catch the first error.

This has no effect as the error has not been cleared. In other words the code will stop on the line with the error and display the message.

```
' https://excelmacromastery.com/
Sub TwoErrors()

    On Error Goto eh
        
    ' generate "Type mismatch" error
    Error (13)

Done:
    Exit Sub
eh:
    On Error Goto eh_other
    ' generate "Application-defined" error
    Error (1034)
Exit Sub
eh_other:
    Debug.Print "eh_other " & Err.Description
End Sub

```

To clear the error we use _On Error GoTo -1_. Think of it like setting a mouse trap. When the trap goes off you need to set it again.

In the code below we add this line and the second error will now cause the code to jump to the _eh\_other_ label

```
' https://excelmacromastery.com/
Sub TwoErrors()

    On Error Goto eh
        
    ' generate "Type mismatch" error
    Error (13)

Done:
    Exit Sub
eh:
    ' clear error
    On Error Goto -1
    
    On Error Goto eh_other
    ' generate "Application-defined" error
    Error (1034)
Exit Sub
eh_other:
    Debug.Print "eh_other " & Err.Description
End Sub

```

**Note 1:** There are probably rare cases where using _On Error GoTo -1_ is useful. In most cases using [Resume Next](https://excelmacromastery.com/vba-error-handling/#Resume_Next) is better as it clears the error and resumes the code at the next line after the error occurs.

**Note 2:** The [Err Object](https://excelmacromastery.com/vba-error-handling//#The_Err_Object) has a member _Clear_. Using _Clear_ clears the text and numbers in the Err object, but it does NOT reset the error.

### Using On Error

As we have seen, VBA will do one of three things when an error occurs

-   Stop and display the error.
-   Ignore the error and continue on.
-   Jump to a specific line.

VBA will always be set to one of these behaviors. When you use **On Error**, VBA will change to the behaviour you specify and forget about any previous behavior.

In the following Sub, VBA changes the error behaviour each time we use the **On Error** statement

```
' https://excelmacromastery.com/
Sub ErrorStates()

    Dim x As Long
    
    ' Go to eh label if error
    On Error Goto eh
    
    ' this will ignore the error on the following line
    On Error Resume Next
    x = 1 / 0
    
    ' this will display an error message on the following line
    On Error Goto 0
    x = 1 / 0
  
Done:  
   Exit Sub
eh:
    Debug.Print Err.Description
End Sub

```

## Resume Next

The _Resume Next_ statement is used to clear the error and then resume the code from the line after where the error occurred.

If your code can have multiple errors and you want to keep detecting them then this line is very useful.

For example, in the following code we want to resume the code after the error has been reported:

```
Private Sub Main()

    On Error Goto eh
    
    Dim i As Long
    For i = 1 To 3
        ' Generate type mismatch error
         Error 13
    Next i

done:
    Exit Sub
eh:
    Debug.Print i, Err.Description
End Sub

```

   
We could use [On Error Goto -1](https://excelmacromastery.com/vba-error-handling/#On_Error_GoTo_-1) to clear the code and then use a goto statement to go back to the code like this:

```
Private Sub Main()

    On Error Goto eh
    
    Dim i As Long
    For i = 1 To 3
        ' Generate type mismatch error
         Error 13
continue:
    Next i

done:
    Exit Sub
eh:
    Debug.Print i, Err.Description
    On Error Goto -1 ' clear the error
    Goto continue ' return to the code
End Sub

```

   
The _Resume Next_ provides a nicer way of doing it and it always means the code is much clearer and easier to understand:

```
Private Sub Main()

    On Error Goto eh
    
    Dim i As Long
    For i = 1 To 3
        ' Generate type mismatch error
         Error 13
continue:
    Next i

done:
    Exit Sub
eh:
    Debug.Print i, Err.Description
    ' clear the error and return to the code
    Resume Next  
End Sub

```

## The Err Object

When an error occurs you can view details of the error using the **Err** object.

When an runtime error occurs, VBA automatically fills the **Err** object with details.

The code below will print _“Error Number: 13 Type Mismatch”_ which occurs when we try to place a string value in the long integer _total_

```
' https://excelmacromastery.com/
Sub UsingErr()

    On Error Goto eh
    
    Dim total As Long
    total = "aa"

Done:
    Exit Sub
eh:
    Debug.Print "Error number: " & Err.Number _
            & " " & Err.Description
End Sub

```

The **Err.Description** provides details of the error that occurs. This is the text you normally see when an error occurs e.g. “Type Mismatch”

The **Err.Number** is the ID number of the error e.g. the error number for “Type Mismatch” is 13. The only time you really need this is if you are checking that a specific error occurred and this is only necessary on rare occasions.

The **Err.Source** property seems like a great idea but it does not work for a VBA error. The source will return the project name, which hardly narrows down where the error occurred. However, if you create an error using **Err.Raise** you can set the source yourself and this can be very useful.

### Getting the Line Number

The **Erl** function is used to return the line number where the error occurs.

It often causes confusion. In the following code, _Erl_ will return zero

```
' https://excelmacromastery.com/
Sub UsingErr()

    On Error Goto eh
    
    Dim val As Long
    val = "aa"

Done:
    Exit Sub
eh:
    Debug.Print Erl
End Sub

```

This is because there are no line numbers present. Most people don’t realise it but VBA allows you to have line numbers.

If we change the Sub above to have line number it will now print out 20

```
' https://excelmacromastery.com/
Sub UsingErr()

10        On Error Goto eh
          
          Dim val As Long
20        val = "aa"

Done:
30        Exit Sub
eh:
40        Debug.Print Erl
End Sub

```

Adding line numbers to your code manually is cumbersome. However there are tools available that will allow you to easily add and remove line numbers to a sub.

When you are finished working on a project and hand it over to the user it can be useful to add line numbers at this point. If you use the error handling strategy in the [last section of this post](https://excelmacromastery.com/vba-error-handling//#A_Complete_Error_Handling_Strategy), then VBA will report the line where the error occurred.

### Using Err.Raise

**Err.Raise** allows us to create errors. We can use it to create custom errors for our application which is very useful. It is the equivalent of the **Throw** statement in Java\\C#.

The format is as follows

```
Err.Raise [error number], [error source], [error description]

```

Let’s look at a simple example. Imagine we want to ensure that a cell has an entry that has a length of 5 characters. We could have a specific message for this

```
' https://excelmacromastery.com/
Public Const ERROR_INVALID_DATA As Long = vbObjectError + 513

Sub ReadWorksheet()

    On Error Goto eh
    
    If Len(Sheet1.Range("A1")) <> 5 Then
        Err.Raise ERROR_INVALID_DATA, "ReadWorksheet" _
            , "The value in the cell A1 must have exactly 5 characters."
    End If
    
    ' continue on if cell has valid data
    Dim id As String
    id = Sheet1.Range("A1")
    

Done:
    Exit Sub
eh:
    ' Err.Raise will send code to here
    MsgBox "Error found: " & Err.Description
End Sub


```

When we create an error using _Err.Raise_ we need to give it a number. We can use any number from 513 to 65535 for our error. We must use _vbObjectError_ with the number e.g.

```
Err.Raise vbObjectError + 513

```

### Using Err.Clear

Err.Clear is used to clear the text and numbers from the Err.Object. In other words, it clears the description and number.If you want the clear the actual error you can use either [On Error GoTo -1](https://excelmacromastery.com/vba-error-handling/#On_Error_Goto_-1) or [Resume Next](https://excelmacromastery.com/vba-error-handling/#Resume_Next)

It is rare that you will need to use Err.Clear but let’s have a look at an example where you might.

In the code below we are counting the number of errors that will occur. To keep it simple we are generating an error for each odd number.

We check the error number each time we go through the loop. If the number does not equal zero then an error has occurred. Once we count the error we need to set the error number back to zero so it is ready to check for the next error.

```
' https://excelmacromastery.com/
Sub UsingErrClear()

    Dim count As Long, i As Long

    ' Continue if error as we will check the error number
    On Error Resume Next
    
    For i = 0 To 9
        ' generate error for every second one
        If i Mod 2 = 0 Then Error (13)
        
        ' Check for error
        If Err.Number <> 0 Then
            count = count + 1
            Err.Clear    ' Clear Err once it is counted
        End If
    Next

    Debug.Print "The number of errors was: " & count
End Sub

```

**Note 1:** _Err.Clear_ resets the text and numbers in the error object but it does not clear the error – see [Resume Next](https://excelmacromastery.com/vba-error-handling/#Resume_Next) Or [On Error GoTo -1](https://excelmacromastery.com/vba-error-handling/#On_Error_Goto_-1) for more information about clearing the actual error.

## Logging

Logging means writing information from your application when it is running. When an error occurs you can write the details to a text file so you have a record of the error.

The code below shows a very simple logging procedure

```
' https://excelmacromastery.com/
Sub Logger(sType As String, sSource As String, sDetails As String)
    
    Dim sFilename As String
    sFilename = "C:\temp\logging.txt"
    
    ' Archive file at certain size
    If FileLen(sFilename) > 20000 Then
        FileCopy sFilename _
            , Replace(sFilename, ".txt", Format(Now, "ddmmyyyy hhmmss.txt"))
        Kill sFilename
    End If
    
    ' Open the file to write
    Dim filenumber As Variant
    filenumber = FreeFile 
    Open sFilename For Append As #filenumber
    
    Print #filenumber, CStr(Now) & "," & sType & "," & sSource _
                                & "," & sDetails & "," & Application.UserName
    
    Close #filenumber
    
End Sub

```

You can use it like this

```
' Create unique error number
' https://excelmacromastery.com/
Public Const ERROR_DATA_MISSING As Long = vbObjectError + 514

Sub CreateReport()

    On Error Goto eh
    
    If Sheet1.Range("A1") = "" Then
       Err.Raise ERROR_DATA_MISSING, "CreateReport", "Data is missing from Cell A1"
    End If

    ' other code here
Done:
    Exit Sub
eh:
    Logger "Error", Err.Source, Err.Description
End Sub

```

The log is not only for recording errors. You can record other information as the application runs. When an error occurs you can then check the sequence of events before an error occurred.

Below is an example of logging. How you implement logging really depends on the nature of the application and how useful it will be:

```
' https://excelmacromastery.com/
Sub ReadingData()
    
    Logger "Information", "ReadingData()", "Starting to read data."
       
    Dim coll As New Collection
    ' add data to the collection
    coll.Add "Apple"
    coll.Add "Pear"
    
    If coll.Count < 3 Then
        Logger "Warning", "ReadingData()", "Number of data items is low."
    End If
    Logger "Information", "ReadingData()", "Number of data items is " & coll.Count
    
    Logger "Information", "ReadingData()", "Finished reading data."

End Sub

```

Having a lot of information when dealing with an error can be very useful. Often the user may not give you accurate information about the error that occurred. By looking at the log you can get more accurate information about the information.

## Other Error Related Items

This section covers some of the other Error Handling tools that VBA has. These items are considered obsolete but I have included them as they may exist in legacy code.

### Error Function

The Error Function is used to print the error description from a given error number. It is included in VBA for backward compatibility and is not needed because you can use the _Err.Description_ instead.

Below are some examples:

```
' Print the text "Division by zero"
Debug.Print Error(11)
' Print the text "Type mismatch"
Debug.Print Error(13)
' Print the text "File not found"
Debug.Print Error(53)

```

### Error Statement

The Error statement allows you to simulate an error. It is included in VBA for backward compatibility. You should use **Err.Raise** instead.

In the following code we simulate a “Divide by zero” error.

```
' https://excelmacromastery.com/
Sub SimDivError()

    On Error Goto eh
        
    ' This will create a division by zero error
    Error 11
    
    Exit Sub
eh:
    Debug.Print Err.Number, Err.Description
End Sub

```

This statement is included in VBA for backward compatibility. You should use Err.Raise instead.

## A Simple Error Handling Strategy

With all the different options you may be confused about how to use error handling in VBA. In this section, I’m going to show you how to implement a simple error handling strategy that you can use in all your applications.

### The Basic Implementation

This is a simple overview of our strategy

1.  Place the _On Error GoTo Label_ line at the start of our topmost sub.
2.  Place the error handling _Label_ at the end of our topmost sub.
3.  If an expected error occurs then handle it and continue.
4.  If the application cannot continue then use Err.Raise to jump to the error handling label.
5.  If an unexpected error occurs the code will automatically jump to the error handling label.

The following image shows an overview of how this looks

![error-handling](https://excelmacromastery.com/wp-content/uploads/2016/11/Error-handling.jpg)

The following code shows a simple implementation of this strategy:

```
' https://excelmacromastery.com/
Public Const ERROR_NO_ACCOUNTS As Long = vbObjectError + 514

Sub BuildReport()

    On Error Goto eh
    
    ' If error in ReadAccounts then jump to error
    ReadAccounts
    
    ' Do something with the code
    
Done:
    Exit Sub
eh:
    ' All errors will jump to here
    MsgBox Err.Source & ": The following error occured  " & Err.Description
End Sub

Sub ReadAccounts()
    
    ' EXPECTED ERROR - Can be handled by the code
    ' Application can handle A1 being zero
    If Sheet1.Range("A1") = 0 Then
        Sheet1.Range("A1") = 1
    End If
    
    ' EXPECTED  ERROR - cannot be handled by the code
    ' Application cannot continue if no accounts workbook
    If Dir("C:\Docs\Account.xlsx") = "" Then
        Err.Raise ERROR_NO_ACCOUNTS, "UsingErr" _
                , "There are no accounts present for this month."
    End If

    ' UNEXPECTED ERROR - cannot be handled by the code
    ' If cell B3 contains text we will get a type mismatch error
    Dim total As Long
    total = Sheet1.Range("B3")
    
    
    ' continue on and read accounts
    
End Sub

```

This is a nice way of implementing error handling because

-   We don’t need to add error handling code to every sub.
-   If an error occurs then VBA exits the application gracefully.

## A Complete Error Handling Strategy

The above strategy has one major drawback. It doesn’t provide any information about the error. It is better than having no strategy as it prevents the application crashing. But that is the only real benefit.

VBA doesn’t fill **Err.Source** with anything useful so we have to do this ourselves.

In this section, I am going to introduce a more complete error strategy. I have written two subs that perform all the heavy lifting so all you have to do is add them to your project.

The purpose of this strategy is to provide you with the _Stack\*_ and line number when an error exists.

\*The _Stack_ is the list of sub/functions that were currently in use when the error occurred.

This is our strategy

1.  Place error handling in all the subs.
2.  When an error occurs, the error handler adds details to the error and raises it again.
3.  When the error reaches the topmost sub it is displayed.

We are simply “bubbling” the error to the top. The following diagram shows a simple visual of what happens when an error occurs in _Sub3_

![Error Handling - bubbling](https://excelmacromastery.com/wp-content/uploads/2016/11/Error-handling-bubbling1.jpg)

The only messy part to this is formatting the strings correctly. I have written two subs that handle this, so it is taken care of for you.

There are the two helper subs, **RaiseError** and **DisplayError**. You can download the library below:

(function(d,u,ac){var s=d.createElement('script');s.type='text/javascript';s.src='https://a.omappapi.com/app/js/api.min.js';s.async=true;s.dataset.user=u;s.dataset.campaign=ac;d.getElementsByTagName('head')\[0\].appendChild(s);})(document,69949,'sjzolo51fqgrksrnci8l');

### An Example of using this strategy

Here is a simple coding example that uses these subs. In this strategy, we don’t place any code in the topmost sub. We only call subs from it.

```
' https://excelmacromastery.com/
Sub Topmost()

    On Error Goto EH
    
    Level1

Done:
    Exit Sub
EH:
    DisplayError Err.source, Err.Description, "Module1.Topmost", Erl
End Sub

Sub Level1()

    On Error Goto EH
    
    Level2

Done:
    Exit Sub
EH:
   RaiseError Err.Number, Err.source, "Module1.Level1", Err.Description, Erl
End Sub

Sub Level2()

    On Error Goto EH
    
    ' Error here
    Dim a As Long
    a = "7 / 0"

Done:
    Exit Sub
EH:
    RaiseError Err.Number, Err.source, "Module1.Level2", Err.Description, Erl
End Sub

```

The result looks like this:

![error handling output](https://excelmacromastery.com/wp-content/uploads/2016/11/error-handling-output.png)

If your project has line numbers the result will include the line number of the error:

![error handling output line](https://excelmacromastery.com/wp-content/uploads/2016/11/error-handling-output-line.png)

## Error Handling in a Nutshell

-   Error Handling is used to handle errors that occur when your application is running.
-   You write specific code to handle expected errors. You use the VBA error handling statement _On Error GoTo \[label\]_ to send VBA to a label when an unexpected error occurs.
-   You can get details of the error from _Err.Description_.
-   You can create your own error using _Err.Raise_.
-   Using one _On Error_ statement in the top most sub will catch all errors in subs that are called from here.
-   If you want to record the name of the Sub with the error, you can update the error and rethrow it.
-   You can use a log to record information about the application as it is running.