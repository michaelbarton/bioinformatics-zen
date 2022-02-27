---
tags: post
feed: false
title: Organised bioinformatics experiments
date: 2008-05-24
---

One of the things I've found in two years of doing bioinformatics is that
directories quickly fill up with files: data, scripts, results, and so forth.
Remembering the contents of each file is difficult as the only available
identifier is the file path. When there are many similarly named files this
makes remembering the purpose of each file even more difficult.

A second problem with computational workflows is the dependecy between the
output of one script as the input to another. The complexity increases
exponentially as the number of scripts increases. For example: a script needs
the data from a file or is dependent on an intermediate set of results from
the output of another script. These dependencies mean if the ultimate analysis
result needs to be updated then all these scripts need to be re-run in the
correct order. Manually rerunning scripts in a specific order is however
cumbersome and easily generates errors.

A [previous post I wrote][1] tried to address some of these problems by being
strict about directory and file naming, however this does not solve
dependencies between files. For the last year I've been trying Ruby on Rails, a
framework for generating websites. I think many of the techniques used in this
framework are also very applicable to structing bioinformatics experiments.

[1]: /post/organising-yourself-as-a-dry-lab-scientist/

#### Use a database and object relational management system

My first point is the most important, and the one that has made my work much
easier: use a database to store data. Manipulating flat files with scripts is
hard work and a source of bugs. The only time I open a flat file, is to load
the contents into a database. A database is allows you to access data in a
standard format, in the same way, every time. The alternative is to have lots
of little snippets of code to manipulate different flat file formats, then link
each dataset with hashes and arrays: messy and very hard to maintain if new
datasets are added.

Databases are useful but the language to access them (SQL) has a steep learning
curve. Object relational management libraries (ORM) allow you to access a
database using an object orientated approach in the language you are familiar
with. SQL is still useful for creating complex joins between different
datasets, but unless you have to use a specific SQL query, use an ORM instead,
and the library will take care of all the SQL for you. Here's an example using
Datamapper, a Ruby ORM library. (Note: At the time I wrote this post the
DataMapper library had advantages over ActiveRecord. I don't agree with this
anymore however and would recommend using ActiveRecord instead. The examples
below however are still applicable.)

The first block of code defines the link between the database table and the
Ruby class. The name of the class (Gene) corresponds to the table (genes). The
properties (name \& sequence) correspond to columns in the table, and get/set
methods for the object.

```ruby
class Gene < DataMapper::Base
  property :name,      :string
  property :sequence,  :text
end
```

Using this class, data can be manipulated using object oriented programming,
making the code more readable. Even if you're not familiar with Ruby I think
the below code is simple and easy to understand, which would not necessarily be
the case for hard-coded SQL statements.

```ruby
# Create object using accessors
gene = Gene.new
gene.name = 'ALS2'
gene.sequence = 'ATG...'
gene.save!

# Search and get an array of
# records matching a specific criteria
genes = Gene.all( :name => 'ALS2' )

# Delete the first record in this array
genes.first.destroy!
```

#### Use make-type files instead of scripts

As I expand an analysis project I'll need to write more and more scripts
resulting in a directory full of scripts and the correspondingly generated
output. My next point therefore is, instead of using scripts, to use make-type
files. If you're unfamiliar with make files, the best way to explain is with an
example. Here's an illustration using the Ruby version of make - Rake. I've
created an example set of analyses where instead of each being a script they
are instead a task in the Rake file.

```ruby
desc 'Delete all exiting rows'
task :delete\_sequences do
  # Clear the sequence table
end

desc 'Load protein sequences into the databases'
task :load\_sequences =&gt; :delete\_sequences do
  # Load a set of DNA sequences into my database
end

desc 'Calculates statistics for gene sequences'
task :sequence\_stats do
  # Calculate sequence mean and SD.
end

desc 'Reset project and repeat all analysis'
task :rebuild =&gt; [
 :delete\_sequences,
 :load\_sequences,
 :sequence\_stats]
end
```

As the example shows, the characteristic of a Rake file is a set of named tasks
that each perform an action. Within these tasks any valid Ruby code can be
inserted. Therefore anything I would put in a script can instead be put in a
task. Rake also allows me to [manage the dependencies][2] between the tasks, so
if I need to repeat one set of analyses, the corresponding dependencies are
also run. In my example, before my gene sequences are loaded, any pre-existing
rows in the database are first cleared. I've also created a task called rebuild
that clears all the data project and repeats the analysis from scratch.

[2]: http://www.bleedingedgebiotech.com/blog/2008/05/02/a-pipeline-is-a-rakefile/

Calling `rake -T` at the command line list all the tasks outlined in the file.
This is a handy way of keeping track of what all the tasks in your project are
doing. This would also be useful for anyone else who was looking at your
project.

```ruby
rake :rebuild
rake :delete\_sequences
rake :load\_sequences
rake :sequence\_stats
```

#### Keep data code in models, and analysis code in tasks

My next point is to decouple the code that fetches data from the database, from
the code that analyses it. My reasoning is that you don't care how the data is
retrieved, only that it is as you expect. If I change the way I get sequences
from the database, I don't need to the change the corresponding analysis code
as long as it is returned in the expected format. Decoupling the two sets of
code also stops it being repeated. If I need the same data elsewhere, I can
access it from the model, without having to cut and paste, which makes code
easier to maintain. Here's an example for calculating the mean of a set of
sequences. The data fetching code is in the Gene class, and manipulation of the
data is in the rake task.

##### gene.rb

```ruby
def self.mean\_length
   genes = Gene.find(:all)
   lengths = genes.map{|gene| gene.sequence.length}
   lengths.to\_statarray.mean
end
```

##### analysis.rake

```ruby
desc 'Calculates statistics for gene sequences'
task :sequence\_stats do
  File.open('results.txt','w') do |file|
    file.puts "Mean length : #{ Gene.mean\_length }"
  end
end
```

#### Use testing and validations

The importance of code testing is widely discussed, so I'm not going to go into
detail. Validations however receive less attention, but I believe they can be
very important in computational research. The majority of data in
bioinformatics has been compiled by a script, and you can't be 100% sure that
the data you're given is in the format you expect, or even that you're not
making mistakes yourself. Validations are a really simple way of making
sure that the data is what you expect. Here's an simple one line validation
that makes sure the DNA sequence is coding, by ensuring that it begins with a
start codon, finishes with a stop codon, and contains only valid DNA sequence.
I use this in the following method so that any sequences that don't match this
criteria will print an error at the command line, when the data is loaded.

```ruby
# Checks that the sequence has a start codon,
# a stop codon, and contains only ATGCs
# and line breaks
validates\_format\_of :sequence,
  :with => /^ATG[ATGC\n]+(TAG|TAA|TGA)$/im

def self.create\_from\_flatfile(entry)

  gene = Gene.new
  gene.name = entry.definition.split(/\s+/).first
  gene.sequence = entry.data

  if gene.valid?
    gene.save!
  else
    puts "#{gene.name} is not valid sequence "
    # Could raise an error here instead
    # Or even better write to an error log
  end
end
```

#### Summary

I've given some examples on how to use these principles, but they have been
very brief. I've implemented [a complete example on Github][4] so if you are
interested how this can be put into practice, pull the repository and take a
look. I've done this in Ruby as it's the language I know, but all major
languages have libraries to implement all these techniques, so the [language
you choose][5] is less important than using good programming practices for the
task you're working on.

[4]: https://github.com/michaelbarton/organised_experiments/tree/master
[5]: http://network.nature.com/forums/bioinformatics/1611
