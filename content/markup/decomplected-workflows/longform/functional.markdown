
##### A functional approach to building workflows

I have described how using Makefiles can result in simpler but still
reproducible workflows. A second way I think workflows can be further
simplified is to take a functional approach to organising the workflow. Two
considerations in functional programming, is firstly to think as functions as
the primary compondents of the the program, and secondly that all data is
cannot be changed after creation.

###### Data is the API of the workflow

Speaking from experience it is very tempting to force an object orientated
approach into a bioinformatics workflow. An example of this is using an ORM and
then injecting objects into your workflow. This means you have to consider the
methods the classes provide to access the data, and secondly how is the data
going to be based between the steps of the workflow. I have instead to just use
the data as the API of the workflow, all that really matters is how the data is
going to be passed between each step of the workflow and in which format. This
cuts out a large part of the complexity of the workflow. In the case of using
Makefiles I just need to generate simple easily parsable output file for the
next step. Previously I might have considered serialising objects to file and
the marshalling them to do things in the next step. This is, however, just
plain horrible.

###### Immutable data

Consider all data immutable once you have generated it. Don't update a file
that has been created, instead generate a copy of the file with required
changes. This removes "state" from the workflow. You don't need to look inside
a file to see if the changes have been applied: all you need to know is if it
exists or not. Furthermore it's very simple to `diff` two files to what the
changes are, rather than compare before/after versions of the file.

The above statement might preclude the possiblity of using databases in
workflow steps. This is however not the case. A common pattern in my workflows
is to fetch a set of data I wish to analyse, build it into a database, then
generate different file types I wish to analyse based on this database. The
only condition of doing this is that the database must be a file type. I prefer
to using simple key-value pairs in a text file then use grep to fetch out the
required values. More complex databases and faster database can however be
generated Tokyo Cabinet which uses a file. Using a text file as the database
important fits into a Makefile workflow, which means that I my input data is
changed then make takes care of automatically regenerating the database and all
downstream steps.

###### Functions composed of simple functions

Makefile tasks can be considered as functions taking one file as an input and
returning another as an output. The advantage of small compartmentalised
functions is that it is simple to see the output of each step and verify it is
what you expect. In contrast loading several different types of data into a
database and then pulling out a single file at the end provides more
opportunity for mistakes.

Makefile steps can be decomposed further by breaking up the steps. The GNU
coreutils provides a wide variety of programs that you might be tempted to
write your own program to produce. For instance there are many useful commands
for manipulating data:

  * [cut][]: Select specific columns from delimited data formats.
  * [tr][]: Translate characters of one type into another.
  * [paste][]: Join lines from different files together as columns.
  * [join][]: Row join two files together based on common identifiers.
  * [comm][]: Select or reject common lines between two files.
  * [uniq][]: Select or count unique lines in a file.
  * [sort][]: Sort lines in file.

[cut]: http://man.cx/cut
[tr]: http://man.cx/tr
[paste]: http://man.cx/paste
[join]: http://man.cx/join
[comm]: http://man.cx/comm
[uniq]: http://man.cx/uniq
[sort]: http://man.cx/sort

SEE ALSO BIOPIECES, SSED and GREP

UNIX pipes can also be used to [redirect the input of one command into
another][pipes]. Therefore as much as possible your Makefile steps should be
composed of small functions piping their input between each other. The
advantage is that a UNIX command will be faster and bug-free compared to
anything you would write your self. Furthermore steps composed of curetil
pipelines are easier to edit and debug. This part of the UNIX philosophy:
simple parts connected by clean interfaces. You will however still need to
write your own programs when core utils are not sufficient and this leads into
my next point.

[pipes]: http://linfo.org/pipe.html

###### Write functions instead of scripts

I think one of the points that separates a computational scientist, such as a
bioinformatician, from a software developer is writing many individual scripts
instead of a single large program. Scripts are written to quickly test a theory
by performing some operation on a set of input data. The problem however is
that scripts can quickly grow become complected by braiding many different
analysis threads into a large hairball of code.

Instead of script consider writing a function: a small portion of code that
takes an input file or stream and perfroms a single transformative mapping or
filter operation. This way it is simple to slot this function into a command
line pipeline. Writing functions instead of scripts also means all the analysis
logic is in the Makefile you will generally only need to look here to see
understand what's happening in the pipeline and therefore only need to change
the Makefile most of the time to change the analysis. Finally by isolating and
modularising into small code functions you are becoming language agnostic you
can write one function in clojure, and another in ruby, and a third in R.
Writing large monolithic ties you to a single language. Finally small scripts
are easier to debug, change and understand

