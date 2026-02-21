---
tags: post
feed: false
title: Using helper scripts to make bioinformatics analysis easier to maintain
date: 2008-02-29
---

One of the differences between researching a scientific problem using a computer, and developing software, is the approach to writing code. If youâ€™re producing a bioinformatics application there is more emphasis on generating high quality, flexible code, as this makes future maintenance easier. On the other hand if youâ€™re trying to find the answer to a biological question using a series of scripts, then the focus is on the results, rather than the standard of code. During my work, the number of scripts I have tends to grow quickly, and this leads to problems with maintaining dependencies across scripts. Examples of this can be database connection parameters, or the file system location of a library Iâ€™m calling. This is because the fastest way to get this information into a script, is to cut and paste from an already existing one. However this becomes difficult to manage, when something changes, because I have to go back through all my scripts and update each in turn.

I think a better way to organise these dependencies is to use a helper script which encapsulates the commonality between the other scripts. For example, if Iâ€™m analysing the evolution of gene expression, my directory might look something like this.

- genome_analysis.rb
- transcript_analysis.rb
- protein_analysis.rb
- analysis_helper.rb

As I described the analysis_helper.rb script would contain the common database parameters and library calls, and the other scripts call this helper in their first line. If anything changes I only have to update analysis_helper.rb and the changes are reflected in the other scripts.

This might seem trivial, but the more commonality I extract to the analysis_helper.rb, the more useful it becomes. As a further example, if my expression analysis always begins with a multiple sequence alignment of genes from related species, then this could be extracted into method in the helper script. This then becomes useful when in peer review, a reviewer asks for a more appropriate sequence alignment method. All I have to do is change the method in the helper script, and then the analysis can be repeated without having to edit any of the other scripts.
