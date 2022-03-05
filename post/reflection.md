---
tags: post
feed: false
title: Reflection
date: 2012-07-15
---

This inspiration for this series owes much to [Rich Hickey's talk on "Simple
made easy"][talk]. I have aimed to outline the possibilities of applying this
in computational research over the previous four posts. My main point has been
that building simple workflows from simple tools makes for easier maintenance
and creating reproducible computational workflows.

[talk]: http://www.infoq.com/presentations/Simple-Made-Easy

When I first began in bioinformatics I programmed in Java, managed my data
using SQL, and created build files with Ant. Later I wrote smaller Ruby
scripts, used object relational mapping to connect to the database, and Rake to
create reproducible analyses. In the last six months I have changed to creating
composable functions in R, Ruby, Clojure or GNU coreutils, storing data in
plain-text files, and maintaining reproducibility with GNU make. All of these
setups have focused on reproducible bioinformatics workflows. Each time I've
varied my tools to reduce the amount of complexity in my projects. Clojure
syntax is simpler than Ruby, as is Ruby's when compared to Java, and using a
GNU coreutil is simpler that writing something yourself.

The points I have outlined in this series of posts may be obvious to many:
plain text files, UNIX pipelines and GNU Make are at the centre of
bioinformatics. Using larger and newer tools are however attractive because of
their newness and the possibility of potential features. I have often started
using new tools after reading about them on blogs or discussion boards. A new
tool may offer improved features over a predecessor but at the same time may
also tie you to a particular way of working, therefore making it harder to
incorporate alternative approaches or tools without significant rewriting or
restructuring. The [UNIX philosophy][unix] instead recommends building tools to
do one thing well. The [Clojure philosophy][clojure] recommends combining
composable libraries instead of tying yourself to larger frameworks. Building
tools and workflows with this philosophy in mind allows for combining and
interchanging different tools and approaches more easily and simply.

[unix]: http://en.wikipedia.org/wiki/Unix_philosophy
[clojure]: http://www.infoq.com/presentations/Why-Prismatic-Goes-Faster-With-Clojure
