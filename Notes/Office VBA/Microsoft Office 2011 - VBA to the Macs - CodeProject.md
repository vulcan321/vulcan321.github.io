# Microsoft Office 2011 - VBA to the Macs

Developing custom functionality for Microsoft Office 2011 for Mac in C and VBA

-   [Download source - 59.6 KB](https://www.codeproject.com/KB/office/810282/vba2themacs_src.zip)
-   [Download demo - 53.6 KB](https://www.codeproject.com/KB/office/810282/vba2themacs_demo.zip)

## Introduction

With the release of Microsoft Office 2011 for Mac, VBA made a welcome return to the Apple platform.

Alas, though the VBA implementation in Microsoft Office 2011 closely mirrors the implementation found on the Windows platform, none of the many features that are provided through COM and ActiveX on the Windows platform made the journey across. Add to that, a total absence of anything resembling an SDK, and developer reference documentation that can at best be described as rudimentary – and the prospect of developing custom Office 2011 solutions quickly appear daunting.

In this article, I will demonstrate how it is possible to develop dynamic libraries (_dylib_ files) in C to provide custom functionality for Office 2011 through VBA from simple input and output operations using basic types such as booleans, numbers, strings, arrays and VBA User Defined Types, to the implementation of simple RegEx and HTTP POST and GET functionality.

## Background

On the Windows platform, the Microsoft Office suite can be extended using a series of technologies such as ActiveX/COM, application specific components such as the XLL – even accessing DLL functions directly following registration of these using the Excel `REGISTER` function, are all viable approaches. On the Apple OS X platform, without the SDK, these options are not available.

Now, Microsoft may have failed to provide an SDK, and the developer documentation may be crude – but they did provide a VBA environment that will be recognisable to those that have been exposed to the version seen on the Windows platform, and they provided support for the `DECLARE` statement. It is through the use of declare that new functionality can be provided in the VBA environment.

For a VBA developer not familiar with the Apple OS X platform, there is very little in the way of documentation available. Having searched extensively on the web, I was unable to locate anything that could serve as a starting point, and provide basic guidance in how to interface VBA to external libraries on OS X. In this article, I hope to remedy the situation somewhat, and hopefully spur the odd developer on to take another look at VBA on the Mac.

It is assumed that the reader is familiar with VBA and interfacing to external functions and libraries. This article is not attempting to teach you VBA - but rather show you how your existing VBA skills can be applied to the Apple OS X platform.

## Getting Started

The configuration used for this article is as follows:

-   Apple OS X 10.9.2
-   Apple Xcode 5.1.1
-   Microsoft Office 2011 for Mac 14.4.1

There is nothing in the approach or code base that requires the specific OS X and Xcode versions, any OS X release and corresponding Xcode version you have to hand should be fine.

Before getting started, there are a few things to keep in mind for those more familiar with the Windows world:

-   On Apple OS X, the DLL equivalent is the `dylib`
-   Microsoft Office 2011 for Mac is a 32bit application suite
-   The VBA version in Office 2011 appear to be equivalent to the Windows VBA release 6.5 – that is, the version shipped with Microsoft Office 2007 in the Windows world

In summary, the custom library (`dylib`) we are developing for OS X must be a 32bit dynamic library. As far as VBA syntax is concerned, we should be able to refer to the developer reference documentation for Microsoft Office 2007 for Windows for pointers and samples.

### The Xcode Project

In Xcode, create a new project and specify the C/C++ Library template.

![Sample Image - maximum width is 600 pixels](https://www.codeproject.com/KB/office/810282/vba2themacs1.png)

Ensure that the library type is specified as Dynamic as shown.

![Sample Image - maximum width is 600 pixels](data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==)

Once your project has been created, ensure that the **Architectures** setting specifies **32-bit Intel (i386)** as shown.

![Sample Image - maximum width is 600 pixels](data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==)

### Basic Input/Output

The basics of any input and output revolve around booleans, numbers and strings. In the _introduction.c_ source file in the project for this article, you will find the following C functions that perform basic operations on numbers and strings.


```c
double CIntroAddDouble( double a, double b ) { return a + b; }

bool CIntroIntIsOdd (int i) { return i % 2; }

int CIntroStrLen (char *str) { return strlen(str); }
```

Then, there is the array.

In this little example, the C function `CIntroArraySum` is being passed two parameters – a pointer to a long representing the first element in the array being passed (`firstArrayElement`), and a second parameter, a long specifying the length of the array being passed (`arrayLength`).

Note that, as is the case on the Windows platform, it is not possible to pass arrays where elements contain `string`s, to and from `dylib` functions and commands. On the Windows platform, a `string` array is normally passed to and from DLL files in the form of a `SAFEARRAY`.

The C function enumerates the array passed, and sums up the individual array element values – returning the total.

```c
int CIntroArraySum(long *firstArrayElement, long arrayLength) {
    int ret = 0 ;
    for (int i = 0; i < arrayLength; i++)
    {
        ret = ret + firstArrayElement[i];
    }
    return ret;
}
```

Finally – a sample command, which enumerates and updates the elements of an array allocated, initialised and passed as a parameter from VBA.

```c
void CIntroArrayUpdate(long *arrayElement, long arrayLength) {
    for (int i = 0; i < arrayLength; i++) {
        arrayElement[i] = arrayLength - i;
    }
    return;
}
```

None of these functions are in any way OS X specific, they will function identically on the Windows platform and as such should be familiar to Windows developers that have been developing and/or interfacing to DLL files from VBA.

### The VBA Code

As part of the `declare` syntax, it is necessary to provide the full path to the _dylib_ file, unless the file is placed on one of the default search paths for _dylib_ files. I would recommend that you copy the file _libvba2themacs.dylib_ to one of the standard search paths, _/usr/lib_, _/usr/local/lib_ or alternatively _/Users/\[Username\]/lib_. Doing so ensures that the declarations can be limited to providing the _dylib_ file name only. These three paths are search by default by all the OS X versions available to me, when looking for a specified _dylib_ file. There may well be others – but I haven’t gotten around to locating them yet.

Assuming that the _dylib_ has been placed in one of the search paths, the VBA declare statement for the basic functions and commands above, will look as follows:

VB.NET

```vb
Private Declare Function CIntroAddDouble Lib "libvba2themacs.dylib" _
(ByVal a As Double, ByVal b As Double) As Double
Private Declare Function CIntroIntIsOdd Lib "libvba2themacs.dylib" _
(ByVal a As Integer) As Boolean
Private Declare Function CIntroStrLen Lib "libvba2themacs.dylib" _
(ByVal a As String) As Long
Private Declare Function CIntroArraySum Lib "libvba2themacs.dylib" _
(ByRef firstArrayElement As Long, ByVal arraySize As Long) As Long
Private Declare Sub CIntroArrayUpdate Lib "libvba2themacs.dylib" _
(ByRef firstArrayElement As Long, ByVal arraySize As Long)
```

In summary, passing parameters from VBA to our `dylib` for basic types can be done `ByVal`. For arrays, the first array element must be passed `ByRef` while the array length should be passed `ByVal`.

### Getting Strings from the dylib

Passing and returning numerical types, as well as passing `string`s is simple enough, but when it comes to returning `string` values from the `dylib`, a different approach is needed. In VBA, any `string` appears to be a BSTR (an OLE `string`, but this is an assumption on my behalf, there is no documentation to refer to), so any attempt at returning a C `string` directly to VBA will result in memory access errors and cause Office to crash. One way around for this problem, is to allocate and initialise a `string` to hold the returned value in VBA, ensuring that its sized so as being large enough to hold the expected response, then pass the response `string` as a parameter to the external function or sub in the `dylib` where it can be updated.

As an example of this, consider retrieving host configuration information such as OS build details or hardware platform. On OS X, as well as on most Linux varieties, this can be done using uname. In C, an example function that retrieves the OS release details using uname would look something like the following:


```c
int CUnameRelease(char *data)
{
    struct utsname utsnameData;
    uname(&utsnameData);
    strcpy(data, utsnameData.release);
    return strlen(utsnameData.release);
}
```

Here, an initialised `string` parameter (`data`) is passed to the C function. This C function in turn executes `uname`, and subsequently copies the resulting release details to the VBA `string` (`data`). In order to aid in error trapping on the VBA side, the size of the release details `string` from the `uname` call is returned by the function as a 32bit integer.

In VBA, the corresponding `declare` statement for the `CUnameRelease` function above, will be as follows – again, note that the string parameter is declared `ByVal`:

VB.NET

```vb
Private Declare Function CUnameRelease Lib "libvba2themacs.dylib" (ByVal Release As String) As Long
```

The process flow for the `string` manipulation and return can be summarised as follows:

VBA Function/Sub Allocate & initialise string and calls --> dylib Function/Command Updates string --> VBA Function/Sub Reads updated string

The VBA implementation of a function that retrieves the `uname` release parameter using the C function would look as follows:

VB.NET

```vb
Public Function vbaxUnameRelease() As String
    Dim lng As Long
    Dim ret As String
    ret = String(256, vbNullChar)
    lng = CUnameRelease(ret)
    If lng <= 256 Then
        vbaxUnameRelease = ret
    Else
       vbaxUnameRelease = "CUnameRelase value in excess of 256 characters"
    End If
End Function
```

In this VBA function, a 256-character `string` is allocated and initialised using `vbNullChar`. This `string` is then passed as a parameter to the `CUnameRelease` function in our `dylib` where the `string` is populated with the `uname` release parameter details. The long returned from `CUnameRelease` enables the implementation of error trapping, should the string in the `dylib` be longer than the VBA allocated `string`.

### The VBA Type and C struct

As you may have noticed, uname actually returns a `struct` called `utsname`. This `struct` is defined as follows:

C

```
#define    _SYS_NAMELEN    256
struct utsname {
    char    sysname[_SYS_NAMELEN];    /* [XSI] Name of OS */
    char    nodename[_SYS_NAMELEN];    /* [XSI] Name of this network node */
    char    release[_SYS_NAMELEN];    /* [XSI] Release level */
    char    version[_SYS_NAMELEN];    /* [XSI] Version level */
    char    machine[_SYS_NAMELEN];    /* [XSI] Hardware type */
};
```

So, in our C function, the one call to `uname` actually retrieves 5 different `string` values each a maximum of 256 characters in length. Instead of just returning a single value from our `dylib` function, it would be advantageous to return all the parameters of the `utsname` result, thereby passing all the data to VBA for further processing in one single operation.

One approach would be to use a VBA UDT (User Defined Type). As is the case in VBA on the Windows platform, a VBA UDT can be defined so that it mirrors a corresponding C `struct` definition. An instance of the VBA UDT can then be passed to a `dylib` function or process as a parameter. The definition of a VBA UDT for the C `struct utsname` will look as follows:

C

```
Public Type UTSNAME
    Sysname As String * 256
    Nodename As String * 256
    Release As String * 256
    Version As String * 256
    Machine As String * 256
End Type
```

In VBA, the corresponding `declare` statement for the `CUnameDataStruct` function above, will be as follows – note that the `UTSNAME` type parameter must be declared as `ByRef`:

C

```
Private Declare Sub CUnameData Lib "libvba2themacs.dylib" (ByRef unameData As UTSNAME)
```

So, in a single VBA call, we are now able to retrieve all five parameters that make up the utsname struct in one single call to the `dylib`. In the sample Excel based VBA function here, the attribute values from the UDT are returned as a Variant data type – a typical Excel array function.

VB.NET

```vb
Public Function vbaxUnameData() As Variant
    Dim ret(1 To 5, 1 To 1) As Variant
    Dim utsnameData As UTSNAME
    Call CUnameDataStruct(utsnameData)
    ret(1, 1) = utsnameData.Sysname
    ret(2, 1) = utsnameData.Nodename
    ret(3, 1) = utsnameData.Release
    ret(4, 1) = utsnameData.Version
    ret(5, 1) = utsnameData.Machine
    vbaxUnameData = ret
End Function
```

In summary, numerical values can be passed between a `dylib` and VBA without issues in a way familiar to those used to the Windows platform, `string`s can be passed as well – but only as pre allocated and initialised parameters, and finally a VBA UDT/C `struct` can be used to pass data between VBA and the `dylib`.

### Implementing RegEx Match

You now know how to go about getting data in and out of custom libraries using VBA. So what can we do with this knowledge?

Consider a basic piece of functionality often used in data entry validation – check if the entered value matches an expected format. This could, for example, be to check if a valid email address format is used, or if a phone number is valid.

Implementing this kind of validation logic using only VBA can often be a challenge, and any changes to what constitutes a valid format will frequently result in VBA code changes being needed. In this use case, implementing a generic RegEx based validation function would make a great deal of sense. If such as function was implemented, you could simply pass the input `string` and the latest version of the regex pattern that defines the valid format for the `string` type, perform a RegEx match check operation and get a simple match/no-match response. Should the format change at some point in the future, all that requires updating will be the regex pattern, the function itself remains unaffected.

The following C function shows an example of such a function, accepting two `string` inputs – the `string` we want to check (`regexString`), and the regex pattern we want to check against (`regexPattern`). If the regex pattern is valid and there is a match against the `string`, it returns `true`, otherwise it returns `false`.
```c
#include <regex.h>
bool CRegexMatchBool(char *regexString, char *regexPattern)
{
    int status;
    regex_t rt;
    status = regcomp(&rt, regexPattern, 0);
    if (status)
    {
        return 0;
    }
    else
    {
        status = regexec(&rt, regexString, 0, NULL, 0);
        regfree(&rt);
        return (!status);
    }
}
```

In VBA, the corresponding declaration for our function would look as follows:

```vb
Private Declare Function CRegexMatchBool Lib "libvba2themacs.dylib" _
(ByVal regexString As String, ByVal regexPattern As String) As Boolean
```

Finally, a VBA function, which calls `CRegexMatchBool`, could be implemented as follows:

```vb
Public Function vbaxRegexMatchBool_
(ByVal regexString As String, ByVal regexPattern As String) As Boolean
    Dim bret As Boolean
    bret = CRegexMatchBool(regexString, regexPattern)
    vbaxRegexMatchBool = bret
End Function
```

If you consider what would be involved in creating a VBA only generic validation function, implementing a simple `dylib` function as shown above is well worth the time and effort.

### Implementing HTTP GET and POST

In OS X a number of open source components are readily available as part of the core OS, and for HTTP functionality, we can utilize `libcurl` to implement custom functions for HTTP `GET` and `POST` operations that can be called from VBA. The `dylib` project will require a reference to the `libcurl` library – in this case, _libcurl.4.dylib_ is used.

For more details on `libcurl`, refer to [http://curl.haxx.se/libcurl](http://curl.haxx.se/libcurl).

For simplicity, HTTP `GET` and `POST` are implemented as two distinct functions in the sample code base. For more details, refer to the source code in the Xcode project.
```c
#include <curl/curl.h>

int CCurlHttpGet(char *url, char *httpResponse)
{...
```

The `CCurlHttpGet` function uses the approach detailed in the `CIntroUnameRelease` function – from VBA, two parameters are passed to the C function, the target web address for the HTTP call (`url`) and an initialised string (`httpResponse`), large enough for the expected response form the call.

```c
int CCurlHttpPost(char *url, char *fields, char *httpResponse)
{...
```

`CCurlHttpPost` also uses the approach detailed in the `CUnameRelease` function – in this case, three parameters are passed to the C function, a `string` containing the target web address for the HTTP call (`url`), a `string` containing the fields data (`fields`) and an initialised `string` (`httpResponse`), large enough for the expected response from the call.

Both HTTP functions return the length of the HTTP response as an integer (VBA long) allowing for error trapping in VBA. In case of errors, the HTTP functions will return a `0`, and the response `string` (`httpResponse`) will contain the error message.

## Using the Code

The download for this article contains in addition to the Xcode 5.1 project files, an Excel 2011 XLSM file containing examples of all the functions mentioned in this article and a compiled dylib file _libvba2themacs.dylib_. The `declare` statements used in the Excel VBA code do not reference a full path name to the dylib, so in order to run these functions, the _libvba2themacs.dylib_ file must be copied to either _/usr/lib_, _usr/local/lib_ or _/Users/\[user name\]/lib_.

## Points of Interest

The process of developing custom libraries for VBA on Apple OS X may be hampered by the absence of an SDK, and developer documentation may be rudimentary - but once the basic techniques are understood, you can focus on locating the right header file and getting your C code right. The Apple OS X platform has a large number of open source components readily available as part of the standard OS install, in addition to a number of powerful OS X specific APIs.

I highly recommend joining the Apple Developer Network, a no cost option - subscription charges only apply if you wish to have the ability to publish to the App Store. Free membership will provide you with access to vast amounts of developer reference documentation and sample code.