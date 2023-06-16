# Drawing with the GDI

[Previous page](https://flylib.com/books/en/4.348.1.11/1/)

[Table of content](javascript:;)

[Next page](https://flylib.com/books/en/4.348.1.13/1/)

\[Previous\] \[Next\]

Enough of the preliminaries. By now, you probably feel as if you asked for the time and got an explanation of watchmaking. Everything you've learned so far in this chapter will come in handy sooner or later—trust me. But now let's talk about functions for outputting pixels to the screen.

The functions discussed in the next several sections are by no means all of the available GDI output functions. A full treatment of every one would require a chapter much larger than this one. When you finish reading this chapter, look at the complete list of _CDC_ member functions in your MFC documentation. Doing so will give you a better feel for the wide-ranging scope of the Windows GDI and let you know where to go when you need help.

## Drawing Lines and Curves

MFC's _CDC_ class includes a number of member functions that you can use to draw lines and curves. The following table lists the key functions. There are others, but these paint a pretty good picture of the range of available line-drawing and curve-drawing functions.

**_CDC_ Functions for Drawing Lines and Curves**

| Function | Description |
| --- | --- |
| _MoveTo_ | Sets the current position in preparation for drawing |
| _LineTo_ | Draws a line from the current position to a specified position and moves the current position to the end of the line |
| _Polyline_ | Connects a set of points with line segments |
| _PolylineTo_ | Connects a set of points with line segments beginning with the current position and moves the current position to the end of the polyline |
| _Arc_ | Draws an arc |
| _ArcTo_ | Draws an arc and moves the current position to the end of the arc |
| _PolyBezier_ | Draws one or more Bézier splines |
| _PolyBezierTo_ | Draws one or more Bézier splines and moves the current position to the end of the final spline |
| _PolyDraw_ | Draws a series of line segments and Bézier splines through a set of points and moves the current position to the end of the final line segment or spline |

Drawing a straight line is simple. You just set the current position to one end of the line and call _LineTo_ with the coordinates of the other:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.MoveTo (0, 0); dc.LineTo (0, 100); </pre></td></tr></tbody></table>

To draw another line that's connected to the previous one, you call _LineTo_ again. There's no need to call _MoveTo_ a second time because the first call to _LineTo_ sets the current position to the end of the line:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.MoveTo (0, 0); dc.LineTo (0, 100); dc.LineTo (100, 100); </pre></td></tr></tbody></table>

You can draw several lines in one fell swoop using _Polyline_ or _PolylineTo_. The only difference between the two is that _PolylineTo_ uses the device context's current position and _Polyline_ does not. The following statements draw a box that measures 100 units to a side from a set of points describing the box's vertices:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>POINT aPoint[5] = { 0, 0, 0, 100, 100, 100, 100, 0, 0, 0 }; dc.Polyline (aPoint, 5); </pre></td></tr></tbody></table>

These statements draw the same box using _PolylineTo_:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.MoveTo (0, 0); POINT aPoint[4] = { 0, 100, 100, 100, 100, 0, 0, 0 }; dc.PolylineTo (aPoint, 4); </pre></td></tr></tbody></table>

When _PolylineTo_ returns, the current position is set to the endpoint of the final line segment—in this case, (0,0). If _Polyline_ is used instead, the current position is not altered.

Charles Petzold's _Programming Windows_ contains an excellent example showing how and why polylines can be useful. The following _OnPaint_ function, which is basically just an MFC adaptation of Charles's code, uses _CDC::Polyline_ to draw a sine wave that fills the interior of a window:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>#include &lt;math.h&gt; #define SEGMENTS 500 #define PI 3.1415926    <img src="https://flylib.com/books/4/348/1/html/2/grayvellip.jpg" width="3" height="13" border="0"> void CMainWindow::OnPaint () {     CRect rect;     GetClientRect (&amp;rect);     int nWidth = rect.Width ();     int nHeight = rect.Height ();     CPaintDC dc (this);     CPoint aPoint[SEGMENTS];     for (int i=0; i&lt;SEGMENTS; i++) {         aPoint[i].x = (i * nWidth) / SEGMENTS;         aPoint[i].y = (int) ((nHeight / 2) *             (1 - (sin ((2 * PI * i) / SEGMENTS))));     }     dc.Polyline (aPoint, SEGMENTS); } </pre></td></tr></tbody></table>

You can see the results for yourself by substituting this code for the _OnPaint_ function in Chapter 1's Hello program. Note the use of the _CRect_ functions _Width_ and _Height_ to compute the width and height of the window's client area.

An arc is a curve taken from the circumference of a circle or an ellipse. You can draw arcs quite easily with _CDC::Arc_. You just pass it a rectangle whose borders circumscribe the ellipse and a pair of points that specify the endpoints of two imaginary lines drawn outward from the center of the ellipse. The points at which the lines intersect the ellipse are the starting and ending points of the arc. (The lines must be long enough to at least touch the circumference of the ellipse; otherwise, the results won't be what you expect.) The following code draws an arc representing the upper left quadrant of an ellipse that is 200 units wide and 100 units high:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CRect rect (0, 0, 200, 100); CPoint point1 (0, -500); CPoint point2 (-500, 0); dc.Arc (rect, point1, point2); </pre></td></tr></tbody></table>

To reverse the arc and draw the upper right, lower right, and lower left quadrants of the ellipse, simply reverse the order in which _point1_ and _point2_ are passed to the _Arc_ function. If you'd like to know where the arc ended (an item of information that's useful when using lines and arcs to draw three-dimensional pie charts), use _ArcTo_ instead of _Arc_ and then use _CDC::GetCurrentPosition_ to locate the endpoint. Be careful, though. In addition to drawing the arc itself, _ArcTo_ draws a line from the old current position to the arc's starting point. What's more, _ArcTo_ is one of a handful of GDI functions that's not implemented in Windows 98. If you call it on a platform other than Windows NT or Windows 2000, nothing will be output.

If splines are more your style, the GDI can help out there, too. _CDC::PolyBezier_ draws Bézier splines—smooth curves defined by two endpoints and two intermediate points that exert "pull." Originally devised to help engineers build mathematical models of car bodies, Bézier splines, or simply "Béziers," as they are more often known, are used today in everything from fonts to warhead designs. The following code fragment uses two Bézier splines to draw a figure that resembles the famous Nike "swoosh" symbol. (See Figure 2-2.)

<table cellpadding="5" width="95%"><tbody><tr><td><pre>POINT aPoint1[4] = { 120, 100, 120, 200, 250, 150, 500, 40 }; POINT aPoint2[4] = { 120, 100,  50, 350, 250, 200, 500, 40 }; dc.PolyBezier (aPoint1, 4); dc.PolyBezier (aPoint2, 4); </pre></td></tr></tbody></table>

The curves drawn here are independent splines that happen to join at the endpoints. To draw a continuous curve by joining two or more splines, add three points to the POINT array for each additional spline and increase the number of points specified in _PolyBezier_'s second parameter accordingly.

![click to view at full size.](https://flylib.com/books/4/348/1/html/2/f02mg02.jpg)

**Figure 2-2.** _A famous shoe logo drawn with Bézier splines._

One peculiarity of all GDI line-drawing and curve-drawing functions is that the final pixel is never drawn. If you draw a line from (0,0) to (100,100) with the statements

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.MoveTo (0, 0); dc.LineTo (100, 100); </pre></td></tr></tbody></table>

the pixel at (0,0) is set to the line color, as are the pixels at (1,1), (2,2), and so on. But the pixel at (100,100) is still the color it was before. If you want the line's final pixel to be drawn, too, you must draw it yourself. One way to do that is to use the _CDC::SetPixel_ function, which sets a single pixel to the color you specify.

## Drawing Ellipses, Polygons, and Other Shapes

The GDI doesn't limit you to simple lines and curves. It also lets you draw ellipses, rectangles, pie-shaped wedges, and other closed figures. MFC's _CDC_ class wraps the associated GDI functions in handy class member functions that you can call on a device context object or through a pointer to a device context object. The following table lists a few of those functions.

**_CDC_ Functions for Drawing Closed Figures**

| Function | Description |
| --- | --- |
| _Chord_ | Draws a closed figure bounded by the intersection of an ellipse and a line |
| _Ellipse_ | Draws a circle or an ellipse |
| _Pie_ | Draws a pie-shaped wedge |
| _Polygon_ | Connects a set of points to form a polygon |
| _Rectangle_ | Draws a rectangle with square corners |
| _RoundRect_ | Draws a rectangle with rounded corners |

GDI functions that draw closed figures take as a parameter the coordinates of a "bounding box." When you draw a circle with the _Ellipse_ function, for example, you don't specify a center point and a radius; instead, you specify the circle's bounding box. You can pass the coordinates explicitly, like this:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.Ellipse (0, 0, 100, 100); </pre></td></tr></tbody></table>

or pass them in a RECT structure or a _CRect_ object, like this:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CRect rect (0, 0, 100, 100); dc.Ellipse (rect); </pre></td></tr></tbody></table>

When this circle is drawn, it touches the _x_\=0 line at the left of the bounding box and the _y_\=0 line at the top, but it falls 1 pixel short of the _x_\=100 line at the right and 1 pixel short of the _y_\=100 line at the bottom. In other words, figures are drawn from the left and upper limits of the bounding box up to (but not including) the right and lower limits. If you call the _CDC::Rectangle_ function, like this:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.Rectangle (0, 0, 8, 4); </pre></td></tr></tbody></table>

you get the output shown in Figure 2-3. Observe that the right and lower limits of the rectangle fall at _x_\=7 and _y_\=3, not _x_\=8 and _y_\=4.

![click to view at full size.](https://flylib.com/books/4/348/1/html/2/f02mg03.jpg)

**Figure 2-3.** _A rectangle drawn with the statement dc.Rectangle (0, 0, 8, 4)._

_Rectangle_ and _Ellipse_ are about as straightforward as they come. You provide the bounding box, and Windows does the drawing. If you want to draw a rectangle that has rounded corners, use _RoundRect_ instead of _Rectangle_.

The _Pie_ and _Chord_ functions merit closer scrutiny, however. Both are syntactically identical to the _Arc_ function discussed in the previous section. The difference is in the output. (See Figure 2-4.) _Pie_ draws a closed figure by drawing straight lines connecting the ends of the arc to the center of the ellipse. _Chord_ closes the figure by connecting the arc's endpoints. The following _OnPaint_ handler uses _Pie_ to draw a pie chart that depicts four quarterly revenue values:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>#include &lt;math.h&gt; #define PI 3.1415926    <img src="https://flylib.com/books/4/348/1/html/2/grayvellip.jpg" width="3" height="13" border="0"> void CMainWindow::OnPaint () {     CPaintDC dc (this);     int nRevenues[4] = { 125, 376, 252, 184 };     CRect rect;     GetClientRect (&amp;rect);     dc.SetViewportOrg (rect.Width () / 2, rect.Height () / 2);     int nTotal = 0;     for (int i=0; i&lt;4; i++)         nTotal += nRevenues[i];     int x1 = 0;     int y1 = -1000;     int nSum = 0;     for (i=0; i&lt;4; i++) {         nSum += nRevenues[i];         double rad = ((double) (nSum * 2 * PI) / (double) nTotal) + PI;         int x2 = (int) (sin (rad) * 1000);         int y2 = (int) (cos (rad) * 1000 * 3) / 4;         dc.Pie (-200, -150, 200, 150, x1, y1, x2, y2);         x1 = x2;         y1 = y2;     } } </pre></td></tr></tbody></table>

Note that the origin is moved to the center of the window with _SetViewportOrg_ before any drawing takes place so that the chart will also be centered.

![](https://flylib.com/books/4/348/1/html/2/f02mg04.gif)

**Figure 2-4.** _Output from the Arc, Chord, and Pie functions._

## GDI Pens and the _CPen_ Class

Windows uses the pen that is currently selected into the device context to draw lines and curves and also to border figures drawn with _Rectangle_, _Ellipse_, and other shape-drawing functions. The default pen draws solid black lines that are 1 pixel wide. To change the way lines are drawn, you must create a GDI pen and select it into the device context with _CDC::SelectObject_.

MFC represents GDI pens with the class _CPen_. The simplest way to create a pen is to construct a _CPen_ object and pass it the parameters defining the pen:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen (PS_SOLID, 1, RGB (255, 0, 0)); </pre></td></tr></tbody></table>

A second way to create a GDI pen is to construct an uninitialized _CPen_ object and call _CPen::CreatePen_:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen; pen.CreatePen (PS_SOLID, 1, RGB (255, 0, 0)); </pre></td></tr></tbody></table>

Yet a third method is to construct an uninitialized _CPen_ object, fill in a LOGPEN structure describing the pen, and then call _CPen::CreatePenIndirect_ to create the pen:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen; LOGPEN lp; lp.lopnStyle = PS_SOLID; lp.lopnWidth.x = 1; lp.lopnColor = RGB (255, 0, 0); pen.CreatePenIndirect (&amp;lp); </pre></td></tr></tbody></table>

LOGPEN's _lopnWidth_ field is a POINT data structure. The structure's _x_ data member specifies the pen width. The _y_ data member is not used.

_CreatePen_ and _CreatePenIndirect_ return TRUE if a pen is successfully created, FALSE if it is not. If you allow _CPen_'s constructor to create the pen, an exception of type _CResourceException_ is thrown if the pen can't be created. This should happen only if Windows is critically low on memory.

A pen has three defining characteristics: style, width, and color. The examples above create a pen whose style is PS\_SOLID, whose width is 1, and whose color is bright red. The first of the three parameters passed to _CPen::CPen_ and _CPen::CreatePen_ specifies the pen style, which defines the type of line the pen draws. PS\_SOLID creates a pen that draws solid, unbroken lines. Other pen styles are shown in Figure 2-5.

![](https://flylib.com/books/4/348/1/html/2/f02mg05.gif)

**Figure 2-5.** _Pen styles._

The special PS\_INSIDEFRAME style draws solid lines that stay within the bounding rectangle, or "inside the frame," of the figure being drawn. If you use any of the other pen styles to draw a circle whose diameter is 100 units using a PS\_SOLID pen that is 20 units wide, for example, the actual diameter of the circle, measured across the circle's outside edge, is 120 units, as shown in Figure 2-6. Why? Because the border drawn by the pen extends 10 units outward on either side of the theoretical circle. Draw the same circle with a PS\_INSIDEFRAME pen, and the diameter is exactly 100 units. The PS\_INSIDEFRAME style does not affect lines drawn with _LineTo_ and other functions that don't use a bounding rectangle.

![click to view at full size.](https://flylib.com/books/4/348/1/html/2/f02mg06.jpg)

**Figure 2-6.** _The PS\_INSIDEFRAME pen style._

The pen style PS\_NULL creates what Windows programmers refer to as a "NULL pen." Why would you ever want to create a NULL pen? Believe it or not, there are times when a NULL pen can come in handy. Suppose, for example, that you want to draw a solid red circle with no border. If you draw the circle with MFC's _CDC::Ellipse_ function, Windows automatically borders the circle with the pen currently selected into the device context. You can't tell the _Ellipse_ function that you don't want a border, but you _can_ select a NULL pen into the device context so that the circle will have no visible border. NULL brushes are used in a similar way. If you want the circle to have a border but want the interior of the circle to be transparent, you can select a NULL brush into the device context before you draw.

The second parameter passed to _CPen_'s pen-create functions specifies the width of the lines drawn with the pen. Pen widths are specified in logical units whose physical meanings depend on the current mapping mode. You can create PS\_SOLID, PS\_NULL, and PS\_INSIDEFRAME pens of any logical width, but PS\_DASH, PS\_DOT, PS\_DASHDOT, and PS\_DASHDOTDOT pens must be 1 logical unit wide. Specifying a pen width of 0 in any style creates a pen that is 1 pixel wide, no matter what the mapping mode.

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

The ellipse is filled with the color or pattern of the current brush, which defaults to white. To change the default, you need to create a GDI brush and select it into the device context before calling _Ellipse_. I'll demonstrate how to do that in just a moment.

### Extended Pens

If none of the basic pen styles suits your needs, you can use a separate class of pens known as "extended" pens, which the Windows GDI and MFC's _CPen_ class support. These pens offer a greater variety of output options. For example, you can create an extended pen that draws a pattern described by a bitmap image or uses a dithered color. You can also exercise precise control over endpoints and joins by specifying the end cap style (flat, round, or square) and join style (beveled, mitered, or rounded). The following code creates an extended pen 16 units wide that draws solid green lines with flat ends. Where two lines meet, the adjoining ends are rounded to form a smooth intersection:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>LOGBRUSH lb; lb.lbStyle = BS_SOLID; lb.lbColor = RGB (0, 255, 0); CPen pen (PS_GEOMETRIC ¦ PS_SOLID ¦ PS_ENDCAP_FLAT ¦     PS_JOIN_ROUND, 16, &amp;lb); </pre></td></tr></tbody></table>

Windows places several restrictions on the use of extended pens, not the least of which is that endpoint joins will work only if the figure is first drawn as a "path" and is then rendered with _CDC::StrokePath_ or a related function. You define a path by enclosing drawing commands between calls to _CDC::BeginPath_ and _CDC::EndPath_, as shown here:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.BeginPath ();        // Begin the path definition dc.MoveTo (0, 0);       // Create a triangular path dc.LineTo (100, 200); dc.LineTo (200, 100); dc.CloseFigure (); dc.EndPath ();          // End the path definition dc.StrokePath ();       // Draw the triangle </pre></td></tr></tbody></table>

Paths are a powerful feature of the GDI that you can use to create all sorts of interesting effects. We'll look more closely at paths—and at the _CDC_ functions that use them—in Chapter 15.

## GDI Brushes and the _CBrush_ Class

By default, closed figures drawn with _Rectangle_, _Ellipse_, and other _CDC_ output functions are filled with white pixels. You can change the fill color by creating a GDI brush and selecting it into the device context prior to drawing.

MFC's _CBrush_ class encapsulates GDI brushes. Brushes come in three basic varieties: solid, hatch, and pattern. Solid brushes paint with solid colors. If the display hardware won't allow a solid brush color to be displayed directly, Windows simulates the color by dithering colors that _can_ be displayed. A hatch brush paints with one of six predefined crosshatch patterns that are similar to ones commonly found in engineering and architectural drawings. A pattern brush paints with a bitmap. The _CBrush_ class provides a constructor for each different brush style.

You can create a solid brush in one step by passing a COLORREF value to the _CBrush_ constructor:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CBrush brush (RGB (255, 0, 0)); </pre></td></tr></tbody></table>

Or you can create a solid brush in two steps by creating an uninitialized _CBrush_ object and calling _CBrush::CreateSolidBrush_:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CBrush brush; brush.CreateSolidBrush (RGB (255, 0, 0)); </pre></td></tr></tbody></table>

Both examples create a solid brush that paints in bright red. You can also create a brush by initializing a LOGBRUSH structure and calling _CBrush::CreateBrushIndirect_. As with _CPen_ constructors, all _CBrush_ constructors that create a brush for you throw a resource exception if the GDI is low on memory and a brush can't be created.

Hatch brushes are created by passing _CBrush_'s constructor both a hatch index and a COLORREF value or by calling _CBrush::CreateHatchBrush_. The statement

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CBrush brush (HS_DIAGCROSS, RGB (255, 0, 0)); </pre></td></tr></tbody></table>

creates a hatch brush that paints perpendicular crosshatch lines oriented at 45-degree angles, as do these statements:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CBrush brush; brush.CreateHatchBrush (HS_DIAGCROSS, RGB (255, 0, 0)); </pre></td></tr></tbody></table>

HS\_DIAGCROSS is one of six hatch styles you can choose from. (See Figure 2-7.) When you paint with a hatch brush, Windows fills the space between hatch lines with the default background color (white) unless you change the device context's current background color with _CDC::SetBkColor_ or turn off background fills by changing the background mode from OPAQUE to TRANSPARENT with _CDC::SetBkMode_. The statements

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CBrush brush (HS_DIAGCROSS, RGB (255, 255, 255)); dc.SelectObject (&amp;brush); dc.SetBkColor (RGB (192, 192, 192)); dc.Rectangle (0, 0, 100, 100); </pre></td></tr></tbody></table>

draw a rectangle 100 units square and fill it with white crosshatch lines drawn against a light gray background. The statements

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CBrush brush (HS_DIAGCROSS, RGB (0, 0, 0)); dc.SelectObject (&amp;brush); dc.SetBkMode (TRANSPARENT); dc.Rectangle (0, 0, 100, 100); </pre></td></tr></tbody></table>

draw a black crosshatched rectangle against the existing background.

![click to view at full size.](https://flylib.com/books/4/348/1/html/2/f02mg07.jpg)

**Figure 2-7.** _Hatch brush styles._

### The Brush Origin

One attribute of a device context that you should be aware of when using dithered brush colors or hatch brushes is the brush origin. When Windows fills an area with a hatched or dithered brush pattern, it tiles an 8-pixel by 8-pixel pattern horizontally and vertically within the affected area. By default, the origin for this pattern, better known as the _brush origin,_ is the device point (0,0)—the screen pixel in the upper left corner of the window. This means that a pattern drawn in a rectangle that begins 100 pixels to the right of and below the origin will be aligned somewhat differently with respect to the rectangle's border than a pattern drawn in a rectangle positioned a few pixels to the left or right, as shown in Figure 2-8. In many applications, it doesn't matter; the user isn't likely to notice minute differences in brush alignment. However, in some situations it matters a great deal.

![click to view at full size.](https://flylib.com/books/4/348/1/html/2/f02mg08.jpg)

**Figure 2-8.** _Brush alignment._

Suppose you're using a hatch brush to fill a rectangle and you're animating the motion of that rectangle by repeatedly erasing it and redrawing it 1 pixel to the right or the left. If you don't reset the brush origin to a point that stays in the same position relative to the rectangle before each redraw, the hatch pattern will "walk" as the rectangle moves.

The solution? Before selecting the brush into the device context and drawing the rectangle, call _CGdiObject::UnrealizeObject_ on the brush object to permit the brush origin to be moved. Then call _CDC::SetBrushOrg_ to align the brush origin with the rectangle's upper left corner, as shown here:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPoint point (x1, y1); dc.LPtoDP (&amp;point); point.x %= 8; point.y %= 8; brush.UnrealizeObject (); dc.SetBrushOrg (point); dc.SelectObject (&amp;brush); dc.Rectangle (x1, y1, x2, y2); </pre></td></tr></tbody></table>

In this example, _point_ is a _CPoint_ object that holds the logical coordinates of the rectangle's upper left corner. _LPtoDP_ is called to convert logical coordinates into device coordinates (brush origins are always specified in device coordinates), and a modulo-8 operation is performed on the resulting values because coordinates passed to _SetBrushOrg_ should fall within the range 0 through 7. Now the hatch pattern will be aligned consistently no matter where in the window the rectangle is drawn.

## Drawing Text

You've already seen one way to output text to a window. The _CDC::DrawText_ function writes a string of text to a display surface. You tell _DrawText_ where to draw its output by specifying both a formatting rectangle and a series of option flags indicating how the text is to be positioned within the rectangle. In Chapter 1's Hello program, the statement

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.DrawText (_T ("Hello, MFC"), -1, &amp;rect,     DT_SINGLELINE ¦ DT_CENTER ¦ DT_VCENTER); </pre></td></tr></tbody></table>

drew "Hello, MFC" so that it was centered in the window. _rect_ was a rectangle object initialized with the coordinates of the window's client area, and the DT\_CENTER and DT\_VCENTER flags told _DrawText_ to center its output in the rectangle both horizontally and vertically.

_DrawText_ is one of several text-related functions that are members of MFC's _CDC_ class. Some of the others are listed in the table below. One of the most useful is _TextOut_, which outputs text like _DrawText_ but accepts an _x_\-_y_ coordinate pair that specifies where the text will be output and also uses the current position if it is asked to. The statement

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.TextOut (0, 0, CString (_T ("Hello, MFC"))); </pre></td></tr></tbody></table>

writes "Hello, MFC" to the upper left of the display surface represented by _dc_. A related function named _TabbedTextOut_ works just like _TextOut_ except that it expands tab characters into white space. (If a string passed to _TextOut_ contains tabs, the characters show up as rectangles in most fonts.) Tab positions are specified in the call to _TabbedTextOut_. A related function named _ExtTextOut_ gives you the added option of filling a rectangle surrounding the output text with an opaque background color. It also gives the programmer precise control over intercharacter spacing.

By default, the coordinates passed to _TextOut_, _TabbedTextOut_, and _ExtTextOut_ specify the location of the upper left corner of the text's leftmost character cell. However, the relationship between the coordinates passed to _TextOut_ and the characters in the output string, a property known as the _text alignment_, is an attribute of the device context. You can change it with _CDC::SetTextAlign_. For example, after a

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.SetTextAlign (TA_RIGHT); </pre></td></tr></tbody></table>

statement is executed, the _x_ coordinate passed to _TextOut_ specifies the rightmost position in the character cell—perfect for drawing right-aligned text.

You can also call _SetTextAlign_ with a TA\_UPDATECP flag to instruct _TextOut_ to ignore the _x_ and _y_ arguments passed to it and use the device context's current position instead. When the text alignment includes TA\_UPDATECP, _TextOut_ updates the _x_ component of the current position each time a string is output. One use for this feature is to achieve proper spacing between two or more character strings that are output on the same line.

**_CDC_ Text Functions**

| Function | Description |
| --- | --- |
| _DrawText_ | Draws text in a formatting rectangle |
| _TextOut_ | Outputs a line of text at the current or specified position |
| _TabbedTextOut_ | Outputs a line of text that includes tabs |
| _ExtTextOut_ | Outputs a line of text and optionally fills a rectangle with a background color or varies the intercharacter spacing |
| _GetTextExtent_ | Computes the width of a string in the current font |
| _GetTabbedTextExtent_ | Computes the width of a string with tabs in the current font |
| _GetTextMetrics_ | Returns font metrics (character height, average character width, and so on) for the current font |
| _SetTextAlign_ | Sets alignment parameters for _TextOut_ and other output functions |
| _SetTextJustification_ | Specifies the added width that is needed to justify a string of text |
| _SetTextColor_ | Sets the device context's text output color |
| _SetBkColor_ | Sets the device context's background color, which determines the fill color used behind characters that are output to a display surface |

Two functions—_GetTextMetrics_ and _GetTextExtent_—let you retrieve information about the font that is currently selected into the device context. _GetTextMetrics_ fills a TEXTMETRIC structure with information on the characters that make up the font. _GetTextExtent_ returns the width of a given string, in logical units, rendered in that font. (Use _GetTabbedTextExtent_ if the string contains tab characters.) One use for _GetTextExtent_ is to gauge the width of a string prior to outputting it in order to compute how much space is needed between words to fully justify the text. If _nWidth_ is the distance between left and right margins, the following code outputs the text "Now is the time" and justifies the output to both margins:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CString string = _T ("Now is the time"); CSize size = dc.GetTextExtent (string); dc.SetTextJustification (nWidth - size.cx, 3); dc.TextOut (0, y, string); </pre></td></tr></tbody></table>

The second parameter passed to _SetTextJustification_ specifies the number of break characters in the string. The default break character is the space character. After _SetTextJustification_ is called, subsequent calls to _TextOut_ and related text output functions distribute the space specified in the _SetTextJustification_'s first parameter evenly between all the break characters.

## GDI Fonts and the _CFont_ Class

All _CDC_ text functions use the font that is currently selected into the device context. A _font_ is a group of characters of a particular size (height) and typeface that share common attributes such as character weight—for example, normal or boldface. In classical typography, font sizes are measured in units called _points_. One point equals about 1/72 inch. Each character in a 12-point font is nominally 1/6 inch tall, but in Windows, the actual height can vary somewhat depending on the physical characteristics of the output device. The term _typeface_ describes a font's basic style. Times New Roman is one example of a typeface; Courier New is another.

A font is a GDI object, just as a pen or a brush is. In MFC, fonts are represented by objects of the _CFont_ class. Once a _CFont_ object is constructed, you create the underlying GDI font by calling the _CFont_ object's _CreateFont_, _CreateFontIndirect_, _CreatePointFont_, or _CreatePointFontIndirect_ function. Use _CreateFont_ or _CreateFontIndirect_ if you want to specify the font size in pixels, and use _CreatePointFont_ and _CreatePointFontIndirect_ to specify the font size in points. Creating a 12-point Times New Roman screen font with _CreatePointFont_ requires just two lines of code:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CFont font; font.CreatePointFont (120, _T ("Times New Roman")); </pre></td></tr></tbody></table>

Doing the same with _CreateFont_ requires you to query the device context for the logical number of pixels per inch in the vertical direction and to convert points to pixels:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CClientDC dc (this); int nHeight = -((dc.GetDeviceCaps (LOGPIXELSY) * 12) / 72); CFont font; font.CreateFont (nHeight, 0, 0, 0, FW_NORMAL, 0, 0, 0,     DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS,     DEFAULT_QUALITY, DEFAULT_PITCH ¦ FF_DONTCARE,     _T ("Times New Roman")); </pre></td></tr></tbody></table>

Incidentally, the numeric value passed to _CreatePointFont_ is the desired point size _times 10_. This allows you to control the font size down to 1/10 point—plenty accurate enough for most applications, considering the relatively low resolution of most screens and other commonly used output devices.

The many parameters passed to _CreateFont_ specify, among other things, the font weight and whether characters in the font are italicized. You can't create a bold, italic font with _CreatePointFont_, but you can with _CreatePointFontIndirect_. The following code creates a 12-point bold, italic Times New Roman font using _CreatePointFontIndirect_.

<table cellpadding="5" width="95%"><tbody><tr><td><pre>LOGFONT lf; ::ZeroMemory (&amp;lf, sizeof (lf)); lf.lfHeight = 120; lf.lfWeight = FW_BOLD; lf.lfItalic = TRUE; ::lstrcpy (lf.lfFaceName, _T ("Times New Roman")); CFont font; font.CreatePointFontIndirect (&amp;lf); </pre></td></tr></tbody></table>

LOGFONT is a structure whose fields define all the characteristics of a font. _::ZeroMemory_ is an API function that zeroes a block of memory, and _::lstrcpy_ is an API function that copies a text string from one memory location to another. You can use the C run time's _memset_ and _strcpy_ functions instead (actually, you should use _\_tcscpy_ in lieu of _strcpy_ so the call will work with ANSI or Unicode characters), but using Windows API functions frequently makes an executable smaller by reducing the amount of statically linked code.

After creating a font, you can select it into a device context and draw with it using _DrawText_, _TextOut_, and other _CDC_ text functions. The following _OnPaint_ handler draws "Hello, MFC" in the center of a window. But this time the text is drawn using a 72-point Arial typeface, complete with drop shadows. (See Figure 2-9.)

<table cellpadding="5" width="95%"><tbody><tr><td><pre>void CMainWindow::OnPaint () {     CRect rect;     GetClientRect (&amp;rect);     CFont font;     font.CreatePointFont (720, _T ("Arial"));     CPaintDC dc (this);     dc.SelectObject (&amp;font);     dc.SetBkMode (TRANSPARENT);     CString string = _T ("Hello, MFC");     rect.OffsetRect (16, 16);     dc.SetTextColor (RGB (192, 192, 192));     dc.DrawText (string, &amp;rect, DT_SINGLELINE ¦         DT_CENTER ¦ DT_VCENTER);     rect.OffsetRect (-16, -16);     dc.SetTextColor (RGB (0, 0, 0));     dc.DrawText (string, &amp;rect, DT_SINGLELINE ¦         DT_CENTER ¦ DT_VCENTER); } </pre></td></tr></tbody></table>

![click to view at full size.](https://flylib.com/books/4/348/1/html/2/f02mg09.jpg)

**Figure 2-9.** _"Hello, MFC" rendered in 72-point Arial with drop shadows._

The shadow effect is achieved by drawing the text string twice—once a few pixels to the right of and below the center of the window, and once in the center. MFC's _CRect::OffsetRect_ function makes it a snap to "move" rectangles by offsetting them a specified distance in the _x_ and _y_ directions.

What happens if you try to create, say, a Times New Roman font on a system that doesn't have Times New Roman installed? Rather than fail the call, the GDI will pick a similar typeface that _is_ installed. An internal font-mapping algorithm is called to pick the best match, and the results aren't always what one might expect. But at least your application won't output text just fine on one system and mysteriously output nothing on another.

## Raster Fonts vs. TrueType Fonts

Most GDI fonts fall into one of two categories: raster fonts and TrueType fonts. Raster fonts are stored as bitmaps and look best when they're displayed in their native sizes. One of the most useful raster fonts provided with Windows is MS Sans Serif, which is commonly used (in its 8-point size) on push buttons, radio buttons, and other dialog box controls. Windows can scale raster fonts by duplicating rows and columns of pixels, but the results are rarely pleasing to the eye due to stair-stepping effects.

The best fonts are TrueType fonts because they scale well to virtually any size. Like PostScript fonts, TrueType fonts store character outlines as mathematical formulas. They also include "hint" information that's used by the GDI's TrueType font rasterizer to enhance scalability. You can pretty much bank on the fact that any system your application runs on will have the following TrueType fonts installed, because all four are provided with Windows:

-   Times New Roman

-   Arial

-   Courier New

-   Symbol

In Chapter 7, you'll learn how to query the system for font information and how to enumerate the fonts that are installed. Such information can be useful if your application requires precise character output or if you want to present a list of installed fonts to the user.

## Rotated Text

One question that's frequently asked about GDI text output is "How do I display rotated text?" There are two ways to do it, one of which works only in Microsoft Windows NT and Windows 2000. The other method is compatible with all 32-bit versions of Windows, so it's the one I'll describe here.

The secret is to create a font with _CFont::CreateFontIndirect_ or _CFont::CreatePointFontIndirect_ and to specify the desired rotation angle (in degrees) times 10 in the LOGFONT structure's _lfEscapement_ and _lfOrientation_ fields. Then you output the text in the normal manner—for example, using _CDC::TextOut_. Conventional text has an escapement and orientation of 0; that is, it has no slant and is drawn on a horizontal. Setting these values to 450 rotates the text counterclockwise 45 degrees. The following _OnPaint_ handler increments _lfEscapement_ and _lfOrientation_ in units of 15 degrees and uses the resulting fonts to draw the radial text array shown in Figure 2-10:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>void CMainWindow::OnPaint () {     CRect rect;     GetClientRect (&amp;rect);     CPaintDC dc (this);     dc.SetViewportOrg (rect.Width () / 2, rect.Height () / 2);     dc.SetBkMode (TRANSPARENT);     for (int i=0; i&lt;3600; i+=150) {         LOGFONT lf;         ::ZeroMemory (&amp;lf, sizeof (lf));         lf.lfHeight = 160;         lf.lfWeight = FW_BOLD;         lf.lfEscapement = i;         lf.lfOrientation = i;         ::lstrcpy (lf.lfFaceName, _T ("Arial"));         CFont font;         font.CreatePointFontIndirect (&amp;lf);         CFont* pOldFont = dc.SelectObject (&amp;font);         dc.TextOut (0, 0, CString (_T ("          Hello, MFC")));         dc.SelectObject (pOldFont);     } } </pre></td></tr></tbody></table>

This technique works great with TrueType fonts, but it doesn't work at all with raster fonts.

![click to view at full size.](https://flylib.com/books/4/348/1/html/2/f02mg10.jpg)

**Figure 2-10.** _Rotated text._

## Stock Objects

Windows predefines a handful of pens, brushes, fonts, and other GDI objects that can be used without being explicitly created. Called _stock objects_, these GDI objects can be selected into a device context with the _CDC::SelectStockObject_ function or assigned to an existing _CPen_, _CBrush_, or other object with _CGdiObject::CreateStockObject_. _CGdiObject_ is the base class for _CPen_, _CBrush_, _CFont_, and other MFC classes that represent GDI objects.

The following table shows a partial list of the available stock objects. Stock pens go by the names WHITE\_PEN, BLACK\_PEN, and NULL\_PEN. WHITE\_PEN and BLACK\_PEN draw solid lines that are 1 pixel wide. NULL\_PEN draws nothing. The stock brushes include one white brush, one black brush, and three shades of gray. HOLLOW\_BRUSH and NULL\_BRUSH are two different ways of referring to the same thing—a brush that paints nothing. SYSTEM\_FONT is the font that's selected into every device context by default.

**Commonly Used Stock Objects**

| Object | Description |
| --- | --- |
| NULL\_PEN | Pen that draws nothing |
| BLACK\_PEN | Black pen that draws solid lines 1 pixel wide |
| WHITE\_PEN | White pen that draws solid lines 1 pixel wide |
| NULL\_BRUSH | Brush that draws nothing |
| HOLLOW\_BRUSH | Brush that draws nothing (same as NULL\_BRUSH) |
| BLACK\_BRUSH | Black brush |
| DKGRAY\_BRUSH | Dark gray brush |
| GRAY\_BRUSH | Medium gray brush |
| LTGRAY\_BRUSH | Light gray brush |
| WHITE\_BRUSH | White brush |
| ANSI\_FIXED\_FONT | Fixed-pitch ANSI font |
| ANSI\_VAR\_FONT | Variable-pitch ANSI font |
| SYSTEM\_FONT | Variable-pitch system font |
| SYSTEM\_FIXED\_FONT | Fixed-pitch system font |

Suppose you want to draw a light gray circle with no border. How do you do it? Here's one way:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen (PS_NULL, 0, (RGB (0, 0, 0))); dc.SelectObject (&amp;pen); CBrush brush (RGB (192, 192, 192)); dc.SelectObject (&amp;brush); dc.Ellipse (0, 0, 100, 100); </pre></td></tr></tbody></table>

But since NULL pens and light gray brushes are stock objects, here's a better way:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.SelectStockObject (NULL_PEN); dc.SelectStockObject (LTGRAY_BRUSH); dc.Ellipse (0, 0, 100, 100); </pre></td></tr></tbody></table>

The following code demonstrates a third way to draw the circle. This time the stock objects are assigned to a _CPen_ and a _CBrush_ rather than selected into the device context directly:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen; pen.CreateStockObject (NULL_PEN); dc.SelectObject (&amp;pen); CBrush brush; brush.CreateStockObject (LTGRAY_BRUSH); dc.SelectObject (&amp;brush); dc.Ellipse (0, 0, 100, 100); </pre></td></tr></tbody></table>

Which of the three methods you use is up to you. The second method is the shortest, and it's the only one that's guaranteed not to throw an exception since it doesn't create any GDI objects.

## Deleting GDI Objects

Pens, brushes, and other objects created from _CGdiObject_\-derived classes are resources that consume space in memory, so it's important to delete them when you no longer need them. If you create a _CPen_, _CBrush_, _CFont_, or other _CGdiObject_ on the stack, the associated GDI object is automatically deleted when _CGdiObject_ goes out of scope. If you create a _CGdiObject_ on the heap with _new_, be sure to delete it at some point so that its destructor will be called. The GDI object associated with a _CGdiObject_ can be explicitly deleted by calling _CGdiObject::DeleteObject_. You never need to delete stock objects, even if they are "created" with _CreateStockObject_.

In 16-bit Windows, GDI objects frequently contributed to the problem of resource leakage, in which the Free System Resources figure reported by Program Manager gradually decreased as applications were started and terminated because some programs failed to delete the GDI objects they created. All 32-bit versions of Windows track the resources a program allocates and deletes them when the program ends. However, it's _still_ important to delete GDI objects when they're no longer needed so that the GDI doesn't run out of memory while a program is running. Imagine an _OnPaint_ handler that creates 10 pens and brushes every time it's called but neglects to delete them. Over time, _OnPaint_ might create thousands of GDI objects that occupy space in system memory owned by the Windows GDI. Pretty soon, calls to create pens and brushes will fail, and the application's _OnPaint_ handler will mysteriously stop working.

In Visual C++, there's an easy way to tell whether you're failing to delete pens, brushes, and other resources: Simply run a debug build of your application in debugging mode. When the application terminates, resources that weren't freed will be listed in the debugging window. MFC tracks memory allocations for _CPen_, _CBrush_, and other _CObject_\-derived classes so that it can notify you when an object hasn't been deleted. If you have difficulty ascertaining from the debug messages which objects weren't deleted, add the statement

<table cellpadding="5" width="95%"><tbody><tr><td><pre>#define new DEBUG_NEW </pre></td></tr></tbody></table>

to your application's source code files after the statement that includes Afxwin.h. (In AppWizard-generated applications, this statement is included automatically.) Debug messages for unfreed objects will then include line numbers and file names to help you pinpoint leaks.

## Deselecting GDI Objects

It's important to delete the GDI objects you create, but it's equally important to never delete a GDI object while it's selected into a device context. Code that attempts to paint with a deleted object is buggy code. The only reason it doesn't crash is that the Windows GDI is sprinkled with error-checking code to prevent such crashes from occurring.

Abiding by this rule isn't as easy as it sounds. The following _OnPaint_ handler allows a brush to be deleted while it's selected into a device context. Can you figure out why?

<table cellpadding="5" width="95%"><tbody><tr><td><pre>void CMainWindow::OnPaint () {     CPaintDC dc (this);     CBrush brush (RGB (255, 0, 0));     dc.SelectObject (&amp;brush);     dc.Ellipse (0, 0, 200, 100); } </pre></td></tr></tbody></table>

Here's the problem. A _CPaintDC_ object and a _CBrush_ object are created on the stack. Since the _CBrush_ is created second, its destructor gets called first. Consequently, the associated GDI brush is deleted before _dc_ goes out of scope. You could fix this by creating the brush first and the DC second, but code whose robustness relies on stack variables being created in a particular order is bad code indeed. As far as maintainability goes, it's a nightmare.

The solution is to select the _CBrush_ out of the device context before the _CPaintDC_ object goes out of scope. There is no _UnselectObject_ function, but you can select an object out of a device context by selecting in another object. Most Windows programmers make it a practice to save the pointer returned by the first call to _SelectObject_ for each object type and then use that pointer to reselect the default object. An equally viable approach is to select stock objects into the device context to replace the objects that are currently selected in. The first of these two methods is illustrated by the following code:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen (PS_SOLID, 1, RGB (255, 0, 0)); CPen* pOldPen = dc.SelectObject (&amp;pen); CBrush brush (RGB (0, 0, 255)); CBrush* pOldBrush = dc.SelectObject (&amp;brush);   <img src="https://flylib.com/books/4/348/1/html/2/grayvellip.jpg" width="3" height="13" border="0"> dc.SelectObject (pOldPen); dc.SelectObject (pOldBrush); </pre></td></tr></tbody></table>

The second method works like this:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen pen (PS_SOLID, 1, RGB (255, 0, 0)); dc.SelectObject (&amp;pen); CBrush brush (RGB (0, 0, 255)); dc.SelectObject (&amp;brush);    <img src="https://flylib.com/books/4/348/1/html/2/grayvellip.jpg" width="3" height="13" border="0"> dc.SelectStockObject (BLACK_PEN); dc.SelectStockObject (WHITE_BRUSH); </pre></td></tr></tbody></table>

The big question is why this is necessary. The simple truth is that it's not. In modern versions of Windows, there's no harm in allowing a GDI object to be deleted a split second before a device context is released, especially if you're absolutely sure that no drawing will be done in the interim. Still, cleaning up a device context by deselecting the GDI objects you selected in is a common practice in Windows programming. It's also considered good form, so it's something I'll do throughout this book.

Incidentally, GDI objects are occasionally created on the heap, like this:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>CPen* pPen = new CPen (PS_SOLID, 1, RGB (255, 0, 0)); CPen* pOldPen = dc.SelectObject (pPen); </pre></td></tr></tbody></table>

At some point, the pen must be selected out of the device context and deleted. The code to do it might look like this:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>dc.SelectObject (pOldPen); delete pPen; </pre></td></tr></tbody></table>

Since the _SelectObject_ function returns a pointer to the object selected out of the device context, it might be tempting to try to deselect the pen and delete it in one step:

<table cellpadding="5" width="95%"><tbody><tr><td><pre>delete dc.SelectObject (pOldPen); </pre></td></tr></tbody></table>

But don't do this. It works fine with pens, but it might not work with brushes. Why? Because if you create two identical _CBrush_es, 32-bit Windows conserves memory by creating just one GDI brush and you'll wind up with two _CBrush_ pointers that reference the same HBRUSH. (An HBRUSH is a handle that uniquely identifies a GDI brush, just as an HWND identifies a window and an HDC identifies a device context. A _CBrush_ wraps an HBRUSH and stores the HBRUSH handle in its _m\_hObject_ data member.) Because _CDC::SelectObject_ uses an internal table maintained by MFC to convert the HBRUSH handle returned by _SelectObject_ to a _CBrush_ pointer and because that table assumes a one-to-one mapping between HBRUSHes and _CBrush_es, the _CBrush_ pointer you get back might not match the _CBrush_ pointer returned by _new_. Be sure you pass _delete_ the pointer returned by _new_. Then both the GDI object and the C++ object will be properly destroyed.

## The Ruler Application

The best way to get acquainted with the GDI and the MFC classes that encapsulate it is to write code. Let's start with a very simple application. Figure 2-12 contains the source code for Ruler, a program that draws a 12-inch ruler on the screen. Ruler's output is shown in Figure 2-11.

![click to view at full size.](https://flylib.com/books/4/348/1/html/2/f02mg11.jpg)

**Figure 2-11.** _The Ruler window._

**Figure 2-12.** _The Ruler application._

<table cellpadding="5" width="95%"><tbody><tr><td><h3>Ruler.h</h3><pre>class CMyApp : public CWinApp { public:     virtual BOOL InitInstance (); }; class CMainWindow : public CFrameWnd { public:     CMainWindow (); protected:     afx_msg void OnPaint ();     DECLARE_MESSAGE_MAP () }; </pre></td></tr></tbody></table>

<table cellpadding="5" width="95%"><tbody><tr><td><h3>Ruler.cpp</h3><pre>#include &lt;afxwin.h&gt; #include "Ruler.h" CMyApp myApp; ///////////////////////////////////////////////////////////////////////// // CMyApp member functions BOOL CMyApp::InitInstance () {     m_pMainWnd = new CMainWindow;     m_pMainWnd-&gt;ShowWindow (m_nCmdShow);     m_pMainWnd-&gt;UpdateWindow ();     return TRUE; } ///////////////////////////////////////////////////////////////////////// // CMainWindow message map and member functions BEGIN_MESSAGE_MAP (CMainWindow, CFrameWnd)     ON_WM_PAINT () END_MESSAGE_MAP () CMainWindow::CMainWindow () {     Create (NULL, _T ("Ruler")); } void CMainWindow::OnPaint () {     CPaintDC dc (this);          //     // Initialize the device context.     //     dc.SetMapMode (MM_LOENGLISH);     dc.SetTextAlign (TA_CENTER ¦ TA_BOTTOM);     dc.SetBkMode (TRANSPARENT);     //     // Draw the body of the ruler.     //     CBrush brush (RGB (255, 255, 0));     CBrush* pOldBrush = dc.SelectObject (&amp;brush);     dc.Rectangle (100, -100, 1300, -200);     dc.SelectObject (pOldBrush);     //     // Draw the tick marks and labels.     //     for (int i=125; i&lt;1300; i+=25) {         dc.MoveTo (i, -192);         dc.LineTo (i, -200);     }     for (i=150; i&lt;1300; i+=50) {         dc.MoveTo (i, -184);         dc.LineTo (i, -200);     }     for (i=200; i&lt;1300; i+=100) {         dc.MoveTo (i, -175);         dc.LineTo (i, -200);         CString string;         string.Format (_T ("%d"), (i / 100) - 1);         dc.TextOut (i, -175, string);     } } </pre></td></tr></tbody></table>

The structure of Ruler is similar to that of the Hello application presented in Chapter 1. The _CMyApp_ class represents the application itself. _CMyApp::InitInstance_ creates a frame window by constructing a _CMainWindow_ object, and _CMainWindow_'s constructor calls _Create_ to create the window you see on the screen. _CMainWindow::OnPaint_ handles all the drawing. The body of the ruler is drawn with _CDC::Rectangle,_ and the hash marks are drawn with _CDC::LineTo_ and _CDC::MoveTo_. Before the rectangle is drawn, a yellow brush is selected into the device context so that the body of the ruler will be painted yellow. Numeric labels are drawn with _CDC::TextOut_ and positioned over the tick marks by calling _SetTextAlign_ with TA\_CENTER and TA\_BOTTOM flags and passing _TextOut_ the coordinates of the top of each tick mark. Before _TextOut_ is called for the first time, the device context's background mode is set to TRANSPARENT. Otherwise, the numbers on the face of the ruler would be drawn with white backgrounds.

Rather than hardcode the strings passed to _TextOut_, Ruler uses _CString::Format_ to generate text on the fly. _CString_ is the MFC class that represents text strings. _CString::Format_ works like C's _printf_ function, converting numeric values to text and substituting them for placeholders in a formatting string. Windows programmers who work in C frequently use the _::wsprintf_ API function for text formatting. _Format_ does the same thing for _CString_ objects without requiring an external function call. And unlike _::wsprintf_, _Format_ supports the full range of _printf_ formatting codes, including codes for floating-point and string variable types.

Ruler uses the MM\_LOENGLISH mapping mode to scale its output so that 1 inch on the ruler corresponds to 1 logical inch on the screen. Hold a real ruler up to the screen and on most PCs you'll find that 1 logical inch equals a little more than 1 physical inch. If the ruler is output to a printer instead, logical inches and physical inches will match exactly.