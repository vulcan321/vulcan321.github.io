how to get bookmark's position relative to page

Here's an example of how to do this:

```vb
Sub GetBookmarkInfo()
    Dim bm As Bookmark
    For Each bm In ActiveDocument.Bookmarks
        Debug.Print "Bookmark Name: " & bm.Name
        Debug.Print "Bookmark Range: " & bm.Range.Text
        Debug.Print "Bookmark Start: " & bm.Start
        Debug.Print "Bookmark End: " & bm.End
        Debug.Print "Bookmark Column Index: " & bm.Column
        Debug.Print "Bookmark Story Type: " & bm.StoryType
        Debug.Print "Bookmark ID: " & bm.ID
        Debug.Print "Bookmark Reference: " & bm.Reference
    Next bm
End Sub
```
This macro loops through all the bookmarks in the active document and prints out their detailed information in the Immediate Window. The bm.Name property returns the name of the bookmark, bm.Range.Text returns the text of the bookmark's range, bm.Start and bm.End return the character positions of the bookmark's start and end, bm.Column returns the column index of the bookmark, bm.StoryType returns the type of story (main text, header, footer, footnote, etc.) that the bookmark is associated with, bm.ID returns the ID of the bookmark, and bm.Reference returns the reference of the bookmark.
You can modify this macro to suit your specific needs, such as searching for a specific bookmark by name or performing some operation on the bookmark's range.


Here's an example of how to do this:

```vb
Sub GetBookmarkPosition()
    Dim bm As Bookmark
    For Each bm In ActiveDocument.Bookmarks
        Debug.Print "Bookmark Name: " & bm.Name
        Debug.Print "Bookmark Page Number: " & bm.Range.Information(wdActiveEndPageNumber)
        Debug.Print "Bookmark Top Position: " & bm.Range.Information(wdVerticalPositionRelativeToPage)
        Debug.Print "Bookmark Left Position: " & bm.Range.Information(wdHorizontalPositionRelativeToPage)
    Next bm
End Sub
```
This macro loops through all the bookmarks in the active document and prints out their position relative to the page in the Immediate Window. The bm.Range.Information(wdActiveEndPageNumber) property returns the page number that the bookmark is on, while bm.Range.Information(wdVerticalPositionRelativeToPage) and bm.Range.Information(wdHorizontalPositionRelativeToPage) return the top and left positions of the bookmark relative to the page, respectively.
Note that the position is returned in points, which is a unit of measurement in Word. You can convert this to other units of measurement such as inches or centimeters if necessary.