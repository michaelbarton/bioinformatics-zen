---
kind: article
title: reflection
---

The points I have outlined in the previous posts will be obvious to many. Plain
text files, UNIX pipelines and GNU Make have been common tools in
bioinformatics. They are not however pervasive as many come to the field from
different background and often lack specific training

I have been in field of bioinformatics for six years and have in the last six
months have incorporated this as my workflow.

I was used Java/Ant/SQL to perform bioinformatics analysis. Later I switched to
using Ruby/Rake/ActiveRecord. I now use mainly use GNU make, GNU coreutils,
plain text files and writing short functions in clojure. In all of these setups
I've been creating workflows that have been reporducible and with various
levels or organisation. I've changed each system I've been using to however
reduce the amount of complexity in mantaining the project. Clojure syntax is
simpler than Ruby, as is Ruby's when compared to Java. The same can be said
when comparing Ant/Rake/Make and SQL/ORM/Plain-text. In each case I found my
self reducing complexity, not necessarily easier but using simpler tools.
Watching Rich Hickey's talk also really underlined why using simpler tools is
important.

I think there is a culture in computational fields that newer is usually
better, I know this is often the case in Ruby. I would often look down
UNIXarians as being "behind the curve" of the newest trends by sticking to old
tools. I feel that as I have matured as a bioinformatician and programmer I've
moved from thinking I know a lot to realising I know very little. This has lead
me to question new tools and approaches much more.
