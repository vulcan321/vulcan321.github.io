VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BPLink"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Public Enum BPLinkType
    URL = 1
    JUMP = 2
    BKMARK = 3
End Enum

Private m_LinkType As BPLinkType

Private m_SubAddress As String

Private m_Address() As String 'Definition of contents of array is dependant
'on the BPLinkType. Definitions thus far are:
' URL:      [URL],,
' JUMP:     [PAGENO],[X-COORD],[Y-COORD] NOT-IMP --> where 0,0 is COORD from bottom left cnr of page
' BKMARK:   [PAGENO],[X-COORD],[Y-COORD] NOT-IMP --> where 0,0 is COORD from bottom left cnr of page

Private m_Attributes() As String 'Extensible array of points defining the region for
'which this link will lay over. Generally it is a rectangle, but may include any number
'of points. Note, the first number is the Page Numer, for example:
'URL:       [PAGENO],[X-COORD],[Y-COORD],[X-COORD],[Y-COORD],[X-COORD],[Y-COORD],[X-COORD],[Y-COORD]...
'JUMP:      [PAGENO],[X-COORD],[Y-COORD],[X-COORD],[Y-COORD],[X-COORD],[Y-COORD],[X-COORD],[Y-COORD]...
'BKMARK:    [WEIGHT],[TEXT]

Public Property Let LinkType(ByVal LinkType As BPLinkType)
    m_LinkType = LinkType
End Property

Public Property Let SubAddress(ByVal SubAddress As String)
    m_SubAddress = SubAddress
End Property

Public Property Let text(ByVal text As String)
    m_Text = text
End Property

Public Property Let address(address() As String)
    m_Address = address
End Property

Public Property Let Attributes(Attributes() As String)
    m_Attributes = Attributes
End Property

Private Sub Class_Initialize()
    m_LinkType = 0
    m_Text = ""
    ReDim m_Address(0)
    ReDim m_Attributes(0)
End Sub

Public Property Get Serialized() As String
    Dim Output As String
    
    'Reset the size of Address array to ensure consistency in number of columns output
    ReDim Preserve m_Address(0 To 2)
    
    Output = "!INVALID"
    Select Case m_LinkType
        Case BPLinkType.BKMARK
            Output = "BKMARK"
        Case BPLinkType.JUMP
            Output = "JUMP"
        Case BPLinkType.URL
            Output = "URL"
    End Select
        
    For i = LBound(m_Address) To UBound(m_Address)
        'The Address may contain non-numeric characters. In that case, we will
        'place double quotes around such text
        
        If IsNumeric(m_Address(i)) Then
            Output = JoinWithComma(Output, m_Address(i))
        Else
            If Len(m_Address(i)) > 0 Then
                Output = JoinWithComma(Output, """" & m_Address(i) & """")
            Else
                Output = JoinWithComma(Output, m_Address(i))
            End If
        End If
    Next
            
    For i = LBound(m_Attributes) To UBound(m_Attributes)
        If IsNumeric(m_Attributes(i)) Then
            Output = JoinWithComma(Output, m_Attributes(i))
        Else
            If Len(m_Attributes(i)) > 0 Then
                Output = JoinWithComma(Output, """" & m_Attributes(i) & """")
            Else
                Output = JoinWithComma(Output, m_Attributes(i))
            End If
        End If
    Next
    
    Serialized = Output
End Property

Private Function JoinWithComma(ByVal TxtA As String, ByVal TxtB As String) As String
    JoinWithComma = TxtA & "," & TxtB
End Function

Public Property Get Serialized2() As String
    Dim Output As String
    
    'Reset the size of Address array to ensure consistency in number of columns output
    ReDim Preserve m_Address(0 To 2)
    
       
    Output = "!INVALID"
    Select Case m_LinkType
        Case BPLinkType.BKMARK
            Output = "BKMARK"
        Case BPLinkType.JUMP
            Output = "JUMP"
        Case BPLinkType.URL
            Output = "URL"
    End Select
    
    Output = JoinWithComma(Output, m_SubAddress)
    
    For i = LBound(m_Address) To UBound(m_Address)
        'The Address may contain non-numeric characters. In that case, we will
        'place double quotes around such text
        
        If IsNumeric(m_Address(i)) Then
            Output = JoinWithComma(Output, m_Address(i))
        Else
            If Len(m_Address(i)) > 0 Then
                Output = JoinWithComma(Output, """" & m_Address(i) & """")
            Else
                Output = JoinWithComma(Output, m_Address(i))
            End If
        End If
    Next
            
    For i = LBound(m_Attributes) To UBound(m_Attributes)
        If IsNumeric(m_Attributes(i)) Then
            Output = JoinWithComma(Output, m_Attributes(i))
        Else
            If Len(m_Attributes(i)) > 0 Then
                Output = JoinWithComma(Output, """" & m_Attributes(i) & """")
            Else
                Output = JoinWithComma(Output, m_Attributes(i))
            End If
        End If
    Next
         
    Serialized2 = Output
End Property


