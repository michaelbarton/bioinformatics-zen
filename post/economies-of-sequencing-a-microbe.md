---
tags: post
feed: false
title: The economics of PacBio sequencing a microbe
date: 2015-11-02
---

This post is a condensed version of a discussion we had in my office after
PacBio announced their new Sequel long-read sequencer. This contains some
hand-wavy statements and calculations, however the aim is to provide some
insight into how we make decisions about sequencing here at the JGI. I wrote
this blog post jointly with Alex Copeland the QC and Assembly group lead, and
Alicia Clum the Genome Assembly and Analysis lead. [Alicia recently joined
twitter][alicia] and you should definitely follow her. She may have mentioned
that she wanted everyone to send her all their genome assembly questions but I
could have misheard her.

[alicia]: https://twitter.com/alicia_clum

The PacBio Sequel specifications indicate ~7x the output per SMRT cell at half
the instrument price of the RSII ($300k vs. $750k). The caveat being that the
individual SMRT cell price will be 2-3X more expensive. [Keith Bradnam has a
round up][keith bradnam] of all the news and blogs discussing the announcement.
The Joint Genome Institute (JGI) will be receiving one of the Sequels in
November as part of the early access program. Therefore we are already in the
process of considering how to integrate the Sequel into our existing pipelines.

[keith bradnam]: http://www.acgt.me/blog/2015/10/1/who-is-saying-what-about-the-new-pacbio-sequel-system

The JGI offers several assembly products for Prokaryotes and Eukaryotes. Each
product is a combination of different DNA extraction, library preparation,
sequencing and informatics post-processing. Our microbial isolate products
relevant to the PacBio announcement and this discussion are:

- **Prokaryotic Minimal Draft** - A cultured Bacteria or Archaea, with a
  typically simple genome. Sequenced as a 2x150bp, 275bp insert fragment
  library on an Illumina 1T HiSeq with 48x pooling. We sequenced 1050 of
  these last fiscal year.

- **Prokaryotic Improved Draft** - Library preparation using AMPure bead
  purification to select fragments greater than 10kbp. Sequenced on the
  PacBio RSII usually requiring only a single SMRT cell. A "better" product
  than the prokaryotic minimal draft because this often produces a single
  contig assembly, this is used for more complex prokaryotic genomes such as
  _Actinomycetes_. We sequenced 250 of these last fiscal year, and expect
  to produce ~500 this year.

- **Eukaryotic Minimal Draft** - A cultured eukaryote, usually fungal.
  Similar to the prokaryotic minimal draft this is sequenced as a 2x150bp,
  275bp insert fragment library on an Illumina 1T HiSeq with 8x pooling.
  Typically we sequence eukaryotes with more tractable genomes, such as
  _Aspergillus_, using this protocol. We sequenced 100 of these in the last
  fiscal year.

- **Eukaryotic Standard Draft** - Two libraries generated and sequenced using
  the ALLPATHS-LG recipe: one standard Illumina fragment, and one 4kb long
  mate pair library. The long mate pairs using ALLPATHS-LG allow us to
  generate a better assembly than the minimal draft. We sequenced ~100 of
  these in the last fiscal year.

- **Eukaryotic Improved Draft** - Same as a prokaryotic improved draft except
  that this is larger eukaryotic genome and requires ~5 SMRT cells for a
  ~40Mbp haploid genome. Extra attention is required in assembly due to the
  presence of organelles. We sequenced less than 10 of these in the last
  fiscal year. For the last few years this product has been a combined
  draft of one Illumina fragment library, one Illumina long mate pair library
  and one PacBio library. This fiscal year we will now switch to a 20kbp
  Blue Pippin library which has higher labour and reagent costs, compared
  with an AMPure PacBio library, but which produces a better assembly.

## Eukaryotic Sequencing

You may notice that there is no 'Prokaryotic Standard Draft' in this list, i.e.
no combined standard fragment and long mate pair sequencing of Prokaryotes. The
reason is that producing the long mate pair library and sequencing on Illumina
costs us about the same as sequencing on the PacBio RSII, while a PacBio 10kbp
library produces a better assembly overall with the same current throughput.

For the same reason this fiscal year we are also discontinuing the Illumina
"Eukaryotic Standard Draft". Recent analysis by Alicia shows that we can also
get better assemblies switching to 10kbp+ PacBio libraries for eukaryotes
rather than continuing with the long mate pair and fragment approach. The extra
costs associated with preparing two different libraries versus a single PacBio
library which also produces a more contiguous assembly means we will do half
our fungal draft sequencing on the PacBio for the next fiscal year.

This then leads into the Sequel announcement - given that we already use ~5
SMRT cells for a eukaryotic genome, switching to the PacBio Sequel will likely
mean that this product type will become even more cost effective. This is
calculated using the announced numbers: ~7X the GBp per SMRT cell at 2-3X the
SMRT cell cost would mean approximately ~2X cost saving.

## Prokaryotic Sequencing

The second point, and the reason to write this blog post, is what effect could
the PacBio Sequel have on our current prokaryotic sequencing? Considering our
existing PacBio prokaryotic sequencing, switching to the Sequel would mean more
data that we do not necessarily require because, in most cases, one SMRT cell
is sufficient to get a complete assembly for the average Bacteria/Archaea.
Using one Sequel SMRT cell would make each prokaryotic assembly 2-3X more
expensive than it already is. Therefore, it is unlikely we would do a straight
switch over to the Sequel for Prokaryotes if cost were the only consideration.
There are however two caveats to this.

The first caveat is that we are currently in the middle of sequencing 1000
_Actinomycetes_ - bacteria that we sequence on the PacBio RSII as prokaryotic
improved drafts. These are high GC, repeat-rich genomes, with especially long
repeats, meaning 2-3 RSII SMRT cells are usually needed to produce sufficient
numbers of reads long enough to span repeats. Therefore in the cases where we
are already using multiple SMRT cells, switching to the Sequel would make sense
for the same cost-saving described above. An added advantage, and worth
mentioning in this context, is that PacBio sequencing displays no GC-bias, so
this is an additional advantage for organisms with very high or low GC genomes.
An example is the JGI recently completed sequencing and assembly of a
_Piromyces_ fungal genome with <20% GC which, for the last decade, has resisted
all previous attempts at sequencing and assembly.

The second caveat is that the increased Sequel capacity makes pooling
important. If you are unfamiliar with pooling, this is the process of combining
multiple different DNA libraries together and then sequencing them all
together, usually in an Illumina flowcell. A unique oligonucleotide 'barcode'
is added to each library during preparation which allows the FASTQ data to be
separated back into the original library after sequencing. If we could take
advantage of the extra Sequel capacity and sequence 7 microbes per SMRT cell
using barcodes, then the same cost savings would apply.

An additional possibility that would streamline laboratory preparation, and
therefore cost, is to skip barcoding entirely. The reason being that the
long-read overlaps are unambiguous enough that the genomes would simply
assemble together out of the pool, similar to that of a metagenome. This would
however require the production planning to ensure that the pairwise genome
distance between any two organisms is large enough to ensure no cross-assembly.
I had a short twitter conversation and this approach with [Mick Watson who
outlined some possible problems][problems].

[problems]: https://twitter.com/bioinformatics/status/650391667741069312

## Why don't we sequence everything on PacBio?

In the process of discussing the Sequel the question arose that we have
considered multiple times in the past: why don't we sequence all microbes on
the PacBio? One reason is that an Illumina prokaryotic minimal draft costs
around 1/10th as much as a PacBio prokaryotic improved draft. Sequencing 1000
microbes on Illumina instead of PacBio RSII is the difference in approximately
$360,000 a year.

This is a pure cost-only comparison and if cost was the only factor, then we
would sequence everything on Illumina 1T using a standard fragment library.
However, assembly quality is extremely important, and is why we don't only do
this. If the costs drop in future with the new PacBio Sequel platform, we will
reevaluate opportunities for applying PacBio to prokaryotic isolate sequencing.
