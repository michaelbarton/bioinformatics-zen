
### A functional approach to building workflows

In the previous post I described how using Makefiles can result in simple and
reproducible workflows. Here I'm going to outline simplifying workflows further
by taking a functional approach. Functional programming is an alternative
paradigm to imperative programming such as C or object orientated programming
such as Java. There are two concepts in functional programming which I think
are particularly applicable to creating computational workflows: treating
functions as the primary components, and that all data is immutable after
creation.

### Data is the API

Speaking from experience there is a temptation to force an object orientated
approach into a computational workflow. An example of this is using an ORM and
then injecting objects into your workflow. This means you have to consider both
the methods the classes provide to access the data and also how this data is
passed between the steps of the workflow. This adds two considerations instead
of just the one of passing the data around.

Making the data the primary API of the workflow makes everything simpler. All I
need to know is the input data format and which format the next requires the
data to be in. Therefore if I'm using make I just need to generate a simple
easily parsable output file for the next step. Using Ruby objects as the API of
the workflow instead requires me to start serialising objects to file or
database and the marshalling them to do things in the next step. If your
objects change then everything needs to change. This is a horrible way to work.

### Immutable data

Consider all data immutable once you have generated it. Don't update a file
that has been created, instead generate a copy of the file with required
changes. This removes "state" from the workflow. You don't need to look inside
a file to see if the changes have been applied: all you need to know is if it
exists or not. Furthermore it's very simple to `diff` two files to see what the
changes are, rather than trying to compare the before and after versions of the
file.

The above statement might preclude the possibility of using databases in
workflow steps. This is however not the case. A common pattern in my workflows
is to fetch a set of data I wish to analyse, build it into a database, then
generate different file types I wish to analyse based on this database. The
only condition of doing this is that the database must be a file. Concretely,
the database should be file which can be used as a make dependency.

I prefer to using simple key-value pairs in a text file where ever possible as
this allows coreutils such such as grep to fetch and manipulate required
values. More complex queries and faster random database can however be
generated from in-file databases such as [Tokyo Cabinet][tokyo]. Using an
in-file database importantly fits into a Makefile workflow means that if any
input data changed then the database and all downstream steps will be
automatically be regenerated.

[tokyo]: ADD TOKYO LINK

### Functions composed of simple functions

Makefile targets can be considered as functions taking one file as an input and
returning another as an output. The advantage of small compartmentalised
functions is that it is simple to see the output of each step and verify it is
what you expect. The alternative approach I previously advocated was loading
several different types of data into a database and then generating a single
output file. I believe however combining many steps into a database however
provides more opportunity for mistakes: small decomposed workflow steps are
easier to examine, debug and replace.

Makefile targets can often be composed from smaller focused functions combined
together to produce the required output. The GNU coreutils provides a wide
variety of programs that, if you didn't know about them, you might be tempted
to write your own equivalent script. There are many useful commands in the
coreutils for manipulating data:

  * [cut][]: Select specific columns from delimited data formats.
  * [tr][]: Translate characters of one type into another.
  * [paste][]: Join records from different files together as columns.
  * [join][]: Row join two files together using on common identifiers.
  * [comm][]: Select or reject common lines between two files.
  * [uniq][]: Select or count unique lines in a file.
  * [sort][]: Sort records by different file columns.
  * [sed][]: Complex file transformations and editing (Also ssed too).
  * [grep][]: Select records by more complex criteria.

[cut]: http://man.cx/cut
[tr]: http://man.cx/tr
[paste]: http://man.cx/paste
[join]: http://man.cx/join
[comm]: http://man.cx/comm
[uniq]: http://man.cx/uniq
[sort]: http://man.cx/sort
[sed]: http://man.cx/sed
[grep]: http://man.cx/grep

UNIX pipes can also be used to [redirect the input of one command into
another][pipes]. Therefore as much as possible my Makefile steps are composed
of small functions piping their input between each other. The advantage is that
a UNIX command will be faster and bug-free compared to anything you would write
yourself. Furthermore Makefile targets composed of coreutil pipelines are easier
to edit and debug. This part of the UNIX philosophy: simple parts connected by
clean interfaces. You will however still need to write your own programs when
core utils are not sufficient and this leads into my next point.

[pipes]: http://linfo.org/pipe.html

### Write functions instead of scripts

I think one of the points that separates a computational scientist, such as a
bioinformatician, from a software developer is writing many individual scripts
instead of a single large program. Scripts are written to quickly test a theory
by performing some operation on a set of input data. The problem however is
that scripts can quickly grow become complected by braiding many different
analysis threads into a large hairball of code.

Therefore instead of writing a script consider writing a function: a small
function that takes an input file or stream and performs a single
transformative mapping or filter operation. This way it is simple to combine
your own custom functions with the powerful coreutil functions. Finally small
scripts are easier to debug, change and understand

Writing small functions instead of scripts means that the logic is in the
Makefile and you only need to look here to see understand what's happening. In
contrast writing scripts distributes the workflow logic across each of the
script files. 

Finally by isolating and modularising into small code functions you are
becoming language agnostic, where you can write one function in Clojure, a
second in Ruby, and a third in R. Creating large monolithic projects however
ties you to a single language.
