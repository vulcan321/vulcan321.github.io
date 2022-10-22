## **3 Ways to Convert String to Number in Excel VBA**

### **1\.** **Convert String to Number Using Type Conversion Functions**

Excel provides several built-in [**type conversion functions**](https://docs.microsoft.com/en-us/office/vba/language/concepts/getting-started/type-conversion-functions). We can use them in our VBA code to easily convert from string datatype to different datatypes.

#### **1.1 String to Integer**

To convert **string** to **integer**, we can use the **CInt function** in our code. The **CInt function** takes only **one argument** and that should be a **numeric value**. Let’s try the following code in the Visual Code Editor.

```visual-basic
Sub StringToNumber()
MsgBox CInt(12.3)
End Sub
```

Press **F5** to **run** the **code**. The output is shown in the **MsgBox**.

The CInt function **converted** the **numeric string** value **(“12.3”**) to an **integer** **12.  
**To understand more about the **CInt function**, run the following code in the code editor and **observe** the **results**.

```visual-basic
Sub StringToNumber()
For i = 3 To 7
Cells(i, 3).Value = CInt(Cells(i, 2))
Next
End Sub
```

Copy

![convert string to number in Excel VBA](https://www.exceldemy.com/wp-content/uploads/2022/03/convert-string-to-number-3.png)

**Code Explanation**

In this code, we used the  [](https://www.exceldemy.com/for-next-loop-excel-vba/)[**For…Next loop**](https://www.exceldemy.com/for-next-loop-excel-vba/) to apply the **CInt function** on the strings of cells **B3:B7.** The **outputs** are printed in cells **C3:C7.** We used the [**Cells function**](https://docs.microsoft.com/en-us/office/vba/api/excel.cells) to specify the input values and where to print the output values.

**Results**

The CInt function **converted 25.5** to the **next integer number 26**. On the other hand, it **converted 10.3** to **10, not 11**. When a decimal numeric value is less than .5, the function rounds down to the same number. But the **decimal** numeric string value turns into the **next integer** number if it is **equal to** or **greater than .5.**

**Note**

The integer value has a range between **\-32,768** to **32,767**. If we put a numeric value that is **out of this range**, Excel will show an **error**.

___

#### **1.2 String to Long**

The **CLng function** converts a numeric string value to a **long datatype**. It works similarly to the CInt function. The key difference lies in its **range** which is between **\-2,147,483,648** and **2,147,483,647.**

```
The code to run is here below:
Sub StringToNumber()
For i = 3 To 9
Cells(i, 3).Value = CLng(Cells(i, 2))
Next
End Sub
```

Here, cells **B3:B9** contain some **numerical string value**, and **converted** l**ong numbers** are in cells **C3:C9.** The **CLng function** **converted** **\-32800** and **32800** successfully to **long numbers** which the **CInt function** couldn’t. But it’ll also get an **error** if the input **numeric value** is **out of range.**

___

#### **1.3 String to Decimal**

Using the **CDec function** we can **convert** a **numerical string value** to a **decimal datatype. Run** the following code to **convert** the **numerical values** in cells **B3:B7** to the **decimal datatype.**

```visual-basic
Sub StringToNumber()
For i = 3 To 7
Cells(i, 3).Value = CDec(Cells(i, 2))
Next
End Sub
```

___

#### **1.4 String to Single**

In this example, we’ll turn the input strings into [**single datatype**](https://docs.microsoft.com/en-us/office/vba/language/reference/user-interface-help/single-data-type) (single-precision floating-point) numbers. For this, we need to use the **CSng function**.

The single datatype ranges- **(i)  -3.402823E38** to **\-1.401298E-45** for **negative** numbers.  
                                             **(ii)** **1.401298E-45** to **3.402823E38** for **positive** numbers.

Run the following code in the visual basic editor.

```visual-basic
Sub StringToNumber()
For i = 3 To 7
Cells(i, 3).Value = CSng(Cells(i, 2))
Next
End Sub
```

In the output, cells **B3:B9** contain some **numerical string value,** and **converted single datatype numbers** are in cells **C3:C9.**  But it’ll also get an **error** if the input **numeric value** is **out of range.**

#### **1.5 String to Double**

In this example, we’ll turn the input strings into [**double datatype**](https://docs.microsoft.com/en-us/office/vba/language/reference/user-interface-help/double-data-type) (double-precision floating-point) numbers. For this, we need to use the **CDbl function**.

The double datatype ranges- **(i) -1.79769313486231E308** to **\-4.94065645841247E-324** for **negative** numbers.  
                                               **(ii)** **4.94065645841247E-324** to **1.79769313486232E308** for **positive** numbers.

Run the following code in the visual basic editor.

```visual-basic
Sub StringToNumber()
For i = 3 To 7
Cells(i, 3).Value = CSng(Cells(i, 2))
Next
End Sub
```

In the output, cells **B3:B9** contain some **numerical string value** and **converted double datatype numbers** are in cells **C3:C9.**  But it’ll also get an **error** if the input **numeric value** is **out of range.**

___

#### **1.6 String to Currency**

The **currency data type** is handy when calculations are related to **money**. Moreover, if we want more accuracy in **fixed**–**point** **calculation**, the use of the currency data type is a good choice. We need to use the **CCur function** to convert a string into a **currency data type**. The data type **ranges** from **\-922,337,203,685,477.5808** to **922,337,203,685,477.5808.**

Code to **convert** **numeric string value** of cells **B3:B7** to **currency data type** in cells **C3:C7** is here below.

```visual-basic
Sub StringToNumber()
For i = 3 To 7
Cells(i, 3).Value = CCur(Cells(i, 2))
Next
End Sub
```

___

#### **1.7 String to Byte**

The **CByte function** converts numerical string values to the **byte data type** which ranges from **0 to 255.  
****Code** is as follows**:**

```visual-basic
Sub StringToNumber()
For i = 3 To 7
Cells(i, 3).Value = CByte(Cells(i, 2))
Next
End Sub
```

 In the output, cells **B3:B9** contain some **numerical string value,** and **converted byte data type numbers** are in cells **C3:C9.**  But it’ll also get an **error** if the input **numeric value** is **out of range.**