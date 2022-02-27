---
tags: post
feed: false
title: How I develop
date: 2015-07-24
---

I've been in the bioinformatics field for almost 10 years, originally coming
from a molecular biology degree background, I deciding to move into computing
after struggling to find a job doing lab work. This post is a general outline
of how I now develop since then.

## Programming languages

I began coding around 10 years ago during my bioinformatics master's degree
when I was was writing Java using Eclipse on Debian. I've never been too keen
on Java because of the verbosity of classes and getter/setters and so forth.

During my PhD I switched to learn Ruby. This was certainly a revelation after
several years writing Java. The ability to dynamically define methods on
classes or dynamically look up missing methods combined with a simple syntax
felt very liberating. I used Ruby for several years and it's still my choice
when I want a scripting language. I wrote a Ruby program to [help finish and
submit genome sequences][nextgs] which I used during my postdoc. I'm still
proud of this because I used all modern software development practices - though
afterwards I did [question the value of good scientific software][question].

[question]: /post/whats-the-point-of-writing-good-scientific-software/
[nextgs]: http://next.gs

These days I've also learnt Python, Haskell, Clojure and Erlang. I try use
which ever language seems the most appropriate for the task given their
different strengths and weaknesses. This however tends to be mostly bash for
speed of development or Python for collaborative projects, this is ironic as I
quite dislike python. I think this dislike comes from already gotten used to
the advantages of functional languages or lisps. In Python I miss the strong
generalised algebraic data typing of Haskell, or elegant macros such as `->` in
Clojure, which are both aspects of what makes these languages a pleasure to
use. I don't think you can really avoid python when working in bioinformatics,
but the libraries functools, pymonad and itertools can help to make it more
functional.

I also use R regularly for modelling and statistics. I used to hate R, however
the libraries ggplot2, dplyr, tidyr, readr, stringr and magrittr make it feel
like working in a different, more usable language. The amazes me because
almost all were created by one person - [Hadley Wickham][].

[hadley wickham]: http://had.co.nz/

## Development environment

My development workflow is centred around using my `~/.dotfiles` running on Mac
OSX. I use vim as my editor, tmux for a window manager and zsh as the shell. I
love using vim and I think I wouldn't have had such a enjoyable career so far
if I hadn't picked it up, and then subsequently spent the time tuning and
tweaking it. A good habit I've gotten into is to consciously notice pain points
when I'm coding and try to create a shell or editor shortcut to address it. I
first created my [dotfiles repository][dot] 7 years ago and it has over 1,000
commits on it since then. I've since found Tim Pope's [vim sensible][vim], and
cleared out many of my vim settings in favour of these sensible defaults.

[vim]: https://github.com/tpope/vim-sensible
[dot]: https://github.com/michaelbarton/dotfiles

I try to automate everything as much as possible. I hate doing manual tasks
more than a couple of times. Being forced, such as by infrastructure or
tooling, is something that I find the most annoying. As an example of
automation, I have a script called [gitme][] which clones a git repository,
switches to the last committed git branch, splits and arranges tmux windows,
bootstraps the project as I describe below, and finally starts an autotesting
script. This script allows me to pull and immediately start working on a cloned
project.

[gitme]: https://github.com/michaelbarton/dotfiles/blob/master/bin/gitme

## Focus

Trying to focus and avoid distractions is very important to me. I feel that an
unbroken period of 3-4 hours is very valuable for working on projects. I try to
make the most of these periods and what I've felt has worked for me:

- The [self control app][app] is excellent. This allows you to block a list
  of websites for a set period of time, and there's no way to unblock them
  until the time is up. I use this to block email, twitter and hacker news.
  Twitter and email are terrible distractions to getting anything done.

- Getting up very early. I built [nucleotid.es][] by getting up at 6am every
  morning for about 6 months. An average of 2-3 hours of time everyday
  allowed me to create the prototype site to prove that this could be useful.
  These hours in the morning feel like my most productive and usually there's
  no one else awake to interrupt you.

[nucleotid.es]: http://nucleotid.es/
[app]: https://selfcontrolapp.com/

## My computer is a cache of what I'm working on

I am very strongly in favour of developer parity. This is the idea that my
development, staging and production environments should all be identical. For
example if something works when I test it on my laptop and then fails when I
test it on the server then my environments are not identical. I want developer
parity so that I can spend my time improving code rather than debugging
differences between environments.

To this end, I treat my laptop as a cache of what I'm working on. I have a
launchctl script that deletes and then recreates the directory `~/cache` every
time I turn my laptop on. Any projects I `git clone` into this directory will
be purged at the end of the day. This therefore forces me to push feature
branches and tidy up my projects before I finish for the day.

As a result of this all my development projects now contain all their own setup
and configuration. Each project includes a command to be able to bootstrap all
the resources required to start work on it. Examples of this are using
virtualenv to set up third party libraries, or fetching a set of S3 resources
for a website.

Most importantly this bootstrap command is the same for developing on my
computer, deploying on a server, or running on the continuous integration
server. This means that if it works on my computer it _should_ work everywhere.
If it doesn't then I get email immediately for the CI server that something has
has been broken.

## Every project I work on has the same development CLI

I structure all my projects the same way where they all have the same named
scripts that perform similar actions. These are located in the directory
`./script` and are as follows:

- **bootstrap**: all initial setup required the first time after cloning a
  project. This might be downloading data from S3 or setting up third-party
  libraries with bundler or cabal. After running this script I should be able
  to run or build this project.

- **test**: run unit tests on the code. Pretty straight forward as you
  expect. These are all the tests I run to help me develop, i.e. catching
  individual breaking changes to the code as I write them. This should a
  return a non-zero exit code if the tests fail.

- **feature**: run features tests, usually in cucumber, to test the user
  facing interface of the project. This should catch any changes that break
  the stack as a whole. Increasingly as I create micro services using docker,
  I'll rebuild the Docker image then run the feature tests against a
  container of this image. This insures and breaking changes to the
  Dockerfile, libraries or code are caught as early as possible.

- **build**: build whatever this project is about: compile a binary, a docker
  image or the set of webpages.

- **autotest**: start a script that watches for any file changes to the code
  then reruns the **test** script. This is extremely useful for seeing
  breaking changes immediately, as you're coding. Tools like inotify make
  this straight forward to set up.

- **autofeature**: the same as **autotest** but runs **feature** instead.
  Again this is very handy for catching breaking changes quickly as long my
  features will run in a few seconds. Even when they don't, I use cucumber
  tags to subset the quick features, or run only the feature file relevant to
  what I'm working on.

The advantage of this is that I know that every project had the same entry
points. Even if I haven't worked on something in years, I know I can clone it,
then bootstrap it and start the autotest script.
