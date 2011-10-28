--- 
kind: article
title: git, github, and bioinformatics software development
category: misc
created_at: 2008-04-15 10:48:46
---
<a href="http://github.com/">Github</a>, a source code management (SCM) repository based on git has exited beta and is ready for people to sign up. Git and github offer interesting opportunities for bioinformatics software development, and I think it's worth taking a few minutes to explore them. <a href="http://github.com/plans">There's a free option too</a>, so it doesn't cost anything to sign up and play around.

<!--more-->
<h4>Source code management</h4>
Github is based on <a href="http://git.or.cz/">git</a>, and if you're familiar with a source code management tool like subversion, git uses a similar command syntax, and would only take about 20 minutes to familiarise with. Git does many things to improve upon SCM, and one of the first things I noticed is how much faster it is than subversion. Also if you've ever used subversion, you'll know that it creates a .svn directory in every subdirectory of the project. This can make it rather difficult to share and maintain. Git on the other hand creates a single .git directory in the root of the project, so if you want to share the project minus git revision control, you can just delete this directory. Git also simplifies the process of when there there is more than one developer working on a project, where each developer needs to work on the same code, which will obviously lead to conflicts in the different versions. Git's approach allows each developer to copy the main project and work on their own version. This copy can be modified, and committed to, while nothing is sent back to the master copy. Only when you decide to push the changes to the master, are they sent back to the original, at which point the maintainer decides what changes to merge into original version. Subversion does have this option to create branches, but I find that git's interface is much simpler and gives the developer more freedom in taking risks and trying out new code.
<h4>Social Software</h4>
Github builds on git and takes the easy branching feature a step further to create a social software site. I know everyone and their dog is creating a social [insert verb]ing application/site, but you might find that that github's approach can make a difference in your approach to software development. Github makes it possible to see who is creating branches of your project, visualised as a network, <a href="http://http//github.com/blog/39-say-hello-to-the-network-graph-visualizer">where branch and merge points are shown in a timeline</a>.

<a href="http://github.com/sam/dm-core/network"><img class="aligncenter size-medium wp-image-152" title="github network example" src="http://www.bioinformaticszen.com/wp-content/uploads/2008/04/network-thumb.png" alt="Image of github network feature" width="250" height="300" /></a>

As a use case, I'm working on a manuscript and I have a set of ruby classes which I've been using in my analysis. I think these might be useful to other bioinformaticians, and I'd like to contribute them to the <a href="http://bioruby.open-bio.org/">BioRuby library</a>. To do this, I have to contact the BioRuby mailing list with my suggestion, get CVS access, and my changes, them commit them to the trunk. Were BioRuby a git repository I could fork it at the beginning of my project, edit BioRuby as I am doing my research, then when my manuscript is done I can prune and tidy my changes and push them back as a patch. Even better, with github's network feature, anyone interested in BioRuby can see that I've forked it, follow the link to my changes and see what I'm doing, even before I've committed my changes back to the main project. The BioRuby developers spend a lot of time maintaining the code and so are entitled to tell me what I can do with my ideas, however I'm writing this as a suggestion as a way for BioRuby to further grow, and encourage contributions

I think it would be great if bioinformatics researchers, on publication of a manuscript, included a link to a github repository. As how often is bioinformatics code reinvented? Or when someone emails another researcher for their code, wouldn't it be great to know what they're up to? In particular, when you see some code mentioned in a paper, you want to be able to quickly get access, and start playing around. Whether people would want to share code in this way is one issue, but if they choose to, the features that git and github offer can make it much easier.
<h4>More on git and github</h4>
<a href="http://keithp.com/blogs/Repository_Formats_Matter/">Repository Formats Matter</a>

<a href="http://git.or.cz/course/svn.html">Moving from subversion to git</a>

<a href="http://jointheconversation.org/railsgit">Video tutorial on using git</a>

<a href="http://github.com/blog/42-commit-comments">Comments in github</a>

<a href="http://rob.cogit8.org/blog/2008/Mar/14/i-can-haz-hardcore-forking-action/">Project forking using github</a>

<a href="http://weblog.rubyonrails.org/2008/4/2/rails-is-moving-from-svn-to-git">Ruby on Rails moves to github</a>
