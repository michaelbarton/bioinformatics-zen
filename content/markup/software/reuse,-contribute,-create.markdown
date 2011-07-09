---
  kind: article
  title: Reuse, contribute, create
  created_at: 2009-01-26 00:00 GMT
---
### Use existing code

A quick way to get something done is using code that someone else has already written. Many languages have a bioinformatics specific library, such as [BioPerl][perl], [BioJava][java], [BioPython][python], or [BioRuby][ruby]. These libraries have functions for many common tasks, such as reading Fasta files, or parsing BLAST results.

One reason to use an existing library over writing your own code is saving time. These libraries are also mature and tested, which means the chance of a bug is much less.  If you're unable to do something in particular and can't find an answer in the documentation, asking a question on the mailing list will usually result in a suggestion of where to look.

### Contribute to existing code

The more specific your requirement the less likely an existing solution. In this case you'll need to create the necessary fix yourself. After coding something up, being a generous person you will want to contribute the code to a bioinformatics library. This might mean a little work, but by contributing you can save other people time with the same problem.

Contributing code first requires getting the library source code using whatever version control system (VCS) the code is managed with. This can be difficult if you're never used a VCS before, but is a good change to learn. Once you've got the library you'll need to add your own code, as well as some documentation, and usually a few tests.  After this you'll need to send your update back via the VCS, or submit a patch to the mailing list.

### Create new code

Creating a new library should be a last resort, but sometimes the function you want doesn't fit with any existing libraries. Why is creating a new library a last resort? Because it takes more work than adding to an existing library. Having said that, creating a new library does have benefits, as packaging your code makes it is easier to maintain and use across your own projects. Taking the time to share your code with other people also makes you a good person.

Smaller and simpler is better when creating a new library. The simpler the library, the easier it is for others to use, and for you to maintain. Use a version control system to keep track of changes to the code, [git][git] is a good choice. Document the code, and create some web pages highlighting how the library is used. Develop unit tests so that you can make sure the functionality remains the same whenever changes. Make the code open source so that anyone else can contribute. Finally host the library somewhere so that people can get access. There are usually specific resources for each language, for instance in Ruby there is [Rubyforge][forge] or [Github][gh].

This sounds like a lot of work, which is why simpler and lighter libraries are easier is to maintain. The process of creating a new library is a rewarding itself, but also has benefits. Other people may like your library and decide to contribute or fix any bugs. Therefore if you use the library regularly yourself, the investment in creating and maintaining a library will feed back into your own work.

[perl]: http://www.bioperl.org/wiki/Main_Page 
[java]: http://biojava.org/wiki/Main_Page
[ruby]: http://bioruby.open-bio.org/
[python]: http://www.biopython.org/wiki/Documentation
[git]: http://git-scm.com/
[forge]: http://rubyforge.org/
[gh]: https://github.com/
