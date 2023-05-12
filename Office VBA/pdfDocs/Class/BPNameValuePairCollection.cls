VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BPNameValuePairCollection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private m_NameValuePairCollection As Collection

Private Sub Class_Initialize()
    Set m_NameValuePairCollection = New Collection
End Sub

Public Property Get count() As Long
    count = m_NameValuePairCollection.count
End Property

Public Sub Add(ByVal BPNameValuePair As BPNameValuePair)
    m_NameValuePairCollection.Add BPNameValuePair
End Sub

Public Sub Remove(ByVal BPNameValuePair As BPNameValuePair)
    m_NameValuePairCollection.Remove BPNameValuePair
End Sub

Public Property Get Item(ByVal index As Integer) As BPNameValuePair
    Set Item = m_NameValuePairCollection.Item(index)
End Property

Public Function Exists(ByVal Name As String) As Boolean
    If IndexOf(Name) > 0 Then
        Exists = True
    End If
End Function

Public Function IndexOf(ByVal Name As String) As Integer
    IndexOf = 0
    Dim i As Integer
    For i = 1 To m_NameValuePairCollection.count
        If Name = m_NameValuePairCollection.Item(i).Name Then
            IndexOf = i
        End If
    Next
End Function

