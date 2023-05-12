VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmProgress 
   ClientHeight    =   1890
   ClientLeft      =   45
   ClientTop       =   360
   ClientWidth     =   4695
   OleObjectBlob   =   "frmProgress.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "frmProgress"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public Enum BPProgressType
    BPProgressIncrement = 1
    BPProgressDecrement = 2
    BPProgressStart = 3
    BPProgressEnd = 4
End Enum

Public strFormProgressPrinting As String
Public strFormProgressCleaningUp As String
Public strFormProgressThumbnailPageNumbers As String
Public strFormProgressExternalHyperlinks As String
Public strFormProgressCrossReferences As String
Public strFormProgressInternalLinks As String
Public strFormProgressFootnotes As String
Public strFormProgressEndnotes As String
Public strFormProgressBuildFileIdentifier As String
Public strFormProgressInitialized As Boolean
    

Private Sub btnCancel_Click()
    DoCancel
End Sub

Public Sub InitUI(ByVal formProgressCaption As String, ByVal formProgressPrinting As String, ByVal formProgressCleaningUp As String, ByVal formProgressCancel As String, _
        ByVal formProgressThumbnailPageNumbers As String, ByVal formProgressExternalHyperlinks As String, ByVal formProgressCrossReferences As String, ByVal formProgressInternalLinks As String, _
        ByVal formProgressFootnotes As String, ByVal formProgressEndnotes As String, ByVal formProgressBuildFileIdentifier As String, Optional ByVal fromAgenda As Boolean)
    Me.Caption = IIf(fromAgenda, formProgressCaption, formProgressCaption)
    Me.btnCancel.Caption = formProgressCancel
    Me.strFormProgressInitialized = True
End Sub

Public Sub SetProgress(ByVal ProgressType As BPProgressType, Optional ByVal Status As String = "")
    If Len(Status) > 0 Then
        Me.lblStatus.Caption = Status
    End If
    
    Select Case ProgressType
        Case BPProgressType.BPProgressIncrement: ProgressIncrement
        Case BPProgressType.BPProgressDecrement: ProgressDecrement
        Case BPProgressType.BPProgressStart: ProgressStart
        Case BPProgressType.BPProgressEnd: ProgressEnd
        Case Else
    End Select
    
    Me.Repaint
    
    Dim TheDate As Date
    TheDate = Timer
    Do
        DoEvents
    Loop Until (Timer - TheDate) > 0.02
End Sub

Private Sub ProgressIncrement()
    Dim ProgressValue As Integer
    ProgressValue = Me.lblProgressTop.Width
    If ProgressValue < (Me.lblProgressBack.Width - 6) Then
        Me.lblProgressTop.Width = ProgressValue + 1
    Else
        Me.lblProgressTop.Width = 1
    End If
End Sub

Private Sub ProgressDecrement()
    Dim ProgressValue As Integer
    ProgressValue = Me.lblProgressTop.Width
    If ProgressValue > 1 Then
        Me.lblProgressTop.Width = ProgressValue - 1
    Else
        Me.lblProgressTop.Width = Me.lblProgressBack.Width - 6
    End If
End Sub

Private Sub ProgressStart()
    Me.lblProgressTop.Width = 0
End Sub

Private Sub ProgressEnd()
    Me.lblProgressTop.Width = Me.lblProgressBack.Width - 6
End Sub

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
    Cancel = 1
    DoCancel
End Sub

Private Sub DoCancel()
    Me.btnCancel.Enabled = False
    g_Terminate = True
    Me.Hide
End Sub

