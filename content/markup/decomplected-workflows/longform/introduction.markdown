---
kind: article
title: introduction
---

I wrote a blog post four years ago called [organised bioinformatics
experiments][1] which described how I organised my computational projects. This
approach described using databases and the Ruby equivalent of GNU Make to make
organising *in-silico* research easier and also more reproducible. I have since
used this approach consistently since writing it, and several people have been
generous to say that this has also influenced the way they work.

In the last few months I have however changed the way I work. Therefore in this
post I'm going to deconstruct the previous 'organised bioinformatics
experiments' approach and outline some disadvantages. In subsequent posts I
will outline my new approach and why I think it is better.

I write this series with the aim of stressing the importance of organising
projects for new bioinformaticians, such as those doing a master's degree or
early in their PhD. I also hope to be able to highlight tools and approaches
that may not have been considered by more experienced bioinformaticians.

[1]: /post/organised-bioinformatics-experiments/

#### Reproducibility and Organisation

First I'm going to outline the problem of organising computational experiments.
These essence of this problems is writing a Perl script at the start of your
PhD and then trying to remember what this script does several years later when
you are writing your PhD thesis. How do you organise hundreds of files over the
years of a research project?

Wet lab scientists track all of their experiments in a lab notebook. This
produces a record of the steps taken in their research that allows someone else
to reproduce their experiments. This someone may include themselves when they
need to repeat or update an experiment days, months, years later. The problem I
have found in my own research are is there is no simple *in-silico* analogy to
laboratory notebook. How do I effectively reproduce my research from a set of
scripts I may not have looked at for a month? How do I organise all my scripts,
data, and output figures in the project? I think this question can be broken
down into two components:

  * **Reproducibility**:

    A research project map input data into a tractable format, run analyses on
    these data, then generate a set of output figures and statistics. The
    difficulty in making project reproducible is that all scripts must be run
    in the correct. Furthermore if the code in an earlier step changes then all
    subsequent downstream steps must be rerun. This process is fragile and can
    lead to errors and omissions.

  * **Organisation**:

    Research projects which start with an inkling of idea can rapidly grow into
    large numbers of scripts. How can these large numbers of related files be
    assembled in a project? How should data, figures and images be labelled? A
    well organised project should be able to be returned to in several months
    and its purpose understood with little effort.

#### Complected bioinformatics experiments 

In my previous [organised bioinformatics experiments post][1] I tried to
address these problems using a systematic approach. I specified this as
follows:

  * **Databases**

    All data should be entered into a database at the start of project. This
    keeps the data in a consistently accessible format. Denormalisation of data
    often makes integrating data from different sources simpler.

  * **Object Relational Management (ORM)**

    The data in the project should only be available in analysis steps via Ruby
    ORM classes. The reasons for this are that it makes accessing the data much
    simpler and data-accessing code can be found in the same place with
    descriptive names.

  * **Rake**
    
    Rake is a build tool similar to GNU Make but written in the Ruby
    programming language. Each analytical step should be defined as a Rake
    tasks. Parts of the project are ordered into incrementally numbered sub
    directories based on their order in the project. The reasons for this this
    that Rakefiles can be used to manage dependencies between project steps
    filing them into sub directories provides a consistent organisation.

You can find [an example project][2] organised this way on github. I think this
approach satisfies both of the requirements I outlined above. The analysis is
strictly organised into Rakefiles and takes care of calling the project steps
in the correct order. Second project is well organised as the data is kept in
the database, access to the data is allowed through Ruby ORM classes.

[2]: ADD EXAMPLE PROJECT URL

I found that over time as used this approach there were downsides. This
approach as complexity to a project. For instance:

  * **Tied to a specific programming language**

    Everything must be written in Ruby making it harder to include different
    programming languages. This can be worked around by calling secondary
    scripts using the shell from inside the Rakefile. Maintaining different
    shell scripts this way immediately adds complexity because all the analysis
    steps are no longer maintained in Rakefiles which returns to the original
    problem of keeping scripts organised.

  * **Database**

    Using SQL in conjunction with a databases can make certain types of
    operations much easier and faster than parsing a flat file with a script.
    Using a database unconditionally for all types of data however adds
    complexity because of the extra layer of code required to manipulate the
    data. Furthermore the data is effectively hidden. To see and get a feel for
    the data you're using you have to write queries into a database viewer,
    which is more overhead. 

  * **Mutable project state**

    Changing files or the database tables over different project steps adds
    mutability to a project. What state is the project in at any given time?
    For instance if you create a database tables then in the next step add an
    additional column the current state of the table must be tracked, which
    adds more complexity.

The 'organised bioinformatics approach' makes reproducing and organising a
project but not necessarily simpler. Using Rakefiles makes it easy to run
`rake` repeat all project analyses but adds what I think is a great deal of
complexity. This complexity is manifest as the project becoming increasing hard
to maintain and manage as it grows. Feeling an internal sense of resistance
when trying to change or update an aspect of an *in-silico* analysis is sign of
too much complexity. Therefore this has lead me to think that in addition to
reproducibility and organisation computational workflows have an additional
requirement:

  * **Simplicity**

    Computational analysis pipelines should be simple to maintain. This
    simplicity should make it trivial to add, update, or remove steps in the
    workflow.

Much of the inspiration for ideas I have outlined here come from [a talk given
by Rich Hickey][3], the inventor of Clojure. One of the points of his talk is
that we should prefer simple over easy, as choosing easy can lead to increasing
complexity in a project. Rich uses the term "complecting" to describe braiding
more and more software into the project resulting in greater and greater
complexity. Therefore with respect to this I going to describe in a following
series of posts what I think of as "Decomplected Computational Workflows."
These posts will described how I use Makefiles, language agnostic functions,
immutable data, and modularised projects to reduce the complexity in my
computational projects.

[3]: LINK TO RICH'S TALK
