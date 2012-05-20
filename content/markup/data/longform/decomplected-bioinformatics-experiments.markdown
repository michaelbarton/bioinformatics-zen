---
kind: article
title: Decomplected bioinformatics experiments
---

I wrote a blog almost four years ago on how to [organise bioinformatics
experiments][1]. I wrote about how I thought bioinformatics should be organised
and the best way to run computational analysis. I have used this approach for
several years but have recently started taking a different approach. So here
I'm going to deconstruct my previous 'Organised bioinformatics experiments'
approach and outline the 'Decomplected bioinformatics experiments' approach I 
have been using more recently. Before I do this however I'm going to outline 
the problem I trying to solve in my day-to-day workflow.

[1]: /post/organised-bioinformatics-experiments/

#### Reproducibility and Organisation

Wet lab scientists track all of their experiments in a lab notebook. This
produces a record of the steps taken in their research and should allow someone
else to reproduce their experiments. This someone may include themselves when
they need to repeat or update an experiment days, months, years later.

The problems I have found in my own research are is there is no simple *in
silico* analogy to laboratory notebook. How do I effectively reproduce my
research from a set of scripts I may not have looked at for a month? How do I
organise all my script, data, and output figures in the project? I think these
questions distill into two problems:

  * **Reproduciblity**: The steps in research project often map input data into
    a tractable format, run analyses on these data, then generate a set of
    output figures. The difficulty creating a reproducible is that all the
    scripts used to run the analysis must be correctly run in order.
    Furthermore if an earlier step is changed all downstream steps must be
    rerun. This process is fragile and can lead to errors if steps are not
    correctly called.

  * **Organisation**: Research projects which start with an inkling of idea can
    rapidly grow into large numbers of scripts. How can these large numbers of
    related files be organised in a project? How should data, figures and
    images be label? The problem of organisation comes from trying to solve
    these issues so that a project can be returned to in several months and
    it's purpose understood with a quick review.

#### Complected bioinformatics experiments 

In my previous ['Organised Bioinformatics Experiments' post][1] I tried to
address these problems using a systematic approach. Concretely I specified that
all data should be entered into a database at the start of project. This data
should is made available to analysis in the project using predefined methods in
Ruby ORM classes. Finally each step in the analysis is defined within rake
tasks (a make-like tool for Ruby) in project subdirectories, a master rakefile
then requires each of the subdirectory rake files. You can find [an example
project][2] organised this way on github.

[2]: ADD EXAMPLE PROJECT URL

I believe this approach satisfies both of the requirements I outlined above.
Firstly the analysis steps are strictly organised into Rake files. This makes
the project reproducible as Rake takes care of calling any downstream steps
when there is an upstream change in the workflow. Second project is well
organised as the data is kept in the database, access to the data is allowed
through Ruby ORM classes, and all analysis steps are in the Rake files. So what
is the problem?

I think that there is a third requirement for creating a computational
pipelines and that is *simplicity*. Organising computational analysis this way
adds a lot of complexity to the project. Three examples:

  * **Tied to a programming language**. Everything must be writen in Ruby, this
    makes it harder to include different languages. The solution to this is to
    shell out to second script containing the data. Maintaing different shell
    scripts this way immediately adds complexity because all the analysis steps
    are no only maintained in the Rake files.

  * **Database**. Using SQL in conjuction with a databases can make certain
    types of operations much easier and faster than parsing a flatfile with a
    script. However using a database for all types of data adds complexity
    because of the extra layer of code required to manipulate the data.
    Furthermore the data is effectively hidden. To see and get a feel for the
    data you're using you have to use a database viewer, which again is more
    complexity. 

  * **Mutable project state**. Updating files or the database over different
    project steps adds a layer of mutability to a project. What state is the
    project in at any given time? For instance if you take more than one pass
    over a database table you have to keep track of that table somehow, which
    is adding more complexity.

The example I outlined above here I think are the result of example of choosing
easier over simpler. Using Rakefiles makes it easy to call `rake` in the
project root to run all analyses from the beginning. This satisfies the
*reproducibility* requirement, this however adds complexity. This complexity
manifest as the project becoming increasing hard to maintain and manage as it
grows. Have you ever had a feeling a resistance when you're required to change
or update an aspect of an *in-silico* analysis? This is the complexity of a
project making it harder and harder to do this. This is why computational
workflows have an additional requirement:

  * **Simplicity**: Computational analysis pipelines should be simple to
    maintain. This simplicity should make it trivial to add, update, or remove
    steps in the workflow.

A greal deal of the inspiration for this post comes from [a talk given by Rich
Hickey][3], the inventor of the Clojure programming language. One of the points
of his talk is that we should prefer simple over easy, as repeatedly choosing
easy can lead to increasing amount of complexity in a project. Rich uses the
term "complecting" to describe braiding more and more software into the project
to increase the complexity. The term I use here "Decomplected Bioinformatics
Experiments" is therefore a nod to this.

[3]: LINK TO RICH'S TALK

#### Decomplected Bioinformatics Experiments

The workflow I use now is composed of Makefiles, language agnositic functions,
immutable data, and modularised projects. I outline how I use each of these
steps below:

##### Makefiles

In my previous post I described how I used Rakefiles to make projects
reproducible. Using Rake you can define each step in a computational workflow
as follows:

    task :one do
      # execute Ruby code inside here.
    end

    task :two => :one do
      # execute more code
    end

    task :default => :two

This means that task 'two' is dependent on task 'one.' Writing `rake two` on
the command line will therefore call the code inside 'one' followed by the code
inside the 'two' block. When I set a 'default' task in the last line this
defines which task is called when I just call `rake` without any arguments. If
I set the default task to the last step in the project I can in theory rerun
all the analysis in my project from the beginning just with a single `rake`
command. 

Now consider a Makefile in comparison:

    two: one
        # Execute something here

    one:
        # Execute something else

Rakefiles and Makefiles both allow a syntax for describing dependencies between
steps in a workflow. Makefiles are however generally focused on steps which
depend on files from the previous step and produce files in the next step.
Rakefiles in contrast generally focus around executing code which is indepdent
of files. I have since switched from Rakefiles to Makefiles for the following
reasons:

###### Simpler dependencies between steps

I found that, occasionally, if the dependencies between steps in Rakefile
became too complicated then some steps would not always be executed. I found
this quite hard to debug at times. 

In comparison Make dependencies are based on file names. Consider the simple
dependency A -> B, where both are files, if A has a chronologically later time
stamp than B then the step that regenerates be will be updated otherwise
nothing will change. I found this made Makefile-based projects both
reproducible and much simpler.

###### Language agnostic

Using Rake meant that I had to write all the steps in Ruby. I was pretty happy
with this since Ruby is a great language to write in. I've however started
really enjoying writing in Clojure so I no longer want to have to write
everything in Ruby. All Makefile steps are shell calls. So instead of writing
Ruby code inside the Rakefile I package the code, in any language, as a binary
I can call from the Makefile. This is especially useful as you'll see in the
next section. Since the Makefile uses the shell it makes it much easier to use
the very powerful coreutils available on every \*NIX distribution.

###### Dependencies include the generative code

Dependecies can be any type of file including the file you're calling. For
example, consider the following simple Makefile task:

    output: ./bin/analyse input
        $^ > $@

In the first line I am generating an output file call 'output.' This file is
dependent on two files './bin/analyze' and 'input.' I use the Makefile macros
'$^' and '$@' to specify the dependency file list and the output file
respectively. The second line is therefore becomes ` ./bin/analyse input >
output`.

The point that really struck me as making Makefiles useful is that by making
the './bin/analyse' file a dependency when I edit this file, thereby changing
the timestamp, the output of this step and any downstream steps will be rerun
when I call `make` again. This solves a very important problem for me: it's not
just if the data changes that a workflow needs to be rerun, but also any
scripts that are used to generate the data.

###### Abstraction of steps

Make allows the following syntax

    all: prot00001.txt prot00002.txt prot00003.txt prot00004.txt

    *.txt: ./bin/intensive_operation *.fasta
       $^ > $@

    *.fasta:
        curl http://database.example.com/$@ > $@

UPDATE THIS SECTION WITH THE CORRECT * MACRO

The first line specifies that four files are required for the final make task.
There are however no dependencies that list these files, instead there are
dependencies listing files based on the file type extension. The chain of
depencies downloads a `.fasta` file corresponding the name of the file. The
next step is then performs an operation on this fasta file and produces a
`.txt` file also with the corresponding name.

Using this format allows the operations to be abstracted to be abstracted out
over the file extensions. This makes it much simpler to change the data from
the process. If I need to add another file I just add this in the `all` task.
If I need to change the process for producing the output I just edit the
relevent task. Idiomatically, however, I should use a variable named `objects`
to specify the output I am interested in.

    objects = prot00001.txt prot00002.txt prot00003.txt prot00004.txt

    all: $(objects)

    *.txt: ./bin/intensive_operation *.fasta
       $^ > $@

    *.fasta:
        curl http://database.example.com/$@ > $@

I would go further than this however and move all the objects to a separate
file and read their names in as a dependency. This would mean you would only
change the Makefile when making changes to your workflow, thereby isolating
different changes to different files in the revision control history.

###### Very simple parallelisation

Bigger datasets required more time to process and taking advantage of mutlicore
processors is a cheap way to reduce this running time. Given the Makefile I
outlined about in the previous section I can run this command.

  `make -j 4`

This create a separate process to generate each of the four required files. If
the number of files required to be generated exceeds the number of processes
specified, using the `-j` flag, then these will begin after another has
finished.  This approach is a pretty simple method for parallelising tasks, as
long as you can abstract out the workflow processes to fit this approach.

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

Makefile tasks are functions taking one file as an input and returning another
as an output. The advantage of small compartmentalised functions is that it is
simple to see the output of each step and verify it is what you expect. In
contrast loading several different types of data into a database and then
pulling out a single file at the end provides more opportunity for error.

Each Makefile step can be decomposed further by breaking up the internal
process. Let me use the following example to illustrate


allows you to use any tools, ruby, clojure, coreutils, biopieces

    - don't using scripts, use bin files as essentially transforming functions
      that can be mapped using make
    - scripts are still bad and add complexity

    - the only thing `doing things` is the Makefile

###### Prefer line based input output files

FUNCTIONAL APPROACH
    - simple flat files can also be manipulated using coreutils which are fast
      and easily parallelisable
    - create single input bin files easy to get simple parrallelisation with
      xargs and make -j then

  MODULARISATION:
    - Don't keep anything local.
    - Forces results to be easily reproducible.
    - Forces you to break up and modularise the code.
    - Also doesn't matter if your computer gets stolen etc.

MAKE

  ADVANTAGES:
    - move from organisation to simplicity
    - decomplect => don't make projects easier, make them simpler
    - use very simple flat file formats as the API
    - must be simple otherwise it becomes hard to remember their purpose
    - parrallelisation
    - API is the data - functional programming approach
    - thoroughly tested and used software
    - update only uncompleted steps
    - simple parallelisation
    - fast
    - easy access to the powerful UNIX shell

  TRADEOFFS:
    - Timestamp based
    - somewhat ugly syntax difficult
    - possible to get into depdency problems


WRITEUP:

  MAKE:

  EXAMPLES
    - generating a plot from an R script
    - hmmer analysis for parallelisation
    - complex cluster identification approach

  REFLECTION:
    - seem obivious to many people
    - Java, Ant, XML, MySQL
    - Ruby, ORM/ActiveRecord, Rake, YAML
    - Clojure/Lisp, flatfiles, Make, coreutils,
    - change in attitude, think I know everything =>  realise I know very little
    - Still use databases where appropriate - tokyocabinent generates single
      file.
