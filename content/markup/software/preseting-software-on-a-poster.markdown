---
  kind: article
  title: Presenting bioinformatics software as a poster
  created_at: 2011-06-27 00:00 GMT
---

I've spent my time recently working on [a tool to simplify genome
scaffolding][post]. I presented this tool at this year's American Society for
Microbiology conference (ASM 2011). I find poster sessions at large conferences
overwhelming. There are many posters and so you have to be selective and know
which ones are likely to interest you before hand. I've gone to see I poster
I thought I would be interested in beforehand only to find it wasn't what
I expected.

Posters sessions can also be daunting for the presenter too. In my case I found
it difficult to produce a poster to present a piece of bioinformatics software.
Software is an abstract concept so it's hard to present this as concrete
narrative that the poster viewers can connect to. Contrast this with presenting
research which has the benefit of a research storyline and, possibly,
eye-catching figures.

The poster I created for ASM was minimised the amount text on the page. I've
already [written extensive documentation][scaf] on Scaffolder if the form of
Ruby Doc, Unix man pages and a getting started guide. I believe that large
amounts on text would be forgotten. I aimed this poster to serve as an a brief
introduction to software and anyone interested in learning more can take the
simple seven character URL ([http://next.gs][]) to the tool documentation.

<%= image('/images/scaffolder-poster-thumb.png',600, :link =>
'/images/scaffolder-poster.png') %>

The left-hand side of the poster describes the problem that manually joining
a genome scaffold by hand is error prone and difficult to reproduce. The larger
right-hand side illustrates the scaffolder file format and how it solves these
problems. When Attendees expressed an interest I ran through a two minute talk
using the poster as a prop to illustrate the main points. I could then answer
any additional questions. I think this worked well as I was able to have
several conversations about problems people were having with their genome
project.

I poster was simple to produce and took about one week. I have no graphical
design experience so instead I planned before-hand in as much detail as
possible. I created the poster in Inkscape using the shape and text tools. When
I couldn't reproduce what I envisaged in my design a Google search found plenty
of Inkscape tutorials. An example was creating the grunge back ground for the
left-hand side.

[scaffolder]: http://next.gs
[post]: /research/experiments-in-genome-scaffolding-and-peer-review/
