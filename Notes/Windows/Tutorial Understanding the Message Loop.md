# Understanding the Message Loop

Understanding the message loop and entire message sending structure of windows programs is essential in order to write anything but the most trivial programs. Now that we've tried out message handling a little, we should look a little deeper into the whole process, as things can get very confusing later on if you don't understand why things happen the way they do.

### What is a Message?

A message is an integer value. If you look up in your header files (which is good and common practice when investigating the workings of API's) you can find things like:

```
#define WM_INITDIALOG                   0x0110
#define WM_COMMAND                      0x0111

#define WM_LBUTTONDOWN                  0x0201

```

...and so on. Messages are used to communicate pretty much everything in windows at least on basic levels. If you want a window or control (which is just a specialized window) to do something you send it a message. If another window wants you to do something it sends you a message. If an event happens such as the user typing on the keyboard, moving the mouse, clicking a button, then messages are sent by the system to the windows affected. If you are one of those windows, you handle the message and act accordingly.

Each windows message may have up to two parameters, `wParam` and `lParam`. Originally `wParam` was 16 bit and `lParam` was 32 bit, but in Win32 they are both 32 bit. Not every message uses these parameters, and each message uses them differently. For example the `WM_CLOSE` message doesn't use either, and you should ignore them both. The `WM_COMMAND` message uses both, `wParam` contains _two_ values, `HIWORD(wParam)` is the notification message (if applicable) and `LOWORD(wParam)` is the control or menu id that sent the message. `lParam` is the `HWND` (window handle) to the control which sent the message or `NULL` if the messages isn't from a control.

`HIWORD()` and `LOWORD()` are macros defined by windows that single out the two high bytes (High Word) of a 32 bit value (`0x**FFFF**0000`) and the low word (`0x0000**FFFF**`) respectively. In Win32 a `WORD` is a 16bit value, making `DWORD` (or Double Word) a 32bit value.

To send a message you can use `PostMessage()` or `SendMessage()`. `PostMessage()` puts the message into the _Message Queue_ and returns immediatly. That means once the call to `PostMessage()` is done the message may or may not have been processed yet. `SendMessage()` sends the message directly to the window and does not return untill the window has finished processing it. If we wanted to close a window we could send it a `WM_CLOSE` message like this `PostMessage(hwnd, WM_CLOSE, 0, 0);` which would have the same effect as clicking on the ![[x]](http://www.winprog.org/tutorial/message_loop.htmlimages/button_close.gif) button on the top of the window. Notice that `wParam` and `lParam` are both `0`. This is because, as mentioned, they aren't used for `WM_CLOSE`.

### Dialogs

Once you begin to use dialog boxes, you will need to send messages to the controls in order to communicate with them. You can do this either by using `GetDlgItem()` first to get the handle to the control using the ID and then use `SendMessage()`, OR you can use `SendDlgItemMessage()` which combines the steps. You give it a window handle and a child ID and it will get the child handle, and then send it the message. `SendDlgItemMessage()` and similar APIs like `GetDlgItemText()` will work on all windows, not just dialog boxes.

### What is the Message Queue

Lets say you were busy handling the `WM_PAINT` message and suddenly the user types a bunch of stuff on the keyboard. What should happen? Should you be interrupted in your drawing to handle the keys or should the keys just be discarded? Wrong! Obviously neither of these options is reasonable, so we have the message queue, when messages are posted they are added to the message queue and when you handle them they are removed. This ensure that you aren't going to miss messages, if you are handling one, the others will be queued up untill you get to them.

### What is a Message Loop

```
while(GetMessage(&Msg, NULL, 0, 0) > 0)
{
    TranslateMessage(&Msg);
    DispatchMessage(&Msg);
}

```

1.  The message loop calls `GetMessage()`, which looks in your message queue. If the message queue is empty your program basically stops and waits for one (it _Blocks_).
2.  When an event occures causing a message to be added to the queue (for example the system registers a mouse click) `GetMessages()` returns **a positive value** indicating there is a message to be processed, and that it has filled in the members of the `MSG` structure we passed it. It returns `0` if it hits `WM_QUIT`, and **a negative value** if an error occured.
3.  We take the message (in the `Msg` variable) and pass it to `TranslateMessage()`, this does a bit of additional processing, translating virtual key messages into character messages. This step is actually optional, but certain things won't work if it's not there.
4.  Once that's done we pass the message to `DispatchMessage()`. What `DispatchMessage()` does is take the message, checks which window it is for and then looks up the Window Procedure for the window. It then calls that procedure, sending as parameters the handle of the window, the message, and `wParam` and `lParam`.
5.  In your window procedure you check the message and it's parameters, and do whatever you want with them! If you aren't handling the specific message, you almost always call `DefWindowProc()` which will perform the default actions for you (which often means it does nothing).
6.  Once you have finished processing the message, your windows procedure returns, `DispatchMessage()` returns, and we go back to the beginning of the loop.

This is a very important concept for windows programs. Your window procedure is not magically called by the system, in effect _you call it yourself_ indirectly by calling `DispatchMessage()`. If you wanted, you could use `GetWindowLong()` on the window handle that the message is destined for to look up the window's procedure and call it directly!

```
while(GetMessage(&Msg, NULL, 0, 0) > 0)
{
    WNDPROC fWndProc = (WNDPROC)GetWindowLong(Msg.hwnd, GWL_WNDPROC);
    fWndProc(Msg.hwnd, Msg.message, Msg.wParam, Msg.lParam);
}

```

I tried this with the previous example code, and it does work, however there are various issues such as Unicode/ANSI translation, calling timer callbacks and so forth that this method will not account for, and very likely will break all but trivial applications. So do it to try it, but don't do it in real code :)

Notice that we use `GetWindowLong()` to retreive the window procedure associated with the window. Why don't we just call our `WndProc()` directly? Well our message loop is responsible for ALL of the windows in our program, this includes things like buttons and list boxes that have their own window procedures, so we need to make sure that we call the right procedure for the window. Since more than one window can use the same window procedure, the first parameter (the handle to the window) is used to tell the window procedure which window the message is intended for.

As you can see, your application spends the majority of it's time spinning round and round in this message loop, where you joyfully send out messages to the happy windows that will process them. But what do you do when you want your program to exit? Since we're using a `while()` loop, if `GetMessage()` were to return `FALSE` (aka `0`), the loop would end and we would reach the end of our `WinMain()` thus exiting the program. This is exactly what `PostQuitMessage()` accomplishes. It places a `WM_QUIT` message into the queue, and instead of returning a positive value, `GetMessage()` fills in the Msg structure and returns `0`. At this point, the `wParam` member of `Msg` contains the value that you passed to `PostQuitMessage()` and you can either ignore it, or return it from `WinMain()` which will then be used as the exit code when the process terminates.

**IMPORTANT:** `GetMessage()` will return `**-1**` if it encounters an error. Make sure you remember this, or it will catch you out at some point... even though `GetMessage()` is defined as returning a `BOOL`, it can return values other than `TRUE` or `FALSE`, since `BOOL` is defined as `UINT` (`unsigned int`). The following are examples of code that may _seem_ to work, but will not process certian conditions correctly:

```
    while(GetMessage(&Msg, NULL, 0, 0))

```

```
    while(GetMessage(&Msg, NULL, 0, 0) != 0)

```

```
    while(GetMessage(&Msg, NULL, 0, 0) == TRUE)

```

**The above are all wrong!** It may be of note that I used to use the first of these throughout the tutorial, since as I just mentioned, it works fine as long as `GetMessage()` never fails, which when your code is correct it won't. However I failed to take into consideration that if you're reading this, your code probably won't be correct a lot of the time, and `GetMessage()` will fail at some point :) I've gone through and corrected this, but forgive me if I've missed a few spots.

```
    while(GetMessage(&Msg, NULL, 0, 0) > 0)

```

This, or code that has the same effect should always be used.

I hope you now have a better understanding of the windows message loop, if not, do not fear, things will make more sense once you have been using them for a while.