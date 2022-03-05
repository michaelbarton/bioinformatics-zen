---
tags: post
feed: false
title: About Latex
date: 2008-12-24
---

LaTeX (pronounced lay-tek) is a document creation system aimed at scientific
and technical documents. LaTeX documents are written in plain text using markup
to describe which parts should be sections tables or pictures. The LaTeX system
parses the markup and formats the text to produce either dvi, postscript or pdf
output. As LaTeX is entirely text based, the content can be tracked using a
version control system. Plain text files mean that you can work on a document
with your favourite editor, and can also be manipulated at the command line
using Unix tools. The syntax of LaTeX markup will take an hour or two of
practice to learn, but the advantage of creating documents from a marked up
source is that the results are consistent and reproducible, which isn't always
the case for graphical document editors.

### Features

The main reason for using LaTeX is that it allows you to work on the content of
the document, not the formatting. If you were using a graphical editor you
format the text as type, but with LaTeX you only have to add the markup to the
document and LaTeX takes care of the rest. This can save a lot of time with
large documents. The basic features of LaTeX include automatic generation of
tables of contents, tables of figures and automatic numbering of sections
tables and figures. BibTeX is the companion to LaTeX which adds simple
organisation and addition of citations. Citations are added to documents using
a simple "cite" command in the text, without the requirement for third party
software. One of the benefits of creating documents using LaTeX is that the
produced formatting is the result of best practices in typography and document
presentation, which means LaTeX documents look better than the average.

### Templates and Plugins

LaTeX is free software and available for most operating systems. There is a
large LaTeX community which develops themes and modules that can be added to
LaTeX documents. Many journals also provide LaTeX templates in which papers can
be submitted. There are templates available for writing a [thesis or
dissertation][thesis], and there is likely a specific templates which follows
your own institution guidelines. There are many useful third party plugins for
adding extras to a document. For example [beautiful formating of
tables][table], [grouping figures into subfigures][subfig], [replacing text
inside figures][replace] and even [a framework for including R-code inside a
LaTeX document][sweave].

### Creating a LaTeX document

In this video I'm illustrating how to create a simple LaTeX document with text
and headings. An overview of LaTeX document structure [is outlined by Andrew
Roberts][latex_intro]

<object width="640" height="385"><param name="movie" value="http://www.youtube.com/v/PF1hFaoWEY4&hl=en&fs=1&hd=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/PF1hFaoWEY4&hl=en&fs=1&hd=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="640" height="385"></embed></object>

<p/>

### Creating figures in LaTeX

This screencast illustrates how to add a figure to a LaTeX document. The figure
size is changed and a list of figures is added to the document. Andrew Roberts
LaTeX site shows [different examples of LaTeX figure settings][latex_figs].

<object width="640" height="385"><param name="movie" value="http://www.youtube.com/v/GXmmS8N_s0o&hl=en&fs=1&hd=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/GXmmS8N_s0o&hl=en&fs=1&hd=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="640" height="385"></embed></object>

<p/>

### Creating tables in LaTeX

This screencast illustrates adding a simple table to a LaTeX document. The
table is then formatted to look more "professional" using the [booktabs
package][table]. More information on tables in LaTeX can be found at [Andrew
Robert's website][latex_tables] and on the [Wikibooks
website][wiki_books_tables]

<object width="640" height="385"><param name="movie" value="http://www.youtube.com/v/9Rh77LBJIDc&hl=en&fs=1&hd=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/9Rh77LBJIDc&hl=en&fs=1&hd=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="640" height="385"></embed></object>

<p/>

### Adding references in LaTeX

This screencast shows how to add dynamic references to the text in a document.
This includes automatically adding references to tables and figures. The second
half of the video illustrates how to add a bibliography to a LaTeX document,
and how to cite articles in the text. More information about citations can be
found on [Andrew Robert's website][latex_citations].

<object width="640" height="385"><param name="movie" value="http://www.youtube.com/v/jvh_2EQ1iwM&hl=en&fs=1&hd=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/jvh_2EQ1iwM&hl=en&fs=1&hd=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="640" height="385"></embed></object>

<p/>

[thesis]: http://tex.stackexchange.com/questions/326/latex-templates-for-writing-a-thesis
[table]: http://www.ctan.org/tex-archive/macros/latex/contrib/booktabs/
[subfig]: http://www.ctan.org/tex-archive/macros/latex/contrib/subfig/
[replace]: http://www.ctan.org/tex-archive/macros/latex/contrib/subfig/
[sweave]: http://www.stat.uni-muenchen.de/~leisch/Sweave/
[latex_intro]: http://www.andy-roberts.net/misc/latex/latextutorial2.html
[latex_figs]: http://www.andy-roberts.net/misc/latex/latextutorial5.html
[latex_tables]: http://www.andy-roberts.net/misc/latex/latextutorial4.html
[latex_citations]: http://www.andy-roberts.net/misc/latex/latextutorial3.html
[wiki_books_tables]: http://en.wikibooks.org/wiki/LaTeX/Tables
