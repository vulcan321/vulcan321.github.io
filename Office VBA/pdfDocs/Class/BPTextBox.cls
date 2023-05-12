VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BPTextBox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private WithEvents m_TextBox As MSForms.TextBox
Attribute m_TextBox.VB_VarHelpID = -1

Public Property Get TextBox() As MSForms.TextBox
    Set TextBox = m_TextBox
End Property

Public Sub SetTextBoxItem(TextBox As MSForms.TextBox)
    Set m_TextBox = TextBox
End Sub

Private Sub m_TextBox_Click()
    MsgBox m_TextBox.text
End Sub
