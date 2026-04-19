1\. AppleScript Basics

Tools, Resources and First Steps in AppleScript Syntax

If you are a proficient AppleScripter just looking for tips on converting Office VBA-to-AppleScript, you can skim or skip most of this section aside from the **Microsoft Office AppleScript Resources** section below.

Script Editors

If you have never done any AppleScripting, you first need to know where to write your scripts. Go to /Applications/AppleScript folder, and launch Script Editor. That‘s it.

Script Editor is a fairly basic IDE (though immeasurably better than the earlier version found in Classic OS 8 and 9 and in the early versions of OS X up to 10.2.8). If you find after a while you want something better, take a look both at the free editor _Smile_ <[http://www.satimage.fr/software/en/downloads\_software.html](http://www.satimage.fr/software/en/downloads_software.html)\>, an advanced script editor which is somewhat unusual and has a rather steep curve, and the commercial _Script Debugger_ <[http://www.latenightsw.com/sd4/download.html](http://www.latenightsw.com/sd4/download.html)\> which has got one of the very best IDEs for any programming language (outstripping any version of Visual Basic Editor you may know) for features and intuitive ease of use, and is available in a free time-limited Trial Demo version.

These articles require, and are illustrated with only the Script Editor built-in to OS X. They will use OS 10.4 Tiger, but all examples would be identical in OS 10.3 Panther and are most likely to be the same also in OS 10.5 Leopard (which Apple has not yet released at the time of writing). There is no difference between using a new Intel Mac or an older PPC Mac when developing or running AppleScripts. Using Office 2004, all commands to the Office apps are carried out on Intel Macs in Rosetta in any case, although calls to other applications such as the Finder and to built-in scripting additions will be native Intel. When the next version of Mac Office is released, commands will run native to the platform they‘re executing on.

(Note: all code in this document was written for Office 2004. Some of it could require changes, as well as opportunities for possible optimization, if some of the terminology changes in Office 2008.)

Learning AppleScript

AppleScript was designed to be easy to read – "English-like" is the proverbial expression. It‘s not so much easier to _write_, however, than any other programming language, and it‘s got its own conventions. Beginners to programming or scripting tend to appreciate the somewhat "colloquial" syntax, while many people accustomed to programming in other languages – VBA coders, you are warned! – tend to get annoyed at occasional lack of predictability. There are often several different ways of saying the same thing, but that doesn‘t mean that just _any_ way you can dream up will work. It‘s probably best just to stick to the recommended canonical way: you can‘t go wrong.

Now let‘s face it: you‘re never going to be able to write AppleScript until you _learn_ it. If you can write VBA code, or any other programming language, it won‘t take you long at all, since almost all the concepts and constructs are familiar; maybe a few days or weeks to get fluent in the basics. There are now many books on AppleScript.

The two extremes of approach might be represented by _AppleScript:The Missing Manual_ by Adam Goldstein (O‘Reilly), a primer to bring you up to speed quickly with the basics, but you‘ll have to dip into another reference such as Matt Neuburg‘s book when you hit an issue not dealt with there, and _AppleScript:The Definitive Guide, 2<sup>nd</sup> Edition_ by Matt Neuburg (O‘Reilly) which is the very best book on AppleScript as a language and the perfect one for people who already know another programming language such as VBA. For a step-by-step approach, especially if a beginner, choose between the most complete and exhaustive book (some 808 pages) _AppleScript: The Comprehensive_ _Guide to Scripting and Automation in Mac OS X, 2<sup>nd</sup> Edition_ by Hanaan Rosenthal (Apress), or a beginner‘s approach _Beginning AppleScript_ by Stephen G. Kochan (Wrox), or the most compact all-purpose guide _Danny Goodman‘s AppleScript Handbook, Mac OS X Edition_ by Danny Goodman. (If you get into Finder scripting, Ben Waldie‘s useful _AppleScripting the Finder_ eBook is available from SpiderWorks.) Finally, the old _AppleScript Language Guide_, a free PDF on the Apple website, although written for OS 8.6 and outdated now, is still mostly accurate as far as it goes.

In addition, _MacTech Magazine_ regularly runs AppleScript articles that range from beginning AppleScript to advanced AppleScript.

To follow along with these articles, you should not need any of them, but to actually get into writing scripts and translating VBA macros to AppleScript yourself, you will need to familiarize yourself with AppleScript syntax, and should get one or more of these books. URLs for ordering or downloading them, as appropriate, can be found in the _Resources_ chapter at the end of this document.

Office AppleScript

Now, assuming you know, or can follow basic AppleScript syntax, what about scripting the Office apps? Well, if you know Office VBA, you‘re just about there already. The AppleScript 2004 object models of Word, Excel and PowerPoint are, for all intents and purposes, identical to that of their respective VBA object models.

They really _are_ the same object model – with a few differences endemic to the differing structures of the two languages, as described in detail in the next section. The equivalent AppleScript terms are all lower cased and can consist of several words, as opposed to VBA‘s portmanteau capitalized MultipleWordsSquishedTogether: e.g., Word VBA‘s AutoTextEntry Object becomes the **auto text entry** class in AppleScript.

Because the object model provides a great many arguments to Methods in VBA (which become parameters to commands in AppleScript) plus a great many enumerated constants (all those wdWhatever and xlThisOrThat constants) as values for these arguments/parameters, this can make for quite a mouthful in AppleScript, where all these words run into each other without punctuation. Thus

   ActiveDocument.SaveAs FileName:=myDocName, FileFormat:=wdFormatText

in VBA becomes in AppleScript:

save as active document file name myDocName file format format text

Here the command name **save as** is followed by its direct object **active document** without any punctuation, and then the two parameters **file name** and **file format** are each followed by a value: in the case of the **file name** by a variable myDocName (clearly seen to be a variable due to the different green formatting than the blue used by Script Editor for application keywords\*), in the case of **file format** one of the enumerated values available to it, namely _format text_. But all running on without punctuation.

(\*These colors are the default formatting styles in Script Editor, as used throughout this document. You can change any or all of the styles – their font, size and/or color – representing the eight different syntactical elements in AppleScript Formatting by going to Script Editor / Preferences / Formatting.)

Another example:

   temp = Options.DefaultFilePath(wdUserTemplatesPath)

in VBA becomes in AppleScript:

**set** temp **to** get default file path file path type user templates path

(Note in the latter example a departure from the VBA model where DefaultFilePath is a Property of the Options object while in AppleScript **get default file path** is a command with a _file path type_ parameter, and _user templates path_ one of the enumerated values it can have.)

Regular AppleScripters can be put off by these long run-on constructions found in Office 2004 scripting: there‘s nothing very English-like about it, without the usual prepositions at the beginning of parameter names (or else "–ing" participles on verbs) that would improve readability. At times, the enumerated values repeat words found in the parameter names, which in turn may repeat words found in the command name, and they seem to run together. Regular VBA scripters will be pleased to see familiar terms appearing in the AppleScript version, and will soon adapt to the lack of dots and other punctuation. Most writers of Office VBA macros should become accustomed to Office AppleScript quite easily.

Dictionaries

So, where are these Word-specific AppleScript terms to be found? Don‘t go looking in the Help menu, as you might in the VB Editor. Script Editor‘s Help knows nothing about Word or Excel or any of the hundreds of other scriptable applications. Look in the File menu of the Script Editor, at the "Open Dictionary…" menu item. Select "Microsoft Word" in the list that comes up (or click the Browse button if you can‘t find it, and browse to it in /Applications/Microsoft Office 2004/ via a normal Mac OS "Open" navigation box).

You will now see the Word AppleScript Dictionary, with the hundreds of classes and commands available. They are divided into Suites of associated terms: don‘t forget to check more than one suite (you‘ll usually start with the Microsoft Word Suite) if you don‘t find what you‘re looking for.

In particular, always remember that **text range** – corresponding to Range Object in VBA – is a class in the Text Suite. (But in Excel, the **range** class is in the Table Suite. Go figure.) Or if you have a good idea at what the term you‘re looking for, or part of the term, might be called in AppleScriptese, just enter it in the Search box and look through the results.

You‘ll soon figure out the color-coded "C", "P" and other icons for "Command", "Class", "Property", etc. also spelled out in the Kind column. (If you‘re treating yourself well and have Script Debugger, there are more results including "F" for Functions, i.e., Commands returning results, "#" for enumerations, and so on, and clearer descriptors.)

The Dictionary entries show you all the properties and elements of classes, e.g.,

**footnote** _n_ \[inh. base object\] : Every footnote

elements

contained by documents, selection objects, ranges.

properties

**entry index** (integer, r/o) : Returns the index for the position of the object in its container element list.

**note reference** (text range, r/o) : Returns a text range object that represents a footnote mark.

**text object** (text range, r/o) : Returns a text range object that represents the portion of a document that's contained in the footnote object.      

The current version of Script Editor shows you which classes the class in question is an element of – i.e., is contained by – as well as any elements it itself may contain – here none. For those who can afford to splurge (or check the Demo), Script Debugger makes the hierarchy clearer. Note that the description of each property begins with the data type of the property, e.g., integer (a basic AppleScript type), text range (another Word class), and so on. Other classes, such as **text range** here are clickable links to their own entries in the Dictionary, which is useful.

If the properties are read only, they are marked as r/o. (Tip: some r/o properties can actually be set at the time of creation only, when using the 'make new \[object\] with properties {…}' command. In other words, it‘s always worth a try to see if it‘s possible.) When making a new object, there are default values for every property, so they do not have to mention it if default. The dictionary will usually, but not always, tell you what the defaults are, especially for boolean properties (true or false values).

For commands, the Dictionary shows you any parameters and whether a result is returned or not:

**undo** _v_ : Undoes the last action or a sequence of actions, which are displayed in the undo list. Returns true if the actions were successfully undone.

**undo** document

\[**times** integer\] : The number of actions to be undone.

→ boolean

The first indented line after the definition shows the command followed by the data type of its direct object (if any: it‘s **document** in the example above), and then the lower lines, indented another level, specify any parameters (arguments) that the command may have. Parameters in \[square brackets\] are optional parameters, such as \[times\] in the example. The parameter is followed by the data type that it takes, or a full enumeration with enumerated values separated by slashes, if the enumeration is not a class itself. (For example, the _file path type_ parameter of **get default file path** mentioned earlier is

**get default file path** _v_ : Returns the default folders for items such as documents, templates, and graphics.

**get default file path**

**file path type** documents path/pictures path/user templates path/workgroup templates path/user options path/auto recover path/tools path/tutorial path/startup path/program path/graphics filters path/text converters path/proofing tools path/temp file path/current folder path/style gallery path/trash path/office path/type libraries path/border art path : Which path should be returned.

—>Unicode text : The specified default path.       

The final line of the definition, if the —> arrow is present, shows the data type and description (if needed) of the result returned. (Script Debugger uses the word 'Result' rather than an arrow.)

More About Dictionaries

You may have already noticed, if you opened an application dictionary in Script Editor, that the various terms are listed in like-minded Suites. This is something of an archaic, legacy, inheritance from the beginnings of AppleScript, but dictionaries are still put together this way. The groupings into suites can sometimes seem a bit of an anomaly, especially in the Office applications. For example, in Word, everything to do with Ranges (called **text range** in Word AppleScript) is found in the Text Suite, everything to do with tables in the Table Suite, everything to do with Word Art in the Drawing Suite, and most of the rest in the Microsoft Word Suite.

This seems logical enough, when you know that Text, Table and Drawing Suites are already defined for AppleScript and exist in many applications, although they can each implement particular terms in their own ways. But it also means that since **selection object** class is in the Microsoft Word Suite while **text range** is in the Text Suite, very similar commands such as **extend** (that applies to _selection_ properties) and **move end of range** (that applies to _text object_ properties and other ranges) are likewise found in the two different Suites rather than close together.

It is quite easy to forget this and to look fruitlessly for a command or class in the Microsoft Word Suite to no avail, forgetting to look in the Text Suite or Table Suite. Fortunately, in the modern Script Editor, you can enter a term such as 'move end' (which you might guess at from recalling the MoveEnd Method of VBA) in the search box, and the dictionary will produce all occurrences of 'move end' – including the one you‘re looking for – wherever it may occur in the dictionary. If you splurge for Script Debugger, you have the added feature that all Classes and Commands can also be seen all listed together alphabetically as well as by Suite, so you can just ignore the whole Suite issue completely if you wish and look up a term directly. (Script Editor allows you to view by Containment – and, supposedly, Inheritance – rather than Suites, but that doesn't help to find a term if you don't know where it occurs in the object model hierarchy.)

You will also see that, within each Suite, Commands and Classes are listed separately, each list alphabetically, with the commands listed above the classes. In Script Editor 2, the lists have no "Commands" and "Classes" headings – they just run on from one to the other – but you will note a difference in the icons used: a light blue circle with a "C" for Commands, and a purple square with a "C" for Classes.

Script Debugger has better organization, where there are separate lists in a column browser for Commands, Classes Enumerations and AppleScript Types. This is somewhat akin to how Objects and Methods can be thought of as separate groups within VBA. (Unlike many programming languages, especially rigorous Object Oriented languages, AppleScript commands do not "belong" to classes in the way that Methods belong to classes in OO languages, although they act only upon such classes as they are restricted to.)

A major difference in how AppleScript application dictionaries are structured compared to VBA Help is that Properties are not separated off into their own subsection, not even for browsing. There are Classes (like VBA Objects) and Commands (like VBA Methods), and that‘s it. (In Script Debugger dictionary presentations, you can also find lists of Enumerations – something like those wdConstants and xlConstants listings in the VBA Object Browser, and AppleScript Types – like integer, string, etc. These are not shown in Script Editor.)

Properties of each class are listed separately for each class, as are its Elements. It often happens, especially in Office applications, derived as they are from the same Object Model as VBA, that properties of the same name occur in several different classes. For example, in Excel, both **range** and **row** have a _row height_ property. Many, many classes have a _value_ property. But you won‘t see generic definitions in the Excel dictionary for **row height** or **value**, as you might in VBA Help. Instead you‘ll find _row height_ listed under properties in both **range** and **row** classes, and _value_ listed under properties in **listbox, range, cell** and many other classes.

In AppleScript, unlike VBA, there is a distinction between the two different kinds of attributes classes can have: _properties_ and _elements_. _Properties_ are one-to-one: every instance (object) of a particular class _must_ have one, and only one, instance of each property the class lists in the dictionary. There is a nice advantage to this, which we will see later, in that there is a pre-defined default value for every property if you don‘t bother to specify another value when you create a new object.

_Elements_ are many-to-one: objects may have 0 or more (any number of) elements, which generally have to be made if you are creating a new object. Elements are themselves application objects whose type is specified in the dictionary. (Properties may also be application objects, or may be basic AppleScript types such as Unicode text, or integer or boolean, or may be enumerated values.)

We will see many examples later. One confusing thing about the current Script Editor is that it also lists under elements the classes that contain the defined class (as we saw above in the **footnote** example, where it lists a whole slew of classes "contained by" footnote) rather than just the classes (types) of elements which the defined class "contains" (none in the case of footnote). This was not true of the old pre-OS 10.2 Script Editor which didn‘t list these at all, and it is not true of Script Debugger which quite properly lists these "contained by" classes under a different where used heading. In my opinion, it‘s a bug to list them under elements as Script Editor does, although very useful to know about them. Just be sure you note the difference between real elements (that the defined class "contains") and these "contained by" classes.

Microsoft Office AppleScript Resources

As you can see, some of the definitions are pretty sparse. The format for AppleScript dictionaries and their definitions is determined by Apple. The new "sdef" type of Dictionary (you‘ll see that Word‘s is titled "Microsoft Word.sdef") as used by Script Editor 2 in Panther OS 10.3 and later, in Smile 3 and in Script Debugger 4, gives a lot more scope than the previous type of dictionary seen in OS 10.2 and earlier, but still nowhere near the scope of Visual Basic Editor‘s Help.

If you‘re a real VBA expert, you may not need the longer descriptions and examples for terms you‘re translating to AppleScript. But they are available. Microsoft has provided voluminous AppleScript Reference Guides for Word, Excel and PowerPoint, free, at the Developer Center on their MacTopia website: <http://www.microsoft.com/mac/resources/resources.aspx?pid=asforoffice>.

These are truly invaluable resources: 500-page PDF manuals in the case of Word and Excel, a little smaller for PowerPoint, that not only give fuller descriptions and examples of usage for every term in the dictionaries, but essential introductory essays explaining how to script important aspects. For example in the Word AppleScript Reference, there is a full discussion, with examples, of using ranges. The main body of each Reference consists of the application's full VBA Help adapted to AppleScript, sometimes with unique AppleScript-only information in addition. These Reference guides will be your most important resources for scripting Office.

For further help, when you get stuck, write to the appropriate Microsoft Mac office newsgroup:

microsoft.public.mac.office
microsoft.public.mac.office.entourage
microsoft.public.mac.office.excel
microsoft.public.mac.office.powerpoint
microsoft.public.mac.office.word

These can all be accessed either by subscribing via the Microsoft News Server (msnews.microsoft.com) in Entourage (you‘ll find the Microsoft News Server near the bottom of your Folders List: click on it, enter ".mac." In the Search Box in the main window, and cmd-click the newsgroup(s) above, then click the Subscribe button) or any other newsreader; or via the "Browser" links to Google groups in Safari or another browser at <http://www.microsoft.com/mac/community/community.aspx?pid=community>. Using a newsreader is best as your question will appear there a few seconds after posting, while Google groups in a browser can take several hours before they appear.

Another place to request AppleScript help (particularly help not specific to the Microsoft Office apps) is by joining the AppleScript-Users Mailing List run by Apple at <http://lists.apple.com/mailman/listinfo/applescript-users>.

Compiling, Saving and Running Scripts

Compiling Scripts

AppleScript is pre-compiled before saving, and formats the different "parts of speech" (uncompiled text, operators, language keywords, application keywords, comments, values, variables and references) with distinct fonts and colors when compiling. In Script Editor, if you go to Script Editor menu/Preferences/Formatting, you can see the colors and fonts. You can even change them, if you wish. When you type new code, or if you are reading this on-screen and can copy and paste the examples in these articles, newly entered code is always seen in the uncompiled formatting, e.g.,

tell app "Microsoft Word"

   save as active document file name myDocName file format format text

end tell 

If your script is written with proper syntax, clicking the Compile button (or select Script/Compile or press cmd-K, or simply Enter), it will compile like this:

tell application "Microsoft Word"

   save as active document file name myDocName file format format text

end tell

Compiling sets the formatting. (AppleScript has quickly looked up terms in its own language dictionary and parser, in the application dictionary of the 'tell' block, and in installed scripting addition dictionaries, worked out which terms are AppleScript keywords, application keywords, quoted text, etc. and made anything that is "none of the above" into variables, as long as your syntax has no errors.)

Compiling also sets the indentation within "blocks", which is very nice of it, if there is no error. If there is a syntax error, the script will not compile, and you will get an error message. AppleScript error messages are notorious for being incomprehensible, but most of the time, it will be one or the other of two problems: either

1.            You have made a typographical error, so what should be a language or application keyword instead is considered a variable, with the words following (or even preceding, if you mistyped the last or middle word of a multi-word keyword) also variables or keywords in a statement that now makes no sense; or

2.            You have pasted some code from a document or email message where some long lines hard-wrapped to a new line, making both syntactically wrong. In the latter case you need to remove the infiltrating carriage return or else add a continuation character (¬ , made by typing option-L) to the end of the first, broken line.

If you‘re writing your own script, you may simply have got the syntax wrong, of course. Even if you‘ve pressed the "Compile" button without problem, with all keywords correctly typed, it is still possible that the syntax is meaningless and you will get an error in execution when running the script.

Running Scripts

Finally, when you‘ve got a script working, how do you save it and run it? Of course it can be test-run from Script Editor by clicking the Run button, but you will want to save it and run it more conveniently when you‘re in Word. Unlike VBA macros, you cannot save a script in the document itself (more on this in the next section). You have the choice of saving a script as a self-standing Application (or Application Bundle, the way ahead) or as a Script (or Script Bundle), by flipping the File Format popup in Script Editor‘s Save dialog. (You can also save as Text, useful when you have to interrupt your work with a script that won‘t yet compile, but no such text will execute: it must be saved as Application or Script to run.)

A script application might be useful when creating a workflow involving several applications, or when what you want to save is a "droplet" on which you can drop files. (you effect this by including an 'on open' subroutine and saving as an Application. Discussed in more depth in any of the AppleScript books.) But script applications have the same liability as any application: there is a delay of a few seconds after the file is double-clicked while the application launches, bouncing up and down in the Dock until it is ready to go. By contrast, saving as a Script (which adds the .scpt extension) carries no such overhead when run from a suitable script runner such as a script menu: it just runs straight off, just like macros.

Unlike Entourage, which has had its own script menu from its inception, Word, Excel and PowerPoint 2004 do not have their own script menus. (It‘s always possible that the next version might introduce these, which would allow for keyboard shortcuts such as Entourage does.)

But the OS has its own script menu. To enable it, in Tiger OS 10.4 go to /Applications/AppleScript/AppleScript Utility and double-click it. Click "Show scripts menu in menu bar" checkbox and close. (In Panther OS 10.3, go to /Applications/AppleScript/Script Menu.menu and double-click it.) Now you will see a black "squiggly-S" icon on the right-hand side of the main menu bar, near the menu clock:

![](http://preserve.mactech.com/vba-transition-guide/index-006.htmlfig1.jpg)

^ System Script Menu

Click the menu, then Open Scripts Folder/Open User Scripts Folder (in Panther, there is no sub-item). This creates and opens a "Scripts" folder here: ~/Library/Scripts/, where ~/ means your username Home folder (Mac HD/Users/username/). This is where you will store your scripts to make them appear in the same menu – you just select a script name in the menu and it runs.

If the menu starts to get too long for comfort, and you‘d like to see some or all of your Word scripts, say, only when Word is in the front, make an "Applications" subfolder inside this Scripts folder, and then a "Microsoft Word" (and a separate "Microsoft Excel" and "Microsoft PowerPoint" and whichever other applications you‘d like to do the same for) subfolder inside the "Applications" folder. You _must_ spell out the full name of the application exactly as it appears on your computer or it won‘t make the match to the application. You can do all this automatically in OS 10.4 (and later, presumably) by bring Word or any application to the front, clicking the Script menu, and choose Open Scripts Folder/Open Microsoft Word Scripts Folder: this creates the folder if it does not yet exist. Now any scripts saved in the Microsoft Word subfolder will be seen in the Scripts menu only when Word is the active application in the front. (So don‘t put scripts in there that you want to call from another application or the Finder to get Word going.)

This is one great advantage AppleScript has over VBA: You can call a Word script from, say, Entourage or FileMaker Pro, to take some selected text, for example, and use it in a Word document, perhaps even doing it all automatically in the background. It is certainly a limitation that you cannot call scripts from a button on a Word toolbar nor (yet) from a keyboard shortcut (at least not without a third-party utility such as iKey, DragThing or QuicKeys: see the _Resources_ chapter for URLs), but the Scripts menu is nevertheless and excellent device for running scripts with no overhead. In the next chapter I discuss some third-party tools that can provide palettes with buttons for running scripts, and even toolbars you can make yourself if you are up to it.