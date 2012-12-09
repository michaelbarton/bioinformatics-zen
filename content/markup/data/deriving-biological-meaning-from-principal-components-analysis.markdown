--- 
kind: article
title: Deriving meaning from principal components analysis
created_at: "2007-08-01 15:35:11"
---

Here I'm going to illustrate how you can relate principal components analysis
back to the to the originating data to derive meaning. If you want to reproduce
what I'm doing, the R code is [here][code]

[code]: https://gist.github.com/3969797#file_pca.r

I'm using the same dataset as before, 200 crabs where five morphological
characteristics have been measured for each. These are:

  * <code>**FL**</code> - Frontal lobe size
  * <code>**RW**</code> - Rear width
  * <code>**CL**</code> - Carapace length
  * <code>**CW**</code> - Carapace width
  * <code>**BD**</code> - Body depth

So jumping right in, carrying out PCA on the data, we get five components. The
number of components you get will always be less than or equal to the number of
columns in your data frame. Here's the first three of these components from the
crab data

<table>
<tr>
<td>FL</td>
<td>0.28898</td>
<td>0.32325</td>
<td>-0.50717</td>
</tr>
<tr>
<td>RW</td>
<td>0.19728</td>
<td>0.86472</td>
<td>0.41414</td>
</tr>
<tr>
<td>CL</td>
<td>0.5994</td>
<td>-0.19823</td>
<td>-0.17533</td>
</tr>
<tr>
<td>CW</td>
<td>0.66165</td>
<td>-0.28798</td>
<td>0.49138</td>
</tr>
<tr>
<td>BD</td>
<td>0.28373</td>
<td>0.15984</td>
<td>-0.54688</td>
</tr>
</table>

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
