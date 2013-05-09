---
  kind: article
  feed: true
  title: Generating high fidelity 454 data may require 5' trimming
  created_at: "2013-5-08 17:00 GMT"
---

In a previous post [I trained machine learning classifiers][previous] to
identify inaccurate reads in 16S-based metagenomic studies. This analysis was
based on available mock community data - where an known set of 16S genes is
sequenced and the generated reads compared to original sequences. The value of
this data is that if you know the original sequences you can identify the types
of errors you are observing in the output data and hence correct for it.

One point the troubled me however was the method I used to identify which of
the generated 454 reads are accurate. The approach I used for this was as
follows:

  * Remove barcodes from reads and trim down to 200bp with the first base
    beginning after the end of the 5' primer.
  * Select the unique representative reads and count how many times each unique
    read is observed in the data.
  * Build an alignment from the **N** most abundant unique reads. **N** is
    twice the number of sequences used in the mock-community data.
  * Use [single linkage clustering][clust] to group the aligned unique reads to
    within 4bp differences of each other. This merges reads which match to with
    4bp of another more abundant reads into the same group.

The result of this method should be **N** unique reads in the output data and
each corresponding to one of the mock-community sequences. This approach
assumes that after removing up to 4 single base errors and indels, the
remaining most abundant unique read for each mock community sequence should be
the correct one. This assumption can be described another way: any errors
resulting from PCR infidelity or 454 errors that result generate a new read
sequence will not produce more copies than that of the original correct
sequence.

I built this workflow with a combination of mothur and shell scripting. There
is a gist on github illustrating this [method of identifying correct reads based
on abundance][gist].

[previous]: /post/machine-learning-to-detect-bad-sequencing-reads/
[clust]: http://www.ncbi.nlm.nih.gov/pubmed/20236171
[gist]: https://gist.github.com/michaelbarton/5490636

The point that bothered me this approach is that it does actually compare the
reads against the original mock community to test that the sequences are
identical. Therefore before pursing further machine learning approaches I aimed
to first confirm the reads identified as accurate reads actually match the
mock-community sequences.

## Read fidelity in Quince et. al 2009 data

I used a simple approach to identify accurate: trim the community sequence to a
short substring and see how many reads contained this exacted substring. I
started with the divergent mock-community data from [Quince *et. al*
2009][quince]. This is the same data I used for machine learning filtering of
inaccurate reads. I trimmed the community sequences to 100bp beginning at 5'
end and searched the generated read data for exact matching substrings using
`grep`. The following code illustrates this approach and the number of matches.

[quince]: http://www.ncbi.nlm.nih.gov/pubmed/19668203

<%= highlight %>
fastx_trimmer -l 100 -i SRX002564.community.tab -o trim100.fasta

grep --invert-match '>' trim100.fasta \
  | sort | uniq \
  | parallel 'grep {} SRX002564.fasta | wc -l' \
  | sort -r -n \
  | tr "\\n" " "

#=> 1609 1543 1024 14 5 5 4 4 3 3 2 2 2 2 1 1 0 0 0 0 0 0 0 
<%= endhighlight %>

This shows a large variance in the number of reads matching a community
sequence substring. There are 3 with &gt;1000 matching reads while the
remainder of community substring match &lt;20 reads. I found this result
surprising so I double checked by comparing a couple of the community sequence
the corresponding most abundant generated reads. The community sequence is
shown in the top row and generated reads after removal of primer are shown in
the rows below.

<%= highlight %>
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
<%= endhighlight %>

This highlights that for two of the divergent mock-community sequences
instances there are errors near the 5' of the most abundant reads. These errors
therefore prevent exact substring matches to the mock-community sequence. I
considered if this was the case for the entire sequence or just the 5' region.
I therefore repeated this process but selecting a 100bp substring that was 50bp
downstream from the 5' end.

<%= highlight %>
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
<%= endhighlight %>

This shows that using a substring with the first 50bp from 5' end removed find
a larger number of exact matching reads. The following figure compares the
differences in exact matches to a mock-community sequence substring. The figure
is on a logarithmic scale.

<%= lightbox(amzn('read-analysis/002-read-fidelity/SRX002564.fidelity.png'),
amzn('read-analysis/002-read-fidelity/thumb.SRX002564.fidelity.png'), "Number
of correct reads vs read length.") %>

## Read fidelity in the Human Microbiome Pilot Study

This analysis is only based on a single 454 run and so this may only be a
single phenomenon. In addition was generated in 2009 and so further instrument
improvements may remove this possible effect. I therefore considered further
additional data determine if this effect was consistent.

The human microbiome project (HMP) has [a pilot study][pilot] which compares a
single mock community with the output from several different sequencing
centres. I repeated the above analysis with 9[^runs] of the 19 sequencing
experiments. I chose a sample of 9 experiments to reduce overall analysis time.

[pilot]: http://www.ncbi.nlm.nih.gov/bioproject/48341

The major difference with analysing these data is that there is no specific set
of mock community sequences. The HMP instead used three pairs of primers to
create amplicons from 22 genomes[^genomes]. I therefore created the 16S
mock-community[^mock] by simulating PCR *in silico* using the primers and
corresponding genomes. I then tested the HMP generated reads against this
mock-community using the same approach as before. The following figure compares
the distribution of matching reads for the different substrings of the
mock-community.

<%= lightbox(amzn('read-analysis/002-read-fidelity/SRP002397.fidelity.png'),
amzn('read-analysis/002-read-fidelity/thumb.SRP002397.fidelity.png'), "Number
of correct reads vs read length.") %>

This figure is harder to interpret because the two distributions overlap. There
is less of a clear difference as to whether 5' trimming improves read fidelity.
The following figure instead compares the difference in matching reads for 5'
trimming versus no trimming. The larger the value the greater the number of
substring-matching reads for the 5' trimmed sequences versus the untrimmed
community sequences.

<%= lightbox(amzn('read-analysis/002-read-fidelity/SRP002397.difference.png'),
amzn('read-analysis/002-read-fidelity/thumb.SRP002397.difference.png'), "Number
of correct reads vs read length.") %>

This figure shows that for two of the nine sample experiments 5' trimming
resulted in less matching sequences. Alternatively in seven of nine experiments
5' trimming of the community sequence increased the number of matching reads.

## Summary

If machine learning algorithms are to be used to classify and filter incorrect
reads then the training data must be as accurate as possible. This means that
every effort should be made to correctly label the accurate reads in the
training data. The use of 3' trimming is common to remove errors as the
probability of errors is associated with position in the generated read. I have
not found any articles suggesting that 5' trimming may improve read-fidelity so
I would be interested if anyone can highlight similar findings.

Either way this 5' trimming may not be useful in every case as the above figure
showed. Instead by sending a mock-community with marker-based sequencing run
the length of both 5' and 3' trimming could be tuned to each specific
sequencing run. Furthermore I believe a machine learning approach may require
the optimisation of two factors: how much of each read needs to be trimmed and
how accurately the remaining reads can be accurately filtered for inaccuracy.

## Footnotes

[^runs]: I used the HMP experiments: SRX020136 SRX020134 SRX020131 SRX020130 SRX020128 SRX019987 SRX019986 SRX019985 SRX019984. Each of these experiments contained 9 individual runs each making for a total of 81 454 GS FLX runs.

[^genomes]: The accesions for the genomes used in the HMP pilot study are: AE017194 DS264586 NC_000913 NC_000915 NC_001263 NC_002516 NC_003028 NC_003112 NC_003210 NC_004116 NC_004350 NC_004461 NC_004668 NC_006085 NC_007493 NC_007494 NC_007793 NC_008530 NC_009085 NC_009515 NC_009614 NC_009617

[^mock]: The HMP 16S mock community was created by simulating PCR amplification on the genome sequences using [primer search](http://emboss.sourceforge.net/apps/release/6.1/emboss/apps/primersearch.html) and allowing up to a 20% mismatch against the primer sequence. Amplicons greater were allowed up to 2000bp. The aim of this was to consider as many of the possible amplicons as possible. The primer sequences were subsequently removed from the amplicons with up 2bp differences allowed.

