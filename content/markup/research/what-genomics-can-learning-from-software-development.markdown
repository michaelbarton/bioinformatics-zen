---
  kind: article
  title: The Lava Flow Structure of Genomics Projects
---

### Problem

I've spent the last year doing the hands-on training of a next-generation
genome sequencing project. One of the things I've discovered is that each of
the steps in the project (assembly, scaffolding, annotation, analysis of gene
content) are tightly coupled to the outcome of the previous step. As an example
of this consider an assembled, scaffolded and subsequently annotated microbial
genome. Someone from the laboratory gives you a FASTA file containing a 150bp
sequence that closes a gap in the genome. Supposing you use this sequence to
close the corresponding gap you are improving the genome sequence because
there's one less hole in the data. The question is then what to do about the
possible content encoded in this new sequence region. Do you re-run the
sequence through the annotation software to identify any new encoded genomic
elements? Thereby producing producing version 1.1 of your genome.

Now consider that a new assembly algorithm is published which performs 100%
better based on some metric of genome assembly. Do you completely reassemble
your genome, version 2.0, in the hope of resolving the regions you've been
struggling with? If this is the case then you must also subsequently repeat the
scaffolding and annotation steps as they are all dependent on the originating
nucleotide sequence. The pragmatic answer to this question is no, because
repeating all these steps would be accurately described as a monumental
pain-in-the-ass and a step backwards in the project.

This why genomics projects can be described a lava flow of data. Each assembly,
scaffolding, annotation, and analysis step in the project "freezes" the last
step in place. A new layer of molten data is poured on top of the previous
layer. To move from version 1.0 to 1.1 or 2.0 almost requires starting from
scratch an repeating each step.

Now assuming you have an infinite amount of time to go back, re-assemble your
genomes sequence. How do you compare this new version 2.0 with the original
version 1.0 to determine how the new assembly algorithm has fared? Should you
look at the new the gene complement derived from the new sequence? Should you
compare the differences in the nucleotide sequences? Most likely you would
compare the two nucleotide sequences. But then how do you do this? Pairwise
sequence alignment? This is less than ideal because you now using an
probabilistic algorithm to compare two structures that you have essentially
built. We should know the differences between version 1.0 and 2.0 because we've
made both of them!

Finally consider you accidentally delete the scaffolded sequence for genome v2.0.
This shouldn't be a problem you still have the assembled contigs therefore all
you have to do is join them back together again. Probably not though because
some contigs were cut-and-pasted together manually in a text editor. These
steps can't easily be repeated we they were performed by hand so we can't get
back to exactly where we were before.

### One possible solution

I haven't written this post as rant on the state of genomics. That would be
rather critical and counter-productive. No the reality is much worse, I've
outlined some of the current problems in genomics field so I can start blowing
my own trumpet about on how I have all the solutions.

Well, perhaps not all of the answers, but one at least.

I written a piece of software to simplify the scaffolding step in a genomics
project. Instead of scaffolding contigs together by cutting-and-pasting in
a text editor you write a separate file using a domain specific language
describing how the is made. This software, which I've imaginatively called
"Scaffolder," parses this instruction file, then edits and joins the together
as required to produce the final output sequence. The format of this "scaffold
file" looks something like this.

INSERT EXAMPLE SCAFFOLD FILE SYNTAX

What does this achieve?  First I think this makes determining how the scaffold
is derived is much simpler. You can look at this file and see that sequence
X is used here and sequence Y is used there, et cetera. This much easier to
examine, and of course edit, compared with looking at 7 gigabases of
nucleotides. Getting technical this effectively decouples the data (contigs)
from the manipulation of the data (joining the contigs into a larger scaffold
sequence).

I also think this scaffold syntax makes two genome builds easier to compare.
You can just diff the two scaffold files the differences between the
constructions. You can see when sequences are removed or added, or if their
coordinates have been updated. Compare doing the same thing with a huge block
of nucleotides with a line break every 40 characters.

INSERT EXAMPLE SCAFFOLD DIFF

The second point which I think makes Scaffolder useful is reproducibility. As
long as you have the scaffold file and the set of sequences you can always
reproduce the same genome sequence.

### Almost there

I've written a manuscript more formally describing what scaffolder is and what
it does. You can find a [pre-print of the Scaffolder manuscript at Nature
Preceedings][pre] and I've recently submitted this manuscript to [Open Research
Computation][orc]. If you haven't already read the [recent blog posts about
ORC][blogs] this journal aims to publish articles about open-source scientific
software with an emphasis on re-use and test-code coverage.

Cameron Neylon, the editor-in-chief, has generously agreed to allow me to try
and experiment in the peer review process with the Scaffolder manuscript. I've
started a question on BioStar asking for community input on how Scaffolder
could be improved Scaffolder. This is essentially an experiment in open
peer-review where anyone can make a suggestion and upvote, downvote or comment
on other suggestions. The reviewers of the manuscript will be able to see this
and this will feed directly into peer-review process.

[pre]:

[orc]:

[blogs]: http://www.google.com/search?q=%22open+research+computation%22&tbm=blg

[biostar]:
