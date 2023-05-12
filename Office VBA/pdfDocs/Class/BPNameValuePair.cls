VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BPNameValuePair"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private m_Name As String
Private m_Value As String

Public Property Get Name() As String
    Name = m_Name
End Property

Public Property Let Name(Name As String)
    m_Name = Name
End Property

Public Property Get Value() As String
    Value = m_Value
End Property

Public Property Let Value(Value As String)
    m_Value = Value
End Property

Private Sub Class_Initialize()
    m_Name = ""
    m_Value = ""
End Sub
