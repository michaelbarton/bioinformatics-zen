--- 
kind: article
title: Organising yourself as a dry lab scientist
category: misc
created_at: "2007-02-16 18:17:38"
---

Browsing [wikiomics][1], I found this [small section][2] on keeping organised 
as a practising bioinformatician. In particular, I found these lines very 
interesting:

  * Use text files/plain e-mail whenever possible.
  * Give meaningful names to your files.
  * Create separate folders/directories for each project with meaningful names.

I find keeping my work organised one of the most frustrating but necessary 
tasks of being a bioinformatician. Wet scientists are expected to keep 
laboratory books, and not doing so is considered very bad practice since it 
makes it near impossible for someone else to reproduce the work. I am jealous 
when I see these books filled with pictures of gels and printed tables of 
results.

I've tried previously to use a lab book for keeping track of my work, but I 
didn't find it applicable for the many different types of scripts and results I 
was producing. I think in part this boils down to how little time it takes to 
write a new script versus the time required to put pen to paper to describe 
what you've just done. Therefore below I'm going to outline one possible method 
for organising myself.

First of all use the most verbose names as possible for directories and files. 
This helps when trying to find a specific file. Being verbose as possible in 
naming your files is useful because often sets of files are all related to a 
similar subject. Take the following example:

    ancova\_sequence\_hydrophobicity.R
    ancova\_sequence\_hydrophobicity\_interaction\_term.R
    ancova\_sequence\_hydrophobicity\_residuals.R

All three files contain a script fitting an ancova model, but all differ 
slighty in focusing on different parts of the model. Finding the one you need 
is still simple for you, but perhaps not so in a few months time when you 
return to the results to write a paper:

    ancova\_sequence\_hydrophobicity.R
    ancova\_sequence\_hydrophobicity.csv
    ancova\_sequence\_hydrophobicity.png
    ancova\_sequence\_hydrophobicity\_interaction\_term.R
    ancova\_sequence\_hydrophobicity\_interaction\_term.csv
    ancova\_sequence\_hydrophobicity\_interaction\_term.png
    ancova\_sequence\_hydrophobicity\_residuals.R
    ancova\_sequence\_hydrophobicity\_residuals.csv
    ancova\_sequence\_hydrophobicity\_residuals.png

This time I now have the files for the results of each model (.csv) and a plot 
of these results (.png). This illustrates how quickly the number of files can 
expand. I thinks its also more difficult to understand what each file refers to 
since they all have very similar names.

Here's an alternative way I think these files could instead be organised:

    ancova\_sequence\_hydrophobicity/
      lib/
        generate\_ancova\_model.r
      scripts/
        model.r
        model\_interaction\_term.r
        model\_residuals.r
      results/
        model.csv
        model\_interaction\_term.csv
        model\_residuals.csv
      pictures/
        model.png
        model\_interaction\_term.png
        model\_residuals.png

Each sub directory describes its contents, which satifies the requirement for 
verbose naming. Furthermore the directory path contributes to describing each 
file, e.g. `ancova\_sequence\_hydrophobicity/results/model\_residuals.csv`. 
This is helpful if you are referencing the file else where and want an idea of 
what the file contains.

Since the files are related, they each have an identically named counterpart in 
the other directories. This is useful for determining which script produced 
which result. Furthermore since I have common code I use to generate the ancova 
model I should extract this out into a `lib` directory. This means all the code 
for the model is in one place and therefore easier to edit and maintain.

There are an infinite number of ways to organise to organise your dry projects. 
My example is just one way to do this however and I think any system is better 
than nothing for keeping track of what you've been doing.

[1]: http://wikiomics.org/
[2]: http://openwetware.org/wiki/Wikiomics:Bioinfo_tutorial
