3. Word

Word VBA Macros to AppleScript

Make sure you have read Chapter 2: AppleScript in Microsoft Office (General) first. It deals with many important features of VBA, including Word VBA, that need to be treated very differently in AppleScript, as well as some equivalent control and operator statements in AppleScript you need to know. All examples in that chapter, as it happens, are for Word.

This chapter consists of typical, and popular, subroutines (macros) in VBA, and their equivalent in AppleScript, with comments as necessary to explain differences in the AppleScript approach. Almost all the examples come from

<http://www.word.mvps.org/FAQs/MacrosVBA/>

(Note: If you are using Safari as your browser, the page may come up blank initially. Refresh the page a few times to see it, and you may need to do the same for other www.word.mvps.org links.) Jonathan West, Word MVP, who also wrote some of them, suggested all the examples.

Note: when testing out scripts in Script Editor, you may wish to begin every one with an activate command on its own line just inside the tell application "Microsoft Word" block, as its first line. That will bring Word to the front so you can see what is happening. It is not necessary to include activate when running saved scripts from the script menu while Word is in the front (and there may be other occasions when you are running a script from elsewhere and don't want Word to come to the front). I have not included activate in the sample scripts here, but you may wish to do so.

Before launching into scripting Word, it is a good idea to read the introductory section Using the Word Dictionary and especially the section Working with text range objects on p.18, of the Word AppleScript Reference available in PDF format free from Microsoft at <http://www.microsoft.com/mac/resources/resources.aspx?pid=asforoffice>. Although it is largely aimed at AppleScripters unfamiliar with Word's Object Model rather than vice versa, it is full of useful knowledge for all scripters of Word.

Remember that this article was written while Office 2004 is current: some problems with Word 2004's AppleScript discussed here may be fixed in Word 2008 and workarounds provided here may no longer be needed there.

Note that although the class name in AppleScript for VBA's Range Object is text range (in the Text Suite), the name of the property corresponding to the Range Property in countless classes is almost always called text object (returning an object of text range class). Similarly the font class is the "type" of the font object property in other classes. There is a very good reason why application developers avoid using the same name for a class as for a property, which is explained below in the Find and Replace Text section, and in more detail in Chapter 6: Entourage.

Also very important to understand, since you may have to work around it in your scripts, is that text ranges you define are not "dynamic": you can manipulate them at will, but if you change their start or end positions or their content, the variable you may have set to the range will now not return the altered range, and you need re-set the variable to the result returned, if it is the altered range, or get hold of it some other way.

This is an unfortunate by-product of how Range had to be implemented in AppleScript, and may be a thorn in your side when you come to convert your macros, but there is virtually always some way to work around the changes. Two sections below – Delete duplicate paragraphs using a Text Range object and Working with Bookmarks – both go into this issue in some detail, with examples.

New Document , Open Document, and Templates

Make a New Document

Just a reminder, already mentioned in Chapter 2, that the way to make a new blank document equivalent to

      Application.Documents.Add

is

make new document

Normally in AppleScript, you would expect to be able to specify many, or most, of the properties of document in a with properties parameter, right at creation time, as in Chapter 2's example of making a new table at a document. (A scripter would expect that only elements, if any are needed, would have to be added afterwards.) But that is not the case with making new documents in Word: properties cannot be set at inception of the document, which needs to be created first before they can be altered.

This seems to be an "Office special" and corresponds with how the Add Method works, so should not surprise people accustomed to VBA, although it would surprise a regular AppleScripter accustomed to other applications. In the same way that in VBA the only arguments that can be specified with Documents.Add are Template, NewTemplate, DocumentType, Visible (more on templates in a moment), but not any of the 50 or so Properties of Document itself, which are specified later, so it is with AppleScript.

For example, in VBA, to set the font and a bit of content, you would do this:

Set NewDoc = Documents.Add

With NewDoc.Content

      .Font.Name = "Arial"

      .Text = "Here is some Text."

End With

An AppleScripter would expect to be able to do this:

tell application "Microsoft Word"

     set newDoc to make new document with properties {text object:¬

         {font object:{name:"Arial"}, content:"Here is some text."}}

end tell

(Even though text object is listed in the dictionary as read-only, such properties can usually be set at inception.) But all you get is a blank new document if you try it that way. Instead, you need to do it "VBA-style", setting properties of the document's text object after the fact:

tell application "Microsoft Word"

     set newDoc to make new document

     tell newDoc's text object

          set name of font object to "Arial"

          set content to "Here is some text."

     end tell

end tell

What about those four arguments that can be set with VBA's Documents.Add? I doubt you will ever run into .Visible = False in a macro, but if you should, you won't be able to make an invisible document in AppleScript. You can set the collapsed property of the document's window 1 to true if you wish, which minimizes it, once you have created the document.

You cannot preset a new document to be a template (which is what the NewTemplate argument does if set to True in VBA) but you certainly will be able to save a new document as a template later, using the save as command with its file format parameter set to template, so this does not present any problem. When converting a macro that has NewTemplate:=True, just ignore that in AppleScript and use save as file format format template when saving.

Similarly, the only value for DocumentType other than the default of wdNewBlankDocument (which can just be ignored, since it's the default) that works on the Mac is wdNewWebPage, so, once again, if you should happen to run into DocumentType:= wdNewWebPage, just ignore it and save as file format format HTML when saving. You can also set its view to Online View just after making the document:

     set view type of view of window 1 of newDoc to online view

Making a Document from a Template

Now, the one thing you really need to be able to do is to make a new document from a template, equivalent to the Template argument of the Add Method. Even if it doesn't work in a with properties parameter to make new document (which would be nice) you ought to be able to set the attached template property (which is not read-only) of the new document to any template you wish, like this:

tell application "Microsoft Word"

     set newDoc to make new document

     set attached template of newDoc to "Mac HD:Applications:" & ¬

     "Microsoft Office 2004:My Templates:Test Template.dot"

     get name of attached template of newDoc

end tell

Note: when the dictionary says you can provide the "name" of the template, it means the full path. For this article I had to "break up" the path into shorter bits so as not to introduce hard carriage returns in the published version, but you don't need to do this – just enter the whole colon-delimited path of a template. Or type POSIX file "" as alias as Unicode text in Script Editor and drag the file to between the quotes. (Script Debugger makes this even easier by offering a choice of reference types, including "HFS path": just drag the file, with no typing required.)

That will compile and run, and you will even see the correct name (just the name this time: "Test Template.doc") as the result if you include that last line. But nothing changes in the document: no styles, no macros are added. It's a bug in Word 2004. We have been assured that the bug will be fixed in Word 2008 without fail, and that even

make new document with properties {attached template:"Mac HD:" & ¬ "Applications:Microsoft Office 2004:My Templates:Test Template.dot"

will work then.

If it doesn't, there is a workaround suggested by Jonathan West, that works pretty well. After setting the attached template, we insert it using insert file. That gets the text, including headers and footers, the styles, and (in 2004) the macros. All it is missing is the page setup – the margins, line spacing, and so on. If the template uses different settings than your Normal template, including larger header space, for example, you can take the workaround further with more code that opens the template for an instant as a document so as to be able to retrieve its page setup settings.

Be ware that when you set an attached template to a document, you will get the Macro Alert warning if your Preferences have that option checked in Security preferences and your template contains macros. (It looks as if you could turn that off temporarily via the automation security property in application, but that doesn't seem to work, which is probably a good thing. It's probably not a bug, but an intentional security feature. They ought to remove it rather than disable it, however.) Of course this should not be an issue in Office 2008 where macros won't work anyway.

Here's the workaround:

set templatePath to "Mac HD:Applications:" & ¬

     "Microsoft Office 2004:My Templates:Test Template.dot"

tell application "Microsoft Word"

     set newDoc to make new document

     set attached template of newDoc to templatePath

     insert file at text object of newDoc file name templatePath

end tell

Since we need to use the template path twice we set a variable templatePath to it. If you want to include the page setup settings (the margins, etc.) – a good idea – use the following longer version. It feels like a bit of a hack to have to open the template, but it's so instantaneous that you may not even notice it (its text is the same as the document will have a moment later):

set templatePath to "Mac HD:Applications:" & ¬

     "Microsoft Office 2004:My Templates:Test Template.dot"

tell application "Microsoft Word"

     activate

     set newDoc to make new document

     set attached template of newDoc to templatePath

    

   set theTemplate to attached template of newDoc -- a template object now

     set editableTemplate to open as document theTemplate -- a document

     set pageSetupProps to properties of (get page setup of editableTemplate)

     set lineNumberProps to properties of (get line numbering of pageSetupProps)

     close editableTemplate saving no

     tell page setup of newDoc

          set its properties to pageSetupProps

          tell its line numbering

              set its properties to lineNumberProps

          end tell

     end tell

       end tell

  

     insert file at text object of newDoc file name templatePath

end tell

There are a few interesting lines in this longer version. The open as document command opens a template as a document, so now all of document's properties, including page setup, are available. The next line gets a very special property of page setup (and of almost all classes in all the Office applications) – the properties property. That returns a record of all its properties. It's not only very efficient, sending just one AppleEvent instead of 30 separate ones, but it saves having to specify each one in the script and set a variable to each.

One of page setup's properties is a reference – its line numbering property – so we get all its properties too. Otherwise when we try to set another document's page setup properties to this properties record, it would balk at being set to another document's item. Then we close the template, having garnered from it all the information we need.

Then comes the rather amazing bit – being able to set newDoc's page setup's properties to the variable containing the whole properties record, and the same for the line numbering properties. The reason why it's amazing – aside from saving us the trouble and effort of specifying 30 properties by 30 more variables – is that the 30 properties contain one – the class – that's read-only. Fortunately that doesn't error but is just ignored. (The class is already correct in any case.) It's just the same for the line numbering properties. Then we insert the template file, and everything is as it should be.

Still, it may be a nuisance to have to turn off the macro alert warning, or to have to put up with it, while still using Word 2004, and you may not like the template opening up either. So for now, while still in 2004, you could use a completely different workaround, which will not work in Word 2008 but should not have to.

You can substitute:

do Visual Basic "Documents.Add Template:=\"Mac HD:" & ¬

"Applications:Microsoft Office 2004:My Templates:Test Template.dot\""

for the make new document with properties statement, and your scripts converting macros that use Documents.Add Template will work in Word 2004. Of course, the do Visual Basic command will stop working in Word 2008, along with VBA itself (it too needs the VBA compiler), and you'll need to switch over to native AppleScript at that time.

If all goes according to plan something like this should even work both now and then (if compiled and saved now, in 2004):

tell application "Microsoft Word"

     try

          do Visual Basic "Documents.Add Template:=\"Mac HD:" & ¬

              "Applications:Microsoft Office 2004:My Templates:Test Template.dot\""

     on error

          make new document with properties {attached template:¬

              "Mac HD:Applications:" & ¬

              "Microsoft Office 2004:My Templates:Test Template.dot"}

     end try

end tell

But it's better to wait until the new version comes out and then test it. After all, you will probably have a new location for your template then – it's not likely to still be in the Microsoft Office 2004 folder. The do Visual Basic command, in a script saved from 2004, might not error, it might just not do anything. If you try to compile or edit it in 2008, it probably will not even compile. The syntax for setting the template of the document may well turn out to be different than anticipated here. So just consider this a workaround for 2004. Check it out properly when the time comes, in Word 2008.

Open an Existing Document

It's a relief to say that opening an existing document is dead simple in AppleScript. The equivalent of the Open Method in VBA:

   Documents.Open FileName:="Mac HD:Folder:Filename.doc"

is the open command (in the Standard Suite) in AppleScript:

tell application "Microsoft Word"

     open alias "Mac HD:Folder:Filename.doc"

end tell

Note that you should properly use the alias reference form, but the Word developers have enabled a coercion allowing you to use just the path text as an equivalent, just as in VBA. Also, in AppleScript, you can open a list of documents all at once if you wish.

Sometimes we are interested not just in opening a document, but also in modifying it, or getting some information from it, of course. In VBA, that is very straightforward: you just set a variable (reference) to the result of the Open statement, which returns a Document object, and then set some Properties of it or apply some Methods to it:

Dim oDoc As Document

Set oDoc = Documents.Open FileName:="Mac HD:Folder:Filename"

With oDoc

.HyphenationZone = InchesToPoints(0.25)

.HyphenateCaps = False

.AutoHyphenation = True

End With

The process of setting a variable to the result of a command is usually straightforward in AppleScript too. However, the command open from the Standard Suite does not return a result, so you cannot set a variable to the command. The commands in the Standard Suite are derived from a model supplied by Apple, who strongly advise all applications to use the Standard Suite as far as possible to maintain a consistency to the language.

It is possible for applications to add their own parameters to commands of the Standard Suite, and Word adds a great many, in fact 10 of them, all derived from VBA's Open. But they cannot alter the behavior that open does not return a result. They would have done far better to do what Excel does – leave the plain open command in place without parameters, and also give Word its own 'open document' command with all the parameters, that would return a result.

Here is a workaround that seems likely to be successful:

tell application "Microsoft Word"

     open " Mac HD:Folder:Filename.doc"

     set theDoc to active document

     tell theDoc

          set hyphenation zone to (inches to points inches 0.25)

          set hyphenate caps to true

          set auto hyphenation to true

     end tell

end tell

We open the document and then set our variable to active document – the document in the front. The open command always opens the file in the front of the application, so this works if the document was not already open. If the document already is open, however, it does not come to the front, and you will be acting on the wrong document. So here's the full workaround you need:

tell application "Microsoft Word"

     try

          set theDoc to document "Filename.doc"

     on error

          open "Mac HD:Folder:Filename.doc"

          set theDoc to active document

     end try

     tell theDoc

          set hyphenation zone to (inches to points inches 0.25)

          set hyphenate caps to true

          set auto hyphenation to true

     end tell

end tell

It still makes me nervous though – theoretically there might some problem along the way. But it works, and is what we have for now. When Office 2008 arrives, do check in the Microsoft Word Suite to see if there is an 'open document' or similarly named command that returns a result, and also check open in the Standard Suite just in case, as well.

Working with Collections

As explained in Chapter 2, AppleScript does not have Collection Objects as such. You simply get the plural (a list) of any class. You will note that the dictionary always gives the plural if there is one: very, very rarely, there is no plural, and then you can‘t get a list. This is only the case for those rare classes where there is only one such object, such as application or selection. In all other cases, the class is an element of another class (and is so denoted by that "Contained by" reference in the dictionary), either of the application itself or of another class.

The canonic synonym, usually used in preference to the plural, is every [class name], which means the same thing. The usual For Each loop in VBA iterating through every member of a collection translates to a repeat loop in AppleScript, as explained in Chapter 2. (You get a choice between repeat with someObject in (every element) or repeat with i from 1 to (count every element).)

Unlink Fields

First, here is a simple VBA macro operating on the Fields Collection, with a simple translation to AppleScript via a repeat loop on a list:

For Each oField In ActiveDocument.Fields
    oField.Unlink
Next oField

becomes

tell application "Microsoft Word"

     set allFields to (every field of active document)

     repeat with oField in allFields

          unlink oField

     end repeat

end tell

That works. Here follows a small side-issue, which you can skip if you're not interested in the reasons why it can't be optimized further: It would be reasonable to hope that we could optimize this by using AppleScript's ability to have commands act on a whole list at once (see the last section of Chapter 2) and avoid the tedious repeat loop:

tell application "Microsoft Word"

     unlink (every field of active document)

end tell

…but having a command act on a list does not always work: the application developers need to have implemented it. In this case it does not work: you get an error, even when using the explicit get or a variable, that "{field 1 of active document, field 2 of active document, …} does not understand the unlink message." If you check the document, you'll see that the first field was in fact unlinked, but no others: it's just that the unlink command has not been implemented to work on lists. In most cases in Word, Excel and PowerPoint, unlike Entourage, that will be the case. The commands mostly mirror the VBA Methods from which they have been derived, which do not know anything about lists. It's too bad, but outside a few exceptions you might come upon, you'll have to use repeat loops.

In the repeat loop example above that does work, you first need to set a variable (allFields) and refer to that. If you instead try the following, without a variable, even with the explicit get:

     repeat with oField in (get every field of active document)

          unlink oField

     end repeat

you will get an error that some field "does not understand the unlink message". That's because the fields keep getting re-indexed as they get unlinked, skipping every second one, until the index is larger than the number of fields left. You‘d have to do it this way instead:

tell application "Microsoft Word"

     repeat with i from (count (get every field of active document)) to 1 by -1

          set oField to item i of (get every field of active document)

          unlink oField

     end repeat

end tell

Not only would you need to use the explicit get, but you would need the repeat with i from format (nothing wrong with that) backwards from the last item to the first by –1 (also OK) and – if you insist on avoiding a variable – would have to (get every field of active document) twice, sending an AppleEvent each time. That is not a good idea, is unnecessary, wasteful and slow. Just use a variable (like allFields) as in the first version above or with a repeat with i syntax if you prefer:

tell application "Microsoft Word"

     set allFields to (every field of active document)

     repeat with i from 1 to (count allFields)

             set oField to item i of allFields

          unlink oField

     end repeat

end tell

That also works. End of digression.

Unlink Header Fields

Here's another unlink macro (by Word MVP Bill Coan) that unlinks every header and footer in the document:

Dim oField As Field

Dim oSection As Section

Dim oHeader As HeaderFooter

Dim oFooter As HeaderFooter

 

For Each oSection In ActiveDocument.Sections

 

    For Each oHeader In oSection.Headers

        If oHeader.Exists Then

            For Each oField In oHeader.Range.Fields

                oField.Unlink

            Next oField

        End If

    Next oHeader

 

    For Each oFooter In oSection.Footers

        If oFooter.Exists Then

             For Each oField In oFooter.Range.Fields

                 oField.Unlink

            Next oField

        End If

    Next oFooter

 

Next oSection

 

Now in VBA this looks awfully similar to the first example – it unlinks fields in the Ranges of headers and footers rather than in the main body of the document. However, it is completely different in AppleScript, due to the facts that 1) there are no collection objects and 2) this time we cannot create a list of headers and footers either since the header footer class is not an element of any other class, not even of section as you might expect, and the method of getting hold of these objects is much trickier.

It probably comes down to the fact that in AppleScript you cannot have read-only elements, although you can of course have read-only properties. By definition, an object can have 0 to infinite number of elements, and all you have to do to get a new one is to make new element at someObject and hey, presto, you've got another one. Word's Object Model (and Excel's and PowerPoint's too) has many Collection Objects that have no Add Method – you cannot make a new one, you just take what you're given.

The HeaderFooters Collection Object of each document Section is one of those: it has only (at a maximum) three Headers (representing the Primary, First Page and Even Pages Headers) and three Footers (same). You cannot add your own. Fair enough.

Therefore, in AppleScript, header footer objects cannot be elements of section since if they were you could make oodles of them. They have to be self-standing objects (the dictionary says they are inherited from base object) divorced from the Object Model, which is a shame. You get them by using the get header and get footer proprietary commands rather than, say, header footers of section 1 of active document.

You also need to specify an "index" parameter to specify which header or footer you want. That is similar to VBA's Headers and Footers Properties of Section when used with an index. i.e.

   ActiveDocument.Sections(1).Headers(wdHeaderFooterPrimary)

corresponds exactly to

get header (section 1 of active document) index header footer primary

So far so good. But there's no easy way to get every header or every footer, nothing equivalent to

   ActiveDocument.Sections(1).Headers

in the macro above. We have to go get each one – all 6 headers and footers – by index. We could perhaps run each one through a handler to get its text object (Range) and fields, or we can just accumulate them all together in a list (by putting each into a single-item list framed by list braces) and concatenating these lists together, then run a repeat loop on the list, as this version does:

tell application "Microsoft Word"

          set theSections to every section of active document

     repeat with theSection in theSections

          set theHeaderFooters to {get header theSection index ¬

              header footer primary} & {get header theSection index ¬

              header footer first page} & {get header theSection index ¬

              header footer even pages} & {get footer theSection index ¬

              header footer primary} & {get footer theSection index ¬

              header footer first page} & {get footer theSection index ¬

              header footer even pages}

          repeat with theHeaderFooter in theHeaderFooters

              set theFields to every field of text object of theHeaderFooter

              repeat with theField in theFields

                   unlink theField

              end repeat

          end repeat

     end repeat

end tell

One thing you may notice is that we don't have to run an exists test on the header footers as in VBA. In the VBA model, only primary headers and footers exist by default (even if they are empty): you have to check whether 'first page' and 'even pages' varieties (constants wdHeaderFooterFirstPage, wdHeaderFooterEvenPages) exist. In AppleScript, because get header and get footer can apply header footer first page and even pages as parameters and get a result, all of them exist by default, even if empty. So the script above works. There are no problems with empty lists for theFields when the text object of theHeaderFooter has none.

You will need to be on the lookout for other classes, which are not elements of another class, nor part of a friendlier object oriented model, but are only available as the result of a proprietary command. There are quite a few of these around.

Find and replace text

A very common activity in Word macros is finding and replacing text. (There was an example already in Chapter 2: tell blocks.) Unlike the ordinary Find/Replace dialog in the User Interface, Word's VBA only finds and replaces within a specific part of a document (e.g. the main body, a header, a text box). If you want to do a global find/replace everywhere in a document including headers, footers and textboxes, you need to do something like this, as in a macro by Word MVP Jonathan West:

Sub ReplaceEverywhere(FindText As String, ReplaceText as String)

Dim oSection As Section

Dim oShape As Shape

Dim oHF As HeaderFooter

 

ReplaceInRange FindText, ReplaceText, ActiveDocument.Content

For Each oShape In ActiveDocument.Shapes

If oShape.TextFrame.HasText Then

ReplaceInRange FindText, ReplaceText, oShape.TextFrame.TextRange

End If

Next oShape

For Each oSection In ActiveDocument.Sections

For Each oHF In oSection.Headers

ReplaceInRange FindText, ReplaceText, oHF.Range

For Each oShape In oHF.Shapes

If oShape.TextFrame.HasText Then

ReplaceInRange FindText, ReplaceText, _

             oShape.TextFrame.TextRange

End If

Next oShape

Next oHF

For Each oHF In oSection.Footers

ReplaceInRange FindText, ReplaceText, oHF.Range

For Each oShape In oHF.Shapes

If oShape.TextFrame.HasText Then

ReplaceInRange FindText, ReplaceText, oShape.TextFrame.TextRange

End If

Next oShape

Next oHF

Next oSection

End Sub

 

Sub ReplaceInRange(FindText As String, ReplaceText as String, _

      oRange as Range)

With oRange.Find

.Format = False

.Text = FindText

.Replacement.Text = ReplaceText

.Wrap = wdFindStop

.Execute Replace:=wdReplaceAll

End With

End Sub

Here is the exact AppleScript equivalent:

on ReplaceEverywhere(findText, replaceText)

     local theShape, theRange, theHeaderFooters, theHeaderFooter

     tell application "Microsoft Word"

          --first find and replace in the body (main story) of document

          set theRange to text object of active document

          my ReplaceInRange(findText, replaceText, theRange)

         

          --now in all shapes

          set allShapes to (every shape of active document)

          repeat with theShape in allShapes

              set theTextFrame to (text frame of theShape)

                  if has text of (text frame of theShape) then

                   --note: 'text range', not 'text object' of text frame

                   set theRange to text range of text frame of theShape

                   my ReplaceInRange(findText, replaceText, theRange)

              end if

          end repeat

         

          -- now in the headers and footers of each section

          set allSections to every section of active document

          repeat with theSection in allSections

              set theHeaderFooters to {get header theSection index ¬

                   header footer primary} & {get header theSection index ¬

                   header footer first page} & {get header theSection index ¬

                   header footer even pages} & {get footer theSection index ¬

                   header footer primary} & {get footer theSection index ¬

                   header footer first page} & {get footer theSection index ¬

                   header footer even pages}

 

              repeat with theHeaderFooter in theHeaderFooters

                   set theRange to text object of theHeaderFooter

                   my ReplaceInRange(findText, replaceText, theRange)

                  

                   --now in their shapes

                   set allShapes to (every shape of theHeaderFooter)

                   repeat with theShape in allShapes

                        if has text of (text frame of theShape) then

                            --note: 'text range', not 'text object' of text frame

                            set theRange to text range of text frame of theShape
                            
                            my ReplaceInRange(findText, replaceText, theRange)

                        end if

                   end repeat

              end repeat

          end repeat

     end tell

end ReplaceEverywhere

 

 

on ReplaceInRange(findText, replaceText, theRange)

     tell application "Microsoft Word"

          set findObject to find object of theRange

          tell findObject

              set format to false

              set content to findText

              set content of its replacement to replaceText

              set wrap to find stop

          end tell

          execute find findObject replace replace all

     end tell

end ReplaceInRange

Two things to note here: you'll see that in the ReplaceInRange handler that does the work for each range, we have used a tell block to the findObject (the find object property of the text range) as explained in Chapter 3.

But whereas in VBA the Execute Method could also be placed inside the "With" block, just like all the Properties, the equivalent thing does not at first seem to work with the execute find command in AppleScript even though it takes the same direct parameter (findObject) as well as the properties. It works fine when placed outside the tell block and findObject specifically referenced as the direct parameter. Commands whose direct parameter is the target of a tell block should act on the targeted object without problem, but AppleScript seems to be a little confused. In fact, you can place execute find inside the tell block if you include the term 'it' to make it clear what the direct object is:

          tell findObject

              set format to false

              set content to findText

              set content of its replacement to replaceText

              set wrap to find stop

              execute find it replace replace all
                   end tell

The second thing is that the text frame class (in the Drawing Suite) has a text range – not text object – property to represent its Range. Generally speaking, the developers were very careful not to give properties the same name as classes, since this can cause AppleScript to become confused. (See more about this in the Entourage Chapter 6.) So various classes have a find object property of class find; a font object property of type font; and a text object property of type text range. Here somebody forgot about that: so just in case you ever wanted to run a whose filter on the text range property of text frame, or refer to it in a tell block targeted at text frame, you would need to include the keyword its. (See the Entourage chapter for details and examples.)

Lo and behold – there is one more such example of a property with the same name as a class, right here in this script. In the ReplaceInRange handler's tell block directed at the findObject, we had to say 'its replacement' because replacement is also a class name and the script would indeed become confused and would error here if we did not include its, which specifies that we really do mean the findObject's replacement property and not the application's replacement element (class) that would otherwise take precedence.

You should keep this pair of handlers handy, as in a script "library". (That's a saved script that has no top-level commands, only handlers [subroutines] and perhaps some script properties if needed.) You then need only copy and paste these two handlers into any script that needs it. Many will. (Or you need not do even that. Read up in an AppleScript book how to load script: you can then just load the script library when needed and tell it to do the ReplaceEverywhere subroutine.) For a particular text find/replace, you then just call the ReplaceEverywhere handler.

For example, to replace "hot" with "cold" everywhere in a document:

my ReplaceEverywhere("hot", "cold")

Traditionally, you put this "top level" command at the top of the script and the handlers at the bottom, but you need not: you can do the opposite. When the script compiles it "learns" where everything is. Strictly speaking, if the call to ReplaceEverywhere("hot", "cold") is not itself inside an application tell block, you do not need the my. But since most of the time you will be calling it from within another Word tell block, you absolutely need the my (which means that the script, not the application, is the "parent", so the script will not assume that the term ReplaceEverywhere is a keyword of the application, which would fail and error.) Just get used to always using my when calling subroutines and you can't go wrong.

Many Kinds of Deletions

Deleting items in AppleScript is trickier than in VBA because all the references to objects are by index and get re-evaluated every time you delete an item, so items will get skipped and the script eventually error when it gets to the final items whose indices are greater than any existing item. Therefore you must iterate backwards through items, which imposes just the one type of repeat loop that can go backwards "by -1". This aspect is mentioned in all the scripts of this section, and in greatest detail in the Delete all empty rows of a table script.

Delete all rows of a table that contain a particular text string in the first column

(by Word MVP Bill Coan)

Sub DeleteRows()

 

Dim TargetText As String

Dim oRow As Row

 

If Selection.Information(wdWithInTable) = False Then Exit Sub

 

TargetText = InputBox$("Enter target text:", "Delete Rows")

 

For Each oRow In Selection.Tables(1).Rows

If oRow.Cells(1).Range.Text = TargetText & vbCr & Chr(7) Then oRow.Delete

Next oRow

 

End Sub

This translates to:

set cellEndChar to ASCII character 7

tell application "Microsoft Word"

     if (get selection information selection information type ¬

          (with in table)) = "false" then return

     display dialog ¬

          "Delete rows with this text in cell 1:" default answer ¬

          "Enter target text" with icon 1

     set targetText to text returned of result
      

     set theRows to every row of table 1 of selection

     repeat with i from (count theRows) to 1 by -1

          set theRow to item i of theRows

          if content of text object of cell 1 of theRow = ¬

              (targetText & return & cellEndChar) then

              delete theRow

          end if

     end repeat

end tell

Notes: What VBA knows as Chr(7), AppleScript knows as ASCII character 7 (and old teletype operators knew as "Bell"). It's an invisible character that is used by Word as a table-cell-end character following a carriage return, known as vbCr or Chr(13) in VBA and return or ASCII character 13 in AppleScript. You can see a visual representation if you turn on Show Non-Printing Characters in Word's Preferences or standard tool bar. ASCII character is a command in the Standard Additions dictionary (Apple's built-in collection of scripting additions).

There is always a certain overhead that slows down a script when calling scripting additions, so you don't want to call it over and over in a repeat loop. That's why we set a variable to it at the top of the script: it's called just once this way. Similarly, you normally always want to use AppleScript's three constants return, space and tab rather than their equivalent ASCII character commands (13, 31, 9). (In the old Word AppleScript of Word X and earlier, you could not use tab in Word tell blocks: it was always interpreted as Word's tab class. In 2004, they were clever to do away with that conflict: the class is now called tab stop, and tab on its own is the usual text character.)

AppleScript is also clever in never confusing the return character with the return command. You can see the difference in the last few lines of the script above between the light blue regular-weight return (the character) and the dark blue bold weight for the return command (formatted as a Language keyword).

You will notice the difference between the AppleScript repeat loop and VBA's For Each loop. In AppleScript, if we use the 'repeat with theRow in the Rows' syntax (or more literally 'repeat with theRow in (every row of table 1 of selection)') AppleScript actually keeps track of the count by indexing the list exactly as in a 'repeat with i from 1 to (count theRows)'. It constantly checks, or refreshes, the list of items but not the index, on every iteration. So any time you use a delete loop to delete items, you must use the form above where you iterate backwards from (count theRows) to 1 by -1.

Otherwise, every time you delete an item the next iteration skips one (Say you delete item 1, then "item 2" is now the original item 3, and the original item 2, now "item 1", gets skipped. Every second item gets skipped this way, and pretty soon you hit an error when the index is larger than the last remaining item.) Always iterate backwards when deleting: that way all as-yet-uninspected items keep their original index to the end.

Finally, note that the with in table (note the separate words "with in") information type does not return the booleans true and false but the strings "true" and "false".

Delete duplicate paragraphs using a Text Range object

Dim AmountMoved As Long

Dim myRange As Range

 

'start with first paragraph and extend range down to second

Set myRange = ActiveDocument.Paragraphs(1).Range

AmountMoved = myRange.MoveEnd(unit:=wdParagraph, Count:=1)

 

'loop until there are no more paragraphs to check

 

Do While AmountMoved > 0

 

'if two paragraphs are identical, delete second one

'and add the one after that to myRange so it can be checked

 

If myRange.Paragraphs(1).Range.Text = _
myRange.Paragraphs(2).Range.Text Then

myRange.Paragraphs(2).Range.Delete

AmountMoved = myRange.MoveEnd(unit:=wdParagraph, Count:=1)

Else

'if two paragraphs aren't identical, add the one after

'that to my range, so it can be checked, and drop the first one,

'since it is no longer of interest.

AmountMoved = myRange.MoveEnd(unit:=wdParagraph, Count:=1)

myRange.MoveStart unit:=wdParagraph, Count:=1

End If

 

Loop

Although this is quite straightforward (VBA macro by Word MVP Bill Coan), some adjustments need to be made for AppleScript:

tell application "Microsoft Word"

     --start with first paragraph and extend range down to second

     set myRange to text object of paragraph 1 of active document

     set rangeEnd to end of content of myRange

    

     --in AppleScript a new range is made and returned, cannot alter

     --ranges in place, so redefine myRange to the new range

     set myRange to (move end of range myRange by a paragraph item count 1)

     set newRangeEnd to end of content of myRange

     set amountMoved to newRangeEnd - rangeEnd

     set rangeEnd to newRangeEnd

    

     --loop until there are no more paragraphs to check

     repeat while amountMoved > 0

         

          --if two paragraphs are identical, delete second one

          --and add the one after that to myRange so it can be checked

          if content of text object of paragraph 1 of myRange = ¬

              content of text object of paragraph 2 of myRange then

              delete text object of paragraph 2 of myRange

              set myRange to text object of paragraph 1 of myRange

              set rangeEnd to end of content of myRange
                set myRange to (move end of range myRange ¬

                   by a paragraph item count 1        

               set newRangeEnd to end of content of myRange

              set amountMoved to newRangeEnd - rangeEnd

              set rangeEnd to newRangeEnd

             

          else

              --if two paragraphs aren't identical, add the one after

              --that to my range, so it can be checked, and drop

              --the first one, since it is no longer of interest.

              set myRange to (move end of range myRange ¬

                   by a paragraph item count 1

              try

                   set newRangeEnd to end of content of myRange

                    set amountMoved to newRangeEnd - rangeEnd

                   set rangeEnd to newRangeEnd

                   set myRange to (move start of range myRange ¬

                        by a paragraph item count 1         

               on error -- errors because can't get newRangeEnd when

                         -- move end of range is missing value at end of document                    

                   set amountMoved to 0

              end try

          end if

         

     end repeat

    

end tell

The differences result from the fact that in AppleScript you cannot alter a range and still have it continue to be the same range – once again, ranges are not dynamic. You can change the range all right, but then you have to reset the variable myRange to the newly altered one. In order to make that possible, the commands that alter ranges have to return the new range so we can get hold of it. This is almost straightforward with a command such as set range, which in its VBA version does not need to return a result at all, so in AppleScript it simply returns the altered range: just re-set the same variable (e.g. myRange) that you had for it before the set range and just carry on as you did in VBA.

For example, myRange is redefined here to end at the end of the third paragraph of the active document:

Set myRange = ActiveDocument.Paragraphs(1).Range

myRange.SetRange Start:=myRange.Start, _
End:=ActiveDocument.Paragraphs(3).Range.End

At the end, myRange is still defined, only now it will end at the end of the third paragraph. SetRange does not return a result, and does not need to: myRange has been modified "in place".

In AppleScript, you first need to understand that you can't set a variable myRange to the text object (range) of paragraph 1 and then try to extend that over more paragraphs, at least not with the set range command: Word will crash. (I believe that this may be a bug in set range, since it is not true for the move end of range command, as we have seen. So consider what follows a workaround for the bug, and one you need to know about.) myRange remains a reference to the first paragraph, and you cannot make it be something else simultaneously.

Instead create your own range set to the same start and end points, and modify that range instead:

tell application "Microsoft Word"

     set par1Range to text object of paragraph 1 of active document

     set myRange to create range active document start (start of content of par1Range) end (end of content of par1Range)

     set myRange to set range myRange start (start of content of myRange) ¬

          end (end of content of (get text object of paragraph 3 of active document))

     content of myRange

end tell

That works fine – no crashing. myRange is set to the same dimensions as par1Range, but in terms of a start and an end point, not in terms of belonging to a particular paragraph. You can now set set range to redefine the end point, once again in terms of an integer, not paragraph 3 itself. set range returns a result that is a text range, but a new one. There is no modifying "in place". In order to continue referring to it as myRange, you need to redefine the variable myRange to that result. (Or you could set a different variable to the result. But if your VBA macro expects it still to be called myRange, your script should too, to minimize changes.) Now you can carry on.

An alternate workaround is just to avoid set range entirely:

tell application "Microsoft Word"

     set par1Range to text object of paragraph 1 ¬

          of active document

     set par3Range to text object of paragraph 3 ¬

          of active document

     set myRange to create range active document start ¬

          (start of content of par1Range) end ¬

          (end of content of par3Range)

     content of myRange

end tell

In the case of commands such as move end of range and move start of range, although they otherwise work just the same as MoveEnd and MoveStart in VBA, the fact that they have to return the modified range means that they cannot instead return the handy result of the number of characters moved as in VBA. That's not very hard to find – just keep getting the end of content of the text object of the range both before and after the move, and subtract one from the other to get the difference (amountMoved) as the same amount moved.

It also means you have to keep updating the variables for rangeEnd and newRangeEnd (set rangeEnd to newRangeEnd after performing the subtraction) or you'd "run out of variables". So it just takes a few more lines of code to do the same thing.
In VBA, you can do this, as in the macro we're converting:

Set myRange = ActiveDocument.Paragraphs(1).Range

AmountMoved = myRange.MoveEnd(unit:=wdParagraph, Count:=1)

That sets myRange to the Range of the first paragraph, and then uses MoveEnd to move the end another paragraph on. Again, it does so "in place" – there's no need to redefine myRange, it's still there as a dynamic reference. So the MoveEnd Method has the "luxury" of being able to return the integer representing the number of characters this move has advanced.

In AppleScript, we do not have to create our own range this time. We can use move end of range on a text range set to the text object of the first paragraph, without crashing. However we still cannot modify the range "in place". Exactly as in the previous example, we have to set myRange, or another variable, to get hold of the new range returned by created by move end of range:

tell application "Microsoft Word"

     set myRange to text object of paragraph 1 of active document

     set myRange to (move end of range myRange ¬

          by a paragraph item count 1)

end tell

That's fine. But the necessity of the command to return the new range as the result means it cannot return the amount moved, as we have seen earlier. That is why so much of the script version is concerned with calculating this amount moved, which is not at all difficult (getting and redefining rangeEnd after every move) but a bit of a bother. As we shall see shortly, there is a simpler way to do it given the necessary difference in the AppleScript command from the VBA version..

Also, in the macro we're converting, at the end of the document you have to keep alert. In VBA when you try to do the final MoveEnd on the last paragraph mark, it doesn't error but simply returns 0. In AppleScript, move end of range also doesn't error but returns missing value (for a nonexistent new range that can't be made); that's a sort of null value. But the next line that attempts to get end of content of a non-existent range – that of course errors.

So we trap the error in a try/on error block and arbitrarily set the amountMoved variable to 0. (This is perhaps a somewhat silly way to do it, but I did so in order to keep the structure the same as for the VBA macro and to demonstrate that AppleScript has a repeat while loop too, although it's not used too often.)

You could re-do the script keeping all the move end and move start commands (and of course the delete) but simply omit all the get end of content and the amountMoved calculations: just leave all that out and depend on the trapped error at the end to close the script in a simple repeat loop with no while. New improved version, optimized for AppleScript:

tell application "Microsoft Word"

     --start with first paragraph and extend range down to second

     set myRange to text object of paragraph 1 of active document

     set myRange to (move end of range myRange by a paragraph item count 1)

    

     --loop until there are no more paragraphs to check

     repeat

          --if two paragraphs are identical, delete second one

          --and add the one after that to myRange so it can be checked

          if content of text object of paragraph 1 of myRange = ¬

              content of text object of paragraph 2 of myRange then

              delete text object of paragraph 2 of myRange
                    set myRange to text object of paragraph 1 of myRange

              set myRange to (move end of range myRange ¬

                   by a paragraph item count 1)

          else

              --if two paragraphs aren't identical, add the one after

              --that to my range, so it can be checked, and drop

              --the first one, since it is no longer of interest.

              set myRange to (move end of range myRange ¬

                   by a paragraph item count 1)

              try

                   set myRange to (move start of range myRange ¬

                        by a paragraph item count 1)

              on error -- last paragraph (missing value, so can't move start)

                   exit repeat -- finish

              end try

          end if

     end repeat

end tell

Delete all empty rows in a table

(VBA macro by Word MVPs Dave Rado and Ibby)

Public Sub DeleteEmptyRows()

 

Dim oTable As Table, oRow As Range, oCell As Cell, Counter As Long, _

NumRows As Long, TextInRow As Boolean

 

' Specify which table you want to work on.

Set oTable = Selection.Tables(1)

' Set a range variable to the first row's range

Set oRow = oTable.Rows(1).Range

NumRows = oTable.Rows.Count

Application.ScreenUpdating = False

 

For Counter = 1 To NumRows

 

StatusBar = "Row " & Counter

TextInRow = False

 

For Each oCell In oRow.Rows(1).Cells

If Len(oCell.Range.Text) > 2 Then

'end of cell marker is actually 2 characters

TextInRow = True

Exit For

End If

Next oCell

 

If TextInRow Then

Set oRow = oRow.Next(wdRow)

Else

oRow.Rows(1).Delete

End If
Next Counter

 

Application.ScreenUpdating = True

 

End Sub

Here is the AppleScript equivalent. Note that the repeat loop has to be done differently, and backwards, as with a previous example, because we are deleting items. More on this following the script.

tell application "Microsoft Word"

     activate

     --Specify which table you want to work on

     set theTable to table 1 of selection -- or table 1 of active document

     set numRows to number of rows of theTable -- faster than counting rows

     set screen updating to false

    

     --iterate backwards because deleting!

     repeat with i from numRows to 1 by -1

          set rowText to text object of row i of theTable

         

          set status bar to "Row " & i

          set textInRow to false

         

          --you NEED the explicit gets if not setting variables!

          repeat with theCell in (get every cell of rowText)

              if (count of (get content of text object of theCell)) > 2 then

                   -- end of cell marker is 2 characters, count faster than length

                   set textInRow to true

                   exit repeat -- no need to check other cells

              end if

          end repeat

         

          if not textInRow then

              delete row 1 of rowText
              
          end if        

     end repeat

     set screen updating to true   

end tell

AppleScript does not have anything like VBA's .Next(wdRow) to go on to the next row no matter where you are in the loop or if you just deleted a row or not. Any sort of repeat loop, even one iterating through a previously-formed list such as

set allRows to every row of theTable

is still composed of objects that are references. And in this case, as in many cases the references are by index {row 1 of table 1, row 2 of table 1, row 3 of table 1, … etc.} So even if you

set allRows to every row of theTable

repeat with i from 1 to (count allRows)

   set theRow to item i of allRows

hoping that it will merely go fetch the item i of your list as it was when you made the list, that is not the case. That item was a reference to row i of theTable, so now it goes and re-evaluates row i of the table, which has a different content than row i had previously (if you altered the table during the loop). The result is that it will skip an item. This is not the case in an application like Entourage where almost every application reference is to a "hard-coded" object with a unique ID in its database. That is a sort of "luxury" a database-based application can have.

(In Entourage, all references to objects, however you make them – by name, by index, whatever – all resolve to the "canonic" reference by ID. So a list of allMessages in a folder, for example, would consist of {message id 12345, message id 12346, message id 12347, message id 12348}. Even if you deleted the second item of that list, it does not disappear from the list, so getting item 3 of allMessages still gets you message id 12347, not id 12348.)

In Word, as in the Finder and most other applications, the index of the reference will be re-evaluated, and you'll end up with an item skipped and later an error when the final indices are found not to exist any longer. That's why you have to iterate backwards, since indices lower than items you have deleted are not affected.

There are some situations where you can work around Word's propensity to re-evaluate every reference: for example, application references such as active document. If you set a variable like theDoc to active document (meaning the document in the front, of course), then minimize (collapse) window 1 of the front document to the Dock, and then call theDoc again (perhaps to activate it again), your original reference is lost, since Word re-evaluates theDoc to the new document that is now in the front!

The way to get around this is to find something that uniquely identifies the current active document and refer to it by this identifier when setting your variable. The ideal unique identifier of any document is its name: there can only be one document with the same name:

tell application "Microsoft Word"

     set theName to name of active document

     set theDoc to document theName

end tell

Here the variable theDoc remains "hard-coded" to the document currently active. So even when you collapse its window to the Dock and another document becomes active window, the variable theDoc remains pointing to the same document that it was originally set to, and you can re-activate or do anything to it without it pointing to a different document.

But in the case of this list of allRows, where each individual list item is a reference to {row 1 of table 1, row 2 of table 1… etc.} – a list of rows by index – and gets re-evaluated when called, resulting in skipped items and an error. So you must iterate backwards. There is no unique identifying feature for any row, at least not when getting 'every row' as a list. (Although the Dictionary definition for table claims that you can get a row element "by name" that really means "by index" since rows do not have a name property). It‘s the index for each row that constantly gets re-evaluated as you delete rows, so iterating backwards is the only way to do it.

Because of the repeat with i from numRows to 1 by -1 format, where i is a counter that does not need to be explicitly incremented by you, there is also no need for an initializing statement equivalent to VBA's

Set oRow = oTable.Rows(1).Range

That all gets taken care of inside the repeat loop by

set rowText to text object of row 1 of theTable

Similarly there is no need for a check for textInRow being true, since there's nothing to do if it is: the i counter will increment by itself.

The screen updating and status bar features work just the same in AppleScript as in VBA, only with the adaptations above you will now see the status bar counting down to 1 (which is neat in itself since you'll know how far there is to go before it finishes).

Remove all empty paragraphs from a document

Here's an example that shouldn't require a repeat loop, therefore no backwards iterations either. That's because it uses Find/Replace to do the removing in one go. It comes from a macro by Dave Rado at <http://www.word.mvps.org/FAQs/MacrosVBA/DeleteEmptyParas.htm>, which has extra code to remove empty lines from within and around tables in the document. That code is quite similar to the example just above here, extended to all the tables in a document, and does require converting to backwards repeat loop iterations "by -1". You should not have any trouble adding those portions if you've been following the examples here so far.

But there's another issue: this macro does not actually work on the Mac (at least not in Word 2004). Things like this will happen from time to time when you get macros from people using Word Windows, so let's try to deal with that too. It seems that on Word Windows, you can work around the fact that ^p – a special character combination that means "paragraph mark" – is not, for some reason, allowed in the Find box when you also use wildcards. (We want to use wildcards to represent {2,}, a wildcard meaning "two or more occurrences" of the paragraph mark.)

On Word Windows, you simply use ^13 instead of ^p in the Find box, with Use Wildcards, in the expression ^13{2,}. But that doesn't work in Word 2004, neither in the UI nor in VBA, nor in AppleScript. Try it in the Find box in the UI and you will see for yourself. You can use ^13 without wildcards, but not ^13{2,} with wildcards (an error message "The Find What box contains an expression which is not valid" appears). In a script, you just get an error message that the "find does not understand the execute find message", which is actually the same error. Apparently, on the Mac, ^13 just means the same as ^p and is subject to the same constraints. Whether this is a bug or is somehow unavoidable is unknown.

Our workaround will simply be to look for two paragraph marks together ^p^p and repeat the Replace All a few times until there are no more double-paragraph marks. Doing a Find and Replace is still so much faster than looping through all the paragraphs that this is a reasonable workaround. Here are the VBA macro and its modified AppleScript version:

'Note that using Find and Replace is dramatically faster

'than cycling through the Paragraphs collection

 

'Replace: ^13{2,} with ^p, which replaces all occurrences

'of two or more consecutive paragraph marks with one paragraph mark

 

With ActiveDocument.Range.Find

.Text = "^13{2,}"

.Replacement.Text = "^p"

.Forward = True

.Wrap = wdFindContinue

.Format = False

.MatchCase = False

.MatchWholeWord = False

.MatchAllWordForms = False

.MatchSoundsLike = False

.MatchWildcards = True

.Execute Replace:=wdReplaceAll

End With

 

'However, you can't use Find & Replace to delete the first or last 'paragraph in the document, if they are empty. To delete them:

 

Dim MyRange As Range

Set MyRange = ActiveDocument.Paragraphs(1).Range

If MyRange.Text = vbCr Then MyRange.Delete

 

Set MyRange = ActiveDocument.Paragraphs.Last.Range

If MyRange.Text = vbCr Then MyRange.Delete

Note that when replacing, you need the special ^p character to insert a proper paragraph end (^13 would insert some sort of corrupt version, though it looks all right at first glance. It might be just a carriage return without all the extra info that is stored in a Word paragraph mark.) Here is the modified AppleScript version, with comments below:

tell application "Microsoft Word"

     -- replace ^p^p with ^p to replace all occurrences of two

     -- consecutive paragraph marks with one paragraph mark

     -- repeat until done

    

     repeat

          set textObject to (text object of active document) -- redo each time

         

          if (content of textObject) does not contain (return & return) then

              exit repeat -- done

          end if

         

          set findObject to (find object of textObject)

          -- we need a separate execute find on it, so best set a
              -- variable to it so we just get it once

          tell findObject

              set {content, content of its replacement, forward, wrap, format, ¬

                   match case, match whole word, match all word forms, ¬

                   match sounds like, match wildcards} to {"^p^p", "^p", ¬

                   true, find continue, false, false, false, false, false, false}

          end tell

          execute find findObject replace replace all

         

          -- Find/Replace cannot delete first or last paragraph if empty, so:

          set myRange to text object of paragraph 1 of active document

          if content of myRange = return then delete myRange

         

          try

              set myRange to text object of paragraph -1 of active document

              if content of myRange = return then delete myRange

          end try

     end repeat

    

end tell

We use a plain repeat block since we do not know how many times we'll need to run it. (If we were to use repeat while (get text object of active document does not contain return & return) or a variable set to the same thing, it does not re-evaluate each time and the repeat loop never finishes (I've tried it). Instead we re-set the textObject variable just inside the repeat loop to force a re--evaluation, and then exit repeat under that condition.

That means that we also need to run the code to delete the first and last paragraphs if they are empty inside the loop; otherwise the text range will continue to have two paragraph marks at the very end if the last paragraph is empty – forever, and you'd never get out of the repeat loop. Finally, you need a try/end try block around the code deleting the last empty paragraph since it errors when it tries to delete myRange. It actually does delete the paragraph (just a 'return') but still errors. So a simple try/error gets around that.

In the above script, just use

set textObject to (text object of selection) -- redo each time

instead of text object of active document to have the Find & Replace work on selected text rather than on a whole document.

Working with Bookmarks

There are two interesting articles on the Word MVP website, by Ibby and by Dave Rado, about working with bookmarks:

<http://www.word.mvps.org/FAQs/MacrosVBA/WorkWithBookmarks.htm>

<http://www.word.mvps.org/FAQs/MacrosVBA/InsertingTextAtBookmark.htm>

This is not the place to repeat all their helpful tips and explanations, but just to check that everything they recommend can easily be done in AppleScript too. First go to Preferences/View, and check to Show Bookmarks so you can see what‘s happening.

To insert text at (that is, after) a placeholder bookmark (one where you inserted a bookmark at an insertion point in the text):
ActiveDocument.Bookmarks("myBookmark").Range.Text = "Inserted Text"

translates to:

tell application "Microsoft Word"

     set content of text object of bookmark ¬

          "myBookmark" of active document to "Inserted Text"

end tell

To insert text at an enclosing bookmark (one where you had selected some text to insert your bookmark), and then recreate the bookmark which would otherwise vanish:

Dim bmRange As Range

 

Set bmRange = ActiveDocument.Bookmarks("myBookmark").Range

bmRange.Text = "Inserted Text"

ActiveDocument.Bookmarks.Add _

Name:="myBookmark", _

Range:=bmRange

translates to:

tell application "Microsoft Word"

     set bmRange to text object of bookmark "myBookmark" of active document

     set content of bmRange to "Inserted Text"

     make new bookmark at active document with properties ¬

          {name:"myBookmark", text object:bmRange}

end tell

However, if you try that, you end up with a "placeholder" (insertion point) bookmark somewhere completely different in the document! This is once again because of AppleScript's (or, rather, the Word implementation's) inability to keep a variable to a dynamic range once it changes. The instant you change the text of the text range of the bookmark, your range bmRange goes up in a puff of smoke.

You can check that: insert

        properties of bmRange

as the second line inside the tell block, just after defining bmRange in the first line and end the script with an end tell right there. You will get an enormous record of dozens upon dozens of properties of this text range.

Then go back and insert the same line just after the original second line inside the block, i.e., just after setting the content of bmRange to "Inserted Text", and end the script there. You would expect to get the same enormous record of properties with the content property changed. Instead you get no result at all – bmRange does not exist any more. So you cannot use it to define the text object of your new bookmark.

Instead, get the start of content of bmRange before you alter it, (which is identical to the start of bookmark of the bookmark: you can verify that if you wish), measure the length (i.e., count) the string you are inserting, and add that number to the start of content result to get the new end of content, and end of bookmark, for the new bookmark. (The start of content is an insertion point whose number is the same as that of the character it comes after – recalling that the first insertion point and start of content in the document is 0, not 1 – so no subtraction of 1 is needed after adding the length of the new text to get the new end of content.)

Use these two numbers as start of bookmark and end of bookmark properties for making your new bookmark. (They also have the advantage that they are intended to be settable, whereas the text object property is marked as read-only.) Here's the script:

tell application "Microsoft Word"

     set bmRange to text object of bookmark "myBookmark" of active document

     set bmStart to bmRange's start of content

     set content of bmRange to "Inserted Text"

     set bmEnd to bmStart + (count "Inserted Text")

    

     make new bookmark at active document with properties ¬

          {name:"myBookmark", start of bookmark:bmStart, end of bookmark:bmEnd}

end tell

This works perfectly. It has had to be adapted from the straightforward translation from the VBA that we first tried, after checking it and thinking about the cause of the problem (the problem with ranges being non-dynamic in AppleScript). That led to an alternative approach, using some of the many, many properties, classes and commands available. There's almost always a solution.

It should be quite evident by now that although most of the Word Object Model transfers over quite nicely from VBA to AppleScript, there are quite a number of differences in how VBA and AppleScript work – both in trying to shape the syntax into effective statements, but also sometimes in how (near-)equivalences had to be implemented by the Word developers too, so that a certain degree of working things out, and working around unexpected snags, is part of the process of converting your macros.

That is why I have tried to explain in some detail the why as well as the how, since you will undoubtedly hit other issues in other parts of Word's vocabulary and will need to understand the problems. If you have a sense for why things work as they do, you will undoubtedly also find the solutions.