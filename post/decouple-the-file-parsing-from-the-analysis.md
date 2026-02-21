---
tags: post
feed: false
title: Decouple the file parsing from the analysis
date: 2008-01-07
---

A common task in bioinformatics is to read data from a set of files, arrange into the required format, then run an analysis to verify or falsify your expectation. An example would be reading in the yeast interaction network, and protein evolution rates, then correlating the two sets of data to see if there is a trend. Using Perl, you would specify how each file gets read in, arrange the sets of data by gene name, then correlate the two.

<strong>Anti Pattern</strong>
I argue that that it is better to split this single script into two, one that takes the data from the files and outputs it into the required tabular format, the second reads in the table and runs the analysis. Why go through the trouble of doing this? Because in the instance of a single script, the analysis of the data is tightly coupled to the format the data is in, or in other words the analysis code knows too much about the format of the original data files.

Imagine a more comprehensive study of protein evolution is produced, if you want to use this data, you'll have to edit the whole script. This will usually end up with you having to change the way the analysis is done, because the reading in of the files overlaps with it. This presents the chance that a new bug could be introduced. Testing for any such bugs is difficult to do because the script is doing two things at the same time, and the data itself can't be verified because it's hidden inside the program.

<strong>Advantages</strong>
Then what is the benefit of the extra time required to split this script into two? Well first of all, it means that the scripts need to know only one thing about each other, how the data needs to be tabulated so the analysis can be performed. That's all. As long as this doesn't change, everything else can. If the data formatting side takes a long time, you can write it in C to decrease the time, but the analysis script doesn't need to change. The reverse is true for the data formatting, if the analysis is modified. The correct tabulation of the data can also be tested, since it is output before the analysis is run. Important for making sure that you are analysing the correct information. Also, a CSV file is programming language agnostic, so anyone can repeat or further the analysis, without being tied to the language you used.

Finally, asserting that each script does only one thing is good programming practice. This prevents monolithic, hard to debug code, and encourages modularity and reusability. If there is bunch of code you're always using - copying and pasting from one script to another, pull this out and make it up into a library. You'll save yourself effort each time you need to use it, and if you find a bug you only need to fix it once.
