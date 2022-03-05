---
tags: post
feed: false
title: A functional approach to bioinformatics workflows
date: 2012-07-11
---

This is the third post in a series discussing creating simple, reproducible and
organised research workflows. In the previous post I described how [using
Makefiles can result in simple and reproducible workflows][make]. Here I'm
going to outline simplifying workflows further by taking a functional approach
to building them.

[make]: /post/makefiles/

Functional programming is an alternative paradigm to imperative programming
such as C or object orientated programming with Java. There are two concepts in
functional programming which I think are particularly applicable to creating
computational workflows: treating functions as the primary actors, and that all
data should be immutable after creation.

## Data is the API

Speaking from experience there is a temptation to force an object-orientated
approach into a computational workflow. An example of this is using an ORM and
then injecting objects into your workflow code. This then means there are two
considerations to take into account when building a workflow, the first is the
how to access the data from the objects and the second how to pass the data
between workflow steps.

Using Ruby objects as the API of the workflow requires me to start serialising
objects to file or database and the marshalling them in the next step. If your
objects change then everything needs to change. Writing from experience this
quickly gets hard to track in my head and is horrible to maintain. Making the
data the primary API of the workflow makes everything simpler. All I need to
know is the format of the input data and the expected data format for the next
workflow step. This often means generating a simple and easily parsable output
file.

## Immutable data

Consider all data immutable once you have generated it in a workflow step.
Don't update a file that has been created, instead generate a copy of the file
with required changes. This removes "state" from the workflow. You don't need
to look inside a file to see if the changes have been applied: all you need to
know is if it exists or not. Furthermore it's very simple to `diff` two files
to see what the changes are, rather than trying to compare the before and after
versions of the file. This makes examining intermediate steps for errors much
simpler.

This may appear to preclude the possibility of using databases in a workflow.
This is however not the case. A common pattern in my workflows is to fetch a
set of data I wish to analyse, build it into a database, then generate
different file types I wish to analyse based on this database. The only
condition of doing this is that the database must be a file. Concretely, the
database should be file which can be used as a dependency for GNU Make.

I prefer to use simple key-value pairs in a text file wherever possible. This
allows coreutils such as `grep` to fetch and manipulate required entries. More
complex queries and faster random-access databases can however be generated
from in-file databases such as [Kyoto Cabinet][kyoto]. Using an in-file
database importantly fits into a Makefile workflow, meaning that if any of the
input data changes then the database and all downstream steps will be
automatically be regenerated enforcing consistency across all steps.

[kyoto]: http://fallabs.com/kyotocabinet/

## Functions composed of simple functions

Makefile targets can be considered a function taking one file as an input and
returning another as an output. The advantage of small compartmentalised
functions is that it is simple to see the output of each step and verify it is
what you expect. Furthermore small decomposed workflow steps are easier to
examine, debug and replace.

Makefile targets can often be composed from smaller focused functions combined
together to produce the required output. GNU coreutils provides a wide variety
of programs that, if you didn't know about them, you might be tempted to write
your own equivalent script. There are however many useful commands in the
coreutils for manipulating data:

- [cut][]: Select specific columns from delimited data formats.
- [tr][]: Translate characters of one type into another.
- [paste][]: Join records from different files together as columns.
- [join][]: Row join two files together using on common identifiers.
- [comm][]: Select or reject common lines between two files.
- [uniq][]: Select or count unique lines in a file.
- [sort][]: Sort records by different file columns.
- [sed][]: Complex file transformations and editing (Consider [ssed][] too).
- [grep][]: Select records by more complex criteria.

[cut]: http://man.cx/cut
[tr]: http://man.cx/tr
[paste]: http://man.cx/paste
[join]: http://man.cx/join
[comm]: http://man.cx/comm
[uniq]: http://man.cx/uniq
[sort]: http://man.cx/sort
[sed]: http://man.cx/sed
[grep]: http://man.cx/grep
[ssed]: https://launchpad.net/ssed/

UNIX pipes can also be used to [redirect the input of one command into
another][pipes]. Therefore as much as possible my Makefile steps are composed
of small functions piping their input between each other. The advantage is that
a UNIX command will be faster and bug-free compared to anything you would write
yourself. Furthermore Makefile targets composed of coreutil pipelines are easier
to edit and debug. This part of the UNIX philosophy: simple parts connected by
clean interfaces. You will however still need to write your own programs when
coreutils are not sufficient and this leads into my next point.

[pipes]: http://linfo.org/pipe.html

## Write simple functions instead of large scripts

I think one of the points that separates a computational scientist, such as a
bioinformatician, from a software developer is writing many individual scripts
instead of a single large program. Scripts are written to quickly test a theory
by performing an operation on a set of input data. The problem however is that
scripts can quickly become complected by braiding many different analysis
threads into a growing hairball of code.

Therefore instead of writing a script that performs several operations consider
writing a script that performs a single function: a small executable file that
takes an input file or stream and performs a single transformative mapping or
filter operation. This way it is simple to combine your own custom functions
with existing powerful coreutil functions. Furthermore small scripts have the
advantage of being easier to debug, change and remember.

Writing small functions instead of larger scripts means that the logic is in
the Makefile and you only need to look here to see understand what's happening
in your workflow. In contrast writing large multi-function scripts pushes a
portion of the workflow logic into the script files.

Finally by isolating and modularising into small code functions you are
becoming language agnostic, where you can write one function in Clojure, a
second in Ruby, and a third in R. Creating large monolithic projects however
often will tie you to a specific language.
