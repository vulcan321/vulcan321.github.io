  

6\. Entourage

An Introduction to Entourage Scripting (No VBA Anywhere in Sight)

Entourage?

Why Entourage? You're probably already aware that Entourage, although a fully-fledged and important application in the Microsoft Office Mac suite, has never had VBA in the first place, so there's nothing to convert. Although Entourage corresponds quite closely to the role played by Outlook in Office Windows, it was never a port of Outlook to the Mac in the way that Word, Excel and PowerPoint are. (Actually, Word, Excel and PowerPoint were all originally on the Mac and in their earliest versions could be seen as being ported from Mac to Windows, but that's a story for another day. In their current incarnations, it works the other way around, with a Mac-oriented UI, modifications, adaptations, and Mac-specific features being added after receiving the shared part of the code – the core features – from the current Windows versions.)

Entourage, however, has always had an excellent AppleScript implementation. Now that you're becoming proficient in AppleScript, you suddenly have a whole new world open to you – actually, many new worlds; as many as there are AppleScriptable applications on the Mac.

Entourage shares many cross-Office features with the other Office applications, and has many useful features of its own. This article will give you just a short introduction to Entourage scripting as an example of how your AppleScript skills can now be extended and put to good use. In addition, a few useful techniques and implementations, plus one or two pitfalls to avoid, are described here that are not documented anywhere in the Entourage AppleScript dictionary nor anywhere else.

Finally, since Entourage has been scriptable for so long, there are already many scripts available for it – many can be found at MacScripter: <[http://scriptbuilders.net](http://macscripter.netscriptbuilders.net)\>. You might find some there that already do exactly what you need. You‘ll also find a very large collection of open-source scripts from which to learn.

Entourage has a dictionary built on top of (and expanded from) the old Outlook Express Mac from Classic OS 8 (or maybe even 7.5) days. On the one hand, most of its syntax is a lot simpler and clearer than the other, rather contrived set from the other Office applications, and really does read more like English. On the other hand, the oldest part of the dictionary (non-Exchange email) is derived from the old OS 7 Apple Mail Suite, which had a few really odd quirks. The very newest parts of the dictionary (Exchange functionality) have a few quirks of their own.

Since Entourage does so many types of things, and makes so many different kinds of objects, this chapter will deal first with Email Messages, then Contacts & Groups, then Calendar Events & Tasks. (Notes will have to look after themselves.) Some scripts will overlap areas. We‘ll start by linking from the previous chapters – sending a document you made in Word, Excel, or PowerPoint as an attachment to an email message.

(All scripts in this chapter are my own: some published, some unpublished until now.)

Email: Make and Send a Message with an Attachment

You've just saved a document in Word, Excel or PowerPoint. Now you want to send it as an email attachment to someone. That's quite simple – just go to File/Send To/Mail Recipient (As Attachment). That brings up an empty email window in Entourage with the document already in place as an attachment. You then fill in the recipients, subject, write your message, and send. But if you regularly need to send such messages with attachments, every day, many times, always to the same recipients, this is going to get tedious very fast. Instead, write a script telling Entourage to do it all for you in a flash.

If you want to write a different message each time, the script can just switch you to Entourage with the attachment in place, the recipients already filled in, and the subject too, if you wish, and maybe a salutation ready for you to write the rest of the message. But if the message text can be "potted" as well, you can simply have the message prepared and sent off in the background without ever switching away from the application you're working in. We‘ll look at both cases.

The first step, in both cases, is to check that the document is saved – or save it – and to get its file path. This one step needs to be done in the application you're working from, and will be slightly different depending on whether that's Word, Excel or PowerPoint.

In Word:

**tell** application "Microsoft Word"

     **try**

          **set** frontDoc **to** active document

          save frontDoc

     on error -- if you cancel out of Save dialog for an unsaved doc, avoid error

          return

     end try

     set filePath to full name of frontDoc

end tell

In Excel:

tell application "Microsoft Excel"

     try

          set frontDoc to active workbook

     on error -- avoid error if no workbook open

          return

     end try

      set containerPath to path of frontDoc

     if containerPath = "" then -- unsaved

          activate

          set docName to name of frontDoc

          set filePath to (choose file name default name docName) as Unicode text

          if filePath does not contain "." then set filePath to filePath & ".xls"

          save frontDoc in filePath

     else -- already saved as file, re-save  

          save frontDoc

          set filePath to full name of frontDoc

     end if

end tell

In PowerPoint:

tell application "Microsoft PowerPoint"

try    

      set frontDoc to active presentation

on error -- avoid error if no presentation open

     return

end try

set containerPath to path of frontDoc

     if containerPath = "" then -- unsaved

          activate

          set docName to name of frontDoc

          set filePath to (choose file name default name docName) as Unicode text

          if filePath does not contain "." then set filePath to filePath & ".ppt"


          save frontDoc in filePath

     else -- already saved as file, can't re-save (bug)

          beep

          display dialog "Due to a bug in PowerPoint, you need to make sure you " & ¬

              "have saved the presentation first." & return & return & ¬

              "If you have done so, click \"Proceed\"." buttons ¬

              {"Cancel", "Proceed"} with icon 2

          set filePath to full name of frontDoc

     end if

end tell

(You'll note that PowerPoint has another bug. Hopefully, that will be fixed in Office 2008 and you can then remove the display dialog and replace the else section by the same as the equivalent bit in the Excel code.)

Make a Draft Window (message window open on screen)

OK, now that we have the filePath of the front document (as text) we can proceed to make our email message. If we want to open a new message in Entourage, preset to recipients "My Boss" whose email address is "myboss@myCompany.com" and "His Boss", email address "hisboss@myCompany.com", and include a CC to "My Colleague", email address "mycolleague@myCompany.com", with a salutation ("Hi, Everyone") in place, a subject "Today's File", and your usual default signature, the script would now continue:

 

tell application "Microsoft Entourage"

     activate

     set mySigType to default signature type of default mail account

     if mySigType is other then set mySig to default signature choice ¬

          of default mail account

     set newMsg to make new draft window with properties ¬

          {subject:"Today's File", to recipients:¬

              "My Boss <myboss@myCompany.com>, " & ¬

              "His Boss <hisboss@myCompany.com>", CC recipients:¬

              "My Colleague <mycolleague@myCompany.com>", content:¬

              "Hi, Everyone" & return & return, signature type:¬

              mySigType, attachment:alias filePath}

     if mySigType is other then set other signature choice of newMsg to mySig

end tell

 

Note that we activate Entourage to bring it to the front, and that we have to extract the default signature of the default account to be able to use it when we make a new draft window. Checking the dictionary for any type of mail account (POP account, IMAP account, Hotmail account, Exchange account) you will notice that the default signature type might be random, none or other. other is the regular sort of signature: in that case you also have to extract the other signature choice, which is the actual signature. But if your account uses a random or none type, then there is no other signature choice, so we can't specify it later when making the new draft window or the script will error.

The need to use short lines with the continuation character ¬ in this article obscures the fact that the to recipients property (and cc recipients and bcc recipients properties as well) is just a continuous, single string, with the various recipients separated by commas. I.e., when you write your own scripts you wouldn't bother with the continuation character ¬ and would let Script Editor wrap the whole make new draft window command, with the to recipients property specified as:

to recipients:"My Boss <myboss@myCompany.com>, His Boss <hisboss@myCompany.com>"

You do not need to include the display names if you don‘t want to, for any recipients, and in that case you don't need the < > angled brackets around the email address either. So the line above could be written as:


to recipients:"myboss@myCompany.com, hisboss@myCompany.com"

Now if you take a good look at the draft window entry in the dictionary, you will not discover any attachment property! Yet the code works. That is because the developers made a coercion to make things simpler: a putative property for use only at inception, in the with properties parameter of the make new draft window (or draft news window) or outgoing message commands. It doesn't work anywhere else. attachment is actually an element, not a property, of draft window and message classes, since there can be any number of them, from 0 to many.

If you want to get the attachments of an incoming or sent message, you can't get the attachment: you'll get an error. Instead you have to get attachments or every attachment of message, and then get the file property of each one if you want to track them down.

Getting back to our draft window (new message window), you could add the attachment after the fact this way:

set newMsg to make new draft window with properties {subject:"Today's File"}

make new attachment at newMsg with properties {file:alias filePath}

But if you have a lot of attachments to make, this would get tedious. Using the with properties parameter of make new draft window, you can attach a whole raft of attachments, using a list of aliases in { } list braces as the attachment property. You'll also notice we omitted a large number of draft window properties in our code: account, bounds, encoding, priority, and much else we didn‘t need to set. They all have default values, and do not need to be specified, but should we want to change any of them, we can do so.

Make a new Outgoing Message (in the background) and send it

Now how about really automating this process? If you have to send these documents as email attachments every day, and no special customized text message needs to be written each time, you can write a script to send it off all without interruptions of any kind; it's easy to do. Instead of making a draft window, make an outgoing message, and send it off without even bringing Entourage to the front – just stay in whatever application you're in.

Now if you look in the Entourage dictionary, you'll see that recipient is an element, not a property, of message (and of both its subclasses outgoing message and incoming message). That makes sense, since you can have several recipients (of all types, including To, CC, and BCC). And when you want to get the recipients of a message (incoming, or sent, for example), that's how you go about it: every recipient of theMsg . (We‘ll get into how you select the message a little later.) Then you delve into the recipient properties to get the email address and any display name – we'll get into that soon too.

You'd expect that when making a new outgoing message, you'd have to make each recipient at the new message just after making the message – the normal process for creating elements "at" an object. However, it can't be done with outgoing message. The reason is that once a message (as opposed to a draft window) is made, it's "encoded" for the Internet, and its internal structure cannot be modified. Fortunately, the developers again have implemented a coercion – another "putative" recipient property, just like the putative attachment property we've already seen.

Only this time it's essential: it's not a convenient alternative method – this time it's the only method. And it's not documented anywhere, except here. So make sure this one sinks in. Once again, it is only available at inception, when calling make new outgoing message with properties.

Both properties – address, recipient type – listed under recipient class in the dictionary – are available. The address property's type is the rather confusing address class, which in turn has another, different address (text) property – the actual email address – plus a display name text property as well If you are just sending to a single to recipient, you can omit a lot of the specifications, taking advantage of the fact that to recipient is the default recipient type, and you can also use a "Display Name <eaddress@domain>" shorthand (< > angle brackets around the email address) instead of the more complex recipient record structure. This handy coercion is also undocumented:

 

 

tell application "Microsoft Entourage"

     launch -- in background

     set theMsg to make new outgoing message with properties ¬

          {subject:"Today's File", content:¬

              "Please find today's .pdf file attached.", recipient:¬

              "Joe Blow <joeblow@aol.com>", attachment:alias filePath}

     send theMsg


end tell

Note the first line: launch. If Entourage is already open in the background, this will do nothing. If Entourage is not open, this will launch it without bringing it to the front, as would happen if you omitted this line. (It's part of the AppleScript language, not Entourage, and works the same way for every application.) Note the simple recipient property value. (Since the script doesn't specify where to make it 'at', it does so in the local Drafts folder, the default location, using the default account. These properties can all be specified otherwise, of course, if you wish.) The file (alias filePath) in the attachment property depends on your having included the previous code to Word, Excel or PowerPoint to store the path of the saved front document as the variable filePath. The last line sends the message.

But the full syntax for recipient lets you specify as many recipients as you want, of whichever recipient types (to, cc, bcc) you want, by setting a list (in {} list braces) of all the recipients to the "putative" recipient property. You must also use record braces, which look the same, for each recipient, since each one is a record (containing address and recipient type properties) where each address is also a record (containing address and display name properties). That makes for a lot of braces:

 

tell application "Microsoft Entourage"

     launch

     set theMsg to make new outgoing message with properties ¬

          {subject:"Today's File", content:¬

              "Please find today's .pdf file attached.", recipient:¬

              {{address:{address:"joeblow@aol.com", display name:¬

                   "Joe Blow"}, recipient type:to recipient}, {address:¬

                   {address:"janeblow@earthlink.com", display name:¬

                        "Jane Blow"}, recipient type:cc recipient}, {address:¬

                   {address:"scrooge@msn.com", display name:¬

                        "Ebenezer Scrooge"}, recipient type:¬

                   bcc recipient}}, attachment:alias filePath}

     send theMsg

end tell

(That's just one recipient per type: you can include as many as you wish, of course, in the list. You can omit the recipient type if it's a to recipient, and you can omit display names.) And remember that when you write your own scripts you can ignore the line continuation marks and short lines used here so you won't get line-end errors if you copy and paste from an online source: any script editor will wrap long lines as needed.)

Once again, the filePath variable in the attachment property depends on your having included the previous code to Word, Excel or PowerPoint to store the path of the saved front document as this variable filePath. Just save the whole script (with both Word/Excel/PPT and Entourage code) in the system Script menu, and select it with your daily document in front, and off it goes to all those recipients without any activity or disturbance in your front application. You can also add a line of code to the Word/Excel/PPT block to close the active document (/workbook/presentation) saving yes, if you wish.

Now, when you first try to run this script or any other that sends a message, you will get a warning that "an external application is trying to send mail". Click to allow it, and if you are going to be doing much scripting of Entourage, also click to not warn you again. Better yet, go into Entourage/Preferences/Security and turn off both warnings about external applications trying to send mail and trying to access the address book, or you will get no end of these when trying to run scripts, which Entourage persists in considering as "external applications".

So far, there have been no malicious exploits reported for Entourage. On the Mac, as you probably know, there are no self-executing applications, so there is very low likelihood of your launching a malicious script, unless perhaps it is disguised as something else. [Ed. Note – it is something to be mindful of, and to take into consideration with your security policy if your company has one.][PB1]

Make a new outgoing message with more settings

In learning how to make a new message, we have been mostly concerned with recipients, since that is the tricky part. There are a great many other properties that can be set by script – in fact, everything that you can do in the UI (and then some). They are all very easy to script.

You might want to specify a different email account than your default account. Note: there is no generic "account" class, so you need to specify whether it is a POP account, IMAP account, Hotmail account, or Exchange account. Entourage is a database-based application, so virtually everything in it has a unique ID, and all references to elements (items) resolve to an ID reference, even accounts. (E.g., POP account id 1, IMAP account id 2, etc.)

But you won't usually know those. You can refer to almost everything in Entourage by its name, by its index if you know it, by its ID, or by a whose filter. The name of an account is not its email address (unless that's how you named it, which many people do), but the name you assigned it in Tools/Accounts/Mail. So usually you will refer to it by name as POP account "My Account" or whatever its name is.


The message will appear automatically with the default signature you use for that account. So don't add it to the message content or it will appear twice. If you want to change it for this message, you need to change the default signature type and default signature choice of the account first (or to 'none' signature type and add the text you want to the message content) and then change it back after you make the message.

outgoing message is a subclass of the generic message class (with extra properties not sensible for received incoming messages), and inherits a few read-only properties that are appropriate only for (your own) messages after they are sent – such as forwarded, redirected, replied to, resent. Don't set them for a new message, even though most read-only properties can actually be set at inception if you really need to.

connection action is something only normally applicable to incoming POP messages. Probably it should have been made a property of incoming message class, not message. Don't try to set that for a new message either. edited really and truly is read-only and can't be set by script, ever.

color is a mistake, and is deprecated (inherited from Outlook Express). Don't try to set it: it's been replaced by category – each category has a color property which can be set. category property here is a list of categories {category "Work", category "Personal} since messages and other objects can have more than one category (the first one listed is primary and sets the color). Or it can be an empty list {} for no categories: there is no category "None"! The default is {} which does not need to be set.

Normally you will not set source, but you would if trying to duplicate another message (with perhaps a few differences which you set separately). source is the entire structured message text, parts, attachments, and headers. You wouldn't normally try to script headers either: let them be formed automatically.

All other properties can be set. has html could be set to true at inception – the default is false – but that just determines that your default HTML font and size will be used. Entourage does not have any way to script formatted text. And for some reason setting has html to true removes carriage returns from the message content, so don't do it.

Basically, stick to the properties marked in the dictionary as read-write. If you don't specify where to make the message, it gets made at your Drafts folder. The alternate location you might prefer to specify would be the outbox. Here's a typical example:

tell application "Microsoft Entourage"

     -- add carriage returns before signature used for the account

     set theBody to "Some long text here. As long as you want." & return & return

     set theMsg to make new outgoing message at outbox folder with properties ¬

          {account:POP account "My Account", subject:"My New Message", content:¬

              theBody, recipient:"Joe Blow <jblow@aol.com", flagged:¬

              true, priority:high, category:{category "Work"}}

end tell

Make an incoming message

You might wonder what would be the point of making a new incoming message, since those are messages you receive from others. You wouldn't think it would even be possible. In fact, it's a way of importing messages into Entourage. (The import command is so far just valid for .mbox files, which become message folders.)

You could read the content of an .eml message file, in a way similar to reading a .vcf file in “Attach a vCard” later in this chapter, and use that as the source property – the only property you'll need – to make a new incoming message at any folder. Or to make a duplicate message from properties of an existing message at a location where duplicate does not work.

The interesting thing is that this is possible by AppleScript, although not in the UI. Most of the so-called read-only properties are settable at inception, so you can do almost whatever you want with the power of AppleScript. Just follow the same sort of procedure as making an outgoing message, but do it as an incoming message, to see for yourself.

Email: Selecting Messages, Running Scripts from Rules, Schedules, Menus

Sometimes the email scripts you run will be on received messages. You may have seen that Entourage's Rules (in Tools menu) can be enabled to run automatically on messages as they come into the Inbox, and one of the possible Actions they can perform is to Run AppleScript. Similarly, Schedules (also in the Tools menu) can be set to perform tasks on a regular repeated schedule, or at startup or on quit, and can also Run AppleScript. Both of these provide a very high degree of customization and automation, since AppleScript can do "almost anything" with Entourage's objects, far more than standard Rule and Schedule actions can do, and also with a far finer degree of selection and combination.

You may have found a certain degree of frustration with rules that let you filter when "all criteria are met" (i.e., boolean AND for all conditions) or when "any criteria are met" (i.e., boolean OR for all conditions) but no finer or more complex granularity: AppleScript can handle any degree of complexity, so just write it as a script and run the script from the rule.

Before we get to some more examples, there's one thing, not fully explained in the Entourage dictionary, that needs to be dealt with. It will come up again and again in your Entourage scripts. How do you specify the selected message(s) on which you want to run a script, and how do you specify the message on which the running rule should operate? By the same application property – current messages – which is always a list of messages.


So to specify the actual message on which the rule (or schedule) is running, you need to get item 1 of that list. Same goes if you have selected just one message in a message list. So far so good, but you'll find that if you try

tell application "Microsoft Entourage"

     set theMsg to item 1 of current messages

end tell

you get an error: "Microsoft Entourage got an error: Can't get item 1 of current messages."

That is because current messages is one of the rare properties that requires an explicit get command, or else setting a variable to it in a separate line – which does the same thing as get, namely evaluates the reference (the list of specific messages) from which you can select your item 1.

set theMsg to item 1 of (get current messages)

--> incoming message id 120434

That works, and is what you need to remember to do every time you need item 1 of current messages.

It's exactly the same with selection, another property of the application: you need the explicit get, or a variable, to be able to work with it further. selection, or rather get selection, will return whatever (*almost) is selected in the UI, as one of the following classes: 1) a list, 2) a folder, or 3) text, depending on what is selected. Selected objects such as contacts, groups, events, tasks, notes, messages are always returned as a list, even when only a single object is selected – it is returned as a one-item list. The only exception is for a selected folder or custom view in the Folders List, which is returned as a folder (only one can be selected at a time). Selected text in a message or note (including the note sections and all text fields in contact, event and task windows) is returned as Unicode text.

You always need to check for the class of the selection to make sure you have what you want and can operate on it (you can't even get 'item 1' of the selection if it's a folder, and 'item 1' turns out to be the first character if it's text): it's very easy to miss the fact that you selected a folder rather than a message in it. (This is why using current messages instead of selection is preferable for messages: current messages works even if the folder, rather than the messages, has the focus in the UI.) So usually it's best to set a variable to selection, then check its class, and finally whatever you need from it:

tell application "Microsoft Entourage"

     set theSelection to selection

     if class of theSelection is list then

          set theObject to item 1 of theSelection

          -- will then check class of theObject for contact, etc.

     else

          beep

          display dialog "First make sure you have selected one or more " & ¬

              "contacts in the Address Book." buttons {"Cancel"} with icon 2

     end if

     --rest of script

end tell

(*Even a single calendar event selected in the Calendar returns a single-item list of the selected event. But a few odd things – mostly popup objects like mini-calendars for date selections, buttons in Print dialogs and the like, things for which Entourage has no AppleScript class – baffle the script and return an error if you try the get selection when they're selected. For most "blank" selections, though, such as a place-holder for a new calendar event which hasn't been opened yet, or an open event or contact window in which you've selected nothing at all, it will return an empty list {} or empty text "", as it should.)

One more device that needs to be mentioned is Entourage's own script menu. Entourage has had a script menu since long before the OS ever had one. It is still used by long-time Entourage users, although the system's script menu works perfectly fine for Entourage too. Entourage's script menu has two advantages over the system's script menu:

1) scripts run from it run marginally faster, but that's much less noticeable now in Tiger OS 10.4 where the system script menu no longer is handicapped by slow calls to applications, and

2) there is an excellent method for adding keyboard shortcuts to scripts. Go to the Entourage Help menu and enter "About the script menu" to see how keyboard shortcuts work.

Being able to run scripts manually several times a day via a keyboard shortcut is a great boon. But there is currently also a major disadvantage of the Entourage script menu for some scripts. Most scripts are fine, but those that have script properties (see your AppleScript books) whose values persist between script runs may have issues.



The scripts made by the current Script Editor are now Data Fork-only files. The Entourage 2004 script menu can run these, but it does not retain changes in script property values when the script ends. (The old Resource Fork scripts were replaced in Script Editor 2, released with Panther OS 10.3. But Microsoft Office 2004 still has to work in Jaguar OS 10.2.8 which was still quite prevalent when Office 2004 came out and could not adopt the new Panther APIs for script menus.) This issue is expected to disappear with Entourage 2008, where it is assumed that the modern script menu APIs will be adopted, so that changes made to script property values in running Data Fork scripts as made by Script Editor will be retained.

So if you write a script that uses script properties whose values can be altered by script, as one or two of the examples below do, you have three choices: either

1) run it from the system script menu, just as you do for your Word and Excel scripts, and manage without keyboard shortcuts, or

2) if you have Script Debugger you can still save the scripts in Resource Fork format.

3) Download Mac MVP Barry Wainwright's "Convert Script", which will convert your data-fork script into a resource-fork script using a Unix shell script. You just drop your script on it and it's converted. Here's the URL: <http://www.barryw.net/scripts/index.html>

(None of these issues apply if you save your script as an Application to be run externally.)

To run scripts from Entourage's script menu, which looks just like the system one but is on the left side of the menu bar just to the right of the Help menu, put your scripts here: ~/Documents/Microsoft User Data/Entourage Script Menu Items/ folder (where ~/ means your user folder). They then appear as menu items in the Entourage script menu.

Email: Reply with Insertion Reversed

Here's a script that lets you flip your Reply style and signature placement from top to bottom, or vice-versa, on a per-message basis. I use it several times a day myself. People send you email replies where they may reply at the top, or may reply at the bottom. Nothing is messier than a chain of replies where the writers switch from one to the other, ruining the continuity. But in the meantime you have chosen your preferred method in the Entourage preferences – you can't flip-flop the preferences continually. So, if you want to sometimes reply in the opposite manner to your regular preference, just run this script.

But, first you have to set it up. This is done by setting the properties at the top. Don't worry – you will be able to do so. In the version of this script available at <http://macscripter.net> you set these properties by running a separate PREFS script, which uses the standard scripting addition commands load script and store script to change the values of the properties in the main script.

However: a) that won't work (in Entourage 2004) with your scripts made by Script Editor (see above) – the copies at macscripter.net are resource-fork scripts made in Script Debugger and b) you're a scripter, not a regular user, so you can just set the properties how you like in Script Editor, and they will work. (If you ever want to change them in the future, just open the script in Script Editor, change them, and save.)

You can add a keyboard shortcut to the script name, which is particularly handy for this script, and put it in the Entourage script menu. Here are the four properties to go at the top of the script:

 

property replyUsingMessageFormat : true

property htmlText : true

property attributionStyle : "short headers" -- or "internet" or "none"

property insertionPointOnTop : false --(only applies to internet-style)

 

The first two properties, replyUsingMessageFormat and htmlText, are for indicating whether you want to reply in the same format (i.e., Plain Text or HTML) as the original message, or whether you always want to reply in one or the other. This should be the same as you set it in the Entourage "Compose" preferences: AppleScript cannot access those preferences so you need to set them here.

If you set replyUsingMessageFormat to true, then also set htmlText to true. If you set replyUsingMessageFormat to false, set htmlText to whichever you want (false if you want Plain Text always). If your usual attribution style in the Entourage Reply Preferences is to "Place reply [quoted] text at top of message and use this attribution line" (i.e., reply at bottom) and for the script you want the opposite format of "Place reply at top of message and include From, Date, To and Subject lines" (i.e., reply at top with signature at top), set attributionStyle to "short headers".

On the other hand, if your usual attribution style is "Place reply at top of message and include From, Date, To and Subject lines" (i.e., reply at top), to do the opposite in the script set attributionStyle to "internet". (Or to "none", if that's what you want for the script.) In the second case – attributionStyle set to "internet" – you can also choose whether to set insertionPointOnTop to true (which means you'd be replying at the top: this is the way to get both the "internet" attribution plus reply-at-top, but it still places the signature at the very bottom, so is probably not what you want) or false (so reply at bottom). Naturally whatever text comes after the double-dashes ( -- ) is just comment and not code.

Here is the whole script when compiled, with the default property values chosen:

property replyUsingMessageFormat : true

property htmlText : true

property attributionStyle : "short headers"

-- or "internet" or "none"

property insertionPointOnTop : false

-- (only applies to internet-style attribution)

 

tell application "Microsoft Entourage"


     try

          if window 1 = main window then

              set theMsg to item 1 of (get current messages)

             

          else if class of window 1 = message window then

              set theMsg to displayed message of window 1

          else

              error number -128

          end if        

          if class of theMsg ≠ incoming message then error number -128

     on error

          beep

          display dialog "You must have a received message in the " & ¬

              "front or selected in the message pane of the main " & ¬

              "window for the Reply script to work." buttons {"OK"} ¬

              default button "OK" with icon 0

          return

     end try

    

     if replyUsingMessageFormat then

          if theMsg's has html then

              set htmlText to true

          else

              set htmlText to false

          end if

     end if

    

     if attributionStyle = "short headers" then

          reply to theMsg attribution style short attribution ¬

              html text htmlText

     else if attributionStyle = "internet" then

          reply to theMsg attribution style internet attribution ¬

              place insertion point on top insertionPointOnTop ¬

              html text htmlText

     else -- no attribution


          reply to theMsg attribution style no attribution ¬

              html text htmlText

     end if

end tell

The first part of the script checks to see whether you are replying to a message viewed in the Preview Pane of the main window, in which case it will be our good friend

   item 1 of (get current messages)

since the message viewed in the preview Pane is the message selected in the message list, i.e., the first (and only) of current messages. If not, it checks to see if the class (type) of window in the front is a message window, (meaning a window showing a saved message, not a "new message" draft window), and if so, it gets the displayed message of the window.

It then checks to make sure you have selected or opened a received message by checking for incoming message class. If the front window is neither the main window nor a message window, or if the class of the message is not incoming message, it invokes an error number -128 (equivalent to "Cancel" and thus a safe error to invoke), which it then catches in the on error block and displays a dialog to alert you and quits the script (return) when you click OK. The reason it goes about it in this fashion (invoking an error instead of just displaying the dialog and quitting in the appropriate else and if statements) is in order to also catch a true error if there is no window open at all, and also to only have to call the display dialog once, no matter which condition causes it.

If all is well, the script continues to the next if block to check if you're replying to an HTML message in the case that your preference is replyUsingMessageFormat, and if so sets the htmlText property to true as well. Finally, it moves on to call the reply to command with the appropriate parameters for attribution style and html text depending on your preferences (set properties).

A third, optional, parameter for reply to, namely opening window is true by default so does not need to be specified, and therefore a new draft window with recipient, quoted text and attribution all set to go opens immediately. (Setting opening window to false is the technique to use when you want to set a prepared reply text by the script and just send off the message automatically in the background.)

Save the script to the Entourage Script Menu Items folder in script (.scpt) format, naming it as "Reply Insertion Reversed \cmR.scpt " to apply a keyboard shortcut of control-command-R. (When adding keyboard shortcuts, you need one or more of the modifier keys Command (Apple), Option, Control, Shift. You must avoid shortcuts already taken by Entourage, other scripts, or the OS. Control is a good modifier key to include because the built-in Entourage shortcuts virtually never use it.)

The version of the script at scriptbuilders.net includes a second script "Reply All Reversed" which does the same but as Reply To All. To make one yourself, just copy and paste the script above into a new script window and add with reply to all to each of the reply to lines at the bottom:

if attributionStyle = "short headers" then

          reply to theMsg attribution style short attribution ¬

              html text htmlText with reply to all

     else if attributionStyle = "internet" then

          reply to theMsg attribution style internet attribution ¬

              place insertion point on top insertionPointOnTop ¬

              html text htmlText with reply to all

     else -- no attribution

          reply to theMsg attribution style no attribution ¬

              html text htmlText with reply to all

     end if

You can save this one as "Reply All Reversed \scmR.scpt " to get a shift-control-command-R shortcut.

Email (and Contact): Adjust Messages before Sending

You may have noticed that none of the Office applications can run scripts automatically when some event occurs in the application: i.e., there are no events available. (This is a loss compared to VBA in the other Office applications, as has been noted.) This is not because AppleScript could not do so – in fact events provide the entire basis of AppleScript Studio which lets you make your own Cocoa applications using AppleScript – but it is extremely rare, almost nonexistent, in scripting applications.

Thus you cannot "intercept" events such as button-clicking or selecting menu items. This is intentional on the part of the application developers as a security measure – they do not want to allow the possibility of malicious interference. So that means that you cannot have a script run automatically when you click the Send Now button. You have likely discovered that the so-called "Outgoing Rules" are really "Outgone Rules": they run only on the sent message after it has been sent, too late to alter anything in it.


However, there is a trick to it that works almost every time: run a script every 1 minute from a repeating Schedule. The script can check for all sorts of things, in particular whether there is a new draft window (new message window) in the front, and do nothing otherwise, but do whatever you need when it finds one and checks for other conditions. Since it should almost always take you more than a minute to write a message (and the average will actually be 30 seconds before the next schedule run), it can catch your message before you've finished writing it and add what you need. The next two scripts take advantage of that fact. [Ed. Note: be careful with this one, and bear the timing in mind. For short messages, you can certainly compose a message quickly enough and be out of sync with the scheduler. If you rely on this method, check your message before sending to make sure your script had a chance to run!]

Attach a vCard

Entourage has no setting to attach your vCard to outgoing messages. You can drag your "Me" contact from the address book to the message every time, but that soon becomes tedious. Instead run this script, which uses a cool technique, plus AppleScript's read/write commands and some Finder scripting to update your vCard, then attach it. If you're one of those people who likes to send your vCard on every message (well, I know there are people who do), set the script to run from a repeating schedule every 1 minute.

 

tell application "Microsoft Entourage"

     set MUDpath to (path to MUD) as Unicode text

     set meContact to me contact

     set vcInfo to vcard data of meContact

     set myname to name of meContact

end tell

 

set pathName to (MUDpath & myname & ".vcf") as Unicode text

 

try

     set f to open for access file pathName with write permission

     --will create a new one or update every time

     set eof f to 0

     write vcInfo to f

     close access f

    

     tell application "Finder"

          set creator type of file pathName to "OPIM"

          set file type of file pathName to "vCrd"

     end tell

    

     set theVcard to alias pathName

    

on error errMsg number errNum

     try

          close access f

     end try

     beep 2

     return

end try

 

tell application "Microsoft Entourage"

     try

          if class of window 1 ≠ draft window then error number -128


     on error

          return

     end try

     set newMsg to window 1

    

     set theAttachments to every attachment of newMsg

     repeat with theAttachment in theAttachments

          -- only one, don't multiply vCards

          if name of theAttachment = (myname & ".vcf") then return

     end repeat

    

     make new attachment at newMsg with properties {file:theVcard}

    

end tell

 

The first part of the script gets the path to MUD, the path to the Microsoft User Data folder, where we are going to store our vCard. Although you don't realize it when you make vCards in the UI, Entourage needs it as a file on your hard disk in order to be able to make an attachment to a message. We could make it in the "Entourage Temp" subfolder there, where Entourage makes vCards dragged to a message, but instead we'll make it right in the MUD folder to have it easily available in the UI too.

Entourage requires (and won‘t let you delete) a "Me" contact, so the line that gets it will never error. Now there is a very handy property of contact called vcard data, which is exactly what it says: all the data, in text form, that makes up a vCard. We also need the name of your Me contact too, to become the name of the vCard.

The next section of the script, after the first Entourage block, creates the vCard file. First we compose the full path of the file-to-be: being the path to MUD plus your name plus the .vcf extension. All the next group of commands come from the Standard Additions whose dictionary you can find in Script Editor. Among the many interesting commands, find the File Read/Write Suite. In order to write to a file you need to open for access file [pathname] with write permission.

That creates a new file if it doesn't exist yet, or accesses it if it does. The command set eof f to 0 erases it (we are about to update the vCard, which might have out-of-date info from the last time). We then write the vcard data to the file and close it. (Always put a write command inside a try/error block, and try to close access the file if there's any sort of error. It's very bad to leave a file with open access.)

On most Macs, Apple's Address Book is the default "owner" of .vcf (vCard) files. So the file would appear with Address Book's vCard icon. We therefore tell the Finder to set the file's creator type to "OPIM" – Entourage's 4-character signature (creator type) – and its file type to "vCrd" to get the correct­ Entourage icon: vCard, not database or message folder or anything else.

Finally, back in Entourage, we check that the front window is a draft window and check for existing attachments: after all, if the script is running from a schedule every 1 minute we don't want it multiplying the vCard by adding a new copy every minute! So if we find that there already is an attachment with (your name & ".vcf) we quit the script (return) without doing anything. Otherwise, we proceed to make a new attachment at the draft window, just as we did in the very first example, using the alias object as the file property for the attachment. Whenever you send off the message, it will take your vCard with it.

Note that by a reverse process you could make new contacts in your Entourage address book by running a script (possibly from a mail rule filtered on messages with attachments whose names contain ".vcf") to save .vcf attachments to your hard disk (say, a subfolder for vCards in the MUD folder, or somewhere temporary and delete the files at the end of the script), then use the read command to read as Unicode text the file into an r variable and, in Entourage, make new contact with properties {vcard data:r}.

However, this script might backfire if the vCard was sent via Apple's Mail and Address Book or some other applications which make vCards differently: Entourage uses Unicode text – which is why writing the vcard data worked well and why you need to read it back as Unicode text. But this is probably incorrect of Entourage: other applications such as Apple's apps write vCards as plain text (string). In addition, Apple's Address Book now follows a different protocol, so it cannot even be adjusted for Entourage. If you read one of Apple's vCards as Unicode text, the resulting Entourage contact appears to be completely blank. It may be different again coming from other sources, but this will probably do as a workaround, given that Entourage is the only application with Unicode vCards. A short test that checks for the presence of a byte-order mark (BOM) of hex-characters FEFF – ASCII characters 254 and 255 – as the first two characters of the text should suffice. (If the text begins with the BOM, it's Unicode UTF-16 as made by Entourage vCards; if not, it's a plain text vCard not compatible with Entourage.)

set r to read theVcard -- an .vcf alias (file) on your computer

if (ASCII number (character 1 of r2)) = 254 and ¬


     (ASCII number (character 2 of r2)) = 255 then -- checks for Unicode

     set r to read theVcard as Unicode text -- gets the data correctly

     tell application "Microsoft Entourage"

          make new contact at address book 1 with properties {vcard data:r1}

     end tell

else

     beep

     display dialog "This vCard is not from Entourage and cannot be " & ¬

          "imported as a contact. Sorry." buttons {"OK"} default button 1 ¬

          with icon 0

end if

Send from Other Account

Frequently people receive mail at a "public" email address – which may even be an "alias" that forwards the mail on to another address. In reply, you might want to send from a different email address. Or sometimes, everything works fine when replying because the address is the appropriate one, but when sending a new (non-reply) message Entourage will naturally send it from the default account unless you remember to change the account manually in the "From" popup. Especially in business, you'd like to be able to send mail automatically from the "correct" account.

By creating a category (in Edit/Categories/Edit Categories) with the same name as the mail account, and then assigning this category to contacts in your address book to whom you wish correspondence to be sent only from that account, this script will make it possible, Again, you need to run it from a repeating Schedule every 1 minute, so it catches the message window before you send it, and changes the account while you're writing.

You need to enter the name of each such account/category, each in its own set of "quotes" and separated by commas, in the otherAccountNames property list braces, like this: {"Correspondence", "billing@mybusiness.com"}. Some people name their mail accounts as the actual email address, some give descriptive names. You must use whatever the names are as they appear in Tools/Accounts/Mail, without the (POP) or (IMAP) or (Exchange) description.

(*enter account/category names in {},

comma-separated "quoted text" items*)

property otherAccountNames : {}

 

tell application "Microsoft Entourage"

    

     if otherAccounts = {} then

          beep

          return

     end if

    

     try

          set frontWin to front window

          if class of frontWin ≠ draft window then

              return -- quit if no new draft window open

          end if

     on error

          return

     end try

    

     set recipsList to every recipient of frontWin

     
    

     set exitRpt to false -- for outer loop

     repeat with i from 1 to count recipsList

          repeat 1 times

               set theRecip to item i of my recipsList

              set eAddress to address of the address of theRecip

              if eAddress ≠ "" then

                   try

                        set foundItem to item 1 of (find eAddress)

                   on error -- not a contact

                        exit repeat -- 1 times

                   end try

              else -- group

                   try

                        set dName to display name of address of theRecip

                        set foundItem to group dName

                   on error

                        -- text typed in without being group or email address

                        exit repeat -- 1 times

                   end try

              end if

             

              set theCats to category of foundItem

              if theCats = {} then exit repeat

              repeat with j from 1 to (count theCats)

                   set catname to name of (item j of theCats)


                   if {catname} is in otherAccountNames then

                        try

                            set otherAccount to POP account catname

                        on error

                            try

                                 set otherAccount to IMAP account catname

                            on error

                                 try

                                      set otherAccount to Exchange account catname

                                 on error

                                      beep 2

                                      return

                                 end try

                            end try

                        end try

                       

                        tell frontWin to set its account to otherAccount

                        set exitRpt to true

                        exit repeat

                   end if

              end repeat

          end repeat -- 1 times

          if exitRpt then exit repeat -- done

     end repeat

    

end tell

Note that the script checks for every recipient. If all you care about is the first To recipient, remove the outer repeat block and exitRpt lines, and

   set theRecip to first recipient of frontWin

instead.

AppleScript does not have a 'Next Repeat' operator, so note the trick in the script to effect the same thing by including a repeat 1 times block inside the outer repeat block. That way, when you hit a condition that makes continuation with the current list item unnecessary and undesirable (for example, when no recipient is a contact or group bearing the sought category), the script moves on to the next list item by an exit repeat within the '1 times' repeat block, rolling it forward to the next item in the outer repeat loop.

That's why, when there's a condition that requires exiting the outer repeat block, namely having found both a category and the account of the same name, you first have to set the variable exitRpt to true , exit the inner '1 times' repeat block, and use the true value of exitRpt after the '1 times' block closes as the criterion for exit repeat from the outer block.

Also note that there's no generic account class (although message has an account property), so you need to check for POP account, IMAP account and Exchange account of the designated name in turn.


Contacts and Groups (Address Book)

Make a New Contact

It is a simple matter to make a new contact. There are no fewer than 70 properties of contact (63 of which you can get via the handy property properties), and almost all of them are read-write. Fortunately, you don't have to set all of them! They all have defaults (almost all of which are ""), which do not need to be set. You can set as few properties as you want or have information for.

One thing that has changed in the latest versions of Entourage is that you have multiple address books (and calendars) if you have an Exchange account. (I would not be surprised if this were coming for local address books too in a later version.) If that applies to you, you would now have to specify in which address book you want to make the contact, or let it be the default location. (More on default location in a moment.)

As of Entourage 2004 v11.2, address book and calendar are now fully-fledged classes. Contacts are now elements of address book, not of the application as they used to be. In order not to break all the many scripts out there which simply make new contact and refer to contracts by name, not in an address book, the developers have cleverly allowed the old terminology to work by assuming a default address book.

If you do not have an Exchange account, you have only one address book, the local one "On My Computer". If you do have an Exchange account, your default address book is the one associated with your default mail account. If that's your Exchange account, then your default address book is your primary Exchange address book. If your default mail account is a POP or IMAP account, your default address book is your local one "On My Computer".

That means that you can still not specify a location at which to make contacts (and if you are still pre-v11.2 you must not do so, or your script will error) and they will still be made. If you have v11.2 or later, you can specify any of them. The way you refer to the local address book is

   address book 1

or

   address book id 14

The way you refer to an Exchange address book could be

   (get primary address book) of Exchange account 1

or

address book "Extra" of address book "Contacts" ¬

   of Exchange account "Name"

or any of the usual ways (by name, by index, by ID, by a whose filter).

Note that if you have nested "subfolder" Exchange address books as in the last example, they only show up that way (without any access to their contents) in the Folders List in the Mail area of Entourage. In the Address Book area they appear in a "flat" list. This is not Outlook. So 1) give your extra address books unique names and 2) if you have nested them as subfolders, you'll need to check the folder hierarchy in the Mail area before writing your script.

So, at the default address book:

tell application "Microsoft Entourage"

     set newContact to make new contact with properties ¬

          {first name:"Joe A.", last name:"Blow", home address:{street address:¬

              "123 Main Street", city:"Plainsville", state:"CA", zip:¬

              "98765", country:"USA"}, default postal address:¬

              home, home phone number:"(312) 555-1212", mobile phone number:¬

              "(312) 555-2323", category:{category "Family"}}

     set email1 to make new email address at newContact with properties ¬

          {label:home, contents:"jblow@aol.com"}

     set email2 to make new email address at newContact with properties ¬

          {label:work, contents:"jblow@jblowindustries.com"}

     set default email address of newContact to email1

end tell

Now you could just take a shortcut and set the email address property to "jblow@aol.com", rather than making email address elements afterwards. But then you could make only one of them that way and you couldn't set its label to home (it would be work, by default). It is a useful and quick shortcut when there's only one email address and you're happy for it to have the Work label.

You need to set variables (email1, email2) to the email address elements in order to select one of them as default email address. (By default, the first one made will be.)

There is a lot more you can set for contact, or can change on an existing contact – have a go. Almost all properties are text type, but note that children is a list. Then there are a few properties that are records like the home address made above, and a few that are dates, namely anniversary, birthday and the two custom date fields.

Open an Existing Contact

Entourage keeps a database for each identity. All its elements are in that database, not in separate files on your computer like Word documents. That makes it much easier to refer to them, whether to open them or to modify them. They are almost always obtainable by ID (which you usually won‘t know), by index – generally in order of creation (which you won‘t know), by name (which you will know), or by whose filter (which you can devise).

The same conditions apply to referring to contacts as to making them, with regard to location. If you do not have an Exchange account, you can just refer to contact "Joe A. Blow" – of no location. (You do have to get the name exactly right if you refer by name.) You can do the same if he is in your default address book, even if you have Exchange with all its extra address books. However, this does not work to reference the contact:

   contact "Joe A. Blow" of address book 1

(I hope this is made to work for a later version. It seems to me to be a bug.) You cannot refer by name to a contact in a particular specified address book. But this works, though slower:

first contact of address book 1 whose name is "Joe A. Blow"

So to open that contact into its tabbed contact window, just preface any valid expression for contact with the command open:

tell application "Microsoft Entourage"

     open contact "Joe A. Blow" -- if in default address book

     -- or if not:

     open (first contact of address book 1 whose name is "Joe A. Blow")

end tell

Invert Contact Names

Occasionally you'll find that you've created a contact via 'Add to Address Book' from a message where the sender was using an email client that puts the last name before the first name, like so: LastName, FirstName. Worse, you may have imported hundreds of contacts of this type from some other program. Entourage does not understand this format and puts the LastName, plus the comma, into the First Name field, and LastName into the First Name field, and then sorts by the (real) FirstName placed last – a mess. A simple script will put that right:

 

tell application "Microsoft Entourage"

     set backToFronts to every contact whose ¬

          first name ends with ","

     repeat with theContact in backToFronts

          tell theContact

              set {realFirst, realLast} to {last name, first name}

              try

                   set realLast to text 1 thru -2 of realLast

              on error

                   set realLast to ""

              end try

              set {first name, last name} to {realFirst, realLast}

          end tell

     end repeat


     display dialog "All done!"

end tell

Note the 'whose' filter in the first line to get just the contacts with commas: otherwise you'd end up switching names of contacts that were correct to begin with. The reason for using the tell theContact block (rather than using of theContact) was primarily to be able to set a list of properties in one line:

set theContact's {first name, last name} to {realFirst, realLast}

outside a tell block directed to theContact would error. However, getting a list of properties in one line always works:

set {realFirst, realLast} to theContact's {last name, first name}

One of the many quirks of AppleScript…

Flag Contact for Follow-Up (Make a Task)

You will have noticed that in Word, Excel and PowerPoint, you can "Flag for Follow Up" in the Tools menu. That creates an Entourage Task for your document (once you save it) that can send you a Reminder about it. This is very useful, and an impressive use of Office as an inter-application suite. However, Entourage itself does not have the same utility, except for email messages.

Of course, Calendar Events and Tasks have their own reminders, which is the same thing. But there is no way to flag a contact other than by just setting the little red flag: there's no "Flag for Follow Up" menu item to make a task with a reminder for the contact – say, as a reminder that you need to email them, or phone them, or write a letter. This simple script will do it by making a task with a reminder in just the same way, carrying over the name of the contact and a prospective Reminder time, which you can change, and links the task to the contact.

-- Prepare the times of the due date and reminder

set now to current date

copy now to today

set time of today to 0 -- midnight

set nextHour to (((time of now) div hours) + 1) * hours

set time of now to nextHour -- on the hour

 

tell application "Microsoft Entourage"

     try

          --get the selected contact(s)

          set theContacts to (get selection)

          --check that they are actually contacts

          if class of (item 1 of theContacts) ≠ contact then ¬

              error number -128

     on error

          beep

          display dialog "First select a contact before running " & ¬

              "the script." buttons {"Cancel"} default button 1 ¬

              with icon 0

          return

     end try


    

     repeat with theContact in theContacts

          repeat 1 times -- to allow for skipping contacts

              if class of theContact ≠ contact then exit repeat

              set theName to name of theContact

              (* if the contact has no name, check for

              nickname, company, email address, IM address

              in that order until you find one *)

              if theName = "" then set theName to nickname of theContact

              if theName = "" then set theName to company of theContact

              try

                   if theName = "" then set theName to email address 1 ¬

                        of theContact

              end try

              try

                   if theName = "" then set theName to ¬

                        instant message address 1 of theContact

              end try

              --if still no name, forget this one

              if theName = "" then exit repeat -- go on to next one

              --set a red flag

              set flagged of theContact to true

             

              -- make the task with the info

              -- get the contact's categories and projects along the way

              set theTask to make new task with properties {name:¬

                   ("Flagged Contact: " & theName), due date:¬

                   today, remind date and time:now, category:¬


                   (get category of theContact), project list:¬

                   (get project list of theContact)}

             

              link theTask to theContact

              open theTask

             

          end repeat

     end repeat

end tell

The first section of the script prepares the times for the due date and reminder of the task to be created. It is always best to perform date manipulations outside application tell blocks if possible: otherwise you sometimes hit errors. (If you do, and can't extricate yourself from the tell block, try tell AppleScript to … That sometimes works.) As you may have learned, dates, along with lists, records and script objects only, and unlike all other data types in AppleScript, are mutable when variables are set to them. (The old AppleScript Language Guide refers to these four data types as "Data Sharing" types: I will refer to them as "mutable".)

Since we want two different dates (times) to be derived from the variable now which is set to the current time (current date), we need to copy, not set, the variable now to today. Otherwise any changes we make to today would also occur with now. (Most other programming languages have far more mutable types and objects than AppleScript does.)

now and today are date objects, meaning date-and-time. (Read up more on dates in an AppleScript book.) By setting the time of today to 0, we change its time, which is calculated in integer seconds, to midnight. (Task due dates need to be set to midnight of the day in question.) With our other date variable now we need to do some fancier date arithmetic. We are going to pre-set the prospective Reminder time to the upcoming hour – not an hour from now (which is probably something like 3:14:47 PM) but right on the hour (3:00:00 PM). AppleScript has some handy constants – minutes, hours, days, weeks – which are just integers, namely the number of seconds in those units of time (60, 3600, 86400, 604800 respectively), so you don't have to remember or calculate them every time you need them.

We use the operator div to get the whole-number integer part of the dividend of now's time when divided by hours (3600), i.e., the hour of the current time (e.g., 14 for 2:00 pm), add 1 (to make 15), multiply that again by hours (3600) to get the number of seconds at 3:00 pm, and make that the new time of now. (If the time of now is after 23:00, this procedure will automatically roll over to 0:00 of the next day, with the day and date advancing)

The next part of the script first gets the selection. As discussed in the first part of this chapter, selection can be a list (of items such as contacts, messages, tasks, also a single calendar event in the calendar) which may be a single-item list if only one item is selected, or it can be a folder, or it can be text if text has been selected in a message or note window. Or there might be no selection (rare but possible).

Before running this script you are meant to select one or more contacts in the Address Book or in a custom view. The script checks the class of item 1 of the selection to make sure it is in fact a contact: if there is no item 1 (empty selection) or no selection the on error block catches it. If the class of item 1 is not contact, an error is invoked so on error catches it again, a beep and dialog appear and the script quits. The return command you see, which would quit the script, is actually never met since now (since about OS 10.2 or so) the "Cancel" button, which is the only button in the display dialog, itself automatically causes a number -128 error that quits the script.

All being well, the script proceeds. You will notice again, as with several other scripts used as examples, that there is an inner repeat 1 times block inside the outer repeat block. That is to allow the script to skip an item (exit repeat) if its class is not contact. (You might have selected a number of different kinds of items in a Mixed custom view in the Projects area of Entourage.) Without the inner 1 times repeat block, exit repeat would just quit everything: the 1 times repeat substitutes for a "Next Repeat" which AppleScript does not have. (There are other ways to structure the script that still make it possible but it requires deeper nesting of if blocks.)

Most of the rest of the script is concerned with tracking down something to use as a name if the contact has no name. You may have noticed that there is actually no name property of contact in the dictionary! But as an element of the application, a contact can be specified "by name", and the developers have implemented this "name" to point to the display name property of contact, as a synonym. The display name in turn – though it does not say so anywhere – consists of the concatenation of the first name and last name properties with an intermediate space between them if both first name and last name are not empty (otherwise no space).

Contact has a display name property because, surprisingly, contact is actually a subclass of the address class. (So it also has an address property too, even though it can have many email addresses as elements. address points to the default email address property, or "" if none.) If a contact has no first name and no last name, the address book displays in the "Name" column the nickname, company, default email address, or default IM address, looking (for text) in that order. So that's what the script looks for too, and stops looking when it finds one of those. If none of those fields is filled, it's probably a rogue contact, and the script just moves on to the next selected contact, via that exit repeat referred to above.

Now it sets the flagged property of the contact to true, which will place a red flag in the next-to-leftmost column in the Address Book, and then makes a new task using "Flagged Contact: " plus the contact name as the name of the task, today as the due date, and the modified now (the next hour) as the remind date and time (Reminder). In passing, without even needing separate lines, it sets the task's category to the contact's category (if any), which requires the explicit get; and the same for the project list (i.e., projects) property.


Finally, the script links the task to the contact and opens the task, i.e., its window – which is precisely why we set a variable theTask when making it, to be able to follow up with the two final commands to link and open it. You can then adjust the due date and reminder time if you wish. If you think you might use this script in future, save it to Entourage Script Menu Items folder and add a keyboard shortcut such as \cmC (control-command-C) to the end of its name.

Copy to a Custom Field (Contacts)

If you export Entourage contacts to a text file via File/Export/Local contacts, you will have discovered that it does not export the Category information for the contacts. There are times, for example if you then import the text file into Excel, when you really need to have the Category information. One way to get it is to use a script to enter the category names in one of Entourage's custom fields. There are 8 of those, and you usually won‘t need all of them. Let's say you want to enter the Category information in Custom 8 field.

You probably should rename that to "Categories"; of course that's easy to do in the address book (open any contact click on the Custom 8 label and choose Edit Label) but it's also possible to do that by script, which we will do. Note that contacts (and other Entourage objects) can have more than one category: that's why category property of contact (and of event, task, note, group, etc.) is a list of categories.

For our script we'll need to use a separator when converting the list of category names to text: here we'll use a comma but you could use any other separator, e.g., a semicolon, or slash, if you prefer. The way to do this is to set AppleScript's text item delimiters to the chosen separator character (within list braces), and then coerce the list to text.

You should then reset the delimiters to whatever they were, namely the default "" in most cases, afterwards, because the delimiters are retained for the entire session (i.e. until Quit) of whatever application is running the script (Script Editor, Entourage if run from its menu, System Events if run from the system menu, etc.) and might mess up other scripts if they are not rigorous (as they should be) about setting delimiters before coercing lists to text.

Here is the script:

tell application "Microsoft Entourage"

     set custom field eight name of address book 1 to "Categories"

     set categoryContacts to every contact ¬

where its category ≠ {}

     repeat with i from 1 to (count categoryContacts)

          set theContact to item i of my categoryContacts

          set catNames to {}

          set theCats to category of theContact

          repeat with j from 1 to count theCats

              set theCategory to item j of theCats

              set end of catNames to name of theCategory

          end repeat

          set AppleScript's text item delimiters to {", "}

          set catNames to catNames as Unicode text

          set AppleScript's text item delimiters to {""}

          set custom field eight of theContact to catNames

     end repeat

     beep

     display dialog "All done!" buttons {"OK"} ¬

          default button "OK" with icon 1


end tell

Note the where its instead of whose in the second line. In this case it is not optional, but mandatory: otherwise you will get an empty list {}. That is because Entourage, rather unfortunately, uses the same keyword 'category' both for this property of contact (and of other objects too) and also for the category class. (Every category you create in the UI or by script is a member of the category class.)

When used in a whose filter, AppleScript gets confused by the namespace conflict between a class and property of the same name, and gives priority to the class over the property. Since there are obviously no contacts which have the category class (they're all of contact class) the result is {} – always empty. But by using an equivalent formulation that includes the magic word its, thus pinpointing contact, not the application, as the container and category as its property, all becomes clear and you get the true result you're looking for. (You need to do the same thing when filtering on every message of some folder where its account is… .)

When the developers came to create the new class project in Entourage 2004, they had learned this lesson, and named the corresponding property of contact, event, etc. project list – so there is no conflict and you can use whose with abandon.

Also note the other pronoun my in the first line of the repeat block. That optimizes iterating through lists – by an enormous degree when the list is large. It can be dozens or hundreds of times faster, so use it. But it only works at the top level of a script, not in a handler unless you declare the list (categoryContacts) as a global variable at the top of the script in which you iterate in a handler. (There is also another method that can be used within handlers, requiring script objects: see the Neuburg book.)

Recipients Group (Make New Group)

Do you ever get email messages that were sent to a large number of recipients – perhaps from someone who sends out a newsletter? You might want to be able to email all the same people, as a group, yourself. Wouldn't it be nice if you could put all the recipients into a group in your Address Book so that you could send messages to the same set of people?

Entourage offers only "Add Sender to Address Book" from a rule or "Add to Address Book" when you click on a single name and address, one at a time – there's nothing for adding multiple recipients anywhere. This script will do it for you. First select the message in question, then run the script:

tell application "Microsoft Entourage"

     display dialog "Enter a name for the group to be made from " & ¬

          "the To recipients of selected messages:" default answer "" with icon 1

     set groupName to text returned of result

     display dialog "Do you want the group set to show " & ¬

          "individual addresses or NOT show addresses in messages " & ¬

          "to the group?" buttons {"Cancel", "Show addresses", ¬

          "Don't show"} default button 3 with icon 1

     if button returned of result = "Don't show" then

          set showOnlyName to true

     else

          set showOnlyName to false

     end if

    

     set theGroup to make new group with properties ¬

          {name:groupName, show only name in messages:showOnlyName}

     set selectedMessages to (current messages)

    

      set entryAddresses to {} -- initialize an empty list

     repeat with i from 1 to (count selectedMessages)

          set theMsg to item i of my selectedMessages


          repeat with toRecip in (every recipient of theMsg ¬

              whose recipient type is to recipient)

              set {dName, eAddress} to {display name, address} ¬

                   of (address of toRecip)

              if dName ≠ "" then

                   set nameAddress to "\"" & dName & "\" <" & eAddress & ">"

              else

                   set nameAddress to eAddress

              end if

              if {eAddress} is not in entryAddresses then

                   make new group entry at theGroup ¬

                        with properties {content:nameAddress} -- note content syntax!

                   set end of entryAddresses to eAddress

              end if

          end repeat

     end repeat

     beep 2

     open theGroup

end tell

The script first asks you to name the new group; note that default answer:"" is the way to include a blank text box in display dialog: check for more options in the display dialog entry in the Standard Additions dictionary. The variable groupName is set to text returned of result (what you type in the text box). Then you are asked whether or not you wish to allow the group to list names and email addresses, corresponding to the similar checkbox you will find in the UI of every group in the address book when you open its window, and sets the variable showOnlyName to true or false depending on the answer.

Then we make the new group, assigning it the variable theGroup, specifying its name and show only name in messages properties with the variables we previously assigned for those values. We get the selected messages – you can run the script on several messages at once if you wish, or just one (as we know already, current messages is always a list, even if just a single-item list) – and then process each item of the selectedMessages list (each message) ­in the repeat loop.

Before starting the outer repeat loop, we initialize an empty list entryAddresses, to which we will add entries as we make them. By setting it only once, outside the outer repeat loop, we insure that duplicate contacts will be avoided for all the messages being processed.

Within the outer repeat loop (for each message) we now proceed to the inner repeat loop for each to recipient of the message. (If you want to include cc recipients as well, simply remove the whose recipient type is to recipient clause.)

We now delve into the peculiar structure of the recipient class once again, whereby its address property is in fact a record containing both a different address property (a string this time, namely the actual email address) and a display name property which might be "" (blank) if not included in the message, and assign the variables eAddress and dName to them respectively. We then need to check whether the display name is in fact present or missing, since if it is not blank (dName ≠ "") we include it followed by a space and the email address in < > brackets when assigning the nameAddress variable; if the display name is blank (else) we include only the email address on its own.

Note the extra quotes we put around dName if present: that is required in Entourage if the display name happens to contain any punctuation (such as a period after an initial) – which would otherwise error further down the script when creating the group entry – and it does no harm if there is no punctuation: in fact, in that case, you will not even see the quotes around the display name in the UI since they are removed automatically if not needed.


Also note that we need to escape literal double quotes with the \ backslash in AppleScript, i.e., \". So when concatenating literal quotes to a variable representing text, namely dName here, that comes out as "\"" & dName & "\"". In the script the final (outer) closing quote is of course withheld until the rest of the literal text ( <) before the next concatenation has been added: "\"" & dName & "\" <".

We then check to see whether the email address eAddress has already been added to the list of entryAddresses: we do not want duplications. We do it this way (checking for eAddress rather than nameAddress) because we don't care if a previous instance did or did not include some version or other of the display name: we do not want to duplicate messages to this person every time in future even if the current message did so.

If we do not see the email address already in the entryAddresses list, we proceed to make a new group entry at (in) the group and add the email address to the list now. (Note how we

set end of entryAddresses to eAddress

That is the best and most efficient way to add a new item to a list in AppleScript, and you should always use it. Concatenating a new-single-item list to the existing list is much slower: it forces AppleScript to make a new copy of the list in memory and to iterate the list as well. Similarly using copy eAddress to end of entryAddresses is less efficient for the same reason.)

Important Tip! Now we come to the most peculiar part of this script, something you should remember or file away should you ever work with groups again. If you look at the dictionary entry for group entry in the Entourage Contact Suite you will see it has the following structure:

group entry n, pl group entries : every group entry

elements

contained by groups.

properties

content (address, r/o) : address of entry

See the "type" for its sole content property: address class. That's the same class I just referred to a couple of paragraphs ago. If you click the link to it in Script Editor, it takes you there:

address n, pl addresses : every address

elements

contained by application.

properties

display name (Unicode text) : the name used for display

address (string) : the e-mail address

That's the odd address class with the two properties address and display name once again. And if you go to the trouble to

get content of every group entry of group "Group Name"

using the name of any existing group you have, you will see that in fact the content of each entry does in fact have the record structure of

{address:"jblow@aol.com", display name:"Joe Blow"}

Therefore when preparing to make a new group entry at our new group, surely the syntax ought to be:

make new group entry at theGroup ¬

     with properties {content:{address:eAddress, display name:dName}}

rather than:

make new group entry at theGroup ¬

     with properties {content:nameAddress}

where we went to all that trouble to make nameAddress text in this format:

set nameAddress to "\"" & dName & "\" <" & eAddress & ">"