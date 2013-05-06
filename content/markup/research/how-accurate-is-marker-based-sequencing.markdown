---
  kind: article
  feed: true
  title: Generating high fidelity 454 data may require 5' trimming
  created_at: "2013-4-17 17:00 GMT"
---

In a previous post [I trained machine learning classifiers][previous] to
identify inaccurate reads in 16S-based metagenomic studies. This analysis was
based on available mock community data - where an known set of 16S genes is
sequenced and the produced reads are compared to original. The value of this
data is that if you know the original sequences you can identify the types of
errors you are observing in the output data and hence correct for it.

One point bothered me about may analysis: how I identified which reads are
accurate in the output data compared the original mock community data. My
original method for doing this was:

  * Remove barcodes from reads and trim down to 200bp from the 3' end.
  * Select unique reads and count how many times each unique read is observed
    in the data.
  * Build an alignment from the **N** most abundant unique reads. **N** is
    twice the number of sequences used in the mock community.
  * Use [single linkage clustering][clust] to group the aligned unique reads to
    within 4bp differences of each other. This removes the unique reads which
    match to with 4bp of another more abundant unique reads.

The result of this should be the correct reads in the output data. This is
based on the assumption that, after removing upto 4 single base errors and
indels, the most abundant unique read for each mock community sequence should
be the correct one. I built this workflow with a combination of mothur and
shell scripting. There is a gist on github showing this [method of identifying
correct reads based on abundance][gist].

[previous]: /post/machine-learning-to-detect-bad-sequencing-reads/
[clust]: http://www.ncbi.nlm.nih.gov/pubmed/20236171
[gist]: https://gist.github.com/michaelbarton/5490636

After machine learning approaches showed some success I planned to move on to
cross validating against different datasets. One thing bothered me though: this
abundance based approach didn't actually compare the accurate reads against the
original mock community data. So before going any further I decided to first
test the accurate reads against the mock community data to determine fidelity.

## Read fidelity in Quince et. al 2009 data

I determined read fidelity by trimming the community sequences to 100bp from
the 5' end then searching how many of sequenced reads contained this substring.
The advantage of doing the analysis this way is that it is straightforward to
find exact matching substrings using `grep`. Furthermore using the community
sequence to search the sequenced reads removes the possibility of incorrect
trimming of the barcode or primers. I used the divergent sequences and
corresponding 454 dataset from the [Quince *et. al* 2009][quince] analysis. The
following code shows this approach.

[quince]: http://www.ncbi.nlm.nih.gov/pubmed/19668203

<%= highlight %>
fastx_trimmer -l 100 -i SRR013437.community.tab -o trim100.fasta

grep --invert-match '>' trim100.fasta \
  | parallel 'grep {} SRR013437.fasta | wc -l' \
  | sort -r -n \
  | tr "\\n" " "

#=> 1609 1543 1024 14 5 5 4 4 3 3 2 2 2 2 1 1 0 0 0 0 0 0 0 
<%= endhighlight %>

This appears to show a large variance in the number of reads matching a
community sequence substring. There are 3 community sequences with >1000
matching reads while the rest of the community sequences have &lt;20 matching
reads. I found this is somewhat surprising so I double checked what I saw was
true by comparing the individual read and community sequences. The follow
alignments compare two example community sequences (8 and 72) with the most
abundant corresponding unique reads according to nucmer. This highlights errors
in the 5' end of the reads.

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

What happens if instead of using 100bp substrings from the 5' of the
mock=community sequence I drop the first 50bp and repeat the process?

<%= highlight %>
fastx_trimmer -f 50 -l 150 \
  -i SRR013437.community.tab \
  -o trim50_150.fasta

grep --invert-match '>' trim50_150.fasta \
  | parallel 'grep {} SRR013437.fasta | wc -l' \
  | sort -r -n \
  | tr "\\n" " "

#=> 2273 2229 1943 1873 1802 1795 1774 1701 1692 1677 1670
#   1628 1596 1573 1545 1522 1446 1442 1399 1356 935 635 548 
<%= endhighlight %>

<%= lightbox(amzn('read-analysis/002-read-fidelity/SRR013437.fidelity.png'),
amzn('read-analysis/002-read-fidelity/thumb.SRR013437.fidelity.png'), "Number
of correct reads vs read length.") %>

This figure shows the difference trimming the 5' end has on the number of reads
matching the mock-community sequence. This figure is on a log. 10 scale on the
x-axis.

