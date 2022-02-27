---
tags: post
feed: false
title: Experiments in Genome Scaffolding and Peer-Review
date: 2011-03-15
---

### Problem

I've spent the last year learning hands-on about next-generation genome
sequencing. I've found that each step in a genome project (assembly,
scaffolding, annotation, analysis of gene content) is tightly coupled to the
outcome of the previous step. For example consider you've assembled, scaffolded
and subsequently annotated a microbial genome. Call this genome build v1.0.
Subsequently a new assembly algorithm is published which performs 100% better
on a given assembly metric. Do you completely reassemble your genome, producing
genome build v2.0, in the hope of that the new algorithm can resolve
troublesome repeat regions? Do you also then repeat the scaffolding and
annotation steps based on the new contig sequences from the assembly software?

The pragmatic answer to this question is probably no. Repeating all this steps
would accurately be described as a pain-in-the-ass and a step backwards in the
project. The steps in a genomics projects could be described as a lava flow of
data. Each assembly, scaffolding, annotation, and analysis step "freezes" the
last step in place. A new layer of molten data is poured on top of the previous
layer. To create v2.0 using new sequences or algorithms almost requires
starting from scratch and repeating each step. The effort required may mean
that repeating a step is non-trivial.

Assuming you have an infinite amount of time to go back, re-assemble,
re-scaffold, and re-annotate your genome. How do you compare v2.0 with the
original v1.0? Should you look at the differences in gene complement, contrast
the nucleotide sequences, or both? Most likely you would start by examining
the differences in the two genome sequences. But then how do you do this?
Pairwise sequence alignment? This is less than ideal because you're using
a probabilistic algorithm to compare two structures that you have essentially
built. We should know the differences between v1.0 and v2.0 of a genome build
because we've made both of them!

One final point to consider: imagine you accidentally delete the draft
sequence for v2.0. You still have the contigs produced by the assembly software
so you'll have to repeat the process of joining them together into a scaffold.
This, however, is not simple because the contigs may have been cut-and-pasted
together by hand. Since these scaffolding steps were performed manually it may
not be possible to get back to the exact sequence for v2.0 using only the
original contigs.

### Scaffolder

I recently produced a software tool that aims to solve two of these problems.
Instead of cutting-and-pasting contigs together the scaffold is specified in
a separate file using a [domain specific language][dsl]. This tool, [which I've
imaginatively called "Scaffolder,"][nextgs] parses this "scaffold file", and
performs the contig edits and joins required to produce the draft genome build.
An example of this scaffold file looks something like this.

```yaml
---
- sequence:
    source: "contig00001"
    reverse: true
- unresolved:
    length: 10
- sequence:
    source: "scaffold00006"
    inserts:
      - source: "pcr_sequence_6-1"
        open: 599152
        close: 599817
```

What does this achieve? First I think this makes determining how the scaffold
is derived is much simpler. You can look at this file and see that sequence
X is used here and sequence Y is used there, et cetera. This much easier to
examine, and of course edit, contrasted with shifting blocks of text within
7 gigabases of nucleotide sequence. Using a separate scaffold file decouples
the data (contigs) from the manipulation of the data (joining the contigs into
a larger scaffold sequence).

This scaffold syntax makes two different versions of a genome easier to
contrast - you can just use a Unix diff on the two scaffold files. This
highlights when contigs are removed, added, or if their coordinates have been
updated. Compare this with running diff on a huge block of nucleotide sequence
or running a pairwise alignment algorithm.

{% include 'image.njk',
  url: 'http://s3.amazonaws.com/bioinformatics-zen//scaffolder/after.png',
  alt: 'Example a scaffold file diff.' %}

A further reason I wrote Scaffolder is to also make genome scaffolds
reproducible and remove the manual element from joining contigs together. You
can write your scaffold using the Scaffolder syntax and as long as you have
the scaffold file and the set of sequences you can always reproduce it.
Furthermore so can anyone else.

If you want to [learn more about Scaffolder check out the website][nextgs].
The website has pages for [getting started][started], the [Scaffolder
API][api] and the [Unix manual pages for command line interface][man].

### Almost there

We, in [Hazel Barton's laboratory][hazel], have written a manuscript which
more formally describes Scaffolder, and you can find a [pre-print of it on
Nature Precedings][pre]. We've submitted this manuscript to [Open Research
Computation (ORC)][orc] this journal, which if you haven't already read the
[recent blog posts describing it][blogs], aims to publish open-source
scientific software with an emphasis on re-use and test-code coverage.
[Cameron Neylon][cameron], the editor-in-chief at ORC, has generously agreed
to allow me to try and experiment with the peer-review process for the
Scaffolder manuscript.

I would like Scaffolder to be useful for building genome sequence and I think
a way towards this is to solicit feedback from the genomics community.
Therefore I've started [a question on BioStar asking how Scaffolder could be
improved][biostar]. Not only do I hope this will help improve Scaffolder but
can perhaps examine different ways in which the web can be used as part of the
peer-review process. Anyone can make a suggestion or critique then upvote,
downvote and comment on other suggestions. These comments will then hopefully
help inform the manuscript reviewers.

[pre]: http://precedings.nature.com/documents/5779/version/1
[orc]: http://www.openresearchcomputation.com/
[blogs]: http://cameronneylon.net/blog/open-research-computation-an-ordinary-journal-with-extraordinary-aims/
[biostar]: http://biostar.stackexchange.com/questions/6487/what-improvements-would-you-recommend-for-this-genome-scaffolding-software
[dsl]: http://en.wikipedia.org/wiki/Domain-specific_language
[nextgs]: http://next.gs/
[started]: http://next.gs/getting-started/
[api]: http://rubydoc.info/gems/scaffolder/frames
[man]: http://next.gs/man/
[cameron]: http://cameronneylon.net/
[hazel]: http://www.cavescience.com/
