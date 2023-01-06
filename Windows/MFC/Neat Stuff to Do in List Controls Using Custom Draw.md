# Neat Stuff to Do in List Controls Using Custom Draw


Using the custom-draw features in version 4.70 of the common controls to customise the look and feel of list controls

-   [Download files - 27.6 KB](https://www.codeproject.com/KB/list/lvcustomdraw/LVCustomDraw.zip)

## Introduction

Custom draw can be thought of as a light-weight, easier-to-use version of owner draw. The ease of use comes from the fact that there is only one message to handle (`NM_CUSTOMDRAW`) and you can get Windows to do some of the work for you, so you don't have to go through all the grunt work that's part of owner-drawing.

This article will focus on using custom draw with a list view control, partly because I've done a few custom-drawn list controls in my own work and I'm familiar with the process; but also because it's possible to do some neat effects with very little code.

## The Basics of Custom Draw

I will try my best to summarize the custom draw process here, without simply restating the documentation. For these examples, assume that you have a list control in a dialog and the list is in report view mode with multiple columns.

### Hooking Up a Custom Draw Message Map Entry

Custom draw is a process similar to using callbacks. Windows notifies your program, via a notification message, at certain points in the process of drawing the list control. You can choose to ignore the notifications altogether (in which case you'll see the standard list control), process some part of the drawing yourself (for simple effects) or even draw the control yourself (just as when owner-drawing a control). The real selling point is that you can choose to respond to only some of the notifications if you so wish. That way, you only have to paint the parts you need to and Windows will do the rest.

Let's say that you want to add custom draw to the existing list control to give it some flare. Assuming you have the right common controls DLL on the system, Windows is already sending `NM_CUSTOMDRAW` messages your way; you just have to add a handler for the message to start using custom draw. The handler will look like this:

C++

```cpp
ON_NOTIFY ( NM_CUSTOMDRAW, IDC_MY_LIST, OnCustomdrawMyList )
```

...and the prototype looks like this:

C++

```cpp
afx_msg void OnCustomdrawMyList ( NMHDR* pNMHDR, LRESULT* pResult );
```

This tells MFC that you want to handle a `WM_NOTIFY` message sent from your list control (whose ID is `IDC_MY_LIST`) when the notification code is `NM_CUSTOMDRAW`. The handler is a function called `OnCustomdrawMyList`. If you have a CListCtrl-derived class that you want to add custom draw to, you can use `ON_NOTIFY_REFLECT` instead:

C++

```cpp
ON_NOTIFY_REFLECT ( NM_CUSTOMDRAW, OnCustomdraw )
```

The message handler has the same prototype as above, but goes in your derived class instead.

### Custom Draw Stages

Custom draw breaks the drawing process into two parts: erasing and painting. Windows may send `NM_CUSTOMDRAW` messages at the beginning and end of each part. So in total that's four messages. However, your application may actually receive as few as one or many more than four messages, depending on what you tell Windows you want. The times when a notification may be sent are called "draw stages." You need to have a good grasp of this concept, since it's used throughout custom draw. So, to summarize that rather dry paragraph, you may be notified at the following times (or stages):

-   Before an item is painted
-   After an item is painted
-   Before an item is erased
-   After an item is erased

Not all of those are equally useful and, in practice, I have not yet needed to handle more than one stage. In fact, while doing some experimenting in the process of writing this article, I was unable to get Windows to send either the pre-erase or post-erase messages! So don't let this section intimidate you.

### Responding to NM\_CUSTOMDRAW Messages

The value you return from your custom draw handler is a vitally important piece of information, as it tells Windows how much of the drawing process you have done and, indirectly, how much you want Windows itself to do. There are five responses you can send from your custom draw handler:

1.  I don't want to do anything now; Windows should paint the control or item itself as if there were no custom draw handler.
2.  I changed the font being used by the control; Windows must recalculate the `RECT` of the item being drawn.
3.  I painted the entire control or item; Windows should not do anything more with the control or item.
4.  I want to receive additional `NM_CUSTOMDRAW` messages during the draw stages of each item in the list.
5.  I want to receive additional `NM_CUSTOMDRAW` messages during the draw stages of each sub-item in the row currently being drawn.

Notice that the phrase "control or item" appears often. Remember that I said you may receive more than four `NM_CUSTOMDRAW` messages? This is where that happens. The first `NM_CUSTOMDRAW` you receive applies to the entire control. If you return response 4 above (requesting notifications on a per-item basis), then you will receive messages as each item (row) goes through its drawing stages. And if you then return response 5, you'll get even more messages as each sub-item (column) goes through its drawing stages.

In report-mode list controls, you can use any of those responses, depending on what kind of effect you want to achieve. I'll present some examples of how to respond to `NM_CUSTOMDRAW` messages a little later.

### Information Provided by NM\_CUSTOMDRAW Messages

The `NM_CUSTOMDRAW` message passes your handler a pointer to an `NMLVCUSTOMDRAW` struct, which contains the following information:

-   The window handle of the control
-   The ID of the control
-   The draw stage the control is currently in
-   The handle of a device context you should use if you perform any drawing
-   The `RECT` of the control, item, or sub-item being drawn
-   The item number (index) of the item being drawn
-   The sub-item number (index) of the sub-item being drawn
-   Flags indicating the state of the item being drawn (selected, grayed, etc.)
-   The `LPARAM` data of the item being drawn, as set by `CListCtrl::SetItemData`

Any of those items may be important depending on the effect you're going for, but you'll always use the draw stage and usually the device context. The item indexes and `LPARAM` are often very useful as well.

## A Simple Example

OK, time to actually see some code after all the boring details. The first example will be pretty simple, and will just change the color of the text in the control, rotating between red, green, and blue. This involves four steps:

1.  Handling `NM_CUSTOMDRAW` during the pre-paint stage for the control
2.  Telling Windows we want to get `NM_CUSTOMDRAW` messages for each item
3.  Handling the subsequent `NM_CUSTOMDRAW` messages sent for each item.
4.  Setting the text color for each item.

Here's the handler:

C++

```cpp
void CMyDlg::OnCustomdrawMyList ( NMHDR* pNMHDR, LRESULT* pResult )
{
NMLVCUSTOMDRAW* pLVCD = reinterpret_cast<NMLVCUSTOMDRAW*>( pNMHDR );

    // Take the default processing unless we 
    // set this to something else below.
    *pResult = CDRF_DODEFAULT;

    // First thing - check the draw stage. If it's the control's prepaint
    // stage, then tell Windows we want messages for every item.

    if ( CDDS_PREPAINT == pLVCD->nmcd.dwDrawStage )
        {
        *pResult = CDRF_NOTIFYITEMDRAW;
        }
    else if ( CDDS_ITEMPREPAINT == pLVCD->nmcd.dwDrawStage )
        {
        // This is the prepaint stage for an item. Here's where we set the
        // item's text color. Our return value will tell Windows to draw the
        // item itself, but it will use the new color we set here.
        // We'll cycle the colors through red, green, and light blue.

        COLORREF crText;

        if ( (pLVCD->nmcd.dwItemSpec % 3) == 0 )
            crText = RGB(255,0,0);
        else if ( (pLVCD->nmcd.dwItemSpec % 3) == 1 )
            crText = RGB(0,255,0);
        else
            crText = RGB(128,128,255);

        // Store the color back in the NMLVCUSTOMDRAW struct.
        pLVCD->clrText = crText;

        // Tell Windows to paint the control itself.
        *pResult = CDRF_DODEFAULT;
        }
}
```

The result of this code is shown below. See how each row has the color we told Windows to use? Cool, and all that with just a couple of if statements!

![ [sample list view 1 - 3K] ](https://www.codeproject.com/KB/list/lvcustomdraw/lvcustomdraw1.gif)

One thing to keep in mind is you must always check the draw stage before doing anything else, because your handler will receive many messages, and the draw stage determines what actions your code takes.

## A Little Less Simple Example

The next sample shows how to handle custom draw for sub-items (that is, the columns). Our handler will set the text and cell background colors, but it won't be much more complex than the previous one; there's just one additional if block. The steps involved when dealing with sub-items are:

1.  Handling `NM_CUSTOMDRAW` during the pre-paint stage for the control
2.  Telling Windows we want to get `NM_CUSTOMDRAW` messages for each item
3.  When one of those messages comes in, tell Windows we want to get `NM_CUSTOMDRAW` messages during each sub-item's pre-paint stage.
4.  Set the text and background colors each time a subsequent message arrives for a sub-item.

Note that we will get an `NM_CUSTOMDRAW` message for each item as a whole, and another one for sub-item 0 (the first column). Here's the code:

C++


```cpp
void CMyDlg::OnCustomdrawMyList ( NMHDR* pNMHDR, LRESULT* pResult )
{
NMLVCUSTOMDRAW* pLVCD = reinterpret_cast<NMLVCUSTOMDRAW*>( pNMHDR );

    // Take the default processing unless 
    // we set this to something else below.
    *pResult = CDRF_DODEFAULT;

    // First thing - check the draw stage. If it's the control's prepaint
    // stage, then tell Windows we want messages for every item.

    if ( CDDS_PREPAINT == pLVCD->nmcd.dwDrawStage )
        {
        *pResult = CDRF_NOTIFYITEMDRAW;
        }
    else if ( CDDS_ITEMPREPAINT == pLVCD->nmcd.dwDrawStage )
        {
        // This is the notification message for an item.  We'll request
        // notifications before each subitem's prepaint stage.

        *pResult = CDRF_NOTIFYSUBITEMDRAW;
        }
    else if ( (CDDS_ITEMPREPAINT | CDDS_SUBITEM) == pLVCD->nmcd.dwDrawStage )
        {
        // This is the prepaint stage for a subitem. Here's where we set the
        // item's text and background colors. Our return value will tell 
        // Windows to draw the subitem itself, but it will use the new colors
        // we set here.
        // The text color will cycle through red, green, and light blue.
        // The background color will be light blue for column 0, red for
        // column 1, and black for column 2.
    
        COLORREF crText, crBkgnd;
        
        if ( 0 == pLVCD->iSubItem )
            {
            crText = RGB(255,0,0);
            crBkgnd = RGB(128,128,255);
            }
        else if ( 1 == pLVCD->iSubItem )
            {
            crText = RGB(0,255,0);
            crBkgnd = RGB(255,0,0);
            }
        else
            {
            crText = RGB(128,128,255);
            crBkgnd = RGB(0,0,0);
            }

        // Store the colors back in the NMLVCUSTOMDRAW struct.
        pLVCD->clrText = crText;
        pLVCD->clrTextBk = crBkgnd;

        // Tell Windows to paint the control itself.
        *pResult = CDRF_DODEFAULT;
        }
}
```

The resulting list is shown below:

![ [sample list view 2 - 3K] ](https://www.codeproject.com/KB/list/lvcustomdraw/lvcustomdraw2.gif)

A couple of things to note here:

-   The `clrTextBk` color is painted in just the column. The area to the right of the last column and below the last row still gets the control's background color.
-   While I was reviewing the docs, I read the page titled "`NM_CUSTOMDRAW` (list view)" and it says that you can return `CDRF_NOTIFYSUBITEMDRAW` from the very first custom draw message, without having to handle the `CDDS_ITEMPREPAINT` draw stage. I tested this, however, and it did not work. You do in fact need to handle the `CDDS_ITEMPREPAINT` stage.

## Handling the Post-paint Draw Stage

So far, the examples have handled the pre-print stage, to change the appearance of the list items when Windows draws them. However, during the pre-paint stage, your options are limited to just changing the color or appearance of the text. If you want to change how the icon is drawn, you can either draw the entire item during the pre-paint stage (overkill), or do custom drawing during the post-paint stage. When you do custom drawing during the post-paint stage, your custom draw handler is called after Windows has drawn the entire item or sub-item, and you can do any additional drawing you want to.

In this example, I will create a list control where the icons of the selected items do not change color. The steps involved are:

1.  Handling `NM_CUSTOMDRAW` during the pre-paint stage for the control
2.  Telling Windows we want to get `NM_CUSTOMDRAW` messages for each item
3.  When one of those messages comes in, tell Windows we want to get an `NM_CUSTOMDRAW` message during the item's post-paint stage.
4.  Redraw the icons when necessary each time a subsequent message arrives for an item.

C++

```cpp
void CMyDlg::OnCustomdrawMyList ( NMHDR* pNMHDR, LRESULT* pResult )
{
NMLVCUSTOMDRAW* pLVCD = reinterpret_cast<NMLVCUSTOMDRAW*>( pNMHDR );

    *pResult = 0;

    // If this is the beginning of the control's paint cycle, request
    // notifications for each item.

    if ( CDDS_PREPAINT == pLVCD->nmcd.dwDrawStage )
        {
        *pResult = CDRF_NOTIFYITEMDRAW;
        }
    else if ( CDDS_ITEMPREPAINT == pLVCD->nmcd.dwDrawStage )
        {
        // This is the pre-paint stage for an item.  We need to make another
        // request to be notified during the post-paint stage.

        *pResult = CDRF_NOTIFYPOSTPAINT;
        }
    else if ( CDDS_ITEMPOSTPAINT == pLVCD->nmcd.dwDrawStage )
        {
        // If this item is selected, re-draw the icon in its normal
        // color (not blended with the highlight color).

        LVITEM rItem;
        int    nItem = static_cast<int>( pLVCD->nmcd.dwItemSpec );

        // Get the image index and state of this item.  Note that we need to
        // check the selected state manually.  The docs _say_ that the
        // item's state is in pLVCD->nmcd.uItemState, but during my testing
        // it was always equal to 0x0201, which doesn't make sense, since
        // the max CDIS_* constant in commctrl.h is 0x0100.

        ZeroMemory ( &rItem, sizeof(LVITEM) );
        rItem.mask  = LVIF_IMAGE | LVIF_STATE;
        rItem.iItem = nItem;
        rItem.stateMask = LVIS_SELECTED;
        m_list.GetItem ( &rItem );

        // If this item is selected, redraw the icon with its normal colors.
        if ( rItem.state & LVIS_SELECTED )
            {
            CDC*  pDC = CDC::FromHandle ( pLVCD->nmcd.hdc );
            CRect rcIcon;

            // Get the rect that holds the item's icon.
            m_list.GetItemRect ( nItem, &rcIcon, LVIR_ICON );

            // Draw the icon.
            m_imglist.Draw ( pDC, rItem.iImage, rcIcon.TopLeft(),
                             ILD_TRANSPARENT );

            *pResult = CDRF_SKIPDEFAULT;
            }
        }
}
```

Again, custom draw lets us get away with doing as little work as possible. What this example does is let Windows do all the painting for us, then overwrites the icon for each item that is selected. That way, all the user sees is the icon that we draw. The resulting list is pictured below. Notice that the icon of Stan looks the same as those of the unselected items.

![ [sample list view 3 - 8K] ](https://www.codeproject.com/KB/list/lvcustomdraw/lvcustomdraw3.gif)

The only drawback to drawing in this way is that sometimes you can see a bit of flicker, since the icons are drawn twice in quick succession.

## Using Custom Draw as a Replacement for Owner Draw

Another neat thing you can do with custom draw is use it to do the same thing you would do with owner draw. The difference is that IMO the code is much easier to write and understand when using custom draw. The other advantage is that if you only need to owner-draw certain rows, you can do that and have Windows draw the others. When doing a real owner-drawn control, you have to do everything, even if you don't need any "special effects" for some rows.

When you owner-draw using custom draw, you handle the `NM_CUSTOMDRAW` message sent during an item's pre-paint stage, do all the drawing, and return `CDRF_SKIPDEFAULT` from your handler. This is different than what we've done so far. `CDRF_SKIPDEFAULT` tells Windows to not do any painting in the row because you've already done it all.

I won't include the code for this example here in the article, since it's a bit long, but you can step through the code in the debugger and see what's happening. If you arrange your windows so you can see both the demo app's dialog and the code at the same time, you'll see the painting happening step-by-step. The list control is pretty simple, with just one column and no header control. The list looks like this:

![ [sample list view 4 - 6K] ](https://www.codeproject.com/KB/list/lvcustomdraw/lvcustomdraw4.gif)

## Other Things You Can (Supposedly) Do

With a little imagination, you can create some rather neat effects using custom draw. In a recent project I did at work, I wrote a list control that looks like this:

![ [sample 2-line report view - 5K] ](https://www.codeproject.com/KB/list/lvcustomdraw/lvcustomdraw5.gif)

I won't mention the product by name, since I don't want this to turn into an advertisement, but you can probably figure it out. :) Notice how the list control items look normal if the text fits on one line, but the text wraps to two lines if necessary. This way, all of the text is visible, and the user doesn't have to keep scrolling back and forth to read all of the text. I achieved this effect by handling the pre-paint stage and doing all the drawing myself.

As for why the title of this section says "supposedly": As I mentioned earlier, the docs state that you can do custom draw processing during the pre-erase and post-erase draw stages. I had never written code that acted during those stages before, so in the process of writing this article, I planned on doing an example that painted a pattern behind the list items after they were erased. However, I was unable to get Windows to send `NM_CUSTOMDRAW` messages during either the pre-erase or post-erase stages! I tried several things in my custom draw handler, and experimented a bit, but in the end I had to give up. I am suspicious of the documentation on this one, since on the page titled "`NM_CUSTOMDRAW` (list view)", it lists a return code (`CDRF_NOTIFYITEMERASE`) which does not even exist in the _commctrl.h_ header file! When such a vital piece of information is wrong, I tend to view the surrounding documentation as being of questionable accuracy.

In any event, if you did handle the pre-erase or post-erase stage, you would also need to handle the pre-paint stage. Otherwise, the default Windows behavior would wipe out the drawing you did during the erase stage. Given that fact, I couldn't come up with anything that would require you to handle one of the erase stages; any special effects could be accomplished in the paint stages just as easily.

## Demo Project

The demo project is a wizard that contains the four list controls I covered in this article. The project has the complete code for the list controls and the custom draw handlers, which you should inspect and step through to get a better feel for how custom draw works and how you can use it in your own programs.