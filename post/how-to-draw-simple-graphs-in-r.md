---
tags: post
feed: false
title: How to draw simple graphs in R
date: 2007-05-04
---

<script type="text/javascript"><!--
google_ad_client = "pub-3537851447004532";
//BZen Banner
google_ad_slot = "0910526264";
google_ad_width = 468;
google_ad_height = 60;
//--></script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>

Graphs and statistics, you can't really get away from it. Even if you try, like a warm seafood sandwich, it'll come up later. So here I made up some example data to produce a short tutorial on how to represent common types of information in R.

<strong>R and example data</strong>
First of all you'll need R to follow the examples, install instructions are <a href="http://wiki.r-project.org/rwiki/doku.php?id=getting-started:installation:installation">here</a>. Second you'll need the example data either in <a href="http://www.box.net/shared/ix5qdar3l0">zip</a> or <a href="http://www.box.net/shared/exjl2ba8qr">tar.gz</a> format.

<strong>Categorical data</strong>
Categorical data is usually something with a name, and no numerical value. Round, Square, Triangular are categories. Small, Medium, and Large are ordered categories. The example categorical data file is categorical.csv.

To load this into R:
<code>
data &lt;- read.csv(file="path/to/file/categorical.R")
</code>
This stores the information in an object called <code>data</code>. The data is 20 measurements for three bioinformaticians based on their field of study (categories). Each measurement is how many cups of tea that bioinformatician drank in one day. We can look at the first few lines of the data using the <code>head</code> command
<code>
head(data)
Systems.biology Functional.genomics Non.coding.RNA
1 2 2 5
2 2 2 5
3 2 2 6
4 2 3 4
5 2 4 7
6 2 3 5
</code>
The first column is the row number, followed by three columns, one for each bioinformatician and their cups of tea that day.

So how to visualise categorical data in R? Well first the data needs to in a different format. Currently the data has one column for each set of measurements - all the systems biologists are in the first column, and so forth. This is called "wide", because if I had collected data for 100 bioinformaticians, there would be 100 columns. You can see how this quickly gets difficult to manage.

A better format is "long". Which instead has a column for each type of variable. We have two variables, the first is the area of bioinformatics, the second is the number of cups of tea.

So how how can we can get the data from wide to long? Fortunately, there is an R package for this called, reshape. Unfortunately, reshape doesn't come as standard, with R. You'll need to follow the <a href="http://wiki.r-project.org/rwiki/doku.php?id=getting-started:installation:packages">instructions</a> for installing additional packages.

Once you've installed reshape, the library is loaded by typing.
<code>
library(reshape)
</code>
Then we use reshape as follows
<code>
data &lt;- melt(data,measure.var=c("Systems.biology","Functional.genomics","Non.coding.RNA"))
</code>
The three variables are identified by the <code>measure.var=c(...</code> argument. Looking at the data, we can now see it's in the "long" format.
<code>
head(data)
variable value
1 Systems.biology 2
2 Systems.biology 2
3 Systems.biology 2
4 Systems.biology 2
5 Systems.biology 2
6 Systems.biology 2
</code>
The first column is the type of bioinformatics, the second the cups of tea. You can see the advantage of this, if I wanted to add another area of research, such as phylogenetics, I would add an extra row rather than an extra column. Now, imagine if we were using the database, this would be the difference between updating the schema and or inserting a new record.

So next I want to plot this data to see which researchers are drinking the most tea. I'm using another R package for this, called lattice. Luckily, lattice comes as standard with R so can be loaded with no extra installation.
<code>
library(lattice)
</code>
For visualising categorical data, a good plot is a box and whisker plot. The lattice command for this is <code>bwplot</code>. Here's the code to produce the plot.
<code>
plot &lt;- bwplot(value ~ variable, data = data)
plot$ylab &lt;- "Cups of Tea per day"
print(plot)
</code>
The formula <code>value ~ variable</code> tells R that the value (cups of tea) is a result of the variable (area of bioinformatics studied). The next bit <code>data=data</code> says that the data for this plot is stored in the R object named data. We put the result of this command into an R object called plot. On the next line <code>plot$ylab</code> is the label for the y-axis and I'm setting it to cups of tea per day. Finally <code>print(plot)</code> prints out my plot object to the graphics device.

<img src="http://www.bioinformaticszen.com/wp-content/uploads/2007/04/categorical.png" alt="Categorical variables plot" class="centre" width="75%" />

From this it's pretty obvious what the trends are. Systems biologists drink exactly 2 cups of tea every data, functional genomists range 1-5, whilst a non-coding RNA-ist can drink up to 8 cups of tea per day. Crazy!

If you wanted to model this categorical data, to see if area of study significantly affects how many cups of tea were drunk, anova would be a good choice.

<strong>Continuous data</strong>

Continuous data is numerical. The example data is in continuous.csv. The file is read in using the same method as before.
<code>
data &lt;- read.csv(file="/Users/mike/Desktop/plots/continuous.csv")
head(data)
distance productivity
1 41.30473 34.69197
2 36.34507 35.53591
3 39.88439 36.17467
4 26.05197 37.84792
5 39.92318 34.59474
6 55.23140 34.89835
</code>
The data measure shows a bioinformatician's distance from the tea making area and their weekly productivity. Since I'm comparing one value with another, the data is already in the correct format with two columns.

The best way to compare two continuous variables is with a simple xyplot, with one on each axis. I create the plot in a similar way as before, by modelling productivity as a response of "distance to tea making area". This time I'm using the <code>xyplot</code> function. Not forgetting to label each axis.
<code>
plot &lt;- xyplot(productivity ~ distance, data=data)
plot$xlab &lt;- "Distance to tea making area (feet)"
plot$ylab &lt;- "Weekly productivity (hours)"
print(plot)
</code>
<img src="http://www.bioinformaticszen.com/wp-content/uploads/2007/05/continuous.png" alt="Continuous data" class="centre" width="75%" />

It looks likes productivity declines the further away from the tea making area. I knew drinking cups of tea made we work better! I want to confirm this, and one way to do this would be to add a line to plot. To do this with lattice I have to change the way the "panel" is created.

The panel is the area inside the axis where the points are drawn. At the moment the panel is created using <code>panel.xyplot</code>, which is the default for xyplot. Here's how to create a custom panel.
<code>
custom_panel_lm &lt;- function(x,y,...){</code>

panel.xyplot(x,y,...)
panel.lmline(x,y)

}

plot$panel &lt;- custom_panel_lm
print(plot)

The first command <code>function(x,y,...)</code> defines a method that expects two parameters x and y, our continuous variables, plus some other arguments (...) that I'm not worried about. The function defines two method calls, the first draws the plot using the default panel.xyplot function. The second then draws a linear trend line over the data using the xy parameters. Setting a custom panel is done similarly to the way the axis text was defined.
<code>
plot$panel &lt;- custom_panel_lm
print(plot)
</code>

<img src="http://www.bioinformaticszen.com/wp-content/uploads/2007/05/continuous_lm.png" alt="Continuous variable with trend line" class="centre" width="75%" />

Which produces the plot I was after, the line indicates the trend between distance and productivity. However it's worth introducing a note of caution about trend lines. If you follow the line far enough, at some point the number of hours will become negative, something not possible. What we might expect is that hours decreases with distance, but never crosses the x-axis. One way to look at trends without making assumptions is to use the loess rather than lmline function.
<code>
custom_panel_loess &lt;- function(x,y,...){</code>

panel.xyplot(x,y,...)
panel.loess(x,y)

}

plot$panel &lt;- custom_panel_loess
print(plot)

<img src="http://www.bioinformaticszen.com/wp-content/uploads/2007/05/continuous_loess.png" alt="Continuous variable with loess" class="centre" width="75%" />
The line is more "wobbly" but it gives us an unbiased view of the trend without coercing to a prior assumption, for example, a straight line. If I wanted to create a statistical model of this data I would use some sort of regression.

<strong>Factored categorical data</strong>

We have an idea of the trends in how many cups of tea researchers drink. But what if I wanted to see how this changed across seasons. How many cups of tea get drunk in winter as opposed to summer. This data is in categorical_categorical.csv.
<code>
data &lt;- read.csv(file="/Users/mike/Desktop/plots/categorical_categorical.csv")
head(data)
SB FG ncRNA SB.1 FG.1 ncRNA.1
1 2 3 5 0 1 6
2 2 3 5 0 0 8
3 2 3 4 0 3 6
4 2 2 6 0 3 6
5 2 4 5 0 4 7
6 2 3 6 0 3 7
</code>
Again this data is in wide format, The first three columns is the winter data, the second three columns are the summer data. The data is categorical (area of research), organised, by a second category (season). So first of all I need to shape this into long format . This time I'll need three columns because I have three variables, cups of tea, area of bioinformatics, and season.
<code>
winter &lt;- data[,1:3]
summer &lt;- data[,4:6]</code>

winter &lt;- melt(winter,measure.var=c("SB","FG","ncRNA"))
summer &lt;- melt(summer,measure.var=c("SB.1","FG.1","ncRNA.1"))

In the first two lines I'm splitting the data into two R objects one for winter, and one for summer. This bit <code>[,1:3]</code> selects columns 1 to 3. In the next two lines I'm melting the data in the same was as before. If we look at the two data sets, they're both now in long format.
<code>
head(summer)
variable value
1 SB.1 0
2 SB.1 0
3 SB.1 0
4 SB.1 0
5 SB.1 0
6 SB.1 0</code>

head(winter)
variable value
1 SB 2
2 SB 2
3 SB 2
4 SB 2
5 SB 2
6 SB 2

However I need to add the extra seasonal variable as a new column for each.
<code>
summer &lt;- cbind(summer,season="summer")
winter &lt;- cbind(winter,season="winter")
</code>
The command <code>cbind</code> means bind a new column, I'm calling this column season, and it only contains one value, either summer or winter, which will be repeated for each row.
<code>
head(summer)
variable value season
1 SB.1 0 summer
2 SB.1 0 summer
3 SB.1 0 summer
4 SB.1 0 summer
5 SB.1 0 summer
6 SB.1 0 summer
</code>
You can see that this extra column has now been added. Finally we need to combine the two data set together.
<code>
data &lt;- rbind(winter,summer)
</code>
The command <code>rbind</code> means bind new rows. I'm using this to join the summer data to the bottom of the winter data. I'm almost ready to plot the data. However there's one more thing, the summer data has .1 attached to the end of each bioinformatics entries. We can see this by looking at the levels of the variable column.
<code>
levels(data$variable)
[1] "SB"      "FG"      "ncRNA"   "SB.1"    "FG.1"    "ncRNA.1"
</code>
This is corrected by replacing the names of the last three variables with that of the first three.
<code>
levels(data$variable)[4:6] &lt;- levels(data$variable)[1:3]
levels(data$variable)
[1] "SB" "FG" "ncRNA"
</code>
As you can see the names are now consistent. And the only thing that remains is to plot the data.
<code>
plot &lt;- bwplot(value ~ variable | season, data=data)
plot$ylab &lt;- "Cups of Tea per day"
print(plot)
</code>
<img src="http://www.bioinformaticszen.com/wp-content/uploads/2007/04/categorical_categorical.png" alt="Categorical variable organised by second category" class="centre" width="75%" />
The plot has been split for the two different seasons. This factoring was produced by using the <code>| season</code> part of the plot formula. The vertical bar means "given". So the layout of the plot is cups of tea per day as a result of area of bioinformatics <em>given</em> time of year. If I wanted create a statistical model for this data, I'd probably think about a factorial anova.

<strong>Factored continuous data</strong>

My final example is continuous data factored by a categorical variable. This is stored in the file called continuous_categorical.csv.
<code>
data &lt;- read.csv("/path/to/file/continuous_categorical.csv")
head(data)
water water.prod tea tea.prod hipflask hf.prod
1 0.4172023 33.99677 0.7731859 31.71567 1.1661047 24.90616
2 0.9628104 40.04022 0.5545423 29.11507 0.3830907 31.74964
3 1.3025050 40.78758 0.9033747 28.75205 1.0460207 29.64453
4 1.3352481 40.19776 1.2515750 28.68057 1.3909051 20.29845
5 0.8253107 38.38265 0.9861313 30.44975 0.2510354 31.51177
6 1.5136886 40.61841 0.9458123 29.50657 1.1346057 25.31571
</code>
In this data there are three different types of drinks, water, tea, and the contents of a hipflask. The amount consumed is measured, with the corresponding effect on productivity. So here we have two continuous variables, amount drunk and productivity, and one categorical, the type of liquid. The first thing I need to do is convert the data into long format to reflect this.
<code>
water &lt;- cbind(data[,1:2],drink="water")
tea &lt;- cbind(data[,3:4],drink="tea")
hipflask &lt;- cbind(data[,5:6],drink="hipflask")
</code>
Here I've split the the data set into three smaller ones, and added an extra column to reflect the type of liquid.
<code>
head(water)
water water.prod drink
1 0.4172023 33.99677 water
2 0.9628104 40.04022 water
3 1.3025050 40.78758 water
4 1.3352481 40.19776 water
5 0.8253107 38.38265 water
6 1.5136886 40.61841 water
&gt; head(tea)
tea tea.prod drink
1 0.7731859 31.71567 tea
2 0.5545423 29.11507 tea
3 0.9033747 28.75205 tea
4 1.2515750 28.68057 tea
5 0.9861313 30.44975 tea
6 0.9458123 29.50657 tea
</code>
However looking at the individual data sets we can see that the variable names do not match. For example there's one column named water productivity and another named tea productivity. Actually they are the same variable, productivity. So therefore I have to rename the first two columns to be consistent.
<code>
col.names &lt;- c("volume","productivity")
names(water)[1:2] &lt;- col.names
names(tea)[1:2] &lt;- col.names
names(hipflask)[1:2] &lt;- col.names
</code>
Now I can join this this three datasets back together again. Row bind would have complained if I hadn't they didn't all have the same column names.
<code>
data &lt;- rbind(water,tea,hipflask)
head(data)
volume productivity drink
1 0.4172023 33.99677 water
2 0.9628104 40.04022 water
3 1.3025050 40.78758 water
4 1.3352481 40.19776 water
5 0.8253107 38.38265 water
6 1.5136886 40.61841 water
</code>
All that remains is to plot the data using the <em>given</em> notation for the categorical variable. I've also added a loess function for the using a custom panel. Both of these should be familiar from above.
<code>
plot &lt;- xyplot(productivity ~ volume | drink, data=data)
plot$xlab &lt;- "Average volume ingested (litres / day)"
plot$ylab &lt;- "Weekly productivity (hours)"
custom_panel &lt;- function(x,y,...){</code>

panel.xyplot(x,y,...)
panel.loess(x,y,col="red",lty=2)

}

plot$panel &lt;- custom_panel
print(plot)

<img src="http://www.bioinformaticszen.com/wp-content/uploads/2007/04/continuous_categorical.png" alt="Continuous variable organised by category" class="centre" width="75%" />
If I wanted to model this data I would probably start with an ANCOVA. However it might be a bit trickier than that as the contents of the hipflask seem to have a very non-linear effect on productivity.
