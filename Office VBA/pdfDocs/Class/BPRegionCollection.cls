VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BPRegionCollection"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private m_BPRegionCollection As Collection

Private Sub Class_Initialize()
    Set m_BPRegionCollection = New Collection
End Sub

Public Property Get count() As Long
    count = m_BPRegionCollection.count
End Property

Public Sub Add(ByVal BPRegion As BPRegion)
    m_BPRegionCollection.Add BPRegion
End Sub

Public Sub Remove(ByVal BPRegion As BPRegion)
    m_BPRegionCollection.Remove BPRegion
End Sub

Public Property Get Item(ByVal index As Integer) As BPRegion
    Set Item = m_BPRegionCollection.Item(index)
End Property


