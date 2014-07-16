---
  kind: article
  title: Continuous, reproducible genome assembler benchmarking
  created_at: "2009-01-26 00:00 GMT"
---

New bioinformatics software is always being produced and published. The
constant stream of new developments makes it difficult to keep track of the
software available for common bioinformatics tasks. An example of this is the
domain of genome assembly where there is already a large number of existing
software.

If you are researching which bioinformatics software to use, it can be
difficult understanding how effective the software is. For example given a new
genomer assembler publication, how can you know how well it will assemble your
data? A publication may include benchmarks however these may not be applicable
to all types data, or may suffer from the authorship bias in the way the
results are presented.

Even if you know which is the best genome assembler for your data, another
question is how easy is it to install? Does the software require complex
dependencies such as language libraries or other third-party software? How easy
is to debug the software if it fails, does it give cryptic error messages? The
poor usability experience of many bioinformatics software can lead to
scientists using the software that their colleagues knows how to use, rather
than what may be the state of the art.

## A registry of assemblers

There is precedent for solving the problem of objective benchmarks for genome
assemblers. These are the Assemblathon and GAGE:

    * The [Assemblathon 1][asm1] and [Assemblathon 2][asm2] aimed to evaluate
      the current state of genome assembly. Sets of genome reads were provided
      to the genomics community and teams were invited to submit their best
      assembly for each. The quality and accuracy of each of the submitted
      assemblies was then evaluated and compared with each other.

   *  The [Genome Assembly Gold-Standard Evaluations (GAGE)][gage] took the
      opposite approach and instead ran several genome assemblers themselves
      against four different read datasets. The results of each assembler were
      then evaluated.

I believe that these objective evaluations are critical for the bioinformatics
community. The development of performance benchmarks, not just for genome
assembly but for all common tasks, helps researchers determine which software
they should be using in their research. I believe that this can be taken a step
further to solve the problems I described above. For instance using genome
assembly again as an example:

  * Create a registry that lists available genome assemblers which is also
    continuously updated as new assemblers become available. This acts as a
    resource which developers can register their assembler with. This then
    allows researchers to browse all available assemblers in the same place.

  * Continuously benchmark the assemblers against reference data. This would
    provide an objective evaluation of each assembler's effectiveness for a
    given data set. Running these benchmarks on a regular cycle allows new
    assemblers to be evaluated and compared against existing benchmarks. This
    allows researchers to select which genome assembler performs best for a
    given type of data, e.g. a low GC content genome.

  * Provide simple installation and configuration of parameters. Each developer
    provides an out-of-the-box version of their assembler that includes
    defaults parameters that works for most common scenarios. The assembler
    should be packaged so that installation is as simple as possible. This
    allows researchers to use an assembler without requiring difficult or
    manual compilation of software.

To this end I created [nucleotides - a registry of genome assemblers and
benchmarks][nuc] with the end of satisfying these goals. This shows, a
currently short, list of genome assemblers. Each of these assemblers is shown
alongside benchmarks resulting from testing against reference read data.
Finally each assembler is packaged within a Docker image allowing simple
installation of each one.

## Reproducible genome assembly benchmarks using Docker

An important part of this is that all assemblers are constructed as
[Docker][docker] images. If you are unfamiliar with Docker, an image is
analogous to a list of instructions or blueprint that specifies how an
assembler should be installed and used. If a system has Docker installed, this
blueprint (called a Dockerfile) can be used to install everything required to
get an assembler running. This thereby simplifies installation for an
assembler, each assembler can installed with the `docker pull` command.

If assemblers are packaged up as Docker images using a common API then running
benchmarks against a variety of reference data is much simpler. Each assembler
can be cloned from the repository and run against test data. The output of the
assembler can then be compared against the reference genome using [quast][] to
provide a benchmark. These benchmarks are the homepage of [nucleotid.es][nuc].
Eventually, by running against a variety of test datasets, this site will
provide a way to see which assembler performs best for each kind of data.

[asm1]: http://www.ncbi.nlm.nih.gov/pubmed/21926179

[asm2]: http://www.ncbi.nlm.nih.gov/pubmed/23870653

[gage]: http://www.ncbi.nlm.nih.gov/pubmed/22147368

[nuc]: http://nucleotid.es

[lxc]: https://linuxcontainers.org/

[docker]: http://www.docker.com/

[quast]: http://www.ncbi.nlm.nih.gov/pubmed/23422339
