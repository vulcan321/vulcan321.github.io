# AppleScript in Word — do Visual Basic

Article Contributed by [Paul Berkowitz](https://mvp.microsoft.com "Read about the MVP Award at Microsoft.com")

## AppleScript in Word 2004

The article below was written for Word X, 2001 and 98. All is changed utterly in Word 2004, which now has a fully developed native AppleScript dictionary – in fact it’s probably the largest AppleScript dictionary of any application on the Macintosh. You may perhaps run into an occasional bug – these are still early days – but it is solid, reliable and simply amazing after all the years of “making do”. So the ‘do Visual Basic’ command is no longer necessary in Word 2004. On the other hand, it’s still there and it still works, which is good to know in case you run into a problem. More importantly, it means that older scripts using ‘do Visual Basic’ will continue to work in Word 2004.

Note, however, that any lines  – and I mean _any_ lines – within a Word tell block in an older script and which are _not_ part of a ‘do Visual Basic’ command will _not_ work in Word 2004. They will have to be rewritten. This is easiest to do by opening your script in Word X, saving as Text, then opening it in Word 2004 and rewriting it using the new dictionary. If you open it as a compiled script instead, all the old keywords will appear in «raw code» which is unrecognizable: you will not know what your original English-like terms were. Saving and opening as text will display the English terms, making it easier to convert to the new keywords – which occasionally may even be the same English keywords hiding very different raw code implementations.

If you have spent any time with ‘do Visual Basic’ before, or with Word VBA itself, your knowledge will have not gone to waste. The new AppleScript uses the same Object Model as Word VBA, so you will be familiar with many of the terms and relationships. It actually makes for a very contorted syntax at times, particularly with all the many command parameters and enumerations (specially named constants), many of which are similar to each other and just run on, in AppleScript fashion, without the sort of “:=” punctuation used in VBA.

The Object Model is very complex, since it reflects the complex reality of Word. Don’t expect it to be like scripting a simple text editor such as Tex-Edit Plus. Earlier Word dictionaries attempted to emulate such text editors with the standard Text Suite but failed miserably in practice since Word’s binary structure could not be forced into a simple text model without things going dreadfully wrong. So scripting Word 2004 is definitely a complicated process, with a serious learning curve. But what a joy it is to have a scripting model that works.

In order to find your way around what is virtually a new sub-language of AppleScript, you will need the promised Word AppleScript Reference, which will be made available as a download from MacTopia. Unfortunately, at the time of writing (release date of Office 2004 in May 2004), the Reference is not ready as yet. In the meantime you can use the Visual Basic Editor’s Help: the AppleScript terms are almost identical to the VBA terms except they use “normal” lower-case English such as ‘auto format’ rather than ‘AutoFormat’ and ‘convert numbers to text rather than ‘ConvertNumbersToText’. You get the idea.

The very greatest single advantage of the new AppleScript over ‘do Visual Basic’ is that you can now get a result returned from an AppleScript expression in the normal way, rather than hoping you will be able to find a way to send a string result from VBA by writing to a text file, as described at the very end of this article. That was a very cumbersome workaround – which was not always possible to use  – if your result were a Word object, for example, or anything else that could not be coerced to a string. 

Word 2004’s new AppleScript is brand new territory, yet to be explored. The rest of this article deals with the techniques needed for Word X and earlier. Please bear that in mind when reading about the failures of Word’s native AppleScript below:  that refers only to Word X and earlier, _not_ to Word 2004.

[Return to Top](https://wordmvp.com/Mac/Applescript-VBA.html#top)

## AppleScript In Word X and earlier — do Visual Basic

Word _\[X and earlier\]_ has a decent AppleScript Dictionary with a well-designed Object Model organized in an orthodox AppleScript manner: suites of classes and events, with classes and their properties predominating as they should and just a few proprietary events as well as events from the Standard Suite. This is a model set-up, similar to Entourage’s and better than Excel’s long list of proprietary events that are too numerous to remember, and ought to allow you to script most basic commands in Word, if nothing too advanced. Unfortunately, unlike Entourage and Excel, Word’s AppleScript has been implemented very poorly. Sooner or later – mostly sooner – Word will crash or error, results will be incorrect and placements of text selection will be wildly off-base. Word’s standard AppleScripting is frankly totally unusable. _\[Reminder: this does not apply to Word 2004.\]_

But why use AppleScript at all, once you’ve gone to the trouble to learn VBA? You could simply write and install the same macros that you would in Word Windows.

The reason why you would choose to AppleScript Word via **do Visual Basic** is because you want to run it from outside Word. **do Visual Basic** would usually be called from an outside, self-standing Applescript application (applet) which is probably coordinating several different applications in a work flow that might involve FileMaker Pro, Quark Express, Excel and/or Entourage, or any number of the 100 or so scriptable Mac applications. Or perhaps it might be running as a compiled script in an application with a script menu, such as Entourage: Entourage provides the only means to access the Office Address Book since Word’s VBA cannot do so, and thus provides a means of including contact information in Word via AppleScript. (My own “Address Word Letter” and “Print Tasks Lists” scripts do just that, for example.) Or perhaps you want to run a script from the OS X script menu.

## Calling Installed Macros

If you use Word macros, and have some installed in your own templates and documents, you can use **do Visual Basic** from an external AppleScript simply to call the installed macro with a one-line Run command in VBA. For example, if you have installed a macro called **MyProcedure()** in your Normal template, or in a template in the **Office/Startup/Word** folder in Microsoft Office X or 2001 or 98 folder, or in the active document (the front one that has the focus) in Word, you can just call it by quoted name, without its following parentheses:
```applescript
tell application "Microsoft Word"

     do Visual Basic "Application.Run \\"MyProcedure\\""

end tell
```
If the macro is in your Normal template **only**, you don't even need "**Application.Run**". You can simply call it by name alone, without internal backslashed quotes:
```applescript
tell application "Microsoft Word"

     do Visual Basic "MyProcedure"

end tell
```
 When the macro is **not** in Normal template, you **must** include Application.Run. If it is in a template in the Word Startup folder, you do not need to open the template. If the macro is in an open document "Other Document.doc" which might not be in the front, you need to ensure it is the active document first:
```applescript
tell application "Microsoft Word"

     do Visual Basic "Documents(\\"Other Document.doc\\").Activate

       Application.Run \\"MyProcedure\\""

end tell
```
 As you can see, internal VBA quoting can present a bit of a challenge, **since quotes have to be escaped with backslashes ( \\ )** as usual in AppleScript.

If you are using a template or document other than Normal or a template in the Word Startup folder (probably the best place for macros which you want to have always available without encumbering Normal with too many add-ons) you must locate it with its Mac-type file path using colons if it may not be an open document, and open it first:
```applescript
tell application "Microsoft Word"

        do Visual Basic "Documents.Open \\"Macintosh Hard Disk:Applications:Microsoft Office X:Templates:My Templates:Special Template.dot\\"

         Application.Run \\"Module1.MyProcedure\\""

end tell
```
This example locates a **MyProcedure** macro located in a template named "Special Template" in the **My Templates** folder in its usual location in the **Microsoft Office X** folder. If you have moved it elsewhere you would need to change the file path: these are not like AppleScript alias specifiers, they are hard-coded paths. Much easier is to install the macro in a Word Startup template or Normal template and just call it by name as in the first and second examples.

One alternative to hard-coding file paths, if you are willing to trust your users to put the document into their default Documents, Templates or other "special folder" for which VBA has a **wdDefaultPath** constant, is to use the **DefaultPathProperty** in the VBA code:
```
do Visual Basic "Dim templatesPath as String

templatesPath  = Options.DefaultFilePath(wdUserTemplatesPath)

Documents.Open (templatesPath & \\"Special Template.dot\\")

Application.Run \\"Module1.MyProcedure \\""
```
Note that **wdUserTemplatesPath** indicates the main Templates folder in the Microsoft Office X (or 2001 or 98) folder, not the "My Templates" subfolder within it.

A method which is more reliable, but involves user interaction at least once, is to use AppleScript to find the document, once only, via the **choose file** Standard Addition. Save the result — an alias — as a script property. Then convert it to a file path at run time, before calling **do Visual Basic** . This allows the user to move, and even rename, the document between runs.
```
**property** theDoc : missing value  
  
**if** filePath \= missing value **then  
**   **set** theDoc **to** choose file with prompt "Where is your Word document containing the macro to be run by this script?" \-- _one line_   (\* _result is an alias_ \*)  
**end** **if  
**\----  
**set** filePath **to** theDoc **as** string  
**tell** application "Microsoft Word"  
   do Visual Basic "Documents.Open \\"" & filePath & "\\"  
     Application.Run \\"Module1.MyProcedure\\""  
**end** **tell**
```
There is more information on incorporating AppleScript variables into **do Visual basic**, as done with **filePath** here, later in this article.

### Notes:

-   Even in Mac OS X with its Unix underpinnings, file paths in both VBA and in AppleScript **use colons** ( : ) as disk/folder/file separators on the Mac, beginning with the hard disk (or partition) name, and never the POSIX-style path using forward slashes ( / ) which omits the startup disk.
-   Any of the variations of VBA's Run Method, as outlined in the Visual Basic Help, should be available with ‘do Visual Basic’, but note that the third version given in the VB Help:

Application.Run "'My Document.doc'!ThisModule.ThisProcedure"

doesn't seem to work in Word Mac VBA, at least not Word X, and so it doesn't work with **do Visual Basic** either.

[Return to Top](https://wordmvp.com/Mac/Applescript-VBA.html#top)

## Embedding VBA within AppleScript

A scripter distributing a script publicly will not want to use the hard-coded file path method nor assume that the macro will be in Normal or in a Startup template, since he can't really be sure what the user is going to do with the associated VBA macro or document, even if he instructs users where to put it. Instead, he will **convert** the entire macro into a ‘do Visual Basic’ command within his larger AppleScript. This is really very simple — far easier than using the converse 'MacScript' command in VBA to insert an AppleScript — since you can virtually paste the VBA straight in from the VB Editor without needing to take any special account of ends of lines. Once again, you will need to escape any internal quotes with backslashes ( \\ ).

Here is a simple script that inserts a non-standard date format at the insertion point in the front document. (At least it is non-standard in the US: the format "12 October, 2002" is quite common in the UK). This format — a comma after the month, with the day preceding the month — does not appear in the Insert / Date menu item in the US version of Word Mac.

Note that you do **not** include the **Sub/End Sub** sub-procedure frame as you would in a VBA macro made in the VB Editor:
```applescript
**tell** application "Microsoft Word"

            activate

            do Visual Basic "Selection.InsertAfter Format(Date, \\"d mmmm, yyyy\\")

    Selection.Collapse wdCollapseEnd

            "

**end tell**
```
You can copy this into Script Editor, compile it, and run it right now.  It inserts today's date at the insertion point in "12 October, 2002" format in the front document in Word (or in a new document if Word is not currently open).

When you use **do Visual Basic** in an AppleScript, Word creates a temporary Module (in your Normal template) named "WordTempDDEMod", and adds a Sub (i.e. macro) named TempDDE in that Module, so the final result is:

Sub TempDDE()

                 ' the code you specify with **do Visual Basic**

End Sub

Word then automatically 'calls' TempDDE to execute your code. If the macro completes successfully, the module is automatically deleted. If there are any errors, you'll get a dialog from Word telling you about the problem. If you click on the 'Debug' button in this dialog you'll be taken to the Visual Basic Editor (VBE), where the line in TempDDE that caused the error is highlighted (although this code window may not necessarily be the front window in the VBE). If you instead click **End** in the dialog, or click the **Reset** button in the VBE after hitting **Debug**, the temporary module is deleted. (Eventually AppleScript will tell you that Microsoft Word timed out.) If you attempt to run the offending script again, without first making sure WordTempDDEMod has been deleted, you'll get an error that Word could not create the module (even if you've otherwise fixed what caused the error); just hit **Reset** in the VBE to get rid of the module and try again.

## Multiple Subs and Functions

If your **do Visual Basic** contains two or more ‘do Visual Basic’ **Subs** or **Functions**, leave in all the Sub MacroName()/End Sub lines **except** for the very first and last lines.

Here is an example of a Sub that calls a Function. It is a peculiarity of  **do Visual Basic** and TempDDE() that a Function cannot end the module (because TempDDE always closes with 'End Sub', never 'End Function'), so the Function must come first. But the module can't begin with a Function either, since the first line will always be preceded by  'Sub TempDDE()'. So you have to allow for a one-line TempDDE Sub calling your "real" Sub:
```applescript
**tell** application "Microsoft Word"

            activate

            do Visual Basic "ShowMessage

    End Sub

    Function PrepareMessage(temp As String)

        If temp = \\"\\" Then

            PrepareMessage = \\"You didn't enter your name!\\"

        Else

            PrepareMessage = \\"Thank you, \\" & temp

        End If  

    End Function

    Sub ShowMessage()

        Dim temp As String

        temp = InputBox(\\"Please enter your name\\", \\"What is your name?\\")

        MsgBox PrepareMessage(temp)"

**end tell**
```
Note the oddly placed 'End Sub' in the second line of VBA: it closes the Sub TempDDE() when in operation. The first line 'ShowMessage' calls the real sub at the bottom. It in turn is missing its final 'End Sub' because that will be provided at runtime. Paste this script into Script Editor and run it. It displays a VB dialog with a text field in which to type your name, then (calling the Function) displays a second message thanking you by name, or telling you off if you never entered your name in the text field.

## Passing Variables to VBA

You can pass a variable from AppleScript to VBA, either as a literal string within VBA, where it will have to be surrounded by backslashed quotes ( \\"), or as a number, unquoted, or even, if circumstances ever warranted it, part of the VBA code itself.

Here is an adaptation of the previous script, where the first dialog with the text field is now presented in AppleScript in whatever application you happen to be (if run in Script Editor, you'll see it there). The result is passed, surrounded by backslashed quotes, to the **Call** method in VBA, which passes it on in turn to the ShowMessage Sub as a parameter, and thence to the Function, each parameter properly referenced 'As String'. It has the same TempDDE() / Function /"real" Sub structure as the previous script. Try this one in Script Editor as well.

**set** myname **to** text returned **of** (display dialog "Enter your name" default answer "" with icon 1) \-- all one line
```applescript
**tell** application "Microsoft Word"

            activate

            do Visual Basic "Call ShowMessage(\\"" & myname & "\\")

        End Sub

        Function PrepareMessage(temp As String)

            If temp = \\"\\" Then

                PrepareMessage = \\"You didn't enter your name!\\"

            Else

                PrepareMessage = \\"Thank you, \\" & temp

            End If

        End Function

        Sub ShowMessage(thename As String)

            MsgBox PrepareMessage(thename)"

**end tell**
```
Here is an example from my script “Print Tasks List” which demonstrates how to include an AppleScript variable in the middle of the VBA, this time using it as a number, not a string. In this excerpt, the AppleScript repeat loop at the top, before the Word tell block, first checks to see which Table column the user has chosen to be the “Completed √ ” column for displayed tasks, and sets the Applescript variable **num** (an integer in AppleScript) to that number.

In the **do Visual Basic** command within the Word tell block, you can see where this variable **num** has been inserted after temporarily closing the quotes which contain the **do Visual Basic** command. Because the **num** variable, an integer, is concatenated to a string on its left, it too is coerced to an AppleScipt string according to standard AppleScript behavior, and so is “absorbed” into the **do Visual Basic** string at run time. Within the VBA, since it does not have backslashed quotes around it, it is now used as an integer, not a string. The **do Visual Basic** command's VBA checks each row of the Table (there is in fact only one) in the front document, and if it finds that the column number specified by that number **num** does not contain (InStr = 0) a check mark (√), it sets the font style of that row to Bold. If the column does contain a checkmark, then it sets the font style of that row to Strikethrough. These correspond respectively to the formatting in Entourage's Tasks List for Incomplete and Completed tasks, which the Word Table is replicating. There is no way this could ever be done in Word AppleScript without using **do Visual Basic**:

```applescript
**repeat with** i **from** 1 **to** (count whichColumns)

     **if** item i of whichColumns = "√" **then**

          **set** num **to** i

          **exit repeat**

     **end if**

**end repeat**

tell application "Microsoft Word"

            do Visual Basic "

Dim myRow As Row

Dim cellText As String

Dim i As Integer

With ActiveDocument.Tables(1)

 For i = 2 To  .Rows.Count   ' don't include top row

     Set myRow = .Rows(i)

    cellText = myRow.Cells(" & num & ").Range.Text

    If InStr(cellText, \\"√\\") = 0 Then   ' i.e. contains

        myRow.Range.Font.Bold = True

    Else

        myRow.Range.Font.StrikeThrough = True

    End If

 Next i

End With

**end tell**
```
If you need to include AppleScript variables to be separated by carriage returns in the eventual VBA, you can't use the usual AppleScript return constant; you need the VBA equivalent **vbCr**. Here's another excerpt from the same script that illustrates setting up such a variable **preTable**:
```
**set** preTable **to** "\\"TASKS\\" & vbCr & vbCr & \\"\\" & vbTab & \_

\\"Selected Tasks\\"  & vbTab & \\"\\" & vbCr & vbCr & vbCr

"
```
complete with the internal quotes and **VBTab** character needed to prepare the title of the Table.

## Printing without Fuss

**do Visual basic** can print documents without calling up a Print dialog as regular Applescript does in Word and in many other applications. It can also arrange to put the insertion point wherever is most appropriate for the user at the end of a script run.

Here's a simple excerpt which closes the same Print Tasks List script by bringing the Word application to the front (**Application.Activate**) and puts the insertion point into the first cell of the second row (the first real row of the Table under the header row). If the user has previously chosen to print the table, which will have set the AppleScript variable **printOut** to true, then a final **do Visual Basic** command will print the Table without the nuisance of a Print dialog that the ordinary AppleScript command print always brings up.
```applescript
**tell** application "Microsoft Word"

            do Visual Basic "

            Application.Activate

            ActiveDocument.Activate

            With ActiveDocument.Tables(1).Cell(2,1).Range

                        .Collapse Direction:=wdCollapseStart

                        .Select 'insertion point

            End With          

            "

            **if** printOut **then** do Visual Basic "ActiveDocument.PrintOut"

**end tell**
```
In my opinion, simply being able to:
```applescript
tell application "Microsoft Word"

            do Visual Basic "ActiveDocument.PrintOut"

end tell
```
to print a Word document in AppleScript without that annoying Print dialog coming up makes **do Visual Basic** worth its weight in gold, all by itself. Try it yourself with whatever document is currently open in Word (if it's not too many pages!).

## Returning a Result from VBA to AppleScript

Advanced AppleScripters who may be wondering how to return a practical result from the VBA of ‘do Visual Basic’ command to AppleScript (since its ‘result’ is simply the execution of the command) might wish to download and inspect the companion script “Print Tasks List PREFS” in the “Print Tasks List” or “Print Tasks List X” script package at MacScripter. Its **doVBScript** handler uses **do Visual Basic** to call the VB Method Print #FileNumber to write a VB result as string to a text file in the temporary items folder. AppleScript can then open and read the same file with the open for access and read commands from Standard Additions, and then uses the VB result it finds there to reset script properties (preferences) in the main Print Tasks List script.