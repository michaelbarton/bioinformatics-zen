---
tags: post
feed: false
title: Modularised parts connected by data
date: 2012-07-12
---

This is the fourth post in a series discussing simple, reproducible and
organised research workflows. In previous posts I described how [using
Makefiles][make] and a [functional approach][function] can result in simpler
and more reproducible workflows. Here I'm going to outline how I break-up
larger projects to make them easier to manage.

[make]: /post/makefile/
[function]: /post/functional/

In the [previous post][function] I suggested breaking workflow steps into
combinations of composable functions. The advantage of this is that steps are
easier to understand and maintain compared to large scripts performing multiple
functions. I believe this same principle can also be applied at a macro level
by breaking large projects into modularised sub-projects connected by data.

I began practising this with a self-imposed rule: my computer only serves as a
["hot cache"][cache] for what I'm currently working on. I don't store any
project on my computer longer than I am currently working on it. I enforce this
by creating a soft link for the directory `~/cache` to `/tmp/cache`. The
directory `~/cache` is then the default directory for a new tmux session.
Therefore `~/cache` is where I always work and is also automatically cleared
after a reboot.

[cache]: http://en.wikipedia.org/wiki/Cache_(computing)

At the start of the day, when I begin working on a project, I use [git][] to
clone a local copy to `~/cache`. As all of my projects are [organised around
using Makefiles][make] the first command I call is `make` to run the analysis
up to the latest state. I can then continue to work on the project and push any
changes back to the git repository at the end of the day.

[git]: /post/git/
[make]: /post/makefiles/

## Organisation

The advantage of this approach is that I no longer have problems effectively
organising projects on my hard drive. I previously used to have projects
organised by year but this still made it hard to remember which project
contained the analysis I wanted, given they often had related names.

Instead I now have an empty `~/cache` directory which fills up with a few
projects over the course of the day. I keep all of my projects repositories
organised using [repositoryhosting.com][repo] for my in-progress projects and
[github.com][github] for more complete public projects. Here's a screen shot of
my projects on repository hosting as an example of how I organise everything. I
find this much simpler that working with large numbers of local project
directories.

{% include 'image.njk',
  url: 'http://s3.amazonaws.com/bioinformatics-zen/decomplected/repositories.png',
  alt: 'A list of my project repositories' %}

[repo]: http://repositoryhosting.com/
[github]: https://github.com/

## Reproducibility

I found that the longer a project sat on my hard drive the more complex it
became. This often meant when I came back to a project after a few months I
sometimes found that the analyses were broken or wouldn't finish. I would try
to run `rake build` but this would raise an error requiring me to dig through a
project to find a missing dependency.

Forcing myself to rerun a project from scratch at the start of each day
strictly enforced that a project always worked. If I had added a new dependency
to a project but not specified it, this would immediately become obvious the
next day when I cloned a fresh copy. Furthermore it is very satisfying to clone
a project I haven't worked on in a while, run `make`, and have every workflow
step run error-free to generate the data I was after. This is particularly
useful when finishing a manuscript as I find myself coming back repeatedly to
make minor tweaks during the submission and review process.

## Break up larger projects into smaller units

Repeatedly cloning and re-running a project becomes unfeasible when there is a
computational bottleneck requiring days to run. This is usually indicative that
the project should be split into two separate sub-projects. I do this by adding
a step to the first sub-project to compress the result of the long running
process with `xz` and push this to my S3 account using `s3cmd`. The first step
of the following sub-project is then to download and decompress this data. This
effectively caches the result of a long running process so I can continue to
experiment with downstream analyses steps without repeatedly rerunning a single
intensive analysis.

XZ compresses extremely well so download times have never been a time consuming
problem. However in future I'm considering taking this a step further and using
[git-annex][] so that the data is also version controlled as a part of the
analysis too.

[git-annex]: http://git-annex.branchable.com/

## Minimal data loss

As everything is cleared from my cache directory when I reboot my computer,
it's easy to lose work if I forget to push back changes. I use git to version
control all of my research projects so I have to remember to run `git push` on
everything before I switch off for the day. There have however been three
occasions where I have forgotten to do this and lost data. As you can imagine
it is very frustrating to lose a day's work.

On the other hand there was one occasion where my laptop was stolen. As I had
been forcing myself to work off remote copies of everything for several months
I didn't lose a single piece of data from two in-progress manuscripts. I think
the advantage of forcing yourself to back up projects as part of the
development process is obvious.

## Simpler to run in the cloud

Each sub-project is encapsulated and reproducible via a Makefile. This
therefore often means there is minimal effort required to set up the workflow
to run on a larger, more powerful computer. If I have a long running process I
tend to launch a large EC2 instance, clone my project onto it, then run `make`.
I can then leave this running and check back time-to-time on the progress.
Furthermore if I designed the process to include parallisable tasks, as I
described in my [Makefile][make] post, it is simple to scale up the number of
cores used with the `make -j X` command where `X` is the number of cores
available to the instance.

## Summary

I believe the advantage of breaking a larger project smaller sub-projects is
that they become easier to maintain. Sub-projects are less coupled to each
other having no shared code or state. The single connection is the format of
data passed between them. This makes it much easier to make changes in a one
part of the project without affecting the other parts. Furthermore by keeping
nothing local to my computer this ensures that reproducibility and backups
becomes a part of my development process.
