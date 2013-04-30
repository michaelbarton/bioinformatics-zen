---
  kind: article
  feed: true
  title: How accurate is marker based sequencing?
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

  * Remove barcodes from reads and trim down to 200bp.
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

## Read fidelity in Quince et. al XXXX data

Read fidelity might be considered as a true/false value. Either a read is
correct or it contains errors such as an insertion, substitution or deletion.
Consider the following scenario: a read 250bp read with a homopolymer error at
base 196. If I compare this read with the community sequence from which it
originated then I will identify this read as inaccurate. Now if I trim this
read to 195bp and repeat this I will identify the read as accurate. Therefore
read accuracy is function of which portions of the read you choose to compare
and as read quality decreases towards the 3' end it is convieniet to trim the
3' to increase read accuracy.

I determined read fidelity by comparing all community sequences to each read to
determine if any were a subsequence. I did this in steps of 10bp. Given
community sequence **A** which is 200bp in length I compare this sequence to a
read to determine if **A** is a substring of the read. If not, then I reduce
the mock-community sequence by 10bp from the 3' end (now 190bp) and repeat the
process. I do this for each community sequence against each read until the
first match or until there were no more community sequences to compare. To
emphasise: this process only shows a positive if the generated read exactly
matches a subsequence of the community sequence from the 5' end. The
distribution of matches is as follows:

<%= lightbox(amzn('read-analysis/002-read-fidelity/SRR013437.read_fidelity.png'),
amzn('read-analysis/002-read-fidelity/thumb.SRR013437.read_fidelity.png'),
"Number of correct reads vs read length.") %>

This figure shows that many reads are accurate at ~240bp with a density of
accurate reads towards the cutoff at 50bp. The figure also shows that the
highest density of reads is <6%. This means that the majority of reads ~90% are
inaccurate when comparing 5' substrings of the mock-community sequences. I also
examined the distrution of reads for each mock community sequence.

<%= lightbox(amzn('read-analysis/002-read-fidelity/SRR013437.community_fidelity.png'),
amzn('read-analysis/002-read-fidelity/thumb.SRR013437.community_fidelity.png'),
"Number of correct reads for each community sequence.") %>

This figure highlights a large variance in the number of accurate reads
generated for each community sequences. There are 3 mock community sequences
producing >100 accurate reads, while there are 13 mock community sequences
producing between 1-10 accurate reads. This highlights a large disparity in the
volume and accuracy of generated reads with 3log10 differences in read
generation.

I find these results extraordinary - can there really be such a large disparity
in how reads are generated? These results are generated with a program I wrote
myself so the possiblity that my program contains an error should also be
entertained. There is a relatively straightforward way to test this using a
grep:


<%= highlight %>
fastx_trimmer -l 100 -i SRR013437.community.fasta -o trim100.fasta
grep --invert-match '>' trim100.fasta \
  | parallel 'grep {} SRR013437.fasta | wc -l' \
  | sort -r
<%= endhighlight %>

This shows the confirms the above results: that a majority of reads are
inaccurate and of the reads that are accurate there is a wide disparity in
volume.
