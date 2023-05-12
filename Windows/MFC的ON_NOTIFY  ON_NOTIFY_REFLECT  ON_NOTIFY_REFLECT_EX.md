# MFC的ON\_NOTIFY / ON\_NOTIFY\_REFLECT / ON\_NOTIFY\_REFLECT\_EX



_**ON\_NOTIFY** : Comes from a child control to the parent. This macro goes in the parent’s message map._  
ON\_NOTIFY是子控件把消息发送给父窗口，由父窗口来处理消息，消息处理函数在父控件的类里面。

_**ON\_NOTIFY\_REFLECT**: Comes from a child control, but is “reflected” back to the child (by the parent)so the child can handle its own notification. This macro goes in the child’s message map._  
ON\_NOTIFY\_REFLECT反射，就是说这个消息由子窗口自己来处理

_**ON\_NOTIFY\_REFLECT\_EX**: Same as previous, except that the handler function returns a BOOL, indicating whether or not the message should be routed on to parent classes for possible handlers. Note that the reflected message is handled before the notification message._  
如果ON\_NOTIFY\_REFLECT\_EX(消息， 消息处理函数)中的第二个参数也就是消息处理函数的返回值是bool类型的，且返回值是TRUE，那么就是说这个消息会既发给子控件又发给父窗口，即又在子控件里处理该消息，又在父窗口里处理该消息，如果返回值是FLASE的话或者是其他类型的返回值的话，就只发给子控件了，这个时侯ON\_NOTIFY\_REFLECT\_EX就相当于ON\_NOTIFY\_REFLECT。