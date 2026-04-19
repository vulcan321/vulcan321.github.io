# Microsoft Script Control

## Adding VBA reference

In order to programmatically add the VBA reference for `C:\Windows\SysWOW64\msscript.ocx`, the following snippet might help:

```vbnet
call application.VBE.activeVBProject.references.addFromGuid("{0E59F1D2-1FBE-11D0-8FF2-00A0D10038BC}", 1, 0)

```

## language

`language` can be set to either `"[VBScript](https://renenyffenegger.ch/notes/development/languages/VBScript/index)"` or [`"JScript"`](https://renenyffenegger.ch/notes/development/languages/JavaScript/index).

## Parsing JSON

The following simple example tries to show how [JSON](https://renenyffenegger.ch/notes/development/languages/JavaScript/JSON/index) might be parsed with [Visual Basic for Applications](https://renenyffenegger.ch/notes/development/languages/VBA/index).

```vbnet
'
'   https://stackoverflow.com/a/37711113  was quite helpful.
'
option explicit

sub main() ' {

    dim jsonText as string

    jsonText =                                        _
    "{"                                        & vbcrlf & _
    "  ""num"" :  42,"                         & vbcrlf & _
    "  ""lst"" : [""foo"", ""bar"", ""baz""]," & vbcrlf & _
    "  ""obj"" : {""hello"": ""World""}"       & vbcrlf & _
    "}"

    debug.print(jsonText)

    dim scrContr as new MSScriptControl.ScriptControl
    scrContr.language = "JScript"

    dim parsed as object ' MSScriptControl.JScriptTypeInfo ?

    set parsed = scrContr.eval("(" & jsonText & ")")

    debug.print("num       = " & parsed.num      )
    debug.print("obj.hello = " & parsed.obj.hello)

  '
  ' Apparently, Arrays are a bit more complicated to access
  '
    dim lenLst as long
    lenLst = callByName(parsed.lst, "length", vbGet)

    dim i as long
    for i = 0 to lenLst-1
        debug.print("lst(" & i & ")    = " & callByName(parsed.lst, i, vbGet))
    next i

end sub ' }

```

Github respository [about-VBA](https://github.com/ReneNyffenegger/about-VBA), path: [/object-libraries/Microsoft-Script-Control/parseJSON.bas](https://github.com/ReneNyffenegger/about-VBA/blob/master/object-libraries/Microsoft-Script-Control/parseJSON.bas)

## Calling a JavaScript function

This example tries to demonstrate how a trival [JavaScript](https://renenyffenegger.ch/notes/development/languages/JavaScript/index) function might be called in VBA.

```vbnet
option explicit

sub main() ' {

    dim jsFunc as string

    cells(2,2) = "B2"
    cells(2,3) = "B3"
    cells(3,2) = "C2"
    cells(3,3) = "C3"

    jsFunc = _
      "function tq84(val, rng) {" & vbCrLf & _
      "   return 'val = ' + val+ ', rng.address = ' + rng.address;" & vbCrLf & _
      "}"

  ' debug.print(jsFunc)

    dim scrContr as new MSScriptControl.ScriptControl
    scrContr.language = "JScript"

    scrContr.addCode(jsFunc)

    dim res as string
    res = scrContr.run("tq84", 42, range(cells(2,2), cells(3,3)))

    debug.print("res: " & res)

end sub '

```