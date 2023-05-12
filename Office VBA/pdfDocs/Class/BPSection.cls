VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BPSection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private m_Type As Integer
Private m_PhysicalPage As Integer
Private m_StartingPageNum As Integer


Public Property Let SectionType(SectionType As Integer)
    m_Type = SectionType
End Property

Public Property Let PhysicalPage(PhysicalPage As Integer)
    m_PhysicalPage = PhysicalPage
End Property

Public Property Let StartingPageNum(StartingPageNum As Integer)
    m_StartingPageNum = StartingPageNum
End Property

Public Property Get StartingPageNum() As Integer
    StartingPageNum = m_StartingPageNum
End Property

Private Sub Class_Initialize()
   m_Type = WdCaptionNumberStyle.wdCaptionNumberStyleArabic
   m_StartingPageNum = 1
End Sub

Public Property Get ToString() As String
    Dim Output As String
    
    Output = m_PhysicalPage & "," & m_Type & "," & m_StartingPageNum
     
    ToString = Output

End Property
