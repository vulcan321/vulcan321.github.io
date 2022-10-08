# VBA-Excel: Read Data from XML File

July 10, 2016December 9, 2014 by [Sumit Jain](https://excel-macro.tutorialhorizon.com/author/sumitjain/ "View all posts by Sumit Jain")



To **Read Data from XML File using** in Microsoft Excel, you need to follow the steps below:

-   Create the object of **“Microsoft XML Parser” ) (Microsoft.XMLDOM** is the COM object of **Microsoft XML Parser)**
-   **Load** the XML from a specified path.
-   Select the tag from the XML file using **SelectNodes** or **SelectSingleNode.**

o   **SelectNodes –** Selects a list of nodes matches the **Xpath** pattern.

o   **SelectSingleNode –** Selects the first **XMLNode** that matches the pattern.

-   Iterate through all the Node by using **Nodes.length** and **NodeValue**.
-   Read the attributes by using **Attribute.Length** and **getAttribute.**
-   Read the particular index value from the XML File
-   Get all the values of particular type of nodes.

**Sample XML: (Sample File has been taken from- https://msdn.microsoft.com/en-us/library/ms762271%28v=vs.85%29.aspx )  
**

Read XML -1

-   Create the object of **“Microsoft XML Parser” ) (Microsoft.XMLDOM** is the COM object of **Microsoft XML Parser)**

Set oXMLFile = CreateObject(“Microsoft.XMLDOM”)

-   **Load** the XML from a specified path.

               **XMLFileName = “D:\\Sample.xml”**    

               **oXMLFile.Load (XMLFileName)**

-   Select the tag from the XML file using **SelectNodes** or **SelectSingleNode.**

             **SelectNodes –** Selects a list of nodes matches the **Xpath** pattern.

             **Set TitleNodes = oXMLFile.SelectNodes(“/catalog/book/title/text()”)**

             **SelectSingleNode –** Selects the first **XMLNode** that matches the pattern.

             **Set Nodes\_Particular = oXMLFile.SelectSingleNode(“/catalog/book\[4\]/title/text()”)**

-   Iterate through all the Node by using **Nodes.length** and **NodeValue**.

For i = 0 To (**TitleNodes.Length** – 1)

Title = **TitleNodes(i).NodeValue**

-   Read the attributes by using **Attribute.Length** and **getAttribute.**

Set Nodes\_Attribute = **oXMLFile.SelectNodes(“/catalog/book”)**

For i = 0 To (**Nodes\_Attribute.Length** – 1)

Attributes = **Nodes\_Attribute(i).getAttribute(“id”)**

-   Read the particular index value from the XML File

oXMLFile.**SelectSingleNode**(“/catalog/**book\[4\]**/title/text()”)

-   Get all the values of particular type of nodes.

oXMLFile.**SelectNodes**(“/catalog/book/title\[../**genre = ‘Fantasy’**\]/text()”)

**NOTE**:

Reference needed:

[How to add “Microsoft Forms 2.0 Object Library”](https://excel-macro.tutorialhorizon.com/vba-excel-reference-libraries-in-excel-workbook/ "How to add “Microsoft Forms 2.0 Object Library”")  
[Microsoft Office 12.0 Object Library](https://excel-macro.tutorialhorizon.com/vba-excel-reference-libraries-in-excel-workbook/ "VBA-Excel: Reference Libraries in Excel WorkBook.")

**Complete Code:**
```vbnet
Sub ReadXML()
 Call fnReadXMLByTags
End Sub

Function fnReadXMLByTags()
 Dim mainWorkBook As Workbook
 Set mainWorkBook = ActiveWorkbook
 mainWorkBook.Sheets("Sheet1").Range("A:A").Clear
 Set oXMLFile = CreateObject("Microsoft.XMLDOM")
 XMLFileName = "D:\Sample.xml"
 oXMLFile.Load (XMLFileName)
 Set TitleNodes = oXMLFile.SelectNodes("/catalog/book/title/text()")
 Set PriceNodes = oXMLFile.SelectNodes("/catalog/book/price/text()")
 mainWorkBook.Sheets("Sheet1").Range("A1,B1,C1").Interior.ColorIndex = 40
 mainWorkBook.Sheets("Sheet1").Range("A1,B1,C1").Borders.Value = 1
 mainWorkBook.Sheets("Sheet1").Range("A" & 1).Value = "Book ID"
 mainWorkBook.Sheets("Sheet1").Range("B" & 1).Value = "Book Titles"
 mainWorkBook.Sheets("Sheet1").Range("C" & 1).Value = "Price"
 mainWorkBook.Sheets("Sheet1").Range("D1").Value = "Total books: " & TitleNodes.Length

 For i = 0 To (TitleNodes.Length – 1)
 Title = TitleNodes(i).NodeValue
 Price = PriceNodes(i).NodeValue
 mainWorkBook.Sheets("Sheet1").Range("B" & i + 2).Borders.Value = 1
 mainWorkBook.Sheets("Sheet1").Range("C" & i + 2).Borders.Value = 1
 mainWorkBook.Sheets("Sheet1").Range("B" & i + 2).Value = Title
 mainWorkBook.Sheets("Sheet1").Range("C" & i + 2).Value = Price
 Next
 'Reading the Attributes
 Set Nodes_Attribute = oXMLFile.SelectNodes("/catalog/book")
 For i = 0 To (Nodes_Attribute.Length – 1)
 Attributes = Nodes_Attribute(i).getAttribute("id")
 mainWorkBook.Sheets("Sheet1").Range("A" & i + 2).Borders.Value = 1
 mainWorkBook.Sheets("Sheet1").Range("A" & i + 2).Value = Attributes
 Next
End Function
```
[view raw](https://gist.github.com/thmain/2be0139d4c38f7985b4565c88c767aa9/raw/aa0f4bb9bfcf8615cd326c8c302c58510029e4d4/ReadXml.vb)  

[ReadXml.vb](https://gist.github.com/thmain/2be0139d4c38f7985b4565c88c767aa9#file-readxml-vb)  
hosted with ❤ by [GitHub](https://github.com)

Read XML

```vbnet
'Get the 5th book title 
Set Nodes_Particular = oXMLFile.SelectSingleNode("/catalog/book\[4\]/title/text()")
'index starts with 0, so put 4 for 5th book  
MsgBox "5th Book Title : " & Nodes_Particular.NodeValue  

'Get all the Fantasy books
Set Nodes_Fantasy = oXMLFile.SelectNodes("/catalog/book/title\[../genre = ‘Fantasy’\]/text()")  

mainWorkBook.Sheets("Sheet3").Range("A1").Value = "Fantasy Books"
mainWorkBook.Sheets("Sheet3").Range("A1").Interior.ColorIndex = 40
mainWorkBook.Sheets("Sheet3").Range("A1").Borders.Value = 1

' get their titles
For i = 0 To (Nodes\_Fantasy.Length – 1)
    Title = Nodes\_Fantasy(i).NodeValue
    mainWorkBook.Sheets("Sheet3").Range("A" & i + 2).Value = Title
Next  
```
