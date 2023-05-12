VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} frmSettings 
   ClientHeight    =   5175
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   4350
   OleObjectBlob   =   "frmSettings.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "frmSettings"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False


Private m_StyleWeights() As BPTextBox
Private m_SettingsFile As String
Private Const StyleControlHeight As Integer = 16
Private Const HLineControlHeight As Integer = 2
Private Const ControlGridSize As Integer = 6
Private m_LastStyleControlYPos As Integer
Private m_LastControlYPos As Integer

Private m_SettingsCollection As BPNameValuePairCollection
Private m_BPStyleCollection As BPStyleCollection
Private m_DialogResult As Boolean

Private strBookmarkSelectedStyles As String
Private strBookmarkOtherStyles As String
Private strBookmarkOtherStylesNotIn As String


Public Property Get DialogResult() As Boolean
    DialogResult = m_DialogResult
End Property

Public Property Get StyleCollection() As BPStyleCollection
    Set StyleCollection = m_BPStyleCollection
End Property

Public Property Let StyleCollection(StyleCollection As BPStyleCollection)
    Dim NewSection As Boolean
    Set m_BPStyleCollection = StyleCollection
    m_LastControlYPos = 6
    
    'Initialise the Style Controls
    'For the first section, we parse thru once to see if we need a title for
    'this section or not. There's probably a smarty way of doing this.
    NewSection = False
    For i = 1 To m_BPStyleCollection.count
        If m_BPStyleCollection.Item(i).Checked Then NewSection = True
    Next
    If NewSection Then
        InsertSectionTitleControl strBookmarkSelectedStyles
        InsertHorizontalLineControl
    End If
    For i = 1 To m_BPStyleCollection.count
        If m_BPStyleCollection.Item(i).Checked Then
            
            InsertStyleControl m_BPStyleCollection.Item(i), i
        End If
    Next
    
    'Styles used in this document
    NewSection = False
    For i = 1 To m_BPStyleCollection.count
        If Not m_BPStyleCollection.Item(i).Checked And _
            m_BPStyleCollection.Item(i).InUse Then
            NewSection = True
        End If
    Next
    If NewSection Then
        InsertSectionTitleControl strBookmarkOtherStyles
        InsertHorizontalLineControl
    End If
    For i = 1 To m_BPStyleCollection.count
        If Not m_BPStyleCollection.Item(i).Checked And _
            m_BPStyleCollection.Item(i).InUse Then
            InsertStyleControl m_BPStyleCollection.Item(i), i
        End If
    Next
    
    'All other styles
    NewSection = False
    For i = 1 To m_BPStyleCollection.count
        If Not m_BPStyleCollection.Item(i).Checked And _
            Not m_BPStyleCollection.Item(i).InUse Then
            NewSection = True
        End If
    Next
    If NewSection Then
        InsertSectionTitleControl strBookmarkOtherStylesNotIn
        InsertHorizontalLineControl
    End If
    For i = 1 To m_BPStyleCollection.count
        If Not m_BPStyleCollection.Item(i).Checked And _
            Not m_BPStyleCollection.Item(i).InUse Then
            InsertStyleControl m_BPStyleCollection.Item(i), i
        End If
    Next
End Property

Public Property Get SettingsCollections() As BPNameValuePairCollection
    Set SettingsCollections = m_SettingsCollection
End Property

Public Property Let SettingsCollections(SettingsCollection As BPNameValuePairCollection)
    Dim BPStyle As BPStyle
    Dim BPStyleCollection As BPStyleCollection
    Dim setting As BPNameValuePair
    Dim BSIndex As Integer
    Dim BSArray() As String
    
    Set m_SettingsCollection = SettingsCollection
    
    ' Get all the values from pdfDocs.ini and set them on the settings form.
    ' There should be a smarter way of doing this to minimise code, but this
    ' is sufficient, since we do not have many options yet.
    BSIndex = m_SettingsCollection.IndexOf("Bookmarks")
    If BSIndex > 0 Then
        If IsNumeric(m_SettingsCollection.Item(BSIndex).Value) And _
            m_SettingsCollection.Item(BSIndex).Value = 1 Then
        
            Me.chkbxBookmarks.Value = True
        End If
    End If
    
    BSIndex = m_SettingsCollection.IndexOf("ApplyThumbnailPageNumbering")
    If BSIndex > 0 Then
        If m_SettingsCollection.Item(BSIndex).Value = 1 Then
            Me.CheckBoxThumbnail.Value = True
        Else
            Me.CheckBoxThumbnail.Value = False
        End If
    End If
    
    BSIndex = m_SettingsCollection.IndexOf("printwordmarkup")
    If BSIndex > 0 Then
        If m_SettingsCollection.Item(BSIndex).Value = True Then
            Me.chkbxPrintWordMarkup.Value = True
        Else
            Me.chkbxPrintWordMarkup.Value = False
        End If
    End If
    
    BSIndex = m_SettingsCollection.IndexOf("BookmarksBasedOnTOC")
    If BSIndex > 0 Then
        If IsNumeric(m_SettingsCollection.Item(BSIndex).Value) And _
            m_SettingsCollection.Item(BSIndex).Value = 1 Then
        
            Me.chkbxBookmarkTOC.Value = True
        End If
    End If
    
    BSIndex = m_SettingsCollection.IndexOf("LinkURLs")
    If BSIndex > 0 Then
        If IsNumeric(m_SettingsCollection.Item(BSIndex).Value) And _
            m_SettingsCollection.Item(BSIndex).Value = 1 Then
        
            Me.chkbxHyperlinks.Value = True
        End If
    End If
    
    BSIndex = m_SettingsCollection.IndexOf("LinkRefs")
    If BSIndex > 0 Then
        If IsNumeric(m_SettingsCollection.Item(BSIndex).Value) And _
            m_SettingsCollection.Item(BSIndex).Value = 1 Then
        
            Me.chkbxReferences.Value = True
        End If
    End If
    
    BSIndex = m_SettingsCollection.IndexOf("BookmarkStyles")
    If BSIndex > 0 Then
        Set BPStyleCollection = New BPStyleCollection
        BSArray = Split(m_SettingsCollection.Item(BSIndex).Value, "\")
        For i = LBound(BSArray) To UBound(BSArray)
            Set BPStyle = New BPStyle
            With BPStyle
                .Checked = True
                .Weight = i + 1
                .Name = BSArray(i)
            End With
            
            BPStyleCollection.Add BPStyle
        Next
        
        Me.StyleCollection = BPStyleCollection
    End If
            
End Property

Public Sub InitUI(ByVal formSettingsCaption As String, ByVal tabSettingsCaption As String, ByVal checkBoxBookmarksCaption As String, ByVal checkBoxThumbnailCaption As String, _
        ByVal checkBoxPrintWordMarkupCaption As String, ByVal formLinksCaption As String, ByVal checkBoxHyperlinksCaption As String, ByVal checkBoxReferencesCaption As String, _
        ByVal labelReferencesCaption As String, ByVal chekBoxBookmarkTOCCaption As String, ByVal tabBookmarkStylesCaption As String, ByVal labelHelpCaption As String, _
        ByVal buttonOKCaption As String, ByVal buttonCancelCaption As String, ByVal bookmarkSelectedStyles As String, ByVal bookmarkOtherStyles As String, ByVal bookmarkOtherStylesNotIn As String)
    Me.Caption = g_AppSettings.ProductName & " - " & formSettingsCaption
    Me.MultiPage.Pages("tabSettings").Caption = tabSettingsCaption
    Me.chkbxBookmarks.Caption = checkBoxBookmarksCaption
    Me.CheckBoxThumbnail.Caption = checkBoxThumbnailCaption
    Me.chkbxPrintWordMarkup.Caption = checkBoxPrintWordMarkupCaption
    Me.frmLinks.Caption = formLinksCaption
    Me.chkbxHyperlinks.Caption = checkBoxHyperlinksCaption
    Me.chkbxReferences.Caption = checkBoxReferencesCaption
    Me.lblReferences.Caption = labelReferencesCaption
    Me.chkbxBookmarkTOC.Caption = chekBoxBookmarkTOCCaption
    Me.MultiPage.Pages("tabBookmarkStyles").Caption = tabBookmarkStylesCaption
    Me.LabelHelp.Caption = labelHelpCaption
    Me.btnOK.Caption = buttonOKCaption
    Me.btnCancel.Caption = buttonCancelCaption
    
    strBookmarkSelectedStyles = bookmarkSelectedStyles
    strBookmarkOtherStyles = bookmarkOtherStyles
    strBookmarkOtherStylesNotIn = bookmarkOtherStylesNotIn
End Sub

Private Sub btnCancel_Click()
    Me.Hide
End Sub

Private Sub btnOK_Click()
    Dim BPTextBox As BPTextBox
    Dim MaxLevel As Integer
    Dim BSIndex As Integer
    Dim setting As BPNameValuePair
    Dim bookmarkStyles() As String
    Dim StyleWeightCtl As MSForms.TextBox
    
    ' Get all the values from pdfDocs.ini and set them on the settings form.
    ' There should be a smarter way of doing this to minimise code, but this
    ' is sufficient, since we do not have many options yet.
    BSIndex = m_SettingsCollection.IndexOf("Bookmarks")
    If BSIndex <= 0 Then
        Set setting = New BPNameValuePair
        setting.Name = "Bookmarks"
        m_SettingsCollection.Add setting
        BSIndex = m_SettingsCollection.IndexOf("Bookmarks")
    End If
    m_SettingsCollection.Item(BSIndex).Value = "1"
    'If Me.chkbxBookmarks.Value Then
    '    m_SettingsCollection.Item(BSIndex).Value = "1"
    'Else
    '    m_SettingsCollection.Item(BSIndex).Value = "0"
    'End If
    
    BSIndex = m_SettingsCollection.IndexOf("ApplyThumbnailPageNumbering")
    If BSIndex > 0 Then
        If Me.CheckBoxThumbnail.Value Then
            m_SettingsCollection.Item(BSIndex).Value = "1"
        Else
            m_SettingsCollection.Item(BSIndex).Value = "0"
        End If
    End If
    
    BSIndex = m_SettingsCollection.IndexOf("printwordmarkup")
    If BSIndex > 0 Then
        m_SettingsCollection.Item(BSIndex).Value = Me.chkbxPrintWordMarkup.Value
    End If
    
    BSIndex = m_SettingsCollection.IndexOf("BookmarksBasedOnTOC")
    If BSIndex <= 0 Then
        Set setting = New BPNameValuePair
        setting.Name = "BookmarksBasedOnTOC"
        m_SettingsCollection.Add setting
        BSIndex = m_SettingsCollection.IndexOf("BookmarksBasedOnTOC")
    End If
    If Me.chkbxBookmarkTOC.Value Then
        m_SettingsCollection.Item(BSIndex).Value = "1"
    Else
        m_SettingsCollection.Item(BSIndex).Value = "0"
    End If
    
    BSIndex = m_SettingsCollection.IndexOf("LinkURLs")
    If BSIndex <= 0 Then
        Set setting = New BPNameValuePair
        setting.Name = "LinkURLs"
        m_SettingsCollection.Add setting
        BSIndex = m_SettingsCollection.IndexOf("LinkURLs")
    End If
    If Me.chkbxHyperlinks.Value Then
        m_SettingsCollection.Item(BSIndex).Value = "1"
    Else
        m_SettingsCollection.Item(BSIndex).Value = "0"
    End If
    
    BSIndex = m_SettingsCollection.IndexOf("LinkRefs")
    If BSIndex <= 0 Then
        Set setting = New BPNameValuePair
        setting.Name = "LinkRefs"
        m_SettingsCollection.Add setting
        BSIndex = m_SettingsCollection.IndexOf("LinkRefs")
    End If
    If Me.chkbxReferences.Value Then
        m_SettingsCollection.Item(BSIndex).Value = "1"
    Else
        m_SettingsCollection.Item(BSIndex).Value = "0"
    End If
    
    'Gather Bookmark Styles
    BSIndex = m_SettingsCollection.IndexOf("BookmarkStyles")
    If BSIndex <= 0 Then
        Set setting = New BPNameValuePair
        setting.Name = "BookmarkStyles"
        m_SettingsCollection.Add setting
        BSIndex = m_SettingsCollection.IndexOf("BookmarkStyles")
    End If

    ReDim bookmarkStyles(1 To m_BPStyleCollection.count)
    For i = 1 To m_BPStyleCollection.count
        Set BPTextBox = m_StyleWeights(i)
        If IsNumeric(BPTextBox.TextBox.text) Then
        
            bookmarkStyles(BPTextBox.TextBox.text) = m_BPStyleCollection.Item(i).Name
        End If
    Next
    
    m_SettingsCollection.Item(BSIndex).Value = ""
    For i = LBound(bookmarkStyles) To UBound(bookmarkStyles) - 1
        If Len(bookmarkStyles(i)) > 0 Then
            If Len(m_SettingsCollection.Item(BSIndex).Value) <= 0 Then
                m_SettingsCollection.Item(BSIndex).Value = bookmarkStyles(i)
            Else
                m_SettingsCollection.Item(BSIndex).Value = _
                    m_SettingsCollection.Item(BSIndex).Value & "\" & bookmarkStyles(i)
            End If
        End If
    Next
    
    Me.FrameStyles.Controls.Clear
    m_DialogResult = True
    Me.Hide
End Sub

Private Sub InsertStyleControl(ByRef BPStyle As BPStyle, ByVal index As Integer)
    Dim StyleWeightCtl As MSForms.TextBox
    Dim StyleNameCtl As MSForms.TextBox
    Dim Font As NewFont
    
    ReDim Preserve m_StyleWeights(1 To m_BPStyleCollection.count)
    
    Set NewFont = New NewFont
    With NewFont
        .Size = 10
        .Weight = 900
    End With
        
    Set StyleWeightCtl = Me.FrameStyles.Controls.Add("Forms.TextBox.1", "StyleWeightCtl" & index, True)
    Set StyleNameCtl = Me.FrameStyles.Controls.Add("Forms.TextBox.1", "StyleNameCtl" & index, True)
    
    'Define Properties of Controls here
    With StyleWeightCtl
        .Top = m_LastControlYPos
        .Left = 6
        .Height = StyleControlHeight
        .Width = 24
        .SpecialEffect = fmSpecialEffectBump
        .Font = NewFont
        If BPStyle.Weight > 0 Then
            .text = BPStyle.Weight
        End If
    End With
    Set m_StyleWeights(index) = New BPTextBox
    m_StyleWeights(index).SetTextBoxItem StyleWeightCtl
5
    With StyleNameCtl
        .Top = m_LastControlYPos
        .Left = 36
        .Height = StyleControlHeight
        .Width = 126
        .Locked = True
        .BackColor = &H80000010
        .AutoTab = False
        .TabKeyBehavior = False
        .TabStop = False
        .SpecialEffect = fmSpecialEffectBump
        .Font = NewFont
        .text = BPStyle.Name
    End With
    
    m_LastControlYPos = m_LastControlYPos + StyleControlHeight + ControlGridSize
    Me.FrameStyles.ScrollHeight = m_LastControlYPos
End Sub

Private Sub InsertHorizontalLineControl()
    Dim LabelCtl As MSForms.Label
    Dim LabelCtlNo As Integer
    Dim tmpCtl As MSForms.Control
    Dim i As Integer
    
    'Get the last LabelCtl
    For i = 0 To Me.FrameStyles.Controls.count - 1
        Set tmpCtl = Me.FrameStyles.Controls(i)
        If Left(tmpCtl.Name, 8) = "LabelCtl" Then
           LabelCtlNo = LabelCtlNo + 1
        End If
    Next
    
    Set LabelCtl = Me.FrameStyles.Controls.Add("Forms.Label.1", "LabelCtl" & LabelCtlNo, True)
    With LabelCtl
        .Top = m_LastControlYPos
        .Left = 6
        .Height = HLineControlHeight
        .Width = 158
        .BorderStyle = fmBorderStyleSingle
        .BackColor = WdColor.wdColorBlack
    End With
    
    m_LastControlYPos = m_LastControlYPos + HLineControlHeight + ControlGridSize
    Me.FrameStyles.ScrollHeight = m_LastControlYPos
End Sub
Private Sub InsertSectionTitleControl(ByVal SectionTitle As String)
    Dim LabelCtl As MSForms.Label
    Dim LabelCtlNo As Integer
    Dim tmpCtl As MSForms.Control
    Dim i As Integer
    
    'Get the last LabelCtl
    For i = 0 To Me.FrameStyles.Controls.count - 1
        Set tmpCtl = Me.FrameStyles.Controls(i)
        If Left(tmpCtl.Name, 8) = "LabelCtl" Then
           LabelCtlNo = LabelCtlNo + 1
        End If
    Next
    
    Set LabelCtl = Me.FrameStyles.Controls.Add("Forms.Label.1", "LabelCtl" & LabelCtlNo, True)
    With LabelCtl
        .Top = m_LastControlYPos
        .Left = 6
        .Height = 12
        .Width = 158
        .BorderStyle = fmBorderStyleNone
        .Caption = SectionTitle
    End With
    
    m_LastControlYPos = m_LastControlYPos + 8 + ControlGridSize
    Me.FrameStyles.ScrollHeight = m_LastControlYPos
End Sub

Private Sub chkbxBookmarks_Change()
    
    Select Case Me.chkbxBookmarks.Value
        Case True
            Me.chkbxBookmarkTOC.Enabled = True
            
        Case Else
            Me.chkbxBookmarkTOC.Enabled = False
            
    End Select
End Sub

Private Sub UserForm_Initialize()
    Set m_BPStyleCollection = New BPStyleCollection
    Set m_SettingsCollection = New BPNameValuePairCollection
    
    m_DialogResult = False
End Sub

Private Sub UserForm_QueryClose(Cancel As Integer, CloseMode As Integer)
    m_DialogResult = False
End Sub
