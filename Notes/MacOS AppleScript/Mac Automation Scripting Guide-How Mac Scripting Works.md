## How Mac Scripting Works

The _Open Scripting Architecture (OSA)_ provides a standard and extensible mechanism for interapplication communication in OS X. This communication takes place through the exchange of Apple events. An _Apple event_ is a type of interprocess message that encapsulates commands and data.

A _scriptable application_ responds to Apple events by performing operations or supplying data. Every scriptable app implements its own scripting features and exposes its own unique terminology through a _scripting dictionary_. While not all apps are considered _scriptable_, any app with a graphical user interface responds to Apple Events at a minimal level. This is because OS X uses Apple Events to instruct all apps to perform core tasks such as launching, quitting, opening a document, and printing. To learn about scripting terminology and dictionaries, see [Accessing Scripting Terminology](https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/HowMacScriptingWorks.htmlAboutScriptingTerminology.html#//apple_ref/doc/uid/TP40016239-CH9-SW1).

The OSA provides the following capabilities in OS X:

-   The ability for app developers to create scriptable apps and expose scripting terminology
    
-   The ability for users to write scripts in a variety of scripting languages
    
-   The ability to communicate between apps on the same computer or on different computers using Apple events
    

The _Open Scripting framework_ defines standard data structures, routines, and resources for creating _scripting components_, which implement support for specific scripting languages. The AppleScript and JavaScript components (in `System/Library/Components`), for example, make it possible to control scriptable apps from AppleScript and JavaScript scripts. Through the framework’s standard interface, a scriptable app can interact with any scripting component, regardless of its language. The framework also provides API for compiling, executing, loading, and storing scripts—functions provided by script editing apps.

The _Apple Event Manager_ supplies the underlying support for creating scriptable apps and is implemented in the AE framework within the CoreServices framework. App developers can interact with the Apple Event Manager through the Apple Event APIs in the Foundation framework. See _[NSAppleEventManager Class Reference](https://developer.apple.com/documentation/foundation/nsappleeventmanager)_ and _[NSAppleEventDescriptor Class Reference](https://developer.apple.com/documentation/foundation/nsappleeventdescriptor)_.

Figure 2-1 shows how OSA elements work together in OS X.

**Figure 2-1**The Open Scripting Architecture workflow ![image: ../Art/execute_script_2x.png](https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/HowMacScriptingWorks.htmlArt/execute_script_2x.png)

### Extending the Reach of Scripting

Every scriptable app expands the reach of scripting. Developers can also add new scripting capabilities through scripting additions and scriptable background apps.

A _scripting addition_ is a bundle that implements new scripting terminology. For example, the Standard Additions scripting addition that comes with OS X (found in `/System/Library/ScriptingAdditions/StandardAdditions.osax`), includes commands for using the Clipboard, displaying alerts, speaking text, executing shell scripts, and more. Since scripting additions are loaded in a global context, commands provided by Standard Additions are available to all scripts.

A _scriptable background application_ (sometimes called an _agent_) runs with no visible user interface and provides scripts with access to useful features. System Events and Image Events are examples of scriptable background apps in OS X. Scripts can target System Events to perform operations on property list files, adjust system preferences, and much more. Scripts can target Image Events to perform basic image manipulations, such as cropping, rotating, and resizing.

### Objective-C Bridging

Several technologies in OS X make it possible for scripts to interact with Objective-C frameworks, and vice-versa.

_AppleScriptObjC_ is a bridge between AppleScript and Objective-C, and _JavaScriptObjC_ is a bridge between JavaScript for automation and Objective-C. These bridges enable you to write scripts that use scripting terminology to interact with Objective-C frameworks, such as Foundation and AppKit. The bridges also enable you to design user interfaces for scripts that have the same look and feel of any other Cocoa app. For information about the AppleScriptObjC bridge, see [Objective-C to AppleScript Quick Translation Guide](https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/HowMacScriptingWorks.htmlAppendixA-AppleScriptObjCQuickTranslationGuide.html#//apple_ref/doc/uid/TP40016239-CH79-SW1). For information about JavaScriptObjC, see [Objective-C Bridge](https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/HowMacScriptingWorks.html../../../../releasenotes/InterapplicationCommunication/RN-JavaScriptForAutomation/Articles/OSX10-10.html#//apple_ref/doc/uid/TP40014508-CH109-SW17) in _[JavaScript for Automation Release Notes](https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/HowMacScriptingWorks.html../../../../releasenotes/InterapplicationCommunication/RN-JavaScriptForAutomation/Articles/Introduction.html#//apple_ref/doc/uid/TP40014508)_.

The _Scripting Bridge_ lets you control scriptable apps using standard Objective-C syntax. Instead of incorporating scripts in your Cocoa app or dealing with the complexities of sending and handling Apple events, you can simply send Objective-C messages to objects representing scriptable apps. Your Cocoa app can do anything a script can, but in Objective-C code that’s more tightly integrated with the rest of your project’s code. See _[Scripting Bridge Programming Guide](https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/HowMacScriptingWorks.html../../../Cocoa/Conceptual/ScriptingBridgeConcepts/Introduction/Introduction.html#//apple_ref/doc/uid/TP40006104)_ and _[Scripting Bridge Framework Reference](https://developer.apple.com/documentation/scriptingbridge)_.

https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/index.html#//apple_ref/doc/uid/TP40016239-CH56-SW1