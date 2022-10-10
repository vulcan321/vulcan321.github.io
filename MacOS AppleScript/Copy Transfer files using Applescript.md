```applescript
tell application "Finder"
    set sfolder to folder "Documents" of folder "xxx" of folder "Users" of startup disk
    delay 0.5
    set tfolder to folder "transfer"
    duplicate sfolder to tfolder
 end tell
```