AppleScript in Microsoft Office (General)

Issues in converting VBA to AppleScript in Word, Excel and PowerPoint

On to the nitty-gritty. On the one hand, as mentioned, the Object Models of Word, Excel and PowerPoint are virtually the same in AppleScript as in VBA, with the names of the various terms being very similar as well. On the other hand, there are certain fundamentals of the AppleScript language that differ from the concepts behind VBA, necessitating differences in the implementation and also in the code you write.

This section will go over some of the differences, and also some of the near-equivalences that nevertheless appear somewhat differently, when "translating" from VBA to AppleScript in all the Office applications.

Note: when testing out scripts in Script Editor, you may wish to begin every one with an activate command on its own line just inside the tell application "Microsoft Word" (or "Microsoft Excel" or "Microsoft PowerPoint") block, as its first line. That will bring Word (or Excel or PowerPoint, as the case may be) to the front so you can see what is happening. It is not necessary to include activate when running saved scripts from the script menu while Word is in the front (and there may be other occasions when you are running a script from elsewhere and don't want Word to come to the front). I have generally not included activate in the sample scripts here, but you may wish to do so.

Tell the Application

Let‘s start with the most obvious contrast between VBA and AppleScript. VBA macros run within documents or templates of a particular application: Word, Excel or PowerPoint (on the Mac). AppleScripts are either self-standing applications or scripts run from the OS script menu (actually run by the background application “System Events”). So to call a command or access an object in Word, Excel or PowerPoint – or any other application whatsoever – you must direct your code to it in a 'tell' block:

tell application "Microsoft Word"

    save as active document file name myDocName file format format text

    -- _all your other Word-specific code_

end tell

If you don‘t frame the code within that tell block, it won‘t compile, let alone run:

save as active document file name myDocName file format format text

Click Compile and you get this error message:

            Syntax Error : A class name can't go after this identifier.

This is one of those obscure AppleScript errors. You‘ll note that 'active document' is selected behind the error message. That‘s because save and as are both built-in AppleScript language terms, whereas neither active nor active document are defined terms outside of a Word tell block. So the AppleScript compiler thinks that active is a variable (an "identifier"), and the keyword document (which _is_ another built-in AppleScript language term) cannot follow a variable (the supposed active variable name) without some sort of appropriate preposition between them. E.g.,

save as active in document file name

_would_ compile (before hitting another error at 'myDocName‘) although it doesn‘t mean anything outside Word and can‘t run: if you try to run it you get an

AppleScript Error: Can't make file name into type reference

error message. So always remember to include the 'tell' block when calling Word commands or classes.

Invoking one Office application from another in VBA is a non-issue in AppleScript

Note that it makes no difference in AppleScript whether your script is "primarily" for Word or, say, Excel. When calling Word, you simply tell application "Microsoft Word"; when calling Excel, you tell application "Microsoft Excel". Neither application is running the script.

So when you come upon part of an Excel macro, say, that goes to some trouble to try to get an existing instance of Word or to create a new one, e.g.:

On Error Resume Next

Set oWord = GetObject(, "Word.Application")

If Err Then

Set oWord = New Word.Application

WordWasNotRunning = True

End If

you can just cut all that out. Just end tell your Excel block and start a new tell application "Microsoft Word" block. If Word is not open, this instruction will open it.

The only decision you need to make is to decide whether you now want to bring Word to the front or not. If you do, make the first line of the Word block:

activate

That will bring it to the front if Word is already open (and if it isn't open, activate does not add anything, since Word would come to the front anyway, but it's just fine to include it ). If you don't want Word to come to the front but to stay in the background, make the first line of the Word block:

launch

That will open Word in the background if it isn't open yet, and will do nothing if it is already open in the background.

No Dots, No 'equals' Assignments

Well, you already know that AppleScript is not a "dot" language like VBA, other BASIC languages, Python, etc. Its "English-like", more verbose syntax uses of, with the word order reversed to show containment, attributes, etc.:

ActiveDocument.Paragraphs(1).Range.Text

becomes

tell application "Microsoft Word"

content of text object of paragraph 1 of active document  
end tell

Note how an element (paragraph) can be specified by index (1) but using the singular paragraph, not Paragraphs as in VBA. (There are no Collection Objects in AppleScript: see below). And you don‘t use parentheses, just paragraph 1.

Some people used to "dot" languages, where you "drill down" from a top level object to the property you wish to access as opposed to AppleScript's usual method of "burrowing up" from the property to the top-level object, find the string of "ofs" irritating and are not aware that there is an alternative, the apostrophe-s syntax, in their preferred word order:

active document's paragraph 1's text object's content

But that tends to sound so awful (as English) that most people just use it one level deep (active document‘s paragraph 1, or text object‘s content) when the occasion arises.

A third way, and often very useful, is to tell an object to get some property or element:

tell active document to get its text object

and you can use nested tell blocks, like this:

tell application "Microsoft Word"

    tell active document

        tell paragraph 1

            tell text object

               get content

            end tell

        end tell

    end tell

end tell

That, of course, is very similar to VBA's With-End With blocks, discussed in more detail below.

Here‘s the place to mention a "gotcha": just sometimes those chains of "ofs" (or apostrophe-s‘s, or tells) don‘t work, for no apparent reason: occasionally the developers have forgotten to implement the "implicit get" and you need to use an "explicit get" for one of the deeper 'of' properties:

tell application "Microsoft Word"

    tell active document

        tell text object

            tell find object

               set content to "blue"

               set forward to true

               execute find

            end tell

        end tell

    end tell

end tell  
\--> false

whereas:

tell application "Microsoft Word"

    tell active document

        tell text object

            tell (get find object) _\--_ _crucial!_

               set content to "blue"

               set forward to true

               execute find

            end tell

        end tell

    end tell

end tell  
\--> true

In most applications, when this happens, the absence of an explicit get, when needed, results in an error: this can be perplexing, but at least you know _something_ is wrong. Here you get an incorrect result, which is worse. But it‘s very rare in Word (more common recently in Entourage, especially among the new Exchange properties, where you‘ll get either an error or _missing value_ as a result, without get.) When in doubt, throw in a get.

One more "gotcha" that scripters familiar with VBA, or just about any language but AppleScript, tend to keep stumbling on, even when they know better: in AppleScript, the = sign is not used as an assignment operator (the implicit Let Method in VBA):

     someVariable = "text"

In AppleScript, the = sign is used _only_ as an equality comparison operator:

   if someVariable = "text" then …

To assign a value to a variable, you must use set…to:

   set someVariable to "text"

Also note that, unlike in VBA, there is no difference in the syntax whether you are assigning a basic type like string or integer to the variable, or an application object: you _always_ use set.

Subs and Handlers

In a VBA macro, every line of code is in a Sub or Function. Even if there‘s only one simple procedure in the macro, it has to be in a named Sub Whatever(). In AppleScript, the equivalent "one simple procedure" is the top-level of the script, not in a handler (subroutine).

Actually, as the AppleScript books will tell you, the top level is an implicit 'run' handler, and you can make it explicit if you want by encasing it all in an on run/end run block. But there‘s almost never a reason for doing so, and almost no one ever does. There is only one rare situation where it is necessary: If you are loading and calling the script from another, external, script and need to pass it arguments. Normally, this would be done by calling a subroutine, but there are some rare circumstances – usually from an application, shell or Internet contexts outside AppleScript itself – that can only run a script, not call individual subroutines.

There is another situation where it is customary although not necessary to include on run: if you are making a "droplet" (a script application activated by dropping files or folders on it) with the obligatory on open handler and _also_ want a separate procedure to engage if you double-click the droplet file: then you‘d put it in a 'run' handler.

Many – perhaps most – simple scripts have only the top level, with no extra subroutines (handlers). If you are converting a macro that has just the one Sub(), that‘s all you‘ll need. But what about more complex macros that call other Subs or Functions? It‘s virtually identical in AppleScript, except that you don‘t use the word "Sub" or "Function" at all: the parentheses after a name is what tells AppleScript you‘re calling a handler. (There is another way to call and name handlers without parentheses, called "labeled parameters", but almost nobody uses them.)

Thus, there‘s also no difference syntactically in AppleScript between what would be in VBA a Sub (that does some procedure without returning a result) and a Function (which returns a result). In VBA:

   SubroutineA

or

   Call SubroutineA 

becomes in AppleScript:

SubroutineA()

Except that when you are calling a handler from within an application tell block, as you will be doing virtually all the time, _you must precede the call with the keyword_ my_:_

tell application "Microsoft Word"

    my SubroutineA()

end tell

or you will get an error. (Or you could use the synonym of me _after_ the handler name, if you prefer: SubroutineA() of me.) It‘s perfectly OK to use 'my' even when not in a tell block, so just do it every time and you can‘t go wrong. If you‘re wondering, the 'my' tells AppleScript that the user term SubroutineA belongs to the script itself, and not to the application (Word).

Similarly, if passing parameters to the subroutine, the VBA:

   SubroutineA param1, param2

or

   Call SubroutineA(param1, param2)

both become, in AppleScript:

my SubroutineA(param1, param2)

And the VBA:          

   theResult = FunctionB(param1, param2)

or

   Set theResult = Call FunctionB(param1, param2)

both become, in AppleScript:

set theResult to my SubroutineA(param1, param2) 

Again, a reminder that in all cases this SubroutineA is just a name followed by parentheses – it is not preceded by the word 'Sub' or 'Function' but rather by the obligatory 'on' or its synonym 'to'. It will look something like this:

on SubroutineA(param1, param2) 

        display dialog "Here's " & param1 & " and " & param2                        

end SubroutineA

Note that if you are sending commands to Word or Excel or any other application inside the subroutine, you must include a new tell block to that application there, even if the call to the subroutine was itself within a tell block to the very same application: that "calling" tell block has no force inside another subroutine (handler). It will most often happen, especially converting from VBA macros, that both the calling top-level script (or handler – you can call one subroutine from another too) and the called handler send commands to Word, or Excel, or PowerPoint and both contexts need their own tell block to that application.

Note also that "function" handlers that return results are no different in AppleScript from ones that don‘t:

on SubroutineA(param1, param2)

    set someText to "Here's " & param1 & " and " & param2

    return someText

end SubroutineA

might well be the handler called by

set theResult to my SubroutineA(param1, param2)

Modules

People working on large-scale VBA projects, particularly projects involving several collaborators, may be accustomed to using multiple VBA Modules controlled from a "central" module with global variables passed down to subsidiary modules written by different collaborators.

A similar modular structure is available in AppleScript using _script objects_. Script objects are often considered to be at the advanced end of AppleScript since they are not needed much in basic scripting, but they are fundamental to how AppleScript works. All of the AppleScript books discuss script objects: the Neuburg book is particularly good on script objects and discusses them early on.

The script files – .scpt and .app – in which you save your scripts are one form of script object. As such, they may be loaded by other scripts using the load script command in the built-in Standard Additions collection of scripting additions. All their script properties, variables, and handlers become available to the calling script, which may also set its own script properties and variables to these for convenience. So one script can act as a master script, loading the collaborators' script files as script objects to be used in just the same way as with VBA Modules.

Read up on script objects in the Neuburg and/or Rosenthal books (see Chapter 7: _Resources_ for URLs) if you need to learn more about them.

What About Dim?

In AppleScript, variables are not declared by data type. In fact, they do not have to be declared at all unless you wish to make them global variables – whose scope applies in every handler as well as in the top-level script – or script properties, usually called just properties, which are similar to globals but also have their initial value defined and are persistent between script runs. You declare variables global simply, like this, and preferably at the top of the script:

global var1, var2

You can run several globals together on the same line, separated by commas. Properties are declared and defined like this, at the top of the script, each on its own line:

property prop1 : "whatever"

property prop2 : 3

You _may_ choose to declare "ordinary" variables (i.e. not specifically declared as global or properties) as local, but are not required to: they are local by default whether you declare them as such or not. They are defined only for the handler or the top-level script in which they occur, and remain unknown to other handlers. However, such variables defined at the top level of a script without a declaration, although local to all intents and purposes, have certain quirks (namely retention) that are discussed in detail in the Neuburg book, which is especially good on _scope_ (i.e. the realms within a script where terms and keywords of various types hold sway) .

You can happily change the value of a variable to one of another data type without problem:

set a to 3

set a to "camel"

tell application "Microsoft Word" to set a to paragraph 1 of active document

So you can forget all about Dim now… You also do not need to reset variables whose value is an application reference to Nothing or similar at the end of a script: i.e., there is no need to release object references. Both of these easy practices are ultimately due to the fact that AppleScript has automatic garbage collection and cleans up after itself – you do not need to worry about memory issues or disposal.

if/else/then, tell, repeat, try and other control blocks

If…Then…End If : if…else…then…end if

Most indented "blocks" in VBA have AppleScript equivalents. if…then…end if is identical (once you get used to the lower-case characters) to VBA's If…Then. One feature of AppleScript's "if" syntax is that if the consequent code is just one line you can optionally put the whole thing on a single line rather than in a block, omitting the end if. E.g.,

if x = 3 then  
set y to 4  
end if

can be written (if you wish) instead as

if x = 3 then set y to 4

if…else if…else if…else…end if is identical to VBA's (note the separate words "else" "if"). There is no Select Case control statement as such: use if…else if instead.

With…End With : tell…end tell

The equivalent of VBA's With…End is tell…end tell targeted at an application object:

tell application "Microsoft Word"

    set textObject to the text object of active document

  

    tell (get find object of textObject)

        set forward to true

        set wrap to find continue

        set format to false

        set match all word forms to false

        set match case to false

        set match sounds like to false

        set match whole word to false

        set match wildcards to false

        clear formatting

        clear all fuzzy options

        clear formatting (its replacement)

    end tell

end tell

If you're familiar with Word's Find Object you will recognize the standard method for setting options within a

With ActiveDocument.Range.Find  
    
End With

block. But in AppleScript, you can go a step further in condensing the script if you wish, by putting all properties of the find object that need to be set into an AppleScript list (more on lists soon):

    tell (get find object of textObject)

        set {forward, wrap, format, match all word forms, ¬

           match case, match sounds like, match whole word, ¬

           match wildcards} to {true, find continue, false, false, ¬

           false, false, false, false}

        clear formatting

        clear all fuzzy options

        clear formatting (its replacement)

    end tell

Note that setting multiple properties via a list only works in a tell block, not using of. On the other hand, you can _get_ multiple properties in a list using of:

get {forward, wrap, format, match all word forms, match case, ¬

        match sounds like, match whole word, match wildcards} ¬

        of find object of text object of active document

For…Next, For Each…Next and Do While/Until…Loop : repeat…end repeat

Equivalent to VBA's For…Next, For Each…Next and Do While/Until…Loop loops are AppleScript's repeat…end repeat blocks, of which there are five types, as the AppleScript books will explain in detail. You will be tempted to use

repeat with eachItem in aList

  -- code here

end repeat

for “For Each” loops. This should work fine without problems when eachItem is an application object reference, as it usually will be. But you can often go awry if you forget that eachItem in this construction is a reference, not yet evaluated. The = equality operator will behave unexpectedly rigorously in this block:

repeat with eachItem in {1, 2, 3, 4, 5}

    if eachItem = 2 then

        beep

        display dialog (eachItem as string)

        exit repeat

    end if

end repeat

display dialog (eachItem as string)

No beep is heard, and the dialog displays 5. That's because eachItem never equals 2: it equals 'item 2 of {1,2,3,4,5}'. To avoid dealing with this issue, which you can solve by replacing the second line by

if contents of eachItem = 2 then

(or by other ways of forcing an evaluation of eachItem such as coercion), many people find it simpler just to use

repeat with i from 1 to (count {1, 2, 3, 4, 5})

    set eachItem to item i of {1, 2, 3, 4, 5}

    if eachItem = 2 then

i.e., a For…Next loop, in all cases.

Note: In VBA if you have "For i = 1 to 5 … Next i", the equivalent of this type of repeat loop, when you drop out of the loop having been round 5 times, the value of i is now 6. In AppleScript, i is 5 on exit from the loop 'repeat with i from 1 to 5'. This will surprise VBA coders who often rely on reading the value of n to see whether a loop was exited normally or by means of an Exit For statement.

exit repeat is the equivalent of Exit For, and gets you out of the block.

Check out the last subsection here – Special AppleScript Features – for two very powerful methods that can replace some repeat loops altogether.

On Error Resume Next/Go To : try…on error…end try

While not identical to VBA's On Error, AppleScript has something similar, but you must frame the section of code in which you want to trap the error with a try…end try block. A simple

try

    --code here

end try

is like an On Error Go To line after 'end try' applied to any runtime error that occurs within the block. This code:

try

    --code here

on error

    --alternate code here  

end try

provides an alternative in the event of an error, like On Error Resume Next but which can be located anywhere in your script. A more elaborate

try

    --code here

on error errMsg number errNum

    if errNum = -1708 then
        --alternate code here quoting or parsing the message
             -- and/or checking for the error number

    else

        -- do something else

    end if

end try

lets you branch depending on what the specific error number and/or message was.

Exit Sub : return/error number -128

To quit the top level of a script, you can use return at any time. In a subroutine, that will just get you back to the main script after the line that called the subroutine. To quit the whole script, even from a subroutine, use

      error number -128

which is equivalent to clicking a Cancel button. Just check that you're not in a try block at the time. If you are in a try block, you will have to test for the error number as in the previous example, and if it is -128 invoke error number -128 a second time in the on error section.

No Collection Objects nor Add Method

The examples to this point have been examples of how to "translate" basic VBA language to AppleScript. Of course, there are also some differences in the Object Model of the Office applications due to differences and requirements of AppleScript.

One of the most important is that there are no Collection Objects in AppleScript: the concept does not exist. Quite likely, it once took you some time to get your head around the idea of single Collection Objects that somehow incorporate all existing instances of their singular "client" objects, even before there are any!

You can forget all that now. There's nothing like that in AppleScript: only singular object Classes in the Dictionary. If there are more objects – several instances, either as elements of the application or as elements of some other class – they can be considered together in a list, which is like a VBA Array. There is no special treatment for lists of application objects as opposed to, say, a list of integers {1, 2, 3, 4, 7, 97, 1456863}. It's just a list. every text range, the canonical plural listed in the dictionary for most classes, has a synonym for the plural form – e.g., text ranges. You can frequently (usually) send commands to act on the whole list at once, if the developers have implemented this feature.

Although there are no Collection Objects as such, the plural form of each element, i.e., the list of all instances of that element of any class (or of the application), does of course constitute a collection. So the way of referring to a particular element can be quite similar in AppleScript to the implicit Item method of VBA Collection Objects, but without the parentheses.

Most elements can be referred to by index: document 2, or paragraph 1 of active document, etc. (document 2 is an element of the application, which does not have to be specified explicitly.) The index may change under certain conditions, of course (elements with a lower index being deleted, for example).

So there are often alternative methods. If a class has a name property, then you can generally specify it (as an element) by name, simply following the element's class with the name (a string): document "Converting VBA to AppleScript.doc", or document property "Author" of active document. Sometimes, with built-in elements like Word styles or for applications that maintain databases like Entourage, you can specify elements by unique ID.

And there is a very powerful method – whose filters – available to almost all elements in the Office applications, and is discussed in the next section Special AppleScript Features. The old Script Editor used to inform you of every method of specification for each element of a class, but the new (OS 10.3 and on) Script Editor 2 no longer does, which is a shame. Script Debugger, however, continues to do so.

So how do you add a new instance of a class without a Collection Object to add it to? The answer is: you don't. You create a new object, almost always via the make new command from the Standard Suite:

make v : Make a new element

 

make

new type class : the class of the new element.

at location reference : the location at which to insert the element

[with data anything] : the initial data for the element

[with properties record] : the initial values for the properties of the element

—>reference : to the new object(s)

The virtually universal way is to make the new element at a location (an existing element of the application or of some other class) with properties {…record…}. (An AppleScript record is an unordered collection of key-value pairs.) If you are making a new object that is listed as an element of the application itself (check the application class entry in the Microsoft Word Suite right now, if you have not done so yet), for example if making a new document, omit the at parameter.

As a simple example, to make a blank new document, instead of Documents.Add as you do in VBA, you

tell application "Microsoft Word"

    make new document

end tell

A great feature of AppleScript implementations is that any property that you don't specify with an initial value in the with properties {…} parameter has been given a default value by the developers. You can even leave them all unspecified, as with 'new document' (not that you'd usually want to, for other objects). For example (to save space the tell block to "Microsoft Word" will be left out in some of the examples here, but you always need it when scripting, of course):

make new table at active document



Resulting Table After “make new table” (with Show non-printing characters On)

I just ran that script on this very document and, as you can see, it entered a default table at the cursor (insertion point) with 2 rows and 5 columns, just as in the UI. This doesn't happen in VBA's Tables.Add where you must specify some required arguments (Range, NumRows and NumColumns) but it is obligatory in AppleScript that make new have default values for all properties, without erroring, so the developers have included those. Most of the time, of course, you will be specifying properties at creation time using with properties:

tell application "Microsoft Word"

    set myDoc to make new document

    set myTable to make new table at myDoc with properties ¬

        {allow auto fit:true, allow page breaks:true, column options:¬

            {default width:1.0, preferred width:25, preferred width type:¬

               preferred width percent}, number of columns:¬

            4, number of rows:12, spacing:2.0}

end tell

This sets a certain number of table properties at inception – there are a lot more available, as a glance at the dictionary entry for table will show: in fact the very same properties you can set in VBA, with very similar nomenclature, so you should feel right at home. Any properties not specified will have default values: unfortunately neither the dictionary nor the Word AppleScript Reference tell you what the defaults actually are in this case, but then again, neither does the VBA Help for Table Object (which is what the Reference draws on for its information). So you'll have to test them out, just as you did in VBA.

Note that the number of columns and number of rows properties (which actually correspond to the NumColumns and NumRows parameters of the Tables.Add method rather than to any Property of Table Object in VBA) allow you to set these table dimensions at inception (i.e., only in a make new table statement, not later on) even though the dictionary discloses that they are [r/o] read-only properties. After the table exists, you can add new elements – rows and columns – at the table:

make new row at end of table 1 of active document

You can specify locations (insertion points) for adding elements at the beginning, at the end, or after or before an indexed element:

make new row at after row 5 of table 1 of active document

and you can delete indexed rows or columns too.

None of this is special to Word, by the way: make new [object] with properties applies to most classes in Excel and PowerPoint (and every other scriptable application on the Mac) as well. Occasionally, though, with the Office apps (almost uniquely) it cannot be done that way. This will be because of some peculiarity in the OLE Automation/VBA heritage that just couldn't be adapted to standard AppleScript usage by the developers.

In those cases, you will find "proprietary" commands – usually beginning with the word create (rather than make) – that do the job. (In Word, there are seven commands in the Microsoft Word Suite beginning create, of which the one you'll use the most often is create range.) Be on the lookout for these create and other proprietary commands if you run into any make new errors. Traditional AppleScripters can be unnerved by these, but veteran VBA macro writers should not be put out since they in fact correspond more closely to VBA Methods than does make new [object].

Note: The one important exception to the with properties parameter is when making a new document in Word: in this case you cannot specify the properties at inception (they will be ignored) and must set them immediately after making the document, just as with the Add Method in VBA. This is discussed in more detail in Chapter 4: Word (New Document). Excel does not have this problem when making a new workbook. (In PowerPoint, no properties as such of the presentation can be set, even after making one, not even properties that are meant to be settable, so the issue is not relevant.)

Another exception of sorts is that some Collection Objects in VBA are read-only, where you cannot make new members. So these have not been implemented as elements in AppleScript, since there are no "read-only elements" (as opposed to read-only properties) in AppleScript: you can always make new elements. (The important distinction in AppleScript between properties and elements is discussed in Chapter 1's More about Dictionaries section.)

Instead, the objects (such as headers and footers in Word) are "stand-alone" classes that can only be ’got‘ by proprietary commands in the dictionary, not as elements or properties of a containing class (such as section) as you might expect. Some examples of this sort will be mentioned as they come up in the various application chapters, and it is something you need to be alert to: always check the dictionary to verify if an object is "contained by" another class other than base object, or if you can only get it by a specific command that you might need to search for using the Search box.

An Example of Removing Code Not Needed in AppleScript

As a review, here's a fairly extensive example of the sort of code you might well run into in a macro in one of the Office applications, calling another one, and how much of the macro needs to be stripped away in AppleScript. This particular example needs to run some Word code from a macro in Excel. Not only the bit that invokes an existing or new instance of Word needs to be removed (as in "Invoking one Office application from another", above), but also, as we have now seen, every Dim declaration, and some of the error handling too.

Here is the VBA subroutine (derived from "Control Word from Excel" by Bill Coan and Dave Rado: <http://www.word.mvps.org/FAQs/InterDev/ControlWordFromXL.htm>):

 

Sub ControlWordFromXL()

 

Dim oWord As Word.Application

Dim WordWasNotRunning As Boolean

Dim oDoc As Word.Document

Dim myDialog As Word.Dialog

Dim UserButton As Long

 

'Get existing instance of Word if it's open; otherwise create a new one

 

On Error Resume Next

 

Set oWord = GetObject(, "Word.Application")

If Err Then

Set oWord = New Word.Application

WordWasNotRunning = True

End If

 

On Error GoTo Err_Handler

 

oWord.Visible = True

oWord.Activate

Set oDoc = oWord.Documents.Add

 

' code here to manipulate the document

 

oDoc.Close savechanges:=wdDoNotSaveChanges

 

If WordWasNotRunning Then

oWord.Quit

End If

 

'Make sure you release object references.

 

Set oWord = Nothing

Set oDoc = Nothing

Set myDialog = Nothing

 

'quit

Exit Sub

 

Err_Handler:

MsgBox "Word caused a problem. " & Err.Description, vbCritical, "Error: " _

& Err.Number

If WordWasNotRunning Then

oWord.Quit

End If

 

End Sub

And here's the AppleScript equivalent, presented this time as a subroutine (handler) rather than as a top-level script, which you would do especially if you might want to use the same code frequently in several scripts:

to ControlWord()

    -- no need for any Dim statements

    -- no need for a try/error block to invoke Word

    -- no need to create a new instance of Word specifically, but

     -- check to see if Word is already running, for later  

    tell application "System Events"

        set wordWasRunning to exists process "Microsoft Word"

    end tell

    try

        tell application "Microsoft Word"

            -- no need to make Word visible, nor the option*

            activate

            set oDoc to make new document

           

            -- code here to manipulate the document

           

            close oDoc saving no

            if not wordWasRunning then quit

        end tell

    on error errMsg number errNum

        -- bring current application (e.g., Excel) to the front to view dialog

        activate

        display dialog "Word caused a problem. " & errMsg & ¬

            return & "Error: " & errNum with icon 0

        if not wordWasRunning then

            tell application "Microsoft Word" to quit

        end if

    end try

    -- no need to release object references

end ControlWord

 

Of course without all my explanatory comments the script would be even shorter. Notice that we ask System Events (a faceless background application with a very interesting dictionary – you can find it in /System/Library/CoreServices, if you want to browse it) to tell us if Word, as a process, exists, since there's no way to mimic the VBA method of trying to create a new Word instance (which errors if one exists already). Also note that Word (i.e., the application class in Word's dictionary) does not have a visible property, although window does, so you can certainly hide and show individual windows.

If you want to hide (or show) the whole application, you would do that in System Events, where you can set the visible property of any process, including Word. (The Finder can still do the same thing, at the moment, with its "legacy" commands, but these process features are now actually done by System Events: the Finder would just pass on the command, and some day may no longer do so.) This is a basic difference between the Mac and Windows: the system, rather than the application itself, controls things like visibility of applications.

Also note that in AppleScript you need to put a 'try' somewhere in order to catch an error. Usually, if one wanted to put the try block around the whole content of this ControlWord() handler, you'd put it around the call to the handler rather than inside it.

Also, note that in OS 10.4 (Tiger) that call to Word to quit inside the on error block will be well-behaved, but in OS 10.3 and earlier, if by any chance Word had already quit, this new tell statement would launch Word only to quit it!

What is Missing? What Are Your Options?

There are four big features of Office VBA that are missing from the AppleScript implementation. We've touched on one of them in discussing the script menu: you cannot run scripts from toolbar buttons. This will no doubt distress some people who like to run their macros this way, but at least you can run the scripts from a menu.

Perhaps if a later version of Office introduces script menus run by each application (as Entourage already has), it might be a next step to be able to drag those menu items to a toolbar as in Word's Customize feature. Some day, at any rate. I would not expect it to be a first priority.

In addition, there are several third-party utilities for automating the Mac that provide palettes or toolbars with buttons that can run scripts: QuicKeys, iKey, DragStuff all come to mind. (Look for them at <http://www.versiontracker.com>.) There are others, too. And there are ways in which you can make your own toolbars and buttons if you really want to, which I will mention in a moment.

A greater loss is that there is no way to run Auto Macros automatically when opening or closing a document, or the application. This may be an intentional decision by Microsoft in this day of security consciousness. In order for auto macros to work, scripts would first have to be stored in the documents themselves, as macros are now, as well as be provided with event procedures that watch the application and can intercept buttons and menu items.

While AppleScript is capable of implementing events ("Folder Actions" in the Finder that know when a file is added to folder are one notable example), most applications do not provide them. They have the potential to provide too much power to a scripter to interfere with the application. Storing macros, or scripts, in the documents themselves, as is essential for auto macros to function, is also what has allowed macro viruses to infest (mostly Windows) computers. The Macintosh unit of Microsoft would seem to be anxious not to allow this to happen on the Mac via their applications, and so "auto-scripts" do not appear to have a future.

You will not be able to convert your auto macros to auto scripts, but you can certainly make them into regular scripts that you run manually after launching an application or opening a document. There might be circumstances where it would be convenient to have an Entourage schedule run scripts for Word, Excel or PowerPoint on a regular schedule. [Ed. Note: This can also be achieved with cron and osascript, or scheduled via iCal.]

A third missing feature is UserForms. They are not available via AppleScript. To be honest, VBA user forms aren't all that great on the Mac anyway, stuck as they are in VBA 5.0 dating from 1997. They did not manage the transition to OS X all that well (they are looking rather dowdy), and so often forms made on Windows have not been adapted too well to the differing screen resolution on the Mac: the text and controls seem askew. It must be just too much effort, if even possible, for Microsoft to bring them up to date and also to somehow adapt them for AppleScript, which in its normal form is not in any way a UI feature.

But there is a solution, albeit a complex one. AppleScript Studio provides a glorious UI, where you can make fully-fledged Cocoa applications using AppleScript. And it's free. There is quite a learning curve – it is not for the faint of heart – but it provides a beautiful UI for your scripts with everything you could possibly want – and then some. Its visual objects are mostly made in Interface Builder, a development environment that lets you drop objects and controls of all shapes and sizes onto windows (reminiscent of User Forms, but far more sophisticated) and then control them from a specialized AppleScript dictionary that translates a good many Cocoa classes and methods into AppleScript.

The bonus is that you can also include regular AppleScript targeted at other applications such as the Office applications. (If you want to see an example of an AppleScript Studio add-on for Entourage, download my Entourage Today from <http://macscripter.net>.) You can read about AppleScript Studio at Apple's Developer website : <http://developer.apple.com/applescript/> and <http://developer.apple.com/referencelibrary/API_Fundamentals/AppleScript-fund-date.html>.

If AppleScript Studio is too overwhelming, you might want to look into a third-party scripting addition* called 24U Appearance OSAX, which provides a generous number of controls such as checkboxes, radio buttons, multiple text boxes, and so on. This is probably the most convenient solution and is easy to use: <http://www.24usoftware.com/AppearanceOSAX>. It's not free, and if you distribute your scripts to others, you would have to become involved in paying a rather hefty fee for bundling it.

(*Scripting additions extend the AppleScript language, rather like plug-ins, and are available for use when installed in a 'ScriptingAdditions' [no space] folder made in ~/Library or /Library. Apple has already installed its own collection called Standard Additions in /System/Library/ScriptingAdditions: check out its Dictionary. In the past, the liability always was that to distribute scripts that make use of third-party scripting additions, you had to depend on your users correctly installing their own copy of the same addition, something beyond the comfort zone of many users. Now, since OS 10.3, you can instead save your script as a Script Bundle or Application Bundle, place the scripting addition inside a 'Scripting Additions' [with space!] folder within the Contents/Resources folder of the bundle, and distribute the bundle. You must always check for licensing requirements, of course.)

A similar utility, but free, is Pashua <http://www.bluem.net/downloads/pashua_en/>, which requires some simple Unix-type scripting and is accessible from AppleScript. It needs to be included and installed with your scripts.

Another alternative is the free script editor Smile, already mentioned, which also has a very fully developed UI component. I honestly don't know which presents more of a learning process between AppleScript Studio and Smile, but if you are already using Smile its UI sector would be a natural extension. You'd have to bundle it for users too, but it's free (and your users would never have to look at it or learn anything about it).

Yet another solution, and an excellent one – perhaps the best – is the commercial FaceSpan <http://www.latenightsw.com/fs4/index.html>, which offers a full user-interface like AppleScript Studio (windows, panels, sheets, menus, and all varieties of widgets), but is much easier and more intuitive to use, and designed explicitly for AppleScripters. It is not cheap, however.

That about covers it, aside from one alternative without AppleScript at all: that's REALbasic <http://www.realsoftware.com/>.

Many of these "UserForms" solutions – AppleScript Studio, FaceSpan, 24U Appearance OSAX, and Smile – can also make toolbars with buttons that can run your scripts.

Note for developers: with AppleScript Studio, although the learning curve is very steep, the advantage is that the frameworks required to run the distributed applications are built into every Mac or are included in the builds. Users need to install nothing else. With FaceSpan, no separate installation is needed by users, but the builds include the frameworks and so can be large. For Smile and 24U OSAX solutions, you can now save your scripts in Script Editor and other editors as a script bundle or application bundle (a "package" that looks like a file to users), with Smile or 24U included in the bundle: in the case of 24U you can even include a "Scripting Additions" folder inside the bundle that makes it fully functioning, so again users need install nothing else. 24U allows you to include bundled versions free for free scripts and charge a developer's fee for commercial and shareware scripts. Smile is free.

The fourth missing feature is an AppleScript recorder. Microsoft used to provide a pretty good one up to Office v. X (Excel's was really quite impressive, Word's did everything by 'do Visual Basic') so it's not impossible that they'll bring one back in a later version of Office. But if you made it this far in this article, you're probably not someone who needs or enjoys a script recorder much. The limitations for a script recorder are the same as for a macro recorder – simplistic mirroring of UI actions, all done with 'selection' and no conditionals, etc. Let's pass on that.

That's the bad news. There is also some good news, which is that AppleScript can do some things VBA cannot, as well as connect you to almost everything else on your Mac. Read on.

Some Special AppleScript Features: whose filters and every element

In case you skipped these when learning AppleScript, you should know about two very powerful features of AppleScript that can really speed up your scripts, and simplify them too. Most scriptable applications, fortunately including the Microsoft Office applications, implement both of them.

The first is the whose (or where) filter or, as the old Script Editor used to refer to it, specifying an element "by satisfying a condition".

tell application "Microsoft Word"

    every paragraph of active document whose content of text object contains "AppleScript"

end tell

gets me a list of 66 paragraphs in this document containing the string "AppleScript" in 2 seconds flat, without having to run a laborious repeat loop through every paragraph in turn. You can also ask for first paragraph (or last paragraph) too, but be sure to put that version in a try/on error block since it errors if there are none.

This is really incredibly powerful, works on virtually every element of every class in all the applications, and can save you great time and effort (if you're sure you've got the syntax correct!). I strongly recommend scrapping tedious repeat loops for your For, For Each, Do While VBA loops and substituting whose filters whenever possible when converting your macros. (The repeat loops seem to run a lot slower in AppleScript than in VBA, too – another very good reason.)

One gotcha to look out for: if the name of the property you're filtering on also happens to be the name of a class (e.g., category in Entourage, or replacement in Word) then use the synonym where its instead of whose: the important word its focuses AppleScript on the element being considered and its property of the equivocal name – otherwise AppleScript gets confused since the class name has priority when in doubt and you get an incorrect result of {} (no results).

An equally powerful feature for putting AppleScript to work and avoiding tedious repeat loops is asking for the (singular) property of every element:

 

tell application "Microsoft Word"

    name of every document

end tell

-->{"Document3", "MacPowerPointVBA_PunchList.doc", "Converting VBA To AppleScript in Microsoft Office.doc", "Document2"}

   

    name local of every Word style of active document
    --> {"1 / 1.1 / 1.1.1", "1 / a / i", "Article / Section", "Balloon Text", "Block Text", "Body Text", "Body Text 2", … etc

You get a list of the requested property for every element. Once again, there is no need to go through a tedious repeat loop through each element. (In the case of Word styles, that would be upwards of 165 elements. There could be hundreds or thousands of elements in other contexts.)

Now very occasionally you'll hit a bug with this method (e.g., I just hit one trying to get content of every word of text object of paragraph 1 of active document, where the bug is actually with every word, not with the content of property retrieval), but it's very rare: as long as you can get 'every element of some object' as a list you can get any of its properties in a list too.

Note that you cannot apply a whose filter to the resulting list, or any other AppleScript list (a failing of AppleScript many have waited long to see disappear, and may still yet someday). It‘s only applicable to application elements. What is odd is that most applications, including Entourage, allow you to combine the two features discussed here to get a property list on a whose filter, e.g.:

tell application "Microsoft Entourage"

    name of every contact whose default email address contains "microsoft.com"

end tell
--> {"Bill Gates", "Steve Ballmer", "Roz Ho"}

but you can't do the equivalent for Word, Excel or PowerPoint, e.g.:

tell application "Microsoft Word"

    name of every document whose content of text object contains "AppleScript"

end tell
--> missing value

That's a shame, but the two special features still give you a lot of added power on their own.

There's lots more to explore in AppleScript, but this should cover most of the essential points of convergence, and divergence, between the VBA and AppleScript ways of doing the same things in general terms, across the applications – especially if you read one of the AppleScript books before attempting your own scripts. Now it's time to look at some examples from the individual Microsoft Office applications.

Note: In the following chapters, the version of Office used is 2004, updated to 11.3.3, current at the time of writing. It is quite likely that many of the gaps and bugs mentioned in Office 2004's AppleScript, usually with workarounds provided, will be fixed in Office 2008. If you happen to be reading this after Office 2008 has been released, you may be pleasantly surprised to discover that some of the problems discussed no longer apply. Here's hoping!

