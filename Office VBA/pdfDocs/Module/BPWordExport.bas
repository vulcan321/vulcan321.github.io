Attribute VB_Name = "BPWordExport"
Public g_AppSettings As BPAppSettings 'Our Application Settings, 1 instance only
Public g_Terminate As Boolean 'Allows the termination of the macro
Public g_ProgressForm As frmProgress 'Progress window, duh

Private Const EXT_BOOKMARKS As String = ".BPBKM"
Private Const EXT_LINKS As String = ".BPLNK"
Private Const EXT_POSTSCRIPT As String = ".PS"
Private Const EXT_PDF As String = ".PDF"
Private Const EXT_IDENTIFIER As String = ".PDFDOCS"

Private Const OUTPUTACTION_OPEN As String = "OPEN"
Private Const OUTPUTACTION_IMPORT As String = "IMPORT"
Private Const OUTPUTACTION_EMAIL As String = "EMAIL"
Private Const OUTPUTACTION_SAVEINTODMS As String = "SAVEINTODMS"
Private Const OUTPUTACTION_SAVEAS As String = "SAVEAS"

Private Const SAVEASPDF_PRINTSETTING As String = "SaveAsPDF"
Private Const SAVEASPDF_VIEWINPDFDOCS As String = "OfficeSaveAsViewPDF"

Private strFormProgressConvertingDocument As String
Private strFormProgressOpeningPdfDocs As String
Private strFormProgressCaption As String
Private strFormProgressCancel As String
Public strFormProgressPrinting As String
Public strFormProgressCleaningUp As String
Public strFormProgressThumbnailPageNumbers As String
Public strFormProgressExternalHyperlinks As String
Public strFormProgressCrossReferences As String
Public strFormProgressInternalLinks As String
Public strFormProgressFootnotes As String
Public strFormProgressEndnotes As String
Public strFormProgressBuildFileIdentifier As String

Private strNoDocuments1 As String
Private strNoDocuments2 As String
Private strNoDocuments3 As String
Public strErrorMessage As String
Public strErrorIn As String
Private strExportErrorMessage1 As String
Private strExportErrorMessage2 As String

Private strFormSettingsCaption As String
Private strTabSettingsCaption As String
Private strCheckBoxBookmarksCaption As String
Private strCheckBoxThumbnailCaption As String
Private strCheckBoxPrintWordMarkupCaption As String
Private strFormLinksCaption As String
Private strCheckBoxHyperlinksCaption As String
Private strCheckBoxReferencesCaption As String
Private strLabelReferencesCaption As String
Private strChekBoxBookmarkTOCCaption As String
Private strTabBookmarkStylesCaption As String
Private strLabelHelpCaption As String
Private strButtonOKCaption As String
Private strButtonCancelCaption As String
Private strBookmarkSelectedStyles As String
Private strBookmarkOtherStyles As String
Private strBookmarkOtherStylesNotIn As String

Private settings As BPSettings

Private Const FORMSHOWCONSTANT_MODELESS As Integer = 0
Private Const FORMSHOWCONSTANT_MODAL As Integer = 1

Dim GenerateBookmarks As Boolean
Dim GenerateLinks As Boolean

Dim tempDocument As Document ' Required when a document is marked as Final.
Dim bUseTempDocument As Boolean ' Required when a document is marked as Final.

'Create Agenda Resources
Private strCreateAgendaProgressTitle As String
Private strCreateAgendaProgressCreateLinks As String
Private strCreateAgendaProgressInitialize As String
Private strCreateAgendaProgressFinalize As String
Private strCreateAgendaMsgSuccess As String
Private strCreateAgendaMsgFailed As String
Private strCreateAgendaMsgTemplateNotSaved As String

Private extractedLinksCollection() As String
Private iSize As Integer

Public Sub InitResources(ByVal formProgressCaption As String, ByVal formProgressPrinting As String, ByVal formProgressCleaningUp As String, ByVal formProgressCancel As String, _
        ByVal formProgressThumbnailPageNumbers As String, ByVal formProgressExternalHyperlinks As String, ByVal formProgressCrossReferences As String, ByVal formProgressInternalLinks As String, _
        ByVal formProgressFootnotes As String, ByVal formProgressEndnotes As String, ByVal formProgressBuildFileIdentifier As String, _
        ByVal noDocuments1 As String, ByVal noDocuments2 As String, ByVal noDocuments3 As String, ByVal errorMessage As String, ByVal errorIn As String, _
        ByVal exportErrorMessage1 As String, ByVal exportErrorMessage2 As String, ByVal formProgressConvertingDocument As String, ByVal formProgressOpeningPdfDocs As String)
    strFormProgressCaption = formProgressCaption
    strFormProgressPrinting = formProgressPrinting
    strFormProgressCleaningUp = formProgressCleaningUp
    strFormProgressCancel = formProgressCancel
    strFormProgressThumbnailPageNumbers = formProgressThumbnailPageNumbers
    strFormProgressExternalHyperlinks = formProgressExternalHyperlinks
    strFormProgressCrossReferences = formProgressCrossReferences
    strFormProgressInternalLinks = formProgressInternalLinks
    strFormProgressFootnotes = formProgressFootnotes
    strFormProgressEndnotes = formProgressEndnotes
    strFormProgressBuildFileIdentifier = formProgressBuildFileIdentifier
    strNoDocuments1 = noDocuments1
    strNoDocuments2 = noDocuments2
    strNoDocuments3 = noDocuments3
    strErrorMessage = errorMessage
    strErrorIn = errorIn
    strExportErrorMessage1 = exportErrorMessage1
    strExportErrorMessage2 = exportErrorMessage2
    strExportErrorMessage2 = exportErrorMessage2
    strFormProgressConvertingDocument = formProgressConvertingDocument
    strFormProgressOpeningPdfDocs = formProgressOpeningPdfDocs
End Sub
Public Sub InitSettingsResources(ByVal formSettingsCaption As String, ByVal tabSettingsCaption As String, ByVal checkBoxBookmarksCaption As String, ByVal checkBoxThumbnailCaption As String, _
        ByVal checkBoxPrintWordMarkupCaption As String, ByVal formLinksCaption As String, ByVal checkBoxHyperlinksCaption As String, ByVal checkBoxReferencesCaption As String, _
        ByVal labelReferencesCaption As String, ByVal chekBoxBookmarkTOCCaption As String, ByVal tabBookmarkStylesCaption As String, ByVal labelHelpCaption As String, _
        ByVal buttonOKCaption As String, ByVal buttonCancelCaption As String, ByVal bookmarkSelectedStyles As String, ByVal bookmarkOtherStyles As String, ByVal bookmarkOtherStylesNotIn As String)
    strFormSettingsCaption = formSettingsCaption
    strTabSettingsCaption = tabSettingsCaption
    strCheckBoxBookmarksCaption = checkBoxBookmarksCaption
    strCheckBoxThumbnailCaption = checkBoxThumbnailCaption
    strCheckBoxPrintWordMarkupCaption = checkBoxPrintWordMarkupCaption
    strFormLinksCaption = formLinksCaption
    strCheckBoxHyperlinksCaption = checkBoxHyperlinksCaption
    strCheckBoxReferencesCaption = checkBoxReferencesCaption
    strLabelReferencesCaption = labelReferencesCaption
    strChekBoxBookmarkTOCCaption = chekBoxBookmarkTOCCaption
    strTabBookmarkStylesCaption = tabBookmarkStylesCaption
    strLabelHelpCaption = labelHelpCaption
    strButtonOKCaption = buttonOKCaption
    strButtonCancelCaption = buttonCancelCaption
    strBookmarkSelectedStyles = bookmarkSelectedStyles
    strBookmarkOtherStyles = bookmarkOtherStyles
    strBookmarkOtherStylesNotIn = bookmarkOtherStylesNotIn
End Sub
Public Sub InitCreateAgendaResources(ByVal agendaProgressTitle As String, ByVal agendaProgressCreateLinks As String, ByVal agendaProgressFinalize As String, ByVal agendaMsgSuccess As String, ByVal agendaMsgFailed As String, ByVal agendaMsgTemplateNotSaved As String, ByVal agendaProgressInitialize As String)
    strCreateAgendaProgressTitle = agendaProgressTitle
    strCreateAgendaProgressCreateLinks = agendaProgressCreateLinks
    strCreateAgendaProgressFinalize = agendaProgressFinalize
    strCreateAgendaMsgSuccess = agendaMsgSuccess
    strCreateAgendaMsgFailed = agendaMsgFailed
    strCreateAgendaMsgTemplateNotSaved = agendaMsgTemplateNotSaved
    strCreateAgendaProgressInitialize = agendaProgressInitialize
End Sub
Public Sub OpenToPdfdocs()
    DoExportToPDFDOCS (OUTPUTACTION_OPEN)
End Sub
Public Sub ImportToPdfdocs()
    DoExportToPDFDOCS (OUTPUTACTION_IMPORT)
End Sub
Public Sub EmailAsPdf()
    DoExportToPDFDOCS (OUTPUTACTION_EMAIL)
End Sub
Public Sub SaveIntoAsPdf()
    DoExportToPDFDOCS (OUTPUTACTION_SAVEINTO)
End Sub
Public Sub SaveAsPdf(ByVal outputFileName As String)
    DoSaveAsPDF outputFileName
End Sub
Public Sub SaveIntoPDDMS()
    DoExportToPDFDOCS (OUTPUTACTION_SAVEINTODMS)
End Sub
Public Sub ShowSettings()
    DoSettings
End Sub

Public Sub GenerateThumbnailIdentifier(ByVal outputPDFFilename As String, ByVal ActiveDocFullName As String)

'Dump thumbnail section numbering to a text file
    Dim applyThumbnailPageNumbering As String
    Dim OutputIdentifierFilename As String
    'Generate the Identifier file that will tell Monitor to email the document (*.PDFDOCS)
    applyThumbnailPageNumbering = GetPDFDocsPrintSetting("ApplyThumbnailPageNumbering")
    
    If applyThumbnailPageNumbering = "True" Then
        OutputIdentifierFilename = outputPDFFilename & EXT_IDENTIFIER
    '    On Error Resume Next
    '       ' Kill (OutputIdentifierFilename)
    '    On Error GoTo OnError
        Dim identifier As Boolean
        
        If Not ActiveDocFullName = "" Then
            If Application.Documents.count > 0 Then
                
                Dim i As Integer
                Dim docCount As Integer
                i = 1
                docCount = Application.Documents.count
                
                Do While i <= docCount
                    If Application.Documents(i).FullName = ActiveDocFullName Then
                        Application.Documents(i).Activate
                        Exit Do
                    End If
                    i = i + 1
                Loop
            End If
        End If
        
        identifier = GenerateIdentifier("IMPORT", OutputIdentifierFilename, GetThumbnailSectionsString)
        
    End If
End Sub

Private Function ConvertToPDF(Optional ByVal CurrentDocument As Document, Optional ByVal DocName As String) As String

        Dim PrintToFileSetting As String
        Dim OutputDirectory As String
        Dim outputFileName As String
        Dim ReplacedFilename As String
        Dim OriginalFilename As String
        
        PrintToFileSetting = GetPDFDocsPrintSetting("WordConversionMethod")
        
        If Not CurrentDocument Is Nothing Then
            CurrentDocument.Activate
        End If
        
        Dim appCaption As String
        appCaption = Application.Caption
      
        ' PD-9525, PD-9524
        ' Microsoft Word's caption in 2013 is changed to "Word". This causes pdfDocs to process the output file
        ' improperly due to incorrect prefix
        'If GetWordVersion() >= 15# Then
        '    appCaption = "Microsoft Word"
        'End If
        
        OutputDirectory = settings.UniqueTempDirectory
        If OutputDirectory = "" Then
            OutputDirectory = BPEnvironment.GetNewTempDir
        End If
        'OutputFilename = OutputDirectory & appCaption & " - " & Replace(ActiveDocument.Name, ",", "_")
        If DocName = "" Then
            OriginalFilename = ActiveDocument.Name
            ReplacedFilename = Replace(ActiveDocument.Name, ",", " ")
            outputFileName = OutputDirectory & ReplacedFilename
        Else
            OriginalFilename = DocName
            ReplacedFilename = Replace(DocName, ",", " ")
            outputFileName = OutputDirectory & ReplacedFilename
        End If
        
        If InStr(LCase(outputFileName), ".doc") Or _
            InStr(LCase(outputFileName), ".docx") Or _
            InStr(LCase(outputFileName), ".dot") Or _
            InStr(LCase(outputFileName), ".dotx") Then
        
            outputFileName = GetFilenameWithoutExtension(outputFileName)
    
        End If
        
        Dim bSuccess As Boolean
        If PrintToFileSetting = "SaveAsPDF" Then
            outputFileName = outputFileName & LCase(EXT_PDF)
            g_ProgressForm.SetProgress BPProgressType.BPProgressIncrement, strFormProgressConvertingDocument
            bSuccess = WordExportToPDF(outputFileName, True)
        Else ' Assume "PrintToFile" as this is the default in code setting
            outputFileName = outputFileName & EXT_POSTSCRIPT
            'outputPDF = CreatePostScript(OutputFilename, True)
            bSuccess = GeneratePostScript(settings, outputFileName)
            ' Disable generation of bookmarks from addin if PrintToFileSettings is not save as PDF
        End If
                
        If bSuccess And OriginalFilename <> ReplacedFilename Then
            ' Restore back the original filename
            OriginalFilename = OutputDirectory & GetDefaultFilenameWithoutExtension(OriginalFilename) & GetFileExtension(outputFileName)
            
            ' The calling function DoExportToPDFDOCS has its error handling which cleans up the progress on error
            FileCopy outputFileName, OriginalFilename
            FileDelete (outputFileName)
            
            If FileExists(OriginalFilename) Then
                outputFileName = OriginalFilename
            End If
        End If
        
        ConvertToPDF = outputFileName
            
End Function
Private Sub DoSaveAsPDF(ByVal outputFileName As String)
    If Not outputFileName = "" Then
        Dim directory As String
        directory = GetDirectory(outputFileName)
        outputFileName = GetFileName(outputFileName)
        ' Rewrite the pdf extension with lower case because sometimes the dialog gives a capitalized PDF extension.
        outputFileName = directory & "\" & GetDefaultFilenameWithoutExtension(outputFileName) & LCase(EXT_PDF)
        DoExportToPDFDOCS OUTPUTACTION_SAVEAS, True, outputFileName
    End If
End Sub

Private Sub RunProgressBarIfFileDoesNotExists(ByVal fileName As String, ByVal milliseconds As Long)
    While Not FileExists(fileName)
        g_ProgressForm.SetProgress BPProgressType.BPProgressIncrement, strFormProgressConvertingDocument
        SleepThread milliseconds
    Wend
End Sub

Private Function IsDocumentCoAuthored(ByVal Document As Document) As Boolean
    Dim isCoAuthored As Boolean
    
    If Not Document.CoAuthoring Is Nothing And Not Document.CoAuthoring.Authors Is Nothing And Document.CoAuthoring.Authors.count > 0 Then
        isCoAuthored = True
    End If
    
    IsDocumentCoAuthored = isCoAuthored
End Function

Private Sub CreateTemporaryDocument()
    Dim tempDocumentFilename As String
    tempDocumentFilename = BPEnvironment.GetNewTempDir + ActiveDocument.Name
    
    ' Copy the current document to temp location
    Set tempDocument = Application.Documents.Add(ActiveDocument.FullName, Visible:=False)
    tempDocument.SaveAs2 tempDocumentFilename
    
    ' Turn off Final protection
    tempDocument.Final = False
    ' Activate the tempDocument
    tempDocument.Activate
End Sub

Private Sub LaunchPDFCMDEXEWithProgressBar(ByVal convertedPDFFilename As String, ByVal OutputSavePdfFilename As String, Optional IsAgenda As Boolean = True, Optional CreateBookmarksUsingHeadingsAndHyperlinksSettings As Boolean = False, Optional progressBarLoopSleep As Long = 50)
    LaunchPDFCMDEXE convertedPDFFilename, OutputSavePdfFilename, IsAgenda:=IsAgenda, CreateBookmarksUsingHeadingsAndHyperlinksSettings:=CreateBookmarksUsingHeadingsAndHyperlinksSettings
    RunProgressBarIfFileDoesNotExists OutputSavePdfFilename, progressBarLoopSleep
End Sub


' OutputSavePdfFilename - The desired output full name of the document. If empty, open the current document in pdfDocs, otherwise save the current
'                         document this filename.
Public Function DoExportToPDFDOCS(ByVal outputAction As String, Optional DisplayAlerts As Boolean = True, Optional OutputSavePdfFilename As String = "")
    
    If Word.Application.Windows.count = 0 Then
        MsgBox strNoDocuments1 & " " & Chr(13) & strNoDocuments2, vbExclamation, BPWordExport.g_AppSettings.ProductName & " " & strNoDocuments3
        Exit Function
    End If
    g_Terminate = False
    
    'Output
    Dim OutputDirectory As String
    Dim outputFileName As String
    Dim OutputBookmarksFilename As String
    Dim OutputHyperlinksFilename As String
    Dim OutputPostscriptFilenaeme As String
    
               
    'Remember Settings
    Dim UserZoom As Integer
    Dim Userview As Integer
    'Dim UserShowRevisionsAndComments As Boolean '(supported in Word 2002 and higher only)
    Dim UserMapPaperSize As Boolean
    Dim UserShowHiddenText As Boolean
    Dim AppName As String
    
    Dim macroUpgrade As Boolean
    Dim operationcontinue As Integer

    Dim winStyle As VbAppWinStyle
    Dim monitorPath As String
    Dim monitorID As Integer
    Dim isCoAuthored As Boolean
        
    winStyle = vbNormalNoFocus
    
    Set g_AppSettings = New BPAppSettings
    Set g_ProgressForm = New frmProgress
    g_ProgressForm.InitUI strFormProgressCaption, strFormProgressPrinting, strFormProgressCleaningUp, strFormProgressCancel, strFormProgressThumbnailPageNumbers, _
            strFormProgressExternalHyperlinks, strFormProgressCrossReferences, strFormProgressInternalLinks, strFormProgressFootnotes, strFormProgressEndnotes, _
            strFormProgressBuildFileIdentifier
    
On Error GoTo OnError
    If ActiveDocument.Final Then
        Dim tempDocumentFilename As String
        tempDocumentFilename = BPEnvironment.GetNewTempDir + ActiveDocument.Name
        
        ' Copy the current document to temp location
        Set tempDocument = Application.Documents.Add(ActiveDocument.FullName, Visible:=False)
        tempDocument.SaveAs2 tempDocumentFilename
        
        ' Turn off Final protection
        tempDocument.Final = False
        
        ' Activate the tempDocument
        tempDocument.Activate
        bUseTempDocument = True
    End If

    'Turn off "Allow A4/Letter Paper Resize" option, as it stuffs up out coordinates
    UserMapPaperSize = Options.MapPaperSize
    Options.MapPaperSize = False
    
    'Adjust to Print Layout view
    Userview = ActiveDocument.ActiveWindow.View.Type
    ActiveDocument.ActiveWindow.View.Type = WdViewType.wdPrintView
        
    'Adjust zoom to 100% so that points are calculated correctly
    UserZoom = ActiveDocument.ActiveWindow.View.Zoom.Percentage
    ActiveDocument.ActiveWindow.View.Zoom.Percentage = 100
    
    'Adjust to hide reviewing (supported in Word 2002 and higher only)
    'UserShowRevisionsAndComments = ActiveDocument.ActiveWindow.view.ShowRevisionsAndComments
    'ActiveDocument.ActiveWindow.view.ShowRevisionsAndComments = False
    
    'Adjust to hidden text, if print hidden text is showing
    UserShowHiddenText = ActiveDocument.ActiveWindow.View.ShowHiddenText
    ActiveDocument.ActiveWindow.View.ShowHiddenText = ActiveDocument.ActiveWindow.Application.Options.PrintHiddenText
        
    ' Turn show all off. This is because bookmarks do not get imported when Show All Paragraphs are on.
    showAllParagraph = ActiveWindow.ActivePane.View.ShowAll
    ActiveWindow.ActivePane.View.ShowAll = False
    
    'Initialize the Progress Window
    g_ProgressForm.SetProgress BPProgressType.BPProgressStart, " "
    g_ProgressForm.show FORMSHOWCONSTANT_MODELESS
    
    On Error Resume Next
        If Not IsDocumentCoAuthored(ActiveDocument) Then
            ActiveDocument.Repaginate
        End If
    On Error GoTo OnError
    
    Set settings = New BPSettings
    With settings
        .File = BPEnvironment.GetSettingsFile
        .DeserializeFromFile
    End With
       
    settings.UniqueTempDirectory = BPEnvironment.GetNewTempDir
       
    Dim PrintToFileSettings As String
    Dim defaultScreenUpdating As Boolean
    Dim fileNameWithoutExtension As String
    
    If InStr(ActiveDocument.Name, ".") Then
        fileNameWithoutExtension = GetFilenameWithoutExtension(ActiveDocument.Name)
    Else
        fileNameWithoutExtension = ActiveDocument.Name
    End If
    
    Dim outDirectory As String
    outDirectory = settings.UniqueTempDirectory
    ''''RAD [PD4]: For PD4 We may need this later.
    If Not g_Terminate Then
        PrintToFileSettings = GetPDFDocsPrintSetting("WordConversionMethod")
        
        If PrintToFileSettings = "PrintToPDF" And Not bSkipCustom Then
          
          'And OutputAction And GetPDSettings("ImportOption") <> "DefaultBinder" And OutputAction = "IMPORT" Then
          
            defaultScreenUpdating = Application.ScreenUpdating
            Application.ScreenUpdating = False
            
             'Generate the Hyperlinks (*.BPLNK)
            OutputHyperlinksFilename = outDirectory & fileNameWithoutExtension & EXT_LINKS
            On Error Resume Next
               ' Kill (OutputHyperlinksFilename)
            On Error GoTo OnError
            GenerateLinks = GenerateHyperlinks(OutputHyperlinksFilename)
            
            'If settings.IsBookmarkConfigured Then
            
            'Generate the Bookmarks (*.BPBKM)
            Dim bookmarkFileName As String
            bookmarkFileName = fileNameWithoutExtension & EXT_BOOKMARKS
            OutputBookmarksFilename = outDirectory & "\" & bookmarkFileName
            On Error Resume Next
                'Kill (OutputBookmarksFilename)
            On Error GoTo OnError
            GenerateBookmarks = GenerateBookmarksFromStyles(OutputBookmarksFilename)
            'End If
            
            Application.ScreenUpdating = defaultScreenUpdating
        End If
    End If
    
    Dim convertedPDFFilename As String
    If Not g_Terminate Then
         convertedPDFFilename = ConvertToPDF
    End If
        
    If Not g_Terminate Then
        GenerateThumbnailIdentifier outputPDFFilename:=convertedPDFFilename, ActiveDocFullName:=""
    End If
    Dim exportToPD As Boolean

    If Not OutputSavePdfFilename = "" Then ' This filename comes from the save as file dialog
    
        g_ProgressForm.SetProgress BPProgressType.BPProgressIncrement, strFormProgressConvertingDocument
    
        If FileExists(OutputSavePdfFilename) Then
            FileDelete OutputSavePdfFilename
        End If
        
        Dim isSaveAsPDFSetting As Boolean
                
        If PrintToFileSettings = SAVEASPDF_PRINTSETTING Then ' Word Conversion 2nd Option
            ' Document is converted to PDF already.
            ' We just need to update the default Dictionary DisplayDocTitle in pdfDocsCMD.
            LaunchPDFCMDEXEWithProgressBar convertedPDFFilename, OutputSavePdfFilename, IsAgenda:=False, CreateBookmarksUsingHeadingsAndHyperlinksSettings:=True
        Else
            LaunchPDFCMDEXEWithProgressBar convertedPDFFilename, OutputSavePdfFilename, IsAgenda:=False
        End If
        
        ' Convert to PDF using output
        convertedPDFFilename = OutputSavePdfFilename
        
        ' If user set the save option to view to pdfDocs. Launch PD.
        officeSaveAsViewPDF = GetPDFDocsPrintSetting(SAVEASPDF_VIEWINPDFDOCS)
        If officeSaveAsViewPDF = "True" And FileExists(convertedPDFFilename) Then
            exportToPD = True
        End If
    Else
        exportToPD = True
    End If
    
    If exportToPD = True Then
        Dim args As String
        Dim actionKey As String
        Dim addOfficeArguments As Boolean
        addOfficeArguments = True

        Select Case outputAction
            Case "IMPORT"
                actionKey = "/importintopdfdocs "
            Case "OPEN"
                actionKey = "/openinpdfdocs "
            Case "EMAIL"
                 actionKey = "/email "
            Case "SAVEAS"
                addOfficeArguments = False
                args = Chr(34) & convertedPDFFilename & Chr(34) ' Add quotations, treat filename as one argument.
            Case "SAVEINTO"
                actionKey = "/saveas "
            Case "SAVEINTODMS"
                actionKey = "/saveintodms "
        End Select
    
    
        If Not g_Terminate Then
            If addOfficeArguments Then ' This will only be added if NOT Save as pdf
                args = "/office " & actionKey & Chr(34) & convertedPDFFilename & Chr(34) & " " _
                & Chr(34) & ActiveDocument.FullName & Chr(34)
            
                If GenerateBookmarks Then
                    args = args & " /bookmark " & Chr(34) & OutputBookmarksFilename & Chr(34)
                End If
                
                If GenerateLinks Then
                    args = args & " /hyperlink " & Chr(34) & OutputHyperlinksFilename & Chr(34)
                End If
            End If
                
            g_ProgressForm.SetProgress BPProgressType.BPProgressIncrement, strFormProgressOpeningPdfDocs
            
            LaunchPDFDocsWithParams (args)
        End If
    End If
    
OnCleanup:
    g_ProgressForm.SetProgress BPProgressType.BPProgressEnd, strFormProgressCleaningUp
    If g_Terminate Then
        UserCleanup outputFileName
    Else
        g_ProgressForm.btnCancel.Enabled = False
    End If
    
    'Put back the print hidden text
    ActiveDocument.ActiveWindow.View.ShowHiddenText = UserShowHiddenText
    
    'Put back the reviewing view (supported in Word 2002 and higher only)
    'ActiveDocument.ActiveWindow.view.ShowRevisionsAndComments = UserShowRevisionsAndComments
    
    'Put back the view
    ActiveDocument.ActiveWindow.View.Type = Userview
    
    'Put back the zoom
    ActiveDocument.ActiveWindow.View.Zoom.Percentage = UserZoom
    
    'Put back the Allow A4/Letter Paper Resize option
    Options.MapPaperSize = UserMapPaperSize
    
     ' Put back Show All
    ActiveWindow.ActivePane.View.ShowAll = showAllParagraph
    
    Dim TheDate As Date
    TheDate = Timer
    Do
    Loop Until (Timer - TheDate) > 1.5
    g_ProgressForm.Hide
    
    If bUseTempDocument And Not tempDocument Is Nothing Then
        ' Close temp document
        tempDocument.Close savechanges:=False
        bUseTempDocument = False
        Set tempDocument = Nothing
    End If
OnEnd:
    Exit Function
    
OnError:
    Dim error As String
    Dim errNum As String
    errNum = Err.Number
    errorStr = Err.Description
    
    If (errNum = -2147467259) Then
        errorStr = strExportErrorMessage1 & vbNewLine & strExportErrorMessage2
    End If
    
    MsgBox strErrorMessage & " " & errNum & " " & errorStr
    GoTo OnCleanup
    
End Function
Public Sub LaunchPDFDocsWithParams(param As String)
    Shell GetBPPDFDOCSEXE & " " & param
End Sub
Public Function GetCurrentSettings() As BPSettings
    Dim settings As BPSettings
    
    Set settings = New BPSettings
    With settings
        .File = BPEnvironment.GetSettingsFile
        .DeserializeFromFile
    End With
    
    Set GetCurrentSettings = settings
End Function
Public Function PdfDocs_WordDocumentLoadFieldCodes()
 
    '''DEVELOPER NOTE
    ''' The below code which Locks field codes the headers and footers in some cases (#8108)
    ''' will modify the document flow when called through Automation
    ''' To fix this we call this in this Macro and the Document flow is unchanged.
    ''' However because this method of Automation calling Macro comes with risk, we still use the Automation
    ''' method by default in WordDocument
    ''' If you find yourself editing this area, nou MUST also change the __SetOpenDocumentState
    ''' function in the WordDocument file

    For Each Section In ActiveDocument.Sections
        For Each Header In Section.Headers
            For Each Field In Header.Range.Fields
                If Field.Type = WdFieldType.wdFieldFileName Then
                    Field.Locked = True
                End If
            Next Field
        Next Header
        For Each Footer In Section.Footers
            For Each Field In Footer.Range.Fields
                If Field.Type = WdFieldType.wdFieldFileName Then
                    Field.Locked = True
                End If
            Next Field
        Next Footer
    Next Section

End Function

Public Function DoSettings()

    If Word.Application.Windows.count = 0 Then
        MsgBox strNoDocuments1 & " " & Chr(13) & strNoDocuments2, vbExclamation, BPWordExport.g_AppSettings.ProductName & " " & strNoDocuments3
        Exit Function
    End If
    
On Error GoTo OnError
    Dim settings As BPSettings
    Dim SettingsForm As frmSettings
    Dim BPStyleCollection As BPStyleCollection
    
    Set settings = New BPSettings
    Set SettingsForm = New frmSettings
    Set g_AppSettings = New BPAppSettings
    
    'Dynamic Caption for Settings Form
    SettingsForm.InitUI strFormSettingsCaption, strTabSettingsCaption, strCheckBoxBookmarksCaption, strCheckBoxThumbnailCaption, strCheckBoxPrintWordMarkupCaption, _
                        strFormLinksCaption, strCheckBoxHyperlinksCaption, strCheckBoxReferencesCaption, strLabelReferencesCaption, strCheckBoxBookmarkTOCCaption, _
                        strTabBookmarkStylesCaption, strLabelHelpCaption, strButtonOKCaption, strButtonCancelCaption, strBookmarkSelectedStyles, strBookmarkOtherStyles, strBookmarkOtherStylesNotIn
            
    'Open from Settings File
    With settings
        .File = BPEnvironment.GetSettingsFile
        .DeserializeFromFile
    End With
    SettingsForm.SettingsCollections = settings.settings
    SettingsForm.chkbxBookmarks.Value = settings.IsBookmarksEnabled
    'Get the rest of the styles in this document
    Set BPStyleCollection = SettingsForm.StyleCollection
    For Each Style In ActiveDocument.Styles
        If Style.InUse Then
            If Not BPStyleCollection.Exists(Style.NameLocal) Then
                Set BPStyle = New BPStyle
                With BPStyle
                    .InUse = True
                    .Name = Style.NameLocal
                End With
                
                SettingsForm.StyleCollection.Add BPStyle
            End If
        End If
    Next Style
    For Each Style In ActiveDocument.Styles
        If Not BPStyleCollection.Exists(Style.NameLocal) Then
            Set BPStyle = New BPStyle
            With BPStyle
                .InUse = False
                .Name = Style.NameLocal
            End With
            
            BPStyleCollection.Add BPStyle
        End If
    Next Style
    
    SettingsForm.StyleCollection = BPStyleCollection
    SettingsForm.show FORMSHOWCONSTANT_MODAL
        
On Error GoTo OnTerminate
    If SettingsForm.DialogResult Then
        On Error GoTo OnError
        'Save to Settings File
        settings.settings = SettingsForm.SettingsCollections
        settings.IsBookmarksEnabled = SettingsForm.chkbxBookmarks.Value
        settings.SerializeToFile
    End If
On Error GoTo OnError

OnEnd:
    Exit Function

OnError:
    MsgBox strErrorMessage & " " & Err.Number & " " & Err.Description & " " & strErrorIn & " " & Err.Source
    GoTo OnEnd
    
OnTerminate:
    GoTo OnEnd
End Function

Public Function DoLaunchApp()
    Shell BPEnvironment.GetBPPDFDOCSEXE, vbNormalFocus
End Function
Private Function GenerateIdentifier(ByVal IdentifierAction As String, ByVal outputFileName As String, ByVal ThumbnailCollectionString As String) As Boolean
    GenerateIdentifier = False
    If Not g_ProgressForm Is Nothing Then
        g_ProgressForm.SetProgress BPProgressIncrement, strFormProgressBuildFileIdentifier
    End If
    GenerateIdentifier = BPIdentifier.OutputIdentifierFile(IdentifierAction, outputFileName, ThumbnailCollectionString)
End Function
Public Function GenerateBookmarksFromStyles(ByVal outputPath As String, Optional ByVal ActiveDocFullName As String = "", Optional ByVal IsAgenda As Boolean = False) As Boolean
    Dim settings As BPSettings
    Set settings = GetCurrentSettings
    
    Dim IsInvokedFromPD As Boolean
    IsInvokedFromPD = ActiveDocFullName <> ""
    
    If settings.IsBookmarksEnabled And settings.IsBookmarkConfigured Then
        Dim BSIndex As Integer
        Dim BSArray() As String
        Dim SettingsCollection As BPNameValuePairCollection
        Dim BPStyle As BPStyle
        Dim BPStyles As BPStyleCollection
        
        Dim testBool As Boolean
        
        If IsInvokedFromPD Then
            If Application.Documents.count > 0 Then
                Dim i As Integer
                Dim docCount As Integer
                i = 1
                docCount = Application.Documents.count
                
                Do While i <= docCount
                    If Application.Documents(i).FullName = ActiveDocFullName Then
                        Application.Documents(i).Activate
                        Exit Do
                    End If
                    i = i + 1
                Loop
            End If
        End If
        
        Set SettingsCollection = settings.settings
        
        BSIndex = SettingsCollection.IndexOf("Bookmarks")
        If BSIndex > 0 Then
            If IsNumeric(SettingsCollection.Item(BSIndex).Value) And _
                SettingsCollection.Item(BSIndex).Value = 1 Then
        
                'Create a Style Collection
                BSIndex = SettingsCollection.IndexOf("BookmarkStyles")
                If BSIndex > 0 Then
                    Set BPStyles = New BPStyleCollection
                    BSArray = Split(SettingsCollection.Item(BSIndex).Value, "\")
                    For i = LBound(BSArray) To UBound(BSArray)
                        Set BPStyle = New BPStyle
                        With BPStyle
                            .Checked = True
                            .Weight = i + 1
                            .Name = BSArray(i)
                        End With
                        
                        BPStyles.Add BPStyle
                    Next
                    GenerateBookmarksFromStyles = BPBookmarksStyles.OutputBookmarksFromStyles(BPStyles, outputPath, IsInvokedFromPD, IsAgenda)
                End If
            End If
        End If
    End If
End Function

 Private Function GenerateHyperlinks(ByVal outputFileName As String, Optional ByVal ActiveDocFullName As String = "", Optional ByVal isCreatingAgenda As Boolean) As Boolean
    
    GenerateHyperlinks = False
    
    Dim settings As BPSettings
    Set settings = GetCurrentSettings
        
    Dim BSIndex As Integer
    Dim BSArray() As String
    Dim SettingsCollection As BPNameValuePairCollection
    Dim cont As Boolean
    cont = True
    
    Dim IsInvokedFromPD As Boolean
    IsInvokedFromPD = ActiveDocFullName <> ""
    
    If IsInvokedFromPD Then
        If Application.Documents.count > 0 Then
            Dim i As Integer
            Dim docCount As Integer
            i = 1
            docCount = Application.Documents.count
            
            Do While i <= docCount
                If Application.Documents(i).FullName = ActiveDocFullName Then
                    Application.Documents(i).Activate
                    Exit Do
                End If
                i = i + 1
            Loop
        End If
    End If
    
    Set SettingsCollection = settings.settings
        
    BSIndex = SettingsCollection.IndexOf("LinkURLs")
    If BSIndex > 0 Then
        If IsNumeric(SettingsCollection.Item(BSIndex).Value) And _
            SettingsCollection.Item(BSIndex).Value = 1 Then
           
            BPHyperlinks.OutputWebLinks outputFileName, IsInvokedFromPD, isCreatingAgenda
            cont = False
        End If
    End If
    
    BSIndex = SettingsCollection.IndexOf("LinkRefs")
    If BSIndex > 0 Then
        If IsNumeric(SettingsCollection.Item(BSIndex).Value) And _
            SettingsCollection.Item(BSIndex).Value = 1 Then

            BPHyperlinks.OutputReferenceLinks outputFileName, IsInvokedFromPD
        End If
    End If
    
    On Error GoTo OnErrorShape
    If cont Then
        For Each shape In ActiveDocument.Shapes
            If Not shape.TextFrame.HasText = 0 Then
                If shape.TextFrame.TextRange.hyperLinks.count > 0 Then
                    
                    BPHyperlinks.OutputWebLinks outputFileName, IsInvokedFromPD
                End If
            End If
        Next shape
    End If

GenerateHyperlinks = FileExists(outputFileName)

OnErrorShape:
    Exit Function
End Function

 
Private Function WordExportToPDF(ByVal outputFileName As String, Optional DisplayAlerts As Boolean = True) As Boolean

    Dim exportType As WdExportItem
    Dim createBookmarks As Boolean
    Dim exportCreateBookmarks As WdExportCreateBookmarks
    
    If ActiveWindow.View.ShowRevisionsAndComments Then
        exportType = WdExportItem.wdExportDocumentWithMarkup
    Else
        exportType = WdExportItem.wdExportDocumentContent
    End If
    
    'If settings.IsBookmarkConfigured Then
    '    exportCreateBookmarks = wdExportCreateNoBookmarks
    'Else
        exportCreateBookmarks = wdExportCreateHeadingBookmarks
    'End If
    
    Dim tempWarnBeforeSave As Boolean
    tempWarnBeforeSave = Application.Options.WarnBeforeSavingPrintingSendingMarkup
        
    ' Set WarnBeforeSave option to false so that it will not prompt the user twice
    Application.Options.WarnBeforeSavingPrintingSendingMarkup = False
    
    ActiveDocument.ExportAsFixedFormat outputFileName:= _
            outputFileName, ExportFormat:= _
            wdExportFormatPDF, OpenAfterExport:=False, OptimizeFor:= _
            wdExportOptimizeForPrint, Range:=wdExportAllDocument, From:=1, To:=1, _
            Item:=exportType, IncludeDocProps:=True, KeepIRM:=True, _
            createBookmarks:=exportCreateBookmarks, DocStructureTags:=True, _
            BitmapMissingFonts:=True, UseISO19005_1:=False
    
    Application.Options.WarnBeforeSavingPrintingSendingMarkup = tempWarnBeforeSave
    
    WordExportToPDF = True
        
End Function

Private Function GeneratePostScript(ByRef setting As BPSettings, ByVal outputFileName As String, Optional DisplayAlerts As Boolean = True) As Boolean
    
    g_ProgressForm.SetProgress BPProgressType.BPProgressIncrement, strFormProgressPrinting

On Error GoTo OnError
    Dim BSIndex As Integer
    Dim CompatibilityMode As Integer
    Dim UsersiManO2K As Boolean
    Dim UsersPrinter As String
    Dim LargeNumberOfPages As String
    
    UsersPrinter = ActivePrinter
    'ActivePrinter = g_AppSettings.ProductName
    WordBasic.FilePrintSetup _
        printer:="DocsCorp PDF Printer", _
        DoNotSetAsSysDefault:=1
    
    Dim printItem As WdPrintOutItem
    
    If ActiveDocument.ActiveWindow.View.ShowRevisionsAndComments Then
        'Below Enum is not present in Word2000 and cause compile error
        'printItem = WdPrintOutItem.wdPrintDocumentWithMarkup
        printItem = 7
    Else
        printItem = WdPrintOutItem.wdPrintDocumentContent
    End If
    
    Dim tempDisplayAlerts As Integer
    tempDisplayAlerts = Application.DisplayAlerts
    
    Dim tempWarnBeforeSave As Boolean
    tempWarnBeforeSave = Application.Options.WarnBeforeSavingPrintingSendingMarkup
    
    If Not DisplayAlerts Then
        Application.DisplayAlerts = wdAlertsNone
    End If
    
    ' Set WarnBeforeSave option to false so that it will not prompt the user twice
    Application.Options.WarnBeforeSavingPrintingSendingMarkup = False
    
    Application.ScreenUpdating = True
    ActiveDocument.PrintOut _
        Background:=False, _
        Append:=False, _
        Item:=printItem, _
            Range:=WdPrintOutRange.wdPrintAllDocument, _
            PrintToFile:=True, _
            outputFileName:=outputFileName
    
    If Application.version Like "12*" Then
        LargeNumberOfPages = "0"
    Else
        LargeNumberOfPages = "9999999"
    End If
    
   ' Workaround, to uncheck the PrintToFile option
    ActiveDocument.PrintOut _
           Background:=True, _
           Append:=False, _
           Item:=printItem, _
           PrintToFile:=False, _
           Range:=WdPrintOutRange.wdPrintRangeOfPages, _
           Pages:=LargeNumberOfPages
            
    Application.Options.WarnBeforeSavingPrintingSendingMarkup = tempWarnBeforeSave
    Application.ScreenUpdating = False ' Not sure why we set this to false. I think we should be setting it to false before printing and then setting it
    ' back to its original value after printing. Leaving it for now as this is the way it how it was in PD3 - so assume it's working.
        
    Application.DisplayAlerts = tempDisplayAlerts
        
    'ActivePrinter = UsersPrinter
    
    'The FilePrintSetup method call here is supposed to be setting back the default printer to it's previous value. Though this is not needed anymore because the first call
    'to FilePrintSetup doesn't set the default system printer because of 'DoNotSetAsSysDefault:=1'.
    'Also calling this method causes Office 2013 to crash
    WordBasic.FilePrintSetup _
        printer:=UsersPrinter, _
        DoNotSetAsSysDefault:=1
        
    GeneratePostScript = True
OnExit:
    Exit Function
OnError:
    GeneratePostScript = False
    GoTo OnExit
End Function

' NO LONGER BEING USED.
Private Function GeneratePostScript2000(ByRef setting As BPSettings, ByVal outputFileName As String) As Boolean
    
    g_ProgressForm.SetProgress BPProgressType.BPProgressIncrement, strFormProgressPrinting

On Error GoTo OnError
    Dim BSIndex As Integer
    Dim CompatibilityMode As Integer
    Dim UsersiManO2K As Boolean
    Dim UsersPrinter As String
    
    UsersPrinter = ActivePrinter
    'ActivePrinter = g_AppSettings.ProductName
    WordBasic.FilePrintSetup _
        printer:=g_AppSettings.ProductName, _
        DoNotSetAsSysDefault:=1
        
    BSIndex = setting.settings.IndexOf("CompatibilityMode")
    If BSIndex > 0 Then
        If IsNumeric(setting.settings.Item(BSIndex).Value) Then
            CompatibilityMode = setting.settings.Item(BSIndex).Value
        End If
    End If
    
'On Error Resume Next
    'UsersiManO2K = Application.COMAddIns("iManO2K.AddinForWord2000").Connect
    'Application.COMAddIns("iManO2K.AddinForWord2000").Connect = False
'On Error GoTo OnError

    'Impossible to remove trackedchanges from the print output so
    'set to wdPrintDocumentContent
    Dim printItem As WdPrintOutItem
    printItem = WdPrintOutItem.wdPrintDocumentContent
    
    'BSIndex = Setting.Settings.IndexOf("printwordmarkup")
    'If BSIndex > 0 Then
    '    If Setting.Settings.Item(BSIndex).Value = True Then
    '       printItem = WdPrintOutItem.wdPrintDocumentWithMarkup
    '    Else
    '        printItem = WdPrintOutItem.wdPrintDocumentContent
    '    End If
    'End If

    If CompatibilityMode = 1 Then
        
        Application.ScreenUpdating = True
        ActiveDocument.PrintOut _
            Background:=False, _
            Append:=False, _
            Item:=printItem, _
                Range:=WdPrintOutRange.wdPrintAllDocument, _
                PrintToFile:=True, _
                outputFileName:=outputFileName
        
    ' Workaround, to uncheck the PrintToFile option
        ActiveDocument.PrintOut _
            Background:=True, _
            Append:=False, _
            Item:=printItem, _
            PrintToFile:=False, _
            Range:=WdPrintOutRange.wdPrintRangeOfPages, _
            Pages:="0"
        Application.ScreenUpdating = False
    Else
    
        Application.ScreenUpdating = True
        ActiveDocument.PrintOut _
            Background:=False, _
            Append:=False, _
            Item:=printItem, _
            Range:=WdPrintOutRange.wdPrintAllDocument
        Application.ScreenUpdating = False
            
    End If
        
'On Error Resume Next
    'Application.COMAddIns("iManO2K.AddinForWord2000").Connect = UsersiManO2K
'On Error GoTo OnError
        
    'ActivePrinter = UsersPrinter
    WordBasic.FilePrintSetup _
        printer:=UsersPrinter, _
        DoNotSetAsSysDefault:=1
OnExit:
    Exit Function
OnError:
    ' Do nothing
    GoTo OnExit
End Function

Private Function CheckPrinter() As Boolean
    CheckPrinter = True

    Dim UsersPrinter As String
    UsersPrinter = ActivePrinter
    
On Error GoTo OnError
    'ActivePrinter = g_AppSettings.ProductName
    WordBasic.FilePrintSetup _
        printer:=g_AppSettings.ProductName, _
        DoNotSetAsSysDefault:=1
OnEnd:
    'ActivePrinter = UsersPrinter
    WordBasic.FilePrintSetup _
        printer:=UsersPrinter, _
        DoNotSetAsSysDefault:=1
    Exit Function
OnError:
    CheckPrinter = False
    GoTo OnEnd
End Function
'Private Function GetThumbnailSectionsString(ByRef setting As BPSettings) As String
Private Function GetThumbnailSectionsString() As String
    Dim Output As String
    Dim BPSectionCollection As BPSectionCollection
    Set BPSectionCollection = GetThumbnailSections
    If BPSectionCollection.count > 0 Then
      Output = BPSectionCollection.Serialized
    Else
      Output = ""
    End If
    
    GetThumbnailSectionsString = Output
End Function
'Private Function GetThumbnailSections(ByRef setting As BPSettings) As BPSectionCollection
Private Function GetThumbnailSections() As BPSectionCollection
   'Dim BSIndex As Integer
   Dim SettingsCollection As BPNameValuePairCollection
   Dim PreviousActiveEndPageNumber As Integer 'Total Page numbers (Absolute)
   Dim PreviousStartingPageNum As Integer  ' Starting Page number of the previous section
   Dim PreviousPhysicalPageNum As Integer 'Absolute page number where the previous section started on the document
   Dim test As Integer
   Dim BPSection As BPSection
      
   Set BPSectionCollection = New BPSectionCollection
   'Set SettingsCollection = Settings.Settings
   PreviousActiveEndPageNumber = 0
   PreviousStartingPageNum = 0
   PreviousPhysicalPageNum = 0
   
On Error GoTo OnError

   'BSIndex = SettingsCollection.IndexOf("ApplyThumbnailPageNumbering")
    'If BSIndex > 0 Then
        'If IsNumeric(SettingsCollection.Item(BSIndex).Value) And _
            'SettingsCollection.Item(BSIndex).Value = 1 Then
            
            If IsPageFieldCodeExists() Then
                If g_ProgressForm Is Nothing Then
                    On Error Resume Next
                        ActiveDocument.Repaginate
                Else
                    g_ProgressForm.SetProgress BPProgressIncrement, strFormProgressThumbnailPageNumbers
                End If
               
               'SB added - just pausing here before starting this next step is enough.
               DoEvents
               For wait = 1 To 5000
               Next wait
               
               ActiveDocument.ActiveWindow.View = wdPrintView
               If Options.UpdateFieldsAtPrint = True Then
                ActiveDocument.Range.Fields.Update
               End If
                              
               DoEvents
               For wait = 1 To 5000
               Next wait
               
               For Each sec In ActiveDocument.Sections
                  Set BPSection = New BPSection
                  If IsPageFieldCodeExistsInSection(sec) Then
                        
                    BPSection.SectionType = sec.Footers(wdHeaderFooterPrimary).PageNumbers.NumberStyle
                    
                    If sec.Footers(wdHeaderFooterPrimary).PageNumbers.RestartNumberingAtSection Then
                        BPSection.StartingPageNum = sec.Footers(wdHeaderFooterPrimary).PageNumbers.StartingNumber
                    Else
                        BPSection.StartingPageNum = PreviousStartingPageNum + PreviousActiveEndPageNumber - PreviousPhysicalPageNum + 1
                    End If
                    
                  Else
                    
                    BPSection.SectionType = 5 ' Value 5 is considered to be NONE according to iTextSharp
                                      
                  End If
                  
                  BPSection.PhysicalPage = PreviousActiveEndPageNumber + 1
                  PreviousPhysicalPageNum = PreviousActiveEndPageNumber + 1
                  PreviousStartingPageNum = BPSection.StartingPageNum
                  
                  PreviousActiveEndPageNumber = sec.Range.Information(wdActiveEndPageNumber)
                   
                  BPSectionCollection.Add BPSection
               Next sec
               
               
            End If
        'End If
    'End If
    
   Set GetThumbnailSections = BPSectionCollection
    
OnExit:
    Exit Function
OnError:
    Set GetThumbnailSections = New BPSectionCollection
    GoTo OnExit
End Function

Private Function IsPageFieldCodeExists() As Boolean
    IsPageFieldCodeExists = False
   
On Error GoTo OnError
    
    For Each Section In ActiveDocument.Sections
        For Each Footer In Section.Footers
            For Each Field In Footer.Range.Fields
                If Field.Type = WdFieldType.wdFieldPage Then
                  IsPageFieldCodeExists = True
                  Exit Function
                End If
            Next Field
        Next Footer
    Next Section
    
OnExit:
    Exit Function
OnError:
    IsPageFieldCodeExists = False
    GoTo OnExit
End Function

Private Function IsPageFieldCodeExistsInSection(ByVal sec As Section) As Boolean
    IsPageFieldCodeExistsInSection = False
   
On Error GoTo OnError
    
    'For Each Footer In sec.Footers
       ' For Each Field In Footer.Range.Fields
            'If Field.Type = WdFieldType.wdFieldPage Then
              'IsPageFieldCodeExistsInSection = True
              'Exit Function
           ' End If
        'Next Field
    'Next Footer
    
    If sec.Footers(wdHeaderFooterPrimary).Range.Fields.count > 0 Then
        IsPageFieldCodeExistsInSection = True
    End If
    
OnExit:
    Exit Function
OnError:
    IsPageFieldCodeExistsInSection = False
    GoTo OnExit
End Function
Private Function UserCleanup(ByVal outputFileName As String)
On Error Resume Next
    Kill outputFileName & EXT_BOOKMARKS
    Kill outputFileName & EXT_LINKS
    Kill outputFileName & EXT_POSTSCRIPT
    Kill outputFileName & EXT_IDENTIFIER
On Error GoTo 0

End Function


Public Function DoExportToBinder()

    If Word.Application.Windows.count = 0 Then
        MsgBox strNoDocuments1 & " " & Chr(13) & strNoDocuments2, vbExclamation, BPWordExport.g_AppSettings.ProductName & " " & strNoDocuments3
        Exit Function
    End If
    
    'Output
    Dim OutputHyperlinksFilename As String
    Dim slashPos As Integer
    Dim hyperLinks As Boolean
        
    slashPos = InStrRev(ActiveDocument.FullName, "\", -1, vbTextCompare)
    OutputHyperlinksFilename = Mid(ActiveDocument.FullName, 1, slashPos - 1)

    OutputHyperlinksFilename = OutputHyperlinksFilename & "\Links.txt"
    
    hyperLinks = GenerateBinderHyperlinks(OutputHyperlinksFilename)
    
OnCleanup:
    
    
    'Put back the print hidden text
    ActiveDocument.ActiveWindow.View.ShowHiddenText = UserShowHiddenText
    
    'Put back the reviewing view (supported in Word 2002 and higher only)
    'ActiveDocument.ActiveWindow.view.ShowRevisionsAndComments = UserShowRevisionsAndComments
    
    'Put back the view
    ActiveDocument.ActiveWindow.View.Type = Userview
    
    'Put back the zoom
    ActiveDocument.ActiveWindow.View.Zoom.Percentage = UserZoom
    
    'Put back the Allow A4/Letter Paper Resize option
    Options.MapPaperSize = UserMapPaperSize
    
    Dim TheDate As Date
    TheDate = Timer
    Do
    Loop Until (Timer - TheDate) > 1.5
    g_ProgressForm.Hide
    
OnEnd:
    Exit Function
    
OnError:
    MsgBox strErrorMessage & " " & Err.Number & " " & Err.Description & " " & strErrorIn & " " & Err.Source
    GoTo OnCleanup
    
End Function

Private Function GenerateBinderHyperlinks(ByVal outputFileName As String) As Boolean
    GenerateBinderHyperlinks = True
        
    Dim BSIndex As Integer
    Dim BSArray() As String
    Dim SettingsCollection As BPNameValuePairCollection
    Dim cont As Boolean
    cont = True
    
On Error GoTo OnError
            ActiveDocument.Range 0, 0
            ActiveDocument.Select
    
            BPHyperlinks.GetBinderLinks (outputFileName)

OnEnd:
    Exit Function
    
OnError:
    MsgBox strErrorMessage & " " & Err.Number & " " & Err.Description
    
End Function

Public Sub RestartListNumbersWithinEachSection()
    '
    ' Court Bundling macro - restart list numbers within each section
    '
    Dim tt As Tables
    Dim t As Table
    Dim r As Range
    Dim ll As ListParagraphs
    Dim l As Paragraph
    Dim lt As ListTemplate
    
    Set r = ActiveDocument.Range
    Set tt = r.Tables
    
    For x = 1 To tt.count
    On Error GoTo OnError
    
start:
        Set t = tt(x)
        Set ll = t.Range.ListParagraphs
        
        If ll.count > 0 Then
          
            Set l = ll(1)   ' we only need to deal with the 1st list paragraph
            Set r = l.Range
            r.Select
            r.End = r.start
            r.Select
            
            Set lt = r.ListFormat.ListTemplate ' get the applied list template to maintain format
                
            ' reapply the list template but set ContinuePreviousList to false to reset
            r.ListFormat.ApplyListTemplate ListTemplate:=lt, ContinuePreviousList:= _
                False, ApplyTo:=wdListApplyToWholeList, DefaultListBehavior:= _
                wdWord10ListBehavior
         End If
    Next x
    
OnError:
    If x < tt.count Then
        x = x + 1
        GoTo start
    Else
        Exit Sub
    End If

End Sub

Public Sub ContinueListNumbersWithinEachSection()
    '
    ' Court Bundling macro - continue list numbers within each section
    '
    Dim tt As Tables
    Dim t As Table
    Dim r As Range
    Dim ll As ListParagraphs
    Dim l As Paragraph
    Dim lt As ListTemplate
    
    Set r = ActiveDocument.Range
    Set tt = r.Tables
    
    For x = 1 To tt.count
    On Error GoTo OnError
    
start:
        Set t = tt(x)
        Set ll = t.Range.ListParagraphs
        
        If ll.count > 0 Then
          
            Set l = ll(1)   ' we only need to deal with the 1st list paragraph
            Set r = l.Range
            r.Select
            r.End = r.start
            r.Select
            
            Set lt = r.ListFormat.ListTemplate ' get the applied list template to maintain format
                
            ' reapply the list template but set ContinuePreviousList to true
            r.ListFormat.ApplyListTemplate ListTemplate:=lt, ContinuePreviousList:= _
                True, ApplyTo:=wdListApplyToWholeList, DefaultListBehavior:= _
                wdWord10ListBehavior
         End If
    Next x
    
OnError:
    If x < tt.count Then
        x = x + 1
        GoTo start
    Else
        Exit Sub
    End If

End Sub

Public Sub RestartNumberingForList()


    Dim rows As rows
    Dim row As row
    Dim listPar As ListParagraphs
    Dim par As Paragraph
    Dim isFirst As Boolean
    Dim isFolderFirst As Boolean
    Dim prevColWid As Single
    Dim cont As Boolean
    Dim ctr As Integer
    Dim lt As ListTemplate
    
    Set rows = ActiveDocument.Tables(1).rows
    ctr = 0 'counter for how many folders are within a folder to be reset
    
start:
    For x = 1 To rows.count
    On Error GoTo OnError
        If rows.count > 0 Then
          
            Set row = rows(x)
            
            If row.Range.ListFormat.ListType = wdListMixedNumbering Then 'process if row is list
                Set listPar = row.Range.ListParagraphs
                
                If listPar.count > 0 And (isFirst Or isFolderFirst) Then
                    Set par = listPar(1)
                    Set r = par.Range
                    r.Select
                    r.End = r.start
                    r.Select
                    
                    If isFirst Or (isFolderFirst And prevColWid <> row.Cells(1).Width) Then 'if previous cell width is not the same, assume that it is in different level
                        cont = True
                    Else: cont = False
                    End If
                        
                    If cont And ctr > 0 Then
                        Set lt = r.ListFormat.ListTemplate ' get the applied list template to maintain format
                        
                        ' reapply the list template but set ContinuePreviousList to false to reset
                        r.ListFormat.ApplyListTemplate ListTemplate:=lt, ContinuePreviousList:= _
                        False, ApplyTo:=wdListApplyToWholeList, DefaultListBehavior:= _
                        wdWord10ListBehavior
                    
                        If ctr > 0 Then
                            ctr = ctr - 1
                        End If
                    End If
                    
                    If isFolderFirst Then
                        prevColWid = row.Cells(1).Width
                    Else: cont = False
                    End If
                    
                    isFirst = False
                    
                End If
            Else
                If isFirst Then 'row x-1 contains folder first
                    isFolderFirst = True 'flag first folder
                    ctr = ctr + 1
                    GoTo OnContinue
                Else
                    isFolderFirst = False
                End If
    
                isFirst = True 'flag first element
                ctr = ctr + 1
            End If
         End If
OnContinue:
    Next x
OnError:
    If x < rows.count Then
        x = x + 1
        GoTo start
    Else
        Exit Sub
    End If


End Sub

Public Function GetPDFDocsPrintSetting(ByVal appSettingName As String) As String

    Dim appSettingValue As String

    Dim settingDoc As Document
    Dim appDir As String
    Dim appSettingsFile As String
    Dim xNode As xmlNode
    Dim bFound As Boolean
    
On Error GoTo OnError

    appDir = BPEnvironment.GetUserAppDataDirectory()
    If (appDir <> "") Then
        appSettingsFile = GetPDFDocsSettingsFile

        If (dir(appSettingsFile) = "") Then
            Exit Function
        End If
        
        Set settingDoc = Documents.Open(fileName:=appSettingsFile, ReadOnly:=True, Format:=wdOpenFormatXML, Visible:=False)

        If (settingDoc Is Nothing) Then
            ' Do not raise error and assume default setting, the calling method should assume default.
            Exit Function
        ElseIf settingDoc.XMLNodes.count = 0 Then
            ' close the xml document
            settingDoc.Close savechanges:=False
           
            Set settingDoc = Nothing
            ' Unfortunately we could not read the xml file, we have to try to read it as text file
            bFound = IsPrintSettingFound(appSettingsFile, appSettingName, appSettingValue)
            If (Not bFound) Then
                ' We don't want to raise an error as if the default value is set and the 'eforce' attribute is false the XML setting will not
                ' exist in the XML file.
                
                ' when working with temp document, call activate to make the temp document the ActiveDocument becaues the temp document is invisible
                ' so when settingDoc is closed, the last visible document will be used instead of the temp document
                If bUseTempDocument And Not tempDocument Is Nothing Then
                    tempDocument.Activate
                End If
                
                Exit Function
            End If
        Else
            Set xNode = settingDoc.SelectSingleNode("//pdfDocsAppSettings/" & appSettingName)

            If Not (xNode Is Nothing) Then
                appSettingValue = xNode.text
            Else
                ' close the xml document
                settingDoc.Close savechanges:=False
                Set settingDoc = Nothing
                
                ' when working with temp document, call activate to make the temp document the ActiveDocument becaues the temp document is invisible
                ' so when settingDoc is closed, the last visible document will be used instead of the temp document
                If bUseTempDocument And Not tempDocument Is Nothing Then
                    tempDocument.Activate
                End If
                
                ' Do not raise error and assume default setting, the calling method should assume default.
                Exit Function
            End If
        End If
    Else
        ' Do not raise error and assume default setting, the calling method should assume default.
        Exit Function
    End If

OnError:
    If Not (settingDoc Is Nothing) Then
        ' close the document
        settingDoc.Close savechanges:=False
    End If

    If (Err <> 0) Then
        ' re-raise the error
        Err.Raise Number:=Err.Number, Source:=Err.Source, Description:=Err.Description
    End If
    
     ' when working with temp document, call activate to make the temp document the ActiveDocument becaues the temp document is invisible
     ' so when settingDoc is closed, the last visible document will be used instead of the temp document
     If bUseTempDocument And Not tempDocument Is Nothing Then
        tempDocument.Activate
     End If

    GetPDFDocsPrintSetting = appSettingValue
End Function
Function IsPrintSettingFound(ByVal settingsFile As String, ByVal appSettingName As String, ByRef appSettingValue As String) As Boolean
    Dim bFound As Boolean
    Dim fileHandle As Integer
    Dim setting As String
    Dim index As Integer
    Dim endIndex As Integer

    bFound = False
    fileHandle = -1

On Error GoTo OnError
    ' Get the next file number
    fileHandle = FreeFile()
    ' Open the text file
    Open settingsFile For Input As fileHandle

    Do While Not EOF(fileHandle)
        ' read line by line
        Line Input #fileHandle, setting
        ' remove the leading and trailing whitespace characters
        setting = Trim$(setting)
        index = InStr(1, setting, "<" & appSettingName, vbTextCompare)
        If (index > 0) Then
            endIndex = InStr(1, setting, "</" & appSettingName & ">", vbTextCompare)
            If (endIndex > 0) Then
                'index = Len("<" & appSettingName & ">")
                index = InStr(setting, ">")
                appSettingValue = Trim$(Mid$(setting, index + 1, endIndex - index - 1))
                bFound = True
                Exit Do
            End If
            Exit Do
        Else
            index = InStr(1, setting, "<" & appSettingName & " />", vbTextCompare)
            If (index > 0) Then
                bFound = True
            Else
                index = InStr(1, setting, "<" & appSettingName & "/>", vbTextCompare)
                If (index > 0) Then
                    bFound = True
                End If
            End If
            If (bFound) Then
                ' Found the appSettingValue but empty
                appSettingValue = ""
                Exit Do
            End If
        End If
    Loop

OnError:
    If (fileHandle <> -1) Then
        Close fileHandle
    End If
    IsPrintSettingFound = bFound
End Function
Function IsValidVersion() As Boolean
    Dim version As String

    version = Application.version

    ' is 2000? version 9
    If (Left(version, 1) = "9") Then
        IsValidVersion = False
        Exit Function
    End If

    ' is 2002? version 10
    If (Left(version, 2) = "10") Then
        IsValidVersion = False
        Exit Function
    End If

    ' then it should be valid version as compareDocs doesn't support Word97 or earlier
    IsValidVersion = True

End Function

Sub LoadXML()

Dim xmlPath As String
Dim xmlDoc As MSXML2.DOMDocument
Dim bookmarkSettingsElement As MSXML2.IXMLDOMElement
Dim mainNode As MSXML2.IXMLDOMElement

Set xmlDoc = New MSXML2.DOMDocument
xmlPath = "C:\Users\jayson.cuadro\AppData\Roaming\DocsCorp\pdfDocs\pdfDocsMRU.xml"

If xmlDoc.Load(xmlPath) Then
'    Set bookmarkSettingsElement = xmlDoc.createElement("WordBookmarkStyles")
'    Dim elem1 As MSXML2.IXMLDOMElement
'    Dim elem2 As MSXML2.IXMLDOMElement
'    Dim elem3 As MSXML2.IXMLDOMElement
'
'    Set elem1 = xmlDoc.createElement("BookmarkStyle")
'    elem1.Text = "Heading 1"
'
'    Set elem2 = xmlDoc.createElement("BookmarkStyle")
'    elem2.Text = "No List"
'
'    Set elem3 = xmlDoc.createElement("BookmarkStyle")
'    elem3.Text = "Normal"
'
'    Set mainNode = xmlDoc.ChildNodes(1)
'    bookmarkSettingsElement.appendChild elem1
'    bookmarkSettingsElement.appendChild elem2
'    bookmarkSettingsElement.appendChild elem3
'
'    mainNode.appendChild bookmarkSettingsElement

    Dim bookmarkNode As MSXML2.IXMLDOMNode
    For Each bookmarkNode In xmlDoc.ChildNodes(1).ChildNodes
        If bookmarkNode.nodeName = "WordBookmarkStyles" Then
            Dim bookmarkStyles As MSXML2.IXMLDOMNode
            If bookmarkNode.HasChildNodes Then
                For Each bookmarkStyles In bookmarkNode.ChildNodes
                    MsgBox bookmarkStyles.text
                Next
            End If
        End If
    Next
    
    
Else
    ' failed to load the document
End If
' Save and Close XML document
xmlDoc.Save (xmlPath)
Set xmlDoc = Nothing
End Sub

Public Sub AgendaConvertToPDF()
DoProcessAgenda True
End Sub

Public Sub AgendaNativeFormat()
DoProcessAgenda False
End Sub

Sub DoProcessAgenda(ByVal convertAll As Boolean)
    Dim outputDir As String
    Dim logFilePath As String
    Dim logFileTempPath As String
    Dim CurrentDocument As Document
    Dim tmpDocument As Document
    Dim isSuccess As Boolean
    Dim tempDir As String
    Dim defaultScreenUpdating As Boolean
    
     If dir(ActiveDocument.FullName) = "" Then
        MsgBox strCreateAgendaMsgTemplateNotSaved, vbOKOnly, strCreateAgendaProgressTitle
        GoTo OnEnd
    End If
    g_Terminate = False
    
    iSize = 0
    ReDim extractedLinksCollection(0) As String
    
    Set g_AppSettings = New BPAppSettings
    Set g_ProgressForm = New frmProgress
    g_ProgressForm.InitUI strCreateAgendaProgressTitle, "", "", "Cancel", "", "", "", "", "", "", "", True
    
    g_ProgressForm.SetProgress BPProgressStart, ""
    g_ProgressForm.show FORMSHOWCONSTANT_MODELESS
    
    defaultScreenUpdating = Application.ScreenUpdating
    Application.ScreenUpdating = False
    Options.MapPaperSize = False
    ActiveDocument.ActiveWindow.View.Type = WdViewType.wdPrintView
    ActiveDocument.ActiveWindow.View.Zoom.Percentage = 100
    ActiveDocument.ActiveWindow.View.ShowHiddenText = ActiveDocument.ActiveWindow.Application.Options.PrintHiddenText
    ActiveWindow.ActivePane.View.ShowAll = False
    
    Set CurrentDocument = ActiveDocument
    
    On Error Resume Next
    CurrentDocument.Repaginate
    
    Set tmpDocument = Application.Documents.Add(ActiveDocument.FullName, Visible:=False)
    
    outputDir = CreateOutputFolder(CurrentDocument.path, Not convertAll)
    tempDir = BPEnvironment.GetNewTempDir

    logFileTempPath = CurrentDocument.path + "\Logs\temp.txt"
    logFilePath = CurrentDocument.path + "\Logs\" + Mid(outputDir, InStrRev(outputDir, "\") + 1) + "_Errors.log"
    
        'Delete log files if existing
    If FileOrDirExists(logFileTempPath) Then _
        FileDelete logFileTempPath
    If FileOrDirExists(logFilePath) Then _
        FileDelete logFilePath
    
    'tmpDocument.SaveAs2 tempDir + ActiveDocument.Name, FileFormat:=WdSaveFormat.wdFormatDocumentDefault
    'tmpDocument.SaveAs2 currentDocument.path + "\abc." + ActiveDocument.Name
    tmpDocument.Final = False
    'Application.Documents.Open tmpDocument.FullName, ReadOnly:=True
    tmpDocument.Activate
    
    'Iterate and Extract Table Hyperlinks
    If CurrentDocument.Tables.count > 0 Then
        Dim tbl As Table
        Dim tempTbl As Table
        For t = 1 To CurrentDocument.Tables.count
            Set tbl = CurrentDocument.Tables(t)
            Set tempTbl = tmpDocument.Tables(t)
            For i = 1 To tbl.rows.count
                Set currCell = tbl.Cell(i, 2)
                Set tempCell = tempTbl.Cell(i, 2)
                If currCell.Range.hyperLinks.count > 0 Then
                    g_ProgressForm.SetProgress BPProgressIncrement, strCreateAgendaProgressCreateLinks
                    isSuccess = CheckHyperLinks(CurrentDocument, currCell, currCell.Range, tempCell.Range, outputDir, convertAll, tempDir, logFileTempPath)
                    'isSuccess = CheckHyperLinks(tmpDocument, currCell, currCell.range, tempCell.range, outputDir, False, tempDir, logFileTempPath)
                    If Not isSuccess Then GoTo OnEnd
                End If
            Next i
        Next t
    End If
    
    If Not g_Terminate Then
        Set settings = New BPSettings
        With settings
            .File = BPEnvironment.GetSettingsFile
            .DeserializeFromFile
        End With
           
        settings.UniqueTempDirectory = BPEnvironment.GetNewTempDir
        
        Dim bookmarkfile As String: bookmarkfile = settings.UniqueTempDirectory + "\" + GetFilenameWithoutExtension(CurrentDocument.Name) + EXT_BOOKMARKS
        Dim hyperlinkfile As String: hyperlinkfile = settings.UniqueTempDirectory + "\" + GetFilenameWithoutExtension(CurrentDocument.Name) + EXT_LINKS
        
        'tmpDocument.Save
        BPBookmarksStyles.ActualPageCount = tmpDocument.Range.Information(wdNumberOfPagesInDocument)
        
        tmpDocument.Activate
        
        GenerateLinks = GenerateHyperlinks(hyperlinkfile, isCreatingAgenda:=True)
        GenerateBookmarks = GenerateBookmarksFromStyles(bookmarkfile, IsAgenda:=True)
    End If

    If Not g_Terminate Then
        Dim outputPSFile As String: outputPSFile = ConvertToPDF(tmpDocument, CurrentDocument.Name)
    End If
    
    g_ProgressForm.SetProgress BPProgressEnd, ""
    g_ProgressForm.Hide
    
    'FinalizeAgendaFile tempDir, outputDir, tmpDocument, logFilePath, logFileTempPath
    FinalizeAgendaFile tempDir, outputDir, CurrentDocument, logFilePath, logFileTempPath, outputPSFile, bookmarkfile, hyperlinkfile
    If Not tmpDocument Is nothin Then
        tmpDocument.Close savechanges:=False
        Set tmpDocument = Nothing
    End If
    'Dim tempPath As String: tempPath = tmpDocument.FullName
    'tmpDocument.Close savechanges:=True
    'FileCopy tempPath, tempDir + "\" + currentDocument.Name
    'FileDelete tempPath
    'FinalizeAgendaFile tempDir, outputDir, tempPath, logFilePath, logFileTempPath
    Application.ScreenUpdating = defaultScreenUpdating
OnEnd:
    Exit Sub
End Sub

Sub FinalizeAgendaFile(ByVal tempDir As String, ByVal outputDir As String, ByVal thisDocument As Document, ByVal logErrorFile As String, ByVal logErrorTempFile As String, ByVal PSFile As String, ByVal bookmarkfile As String, ByVal hyperlinkfile As String)
'Sub FinalizeAgendaFile(ByVal tempDir As String, ByVal outputDir As String, ByVal origDocPath As String, ByVal logErrorFile As String, ByVal logErrorTempFile As String)
On Error GoTo ErrorSection
    Dim documentCopy As Document
    Dim outputAgendaFile As String
    Dim origDocPath As String
    Dim success As Boolean
    
    If Not g_Terminate Then
        origDocPath = thisDocument.FullName
        
        'tmpDocument.Close savechanges:=True
        
        If Right(tempDir, 1) = "\" Then
            tempDir = Left(tempDir, Len(tempDir) - 1)
        End If
        
        success = LaunchPDFCMDEXE(tempDir, outputDir, PSFile, bookmarkfile, hyperlinkfile)
        
        Dim fileName As String
        Dim outputFileName As String
        Dim notepadPath As String
            
        fileName = GetFileName(origDocPath)
        fileName = GetFilenameWithoutExtension(fileName)
        fileName = fileName & EXT_PDF
        outputFileName = outputDir & "\" & fileName
        
        CreateAutoRunFile outputDir, fileName
        
        If FileOrDirExists(logErrorTempFile) Then _
            FinalizeAgendaLogErrors logErrorFile, logErrorTempFile
        
        If success Then
            If Not FileOrDirExists(logErrorFile) Then
                MsgBox strCreateAgendaMsgSuccess, vbOKOnly, strCreateAgendaProgressTitle
            Else
                MsgBox strCreateAgendaMsgFailed, vbOKOnly, strCreateAgendaProgressTitle
                notepadPath = Environ("SystemRoot") + "\system32\notepad.exe"
                If FileOrDirExists(notepadPath) Then _
                    Shell notepadPath + " " + logErrorFile, vbNormalFocus
            End If
        End If
        
        'Delete temp Log file
        If FileOrDirExists(logErrorTempFile) Then _
            FileDelete logErrorTempFile
    End If
ErrorSection:
End Sub

Function LaunchPDFCMDEXE(ByVal inputDir As String, ByVal outputDir As String, Optional ByVal PSFile As String = "", _
                         Optional ByVal BMFile As String = "", Optional ByVal HPFile As String = "", Optional ByVal IsAgenda As Boolean = True, _
                         Optional ByVal CreateBookmarksUsingHeadingsAndHyperlinksSettings As Boolean = False, Optional waitOnReturnParam As Boolean = False) As Boolean
    Dim args As String
    Dim shellObj As Object
    Dim waitOnReturn As Boolean: waitOnReturn = waitOnReturnParam
    Dim windowStyle As Integer: windowStyle = 1
    Dim errorCode As Long
    Dim success As Boolean
    
    Set shellObj = CreateObject("WScript.Shell")
    
    ' Chr(34) - Quotation
    If Not inputDir = "" Then
        args = "-inputpath:" & Chr(34) & inputDir & Chr(34)
    End If
    
    If Not outputDir = "" Then
        args = args & " " & "-outputpath:" & Chr(34) & outputDir & Chr(34)
    End If
    
    If IsAgenda Then
        args = args & " " & "-moveunconverted:true" & " -agenda:" & Chr(34) & PSFile & Chr(34) & " -agendaBookmark:" & Chr(34) & BMFile & Chr(34) & " -agendaHyperlink:" & Chr(34) & HPFile & Chr(34)
    End If
    
    If CreateBookmarksUsingHeadingsAndHyperlinksSettings Then
        ' Set the Document embedded dictionary DisplayDocTitle to False (0). This will default the pdfDocs Windows Title into Filename
        ' By default, MS Word generated PDF sets the DisplayDocTitle to True (1) which will display the document Title into the Windows Title in pdfDocs.
        args = args & " " & "-setPDFDefaultDisplayDocTitle:False"
    End If
    
    'args = "-inputpath:" & Chr(34) & inputDir & Chr(34) & " -outputpath:" & Chr(34) & outputDir & Chr(34) & " -moveunconverted:true" & " -agenda:" & Chr(34) & PSFile & Chr(34) & " -agendaBookmark:" & Chr(34) & BMFile & Chr(34) & " -agendaHyperlink:" & Chr(34) & HPFile & Chr(34)
      
    'Shell BPEnvironment.GetBPPDFCMDEXE & " " & args
    
    'errorCode = shellObj.Run(BPEnvironment.GetBPPDFCMDEXE & " " & args, windowStyle, waitOnReturn)
    errorCode = shellObj.Run(Chr(34) & BPEnvironment.GetBPPDFCMDEXE & Chr(34) & " " & args, windowStyle, waitOnReturn)
    
    If errorCode = 0 Then
       success = True
    Else
        success = False
    End If
    
    LaunchPDFCMDEXE = success
End Function

Function CheckHyperLinks(ByVal CurrentDocument As Document, ByVal tableCell As Cell, ByVal currRange As Range, ByVal targetRange As Range, ByVal outputDir As String, ByVal convertDocs As Boolean, ByVal tempDir As String, ByVal logErrorFile As String) As Boolean
    Dim linkDocument As Document
    Dim fName As String, fullFileName As String, ext As String, OutputFile As String, oldName As String
    Dim prefix As String
    Dim newName As String
    Dim num As Integer
    Dim targetEXT As String
    Dim Hyperlink As String
    Dim origFName As String
    Dim oldFullFileName As String
    Dim linkDisplay As String
    Dim currPath As String
    Dim isDirectory As Boolean
    Dim firstColRange As Range
    
    If Not g_Terminate Then
        If currRange.Information(wdWithInTable) And currRange.hyperLinks.count > 0 Then
            For i = 1 To currRange.hyperLinks.count
                On Error GoTo ContinueNext
                With currRange.hyperLinks(i)
                    fullFileName = .address
                    
                    'pound/hash sign (#) exists in the hyperlink
                    If .SubAddress <> "" Then
                        fullFileName = fullFileName + "#" + .SubAddress
                    End If
                    
                    fullFileName = URLDecode(fullFileName)
                    
                    fullFileName = Replace(fullFileName, "/", "\")
                    
                    If Right(fullFileName, 1) = "\" Then 'Directory
                        fullFileName = Left(fullFileName, Len(fullFileName) - 1)
                    End If
                    
                    fName = GetFileName(fullFileName)
                    origFName = fName
                    ext = GetFileExtension(fName)
                    fName = GetFilenameWithoutExtension(fName)
                    
                    'Processing relative path
                    currPath = CurrentDocument.path
                    Do While InStr(fullFileName, "..\") <> 0
                        currPath = GetDirectory(currPath)
                        fullFileName = currPath & Mid(fullFileName, InStr(fullFileName, "..\") + 2)
                    Loop
                    
                    If InStr(fullFileName, ":\") = 0 And Left(fullFileName, 2) <> "\\" Then _
                        fullFileName = CurrentDocument.path & "\" & fullFileName
                    
                    If InStr(fullFileName, "..\") Then _
                        fullFileName = CurrentDocument.path & Mid(fullFileName, InStr(fullFileName, "..\") + 2)
                    
                    Set firstColRange = tableCell.row.Cells(1).Range
                    prefix = Trim(BPEnvironment.ReplaceIllegalCharInFileName(Trim(firstColRange.text)))
    '                If IsNumeric(prefix) Then
    '                    num = Val(prefix)
    '                    If num < 10 Then prefix = "0" & prefix
    '                End If
    
                    If prefix = "" And firstColRange.ListParagraphs.count > 0 Then
                        If Asc(firstColRange.ListFormat.listString) <> 63 Then
                            prefix = firstColRange.ListFormat.listString
                        End If
                    End If
    
                    If Left(ext, 1) <> "." Or InStr(fullFileName, "http:\\") <> 0 Or InStr(fullFileName, "mailto:") <> 0 Then
                        linkDisplay = prefix + " " + ReplaceIllegalCharInFileName(.TextToDisplay)
                    Else
                        linkDisplay = prefix + " " + ReplaceIllegalCharInFileName(.TextToDisplay) + IIf(convertDocs, IIf(IsSupportedFile(ext), EXT_PDF, ext), ext)
                    End If
    
                    'Check for other types of hyperlinks (url/bookmark)
                    If InStr(fullFileName, "http:\\") <> 0 Then 'URL
                        LogError logErrorFile, .address, linkDisplay, "File does not exists: " + .address
                        GoTo ContinueNext
                    End If
                    If InStr(fullFileName, "mailto:") <> 0 Then 'URL
                        LogError logErrorFile, .address, linkDisplay, "File does not exists: " + .address
                        GoTo ContinueNext
                    End If
                    If .address = "" And .SubAddress <> "" Then 'Bookmark
                        LogError logErrorFile, "", linkDisplay, "File not found"
                        GoTo ContinueNext
                    End If
                        
                    'Check invalid characters
                    If BPEnvironment.IsInvalidTextCharacters(fullFileName) Then
                        LogError logErrorFile, origFName, linkDisplay, ""
                        GoTo ContinueNext
                    End If
                    
                    'Check if file exists
                    On Error GoTo BadFileError
                    Dim attrib As Integer
                    Dim isDirError As Boolean: isDirError = True
                    If Not FileOrDirExists(fullFileName) Or dir(fullFileName) = "" Then
                        LogError logErrorFile, origFName, linkDisplay, "File not found"
                        GoTo ContinueNext
                    End If
                    isDirError = False
                    
BadFileError:
                    If isDirError Then
                        LogError logErrorFile, origFName, linkDisplay, "File not found"
                        GoTo ContinueNext
                    End If
                    
                    On Error GoTo ContinueNext
                    If prefix <> "" Then
                        newName = IIf(convertDocs, tempDir, outputDir & "\") & prefix & " " & BPEnvironment.ReplaceIllegalCharInFileName(.TextToDisplay)
                    Else
                        newName = IIf(convertDocs, tempDir, outputDir & "\") & BPEnvironment.ReplaceIllegalCharInFileName(.TextToDisplay)
                    End If
                    'Max filename (including path) should not extend > 250. Comparing to 240 to give space to the extension name
                    If Len(newName) > 240 Then _
                        newName = Left(newName, 240)
                        
                    newName = newName & ext
                    
                    'Check if already exists
                    If dir(newName) <> "" Then
                        'newName = GenerateNewFileName(newName)
                        'Should not handle duplicate row items
                        LogError logErrorFile, origFName, Trim(linkDisplay), "File already exists"
                        FileDelete OutputFile
                        GoTo ContinueNext
                    End If
                    
                    On Error Resume Next
                    If convertDocs Then
                        ReDim Preserve extractedLinksCollection(iSize) As String
                        iSize = iSize + 1
                        'Dim filtered() As String: filtered = Filter(extractedLinksCollection, LCase(GetFilenameWithoutExtension(GetFileName(newName))))
                        Dim searchStr As String: searchStr = LCase(GetFilenameWithoutExtension(GetFileName(newName)))
                        Dim filtered() As String: filtered = Filter(Split("~" & Join(extractedLinksCollection, "~|~") & "~", "|"), "~" & searchStr & "~") 'Exact Match
                        If searchStr <> "" And UBound(filtered) > -1 Then
                            LogError logErrorFile, origFName, Trim(linkDisplay), "File already exists"
                            FileDelete OutputFile
                            GoTo ContinueNext
                        End If
                    End If
                    
'                    'Copy target documents to output folder
'                    outputFile = IIf(convertDocs, tempDir, outputDir) & "\" & fName & ext
'                    oldName = outputFile
'                    FileCopy fullFileName, outputFile
'                    fullFileName = tempDir & "\" & fName & ext
                    
                    Dim success As Boolean
                    
                    oldFullFileName = fullFileName
                    
                    On Error GoTo NameChanged
                    If dir(newName) = "" Then
                        'Copy target documents to output folder
                        OutputFile = IIf(convertDocs, tempDir, outputDir) & "\" & fName & ext
                        oldName = OutputFile
                        FileCopy fullFileName, newName
                        fullFileName = tempDir & "\" & fName & ext
                        
                        'Check invalid characters: newName
                        If BPEnvironment.IsInvalidTextCharacters(newName) Then
                            LogError logErrorFile, GetFileName(newName), prefix + " " + .TextToDisplay, OutputFile
                            GoTo ContinueNext
                        End If
                        
                        
                        Name OutputFile As newName
NameChanged:
                        If Err.Number = 52 Then 'Failed to copy/rename due invalid filename
                            newName = outputDir & "\" & GetFileName(OutputFile)
                            'If (convertDocs) Then
                             '   FileCopy outputFile, newName
                             '   FileDelete outputFile
                            'Else
                                FileCopy fullFileName, newName
                            'End If
                            
                            Hyperlink = GetFileName(newName)
                            targetRange.hyperLinks(i).address = Hyperlink
                            
                            If convertDocs And UCase(GetFileExtension(Hyperlink)) = EXT_PDF Then _
                                extractedLinksCollection(UBound(extractedLinksCollection)) = LCase(GetFilenameWithoutExtension(Hyperlink))
                            
                            LogError logErrorFile, origFName, linkDisplay, newName
                        Else
                            'FileDelete outputFile
                            Hyperlink = GetFileName(newName)
                            Hyperlink = GetFilenameWithoutExtension(Hyperlink)
                            
                            extractedLinksCollection(UBound(extractedLinksCollection)) = LCase(Hyperlink)
                            
                            Hyperlink = Hyperlink & IIf(convertDocs, IIf(IsSupportedFile(ext), EXT_PDF, ext), ext)
                            targetRange.hyperLinks(i).address = Hyperlink
                        End If
                        'Check for corrupted file
                        If IsOfficeDocument(ext) And convertDocs Then
                            If IsCorruptedFile(newName) Then
                                On Error GoTo ContinueNext
                                Dim outputfail As String
                                outputfail = outputDir & "\" & GetFilenameWithoutExtension(Hyperlink) & ext
                                FileCopy newName, outputfail
                                FileDelete newName
                                targetRange.hyperLinks(i).address = GetFilenameWithoutExtension(Hyperlink) & ext
                                
                                'Remove last recorded item
                                ReDim Preserve extractedLinksCollection(UBound(extractedLinksCollection) - 1)
                                
                                LogError logErrorFile, origFName, linkDisplay, outputfail
                                GoTo ContinueNext
                            End If
                        End If
                    Else
                        FileDelete fullFileName
                    End If
                        
                        'FileDelete oldName
                    'End If
                End With
                
ContinueNext:
    '        If Err.Number = 52 Then _
    '            LogError logErrorFile, origFName, linkDisplay, IIf(convertDocs, outputDir & "\" & GetFilenameWithoutExtension(GetFileName(outputFile)), outputFile)
            Next
        End If
    End If
    CheckHyperLinks = True
End Function

Function CreateOutputFolder(ByRef initialPath As String, ByVal isNative As Boolean) As String
    Dim folderName As String
    Dim subFolderPath As String
    Dim init As Integer
    Dim suffix As String
    Dim temp As String
    
    folderName = IIf(isNative, "\Native_Output", "\PDF_Output")
    subFolderPath = initialPath & folderName
    init = 2
    suffix = init
    temp = subFolderPath
    
    Do While FileOrDirExists(subFolderPath)
        suffix = IIf(init < 10, "0" & init, init)
        
        subFolderPath = temp & suffix
        init = init + 1
    Loop
    
    MkDir subFolderPath

    CreateOutputFolder = subFolderPath
End Function

Function GenerateNewFileName(ByVal filePath As String) As String
    Dim init As Integer
    Dim suffix As String
    Dim temp As String
    Dim newName As String
    Dim ext As String
    
    init = 2
    suffix = init
    newName = filePath
    temp = GetFilenameWithoutExtension(filePath)
    ext = GetFileExtension(filePath)
    
    Do While FileOrDirExists(newName)
        suffix = IIf(init < 10, "0" & init, init)
        
        newName = temp & suffix & ext
        init = init + 1
    Loop

    GenerateNewFileName = newName
End Function

Sub CreateAutoRunFile(ByVal directory As String, ByVal fileToExecute As String)
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    Dim oFile As Object
    Set oFile = fso.CreateTextFile(directory & "\Autorun.inf", True)
    oFile.WriteLine "[autorun]"
    oFile.WriteLine "shellexecute=""" & fileToExecute & """"
    oFile.Close
    Set fso = Nothing
    Set oFile = Nothing
End Sub

Function IsSupportedFile(ByVal extension As String) As Boolean
    Dim types() As Variant
    Dim filtered As Variant
    types = Array(".pdf", ".popx", ".pop", ".poptx", ".popt", ".bmp", ".jpg", ".jpeg", ".jpe", ".gif", ".tif", ".tiff", ".png", ".doc", ".docx", ".rtf", ".docm", ".dot", ".dotx", ".dotm", ".txt", ".msg", ".oft", ".eml", ".emlx", ".htm", ".mht", ".dat", ".xls", ".xlsx", ".xlsm", ".xlst", ".xltx", ".xltm", ".xlsb", ".ppt", ".pptx", ".pptm", ".pot", ".potx", ".potm")
    filtered = Filter(types, LCase(extension))
    IsSupportedFile = UBound(filtered) > -1
End Function

Function IsOfficeDocument(ByVal extension As String) As Boolean
    Dim types() As Variant
    Dim filtered As Variant
    types = Array(".doc", ".docx", ".docm", ".dot", ".dotx", ".dotm") ', ".xls", ".xlsx", ".xlsm", ".xlst", ".xltx", ".xltm", ".xlsb", ".ppt", ".pptx", ".pptm", ".pot", ".potx", ".potm")
    filtered = Filter(types, LCase(extension))
    IsOfficeDocument = UBound(filtered) > -1
End Function


Function IsCorruptedFile(ByVal officeDocFile As String) As Boolean
Dim filetoCheck As Document
Dim corrupted As Boolean
On Error GoTo ErrHandler
corrupted = False
Set filetoCheck = Documents.Open(officeDocFile, ReadOnly:=True, Visible:=False)

filetoCheck.Close savechanges:=False
Set filetoCheck = Nothing

IsCorruptedFile = False
ErrHandler:
If Err = 5792 Then IsCorruptedFile = True
End Function
