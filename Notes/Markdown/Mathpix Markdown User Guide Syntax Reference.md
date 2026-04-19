Mathpix Markdown Syntax Reference
Inline math
Inline math can be represented using $TeX$ or \( TeX \) delimiters.
Examples:
Compute \(f(x) = x^2 + 2\) if \(x=2\).
Compute  if .
Newton postulated that $\vec { F } = m \vec { a }$.
Newton postulated that .
Block mode math (non-numbered)
Delimiters: $$...$$
Example LaTeX:
$$
x = \frac { - b \pm \sqrt { b ^ { 2 } - 4 a c } } { 2 a }
$$
Rendered equation:
Delimiters: \[...\]
Example LaTeX:
$$
\[
y = \frac { \sum _ { i } w _ { i } y _ { i } } { \sum _ { i } w _ { i } } , i = 1,2 \ldots k
\]
$$
Rendered equation:
Delimiters: \begin{equation*}...\end{equation*}
Example LaTeX:
\begin{equation*}
l ( \theta ) = \sum _ { i = 1 } ^ { m } \log p ( x , \theta )
\end{equation*}
Rendered equation:
Delimiters: \begin{align*}...\end{align*}
Example LaTeX:
$$
\begin{align*}
t _ { 1 } + t _ { 2 } = \frac { ( 2 L / c ) \sqrt { 1 - u ^ { 2 } / c ^ { 2 } } } { 1 - u ^ { 2 } / c ^ { 2 } } = \frac { 2 L / c } { \sqrt { 1 - u ^ { 2 } / c ^ { 2 } } }
\end{align*}
$$
Rendered equation:
Block mode math (numbered)
Delimiters: \begin{equation}...\end{equation}
Example LaTeX:
$$
\begin{equation}
m = \frac { m _ { 0 } } { \sqrt { 1 - v ^ { 2 } / c ^ { 2 } } }
\end{equation}
Rendered equation:
Align, split, gather equation environments
Delimiters: \begin{align}...\end{align}
Example LaTeX:
\begin{align}
^{|\alpha|} \sqrt{x^{\alpha}} \leq(x \bullet \alpha) /|\alpha|
\end{align}
$$
Rendered equation:
Delimiters: \begin{split}...\end{split}
Reason to use: split your equation into smaller pieces
Example LaTeX:
\begin{split}
a& =b+c-d\\
& \quad +e-f\\
& =g+h\\
& =i
\end{split}
Rendered equation:
Use \\ to denote a new line and & to denote where the lines should align.
Need it numbered? Wrap it in \begin{equation}...\end{equation}
Delimiters: \begin{gather}...\end{gather}
Reason to use: for displaying a set of consecutive equations that don’t require special alignment
Example LaTeX:
\begin{gather}
a_1=b_1+c_1\\
a_2=b_2+c_2-d_2+e_2
\end{gather}
Rendered equation:
Delimiters: \begin{gather*}...\end{gather*}
Reason to use: gather environment without an equation number
Example LaTeX:
\begin{gather*}
a_1=b_1+c_1\\
a_2=b_2+c_2-d_2+e_2
\end{gather*}
Rendered equation:
Equation references
You can use \label{}, \ref{} and \eqref{} to link to any numbered equation in your document:
In equation \eqref{eq:1}, we find the value of an
interesting integral:

\begin{equation}
  \int_0^\infty \frac{x^3}{e^x-1}\,dx = \frac{\pi^4}{15}
  \label{eq:1}
\end{equation}

\begin{equation}
  \| x + y \| \geq | \| x | | - \| y \| |
  \label{eq:2}
\end{equation}

Look at the Equation \ref{eq:2}
In equation [5], we find the value of an
interesting integral:
Look at the Equation [6]
In addition to using numbered block mode equation syntax for standard numbering (ie. 1, 2, 3), you can use also include \tag{} inside of your LaTeX delimiters to create a custom tag. Note that if \tag{} is used in a numbered equation, it will override the document’s numbering.
$$
\frac{x\left(x^{2 n}-x^{-2 n}\right)}{x^{2 n}+x^{-2 n}}
\tag{1.1}
$$
\begin{equation}
\max _{\theta} \mathbb{E}_{\mathbf{z} \sim \mathcal{Z}_{T}}\left[\sum_{t=1}^{T} \log p_{\theta}\left(x_{z_{t}} | \mathbf{x}_{\mathbf{z}_{<t}}\right)\right]
\tag{1.2}
\end{equation}
Chemical diagram formulas (SMILES)
Chemical formulas can be represented using SMILES syntax.
SMILES formulas can be rendered inline via <smiles>OC(=O)c1cc(Cl)cs1</smiles> or block mode via:
```smiles
OC(=O)c1cc(Cl)cs1
```
which renders as:
OH
O
Cl
S
Titles, Sections, Abstracts (LaTeX)
LaTeX syntax	Markdown equivalent	HTML equivalent
\title{My Title}	# My Title	<h1 align="center">My Title</h1>
\author{Author's Name}	No equivalent	No equivalent
\begin{abstract}...\end{abstract}	No equivalent	No equivalent
\section{Section Title}	## Section Title	<h2>Section Title</h2>
\subsection{Section Title}	### Section Title	<h3>Section Title</h3>
\subsubsection{Section Title}	#### Section Title	<h4>Section Title</h4>
Note: The LaTeX \title{} will always render center-aligned and an <h1>...</h1> HTML tag can be aligned using the align="..." attribute, but the Markdown title using # will always render left-aligned.
Note: In Mathpix Markdown, You can use the \title{} command wherever you want the title to appear in your document, as you would use the \maketitle command in a LaTeX document.
Headings (Markdown)
Markdown	HTML	Rendered output
# H1 Heading	<h1>H1 Heading</h1>	
H1 Heading
## H2 Heading	<h2>H2 Heading</h2>	
H2 Heading
## H3 Heading	<h3>H3 Heading</h3>	
H3 Heading
## H4 Heading	<h4>H4 Heading</h4>	
H4 Heading
## H5 Heading	<h5>H5 Heading</h5>	
H5 Heading
## H6 Heading	<h6>H6 Heading</h6>	
H6 Heading
H1 Heading
=====	<h1>H1 Heading</h1>	
H1 Heading
## H2 Heading
----	<h2>H2 Heading</h2>	
H2 Heading
Fonts (Markdown)
Markdown	HTML	Rendered output
**This is bold text**	<b>This is bold text</b>	This is bold text
__This is also bold text__	<strong>This is bold text<strong>	This is also bold text
*This is italic text*	<i>This is bold text</i>	This is italic text
_This is also italic text_	<em>This is bold text</em>	This is also italic text
~~Strikethrough~~	<s>Strikethrough</s>	Strikethrough
==This is marked text==	<mark>This is marked text</mark>	This is marked text
Fonts (LaTeX)
LaTeX syntax	Markdown equivalent	HTML equivalent
\textit{italicized text}	*italicized text* or _italicized text_	<i>italicized text</i> or <em>italicized text</em>
\textbf{bold text}	__bold text__	<b>bold text</b> or <strong>bold text</strong>
\url{link}	[link text](url)	<a href="url">link text</a>
Lists (Markdown)
Create an unordered list by starting a line with +, -, or *
+ Sub-lists are made by indenting 2 spaces:
  - Different characters in in the same sub-list will render the same characters:
    * Ac tristique libero volutpat at
    + Facilisis in pretium nisl aliquet
    - Nulla volutpat aliquam velit
+ Very easy!
Sub-lists are made by indenting 2 spaces:
Different characters in in the same sub-list will render the same characters:
Ac tristique libero volutpat at
Facilisis in pretium nisl aliquet
Nulla volutpat aliquam velit
Very easy!
Create an ordered list by writing 1,2,etc.
1. Lorem ipsum dolor sit amet
2. Consectetur adipiscing elit
3. Integer molestie lorem at massa
Lorem ipsum dolor sit amet
Consectetur adipiscing elit
Integer molestie lorem at massa
1. You can use sequential numbers...
1. ...or keep all the numbers as 1 and it will automatically increment your list.
You can use sequential numbers…
…or keep all the numbers as 1.
Or start your list with any number and the numbering will continue:
57. foo
2. bar
6. foo
foo
bar
foo
Lists (LaTeX)
You can also create lists using the LaTeX style \begin{itemize} ... \end{itemize} environment.
For example:
\begin{itemize}
  \item One entry in the list
  \item Another entry in the list
\end{itemize}
•One entry in the list
•Another entry in the list
You can read a full description of such lists here.
Hint
You can create a hint, which is a collapsible section, by using +++ ... +++.
For example:
+++ Click me...
Hello, world!
+++
 Click me...
Note that whatever text you want to be displayed next to the expand button should go on the same line as the first +++.
Code
Wrap inline code in single backticks (`)
…or wrap code blocks in 3 backticks (```) or 3 tildes (~~~)
var foo = function (bar) {
  return bar++;
};
Include the programming language after the first three backticks or tildes for syntax highlighting:
var foo = function (bar) {
  return bar++;
};
(All major languages supported via highlight.js.)
You can also create a code block by indenting all lines:
    \\ some comments
    line 1 of code
    line 2 of code
    line 3 of code
Will render:
\\ some comments
line 1 of code
line 2 of code
line 3 of code
Tables (Markdown)
Colons can be used to align columns:
| Tables        | Are           | Cool  |
| :------------ |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |
Tables	Are	Cool
col 3 is	right-aligned	$1600
col 2 is	centered	$12
zebra stripes	are neat	$1
There must be at least 3 dashes separating each header cell.
The outer pipes (|) are optional, and you don’t need to make the raw Markdown line up prettily:
Markdown | Less | Pretty
--- | --- | ---
*Still* | `renders` | **nicely**
1 | 2 | 3
Markdown	Less	Pretty
Still	renders	nicely
1	2	3
Tables (LaTeX)
The tabular environment is a powerful and important LaTeX command that provides many options for table rendering and multi row / column spanning cells. The syntax looks as follows:
\begin{tabular}{<<table spec>>} <<table content>> \end{tabular}
This example shows how to create a table in LaTeX.
    \begin{tabular}{| l | l | l | l |}
    \hline
    Day & Min Temp & Max Temp & Summary \\ \hline
    Monday & 11C & 22C & A clear day with lots of sunshine.
    However, the strong breeze will bring down the temperatures. \\ \hline
    Tuesday & 9C & 19C & Cloudy with rain, across many northern regions. Clear spells
    across most of Scotland and Northern Ireland,
    but rain reaching the far northwest. \\ \hline
    Wednesday & 10C & 21C & Rain will still linger for the morning.
    Conditions will improve by early afternoon and continue
    throughout the evening. \\
    \hline
    \end{tabular}
Day	Min Temp	Max Temp	Summary
Monday	11C	22C	A clear day with lots of sunshine. However, the strong breeze will bring down the temperatures.
Tuesday	9C	19C	Cloudy with rain, across many northern regions. Clear spells across most of Scotland and Northern Ireland, but rain reaching the far northwest.
Wednesday	10C	21C	Rain will still linger for the morning. Conditions will improve by early afternoon and continue throughout the evening.
Read the full guide to LaTeX table support for more.
Quotes
Use a > to write a blockquote like this:
> This is my blockquote
This is my blockquote
> This is my blockquote,
> It's taking up two lines.
This is my blockquote,
It’s taking up two lines.
> This is my nested blockquote,
>> it's pretty nifty.
This is my nested blockquote,
it’s pretty nifty.
Links
Use the [Title](url) syntax to insert a link:
[This is a link to the Mathpix website](http://mathpix.com/)
This is a link to the Mathpix website
Images (Markdown)
Use the ![Title](url) syntax to insert an image:
![Michelson–Morley experiment](https://cdn.mathpix.com/snip/images/awccdJC5T8qaH8EAA7-Y0PpPG_RbMVLTc2_-YgewedE.original.fullsize.png)
Michelson–Morley experiment
Include text in quotes after the url for a tooltip (hover over the image to see):
![Michelson–Morley experiment](https://cdn.mathpix.com/snip/images/awccdJC5T8qaH8EAA7-Y0PpPG_RbMVLTc2_-YgewedE.original.fullsize.png "Michelson-Morley experiment")
Michelson–Morley experiment
Images (LaTeX)
You can also insert images using LaTeX’s figure environment.
For example:
\begin{figure}[h]
\includegraphics[width=0.5\textwidth, center]{https://cdn.mathpix.com/snip/images/MJT22mwBq-bwqrOYwhrUrVKxO3Xcu4vyHSabfbG8my8.original.fullsize.png}
\end{figure}

You can read a full description of how to use here.
Footnotes
You can write footnotes either by writing out “first”, “second”, “third”, etc:
Footnote 1 link[^first]
Footnote 1 link[1]
Footnote reference[^second]
Footnote reference[2]
And you can reference the same footnote again like this:
My reference[^second]
My reference[2:1]
Or you can use numbers:
This is my next footnote[^3]
This is my next footnote[3]
You can reference multiple footnotes in a row[^3][^4]
You can reference multiple footnotes in a row[3:1][4]
You can also write inline footnotes:
Inline footnote^[Text of inline footnote] definition.
Inline footnote[5] definition.
Scroll to the bottom of the page to see how these footnotes render:
[^first]: Footnotes **can have markup**

    and multiple paragraphs.

[^second]: Footnote text.

[^3]: Hello I am the third footote!

[^4]: And I'm the 4th!
Horizontal divider lines
Create horizontal rules like this:
___
---
***
Misc.
Here are some other symbols supported:
(c) (C) (r) (R) (tm) (TM) (p) (P) +-
© © ® ® ™ ™ § § ±
Punctuation will get autocorrected:
test.. test... test..... test?..... test!....
test… test… test… test?.. test!..
!!!!!! ???? ,,  -- ---
!!! ??? , – —
Emoji’s
Classic markup:
:wink: :cry: :laughing: :yum:
😉 😢 😆 😋
Shortcuts (emoticons):
:-) :-( 8-) ;)
😃 😦 😎 😉
Subscripts and Superscripts
19^th^
19th
H~2~O

H2O
Using HTML
You can also use HTML tags. Here is an example of a header:
<h2 style="color:blue;">This is a Blue Heading</h2>
This is a Blue Heading
You can also render SVGs!
<svg id="function random() { [native code] }" xmlns="http://www.w3.org/2000/svg" version="1.1" width="200px" height="150px" viewBox="0 0 200 150">\n\t<style> #function random() { [native code] } {pointer-events:none; }  #function random() { [native code] } .event  { pointer-events:all;}  </style>\n\t<text x="136" y="79" font-family=" Helvetica" font-weight="900" font-size="14" fill="rgb(255,13,13)">O</text>\n\t<text x="115" y="43" font-family=" Helvetica" font-weight="900" font-size="14" fill="rgb(255,13,13)">O</text>\n\t<text x="126" y="43" font-family=" Helvetica" font-weight="900" font-size="14" fill="rgb(255,13,13)">H</text>\n\t<text x="73" y="42" font-family=" Helvetica" font-weight="900" font-size="14" fill="rgb(255,13,13)">O</text>\n\t<text x="84" y="42" font-family=" Helvetica" font-weight="900" font-size="14" fill="rgb(255,13,13)">H</text>\n\t<line x1="118" y1="64" x2="134" y2="72" style="stroke:rgb(0,0,0);stroke-width:1"/>\n\t<line x1="120" y1="60" x2="136" y2="69" style="stroke:rgb(0,0,0);stroke-width:1"/>\n\t<line x1="79" y1="63" x2="100" y2="75" style="stroke:rgb(0,0,0);stroke-width:1"/>\n\t<line x1="79" y1="67" x2="95" y2="76" style="stroke:rgb(0,0,0);stroke-width:1"/>\n\t<line x1="58" y1="99" x2="58" y2="74" style="stroke:rgb(0,0,0);stroke-width:1"/>\n\t<line x1="62" y1="96" x2="62" y2="77" style="stroke:rgb(0,0,0);stroke-width:1"/>\n\t<line x1="99" y1="99" x2="79" y2="111" style="stroke:rgb(0,0,0);stroke-width:1"/>\n\t<line x1="95" y1="97" x2="79" y2="106" style="stroke:rgb(0,0,0);stroke-width:1"/>\n\t<line x1="120" y1="46" x2="120" y2="63" style="stroke:rgb(0,0,0);stroke-width:1"/>\n\t<line x1="100" y1="75" x2="120" y2="63" style="stroke:rgb(0,0,0);stroke-width:1"/>\n\t<line x1="79" y1="45" x2="79" y2="63" style="stroke:rgb(0,0,0);stroke-width:1"/>\n\t<line x1="58" y1="74" x2="79" y2="63" style="stroke:rgb(0,0,0);stroke-width:1"/>\n\t<line x1="79" y1="111" x2="58" y2="99" style="stroke:rgb(0,0,0);stroke-width:1"/>\n\t<line x1="99" y1="99" x2="100" y2="75" style="stroke:rgb(0,0,0);stroke-width:1"/>\n\t<line id="function random() { [native code] }:Bond:1-0" class="event" x1="120" y1="63" x2="141" y2="75" stroke-width="8" stroke-opacity="0"/>\n\t<line id="function random() { [native code] }:Bond:4-3" class="event" x1="79" y1="63" x2="100" y2="75" stroke-width="8" stroke-opacity="0"/>\n\t<line id="function random() { [native code] }:Bond:7-6" class="event" x1="58" y1="99" x2="58" y2="74" stroke-width="8" stroke-opacity="0"/>\n\t<line id="function random() { [native code] }:Bond:9-8" class="event" x1="99" y1="99" x2="79" y2="111" stroke-width="8" stroke-opacity="0"/>\n\t<line id="function random() { [native code] }:Bond:2-1" class="event" x1="120" y1="39" x2="120" y2="63" stroke-width="8" stroke-opacity="0"/>\n\t<line id="function random() { [native code] }:Bond:3-1" class="event" x1="100" y1="75" x2="120" y2="63" stroke-width="8" stroke-opacity="0"/>\n\t<line id="function random() { [native code] }:Bond:5-4" class="event" x1="79" y1="38" x2="79" y2="63" stroke-width="8" stroke-opacity="0"/>\n\t<line id="function random() { [native code] }:Bond:6-4" class="event" x1="58" y1="74" x2="79" y2="63" stroke-width="8" stroke-opacity="0"/>\n\t<line id="function random() { [native code] }:Bond:8-7" class="event" x1="79" y1="111" x2="58" y2="99" stroke-width="8" stroke-opacity="0"/>\n\t<line id="function random() { [native code] }:Bond:9-3" class="event" x1="99" y1="99" x2="100" y2="75" stroke-width="8" stroke-opacity="0"/>\n\t<circle id="function random() { [native code] }:Atom:0" class="event" cx="141" cy="75" r="8" fill-opacity="0"/>\n\t<circle id="function random() { [native code] }:Atom:1" class="event" cx="120" cy="63" r="8" fill-opacity="0"/>\n\t<circle id="function random() { [native code] }:Atom:2" class="event" cx="120" cy="39" r="8" fill-opacity="0"/>\n\t<circle id="function random() { [native code] }:Atom:3" class="event" cx="100" cy="75" r="8" fill-opacity="0"/>\n\t<circle id="function random() { [native code] }:Atom:4" class="event" cx="79" cy="63" r="8" fill-opacity="0"/>\n\t<circle id="function random() { [native code] }:Atom:5" class="event" cx="79" cy="38" r="8" fill-opacity="0"/>\n\t<circle id="function random() { [native code] }:Atom:6" class="event" cx="58" cy="74" r="8" fill-opacity="0"/>\n\t<circle id="function random() { [native code] }:Atom:7" class="event" cx="58" cy="99" r="8" fill-opacity="0"/>\n\t<circle id="function random() { [native code] }:Atom:8" class="event" cx="79" cy="111" r="8" fill-opacity="0"/>\n\t<circle id="function random() { [native code] }:Atom:9" class="event" cx="99" cy="99" r="8" fill-opacity="0"/>\n</svg>  
O
O
H
O
H
Footnotes can have markup
and multiple paragraphs. ↩︎
Footnote text. ↩︎ ↩︎
Hello I am the third footote! ↩︎ ↩︎
And I’m the 4th! ↩︎
Text of inline footnote ↩︎