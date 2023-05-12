VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BPRegion"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False

Private m_Points() As Integer

Public Sub GetPoints(ByRef Points() As Integer)
    Points = m_Points
End Sub

Public Property Let Points(Points() As Integer)
    m_Points = Points
End Property
