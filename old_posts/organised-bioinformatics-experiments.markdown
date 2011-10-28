--- 
kind: article
title: Organised bioinformatics experiments
category: misc
created_at: 2008-05-24 18:43:04
---
One of the things Iâ€™ve found in two years of doing bioinformatics, is that directories quickly fill up with files, usually data, scripts, and results. Working out the contents of each file is difficult as the only identifier is the name, which with lots of similarly named files, is confusing. Using lots of scripts gets more complicated when there are dependencies. For example scripts need the data from one file, or are dependent on an intermediate set of results from the output of another script. These dependencies mean that when a set of results needs updating, usually many times when producing a manuscript, scripts need to be re-run in the correct order. The requirement of manually re-running scripts in a specific order is cumbersome, and easily generates errors.

<!--more-->

A <a href="http://www.bioinformaticszen.com/2007/02/organising-yourself-as-a-dry-lab-scientist/">previous post I wrote</a> tried to address some of these problems by being strict about directory and file naming, however this does not solve dependencies between files. For the last year Iâ€™ve been working with Ruby on Rails, and I think many of the techniques used in this framework are also applicable to bioinformatics experiment structuring.
<ul>
	<li>Always use a database and object relational management library for data, not flat files</li>
	<li>Use a single Make-type file in each directory, instead of many scripts</li>
	<li>Put code related to data in models, put analysis code in make-like tasks</li>
	<li>Use validations and testing to verify data and code</li>
</ul>
<h4>Use a database and object relational management system</h4>
My first point is the most important, and the one that has made my work much easier. Without exception, <a href="http://www.bioinformaticszen.com/2007/02/bioinformatics-use-a-database-for-data/">always use a database to store data</a>. Manipulating flat files in scripts is hard work, and is also a source of bugs. The only time I open a flat file, is to load the contents into a database. A database is allows you to access data in a standard format, in the same way, every time. The alternative is to have lots of little snippets of code to manipulate different flat file formats, then link each dataset with hashes and arrays: messy and very hard to maintain if new datasets are added.

Databases are useful but the language to access them (SQL) has a steep learning curve. Object relational management libraries (ORM) allow you to access a database using <a href="http://www.bioinformaticszen.com/2007/03/three-libraries-and-a-tool-to-enhance-your-bioinformatics-coding/">an object orientated approach in the language you are familiar with</a>. SQL is still useful for creating complex joins between different datasets, but unless you have to use SQL, use ORM instead, and the library takes care of all the SQL for you. Hereâ€™s and example, with out a single line of SQL, using <a href="http://datamapper.org/">Datamapper</a>, the Ruby ORM library.

The first block of code defines the link between the database table and the Ruby class. The name of the class (Gene) corresponds to the table (genes). The properties (name &amp; sequence) correspond to columns in the table, and get/set methods for the object.
<pre lang="ruby">class Gene &lt; DataMapper::Base
  property :name,      :string
  property :sequence,  :text
end</pre>
Using this class, data can be manipulated using object oriented programming, making the code more readable. Even if youâ€™re not familiar with Ruby I think the below code is simple and easy to understand, which would not necessarily be the case for hard-coded SQL statements.
<pre lang="ruby"># Create object using accessors
gene = Gene.new
gene.name = 'ALS2'
gene.sequence = 'ATG...'
gene.save!

# Search and get an array of
# records matching a specific criteria
genes = Gene.all( :name =&gt; 'ALS2' )

# Delete the first record in this array
genes.first.destroy!</pre>
<h4>Use make-type files instead of scripts</h4>
As I start doing some bioinformatics, Iâ€™ll need to write more scripts, and soon Iâ€™ll have a directory full of files. So this brings me to next point, instead of scripts I recommend using make-type files. If youâ€™re not familiar with make files, the best way to explain is with an example.  Hereâ€™s an illustration using the Ruby version of make - Rake. Iâ€™ve created an example set of analyses where instead of each being a script they are instead a task in the Rake file.
<pre lang="ruby">  desc 'Delete all exiting rows'
  task :delete_sequences do
    # Clear the sequence table
  end

  desc 'Load protein sequences into the databases'
  task :load_sequences =&gt; :delete_sequences do
    # Load a set of DNA sequences into my database
  end

  desc 'Calculates statistics for gene sequences'
  task :sequence_stats do
    # Calculate sequence mean and SD.
  end

 desc 'Reset project and repeat all analysis'
 task :rebuild =&gt; [
   :delete_sequences,
   :load_sequences,
   :sequence_stats]</pre>
As the example shows, the characteristic of a Rake file is a set of named tasks that each perform an action. Within these tasks any valid Ruby code can be inserted. Therefore anything I would put in a script can instead be put in a task. Rake also allows me to <a href="http://www.bleedingedgebiotech.com/blog/ruby/a-pipeline-is-a-rakefile/">manage the dependencies</a> between the tasks, so if I need to repeat one set of analyses, the corresponding dependencies are also run. In my example, before my gene sequences are loaded, any pre-existing rows in the database are first cleared. Iâ€™ve also created a task called rebuild that clears all the data project and repeats the analysis from scratch.

Calling â€œrake -Tâ€ at the command line list all the tasks outlined in the file. This is a handy way of keeping track of what all the tasks in your project are doing. This would also be useful for anyone else who was looking at your research.
<pre>rake :rebuild
rake :delete_sequences
rake :load_sequences
rake :sequence_stats</pre>
<h4>Keep data code in models, and analysis code in tasks.</h4>
My next point is to decouple the code that gets data from the database, from the code that analyses it. My reasoning is that you donâ€™t care how the data is retrieved, only that it is as you expect. If I change the way I get sequences from the database, I donâ€™t need to the change the corresponding analysis code as long as it is returned in the expected format. Decoupling the two sets of code, also stops it being repeated. If I need the same data else where, I can access it from the model, without having to cut and paste, which makes code easier to maintain. Hereâ€™s an example for calculating the mean of a set of sequences. The data fetching code is in the Gene class, and manipulation of the data is in the rake task.
<h5>gene.rb</h5>
<pre lang="ruby"> def self.mean_length
   genes = Gene.find(:all)
   lengths = genes.map{|gene| gene.sequence.length}
   lengths.to_statarray.mean
 end</pre>
<h5>analysis.rake</h5>
<pre lang="ruby">desc 'Calculates statistics for gene sequences'
task :sequence_stats do
  File.open('results.txt','w') do |file|
    file.puts "Mean length : #{ Gene.mean_length }"
  end
end</pre>
<h4>Use testing and validations</h4>
The importance of code testing is widely discussed, so Iâ€™m not going to go into detail. Validations however receive less attention, but I believe they can be very important in computational research. The majority of data in bioinformatics has been compiled by a script, and you canâ€™t be 100% sure that the data youâ€™re given is in the format you expect, or even that <a href="http://www.michaelbarton.me.uk/2007/12/dirty-laundry-in-public/">youâ€™re not making mistakes yourself</a>. Validations are a really simple way of making sure that the data is what you expect. Hereâ€™s an simple one line validation that makes sure the DNA sequence is coding, by ensuring that it begins with a start codon, finishes with a stop codon, and contains only valid DNA sequence. I use this in the following method so that any sequences that donâ€™t match this criteria will print an error at the command line, when the data is loaded.
<pre lang="ruby"># Checks that the sequence has a start codon,
# a stop codon, and contains only ATGCs
# and line breaks
validates_format_of :sequence,
  :with =&gt; /^ATG[ATGC\n]+(TAG|TAA|TGA)$/im

def self.create_from_flatfile(entry)

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
end</pre>
<h4>Summary</h4>
Iâ€™ve given some examples on how to use these principles, but they have been very brief. Iâ€™ve implemented a complete example on <a href="http://github.com/michaelbarton/organised_experiments/tree/master">Github</a> so if you are interested how this can be put into practice, pull the repository and take a look. Iâ€™ve done this in Ruby as itâ€™s the language I know, but all major languages have libraries to implement all these techniques, so the <a href="http://network.nature.com/forums/bioinformatics/1611">language you choose</a> is less important than using good programming practices for the task youâ€™re working on.
