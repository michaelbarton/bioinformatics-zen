---
kind: article
title: Decomplected bioinformatics experiments
created_at: "2012-05-13 00:00:00"
---

PROBLEM:
  - The problem is complexity.
  - Computational experiments are hard to reproduce and hard to maintain.
  - The complexity makes it hard to maintain and update the project as it 
    grows.

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

  BACKGROUND:
    - Wet lab scientists need to keep track of everything they do.
    - Make is dry lab equivalent of lab book.
    - ipython is something similar.
    - make is lab book, but also something that can be used to reproduce the entire 
      output.

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
    - much, much easier to swap out components
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
