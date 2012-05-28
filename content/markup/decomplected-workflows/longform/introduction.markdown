---
kind: article
title: introduction
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

