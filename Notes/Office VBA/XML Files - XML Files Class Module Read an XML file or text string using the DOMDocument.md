# Class: XMLFileRead in Category [XML Files : XML Files](https://www.fmsinc.com/microsoftaccess/modules/code/XMLFiles/XMLFiles/XMLFileRead_class.htm../../index.html#XML_Files_XML_Files) from Total Visual SourceBook

### Read an XML file or text string using the DOMDocument MSXML.DLL object from VBA and VB6.

Easily read the root, elements (nodes) for children and sibling nodes. Examples show how to read the entire file and search for specific nodes.

## [Procedure List](https://www.fmsinc.com/microsoftaccess/modules/code/XMLFiles/XMLFiles/XMLFileRead_class.htm#ProcedureListID)

<table class="table-bordered table-condensed table-hover table-striped" align="center"><tbody><tr class="PricingSectionTitle"><td class="PricingTitle">Procedure Name</td><td class="PricingTitle">Type</td><td class="PricingTitle">Description</td></tr><tr><td class="TableBodyBold">(Declarations)</td><td class="text-center">Declarations</td><td class="text-left">Declarations and private variables for the CXMLFileRead class.</td></tr><tr><td class="TableBodyBold">FirstChild</td><td class="text-center">Property</td><td class="text-left">Get the FirstChild of the XML file which should show the version info.</td></tr><tr><td class="TableBodyBold">Root</td><td class="text-center">Property</td><td class="text-left">Get the root of the XML file.</td></tr><tr><td class="TableBodyBold">LoadXMLFile</td><td class="text-center">Method</td><td class="text-left">Load the XML file from a physical file on disk.</td></tr><tr><td class="TableBodyBold">LoadXMLString</td><td class="text-center">Method</td><td class="text-left">Load the XML file as a string rather than loading it from a physical file on disk.</td></tr><tr><td class="TableBodyBold">ReadTextFile</td><td class="text-center">Private</td><td class="text-left">Open the named text file and return its contents as a string.</td></tr><tr><td class="TableBodyBold">RootNodeCount</td><td class="text-center">Method</td><td class="text-left">Get the number of nodes on the root.</td></tr><tr><td class="TableBodyBold">ChildNodeCount</td><td class="text-center">Method</td><td class="text-left">Get the number of nodes in the current node.</td></tr><tr><td class="TableBodyBold">GetNextNode</td><td class="text-center">Method</td><td class="text-left">Get the name of the next node. Get all the child nodes, then the sibling nodes, and then back to the parent level.</td></tr><tr><td class="TableBodyBold">GetChildNode</td><td class="text-center">Method</td><td class="text-left">Get the name and value of the specified child node by index. Optionally reset the current node to the new node if it was found. Use the GetChildNodeCount procedure to get the number of child nodes for the current node.</td></tr><tr><td class="TableBodyBold">GetNextChildNode</td><td class="text-center">Method</td><td class="text-left">Get the name and value of the next child node. Optionally reset the current node to the new node if it was found.</td></tr><tr><td class="TableBodyBold">GetNextSiblingNode</td><td class="text-center">Method</td><td class="text-left">Get the name and value of the next sibling node. Optionally resets the current node to the new node if it was found.</td></tr><tr><td class="TableBodyBold">GetChildNodeCount</td><td class="text-center">Method</td><td class="text-left">Get the number of child items in the current node.</td></tr><tr><td class="TableBodyBold">GetSiblingCount</td><td class="text-center">Method</td><td class="text-left">Get the number of siblings for the current node.</td></tr><tr><td class="TableBodyBold">GetNodeValue</td><td class="text-center">Method</td><td class="text-left">Get the node value by calling it explicitly or searching for it. Optionally make it the current node.</td></tr></tbody></table>

## [Example Code for Using Class: XMLFileRead](https://www.fmsinc.com/microsoftaccess/modules/code/XMLFiles/XMLFiles/XMLFileRead_class.htm#XMLFileReadID)

```vb
' Example of using the CXMLFileRead class to read XML files in VBA and VB6.
'
' To use this example, create a new module and paste this code into it.
' Then run either of the procedures by putting the cursor in the procedure and pressing:
'    F5 to run it, or
'    F8 to step through it line-by-line (see the Debug menu for more options)
' View the results in the immediate window

Private Const mcstrXMLFile As String = "C:\Total Visual SourceBook 2013\Samples\white-house.xml"

Private Sub ReadXMLFileAll()
  ' Comments: Read all the contents of an XML file or text string using VBA and VB6.
  '           View results in the immediate window.

  Dim strError As String
  Dim lngError As Long
  Dim strXML As String
  Dim clsXMLRead As New CXMLFileRead
  Dim strNodeName As String
  Dim strValue As String
  Dim intNodes As Integer

  If True Then
    ' If you have an XML file on disk, you can load it like this:
    strError = clsXMLRead.LoadXMLFile(mcstrXMLFile, lngError)
  Else
    ' If you have the file in memory, you can load it without creating a physical file.
    ' This function can be run if you have the Geospatial module modGoogleMapsAPI loaded
    'strXML = GoogleGeocodeXML("White House")
    strError = clsXMLRead.LoadXMLString(strXML, lngError)
  End If

  If strError = "" Then
    ' If there's no error, you can read the contents of the file
    Debug.Print "First Child: " & clsXMLRead.FirstChild

    ' Read the root level values
    intNodes = clsXMLRead.RootNodeCount
    Debug.Print "XML Root   : " & clsXMLRead.Root
    Debug.Print "Root Nodes : " & intNodes

    ' Iterate through all the nodes
    Do
      strValue = clsXMLRead.GetNextNode(strNodeName)
      If (strNodeName <> "") Then
        intNodes = clsXMLRead.GetChildNodeCount
        If intNodes = 1 Then
          Debug.Print "Node       : <" & strNodeName & "> " & strValue
        Else
          Debug.Print
          Debug.Print "Node       : <" & strNodeName & "> Items: " & intNodes
        End If
      End If
    Loop Until (strNodeName = "")
  Else
    Debug.Print "Error : " & strError
    Debug.Print "Number: " & lngError
  End If

End Sub

Private Sub ReadXMLFilePortions()
  ' Comments: Read and search portions of an XML file or text with VBA and VB6.
  '           View results in the immediate window.

  Dim strError As String
  Dim lngError As Long
  Dim strXML As String
  Dim clsXMLRead As New CXMLFileRead
  Dim strNodeName As String
  Dim strValue As String
  Dim intNodes As Integer
  Dim fFound As Boolean
  Dim intCount As Integer

  If True Then
    ' If you have an XML file on disk, you can load it like this:
    strError = clsXMLRead.LoadXMLFile(mcstrXMLFile, lngError)
  Else
    ' If you have the file in memory, you can load it without creating a physical file.
    ' This function can be run if you have the Geospatial module modGoogleMapsAPI loaded
    'strXML = GoogleGeocodeXML("White House")
    strError = clsXMLRead.LoadXMLString(strXML, lngError)
  End If

  If strError = "" Then
    Debug.Print "First Child: " & clsXMLRead.FirstChild

    intNodes = clsXMLRead.RootNodeCount
    Debug.Print "XML Root   : " & clsXMLRead.Root
    Debug.Print "Root Nodes : " & intNodes

    ' Get all the child nodes of the current node by referencing it by index
    Debug.Print
    Debug.Print "Child Nodes:"
    For intCount = 1 To intNodes
      If clsXMLRead.GetChildNode(intCount - 1, False, strNodeName, strValue) Then
        Debug.Print "Child Node : " & intCount & " <" & strNodeName & "> " & strValue
      End If
    Next intCount

    ' Get a particular node's value without going through the entire XML tree (does not reset the current node)
    Debug.Print
    Debug.Print "Specified Nodes:"
    Debug.Print "Node Latitude : " & clsXMLRead.GetNodeValue("//GeocodeResponse/result/geometry/location/lat", False, fFound)
    Debug.Print "Node Longitude: " & clsXMLRead.GetNodeValue("//GeocodeResponse/result/geometry/location/lng", False, fFound)

    ' Search for a particular node
    Debug.Print
    Debug.Print "Node Search : "
    strValue = clsXMLRead.GetNodeValue("//GeocodeResponse/result/address_component/long_name[. ='District of Columbia']", True, fFound)
    If fFound Then
      strNodeName = "long_name"
      Debug.Print "Node       : <" & strNodeName & "> " & strValue
      Debug.Print "Child Nodes: " & clsXMLRead.GetChildNodeCount
      Debug.Print "Siblings   : " & clsXMLRead.GetSiblingCount
    End If

    ' Get all the sibling nodes for the current level (does not include the sibling we just retrieved)
    Do While clsXMLRead.GetNextSiblingNode(True, strNodeName, strValue)
      Debug.Print "Sibling Node: <" & strNodeName & "> " & strValue
    Loop

    ' Get the remainder of the XML file
    Do
      strValue = clsXMLRead.GetNextNode(strNodeName)
      If (strNodeName <> "") Then
        intNodes = clsXMLRead.GetChildNodeCount
        If intNodes = 1 Then
          Debug.Print "Node       : <" & strNodeName & "> " & strValue
        Else
          Debug.Print
          Debug.Print "Node       : <" & strNodeName & "> Items: " & intNodes
        End If
      End If
    Loop Until (strNodeName = "")
  Else
    Debug.Print "Error : " & strError
    Debug.Print "Number: " & lngError
  End If
End Sub
```