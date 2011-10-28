--- 
kind: article
title: Visualising and exploring multivariate datasets using singular value decomposition and self organising maps
category: misc
created_at: 2007-07-17 22:57:00
---
Hola from Madrid, I've come here for a data analysis summer school. Last week, there was an interesting class on dimensionality reduction, and since multivariate datasets are prevalent in this -omic era, I thought to post a discussion of what I learnt. The aim of this example is illustrate one technique for visualising multivariate data, singular value decomposition, and a second technique for exploring it, self organising maps.

<!--more-->
<h4>The Dataset</h4>
I'll be doing this example in R, instructions for getting and installing can be found <a href="http://www.r-project.org/">here</a>. I'm using the example crab data which is in the MASS package. This data contains five measured morphological characteristics for both sexes of two species, orange and blue. The morphological categories are as follows
<ul>
	<li>FL frontal lobe size (mm)</li>
	<li>RW rear width (mm)</li>
	<li>CL carapace length (mm)</li>
	<li>CW carapace width (mm)</li>
	<li>BD body depth (mm)</li>
</ul>
We can treat these five variables as our observations, and in practice these could be any characteristic, for example each could be an expression level in a microarray experiment. The aim of the analysis to identify the underlying characteristics of the data, which in this case could be crab species and gender. Here's how to load the crab data

<code>
# Access the MASS library, which contains the crab data
library(MASS)
</code>

<code>
# Load the crab data
data(crabs)
</code>

<code>
# Show the first few entries of the data
head(crabs)
</code>
<h4>Dimensionality reduction and visualisation</h4>
The first thing I want to do is visualise the data to get a feel for it's shape. Because of the restrictions of time and space, it's difficult to conceptualise information using more than three dimensions. It would be possible to create a plot on three axis, then use point colour and size for the last two variables, however this would be complex and add little meaning.

Instead I'm going to use dimensionality reduction techniques to effectively "simplify" the data, then plot it. The most widely used technique, and one that you have likely already heard of, is principle components analysis or PCA.

PCA is difficult to describe, but in essence it will create a new variable that describes a large proportion of the variation in the data, this is then the first component. This component is factored out, and a second component calculated that explains the remaining variation. This is repeated, creating new components until all the variation has been explained. When I use the phrase "explaining variation", imagine that some variable in the data set are correlated, for example shell length and width; a change in one usually shows a corresponding change in other. When you factor this out, to create a component, you have explained x amount of variation.

PCA calculation is based in linear algebra, if you're interested there are plenty of sites that explain the process but I'm not going into detail. Instead I'll use the available R function, and plot the first two components.

<code>
# Library for producing plots
library(lattice)
</code>

<code>
# Simple method call for PCA on the variables of the crab data
prin.comp &lt;- (princomp(crabs[,4:8]))
</code>

<code>
# Create a simple plot of the first two components
library(lattice)
pca.plot &lt;- xyplot(prin.comp$scores[,2] ~ prin.comp$scores[,1])
pca.plot$xlab &lt;- "First Component"
pca.plot$ylab &lt;- "Second Component"
pca_plot
</code>

<img src="http://img389.imageshack.us/img389/7449/pcaplottl1.png" alt="Principle components plot" width="420" />

This demonstrates how the five dimensional data is now projected into two. This is a perfectly acceptable method for dimensionality reduction. However for the rest of this post, I prefer to use singular value decomposition (SVD) as opposed to PCA. PCA and SVD are closely related, but I have a better understanding of SVD, and therefore will be explain how to use it in more detail. Here's the code to perform SVD on my data.

<code>
# First normalise the data by row
# This isn't necessary for SVD,
# but it is for the self organising maps we'll be using later.
crabs.x &lt;- as.matrix(t(scale(t(crabs[,4:8]))))
</code>

<code>
# Run the SVD with a similar method call to that of PCA
crabs.svd &lt;- svd(crabs.x)
</code>

After performing dimensionality reduction using SVD, PCA or any related technique, the first thing you might be interested in is how much of the variation is explained by each component. In the R svd object, the singular values are scores in the d matrix, which is stored as an array.

<code>
# Calculate the percentage of variation explained by each of the components
# Each value divided by the total
var.explained &lt;- crabs.svd$d/sum(crabs.svd$d)
var.explained.plot &lt;- barchart(crabs.svd$d/sum(crabs.svd$d) ~ c(1:length(crabs.svd$d)),
horizontal=F,xlab="Component",ylab="Percentage of variation explained")
var.explained.plot
</code>

<img src="http://img73.imageshack.us/img73/9720/svdcomponentplotva6.png" alt="Barchart showing the variation explained by each of the singular values" width="420" />

It's easy to see from this plot that the first singular value explains a huge amount of the variation, about 95%. The other components quickly drop off, the second value explaining about 2%. Similarly to the PCA, we want to project the five dimensional crab data into two dimensions, for this we'll use the first and second components since they explain most of the variation. As an aside, since the first value is so large it would be reasonable to visualise the data in just one dimension, for example using a histogram.

In the svd object, the singular value scores for each crab are in the u matrix, so that the first two dimensions can be projected using the first two columns of this matrix.

<code>
plot(crabs.svd$u[,1],crabs.svd$u[,2])
</code>

However, I would like to demonstrate some interesting properties of the svd matrices. The svd matrix v contains the singular value scores for each variable; the first column of this matrix shows how much each morphological characteristic contributes to the first singular value. The matrix can therefore be used to project the original data into k number of required dimensions. So for example multiplying the original crab.x data by the first column of the v matrix will result in the first column of the u matrix: the first dimensional projection of the data. Since we're interested in k=2 dimensions we subset the v matrix for the first two columns then multiply the crab.x data by this.

<code>
# Trim to first two components
transform &lt;- crabs.svd$v[,1:2]
</code>

<code>
# Project the crab data onto two dimensions using the first transform matrix
# The symbol %*% denotes matrix multiplications,
# as opposed to the R default of array multiplication
crabs.projection &lt;- crabs.x %*% transform
# You can check the resulting values against the first
# two columns of the u matrix to see that they are the same
</code>

You might ask, whats the point of performing this procedure when the projection scores are already available? Well imagine you have a new set of data, for example five new crabs not in the original set, if you wished to see how these new crabs relate to the original ones, rather than rerunning the SVD, you could project the new data onto the old data using the transform matrix. Another example, imagine you have a library of articles, and word frequencies in each. Using SVD and then a transform matrix, you can query new articles against your existing data set to see which is the most related. This is very similar to latent semantic indexing, an important method in text mining.

So, I plot the first two projections

<code>
# Plot the projection
projection.plot &lt;- xyplot(crabs.projection[,2] ~ crabs.projection[,1],
xlab="First singular value",ylab="Second singular value")
projection.plot
</code>

<img src="http://img464.imageshack.us/img464/6240/svdplotnr6.png" alt="Singular value decomposition projection of the data" width="420" />

The same as the PCA plot, I now have the data in two dimensions, but remember even though they are plotted on similar scales the x axis explains 95% of the variation in the data, compared with the y axis which only explains about 2%. From the appearance of this plot we can see a continuous arc shape with no easily identifiable clusters. If you saw a set of points identifiably split away from the rest, you could say this was a distinct set of crabs and would look in more detail at their characteristics. Instead, here there are no visible clusters so we use another multivariate method to explore the data - self organising maps.
<h4>Self organising maps</h4>
A self organising map is a rectangular or a hexagonal grid which, through a number of iterations, shapes itself to best fit the landscape of a dataset. Each node in this grid is associated with a number of points. It's easier to see how Sims work rather than explain them, so here's the code to produce a self organising map.

<code>
# Dimensions of the SIM grid, the number of nodes in each side
Sim.x = 6
som.y = 6
som.shape = "rect"
</code>

<code>
# Number of iterations to perform
# More iterations produces a better fit
iterations &lt;- 1e6
</code>

<code>
# Call the self organising map method
# This may take up to 10 minutes depending on your processor
# On my 2GHz Mac, about 2 minutes
crabs.som &lt;- som(crabs.x,som.x,som.y,rlen=iterations,topol=som.shape)
</code>

The figure below illustrates how the som fits the data better with increasing numbers of iterations.

<img src="http://img62.imageshack.us/img62/6705/somtrainingxj2.png" alt="Illustration of the self organising map fitting the crab data" width="420" />

You'll notice that the SOM plot is in two dimensions, the same as the SVD projection of the data. I ran the SOM on the five dimensional crab data, not it's projection, therefore the SOM fits itself to a five dimensional landscape, however using the transform matrix I made earlier I can again project each node's five dimensional position into that of the two dimensional plot. Another reason why using the transform matrix can be useful.

Here's some R code, that you can use to perform a similar operation.

<code>
# The codes object contains the positions of the SOM nodes, in terms of the original five dimensional data
# Using the transform matrix we can project the position of these nodes from five dimension into two.
som.projection &lt;- crabs.som$code %*% transform
</code>

<code>
# A custom panel to for projecting the SOM onto the data
# Plotting the SOM node points is easy, but joining them correctly with lines requires a little more R/Lattice trickery
som.panel &lt;- function(x,y,subscripts,...){
</code>

<code>
panel.xyplot(x,y,...)
</code>

<code>
# Plot the SOM points
panel.points(som.projection[,1],som.projection[,2],
col="red")
</code>

<code>
# Plot the x axis lines
for(i in 1:som.x){
panel.lines(som.projection[(i*som.x-(som.x-1)):(i*som.x),],
col="red")
}
</code>

<code>
# Plot the y axis lines
for(i in 1:som.y){
panel.lines(som.projection[som.y*(1:som.y) - (i-1),],col="red")
}
</code>

<code>
}
som.plot &lt;- xyplot(crabs.projection[,2] ~ crabs.projection[,1],panel=som.panel)
som.plot$xlab &lt;- "First component"
som.plot$ylab &lt;- "Second component"
som.plot
</code>

Since the SOM has now shaped to fit the data, we can now effectively look at the data through the "eyes" of the self organising map. The SOM is a 6x6 grid, each node in the grid has a number of data points associated with it. By plotting the density of the data in the SOM, we can begin to see the "landscape".

<code>
# The code.sum object lists the x and y coordinates of each node, and the number of data points associated with it.
# We can create a heatmap showing the density of data points across the SOM
# nobs = number of observations
# I added 1 to each axis, so the range is 1-6 rather than 0-5
data.landscape &lt;- levelplot(nobs ~ (x + 1) * (y + 1) ,crabs.som$code.sum)
data.landscape$xlab &lt;- "SOM x axis"
data.landscape$ylab &lt;- "SOM y axis"
data.landscape
</code>

<img src="http://img469.imageshack.us/img469/6523/datalandscapetx9.png" alt="Visualising the density of observations in the self organising map" width="420" />

From this plot we can see that there two clusters of high density, in the lower left and in the upper right. We can look at the morphology of the crabs in the these clusters with the following code.

<code>
# Select the original data using the x y coordinates from the som
cluster.1 &lt;- crabs.som$visual$x == 0 &amp; crabs.som$visual$y == 0
cluster.2 &lt;- crabs.som$visual$x == 5 &amp; crabs.som$visual$y == 5
</code>

<code>
# Cross reference this with the original crab data, and create a data frame
clusters &lt;- rbind(cbind(crabs.x[cluster.1,],1),
cbind(crabs.x[cluster.2,],2))
names(clusters) &lt;- c(names(crabs[,4:8]),"cluster")
</code>

<code>
# Create parallel plot, illustrating the morphology of each cluster.
cluster.plot &lt;- parallel( ~ clusters[,1:5] | as.factor(clusters[,6]),varnames=names(crabs[,4:8]))
cluster.plot
</code>

<img src="http://img105.imageshack.us/img105/2687/clusterplotzx6.png" alt="Two clusters in the crab data" width="420" />

You can see the data in the first cluster has the opposite morphology to that of the crabs in the second cluster. Furthermore looking at the species and sex of these crabs, we can see that cluster one contains male blue crabs and the second cluster contains orange female crabs.

<code>
crabs[cluster.1,]
crabs[cluster.2,]
</code>

Each of these clusters lies at the extreme ends of the arc we saw in the original SVD plot, so we can hypothesise, based on the shape of the plot, that crab morphology shows a continuous distribution between orange males and blue females. Given the shape of the arc we might expect that at the apex on the left hand side, we get the opposite: orange males and blue females. We can test this simply.

<code>
# Select the crabs at the extreme left of the first projection
extreme.left &lt;- crabs.projection[,1] &lt; -1.9995
crabs[extreme.left,]
</code>

We can see, with the exception of one, that this is indeed the case.
<h4>Summary</h4>
If you're still reading this - thanks. What I intended to be a short demonstration has come in at over two thousand words. I hope it has been a useful introduction to how SVD can be used to simplify and visualise data, and with a combination of self organising maps and a little intuition you can begin to get an understanding of your multivariate data.
