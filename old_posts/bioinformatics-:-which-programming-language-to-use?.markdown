--- 
kind: article
title: "Bioinformatics : which programming language to use?"
category: misc
created_at: "2007-03-14 20:42:02"
---
Two recent posts on using programming languages in bioinformatics. One at <a href="http://biowhat.com/2007/03/13/begginers-guide-to-bioinformatics/">biowhat</a> and the other at <a href="http://omicsomics.blogspot.com/2007/03/you-say-tomato-i-say-tomato.html">Omics! Omics!</a>. Both discuss what type of language to use. Heavy weight languages such as C++ and Java versus lighter scripting languages such as Perl, Ruby and Python.

I think this depends on what what your research goals are. If your aim is to build a tool for biologists, then you probably need an application building language such as C or Java. On the other hand if you want to find an answer to a biological question then it's a lot easier to create a short Perl script than manipulates the data to produce the desired result.

<strong>Heavy weight</strong>
My background is biology rather than computing science, but I find languages like Java encourage a better coding style. Which if you're working on a large project, is what you want. The object orientation aspects such as polymorphism and encapsulation work to prevent bugs. The syntax of these languages are often a lot stricter; object types are declared and generics can be used to further enforce correct allocation of resources. Development environments such as <a href="http://www.eclipse.org/">Eclipse</a> and <a href="http://www.netbeans.org/">Netbeans</a> can also make the production relatively quick. On the other hand using a language like this to strip a set of protein names from a file can be rather cumbersome and somewhat overkill.

<strong>Light weight</strong>
Perl was originally intended as a regular expression language for manipulating text. Something that is still very useful in biology, given the vast array of non-standard formats that biological data is distributed in. If you want to quickly strip data from a file, then Perl is by far the best choice. Which is probably what has made Perl the most popular choice of language in bioinformatics, and led to the incredibly successful <a href="http://www.bioperl.org/wiki/Main_Page">bioperl</a> project. A very useful set of libraries for performing common bioinformatics tasks; created and maintained by the community.

<strong>Specialised</strong>
If you want to create a non-linear mixed effects model, or solve a series of stochastic differential equations then you'll need a language designed with specific set of functions in mind. Examples are the impenetrably named "<a href="http://www.r-project.org/">R</a>" for statistics, and the more descriptive <a href="http://www.mathworks.com/">Matlab</a>/<a href="http://www.wolfram.com/">Mathematica</a> for, unsurprisingly, mathematics. Numerical languages such as these also take care of the sometimes tricky binary imprecision problem. Where storing a base 10 number in base 2 format can lead to inaccuracies.

Of course no programming language is a <a href="http://en.wikipedia.org/wiki/Golden_hammer">golden hammer</a> that can solve all of your problems. Each has it's own place. During my work I use a combination of Java, <a href="http://ant.apache.org/">Ant</a> and <a href="http://www.hibernate.org/">Hibernate</a> to maintain a large omic database. I then use R to pull the data and run my statistical analyses. Using a database also decouples stripping the data out of the files, from running the statistical analysis. Have I mentioned <a href="http://www.bioinformaticszen.com/2007/02/bioinformatics-use-a-database-for-data/">before</a> that databases are great?
