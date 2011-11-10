--- 
kind: article
title: "BioRuby and Ruby on Rails: Active BioRecords"
category: misc
created_at: "2008-03-06 19:38:55"
---
A common practice in any computationally based field is writing code where the intended functionality has already been produced by someone else. This is usually called reinventing the wheel. This isn't very useful since you're spending time on an intermediate step, when instead you can use existing code and jump ahead to the next step in your research. Of course, it's easy for me to shout bad practice on my blog, but I'm the worst person for doing this. I work in bioinformatics because I like writing code to solve problems, and my first response is to start coding, rather than look to see if someone has created a solution already. On the other hand, the benefit of using existing libraries is that you can build new things on what has already been done.

<!--more-->
<h4>BioRuby on Rails</h4>
During my research I've been trying to programmatically get EMBL files from the EBI database. I saw <a href="http://nsaunders.wordpress.com/2008/01/14/rapid-command-line-access-to-the-pdb/">Neil's post on accessing PDB files directly over HTTP</a>, and there is also <a href="http://www.ebi.ac.uk/cgi-bin/dbfetch">a similar method for the EBI</a>. I thought it would be interesting to combine this with Bio::EMBL so that I can instantiate a BioRuby EMBL object just by calling a method with the required accession.
<pre lang="ruby">
  def self.fetch(id)
    uri = 'http://www.ebi.ac.uk/cgi-bin/dbfetch?db=EMBL&amp;id=' + id.downcase + '&amp;style=raw'
    embl = Bio::EMBL.new(open(uri).read)
    return embl
  end</pre>
This has a short coming, where downloading each EMBL record takes a couple of seconds, and is therefore slow for repeated use. This lead me to thinking about ways I could store the the object after it has been downloaded once, then reload it every time it's called again in future. ActiveRecord, part of Ruby on Rails, is useful for storing objects in database.
<pre lang="ruby">
require 'rubygems'
require 'bio'
require 'open-uri'

require 'active_record'

class ActiveEMBL &lt; ActiveRecord::Base

  serialize :embl_obj

  def after_create
    self.embl_obj = ActiveEMBL.fetch(self.accession)
    save
  end

  def self.get(embl_id)
    ActiveEMBL.find_or_create_by_accession(embl_id)
  end

  private

  def self.fetch(id)
    uri = 'http://www.ebi.ac.uk/cgi-bin/dbfetch?db=EMBL&amp;id=' + id.downcase + '&amp;style=raw'
    embl = Bio::EMBL.new(open(uri).read)
    return embl
  end
end</pre>
The ActiveEMBL class inherits from ActiveRecord::Base, and the Bio::EMBL object is stored as an attribute. The get method calls ActiveRecords's dynamic find_or_create_by method, which returns the corresponding method if it exists, or creates a new one if it doesn't. If a record is created, the after_create method is automatically called which then calls the fetch method, and saves itself with the created Bio::EMBL object. The storing of the Bio::EMBL object is also taken care of by ActiveRecord when I declare in the first line that it should be serialised. The only other thing I have to do is create a table called active_embls and make sure it has three columns: id , accession, and embl_obj.

Ruby benchmarking can be used to show the difference in time between when the file downloaded the first time, and then again when it's reloaded from the local database.
<pre lang="ruby">
  require File.dirname(__FILE__) + '/active_embl.rb'
  require 'benchmark'
  include Benchmark

  ActiveRecord::Base.establish_connection(
    # Database connection details
  )

  id = 'J00231'

  bmbm(10) do |x|
    x.report('fetching') { ActiveEMBL.get(id) }
    x.report('loading') { ActiveEMBL.get(id).destroy }
  end</pre>
This shows a substantial difference in running time between the two.
<pre>
                user     system       total      real
fetching    0.030000   0.010000   0.040000 ( 2.561105)
loading     0.000000   0.000000   0.000000 ( 0.001548)</pre>
The only problem that the Bio::EMBL object is a composite attribute, and so the Bio::EMBL methods are not directly accessible from the ActiveEMBL class, and instead must be accessed via the composite.
<pre lang="ruby">
  embl.embl_obj.sequence # 'ATG...'</pre>
This isn't very elegant, as I want to treat the ActiveEMBL object as a BioRuby EMBL object. I could write aliases for all the method, but an easier way is to just to use Ruby's meta-programming ability to direct all the Bio::EMBL object method calls to the EMBL obj first.
<pre lang="ruby">
  alias original_method_missing method_missing

  def method_missing(meth,*args)
    if read_attribute(:embl_obj).respond_to? meth
      read_attribute(:embl_obj).send meth, *args
    else
      original_method_missing meth, *args
    end
  end</pre>
The Bio:Ruby EMBL methods can now be called directly. The drawback is that none of the Bio::EMBL object methods have the same name as the ActiveRecord::Base object.
<pre lang="ruby">
  embl.sequence # 'ATG...'</pre>
The code for this is <a href="http://www.bioinformaticszen.com/wp-content/uploads/2008/03/active_embl.rb.txt">here</a>, and its pretty generic and similar approaches to other objects would only need to change the fetch method. A further example could use BioRuby's <a href="http://bioruby.org/rdoc/classes/Bio/Fetch.html">Bio::Fetch</a> code to generically fetch data from any bioinformatics database, and <a href="http://biosql.org/wiki/Main_Page">BioSQL</a> could be used to explicitly represent bioinformatics objects in SQL. This could then be combined with ActiveRecord dynamic finders to create searches by fields something like this.
<pre lang="ruby">
  ActiveEMBL.find_by_sequence_length = 30</pre>
