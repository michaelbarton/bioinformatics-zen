---
tags: post
feed: false
title: "A problem in bioinformatics: we often don't even know what we want."
date: 2020-08-06
---

While I worked at the JGI I spent time trying to answer one of the most
common bioinformatics questions: which software is the best for processing my
data? Whether this data is for genome assembly, annotation, read mapping,
RNA-seq, the list of domains in bioinformatics is endless. I'll argue here that
a significant part of the problem in choosing the bioinformatics software is
not that we don't know which tools are the best, but rather that don't even
know what makes one tool better than another.

For any require analysis biological data, there is rarely any single pass or
fail criteria. Biology doesn't often have the types of problems that are
popular in machine learning, such as "does this image contain a cat or not?"
Instead there are thousands of different metrics than can be measured on a
biological data set. As an example, after sequencing then assembling a genome,
what would it mean for one assembly of the same genome to be better than
another? Should the genome be as contiguous as possible? If that's true and
contiguity is what we care about, how many incorrectly assembly regions can be
tolerated in the pursuit of better contiguity?

Continuing with genome sequencing as an example, the purpose of the assembly
might be to get the parts of the genome that are useful for downstream
analysis. Scientists often want to look at genes and proteins rather than the
genome. So Instead of asking what the quality of the genome sequence looks
like, we can ask what is the quality of the parts of the genome we're most
interested in. If all the protein-coding regions assembled are as "correct" as
possible would we care if there was less contiguity, such as in the intergenic
regions?

If it would be possible to get a genome assembly with 100% accurate
protein-genes, at the expense of harder to assemble non-coding regions would
that be enough? Of course the answer to this is no, we do care about the whole
of the genome somewhat too. Given that, then what should the ratio of
correctness in coding to non-coding regions be? Perhaps an arbitrary 100:1?

This gets to the crux of the point I want to make. Once we decide what the
criteria we care about are, we have to get into the details of how we measure
them. What do we mean when we say contiguity, do we want to use NG50? What
about misassemblies? Would we measure this by the how many bases are
misassembled or by how independent misassemblies there are. If we require
mostly correct coding regions, would we prefer 95% of the genes are 100%
accurate, or 100% of the genes should be at least 95% accurate. Would we weight
non-coding rRNA genes by these same amounts?

To choose whether one assembler is better than another we have to quantify
these amounts exactly. There is no other choice if we want to critically rank
software. We need a function that produces a quantifiable metric for each
assembly which we can then use to sort all available assembly software. As an
example this could look something like:

- 70% of incorrect bases across all coding genes, divided by the total number
  of bases across all coding genes.

- 10% of the number of incorrect bases in the rRNA genes, divided by the
  total number of bases across rRNA coding genes.

- 10% The fragmentation (NG50) of the genome divided by the length of the
  genome.

- 5% The number of bases in misassembled regions divided by the length of the
  genome.

- 5% The number of misassembly regions divided by the length of the genome.

These are arbitrary numbers pulled out of the air to make a point: adding up
all these single metrics together should return a metric between 0-1 that gets
closer to 1 as the assembly improves along every axes we care about. Even in
the case when one metric increases while another decreases, we would still have
a single loss function we can use for comparing two assemblies to tell if which
one is better than the other by the metrics we care about.

## Summary

Choosing what makes one tool better than another is difficult because we never
know the specifics of what we want ahead of time. Using the example of genome
assembly we know that that we want a good genome that has mostly correct
genomes, good contiguity, and not too many misassemblies or incorrect bases.
The problem with quantitatively comparing two assemblers is that we have to be
very specific about what makes one assembler better than another or there is no
way to determine what is the best tool. Anyone who generates [a ranking of
bioinformatics software][ranking] to determine which is better than another,
has to have made these kinds of trade-offs around which metrics are most
important.

[ranking]: /post/automating-selection-of-genome-assembly-software/

In closing, every kind of quality metric you could use to compare two different
bioinformatics tools is only a single axes from a large pool of possible metrics
in which efficacy can be measured. To make a meaningful decision about we have
to get much more specific about the metrics that matter, and make one output
better than another.
