VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BPStyleCollection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private m_BPStyleCollection As Collection

Private Sub Class_Initialize()
    Set m_BPStyleCollection = New Collection
End Sub

Public Property Get count() As Long
    count = m_BPStyleCollection.count
End Property

Public Sub Add(ByVal BPStyle As BPStyle)
    m_BPStyleCollection.Add BPStyle
End Sub

Public Sub Remove(ByVal BPStyle As BPStyle)
    m_BPStyleCollection.Remove BPStyle
End Sub

Public Property Get Item(ByVal index As Integer) As BPStyle
    Set Item = m_BPStyleCollection.Item(index)
End Property

Public Function Exists(ByVal BPStyleName As String) As Boolean
    If IndexOf(BPStyleName) > 0 Then
        Exists = True
    End If
End Function

Public Function IndexOf(ByVal BPStyleName As String) As Integer
    IndexOf = 0
    Dim i As Integer
    For i = 1 To m_BPStyleCollection.count
        If BPStyleName = m_BPStyleCollection.Item(i).Name Then
            IndexOf = i
        End If
    Next
End Function

Public Sub Serialize()

End Sub

Public Sub Deserialize()

End Sub
