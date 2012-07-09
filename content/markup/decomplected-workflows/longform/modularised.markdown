---
kind: article
unpublished: true
title: Modularised parts connected by data
created_at: "2012-07-12 00:00:00"
---

I suggested breaking workflow steps into combinations of composable functions
in my discussion of [building functional workflow][functional]. The advantage
of this is that steps are easier to understand and maintain compared to large
scripts performing many functions. I believe this same priciple can also be
applied on a macro level to breaking large projects into modularised components
connected by data.

[functional]: /post/decomplected-experiments/functional.markdown

I no longer store any project on my computer longer than I am currently working
on it. I do this my creating a soft link for the directoy `~/cache` to
`/tmp/cache`. The directory `~/cache` is also the default directory for a new
terminal session. Anything in the `/tmp` directory is automatically cleared
when my computer is turned off and this therefore any code in `~/cache` is
cleared to. I took this approach for a couple of reasons:

#### Reproducability

I found that the longer a project sat on my hard drive the more complex it
became. This meant that when I came back to work on a project after a few month
I sometimes found that the project wouldn't work. I would try to run the `rake
build` but for the interpreter would throw and error requiring me to dig
through a project.

Forcing me to rerun a project from scratch at the start of each day strictly
enforced that a project always worked. If I had missed some depedency at the
end of the previous day this would immediatly become obvious at the start of
the next. In contrast to this, it is very satisfying to clone a project I
haven't worked on in a while run `make` and have every step run through to
generate the data I was after. LaTeX manuscripts and appendices are prime
candidates for this since I often find myself coming back repeatedly to make
small changes.

#### Break up larger projects into smaller units

This approach however is not feasable however when there is a bottle neck in
the project which takes days to run. To solve this I break larger projects up
into the processes that take the longest time to run. I split this part of a
project into into a separate sub-component along with it's own Makefile. The
last two steps in the Makefile are to compress output of the long running data
with `xz` and then push this to my S3 account using `s3cmd`.

When I'm working on the next sub-component of the project, the first two steps
are to download the data and decompress the data from the previous. XZ
compresses extremely well so download times have never been a time consumbing
problem so far. I'd like to consider taking this a step further and use
[git-annex][] so that the data is version controlled without having the running
time of downloading large files when cloning a repository.

[git-annex]: git-annex.branchable.com

Breaking a single project up into smaller components decomplectes the project
by effectively "caching" the results of long running process into the cloud.
Futhermore smaller projects are easier to re-remember at the start of the day
therefore work with.

#### Minimal data loss

As everything is wiped at the end of the day it's easy to lose work to if I
forget to push any changes back. I use git to version control all of my
research projects so I have to remember to run `git push` on everything before
I switch off my computer otherwise the last day's changes will be lost. There
have been three occasions where this has happened and as you can imagine this
is very frustraing. 

On the other hand there was was one occaison where my laptop was stolen from my
house while I was out. I didn't lose a single piece of data from two
in-progress manuscripts or any of the related code becase I had been forcing
myself to work off remote copies of everything for several months.

#### Simpler cloud usage

As each sub-component is encapsulated with a Makefile it is much simpler to run
the project on larger computer. If I have a long running process I tend to
launch a large EC2 instance clone my project onto it a run make. I can then
leave this project running and then check back every so often on it's progress.
If I included parallisable tasks, as I mentioned in my [Makefile][] post, it is
simple to scale up the number of cores used with the `make -j X` command where
`X` is the number of cores in the instance.

[Makefile]: /post/decomplected-experiments/makefile.markdown
