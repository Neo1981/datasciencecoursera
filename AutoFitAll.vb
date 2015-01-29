Private Sub AutoFitAll()
     
    Application.ScreenUpdating = False
    Dim wkSt As String
    Dim wkBk As Worksheet
    wkSt = ActiveSheet.Name
    For Each wkBk In ActiveWorkbook.Worksheets
        On Error Resume Next
        wkBk.Activate
        Cells.EntireColumn.AutoFit
    Next wkBk
    Sheets(wkSt).Select
    Application.ScreenUpdating = True
     
End Sub
