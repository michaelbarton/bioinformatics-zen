---
feed: false
tags: post
title: Scripting
date: 2009-02-20
---

Scripts differentiate computational research from software production. A script
is a file of code with a specific purpose such as running a BLAST search on the
_E. coli_ genome. Contrast this with much larger programs designed to manage a
variety of inputs and commands. A bioinformatician uses scripts as research
tools in the same way a laboratory biologist uses a pipette. In software
development, scripting supplements the designing of a software product. The
focus is the finished product and scripts there to make source code management
or unit testing easier. Since scripts receive comparably less attention as a
part of software design, is there best practice for using scripts?

### Managing dependency

Scripts are often required to run in a specific order. One script produces a
result which is the input to the next script. This means the second script is
dependent on the first. Dependency in software equates to increased complexity
and requires more work to maintain a project. For example, if there is an
undetected bug in one script mistakes are propagated as the next scripts are
run. Or if one script in a series is missed, and the output files of a previous
iteration still remain, then datasets are mixed between workflow repetitions
resulting in unexpected side effects.

Removing the dependencies between workflow steps is difficult. Build files such
as [Rake][rake], [Ant][ant], and [make][make] allow dependencies between
scripted steps to be formalised: the required previous steps are automatically
run first. This is useful to force the requirement that all previous results
are deleted before hand, [or that all rows in the database are
refreshed][biorake], or even that the entire analysis is repeated from scratch.
[Capistrano][cap] is a variant where build files can be used to automate
repetitive tasks across multiple remote computers. All of this can be managed
using single command line calls.

### Light and fluffy

Light and simple scripts are easier to maintain. To simplify, a script reads in
a set of input data (such as a protein sequence), analyses the data (formatdb
on a sequence database followed by BLAST), and then returns to the data (prints
the results to the command line). Using this simplification, a script only
needs to know what data is coming in, how to analyse the data, and how to
return it.

Scripts can be made lighter by reducing the amount of analytical code. Instead
of writing the code to call and parse BLAST, use existing code such as in
[BioPerl][perl]. If the code you need doesn't exist anywhere else, consider
writing it as a separate library which can be shared across all your scripts. A
script that reads in a the data, calls an external library, then prints the
results will be smaller and simpler to understand. Contrast this with a script
that reads in data, formats the data, has several lines of a code to interpret
and massage the results, then writes output.

Keeping light and simple, and formalising dependencies makes script-based
projects easier to manage, maintain, and repeat.

[make]: http://www.gnu.org/software/make/
[ant]: http://ant.apache.org/
[rake]: http://rake.rubyforge.org/
[biorake]: http://github.com/jandot/biorake/tree/master
[cap]: http://capistranorb.com/
[perl]: http://www.bioperl.org/wiki/Main_Page
