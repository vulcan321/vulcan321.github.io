VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "BPAppSettings"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private m_IniFile As BPIniFile
Private m_ProductName As String
Private m_EnableEmail As Boolean
Private m_EnableOrganiser As Boolean
Private m_EnableSaveAs As Boolean
Private m_EnableSaveInto As Boolean
Private m_PrintWordMarkup As Boolean

Public Enum ButtonName
    EmailButton
    OrganiserButton
    SaveAsButton
    SaveIntoButton
End Enum

Public Property Get ProductName() As String
    If Len(m_ProductName) <= 0 Then GetAppSettings
    ProductName = m_ProductName
End Property

Public Property Get IsAdvanceDocs() As Boolean
    IsAdvanceDocs = False
    If BPWordExport.g_AppSettings.ProductName = "AdvanceDocs" Then
        IsAdvanceDocs = True
    End If
End Property

Public Property Get PrintWordmarkup() As Boolean
    If Len(m_PrintWordMarkup) <= 0 Then GetAppSettings
    PrintWordmarkup = m_PrintWordMarkup
End Property


Private Sub Class_Initialize()
    Set m_IniFile = New BPIniFile
    m_IniFile.fileName = BPEnvironment.GetSettingsFile
    GetAppSettings
End Sub

Public Function EnableButton(button As ButtonName) As Boolean
    EnableButton = True
    
    Select Case button
        Case ButtonName.EmailButton
            EnableButton = m_EnableEmail
        Case ButtonName.OrganiserButton
            EnableButton = m_EnableOrganiser
        Case ButtonName.SaveAsButton
            EnableButton = m_EnableSaveAs
        Case ButtonName.SaveIntoButton
            EnableButton = m_EnableSaveInto
    End Select
    
End Function

Private Sub GetAppSettings()
    'Initialize all the AppSettings -> ProductName
    Dim LN As String
    Dim LNArray() As String
    Dim PC As String
    m_ProductName = "pdfDocs"
    LN = m_IniFile.GetKeyFromSection("licencenumber", "License")
    LNArray = Split(LN, "-")
    If UBound(LNArray) >= 5 Then
        If IsNumeric(LNArray(5)) Then
            PC = Mid(LNArray(5), 1, 3)
            Select Case PC
                Case 102: 'AdvanceDocs - ANZ
                    m_ProductName = "AdvanceDocs"
                Case 104: 'AdvanceDocs - OEM
                    m_ProductName = "AdvanceDocs"
                Case 105: 'AdvanceDocs - UK
                    m_ProductName = "AdvanceDocs"
                Case Else:
                    m_ProductName = "pdfDocs"
            End Select
        End If
    End If
    
    LN = ""
    LN = m_IniFile.GetKeyFromSection("EnableEmailButton", "Microsoft Office Settings")
    m_EnableEmail = CheckTrueFalse(LN)
    LN = ""
    LN = m_IniFile.GetKeyFromSection("EnableOrganiserButton", "Microsoft Office Settings")
    m_EnableOrganiser = CheckTrueFalse(LN)
    LN = ""
    LN = m_IniFile.GetKeyFromSection("EnableSaveAsButton", "Microsoft Office Settings")
    m_EnableSaveAs = CheckTrueFalse(LN)
    LN = ""
    LN = m_IniFile.GetKeyFromSection("EnableSaveIntoButton", "Microsoft Office Settings")
    m_EnableSaveInto = CheckTrueFalse(LN)
    
    LN = ""
    LN = m_IniFile.GetKeyFromSection("printwordmarkup", "Microsoft Office Settings")
    m_PrintWordMarkup = CheckTrueFalse(LN)
    
End Sub

Private Function CheckTrueFalse(trueFalse As String) As Boolean
    Dim retrunValue As Boolean
    If trueFalse = "False" Then
        CheckTrueFalse = False
    ElseIf trueFalse = "" Then
        CheckTrueFalse = True
    Else
        CheckTrueFalse = True
    End If
End Function
