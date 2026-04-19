4\. Excel

Excel VBA Macros to AppleScript

Make sure you have read Chapter 2: _AppleScript in Microsoft Office (General)_ first. It deals with many important features of VBA, including Excel VBA, that need to be treated very differently in AppleScript, as well as some equivalent control and operator statements in AppleScript you need to know.

This chapter consists of typical, and popular, subroutines (macros) in VBA, and their equivalent in AppleScript, with comments as necessary to explain differences in the AppleScript approach. All the many examples have been written, and provided, by John McGimpsey, Macintosh MVP specialist in Excel. Some of his explanatory comments have been incorporated as well.

Note: when testing out scripts in Script Editor, you may wish to begin every one with an activate command on its own line just inside the tell application "Microsoft Excel" block, as its first line. That will bring Excel to the front so you can see what is happening. It is not necessary to include activate when running saved scripts from the script menu while Excel is in the front (and there may be other occasions when you are running a script from elsewhere and don't want Excel to come to the front). I have not included activate in the sample scripts here, but you may wish to do so.

Before launching into scripting Excel, it is a good idea to read the introductory section _Using the Excel Dictionary_ and especially the section _How to reference cells and ranges_ on p. 15, of the _Excel AppleScript Reference_ available in PDF format free from Microsoft at <[http://www.microsoft.com/mac/resources/resources.aspx?pid=asforoffice](http://www.microsoft.com/mac/resources/resources.aspx?pid=asforoffice)\>. Although it is largely aimed at AppleScripters unfamiliar with Excel's Object Model rather than vice versa, it is full of useful knowledge for all scripters of Excel.

Remember that this article was written while Office 2004 is current: some problems with Excel 2004's AppleScript discussed here may be fixed in Excel 2008 and workarounds provided here may no longer be needed there.

Excel is one of the most complex and detailed applications there is, with a huge variety of capabilities. Rather than demonstrating a few sample scripts of a somewhat personal choice, this chapter will offer AppleScript translations of short commands of various types to illustrate a wide variety of techniques, such as you might find in various combinations in many macros. Credit for assembling and organizing these samples is fully John McGimpsey's. They should be of help in many different situations and lead you on to other areas of the AppleScript dictionary.

Most of the enormous repertoire of Excel features as programmed through VBA has a straightforward equivalent in AppleScript. But here and there are Methods or Properties that have not made it over, or not in the same format. When we come upon those, solutions and workarounds will be offered.

In particular, although the AppleScript implementation of Excel has been very thoroughly carried out, such that almost all of the VBA Model can be found mirrored in the AppleScript Model, there are some serious bugs connected with columns and rows. Make sure to read the relevant section of this chapter (_Working with Columns and Rows_) or you will run into trouble.

The one significant gap in the AppleScript model is that Worksheet Functions did not make it over from VBA. Apparently there are conflicts between how Excel performs these and how they would have to be done piped through AppleScript, which does not have the same precision with floating point numbers. But you can enter any Function (via AppleScript) into a cell on a worksheet, let Excel do its calculations, pass the result (cell value) back to the script, and clear the cell.

We will start, as with the other application chapters, with making and opening new documents (workbooks and worksheets), then pass on to working with existing worksheets, working with ranges, and then to a few of the many other features of Excel.

New Workbook, Open Workbook, Add a Worksheet

Make a new workbook

Just a reminder, already mentioned in Chapter 2, that the way to make a new blank document equivalent to

   Application.Workbooks.Add

is

make new workbook

Normally in AppleScript, you expect to be able to specify many, or most, of the properties of a workbook in a with properties parameter, right at creation time, as in Chapter 2's example of making a new table at a document. (A scripter would expect that only elements, if any are needed, would have to be added afterwards.) That turned out not to be possible with Word documents, but it is possible with Excel, I am happy to report.

All of the properties listed in the dictionary as read/write, with the exception of those that require that a workbook first be set up as a shared workbook, can be set with properties {…} in the make new command. In VBA, you would have to set these after making the new workbook and setting a reference to it in a variable.

You can do that in AppleScript, too, as we will see below, but you can also set any of the following properties at inception. I have set all of them here to something other than the default values, and they all work, including setting passwords:

tell application "Microsoft Excel"

     set newWkbk to make new workbook with properties ¬

          {accept labels in formulas:false, conflict resolution:¬

              local session changes, date 1904:¬

              false, display drawing objects:¬

              placeholders, personal view list settings:¬

              false, personal view print settings:¬

              false, precision as displayed:true, save link values:¬

              false, update remote references:¬

              false, template remove external data:¬

              true, keep change history:¬

              true, remove personal information:¬

              true, password:"yyyyy", write password:¬

              "zzzzz", read only recommended:¬

              true, workbook comments:"Hi, there"}

end tell

You can verify that these are non-default settings, if you wish, by first running

      properties of active workbook

on a regular blank new workbook, copy the result to a text editor, and then run it again after making another workbook using the script above with non-default property values. Compare the results. If you save and then re-open the workbook, you will be asked for passwords, and all the other properties, including the ones recorded in Excel/Preferences/Calculation/Document Properties are all set already.

Setting properties at inception in the make new command is a useful time-saver, and something to consider when you start writing your own AppleScripts in the future. Probably when converting your VBA macros, it is simpler to just mimic the standard VBA macro line by line:

   Dim newWkbk As Workbook

 

Set newWkbk = Workbooks.Add

With newWkbk

.AcceptLabelsInFormulas = False

.PrecisionAsDisplayed = True

' etc.

End With

In AppleScript:

tell application "Microsoft Excel"

     set newWkbk to make new workbook

     tell newWkbk

          set accept labels in formulas to false

          set precision as displayed to true

          -- etc

     end tell

     end tell

omitting the Dim statement, of course, because there is none in AppleScript.

The one optional argument for the Workbooks.Add method, the Template argument to open a new workbook based on a particular template, has no equivalent template parameter to the make new command. And there is no template property for workbooks to set at inception, either.

But there is a very simple solution that works perfectly. Unlike Mac Word 2004 and earlier, opening an Excel template – whether from Excel, or in the Finder, or via VBA, or via AppleScript – opens a new document (workbook) made from the template. So instead of make new document, just open the template. Thus

   Application.Workbooks.Add Template:="Mac HD:Folder:Template.xlt"

in VBA should be converted to:

tell application "Microsoft Excel"

     open "Mac HD:Folder:Template.xlt"

end tell

and that's all there is to it. If you need to set a variable (reference) to the new workbook, then instead of the basic open command from the Standard Suite – which does not return a result – use Excel's own open workbook command from the Excel Suite:

tell application "Microsoft Excel"

     set newWkbk to open workbook workbook file name ¬

          "Mac HD:Folder:Template.xlt"

end tell

This is the better solution.

Open an existing workbook

And that brings us around to how to open an existing document – which we've just done! As we can see, there are two ways to do it. All applications implement the Standard Suite's open command – it's one of the most basic commands there is, and is required of all Mac applications, even those otherwise unscriptable: open, run, print and quit are all required. Sometimes applications add their own specialized parameters to open, as Word does.

The problem is, that to keep it as flexible as possible, since it can also be used both by unscriptable applications and by the Finder to open any application's documents without having any conception how to represent them when opened, it does not return a result. That is not good for scriptable applications that open their own documents.

Excel does the smartest thing: it leaves the Standard Suite's open command in place – where it can be used to open entire lists of files at once – but with no special parameters. Instead, it also has a separate open workbook command in the Microsoft Excel Suite, equivalent to VBA's Open, with all of its parameters (arguments), and which does return a result. You can therefore set a variable (reference) to the open workbook command. That's the one you should use.

Workbooks.Open Filename:="Mac HD:Folder:File.xls"

translates to:

tell application "Microsoft Excel"

     open alias "Mac HD:Folder:File.xls"

     -- or:

     open "Mac HD:Folder:File.xls"

     -- or:

     open workbook workbook file name "Mac HD:Folder:File.xls"

end tell

while

   Set oWkbk = Workbooks.Open(Filename:="Mac HD:Folder:File.xls")

translates to:

tell application "Microsoft Excel"

     set theWkbk to open workbook workbook file name "Mac HD:Folder:File.xls"

end tell

The open workbook version offers many options. To open a text file you might find a macro with the Format argument, specifying the delimiter (1=Tab, 2=Comma, 3=Space, etc):

Workbooks.Open FileName:="Mac HD:Folder:File.txt", Format:=1

which translates to:

open workbook workbook file name ¬
       "Mac HD:Folder:File.txt" format tab delimiter

Note that you can also use the numbers 1, 2, 3, etc. for the format parameter, and it works! So for translating from VBA macros don't go to the trouble of opening VB Editor to scour the Object Browser and work out which number is equivalent to which parameter. Just use the same number in the script. (There are quite a few enumerations where you can do this.) But it's a lot more useful having the proper names when writing your own scripts from scratch.

For opening text files, there is a much more powerful command, however – open text file. Your VBA macro might well be using the VBA equivalent – OpenText – and then you should too.

Workbooks.OpenText FileName:="Mac HD:Folder:File.txt", _

   DataType:=xlDelimited, Tab:=True

to:

tell application "Microsoft Excel"

     open text file filename ¬

          "Mac HD:Folder:File.txt" data type delimited with tab

end tell

Note that in AppleScript the boolean command values true and false following a parameter name (tab true, tab false) compile as with and without respectively preceding the parameter name (with tab, without tab). Don't be alarmed when that first happens. You can type them either way. A group of booleans all of the same value compile together like so:

tab true consecutive delimiter true

compiles as:

with tab and consecutive delimiter

The VBA OpenText command might come with some rather complex information in the optional FieldInfo argument:

   Workbooks.OpenText FileName:="Mac HD:Folder:File.txt", _

      DataType:=xlDelimited, Tab:=True, _

      FieldInfo:=Array(Array(3, 9), Array(1, 2))

Without getting into exactly what that means here (it has to do with specifying the data types of specific columns) you can translate that FieldInfo value to:

     open text file filename ¬

          "Mac HD:Folder:File.txt" data type delimited ¬

          field info {{3, 9}, {1, 2 }} with tab

where the VBA Arrays become lists in AppleScript. If you need to understand and not just transcribe them, or if there is a problem with that method, read up on field info in either the VBA Help or the Excel AppleScript Reference, and do it this way, as specified by the dictionary:

     open text file filename ¬

          "Mac HD:Folder:File.txt" data type delimited ¬

          field info {{3, skip column}, {1, text format}} with tab

Add a worksheet or chart

From here on, to save space I will omit many of the tell application "Microsoft Excel" blocks for the shorter excerpts. But it always applies. All statements will compile only in Excel tell blocks.

To add a new worksheet to the active workbook, placing it just to the left of the active worksheet:

   ActiveWorkbook.Worksheets.Add

becomes:

make new worksheet at active workbook

You can always use "in" instead of "at" if it sounds better to you:

make new worksheet in active workbook

works just the same. (You may have noticed that AppleScript has many synonyms and alternative ways of saying the same thing. That sometimes confuses people coming from other programming languages.)

Again, you can set read/write properties at inception.

set newSheet to make new worksheet at active workbook with properties ¬

     {name:"Test 1", display page breaks:false}

Using Before or After in VBA allows one to place the new worksheet precisely. To add one worksheet to the beginning of the workbook:
ActiveWorkbook.Worksheets.Add Before:=1, Count:=1

In AppleScript you would do that this way:

make new worksheet at beginning of active workbook

To add two worksheets to the right of the last worksheet:

With ActiveWorkbook.Worksheets

   .Add After:=.Item(.Count), Count:=2

End With

That's a little more complicated for AppleScript, since there is no way to make two or more elements at a time: make new makes just one element. However, we do have a lot of options for inserting elements. Here's how it works:

The proper ways in AppleScript of indicating an insertion location are: at beginning of, at end of, at before [some element], at after [some element]. But they do not always all work: they only do so if implemented by the application developers. What works here is at beginning of, at end of, but not reliably with before or after. (Well, 'before' appears to work if you don't refer to any element (i.e. an existing sheet) as you're supposed to, and just write make new worksheet at before active workbook; but all that's happening is that 'before' is being ignored and the worksheet is made at the default location at the beginning. If you try it 'at before sheet 3' for example, it works once but then crashes if the new sheet 3 is not the active sheet – a peculiar bug that may have something to do with faulty re-indexing on Excel's part. )

For the particular VBA example here, we do not even have to count the sheets – just make a new sheet at the end, twice:

     repeat 2 times

          make new worksheet at end of active workbook

     end repeat

Suppose you already have four sheets, and you want to insert two more after the first one (at the left) and have no idea which sheet is the currently active one. You might try using after (but don't omit the at as well, which sounds peculiar, but is correct). However, if you try it, as seems logical:

tell application "Microsoft Excel"

     tell active workbook

          repeat 2 times

              make new worksheet at after sheet 1

          end repeat

     end tell

end tell

Excel crashes on the second repeat (that bug referred to above: sheet 1 is not active after the first time through the repeat). It does not seem possible to create new sheets in the middle by AppleScript directly – you'll have to add sheets and the beginning or end only. But with a bit of ingenuity you can do it, using the Standard Suite's move command. (Excel's own copy worksheet command was needed to translate VBA's Copy Method to AppleScript in order to get before and after parameters, but the Standard Suite's move command already has a to parameter that allows before and after insertions. The developers did the right thing in making use of move. But it's easy to forget to look in the Standard Suite.)

Here's how to insert two new worksheets after Sheet 1:

tell application "Microsoft Excel"

     tell active workbook

          repeat 2 times

              set ws to make new worksheet at end

              move ws to after sheet 1

          end repeat

     end tell

     end tell

To add a Chart in VBA, you use the Type argument with the Add Method, on the Sheets Collection. (Charts are not Worksheets, but another subvariety of Sheet.)

      ActiveWorkbook.Sheets.Add Type:=xlChart

But the worksheet type property of sheet class , which includes sheet type chart as one of its types, is read-only, and cannot be set even at inception (as sometimes is the case with some commands, we shall see later). If you try to set the type to sheet type chart when making a new sheet this property just gets ignored: you end up with a new worksheet as usual. (This is not unexpected, nor a bug. Just an indication that AppleScript's make new with properties is not the same as VBA's Add Method.)

In AppleScript, chart sheet is a class, corresponding to Chart in VBA, and a subclass of sheet. Unlike in VBA, you can make one directly, so there's no problem:

tell application "Microsoft Excel"

     make new chart sheet at active workbook

end tell

This is just a completely blank sheet, ready for its chart. (chart is a read-write property of chart sheet, and can be set along with most of its own properties.) Charts are complex objects. We will look into them later.

Open a new window on a worksheet

In VBA, multiple windows can be used to look at different parts of the same worksheet:

ActiveWindow.NewWindow

Windows.Arrange ArrangeStyle:=xlHorizontal

In AppleScript you can make the new window, but there's no arrange command. You have to work it out and do it the hard way:

tell application "Microsoft Excel"

     tell active workbook

          set {l, t, h, w} to window 1's {left position, top, height, width}

          new window on workbook

          tell window 1 to set {left, top, height, width} to {l, t, h / 2, w}

          tell window 2 to set {left, top, height, width} to {l, (t + h / 2), h / 2, w}

     end tell 

end tell

Height is measured in points starting at the top of the screen as (0, 0). That is why we add half the height to get half way down. Note that active window is a "dynamic" reference to whichever window is in the front at any time you refer to it, even when you have set a variable to it – the variable "moves" to the current active window. Setting, or even copying, a variable to active window of the application doesn't "hold" the window: when a new window is made it becomes active window, and the variable, which is a reference, now refers to the new one.

If you're not careful, you can end up doing both the operations on the same window and end up with a quarter-size one halfway off the screen, and a full-size one exactly where it was to begin with. That's why it's easier to just refer to window 1 and window 2 of the workbook after the new one is made. In this case it doesn't matter which is the active one.

You can set the view of a window using the View property(xlNormalView, xlPageBreakPreview, or xlPageLayoutView):

   ActiveWindow.View = xlNormalView

In AppleScript:

set view of active window to normal view

Working with Existing Worksheets

Rename a worksheet

Worksheets can be renamed by setting their name property:

   ActiveSheet.Name = "New Sheet Name"

In AppleScript:

set name of active sheet to "New Sheet Name"

This can cause an error if the sheet name is invalid, or a sheet already has that name. One workaround in VBA might look like this:

Const sNAME = "New Sheet Name"

On Error Resume Next

ActiveSheet.Name = sNAME

If ActiveSheet.Name <> sNAME Then MsgBox "Re-name failed"

On Error GoTo 0

In AppleScript, this will do it:

tell application "Microsoft Excel"

     try

          set name of active sheet to "New Sheet Name"

     on error

          display dialog "Re-name failed." buttons {"Cancel"} with icon 0

     end try

end tell

In this case, it does not fail silently, but creates a true error you can trap.

Rename a worksheet with a cell value

Set a worksheet name to the value of a cell:

On Error Resume Next

With ActiveSheet

   .Name = .Range("A1").Text

End With

On Error GoTo 0

In AppleScript:

try

     set name of active sheet to string value of range "A1"

end try

Setting Headers and Footers

Headers and footers are set in VBA using the PageSetup object of a worksheet:

      ActiveSheet.PageSetup.LeftHeader = Format(Date, “dd mmmm yyyy”)

You can also use the CenterHeader, RightHeader, LeftFooter, CenterFooter, and RightFooter properties. Those translate unsurprisingly to AppleScript as center header, right header, left footer and right footer of the page setup object property of worksheet. (Note "object" at the end of the property name, but not so in the class name page setup to which it refers: more on that later.) To set multiple headers and footers:

Public Sub PathAndFileNameInFooter()

   Dim wsSht As Worksheet

   For Each wsSht In ActiveWindow.SelectedSheets

   wsSht.PageSetup.LeftFooter = ActiveWorkbook.FullName

Next wsSht

End Sub

In AppleScript:

     repeat with wkSht in (get selected sheets of active window)

          set left footer of page setup object of wkSht to ¬

                        full name of active workbook

     end repeat

Note that when using the repeat with someVariable in someList form (which closely patterns the usual VBA loop syntax so people tend to prefer it), if you have not previously set a variable someList to the list but instead are accessing the object reference right there in the repeat statement (selected sheets of active window), you must use the explicit get to force an evaluation.

Rename a worksheet with a number index

When Excel copies a worksheet, by default it‘s named "Sheet(xxx)", where xxx is a number that increments each time a worksheet is added. To reproduce that with another name, you might be doing this in VBA:

Const sBASENAME As String = "MySheetName"

Dim ws As Worksheet

Dim sTryName As String

Dim i As Long

Worksheets.Add After:=Sheets(Sheets.Count)

On Error Resume Next

sTryName = sBASENAME

Set ws = ActiveWorkbook.Worksheets(sTryName)

Do Until ws Is Nothing

   Set ws = Nothing

   i = i + 1

   sTryName = sBASENAME & Format(i, " (0)")

   Set ws = ActiveWorkbook.Worksheets(sTryName)

Loop

ActiveSheet.Name = sTryName

On Error GoTo 0

We do a few things differently in AppleScript:

property sBASENAME : "MySheetName"

 

tell application "Microsoft Excel"

     make new worksheet at end of active workbook

     try

          set sTryName to sBASENAME

          set ws to worksheet sTryName of active workbook

          ws -- forces an error if no such worksheet

          set i to 0 -- needs to be explicit

          repeat -- no need to set ws to null at end

              set i to i + 1

              set sTryName to sBASENAME & " (" & i & ")"

              set ws to worksheet sTryName of active workbook

              ws -- forces an error if no such worksheet

          end repeat

     on error
          set name of active sheet to sTryName

     end try

end tell

I've given this script a script property declaration at the top, more nearly equivalent to the CONST declaration that many of these VBA macros have, although it's not strictly necessary. It does draw attention to the definition of sBASENAME, however, more than a simple

set sBASENAME to "MySheetName"

at the top would, so if you want to change the name to something else later it's very clear where to do it, as with CONST declarations. I say it's "not strictly necessary" since you're not taking advantage of the main virtue of script properties – persistence between runs (which you would do in VBA by a very different method) – and thus is no more effective for the purpose of having a single place to make the change than a regular set assignment, but certainly makes the definition clear. Note that the property declaration is placed above and outside the Excel tell block.

Error trapping, especially in connection with repeat loops, are a little different in AppleScript since the try/on error/end try structure has to be carefully positioned, unlike the freer On Error Resume Next manner of VBA. You have to work out whether your try/end try block needs to be around the repeat block, or within it, or whether you might need two of them. You might also need an exit repeat within an if/end if block inside the repeat block; we don't need that this time.

Another way to do it in AppleScript without needing a try/error block uses the exists command found in the Standard Suite and implemented by most applications, including Excel:

property sBASENAME : "MySheetName"

 

tell application "Microsoft Excel"

     tell active workbook

          set i to 1

          repeat until (worksheet (sBASENAME & " (" & i & ")") ¬

              exists) = false

              set i to i + 1

          end repeat

          make new worksheet at end with properties ¬

              {name:sBASENAME & " (" & i & ")"}

     end tell

end tell

This is actually simpler and clearer to read, with the added advantages of not needing extra variables nor those extra lines required to force errors. It does involve "thinking in AppleScript" rather than merely "translating" VBA literally, and is the sort of thing you should start doing as you become more familiar with the language.

One unusual thing about some newer scriptable applications like Excel, Word, PPT and the Apple iApps – less so with "traditional" AppleScriptable applications like Entourage – is that setting a variable to something non-existent often does not in itself necessarily cause an error. The error occurs when you next use the variable. That is why you have to immediately follow both statements setting ws to a worksheet that may not exist with an immediate call to the variable – it's an implicit get – to force the error.

You must check when writing your scripts if such a call is necessary, or else just do it as a matter of course. Do not assume an error will occur otherwise. If not, an error may not appear until later in the script (the first time you need to access ws) at a point where you have not trapped specifically for this one: it could be something else.

Next – in AppleScript there is no default value 0 for an increment variable, as in VBA: the variable is undefined. If you write

   set i to i + 1

without first setting i to 0, the script will error. We need to initialize i to 0 before the repeat loop begins, of course.

There is no equivalent to VBA's Format function in basic AppleScript. Many third-party scripting additions provide equivalent functions, and AppleScript has full access, via the built-in do shell script command in Standard Additions, to all the very powerful Unix tools that can probably out-perform Format if needed. On this occasion, it's a very simple matter just to concatenate the incrementing variable i into a string expression between two parentheses. A string to the left of the concatenation operator & coerces a number on its right to a string, so there is no need for an explicit coercion as string.

Because an error will be forced when you arrive at a sheet name that does not yet exist, taking you right out of the repeat loop into the on error block outside it, there is no need for any sort of while or until condition in the repeat statement nor for an exit repeat in an if block anywhere. You are guaranteed to exit straight into the on error block, and thence to the end of the script every time. It makes life a lot simpler sometimes having structured try/on error blocks!

Finally, in AppleScript, since there is no need to set variables that are application references to null (our equivalent of Nothing), none of that needs to be prepared either. We're done. Quite a lot of syntactical differences between VBA and AppleScript for such a short script.

Delete a worksheet

In VBA, worksheets are deleted with the Delete method. In AppleScript, delete in the Standard Suite works the same way, except that it allows you to delete lists of several items all at once and avoid repeat loops completely in applications where this behavior is implemented. Note however, that workbooks must contain at least one worksheet, so you can‘t delete the last worksheet in a workbook. To delete all but the first sheet in VBA:

   On Error GoTo Err_Handler

Application.DisplayAlerts = False

For i = Worksheets.Count To 2 Step -1

Worksheets(i).Delete

Next i

Err_Handler:

Application.DisplayAlerts = True

As mentioned earlier, this backwards motion through repeat loops is always required in AppleScript in any case. So the way to do an exact replica would be:

tell application "Microsoft Excel"

     set display alerts to false

      try

          set allSheets to (every worksheet in active workbook)

          repeat with i from (count allSheets) to 2 by -1

              delete (item i of allSheets)

          end repeat

      on error

          set display alerts to true

      end try

end tell

But why bother? You're in AppleScript now, so do it the AppleScript way:

tell application "Microsoft Excel"

     set display alerts to false

     try

          delete items 2 thru -1 of (get every worksheet of active workbook)

      end try

      set display alerts to true

end tell

Much easier. (But note the explicit get needed.) The try statement is used because if there is in fact just one worksheet to begin with, there will be no item 2 and the statement will error. That is precisely the point you wish to be at (just one worksheet) so we move on and turn error messages (display alerts) back on. In fact, Excel even lets you do this without erroring:

tell application "Microsoft Excel"

     set display alerts to false

      try

          delete (every worksheet of active workbook)

     end try

     
      set display alerts to true

end tell

Without even telling it to do so, it leaves the first worksheet in place without trying to delete it nor erroring. Well, that's a handy shortcut to use now that you know about it, but don't count on it in all other circumstances.

Deleting a whole list of items, like opening a whole list of items, is a great and powerful advantage of AppleScript, especially in production work: use it.

In all cases, set the application property display alerts to false to get around Excel's annoying "safety feature" of a separate Alert window for each worksheet about to be deleted. Then turn alerts back on when done.

Protecting worksheets

Worksheet protection exists to prevent inadvertent changing of cells by the user. (It is not a security method, as the protection can be bypassed in seconds by freely available methods.) Here's how it's done in VBA:

   ActiveSheet.Protect Password:="drowssap"

In AppleScript there are separate commands protect worksheet and protect workbook, depending on what you're protecting, so:

tell application "Microsoft Excel"

     protect worksheet (active sheet) password "drowssap"

end tell

Note that the converse, unprotect, works on both sheets and workbooks:

     unprotect (active sheet) password "drowssap"

and there is a minor error in the dictionary: although it correctly shows that the command has a direct parameter (sheet/workbook) the formatting in the dictionary for the latter indicates that these are enumeration constants, but in fact they are not: they actually indicate the class of the object required: sheet or workbook. More on this issue, which crops up in several places, at the end of this chapter.

To easily protect all sheets in a workbook using the same password:

Const sPWORD As String = "drowssap"

Dim ws As Worksheet

For Each ws In ActiveWorkbook.Worksheets

   ws.Protect Password:=sPWORD

Next ws

Once again, you can scrap the looping:

set sPWORD to "drowssap"

protect worksheet (every worksheet in active workbook) password sPWORD

It's not just Standard Suite commands like open and delete that can act on multiple items: so do protect worksheet, unprotect, and many others in the Excel dictionary: Excel has evidently implemented most of its own commands to do so too. But you will need to check with every command new to you, since sometimes you will hit one that does not do so.

Hiding worksheets

Worksheets can be hidden from the user. To hide all worksheets with "(hide)" in their name:

Const sHIDEINDICATOR As String = "(Hide)"

Dim ws As Worksheet

For Each ws In Worksheets

   ws.Visible = Not (LCase(ws.Name) Like _

             LCase("*" & sHIDEINDICATOR & "*"))

Next ws

Another easy one for AppleScript:

tell application "Microsoft Excel"

     repeat with ws in (get every worksheet in active workbook)

          set visible of ws to not (name of ws contains "(Hide)")

             end repeat

end tell

AppleScript's text operators – all except AppleScript's text item delimiters (more on them later) – are case insensitive unless you've placed them inside a considering case block. So we do not need to go through any contortions as in the VBA code to compare any word with "(Hide)" or "(hide)". And although standard AppleScript without scripting additions does not have wildcards or regular expressions, it does have contains, which does the job perfectly.

Now here's a case where every worksheet whose… does not work, because Excel can't deal with a property (e.g., visible) of such a construction, as mentioned at the end of Chapter 3.

set visible of (every worksheet in active workbook ¬

          whose its name contains "(Hide)") to false

--> ERROR: Can't set visible of every worksheet of active workbook whose name contains "(Hide)" to false.

So here you need to use a repeat loop.

But there's a subtle twist you need to be aware of: the VBA code above used Not – i.e., ws.Visible = False – as a synonym for the enumeration xlHidden. To prevent the worksheet from appearing even in the Format/Sheet/Unhide dialog, it would instead set the Visible property to xlVeryHidden:

   ActiveSheet.Visible = xlVeryHidden

In AppleScript, that's:

set visible of active sheet to sheet very hidden

The correct enumeration for the visible property is, in AppleScript: sheet hidden, sheet very hidden and sheet visible, equivalent to VBA's xlHidden, xlVeryHidden and xlVisible. You can use true and false as synonyms for sheet visible and sheet hidden respectively if you wish, just as in VBA.

This is a bit clearer in the Object Browser of VB Editor if you check the actual Longs (numbers) of the enumerated constants. But it works in AppleScript too.

This is very convenient in making these VBA-to-AppleScript conversions, as I mentioned back in the open text file section: if the VBA macro writer used numbers instead of the enumerated xl or vb constants, you can generally just transcribe the same numbers into your AppleScript code even though it's not explicitly defined in the AppleScript dictionary which enumerated constants they refer to, nor even that these "number equivalents" exist for the constants.

Working with Columns and Rows

Alert: There are some very serious AppleScript bugs in Excel 2004 to do with columns and rows. Something was implemented incorrectly when the Columns and Rows Collection Objects were adapted for AppleScript. Thus:

     row 5 of (get used range of active sheet)

     column 7 of range "A1:P26" of active sheet

     range "G1:G26" of range "A1:P26" of active sheet

all produce something that is useful and functional, namely a range. The result is never referred to as a column or row, always as a range. But      

     column "G1:G26" of range "A1:P26" of active sheet

(i.e., referring to it as a column, rather than as a range) produces nothing – no result. So you can refer to columns and rows by index (number), never by address. Perhaps this will not be unexpected coming from VBA, where you would typically refer to Columns(7) and Rows(5). It doesn't jibe with what you would expect from the dictionary, where column, row and cell are all subclasses of range and inherit all its properties. That means you ought to be able to do the same with column, row and cell as you do for range, but you can't. For most purposes, if you stick to referring to columns and rows by index, and use range when using an address, things will be smoother.

Worse, and stranger, is that you cannot get anything useful for:

     rows of (get used range of active sheet)

     columns of range "A1:P26" of active sheet

     You get a sort of bogus single object – a single row or column of no dimensions, rather than a list of items as you should. You cannot then get any individual items from what ought to be a list – your script errors if you try. It also means that you cannot do repeat loops of this sort:

     set theRows to rows of (get used range of active sheet)

     repeat with theRow in theRows

          set v to value of theRow

     end repeat

The script just "jumps" over this as if it's not there (try it in a line-by-line debugger editor and you'll see it happen), and then errors as soon as anything tries to use a result or variable set to anything in the loop.

However, you can get there another way since, even more strangely, count (every row) or count rows (the same thing) works fine! You can't get rows, but you can get (count rows)! So you can iterate through a repeat loop getting row i, where i is looping from 1 to (count rows).

Even stranger – and this one is very hard to fathom – you cannot set a variable to a row or column along the way because once again you get no result! The reference to a row or column seems to lose its connection to the real thing whenever it is evaluated to a variable. The only thing that works is a pure application reference without variables, drilling through each element along the way.

So you must do it this way:

     tell (get used range of active sheet)

          repeat with i from 1 to count rows

              set v to value of row i

          end repeat

     end tell

Wait until you've got the final result you need before setting a variable to that (e.g., the value property here), never to the row or column or cell along the way. It's perfectly all right to set a variable to something referred to as a range, however, whether used range or a range by address (range "A1:A46"), including ranges that actually are rows or columns, but not to anything that was defined as, for example, row 5 or column 8. So this is also OK, where the variable ur is set to a range:

      set ur to (get used range of active sheet)

     tell ur

          repeat with i from 1 to count rows

              set v to value of row i

          end repeat

     end tell

but not this, where the variable theRow is set to a row:

      set ur to (get used range of active sheet)

      
     tell ur

          repeat with i from 1 to count rows

              set theRow to row i

              set v to value of theRow

          end repeat

     end tell

These "rules", or behaviors, are baffling, and very hard to discover. So do keep this description on hand until you're used to it.

Another problem is that commands will not work on 'every column of someRange', or 'rows of someRange', because those do not resolve to AppleScript lists as they usually do, as mentioned at the beginning of this section. They are those bogus objects of no consequence mentioned earlier. So you really do need to use the only dependable technique for accessing single items one at a time in a repeat loop with no row or column variables, as illustrated above.

I suspect that the phantoms of the VBA Collection Objects are lurking behind this behavior. The fact that you can count rows and columns and refer to them by index – two Methods available to Rows and Columns Collection Objects in VBA – but not by address sounds rather familiar. As does the fact that you can't resolve the plurals to lists of individual items.

To make things work more smoothly, Microsoft will have to improve the structure behind columns and rows and make them more AppleScript-friendly. And cells too – they are almost as bad, if you try to use them via every cell of someRange. You can set a variable to a cell, though, because it is returned as a range. Stick to range as much as you can.

Value of Columns, Rows and Ranges as Lists

Now for some good news: in AppleScript, you can get and set the value not only of an individual cell, but also of an entire row, column, or any range, via AppleScript lists. This is how it works: the value of a range is a list of lists, with the inner lists being the rows, and the items of the inner lists being the cells. Like so:

{{1, 2, 3}, {10, 20, 30}, {100, 200, 300}, {1000, 2000, 3000}}

represents a range with 3 columns and 4 rows. The top row contains {1, 2, 3}, and so on.

A range consisting of a single row may be thought of as a single list {1, 2, 3}: you can set the value of a 3-columned row to that, if you wish, and it will work. If you ask Excel for the value, however, it will always return a list of list {{1, 2, 3}}, since a row is itself a range: a one-row-range. That is its proper representation. You can set it that way too.

A column's value is always represented like this: {{1}, {10}, {100}, {1000}} – just like any range, but where the inner lists have just one item each.

A single cell's value is returned as just the value: 1, or 10, not as a list of list. That is for convenience. And you can, and usually will, set it that way too. But you could set the value of a cell to {{10}} for example, instead of 10, and you would still see 10 in the cell.

(See the next section – Working with Ranges – for an example setting the content of every cell of a non-contiguous range all to the same value.)

Only the value property can be retrieved and set for a row, column or range as a list of lists in this way. Not even the string value property can operate with multi-cell lists.

With all this in mind, let's try out a couple of simple procedures brought over from VBA.

Selecting the Active Cell‘s Row or column

In VBA, you select the row or column of the active cell using the .EntireRow or .EntireColumn properties:

   ActiveCell.EntireRow.Select

In AppleScript, that's:

select entire column of active cell

(select is in the Standard Suite.) And it works perfectly.

Row Height, Column width, and Autofit

While row height is set by the row height property in points, columns use the column width property to set the width in number of standard numeric characters (e.g., the width of the zero, "0"), which depends on the standard font and size set in Preferences. In VBA, you have the alternative of using the Autofit command on columns and rows to reduce the sizes to the minimum height and width required for the contents. But there is a problem with autofit in AppleScript. The VBA macro writer of this next macro has used all three:

Range("1:4").RowHeight = 20   'points

Range("A:C").ColumnWidth = 20 'characters

With Range("J5:Z43")

   .Columns.AutoFit

   .Rows.AutoFit

   End With

The first two statements translate perfectly to AppleScript, as we will see in a moment. There is nothing difficult about setting row height and column width.

To use autofit, which can be a great convenience, you need to loop it for each column separately, as we have just seen in the discussion about columns and rows. Nothing happens if you try it on columns as a plural, or every column.

That is manageable. Much worse is that autofit does not work at all for rows, not even on a single row. Something is badly wrong there: it actually messes up the columns instead, reducing the width of many of them and destroying any autofit you did for them, and doesn't do anything for the rows. It looks to me as if it is taking the instructions for rows and using them on columns instead by mistake. Fortunately, 99% of the time your rows are likely to be all the same height. If any need to be sized differently, you'll have to set their row height individually.

So, the way you have to convert the macro above is like this:

tell application "Microsoft Excel"

     set row height of range "1:4" to 20 -- points (rows)

     set column width of range "A:C" to 20 -- characters (columns)

     tell range "J5:Z43" of active sheet

          repeat with i from 1 to (count columns)

              autofit column i

          end repeat

          -- now see if here are any rows whose row height

          -- has to be adjusted, and do them separately

     end tell

end tell

Working with Ranges

Alert: If you skipped the previous section on Columns and Rows, please go back and read about a series of serious bugs in the AppleScript implementation, which can affect ranges too if you refer to them as column, row or cell in your scripts rather than as range.

Ranges are the basis for most manipulation of Excel using VBA and AppleScript. Note that ranges are child objects of worksheet, and so cannot contain cells in multiple worksheets.

Note that AppleScript refers to ranges by address in A1 format as it does "by name" in other applications: that is, the keyword range is followed directly, after a space, by the address in quotes, without the parentheses that VBA uses:

VBA: Range("A1:J10")                                             AppleScript: range "A1:J10"

There's one minor "gotcha" that should be mentioned at this point. Most people have discovered, in both VBA and AppleScript, that if they write simply Range("A1:J10") in VBA, or range "A1:J10" or cell "A1" in AppleScript, without specifying any sheet, Excel defaults to the active sheet. However, for some reason, if you refer to used range:

set ur to used range

or

cell 3 of row 4 of (get used range)

without specifying of active sheet, no result is returned and the next line of the script referencing the result will error. It is always best practice, in any case, to target the sheet, perhaps via tell active sheet around as much of the script as needs it (just as in VBA you would write With ActiveSheet). This minor bug will keep you honest! If you are in the habit of omitting active sheet, you will hit perplexing errors when you need to access the used range, as happens in a great many scripts. So it's best not to get into that particular habit.

Selecting or setting a variable to a Range

In VBA, ranges are specified using the Range Property applied to a Worksheet (or to another Range), or Range‘s Cells property applied to a Range. (The Cells property is the default property for the Range object, so it generally is not explicitly called by name. You might see just parentheses with two numbers representing the row and column of the cell respectively.) There is no "cells" property of a range or worksheet in AppleScript: just use the appropriate number to get the cell (column number) of row (row number), as in the second line of the next AppleScript snippet. I.e., where in VBA you write .Cells(10, 6) or just .(10, 6), in AppleScript you write cell 6 of row 10.

Ranges can be selected and set directly.

Range("A1").Select

ActiveWorksheet.Cells(10, 6).Select

Set rMyRange = Range("B10:C14")

becomes:

tell application "Microsoft Excel"

     select range "A1"

     select (cell 6 of row 10 of active sheet)

     set myRange to range "B10:C14"

end tell

You can use the get resize command, in the Table Suite (where most commands acting on ranges are to be found), where VBA uses the .Resize Property (or Method) to expand or choose a range:

Range("A1").Resize(10, 10).Select   ’Selects A1:J10

becomes:

select (get resize range "A1" row size 10 column size 10) --selects A1:J10

Setting a non-contiguous range to a single value

In the last section Working with Columns and Rows we learned how to set the values of a range to a list of lists (rows). VBA is also full of handy shortcuts such as the following:

      Range("A1:B5,G9,A16:D19") = 5

The Range address describes a non-contiguous range consisting of the rectangle containing 10 cells (2 columns of 5 rows) within A1:B5, the single cell G9 off on its own, and the discrete rectangle A16:D19 containing 16 cells (4 columns of 4 rows). The statement is a sort of shortcut (you can't actually set such a range to the integer 5) that sets the value of every cell in the range to 5. It works.

Again, it works because VBA has Default properties which don't need to be spelled out explicitly if you're in a hurry. Cells is the Default property of range, and Value is the Default property of Cell.

At first glance, it doesn't look as if you can do this in AppleScript. But you can – as long as you state the properties explicitly, since there are no Default properties in Excel AppleScript:

set value of every cell of range "A1:B5,G9,A16:D19" to 5

This is even "pure" AppleScript: no "shortcut" required. It sets the value of every cell of that peculiar, disjointed, non-contiguous range to 5. all in one go, just as the VBA version does.

Copying and pasting a Range

The simplest way to copy a range from one location to another is to use the copy range command equivalent to VBA's Copy method:

With ActiveSheet

   .Range("A1:J10").Copy Destination:=.Range("M1")

End With

becomes:

tell application "Microsoft Excel"

     copy range range "A1:J10" destination range "M1"

end tell

You'll notice a quite common repetition of keywords (e.g., range) from commands to direct objects to parameters, all running on. Don't leave any out. You'll see that the shorthand of specifying just the top-left initial cell for the destination range is sufficient in AppleScript as well as in VBA. And without saying so until now, we've sometimes been neglecting to include 'of active sheet' and that is taken for granted as the default, just as in VBA.

Note that copy range copies values, formatting, conditional formatting, validation, etc.

You can paste the contents of the clipboard into the active cell using the paste worksheet command (in the Excel Suite this time), equivalent to the VBA Paste method, or, using the optional destination argument, into a particular cell.

ActiveWorkbook.Sheets("Sheet1").Range("A1:J10").Copy

With Workbooks("Book2.xls").Sheets("Sheet1")

   .Paste Destination:=.Range("J3")

End With

becomes:

tell application "Microsoft Excel"

     copy range (range "A1:J10" of sheet "Sheet1" of active workbook)

        tell sheet "Sheet1" of workbook "Book2.xls"

          paste worksheet destination range "J3"

     end tell

end tell

If you‘re only trying to copy values, it‘s far more efficient and quicker to simply assign them, rather than calling the copy range command (Copy method in VBA):

With Sheets("Sheet1").Range("A1:J10")

   Sheets("Sheet2").Range("B10").Resize( _

          .Rows.Count, .Columns.Count).Value = .Value

End With

becomes:

tell application "Microsoft Excel"

     tell (range "A1:J10" of sheet "Sheet1")

          set value of (get resize (range "B10" of sheet ¬

              "Sheet2" of active workbook) row size (count rows) ¬

              column size (count columns)) to get its value

     end tell

end tell

In this case it is necessary to specify of active workbook for sheet "Sheet2" since it is in a tell block targeted at a range in sheet "Sheet1", a different sheet. AppleScript is perhaps more objected-oriented here than VBA in that if you don't specify of active workbook it looks for Sheet 2 inside its own range "A1:J10", of course doesn't find a sheet there, so doesn't do anything.

Similarly, you absolutely need the explicit get for its value to force it to be evaluated in the same command. (If you set a variable to it in a previous line then the get is not necessary: see Chapter 2. Actually Excel seems not nearly so insistent on the explicit get as Word, but in this case it is necessary.) The its may not be essential this time but it helps keep straight whose value (the original range's) we're talking to. And frequently it is necessary in tell blocks.

Paste special

The paste special command in the Table Suite (there is a different paste special on worksheet command in the Excel Suite which is not concerned with ranges) corresponds to the PasteSpecial method in VBA, and allows you to perform operations on the destination range based on the contents of the clipboard (e.g., add, subtract, multiply, divide).

For instance to multiply the value in each cell of a range by 2:

Application.ScreenUpdating = False

' Get the value in the clipboard using a

' cell in a temporary worksheet

With ActiveWorkbook.Worksheets.Add

   With .Cells(1, 1)

      .Value = 2

      .Copy

   End With

End With

Sheets("Sheet1").Range("A1:J10").PasteSpecial _

      Paste:=xlPasteAll, _

      Operation:=xlPasteSpecialOperationMultiply

' Delete the temporary worksheet

With Application

   .DisplayAlerts = False

   ActiveSheet.Delete

   .DisplayAlerts = True

   .ScreenUpdating = True

End With

Here it is in AppleScript:

tell application "Microsoft Excel"

     set screen updating to false -- speed it up

         --get the value in the clipboard to a cell in a temporary worksheet

     tell (make new worksheet at active workbook)

          tell cell 1 of row 1

              set value to 2

              copy range -- to clipboard

          end tell

     end tell

     paste special (range "A1:J10" of sheet "Sheet1") what paste all ¬

          operation paste special operation multiply

     --delete the temporary worksheet

     set display alerts to false

     delete active sheet

     set display alerts to true

     set screen updating to true

end tell

And quite impressive it is too. Take a good look at the dictionary for paste special and the various enumerations of its parameters. Occasionally the names of keywords vary from the VBA ones, for example what rather than Paste. This is always to avoid terminology conflicts in AppleScript where keywords have a broad scope: paste is a very common term in scripting additions.

Transpose a Range

You can also use the paste special command method to transpose columns and rows. Note that, if the destination range has more than one cell, it must have the same number of rows and columns as the source range has columns and rows:

With ActiveSheet

   .Range("A1:E2").Copy

   .Range("A4:B8").PasteSpecial Transpose:=True

End With

becomes:

tell application "Microsoft Excel"

     copy range range "A1:E2"

     paste special range "A4:B8" with transpose

end tell

Note that paste special will not allow you to transpose the range in place, even if you‘re using a square range. Also recall that compiling transpose true compiles to with transpose.

Inserting a Range

You can insert blank cells into a range using the insert into range command (equivalent to the VBA Insert method), as long as there is room to do so without moving populated cells off the worksheet. It is just like the Insert/Rows-Columns-Cells menu in the UI.

Sheets("Sheet1").Range("B2:B5").Insert Shift:=xlShiftToRight

In AppleScript:

insert into range range "B2:B5" shift shift to right

If a range has been copied, and the Insert method applies to a range of the same size, the clipboard contents will be copied to the inserted cell.

With ActiveWorkbook

   With Sheets("Sheet2").Range("A1:A10")

   .Copy

   Sheets("Sheet1").Range("B2").Resize( _

      .rows.count, .columns.count).Insert _

      
      Shift:=xlShiftToRight, _

      CopyOrigin:=xlFormatFromLeftOrAbove

   End With

End With

Here the CopyOrigin argument in VBA has no AppleScript equivalent, so the defaults will rule : " If this argument is omitted, the format is inherited as from the Left or Above depending on whether the shift was to the right or down." So there's no way to specify it in AppleScript, but in this case the result will be exactly the same – xlFormatFromLeftOrAbove.

tell application "Microsoft Excel"

     tell active workbook

          tell range "A1:A10" of sheet "Sheet2"

              copy range

              insert into range (get resize row size (count rows) ¬

                   column size (count columns)) shift shift to right

          end tell

     end tell

end tell

Deleting a Range

Deleting a range moves cells up or to the left, depending on what the argument specifies. The following example deletes duplicate rows (based on identical values in the first column). Note that the loop goes from largest row to smallest "backwards" via Step -1, since Excel renumbers the rows after a deletion. Since this what AppleScript always does in its own indexing, you would have to do that anyway (repeat with i from lastRowNum to 1 by -1).

Dim i As Long

With ActiveSheet

   For i = .Cells(.Rows.Count, 1).End(xlUp).Row To 2 Step -1

      If .Cells(i, 1).Value = .Cells(i - 1, 1).Value Then _

          .Cells(i, 1).EntireRow.Delete

   Next i

End With

In AppleScript:

tell application "Microsoft Excel"

     tell active sheet

          set lastRowNum to first row index of ¬

              (get end (cell 1 of row (count rows)) direction toward the top)

          repeat with i from lastRowNum to 2 by -1

              if value of (cell 1 of row i) = value of (cell 1 of row (i - 1)) then

                   delete entire row of (cell 1 of row i)

              end if

          end repeat

     end tell

end tell

The thought of stuffing that complex and long-winded (in AppleScript) evaluation of the row number right into the repeat loop statement, as VBA does with its shorter terms and dot syntax, is too much to bear contemplation. It's better to work it out as a variable. Recalling the problems we found with columns and rows (check the Alert in Working with Columns and Rows), it is essential to use the application terms directly without variables for a row, but it always works to set a variable to a range or, as here, to a number (or string, date or other basic type).

With long trails of dots in VBA, it is natural when translating into AppleScript to expect to start at the end and work backwards from there, except that you actually need to start off with the "front" VBA object in order to know where to look for the properties that follow. Don't forget that whereas in VBA a Method name might occur somewhere along the way in the same dot syntax and parent-child relation as for a Property, in AppleScript the equivalent command does not use the same 'of' syntax as a property or element, and has to be sought in the Commands section of the appropriate dictionary Suite.

What in VBA is a Property might be an element, or a property of an element, or even a command, in AppleScript. So it can take a bit of time to find everything and work it all out.

We recall that the Cells(r, c) syntax translates to

      cell c of row r

in AppleScript, and the result is a range. So we look in range class in the Table Suite for something analogous to the End property – it might be end of range or something like that. But there's nothing at all like that to be seen in range class.

So we should look now in the Commands section of the Table Suite for something that might get the end of a range. There's nothing listed under "end of" there. So check the "get" neighborhood – always a good idea. When they need to come up with a proprietary command when a property won't work, the developers often start the command term with "get".

And there it is – get end. It takes a range as direct object or parameter ("direct" because no specific parameter keyword is needed) and its direction parameter takes an enumeration that is just what we are looking for, specifying toward the top for VBA's xlTop. (In this case it really means "last one, or end, starting at the top", i.e., oriented from the top's point of view. We're actually looking for the bottom row, of course.)

We know that although we can't get rows or every row of a range or sheet, we can, by some strange magic, get count rows (or count every row). (Check Working with Columns and Rows again.) Finally the Row Property of Range (it's a good thing, and to be expected, that AppleScript does not call this property "row": it would conflict with the class row) is evidently first row index property in AppleScript – a nice descriptive term that returns an integer, just what we are looking for.

So now we have everything needed to construct the statement that should return the row number of a cell:

     set lastRowNum to first row index of ¬

              (get end (cell 1 of row (count rows)) direction toward the top)

The one remaining thing would be to check whether AppleScript lets you use get end on the sheet itself (the target of the tell block) without producing 65535 as the last row of the sheet instead of the last used row, or would require us to explicitly target used range of the sheet instead, But no, AppleScript allows us to take the same shortcut (or coercion) as Sheet.End does in VBA: we get the last used row number, not 65535.

The rest of the script is easy, using cell c of row i a few more times, and getting the value property of each range (cell). delete entire row works just as it should, as long as you remember to do your repeat loop backwards "by -1" equivalent to VBA's Step -1.

A more efficient way to do this is to collect all the duplicates in a range variable and delete them all at the same time. Note that the Union method in VBA requires that both Range objects are set, and the same will be true in AppleScript with the union command.

Dim rCell As Range

Dim rDelete As Range

With ActiveSheet

   For Each rCell In .Range("A2:A" & _

             .Range("A" & .Rows.Count).End(xlUp).Row)

      If rCell.Value = rCell.Offset(-1, 0).Value Then

          If rDelete Is Nothing Then

             Set rDelete = rCell

          Else

             Set rDelete = Application.Union(rDelete, rCell)

          End If

      End If

   Next rCell

   If Not rDelete Is Nothing Then _

          rDelete.EntireRow.Delete

End With

Here's the AppleScript version:

tell application "Microsoft Excel"

     tell active sheet

          set lastRowNum to first row index of ¬

              (get end (cell 1 of row (count rows)) direction toward the top)

          set rDelete to missing value

          repeat with i from 1 to (count cells of range ("A2:A" & lastRowNum))

              --that's column A from 2nd cell to bottom used cell                                   

              set rCell to (cell i of range ("A2:A" & lastRowNum))

              if value of rCell = value of (get offset rCell row offset -1) then

                   if rDelete = missing value then

                        set rDelete to rCell

                   else

                        set rDelete to union range1 rDelete range2 rCell

                   end if

              end if

          end repeat

          if rDelete ≠ missing value then delete entire row of rDelete

     end tell

end tell

Once again we set a variable to the last row number to make things more manageable in the repeat statement. In AppleScript, a variable that is not defined is not equal to null (our rarely used version of Nothing), it instead causes an error if called. Normally we would just trap that error with a try/on error block, but in this case it would also put the union statement in the same try block and so perhaps catch a different error (leading to a never-ending loop that keeps setting rDelete to the first cell), or would require some very complex error management, plus would invert the order of things to come, making comparisons more difficult.

So it makes good sense to initialize rDelete to a value it couldn't possibly have otherwise. We could set it to anything we like that's not an Excel range, and common initializations would be to "" or 0. But we might as well use AppleScript's handy expression for something undefined but which does not error – missing value. (You'll be seeing that a lot if either you or Excel makes a mistake in scripting.) It's not exactly null, but it's just what we want here.

Checking back if necessary to Working with Columns and Rows, and bearing in mind that in just the same way you cannot get (every cell of someRange) nor set a variable to it, but you can count cells of someRange (!), we have to construct the repeat loop to avoid the repeat with rCell in (cells of someRange) syntax, and equally to avoid setting rCell to item i of (cells of someRange). [someRange in this case being range ("A2:A" & lastRowNum) throughout.]

Instead we must set it up so we refer to

     cell i of someRange

so that's what we do, and everything is fine. The VBA Offset Method is reproduced by get offset: we have to spell out the parameter names row offset and column offset of course, but the default for each is 0 so we can omit column offset.

The union command, which for some reason we find in the Microsoft Excel Suite instead of in the Table Suite where it ought to be since it acts only on ranges, uses parameters range1, range2, etc. I am happy to report that delete entire row works fine on a non-contiguous range.

However, there is yet one other way we could do this in AppleScript, not available to VBA, since delete can act all at once on a list of ranges:

tell application "Microsoft Excel"

     tell active sheet

          set lastRowNum to first row index of ¬

              (get end (cell 1 of row (count rows)) direction toward the top)

          set rDelete to {}

          repeat with i from 1 to (count cells of range ("A2:A" & lastRowNum))

              --that's column A from 2nd cell to bottom used cell                                   

              set rCell to (cell i of range ("A2:A" & lastRowNum))

              if value of rCell = value of (get offset rCell row offset -1) then

                   set end of rDelete to (entire row of rCell)

              end if

          end repeat

          if rDelete ≠ {} then delete rDelete

     end tell

end tell

Isn't that simple in comparison? We initialize rDelete to an empty list {}; if we find a duplicate cell we set the end of the list rDelete to the entire row of that cell without having to check every time to see if the list is empty or not, then at the end we delete the list and that's that. Accustomed as you are to VBA you may prefer to mirror it exactly as you start converting your macros, but in time as you get accustomed to AppleScript you will, and should, find more native and natural ways to do things in your new language.

Sorting a Range

The above example, deleting duplicate rows, assumed that the data was sorted first. (Otherwise there might still have been duplicates that were not in adjacent rows.) This can be accomplished in VBA by the Sort method, and in AppleScript by the identical sort command. If a single cell is specified, the current region will be sorted (the area around the cell bounded by both blank rows and columns. This snippet sorts the current region around cell A1 based first on the values in column A, then on the values in column B:

With ActiveSheet

   Range("A1").Sort _

      Order1:=xlAscending, _

      Key1:=.Columns("A"), _

         Order2:=xlAscending, _

      Key2:=.Columns("B"), _

      Header:=xlNo, _

      MatchCase:=False

End With

It's just the same in AppleScript, recalling that match case true will compile to with match case:

tell application "Microsoft Excel"

     tell active sheet

          sort range "A1" order1 sort ascending key1 column 1 ¬

              order2 sort ascending key2 column 2 header header no ¬

              without match case

     end tell

end tell

You cannot refer to column "A" in AppleScript: the script will error. Your choices are column 1, column "A:A" or range "A:A":

          sort range "A1" order1 sort ascending key1 range ¬

              "A:A" order2 sort ascending key2 range "B:B" header header no ¬

              without match case

Filtering a Range – Autofilter

Each worksheet contains an Autofilter object, and individual Autofilters are applied using the AutoFilter method. Each filter can have two criteria, and filters are cumulative. This example will cause the sheet to display only rows in which the value in column A is >=10 and <=100, and the value in column C is “OK”:

With ActiveSheet.Range("A1")

   .AutoFilter 'remove existing autofilter dropdowns

   .AutoFilter _

      Field:=1, _

      Criteria1:=">=10", _

      Operator:=xlAnd, _

      Criteria2:="<=100", _

      VisibleDropdown:=True

   .AutoFilter _

      Field:=3, _

      Criteria1:="OK", _

      VisibleDropdown:=True

End With

Note that the autofilter is applied to the CurrentRegion around Cell A1, since only one cell is specified.

In AppleScript:

tell application "Microsoft Excel"

     tell range "A1" of active sheet --single cell, applies to current region

          autofilter range -- with no parameters, toggles dropdowns

          autofilter range field 1 criteria1 ">=10" operator ¬

              autofilter and criteria2 "<=100" with visible drop down

          autofilter range field 3 criteria1 "OK" with visible drop down

     end tell

     
end tell

The only difficulty here is in finding the right "autofilter" term. You need to know your VBA well enough to know that the .AutoFilter in the macro is not the Property – which applies to a worksheet and returns the AutoFilter Object for the sheet – but the Method – which applies to a Range. So never mind the autofilter class nor autofilter object property of sheet in Microsoft Excel Suite. Look in the Table Suite, where the class being targeted – range – resides, and you'll find the autofilter range command (analogous to a Method). Everything else is identical.

Finding the last cell in a Range

One frequent need is to find the last used cell in a range, for instance to start a new record. One way is to use the End method:

Dim rNext As Range

With Sheets("Sheet1")

   If IsEmpty(.Range("A1").Value) Then

      Set rNext = .Range("A1")

   Else

      Set rNext = .Range("A" & .Range("A" & _

                .Rows.Count).End(xlUp).Row).Offset(1, 0)

   End If

End With

The welter of nested dots and parentheses gets very difficult to keep straight translating to AppleScript. If you persist, you will find that this is the direct AppleScript translation:

tell application "Microsoft Excel"

     tell sheet "Sheet1" of active workbook

          if value of range "A1" = "" then

              set rNext to range "A1"

          else

              set rNext to get offset of range ("A" & ¬

                   (first row index of (get end range ("A" & (count rows)) ¬

                        direction toward the top))) row offset 1

          end if

     end tell

end tell

Personally, I would prefer disentangling all that with just a few "ofs" at a time, using intermediate variables along the way, at least until I become very familiar with constructions I run into regularly; something like this:

              set lastRowCellA to (get end range ¬

                   ("A" & (count rows)) direction toward the top)

              set lastRowNum to (first row index of lastRowCellA)

              set lastRowCellAA to range ("A" & lastRowNum)

              set rNext to get offset of lastRowCellAA row offset 1

In fact, you can see that by doing this clarifying extraction that there are some redundant and "circular" steps. Once you have lastRowCellA in the first line, you can do the get offset straight away without needing to get the row index and put that back in to the address.

              set lastRowCellA to (get end range ¬

              
                   ("A" & (count rows)) direction toward the top)

              set rNext to get offset of lastRowCellA row offset 1

does exactly the same thing. That's almost simple enough to take the variables out again! But breaking up the code and using self-commenting variable names, if it starts to get too complicated, is usually a good idea: it will help you see things more clearly. (The VBA code was in fact originally written to grab a larger range, not a single cell. In that case the extra steps would be necessary.)

Just remember never to set a variable to a (named) column, row or cell, just to a range. It can be as simple as replacing the word "column" by "range", using the A1 style address.

AutoFilling A Series

You can create a series of numbers or dates using the autofill property:

With Worksheets("Sheet1").Range("A1")

   .Value = 1

   .AutoFill Destination:=.Resize(20, 1), Type:=xlFillSeries

End With

This is straightforward. You can omit the column size parameter since there's no change:

tell application "Microsoft Excel"

     tell range "A1" of worksheet "Sheet1"

          set value to 1

          autofill destination (get resize row size 20) type fill series

     end tell

end tell

Using Validation

Validation restricts user entries into a cell using the Validation object. For instance, an entry could be limited to positive integers:

With ActiveSheet.Range("A2").Validation

   .Delete 'remove current validation object

   .Add _

          Type:=xlValidateWholeNumber, _

          AlertStyle:=xlValidAlertStop, _

          Operator:=xlGreater, _

          Formula1:="0"

   .IgnoreBlank = True

   .InputTitle = ""

   .ErrorTitle = "Invalid Entry!"

   .InputMessage = "Enter an integer > 0"

   .ErrorMessage = "The entry MUST be a positive integer."

   .ShowInput = True

   .ShowError = True

End With

In AppleScript, you cannot delete a property, only an element. The structure of range is such that validation is a read-only property. You can modify it instead, if need be, with the modify command that uses all the same parameters as add data validation uses. Aside from that qualification, the script is just the same as the macro:

tell application "Microsoft Excel"

     tell validation of range "A2" of active sheet

          --can't delete , modify if need be

          add data validation type validate whole number ¬

              alert style valid alert stop ¬

              operator operator greater ¬

              formula1 "0"

          set ignore blank to true

                 set input title to ""

          set error title to "Invalid Entry!"

          set input message to "Enter an integer > 0"

          set error message to "The entry MUST be a positive integer."

          set show input to true

          set show error to true

     end tell

end tell

Formatting Cells

Formatting cells via code can be done via code in a very straightforward way.

NumberFormat

John McGimpsey tells us:

"The NumberFormat property sets the cell‘s number format similarly to the GUI by assigning a string with a valid format. (Check About custom number formats in the Excel Help.) Number formats have four parts, separated by semicolons. By default, the first is applied to positive numbers, the second to negative numbers, the third to zero, and the fourth to text. To assign a text format use the string "@":

   ActiveSheet.Range("A1").NumberFormat = "+0;-0;0;@"

becomes in AppleScript:

set number format of range "A1" of active sheet to "+0;-0;0;@"

"You can also modify the application of the sections, and assign one of the eight custom font colors. For instance, this format sets numbers less than negative 100 to red within parentheses, values between -100 and +100 (inclusive) to green, and values greater than 100 to red. The non-parenthesis formats have a space the width of a parenthesis added to the right side to make sure the numbers align: "

   ActiveSheet.Range("A1:A100").NumberFormat = _

   "[Red][<-100](0);[Green][<=100]0_);[Red]0_);@_)"

becomes in AppleScript:

set number format of range "A1:A100" of active sheet to ¬

     "[Red][<-100](0);[Green][<=100]0_);[Red]0_);@_)"

Alignment, Wrap Text

Alignment (namely left, center, right for horizontal alignment) is set using the horizontal alignment and vertical alignment properties in AppleScript. Whether to wrap text is set using the wrap text property. So:

With ActiveSheet.Range("A1:J10")

   .HorizontalAlignment = xlCenter

   .VerticalAlignment = xlCenter

   .WrapText = True

End with

becomes in AppleScript:

tell application "Microsoft Excel"

     tell range "A1:J10" of active sheet

          set horizontal alignment to horizontal align center

          set vertical alignment to vertical alignment center

          set wrap text to true

     end tell

end tell

Note that the enumeration for the horizontal and vertical alignment parameters differ, for no good reason: horizontal align center and vertical alignment center.

Font Format

Font formats are set using the cell‘s Font object. You can apply multiple properties at once:

   With ActiveSheet.Range("A1").Font

      .Name = "Verdana"

      .FontStyle = "Bold"

      .Size = 12

      .Strikethrough = False

      .Superscript = False

      .Subscript = False

      .OutlineFont = False

      .Shadow = False

      .Underline = xlUnderlineStyleDouble

      .ColorIndex = xlAutomatic

   End With

In AppleScript:

tell application "Microsoft Excel"

     tell font object of range "A1" of active sheet

          set {name, font style, font size, strikethrough, superscript, subscript, ¬

              outline font, shadow, underline, font color index} to {"Verdana", "Bold", ¬

              12, false, false, false, false, false, underline style double, color index automatic}

     end tell

end tell

This time I chose to set all properties at once in a list. It is easier, of course, to keep track of which property is set to which value if you do each on a separate line.

The color index property refers to the 56 colors available in the color palette. That's the same 56 colors as in the palette available in Format/Cells…/Font/Color, rather than the Formatting Palette and Toolbar's reduced palette of 40 colors. But the colors are in a completely different order – the "default palette" used by VBA and AppleScript must date back quite a few years. The correct palette layout, with identifying index numbers, is in the Excel AppleScript Reference under Text Suite/Classes/Font.

In addition to the eight custom colors that you can set using the number format property, you can use the font color index property to set the font color:

      ActiveSheet.Range("A1").Font.ColorIndex = 3   'Default palette red

In AppleScript:

     set font color index of font object of range "A1" of active sheet to 3

Take a good look at the color index enumeration for the font color index property of font class (Text Suite). It gives three so-called constants as available: color index automatic (that's generally black), color index none, and something called 'a color index integer' which will compile and run without error, but turns any existing color black, so it must be defaulting to automatic.

This is "covering" for what ought really to be another 56 constants – namely the numbers 1 through 56. In VBA, if you check the Object Browser you'll see only xlAutomatic and xlNone listed, which have (as all xl and vb constants do) their own numeric version (large negative numbers). But numbers 1-56 have also been reserved. Only the VBA Help tells you that. In AppleScript, some sort of reference to the numbers needed to be given but that "a color index integer" entry is just a dummy, or bogus, constant. It's a description masquerading as a constant. I suggest a reason for this at the end of this Excel chapter. An actual short description, if not "1-56" ought to be listed instead. But the Excel AppleScript Reference, to its credit, does give a full explanation.

You can set a "Microsoft" RGB value for the color, but Excel will choose the “closest” color available in the palette. It's really quite inadequate, but at least gets pure red, green and blue all right:

      ActiveSheet.Range("A1").Font.Color = RGB(255, 0, 0)

becomes:

     set color of font object of range "A1" of active sheet to {255, 0, 0}

See the PowerPoint chapter for a full discussion of Microsoft's RGB vs. AppleScript RGB.

The Color Palette

In VBA, to change a color on the color palette (which applies only to the workbook)

ActiveWorkbook.Colors(33) = RGB(6, 8, 242)

ActiveSheet.Range("A1").Font.ColorIndex = 33 'Assign the new color

Once you set the color of a particular spot on the palette (33) to the best of your ability to the RGB color of your choice {6 ,8, 242}, you can now set the color of any text or fill to that color by accessing its no. 33 color index. This tends to work better than trying to set the color of any font or other object.

But it is not possible to do in AppleScript unfortunately: this is a gap, or bug, in the Model. When you see the Colors property, you know you have to find another way, or an approximation. There is no equivalent of the Colors Collection Object, and colors cannot be elements because you can't make or delete any colors: the number of colors is fixed at 56. It should probably have been implemented as some sort of color palette property for workbook.

What you can do is call the command reset colors, which restores the color palette to the defaults. And you can try setting the color property by (RGB) color, but most likely that just chooses one the 56 colors, so you might as well do it by color index so that at least you know which color you'll be getting reliably. Call reset colors first if you want to be sure of it.

It is also possible to blend colors on occasion. See the next for an example of blending two colors in anything that has a pattern or gradient, like a cell's interior, and a chart's and drawing object's fill gradient colors.

Background Format

Background colors and patterns are set using the cell‘s interior object, much as the font format:

With ActiveSheet.Range("A1").Interior

   .ColorIndex = 3

   .Pattern = xlGray50

   .PatternColorIndex = 13

End With

In AppleScript:

tell application "Microsoft Excel"

    tell interior object of range "A1" of active sheet

         set color index to 3

         set pattern to pattern gray 50

         set pattern color index to 13

    end tell

end tell

This allows you to superimpose a fine-grained pattern (if you wish) with its own color over the basic interior color, to get a very wide variety of blended colors.

Borders

Well, we were going to get here at some point. And now we're here. There's some bad news – not very bad news: you can get every border in AppleScript, I can assure you. But it's more tedious work than in VBA if you need to get all of them at once.

In VBA, borders are integral part of the Object Model, and are set using the cell‘s Borders Collection and Border objects. You can set all the (outside) borders at once using the collection properties:

With ActiveSheet.Range("D10").Borders

   .LineStyle = xlDouble

   .ColorIndex = 3

End With

Or you can set borders individually, which we'll come to later – that is much more analogous in AppleScript.

Unfortunately, borders could not be implemented as elements of range or other objects – which they certainly should be in the sense that they have a many-to-one relationship with the object they're bordering. But they cannot be elements because they are sort of read-only in that you cannot make new borders or delete existing ones. You can change their properties, so they are "writable" in that sense. But for anything defined as an element you ought to be able to 'make new border at range' and you clearly can't do that, nor delete any. Borders are just there.

They also can't be a single 'borders' property with enumerated constants for the different types: they need to be fully-fledged objects whose properties we can modify: Collection Object types, not to put too fine a point on it. And AppleScript does not have those.

(Mind you, that doesn't stop Entourage from having read-only recipients as elements of incoming message class – in fact you can't even make a new recipient at an outgoing message once the message has been created. And since elements can only be made at existing objects, that creates something of a problem, which Entourage gets around by a clever technique that doesn't quite "follow the rules" either – you can read about it in the Entourage Chapter 6.)

There's definitely something missing in the AppleScript syntax that doesn't know how to fit built-in read-only elements into its model. Excel, along with Word, has its fair share of these objects. These are dealt with quite handily in VBA as Collection Objects, but become, quite literally orphans, with no parent aside from a remote progenitor base object, in AppleScript.

If you read the Word chapter, you will recall the same issue with headers and footers there. We have to do the same thing here with borders – only there are more than 6 borders. There are 12. We have to use the command get border and specify which border, 12 times over, to retrieve each of the 12 borders separately. (Word has borders too, with the same issue.)

Here is how you have to do it, if you want to set the line style and color index of all borders of a cell or range, as in the VBA snippet above:

tell application "Microsoft Excel"

     tell range "D10" of active sheet

          set allBorders to {} -- initialize a list

          set end of allBorders to get border which border border bottom

          set end of allBorders to get border which border border left

          set end of allBorders to get border which border border right

          set end of allBorders to get border which border border top

          set end of allBorders to get border which border diagonal down

          set end of allBorders to get border which border diagonal up

          set end of allBorders to get border which border edge bottom

          set end of allBorders to get border which border edge left

          set end of allBorders to get border which border edge right

          set end of allBorders to get border which border edge top

          set end of allBorders to get border which border inside horizontal

          set end of allBorders to get border which border inside vertical

     end tell

     repeat with thisBorder in allBorders

               try

              set line style of thisBorder to double

          end try

          try

              set color index of thisBorder to 3

          end try

     end repeat

end tell

In this case, we set the end of a list to each new border, which is a more efficient way of building a list than concatenating the lists as we did with the Word headers and footers. It makes no discernable difference when you've just got just one or a few items to process, but if you had to repeat this whole procedure hundreds of times over, it could make a significant difference to the speed of the script.

Unfortunately, again, we can't set the line style (nor any other property) of the whole list at once, in this case. The script errors (even if you can exclude any nonexistent borders). So we have to run a repeat loop on each member of the list, using try/end try for each border. In the case of a standard default worksheet cell, both commands error on the last two borders (inside horizontal and inside vertical) which may mean that they don't really exist, although some object is returned from the get border command each time.

Since we can't run a command (set line style, etc.) on the whole list at once, there isn't much advantage in having the list. We could instead set the line style and color index for each border as we make it, sending each border out to a handler to be processed, like this:

tell application "Microsoft Excel"

     tell range "D10" of active sheet

          set thisBorder to get border which border border bottom

          my ModifyBorder(thisBorder)

          set thisBorder to get border which border border left

          my ModifyBorder(thisBorder)

          set thisBorder to get border which border border right

          my ModifyBorder(thisBorder)

          set thisBorder to get border which border border top

          my ModifyBorder(thisBorder)

          set thisBorder to get border which border diagonal down

          my ModifyBorder(thisBorder)

          set thisBorder to get border which border diagonal up

          my ModifyBorder(thisBorder)

          set thisBorder to get border which border edge bottom

          my ModifyBorder(thisBorder)

                    set thisBorder to get border which border edge left

          my ModifyBorder(thisBorder)

          set thisBorder to get border which border edge right

          my ModifyBorder(thisBorder)

          set thisBorder to get border which border edge top

          my ModifyBorder(thisBorder)

          set thisBorder to get border which border inside horizontal

          my ModifyBorder(thisBorder)

          set thisBorder to get border which border inside vertical

          my ModifyBorder(thisBorder)

     end tell

end tell

 

on ModifyBorder(thisBorder)

     tell application "Microsoft Excel"

          try

              set line style of thisBorder to double

          end try

          try

              set color index of thisBorder to 3

          end try

     end tell

     return

end ModifyBorder

This is actually more efficient. Either method works well. You need change only the commands, in the ModifyBorder handler or in the repeat loop of the first method, to apply different effects to all your borders.

Most of the time you will be setting properties of just one, or a few, borders. Here is what the VBA version might look like:

With ActiveSheet.Range("D10")

   .Borders.LineStyle = xlNone ' Remove existing borders

   With .Borders(xlEdgeLeft)

      .LineStyle = xlContinuous

      .Weight = xlThin

      .ColorIndex = 3

   End With

   With .Borders(xlEdgeRight)

      .LineStyle = xlContinuous

      
      .Weight = xlThick

      .ColorIndex = 3

   End With

End With

To remove all existing borders, run either sequence above, but change the commands in the repeat loop or ModifyBorder handler to just

      set line style of thisBorder to line style none

Then follow with

tell application "Microsoft Excel"

     tell range "D10" of active sheet

      set thisBorder to get border which border edge left

          tell thisBorder

              set line style to continuous

              set weight to border weight thick

              set color index to 3

          end tell

          set thisBorder to get border which border edge right

          tell thisBorder

              set line style to continuous

              set weight to border weight thick

              set color index to 3

          end tell

     end tell

end tell

Since you are making the same three settings to each of the two edge borders, again it would be better practice to use a handler to customize the operation:

tell application "Microsoft Excel"

     tell range "D10" of active sheet

          set thisBorder to get border which border edge left

          my Customize(thisBorder)

          set thisBorder to get border which border edge right

          my Customize(thisBorder)

     end tell

end tell

 

on Customize(thisBorder)

     tell application "Microsoft Excel"

          tell thisBorder

              set line style to continuous

              set weight to border weight thick

              set color index to 3

          end tell

     end tell

end Customize

You will note that it is possible to send an application object out to an external handler as a parameter even though that takes it outside the Excel application block. The handler can still accept the item (which it will know as border id border edge left of cell "D10" of active sheet of application "Microsoft Excel") to pass back into the application tell block within the handler when called.

Conditional Formatting

Conditional formatting is applied using the format condition object in the Excel Suite. You will note that it is an element of range class, which may have none, or several of them. (It seems to be limited here to three per range.) Each conditional format may have at most three conditions, and the formats that can be set are for font, interior (background) and border. For instance, in VBA, this will apply a bold green font to values between 0 and 10:

With ActiveSheet.Range("B1").FormatConditions

   .Delete 'Delete existing conditional formats

   With .Add(Type:=xlCellValue, _

             Operator:=xlBetween, _

             Formula1:="0", _

             Formula2:="10").Font

      .Bold = True

      .Italic = False

      .ColorIndex = 4

   End With

End With

Here is the AppleScript version, which works delightfully once you get the syntax right. It is quite interesting to study:

tell application "Microsoft Excel"

     tell range "B1" of active sheet

          try

              delete (every format condition)

          end try

          set newFormatCondition to make new format condition at end ¬

              with properties {format condition type:cell value, condition operator:¬

                   operator between, formula1:"0", formula2:"10"}

          tell font object of newFormatCondition

              set {bold, italic, font color index} to {true, false, 4}

          end tell

     end tell

end tell

Format conditions are elements, not properties, of range, so you can delete any existing ones before making new ones, a good idea when you are making your first format condition for a range in a workbook that may have passed through other hands or has been around. (If you go on to make another format condition at the same range for different conditions, obviously omit the delete command if you want to keep the ones you've just made.) Put the delete command in a try block because it will error if there are no existing format conditions.

Now you will see from the dictionary that every property of format condition is listed as read-only, so how can we set anything? It so happens that there are many classes, at least in other applications, with properties listed in the dictionary as read-only but which can be set at inception, when using make new with properties {…} only, and never afterwards. It is quite common to find these in other applications.

There do not seem to be many such classes in Excel or Word or PowerPoint. However, many "more standard" scriptable applications, such as Entourage, are full of such classes. It is always worth checking and testing for these.

The properties here that can be set at inception are the enumerations and text properties: format condition type, condition operator, formula1 and formula2, i.e., the conditions. But if you try to include settings for the font object or interior object within the properties for make new format condition, they will be ignored as always. Instead, although you can't "set" a font object itself, you can set its own properties (bold, italic, name, font color index, etc.) after the format condition element in which the font object resides is made. This is quite normal for the Office applications: it is true for all the complex objects such as fonts that other objects can have as their properties.

What is unusual, and pleasing, is that the "simple" read-only properties which are not objects and don't have properties of their own that can be set afterwards, can be set at inception, as they should be. This has been implemented properly, and makes these format condition objects useful and very scriptable. The Excel developers are to be commended.

One other thing to note is that these are elements that must be made at beginning or at end of the range – it doesn't matter which (except perhaps to primacy if you overlap two conflicting conditions). You may also have noticed that the dictionary lists "formula 1" and "formula 2" as the parameter names but they compile to "formula1" and "formula2" without spaces, just as we saw them in add data validation. That means they've been implemented as synonyms: you can type either, which is nice, and both versions compile.

You can apply more complex formats based on formula conditions by declaring the Type to be expression (xlExpression in VBA), meaning a formula.

With ActiveSheet.Range("B1").FormatConditions

   .Delete

   With .Add(Type:=xlExpression, _

             Formula1:="=AND($A1>0,$A1<10)")

      With .Font

          .Bold = True

          .Italic = False

          .ColorIndex = 2

      End With

      .Interior.ColorIndex = 3

   End With

End With

tell application "Microsoft Excel"

     tell range "B1" of active sheet

          try

              delete (every format condition)

          end try

          set newFormatCondition to make new format condition at end ¬

              with properties {format condition type:expression, formula1:¬

              "=AND($A1>0,$A1<10)"}

          tell newFormatCondition

              tell its font object

                   set {bold, italic, font color index} to {true, false, 2}

              end tell

              set color index of its interior object to 3

          end tell

              end tell

end tell

This turns the background red and font bold white in B2, when there's a number from 1 to 9 in A1. It works perfectly in AppleScript.

Format conditions can also format borders, as well as fonts and interiors. In VBA, the Borders Collection is a property of the FormatCondition Object and work the same way as fonts and interiors do. In AppleScript you have to use the same get border command as we used in the previous subsection, here targeted at the format condition element, as found in the Microsoft Excel Suite. (It's listed as a different get border command in a different suite, so as to be able to specify the type of object it works on – format condition rather than range. But actually it's the same old get border command and works identically to the one we used with range.) It returns a border of the type you specify with the which border parameter, and you then apply the formatting to each border you retrieve.

Working with Charts

Charts, partly because they‘re so flexible, are complicated objects. chart object objects exist either as chart sheets or as embedded chart objects on a worksheet. The chart object has a chart property, which is a chart (class) that has an enormous number of properties. (I know – that's a ridiculous-sounding sentence, but really and truly that's how the various chart-related classes are organized and named.)

The following example embeds an XY Scatter chart on the active worksheet. It assumes that the data is in columns, with the first row being a header. It will automatically determine the number of series from the number of headers, and will determine the number of data points from the number of X-values in column A.

At the end of this section I have included a table of numbers making up the data John McGimpsey provided for this example. If you are reading this online, you might be able to copy and paste them into an Excel worksheet and try the script. The precise numbers don't matter much: you can see that columns A, B, C were just filled from 1 to 40 (in rows 2 to 41). Column D uses a formula: =MAX(A:A)/2+(1+SIN(A2)*2*PI()), also filled from row 2 down to 41. Column E is a random distribution of the same numbers 1-40 (making Y4's graph plot quite exciting as the numbers flip all over the place).

This is a much longer macro and script than any others in the chapter. Everything in it is quite straightforward, and no more difficult than anything else in the chapter – some of it easier. Due to its length, I will not walk through every line of it, but just point out a few issues, problems, and workarounds where there are any, after the script version.

Public Sub CreateEmbeddedChart()

   Dim oChartObj As ChartObject

   Dim rHeaders As Range

   Dim rData As Range

   Dim i As Long

  

   ' Dynamically grab the data in columns

   With ActiveSheet

      'Find the headers in the first row

      Set rHeaders = .Range("A1").Resize(1, _

          .Cells(1, .Columns.Count).End(xlToLeft).Column)

      'Now find the number of data rows.

      Set rData = .Range("A2:A" & .Range("A" & _

             .Rows.Count).End(xlUp).Row).Resize(, rHeaders.Count)

      If rHeaders.Columns.Count = 1 Or _

             rData.Rows.Count = 1 Then Exit Sub 'no data

     

      'Create chart object

      Set oChartObj = .ChartObjects.Add( _

                   Left:=400, _

                   Top:=100, _

                   Width:=500, _

                   Height:=400)

 

      'Now build the Chart within the ChartObject

      With oChartObj.Chart

          .ChartType = xlXYScatterSmooth   'define chart type

 

          'Add each series

          For i = 2 To rHeaders.Count

             With .SeriesCollection.NewSeries

                .Values = rData.Columns(i)

                .XValues = rData.Columns(1)

                .Name = rHeaders.Cells(i)


             End With

          Next i

                  

          'Add Titles and Format Chart and Axes

          .HasTitle = True

          With .ChartTitle

             .Caption = "My XY Scatter Chart"

             .HorizontalAlignment = xlHAlignCenter

             With .Font

                .Name = "Verdana"

                .Size = 12

                .Bold = True

             End With

          End With

          With .Axes(xlCategory, xlPrimary)

             .HasTitle = True

             With .AxisTitle

                .Caption = "X Values"

                With .Font

                   .Name = "Arial"

                   .Size = 10

                   .Bold = True

                End With

             End With

          End With

          With .Axes(xlValue, xlPrimary)

             .HasTitle = True

             With .AxisTitle

                .Caption = "Y Values"

                With .Font

                   .Name = "Arial"

                   .Size = 10

                   .Bold = True

                End With

             End With

          End With

         

          'Format Plot area

          With .PlotArea

             With .Border

                .Color = vbBlue

                .LineWeight = 1

                .LineStyle = xlContinuous

                .Transparency = 0

             End With

             With .Fill

                .Visible = True

                .ForeColor.RGB = RGB(150, 200, 255)

                .Transparency = 0.5

             End With

          End With
               

          'Format Legend

          .HasLegend = True

          With .Legend

             .Position = xlRight

             With .Border

                .Color = vbBlue

                .LineWeight = 1

                .LineStyle = xlContinuous

                .Transparency = 0

             End With

             With .Fill

                .Visible = True

                .ForeColor.RGB = RGB(150, 200, 255)

                .Transparency = 0.5

             End With

             With .Font

             .Name = "Arial"

             .Size = 10

             .ColorIndex = 5

             End With

          End With

      End With

   End With

End Sub

And here is the AppleScript of the same (make it on another sheet if you try both).

tell application "Microsoft Excel"

     --dynamically grab the data in columns

     tell active sheet

          --Find the headers in the first row:resize range A1 to last used cell of row 1

          set rHeaders to get resize range "A1" column size ¬

              (first column index of (get end (cell (count columns) of row 1) ¬

                   direction toward the left))

          --Now find the number of data rows

          --and set rData to whole range from row 2

          set rData to get resize range ("A2:A" & first row index of (get end ¬

              range ("A" & (count rows)) direction toward the top)) ¬

              column size (count (columns of rHeaders))

          if (count (columns of rHeaders)) = 1 or (count (rows of rData)) = 1 then ¬

              return -- no data, so quit
              
         

          --Create chart object

          set oChartObj to make new chart object at end with properties ¬

              {left position:400, top:100, width:500, height:400}

         

          --Now build the Chart within the ChartObject

          tell chart of oChartObj

              set chart type to xy scatter smooth -- define chart type

             

              -- add each series

              repeat with i from 2 to (count (columns of rHeaders))

                   set newSeries to make new series at end with properties ¬

                        {series values:(column i of rData), xvalues:¬

                            (column 1 of rData), name:(value of cell i of rHeaders)}

                   --  need to specify _value_ (no default property)                                  

              end repeat

             

              --'Add Titles and Format Chart and Axes

              set has title to true

              tell its chart title -- needs 'its !!

                   set caption to "My XY Scatter Chart"

                   tell font object

                        set name to "Verdana"

                        set font size to 12

                        set bold to true

                   end tell

              end tell

             

              set categoryAxis to get axis axis type category axis ¬

                   which axis primary axis

              tell categoryAxis


                   set has title to true

                   tell its axis title -- needs 'its' !!

                        set caption to "X Values"

                        tell font object

                            set name to "Arial"

                            set font size to 10

                            set bold to true

                        end tell

                   end tell

              end tell

             

              set valueAxis to get axis axis type value axis ¬

                   which axis primary axis

              tell valueAxis

                   set has title to true

                   tell its axis title -- needs 'its' !!

                        set caption to "Y Values"

                        tell font object

                            set name to "Arial"

                            set font size to 10

                            set bold to true

                        end tell

                   end tell

              end tell

             

              --'Format Plot area

              tell plot area object

                   tell its border -- needs its

                        set color to {0, 0, 255} -- will this work?, if not:

                        --set its color index to 5

                        set line weight to 1

                        set its line style to continuous

                        -- no transparency property in AppleScript

                        --set transparency to 0


                   end tell

                   tell its chart fill format object

                        set visible to true

                        --set fore color to {150, 200, 255} --can't set color

                        --set transparency to 0.5

                        set foreground scheme color to 23

                        set transparency to 0.8 -- the same color

                   end tell

              end tell

             

              --format legend

              set has legend to true

              tell legend object

                   set its position to legend position right

                   tell its border -- needs its

                        set color to {0, 0, 255} -- will this work?, if not:

                        --set its color index to 5

                        set line weight to 1

                        set its line style to continuous

                        -- no transparency property in AppleScript

                        --set transparency to 0

                   end tell

                   tell its chart fill format object

                        set visible to true

                        --set fore color to {150, 200, 255} -- can't

                        --set transparency to 0.5

                        set foreground scheme color to 23

                        set transparency to 0.8 -- the same color

                   end tell

                   tell its font object

                        set name to "Arial"

                        set font size to 10

                        set its font color index to 5


                   end tell

              end tell

          end tell

     end tell

end tell

There are two things the script cannot do that the VBA macro can. There is no transparency property of border in AppleScript, so you can't set it. As it happens, the macro sets the transparency to 0, i.e., opaque, which is the default anyway, so you won't see any difference.

The fore color property of the chart fill format class, which is the class of the chart fill format object property of both the plot area and the legend of the chart (i.e., the fill color for the cart and the legend box to the right of it), is read-only in AppleScript. You cannot set it directly: and for once there is no alternate color index property that can be set instead either.

However there is a workaround: you can set the foreground color scheme index. There is no table of indexed colors for these things (and I can't find any relation between the color scheme dropdown in the UI's Formatting Palette to the numbers I tested, although there may be one.) By trial and error, I discovered that foreground color scheme 23 is the same color, and setting its transparency to 0.8 instead of 0.5 matches the color and shade made by the macro – RGB(150, 200, 255) – exactly.

I don't know how many of these scheme indices there are – I made it to 100 without erroring, so you will, with some effort, be able to find a match for any color Excel has. And then there are 17 other color schemes that can be set for the chart group property of the chart, so there's no end of colors if you have the time to track down one you want.

You have to omit the line trying to set the fore color, although it compiles, because otherwise the script will error. I have commented it out both times, and substituted setting the foreground color scheme instead. It would be nice if a later version of Excel fixed fore color and back color, although it is not a major issue. The problem derives from the fact that the Excel AppleScript developers made this fore color property a simple color type (an {r, g, b} list of three integers – see the PowerPoint chapter for details). In VBA, it is a complex ColorFormat Object that needs a further RGB Property to set the color.

Some other matters: there are two places in the script that will error if you follow the macro syntax exactly: that's the

          Set rData = .Range("A2:A" & .Range("A" & _

             .Rows.Count).End(xlUp).Row).Resize(, rHeaders.Count)

line right near the beginning, and the last line of the

            With .SeriesCollection.NewSeries

                .Values = rData.Columns(i)

                .XValues = rData.Columns(1)

                .Name = rHeaders.Cells(i)

             End With

block adding the series a few lines below it. If you translate those directly as:

             set rData to get resize range ("A2:A" & first row index of (get end ¬

              range ("A" & (count rows)) direction toward the top)) ¬

              column size (count rHeaders)

and

                   set newSeries to make new series at end with properties ¬

                        {series values:(column i of rData), xvalues:¬

                            (column 1 of rData), name:(cell i of rHeaders)}

you will get a fatal error in the first case, and you won't get the names of the series (Y1, Y2, Y3, Y4) in the Legend box in the second case. (It will show the default names "Series1, Series2, Series3, Series4" instead).

This is because in VBA there are Default Properties of many Objects, which do not have to be spelled out in code. The default property of a row, or of any range, is the Cells property. Since rHeaders is a range that's actually a one-dimensional row, to Count the range is to count the cells, as if written as rHeaders.Cells.Count.

But in AppleScript, counting a range makes no sense: AppleScript does not have "default properties". (Well. I know of just one, in Entourage, but it was very specially implemented. I've never seen it anywhere else.) So the script errors. You need to change it to (count cells of rHeader), or (count columns of rHeader), as I did in the script.

In the case of making the new series, you lose the names in the legend; that's because the default property of a Cell must be its Value property. So setting .Name = rHeaders.Cells(i), where Name is of String type, evidently sets the name of the series to the string Value of Cell(i).

But, once again, in AppleScript, where there is no default property for cell, trying to set a name to a cell (a range) instead of to a string or Unicode text, just doesn't work. It doesn't cause an error (although might if you asked for the name afterwards), but it doesn't do anything. It leaves the names at their defaults of "Series1…" etc. Just set the name of the newSeries to value of cell i of rHeaders, and all is well.

Alert: It is absolutely necessary when making a new chart object at the worksheet and making new series at the chart, that you specify at end (or at beginning) in both cases. (If not in targeted tell blocks that would be at end of active sheet, and at end of oChartObj respectively.) I was pleased to discover that I could set properties of both these elements at inception in the make new chart object with properties and make new series with properties statements, and not have to wait until the objects were made.

One last caution is that, along the way, I noticed a great many properties of many different objects that had the same term for their 'type' (i.e., class) as for the property itself. For example, chart title, axis title, line style properties all refer to classes of the same name. That may seem convenient and less cumbersome than the font object property whose type is class font, the legend object property whose type is class legend, and so on. However, these constructions are actually saving you, the scripter, the possibility of pain and confusion.

When the name of the property is the same as the name of a class, as you will recall from Chapter 2, AppleScript can get confused under two conditions: in whose clauses (always) and, sometimes also when using tell blocks to the parent object of the property rather than using of constructions. VBA scripters writing AppleScript love to use nested tell blocks to mirror VBA With blocks, as I did throughout this script. That means you have to be on guard, and use its before the property. It never hurts to use its, so I added a few extra as well, and you could do worse than to always use it in tell blocks to the parent object.

There is much, much more to learn about charts, but that will have to do for this article. When you hit snags, be creative in trying to think of possible workarounds, and analytic to see if you were trying to take a shortcut through the syntax and lost your way.

Printing

Printing is done with the print out command. Normally this is applied to a sheet:

      ActiveSheet.PrintOut

     print out active sheet

Make sure not to leave it at plain print. That will print, in a manner of speaking, because it's the obligatory print command in the Standard Suite. But what it does is bring up the standard Print dialog in the UI and wait for you to click OK. It also misses the possibility of using all the optional parameters for print out that give you a lot of control.

For example, you can specify number of copies and the page ranges. Leaving out the to parameter prints the remainder of the pages to the end, just like in the UI:

      ActiveSheet.PrintOut From:=2, To:=2, Copies:=4

     print out active sheet from 2 to 2 copies 4

If your sheets are grouped, you can print them all by applying print out to the workbook or active window. (In VBA, those are specified as separate Methods.)

      ActiveWorkbook.PrintOut

     print out active workbook

By default, if the header or footer has page numbers, this will cause the page numbers to print continuously from sheet to sheet (that can be changed in preferences):

[An aside: There's another error in the AppleScript dictionary where sheet/window/workbook are listed as constants of a so-called printout options enumeration, for the direct parameter. But this is absurd: you don't print out a sheet constant, you print out an actual sheet object: it's the type (class) sheet that should be listed there, along with type window and type workbook, not an enumeration. We've seen this before. They are just trying to let you know which classes it can be applied to, as if it were a description.

I think the problem is that AppleScript dictionaries may not permit (or did not used to, anyway, before the new sdef dictionaries) multiple classes to be listed. That's why, in older dictionaries, you will often see the type marked as reference, meaning "some application object", or even as anything if one of the allowable types is a basic AppleScript type such as string or number. (It usually does not actually mean "anything at all" but simply has to cover several classes, so "anything" is used as a catch-all type that permits objects of appropriate classes to be direct objects of the command without erroring.) The more usual type seen is reference. Again, it does not mean "any application object whatsoever" but just "multiple types of [unspecified] application classes".

In some cases in the Excel and Word dictionaries, they have listed what looks like several different copies of the same command, e.g., get border, in several different suites. That permits them to list one class per suite as the direct parameter, which I think must be the reason for the multiple listings. But they're cross-referenced, and it works. In other cases, I can see why they might not have wanted to list reference as the type, but that's better than a bogus enumeration. All they would need to do is to state in the description which classes actually can take the command. In the old dictionaries there was not room for longer descriptions, but in the new sdef dictionaries it can be done.]

One thing you cannot do in Office 2004, unfortunately, is print to PDF by script. It certainly was never in the rather ancient VBA model dating back to Office 97/98 and OS 8. It also did not make it into Office 2004 AppleScript. The print to file parameter for print out looks as if it's meant to do just that, but it doesn't work: it prints to paper.

From all the many requests for this feature, I think there's a good chance that it might be implemented in Office 2008 – time will tell.

Page Setup

While Page Setup in VBA is very inefficient, since each parameter requires a separate call to the Print Driver, you can set any parameters that can be set in the GUI dialog:

With ActiveWorkbook.Sheets("Sheet1").PageSetup

   .PrintTitleRows = "$1:$2"

   ActiveSheet.PageSetup.PrintArea = ""  'determine at print time

   .LeftHeader = ""

   .CenterHeader = "My Report"

   .RightHeader = ""

   .LeftFooter = "Page &P of &N"

   .CenterFooter = ""

   .RightFooter = "&Z&F"

   .LeftMargin = Application.InchesToPoints(1)

   .RightMargin = Application.InchesToPoints(1)

   .TopMargin = Application.InchesToPoints(1.5)

   .BottomMargin = Application.InchesToPoints(1.5)

   .HeaderMargin = Application.InchesToPoints(0.5)

   .FooterMargin = Application.InchesToPoints(0.5)

   .PrintHeadings = False

   .PrintGridlines = False

   .PrintComments = xlPrintNoComments

   .PrintQuality = -4

   .CenterHorizontally = False

   .CenterVertically = False

   .Orientation = xlLandscape

   .Draft = False

   .FirstPageNumber = xlAutomatic

   .Order = xlDownThenOver

   .BlackAndWhite = False

   .Zoom = 100

End With

To fit pages to a certain height or width, you must set the Zoom property to False:

With ActiveWorkbook.Sheets("Sheet1").PageSetup

   .Zoom = False

   .FitToPagesWide = 1

   .FitToPagesTall = 2

End With

That goes very straightforwardly into AppleScript:

tell application "Microsoft Excel"

     tell page setup object of active sheet

          set print title rows to "$1:$2"

          set print area to "" -- determine at print time

          set left header to ""

          set center header to "My Report"

          set right header to ""

          set left footer to "Page &P of &N"

          set center footer to ""

          set right footer to "&Z&F"

          set left margin to inches to points inches 1.0

          set right margin to inches to points inches 1.0

          set top margin to inches to points inches 1.5

          set bottom margin to inches to points inches 1.5

          set header margin to inches to points inches 0.5

          set footer margin to inches to points inches 0.5

          set print headings to false

          set print gridlines to false

          set print quality to -4

          set center horizontally to false

          set center vertically to false

          set page orientation to landscape

          set draft to false

          set first page number to 1

          set order to down then over

          set black and white to false

          set zoom to 100

     end tell

end tell

The only tiny difference of any sort is that AppleScript does not have a documented term for the xlAutomatic constant, so I've set the first page number to 1, the usual "automatic". A bit of checking has discovered that the Long constant in VBA of xlAutomatic is -4105, and that may work if you try it in AppleScript too.

There is also an equivalent version of the macro possible in the old XL 4 Macro language, faster and more efficient than either VBA or AppleScript, which is likely to still work in Office 2008. This is not the place for XL4M code but you might care to look into it if it's still going strong in Office 2008. AppleScript can run XL4M macros via the run VB macro command that can pass arguments to a macro and call it using an A1 or R1C1 range reference, a range object, or the macro's name. So it does look as if the text of the macro could be stored in a cell on a macro sheet and run from there.

Inserting a Page Break

You can set or clear page breaks using the page break property:

This will set a single page break to the left of column C and above row 10:

With ActiveWorkbook.Sheets("Sheet1")

   .Cells.PageBreaks – xlNone 'Clear all manual pagebreaks

   .Range("C10").PageBreak = xlPageBreakManual

End With

In AppleScript:

tell application "Microsoft Excel"

     tell sheet "Sheet1" of active workbook

          set page break of every range to page break none

          set page break of range "C10" to page break manual

     end tell

end tell

Use page break of every range – not every cell.

In VBA, you can also specify a horizontal or vertical page break by adding to the worksheet‘s HPageBreaks or VPageBreaks collection:

With ActiveWorkbook.Sheets("Sheet1")

   .HPageBreaks.Add Before:=.Range("C10")

End With

In AppleScript it's actually a bit simpler, since horizontal page break and vertical page break are separate classes to begin with.

      tell sheet "Sheet3" of active workbook

          make new horizontal page break at end with properties ¬

              {location:range ("C10")}

     end tell

Note: once again the insertion location at end (or at beginning) is essential, or the script errors. (The Excel AppleScript Reference gives a similar example but neglects, or doesn't know about, at end.)

You can actually specify more properties than that, if you wish:

tell application "Microsoft Excel"

     set page break of every range of active sheet to page break none

     make new horizontal page break at end of active sheet with properties ¬

          {location:range ("C10"), extent:page break full, horizontal page break type:¬

              page break manual}

end tell

Setting Different Headers and Footers

At times, one wants a header or footer only on the first page of a multi-page printout. Excel does not have separate first page and even page headers and footers like Word does. To print a footer on only the first page, you‘ll need to cycle through the sheets, printing the first one with the footer, then remove the footer before printing the rest of the pages, then restore it to the worksheet at the end:

Public Sub FirstPageFooterOnly_OneSheet()

   Dim sFooter As String

   With ActiveWorkbook.Sheets("My Sheet")

      sFooter = .PageSetup.LeftFooter 'Save footer

      .PrintOut From:=1, To:=1

      .PageSetup.LeftFooter = "" 'Remove from remaining pages

      .PrintOut From:=2

      .PageSetup.LeftFooter = sFooter 'Restore footer

   End With

End Sub

This is a straightforward conversion to AppleScript, with no surprises – just look up the analogous names in the dictionary and all is OK:

tell application "Microsoft Excel"

     tell sheet "My Sheet" of active workbook

          set sFooter to left footer of page setup object --save footer

          print out from 1 to 1

          set left footer of page setup object to "" -- remove footer 2nd page

          print out from 2

          set left footer of page setup object to sFooter -- restore

     end tell

end tell

Note that if you have Left, Center and Right footers, you‘ll need to save and restore all of them.

Print Preview

You can use the print out method to create a print preview within Excel:

      ActiveSheet.Printout Preview:=True

          print out active sheet with preview

That does the job, but for some reason the script hangs, as if it's tied up waiting for a response, perhaps from the printer driver. Here's the way to avoid that, so the script can move on directly to the next line, or finish if it's done:

tell application "Microsoft Excel"

     activate

     ignoring application responses

          print out active sheet with preview

     end ignoring

end tell

If Office 2008 or a later version introduces its own script menu for Excel, and you run the script from there, ignoring application responses will have no effect. It only works directed at an application other than the one running the script. So run this script from the system's script menu.

Comments

Inserting a Comment

Comments, though they‘re attached to cells, are elements of the sheet, not the cell (range). Inserting a comment is done using the add comment command, but it is rather different in AppleScript than in VBA:

Public Sub AddComment()

   Dim cmt As Comment

   With Worksheets("Sheet1").Range("A10")

      Set cmt = .Comment ' Check to see if comment exists

      If cmt Is Nothing Then _ ' if not, add one

          Set cmt = .AddComment

   End With

   With cmt

      .Text Text:="My Comment" ' Overwrite existing comment

      .Visible = True

      .Shape.Select 'Select to allow editing

   End With

End Sub

In AppleScript:

tell application "Microsoft Excel"

     tell range "A10" of active sheet

          set cmt to its Excel comment -- no error if nothing (dummy comment)

          set vis to visible of cmt --get any property , returns missing value if empty

          if vis is missing value then

              set cmt to add comment

          end if

     end tell

    

     tell cmt

          Excel comment text text "My comment" --overwrites, but omit 'over write'!

          set visible to true

          select its shape object -- to allow editing

     end tell

end tell

In VBA, you set a variable to the putative comment, and if it's Nothing you Add one. Normally in AppleScript, you'd do the same thing by putting it in a try/error block, and if there's no value (it might require calling the variable you set to it to discover that), you would get an error, and in the on error block you'd add the comment.

But the actual behavior is much stranger. Excel comments have got to be one of the weirdest objects around. When a cell does not have a comment, it still has some sort of dummy Excel comment property, which does not error. (Note that you must include the its – its Excel comment – if in a tell block targeted at the range. Otherwise it does error, even if there is a genuine comment there, and you'll never get hold of it.)

However, all the properties of this dummy Excel comment return missing value. So we check for its visible property, and if that returns missing value – neither true nor false – we know we need to add a comment. We do that with the add comment command in the Excel Suite. Now we could include its comment text parameter to add the text then and there, but that would make the script rather complicated since cells with genuine comments have not been dealt with yet. So we just add comment, exactly as the VBA macro did, and handle all of them the same way after the if/end if block concludes.

Now – after the if block – this cell is guaranteed to have a valid, not a dummy, Excel comment: either it had a proper value for visible (true or false) in the first place, so it's bona fide, or else we just made a new comment (without text), so it's bona fide too. We now call the Excel comment text command. This is different from the VBA code where we can set properties of the comment. The Excel comment class has properties all right – author, shape object, and visible – but no property for its text!

Instead we need the Excel comment text command. And what a peculiar command it is. With no parameters used, it returns the existing text. As soon as you include the text parameter with some text, it writes the new text instead of returning the old text. Now it also has a boolean over write parameter as well (that's right, two words – there seems to be certain degree of illiteracy lurking here), but if you include it (with over write, as over write true compiles) the line errors 'range "A10" does not understand the Excel comment text message'!

The solution is just to omit the over write parameter, which is not only redundant, but destructive. Without it, everything works swimmingly. As long as you include the text parameter, and no start parameter, it overwrites the current text. You do not need the start parameter if planning to replace any existing text entirely – start 1 is the default.

Editing a comment

In VBA, one can format comments using code, as well as add text. But there seems to be a bug with being able to get the characters of a text frame in AppleScript, and thus no way to modify the font. Getting characters of text frame of shape object of theComment always returns {} – an empty list. This is a bug, which will hopefully be fixed in a later version.

Changing the Name on all comments

In VBA you can change the name applied to comments by deleting and recreating the comments. But that requires that you know which cell the comment is attached to. You wouldn‘t choose to search every cell in the worksheet, or even every cell in the used range, for their comments – it would take a very long time. Instead you get every comment on the sheet.

In VBA, before you delete the comment you can find where to recreate it by getting its Parent Property. Almost all Objects in Excel, Word and PowerPoint VBA have a Parent property, but for some reason that was not implemented in Office 2004 AppleScript for any of the Office applications. So to get every comment, you would have to loop through every cell of the used range, and basically throw away the VBA version. Here's the VBA code:

Public Sub ChangeCommentName()

   Dim ws As Worksheet

   Dim cmt As Comment

   Dim sCmtText As String

   Dim sOldName As String

   Dim sNewName As String

   sNewName = "new name"

   sOldName = "old name"

   For Each ws In ActiveWorkbook.Worksheets

      For Each cmt In ws.Comments

          With cmt

             sCmtText = Application.Substitute( _

                         .Text, sOldName, sNewName)

             .Delete

             .Parent.AddComment Text:=sCmtText

          End With

      Next cmt

   Next ws

End Sub

Here's the very different AppleScript, looping through cells instead of comments:

tell application "Microsoft Excel"

     set newName to "new name"

     set oldName to "old name"

    

     repeat with ws in (get every worksheet in active workbook)

          set ur to used range of ws

          repeat with i from 1 to count cells of ur


              set cl to cell i of ur

              set cmt to Excel comment of cl -- no error if nothing (dummy comment)

              set vis to visible of cmt --get any property , returns missing value if empty

              if vis is not missing value then

                   set cmtText to Excel comment text cmt

                   set AppleScript's text item delimiters to {oldName}

                   set chunks to text items of cmtText

                   set AppleScript's text item delimiters to {newName}

                   set cmtText to chunks as Unicode text

                   delete cmt

                   add comment cl comment text cmtText

              end if

          end repeat

             set AppleScript's text item delimiters to {""}

     end repeat

end tell

Remember from Working with Columns and Rows that we cannot repeat with cl in (cells of ur) nor set cl to item i of (cells of ur). Instead we must repeat with i from 1 to (count cells of ur) – since count cells works while getting cells (or every cell) does not – and then get cell i of ur.

We do not have Worksheet Functions such as Substitute in AppleScript either (see the introduction to this chapter). We could enter a function such as Substitute in an unused cell and get its value (result), but another way to do it is using the built-in AppleScript text item delimiters to replace text, and restore them to the default {""} at the end.

And it works.

An Extra – Deleting Hyperlinks

It's too soon to know if Excel in Office 2008 will have an option in the UI to not create automatic hyperlinks (that would be nice!), but this routine will delete all the hyperlinks from the active sheet:

Public Sub DeleteActiveSheetHyperlinks()

On Error Resume Next

ActiveSheet.Hyperlinks.Delete

On Error GoTo 0

End Sub

Simple:

tell application "Microsoft Excel"

     try

          delete every hyperlink of active sheet

     end try

end tell

One More

At the very end of these articles, closing Chapter 6 Entourage, is a script for exporting selected contacts to Excel with just the selected fields you want.


