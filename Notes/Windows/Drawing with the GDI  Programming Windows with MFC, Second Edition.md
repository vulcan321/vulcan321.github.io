# Drawing with the GDI

[Previous page](https://flylib.com/books/en/4.348.1.11/1/)

[Table of content](javascript:;)

[Next page](https://flylib.com/books/en/4.348.1.13/1/)

\[Previous\] \[Next\]

Enough of the preliminaries. By now, you probably feel as if you asked for the time and got an explanation of watchmaking. Everything you've learned so far in this chapter will come in handy sooner or later—trust me. But now let's talk about functions for outputting pixels to the screen.

The functions discussed in the next several sections are by no means all of the available GDI output functions. A full treatment of every one would require a chapter much larger than this one. When you finish reading this chapter, look at the complete list of *CDC* member functions in your MFC documentation. Doing so will give you a better feel for the wide-ranging scope of the Windows GDI and let you know where to go when you need help.

# # Drawing Lines and Curves

MFC's *CDC* class includes a number of member functions that you can use to draw lines and curves. The following table lists the key functions. There are others, but these paint a pretty good picture of the range of available line-drawing and curve-drawing functions.

***CDC* Functions for Drawing Lines and Curves**

| Function | Description |
| --- | --- |
| *MoveTo* | Sets the current position in preparation for drawing |
| *LineTo* | Draws a line from the current position to a specified position and moves the current position to the end of the line |
| *Polyline* | Connects a set of points with line segments |
| *PolylineTo* | Connects a set of points with line segments beginning with the current position and moves the current position to the end of the polyline |
| *Arc* | Draws an arc |
| *ArcTo* | Draws an arc and moves the current position to the end of the arc |
| *PolyBezier* | Draws one or more Bézier splines |
| *PolyBezierTo* | Draws one or more Bézier splines and moves the current position to the end of the final spline |
| *PolyDraw* | Draws a series of line segments and Bézier splines through a set of points and moves the current position to the end of the final line segment or spline |

Drawing a straight line is simple. You just set the current position to one end of the line and call *LineTo* with the coordinates of the other:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.MoveTo (0, 0); dc.LineTo (0, 100); </pre></td></tr></tbody></table>

To draw another line that's connected to the previous one, you call *LineTo* again. There's no need to call *MoveTo* a second time because the first call to *LineTo* sets the current position to the end of the line:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.MoveTo (0, 0); dc.LineTo (0, 100); dc.LineTo (100, 100); </pre></td></tr></tbody></table>

You can draw several lines in one fell swoop using *Polyline* or *PolylineTo*. The only difference between the two is that *PolylineTo* uses the device context's current position and *Polyline* does not. The following statements draw a box that measures 100 units to a side from a set of points describing the box's vertices:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>POINT aPoint[5] = { 0, 0, 0, 100, 100, 100, 100, 0, 0, 0 }; dc.Polyline (aPoint, 5); </pre></td></tr></tbody></table>

These statements draw the same box using *PolylineTo*:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.MoveTo (0, 0); POINT aPoint[4] = { 0, 100, 100, 100, 100, 0, 0, 0 }; dc.PolylineTo (aPoint, 4); </pre></td></tr></tbody></table>

When *PolylineTo* returns, the current position is set to the endpoint of the final line segment—in this case, (0,0). If *Polyline* is used instead, the current position is not altered.

Charles Petzold's *Programming Windows* contains an excellent example showing how and why polylines can be useful. The following *OnPaint* function, which is basically just an MFC adaptation of Charles's code, uses *CDC::Polyline* to draw a sine wave that fills the interior of a window:

<table cellpadding="5" width="95%"><tbody><tr><td><pre># include &lt;math.h&gt; # define SEGMENTS 500 # define PI 3.1415926    <img src="https://flylib.com/books/4/348/1/html/2/grayvellip.jpg" width="3" height="13" border="0"> void CMainWindow::OnPaint () {     CRect rect;     GetClientRect (&amp;rect);     int nWidth = rect.Width ();     int nHeight = rect.Height ();     CPaintDC dc (this);     CPoint aPoint[SEGMENTS];     for (int i=0; i&lt;SEGMENTS; i++) {         aPoint[i].x = (i * nWidth) / SEGMENTS;         aPoint[i].y = (int) ((nHeight / 2) *             (1 - (sin ((2 * PI * i) / SEGMENTS))));     }     dc.Polyline (aPoint, SEGMENTS); } </pre></td></tr></tbody></table>

You can see the results for yourself by substituting this code for the *OnPaint* function in Chapter 1's Hello program. Note the use of the *CRect* functions *Width* and *Height* to compute the width and height of the window's client area.

An arc is a curve taken from the circumference of a circle or an ellipse. You can draw arcs quite easily with *CDC::Arc*. You just pass it a rectangle whose borders circumscribe the ellipse and a pair of points that specify the endpoints of two imaginary lines drawn outward from the center of the ellipse. The points at which the lines intersect the ellipse are the starting and ending points of the arc. (The lines must be long enough to at least touch the circumference of the ellipse; otherwise, the results won't be what you expect.) The following code draws an arc representing the upper left quadrant of an ellipse that is 200 units wide and 100 units high:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CRect rect (0, 0, 200, 100); CPoint point1 (0, -500); CPoint point2 (-500, 0); dc.Arc (rect, point1, point2); </pre></td></tr></tbody></table>

To reverse the arc and draw the upper right, lower right, and lower left quadrants of the ellipse, simply reverse the order in which *point1* and *point2* are passed to the *Arc* function. If you'd like to know where the arc ended (an item of information that's useful when using lines and arcs to draw three-dimensional pie charts), use *ArcTo* instead of *Arc* and then use *CDC::GetCurrentPosition* to locate the endpoint. Be careful, though. In addition to drawing the arc itself, *ArcTo* draws a line from the old current position to the arc's starting point. What's more, *ArcTo* is one of a handful of GDI functions that's not implemented in Windows 98. If you call it on a platform other than Windows NT or Windows 2000, nothing will be output.

If splines are more your style, the GDI can help out there, too. *CDC::PolyBezier* draws Bézier splines—smooth curves defined by two endpoints and two intermediate points that exert "pull." Originally devised to help engineers build mathematical models of car bodies, Bézier splines, or simply "Béziers," as they are more often known, are used today in everything from fonts to warhead designs. The following code fragment uses two Bézier splines to draw a figure that resembles the famous Nike "swoosh" symbol. (See Figure 2-2.)

<table cellpadding="5" width="95%"><tbody><tr><td><pre>POINT aPoint1[4] = { 120, 100, 120, 200, 250, 150, 500, 40 }; POINT aPoint2[4] = { 120, 100,  50, 350, 250, 200, 500, 40 }; dc.PolyBezier (aPoint1, 4); dc.PolyBezier (aPoint2, 4); </pre></td></tr></tbody></table>

The curves drawn here are independent splines that happen to join at the endpoints. To draw a continuous curve by joining two or more splines, add three points to the POINT array for each additional spline and increase the number of points specified in *PolyBezier*'s second parameter accordingly.

![click to view at full size.](https://flylib.com/books/4/348/1/html/2/f02mg02.jpg)

**Figure 2-2.** *A famous shoe logo drawn with Bézier splines.*

One peculiarity of all GDI line-drawing and curve-drawing functions is that the final pixel is never drawn. If you draw a line from (0,0) to (100,100) with the statements

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.MoveTo (0, 0); dc.LineTo (100, 100); </pre></td></tr></tbody></table>

the pixel at (0,0) is set to the line color, as are the pixels at (1,1), (2,2), and so on. But the pixel at (100,100) is still the color it was before. If you want the line's final pixel to be drawn, too, you must draw it yourself. One way to do that is to use the *CDC::SetPixel* function, which sets a single pixel to the color you specify.

# # Drawing Ellipses, Polygons, and Other Shapes

The GDI doesn't limit you to simple lines and curves. It also lets you draw ellipses, rectangles, pie-shaped wedges, and other closed figures. MFC's *CDC* class wraps the associated GDI functions in handy class member functions that you can call on a device context object or through a pointer to a device context object. The following table lists a few of those functions.

***CDC* Functions for Drawing Closed Figures**

| Function | Description |
| --- | --- |
| *Chord* | Draws a closed figure bounded by the intersection of an ellipse and a line |
| *Ellipse* | Draws a circle or an ellipse |
| *Pie* | Draws a pie-shaped wedge |
| *Polygon* | Connects a set of points to form a polygon |
| *Rectangle* | Draws a rectangle with square corners |
| *RoundRect* | Draws a rectangle with rounded corners |

GDI functions that draw closed figures take as a parameter the coordinates of a "bounding box." When you draw a circle with the *Ellipse* function, for example, you don't specify a center point and a radius; instead, you specify the circle's bounding box. You can pass the coordinates explicitly, like this:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.Ellipse (0, 0, 100, 100); </pre></td></tr></tbody></table>

or pass them in a RECT structure or a *CRect* object, like this:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CRect rect (0, 0, 100, 100); dc.Ellipse (rect); </pre></td></tr></tbody></table>

When this circle is drawn, it touches the *x*\=0 line at the left of the bounding box and the *y*\=0 line at the top, but it falls 1 pixel short of the *x*\=100 line at the right and 1 pixel short of the *y*\=100 line at the bottom. In other words, figures are drawn from the left and upper limits of the bounding box up to (but not including) the right and lower limits. If you call the *CDC::Rectangle* function, like this:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.Rectangle (0, 0, 8, 4); </pre></td></tr></tbody></table>

you get the output shown in Figure 2-3. Observe that the right and lower limits of the rectangle fall at *x*\=7 and *y*\=3, not *x*\=8 and *y*\=4.

![click to view at full size.](https://flylib.com/books/4/348/1/html/2/f02mg03.jpg)

**Figure 2-3.** *A rectangle drawn with the statement dc.Rectangle (0, 0, 8, 4).*

*Rectangle* and *Ellipse* are about as straightforward as they come. You provide the bounding box, and Windows does the drawing. If you want to draw a rectangle that has rounded corners, use *RoundRect* instead of *Rectangle*.

The *Pie* and *Chord* functions merit closer scrutiny, however. Both are syntactically identical to the *Arc* function discussed in the previous section. The difference is in the output. (See Figure 2-4.) *Pie* draws a closed figure by drawing straight lines connecting the ends of the arc to the center of the ellipse. *Chord* closes the figure by connecting the arc's endpoints. The following *OnPaint* handler uses *Pie* to draw a pie chart that depicts four quarterly revenue values:

<table cellpadding="5" width="95%"><tbody><tr><td><pre># include &lt;math.h&gt; # define PI 3.1415926    <img src="https://flylib.com/books/4/348/1/html/2/grayvellip.jpg" width="3" height="13" border="0"> void CMainWindow::OnPaint () {     CPaintDC dc (this);     int nRevenues[4] = { 125, 376, 252, 184 };     CRect rect;     GetClientRect (&amp;rect);     dc.SetViewportOrg (rect.Width () / 2, rect.Height () / 2);     int nTotal = 0;     for (int i=0; i&lt;4; i++)         nTotal += nRevenues[i];     int x1 = 0;     int y1 = -1000;     int nSum = 0;     for (i=0; i&lt;4; i++) {         nSum += nRevenues[i];         double rad = ((double) (nSum * 2 * PI) / (double) nTotal) + PI;         int x2 = (int) (sin (rad) * 1000);         int y2 = (int) (cos (rad) * 1000 * 3) / 4;         dc.Pie (-200, -150, 200, 150, x1, y1, x2, y2);         x1 = x2;         y1 = y2;     } } </pre></td></tr></tbody></table>

Note that the origin is moved to the center of the window with *SetViewportOrg* before any drawing takes place so that the chart will also be centered.

![](https://flylib.com/books/4/348/1/html/2/f02mg04.gif)

**Figure 2-4.** *Output from the Arc, Chord, and Pie functions.*

# # GDI Pens and the *CPen* Class

Windows uses the pen that is currently selected into the device context to draw lines and curves and also to border figures drawn with *Rectangle*, *Ellipse*, and other shape-drawing functions. The default pen draws solid black lines that are 1 pixel wide. To change the way lines are drawn, you must create a GDI pen and select it into the device context with *CDC::SelectObject*.

MFC represents GDI pens with the class *CPen*. The simplest way to create a pen is to construct a *CPen* object and pass it the parameters defining the pen:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen (PS_SOLID, 1, RGB (255, 0, 0)); </pre></td></tr></tbody></table>

A second way to create a GDI pen is to construct an uninitialized *CPen* object and call *CPen::CreatePen*:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen; pen.CreatePen (PS_SOLID, 1, RGB (255, 0, 0)); </pre></td></tr></tbody></table>

Yet a third method is to construct an uninitialized *CPen* object, fill in a LOGPEN structure describing the pen, and then call *CPen::CreatePenIndirect* to create the pen:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen; LOGPEN lp; lp.lopnStyle = PS_SOLID; lp.lopnWidth.x = 1; lp.lopnColor = RGB (255, 0, 0); pen.CreatePenIndirect (&amp;lp); </pre></td></tr></tbody></table>

LOGPEN's *lopnWidth* field is a POINT data structure. The structure's *x* data member specifies the pen width. The *y* data member is not used.

*CreatePen* and *CreatePenIndirect* return TRUE if a pen is successfully created, FALSE if it is not. If you allow *CPen*'s constructor to create the pen, an exception of type *CResourceException* is thrown if the pen can't be created. This should happen only if Windows is critically low on memory.

A pen has three defining characteristics: style, width, and color. The examples above create a pen whose style is PS\*SOLID, whose width is 1, and whose color is bright red. The first of the three parameters passed to *CPen::CPen* and *CPen::CreatePen* specifies the pen style, which defines the type of line the pen draws. PS\*SOLID creates a pen that draws solid, unbroken lines. Other pen styles are shown in Figure 2-5.

![](https://flylib.com/books/4/348/1/html/2/f02mg05.gif)

**Figure 2-5.** *Pen styles.*

The special PS\*INSIDEFRAME style draws solid lines that stay within the bounding rectangle, or "inside the frame," of the figure being drawn. If you use any of the other pen styles to draw a circle whose diameter is 100 units using a PS\*SOLID pen that is 20 units wide, for example, the actual diameter of the circle, measured across the circle's outside edge, is 120 units, as shown in Figure 2-6. Why? Because the border drawn by the pen extends 10 units outward on either side of the theoretical circle. Draw the same circle with a PS\*INSIDEFRAME pen, and the diameter is exactly 100 units. The PS\*INSIDEFRAME style does not affect lines drawn with *LineTo* and other functions that don't use a bounding rectangle.

![click to view at full size.](https://flylib.com/books/4/348/1/html/2/f02mg06.jpg)

**Figure 2-6.** *The PS\*INSIDEFRAME pen style._

The pen style PS\*NULL creates what Windows programmers refer to as a "NULL pen." Why would you ever want to create a NULL pen? Believe it or not, there are times when a NULL pen can come in handy. Suppose, for example, that you want to draw a solid red circle with no border. If you draw the circle with MFC's *CDC::Ellipse* function, Windows automatically borders the circle with the pen currently selected into the device context. You can't tell the *Ellipse* function that you don't want a border, but you *can_ select a NULL pen into the device context so that the circle will have no visible border. NULL brushes are used in a similar way. If you want the circle to have a border but want the interior of the circle to be transparent, you can select a NULL brush into the device context before you draw.

The second parameter passed to *CPen*'s pen-create functions specifies the width of the lines drawn with the pen. Pen widths are specified in logical units whose physical meanings depend on the current mapping mode. You can create PS\*SOLID, PS\*NULL, and PS\*INSIDEFRAME pens of any logical width, but PS\*DASH, PS\*DOT, PS\*DASHDOT, and PS\_DASHDOTDOT pens must be 1 logical unit wide. Specifying a pen width of 0 in any style creates a pen that is 1 pixel wide, no matter what the mapping mode.

The third and final parameter specified when a pen is created is the pen's color. Windows uses a 24-bit RGB color model in which each possible color is defined by red, green, and blue color values from 0 through 255. The higher the value, the brighter the corresponding color component. The RGB macro combines values that specify the three independent color components into one COLORREF value that can be passed to the GDI. The statement

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen (PS_SOLID, 1, RGB (255, 0, 0)); </pre></td></tr></tbody></table>

creates a bright red pen, and the statement

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen (PS_SOLID, 1, RGB (255, 255, 0)); </pre></td></tr></tbody></table>

creates a bright yellow pen by combining red and green. If the display adapter doesn't support 24-bit color, Windows compensates by dithering colors that it can't display directly. Be aware, however, that only PS\_INSIDEFRAME pens greater than 1 logical unit in width can use dithered colors. For the other pen styles, Windows maps the color of the pen to the nearest solid color that can be displayed. You can be reasonably certain of getting the exact color you want on all adapters by sticking to the "primary" colors shown in the table below. These colors are part of the basic palette that Windows programs into the color registers of every video adapter to ensure that a common subset of colors is available to all programs.

**Primary GDI Colors**

| Color | R | G | B | Color | R | G | B |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Black | 0 | 0 | 0 | Light gray | 192 | 192 | 192 |
| Blue | 0 | 0 | 192 | Bright blue | 0 | 0 | 255 |
| Green | 0 | 192 | 0 | Bright green | 0 | 255 | 0 |
| Cyan | 0 | 192 | 192 | Bright cyan | 0 | 255 | 255 |
| Red | 192 | 0 | 0 | Bright red | 255 | 0 | 0 |
| Magenta | 192 | 0 | 192 | Bright magenta | 255 | 0 | 255 |
| Yellow | 192 | 192 | 0 | Bright yellow | 255 | 255 | 0 |
| Dark gray | 128 | 128 | 128 | White | 255 | 255 | 255 |

How do you use a pen once it's created? Simple: You select it into a device context. The following code snippet creates a red pen that's 10 units wide and draws an ellipse with it:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen (PS_SOLID, 10, RGB (255, 0, 0)); CPen* pOldPen = dc.SelectObject (&amp;pen); dc.Ellipse (0, 0, 100, 100); </pre></td></tr></tbody></table>

The ellipse is filled with the color or pattern of the current brush, which defaults to white. To change the default, you need to create a GDI brush and select it into the device context before calling *Ellipse*. I'll demonstrate how to do that in just a moment.

## # Extended Pens

If none of the basic pen styles suits your needs, you can use a separate class of pens known as "extended" pens, which the Windows GDI and MFC's *CPen* class support. These pens offer a greater variety of output options. For example, you can create an extended pen that draws a pattern described by a bitmap image or uses a dithered color. You can also exercise precise control over endpoints and joins by specifying the end cap style (flat, round, or square) and join style (beveled, mitered, or rounded). The following code creates an extended pen 16 units wide that draws solid green lines with flat ends. Where two lines meet, the adjoining ends are rounded to form a smooth intersection:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>LOGBRUSH lb; lb.lbStyle = BS*SOLID; lb.lbColor = RGB (0, 255, 0); CPen pen (PS*GEOMETRIC ¦ PS*SOLID ¦ PS*ENDCAP*FLAT ¦     PS*JOIN_ROUND, 16, &amp;lb); </pre></td></tr></tbody></table>

Windows places several restrictions on the use of extended pens, not the least of which is that endpoint joins will work only if the figure is first drawn as a "path" and is then rendered with *CDC::StrokePath* or a related function. You define a path by enclosing drawing commands between calls to *CDC::BeginPath* and *CDC::EndPath*, as shown here:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.BeginPath ();        // Begin the path definition dc.MoveTo (0, 0);       // Create a triangular path dc.LineTo (100, 200); dc.LineTo (200, 100); dc.CloseFigure (); dc.EndPath ();          // End the path definition dc.StrokePath ();       // Draw the triangle </pre></td></tr></tbody></table>

Paths are a powerful feature of the GDI that you can use to create all sorts of interesting effects. We'll look more closely at paths—and at the *CDC* functions that use them—in Chapter 15.

# # GDI Brushes and the *CBrush* Class

By default, closed figures drawn with *Rectangle*, *Ellipse*, and other *CDC* output functions are filled with white pixels. You can change the fill color by creating a GDI brush and selecting it into the device context prior to drawing.

MFC's *CBrush* class encapsulates GDI brushes. Brushes come in three basic varieties: solid, hatch, and pattern. Solid brushes paint with solid colors. If the display hardware won't allow a solid brush color to be displayed directly, Windows simulates the color by dithering colors that *can* be displayed. A hatch brush paints with one of six predefined crosshatch patterns that are similar to ones commonly found in engineering and architectural drawings. A pattern brush paints with a bitmap. The *CBrush* class provides a constructor for each different brush style.

You can create a solid brush in one step by passing a COLORREF value to the *CBrush* constructor:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CBrush brush (RGB (255, 0, 0)); </pre></td></tr></tbody></table>

Or you can create a solid brush in two steps by creating an uninitialized *CBrush* object and calling *CBrush::CreateSolidBrush*:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CBrush brush; brush.CreateSolidBrush (RGB (255, 0, 0)); </pre></td></tr></tbody></table>

Both examples create a solid brush that paints in bright red. You can also create a brush by initializing a LOGBRUSH structure and calling *CBrush::CreateBrushIndirect*. As with *CPen* constructors, all *CBrush* constructors that create a brush for you throw a resource exception if the GDI is low on memory and a brush can't be created.

Hatch brushes are created by passing *CBrush*'s constructor both a hatch index and a COLORREF value or by calling *CBrush::CreateHatchBrush*. The statement

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CBrush brush (HS_DIAGCROSS, RGB (255, 0, 0)); </pre></td></tr></tbody></table>

creates a hatch brush that paints perpendicular crosshatch lines oriented at 45-degree angles, as do these statements:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CBrush brush; brush.CreateHatchBrush (HS_DIAGCROSS, RGB (255, 0, 0)); </pre></td></tr></tbody></table>

HS\*DIAGCROSS is one of six hatch styles you can choose from. (See Figure 2-7.) When you paint with a hatch brush, Windows fills the space between hatch lines with the default background color (white) unless you change the device context's current background color with *CDC::SetBkColor* or turn off background fills by changing the background mode from OPAQUE to TRANSPARENT with *CDC::SetBkMode_. The statements

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CBrush brush (HS_DIAGCROSS, RGB (255, 255, 255)); dc.SelectObject (&amp;brush); dc.SetBkColor (RGB (192, 192, 192)); dc.Rectangle (0, 0, 100, 100); </pre></td></tr></tbody></table>

draw a rectangle 100 units square and fill it with white crosshatch lines drawn against a light gray background. The statements

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CBrush brush (HS_DIAGCROSS, RGB (0, 0, 0)); dc.SelectObject (&amp;brush); dc.SetBkMode (TRANSPARENT); dc.Rectangle (0, 0, 100, 100); </pre></td></tr></tbody></table>

draw a black crosshatched rectangle against the existing background.

![click to view at full size.](https://flylib.com/books/4/348/1/html/2/f02mg07.jpg)

**Figure 2-7.** *Hatch brush styles.*

## # The Brush Origin

One attribute of a device context that you should be aware of when using dithered brush colors or hatch brushes is the brush origin. When Windows fills an area with a hatched or dithered brush pattern, it tiles an 8-pixel by 8-pixel pattern horizontally and vertically within the affected area. By default, the origin for this pattern, better known as the *brush origin,* is the device point (0,0)—the screen pixel in the upper left corner of the window. This means that a pattern drawn in a rectangle that begins 100 pixels to the right of and below the origin will be aligned somewhat differently with respect to the rectangle's border than a pattern drawn in a rectangle positioned a few pixels to the left or right, as shown in Figure 2-8. In many applications, it doesn't matter; the user isn't likely to notice minute differences in brush alignment. However, in some situations it matters a great deal.

![click to view at full size.](https://flylib.com/books/4/348/1/html/2/f02mg08.jpg)

**Figure 2-8.** *Brush alignment.*

Suppose you're using a hatch brush to fill a rectangle and you're animating the motion of that rectangle by repeatedly erasing it and redrawing it 1 pixel to the right or the left. If you don't reset the brush origin to a point that stays in the same position relative to the rectangle before each redraw, the hatch pattern will "walk" as the rectangle moves.

The solution? Before selecting the brush into the device context and drawing the rectangle, call *CGdiObject::UnrealizeObject* on the brush object to permit the brush origin to be moved. Then call *CDC::SetBrushOrg* to align the brush origin with the rectangle's upper left corner, as shown here:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPoint point (x1, y1); dc.LPtoDP (&amp;point); point.x %= 8; point.y %= 8; brush.UnrealizeObject (); dc.SetBrushOrg (point); dc.SelectObject (&amp;brush); dc.Rectangle (x1, y1, x2, y2); </pre></td></tr></tbody></table>

In this example, *point* is a *CPoint* object that holds the logical coordinates of the rectangle's upper left corner. *LPtoDP* is called to convert logical coordinates into device coordinates (brush origins are always specified in device coordinates), and a modulo-8 operation is performed on the resulting values because coordinates passed to *SetBrushOrg* should fall within the range 0 through 7. Now the hatch pattern will be aligned consistently no matter where in the window the rectangle is drawn.

# # Drawing Text

You've already seen one way to output text to a window. The *CDC::DrawText* function writes a string of text to a display surface. You tell *DrawText* where to draw its output by specifying both a formatting rectangle and a series of option flags indicating how the text is to be positioned within the rectangle. In Chapter 1's Hello program, the statement

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.DrawText (*T ("Hello, MFC"), -1, &amp;rect,     DT*SINGLELINE ¦ DT*CENTER ¦ DT*VCENTER); </pre></td></tr></tbody></table>

drew "Hello, MFC" so that it was centered in the window. *rect* was a rectangle object initialized with the coordinates of the window's client area, and the DT\*CENTER and DT\*VCENTER flags told *DrawText* to center its output in the rectangle both horizontally and vertically.

*DrawText* is one of several text-related functions that are members of MFC's *CDC* class. Some of the others are listed in the table below. One of the most useful is *TextOut*, which outputs text like *DrawText* but accepts an *x*\-*y* coordinate pair that specifies where the text will be output and also uses the current position if it is asked to. The statement

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.TextOut (0, 0, CString (_T ("Hello, MFC"))); </pre></td></tr></tbody></table>

writes "Hello, MFC" to the upper left of the display surface represented by *dc*. A related function named *TabbedTextOut* works just like *TextOut* except that it expands tab characters into white space. (If a string passed to *TextOut* contains tabs, the characters show up as rectangles in most fonts.) Tab positions are specified in the call to *TabbedTextOut*. A related function named *ExtTextOut* gives you the added option of filling a rectangle surrounding the output text with an opaque background color. It also gives the programmer precise control over intercharacter spacing.

By default, the coordinates passed to *TextOut*, *TabbedTextOut*, and *ExtTextOut* specify the location of the upper left corner of the text's leftmost character cell. However, the relationship between the coordinates passed to *TextOut* and the characters in the output string, a property known as the *text alignment*, is an attribute of the device context. You can change it with *CDC::SetTextAlign*. For example, after a

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.SetTextAlign (TA_RIGHT); </pre></td></tr></tbody></table>

statement is executed, the *x* coordinate passed to *TextOut* specifies the rightmost position in the character cell—perfect for drawing right-aligned text.

You can also call *SetTextAlign* with a TA\*UPDATECP flag to instruct *TextOut* to ignore the *x* and *y* arguments passed to it and use the device context's current position instead. When the text alignment includes TA\*UPDATECP, *TextOut* updates the *x* component of the current position each time a string is output. One use for this feature is to achieve proper spacing between two or more character strings that are output on the same line.

***CDC* Text Functions**

| Function | Description |
| --- | --- |
| *DrawText* | Draws text in a formatting rectangle |
| *TextOut* | Outputs a line of text at the current or specified position |
| *TabbedTextOut* | Outputs a line of text that includes tabs |
| *ExtTextOut* | Outputs a line of text and optionally fills a rectangle with a background color or varies the intercharacter spacing |
| *GetTextExtent* | Computes the width of a string in the current font |
| *GetTabbedTextExtent* | Computes the width of a string with tabs in the current font |
| *GetTextMetrics* | Returns font metrics (character height, average character width, and so on) for the current font |
| *SetTextAlign* | Sets alignment parameters for *TextOut* and other output functions |
| *SetTextJustification* | Specifies the added width that is needed to justify a string of text |
| *SetTextColor* | Sets the device context's text output color |
| *SetBkColor* | Sets the device context's background color, which determines the fill color used behind characters that are output to a display surface |

Two functions—*GetTextMetrics* and *GetTextExtent*—let you retrieve information about the font that is currently selected into the device context. *GetTextMetrics* fills a TEXTMETRIC structure with information on the characters that make up the font. *GetTextExtent* returns the width of a given string, in logical units, rendered in that font. (Use *GetTabbedTextExtent* if the string contains tab characters.) One use for *GetTextExtent* is to gauge the width of a string prior to outputting it in order to compute how much space is needed between words to fully justify the text. If *nWidth* is the distance between left and right margins, the following code outputs the text "Now is the time" and justifies the output to both margins:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CString string = _T ("Now is the time"); CSize size = dc.GetTextExtent (string); dc.SetTextJustification (nWidth - size.cx, 3); dc.TextOut (0, y, string); </pre></td></tr></tbody></table>

The second parameter passed to *SetTextJustification* specifies the number of break characters in the string. The default break character is the space character. After *SetTextJustification* is called, subsequent calls to *TextOut* and related text output functions distribute the space specified in the *SetTextJustification*'s first parameter evenly between all the break characters.

# # GDI Fonts and the *CFont* Class

All *CDC* text functions use the font that is currently selected into the device context. A *font* is a group of characters of a particular size (height) and typeface that share common attributes such as character weight—for example, normal or boldface. In classical typography, font sizes are measured in units called *points*. One point equals about 1/72 inch. Each character in a 12-point font is nominally 1/6 inch tall, but in Windows, the actual height can vary somewhat depending on the physical characteristics of the output device. The term *typeface* describes a font's basic style. Times New Roman is one example of a typeface; Courier New is another.

A font is a GDI object, just as a pen or a brush is. In MFC, fonts are represented by objects of the *CFont* class. Once a *CFont* object is constructed, you create the underlying GDI font by calling the *CFont* object's *CreateFont*, *CreateFontIndirect*, *CreatePointFont*, or *CreatePointFontIndirect* function. Use *CreateFont* or *CreateFontIndirect* if you want to specify the font size in pixels, and use *CreatePointFont* and *CreatePointFontIndirect* to specify the font size in points. Creating a 12-point Times New Roman screen font with *CreatePointFont* requires just two lines of code:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CFont font; font.CreatePointFont (120, _T ("Times New Roman")); </pre></td></tr></tbody></table>

Doing the same with *CreateFont* requires you to query the device context for the logical number of pixels per inch in the vertical direction and to convert points to pixels:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CClientDC dc (this); int nHeight = -((dc.GetDeviceCaps (LOGPIXELSY) * 12) / 72); CFont font; font.CreateFont (nHeight, 0, 0, 0, FW*NORMAL, 0, 0, 0,     DEFAULT*CHARSET, OUT*CHARACTER*PRECIS, CLIP*CHARACTER*PRECIS,     DEFAULT*QUALITY, DEFAULT*PITCH ¦ FF*DONTCARE,     *T ("Times New Roman")); </pre></td></tr></tbody></table>

Incidentally, the numeric value passed to *CreatePointFont* is the desired point size *times 10*. This allows you to control the font size down to 1/10 point—plenty accurate enough for most applications, considering the relatively low resolution of most screens and other commonly used output devices.

The many parameters passed to *CreateFont* specify, among other things, the font weight and whether characters in the font are italicized. You can't create a bold, italic font with *CreatePointFont*, but you can with *CreatePointFontIndirect*. The following code creates a 12-point bold, italic Times New Roman font using *CreatePointFontIndirect*.

<table cellpadding="5" width="95%"><tbody><tr><td><pre>LOGFONT lf; ::ZeroMemory (&amp;lf, sizeof (lf)); lf.lfHeight = 120; lf.lfWeight = FW*BOLD; lf.lfItalic = TRUE; ::lstrcpy (lf.lfFaceName, *T ("Times New Roman")); CFont font; font.CreatePointFontIndirect (&amp;lf); </pre></td></tr></tbody></table>

LOGFONT is a structure whose fields define all the characteristics of a font. *::ZeroMemory* is an API function that zeroes a block of memory, and *::lstrcpy* is an API function that copies a text string from one memory location to another. You can use the C run time's *memset* and *strcpy* functions instead (actually, you should use *\*tcscpy* in lieu of *strcpy_ so the call will work with ANSI or Unicode characters), but using Windows API functions frequently makes an executable smaller by reducing the amount of statically linked code.

After creating a font, you can select it into a device context and draw with it using *DrawText*, *TextOut*, and other *CDC* text functions. The following *OnPaint* handler draws "Hello, MFC" in the center of a window. But this time the text is drawn using a 72-point Arial typeface, complete with drop shadows. (See Figure 2-9.)

<table cellpadding="5" width="95%"><tbody><tr><td><pre>void CMainWindow::OnPaint () {     CRect rect;     GetClientRect (&amp;rect);     CFont font;     font.CreatePointFont (720, *T ("Arial"));     CPaintDC dc (this);     dc.SelectObject (&amp;font);     dc.SetBkMode (TRANSPARENT);     CString string = *T ("Hello, MFC");     rect.OffsetRect (16, 16);     dc.SetTextColor (RGB (192, 192, 192));     dc.DrawText (string, &amp;rect, DT*SINGLELINE ¦         DT*CENTER ¦ DT*VCENTER);     rect.OffsetRect (-16, -16);     dc.SetTextColor (RGB (0, 0, 0));     dc.DrawText (string, &amp;rect, DT*SINGLELINE ¦         DT*CENTER ¦ DT*VCENTER); } </pre></td></tr></tbody></table>

![click to view at full size.](https://flylib.com/books/4/348/1/html/2/f02mg09.jpg)

**Figure 2-9.** *"Hello, MFC" rendered in 72-point Arial with drop shadows.*

The shadow effect is achieved by drawing the text string twice—once a few pixels to the right of and below the center of the window, and once in the center. MFC's *CRect::OffsetRect* function makes it a snap to "move" rectangles by offsetting them a specified distance in the *x* and *y* directions.

What happens if you try to create, say, a Times New Roman font on a system that doesn't have Times New Roman installed? Rather than fail the call, the GDI will pick a similar typeface that *is* installed. An internal font-mapping algorithm is called to pick the best match, and the results aren't always what one might expect. But at least your application won't output text just fine on one system and mysteriously output nothing on another.

# # Raster Fonts vs. TrueType Fonts

Most GDI fonts fall into one of two categories: raster fonts and TrueType fonts. Raster fonts are stored as bitmaps and look best when they're displayed in their native sizes. One of the most useful raster fonts provided with Windows is MS Sans Serif, which is commonly used (in its 8-point size) on push buttons, radio buttons, and other dialog box controls. Windows can scale raster fonts by duplicating rows and columns of pixels, but the results are rarely pleasing to the eye due to stair-stepping effects.

The best fonts are TrueType fonts because they scale well to virtually any size. Like PostScript fonts, TrueType fonts store character outlines as mathematical formulas. They also include "hint" information that's used by the GDI's TrueType font rasterizer to enhance scalability. You can pretty much bank on the fact that any system your application runs on will have the following TrueType fonts installed, because all four are provided with Windows:

-   Times New Roman

-   Arial

-   Courier New

-   Symbol

In Chapter 7, you'll learn how to query the system for font information and how to enumerate the fonts that are installed. Such information can be useful if your application requires precise character output or if you want to present a list of installed fonts to the user.

# # Rotated Text

One question that's frequently asked about GDI text output is "How do I display rotated text?" There are two ways to do it, one of which works only in Microsoft Windows NT and Windows 2000. The other method is compatible with all 32-bit versions of Windows, so it's the one I'll describe here.

The secret is to create a font with *CFont::CreateFontIndirect* or *CFont::CreatePointFontIndirect* and to specify the desired rotation angle (in degrees) times 10 in the LOGFONT structure's *lfEscapement* and *lfOrientation* fields. Then you output the text in the normal manner—for example, using *CDC::TextOut*. Conventional text has an escapement and orientation of 0; that is, it has no slant and is drawn on a horizontal. Setting these values to 450 rotates the text counterclockwise 45 degrees. The following *OnPaint* handler increments *lfEscapement* and *lfOrientation* in units of 15 degrees and uses the resulting fonts to draw the radial text array shown in Figure 2-10:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>void CMainWindow::OnPaint () {     CRect rect;     GetClientRect (&amp;rect);     CPaintDC dc (this);     dc.SetViewportOrg (rect.Width () / 2, rect.Height () / 2);     dc.SetBkMode (TRANSPARENT);     for (int i=0; i&lt;3600; i+=150) {         LOGFONT lf;         ::ZeroMemory (&amp;lf, sizeof (lf));         lf.lfHeight = 160;         lf.lfWeight = FW*BOLD;         lf.lfEscapement = i;         lf.lfOrientation = i;         ::lstrcpy (lf.lfFaceName, *T ("Arial"));         CFont font;         font.CreatePointFontIndirect (&amp;lf);         CFont* pOldFont = dc.SelectObject (&amp;font);         dc.TextOut (0, 0, CString (_T ("          Hello, MFC")));         dc.SelectObject (pOldFont);     } } </pre></td></tr></tbody></table>

This technique works great with TrueType fonts, but it doesn't work at all with raster fonts.

![click to view at full size.](https://flylib.com/books/4/348/1/html/2/f02mg10.jpg)

**Figure 2-10.** *Rotated text.*

# # Stock Objects

Windows predefines a handful of pens, brushes, fonts, and other GDI objects that can be used without being explicitly created. Called *stock objects*, these GDI objects can be selected into a device context with the *CDC::SelectStockObject* function or assigned to an existing *CPen*, *CBrush*, or other object with *CGdiObject::CreateStockObject*. *CGdiObject* is the base class for *CPen*, *CBrush*, *CFont*, and other MFC classes that represent GDI objects.

The following table shows a partial list of the available stock objects. Stock pens go by the names WHITE\*PEN, BLACK\*PEN, and NULL\*PEN. WHITE\*PEN and BLACK\*PEN draw solid lines that are 1 pixel wide. NULL\*PEN draws nothing. The stock brushes include one white brush, one black brush, and three shades of gray. HOLLOW\*BRUSH and NULL\*BRUSH are two different ways of referring to the same thing—a brush that paints nothing. SYSTEM\_FONT is the font that's selected into every device context by default.

**Commonly Used Stock Objects**

| Object | Description |
| --- | --- |
| NULL\_PEN | Pen that draws nothing |
| BLACK\_PEN | Black pen that draws solid lines 1 pixel wide |
| WHITE\_PEN | White pen that draws solid lines 1 pixel wide |
| NULL\_BRUSH | Brush that draws nothing |
| HOLLOW\*BRUSH | Brush that draws nothing (same as NULL\*BRUSH) |
| BLACK\_BRUSH | Black brush |
| DKGRAY\_BRUSH | Dark gray brush |
| GRAY\_BRUSH | Medium gray brush |
| LTGRAY\_BRUSH | Light gray brush |
| WHITE\_BRUSH | White brush |
| ANSI\*FIXED\*FONT | Fixed-pitch ANSI font |
| ANSI\*VAR\*FONT | Variable-pitch ANSI font |
| SYSTEM\_FONT | Variable-pitch system font |
| SYSTEM\*FIXED\*FONT | Fixed-pitch system font |

Suppose you want to draw a light gray circle with no border. How do you do it? Here's one way:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen (PS_NULL, 0, (RGB (0, 0, 0))); dc.SelectObject (&amp;pen); CBrush brush (RGB (192, 192, 192)); dc.SelectObject (&amp;brush); dc.Ellipse (0, 0, 100, 100); </pre></td></tr></tbody></table>

But since NULL pens and light gray brushes are stock objects, here's a better way:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.SelectStockObject (NULL*PEN); dc.SelectStockObject (LTGRAY*BRUSH); dc.Ellipse (0, 0, 100, 100); </pre></td></tr></tbody></table>

The following code demonstrates a third way to draw the circle. This time the stock objects are assigned to a *CPen* and a *CBrush* rather than selected into the device context directly:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen; pen.CreateStockObject (NULL*PEN); dc.SelectObject (&amp;pen); CBrush brush; brush.CreateStockObject (LTGRAY*BRUSH); dc.SelectObject (&amp;brush); dc.Ellipse (0, 0, 100, 100); </pre></td></tr></tbody></table>

Which of the three methods you use is up to you. The second method is the shortest, and it's the only one that's guaranteed not to throw an exception since it doesn't create any GDI objects.

# # Deleting GDI Objects

Pens, brushes, and other objects created from *CGdiObject*\-derived classes are resources that consume space in memory, so it's important to delete them when you no longer need them. If you create a *CPen*, *CBrush*, *CFont*, or other *CGdiObject* on the stack, the associated GDI object is automatically deleted when *CGdiObject* goes out of scope. If you create a *CGdiObject* on the heap with *new*, be sure to delete it at some point so that its destructor will be called. The GDI object associated with a *CGdiObject* can be explicitly deleted by calling *CGdiObject::DeleteObject*. You never need to delete stock objects, even if they are "created" with *CreateStockObject*.

In 16-bit Windows, GDI objects frequently contributed to the problem of resource leakage, in which the Free System Resources figure reported by Program Manager gradually decreased as applications were started and terminated because some programs failed to delete the GDI objects they created. All 32-bit versions of Windows track the resources a program allocates and deletes them when the program ends. However, it's *still* important to delete GDI objects when they're no longer needed so that the GDI doesn't run out of memory while a program is running. Imagine an *OnPaint* handler that creates 10 pens and brushes every time it's called but neglects to delete them. Over time, *OnPaint* might create thousands of GDI objects that occupy space in system memory owned by the Windows GDI. Pretty soon, calls to create pens and brushes will fail, and the application's *OnPaint* handler will mysteriously stop working.

In Visual C++, there's an easy way to tell whether you're failing to delete pens, brushes, and other resources: Simply run a debug build of your application in debugging mode. When the application terminates, resources that weren't freed will be listed in the debugging window. MFC tracks memory allocations for *CPen*, *CBrush*, and other *CObject*\-derived classes so that it can notify you when an object hasn't been deleted. If you have difficulty ascertaining from the debug messages which objects weren't deleted, add the statement

<table cellpadding="5" width="95%"><tbody><tr><td><pre># define new DEBUG_NEW </pre></td></tr></tbody></table>

to your application's source code files after the statement that includes Afxwin.h. (In AppWizard-generated applications, this statement is included automatically.) Debug messages for unfreed objects will then include line numbers and file names to help you pinpoint leaks.

# # Deselecting GDI Objects

It's important to delete the GDI objects you create, but it's equally important to never delete a GDI object while it's selected into a device context. Code that attempts to paint with a deleted object is buggy code. The only reason it doesn't crash is that the Windows GDI is sprinkled with error-checking code to prevent such crashes from occurring.

Abiding by this rule isn't as easy as it sounds. The following *OnPaint* handler allows a brush to be deleted while it's selected into a device context. Can you figure out why?

<table cellpadding="5" width="95%"><tbody><tr><td><pre>void CMainWindow::OnPaint () {     CPaintDC dc (this);     CBrush brush (RGB (255, 0, 0));     dc.SelectObject (&amp;brush);     dc.Ellipse (0, 0, 200, 100); } </pre></td></tr></tbody></table>

Here's the problem. A *CPaintDC* object and a *CBrush* object are created on the stack. Since the *CBrush* is created second, its destructor gets called first. Consequently, the associated GDI brush is deleted before *dc* goes out of scope. You could fix this by creating the brush first and the DC second, but code whose robustness relies on stack variables being created in a particular order is bad code indeed. As far as maintainability goes, it's a nightmare.

The solution is to select the *CBrush* out of the device context before the *CPaintDC* object goes out of scope. There is no *UnselectObject* function, but you can select an object out of a device context by selecting in another object. Most Windows programmers make it a practice to save the pointer returned by the first call to *SelectObject* for each object type and then use that pointer to reselect the default object. An equally viable approach is to select stock objects into the device context to replace the objects that are currently selected in. The first of these two methods is illustrated by the following code:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen (PS_SOLID, 1, RGB (255, 0, 0)); CPen* pOldPen = dc.SelectObject (&amp;pen); CBrush brush (RGB (0, 0, 255)); CBrush* pOldBrush = dc.SelectObject (&amp;brush);   <img src="https://flylib.com/books/4/348/1/html/2/grayvellip.jpg" width="3" height="13" border="0"> dc.SelectObject (pOldPen); dc.SelectObject (pOldBrush); </pre></td></tr></tbody></table>

The second method works like this:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen (PS*SOLID, 1, RGB (255, 0, 0)); dc.SelectObject (&amp;pen); CBrush brush (RGB (0, 0, 255)); dc.SelectObject (&amp;brush);    <img src="https://flylib.com/books/4/348/1/html/2/grayvellip.jpg" width="3" height="13" border="0"> dc.SelectStockObject (BLACK*PEN); dc.SelectStockObject (WHITE_BRUSH); </pre></td></tr></tbody></table>

The big question is why this is necessary. The simple truth is that it's not. In modern versions of Windows, there's no harm in allowing a GDI object to be deleted a split second before a device context is released, especially if you're absolutely sure that no drawing will be done in the interim. Still, cleaning up a device context by deselecting the GDI objects you selected in is a common practice in Windows programming. It's also considered good form, so it's something I'll do throughout this book.

Incidentally, GDI objects are occasionally created on the heap, like this:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen* pPen = new CPen (PS_SOLID, 1, RGB (255, 0, 0)); CPen* pOldPen = dc.SelectObject (pPen); </pre></td></tr></tbody></table>

At some point, the pen must be selected out of the device context and deleted. The code to do it might look like this:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.SelectObject (pOldPen); delete pPen; </pre></td></tr></tbody></table>

Since the *SelectObject* function returns a pointer to the object selected out of the device context, it might be tempting to try to deselect the pen and delete it in one step:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>delete dc.SelectObject (pOldPen); </pre></td></tr></tbody></table>

But don't do this. It works fine with pens, but it might not work with brushes. Why? Because if you create two identical *CBrush*es, 32-bit Windows conserves memory by creating just one GDI brush and you'll wind up with two *CBrush* pointers that reference the same HBRUSH. (An HBRUSH is a handle that uniquely identifies a GDI brush, just as an HWND identifies a window and an HDC identifies a device context. A *CBrush* wraps an HBRUSH and stores the HBRUSH handle in its *m\*hObject* data member.) Because *CDC::SelectObject* uses an internal table maintained by MFC to convert the HBRUSH handle returned by *SelectObject* to a *CBrush* pointer and because that table assumes a one-to-one mapping between HBRUSHes and *CBrush*es, the *CBrush* pointer you get back might not match the *CBrush* pointer returned by *new*. Be sure you pass *delete* the pointer returned by *new_. Then both the GDI object and the C++ object will be properly destroyed.

# # The Ruler Application

The best way to get acquainted with the GDI and the MFC classes that encapsulate it is to write code. Let's start with a very simple application. Figure 2-12 contains the source code for Ruler, a program that draws a 12-inch ruler on the screen. Ruler's output is shown in Figure 2-11.

![click to view at full size.](https://flylib.com/books/4/348/1/html/2/f02mg11.jpg)

**Figure 2-11.** *The Ruler window.*

**Figure 2-12.** *The Ruler application.*

<table cellpadding="5" width="95%"><tbody><tr><td><h3>Ruler.h</h3><pre>class CMyApp : public CWinApp { public:     virtual BOOL InitInstance (); }; class CMainWindow : public CFrameWnd { public:     CMainWindow (); protected:     afx*msg void OnPaint ();     DECLARE*MESSAGE_MAP () }; </pre></td></tr></tbody></table>

<table cellpadding="5" width="95%"><tbody><tr><td><h3>Ruler.cpp</h3><pre># include &lt;afxwin.h&gt; # include "Ruler.h" CMyApp myApp; ///////////////////////////////////////////////////////////////////////// // CMyApp member functions BOOL CMyApp::InitInstance () {     m*pMainWnd = new CMainWindow;     m*pMainWnd-&gt;ShowWindow (m*nCmdShow);     m*pMainWnd-&gt;UpdateWindow ();     return TRUE; } ///////////////////////////////////////////////////////////////////////// // CMainWindow message map and member functions BEGIN*MESSAGE*MAP (CMainWindow, CFrameWnd)     ON*WM*PAINT () END*MESSAGE*MAP () CMainWindow::CMainWindow () {     Create (NULL, *T ("Ruler")); } void CMainWindow::OnPaint () {     CPaintDC dc (this);          //     // Initialize the device context.     //     dc.SetMapMode (MM*LOENGLISH);     dc.SetTextAlign (TA*CENTER ¦ TA*BOTTOM);     dc.SetBkMode (TRANSPARENT);     //     // Draw the body of the ruler.     //     CBrush brush (RGB (255, 255, 0));     CBrush* pOldBrush = dc.SelectObject (&amp;brush);     dc.Rectangle (100, -100, 1300, -200);     dc.SelectObject (pOldBrush);     //     // Draw the tick marks and labels.     //     for (int i=125; i&lt;1300; i+=25) {         dc.MoveTo (i, -192);         dc.LineTo (i, -200);     }     for (i=150; i&lt;1300; i+=50) {         dc.MoveTo (i, -184);         dc.LineTo (i, -200);     }     for (i=200; i&lt;1300; i+=100) {         dc.MoveTo (i, -175);         dc.LineTo (i, -200);         CString string;         string.Format (_T ("%d"), (i / 100) - 1);         dc.TextOut (i, -175, string);     } } </pre></td></tr></tbody></table>

The structure of Ruler is similar to that of the Hello application presented in Chapter 1. The *CMyApp* class represents the application itself. *CMyApp::InitInstance* creates a frame window by constructing a *CMainWindow* object, and *CMainWindow*'s constructor calls *Create* to create the window you see on the screen. *CMainWindow::OnPaint* handles all the drawing. The body of the ruler is drawn with *CDC::Rectangle,* and the hash marks are drawn with *CDC::LineTo* and *CDC::MoveTo*. Before the rectangle is drawn, a yellow brush is selected into the device context so that the body of the ruler will be painted yellow. Numeric labels are drawn with *CDC::TextOut* and positioned over the tick marks by calling *SetTextAlign* with TA\*CENTER and TA\*BOTTOM flags and passing *TextOut* the coordinates of the top of each tick mark. Before *TextOut* is called for the first time, the device context's background mode is set to TRANSPARENT. Otherwise, the numbers on the face of the ruler would be drawn with white backgrounds.

Rather than hardcode the strings passed to *TextOut*, Ruler uses *CString::Format* to generate text on the fly. *CString* is the MFC class that represents text strings. *CString::Format* works like C's *printf* function, converting numeric values to text and substituting them for placeholders in a formatting string. Windows programmers who work in C frequently use the *::wsprintf* API function for text formatting. *Format* does the same thing for *CString* objects without requiring an external function call. And unlike *::wsprintf*, *Format* supports the full range of *printf* formatting codes, including codes for floating-point and string variable types.

Ruler uses the MM\_LOENGLISH mapping mode to scale its output so that 1 inch on the ruler corresponds to 1 logical inch on the screen. Hold a real ruler up to the screen and on most PCs you'll find that 1 logical inch equals a little more than 1 physical inch. If the ruler is output to a printer instead, logical inches and physical inches will match exactly.