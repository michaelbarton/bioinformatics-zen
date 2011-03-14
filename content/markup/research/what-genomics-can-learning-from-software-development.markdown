---
  kind: article
  title: Decoupling the steps in a genomics project
  created_at: 2011-3-14 17:00 GMT
---

### Problem

I've spent the last year learning hands-on about next-generation genome
sequencing. I've found that each of the steps in a genome project (assembly,
scaffolding, annotation, analysis of gene content) are tightly coupled to the
the previous step. For example consider an assembled, scaffolded and
subsequently annotated microbial genome. Then you're provided with a 150bp
sequence that closes a gap in the genome. If you use this sequence to close
this gap there's one less hole in the genome sequence. The question then is
what to do about the possible content encoded in this new sequence region. Do
you re-annotate entire genome sequence to identify any new encoded genomic
elements, producing version 1.1 of your genome?

Now consider a new assembly algorithm is published which performs 100% better.
Do you completely reassemble your genome, producing version 2.0, in the hope of
that the new algorithm can resolving troublesome repeat regions? Then do also
repeat the scaffolding and annotation steps based on the new contig sequences?

The pragmatic answer to these question is probably no? Repeating all these
steps would accurately be described as a monumental pain-in-the-ass and a step
backwards in the project. This why genomics projects can be described a lava
flow of data. Each assembly, scaffolding, annotation, and analysis step in the
project "freezes" the last step in place. A new layer of molten data is poured
on top of the previous layer. To update the genome from version 1.0 to 1.1 or
2.0 with new "patch" of sequence in the genome almost requires starting from
scratch an repeating each step.

Now assuming you have an infinite amount of time to go back, re-assemble,
re-scaffold, and re-annotate your genome. How do you compare the newer version
2.0 with the original version 1.0? Should you look at the differences in gene
complement, contrast the nucleotide sequences, both? Most likely you would
examine the differences in the two genome sequences. But then how do you do
this? Pairwise sequence alignment? This is less than ideal because this uses a
probabilistic algorithm to compare two structures that you have essentially
built. We should know the differences between version 1.0 and 2.0 because we've
made both of them!

One final point to consider: imagine you accidentally delete the draft sequence
for genome v2.0. You still have the contigs produced by the assembly software
so therefore all you have to do is join them back together again. This is not
trivial though because some contigs were cut-and-pasted together by hand.
Therefore because some scaffolding steps were performed manually may not be
possible to get back to the exact sequence for v2.0 from the original contigs.

### Scaffolder

I've recently a software tool to simplify the scaffolding step in a genomics
project. Instead of joining contigs together using cut-and-paste the scaffold
is instead specified in a separate file using a [domain specific
language][dsl]. This tool, which I've imaginatively called "Scaffolder," parses
this "scaffold file", and performs the contig edits and joins required to
produce the genome sequence. The scaffold file format looks something like
this.

<%= highlight %>
---
  -
    sequence:
      source: "contig00001"
      reverse: true
  -
    unresolved:
      length: 10
  -
    sequence:
      source: "scaffold00006"
      inserts:
      -
        source: "pcr_sequence_6-1"
        open: 599152
        close: 599817
<%= endhighlight %>

What does this achieve?  First I think this makes determining how the scaffold
is derived is much simpler. You can look at this file and see that sequence
X is used here and sequence Y is used there, et cetera. This much easier to
examine, and of course edit, compared with 7 gigabases of nucleotide sequence.
Technically this decouples the data (contigs) from the manipulation of the data
(joining the contigs into a larger scaffold sequence).

I also think this scaffold syntax makes two different versions of a genome
easier to contrast - you can just use a Unix diff on the two scaffold files.
This highlights when contigs are removed, added, or if their coordinates have
been updated. Compare doing the same thing with a huge block of nucleotide
sequence with a line break every 40 characters.

<%= image('/images/before.png',600) %>

<%= image('/images/after.png',600) %>

The reason I wrote Scaffolder is to make genome scaffolds reproducible and
remove the manual element from joining contigs together. You can write your
scaffold using the Scaffolder syntax and as long as you have the scaffold file
and the set of sequences you can always reproduce it.

If you want to [learn more about Scaffolder check out the website][nextgs].
This has pages for [getting started][started], the [Scaffolder API][api] and
the [Unix manual pages for command line interface][man].

### Almost there

I've written a manuscript more formally describing Scaffolder, which can find a
[pre-print of on Nature Precedings][pre]. I've submitted this manuscript to
[Open Research Computation][orc]. If you haven't already read the [recent blog
posts about ORC][blogs] this journal aims to publish open-source scientific
software with an emphasis on re-use and test-code coverage.

[Cameron Neylon][cameron], the editor-in-chief, has generously agreed to allow
me to try and experiment with the peer review process for the Scaffolder
manuscript. I would like Scaffolder for bioinformatics working building genome
projects and the best way to do this is solicit feedback from the genomics
community. Therefore I've started [a question on BioStar asking how Scaffolder
could be improved][biostar]. This is an experiment in using the web as part of
the peer-review process. Anyone can make a suggestion or critique then upvote,
downvote or comment on other suggestions. These comments will then hopefully
help inform the manuscript reviewers.

[pre]: http://precedings.nature.com/documents/5779/version/1
[orc]: http://www.openresearchcomputation.com/
[blogs]: http://www.google.com/search?q=%22open+research+computation%22&tbm=blg
[biostar]:
[dsl]: http://en.wikipedia.org/wiki/Domain-specific_language
[nextgs]: http://next.gs/
[started]: http://next.gs/getting-started/
[api]: http://rubydoc.info/gems/scaffolder/frames
[man]: http://next.gs/man/
[cameron]: http://cameronneylon.net/
