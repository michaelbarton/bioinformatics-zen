---
feed: false
tags: post
title: What's the point of writing good scientific software?
date: 2013-02-08
---

Software written by academics has a reputation of being poorer quality than
that of software written by professional software developers. This poorer
quality can be quantified by a lack of documentation, a non-intuitive
interface, or bug-ridden with a tendency to crash.

I assume, since you're reading a bioinformatics blog, that you've experienced
trying to use code that you can't download, won't compile, won't run on your
system, isn't documented, won't work on your data, or just crashes without
explanation. Speaking from personal experience this can be frustrating in the
extreme. Consequently there are efforts to increase the quality of academic
software including [journals focused on publishing software with minimum
standards][orc] and [workshops to help academics write better
software][swptry].

[orc]: http://www.openresearchcomputation.com/
[swptry]: http://software-carpentry.org/

What then does good quality software look like? I think this includes both unit
and integration tests to ensure the software works as expected. Revision
control to ensure that bugs can be removed by reverting to the last working
version. Continuous integration to make sure that software always passes tests
when new changes are committed. Finally documentation of available options with
examples helps users understand how to use the software. A question I have been
recently asking myself however is what's the point of spending the extra time
to create better software?

Pubmed shows the number of articles published by two journals, 'BMC
Bioinformatics' and 'Bioinformatics,' containing the word 'software' in the
title or abstract is ~350 each year. I think this may an underestimate though
since other journals also publish software articles and the terms 'pipeline',
'package' and 'system' may also be used instead of 'software.'

Considering around 1700 bioinformatics software articles published in the last
five years, this represents a significant corpus. This leads me to the question
what is the point of writing good quality software if the chances are small
that anyone will read about, or download it? For every highly cited tool, such
as SAM Tools or PAML, there are likely many other tools which are never
downloaded or used. Does it make sense to invest the extra time in the
documentation and interface if there is a good chance that no one else will
ever use it?

Let me illustrate with a concrete example. I'm a post-doc working in microbial
genomics. I found that I had to write various scripts to help with the
finishing of my genome and the subsequent upload to GenBank. [I have previously
believed][create] that converting any code you've created into a open-source
library benefits the community and prevents reinvention of the wheel. Therefore
I converted my scripts first into a tool called [scaffolder][] and then a
subsequent tool called [genomer][]. Both of these are tested with integration
and unit tests, and I create documentation and [screencasts][].

[create]: /post/reuse,-contribute,-create/
[scaffolder]: http://next.gs/
[genomer]: https://github.com/michaelbarton/genomer
[screencasts]: http://www.youtube.com/watch?v=HfsdJOELFjs

I have however started to realise that perhaps something I thought would be
very useful may be of little interest to anyone else. Furthermore the effort I
have put into testing and documentation may not have been the best use of my
time if no one but I will use it. As my time as a post doc is limited, the
extra time effort spent on improving these tools could have instead have been
spent elsewhere. Would it have been better if I have just completed the minimum
to get them published then moved on to another project?

I have begun to think now that the most important thing when writing software
is to write the usable minimum. If then the tool becomes popular and other
people begin to use it, then I should I work on the documentation and
interface. This will then ensure then I make the best use of my time without
sinking effort onto something that could have little interest. Given the choice
I like writing robust, well documented software but this takes extra time and
in a competitive academic job market I feel like this is a luxury.
