5\. PowerPoint

PowerPoint VBA Macros to AppleScript

Make sure you have read Chapter 2: _AppleScript in Microsoft Office (General)_ first. It deals with many important features of VBA, including PowerPoint VBA, that need to be treated very differently in AppleScript, as well as some equivalent control and operator statements in AppleScript you need to know.

This chapter consists of typical subroutines (macros) in VBA, and their equivalent in AppleScript, with comments as necessary to explain differences in the AppleScript approach. All the examples are by Steve Rindsberg, PowerPoint MVP.

Note: when testing out scripts in Script Editor, you may wish to begin every one with an activate command on its own line just inside the tell application "Microsoft PowerPoint" block, as its first line. That will bring PowerPoint to the front so you can see what is happening. It is not necessary to include activate when running saved scripts from the script menu while PowerPoint is in the front (and there may be other occasions when you are running a script from elsewhere and don't want PowerPoint to come to the front). I have not included activate in the sample scripts here, but you may wish to do so.

Before launching into scripting PowerPoint, it is a good idea to read the introductory section _Using the PowerPoint Dictionary_ of the _PowerPoint AppleScript Reference_ available in PDF format free from Microsoft at <[http://www.microsoft.com/mac/resources/resources.aspx?pid=asforoffice](http://www.microsoft.com/mac/resources/resources.aspx?pid=asforoffice)\>. Although it is largely aimed at AppleScripters unfamiliar with PowerPoint's Object Model rather than vice versa, and the introduction is quite short, it has some useful information for all scripters of PowerPoint. If you are going to be scripting text in text frames, you should turn now to Chapter 2: Word and read up on text range there, and also in the introductory section to the _Word AppleScript Reference._ But note that text frame (in the Drawing Suite of the dictionary), here in PowerPoint as well as in Word, is the one class that uses text range, rather than text object, as the name of its own range property as well as for the name of the text range class itself (in the Text Suite). (There are more details about this in the _Find and Replace Text_ section of Chapter 2: Word.) Also check out the PowerPoint scripts on Apple's AppleScript website: <[http://www.apple.com/applescript/powerpoint/](http://www.apple.com/applescript/powerpoint/)\>.

This is the point where it has to be acknowledged that, in comparison to Word and Excel, the PowerPoint 2004 AppleScript implementation leaves something to be desired. Not to put too fine a point on it, there really are quite a lot of bugs, and some gaps in the Object Model too. It may well be that PowerPoint "came in last" and didn't get a sufficiently exhaustive round of testing before Office 2004 was released on schedule. (There was one master developer who implemented the entire AppleScript implementation, from the ground up, for all of Office 2004, and he needed to finish before the specialist AppleScript testers got to it.) But these bugs are well known and hopefully most will be fixed for Office 2008, which is when you need these scripts after all.

In the meantime, if and when you hit any bugs that cannot be worked around while converting your scripts now, usually all you need do is substitute a line or more of do Visual Basic command, quoting your VBA lines as text in quotes. (You do not need any Dim declarations for these, even if you have your VB Editor set to Option Explicit, although you can include them if you wish.) do Visual Basic was the _only_ way to script PowerPoint in Office v. X and still works fine in 2004, but will not work in Office 2008, at which point you will substitute the native AppleScript version.

If you already know what the proper AppleScript version should be (i.e., if the terms exist and compile, but don't function properly in 2004) you could include them commented out (i.e., preceded by -- dashes), and can try just uncommenting them and removing the do Visual Basic lines in PowerPoint 2008, and testing them out then. Or even put the do Visual Basic in a try block and the pure AppleScript in the on error block – but it's probably better not to second-guess a future implementation and see to it when the time comes. Remember that all quoting within the VBA string needs a backslash \\ escape, like so: \\". do Visual Basic can be a bit tricky with multiple-lines of VBA and with internal quoting; read my article on do Visual Basic, if you do need to use it, here: <[http://word.mvps.org/MacWordNew/WordAppleScript.htm](http://word.mvps.org/MacWordNew/WordAppleScript.htm)\>. Although the article uses Word for its examples, it works exactly the same for PowerPoint. Hopefully, you will not need do Visual Basic at all, but it's there if you need it for the occasional line in PowerPoint 2004.

There's one particularly serious "gotcha" to beware: unaccountably, there is no selection object – either of the application or of the presentation – in PowerPoint 2004 AppleScript. Many VBA macros you have will be referencing the Selection Object, which leaves you stranded. Again, this will hopefully be rectified in PowerPoint 2008. In the meantime, although you can use do Visual Basic to get the Selection (and get particular slides and shapes via Selection.ShapeRange and Selection.SlideRange), do Visual Basic cannot return the result (the selected slide or shape) to AppleScript, so you would seem to be stuck. See if your macro can be rewritten to omit .Selection, which would be best.

Later in this article I provide temporary workarounds for 'selected slide' and 'selected shape' that will allow you to do your VBA macro conversions now in PowerPoint 2004 and make use of your scripts while waiting for Office 2008 to hopefully introduce the selection object to AppleScript. (If PowerPoint 2008 does _not_ implement the selection object, or some alternate way to get selected shape(s) in AppleScript, then you will not be able to convert any macros involving selection or selected shapes in 2008, and would have to remain with PowerPoint 2004 (in Rosetta, if on an Intel computer), or use PowerPoint Windows in Parallels or VMWare, if these PowerPoint macros are necessary to you.)

New Presentation, Open Presentation, New Slide

Make a New Presentation

Just a reminder, already mentioned in Chapter 2, that the way to make a new blank presentation equivalent to

   Application.Presentations.Add

is

make new presentation

Just as in Word, this action – making the fundamental element of the PowerPoint application – is the one important make new command that does not let you set any properties at inception. Normally in AppleScript, you would expect to be able to specify many, or most, of the properties of document in a with properties parameter, right at creation time, as in Chapter 2's example of making a new table at a document in Word. (A scripter would expect that only elements, if any are needed, would have to be added afterwards.) But that is not the case with making new presentations: properties _cannot_ be set at inception of the document, which needs to be created first. This does correspond with how the Add Method works for Presentations, so it should not surprise people accustomed to VBA.

In VBA the only argument that can be specified with Presentations.Add is WithWindow that determines whether the new presentation is visible or not. There is no way to make an invisible presentation in AppleScript, since presentation does not have a visible property to set to false. (Its main document window does, but as with many applications, the visible property of document window is read-only, and is always true.) Nor is there any command such as hide. So invisibility is something you have to give up, if you were ever accustomed to making invisible presentations (for speed) in VBA.

At first there seem to be no properties of a presentation that you can set as such in AppleScript (the dictionary entry for presentation shows all properties as r/o: read only) but don't be dismayed – there are many properties, such as page setup, web options. slide show settings, etc. that return objects whose own properties can be set with abandon and almost infinite choices. This is similar in every Office app: it means you can set these 'properties of properties' after creation of the presentation but not in a 'make new' statement. There are also new elements that can be made at the presentation, also after creation of course, and then you can modify them (i.e. set the elements' own properties) as needed.

Don't forget that what VBA considers Properties includes many Collection Objects (such as Slides), which in AppleScript are elements that you make. All other properties of presentation, both in VBA and in AppleScript, are read-only, aside from a very few (east asian line break level, layout direction, and a few others) that the PowerPoint AppleScript Reference informs us are not available in U.S. English version of PowerPoint in any case. The one real gap in AppleScript, which somehow got omitted, is an equivalent to the DisplayComments property, which is a read/write property and should be controllable from AppleScript. You can make comments (in the Drawing Suite) and set all sorts of attributes for them, but not control whether they are visible or not.

So every script that needs to make a new presentation will start off, simply, as
```
tell application "Microsoft PowerPoint"

     set newPres to make new presentation

     tell slide 1 of newPres

          -- code here

     end tell

end tell
```
You must set a variable of your choice to the make new presentation statement, which by definition returns the object it has made, or you won't have anything to work with. Of course you won't always be going on to tell slide 1 (to set various properties of, and make new elements at, slide 1), but you will get around to that pretty soon in most cases. We will be looking into what can be done with presentations and slides in a moment.

Open an Existing Presentation

It's a relief to say that opening an existing presentation .ppt file is, as with all applications, dead simple in AppleScript. The equivalent of the Open method in VBA:

   Presentations.Open FileName:="Mac HD:Folder:Filename.ppt"

is the open command (in the Standard Suite) in AppleScript:

```
tell application "Microsoft PowerPoint"

     open alias "Mac HD:Folder:Filename.ppt"

end tell
```

Note that you should properly use the alias reference form, but the PowerPoint developers have enabled a coercion allowing you to use just the path text as an equivalent, just as in VBA. Also, in AppleScript, you can open a list of (presentation) files all at once if you wish. – just provide the list of .ppt aliases.

Sometimes we are interested not just in opening a presentation, but also in modifying it, or getting some information from it. In VBA, that is very straightforward: you just set a variable (reference) to the result of the Open statement, which returns a Presentation object, and then set some Properties of it or apply some Methods to it:
```
Dim oPres As Presentation, oSlide As Slide

Set oPres = Presentations.Open(Mac HD:Folder:Filename.ppt")

With oPres

    Set oSlide = .Slides.Add(2, ppLayoutText)

End With
```
The process of setting a variable to the result of a command is usually straightforward in AppleScript too. However, just as in Word, the command open from the Standard Suite does not return a result, so you cannot set a variable to the command. They would have done far better to do what Excel does – leave the plain open command in place for opening multiple files, and also give PPT its own 'open presentation' command with all the parameters, that does return a result.

Here is a workaround:
```
tell application "Microsoft PowerPoint"

     open "Mac HD:Users:yourname:Desktop:Saved Pres.ppt"

     set thePres to active presentation


     set theSlide to make new slide at end of thePres¬

          with properties {layout:slide layout text slide}

end tell
```
We open the presentation and then set our variable to active presentation – the presentation in the front. The open command always opens the file in the front of the application, so this always works, if the presentation was not already open. If the presentation already is open, however, it does not come to the front, and you will be acting on the wrong presentation. So here's the full workaround you need:
```
tell application "Microsoft PowerPoint"

     try

          set thePres to presentation "Saved Pres.ppt"

     on error

          open "Mac HD:Users:yourname:Desktop:Saved Pres.ppt"

          set thePres to active presentation

     end try

     set theSlide to make new slide at end of thePres ¬

          with properties {layout:slide layout text slide}

end tell
```
When Office 2008 arrives, do check in the Microsoft PowerPoint Suite to see if there is an 'open presentation' or similarly named command that returns a result, and also check open in the Standard Suite just in case, as well.

Make a New Slide

This turns out to be quite interesting. The Add method for Slides in VBA requires two arguments: Layout and Index:

ActivePresentation.Slides.Add Index:=1, Layout:=ppLayoutText

Now in AppleScript, there are not many properties of slide that are read/write (and some, like color scheme, require a special proprietary command to change them, so can't be set at inception when making a new slide). layout can be set, but slide index (the AppleScript term for Index) cannot – it's read-only and can't be set, not even at inception as read-only properties sometimes can. There is, however, a proper, bona fide AppleScript way of specifying where an element is inserted, and that's precisely what the developers have done here, to their credit. I have shown many times in these articles that elements are made at an object, and usually that's all you need to do. (See all the previous examples in Word and Excel). But if you try:
```
tell application "Microsoft PowerPoint"

     set newSlide to make new slide at active presentation ¬

          with properties {layout:slide layout text slide}

end tell 
```
hoping that will work, it doesn't: it errors.

If you take a good look at the make command in the Standard Suite of any application, you'll see it has two required parameters: new (rather redundant since it's obligatory, but technically it's this new argument that specifies the class of the new element) and at. Well, you knew that already. But the description for the at parameter says "location reference : the location at which to insert the element". Now, strictly speaking, that really requires a precise location, not just "at" the parent object. Since in some cases it doesn't really matter where, and in other cases there's no choice where new elements go – they go at the end, after existing elements – most applications have implemented a convenient coercion that lets you omit the "at end of [object]". But with the slides of a presentation, we really want to be able to insert them anywhere, not just at the end, and we can!

The proper ways in AppleScript of indicating an insertion location are: at beginning of, at end of, at before [some element], at after [some element]. And all those work:
```
tell application "Microsoft PowerPoint"

     set newSlideA to make new slide at beginning of active presentation ¬


          with properties {layout:slide layout text slide}

     set newSlideB to make new slide at end of active presentation ¬

          with properties {layout:slide layout two objects over text}

     set newSlideC to make new slide at before slide 2 of active presentation ¬

          with properties {layout:slide layout media clip and text}

end tell
```
The last command inserts newSlideC as the new slide 2 before the existing slide 2. (You could also say at after slide 1 to insert it at the same location, if you like the sound of that better.) Don't forget – you can't drop the at preceding before – even though it sounds terrible in English. After the slide is created, you can always get its slide index property to find out where it is located.

Now where did those layout types come from? In the dictionary for slide (Microsoft PowerPoint Suite) you will see all the enumerated constants for layout property strung together, separated by / slashes. (Enumerations have a much nicer "layout" in Script Debugger.) It's very easy to see which one must be the equivalent for VBA's ppLayoutText constant: it's obviously slide layout text slide. (AppleScript developers have to be extremely careful not to cause terminology conflicts: the keywords you see in dictionaries and scripts mask the real "raw codes" that the compiler compiles to: if the same keywords were used for different properties and enumerations, scripts would compile incorrectly and fail. The simplest way for the developers to avoid conflicts is to give enumerations a unique name starting with the class and property – slide layout – and only then follow with the enumerated constant. text is used in so many constants of this enumeration – it's the third word in no less than six of them ­– that they've added the word slide to make sure this one is unique and won't be confused with any of the others.)

You will be able to find the AppleScript version of the VBA constant without difficulty: just precede it by "slide layout" and look for what is virtually the same name. Occasionally you will see macros where the author has used the actual Long (number) rather than the descriptive pp constant: for example for ppLayoutText he might have used the number 2 instead. Unfortunately, in this case that won't work (though in several enumerations in Office it does!). You would need to look up ppSlideLayout in the VBE Object Browser to find its (ppLayoutText) name from the Long (2) first, and then use its obvious AppleScript equivalent from the enumeration list.

Once you've made your slides, you will want to keep track of which one is which, since the canonical reference to slides is by index (slide 1, slide 2, slide 3, etc.) which keeps changing if you insert a new one at the beginning or somewhere in the middle. What you knew as "slide 3" is no longer slide 3, but slide 5, for example.

In VBA, all slides have a Name property (by default "Slide1", "Slide2", etc. but you can rename them). For some reason (this starts to become familiar) there is no name property in AppleScript. However, all slides also have a unique ID, or SlideID property in VBA, which you can get as soon as you've made the slide. (They seem to increment forever from the moment you first launched your copy of PowerPoint.) This property does exist in AppleScript, as the slide ID property. In VBA, you can find the slide again using the SlideID, via the FindBySlideID method of the Slides Collection Object. Such a command does not exist in AppleScript (you start expecting this after a while). But here's where the whose filter of AppleScript comes to the fore. This ought to work:

get first slide of active presentation whose slide ID is 1257

but the result is {} (an empty list = nothing), clearly a wrong result when you know the slide does exist. It's another bug. In fact, the formulation first element whose… is often not quite right in the Office apps: sometimes it gets you the same result as every element whose… instead. (Sometimes it works fine.) The workaround here is to:

get every slide of active presentation whose slide ID is 1257

which gets you the right result:

--> {slide 1 of active presentation}

in list braces. There can only ever be one slide with that ID, so "every" gets you the single-item list. The solution is:

item 1 of (get every slide of active presentation whose slide ID is 1257)

--> slide 1 of active presentation

Insert a Slide

Unfortunately, and unaccountably, there is no AppleScript equivalent of the InsertFromFile method that allows you to insert an existing file of saved slide(s) into a presentation. It's a bug, and should hopefully be made good in Office 2008 – look for an insert from file command.) In the meantime, here's a chance to try out do Visual Basic. You can still convert your macro, and when you get to a line using InsertFromFile, like this:

   ActivePresentation.Slides.InsertFromFile _

      "Macintosh HD:Users:Shared:Sales.ppt", 2, 3, 6

you would, for the moment, in PowerPoint 2004, use:

do Visual Basic "ActivePresentation.Slides.InsertFromFile _

     \"Macintosh HD:Users:Shared:Sales.ppt\", 2, 3, 6"

Note the escape backslashes \ before the internal quotes, and the fact that you do not need to close the outer AppleScript quotes for each line of the quoted VBA. And do remember that this line will fail in Office 2008 – you will need to replace it with (hopefully) the new AppleScript command at that time.

Working with Existing Slides and Shapes

Getting a selected slide or shape

Often you might run into VBA code like this:
```
Dim oSh as Object

Set oSh = ActivePresentation.Slides(4).Shapes(8)

With oSh

   .SomeProperty = "this"

   .AnotherProperty = "that"

End With
```
This is just a reminder from Chapter 2 that 1) in AppleScript you don't need to (and can't) declare (Dim) anything as typed; 2) there are no collection objects in AppleScript, so instead of ActivePresentation.Slides(4).Shapes(8), you refer to shape 8 of slide 4 of active presentation; and 3) you can use a tell block exactly as VBA uses a With block:
```
tell application "Microsoft PowerPoint"

     set theShape to shape 8 of slide 4 of active presentation

     tell theShape

          set some property to "this"

          set another property to "that"

     end tell

end tell
```
Furthermore, if you're setting 18 or so properties of theShape, you don't even need to set each one separately on its own line (although you can if you want to: it's sometimes easier to keep track of them that way): you can set them all in one long line using lists, like this:
```
tell theShape

      set {some property, another property} to {"this", "that"}

end tell
```
You must use the tell block if you want to set a list of properties in one line: you cannot do so using the alternative of syntax.

As mentioned just above, there is no name property of slide in AppleScript. But because it is so useful in VBA as a way of keeping track of and referring to slides you will very often find in the macros you want to convert that the author has named each slide and shape of interest for later reference. Many macros will start out by presuming that you have selected a slide or a shape, and then will proceed to name it for future reference:
```
With ActiveWindow.Selection.SlideRange

   .Name = "MyName"

End With

 

With ActiveWindow.Selection.ShapeRange

   .Name = "MyName"

End With
```
The VBA author will no doubt have been careful to specify that you must select only one slide or shape for the Name property, whether using the SlideRange or ShapeRange property as above, or by .Selection.Slides(n).) Unfortunately, you're going to have to dispense with all this since, as mentioned above, there is no selection object in AppleScript at present in PowerPoint 2004. You will have to wait for Office 2008 in the hope that it has a selection property of the application (and of presentation) to be able to do a direct "translation" of .Selection. Read on for a workaround for PowerPoint 2004 and comments about 2008.

For now, as an alternative, to get the selected slide, this works, if you first click anywhere in the slide pane to make it the active pane:
```
tell application "Microsoft PowerPoint"

     set theIndex to slide index of slide of view ¬

          of active window

     set selectedSlide to slide theIndex of active presentation

     set slideID to slide ID of selectedSlide

end tell
```
The slide of the view of the active window will be your selected slide as long as you are not in Slide Sorter View (which does not have any single slide displayed as a slide property), and as long as you first click somewhere in the Slide pane to make it the active pane if you are in Normal View. Or else switch to Slide View, where it always works. You'll need to dispense with naming the slide (since you can't) and use the slide ID instead.

If you are not going to be moving slide positions around, then just calling selectedSlide will find it later in the script. But to be safer, since that is a reference to the slide by index and the index may well change, get the slide ID now (as in the third line above) and then use it to find your slide later, just as we did in the previous section:

      set theSlide to item 1 of (get every slide of active presentation ¬

             whose slide ID is slideID)

But there doesn't seem to be any way to get the selected shape on a slide (unless it's the only shape, of course). While waiting for the next version to hopefully come up with a selection property, even do Visual Basic wouldn't at first appear to be much use since it cannot return a result to AppleScript.

Since this problem would put so many PowerPoint macros out of bounds I have come up with a workaround as a way to get past that first line of a macro that will otherwise convert nicely to AppleScript. I have made it as a handler (subroutine) called GetSelectedShape() because you are going to need it very frequently for now (PowerPoint 2004, that is), including in many other examples in this chapter. Just keep GetSelectedShape() handy in a script library, and paste it in to the bottom of every script that needs to work with a selected shape.

You call it by entering the line:

set selectedShape to my GetSelectedShape()

whenever you need it (for now, in PPT 2004), to take the place of any VBA line that gets the selected shape or assigns a variable to ActiveWindow.Selection.ShapeRange. Here it is in action:
```
tell application "Microsoft PowerPoint"

     set selectedShape to my GetSelectedShape() --calls the handler below

     -- test only:

     set theText to (content of text range of text frame of selectedShape)

     -- enter rest of script after trying the test and removing the line above

end tell
```
 
```
to GetSelectedShape()

     set textFilePath to (path to temporary items as string) & "Shared Text File"

     tell application "Microsoft PowerPoint"

          activate

          set theIndex to slide index of slide of view ¬

              of active window

          set selectedSlide to slide theIndex of active presentation

          do Visual Basic "n = ActiveWindow.Selection.ShapeRange.ZOrderPosition

     'write n as string to text file, replacing any text there

     FileNumber = FreeFile

     Open \"" & textFilePath & "\" For Output As #FileNumber

     Print #FileNumber, CStr(n)

     Close #FileNumber

     "

          set n to (read alias textFilePath before return) as integer

          set selectedShape to shape n of selectedSlide

          return selectedShape

     end tell

end GetSelectedShape
```
The last line of the top-level script getting the text is just a test for you to try now: first select a text box or shape with some text in it before running this script. You'll see that the result of the script, in Script Editor, is the text from the shape you selected.

In AppleScript we first get hold of the selected slide, exactly as in the previous example, via the view. (In this case, since you have selected a shape, it's guaranteed that the slide pane is active, so you're fine.) With do Visual Basic (in PPT 2004, for now: it will not work in 2008) we get the ZOrderPosition of the selected shape. The ZOrderPosition (or z order position in AppleScript) of a shape is the index number of its "recentness" – the reverse of its order of creation. (Every time you make a new shape, whether in the UI or by macro or script, it now has z order position 1 and pushes the others back to higher numbers.) This index number n is the same as the index of the shape on the slide – and we know which is the selected slide, so we can get shape n of the selected slide and that's the selected shape we're looking for.

The problem is that do Visual Basic cannot return this result n to the script. So instead, we cast the integer n to string (CStr(n)) and write it out to a text file. The very first line of the handler has previously prepared a file path in the user Temporary Items folder on your Mac and set a variable textFilePath to it. (Under OS X, "Temporary Items" is in fact on the root of your hard drive, in /var/tmp, not in your own user folder so don‘t write anything too sensitive there if there are others with access to your computer. Or tell the Finder to delete the file at the end of the script. However, all we are writing here is the number "3" or "4" – that's it – so it's not necessary to take any precautions in this case.) We insert that textFilePath variable, carefully surrounded by escaped quotes, into the do Visual Basic command and use the standard VB FreeFile, Print # and Close # methods to write the string number to the file and close it.

We can then immediately retrieve the string from the file via AppleScript's read Standard Addition command (up to the line ending added by Print #), coerce it back to an integer n, get shape n of the selected slide, and now we have the selected shape. Voilà!

This workaround is just a means for you to test out the rest of a macro-to-script conversion now, in Office 2004, of course; the do Visual Basic command will no longer work in Office 2008. When Office 2008 arrives, you hopefully should be able to replace the call to the handler (set selectedShape to my GetSelectedShape() ) with a straightforward statement getting the selected shape - or so we all fervently hope. The handler gets you over that first hurdle, and you now can convert your macros that depend on selected shapes.

(As mentioned already, if PowerPoint 2008 does not implement the selection object, or some alternate way to get selected shape(s) in AppleScript, then you will not be able to convert any macros involving selection or selected shapes in 2008, and would have to remain with PowerPoint 2004 (in Rosetta, if on an Intel computer), or use PowerPoint Windows in Parallels or VMWare, if these PowerPoint macros are necessary to you.)

Change every shape on a slide, change every slide in a presentation

Here is a macro that sets the background color of every slide in a presentation to a pale aquamarine (the background color of the first color scheme of the second row when you Format/Slide Color Scheme in the UI), and then moves each shape on each slide half an inch to the right, looping through each slide in the presentation and each shape on each slide:
```
Dim oPres As Presentation

Dim oSl As Slide


Dim oSh As Shape

Dim colSch As ColorScheme

 

' Get a reference to the current active presentation

Set oPres = ActivePresentation

 

' Do something with each slide in the presentation

For Each oSl In oPres.Slides

' Set the background color scheme of each slide to a pale aquamarine

Set colSch = oSl.ColorScheme

colSch.Colors(ppBackground).RGB = RGB(222, 246, 241)

' and do something with each shape on each slide

For Each oSh In oSl.Shapes

' move it 36 points (.5 inch) to the right

oSh.Left = oSh.Left + 36

Next

Next
```
Here's the AppleScript version of the same thing:

tell application "Microsoft PowerPoint"

     set oPres to active presentation

     repeat with oSl in (get every slide of oPres)

          set color for (color scheme of oSl) at background scheme ¬

              to color {222, 246, 241}

          repeat with oSh in (get every shape of oSl)

              tell oSh

                   set left position to (get left position) + 36

              end tell

          end repeat

     end repeat

end tell

We skip the Dim declarations of course, and move on to business, using the same variables as the VBA version for clarity, although there is no need in AppleScript to use initial characters of variables, such as "o" , "s" and "l" to remind yourself to use the correct types for Object, String and Long, for example, since it makes no difference in AppleScript. Personally, I like to use variable names that increase the "Englishness" of the statements, such as "thePresentation", "theSlide" and "theShape", unless I'm getting bored with typing long names and might just use "p", "sl" and "sh". It's entirely up to personal taste. Although, when writing scripts to be read by others (or by yourself, some months or years later) using explanatory terms such as "theSlide" and "theShape" helps make the script self-commenting without needing a lot of extra comments, and much easier to follow than the perl-like obscurity of "p" and "s".

Anyhow, this particular macro translates quite easily to AppleScript. colorScheme is a highly unusual class that has no properties whatsoever (such as, e.g., 'background scheme color', 'fill scheme color', etc.) for us to get and set in the normal way – which would be far preferable. Instead (no doubt to do with inheriting the structure from VBA, where ColorScheme.Colors is a Method rather than a Property, with enumerated pp constants as arguments), you have to use the proprietary get color for and set color for commands whose at parameter accesses an identical enumeration of constants: here we use the background scheme constant.

The values for the color need some comment. In VBA, the RGBColor Object is a Long made from an RGB Property of an array of three 0-255 based integers, being an 8-bit Red-Green-Blue composite. In Office AppleScript (meaning Word, Excel, and PowerPoint only here), any property or class whose type is denoted as color wants the same three 0-255 based integers as a list, in list braces: {222, 246, 241}. This is a sort of "Microsoft color" class that ought to be defined as such in the application dictionaries. It is very convenient here when converting VBA macros to AppleScript, because you use the same three numbers for the R, G, B. However, the true Apple-defined RGB color class in AppleScript is a 16-bit RGB list of three 0-65535 integers. If you ever want to transfer a color from Word, Excel or PowerPoint to another Mac application, including Entourage (whose categories have a color property) you would get a completely different color if you used the same three numbers. The way to do it is to square each integer, as in this handy subroutine:

ApplifyMSColor({222, 246, 241})


--> {49284, 60516, 58081}

 

to ApplifyMSColor({r, g, b})

     set r to (r ^ 2) as integer

     set g to (g ^ 2) as integer

     set b to (b ^ 2) as integer

     return {r, g, b}

end ApplifyMSColor

It needs as integer because AppleScript's exponentiation operator ^ produces reals (floating point numbers) that look like 4.9284E+4 when 10000.0 or greater, but these values (all of them 65535 or less) will coerce to integer, which is what the color type requires. In the reverse direction, going from Entourage to PowerPoint, you would get the square root of each 65535-based integer and round down to the nearest integer, which is easily done with the integer division operator div:

set r to (49285 ^ 0.5) div 1

-->222

The coercion as integer would work here too now as of OS 10.4, but not before. If the 65535-based number is not a perfect square, its square root will be a real with a non-zero fractional part: 499285 ^ 0.5 results in 222.002252240828, for example. Before OS 10.4 trying to coerce that sort of real 'as integer' would cause an error, so div 1 was the way to do it, and it works perfectly in all versions of <ac OS X. Back to our script.

Moving the shapes is completely straightforward, as the left position property of shape corresponds exactly to the Left Property in VBA. Note that when getting a property (left position) within a compound statement that will then do something with it in the same line:

set left position to (get left position) + 36

as opposed to setting a variable to it in a previous line, you must use the explicit get. And you must also use the explicit get when using the repeat loop form of repeat with someVariable in someList and you want to use (every element of someObject) as the list instead of setting a variable (someList) to that first.

I used these forms here, with the explicit get, because I know how tempting it is to use the parallel forms of the same expressions you use in VBA. But I actually would advise you to get in the habit of setting variables first to ensure you have evaluated the expressions before you try to operate on them: it is very easy to forget about that explicit get and then wonder why the script keeps erroring "can't get [whatever]".

Before we leave this little script, note that if you want to set the left position of every shape on the slide to the same value (i.e., not relative to its old position, which will be different for each shape), in AppleScript you can avoid the repeat loop entirely, and do it all in one fell swoop:

set left position of every shape of oSl to 100

This is a fantastic boon if you have perhaps 50 shapes on the slide – no looping! (The first few pages of the PowerPoint AppleScript Reference discusses this topic.) Using the every element syntax does not always work (as the developer has to be specifically implement it for an object), but it does here. It can't be done for setting the background of the color scheme because, as you will recall, we were not setting a property there but calling the proprietary command set color for.

Working with Text

Change or Add Text

Text isn‘t limited to text boxes. You can click on most shapes in PowerPoint and start typing text. This is because most (though not all) shapes have a Text Frame. To work with text in shapes programmatically, you start with the text frame. We'll start with a simple macro:

Sub AddSomeText()

' work with the currently selected shape

With ActiveWindow.Selection.ShapeRange

' the shape's "text container" is the TextFrame

With .TextFrame

' unless we specify otherwise, .TextRange refers to

' all of the text in the text frame


With .TextRange

' add some text

.Text = "We can add text to shapes"

End With

End With

End With

 

' or somewhat more compactly

With ActiveWindow.Selection.ShapeRange

.TextFrame.TextRange.Text = "This works too"

End With

End Sub

Most of the example macros here start with that ActiveWindow.Selection.ShapeRange, which we can't replicate in AppleScript. I'm leaving them unaltered in the VBA just to emphasize how often you may need to need to deal with this. Remember that in Office 2008 there should hopefully be a selection property and you would need to replace the line that calls the GetSelectedShape() handler, which won't work then. For now, remember to paste in the GetSelectedShape() handler at the bottom of every script that needs it. I will not include the handler here every time, but they almost all call it, so you'll need it.
```
tell application "Microsoft PowerPoint"

     --get the selected shape via the handler

     set selectedShape to my GetSelectedShape() -- paste it in below!

    

     tell selectedShape

          tell its text frame -- needs 'its'!

              tell its text range -- needs 'its'

                   --unless noted, refers to all the text in the text frame

                   set content to "We can add text to shapes."

              end tell

          end tell

     end tell

    

     --or, more compactly

     set content of text range of text frame of selectedShape to ¬

          "This works too!"

    

end tell
```
All very straightforward. Leave out the final line first time through if you want to see the first text change, as it is replaced by the second one so quickly you won't spot it. Note that using nested tell blocks (corresponding to VBA's With blocks) are useful if there are going to be more commands directed at any of the intermediate targets. Otherwise, for a single command like this one, it's simpler to use the more compact 'of' version. (You can use any combination of tell and of you like: it needn't be all or nothing.) This is a very useful example because it contains two properties – text frame and text range – that are the same term (keywords) both for the property of their containing object and for the class. As explained earlier, and in more detail in the Word and Entourage chapters, that is a bit of a "no-no" for application developers. It means you absolutely have to use its in tell blocks and in whose (where its) clauses. You will notice that with two of them here, if you omit the first its for text frame, the script won't even compile for text range.

Check for Text Frames and Text

Some shapes cannot have text frames (namely lines, arrows, connectors) and in other cases a shape that has a text frame may still cause the macro to throw errors when you try to access the text frame or its text, so some conditional coding and error trapping is always a good idea:
```
Sub TextCaveats()

With ActiveWindow.Selection.ShapeRange


On Error Resume Next

' does it have a text frame?

If .HasTextFrame Then

' does the text frame have any text?

' see if there's any there

' before trying to alter it

If .TextFrame.HasText Then

.TextFrame.TextRange.Text = "And here we are, safely"

End If

End If

End With

 

End Sub
```
becomes:
```
tell application "Microsoft PowerPoint"

     --get the selected shape via the handler

     set selectedShape to my GetSelectedShape() -- paste it in below!

     try -- to avoid error messages if shape has no text frame or no text

          tell selectedShape

              if has text frame then -- does it have one?

                   --if so, does the text frame have any text?

                   if has text of its text frame then -- needs 'its'

                        set content of text range of its text frame to ¬

                            "And here we are safely."

                   end if

              end if

          end tell

     end try

end tell
```
For production work, you would put all the lines, after getting selectedShape, into an IsSafeToTouch(selectedShape) handler, sending it the selectedShape and returning a boolean true, or false under other conditions or on error, before setting the text in the main script. There would be many different places and contexts where you would call this handler before setting different text:
```
     tell application "Microsoft PowerPoint"

     --get the selected shape via the handler

     set selectedShape to my GetSelectedShape() -- paste it in below!

     set check to my IsSafeToTouch(selectedShape)

     if check then

          set content of text range of selectedShape's text frame to ¬


              "Different text depending on context."

     end if

end tell
```
 
```
on IsSafeToTouch(selectedShape)

     tell application "Microsoft PowerPoint"

          try -- to avoid error messages if shape has no text frame or no text

              tell selectedShape

                   if has text frame then -- does it have one?

                        --if so, does the text frame have any text?

                        if has text of its text frame then -- needs 'its'

                            return true

                        else

                            return false

                        end if

                   else

                        return false

                   end if

              end tell

          on error

              return false

          end try

     end tell

end IsSafeToTouch
```
Format the Text Font, Color and Style

Formatting text is quite straightforward, and the AppleScript properties mirror the VBA ones, both in name and function:
```
Sub TextFormatting()

 

With ActiveWindow.Selection.ShapeRange

' work with all the text in the shape

With .TextFrame.TextRange

' Change font formatting

With .Font

.Name = "Arial"

.Size = 24

' make it red

.Color.RGB = RGB(255, 0, 0)

.Bold = True

' and so on

End With

End With

End With

End Sub
```
In AppleScript that becomes:
```
tell application "Microsoft PowerPoint"

     --get the selected shape via the handler


     set selectedShape to my GetSelectedShape() -- paste it in!

     tell text range of text frame of selectedShape

          tell its font

              set {font name, font size, font color, bold} to ¬

                   {"Arial", 24, {255, 0, 0}, true}

          end tell

     end tell

end tell
```
In AppleScript you can set those four properties (or as many as you want) of the font all in one line as a list. Note: This only works in a tell block to the object in question, not in an of format, although you can always get a list of properties using of font.

Working with just portions of the text in a shape

Test out this macro by running it from the UI, via Tools/Macros, rather than in the VBE Editor, so you can see what's going on as it runs. Don't use text that's too long because you're going to get a new MsgBox for every character in the first part. There are four parts: the first part makes every second character blue after flashing each character in a MsgBox; the second turns each word a different shade of green after flashing each word; the third displays each complete "run" of formatted text with the Long representing its RGB value; and the fourth just displays an arbitrary portion of the text : 6 characters starting from character 3.
```
Sub WorkWithPartOfText()

 

Dim x As Long, g As Long

With ActiveWindow.Selection.ShapeRange.TextFrame.TextRange

' access one character at a time

For x = 1 To .Characters.Count

MsgBox .Characters(x)

                ' make every second character blue

' if x divided by 2 = x mod 2 ...

If x / 2 = x \ 2 Then

.Characters(x).Font.Color.RGB = RGB(0, 0, 255)

End If

Next

' or a word at a time:

g = 0

For x = 1 To .Words.Count

MsgBox .Words(x)

'make every word a different shade

g = g + 100

If g > 255 Then g = 0

.Words(x).Font.Color.RGB = RGB(0, g, 100)

Next

' or a "run" at a time

' every change in formatting starts a new run

' if the number of runs in a textrange is 1,

' you know that all of the text

' in the range is formatted identically.

For x = 1 To .Runs.Count

' For each run, display the text and the Long that

' represents the text's RGB color

MsgBox (.Runs(x).Text & " - " & .Runs(x).Font.Color.RGB)

Next

 

' or arbitrary selections of text

' 6 characters starting at position 3, for example

MsgBox .Characters(3, 6)

 

End With
```
Again, this is mostly very straightforward in AppleScript, with just one or two adaptations needed, mentioned at the end:
```
tell application "Microsoft PowerPoint"


     --get the selected shape via the handler

     set selectedShape to my GetSelectedShape() -- paste it in below!

    

     tell text range of text frame of selectedShape

          repeat with i from 1 to count (characters)

              display dialog (get content of character i)

              --make every second character blue

              if i / 2 = i div 2 then

                   set font color of font of character i to {0, 0, 255}

              end if

          end repeat

         

          set g to 0

          repeat with i from 1 to count words

              display dialog (get content of word i)

              --make every word a different shade

              set g to g + 100

              if g > 255 then set g to 0

              set font color of font of word i to {0, g, 100}

          end repeat

         

          set AppleScript's text item delimiters to {", "}

          repeat with i from 1 to (count text flows)

              set theRun to text flow i

              display dialog (get content of theRun) & " - {" & ¬

                   font color of font of theRun & "}"


          end repeat

          set AppleScript's text item delimiters to {""}

         

          display dialog (text 3 thru 8 of (get content))

         

     end tell

end tell
```
First up is something rather trivial, but it could cause you a bit of confusion. I had to change the counter in the repeat loop from x to i : it seems that x and y are defined somewhere in the PowerPoint dictionary (it turns out to be as constants of an enumerated property property of the property effect class, used for animation behavior). That means they will not compile as variables: you get an AppleScript Syntax Error: " Expected variable name or property but found application constant or consideration." A most unfortunate choice of constant name.

Next, all those "compound" lines where a display dialog command is targeted at the content of the text frame require an explicit get before content, or they raise the peculiar error "Can't make content of text frame…into a string" which could make you think that the problem is with the Unicode text that PowerPoint uses. But no – display dialog has accepted Unicode text since Panther, although it used to be an issue previously. (Also coercing 'as string' works which would seem to confirm that impression, but that's just because the coercion forces an evaluation, like get does.)

A distinct difference of display dialog, as opposed to VBA's MsgBox, is that you definitely need to get the content property of character, word, text flow, etc. display dialog will error if you try to get it to use the object reference itself. (This is another instance of VBA objects often having Default properties – in this case Words(Index), etc., in VBA returning a TextRange with a default Text property, while Applescript, which does not have default properties, having to explicitly get the content of word i, etc.) Over in VBA, a coercion (along with the default property) allows you to MsgBox (and Debug.Print too), a Character, Word and Run without casting them to string explicitly. Both MsgBox and display dialog accept numbers, however (display dialog only since OS 10.4), and coerce them to string for you.

Finally, when getting the color of the font (or of anything else) in AppleScript, it is not returned as a single number (Long) as in VBA: a list of three integers is returned. That's all very well, but display dialog cannot display lists. Since we precede the list {0, 200, 100} by a string, the concatenation operator & coerces the list to a string implicitly without our having to write 'as string'.

When lists of strings are coerced to a string, explicitly or implicitly, text separators are inserted between the list items: these are AppleScript's text item delimiters, a language global. The default delimiter is "", i.e., nothing is inserted between the list items. So if we didn't change the delimiter to something visible a list of three integers such as {0, 200, 100} would coerce and display as "0200100". Using ", " as the delimiter, we get "0, 200, 100" and if we add brace characters "{", "}" around that string we get "{0, 100, 200}" which looks exactly like a list in display dialog. After using them we must restore the text item delimiters to what they were before, or to the default {""} since they remain active in the application running the script, for all other scripts too (at least in Script Editor, and in all script menus, although not in Script Debugger) until you change them again. Incidentally, they are theoretically a list of delimiters which is why list braces {""}, {", "}, etc. are used around them, but in actual fact only the first list item is used and you can omit the braces if you wish.

Masters and Properties

Working with masters

Masters are really just a special case of slide objects, for all intents and purposes. For example, to add a new rectangle shape to the master of the currently selected slide, in VBA:
```
Sub AddShapeOnMaster()

 

With ActiveWindow.Selection.SlideRange

   ' Make a new shape in the slide's Master instead of the slide itself

Call .Master.Shapes.AddShape(msoShapeRectangle, 10, 20, 30, 40)

End With

End Sub
```
Here's the AppleScript equivalent:
```
tell application "Microsoft PowerPoint"

     --get the selected slide: make sure slide pane is active

     set theIndex to slide index of slide of view ¬

          of active window

     set selectedSlide to slide theIndex of active presentation


    

     --no 'master' property of slide, get slide master of presentation

     set theMaster to slide master of active presentation

     make new shape at theMaster with properties {auto shape type:¬

          autoshape rectangle, left position:10, top:20, width:30, height:40}

    

end tell
```
Remember that you need to click anywhere in the Slide pane, if you're in Normal view, to make it active (have the focus) before you run the script, since slide of view doesn't exist, and will cause the next line to error otherwise. If you specify a slide other than by selection, this is not an issue, of course.

Now there's a new problem: The dictionary has no master property of slide class corresponding to the .Master you see in VBA. (Honestly, I don't know what they were up to.) However the master of any slide in a presentation is the same as the slide master property of the presentation — which, fortunately, we do have. Obviously, the presentation of the selected slide (there's no actual property for that either) has to be the active presentation – otherwise it couldn't be selected.

If you look up the VBE Help for Shape (you probably knew this already), you will see that the AddShapes Method adds an AutoShape, specified by a particular MsoAutoShapeType constant, plus four integers to describe its position and size: Left, Top, Width, Height. That's what the VBA code above is specifying.

In the shape entry in the dictionary (Drawing Suite), you will find an auto shape type property, which is read/write. Taking a look at it (click the link of its 'type', also auto shape type), you see a long enumerated list of constants that looks very similar to the MsoAutoShapeType enumerated contacts in the VBE Help and Object Browser. Furthermore, it includes an autoshape rectangle constant. Meanwhile the separate shape type enumerated property of shape class has nothing equivalent – nothing that even mentions rectangle. So it's pretty clear that auto shape type enumeration is the one you want, in particular the autoshape rectangle constant.

For the other properties needed for make new shape, it's obvious that left position, top, width and height are the ones you want, Try them out. The script works perfectly. Now insert a new slide: the same rectangle appears. You have been successful in adding a shape to the slide master.

You may be aware that you can have multiple masters, called Designs, in the UI of PowerPoint 2004 (and later). (Check the Help for more information.) On Windows, the Designs Collection has been incorporated in PowerPoint VBA since PPT 2002 – that's three versions now. Unfortunately, it has never made it into PowerPoint Mac. Since the AppleScript model is (with some significant gaps, as we have seen) a port of the VBA Mac Model, it's not in AppleScript either.

What you can do is apply a Design to a presentation from a template by using the apply template command, equivalent to the ActivePresentation.ApplyTemplate (FileName) method in VBA. If the template (represented by the file name parameter) has multiple designs then presumably they will get applied: you just can't verify afterwards the Designs you now have.

If you receive some PowerPoint macros from Windows users that contain references to Designs, you cannot run them in PPT 2004, nor implement the equivalent in AppleScript. Up until now (Office 2004), you would have to omit them from your VBA macros and, for the time being, from your scripts too. Perhaps there is a way to work around the problem using slide master. But there is a chance that Designs, and brand new features in Office 2008 too, will soon become scriptable, unrelated to the VBA in older versions. The AppleScript model is now poised to move ahead on its own. So do look out for Designs, and other AppleScript classes and commands, in Office 2008.

Working with Document Properties

PowerPoint and the other Office applications maintain a set of document properties that contain useful information. To access any of these properties, you need to know the name of the property you're looking for. This macro will give you a list of them:
```
Sub ListBuiltInProperties()

Dim x As Long

On Error Resume Next

Debug.Print "BEGIN ===================================="

With ActivePresentation.BuiltInDocumentProperties

For x = 1 To .Count

Debug.Print "Property Number: " & CStr(x)

Debug.Print "Property Name: " & .Item(x).Name

Debug.Print "Property Value: " & .Item(x).Value

Next

Debug.Print "END ===================================="

End With

End Sub
```
Here's the AppleScript equivalent:
```
tell application "Microsoft PowerPoint"

     set theLog to "BEGIN =============================" & return


     set allDocProps to every document property of active presentation

     repeat with i from 1 to count allDocProps

          set theDocProp to item i of allDocProps

          set theLog to theLog & "Property Number: " & i & return

          set theLog to theLog & "Property Name: " & name of theDocProp & return

          set theLog to theLog & "Property Value: " & value of theDocProp & return

     end repeat

     set theLog to theLog & "END =========================" & return

end tell
```
theLog

Note that document property refers just to the built-in ones, although there's no "built in" in the name of the AppleScript class. Since, in AppleScript, document property is an element of the application, every document property gets all of them. (There appear to be 30.) This class is found in the Microsoft Office Suite, in all the Office applications. Adding some Custom properties in the UI does not add them to every document property. It should add them to the separate list of custom document properties. However, trying every custom document property does not get them either. That's a bug.

Once you know the name of the property you're looking for, you can work with it. To display the value of a particular DocumentProperty, Template for example, in VBA:
```
With ActivePresentation

MsgBox .BuiltInDocumentProperties("Template").Value

End With
```
The AppleScript equivalent is:
```
tell application "Microsoft PowerPoint"

     set templateValue to get value of document property ¬

          "Template" of active presentation

     if templateValue ≠ missing value then

          display dialog templateValue

     else

          display dialog "There is no Template: this presentation is " & ¬

              "based on a Blank New Presentation" with icon 2

     end if

end tell
```
The template property value seems to be missing value (i.e., doesn't exist) whenever your presentation is not based on a template you have created or imported into your My Templates folder (or a subfolder of Templates folder) by selecting it in the Project Gallery. This is true also in VBA, but there you get a blank MsgBox. In AppleScript, you get an error message, so it's nicer to trap the error and provide a better message dialog.

"Template" is a read-only property; you can't change it. Other properties like "Author" are read/write. To change the value of a read/write property in VBA, you'd do:
```
With ActivePresentation

.BuiltInDocumentProperties("Author") = "Your Name Here"

End With
```
It should have your name by default already (all Office applications know to look in the Entourage Address Book for the "Me" contact and use your name there for the Author document property.) But if you want a fancier version, say for business purposes, here's the AppleScript you could run on every commercial presentation you make and send out:
```
tell application "Microsoft PowerPoint"

     set value of document property "Author" of active presentation to ¬

          "Joe Blow, King of the World"

end tell
```
In the UI, go now to File/Properties/Summary, and you'll see it there loud and clear. (Don't worry, you can change it back…)

In Summary

You need to constantly compare the VBA Objects, Properties, and Methods to the classes, properties, elements, and commands in the AppleScript dictionary to try to work out which are equivalent. You can only do that now, in Office 2004, since the VB Editor will not exist in Office 2008. Your job is much harder in PowerPoint than in Word and Excel, since the PowerPoint dictionary seems to be missing a good third or so of the classes and properties you may need. But if you think creatively, you will often find workarounds. Of course, there's always the next version to look forward to, where hopefully many of these gaps will be filled.


