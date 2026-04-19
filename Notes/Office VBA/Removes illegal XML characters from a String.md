[http://allen-conway-dotnet.blogspot.com/2009/10/how-to-strip-illegal-xml-characters.html](http://allen-conway-dotnet.blogspot.com/2009/10/how-to-strip-illegal-xml-characters.html)

Here is the VB.NET working version of removing illegal XML characters from a String:

```
    Public Shared Function RemoveIllegalXMLCharacters(ByVal Content As String) As String

        'Used to hold the output.
        Dim textOut As New StringBuilder()
        'Used to reference the current character.
        Dim current As Char
        'Exit out and return an empty string if nothing was passed in to method
        If Content Is Nothing OrElse Content = String.Empty Then
            Return String.Empty
        End If

        'Loop through the lenght of the content (1) character at a time to see if there
        'are any illegal characters to be removed:
        For i As Integer = 0 To Content.Length - 1
            'Reference the current character
            current = Content(i)
            'Only append back to the StringBuilder valid non-illegal characters
            If (AscW(current) = &H9 OrElse AscW(current) = &HA OrElse AscW(current) = &HD) _
               OrElse ((AscW(current) >= &H20) AndAlso (AscW(current) <= &HD7FF)) _
               OrElse ((AscW(current) >= &HE000) AndAlso (AscW(current) <= &HFFFD)) _
               OrElse ((AscW(current) >= &H10000) AndAlso (AscW(current) <= &H10FFFF)) Then
                textOut.Append(current)
            End If
        Next

        'Return the screened content with only valid characters
        Return textOut.ToString()

    End Function
```