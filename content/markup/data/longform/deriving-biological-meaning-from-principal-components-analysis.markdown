--- 
kind: article
title: Deriving meaning from principal components analysis
created_at: "2007-08-01 15:35:11"
---

Here I'm going to illustrate how you can relate principal components analysis
back to the original. If you want to reproduce what I'm doing, I've put [the R
code on github][code]. I'm be using example dataset to illustrate using PCA.
This data contains 200 crabs where five morphological characteristics have been
measured for each. These are:

[code]: https://gist.github.com/3969797#file_pca.r

  * <code>**FL**</code> - Frontal lobe size
  * <code>**RW**</code> - Rear width
  * <code>**CL**</code> - Carapace length
  * <code>**CW**</code> - Carapace width
  * <code>**BD**</code> - Body depth

The first rows of these data look as follows:

<%= highlight %>
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
<%= endhighlight %>

Each row contains the species of the crab (Blue/Orange), the crab sex
(Male/Female), the row index and the five measured morphological
characteristics.

I'm going to outline how you might apply PCA to analysing mutlivariate data
such as this. If you are interested in learning how PCA is calcuated there is a
[video by Andrew Ng][video]. In addition [the machine learning course at
coursera][coursera] also covers the application of PCA.

[video]: http://youtu.be/ey2PE5xi9-A?t=37m20s
[coursera]: https://www.coursera.org/

PCA can be thought of as describing the underlying structure of data. Each
princpal component relates to underlying variation in the data. The first
component describes the greatest degree of variation in the data, the second
component the next largest component and so forth. Furthermore each component
describes variation orthogonal to the previous components.

This may sound non-intuitive. PCA can still however be used for exploratory
data analysis without understanding the algorithm. If you begin using PCA
regularly Taking the time to understand the algorithm does however pay off.

I'll begin by using R to perform PCA on the crab data. I'll then attach the
first three components to the original crab data so that they can be compared. 

<%= highlight %>
# Perform PCA on the data
# retx returns the scores for each crab
# Append the components for each crab to the original data
R> crab.pca <- prcomp(crabs[,4:8],retx=TRUE)
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
<%= endhighlight %>

The first column is the first component, and so forth. Each row shows how much
each characteristic of the original data adds to the given component, e.g. the
weight for "frontal lobe" in the first component is 0.28898.

When you use PCA, what you want is for components to be able to discriminate
points in the data. When I say discriminating, the components can be used to
spread and separate, so you can get more of an idea of what's happening. In
terms of PCA, a discriminating component has both positive and negative values
in the column. So we can see that the first component has no discriminating
effect as all the values in the column are positive.

Looking to the second component, we can see two negative values, and three
positive values, therefore the second component can be used to discriminate the
data. To visualise this effect we'll use the two most opposing characteristics
- the most negative and the most positive values. In this case it's rear width
(RW) 0.87, and carapace width (CW) -0.29. Plotting these two characteristics we
get the following graph.

<%= image(amzn('/principal_components_analysis/second_component_dotplot.png')) %>

Here you can see that data forms a nosey V shape. Imagine that you drew a line
through each arm of the V, you would get two sets of data. Therefore, we might
assume that there are two different distributions of carapace to rear width
ratio. We can test this by plotting the density of the crabs according to this
ratio

<%= image(amzn('/principal_components_analysis/second_component_density.png')) %>

There are two peaks, with some overlap. So the biological meaning of the second
component is largely picking up the difference in ratios of rear and carapace
widths. What it means, we'll look at later on.

Looking at the third component, again this is discriminating, the most extreme
values are carapace width and body depth. Plotting these, we get this figure.

<%= image(amzn('/principal_components_analysis/third_component_dotplot.png')) %>

This time we have two vaguely parallel lines, so again there appears to be
different ratio of the two characteristics. A density plot illustrates the
distribution of this ratio.

<%= image(amzn('/principal_components_analysis/third_component_density.png')) %>

Two more overlapping but obvious distributions, so it would appear that the
third component highlights a discriminating effect based on the ratio of body
depth to carapace width. We can plot the distribution of crabs based on these
two ratios, which produces this figure.

<%= image(amzn('/principal_components_analysis/morphology.png')) %>

I coloured the crabs based on their species and sex, I also used different
point types to further discriminate sex. Looking at this plot, we can begin to
derive biological meaning based on what we've learnt from principal components
analysis.

The x-axis, which we derived from the second component, appears to be related
to crab gender, as sex appears roughly separated based on this ratio. The boy
crabs seem to have a larger carapace compared to rear width - their shells are
relatively larger than their bums, compared with that of the girl crabs.

On the y-axis, the ratio derived from the third component, appears to separate
crab species. The orange crabs have a larger body depth to their carapace
width, compared with their blue counterparts.

So far, I haven't so far plotted the component plots - which is often the first
thing people do after performing PCA. So here they are, the first/second
components.

<%= image(amzn('/principal_components_analysis/first_components.png')) %>

And the second and third components plot

<%= image(amzn('/principal_components_analysis/second_components.png')) %>

You can see that the first and second component plot doesn't discriminate the
crabs very well. This is why I chose to ignore the first component. The
second/third component plot discriminates the data similarly to the morphology
ratios plot, however the axis that would split gender and species have been
rotated.

So here you have it, I hope this has illustrated how the data produced from PCA
relates to your original data, and how you can begin to interpret it. Here's
the messages I've tried to convey.

* The first two components are not always the most useful.
* Look at the components (columns) with the positive and negative weights.
* Look at you original data in terms of the most positive and negative values
  for these components.
