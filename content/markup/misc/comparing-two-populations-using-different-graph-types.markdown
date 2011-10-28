--- 
kind: article
title: Comparing two populations using different graph types
category: misc
created_at: 2007-10-05 12:35:38
---
I think the title says it all. If you have two populations such as "Treatment" and "Control", what type of graphs can you use to compare the two? Have a look at the examples, then pick <a href="http://www.bioinformaticszen.com/wp-content/uploads/2007/10/comparing_two_populations.txt">the corresponding R code</a>.

All of the charts come from either excellent the <a href="http://stat.ethz.ch/R-manual/R-patched/library/lattice/html/00Index.html">lattice</a> package, or the superb <a href="http://had.co.nz/ggplot2/">ggplot2</a> package. The code should also work for multiple populations as well.

<!--more-->
<h3>lattice</h3>
<strong>Box plot</strong>

<img src="http://www.bioinformaticszen.com/wp-content/uploads/2007/10/box_plot.png" alt="Lattice box plot" />

<strong>Violin plot</strong>

<img src="http://www.bioinformaticszen.com/wp-content/uploads/2007/10/violin_plot.png" alt="Lattice violin plot" />

<strong>Density plot</strong>

<img src="http://www.bioinformaticszen.com/wp-content/uploads/2007/10/density_plot.png" alt="Lattice density plot" />
<h3>ggplot2</h3>
<strong>Box and whisker plot</strong>

<img src="http://www.bioinformaticszen.com/wp-content/uploads/2007/10/box_plot2.png" alt="ggplot2 box plot" />

<strong>Box and whisker plot with points</strong>

<img src="http://www.bioinformaticszen.com/wp-content/uploads/2007/10/box_plot_points.png" alt="ggplot2 box and whisker plot with points" />

<strong>Density plot</strong>

<img src="http://www.bioinformaticszen.com/wp-content/uploads/2007/10/density_plot_2.png" alt="ggplot2 density plot" />

<strong>Histogram plot</strong>

<img src="http://www.bioinformaticszen.com/wp-content/uploads/2007/10/histo_plot.png" alt="ggplot2 histogram plot" />
