--- 
  kind: article
  feed: false
  title: An introduction for data mining in bioinformatics
  revised: "2011-11-29"
  created_at: "2007-01-15 23:14:21"
---

In other words, you're a bioinformatician, and data has been dumped in your
lap. Find the patterns, trend, answers, or whatever meaningful knowledge the
data is hiding. From experience, this is a frustrating position to be in. Data
mining is a huge field and is easily bewildering. Nevertheless high throughput
techniques in biology produce data requiring interpretation, especially if the 
data have been generated with a specific hypothesis.

People working in bioinformatics generally come from computer science or
biology backgrounds. Data mining generally requires knowledge of both these 
fields with the additional requirements of statistics and mathematics. 
Hopefully these tips below may be able to give you guidance and an introduction 
to getting started.

### What's your question?

I cannot emphasise this enough. Always have a question in mind. Frame this
question, so that it can be answered in a statistically sound way. Then answer
the question. Importantly this question should be answerable with either true
or false. Then even if the answer is negative and not what you were hoping for
you still have something to write and publish.

Publication of negative results are important and should prevent other people
going down the same path. Furthermore the more important the research question,
the more important even negative results are. If the question isn't important 
then perhaps ask why you're working on it and what are the important questions.

Unfortunately in molecular biology one approach is to generate large amounts of
data then ask someone in bioinformatics to find something publishable. This is
exploratory data analysis and a rather unfair and risky position to be in. The
reason this is risky is because you can sink months of time into looking at the
data but still find nothing.

The answer for exploratory data is analysis is to understand why the data was
produced in the first place. Try to find the underlying biological systems that
are the target of investigation. Can you formulate a question that can be
answered with yes/no or true/false from the data? Come up with several of these
questions and then use the data to answer them. If you can't think of any
questions ask someone related to field to help you. If they can't think of any,
seriously consider what you can hope to achieve.

## Find someone who knows what they are doing

And be very nice to them. People will often spend some time talking to you if
you are enthusiastic and a patient listener. Importantly don't expect anyone to
do the work for you. This is a cardinal sin: dumping a pile of data in front of 
someone else lap and expecting answers.

Research the field, know your data backwards, and have some hypothesis and
questions you'd like to answer. Talking to someone of a statistical nature will
then often result in some advice on how to proceed. If they offer to meet on a
semi-regular basis, even better. I guarantee that discussing the data with a
third person, even if they are not Ronald Fisher, will still bring fresh
perspectives you haven't previously thought of.

### Set a deadline

Without an end point, data mining can drag into weeks, months, or years.
Searching for the elusive answer that will validate all of the time you have
sunk into the project. Sometimes the answers to all of your questions can't be
found with the data. This can be demoralising to the point of considering a
different career. I think it takes a non-trivial amount of discipline to finish
of a project you've become very tired off. Unfortunately this is exactly what
you have to do because you need the publication given the amount of time you've
already invested.

Set a deadline. When you reach it, write up what you've done as a paper.
Otherwise do you still want to be working on this project in another six
months? Seeing your work outlined in manuscript form will show you where you
need to go to finish the project. You'll see whats need to be finalised and 
what is required for a coherent narrative. Even if the paper is not the 
ground-breaking work you were hoping for, you've still gotten something for your time.

### The right tools

Excel and Numbers.app are fine tools for inputting data and creating simple 
graphs. I think however once you're doing sophisticated data analysis you'll 
need specific tools designed for this. I use [R][]  which both free and comes with
many data mining packages such as [vegan][] or [labdsv][]. For beginners R can
be impenetrable, I recommend this [book as an introduction to R][book] as well
as the underlying statistics. I also hear good things about using python with
the numpy and scipy packages.

Using the right tools is a good start also important is a good grounding is
statistics and probability. For instance why should you and scale your
variables before doing multivariate regression? What is the difference
between a parametric vs. non-parametric tests? A good understanding of
statistics will make you more confidence in your results and give you a better
idea of which methods to use in different situations.

### What are you doing?

The large amount of open source software makes it easy to rush into using
support vector machines, hidden Markov models and neural networks. But coming
back to the first point, what are you trying to prove? Always question what are
you doing, how does it fit in to the wider picture? Try to regularly review,
and keep track of where you are going. This will hoepfully keep you focused and 
lead to a satisfying analysis.

[R]: http://www.r-project.org/
[vegan]: http://cc.oulu.fi/~jarioksa/softhelp/vegan.html
[labdsv]: http://ecology.msu.montana.edu/labdsv/R/
[book]: http://www3.imperial.ac.uk/naturalsciences/research/statisticsusingr
