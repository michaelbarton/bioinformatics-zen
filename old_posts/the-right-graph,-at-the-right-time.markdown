--- 
kind: article
title: The right graph, at the right time
category: misc
created_at: "2007-02-28 01:13:55"
---
I think everyone would agree that the most important thing in science is results. The best scientists produce the most relevant and important results. Of course, the best results won't matter if no one knows about them. Which is why we publish and give presentations.

Sometimes I see results in papers and presentations illustrated poorly. Graphs that don't demostrate the point to the reader/audience in the best possible way. Here I give examples of how data can be presented in different contexts, based on two of my favorite resources. The first is the <a href="http://www.r-project.org/">R language</a> for statistics, the other is <a href="http://www.garrreynolds.com/">Garr Reynolds</a>' <a href="http://www.presentationzen.com/">Presentation Zen</a> ideology.

<strong>A bad example</strong>
Here's an extreme case, but not completely uncommon in presentations. Two continuous variables - the oxidation of ammonia to nitric acid, and air flow. The chart was produced, using default options, in <a href="http://download.neooffice.org/neojava/en/index.php">NeoOffice</a>.
<img src="http://www.bioinformaticszen.com/wp-content/uploads/2007/02/officeexamples.tiff" class="centre" alt="Office example" />
My initial complaint, is the inappropriate x axis - the first half of the plot isn't being used. The axis should begin around 40, where the data starts.

Next, the unattractive grey background and horizontal black lines. I personally find this style unpleasant, and would recommend that these always be removed.

Finally, the trend-line, the magenta color is not particularly nice, and why is it so thick? The wide line makes the chart look clunky and inelegant. If you're making a chart, you want people to look at it, and appreciate the data. You've spent months slaving away to produce a set of results, so why not put the extra effort into presenting them well?

<strong>Producing a graph for a paper</strong>
Here is the same data produced using the default plot function in R.
<img src="http://www.bioinformaticszen.com/wp-content/uploads/2007/03/r_example.png" class="centre" alt="Rexample" />

What strikes me about R plots, is how clean they appear. You could argue that it looks rather spartan, but the chart shows the data and nothing else. There are no frills, but then you want to illustrate your results efficiently. If the results aren't that good, then no amount of fluffing will make them better. On the other hand if the results are good, extra decoration distracts from the main point.

<strong>Producing a graph for a presentation</strong>
Controversial, but I say don't. If you can use a simpler way to show the result, do it. When looking at a chart in a paper, the reader has time to read the legend and think about what point it illustrates. I look at all the figures in a paper at least twice.

On the other hand, when presenting, you've usually got a limited time to get your point across. When you show a chart in a presentation the audience has to look at many things, the axis, points, trend-lines. This could distract from you, and your message.

What do you want to do in the time you have? You want to show your work as exciting and interesting to as many people as possible. How many times have you been in a presentation where there has been slide after slide of graphs. You can imagine that audience attention drops dramatically with each new plot. Here's an example slide to illustrate how I would show the above data.

<a href="http://www.bioinformaticszen.com/wp-content/uploads/2007/02/keyexamples.tiff" title="Presentation Example"><img src="http://www.bioinformaticszen.com/wp-content/uploads/2007/02/keyexamples.tiff" class="centre" alt="Presentation Example" /></a>

This shows the point succinctly, no distractions. Remember that you'll be talking at the same time as well. If the audience wants more information, they can find you afterwards. You can direct them to the great figures that you included in your paper!

Of course you'll need to include a plot to demonstrate controversial and important results. The less plots you have prior to these, the more impact they and therefore your point, will have. Garr Reynolds has some <a href="http://www.garrreynolds.com/Presentation/slides.html">tips (point 6)</a> on producing graphs for presentations.

<strong>Finally</strong>
I'd like to end this post by quoting the R <a href="http://stat.ethz.ch/R-manual/R-patched/library/graphics/html/pie.html">help page</a> on the subject of pie charts
<blockquote> Pie charts are a very bad way of displaying information. The eye is good at judging linear measures and bad at judging relative areas. A bar chart or dot chart is a preferable way of displaying this type of data.

Cleveland (1985), page 264: â€œData that can be shown by pie charts always can be shown by a dot chart. This means that judgements of position along a common scale can be made instead of the less accurate angle judgements.â€ This statement is based on the empirical investigations of Cleveland and McGill as well as investigations by perceptual psychologists.</blockquote>
