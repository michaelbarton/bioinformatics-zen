---
kind: article
title: Decomplected bioinformatics experiments
---

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

