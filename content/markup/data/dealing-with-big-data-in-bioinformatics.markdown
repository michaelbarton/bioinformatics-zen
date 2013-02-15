---
  kind: article
  title: Dealing with big data in bioinformatics
  created_at: "2009-10-22 00:00 GMT"
---

Bioinformatics usually involves shuffling data into the right format for
plotting or statistical tests. I prefer to [use a database to store and format
data][database] as I think this make projects easier to maintain compared with
using just scripts. I find a dynamic language like Ruby and libraries for
database manipulation like [ActiveRecord][ar] makes using a database relatively
simple.

Using a database however stops being simple when you have to deal with very
large amounts of data. Here I'm outlining my experience of analysing gigabytes
of data with millions of data points and how tried to improve my software's
performance when manipulating this data. I've ordered each approaches with I
think is the most pragmatic first.

## The simple things

Obvious but sometimes overlooked.

### 1. Use a bigger computer

Using a faster computer might seem like a lazy option compared with optimising
your code, but if the analysis works on your computer it should work the same,
but faster, on a more powerful computer. Using a faster computer is probably
one of the few things I tried which which didn't involved modifying my code and
therefore shouldn't introduce any bugs. I used unit tests to make sure the code
still worked as expected though.

### 2. Add database indices

Since I'm using a database, making sure it runs as fast as possible is another
cheap way to improve performance. Properly indexed database columns reduce
running times when searching or joining tables as an index means rows are
looked up much faster. Database indices are also relatively easy to implement,
just specify which columns need to be indexed either using SQL or in my case
using [ActiveRecord][ar_index].

### 3. Use a faster language interpreter

Most of the time the standard version of ruby is sufficient for running my
code. In last two years though different but faster versions have been created
such as [REE][ree], [JRuby][jruby] and [Ruby 1.9][ruby19]. Therefore when I was
encountering long running times from processing millions of database rows I
thought it was worth trying a faster Ruby version. I use Ruby 1.9 and it did
improve performance. One caveat though was that I had to make my code
compatible with the newer version [specifically for the CSV library][csv].
These code changes were still relatively cheap to implement given the
noticeable performance benefits.

## Delete stuff

After the above three points I generally had to start digging around in my code
- which is bad because changing working code usually creates broken code. A
good way to optimise code, without introducing too many new problems, is just
to delete it entirely.

### 4. Delete unnecessary data and analysis

I find that I often generate variables which I think might be useful at some
future time. As you might expect just deleting the code that produces these
variables removes the time required to compute them. More often than not I
never ended up needing the variable anyway.

### 5. Remove database table joins

I'm using a database because usually I want to compare two or more sets of data
and therefore I need to format them in a way that makes them comparable. Once
formatted I join each variable in the database and then print the results as a
CSV file.

The problem with joining a large number of database records, even with database
indices, is that it can take a very long time. The amount of time required also
increases the more the [data is normalised][norm]. To try and fix this I found
that I could drop the smaller of two variables I was joining and instead do the
join further into my workflow.

For example I had two variables, the first contained millions of entries each
one corresponding to a protein residue. The second data contained around only
100 entries each one corresponding to one of twenty amino acids. Merging these
two variables in my database required millions of joins and took a long time.
Instead I joined my amino acid data to my protein data after I had calculated
the mean of each protein residue. This reduced the number of joins from a
million down to around 100. I did the join as I plotted it using the [merge
function in R][merge].

## Code optimisation

When I was encountering performance problems I left optimising code as a last
resort. There were three reasons for this, the first is that [premature
optimisation may be the root of all evil][premature]. The second reason reason
is that the enemy of good-enough code is perfect code - when I start optimising
code I tend keep going more than is necessary. Code doesn't need to be as fast
as possible though, just fast enough to get the results I need. The third point
is that optimising code, means changing code, which introduces bugs and so the
more the code is optimised the more chance of bugs. Code optimisation was a
necessity though because my analysis was still taking days to run. I should
also point out that my code optimisation was combined with thorough unit
testing and benchmarking - which I think is usually how it should be done.

### 6a. Batch load database query results

One easy way I reducing running times was by batch loading the database table
rows rather than trying to load a big table all at once. Pulling all the
database records into memory means that most of the running time is spent
loading the data into memory rather than actually dealing with it. Batch
loading instead pulls subsets of records into memory at a time and each subset
is then processed before the next set or rows is retrieved. This means less
less memory is used each time. A example of this in Ruby is [the ActiveRecord
method find_in_batches][batches]. 

### 6b. Association loading

[Association loading][assoc] means that when a row of Table A is retrieved from
the database, that all the rows associated with it in Table B are also
retrieved. This will usually mean that the database is only queried twice, once
to find the records from Table A and once to find the records from Table B. The
alternative option is to use a loop to retrieve each required row from Table B
but this will mean as many database queries as there are rows - and more
queries means more running time.

### 6c. Database querying in loops

I found that large loops which query the database were often the majority of my software's running time. I improved this by instead moving the database calls, up or out of the loops as much as possible and caching rows in memory before hand. This meant the looping code was looking things up in memory rather then querying the database each time. A similar approach can also be used to avoid object creation inside loops which also seems to improve performance. Combining this approach with the one below was what most improved the running time in my analysis.

### 6d. Use raw SQL

Object relational management (ORM) libraries like ActiveRecord allow the
database to be manipulated using object orientated programming which generally
makes using a database a lot easer easier. Using an ORM does however add a
performance penalty because it's an extra layer on top of the database. When I
was doing millions of database updates I found that skipping the ORM and
directly using raw SQL contributed to a large saving of processing time. The
advantages of this technique are neatly outlined [by Ilya Grigorik][ilya].

## That's it.

Quite a long post I know. I know code performance is a weighty topic and
probably what I'm outlining here isn't the best way to go about dealing with
large data. I'm there are better ways better technologies to manage large
amounts of data too, e.g. map/reduce or schemaless databases. I'm not a trained
computer scientist or a software engineer, but a biologist and what I've
outlined is what allowed to me to produce the results I need. I'd be happy to
read any further suggestions in the comments though.

[ar]: http://ar.rubyonrails.org/
[database]: /post/using-a-database/
[ar_index]: http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#M001911
[ree]: http://www.rubyenterpriseedition.com/
[jruby]: http://jruby.org/
[ruby19]: http://www.ruby-lang.org/en/news/2009/07/20/ruby-1-9-1-p243-released/
[csv]: http://blog.grayproductions.net/articles/getting_code_ready_for_ruby_19
[norm]: http://en.wikipedia.org/wiki/Database_normalization
[merge]: http://rwiki.sciviews.org/doku.php?id=tips:data-frames:merge
[premature]: http://fetter.org/optimization.html
[batches]: http://archives.ryandaigle.com/articles/2009/2/23/what-s-new-in-edge-rails-batched-find
[assoc]: http://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations
[ilya]: http://www.igvita.com/2007/10/29/boosting-activerecord-performance/
