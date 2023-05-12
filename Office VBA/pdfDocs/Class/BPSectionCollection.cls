VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BPSectionCollection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private m_BPSectionCollection As Collection

Private Sub Class_Initialize()
    Set m_BPSectionCollection = New Collection
End Sub

Public Property Get count() As Long
    count = m_BPSectionCollection.count
End Property

Public Sub Add(ByVal BPSection As BPSection)
    m_BPSectionCollection.Add BPSection
End Sub

Public Sub Remove(ByVal BPSection As BPSection)
    m_BPSectionCollection.Remove BPSection
End Sub

Public Property Get Item(ByVal index As Integer) As BPSection
    Set Item = m_BPSectionCollection.Item(index)
End Property


Public Property Get Serialized() As String
    Dim Output As String
    Dim i As Integer
    
    For i = 1 To m_BPSectionCollection.count
      
       If i = 1 Then
          Output = m_BPSectionCollection.Item(i).ToString
       Else
          Output = Output & ";" & m_BPSectionCollection.Item(i).ToString
       End If
       
    Next
    Serialized = Output
End Property
