---
tags: post
feed: false
title: Software development, the happy path, and confirmation bias
date: 2016-10-06
---

The "happy path" in software development describes designing software for
scenarios where everything goes as expected. The user provides the data in
exactly the right format, the incoming message body doesn't contain any unusual
characters, no two processes ever try to update the same database field at the
same time. The term "happy path" is used derogatorily - the implied meaning is
the team behind the project are guilty of intellectual laziness - if they had
just done their homework and thought about the problem this wouldn't have
happened.

I've recently read two books that I found extremely interesting and exposed me
to this topic for the first time: Black Box Thinking, and the Field Guide to
Understanding Human Error. One of the messages expressed in both of these books
is that identifying the causative error is easy to do hindsight but difficult
in foresight. An analogy, paraphrased from black box thinking, would be a
hypothetical plane crash due to fuel running out:

- **hindsight**: The pilot was obviously to blame for the crash. The fuel was
  slowly running out and they took no action. The black box recorded that the
  warning light coming on to warn them that the fuel was almost gone and they
  took no action to rectify it. The pilot is obviously negligent was not
  paying attention.

- **foresight**: The plane was at the same time experiencing a problem with
  the landing gear and the pilot was trying to resolve if the landing gear was
  deployed or not. The copilot assumed the pilot knew what he was doing so
  wasn't sure if they should mention the fuel situation. The pilot lost track
  of time trying to resolve one problem and by the time the engines started to
  stall it was already too late.

The first scenario might first seem far fetched and contrived however how many
times have we assumed the reason another project was delayed or buggy was
because the team working on it was simply "stupid" or "incompetent"? I think
that in many situations this is the real intellectually laziness. This is
"confirmation bias" we look for reasons that confirm what we already think - we
are good developers or scientists and we would never make these kind of
mistakes or have these kind of problems. However it's easy to blame and make
these kind of generalisations about other people's competency, but for the team
responsible for the project there may have been a tight deadline, changing
requirements, a lack of developers, or that the underlying assumptions were
wrong. All of these reasons can cause a project to have problems but tend to be
much hard to explain compared with simply blaming.

After reading both of the books I mentioned above, I believe if you really care
about developing good software or about doing good research resorting to
blaming is unacceptable. Instead if we care about learning from our mistakes we
must always ask why the problems happened. We must dig down into what went
wrong, learn from it and update own processes. Terms like "stupid" or
"incompetent", or "these things sometimes happen" means that we'll never learn
from our own, or others mistakes and therefore never improve.

## Addendum

What I've written so far is very hand-wavy so here so here are what I think are
some actual concrete suggestions you could try for a research or software
project:

- [Do a project pre-mortem][mortem], before starting a project gather
  everyone involved or even do this by yourself if it's just you. Assume the
  project has gone disastrously wrong and failed, then ask everyone to give
  one reason why this happened. This helps overcome confirmation bias, map
  out possible risks, and then adjust the project for these risks
  accordingly.

- Write the edge cases and failure scenario tests first. It's tempting to
  write the unit and feature tests for the "happy path" first. Listing all
  the possible failure modes for the given piece of code and then writing all
  the unit tests for these first should help overcome confirmation bias and
  the temptation to write tests for the assumed perfect scenario.

- Do experiments to try and disprove your hypotheses. My intuition (which I
  have no data to back up) is that the current funding and publication crunch
  pushes scientists to perform experiments to confirm rather than contradict
  their hypotheses. This is the definition of confirmation bias, and stunts
  scientific learning because we only look for what we want to find. The NY
  Times has a [great interactive article on explicitly this][nytimes].

[nytimes]: http://www.nytimes.com/interactive/2015/07/03/upshot/a-quick-puzzle-to-test-your-problem-solving.html
[mortem]: https://hbr.org/2007/09/performing-a-project-premortem

I'd also recommend a couple of really exceptional books related to the topics
which I've only been able to briefly cover in a blog post. I found these all
excellent reads:

- [Black box thinking][bbt]
- [Peopleware][ppl]
- [The field guide to understanding human error][field]
- [Thinking fast and slow][tfas]

[bbt]: https://www.amazon.com/dp/B00SI0B8XC
[ppl]: https://www.amazon.com/Peopleware-Productive-Projects-Teams-Second/dp/0932633439
[field]: https://www.amazon.com/Field-Guide-Understanding-Human-Error/dp/0754648265
[tfas]: https://www.amazon.com/dp/B00555X8OA/
