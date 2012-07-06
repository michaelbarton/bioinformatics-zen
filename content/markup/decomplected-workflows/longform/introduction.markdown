---
kind: article
title: Introduction
created_at: "2012-07-09 00:00:00"
---

I wrote a blog post four years ago called ['organised bioinformatics
experiments'][1] which my method for maintaining computational projects. This
approach described using databases to manage data and the Ruby equivalent of
GNU Make to organising the *in-silico* analysis steps. I have been using this
approach since writing about it, and several people have generously this post
has influenced the way they work.

In the last few months I have however changed the way I work and in this post
I'm going to deconstruct the previous 'organised bioinformatics experiments'
approach. I will outline what I think are the reasons for using this method and
what are the disadvantages. In subsequent posts I will outline a different
approach which I now use instead.

I write this series with the aim of stressing the importance of organising
projects for new bioinformaticians, such as those doing a master's degree or
early in their PhD. I also hope to be able to highlight tools and approaches
that may also be useful to more experienced bioinformaticians.

[1]: /post/organised-bioinformatics-experiments/

#### Reproducibility and Organisation

First I'm going to outline a problem in computational research which is
organising the files and steps in a research workflow. These essence of this
problem is writing a Perl script at the start of your PhD and then trying to
remember what this script does several years later when you are writing your
PhD thesis. How do you organise hundreds of files and scripts over the years of
a research project?

Wet lab scientists track all of their experiments in a lab notebook. This
produces a record of the steps taken in their research that allows someone else
to reproduce their experiments. This someone may include themselves when they
need to repeat or update an experiment days, months, years later. The problem I
have found in my own research is that there is no simple *in-silico* analogy to
a laboratory notebook. How do I effectively reproduce my research from a set of
scripts I may not have looked at for a month? How do I organise all my scripts,
data, and output figures in the project? I think this question contains two
parts:

  * **Reproducibility**:

    A research project map input data into a tractable format, runs analyses on
    these data, then generates a set of output figures and statistics. The
    difficulty in making a project reproducible is that all scripts must be run
    in the correct order. Furthermore if the code in an earlier step changes
    then all subsequent downstream steps must be rerun. This process is fragile
    and leads to errors and omissions.

  * **Organisation**:

    Research projects which start with an inkling of idea can rapidly grow into
    large numbers of scripts. How can these large numbers of related files be
    assembled in a project? How should data, figures and images be labelled? A
    well organised project should be able to be examined after several months
    and the purpose of the components understood with minimal effort.

#### Complected bioinformatics experiments 

In my previous [organised bioinformatics experiments post][1] I tried to
address these problems using the following systematic approach:

  * **Databases**

    All data should be entered into a database at the start of project. This
    keeps the data in a consistently accessible format. Denormalisation of data
    makes integrating data from different sources simpler.

  * **Object Relational Management (ORM)**

    The data in the project should only be available in analysis steps via Ruby
    ORM classes. This makes accessing the data simpler and all data-related
    code is in the same location.

  * **Rake**
    
    Rake is a build tool similar to GNU Make written in the Ruby language. In a
    research project each step should be defined as a Rake task. Parts of the
    project are divided into incrementally numbered sub directories based on
    their order in the project. This means all analytical code is found in
    Rakefiles and provides a consistent organisation.

You can find [an example project][2] organised this way on github. I think this
approach satisfies both of the requirements I outlined above. The analyses are
strictly organised into Rakefiles which call the project steps in the correct
order. Secondly the project is well organised as the data is kept in the
database, and access is only through Ruby ORM classes. Nevertheless I found
over time there are some downsides, and these downsides are mainly of
complexity.

[2]: ADD EXAMPLE PROJECT URL

  * **Tied to a specific programming language**

    Everything must be written in Ruby making it harder to include different
    programming languages. This can be worked around by calling secondary
    scripts using the shell from inside the Rakefile. Maintaining different
    shell scripts however add complexity because because the analysis has now
    moved out of the Rakefile.

  * **All data in a database**

    SQL can make generating complex data joins much simpler. Using a database
    unconditionally for all types of data however adds complexity in the extra
    layer of code required to manipulate the data. Furthermore the data is
    effectively hidden. To see and get a feel for it you'll need to use a
    database viewer.

  * **Mutable project state**

    Changing files or database tables in different project steps adds
    mutability to a project. What state is the project in at any given time? If
    you create a database table in one next step add an additional column in a
    later current state of the table must be tracked, adding complexity.

The 'organised bioinformatics approach' makes reproducing and organising a
project easer. I however think it does not make it simpler. Using Rakefiles
makes it easy to run `rake` to repeat all project analyses but adds what I
think is a great deal of complexity. This complexity is manifest as the project
becoming increasing hard to maintain as it grows. Feeling an internal sense of
resistance when trying to change or update a workflow step is a sign of too
much complexity. Therefore this has lead me to think that in addition to
reproducibility and organisation, computational workflows have an additional
requirement:

  * **Simplicity**

    Computational analysis pipelines should be simple to maintain. This
    simplicity should make it trivial to add, update, or remove steps in the
    workflow.

Much of the inspiration for what I have outlined here come from [a talk given
by Rich Hickey][3], the inventor of Clojure. One of the points he makes is that
we should prefer simple over easy, as choosing easy can lead to increasing
complexity in a project. Rich uses the term "complecting" to describe braiding
more and more software into the project resulting in greater and greater
complexity. Therefore with respect to this I going to describe in a following
series of posts what I think of as "Decomplected Computational Workflows."
These posts will described how I use Makefiles, language agnostic functions,
immutable data, and modularised projects to reduce the complexity in my
computational projects.

[3]: LINK TO RICH'S TALK
