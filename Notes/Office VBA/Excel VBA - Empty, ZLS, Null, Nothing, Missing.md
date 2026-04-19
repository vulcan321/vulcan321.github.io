**Excel VBA - Empty, ZLS, Null, Nothing, Missing**

\-----------------------------------

**Contents:**

**[Empty](https://www.excelanytime.com/excel/index.php?option=com_content&view=article&id=267:excel-vba-empty-zls-null-nothing-missing&catid=79&Itemid=475#Empty)**

**[VarType Function](https://www.excelanytime.com/excel/index.php?option=com_content&view=article&id=267:excel-vba-empty-zls-null-nothing-missing&catid=79&Itemid=475#VarType Function)**

**[Null](https://www.excelanytime.com/excel/index.php?option=com_content&view=article&id=267:excel-vba-empty-zls-null-nothing-missing&catid=79&Itemid=475#Null)**

**[Nothing](https://www.excelanytime.com/excel/index.php?option=com_content&view=article&id=267:excel-vba-empty-zls-null-nothing-missing&catid=79&Itemid=475#Nothing)**

**[Missing](https://www.excelanytime.com/excel/index.php?option=com_content&view=article&id=267:excel-vba-empty-zls-null-nothing-missing&catid=79&Itemid=475#Missing)**

\-----------------------------------

In excel vba we often refer to an **Empty** variable, **ZLS** (zero-length string) or **null string** or **vbNullString**, **Null** value, **Missing** Argument, or using the **Nothing** keyword with an object variable. It is important to differentiate and understand these terms and expressions while using them in your vba code. In this section, we will also understand using the VarType Function to determine the subtype of a variable, using the IsEmpty & IsNull Functions to check for Empty & Null values, and using the IsMissing Function to check whether optional arguments have been passed in the procedure or not.

**Empty**

When you **declare a variable** in your code using a Dim statement, you are setting aside sufficient memory for the variable (viz. 2 bytes for a Boolean or Integer variable, 4 bytes for a Long variable, and so on), and that the information being stored in the variable has an allowable range (of True or False  for a Boolean variable, a whole number between -32,768 to 32,767  for an Integer variable, a whole number between -2,147,483,648 to 2,147,483,647 for a variable subtype of Long, and so on). You will receive a run-time error if trying to assign a string value to a variable declared as Integer.

While declaring a variable if you do not specify its data type, or if you do not declare a variable at all it will default to **Variant data type** that can hold any type of data (string, date, time, Boolean, or numeric values) & can automatically convert the values that it contains. However, the disadvantage is that this makes Excel reserve more memory than is required (at least 16 bytes), and could also result in mistyping a variable name and not knowing it viz. you might type rowNumbre instead of rowNumber.

When you run a macro, all **variables are initialized to a default value**. The initial default value: for a numeric variable is zero; for a variable length string it is a zero-length or empty string (""); a fixed length string is initialized with the ASCII code 0, or Chr(0); an object variable defaults to Nothing; a Variant variable is initialized to Empty. In numeric context, an Empty variable denotes a zero while in a string context an Empty variable is a zero-length string ("") . A zero-length string ("") is also referred to as a null string. However, it is advised to explicitly specify an initial value for a variable instead of relying on its default initial value.

**Empty** indicates that no beginning value has been assigned to a Variant variable ie. a variable which has not been initialized. An **Empty variable** is represented as 0 in a numeric context or a zero-length string ("") in a string context. Empty is not the same as Null which indicates that a variable contains no valid data.

The **Empty keyword** indicates an uninitialized variable value. It is used as a Variant subtype. You can assign the Empty keyword to explicitly set a variable to Empty.

**IsEmpty Function**

Use the **IsEmpty Function** to check whether a variable has been initialized. The function returns a Boolean value - returns True for an uninitialized variable or if a variable is explicitly set to Empty, otherwise the function returns False. _**Syntax: IsEmpty(expression)**_, where expression is a Variant variable which you want to check. See below example(s) where we use this function to check if a variant variable is empty.

**Empty, Blank, ZLS (zero-length string), null string & vbNullString**

**ZLS** means a **zero-length string** (""), is also referred to as a **null string**, and has a length of zero (0). For all practical purposes using **vbNullString** is equivalent to a **zero-length string** ("") because VBA interprets both in a similar manner, though both are actually not the same - a 'zero length string' actually means creating a string with no characters, whereas  vbNullString is a constant used for a null pointer meaning that no string is created and is also more efficient or faster to execute than ZLS. You can use "" or vbNullString alternatively in your code and both behave similarly. Note that there is no **Blank** keyword in vba, but we can refer to '**blank cells**' or "**empty cells**" in Excel spreadsheet. There are Excel worksheet functions for empty cells: (i) the **COUNTA** function counts the number of cells that are not empty, and also counts or includes a cell with empty text ("") - also referrred to as empty string or zero length string - which is not counted as an empty cell; and (ii) the **ISBLANK** function returns True for an empty cell, and does not treat a zero-length string ("") as a blank (empty cell) similarly as in COUNTA. Both the worksheet functions of ISBLANK and COUNTA distinguish between an empty cell and a cell containing a zero-length string (ie. "" as formula result).

**VarType Function**

Use the **VarType Function** to determine the subtype of a variable. _**Syntax: VarType(variable\_name)**_. The function returns an Integer indicating the variable's subtype. The variable\_name can be any variable except a user-defined data type (data type defined using the Type statement) variable. Examples of return values are: _value_ 0 (_VarType constant_ - vbEmpty, _uninitialized / default_), value 1 (VarType constant - vbNull, contains no valid data), value 2 (VarType constant - vbInteger, Integer), value 3 (VarType constant - vbLong, Long Integer), and so on. The VarType constants can be used anywhere in your code in place of the actual values.

**Example - Empty variable:**
```vbnet
Sub EmptyVar()
    'Empty variable

    'variable var1 has not been declared, hence it is a Variant data type:

    'returns 0, indicating variable subtype Empty:

    MsgBox VarType(var1)

    'returns True, indicating variable subtype Empty:

    MsgBox IsEmpty(var1)

    'returns False - is an Empty variable, not a Null variable - no beginning value has been assigned to a Variant variable:

    MsgBox IsNull(var1)

    'Empty indicates a Variant variable for which you do not explicity specify an initial value, which by default gets initialized in VBA to a value that is represented as both a zero and a zero-length string.

    'returns both messages as below:

    If var1 = 0 Then

    MsgBox "Empty Variable represented as Zero"

    End If

    If var1 = "" Then

    MsgBox "Empty Variable represented as a Zero-Length (Null) String"

    End If

End Sub
```

**Example - Testing for Empty:**
```vbnet
Sub EmptyCheck()
    'testing for Empty

    Dim var1 As Variant

    'variable not initialized - returns 0, indicating variable subtype Empty:

    MsgBox VarType(var1)

    'returns True, indicating variable subtype Empty:

    MsgBox IsEmpty(var1)

    '-----------

    'initialize the variable by specifying a string value:

    var1 = "Hello"

    'returns 8, indicating variable subtype String:

    MsgBox VarType(var1)

    'returns False, indicating variable is not Empty:

    MsgBox IsEmpty(var1)

    '-----------

    'assign Empty keyword to set variable to Empty:

    var1 = Empty

    'returns 0, indicating variable subtype Empty:

    MsgBox VarType(var1)

    'returns True, indicating variable is Empty:

    MsgBox IsEmpty(var1)

    '-----------

    'returns True for an empty worksheet cell, otherwise False:

    MsgBox IsEmpty(ActiveCell)

End Sub
```
**Example - Initialize a Variant variable:**
```vbnet
Sub VarInitialized()
    'initialized variable

    Dim var1 As Variant

    'variable has been initialized to a zero-length string (""):

    var1 = ""

    'returns False, indicating variable is NOT Empty:

    MsgBox IsEmpty(var1)

    'returns 8, indicating variable subtype String:

    MsgBox VarType(var1)

    'returns - "Variable value is a Zero-Length String"

    If var1 = "" Then

    MsgBox "Variable value is a Zero-Length String"

    Else

    MsgBox "Variable value is NOT a Zero-Length String"

    End If

    'returns - "Variable value is NOT Zero"

    If var1 = 0 Then

    MsgBox "Variable value is Zero"

    Else

    MsgBox "Variable value is NOT Zero"

    End If

End Sub
```
**Example - Check a zero-length string:**
```vbnet
Sub CheckZLS()
    'check a zero-length string

    Dim var1 As Variant

    'variable not initialized - returns 0, indicating variable subtype Empty - represented both as Zero (0) and a Zero-Length (Null) String:

    MsgBox VarType(var1)

    'returns "True" for all If statements below:

    If var1 = "" Then

    MsgBox "True"

    End If

    If var1 = vbNullString Then

    MsgBox "True"

    End If

    If Len(var1) = 0 Then

    MsgBox "True"

    End If

End Sub
```
**Null**

In VBA, **Null keyword** is used to indicate that a variable contains no valid data. A value indicating that a variable contains no valid data. **Null** is the result - (i) if you explicitly assign Null to a variable, or (ii) if you perform any operation between expressions that contain Null. The Null keyword is used as a Variant subtype ie. only a Variant variable can be Null, and and variable of any other subtype will give an error. Null is not the same as a zero-length string (""), and neither is Null the same as Empty, which indicates that a variable has not yet been initialized.

If you try to get the value of a Null variable or an expression that is Null, you will get an  error of 'Invalid use of Null' (Run-time Error 94). You will need to ensure the variable contains a valid value. Refer Image 1.

**![](https://www.excelanytime.com/excel/index.php?option=com_content&view=article&id=267:excel-vba-empty-zls-null-nothing-missing&catid=79&Itemid=475images/ExcelVBA/EmptyNull/null_1.gif "Image 1")

Image 1

**

**IsNull Function**

The **IsNull Function** returns a Boolean value - True for an expression that is Null (containing no valid data), or else False for an expression that contains valid data. _**Syntax: IsNull(expression)**_. The expression argument is a variant that contains a numeric or string value, and is necessary to specify.

**Example - Integer variable:**
```vbnet
Sub VarInteger()
'no beginning value assigned to a variable of subtype Integer

Dim intVar As Integer

'returns False (intVar is not Null & neither is it Empty) - no beginning value has been assigned to a variable of subtype Integer:

MsgBox IsNull(intVar)

'returns 2, indicating variable subtype Integer:

MsgBox VarType(intVar)

'returns - "Variable value is Zero" (The initial default value for a numeric variable is zero)

If intVar = 0 Then

MsgBox "Variable value is Zero"

Else

MsgBox "Variable value is NOT Zero"

End If

End Sub
```
**Example - Evaluate Empty / Null variable, use IsNull & VarType vba functions:**
```vbnet
Sub EmptyNullVar()
'evaluate Empty / Null variable, use IsNull & VarType vba functions.

Dim var1 As Variant

'returns False, var1 is not Null but an Empty variable (no beginning value has been assigned to a Variant variable):

MsgBox IsNull(var1)

'variable not initialized - returns 0, indicating variable subtype Empty:

MsgBox VarType(var1)

'returns the message because var1 is an Empty variable:

If var1 = 0 And var1 = vbNullString Then

MsgBox "Empty Variable represented both as Zero (0) and a Zero-Length (Null) String"

End If

'-------------------

'variable is initialized to a zero-length string ("") or vbNullString:

var1 = vbNullString

'returns False - var1 is not a Null variable:

MsgBox IsNull(var1)

'returns 8, indicating variable subtype String:

MsgBox VarType(var1)

'-------------------

'explicitly assigning Null to a variable:

var1 = Null

'returns True, for a Null variable, containing no valid data:

MsgBox IsNull(var1)

'returns 1, indicating variable subtype Null:

MsgBox VarType(var1)

'-------------------

'explicitly assigning valid data to a variable:

var1 = 12

'returns False, for a variable containing valid data:

MsgBox IsNull(var1)

'returns 2, indicating variable subtype Integer:

MsgBox VarType(var1)

'-------------------

'returns False, for an expression containing valid data:

MsgBox IsNull("Hello")

End Sub
```
**Example - Check a Null variable:**
```vbnet
Sub CheckNull()
    'check a Null variable

    'explicitly assigning Null to a variable:

    var1 = Null

    'returns 1, indicating variable subtype Null:

    MsgBox VarType(var1)

    'returns the message, indicating variable subtype Null:

    If VarType(var1) = vbNull Then

    MsgBox "Null variable"

    End If

    'an expression containing Null also evaluates to Null:

    var2 = Null + 2

    'returns 1, indicating variable subtype Null:

    MsgBox VarType(var2)

End Sub
```
**Example - Check worksheet cell for Empty, ZLS, Null:**
```vbnet
Sub WorksheetCell\_ZLS\_Empty\_Null()
    'check worksheet cell for Empty, ZLS, Null
    Dim var1 As Variant
    'returns True:
    MsgBox vbNullString = ""
    'In the case where ActiveCell is Blank:
    'returns True for a Blank cell:
    MsgBox ActiveCell.Value = ""
    MsgBox ActiveCell.Value = vbNullString
    MsgBox ActiveCell.Value = 0
    MsgBox IsEmpty(ActiveCell.Value)
    'assign Active Cell value to variable:
    var1 = ActiveCell.Value
    'returns True:
    MsgBox IsEmpty(var1)
    MsgBox var1 = vbNullString
    MsgBox var1 = ""
    MsgBox var1 = 0
    'returns False:
    MsgBox VarType(var1) = vbNull
    'returns 0, indicating variable subtype Empty:
    MsgBox VarType(var1)
    'If you enter "" in the Active Cell ie. the active cell contains the value: =""  
    'returns True:
    MsgBox ActiveCell.Value = ""
    MsgBox ActiveCell.Value = vbNullString
    'returns False:
    MsgBox ActiveCell.Value = 0
    MsgBox IsEmpty(ActiveCell.Value)
End Sub
```
**Nothing**

Assigning the **Nothing keyword** to an **object variable** disassociates the variable from an actual object. Nothing is assigned to an object variable by using the Set statement. You can assign the same actual object to multiple object variables in vba code, and this association uses your system resources and memory. The system resources and memory get released only either after you assign Nothing to all object variables using the Set statement which disassociates these variables from the actual object, or when all object variables go out of scope and get destroyed. It is advisable to explicity set all object variables to Nothing at the end of your procedure or even earlier while running your code when you finish using them, and this will release memory allocated to these variables.

**Determine if the object variable is initialized - use Is Nothing for objects**: To check if an object has been assigned or set, use the **Is** keyword with **Nothing**, viz. If object\_variable Is Nothing. For objects, you cannot test if an object\_variable is equal to something, and using = instead of Is will give an error.

**Example - Using the Nothing keyword with an object variable:**
```vbnet
Sub ObjNothing()
    'using the Nothing keyword with an object variable
    Dim objVar As Object
    'returns True, because you have not yet assigned an actual object to the object variable:
    MsgBox objVar Is Nothing
    Set objVar = ActiveSheet
    'returns False, because you have assigned an actual object (Sheet) to the object variable:
    MsgBox objVar Is Nothing
    Set objVar = Nothing
    'returns "Variable not associated with an actual object", because you have disassociated the object variable from an actual object:
    If objVar Is Nothing Then
        MsgBox "Variable not associated with an actual object"
    Else
        MsgBox "Actual object is assigned to an Object variable"
    End If
End Sub
```
**Missing**

**Passing Arguments to Procedures**: When an external value is to be used by a procedure to perform an action, it is passed to the procedure by variables. These variables which are passed to a procedure are called arguments. An argument is the value supplied by the calling code to a procedure when it is called. When the set of parentheses, after the procedure name in the Sub or Function declaration statement, is empty, it is a case when the procedure does not receive arguments. However, when arguments are passed to a procedure from other procedures, then these are listed or declared between the parentheses.

**Optional Arguments**: Arguments can be specified as Optional by using the Optional keyword before the argument to its left. When you specify an argument as Optional, all other arguments following that argument to its right must

also be specified as Optional. Note that specifying the Optional keyword makes an argument optional otherwise the argument will be required.

**Check if an argument is Missing, using the IsMissing function**: The Optional argument should be (though not necessary) declared as Variant data type to enable use of the **IsMissing function** which works only when used with variables declared as Variant data type. The IsMissing function is used to determine whether the optional argument was passed in the procedure or not and then you can adjust your code accordingly without returning an error. If the Optional argument is not declared as Variant in which case the IsMissing function will not work, the Optional argument will be assigned the default value for its data type which is 0 for numeric data type variables (viz. Integer, Double, etc) and Nothing (a null reference) for String or Object data type variables.

**IsMissing function**: The **IsMissing function** is used to check whether optional Variant arguments have been passed in the procedure or not. _**Syntax: IsMissing(argname)**_. The function returns a Boolean value - True if no value is passed for the optional argument, and False if a value has been passed for the optional argument. If the IsMissing function returns True for an argument, using the missing argument in the code will cause an error, and thus using this function will help in adjusting your code accordingly.

**Example of using the IsMissing function to check if an argument is Missing:**
```vbnet
Function FullName(strFirstName As String, Optional strSecondName As Variant) As String 
    'The declaration of the procedure contains two arguments, the second argument is specified as Optional. Declaring the Optional argument as Variant data type will enable use of the IsMissing function.

    'The IsMissing function is used to determine whether the optional argument was passed in the procedure, and if not, you can adjust your code accordingly without returning an error.
    If IsMissing(strSecondName) Then
        FullName = strFirstName
    Else
        FullName = strFirstName & " " & strSecondName
    End If
End Function
```

```vbnet
Sub GetName()
    Dim strGivenName As String
    strGivenName = InputBox("Enter Given Name")

    'specifying only the first argument & omitting the second argument which is optional:
    MsgBox FullName(strGivenName)
    End Sub
```