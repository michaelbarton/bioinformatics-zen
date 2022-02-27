---
tags: post
feed: false
title: Deriving meaning from principal components analysis
date: 2007-08-01
---

I'm going to illustrate how you can use principal components analysis to find
underlying trends in your data. If you want to reproduce what I'm doing, I've
put [the R code on github][code]. I'm using an example dataset to illustrate
how PCA can be used. This data contains five different morphological
measurements from 200 crabs. These measurements are:

[code]: https://gist.github.com/3969797#file_pca.r

- <code>**FL**</code> - Frontal lobe size
- <code>**RW**</code> - Rear width
- <code>**CL**</code> - Carapace length
- <code>**CW**</code> - Carapace width
- <code>**BD**</code> - Body depth

The first rows of these data can be seen as follows:

```r
R> library(MASS)
R> data(crabs)
R> head(crabs)

  sp sex index   FL  RW   CL   CW  BD
1  B   M     1  8.1 6.7 16.1 19.0 7.0
2  B   M     2  8.8 7.7 18.1 20.8 7.4
3  B   M     3  9.2 7.8 19.0 22.4 7.7
4  B   M     4  9.6 7.9 20.1 23.1 8.2
5  B   M     5  9.8 8.0 20.3 23.0 8.2
6  B   M     6 10.8 9.0 23.0 26.5 9.8
```

Each row contains the species of the crab (Blue/Orange), the crab sex
(Male/Female), the row index and the five measured morphological
characteristics in millimetres.

I'm going to outline how you might apply PCA to analysing multivariate data
such as this. If you are interested in learning how PCA is calculated there is a
[video by Andrew Ng][video]. In addition [the machine learning course at
coursera][coursera] also covers the application of PCA.

[video]: http://youtu.be/ey2PE5xi9-A?t=37m20s
[coursera]: https://www.coursera.org/course/ml

PCA describes the underlying structure of your data where component relates to
variation. The first component describes the greatest degree of variation in
the data, the second component the next largest component and so forth.
Furthermore each component describes variation orthogonal to previous
components. This may sound esoteric, PCA is however very useful for exploratory
data analysis without understanding the algorithm itself. If you begin using
PCA regularly, taking the time to understand the algorithm will however help
you understand the results of using it.

I'll begin by using R to calculate the PCA on the crab data. I'll then attach
the first three components to the original crab data so that they can be
compared.

```r
# Perform PCA on the data
# retx returns the principal component weights for each crab
R> crab.pca <- prcomp(crabs[,4:8],retx=TRUE)

# Append the components for each crab to the original data
R> crabs$PC1 <- crab.pca$x[,1]
R> crabs$PC2 <- crab.pca$x[,2]
R> crabs$PC3 <- crab.pca$x[,3]
R> head(crabs)

    sp  sex index   FL  RW   CL   CW  BD    PC1     PC2      PC3
1 Blue Male     1  8.1 6.7 16.1 19.0 7.0 -26.46 -0.5765 -0.61157
2 Blue Male     2  8.8 7.7 18.1 20.8 7.4 -23.56 -0.3364 -0.23739
3 Blue Male     3  9.2 7.8 19.0 22.4 7.7 -21.74 -0.7119  0.06550
4 Blue Male     4  9.6 7.9 20.1 23.1 8.2 -20.34 -0.8358 -0.21830
5 Blue Male     5  9.8 8.0 20.3 23.0 8.2 -20.21 -0.6955 -0.36252
6 Blue Male     6 10.8 9.0 23.0 26.5 9.8 -15.34 -0.7950 -0.08414
```

The column `PC1`is the first component, and so forth. Each row shows the value
each crab is given in each component e.g. the weight for the first crab in the
first component is -26.46. The weight for the second crab in the second
component is -0.3364. In addition to each of the crabs (observations) having PCA
weights, the variables also have weights. These can be observed in the
`rotations` part of the returned PCA object.

```r
R> head(crab.pca$rotation)
     PC1     PC2     PC3     PC4     PC5
FL   0.2890  0.3233 -0.5072  0.7343  0.1249
RW   0.1973  0.8647  0.4141 -0.1483 -0.1409
CL   0.5994 -0.1982 -0.1753 -0.1436 -0.7417
CW   0.6617 -0.2880  0.4914  0.1256  0.4712
BD   0.2837  0.1598 -0.5469 -0.6344  0.4387
```

A common application for PCA is to discriminate your data into partitions based
on the underlying structure in the data. I can use the components to spread and
separate the data. PCA discriminating components should have both positive and
negative values. If you look at all the value for the first component `PC1` you
will see that they are all negative and suggest there is little discriminatory
power for this component.

Looking to the second component, this have both positive and negative values
and therefore this second component can be used to discriminate the data. To
visualise this effect we'll use the two values furthest apart - the most
negative and the most positive values. In this case it's rear width (RW) 0.87,
and carapace width (CW) -0.29. Plotting these two characteristics we get the
following graph.

<%= image(amzn('/principal_components_analysis/second_component_dotplot.png'),'') %>

Here you can see that data forms a noisy V shape. Imagine that you drew a line
through each arm of the V, you would get two sets of data. Therefore, we might
assume that there are two different distributions of the ratio of carapace to
rear width. We can test this by plotting the density of the crabs according to
this ratio

<%= image(amzn('/principal_components_analysis/second_component_density.png'),'') %>

There are two peaks, with some overlap. So the biological meaning of the second
component is shows up the difference in ratios of rear and carapace widths.
What this means, I'll examine later .

Looking at the third component, again this is discriminating, the most extreme
values are carapace width and body depth. Plotting these, we get this figure.

<%= image(amzn('/principal_components_analysis/third_component_dotplot.png'),'') %>

This time we have two vaguely parallel lines, so again there appears to be
different ratio of the two characteristics. A density plot illustrates the
distribution of this ratio.

<%= image(amzn('/principal_components_analysis/third_component_density.png'),'') %>

Two more overlapping but obvious distributions, so it appears that the third
component highlights a discriminating effect based on the ratio of body depth
to carapace width. As I wrote, PCA can be used to discriminate based on the
underlying trends in the data. I can therefore plot the distribution of crabs
based on these two derived ratios, which produces this figure.

<%= image(amzn('/principal_components_analysis/morphology.png'),'') %>

I coloured the crabs based on their species and used different point types to
further highlight gender. Looking at this plot, I think you can see a
biological relationship from the second and third principal components.

The x-axis, which we derived from the second component, appears to be related
to crab gender, as sex appears roughly separated based on this ratio. The male
crabs seem to have a larger carapace to rear width compared with that of the
female crabs. On the y-axis, the ratio derived from the third component,
appears to separate crab species. The orange crabs have a larger body depth to
their carapace width, compared with their blue counterparts.

So far, I haven't so far plotted the component plots - which is often the first
thing people do after performing PCA. So here they are, the first/second
components.

<%= image(amzn('/principal_components_analysis/first_components.png'),'') %>

And the second and third components.

<%= image(amzn('/principal_components_analysis/second_components.png'),'') %>

You can see that the first and second component plot doesn't discriminate the
crabs very well. This why it is important to also look at the component
weights. The second/third component plot discriminates the data similarly to
the morphology ratios plot, however the axis that would split gender and
species are rotated.

As a small test of how these ratios discriminate the data I created two
generalised linear binomial models to predict either crab species or gender.
Each model was generated one of two ways, the first using simple additive terms
and the second using the additive terms plus the ratio of the terms indicated
by the principal components analysis. I then bootstrapped the crab data 100
times to test how accurately each model predicted either species or gender. The
R code for this is [available on github also][ml].

[ml]: https://gist.github.com/3969797#file-regression-r

<%= image(amzn('/principal_components_analysis/accuracy.png'),'') %>

This plot shows how effectively the models predicted each response variable.
You can see that for species including the ratio had little effect. The model
predicting species however performs slightly better when the ratio term is
included. This is not a terribly scientific example but goes to show how the
results of PCA might be applied.

So here you have it, I hope this has illustrated how the data produced from PCA
relates to your original data, and how you can begin to interpret it. Here's
the message I've tried to convey:

- The first two components are not always the most useful.
- Look at the components (columns) with the positive and negative weights.
- Look at you original data in terms of the most positive and negative values
  for these components.
