## MacOS
Motivated from [here](https://stackoverflow.com/a/5384319/133374), you can do:

```cpp
[NSApp setActivationPolicy: NSApplicationActivationPolicyAccessory];
```

or

```cpp
[NSApp setActivationPolicy: NSApplicationActivationPolicyProhibited];
```

This should hide the dock icon. See [here](https://developer.apple.com/library/mac/#documentation/AppKit/Reference/NSRunningApplication_Class/Reference/Reference.html) for some documentation about `NSApplicationActivationPolicy`.

In Python, the code to hide the dock icon is:

```cpp
# https://stackoverflow.com/a/9220857/133374
import AppKit
NSApplicationActivationPolicyRegular = 0
NSApplicationActivationPolicyAccessory = 1
NSApplicationActivationPolicyProhibited = 2
AppKit.NSApp.setActivationPolicy_(NSApplicationActivationPolicyProhibited)
```

See also the related question ["How to hide the Dock icon"](https://stackoverflow.com/questions/620841/how-to-hide-the-dock-icon).

___

If you want to avoid that the dock icon pops up at all right at the beginning, you can do that:

```cpp
import AppKit
info = AppKit.NSBundle.mainBundle().infoDictionary()
info["LSBackgroundOnly"] = "1"
```

## Qt
Current workaround would be setting QT\_MAC\_DISABLE\_FOREGROUND\_APPLICATION\_TRANSFORM env variable which was introduce in:  
[https://codereview.qt-project.org/#change,5968](https://codereview.qt-project.org/#change,5968)

```cpp
static void init()
{
    if (qputenv("QT_MAC_DISABLE_FOREGROUND_APPLICATION_TRANSFORM", "1") == 0)
        qDebug() << "bad";
    else
        qDebug() << "good";
}

int main(int argc, char *argv[])
{
    init();
    QApplication a(argc, argv);
    ...
}
```

it\'s documented in qcocoaintegration.mm
```cpp
if (qEnvironmentVariableIsEmpty("QT_MAC_DISABLE_FOREGROUND_APPLICATION_TRANSFORM")) {
    // Applications launched from plain executables (without an app
    // bundle) are "background" applications that does not take keybaord
    // focus or have a dock icon or task switcher entry. Qt Gui apps generally
    // wants to be foreground applications so change the process type. (But
    // see the function implementation for exceptions.)
    qt_mac_transformProccessToForegroundApplication();

    // Move the application window to front to avoid launching behind the terminal.
    // Ignoring other apps is neccessary (we must ignore the terminal), but makes
    // Qt apps play slightly less nice with other apps when lanching from Finder
    // (See the activateIgnoringOtherApps docs.)
    [cocoaApplication activateIgnoringOtherApps : YES];
}
```