[Windows消息处理](https://www.cnblogs.com/lidabo/p/3523088.html)

由于看了一下，比较好理解，暂时先放到这里，待有空再翻译。只是在每节后大致介绍一下讲的内容。

感觉写的比较全，无论从消息的原理还是从MFC操作上来说，值得一看，我也在此做个收藏。

# (一)

说明：以下首先对消息进行介绍，然后在消息处理中，使用类向导创建消息循环，这个操作是在vc6.0（或者之下版本）操作的。

## Introduction

Perhaps one of the most important means of communication in windows is Messages. The traditional program starts at your`main()` function, moves down line-by-line in your code, and eventually exits. The Windows concept is different. The way you program in windows is by responding to events. These events are called messages.

Messages can signal many events, caused by the user, the operating system, or another program. An event could be caused by a mousemove, a key-press, or by your window getting resized. There are 2 kinds of messages: a window message, or a thread message. Since Threads are an advanced issue, I'll refer only to window messages.

### Window Messages

In general, a message must be sent to a window. All the messages sent to you are stored in a Message Queue, a place in the memory which stores message which are transferred between applications.

### Message Loop

the way you retrieve messages from the Message Queue is by creating a Message Loop. A Message Loop is a loop that checks for messages in the Message Queue. once a message is received, the Message Loop dispatches the message by calling a Message Handler, a function designed to help the Message Loop at processing the message.

The Message Loop will end when a `WM_QUIT` message is received, signaling the application to end. This message could be sent because the user selected Exit from your File menu, clicked on the close button (the X small button in the upper right corner of your window), or pressed Alt+F4. Windows has default Message Handlers for almost all the messages, giving your window the default window behavior. In fact, all the standard controls are simply windows with Message handlers. Take a Button for example. When it gets a `WM_PAINT`message it will draw the button. When you Left-click the button, it gets a`WM_LBUTTONDOWN` message, and it draws the pressed-button. When you let go of the mouse button it receives a`WM_LBUTTONUP` message, and respectively draws the button.

Windows defines many different message types (which are stored as UINTs). They usually begin with the letters "WM" and an underscore, as in`WM_CHAR` and`WM_SIZE`. The names of the message are usually a good indicator of what they represent.`WM_SIZE` for sizing messages,`WM_CHAR` for character entry messages and so on. The naming convention in MFC for message handler functions is to take away the "WM_" and replace it with "On", so the message handler for`WM_SIZE` is usually called`OnSize`.

A message comes with 2 parameters that give you more information about the event. Each parameter is a 32-bit value: lParam and wParam. For example:`WM_MOUSEMOVE` will give you the mouse coordinates in one paramter, and in the other some flags indicating the state of the ALT, Shift, CTRL and mouse buttons.

A Message may also return a value which allows you to send data back to the the sending program. For example, the`WM_QUERYENDSESSION` message sent by windows before the computer is shutdown, expects you to return a Boolean value. If your application can terminate conveniently, it should return TRUE; otherwise, it should return FALSE. Other message such as the`WM_CTLCOLOR` messages expect you to return an`HBRUSH`.

**Note**: In the rest of the tutorial I will focus on MFC for simplicity reasons. All the information above applies to both SDK programs, and MFC programs.

### Message Handlers

Fortunately, MFC will give all the code needed for the message loop, One of the`CWinApp` member functions called by WinMain—Run—provides the message loop that pumps messages to the application's window. The only thing you need to do so you can receive messages is to create Message Handlers, and inform MFC of them. So, how do you create a Message Handler? Once you have an MFC C++ class that encapsulates a window, you can easily use ClassWizard to create Message Handlers.

### Using ClassWizard to create Message Handlers

Press Ctrl + W to start the ClassWizard, or right click the Add button and select ClassWizard from the context menu. Open ClassWizard, select Message Maps tab. In Class name select the name of your C++ class. on Object IDs select either the ID of a menu item (for messages caused by the user interacting with a menu), the ID of a control (for messages caused by the user interacting with a control), or the first option to handle messages other messages. Choose the message from the Messages list,`WM_SIZE` for example, and Click on Add Function. Click OK, then click Edit Code. ClassWizard will write a new empty function (`OnSize` for example) with the proper prototype in the class header. The code generated should look similar to this:

```
void CAboutWindow::OnSize(UINT nType, int cx, int cy)
{
    CDialog::OnSize(nType, cx, cy);
    // TODO: Add your message handler code here

    // Here is where you can resize controls in your window, change
    // the size of a bitmap in it, or do what ever you can think of.
}
```

That's it, now you can handle messages. If you want to handle a message and then let the default message handler handle the message, you should call the base class member function that corresponds with the message. Take the following`WM_CLOSE` Message Handler as an example:

```
void CAboutWindow::OnClose()
{
    //The User or another program is trying to close our window...
    //If you don't add code to close the window, your window will never close
}
```

If you want windows to get a shot at the message, you should call the base class member function OnClose:

```C++
void CAboutWindow::OnClose()
{
    MessageBox(_T("Closing the window!"))
    //Call the Base class member function, which will close the window.
    CWnd::OnClose()
}
```

You could use this behavior to screen-out events. For example, a program that prompts the user if he is sure that he wants to close the window:

```C++
void CAboutWindow::OnClose()
{
    int Ret = MessageBox(_T("Are you sure you want to close the window?"),
                         _T("Close Window?"), MB_YESNO);
    if(Ret == IDYES){
        // The User is sure, close the window by calling the base class
        // member
        CWnd::OnClose()
    }
    else{
        // The user pressed no, screen out the message by not calling
        // the base class member

        //Do nothing
    }
}
```

### Sending Messages

Besides receiving messages, you will often find your self sending messages. You might want to send messages to communicate between to windows in your program, or to communicate between different programs. In order to send a message you need a pointer to a c++ window class. This can be retrieved using various functions, including `CWnd::FindWindow, GetDlgItem(), GetParent(),` and more. The`CWnd` class has a`SendMessage()` member function which allows you to send messages to it's window. For example, Let’s say you have a CWnd pointer to the Calculator, and you want to close it. What you should do is send a `WM_CLOSE`message, which will notify the Calculator that it should close. You can use the following code. In order to get a pointer to Calculator, I use the static`CWnd::FindWindow()` function and pass the title of the window, which in our case is "Calculator".

```
CWnd *pCalc;
//Get a pointer to the "Calculator" Window
pCalc = CWnd::FindWindow(NULL, _T("Calculator));
if(pCalc == NULL){
    //Couldn't find Calculator
}
else{
    pCalc->SendMessage(WM_CLOSE);
    //Presto! The Calculator should close.
}
```

# (二)

## How do MFC message handlers work?

Whenever your window receives a message, MFC will call a member function of your class. But how does MFC know what function to call?

MFC uses a technique called Message Maps. A Message Map is a table that associates messages with functions. When you receive a message, MFC will go through your Message Map and search for a corresponding Message Handler. I have showed in Part 1 how you add a Message Handler to the Message Map by using ClassWizard, but what really happens code-wise?

MFC uses a large set of rather complicated macros that add the Message Map to your classes. When you use ClassWizard to create a Message Handler, it will first add the function to your class, and add the corresponding macro to your Message Map. For example, examine the following ClassWizard generated`WM_CLOSE` handler:

#### 第一步：消息映射---Message Map: located in the class implementation

```
BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
    //{{AFX_MSG_MAP(CAboutDlg)
    ON_WM_CLOSE()
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()
```

#### 第二步：函数声明---Function Declaration: located in the class declaration.

```
protected:
    //{{AFX_MSG(CAboutDlg)
    afx_msg void OnClose();
    //}}AFX_MSG
    DECLARE_MESSAGE_MAP()
```

#### 第三步：函数执行---Function Implementation: located in the class implementation

```
void CAboutDlg::OnClose() 
{
    // TODO: Add your message handler code here and/or call default

    CDialog::OnClose();
}
```

By adding a `DECLARE_MESSAGE_MAP` statement to the class declaration, MFC adds the required code to declare the message map. The`BEGIN_MESSAGE_MAP` tells MFC where the Message Map begins, and identifies your class and it's base class. The reason it needs the base class is because Message Handlers are passed through c++ inheritance, just like any other function.`END_MESSAGE_MAP` obviously, tells MFC where the Message Map ends. In between these two macros is where your declare the Message Map entry for your Message Handler. MFC has many predefined macros, which associate messages with your member function. Take the the`ON_WM_CLOSE`macro as an example: It associates the`WM_CLOSE` message with your`OnClose()` member function. The macro takes no parameters since it always expects a function called`OnClose()` which is prototyped as`afx_msg void OnClose()`. This method gives you 2 advantages:

1. It is easy to keep track of Message Handlers and the messages they handle
2. MFC screens out any irrelevant and will break up lParam and wParam to parameters relevant to the message.

Also the return value is simplified, and the Message Handler is prototyped according to the message. For example: If the value should always be zero, MFC simplifies the process and allows you to declare the function as a`void`, and MFC will be responsible for returning 0. To find the name of the message handler that correlates with a given Message Handler macro you should look it up in the MFC documentation.

There are some messages that ClassWizard doesn't support, but you can manualy add your message handler by adding the function and Message Map macro as described above. If you add message-map entries manually, you may not be able to edit them with ClassWizard later. If you add them outside the bracketing comments `//{{AFX_MSG_MAP(classname)` and`//}}AFX_MSG_MAP`, ClassWizard cannot edit them at all. Note that by the same token ClassWizard will not touch any entries you add outside the comments, so feel free to add messages outside the comments if you do not want them to be modified. Messages that are not recognized by ClassWizard, such as message-map ranges, must be added outside the comments.

### The all mighty ON_MESSAGE

Sometimes you will find yourself trying to handle a message that ClassWizard doesn't support, and it doesn't have a Message Map macro. MFC has a generic macro just for this kind of situation`ON_MESSAGE`.`ON_MESSAGE`allows you to handle any message that exists. The prototype of Message Handlers that use`ON_MESSAGE` is

```
afx_msg LRESULT OnMessage(WPARAM wParam, LPARAM lParam);
```

where `OnMessage` is the name of your handler function. The`ON_MESSAGE` macro takes 2 parameters: The address of the handler, and the message it should handle. For example: The following statement Maps`WM_GETTEXTLENGTH` to`OnGetTextLength()`:

```
ON_MESSAGE (WM_GETTEXTLENGTH, OnGetTextLength)
```

`OnGetTextLength` is prototyped as

```
afx_msg LRESULT OnGetTextLength(WPARAM wParam, LPARAM lParam);

说明：以上部分还是接第一部分的类向导，通过ctrl+w快捷键进入，选择之后，vc6会自动把上文标注的三步骤放到相应的位置，下边自定义的消息（在类向导中没有的消息，自己定义的消息），则可以参考上文的三步骤，在和它们对应的位置添加，注意这个需要定义一个消息宏（下面红色标注），WM_APP现在应该为WM_USER，自定义消息只需要在WM_USER之上加上一个数字，因为一般WM_USER之前的消息，是系统消息（ctrl+w中看到的鼠标点击消息、键盘消息】重绘消息等）。
```

### User-defined messages

Sometimes, you will need to communicate between 2 windows in your application or between 2 windows from different applications. An easy way to do this is by using User-defined messages. The name "User-defined" can be confusing at first; you define a User-defined message and not the user of your program. I have stated in Part 1 that messages are identified by numbers, and that Windows predefines standard messages. The way of using predefined messages is to simply use a number. To make sure that you don't conflict with the system defined messages you should use a number in the range of `WM_APP` through 0xBFFF:

```
#define WM_DELETEALL WM_APP + 0x100
//...
pYourDialog->SendMessage(WM_DELETEALL, 0, 0);
```

Handling a user-defined message is done with the `ON_MESSAGE` macro:

```
#define WM_DELETEALL WM_APP + 0x100
//...
//Message Map entry:
ON_MESSAGE (WM_DELETEALL, OnDeleteAll)
//OnDeleteAll is prototyped as 
afx_msg LRESULT OnDeleteAll(WPARAM wParam, LPARAM lParam);
//And is implemented as 
LRESULT OnDeleteAll(WPARAM wParam, LPARAM lParam){
    //Do What ever you want
    return somevalue;
}
```

### Registered Windows Messages

The `RegisterWindowMessage` function is used to define a new window message that is guaranteed to be unique throughout the system. The macro`ON_REGISTERED_MESSAGE` is used to handle these messages. This macro accepts a name of a`UINT` variable that contains the registered Windows message ID. For example:

```
class CMyWnd : public CMyParentWndClass
{
public:
    CMyWnd();

    //{{AFX_MSG(CMyWnd)
    afx_msg LRESULT OnFind(WPARAM wParam, LPARAM lParam);
    //}}AFX_MSG

    DECLARE_MESSAGE_MAP()
};

static UINT WM_FIND = RegisterWindowMessage("YOURAPP_FIND_MSG");

BEGIN_MESSAGE_MAP(CMyWnd, CMyParentWndClass)
    //{{AFX_MSG_MAP(CMyWnd)
        ON_REGISTERED_MESSAGE(WM_FIND, OnFind)
    //}}AFX_MSG_MAP
END_MESSAGE_MAP()
```

The range of user defined messages using this approach will be in the range 0xC000 to 0xFFFF. And you send it using the regular`SendMessage()` method:

```
static UINT WM_FIND = RegisterWindowMessage("YOURAPP_FIND_MSG");
//...
pFindWindow->SendMessage(WM_FIND, lParam, wParam);
```

# （三）

说明 ：这部分才是消息处理的底层部分，前面MFC只是在这部分之上包了一层，所以你在那层看不到消息处理的本质。

## Handling Messages in SDK applications

This article assumes you are familiar with creating a window in an SDK program. The Dialog part assumes you are familiar with creating modal and modeless dialog in a SDK program.

Handling messages in SDK applications is a totally different process than MFC. No ClassWizard or macros to help you. No`CWinApp` to implement the Message Loop for you. It's all up to you.

### Windows Classes and Window Procedures

Window "classes" in traditional programming for Windows define the characteristics of a "class" (not a C++ class) from which any number of windows can be created. This kind of class is a template or model for creating windows. In Windows, every window has a Window Class that defines the attributes of a window such as the window's icon, the window's background and the window's procedure. To create a Window class, you call`RegisterClass` that accepts a`WNDCLASS` structure defining the properties of the Window class. Every window must have a window class, so typically,`RegisterClass`is called in`WinMain`.

Usually, the Message Loop is implemented as a basic `while` loop:

```
MSG msg; 
while (GetMessage (&msg, NULL, 0, 0)) 
{
    TranslateMessage (&msg); 
    DispatchMessage (&msg);
} 
return msg.wParam;
```

The `MSG` structure is a structure that holds all the information about the message: The window it was sent to, the message identifier, the 2`lParam`/`wParam` parameters that come with the message, the time at which the message was sent, and the position of the mouse when the message was sent.

The call to `GetMessage` tells windows to retrieve the first message in the Message Queue. If there is no message in the Message Queue,`GetMessage` will not return until there is. The return value from`GetMessage`depends on the message it retrieved: If it was a`WM_QUIT` message it will return`FALSE`, if it wasn't, it will return`TRUE`. The`TranslateMessage` function translates virtual-key messages into character messages. The character messages are posted to the calling thread's Message Queue, to be read the next time the thread calls the`GetMessage` function. For example, if you get a`WM_KEYDOWN` message,`TranslateMessage` will add a`WM_CHAR` message to your Message Queue. This is very useful because the`WM_KEYDOWN` will only tell you what key has been pressed, not the character itself. A`WM_KEYDOWN` for`VK_A` could mean "a" or "A", depending on the state of the Caps Lock and Shift key.`TranslateMessage` will do the work of checking if it should be capital for you. The call to`DispatchMessage` will call the Window Procedure associated with the window that received the message. That's the SDK Message Loop in a nutshell.

A Window Procedure is a function called by the Message Loop. Whenever a message is sent to a window, the Message Loop looks at the window's Window Class and calls the Window Procedure passing the message's information. A Window Procedure is prototyped as:

```
LRESULT CALLBACK WindowProc( 
    HWND hwnd, // handle to window 
    UINT uMsg, // message identifier 
    WPARAM wParam, // first message parameter 
    LPARAM lParam // second message parameter 
); 
```

The `HWND` is the handle to the window that received the message. This parameter is important since you might create more than one window using the same window class.`uMsg` is the message identifier, and the last 2 parameters are the parameters sent with the message.

Typically, a Window Procedure is implemented as a set of `switch` statements, and a call to the default window procedure:

```
LRESULT CALLBACK WndProc (HWND hwnd, UINT uMsg, 
                      WPARAM wParam, LPARAM lParam) { 
    switch (uMsg)
    { 
    case WM_CREATE: 
        //Do some initialization, Play a sound or what ever you want
        return 0 ; 
    case WM_PAINT: 
        //Handle the WM_PAINT message
        return 0 ; 
    case WM_DESTROY: 
        PostQuitMessage (0) ;
        return 0 ; 
    }
    return DefWindowProc (hwnd, message, wParam, lParam) ; 
}
```

The `switch`-`case` block inspects the message identifier passed in the`uMsg` parameter and runs the corresponding message handler. The`PostQuitMessage` call will send a`WM_QUIT` message to the Message Loop, causing`GetMessage()` to return`FALSE`, and the Message Loop to halt.

### DefWindowProc

As I stated in Part 1, Windows should handle any message you don't handle. The call to`DefWindowProc()` gives Windows a shot at the message. Some messages such as`WM_PAINT` and `WM_DESTROY` must be handled in your Window Procedure, and not in`DefWindowProc`.

### Putting it all together: AllToGether.C（这个是核心的处理函数，入口函数）

```
#include <windows.h>
//Declare the Window Procedure
LRESULT CALLBACK WndProc (HWND, UINT, WPARAM, LPARAM) ;

int WINAPI WinMain(
    HINSTANCE hInstance,  // handle to current instance
    HINSTANCE hPrevInstance,  // handle to previous instance
    LPSTR lpCmdLine,      // pointer to command line
    int nCmdShow          // show state of window
){
    static TCHAR lpszClassName[] = TEXT ("AllTogether") ;
    HWND         hwndMainWindow ;
    MSG          msg ;
    WNDCLASS     wndclass ;//窗口类，窗口显示的样式
    //Fill in the Window class data
    wndclass.cbClsExtra    = 0 ;
    wndclass.cbWndExtra    = 0 ;
    // The default window background
    wndclass.hbrBackground = COLOR_WINDOW;
    // The system, IDC_ARROW cursor
    wndclass.hCursor       = LoadCursor (NULL, IDC_ARROW) ;
    //The system IDI_APPLICATION icon
    wndclass.hIcon         = LoadIcon (NULL, IDI_APPLICATION) ;
    wndclass.hInstance     = hInstance ;
    wndclass.lpfnWndProc   = WndProc ;
    //The name of the class, needed for CreateWindow
    wndclass.lpszClassName = lpszClassName;
    wndclass.lpszMenuName  = NULL ;
    wndclass.style         = CS_HREDRAW | CS_VREDRAW ;

    RegisterClass (&wndclass);//注册类，下面是创建窗体
    hwndMainWindow = 
        CreateWindow (lpszClassName, // pointer to registered class name
            TEXT ("Lets Put it all together"), // pointer to window name
            WS_OVERLAPPEDWINDOW, // window style
            CW_USEDEFAULT, CW_USEDEFAULT, // position of window
            CW_USEDEFAULT, CW_USEDEFAULT, // size of window
            NULL, // handle to parent or owner window
            NULL, // handle to menu 
            hInstance, // handle to application instance
            NULL) ; // pointer to window-creation data
     ShowWindow (hwnd, nCmdShow);
     UpdateWindow (hwnd) ;

     while (GetMessage (&msg, NULL, 0, 0))//消息循环
     {
          TranslateMessage (&msg) ;
          DispatchMessage (&msg) ;
     }
     return msg.wParam ;
}

LRESULT CALLBACK WndProc (HWND hwnd, UINT uMsg, 
                       WPARAM wParam, LPARAM lParam) { 
    switch (uMsg)
    { 
    case WM_CREATE: 
        //Do some initialization, Play a sound or what ever you want
        return 0 ; 
    case WM_PAINT: 
        //Handle the WM_PAINT message
        return 0 ; 
    case WM_DESTROY: 
        PostQuitMessage (0) ;
        return 0 ; 
    }
    return DefWindowProc (hwnd, message, wParam, lParam) ; 
}
```

### Sending Messages

Besides receiving messages, you will often find yourself sending messages. You might want to send messages to communicate between two windows in your program, or to communicate between different programs. In order to send a message, you need a handle to the target window. This can be retrieved using a variety of functions, including`FindWindow()`,`GetDlgItem()`, `GetParent()`,`EnumWindows()` and many more. The SDK has a`SendMessage()` function which allows you to send messages to a window. For example, let's say you have a handle to the Calculator, and you want to close it. What you should do is send a`WM_CLOSE` message, which will notify the Calculator that it should close. You can use the following code. In order to get a pointer to Calculator, I use the`FindWindow()` function and pass the title of the window, which in our case is "Calculator":

```
HWND hWndCalc;
//Get a handle to the "Calculator" Window
hWndCalc = FindWindow(NULL, TEXT("Calculator));
if(hWndCalc == NULL)
{
    //Couldn't find Calculator
}
else
{
    SendMessage(hWndCalc, WM_CLOSE, 0, 0);
    //Presto! The Calculator should close.
}
```

### LOWORD and HIWORD macros: Split up lParam and wParam

Often, one or more of the 32-bit `lParam` and`wParam` parameters are actually made of two 16-bit parameters. One case is the`WM_MOUSEMOVE` message. MSDN states that the`lParam` for this message is actually 2 values: the X position of the mouse, and the Y position of the mouse. But how do you retrieve the values from the`lParam`? The SDK has 2 macros designed for exactly this purpose:`LOWORD()` and`HIWORD()`. The `LOWORD` macro retrieves the low-order word from the given 32-bit value, and the`HIWORD()` macro retrieves the high-order word. So, given an`lParam` of `WM_MOUSEMOVE`, you can retrieve the coordinates using the following code:

```
WORD xPos = LOWORD(lParam);  // horizontal position of cursor 
WORD yPos = HIWORD(lParam);  // vertical position of cursor 
```

### MAKELPARAM and MAKEWPARAM macros: concatenate two 16-bit values

`LOWORD` and `HIWORD` are fine if you want to split up the parameters, but what if you want to create a 32-bit value for use as an`lParam` or`wParam` parameter in a message? The SDK has 2 macros for this situation also:`MAKELPARAM` and`MAKEWPARAM` both combine two 16-bit values into a 32-bit value, that is usable for messages. For example, the following code sends a`WM_MOUSEMOVE` message to a window (`HWND hWndTarget`) with the`fFlags` parameter as the`wParam`, and the x/y coordinates as the`lParam`:

```
SendMessage(hWndTarget, WM_MOUSEMOVE, fFlags, MAKELPARAM(x,y));
```

### Dialogs

Handling a message in a dialog is very similar to handling a message in a normal window. Windows have Window Procedures, Dialogs have Dialog Procedures. One major difference is that you don't specify a window class for a dialog. When you create a dialog using one of the `CreateDialog...` functions or the`DialogBox...`functions, you pass a Dialog Procedure as one of the parameters. A Dialog Procedure is prototyped as:

```
BOOL CALLBACK DialogProc(
    HWND hwndDlg,  // handle to dialog box
    UINT uMsg,     // message
    WPARAM wParam, // first message parameter
    LPARAM lParam  // second message parameter
); 
```

You might have noticed that the Dialog Procedure looks very similar to the Window Procedure, but it isn't a real Window Procedure. The Window Procedure for the dialog is located inside windows. That Window Procedure calls your Dialog Procedure when various messages are sent to your window. Because of the above, there are messages that you will receive in a Window Procedure that you won't receive in a Dialog Procedure. There are a few major differences between a Window Procedure and a Dialog Procedure:

- A Dialog Procedure returns a `BOOL`, a Window Procedure returns a`LRESULT`.
- A Dialog Procedure doesn't need to handle `WM_PAINT` or`WM_DESTROY`.
- A Dialog Procedure doesn't receive a `WM_CREATE` message, but rather a`WM_INITDIALOG` message
- A Window Procedure calls `DefWindowProc()` for messages it does not handle. A Dialog Procedure should return`TRUE` if it handled the message or`FALSE` if not with one exception: if you set the input focus to a control in`WM_INITDIALOG`, you should return`FALSE`.

### User-defined messages

Sometimes, you will need to communicate between 2 windows in your application or between 2 windows from different applications. An easy way to do this is by using User-defined messages. The name "User-defined" can be confusing at first; you define a User-defined message and not the user of your program. I have stated in Part 1 that messages are identified by numbers, and that Windows predefines standard messages. The way of using user-defined messages is to simply use a number. To make sure that you don't conflict with the system defined messages, you should use a number in the range of `WM_APP` through 0xBFFF:

```
#define WM_DELETEALL WM_APP + 0x100
//...
SendMessage(hWndYourDialog, WM_DELETEALL, 0, 0);
```

You handle a user-defined message just like you handle a regular message:

```
#define WM_DELETEALL WM_APP + 0x100
//Window Procedure
LRESULT CALLBACK WndProc (HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) 
{ 
    switch (uMsg) 
    { 
    case WM_DELETEALL:
        //We've got the user-defined message, lets Delete All
        return 0;
    case WM_CREATE: 
        //Do some initialization, Play a sound or what ever you want
        return 0 ; 
    case WM_PAINT: 
        //Handle the WM_PAINT message
        return 0 ; 
    case WM_DESTROY: 
        PostQuitMessage (0) ;
        return 0 ; 
    }
    return DefWindowProc (hwnd, message, wParam, lParam) ; 
}
```

### Registered Windows Messages

The `RegisterWindowMessage` function is used to define a new window message that is guaranteed to be unique throughout the system. Like user-defined messages, Registered Messages are handled like regular messages:

```
static UINT WM_FIND = RegisterWindowMessage(TEXT("YOURAPP_FIND_MSG");
//Window Procedure
LRESULT CALLBACK WndProc (HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) 
{
    switch (uMsg)
    { 
    case WM_FIND:
        //We've got the registered message, lets start Finding.
        return 0;
    case WM_CREATE: 
        //Do some initialization, Play a sound or what ever you want
        return 0 ; 
    case WM_PAINT: 
        //Handle the WM_PAINT message
        return 0 ; 
    case WM_DESTROY: 
        PostQuitMessage (0) ;
        return 0 ; 
    }
    return DefWindowProc (hwnd, message, wParam, lParam) ; 
}
```

The registered message identifiers using this approach will be in the range of 0xC000 to 0xFFFF. And you send it using the regular`SendMessage()` method:

```
static UINT WM_FIND = RegisterWindowMessage(TEXT("YOURAPP_FIND_MSG"));
//...
SendMessage(hWndFindWindow, WM_FIND, lParam, wParam);
```

# （四）

这部分没研究，可以看看，原文：http://www.codeproject.com/Articles/600/Windows-Message-Handling-Part-4

## Introduction

Subclassing is a technique that allows an application to intercept and process messages sent or posted to a particular window before the window has a chance to process them. This is typically done by replacing the Window Procedure for a window with application-defined window procedure. I will devide this article into 3:

### Why subclass?

Sometimes you want to take the functionality of a control and modify it slightly. One example is replacing the menu in an edit control, Another is adding a context menu when you press on a button. One of the most common questions I encounter is "How do I screen out characters from an edit control?". I will show the solution to this from an MFC approach and from an SDK approach, while I try to explain Subclassing.

The need for subclassing comes from the fact that the code for the Windows controls is within Windows, meaning you cannot edit the code. Although you cannot edit the code of the control itself, you intercept the messages sent to it, and handle them your self. You do so by subclassing the control. Subclassing involves replacing the Message Handlers of the control, and passing any unprocessed message to the controls Message Handler.

### SDK Subclassing

Although the Message Procedure for the control is located within windows, you can retrieve a pointer to it by using the`GetWindowLong` function with the`GWL_WNDPROC` identifier. Likewise, you can call`SetWindowLong` and specify a new Window Procedure for the control. This process is called Subclassing, and allows you to hook into a window/control and intercept any message it gets. Subclassing is the Windows term for replacing the Window Procedure of a window with a different Window Procedure and calling the old Window Procedure for default (superclass) functionality. Remember`DefWindowProc()`? instead of calling`DefWindowProc` for default Message Handling you use the old Window Procedure as the default Message Handler.

### Implementing SDK Subclassing

So, lets try to solve the classic question "How do I screen out characters from an edit control?", or "How do I create a letter-only edit control?"

#### First lets analyze how an edit control works:

An edit control is a window. It's window procedure lies within windows. Among other things, whenever it gets a`WM_CHAR` message it adds the character to the text it contains. Now that we know that, we can simply subclass the edit control, and intercept the`WM_CHAR` messages. Whenever the`WM_CHAR` message is a letter or a key like space bar or backspace we'll pass the message to the edit control. If it isn't one of the above, we'll just "Swallow" the message, blocking it from reaching the Edit Control.

The first step to subclassing is to add a global/static `WNDPROC` variable that will store the address of the edit control's Window Procedure.

```
WNDPROC g_OldEdit;
```

The second step is to create a new Window Procedure for the edit control:

```
LRESULT CALLBACK NewEditProc (HWND hwnd, UINT message, 
                             WPARAM wParam, LPARAM lParam)
{

    TCHAR chCharCode;
    switch (message)
    {
    case WM_CHAR:
        chCharCode = (TCHAR) wParam;
        if(chCharCode > 0x20 && !IsCharAlpha(chCharCode))
            return 0;
        break;
    }
    return CallWindowProc (g_OldEdit, hwnd, message, wParam, lParam);
}
```

The `IsCharAlpha` function determines whether a character is an alphabetic character. This determination is based on the semantics of the language selected by the user during setup or by using Control Panel.

More interesting is the `CallWindowProc` function. The`CallWindowProc` function passes message information to the specified Window Procedure. A call to`CallWindowProc` will allow you to call the old Window Procedure with any message you receive, thus providing default message handling

The third step is to replace the Window Procedure for the edit control, and to store the old one in*g_OldEdit*. For example, if you want to subclass an edit control that resides in a dialog (hDlg) and has the ID of`IDC_EDIT1`you would use the following code:

```
hwnd hWndEdit = GetDlgItem(hDlg, IDC_EDIT1);<BR>//Replace the Window Procedure and Store the Old Window Procedure
g_OldEdit = (WNDPROC)SetWindowLong(hWndEdit, GWL_WNDPROC, (LONG)NewEditProc);
```

The control is now subclassed. Any message to the edit control will first go through the`NewEditProc` Window Procedure, which will decide if the message should go to the edit control's Window Procedure .

### MFC Subclassing

Subclassing in both MFC and SDK programs is done by replacing the message handlers of a control. It is rather easy to subclass in a MFC program. First you inherit your class from a class that encapsulates the functionality of a the control. In ClassWizard, click on "Add Class", then "New". For the base class, choose the MFC Control class you are deriving from, in our case,`CEdit`.

![img](./images/scrnsht1.jpg)

Using MFC relieves you from having to call the old Message Handlers, since MFC will take care of it for you.
The second step is to add Message Handlers to your new class. If you handle a message and you want the control's message handler to get a shot at it, you should call the base class member function the corresponds with the message. this is the subclassed`WM_CHAR` handler:

```
void CLetterEdit::OnChar(UINT nChar, UINT nRepCnt, UINT nFlags) 
{
    if(nChar <= 0x20 || IsCharAlpha((TCHAR)nChar))<BR>        {
          //Call base class member, which will call <BR>          //the control's message handler
          CEdit::OnChar(nChar, nRepCnt, nFlags);
          //If not, the message is blocked<BR>        }
}
```

The third and final stage is to associate the window with an instance of our new class. In a dialog this is done simply by using ClassWizard to create a**control** member variable of your class in the window's parent, and associate it with the control.

![img](./images/scrnsht2.jpg)

In a non-dialog parent you should add a member variable instance of your control to it, and call one of the two`CWnd` Subclassing functions:`CWnd::SubclassWindow or CWnd::SubclassDlgItem`. Both routines attach a`CWnd`object to an existing Windows`HWND`.`SubclassWindow` takes the`HWND` directly, and`SubclassDlgItem` is a helper that takes a control ID and the parent window (usually a dialog).`SubclassDlgItem`is designed for attaching C++ objects to dialog controls created from a dialog template.

## Further Reading

For a more in depth treatment of MFC subclassing see Chris Maunder's article: "[Create your own controls - the art of subclassing](http://www.codeproject.com/miscctrl/subclassdemo.asp)".

#### 

## Reflected Messages - MFC 4.0+

When you subclass a control, besides handling the message it receives, in MFC you can also handle the notifications it sends to it's parent window. This technique is called Message Reflecting. Windows controls often send notifications to their parents, for example, a Button will send a `WM_COMMAND` message telling it's parent it has been clicked. Usually it is the parent's job to handle these messages, but MFC will also allow you to handle them in the control itself. In ClassWizard these messages appear with an "=" sign before them, indicating they are Reflected Messages. You handle them just like any other message. The macros for these messages are similar to the regular messages, but have`_REFLECT` added to the end of the macro. For example,`ON_NOTIFY()` becomes`ON_NOTIFY_REFLECT()`.