---
tags: post
feed: false
title: Filtering inaccurate NGS reads using machine learning
date: 2013-04-17
---

One of the earliest things I learned about next generation sequencing is to
expect errors in the generated data. These errors include incorrect base
substitution or incorrect estimation of regions of identical bases
(homopolymers). When doing _de novo_ genome assembly or genome resequencing
these may not pose a problem as a majority consensus at each position can
overrule these errors.

There are cases where inaccurate reads error do however cause a problem such as
tag or marker sequencing. This is the study of a single gene from many
different organisms with the goal of estimating polymorphisms or phylogeny. An
example may be sequencing the same gene (e.g. 16S rRNA) from numerous microbes
in the same environment. Another example is sequencing variations in viral
genes to identify the the source of an epidemic. In both of these cases the
single gene sequenced multiple times is the 'marker' of interest.

The advantage of this marker approach is that it generates a very large number
of reads to allow surveying a population deeply. The problem is that sequencing
errors can give false positives for diversity and variation. An extra base or a
substitution generates a novel sequence and therefore a new genotypic
signature. Furthermore when amplifying large quantities DNA even PCR errors
can become relevant. This can be 'chimeras', where sequences mis-prime to each
other generating a read composed of two origins. An additional rarer problem is
PCR infidelity where base changes are introduced during the amplification
process.

As the use of marker-based approaches increases, many articles are highlighting
the need to identify and remove these poor quality reads. Not doing so can
produce results biased by a large number of false positives leading to
artefactually inflated diversity. If you are interested in the literature on
this topic [my citeulike page has some articles bookmarked][bookmark].

[bookmark]: http://www.citeulike.org/user/michaelbarton/tag/16s

[Amplification and Sequencing Artefacts on 16S rRNA-Based Studies][article] by
Patrick D. Schloss, Dirk Gevers and Sarah L. Westcott. Part of this article
focuses on identifying inaccurate reads based on features of the reads. These
features include the quality of the read, length of the longest homopolymer and
so forth. I highly recommend this paper and it was one of the favourite
articles I read last year. This paper caught my attention because the authors
considered a wide range of features to identify inaccurate reads. This lead me
to think that these features could be applied as a machine learning
classification problem: given a set of labels (1 for an inaccurate 'bad' read,
0 for an accurate 'good' read) and the set of features (homopolymer length,
read quality, etc) can I predict whether the read is bad and should be
discarded?

[article]: http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0027310

## The Data

For this analysis I'll be using the mock community from the [PyroNoise][]
paper. This is an artificial community of 23 sequences that was 454 sequenced.
I'm using this data because it is relatively simple to map the generated reads
back to the original sequence. This thereby makes it straight forward to
identify if a generated read is accurate. The short read archive identifier for
this data is SRR013437.

[pyronoise]: http://www.ncbi.nlm.nih.gov/pubmed/19668203

I preprocessed this data by throwing away reads any shorter than 225bp. This
value is 25bp for the primer and barcode and approximately 200bp of sequence
that can be used for phylogenetic analysis after the barcode and primer are
removed. The 200bp figure is approximate because there may be indels that are
the natural differences between the sequences rather than sequencing error. The
choice of 200bp is arbitrary and different cut-offs may yield different
results. I followed this step by removing any reads containing ambiguous bases
('Ns') in the first 225bp. This preprocessing left 54370 reads to examine.

I generated two groups of data from the processed reads. The first was whether
each read is inaccurate or not. This was resolved by grouping the reads into
clusters based on identity. The top N clusters, where N is the number of
sequences in the original mock community, are those reads which are correct,
every other read was considered inaccurate.

The second data were the descriptive features from which to predict read
accuracy. These data were divided into two groups the first was the longest
homopolymer of each nucleotide type and the second was various quality metrics
for each sequence. I also included original read length too. The distribution
of these features for accurate and inaccurate reads looks as follows.

{% include 'image.njk',
  url: 'http://s3.amazonaws.com/bioinformatics-zen/machine-learning-ngs/SRR013437.dependencies.png',
  alt: Distribution of features according to read accuracy.'' %}

This data does not include all the features in Schloss _et. al_, for instance
barcode and primer errors are not present. I selected only a subset of features
as a starting point for a machine learning algorithm. Further features can be
added in future. Given this feature set and accompanying accuracy labels, the
next step was to create classifiers.

## Classifiers

### Heuristic Classifier

In the Schloss _et. al_ article the authors compared several different
heuristics for filtering and removing reads to improve quality. Two of these
examined if the average quality score of a 50bp sliding window dropped below 35
and if there were homopolymers of any type greater than 8bp. In R this
rule-based classifier might look as follows:

```r
with(data,{
  prediction <- rep(0,length(bad.read))
  prediction[homop_ATGC > 8]     <- 1
  prediction[qual_min_50bp < 35] <- 1

  print.score("heuristic",prediction,bad.read)
})
```

The result of the `print.score` function are the following metrics:

<table>
  <tr>
    <td>Classifier</td>
    <td>Pr(Correct Positive)</td>
    <td>Pr(Correct Negative)</td>
    <td>Matthews Correlation</td>
    <td>Remaining Inaccuracy</td>
  </tr>
  <tr>
    <td>Heuristic</td>
    <td>0.660</td>
    <td>0.663</td>
    <td>0.321</td>
    <td>0.337</td>
  </tr>
</table>

The second and third columns of this table show the probability of when a read
is identified as inaccurate (positive) or accurate (negative) given whether the
read is actually inaccurate or accurate. These are the positive predictive and
negative predictive values. The table shows that approximately 2/3 of reads are
correctly identified in both cases. The Matthews Correlation Coefficient
([Wikipedia][mcc]) shows the overall performance of the classifier with a value
of 1.0 being the correct classification in every case, 0.0 is equivalent to
random classification, and -1.0 is the wrong classification in every case. The
remaining inaccuracy shows how many of the reads are inaccurate after filtering
with the given classifier.

[mcc]: http://en.wikipedia.org/wiki/Matthews_correlation_coefficient

### Regularised Logistic Classifier

The first classifier I trained was a generalised logistic regression
classifier. This uses a link function to map a linear regression to a value
between 0 and 1. This regression can therefore be trained to classify whether
reads are inaccurate or not. As a further step I used the glmnet package to fit
an elastic net generalised logistic regression. This combines both L1 and L2
normalisation to penalise model coefficients with the aim of preventing model
overfitting.

```r
require('glmnet')

x <- as.matrix(data[,!(names(data) %in% c('read','bad.read'))])
y <- data$bad.read

model   <- glmnet(x,y,family=c("binomial"))
lambda  <- cv.glmnet(x,y,family=c("binomial"))$lambda.min
predict <- predict.logit(predict(model, newx=x, s=lambda))

print.score("logistic",predict,y)
```

<table>
  <tr>
    <td>Classifier</td>
    <td>Pr(Correct Positive)</td>
    <td>Pr(Correct Negative)</td>
    <td>Matthews Correlation</td>
    <td>Remaining Inaccuracy</td>
  </tr>
  <tr>
    <td>Logistic</td>
    <td>0.754</td>
    <td>0.656</td>
    <td>0.374</td>
    <td>0.354</td>
  </tr>
  <tr>
    <td>Heuristic</td>
    <td>0.660</td>
    <td>0.663</td>
    <td>0.321</td>
    <td>0.337</td>
  </tr>
</table>

The logistic classifier performs better in correctly identifying inaccurate
reads, almost 10pp (percentage points) better. At the same time there is a
slight decrease in the number of reads incorrectly labelled as accurate: 0.7pp.
This results in a greater remaining error rate in the filtered data: 1.7pp.

One useful consequence of a regression classifier is that the coefficients are
relatively straight forward to interpret. The following figure shows the
regression coefficients of this classifier for decreasing values of the
regularisation coefficient lambda. The graphs are separated into two groups:
the homopolymer coefficients and the quality coefficients. The coefficient for
read length is not shown.

{% include 'image.njk',
  url: 'http://s3.amazonaws.com/bioinformatics-zen/machine-learning-ngs/SRR013437.regress.png',
  alt: 'Value of logistic regression classifier coefficients.' %}

Not too much should be given to the interpretation of this figure as it is the
result of training on only a single data set. This is apparent in the relatively
low value of lambda. The figure does show that the minimum from a 50bp sliding
window is the best predictor based on quality score. This is consistent with
the results seen in Schloss _et. al_, the 10th percentile for minimum quality
score over the length of the read also appears play a role in classification.
Regarding homopolymer length the most important overall features associated
with error appear to be homopolymers of G and C bases.

### Random Forest Classifier

Random forest classifiers are one best performing algorithms in the field of
machine learning. A random forest contains many individual decision trees each
trained with a subset of the data and features. The predicted output is the
modal average of all the forest classifiers.

```r
require('randomForest')

rf <- randomForest(y=factor(data$bad.read),
                   x=data[,!(names(data) %in% c('bad.read','read'))],
                   ntree=500)
predict <- as.numeric(predict(rf)) - 1

print.score("random_forest",predict,data$bad.read)
```

<table>
  <tr>
    <td>Classifier</td>
    <td>Pr(Correct Positive)</td>
    <td>Pr(Correct Negative)</td>
    <td>Matthews Correlation</td>
    <td>Remaining Inaccuracy</td>
  </tr>
  <tr>
    <td>Random forest</td>
    <td>0.833</td>
    <td>0.677</td>
    <td>0.472</td>
    <td>0.323</td>
  </tr>
  <tr>
    <td>Logistic</td>
    <td>0.754</td>
    <td>0.656</td>
    <td>0.374</td>
    <td>0.354</td>
  </tr>
  <tr>
    <td>Heuristic</td>
    <td>0.660</td>
    <td>0.663</td>
    <td>0.321</td>
    <td>0.337</td>
  </tr>
</table>

The random forest performs well in correctly identifying inaccurate reads with
a probability of 0.833 of a read identified as inaccurate actually containing
errors. The probability of correctly identifying accurate reads remains
relatively unchanged. The improvement in the Matthews correlation coefficient
is therefore mainly due to the improvement in accuracy of which bad reads are
identified - fewer correct reads are thrown away.

### Ensemble Classifier

Combinations of machine learning algorithms often perform better than the sum
of the parts. The 'ensemble' approaches may show improved performance when each
of the classifiers models the problem domain with a different structure. For
instance a regression classifier models the problem parametrically and linearly
while a random forest is non-parametric and can find complex interactions.
Combining two different algorithms of this type can, in some cases, combine the
best of both worlds. I therefore created an ensemble classifier based on the
random forest and logistic regression classifiers above. The results of this
are as follows:

```r
require('randomForest')
require('glmnet')

set.seed(1)

x <- as.matrix(data[,!(names(data) %in% c('read','bad.read'))])
y <- data$bad.read

rf <- randomForest(y=factor(y),
                   x=x,
                   ntree=500)
rf.pred <- predict(rf,type='prob')[,2]


glm.model <- glmnet(x,y,family=c("binomial"))
lambda <- cv.glmnet(x,y,family=c("binomial"))$lambda.min
glm.pred <- invlogit(predict(glm.model, newx=x, s=lambda))

weighted.predictions <- function(w,prob.a,prob.b){
  ifelse(((1-w)*prob.a) + (w*prob.b) > 0.5, 1, 0)
}

weight <- seq(0,1,0.01)
scores <- sapply(weight,function(w){
  score(weighted.predictions(w,rf.pred,glm.pred),y)
})

opt.weight <- weight[which(scores == max(scores))]
prediction <- weighted.predictions(opt.weight,rf.pred,glm.pred)

print.score("ensemble",prediction,data$bad.read)
```

<table>
  <tr>
    <td>Classifier</td>
    <td>Pr(Correct Positive)</td>
    <td>Pr(Correct Negative)</td>
    <td>Matthews Correlation</td>
    <td>Remaining Inaccuracy</td>
  </tr>
  <tr>
    <td>Random forest</td>
    <td>0.833</td>
    <td>0.677</td>
    <td>0.472</td>
    <td>0.323</td>
  </tr>
  <tr>
    <td>Ensemble</td>
    <td>0.834</td>
    <td>0.676</td>
    <td>0.472</td>
    <td>0.324</td>
  </tr>
  <tr>
    <td>Logistic</td>
    <td>0.754</td>
    <td>0.656</td>
    <td>0.374</td>
    <td>0.354</td>
  </tr>
  <tr>
    <td>Heuristic</td>
    <td>0.660</td>
    <td>0.663</td>
    <td>0.321</td>
    <td>0.337</td>
  </tr>
</table>

The results of this are approximately the same as that of the random forest
classifier. I can plot the performance of different weights between the random
forest and the logistic regression for comparison. This figure shows clearly
that the logistic classifier adds very little and that weighting mostly towards
the random forest provides the optimum performance. I think this is likely the
result of the random forest overfitting the data and cross validation across
data sets may give more weight to the broader view provided by the logistic
regression.

{% include 'image.njk',
  url: 'http://s3.amazonaws.com/bioinformatics-zen/machine-learning-ngs/SRR013437.ensemble.png',
  alt: 'Performance on ensemble learning model.' %}

## Summary

These current classifiers have not been tested for predictive power only the
degree to which can explain the difference in between good and bad reads in a
single data set. The predictive power should be tested by cross validation
against multiple data from different experiments and sequencing centres. I
would expect the Matthews correlation coefficients for the ML classifiers would
be less than the values shown above because these classifiers have most likely
overfit to this single data set.

As I wrote earlier, only a subset of features have been examined. For instance
errors in the barcode and primer sequence have not been included. The Schloss
_et. al_ paper showed that these are also useful for identifying inaccurate
reads. Therefore I think additional work should include features such as these.
One machine learning approach throws as many features as possible at the
problem and then uses normalisation to identify those with the most predictive
power.

Given all of these caveats, there does appear to be a hard ceiling on the
probability of identifying correct reads. Regardless of which classifier is
used the probability of correctly identifying accurate reads is around 0.66. I
hypothesise that this might be a problem of identifying chimeras - those
sequences that form during the PCR step prior to sequencing. As chimeras are
formed prior to sequencing, it could be considered extremely hard to identify
them based on features associated with sequencing. Tools such as Uchime and
Perseus should be combined in a pipeline to identify chimeras.

The main results of this small analysis appears to be to be the possibility of
an increase in accuracy when identifying inaccurate reads for discarding. This,
very initial, work suggests that using machine learning may be useful for
increasing precision and therefore translate into fewer accurate reads being
thrown away.
