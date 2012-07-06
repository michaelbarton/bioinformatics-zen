---
kind: article
title: Reflection
created_at: "2012-07-13 00:00:00"
---

The points I have outlined in the previous posts are obvious to many. Plain
text files, UNIX pipelines and GNU Make are at central to bioinformatics. Newer
tools however are often attractive because of their newness and the possibility
of the potential features. I have often started using new tools after they
recieved attention on blogs and discussion sites and many tools ofter
significant improvements over a predassessor but this should be weighed up
against the cost of using them. New tools may tie you to one particular way of
working making it harder to incorporate alternative approaches without
rewriting from scratch. The [UNIX philosphy][unix] recommends building tools
that do only one thing very well, or the [Clojure philosophy][clojure] of
composable libraries over frameworks. Building workflows and and methods around
this philospohy allows you to combine and the different tools together and
interchange them more easily and simply.

[unix]: ADD UNIX PHILOSOPHY
[clojure]: ADD CLOJURE PHILOSOPHY

When I first began in bioinformatics I programmed in Java, managed my data
using SQL, and created build files with Ant. Later I wrote smaller Ruby
scripts, used object relational mapping to manage data, and Rake to create
reproducible analyses. In the last six months I have change my workflow to I
write small composable functions in Ruby, Clojure or GNU coreutils, store data
in plain-text files, and maintain reporoducibilty with GNU make.

All of these setups focus on reproducible computational science which I think
should come first above before considering organisation. Each time I've varied
the tools that I've been using I've reduced the amount of complexity in the
project. Clojure syntax is simpler than Ruby, as is Ruby's when compared to
Java, and using an existing GNU coreutil is simpler that writing your own in
any language. The same can be said when comparing Ant/Rake/Make and
SQL/ORM/Plain-text, where each time I'm reducing complexity in the project.
Simpler and more maintainable workflows however allow for creating reproducible
workflows much more simply.

This inspiration for what I've outlined here owes much to [Rich Hickey's talk
on simple over easy][talk]. I think there is a culture of newer is often
better, however I now try to think about what value such new think adds to a
project. A concrete example would be what difference does including a NoSQL
databases have on a project: it makes read/write access faster but is that that
worth the additonal complexity of a database in a workflow. Arguably databases
are useful for complex data queries but using plain text files can be simpler
to use for less complex data management.

[talk]: ADD LINK TO TALK

CHECK RICH HICKEY TALK TITLE

A second more abstract example is learning a new programming language. New
programming languages often recieve a large amount of attention for their
advantages. However what value does a new programming language add to a
project? Faster or more concise code, but could improving an orthogonal skill
such a machine learning or propositional logic have a greater impact given the
investment to learn them.
