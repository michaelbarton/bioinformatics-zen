---
kind: article
title: Makefiles
prefix: true
created_at: "2012-07-10 00:00:00"
---

This is the second post in my series discussing creating simple, reproducible
and organised computational workflows. In this post I will focus on creating
reproducible workflows using GNU Make build files.

A bioinformatics research project should be easily reproducible. Anyone should
be able to repeat all the steps from scratch. Furthermore the simpler it is to
repeat all the project's analyses from the beginning the better.
Reproducibility should also include showing each intermediate step and the
processes used to generate the results. Making a project makes it simpler for
you to return to a project after several months and be able to repeat all your
work. Reproducible research also allows you to share your work with others whom
would like to build upon it.

Build files can be used to manage dependencies of steps upon each in a
computational workflow. Using a build file in your project therefore goes a
long way towards facilitating reproducible research. [GNU Make][make] provides
a syntax to describe project dependency steps as targets in a computational
workflow. Each target represents a file that should be created from a described
set of commands. An example Makefile looks like this:

[make]: ADD LINK TO MAKE

    two.txt: one.txt
        # Command line steps to create 'two.txt' using 'one.txt'

    one.txt:
        # Command line steps to create 'one.txt'
        # Multiple lines of shell commands can be used.

Each target is described on the unindented lines. The name of the create file
comes before the colon ':' and the dependencies needed to create this file come
after. The shell commands to used generate the target file are on the indented
lines following the task name.

The Makefile example above defines two tasks, each generating a file. In the
example these are the files `one.txt` and `two.txt`. In this workflow the
generation of the file `two.txt` is dependent on the generation of `one.txt.`
Calling `make` at the command line will evaluate these targets in the
top-to-bottom order defined in the Makefile.

The anatomy of a makefile target is therefore a line with the name of a file to
create and the dependencies required to do this. Shell commands to generate the
target file are on subsequent indented lines. Makefiles are then created by
chaining these targets together where one output file from one target is the
dependency for another.

I have started using GNU Make in my computational projects because this syntax
allows for very simple specification of a computational workflow. The
dependency system ensures that each target file is regenerated if any earlier
steps change. This therefore make computational projects very reproducible. I
have briefly have how GNU Make works, and in the sections below I will describe
the advantages of using GNU Make.

## Build workflows independent of any language

When I wrote my original post on ['Organised Bioinformatics
Experiments'][organised] I programmed mainly in Ruby. Therefore using the
Ruby-based Rake as a build tool made sense as I could write in the programming
language I was most familiar with.

[organised]: /post/organised-bioinformatics-experiments/

In the last two years I've been experimenting with other languages such as
Erlang and Clojure. I feel that in future I will continue to try new languages
I use and include them in research. Therefore the advantage of using Make over
Rake is that every workflow step is simply a call to the shell and rather than
being tied to a specific programming language. This allows me to use the shell
to call scripts written in any language.

In my my current process I package up my analysis code into scripts and call
these from the Makefile. Separating each analysis step into a single file makes
it much easier to switch out one language for another as long as they both
return the same output data. Often I end up replacing scripts with simple
shell-based combinations of pipes and coreutils. Using in-built shell commands
can often be simpler and faster than writing your own script. Finally
separating the analysis targets into individual files allows an even more
powerful aspect for creating more reproducible computational workflows which
I'll outline in the following section. 

## Generative code as a target dependency

Any file can be a dependency to a Make target, including the script doing the
data processing. For example, consider the example Makefile target:

    output.txt: bin/analyse input.txt
        $^ > $@

The target is a file called `output.txt` which requires two dependencies:
`bin/analyse` and `input.txt`. The target code takes advantage of Makefile
macros, which simplify writing targets. In this case `$^` expands to the list
of dependencies and `$@` expands to the target file. This is therefore similar
to writing:

    output.txt: bin/analyse input.txt
       bin/analyse input.txt > output.txt

The advantage of making `bin/analyse` as a target dependency is that whenever
this file is edited this step and any downstream steps will be regenerated when
I call `make` again. This is because `bin/analyse` will have a later time stamp
that than file that depends on it. This clarifies a critical part of making
workflow reproducible: it is not only when input data changes that a workflow
needs to be rerun, but also any scripts that process or generate data.
Declaring the data processing scripts as dependencies enforces this
requirement.

## Abstraction of analysis steps

Consider this example Makefile with three targets:

    all: prot001.txt prot0002.txt prot003.txt

    %.txt: ./bin/intensive_operation %.fasta
       $^ > $@

    %.fasta:
        curl http://database.example.com/$* > $@

Here the target `all` depending on files: `prot00[1-3].txt`. This target
however defines no code to create them. Furthermore in the following lines you
can see that there are no tasks to generate any of these files individually.
Instead there are tasks to generate files based on two file type extensions:
`.txt` or `.fasta`. When the Makefile is evalutated these wild card operators
will be expanded create targets for files that match the extensions. For
instance the following steps would be executed to generate `prot001.txt`.

    prot001.txt: ./bin/intensive_operation prot001.fasta
        ./bin/intensive_operation prot001.fasta > prot001.txt

    prot001.fasta:
        curl http://database.example.com/prot001 > prot001.fasta

This wild card % target specification allows the process to be abstracted out
independently of individual files. Instead generalised targets are available
for files based on their file extension. This makes it much simpler to change
the data analysed whilst still maintaining the same workflow. Concretely, this
means you can specify additional files to be generated in the `all` task
without changing the rest of the workflow. Idiomatically, I would use a
variable named `objects` to specify the output I am interested in.

    objects = prot001.txt prot002.txt prot003.txt

    all: $(objects)

    %.txt: ./bin/intensive_operation %.fasta
       $^ > $@

    %.fasta:
        curl http://database.example.com/$* > $@

You could go even further than this however and move the list of target files
to a separate file and read their names in as a dependency. This would mean you
would only change the Makefile when making changes to your workflow, thereby
isolating changes between the workflow process and the workflow output to
different files in the revision control history.

## Very simple parallelisation

Bigger data sets required more time to process and taking advantage of
multi-core processors is a cheap way to reduce this. Given the Makefile I
outlined in the previous section I can invoke `make` as follows.

    make -j 4

As I defined my targets above by abstracting out the process based on file
extension each target step can be run independently. Therefore make can use a
sperate process to generate each of the required files. If the number of files
required to be generated exceeds the number of processes specified by the `-j`
flag then these will begin after previous targets have finished. This is a very
cheap method to add multi-core parallelisation to a workflow, as long as you
can abstract out the workflow processes to fit this.

## Summary

Make provides a very elegant functional language, where targets can be thought
of as functions mapping the data from one input file into an output file. The
Make syntax is however very simple, and adding or updating tasks is
straight-forward. Make further allows for simply including your own scripts as
dependencies in a workflow or dropping down to fast and powerful coreutil
functions.
