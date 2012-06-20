---
kind: article
title: Makefiles
---

A bioinformatics research project should be easily reproducible. Anyone should
be able to repeat all the steps from scratch and the simpler, the better.
Reproducibility should also show the processes used to generate the results.
Build files are a method that can be used to manage the dependencies between
project steps and go a long way towards reproducible research.

[GNU Make][make] provides a syntax to describe project dependency steps as
targets in a computational work flow. Each target is a file to be created using
the shell. A target is repeated if there is dependency file with a time stamp
later than the current target file. An example Makefile looks like this:

[make]: ADD LINK TO MAKE

    two.txt: one.txt
        # Run command line steps here

    one.txt:
        # Run command line steps here

Each task is named and dependencies are listed after the colon ':'. The shell
commands to generate the target file are on the indented lines following the
task name. These commands should generate named file if any subsequenct tasks
require this as a dependency.

The Makefile example above defines two tasks, each generating a file. In the
example this is `one.txt` and `two.txt`. In this workflow the generation of the
file `two.txt` is dependent on the generation of `one.txt.` Calling `make` at
the command line will evaluate these targets in the order defined by the
Makefile.

I have since started using GNU Make in my computational projects because this
syntax allows for very simple specification of a computational workflow.
Furthermore the dependency system ensures that each targets is regenerated if
any early steps change. Overall this can make computational projects very
reproducible. In the sections below I will further describe the advantages of
this approach.

### Build workflows independent of any specific language

When I wrote my original post on ['Organised Bioinformatics
Experiments'][organised] I programmed mostly in Ruby. Therefore using the
Ruby-based Rake tool made sense as I could write in the programming language I
was most familiar with.

In the last two years I've been experimenting with functional programming
languages such as Erlang and Clojure. I feel that in future I will continue to
broaden the languages I use and therefore include them in research workflows.
The advantage of using Make over Rake is that every workflow step is simply a
call to the shell and rather than being tied to a specific programming
language. This allows me to use the shell to call scripts written in any
language.

In my my current process I package up my analysis code into scripts and call
these from the Makefile. Separating each analysis step into a single file makes
it much easier to switch out one language for another when appropriate. Often I
end up replacing scripts with simple shell-based combinations of pipes and
coreutils. Using in-built shell commands can often be simpler and faster than
writing a your own script. Finally separating the analysis targets into
individual files allows an even more powerful aspect for creating more
reproducible computational workflows which I'll outline in the following
section. 

[organised]: LINK TO ORGANISED ARTICLE

### Generative code as a target dependency

Any file can be a dependency to a Make task, including the files doing the
processing. For example, consider the example Makefile target:

    output.txt: bin/analyse input.txt
        $^ > $@

The target is a file called **output.txt** which requires two dependencies:
**bin/analyse** and **input.txt**. The executed code however uses two Makefile
macros. Macros can be used to simplify writing Makefiles. In this case **$^**
expands to the list of dependencies and **$@** expands to the target file. This
therefore is similar to writing:

    output.txt: bin/analyse input.txt
       bin/analyse input.txt > output.txt

The advantage of making `bin/analyse` a target dependency is that whenever this
file is edited this step and any downstream steps will be regenerated when I
call `make` again. This clarifies a critical part of making workflow
reproducible: it is not only when input data changes that a workflow needs to
be rerun, but also any scripts that process or generate data.

### Abstraction of steps

Consider this example with three Makefile targets:

    all: prot00001.txt prot00002.txt prot00003.txt prot00004.txt

    *.txt: ./bin/intensive_operation *.fasta
       $^ > $@

    *.fasta:
        curl http://database.example.com/$@ > $@

TODO: UPDATE WITH THE CORRECT * MACRO

Here the target **all** depending on four files: prot0000[1-4].txt. This target
executes no code but instead insures only that the four dependency files are
generated. Looking through the following lines you can see that there are no
tasks to generate any of these files individually. Instead there are tasks to
generate files based on the filetype extensions: **.txt** or **.fasta**. When
running `make` These wild card operators will be expanded to fill in the
required parts for each dependency. For instance the following steps would be
executed to generate **prot00001.txt**.

    prot00001.txt: ./bin/intensive_operation prot00001.fasta
        ./bin/intensive_operation prot00001.fasta > prot00001.txt

    prot00001.fasta:
        curl http://database.example.com/prot00001.fasta > prot00001.fasta

This wild card \* format allows the process to be abstracted out independently
of the individual generated files. This makes it much simpler to change the
data analysed whilst still maintaining the same workflow. Concretely, this
means you can specify additional files to be generate in the *all* task without
changing the rest of the workflow. Idiomatically, I should use a variable named
**objects** to specify the output I am interested in.

    objects = prot00001.txt prot00002.txt prot00003.txt prot00004.txt

    all: $(objects)

    *.txt: ./bin/intensive_operation *.fasta
       $^ > $@

    *.fasta:
        curl http://database.example.com/$@ > $@

You could go even further than this however and move the list of target files
to a separate file and read their names in as a dependency. This would mean you
would only change the Makefile when making changes to your workflow, thereby
isolating changes between the workflow process and the workflow output to
different files in the revision control history.

### Very simple parallelisation

Bigger data sets required more time to process and taking advantage of
multi-core processors is a cheap way to reduce this. Given the Makefile I
outlined in the previous section I can invoke `make` as follows.

  `make -j 4`

As I defined the steps using the file type \* syntax Make understands that each
step can be run independently. Therefore a separate process is used to generate
each of the required files. If the number of files required to be generated
exceeds the number of processes specified  `-j` then these will begin after
previous targets have finished. This is a very cheap method to add multi-core
parallelisation to a workflow, as long as you can abstract out the workflow
processes to fit this.
