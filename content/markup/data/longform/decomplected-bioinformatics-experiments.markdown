---
kind: article
title: Decomplected bioinformatics experiments
created_at: "2012-05-13 00:00:00"
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

#### Maintanence and reproducibility

Wet lab scientists have to track all of their experiments in a lab notebook. 
The reasons for this are so that there is a record what they've done in their 
research which should allow someone else to reproduce their experiments. This 
someone may include is usually themselves when they need to repeat or update an 
experiment days, months, years later.

The problems I have found in my own research are an *in silico* equivalent of a 
laboratory notebook. How do I effectively reproduce my research from a set of 
scripts I may not have looked at for a month? How do I organise all my
script, data, and output figures in the project? What are I think this boils 
down to in computational research is two problems:

  * **Reproduciblity**
    The steps in research project often involve mapping input data into 
    different formats, run analyses on these data, then generate output 
    figures. The problem of reporducibility comes because the input of 
    downstream scripts is dependent on the output of previous scripts. Each 
    step must be run correctly in order to regenerate the results. This is 
    fragile and can lead to errors if steps are not correctly called.

  * **Maintainability**:
    Research projects which start with an inkling of idea can rapidly grow into 
    large numbers of scripts. How can large numbers of related files be 
    organised in a project? How should input and output data be labelled and 
    organised? How should scripts be named? Given the fragile nature of these 
    workflow outlined about how can the scripts be easilty changed and updated  
    to modify the steps without extensive rework?

#### Complected bioinformatics experiments 

In my ['Organised Bioinformatics Experiments' post] I tried to address these 
problems ...

  BACKGROUND:
    - Make is dry lab equivalent of lab book.
    - make is lab book, but also something that can be used to reproduce the 
      entire
      output.
    - rich hicky talk


PROBLEM:
  - The problem is complexity.
  - Computational experiments are hard to reproduce and hard to maintain.
  - The complexity makes it hard to maintain and update the project as it
    grows.
  - Writing this code is too heavy-weight too.

CONSTRAINTS:
  - Solution needs to be simple to write
  - Simple to maintain
  - Language agnostic for everyone to use it
  - Be able to deal with very large datasets

SOLUTION:
  - make + coreutils

ADVANTAGES:
  - thoroughly tested and used software
  - update only uncompleted steps
  - simple parallelisation
  - fast
  - based on the shell

TRADEOFFS:
  - Timestamp based
  - somewhat ugly syntax difficult
  - possible to get into depdency problems
  - unix-based

WRITEUP:

  PROBLEMS WITH PREVIOUS POST:
    - too complicated, language specific
    - too many things braided together
    - makes things easier, but not simpler
    - too hard to maintain, too co-dependent
    - don't using scripts, use bin files as essentially transforming functions that
      can be mapped using make
    - scripts are still bad and add complexity
    - the only thing `doing things` is the Makefile

  MAKE:
    - move from organisation to simplicity
    - decomplect => don't make projects easier, make them simpler
    - use very simple flat file formats as the API
    - must be simple otherwise it becomes hard to remember their purpose
    - simple flat files can also be manipulated using coreutils which are fast and
      easily parallelisable
    - parrallelisation
    - line based input output files
    - API is the data - functional programming approach
    - allows you to use any tools, ruby, clojure, coreutils
    - much, much easier to swap out components => biopieces
    - ipython is something similar.
    - create single input bin files easy to get simple parrallelisation with
      xargs and make -j then

  LOCALLY CACHE TO DEVELOP:
    - Don't keep anything local.
    - Forces results to be easily reproducible.
    - Forces you to break up and modularise the code.
    - Also doesn't matter if your computer gets stolen etc.

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
