VBA字符串处理大全 [转载出处](https://blog.csdn.net/goldengod/article/details/73558537)

1 VBA中的字符串  
2 VBA中处理字符串的函数  
    2.1 比较字符串  
    2.2 转换字符串  
    2.3 创建字符串  
    2.4 获取字符串的长度  
    2.5 格式化字符串  
    2.6 查找字符串  
    2.7 提取字符/字符串  
    2.8 删除空格  
    2.9 返回字符代码  
    2.10 返回数值代表的相应字符  
    2.11 使用字节的函数  
    2.12 返回数组的函数  
    2.13 连接字符串  
    2.14 替换字符串  
    2.15 反向字符串  
\====================================================  
  
1 VBA中的字符串  
  
VBA不仅可以处理数字，也可以处理文本(字符串)。VBA提供了两类字符串：  
一类为固定长度的字符串，声明时包含指字的字符数。例如，下面的语句  
Dim strFixedLong As String\*100  
声明字符串变量后，无论赋予该变量多少个字符，总是只包含100个字符，但字符串最长不超过65526个字符，且需要使用Trim函数去掉字符串中多余的空格。定长字符串只有在必要时才使用。  
另一类为动态字符串。例如，声明字符串变量Dim strDynamic As String后，可以给该变量任意赋值，最多可包含20亿个字符。  
– – – – – – – – – – – – – – – – – – – – – – – – – – – – – –  
2 VBA中处理字符串的函数  
  
2.1 比较字符串  
通常，在VBA中进行字符串比较时，会用到比较运算符(如=、>等)、Like运算符和StrComp函数。此外，在模块的开头用Option Compare语句指定比较方式。  
2.1.1 比较运算符  
可以采用简单的逻辑运算符进行两个字符串的比较，即<(小于)、<=(小于或等于)、>(大于)、>=(大于或等于)、=(等于)、<>(不等于)。此外，还可以使用Like运算符进行比较。  
2.1.2 StrComp函数  
StrComp函数返回字符串比较的结果。其语法为：  
    StrComp(string1,string2\[,compare\])  
其中，参数string1和strng2为必需的参数，可以是任何有效的字符串表达式。  
参数Compare为可选参数，如果该参数为Null，将发生错误。如果参数Compare设置为常数vbUseCompareOption或-1或忽略该参数，将使用Option Compare语句设置进行比较；如果忽略该参数且没有设置Option Compare语句，则按二进制进行比较；如果参数Compare设置为常数vbBinaryCompare或0，则用二进制进行比较；如果参数Compare设置为常数vbTextCompare或1，则按文本进行比较；如果参数Compare设置为常数vbDatabaseCompare或2，此时仅适用于Microsoft Access，进行基于数据库信息的比较。  
StrComp函数的返回值为：如果String1<String2，则返回值为-1；如果String1=String2，则返回值为0；如果String1>String2，则返回值为1；如果String1或String2为Null，则返回值为Null。  
看看下面的示例：  
Sub testStringCompare()  
  Dim MyStr1 As String, MyStr2 As String, MyComp1, MyComp2, MyComp3, MyComp4  
  MyStr1 = “ABCD”  
  MyStr2 = “abcd”  
  MyComp1 = StrComp(MyStr1, MyStr2, 1)    ‘ 返回 0  
  MyComp2 = StrComp(MyStr1, MyStr2, 0)    ‘ 返回 -1  
  MyComp3 = StrComp(MyStr1, MyStr2)    ‘ 返回 -1  
  MyComp4 = StrComp(MyStr2, MyStr1)    ‘返回1  
  MsgBox “StrComp(MyStr1, MyStr2, 1)的结果为:” & MyComp1  
  MsgBox “StrComp(MyStr1, MyStr2, 0)的结果为:” & MyComp2  
  MsgBox “StrComp(MyStr1, MyStr2)的结果为:” & MyComp3  
  MsgBox “StrComp(MyStr2, MyStr1)的结果为:” & MyComp4  
End Sub  
示例说明：如果StrComp函数的第三个参数值为1，则以文本比较的方式进行字符串比较；如果第三个参数值为0或忽略该参数，则以二进制比较的方式进行字符串比较。注意，文本比较的方式不区分字母大小写，而二进制比较方式则区分大小写。  
\[编程方法和技巧\] 完成一次简单的单一比较，如  
If UCase(sString1)<UCase(sString2) Then  
比使用StrComp函数：  
If StrComp(sString1,sString2,vbTextCompare)=-1 Then  
在性能上要提高30%，且更容易阅读和理解。  
  
2.2 转换字符串  
2.2.1 StrConv函数  
使用StrConv函数来按指定类型转换字符串。其语法为：  
    StrConv(string,conversion,LCID)  
其中，参数string为要转换的字符串，参数conversion为指定转换的类型，参数LCID为可选参数。  
如果将参数conversion设置为vbUpperCase或1，则将字符串转换成大写；设置为vbLowerCase或2，则将字符串转换成小写；设置为vbProperCase或3，则将字符串中每个字的开头字母转换成大写；设置为vbUnicode或64，则根据系统的缺省码页将字符串转换成Unicode；设置为vbFromUnicode或128，则将字符串由Unicode转换成系统的缺省码页。  
在将ANSI格式的Byte数组转换成字符串时，应使用StrConv函数；转换Unicode格式的数组时，使用赋值语句。下面的例子使用StrConv函数将Unicode字符串转换成ANSI字符串：  
Sub testConverseString()  
  Dim i As Long  
  Dim x() As Byte  
  x = StrConv(“ABCDEFG”, vbFromUnicode)    ‘ 转换字符串。  
  For i = 0 To UBound(x)  
    Debug.Print x(i)  
  Next  
End Sub  
下面的例子将句子中每个词语的首字母转换为大写：  
Sub testConverseString2()  
  Debug.Print StrConv(“my book is this book.”, vbProperCase)  
End Sub  
程序运行后，在VBE窗口中的立即窗口中将会看到上述结果。  
下面的示例演示了如何把一个字符串转换为字节数组，以便使用在API函数调用中：  
Sub Test()  
  Dim byArray() As Byte  
  Dim sString As String  
  sString = “Some stuff”  
  byArray = StrConv(sString, vbFromUnicode)  
End Sub  
StrConv函数将下面的字符看成是字的分隔符：  
Null：Chr$(0)  
水平制表符：Chr$(9)  
换行符：Chr$(10)  
垂直制表符：Chr$(11)  
换页符：Chr$(12)  
回车符：Chr$(13)  
空格：Chr$(32)  
\[编程方法和技巧\] 在使用API时该函数很重要，很多程序调用都要求传递给它们Unicode字符，或者赋给返回变量Unicode字符。  
2.2.2 Str函数  
将数值转换成字符串，即返回代表一个数值的字符串。其语法为：  
    Str(number)  
当一个数字转成字符串时，总会在前面保留一个空位来表示正负，即字符串的第一位一定是空格或正负号。如果参数number为正，返回的字符串前面包含一空格。Str函数将句点(.)作为有效的小数点。示例如下：  
  MyString = Str(459)    ‘ 返回 ” 459″  
  MyString = Str(-459.65)   ‘ 返回 “-459.65”  
  MyString = Str(459.001)    ‘ 返回 ” 459.001″  
\[编程方法和技巧\] 使用LTrim函数可删除Str函数在返回的字符串开头添加的前导空格。此外，CStr函数和Format函数已经取代了Str函数，CStr函数不用为正数的符号而添加前导空格，Format函数能够用来识别小数点。  
2.2.3 CStr函数  
CStr将数值表达式转换成String数据类型。示例如下：  
MyDouble = 437.324   ‘ MyDouble 为 Double 类型  
MyString = CStr(MyDouble)    ‘ MyString 的内容为”437.324″  
\[编程方法和技巧\] 传递给CStr的未初始化的数字数据类型返回“0”，传递给CStr的未初始化的日期变量返回“0:00:00”。  
  
2.3 创建字符串  
2.3.1 Space函数  
该函数返回指定数的空格的字符串。语法为：  
    Space(number)  
其中，参数number必须，为字符串中指定的空格数。  
如下例所示：  
Sub CreateString1()  
  Dim MyString  
‘ 返回 10 个空格的字符串。  
  MyString = Space(10)  
  ‘ 将 10 个空格插入两个字符串中间。  
  MyString = “Hello” & Space(10) & “World”  
End Sub  
该函数可用于在调用外部DLL时建立字符串缓冲区，特别是在调用Window API时。此外，使用该函数还可以使字符串在特定长度的缓冲区左对齐或右对齐。  
注意，如果参数number是负数，则会产生运行时错误5：“无效的过程调用或参数”。  
\[编程方法和技巧\] 可以使用Space函数添加和清除存储在定长字符串中的数据，例如，下面的代码用空格填充一个定长字符串：  
Dim strFixed As String \* 32  
……  
strFixed = Space(Len(strFixed))  
2.3.2 String函数  
该函数返回重复的字符或字符串。其语法为：  
    String(number,character)  
其中，参数number必须，指定所返回的字符串的长度；参数character必须，指定字符的字符代码或字符串表达式。  
例如，下面使用String函数生成指定长度且只含单一字符的字符串。  
Sub CreateString2()  
  Dim MyString  
  MyString = String(5, “\*”)    ‘ 返回 “\*\*\*\*\*”  
  MyString = String(5, 42)    ‘ 返回 “\*\*\*\*\*”  
  MyString = String(10, “ABC”)    ‘ 返回 “AAAAAAAAAA”  
End Sub  
如果参数number包含Null，则返回Null；如果参数character包含Null，则返回Null；参数character可以指定为字符串或者是ANSI字符代码，如：  
strString1=String(128,”=”) ‘用”=”填充  
strString2=String(128,0) ‘用Chr$(0)填充  
\[编程方法和技巧\]   
(1) String函数在用于创建较长的“\_”，“-”，或者“=”构成的水平线以便给报表分段时十分有用。  
(2) 当调用API函数向缓冲区写入字符串值时，首先要用String函数创建一个长度合适的字符串变量，并且用诸如Chr$(0)之类的单个字符来填充。  
  
2.4 获取字符串的长度  
可以使用Len函数来确定任何字符串或字符串表达式的长度，其语法为：  
    Len(string|varname)  
其中，参数string为任何有效的字符串表达式；参数varname为任何有效的变量名称。两个参数必须取一。  
利用LenB函数可以确定存储某变量所需的实际字节数。  
下面的示例使用Len函数来获取某字符串的长度(字符数)或某变量的大小(位数)。  
Type CustomerRecord    ‘ 定义用户自定义的数据类型  
    ID As Integer   ‘ 将此定义放在常规模块中  
    Name As String \* 10  
    Address As String \* 30  
End Type  
Sub GetStrLen()  
  Dim Customer As CustomerRecord    ‘ 声明变量  
  Dim MyInt As Integer, MyCur As Currency  
  Dim MyString, MyLen  
  MyString = “Hello World”    ‘ 设置变量初值  
  MyLen = Len(MyInt)    ‘ 返回 2  
  MyLen = Len(Customer)    ‘ 返回 42  
  MyLen = Len(MyString)    ‘ 返回 11  
  MyLen = Len(MyCur)    ‘ 返回 8  
End Sub  
此外，在需要大量判断是否为空字符串的代码中，使用Len函数也可以加快代码执行的速度。例如：  
If strTemp = “” Then  
  ‘要执行的代码  
End If  
上面的代码可以用以下代码代替：  
If Len(strTemp) = 0 Then  
  ‘要执行的代码  
End If  
注意：  
(1) 参数string和参数varname互不相容，即只能指定这两个参数中的某一个，不能同时指定这两个参数。  
(2) 如果参数string或参数varname中包含Null，则Len函数会返回Null。  
(3) 在向文件写入某种用户自定义类型数据时，Len函数会返回数据的大小(字符数)。  
(4) LenB函数返回用户自定义类型数据实际占用的内存大小。  
(5) 在对字节数据或Unicode字符串使用LenB函数时，LenB函数返回表示数据或字符串的字节数。  
(6) 不能对对象变量使用Len函数。  
(7) 如果参数varname是一个数组，则必须指定一个有效的下标，即Len函数不能确定数组中元素的总数或数组占用内存的大小。  
(8) Len函数对Variant类型变量的处理和字符串变量一样，Len函数返回变量所存储的实际字符数，如下面的代码：  
Dim vVar  
vVar=100  
MsgBox Len(vVar)  
结果为3。  
(9) 由于VB本质上使用的是Unicode字符串(用两个字节的空间来存储一个字符)，因此当相同的字符串变量传递给Len函数和LenB函数时会出现不同的返回值。例如，对于一个包含4个字符的字符串，使用Len函数时返回值为4，使用LenB函数则为8。  
(10) 使用强类型变量(即强制声明该变量的类型)时，Len函数会返回存储该变量所需的字节数。例如，长整型变量的长度为4。  
下面的示例说明了为什么要显式声明数据类型：  
Sub test()  
  Dim lVar As Long  
  Dim vVar  
  lVar = 10000000  
  vVar = 10000000  
  MsgBox LenB(lVar) ‘返回4  
  MsgBox LenB(vVar)’返回16  
End Sub

很显然，Variant类型变量比强制声明的类型变量要占用更多的内存。

2.5 格式化字符串  
可以使用Format函数规定输出的字符串的格式，其语法为：  
    Format(expression\[,format\[,firstdayofweek\[,firstweekofyear\]\]\])  
其中，参数expression必须，为任何有效的表达式；其余参数均可选。参数format表示所要采用的格式，参数firstdayofweek使用常数，表示一星期的第一天，参数firstweekofyear使用常数，表示一年的第一周。  
在参数format中，使用字符“@”，表示空格或字符占位符，如果在输入的字符串相应位置有字符，则显示该字符，否则显示空格；使用字符“&”，表示空或字符占位符，如果在输入的字符串的相应位置有字符，则显示该字符，否则不显示；使用字符“<”，则将所有字符显示为小写格式；使用字符“>”，则将所有字符显示为大写格式；使用字符“！”，强制占位符从左向右填满， 满足默认为从右向左。  
例如下面的代码：  
Dim strOut  
  strOut = Format(“8888888”, “(@@@)&&&-&&&&”) ‘返回(   )888-8888  
  strOut = Format(“8888888”, “(&&&)&&&-&&&&”) ‘返回()888-8888  
在Format函数中，还可以同时格式化普通字符串和空字符串，只须在指定的格式中用分号隔开两个部分，第一部分用于非空字符串，第二部分用于空字符串。例如：  
strOut = Format(“6666666”, “(@@@)&&&-&&&&;No Phone”) ‘返回(   )666-6666  
strOut = Format(“”, “(@@@)&&&-&&&&;No Phone”) ‘返回No Phone  
又如，下面的代码将字母全部转换为大写：  
Dim strOut  
strOut = Format(“Hello”, “>@@@@@”) ‘返回HELLO  
同理，可以使用“<”将字母全部转换为小写。  
Format函数的简要使用规则：  
(1) 允许用预先定义或用户定义的格式来建立多种用于输出字符串、数字和日期/时间数据的方法。  
(2) 创建用户定义的数值格式最多可以有四个部分，每个部分代表一种不同类型的数值，且用分号分隔。第一部分在单独命名使用时可用于所有值，与其它多个部分一起使用时只用于正数；第二部分用于负数；第三部分用于零值；第四部分用于Null值。  
在参数format中不必包括所有四部分，但所用部分的数目决定了每一个部分所定义的数值类型：只有一个部分，则应用于所有数值；有两个部分，则第一部分应用于正数和零值，第二部分应用于负数；有三个部分，则第一部分用于正数，第二部分应用于负数，第三部分应用于零值；有四个部分，则每部分的使用如前所述。  
如果忽略了一个部分，则该部分使用与定义正数的部分一样的格式，例如：  
“#.00;;#,##”  
表示负数值与正数值使用同一种格式显示。  
如果参数含有命名格式，则只能有一个部分。  
(3) 字符串值的用户定义格式有两个部分，第一部分可应用于所有值，第二部分只应用于Null值或零长字符串。  
(4) 预定义的日期和时间格式如下：  
General Date  
范例： Format(“28/02/2007″,”General Date”)  
返回： 2007-2-28  
Long Date  
范例： Format(“28/02/2007″,”Long Date”)  
返回： 2007年2月28日  
Medium Date  
范例： Format(“28/02/2007″,”Medium Date”)  
返回： 07-02-28  
Short Date  
范例： Format(“28/02/2007″,”Short Date”)  
返回： 2007-2-28  
Long Time   
范例： Format(“17:30:03″,”Long Time”)  
返回： 17:30:03  
Medium Time  
范例： Format(“17:30:03″,”Medium Time”)  
返回： 下午 05:30  
Short Time   
范例： Format(“17:30:03″,”Short Time”)  
返回： 17:30  
(5) 预定义的数值格式如下：  
General Number  
范例： Format(123456.0789,”General Number”)  
返回： 123456.0789  
Currency  
范例： Format(123456.0789,”Currency”)  
返回： ￥123,456.08  
Fixed  
范例： Format(0.2,”Fixed”)  
返回： 0.20  
Standard  
范例： Format(123456.0789,”Standard”)  
返回： 123,456.08  
Percent  
范例： Format(.7321,”Percent”)  
返回： 73.21%  
Scientific  
范例： Format(123456.0789,”Scientific”)  
返回： 1.23E+05  
Yes/No  
范例1： Format(0,”Yes/No”)  
返回：  No  
范例2： Format(23,”Yes/No”)  
返回：  Yes  
True/False  
范例1： Format(0,”True/False”)  
返回：  False  
范例2： Format(23,”True/False”)  
返回：  True  
On/Off  
范例1： Format(0,”On/Off”)  
返回：  Off  
范例2： Format(23,”On/Off”)  
返回： On  
(6) 创建用户自定义的日期和时间格式的字符：  
C  
元素：日期  
显示：基于当前Windows系统的短日期和短时间国际设置格式的日期或时间。  
范例：Format(“28/02/2007 17:30:03″,”c”)  
返回：2007-2-28 17:30:03  
dddddd  
元素：日期  
显示：基于当前Windows系统的长日期国际设置格式的完整日期。  
范例：Format(“28/02/2007″,”dddddd”)  
返回：2007年2月28日  
/  
元素：日期分隔符  
范例：Format(“28/02/2007″,”mm-dd-yyyy”)  
返回：02-28-2007  
d  
元素：日  
显示：1～31范围内的一个数字，无前导0。  
范例：Format(“02/02/2007″,”d”)  
返回：2  
dd  
元素：日  
显示：01～31范围内的一个数字，有前导0。  
范例：Format(“02/02/2007″,”dd”)  
返回：02  
ddd  
元素：日  
显示：英文简写(Sun～Sat)  
范例：Format(“02/02/2007″,”ddd”)  
返回：Fri  
dddd  
元素：日  
显示：英文全称(Sunday～Saturday)  
范例：Format(“02/02/2007″,”dddd”)  
返回：Friday  
ddddd  
元素：日期  
显示：基于计算机Windows国际设置短日期格式的日期。  
范例：Format(“02/02/2007″,”ddddd”)  
返回：2007-2-2  
h  
元素：小时  
显示：0～23范围内的一个数字，无前导0。  
范例：Format(“05:08:06″,”h”)  
返回：5  
hh  
元素：小时  
显示：00～23范围内的一个数字，有前导0。  
范例：Format(“05:08:06″,”hh”)  
返回：05  
n  
元素：分  
显示：0～59范围内的一个数字，无前导0。  
范例：Format(“05:08:06″,”n”)  
返回：8  
nn  
元素：分  
显示：00～59范围内的一个数字，有前导0。  
范例：Format(“05:08:06″,”nn”)  
返回：08  
s  
元素：秒  
显示：0～59范围内的一个数字，无前导0。  
范例：Format(“05:08:06″,”s”)  
返回：6  
ss  
元素：秒  
显示：00～59范围内的一个数字，有前导0。  
范例：Format(“05:08:06″,”ss”)  
返回：06  
ttttt  
元素：时间  
显示：基于12小时制的时间，包含Windows区域设置中指定的时间分隔符和前导0。  
范例：Format(“05:08:06″,”ttttt”)  
返回：5:08:06  
AM/PM  
元素：时间  
显示：用大写的AM和PM表示的12小时制的时钟格式。  
范例：Format(“17:08:06″,”hh:mm:ss AM/PM”)  
返回：05:08:06 PM  
am/pm  
元素：时间  
显示：用小写的am和pm表示的12小时制时钟格式。  
范例：Format(“17:08:06″,”hh:mm:ss am/pm”)  
返回：05:08:06 pm  
A/P  
元素：时间  
显示：12小时制时钟格式，用大写“A”表示AM，大写“P”表示PM。  
范例：Format(“17:08:06″,”hh:mm:ss A/P”)  
返回：05:08:06 P  
a/p  
元素：时间  
显示：12小时制时钟格式，用小写“a”表示am，小写“p”表示pm。  
范例：Format(“17:08:06″,”hh:mm:ss a/p”)  
返回：05:08:06 p  
：  
元素：时间分隔符  
显示：时间格式  
范例：Format(“17:08:06″,”hh:mm:ss”)  
返回：17:08:06  
w  
元素：星期几  
显示：1～7范围内的一个数字(1～7分别表示星期天到星期六)。  
范例：Format(“02/02/2007″,”w”)  
返回：6  
ww  
元素：周  
显示：1～54范围内的一个数字。  
范例：Format(“02/02/2007″,”ww”)  
返回：5  
m  
元素：月  
显示：1～12范围内的一个数字，无前导0。  
范例：Format(“02/02/2007″,”m”)  
返回：2  
mm  
元素：月  
显示：01～12范围内的一个数字，有前导0。  
范例：Format(“02/02/2007″,”mm”)  
返回：02  
mmm  
元素：月  
显示：英文月份简写(Jan～Dec)  
范例：Format(“02/02/2007″,”mmm”)  
返回：Feb  
mmmm  
元素：月  
显示：英文月份全称(January～December)  
范例：Format(“02/02/2007″,”mmmm”)  
返回：February  
q  
元素：季度  
显示：1～4范围内的一个数字  
范例：Format(“02/02/2007″,”q”)  
返回：1  
y  
元素：一年中的某天  
显示：1～366范围内的一个数字。  
范例：Format(“02/02/2007″,”y”)  
返回：33  
yy  
元素：年  
显示：00～99范围内的一个两位数字。  
范例：Format(“02/02/2007″,”yy”)  
返回：07  
yyyy  
元素：年  
显示：100～9999范围内的一个四位数字。  
范例：Format(“02/02/2007″,”yyyy”)  
返回：2007  
(7)用于创建用户自定义数字格式的字符  
0  
说明：数字占位符。如果参数expression所代表的数值在相应的0位置上有一个数字，则显示这个数字，否则显示0。所指定的小数点后的位数，使数值舍入为给定的小数位数，但不影响小数点左边的数字位数。  
范例1：Format(23.675,”00.0000″)  返回：23.6750  
范例2：Format(23.675,”00.00″)  返回：23.68  
范例3：Format(2345,”00000″)  返回：02345  
范例4：Format(2345,”00.00″)  返回：2345.00  
#  
说明：数字占位符。如果参数expression所代表的数值在相应的#位置上有一个数字，则显示这个数字，否则什么也不显示。  
范例1：Format(23.675,”##.##”)  返回：23.68  
范例2：Format(23.675,”##.####”)  返回：23.675  
范例3：Format(12345.25,”#,###.##”)  返回：12,345.25  
.  
说明：小数点占位符。小数点占位符实际显示的字符由本机Windows系统国际设置格式决定。  
%  
说明：百分数占位符。首先将参数expression所代表的数值乘以100，然后把它作为百分数显示。  
范例：Format(0.25,”##.00%”) 返回：25.00%  
，  
说明：千位分隔符。实际显示的字符由本机Windows系统国际设置格式决定。在格式定义中只需要给出一个千位分隔符。  
范例：Format(1000000,”#,###”)  返回：1,000,000  
E-E+ e-e+  
说明：科学计数法格式。如果格式表达式在E-、E+或e-、e+的右边至少有一个数字占位符(0或#)，数字就以科学计数法格式显示数字，参数Format中所用的字母E或e在该数字和它的指数之间显示。右边的数字占位符数目决定了要在指数中显示的位数。使用E-或e-可以在负指数前插入一个减号，使用E+或e+可以在正指数前插入一个正号。  
范例：Format(1.09837555,”######E-###”)  返回：109838E-5  
\-+$  
说明：显示一个直接量字符。  
范例：Format(2345.25,”$#,###.##”)  返回：$2,345.25  
\\  
说明：反斜杠后的字符以直接量字符显示。可以用反斜杠将某个特定格式的字符以直接量字符显示。  
范例：Format(0.25,”##.##\\%”)  返回：.25%  
(8) 用于创建用户自定义字符串格式的字符  
@  
说明：字符占位符。如果expression在相应的@位置上有一个字符，就显示这个字符，否则显示一个空格。  
范例：Format(“VBA”,”\\\*@\\\*@@@@@”)  返回：\* \*  VBA  
&  
说明：字符占位符。如果expression在相应的&位置上有一个字符，就显示这个字符，否则什么也不显示。  
范例：Format(“VBA”,”\\\*&&\\\*&&&&”)  返回：\*\*VBA  
<  
说明：用小写形式显示所有字符。  
范例：Format(“VBA”,”<“)  返回：vba  
\>  
说明：用大写形式显示所有字符。  
范例：Format(“vba”,”>”)  返回：VBA  
！  
说明：从左向右处理占位符(缺省情况为从右向左处理占位符)。  
\[编程方法和技巧\]  
(1) 使用没有格式定义的Format函数格式化数字比使用Str函数格式化数字更好。Format函数与Str函数不同，它会把正数中一般保留用于表示符号的前导空格清除掉。  
(2) 可以使用Format函数以1000为单位对数字进行标度，做法是在语句中小数点的左边用一个千位分隔符(，)表示标度数字的一个千位；可以使用多个千位分隔符。例如：  
Format(1000000,”##0,.”) 返回：1000.  
Format(1000000,”##0,,.”)  返回：1.  
  
2.6 查找字符串  
2.6.1 InStr函数  
可使用InStr函数返回一字符串在另一字符串中的位置，因此，也可以使用该函数确定一个字符串中是否包含有另一个字符串。其语法为：  
    InStr(\[Start,\]string1,string2\[,compare\])  
其中，参数Start为可选参数，设置查找的起点，如果省略，则从第一个字符的位置开始查找，当指定了参数Compare时，则要指定此参数。参数string1为被查找的字符串，参数string2为要查找的字符串，这两个参数都是必需的。  
如果在String1中没有找到String2，返回0；如果找到String2，则返回String2第一个出现的首字符位置(即1到String1的长度)；如果String2的长度为零，返回Start。  
可看看下面的示例：  
Sub test()  
  Dim SearchString, SearchChar, MyPos  
  SearchString = “XXpXXpXXPXXP”   ‘被搜索的字符串  
  SearchChar = “P”   ‘要查找字符串 “P”  
‘从第四个字符开始，以文本比较的方式找起，返回值为 6(小写 p)  
  ‘小写 p 和大写 P 在文本比较下是一样的  
  MyPos = InStr(4, SearchString, SearchChar, 1)  
  Debug.Print MyPos  
  ‘从第一个字符开使，以二进制比较的方式找起，返回值为 9(大写 P)  
  ‘小写 p 和大写 P 在二进制比较下是不一样的  
  MyPos = InStr(1, SearchString, SearchChar, 0)  
  Debug.Print MyPos  
  ‘缺省的比对方式为二进制比较(最后一个参数可省略)  
  MyPos = InStr(SearchString, SearchChar)    ‘返回 9  
  Debug.Print MyPos  
  MyPos = InStr(1, SearchString, “W”)   ‘返回 0  
  Debug.Print MyPos  
End Sub  
2.6.2 InStrRev函数  
也可以使用InStrRev函数返回一个字符串在另一个字符串中出现的位置，与InStr函数不同的是，从字符串的末尾算起。其语法为：  
    InStrRev(String1,String2\[,\[Start\[,compare\])  
参数String1为被查找的字符串，参数String2为要查找的字符串，这两个参数都是必需的。参数Start为可选参数，设置每次查找开始的位置，若忽略则使用-1，表示从上一个字符位置开始查找。参数Compare为可选参数，表示所使用的比较方法，如果忽略则执行二进制比较。  
下面的示例使用了InStr函数和InStrRev函数，相应的结果不同：  
Sub test()  
  Dim myString As String  
  Dim sSearch As String  
  myString = “I like the functionality that InsStrRev gives”  
  sSearch = “th”  
  Debug.Print InStr(myString, sSearch) ‘返回8  
  Debug.Print InStrRev(myString, sSearch) ‘返回26  
End Sub  
– – – – – – – – – – – – – – – – – – – – – – –  
  
2.7 提取字符/字符串  
2.7.1 Left函数  
Left函数可以从字符串的左边开始提取字符或指定长度的字符串，即返回包含字符串中从左边算起指定数量的字符。其语法为：  
    Left(String,CharNum)  
其中，如果参数String包含Null，则返回Null；如果参数CharNum的值大于或等于String的字符数，则返回整个字符串。  
例如，下面的代码返回指定字符串的前两个字符：  
strLeft=Left(“This is a pig.”，2)  
Left函数与InStr函数结合，返回指定字符串的第一个词，例如下面的代码：  
str = “This is a pig.”  
FirstWord = Left(str, InStr(str, ” “) – 1)  
2.7.2 Right函数  
与Left函数不同的是，Right函数从字符串的右边开始提取字符或指定长度的字符串，即返回包含字符串中从右边起指定数量的字符。其语法为：  
    Right(String,CharNum)  
例如：  
AnyString = “Hello World”    ‘ 定义字符串  
MyStr = Right(AnyString, 1)   ‘ 返回 “d”  
MyStr = Right(AnyString, 6)    ‘ 返回 ” World”  
MyStr = Right(AnyString, 20)   ‘ 返回 “Hello World”  
如果存放文件名的字符串中没有反斜杠(\\)，下面的代码将反斜杠(\\)添加到该字符串中：  
If Right(strFileName,1) <> “” Then  
  strFileName=strFileName & “\\”  
End If  
下面的函数假设传递给它的参数或者是文件名，或者是包含完整路径的文件名，从字符串的末尾开始返回文件名。  
Private Function ParseFileName(strFullPath As String)  
  Dim lngPos As Long, lngStart As Long  
  Dim strFilename As String  
  lngStart = 1  
  Do  
    lngPos = InStr(lngStart, strFullPath, “\\”)  
    If lngPos = 0 Then  
      strFilename = Right(strFullPath, Len(strFullPath) – lngStart + 1)  
    Else  
      lngStart = lngPos + 1  
    End If  
  Loop While lngPos > 0  
  ParseFileName = strFilename  
End Function  
2.7.3 Mid函数  
Mid函数可以从字符串中提取任何指定的子字符串，返回包含字符串中指定数量的字符的字符串。其语法为：  
    Mid(String,Start\[,Len\])  
其中，如果参数String包含Null，则返回Null；如果参数Start超过了String的字符数，则返回零长度字符串(“”)；如果参数Len省略或超过了文本的字符数，则返回字符串从Start到最后的所有字符。  
例如，下面的代码：  
Str=Mid(“This is a pig.”,6,2)  
将返回文本“is”。  
下面的代码：  
MyString = “Mid Function Demo”   ‘建立一个字符串  
FirstWord = Mid(MyString, 1, 3)   ‘返回 “Mid”  
LastWord = Mid(MyString, 14, 4)    ‘返回 “Demo”  
MidWords = Mid(MyString, 5)   ‘返回 “Funcion Demo”  
Mid函数常用于在字符串中循环，例如，下面的代码将逐个输出字符：  
Dim str As String  
Dim i As Integer  
Str=”Print Out each Character”  
For i=1 to Len(str)  
  Debug.Print Mid(str,i,1)  
Next i  
2.7.4 Mid语句  
Mid语句可以用另一个字符串中的字符替换某字符串中指定数量的字符。其语法为：  
    Mid(Stringvar,Start\[,Len\])=string  
其中，参数Stringvar代表为要被更改的字符串；参数Start表示被替换的字符开头位置；参数Len表示被替换的字符数，若省略则全部使用string；参数string表示进行替换的字符串。  
被替换的字符数量总小于或等于Stringvar的字符数；如果string的数量大于Len所指定的数量，则只取string的部分字符。示例如下：  
MyString = “The dog jumps”   ‘ 设置字符串初值  
Mid(MyString, 5, 3) = “fox”    ‘ MyString = “The fox jumps”  
Mid(MyString, 5) = “cow”   ‘ MyString = “The cow jumps”  
Mid(MyString, 5) = “cow jumped over”    ‘ MyString = “The cow jumpe”  
Mid(MyString, 5, 3) = “duck”    ‘ MyString = “The duc jumpe”  
– – – – – – – – – – – – – – – – – – – – – – –  
  
2.8 删除空格  
LTrim函数删除字符串前面的空格；  
RTrim函数删除字符串后面的空格；  
Trim函数删除两头的空格。  
示例如下：  
MyString = ”  <-Trim->  ”    ‘ 设置字符串初值  
TrimString = LTrim(MyString)    ‘ TrimString = “<-Trim->  “  
TrimString = RTrim(MyString)   ‘ TrimString = ”  <-Trim->”  
TrimString = LTrim(RTrim(MyString))    ‘ TrimString = “<-Trim->”  
‘ 只使用 Trim 函数也同样将两头空格去除  
TrimString = Trim(MyString)   ‘ TrimString = “<-Trim->”  
– – – – – – – – – – – – – – – – – – – – – – –  

2.9 返回字符代码  
Asc函数返回指定字符串表达式中第一个字符的字符代码。示例如下：  
MyNumber = Asc(“A”)   ‘ 返回 65  
MyNumber = Asc(“a”)    ‘ 返回 97  
MyNumber = Asc(“Apple”)   ‘ 返回 65  
\[编程方法和技巧\]  
(1) 在数据验证中用Asc来决定一些条件，如第一个字符是大写还是小写、是字母还是数字。  
Private Sub CommandButton1\_Click()  
  Dim sTest As String  
  Dim iChar As Integer  
  sTest = TextBox1.Text  
  If Len(sTest) > 0 Then  
    iChar = Asc(sTest)  
    If iChar >= 65 And iChar <= 90 Then  
      MsgBox “第一个字符是大写”  
    ElseIf iChar >= 97 And iChar <= 122 Then  
      MsgBox “第一个字符是小写”  
    Else  
      MsgBox “第一个字符不是字母”  
    End If  
  Else  
    MsgBox “请在文本框中输入”  
  End If  
End Sub  
(2) 用Asc函数和Chr函数来创建基本加密的方法。  
Private Sub CommandButton2\_Click()  
  Dim MyName As String, MyEncryptedString As String  
  Dim MyDecryptedString As String  
  Dim i As Integer  
  MyName = “fanjy”  
  For i = 1 To Len(MyName)  
    MyEncryptedString = MyEncryptedString & Chr(Asc(Mid(MyName, i, 1)) + 25)  
  Next i  
  MsgBox “您好!我的名字是” & MyEncryptedString  
  For i = 1 To Len(MyName)  
    MyDecryptedString = MyDecryptedString & Chr(Asc(Mid(MyEncryptedString, i, 1)) – 25)  
  Next i  
  MsgBox “您好!我的名字是” & MyDecryptedString  
End Sub  
– – – – – – – – – – – – – – – – – – – – – – –  
  
2.10 返回数值代表的相应字符  
Chr函数返回指定字符码所代表的字符，其语法为：  
    Chr(charcode)  
其中参数charcode代表字符码，一般为0～255。例如：  
MyChar = Chr(65)  ‘ 返回 A  
MyChar = Chr(97)   ‘ 返回 a  
MyChar = Chr(62)  ‘ 返回 >  
MyChar = Chr(37)  ‘ 返回 %  
\[编程方法和技巧\]  
(1) 使用Chr(34)将引号嵌入字符串，如  
Chr(34) & sString & Chr(34)  
(2) 下面列出了在调用Chr函数时比较常用的字符代码：  
代码  值    描述  
0   Null   相当于vbNullChar常数  
8   BS   相当于vbBack常数  
9   TAB   相当于vbTab常数  
10   CR   相当于vbCr和vbCrLf常数  
13   LF   相当于vbLf和vbCrLf常数  
34   “”   引号  
– – – – – – – – – – – – – – – – – – – – – – –  
  
2.11 使用字节的函数  
VBA中返回字符串的函数有两种格式，一种以$结尾，返回字符串，不需要进行类型转换，所以速度较快，但如果输入值是包含Null的Viarant，则会发生运行错误；一种没有$，返回Viarant数据类型，如果输入值是包含Null的Viarant，则返回Null。因而，如果要使得程序运行速度快，则使用带有$的函数且要避免向这些函数传递空值。  
– – – – – – – – – – – – – – – – – – – – – – –  
  
2.12 返回数组的函数  
2.12.1 Filter函数  
Filter函数返回一个下标从零开始的数组，该数组包含基于指定筛选条件的一个字符串数组的子集。其语法为：  
    Filter(sourcearray,match\[,include\[,compare\]\])  
其中，参数sourcearray必需，是要执行搜索的一维字符串数组；参数match必需，是要搜索的字符串；参数include可选，Boolean值，表示返回子串包含还是不包含match字符串，如果include为True，返回包含match子字符串的数组子集，如果include为False，返回不包含match子字符串的数组子集；参数compare可选，表示所使用的字符串比较类型，其设置值为：-1(常数为vbUseCompareOption)表示使用Option Compare语句的设置值来执行比较；0(常数为vbBinaryCompare)表示执行二进制比较；1(常数为vbTextCompare)表示执行文字比较；2(常数为vbDatabaseCompare)只用于Microsoft Access，表示基于数据库信息来执行比较。  
如果在sourcearray中没有发现与match相匹配的值，Filter函数返回一个空数组；如果sourcearray是Null或不是一个一维数组，则产生错误。  
Filter函数所返回的数组，其元素数是所找到的匹配项目数。  
\[编程方法和技巧\]  
(1) Filter函数也可以过滤数字值。此时，应指定Variant类型的字符串sourcearray，并用数字值给数组赋值。同时，也可以将字符串、Variant、Long或Integer数据传递给match。但应注意，返回的字符串表现为被过滤数字的字符串的形式。例如：  
Sub test()  
  Dim varSource As Variant, varResult As Variant  
  Dim strMatch As String, i  
  strMatch = CStr(2)  
  varSource = Array(10, 20, 30, 21, 22, 32)  
  varResult = Filter(varSource, strMatch, True, vbBinaryCompare)  
  For Each i In varResult  
    Debug.Print i  
  Next  
End Sub  
将返回20，21，22，32  
(2) Filter函数可以和Dictionary对象很好地配合使用。可以把Dictionary对象产生的Key值作为一种过滤Dictionary对象成员的快速方法传递给Filter函数，如：  
Sub test()  
  Dim i As Integer  
  Dim sKeys() As Variant  
  Dim sFiltered() As String  
  Dim sMatch As String  
  Dim blnSwitch As Boolean  
  Dim oDict As Dictionary  
  Set oDict = New Dictionary  
  oDict.Add “Microsoft”, “One Microsoft Way”  
  oDict.Add “AnyMicro Inc”, “31 Harbour Drive”  
  oDict.Add “Landbor Data”, “The Plaza”  
  oDict.Add “Micron Co.”, “999 Pleasant View”  
  sKeys = oDict.Keys  
  sMatch = “micro”  
  blnSwitch = True  
  ‘寻找包含字符串macro(不区分大小写)的所有键  
  sFiltered() = Filter(sKeys, sMatch, blnSwitch, vbTextCompare)  
  For i = 1 To UBound(sFiltered)  
      Debug.Print sFiltered(i) & “,” & oDict.Item(sFiltered(i))  
  Next i  
End Sub  
2.12.2 Split函数  
Split函数返回一个下标从零开始的一维数组，包含指定数目的子字符串。其语法为：  
    Split(expression\[,delimiter\[,limit\[,compare\]\]\])  
其中，参数expression必需，表示包含子字符串和分隔符的字符串，若expression是一个长度为零的字符串(“”)，该函数则返回一个没有元素和数据的空数组；参数delimiter用于标识子字符串边界的字符串字符，若忽略则使用空格(“ “)作为分隔符，若是一个长度为零的字符串则返回仅包含一个元素的数组，该元素是expression所表示的字符串；参数limit表示要返回的子字符串数，-1表示返回所有的子字符串；参数compare表示判别子字符串时使用的比较方式，其值与Filter函数的设置值相同。  
– – – – – – – – – – – – – – – – – – – – – – –  

2.13 连接字符串  
Join函数返回连接某数组中的多个子字符串而组成的字符串，即将数组中的字符串连接起来。其语法为：  
    Join(sourcearray\[，delimiter\])  
其中，参数sourcearray必需，是包含被连接子字符串的一维数组；参数delimiter可选，代表在所返回的字符串中用于分隔子字符串的字符，若忽略则使用空(“ ”)来分隔，若为零长字符串(“”)，则所有项目都连接在一起，中间没有分隔符。  
– – – – – – – – – – – – – – – – – – – – – – –  
  
2.14 替换字符串  
Replace函数返回一个被替换了的字符串，该字符串中指定的子字符串已被替换成另一个子字符串，并且替换指定次数。其语法为：  
    Replace(expression,find,replace\[,start\[,count\[,compare\]\]\])  
其中，参数expression必需，表示所要替换的子字符串；参数find必需，表示要搜索到的子字符串；参数replace必需，表示用来替换的子字符串；参数start表示开始搜索的位置，若忽略，则从1开始；参数count表示进行替换的次数，缺省值是-1，表示进行所有可能的替换；参数compare表示判别子字符串时所用的比较方式，与Filter函数的设置值相同。  
如果expression的长度为零，Replace返回零长度字符串(“”)；如果expression为Null，则返回错误；如果find的长度为零，则返回expression的副本；如果replace的长度为零，则返回删除了所有出现find的字符串的副本；如果start的值大于expression的长度，则返回长度为零的字符串；如果count为0，则返回expression的副本。  
Replace函数返回的字符串是从参数start所指定的位置开始到expression结尾已经进行过替换的字符串。  
注意：  
(1) 如果没有使用参数count，那么当替换较短字符串时就要注意，防止形成一个不相关的字符。  
(2) 如果start值大于1，返回的字符串将从start开始，而不是从原有字符串的第一个字符开始。  
– – – – – – – – – – – – – – – – – – – – – – –  
  
2.15 反向字符串  
StrReverse函数返回与指定字符串顺序相反的字符串，其语法为：  
    StrReverse(expression)  
其中，参数expression是一个字符串，应用StrReverse函数后将返回与该字符串顺序相反的字符串。如果expression是一个长度为零的字符串(“”)，则返回一个长度为零的字符串；如果expression为Null，则产生一个错误。  
    
使用字符串函数  
不同的类中都定义有字符串函数。这些类包括 Microsoft.VisualBasic.Strings 类和 System.String 类。  
  
使用 Microsoft.VisualBasic.Strings 类中的字符串函数  
下列函数是 Microsoft.VisualBasic.Strings 类中定义的字符串函数。  
注意：要使用字符串函数，请通过在源代码开始处添加以下代码将命名空间 Microsoft.VisualBasic.Strings 导入到项目中：   
Imports Microsoft.VisualBasic.Strings  
Asc 和 AscW  
Asc 函数和 AscW 函数返回一个整数值，表示与指定的字符相对应的字符代码。这两个函数接受任何有效的字符表达式或字符串表达式作为参数。当字符串是输入参数时，则仅输入字符串的第一个字符。当字符串不包含任何字符时，将出现 ArgumentException 错误。Asc 返回输入字符的代码数据点或字符代码。对于单字节字符集 (SBCS) 值，返回值可以是 0 到 255 之间的数字。对于双字节字符集 (DBCS) 值，返回值可以是 -32768 到 32767 之间的数字。AscW 为输入字符返回 0 到 65535 之间的 Unicode 代码数据点。  
示例：   
Dim MyInt As Integer  
MyInt = Asc(“A”)   ‘ MyInt is set to 65.  
MyInt = Asc(“a”)   ‘ MyInt is set to 97.  
MyInt = Asc(“Apple”)   ‘ MyInt is set to 65.  
Chr 和 ChrW  
Chr 函数和 ChrW 函数返回与指定的字符代码相关联的字符。当 CharCode 超出 -32768 到 65535 的范围时，将出现 ArgumentException 错误。  
示例：   
本示例使用 Chr 函数返回与指定的字符代码相关联的字符。   
Dim MyChar As Char  
MyChar = Chr(65)   ‘ Returns “A”.  
MyChar = Chr(97)   ‘ Returns “a”.  
MyChar = Chr(62)   ‘ Returns “>”.  
MyChar = Chr(37)   ‘ Returns “%”.  
GetChar  
GetChar 函数返回一个 Char 值，表示指定字符串的指定索引中的字符。当索引小于 1 或大于指定输入参数中最后一个字符的索引时，将出现 ArgumentException 错误。  
示例：  
本示例显示了如何使用 GetChar 函数从字符串的指定索引中返回字符。   
Dim myString As String = “ABCDE”  
Dim myChar As Char  
myChar = GetChar(myString, 4)   ‘ myChar = “D”  
InStr  
InStr 函数返回一个整数，指定一个字符串在另一个字符串中首次出现的起始位置。  
示例：  
以下示例使用 InStr 函数返回一个字符串在另一个字符串中首次出现的位置：   
Dim SearchString, SearchChar As String  
Dim MyPos As Integer  
SearchString =”XXpXXpXXPXXP”   ‘ String to search in.  
SearchChar = “P”   ‘ Search for “P”.  
‘ A textual comparison starting at position 4. Returns 6.  
MyPos = InStr(4, SearchString, SearchChar, CompareMethod.Text)     
Join  
Join 函数返回一个字符串，该字符串是通过连接数组中包含的子字符串创建的。包含必须连接的子字符串的一维数组将作为参数传递给 Join 函数。该函数使用 Delimiter、String 作为可选参数来分隔返回的字符串中的子字符串。当省略 Delimiter 时，将使用空格（“ ”）作为子字符串之间的分隔符。当 Delimiter 是零长度字符串 (“”) 时，数组中的子字符串将不使用分隔符，而是直接相连。  
示例：  
以下示例显示了如何使用 Join 函数：   
Dim myItem(2) As String  
Dim myShoppingList As String  
myItem(0) = “Pickle”  
myItem(1) = “Pineapple”  
myItem(2) = “Papaya”  
‘ Returns “Pickle, Pineapple, Papaya”  
myShoppingList = Join(myItem, “, “)  
LCase  
LCase 函数返回已经转换为小写的字符串或字符。只有大写字母被转换为小写。所有小写字母和非字母字符均保持不变。  
示例：  
以下示例使用 LCase 函数返回字符串的小写形式：   
Dim UpperCase, LowerCase As String  
Uppercase = “Hello WORLD 1234”   ‘ String to convert.  
Lowercase = LCase(UpperCase)   ‘ Returns “hello world 1234”.  
LTrim、RTrim 和 Trim  
这些函数会返回一个包含指定字符串的副本的字符串。在使用 LTrim 时，没有起始空格。在使用 RTrim 时，没有尾随空格。在使用 Trim 时，既没有起始空格也没有尾随空格。  
示例：  
以下示例使用 LTrim 函数删除字符串变量中的起始空格，使用 RTrim 函数删除字符串变量中的尾随空格，以及使用 Trim 函数删除字符串变量中的起始空格和尾随空格：   
Dim MyString, TrimString As String  
MyString = ”  <-Trim->  ”   ‘ Initializes string.  
TrimString = LTrim(MyString)   ‘ TrimString = “<-Trim->  “.  
TrimString = RTrim(MyString)   ‘ TrimString = ”  <-Trim->”.  
TrimString = LTrim(RTrim(MyString))   ‘ TrimString = “<-Trim->”.  
‘ Using the Trim function alone achieves the same result.  
TrimString = Trim(MyString)   ‘ TrimString = “<-Trim->”.  
Replace  
Replace 函数返回一个字符串，其中指定的子字符串按指定的次数替换为另一个子字符串。Replace 函数的返回值是一个字符串，该字符串在 Start 参数指定的位置开始，然后在指定字符串的末尾以 Find 参数和 Replace 参数中的值所指定的替换内容结束。  
示例：  
本示例演示了 Replace 函数：   
Dim myString As String = “Shopping List”  
Dim aString As String  
‘ Returns “Shipping List”.  
aString = Replace(myString, “o”, “i”)  
StrComp  
StrComp 函数返回 –1、0 或 1。这将基于字符串比较的结果。字符串将从第一个字符开始按字母数字顺序排列的值进行比较。  
示例：  
以下示例使用 StrComp 函数返回字符串比较的结果。如果省略第三个参数，则使用选项比较语句或项目默认设置中定义的比较类型。   
Dim MyStr1, MyStr2 As String  
Dim MyComp As Integer  
MyStr1 = “ABCD”   
MyStr2 = “abcd”   ‘ Defines variables.  
‘ The two strings sort equally. Returns 0.  
MyComp = StrComp(MyStr1, MyStr2, CompareMethod.Text)  
‘ MyStr1 sorts after MyStr2. Returns -1.  
MyComp = StrComp(MyStr1, MyStr2, CompareMethod.Binary)  
‘ MyStr2 sorts before MyStr1. Returns 1.  
MyComp = StrComp(MyStr2, MyStr1)  
StrConv  
StrConv 函数返回一个字符串，该字符串转换为输入参数中指定的值。StrConv 函数将转换字符串。这种转换基于 Conversion 参数中的值。Conversion 参数中的值是 VbStrConv 枚举的成员。  
Conversion 参数的设置为：  
枚举成员 说明   
VbStrConv.None 不执行转换   
VbStrConv.LinguisticCasing – 使用语言规则而不是文件系统（默认值）来区分大小写  
– 仅对大写和小写字母有效   
VbStrConv.UpperCase 将字符串转换为大写字符   
VbStrConv.LowerCase 将字符串转换为小写字符   
VbStrConv.ProperCase 将字符串中每个单词的第一个字母转换为大写   
示例：  
以下示例将文本转换为小写字母：   
Dim sText, sNewText As String  
sText = “Hello World”  
sNewText = StrConv(sText, VbStrConv.LowerCase)  
Debug.WriteLine (sNewText)   ‘ Outputs “hello world”.  
StrDup  
StrDup 函数返回一个由指定的字符重复指定的次数而形成的字符串或对象。StrDup 函数具有两个参数：Number 参数和 Character 参数。Number 参数指定函数必须返回的字符串的长度。StrDup 函数仅使用 Character 参数中的第一个字符。Character 参数可以是 Char 数据类型、String 数据类型或 Object 数据类型。  
示例：  
以下示例使用 StrDup 函数返回由重复字符组成的字符串：   
Dim aString As String = “Wow! What a string!”  
Dim aObject As New Object()  
Dim myString As String  
aObject = “This is a String that is contained in an Object”  
myString = StrDup(5, “P”)   ‘ Returns “PPPPP”  
myString = StrDup(10, aString)   ‘ Returns “WWWWWWWWWW”  
myString = StrDup(6, aObject)   ‘ Returns “TTTTTT”  
StrReverse  
StrReverse 函数返回一个字符串，该字符串将指定字符串的字符顺序颠倒过来。  
示例：   
Dim myString As String = “ABCDEFG”  
Dim revString As String  
‘ Returns “GFEDCBA”.  
revString = StrReverse(myString)  
UCase  
UCase 函数返回一个字符串或字符，包含已转换为大写的指定字符串。只有小写字母被转换为大写字母。所有大写字母和非字母字符均保持不变。  
示例：  
以下示例使用 UCase 函数返回字符串的大写形式：   
Dim LowerCase, UpperCase As String  
LowerCase = “Hello World 1234”   ‘ String to convert.  
UpperCase = UCase(LowerCase)   ‘ Returns “HELLO WORLD 1234”.  
  
使用 System.String 类中的字符串函数  
以下是 System 命名空间的 String 类中的字符串函数。  
注意：要使用字符串函数，请通过在源代码开始处添加以下代码将 System.String 命名空间导入到项目中：   
Imports System.String  
Compare  
Compare 函数比较输入参数中的两个字符串。通过使用单词排序规则来执行比较。发现不相等情况或比较完两个字符串后，比较将终止。  
Compare 示例：   
‘ Code is not compiled unless it is put in a Sub or in a Function.  
Dim s1, s2 As String  
s1 = “testexample”  
s2 = “testex”  
MsgBox(Compare(s2, s1)) ‘Returns -1.  
MsgBox(Compare(s1, s2)) ‘Returns 1.Concat  
Concat 函数将一个或多个字符串相连接，然后返回连接后的字符串。  
Concat 示例：  
以下示例显示了如何使用 Concat 的重载版本：   
‘ Code is not compiled unless it is put in a Sub or in a Function.  
Dim s1, s2, sa(3) As String  
sa(0) = “A”  
sa(1) = “B”  
sa(2) = “C”  
s1 = “test”  
s2 = “example”  
s1 = Concat(s1, s2)  ‘Returns testexample.  
MsgBox(s1)  
MsgBox(Concat(sa)) ‘Returns ABC.Copy  
Copy 函数将指定字符串中的值复制到另一个字符串中。  
Copy 示例：   
‘ Code is not compiled unless it is put in a Sub or in a Function.  
Dim s1, s2 As String         
s1 = “Hello World”  
‘Copy the string s1 to s2.  
s2 = Copy(s1)  
MsgBox(s2) ‘Displays Hello World.Remove  
Remove 函数从指定字符串的指定位置开始删除指定数目的字符。Remove 函数有两个参数。分别是 StartIndex 参数和 Count 参数。Startindex 参数指定开始删除字符的字符串位置。Count 参数指定要删除的字符数。  
Remove 示例：   
‘ Code is not compiled unless it is put in a Sub or in a Function.  
Dim s1, s2 As String         
s1 = “Hello World”  
‘Removes 3 characters starting from character e.  
s2 = s1.Remove(1, 3)  
MsgBox(s2) ‘Displays Hello World.  
Substring  
Substring 函数从指定字符串的指定位置开始检索字符串。  
Substring 示例：  
以下示例将从指定的字符位置开始并按指定的长度来检索子字符串：   
‘ Code is not compiled unless it is put in a Sub or in a Function.  
Dim s1, s2 As String  
s1 = “Hello World”  
s2 = s1.Substring(6, 5) ‘Returns World.  
MsgBox(s2)ToCharArray  
ToCharArray 函数将字符串中的字符复制到 Unicode 字符数组中。  
ToCharArray 示例：  
以下示例将指定位置中的字符复制到 Character 数组中：   
‘ Code is not compiled unless it is put in a Sub or in a Function.  
Dim s1 As String  
Dim ch(10) As Char  
s1 = “Hello World”  
‘Copies the characters starting from W to d to a Character array.  
ch = s1.ToCharArray(6, 5)  
MsgBox(ch(3)) ‘Displays l.ToLower  
ToLower 函数采用一个字符串作为参数，然后以小写形式返回该字符串的副本。  
ToLower 示例：   
‘ Code is not compiled unless it is put in a Sub or in a Function.  
Dim s1, s2 As String  
s1 = “Hello World”  
s2 = s1.ToLower() ‘Converts any uppercase characters to lowercase.  
MsgBox(s2) ‘Displays hello world.ToUpper  
ToUpper 函数采用一个字符串作为参数，然后以大写形式返回该字符串的副本。  
ToUpper 示例：   
‘ Code is not compiled unless it is put in a Sub or in a Function.  
Dim s1, s2 As String  
s1 = “Hello World”  
s2 = s1.ToUpper() ‘Converts any lowercase characters to uppercase.  
MsgBox(s2) ‘Displays HELLO WORLD.Trim、TrimStart 和 TrimEnd  
这些函数会返回一个包含指定字符串的副本的字符串。使用 Trim 函数时，既没有起始空格也没有尾随空格。使用 TrimStart 函数时，没有起始空格。使用 TrimEnd 函数时，没有尾随空格。  
示例：  
以下示例使用 TrimStart 函数删除字符串变量开始处的空格，使用 TrimEnd 函数删除字符串变量末尾的空格，以及使用 Trim 函数删除字符串变量中的起始空格和尾随空格：   
‘ Code is not compiled unless it is put in a Sub or in a Function.  
Dim s1, s2 As String  
s1 = ”   Hello World   “  
s2 = s1.Trim()      ‘Returns Hello World without any white spaces.  
s2 = s1.TrimStart   ‘Removes the spaces at the start.     
s2 = s1.TrimEnd     ‘Removes the white spaces at the end.