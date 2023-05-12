VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BPSettings"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' The Business Prophet Settings Class handles the serialization
' and deserialization of settings for Word Export functionality.
' It uses NameValue Pairs because the settings file is in the
' the format of an INI file, key = value.

Private m_SettingsFile As String
Private m_UniqueTempDirectory As String
Private m_SettingsCollection As BPNameValuePairCollection
Private m_BPLinkCollection As BPLinkCollection
Private m_bookmarksEnabled As Boolean

Public Property Get File() As String
    File = m_SettingsFile
End Property

Public Property Let File(File As String)
    m_SettingsFile = File
End Property

Public Property Get settings() As BPNameValuePairCollection
    Set settings = m_SettingsCollection
End Property

Public Property Let settings(settings As BPNameValuePairCollection)
    Set m_SettingsCollection = settings
End Property

Public Property Get IsBookmarkConfigured() As Boolean
    Dim isBookmarkConfigured_ As Boolean
    isBookmarkConfigured_ = False
        
    For i = 1 To m_SettingsCollection.count
        If m_SettingsCollection.Item(i).Name = "BookmarkStyles" And Trim(m_SettingsCollection.Item(i).Value) <> "" Then
            isBookmarkConfigured_ = True
        End If
    Next
    IsBookmarkConfigured = isBookmarkConfigured_
End Property

Public Property Get IsBookmarksEnabled() As Boolean
    IsBookmarksEnabled = m_bookmarksEnabled
End Property
Public Property Let IsBookmarksEnabled(bookmarksEnabled As Boolean)
    m_bookmarksEnabled = bookmarksEnabled
End Property
Public Property Get UniqueTempDirectory() As String
    UniqueTempDirectory = m_UniqueTempDirectory
End Property

Public Property Let UniqueTempDirectory(uniqueTempDir As String)
    m_UniqueTempDirectory = uniqueTempDir
End Property


Public Sub SerializeToFile()
    Dim xmlPath As String
    Dim xmlDoc As MSXML2.DOMDocument
    Dim bookmarkSettingsElement As MSXML2.IXMLDOMElement
    Dim attributeEnforced As MSXML2.IXMLDOMAttribute
    Dim attributeVersion As MSXML2.IXMLDOMAttribute
    Dim mainNode As MSXML2.IXMLDOMElement
    Dim bookmarkStyleValues() As String
    
    
    Set xmlDoc = New MSXML2.DOMDocument
    xmlPath = GetWordExportSettingsFile
    isBookmarkNodeExisting = False
    
    If Not FileOrDirExists(xmlPath) Then
        ' Create the xml file if it's not existing yet
        xmlDoc.Save (xmlPath)
    End If
    
    Set mainNode = xmlDoc.createElement("WordExportSettings")
    Set bookmarkSettingsElement = xmlDoc.createElement("WordBookmarkStyles")
    
    For i = 1 To m_SettingsCollection.count
        If m_SettingsCollection.Item(i).Name = "BookmarkStyles" Then
            bookmarkStyleValues = Split(m_SettingsCollection.Item(i).Value, "\")
        End If
    Next
    
    Dim tempXMLElement As MSXML2.IXMLDOMElement
    
    For i = 0 To UBound(bookmarkStyleValues)
        Set tempXMLElement = xmlDoc.createElement("BookmarkStyle")
        tempXMLElement.text = bookmarkStyleValues(i)
        bookmarkSettingsElement.appendChild tempXMLElement
    Next
    
    Set tempXMLElement = xmlDoc.createElement("Enabled")
    If m_bookmarksEnabled Then
        tempXMLElement.text = "True"
    Else
        tempXMLElement.text = "False"
    End If
    
    bookmarkSettingsElement.appendChild tempXMLElement
    
    'enforced and version attribute
    'Set attributeEnforced = xmlDoc.createAttribute("enforced")
    'attributeEnforced.NodeValue = "false"
    
    'Set attributeEnforced = xmlDoc.createAttribute("version")
    'attributeVersion.NodeValue = "0"
    
    'bookmarkSettingsElement.setAttributeNode attributeEnforced
    bookmarkSettingsElement.setAttribute "enforced", "false"
    bookmarkSettingsElement.setAttribute "version", "0"
    mainNode.appendChild bookmarkSettingsElement
    
    'Settings WordLinks - BEGIN
    Set linksSettingsElement = xmlDoc.createElement("WordLinks")
    Dim BSIndex As Integer
    BSIndex = m_SettingsCollection.IndexOf("LinkURLs")
    If BSIndex > 0 Then
        If m_SettingsCollection.Item(BSIndex).Value = 1 Then
            Set tempXMLElement = xmlDoc.createElement("Link")
            tempXMLElement.text = "LinkURLs"
            linksSettingsElement.appendChild tempXMLElement
        End If
    End If
    
    BSIndex = m_SettingsCollection.IndexOf("LinkRefs")
    If BSIndex > 0 And m_SettingsCollection.Item(BSIndex).Value = 1 Then
        Set tempXMLElement = xmlDoc.createElement("Link")
        tempXMLElement.text = "LinkRefs"
        linksSettingsElement.appendChild tempXMLElement
    End If

    linksSettingsElement.setAttribute "enforced", "false"
    linksSettingsElement.setAttribute "version", "0"
    mainNode.appendChild linksSettingsElement
    'Settings WordLinks - END
    
    xmlDoc.appendChild mainNode
    ' Save and Close XML document
    xmlDoc.Save (xmlPath)
    Set xmlDoc = Nothing
                    
    'End If
End Sub


'Public Sub SerializeToFile()
'    Dim IniFile As BPIniFile
'
'    Set IniFile = New BPIniFile
'
'    With IniFile
'        .fileName = BPEnvironment.GetSettingsFile
'        .Section = "Microsoft Word Export"
'    End With
'
'    If Not IniFile.CheckIniFile Then
'        IniFile.CreateIniFile (IniFile.fileName)
'    End If
'
'    If Not IniFile.CheckSection Then
'        IniFile.CreateSection
'    End If
'
'    For i = 1 To m_SettingsCollection.count
'        IniFile.SaveKey m_SettingsCollection.Item(i).Value, m_SettingsCollection.Item(i).Name
'    Next
'
'End Sub

'Public Sub DeserializeFromFile()
'    Dim IniFile As BPIniFile
'    Dim KeyCollection As Collection
'    Dim NVPair As BPNameValuePair
'    Dim KeyItem(1) As String
'
'    Set IniFile = New BPIniFile
'    Set m_SettingsCollection = New BPNameValuePairCollection
'
'    With IniFile
'        .fileName = BPEnvironment.GetSettingsFile
'        .Section = "Microsoft Word Export"
'    End With
'
'    If IniFile.CheckIniFile And _
'        IniFile.CheckSection Then
'        Set KeyCollection = IniFile.GetAllKeysFromSection
'
'        Dim Item As Variant
'        For i = 1 To KeyCollection.count
'            For j = LBound(KeyCollection.Item(i)) To UBound(KeyCollection.Item(i))
'                KeyItem(j) = KeyCollection.Item(i)(j)
'            Next
'
'            Set NVPair = New BPNameValuePair
'            NVPair.Name = KeyItem(0)
'            NVPair.Value = KeyItem(1)
'            m_SettingsCollection.Add NVPair
'        Next
'    End If
'End Sub

Public Sub DeserializeFromFile()
    Dim KeyCollection As Collection
    Dim NVPair As BPNameValuePair
    Dim KeyItem(1) As String

    Set m_SettingsCollection = New BPNameValuePairCollection

    Dim xmlPath As String
    Dim xmlDoc As MSXML2.DOMDocument
    Dim bookmarkSettingsElement As MSXML2.IXMLDOMElement
    Dim mainNode As MSXML2.IXMLDOMElement

    Set xmlDoc = New MSXML2.DOMDocument
    xmlPath = GetWordExportSettingsFile
    
    If Not FileOrDirExists(xmlPath) Then
        Exit Sub
    End If
    
    If xmlDoc.Load(xmlPath) Then
        Set NVPair = New BPNameValuePair
        NVPair.Name = "Bookmarks"
        NVPair.Value = "1"
        m_SettingsCollection.Add NVPair

        Dim settingsNode As MSXML2.IXMLDOMNode
        For Each settingsNode In xmlDoc.ChildNodes(0).ChildNodes
            ' lower case
            If LCase(settingsNode.nodeName) = "wordbookmarkstyles" Then
                Dim bookmarkStyles As MSXML2.IXMLDOMNode
                If settingsNode.HasChildNodes Then
                    Dim ctr As Integer
                    Dim bookmarkStylesValue As String
                    bookmarkStylesValue = ""
                    ctr = 1
                    For Each bookmarkStyles In settingsNode.ChildNodes
                        If LCase(bookmarkStyles.nodeName) = "bookmarkstyle" Then
                            
                            bookmarkStylesValue = bookmarkStylesValue & bookmarkStyles.text
                            bookmarkStylesValue = bookmarkStylesValue & "\"
                            
                        ElseIf LCase(bookmarkStyles.nodeName) = "enabled" Then
                            
                            If LCase(bookmarkStyles.text) = "true" Then
                                m_bookmarksEnabled = True
                            Else
                                m_bookmarksEnabled = False
                            End If
                            
                        End If
                        ctr = ctr + 1
                    Next
                    ' remove the trailing '\'
                    bookmarkValuesLength = Len(bookmarkStylesValue)
                    If (bookmarkValuesLength > 0) Then
                        If Mid(bookmarkStylesValue, bookmarkValuesLength, 1) = "\" Then
                        bookmarkStylesValue = Mid(bookmarkStylesValue, 1, bookmarkValuesLength - 1)
                        End If
                    End If
                    
                End If

                Set NVPair = New BPNameValuePair
                NVPair.Name = "BookmarkStyles"
                NVPair.Value = bookmarkStylesValue
                m_SettingsCollection.Add NVPair
                
                ' this exit for will be removed if this will be used as generic method to get the settings from PD settings file
                'Exit For
            ElseIf LCase(settingsNode.nodeName) = "wordlinks" Then
                Dim wordLinkNode As MSXML2.IXMLDOMNode
                For Each wordLinkNode In settingsNode.ChildNodes
                    If wordLinkNode.nodeTypedValue = "LinkURLs" Then
                        Set NVPair = New BPNameValuePair
                        NVPair.Name = "LinkURLs"
                        NVPair.Value = 1
                        m_SettingsCollection.Add NVPair
                    ElseIf wordLinkNode.nodeTypedValue = "LinkRefs" Then
                        Set NVPair = New BPNameValuePair
                        NVPair.Name = "LinkRefs"
                        NVPair.Value = 1
                        m_SettingsCollection.Add NVPair
                    End If
                Next
            End If
        Next

    Else
        ' failed to load the document
    End If

    Set xmlDoc = Nothing
End Sub



