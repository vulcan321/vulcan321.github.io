VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BPStyle"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private m_Name As String

Private m_InUse As Boolean

Private m_Checked As Boolean

Private m_Weight As Integer

Public Property Let Name(ByVal Name As String)
    m_Name = Name
End Property

Public Property Get Name() As String
    Name = m_Name
End Property

Public Property Let InUse(ByVal InUse As Boolean)
    m_InUse = InUse
End Property

Public Property Get InUse() As Boolean
    InUse = m_InUse
End Property

Public Property Let Checked(ByVal Checked As Boolean)
    m_Checked = Checked
End Property

Public Property Get Checked() As Boolean
    Checked = m_Checked
End Property

Public Property Let Weight(Weight As Integer)
    m_Weight = Weight
End Property

Public Property Get Weight() As Integer
    Weight = m_Weight
End Property

Private Sub Class_Initialize()
    m_Name = ""
    m_InUse = False
    m_Checked = False
    m_Weight = -1
End Sub


