153

This answer is not useful

Save this answer.

[](https://stackoverflow.com/posts/2631691/timeline)

Show activity on this post.

```vbnet
If obj Is Nothing Then
    ' need to initialize obj: '
    Set obj = ...
Else
    ' obj already set / initialized. '
End If
```

___

Or, if you prefer it the other way around:

```vbnet
If Not obj Is Nothing Then
    ' obj already set / initialized. '
Else
    ' need to initialize obj: '
    Set obj = ...
End If
```

[Share](https://stackoverflow.com/a/2631691/19688229 "Short permalink to this answer")

Share a link to this answer (Includes your user id)

Copy link[CC BY-SA 2.5](https://creativecommons.org/licenses/by-sa/2.5/ "The current license for this post: CC BY-SA 2.5")

[Edit](https://stackoverflow.com/posts/2631691/edit "Revise and improve this post")

Follow