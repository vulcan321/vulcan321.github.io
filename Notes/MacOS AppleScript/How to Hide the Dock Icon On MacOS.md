# How to hide the Dock icon


## Solution 1

I think you are looking for the `LSUIElement` in the Info.plist

> LSUIElement (String). If this key is set to “1”, Launch Services runs the application as an agent application. Agent applications do not appear in the Dock or in the Force Quit window. Although they typically run as background applications, they can come to the foreground to present a user interface if desired.

See a short discussion [here](http://www.cocoabuilder.com/archive/message/cocoa/2009/2/3/229461) about turning it on/off


## Solution 2

You can use what is called Activation Policy:

### Objective-C

```objectivec
// The application is an ordinary app that appears in the Dock and may
// have a user interface.
[NSApp setActivationPolicy: NSApplicationActivationPolicyRegular];

// The application does not appear in the Dock and does not have a menu
// bar, but it may be activated programmatically or by clicking on one
// of its windows.
[NSApp setActivationPolicy: NSApplicationActivationPolicyAccessory];

// The application does not appear in the Dock and may not create
// windows or be activated.
[NSApp setActivationPolicy: NSApplicationActivationPolicyProhibited];
```

### Swift 4

```swift
// The application is an ordinary app that appears in the Dock and may
// have a user interface.
NSApp.setActivationPolicy(.regular)

// The application does not appear in the Dock and does not have a menu
// bar, but it may be activated programmatically or by clicking on one
// of its windows.
NSApp.setActivationPolicy(.accessory)

// The application does not appear in the Dock and may not create
// windows or be activated.
NSApp.setActivationPolicy(.prohibited)
```

This should hide the dock icon.

### See also

-   Answer that inspired this one: [How to create a helper application (LSUIElement) that also has a (removable) dock icon](https://stackoverflow.com/a/5384319/133374)
-   [Documentation for `NSRunningApplicationActivationPolicy`](https://developer.apple.com/documentation/appkit/nsapplication/activationpolicy).
-   A related question: ["Start a GUI process in Mac OS X without dock icon"](https://stackoverflow.com/q/6796028/3939277).

## Solution 3

To do it while abiding to the Apple guidelines of not modifying application bundles and to guarantee that Mac App Store apps/(Lion apps ?) will not have their signature broken by info.plist modification you can set LSUIElement to 1 by default then when the application launches do :

```reasonml
ProcessSerialNumber psn = { 0, kCurrentProcess };
TransformProcessType(&psn, kProcessTransformToForegroundApplication);
```

to show it's dock icon, or bypass this if the user chose not to want the icon.

There is but one side effect, the application's menu is not shown until it losses and regains focus.

Source: [Making a Checkbox Toggle The Dock Icon On and Off](https://stackoverflow.com/questions/1082374/making-a-checkbox-toggle-the-dock-icon-on-and-off)

Personally i prefer not setting any Info.plist option and use `TransformProcessType(&psn, kProcessTransformToForegroundApplication)` or `TransformProcessType(&psn, kProcessTransformToUIElementApplication)` based on what is the user setting.