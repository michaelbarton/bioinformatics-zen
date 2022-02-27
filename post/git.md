---
tags: post
feed: false
title: Git
date: 2009-01-11
---

### About

Git is a version control system or VCS for short. A VCS helps you manage your
code by saving changes as versions in a repository. Each version of any file
can be retrieved by rolling back the changes to the required version. At the
most basic a VCS allows you the freedom to experiment and actively break the
code you're working because the last working version can be reverted to with a
single command. Version control is used in software development, and in
bioinformatics is useful for keeping track of the scripts and libraries you use
in development. Version control using an external server is also a good way to
back-up code.

### Features

As a VCS git is clean and minimal, working out of a single .git directory in
the root of your project. If you want to remove the project from version
control, delete the .git directory and all git files are gone. Git managed
repositories are small using compression to store the differences between
versions. Git is fast at storing the latest version of your code, on even a
large repository, it is almost instantaneous. Git repositories are simple to
create, and don't necessarily require an external server to begin tracking
versions. If you do use an external git server, pushing and pulling to the
server is also very fast. Another feature of git allows you to create branches
within your code repository. Branching means copying the code as a duplicate
branch of the main "master" branch. The duplicate branch can be modified,
committed to and then compared with the original branch. If you are happy with
the changes in the new branch you can merge them back into the original master
branch. Another option is to leave the alternate branch to work on later since
switching back to the master branch will restore the previous state before
branching. In this way using a branches is a simple and lightweight way to
develop or experiment with new features.

### Collaboration

Git is useful for collaborating on shared source code repositories. The
collaborative development of the Linux kernel is the reason git was [created by
Linus Torvalds][history]. A key feature of git is that it is distributed. You
are not bound by working from a single source server. I have my copy of the
repository and you have yours. I like the changes you are making so I clone
your repository as a branch into my own. I can test out the changes you've made
before merging them into my master branch. If I only want a subset of the
changes you've made I can use the git cherry-pick command to merge only the
changes I want. The website [github.com][gh] enables a collaborative aspect of
developing software with git. Github acts as a git server but also highlights
the social links of branches between developers. Other developers' git
repositories can be viewed and downloaded, but also forked into your own github
space. This fork acts as a copy of the original repository with the
relationship between the two repositories maintained. Github monitors the
commits, merges and branching between repositories which can be viewed,
compared, or visualised as a network.

### Getting started

- [The git website][git]
- [Video introduction to git][video]
- [Links for git beginners on Github][new]
- [Using git for research][research]
- [Extensive git guide][guide]

[history]: http://en.wikipedia.org/wiki/Git_(software)#History
[gh]: https://www.github.com
[git]: http://git-scm.com/
[video]: http://schacon.github.io/2008/06/02/railsconf-git-talk.html
[research]: http://mendicantbug.com/2008/11/30/10-reasons-to-use-git-for-research/
[new]: https://github.com/blog/120-new-to-git
[guide]: http://www-cs-students.stanford.edu/~blynn/gitmagic/
