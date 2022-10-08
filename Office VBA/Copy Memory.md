The following is a fully fledged example which uses conditional compilation* to allow it to work on any Mac/Windows/32-bit/64-bit computer. 

It also demonstrates the two different ways to declare and call the function (by Pointer and by Variable).
```vbnet
#If Mac Then
  #If Win64 Then
    Private Declare PtrSafe Function CopyMemory_byPtr Lib "libc.dylib" Alias "memmove" (ByVal dest As LongPtr, ByVal src As LongPtr, ByVal size As Long) As LongPtr
    Private Declare PtrSafe Function CopyMemory_byVar Lib "libc.dylib" Alias "memmove" (ByRef dest As Any, ByRef src As Any, ByVal size As Long) As LongPtr
  #Else
    Private Declare Function CopyMemory_byPtr Lib "libc.dylib" Alias "memmove" (ByVal dest As Long, ByVal src As Long, ByVal size As Long) As Long
    Private Declare Function CopyMemory_byVar Lib "libc.dylib" Alias "memmove" (ByRef dest As Any, ByRef src As Any, ByVal size As Long) As Long
  #End If
#ElseIf VBA7 Then
  #If Win64 Then
    Private Declare PtrSafe Sub CopyMemory_byPtr Lib "kernel32" Alias "RtlMoveMemory" (ByVal dest As LongPtr, ByVal src As LongPtr, ByVal size As LongLong)
    Private Declare PtrSafe Sub CopyMemory_byVar Lib "kernel32" Alias "RtlMoveMemory" (ByRef dest As Any, ByRef src As Any, ByVal size As LongLong)
  #Else
    Private Declare PtrSafe Sub CopyMemory_byPtr Lib "kernel32" Alias "RtlMoveMemory" (ByVal dest As LongPtr, ByVal src As LongPtr, ByVal size As Long)
    Private Declare PtrSafe Sub CopyMemory_byVar Lib "kernel32" Alias "RtlMoveMemory" (ByRef dest As Any, ByRef src As Any, ByVal size As Long)
  #End If
#Else
  Private Declare Sub CopyMemory_byPtr Lib "kernel32" Alias "RtlMoveMemory" (ByVal dest As Long, ByVal src As Long, ByVal size As Long)
  Private Declare Sub CopyMemory_byVar Lib "kernel32" Alias "RtlMoveMemory" (ByRef dest As Any, ByRef src As Any, ByVal size As Long)
#End If


Public Sub CopyMemoryTest()

  Dim abytDest(0 To 11) As Byte
  Dim abytSrc(0 To 11) As Byte
  Dim ¡ As Long

  For ¡ = LBound(abytSrc) To UBound(abytSrc)
    abytSrc(¡) = AscB("A") + ¡
  Next ¡

  MsgBox "Dest before copy = #" & ToString(abytDest) & "#"
  CopyMemory_byVar abytDest(0), abytSrc(0), 4
  MsgBox "Dest during copy = #" & ToString(abytDest) & "#"
  CopyMemory_byPtr VarPtr(abytDest(0)) + 4, VarPtr(abytSrc(0)) + 4, 4
  MsgBox "Dest during copy = #" & ToString(abytDest) & "#"
  CopyMemory_byPtr VarPtr(abytDest(8)), VarPtr(abytSrc(8)), 4
  MsgBox "Dest after copy = #" & ToString(abytDest) & "#"

End Sub

Public Function ToString(ByRef pabytBuffer() As Byte) As String
  Dim ¡ As Long
  For ¡ = LBound(pabytBuffer) To UBound(pabytBuffer)
    ToString = ToString & Chr$(pabytBuffer(¡))
  Next ¡
End Function
```

Explanation:

The Mac version of the CopyMemory function returns a result whilst the Win version does not. (The result is the dest pointer, unless an error occurred. See the memmove reference here.) Both versions, however, can be used in exactly the same way, without brackets.

The declare differences are as follows:

64-bit Mac/Win VBA7:

Use the PtrSafe keyword
Use the Any type for all ByRef parameters
Use the LongPtr type for ByVal handle/pointer parameters/return values
Use the LongLong type appropriately for other return values/parameter
32-bit Win VBA7:

Use the PtrSafe keyword
Use the Any type for all ByRef parameters
Use the LongPtr type for ByVal handle/pointer parameters/return values
Use the Long (not LongLong) type appropriately for other return values/parameter
32-bit Mac/Win VBA6:

No PtrSafe keyword
Use the Any type for all ByRef parameters
Use the Long type for ByVal handle/pointer parameters/return values
Use the Long type appropriately for other return values/parameter
Caveats:

Tested on Mac Excel 2016 64-bit.
Tested on Windows Excel 2007 32-bit.

Seems Excel 2007 has issues related to double word alignment. In this example:

CopyMemory_byVar abytDest(0), abytSrc(0), 4 '-> ABCD
 CopyMemory_byVar abytDest(1), abytSrc(1), 8 '-> ABCDEFGHI

CopyMemory() skips all copying until a double word alignment is reached (3 skips in this case), then continues copying from the 4th byte.