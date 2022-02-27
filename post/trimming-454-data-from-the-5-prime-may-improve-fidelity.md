---
tags: post
feed: false
title: Trimming 454 reads at the 5' end may improve fidelity
date: 2013-05-13
---

A previous post described [training machine learning classifiers][previous] to
filter inaccurate reads in 16S-based metagenomic studies. This analysis was
based on available mock community data - where an known set of 16S genes is
sequenced and the generated reads compared to the original sequences. The value
of using a mock community is that knowing the original sequences allows you to
identify the types of errors you are observing in the output data. The method I
previously used to find the accurate reads using the mock community data was as
follows:

1. Remove barcodes and primers from reads and trim down to 200bp.
2. Select the unique representative reads and count how many times each
   unique read is observed in the data.
3. Build an alignment from **N**\*2 of the most abundant unique reads. **N**
   is the number of sequences used in the mock community data.
4. Use [single linkage clustering][clust] to group the aligned unique reads
   to within 4bp differences of each other. This merges the unique read that
   matches to with 4bp of another unique read into the more abundant read
   group.

The result of this method should be **N** unique reads in the output data and
each unique read should then correspond to one of the mock community sequences.
This approach assumes that after removing up to 4 single base errors and
indels, the remaining most abundant unique read for each mock community
sequence should be the correct one. This assumption can be described another
way: any novel sequences generated from infidelity in the PCR or sequencing
steps should not produce more copies than that of the original correct
sequence.

I built this workflow with a combination of mothur and shell scripting. There
is a gist on github illustrating this [method of identifying correct reads based
on abundance][gist].

[previous]: /post/machine-learning-to-detect-bad-sequencing-reads/
[clust]: http://www.ncbi.nlm.nih.gov/pubmed/20236171
[gist]: https://gist.github.com/michaelbarton/5490636

This approach bothered me because it does not actually compare the reads that I
specify as correct against the original mock community. Therefore before
pursing further machine learning approaches I aimed to first confirm the reads
identified as accurate exactly match the mock community sequences.

## Read fidelity in Quince et. al 2009 data

I used a simple approach to identify accurate reads in the 454 data: trim each
mock community sequence to a 100bp substring and see how many reads contained
this substring. I started with the divergent mock community data from [Quince
_et. al_ 2009][quince]. This is the same data I used for machine learning
approach to filtering inaccurate reads. I trimmed the community sequences to
100bp beginning at 5' end and searched the generated read data for exact
matching substrings using `grep`. The following code illustrates this approach
with the resulting number of matches.

[quince]: http://www.ncbi.nlm.nih.gov/pubmed/19668203

```bash
fastx_trimmer -l 100 -i SRX002564.community.tab -o trim100.fasta

grep --invert-match '>' trim100.fasta \
  | sort | uniq \
  | parallel 'grep {} SRX002564.fasta | wc -l' \
  | sort -r -n \
  | tr "\\n" " "

#=> 1609 1543 1024 14 5 5 4 4 3 3 2 2 2 2 1 1 0 0 0 0 0 0 0
```

This shows a large variance in the number of reads matching a mock community
sequence substring. There are 3 with &gt;1000 matching reads while the
remainder of match &lt;20 reads. I double-checked this result by examining a
couple of the community sequence reads individually. This is illustrated below
where the community sequence is shown in the top row and generated reads after
removal of the primer are shown in the rows below.

```
>8                      CTA-ACGATGA-TACTCGAT
>SRR013437.14   tccacacc...A.......A........
>SRR013437.627  tccacacc...A.......A........
>SRR013437.935  tccacgcc...G.......A........
>SRR013437.2322 tcctcgcc...A.......A........
>SRR013437.2423 cccacgcc...A.......A........

>72                  GCCGTAA-CGATGAGAACTAGCC
>SRR013437.245  tccac.......A...............
>SRR013437.351  tccac.......A...............
>SRR013437.433  tccac.......A...............
>SRR013437.542  tccac.......A...............
>SRR013437.661  tccac.......A...............
```

This highlights that, for two of these mock community sequences, there appear
to be insertions in the 5' ends of the most abundant reads. These differences
prevent exact substring matches to the mock community sequence. I considered if
this was the case for the for further downstream sequence by repeating this
process with a 100bp substring 50bp downstream from the 5' end.

```bash
fastx_trimmer -f 50 -l 150 \
  -i SRX002564.community.tab \
  -o trim50_150.fasta

grep --invert-match '>' trim50_150.fasta \
  | sort | uniq \
  | parallel 'grep {} SRX002564.fasta | wc -l' \
  | sort -r -n \
  | tr "\\n" " "

#=> 2273 2229 1943 1873 1802 1795 1774 1701 1692 1677 1670
#   1628 1596 1573 1545 1522 1446 1442 1399 1356 935 635 548
```

This shows that using a substring 50bp further downstream finds a larger number
of exact matches in the reads. The following figure compares the difference in
the substring matches. The figure is on a logarithmic scale.

{% include 'image.njk',
  url: 'http://s3.amazonaws.com/bioinformatics-zen/read-analysis/002-read-fidelity/SRX002564.fidelity.png',
  alt: 'Number of correct reads vs read length.' %}

## Read fidelity in the Human Microbiome Pilot Study

This examined only a single 454 run and one which was generated in 2009. I
therefore considered further additional data determine if I observed this
result again. The human microbiome project (HMP) has [a pilot study][pilot]
which compares a single mock community with the output from several different
sequencing centres. I repeated the above analysis with 9[^runs] from 19 of
these sequencing experiments. I used a sample of 9 experiments to reduce
overall analysis time.

[pilot]: http://www.ncbi.nlm.nih.gov/bioproject/48341

The major difference with analysing these data is that there is no specific set
of mock community sequences. The HMP instead used three pairs of primers to
create amplicons from 22 genomes[^genomes]. I therefore created the 16S
mock community[^mock] by simulating PCR _in silico_ using the primers and
corresponding genomes. I then tested the HMP generated reads against this
mock community using the same approach as before. The following figure compares
the distribution of matching reads for the different substrings of the
mock community.

{% include 'image.njk',
  url: 'http://s3.amazonaws.com/bioinformatics-zen/read-analysis/002-read-fidelity/SRP002397.fidelity.png',
  alt: 'Number of correct reads vs read length.' %}

This figure is harder to interpret because the two distributions overlap. There
is less of a clear difference as to whether 5' trimming results in a greater
number of matches to the community substring. The following figure instead
compares the difference in total number of matching reads for 5' trimming
versus no trimming. A larger value equates to a greater the number of
substring-matching reads for the 5' trimmed sequence versus the untrimmed
sequence.

{% include 'image.njk',
  url: 'http://s3.amazonaws.com/bioinformatics-zen/read-analysis/002-read-fidelity/SRP002397.difference.png',
  alt: 'Number of correct reads vs read length.' %}

This figure shows that for two experiments 5' trimming resulted in less matches
to the community substring. In one of these cases this resulted in &gt;3000
fewer matching reads. In seven of nine experiments however 5' trimming of the
mock community sequence increased the number of matching reads. In two cases 5'
trimming produced an improvement of &gt;5000 exact substring matches.

## Summary

The use of 3' trimming in marker-based metagenomics is common. I am not
familiar with any articles showing that 5' trimming may improve read-fidelity
however. I would be interested if anyone can highlight similar approaches. I
think it may also be work considering if this 5' trimming could be related to
chimerism.

Trimming the 5' end should not however be used in every case without prior
consideration. Instead I believe a quality-control mock community should be
added to each sequencing run to assess whether this is necessary. This way both
5' and 3' trimming could be tuned to each specific sequencing run. A similar
point is argued in Schloss _et. al_ 2011:

> We have shown that even when sequencing centers follow the same procedures
> there is variation between and more importantly, within centers. The
> inclusion of a mock community sample on each sequencing run can be used to
> calculate the rate of chimerism, sequencing error rate, and drift in the
> representation of a community structure.
>
> --- **Patrick D. Schloss mail, Dirk Gevers, Sarah L. Westcott**. Reducing the
> Effects of PCR Amplification and Sequencing Artifacts on 16S rRNA-Based
> Studies. [PLoS One][schloss].

[schloss]: http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0027310

If machine learning approaches are to be used to filter incorrect reads then
the training data must be as accurate as possible. This means that every effort
should be made to correctly label the accurate reads in the training data.
Therefore I believe a constructing a machine learning filter may require the
optimisation of two factors: how much of each read needs to be trimmed and how
accurately the remaining reads can be accurately filtered for inaccuracy. This
would balance read length for phylogenetic analysis against how may errors in
the generated reads can be tolerated.

## Footnotes

[^runs]: I used the HMP experiments: SRX020136 SRX020134 SRX020131 SRX020130 SRX020128 SRX019987 SRX019986 SRX019985 SRX019984. Each of these experiments contained 9 individual runs each making for a total of 81 454 GS FLX runs.
[^genomes]: The accessions for the genomes used in the HMP pilot study are: AE017194 DS264586 NC_000913 NC_000915 NC_001263 NC_002516 NC_003028 NC_003112 NC_003210 NC_004116 NC_004350 NC_004461 NC_004668 NC_006085 NC_007493 NC_007494 NC_007793 NC_008530 NC_009085 NC_009515 NC_009614 NC_009617.
[^mock]: The HMP 16S mock community was created by simulating PCR amplification on the genome sequences using [primer search](http://emboss.bioinformatics.nl/cgi-bin/emboss/primersearch) and allowing up to a 20% mismatch against the primer sequence. Amplicons greater than 2000bp were discarded. The primer sequences were trimmed from the simulated amplicons except those with more than 2bp differences which were instead discarded.
