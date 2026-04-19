# Objective-C 运行AppleScript脚本

 

在Objective-C里其实也可以运行AppleScript

第一种方式是Source 将脚本写到变量[字符串](https://so.csdn.net/so/search?q=%E5%AD%97%E7%AC%A6%E4%B8%B2&spm=1001.2101.3001.7020)里

```objc
    NSAppleEventDescriptor *eventDescriptor = nil;
    NSAppleScript *script = nil;
    NSBundle *bunlde = [NSBundle mainBundle];
    NSString *scriptSource = @"tell application \"Finder\"\r"
                            "display dialog \"test\"\r"
                            "end tell";
    if (scriptSource)
    {
        script = [[NSAppleScript alloc] initWithSource:scriptSource];
        if (script)
        {
            eventDescriptor = [script executeAndReturnError:nil];
            if (eventDescriptor)
            {
                NSLog(@"%@", [eventDescriptor stringValue]);
            }
        }
    }
```

  
第二种方式是将File， 将脚本写到文件里

```objc
    NSAppleEventDescriptor *eventDescriptor = nil;
    NSAppleScript *script = nil;
    NSBundle *bunlde = [NSBundle mainBundle];
    NSString *scriptPath = @"/Users/exchen/Documents/test.scpt";
    if (scriptPath)
    {
        script = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:scriptPath] error:nil];
        if (script)
        {
            eventDescriptor = [script executeAndReturnError:nil];
            if (eventDescriptor)
            {
                NSLog(@"%@", [eventDescriptor stringValue]);
            }
        }
    }
```