---
  kind: article
  feed: true
  title: Machine learning to detect inaccurate NGS reads.
  created_at: "2013-4-12 14:00 GMT"
---

One of the earlier things I learned about next generation sequencing is that
there is more error in the generated data than traditional Sanger sequencing.
These errors might be incorrect base substitution or incorrect estimation of
the length of regions of identical bases (homopolymers). When doing *de novo*
genome assembly or genome resequencing the errors in these reads pose may not
pose a problem as a majority consensus at each position will overrule these
errors.

There are cases where inaccurate reads error do pose a problem such as tag or
marker sequencing. This is the study of a single gene from many different
organisms with the goal of estimating polymorphisms or phylogeny. An example
may be sequencing the same gene (e.g. 16S rRNA) from many different microbes in
the same environment. Another example is sequencing influenza virus genes to
identify the reservoir of strains. In both of these cases the single gene
sequenced multiple times is the 'marker' of interest.

The advantage of this marker approach is that it generates a very large number
of reads to allow surveying a population very deeply. The problem however is
that the sequencing errors I described about can give false positives for
diversity. An extra base or a substitution generates a novel sequence and
therefore a new genotypic signature. Furthermore when amplifying such numbers
of DNA sequence even PCR errors can become relevant too. This can be 'chimeras,
where sequences mis-prime to each other generating a read composed of two
origins. An additional rarer problem is PCR infidelity where base changes are
introduced during the amplification process.

As use of marker-based approaches increases many articles are being published
highlighting the need to identify and remove these poor quality reads. Not
doing so can lead to results biased by a large number of false positives
leading to artefactually inflated diversity. If you are interested in this
literature [my citeulike page has some articles bookmarked][bookmark] related
to this topic.

[bookmark]: http://www.citeulike.org/user/michaelbarton/tag/16s

I'm going to highlight one particular article here: [Reducing the Effects of
PCR Amplification and Sequencing Artefacts on 16S rRNA-Based Studies][article]
by Patrick D. Schloss, Dirk Gevers and Sarah L. Westcott. Part of this article
focuses on identifying incorrect reads based on features of the reads. These
features include the quality of the read, length of the longest homopolymer and
so forth. I highly recommend this paper and it was one of my favourite articles
I read last year. This paper caught my imagination because the authors
considered of the wide range of features to identify inaccurate reads. This
lead me to think that these features could be applied as a machine learning
problem: given a set of labels (0/1 for an inaccurate read) and the set of
features (homopolymer length, read quality, etc) can I predict whether the read
should be discarded?

[article]: http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0027310

### The Data

For this analysis I'll be using the mock community from the [PyroNoise][]
paper. This is an artificial community of 23 sequences that was sequenced to
develop the PyroNoise algorithm. I'm using this data because it is
relatively simple to map the generated reads back to the original sequence.
This thereby makes it straight forward to identify if a generated read is
accurate. The short read archive identifier for this data is SRR013437.

[PyroNoise]: http://www.ncbi.nlm.nih.gov/pubmed/19668203

I preprocessed this data by throwing away reads any shorter than 225bp. This
value is 25bp for the primer and barcode and approximately 200bp of sequence
that can be used for phylogenetic analysis after the barcode and primer are
removed. The 200bp figure is approximate because there may be indels that are
the result of natural mutation rather than sequencing error. The choice of
200bp is arbitrary and different cut-offs may yield different results. I
followed this by removing any reads containing ambiguous bases ('Ns') in the
first 225bp. This preprocessing left 54370 reads to examine.

### The Feature Set

I next needed to generate two groups of data from the processed reads. The
first is the label of whether read is inaccurate and the second is the
descriptive features which could be used to try and predict the label. I
generated a set of features of data. These features represent an attribute for
each point in the data

<%= lightbox(amzn('machine-learning-ngs/SRR013437.dependencies.png'),
amzn('machine-learning-ngs/thumb.SRR013437.dependencies.png'), "Distibution of
features according to read accuracy.") %>


Ensemble with all other approaches - amplicon noise etc. Why not combine to
improve this?

