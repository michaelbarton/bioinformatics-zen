--- 
kind: article
title: Organising yourself as a dry lab scientist
category: misc
created_at: 2007-02-16 18:17:38
---
Browsing <a href="http://wikiomics.org/">wikiomics</a>, I found this <a href="http://wikiomics.org/wiki/Bioinfo_tutorial#Before_you_start">small section</a> on keeping organised as a practising bioinformatician. In particular these lines contain gems of information.
<ul>
	<li> Use text files/plain e-mail whenever possible</li>
	<li> Give meaningful names to your files</li>
	<li> Create separate folders/directories for each project with meaningful names</li>
</ul>
I find keeping my work organised one of the most frustrating but necessary tasks of being a bioinformatician. Also this subject seems to recieve little attention in the bioinformatics community.

Wet scientists are expected to keep laboratory books. Where not doing so considered very bad practice. I am jealous when I see these books filled with pictures of gels and printed tables of results. I've tried using a lab book, but I didn't find it applicable for the many different types of scripts and results I was producing.

Here are some tips I find useful for organising myself.

<!--more-->

I couldn't agree more with the above tips. Give directories and files the most verbose names as possible. This helps when trying to find a specific file. Being verbose as possible in naming your files is useful because often sets of files are all related to a similar subject. Take the following example.
<ul>
	<li>ancova_sequence_hydrophobicity.R</li>
	<li>ancova_sequence_hydrophobicity_interaction_term.R</li>
	<li>ancova_sequence_hydrophobicity_residuals.R</li>
</ul>
All three files contain a script fitting an ancova model, but all differ slighty in focusing on different parts of the model. Finding the one you need is still simple for you, but perhaps not so in a few months time when you return to the results to write a paper.

Consider this example
<ul>
	<li>ancova_sequence_hydrophobicity.R</li>
	<li>ancova_sequence_hydrophobicity.csv</li>
	<li>ancova_sequence_hydrophobicity.tiff</li>
	<li>ancova_sequence_hydrophobicity_interaction_term.R</li>
	<li>ancova_sequence_hydrophobicity_interaction_term.csv</li>
	<li>ancova_sequence_hydrophobicity_interaction_term.tiff</li>
	<li>ancova_sequence_hydrophobicity_residuals.R</li>
	<li>ancova_sequence_hydrophobicity_residuals.csv</li>
	<li>ancova_sequence_hydrophobicity_residuals.tiff</li>
</ul>
Here, there are files for the results of each model (csv) and a plot of the results (tiff). This illustrates how quickly things can expand. Making it more difficult to understand what each file refers to.

Here's one way that this could be organised
<ul>
	<li>1.ancova_sequence_hydrophobicity
<ul>
	<li>scripts
<ul>
	<li>model.R</li>
	<li>model_interaction_term.R</li>
	<li>model_residuals.R</li>
</ul>
</li>
	<li>results
<ul>
	<li>model.csv</li>
	<li>model_interaction_term.csv</li>
	<li>model_residuals.csv</li>
</ul>
</li>
	<li>pictures
<ul>
	<li>model.tiff</li>
	<li>model_interaction_term.tiff</li>
	<li>model_residuals.tiff</li>
</ul>
</li>
</ul>
</li>
</ul>
Each sub directory names describes its contents, which keeps things verbose. Furthermore the directory path contributes to describing each file, e.g. 1.ancova_sequence_hydrophobicity/results/model_residuals.csv. This helpful if you are referencing the file else where and want to know what the file contains.

Since the files are related, they each have an identically named counterpart in the other directories. This is useful for determining which script produced which result.

Finally the top level directory has a number. Often projects and experiments are carried out linearly, one being done after another. Keeping the directories numbered can help to trace the thought process at a later date.

There's an interesting post at <a href="http://lifehacker.com/software/file-storage/geek-to-live-organizing-my-documents-156196.php">LifeHacker</a> about organising file structure. The comments also have a lot of useful ideas too.

There are an infinite number of ways to organise. Probably the best way to do this is to use the system that suits you best. Experiment, you're a scientist.
