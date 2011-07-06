---
  kind: article
  title: Presenting software on a poster
  created_at: 2011-06-27 00:00 GMT
---

I've spent time recently working on [a tool to simplify genome
scaffolding][post]. I presented a poster on related to this at the American
Society for Microbiology conference this year (ASM 2011). As an attendee
I find poster sessions at large conferences can be overwhelming. There are
many posters and so it can be hard to find the most rel event.

Similarly, from the opposite side, being overlooked in a room with hundreds of
other posters can be disheartening for the presenter. Unique to informatics,
I think creating and presenting a poster about software can be hard. Software
is an abstract concept so it's hard to relay a narrative that poster viewers
can connect to. Contrast this with presenting research which has the benefit
of a research storyline and, possibly, eye-catching figures.

The poster I created for ASM minimised the amount text on the page. There is
[written documentation on Scaffolder][scaf] in the form of Ruby Doc, Unix man
pages and a getting started guide so repeating this on the poster felt
redundant. I also believed that large amounts of text describing software
would be forgotten. So instead I designed this poster as an a brief
introduction to the software. Anyone interested in learning more could follow
the short URL ([http://next.gs][]) to the tool website containing much more
details.

<%= image('/images/scaffolder-poster-thumb.png',600, :link => '/images/scaffolder-poster.png') %>

The left-hand side of the poster describes the problem of creating a genome by
joining the scaffold contigs by hand. The larger right-hand side illustrates
the scaffolder file format and how the software solves these problems. If an
attendees expressed an interest in learning more I ran through a two-minute
talk using the poster as a prop for the main points. I could then answer any
additional questions. I think this worked well as I was able to have several
conversations about problems people were having with their genome project.

The poster was simple to produce and took about one week. I created the poster
in Inkscape and the design is composed mainly of the simple the shape and text
tools available. When I couldn't reproduce what I envisaged in my design
a Google search found plenty of Inkscape tutorials. Overall I felt that an
information light, but visually appealing, design was the good way to attract
interest in the software and start a conversation.

[scaffolder]: http://next.gs
[post]: /research/experiments-in-genome-scaffolding-and-peer-review/
