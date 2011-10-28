--- 
kind: article
title: Why data testing is important in computational research
category: misc
created_at: 2007-12-31 19:33:08
---
 I wrote in a previous post about the <a href="http://www.bioinformaticszen.com/2007/11/good-programming-versus-biological-intuition/">importance of testing in computational research</a>. If youâ€™re developing a piece of software, <a href="http://www-128.ibm.com/developerworks/library/j-test.html">functional testing is essential</a>. However, we bioinformaticians donâ€™t just develop software, we also have to develop conclusions and hypothesis, based on data, as well as code weâ€™ve written. Here is an example of why I think data testing is as equally important as functional testing in research.

Imagine you want to see if the structural stability of protein correlates with the number of disulphide bonds. To do this you can create two methods in a Ruby mixin.
<pre lang="ruby">
module CysteineStatistics
  def n_cys
    to_s.downcase.scan('c').length
  end

  def avg_cys
    n_cys / to_s.length.to_f
  end
end</pre>
These two methods can be be mixed into the String class to add the functionality. For the sake of this demonstration Iâ€™m using String, but in reality you would look at adding this to the Bioruby Bio::Sequence class.
<pre lang="ruby">
class String
  include CysteineStatistics
end</pre>
Being a responsible bioinformatician Iâ€™ll write some testing code to make sure that the methods do what I expect.
<pre lang="ruby">
class TestCysteineStatistics &lt; Test::Unit::TestCase

  def test_n_cysteines
    small_sequence = 'AAACAAA'
    assert_equal(small_sequence.n_cys,1)
  end

  def test_avg_cysteines
    small_sequence = 'AAACAAA'
    assert_equal(small_sequence.avg_cys,1.0/7.0)
  end
end</pre>
Again in real life I would probably write a few more tests just to make sure. Both these tests pass though, so the code is doing what I want. Next I write a short script to analyse my set of protein sequences.
<pre lang="ruby">
# Read in each sequence, then print out the average number of cysteines
  CSV.open(out_file,'w') do |csv|
  CSV.open(in_file,'r') {|row| csv &lt;&lt; [row[0], row[1].avg_cys]}
end</pre>
Which gives me a file containing average cysteine count for all my protein sequences. Next I would correlate these values with some structural stability measure Iâ€™ve worked out. Hereâ€™s what the file looks like.
<pre>
1,0.0203291384317522
2,0.0248447204968944
3,0.0388349514563107
.
.
.</pre>
This is fine and I could finish the post here. The point I would like to make though, that in an ideal world this is not the end of the story, and before I move on to the next stage of my research Iâ€™m going to test my data.
<pre lang="ruby">
class TestCysteineStatistics &lt; Test::Unit::TestCase

  # A shortcut method to find the entry in the data file
  def entry(id)
    CSV.open('count.csv','r') {|row| return row[1].to_f if row[0] == id.to_s}
  end

  def test_avg_cysteines_for_2
    assert_equal(0.025,entry(2))
  end

  def test_avg_cysteines_for_3
    assert_equal(0.0392156862745098,entry(3))
  end
end</pre>
What Iâ€™ve done for this script is take two proteins from my original data set and calculate their average cysteine content by hand, then compare this with the calculated value. Running this test produces the following result.
<pre>
Loaded suite test_data
Started
FF
Finished in 0.018369 seconds.

1) Failure:
test_avg_cysteines_for_2(TestCysteineStatistics) [test_data.rb:11]:
&lt;0.025&gt; expected but was
&lt;0.0248447204968944&gt;.

2) Failure:
test_avg_cysteines_for_3(TestCysteineStatistics) [test_data.rb:15]:
&lt;0.0392156862745098&gt; expected but was
&lt;0.0388349514563107&gt;.

2 tests, 2 assertions, 2 failures, 0 errors</pre>
Both tests fail, indicating a difference in what Iâ€™ve written my code to do, and what Iâ€™ve calculated by hand. So where is the error? The problem is Iâ€™ve divided the number of cysteines by the length of the sequence, which in theory is correct. However, when DNA sequence is translated to protein, stop codons are translated and added as a special character â€˜*â€™, meaning that the length of the protein sequence is actually one residue longer than is correct. Something that was not picked up by the code testing, but was by the data testing.

Summary
Code testing will find all the possible errors that you can think of, data testing will find all the errors you donâ€™t. This could seem laborious, and will not be applicable to every situation, <a href="http://www.michaelbarton.me.uk/2007/12/dirty-laundry-in-public/">but can be useful in the real world</a>.

All the code in this tutorial can be found <a href="http://www.bioinformaticszen.com/wp-content/uploads/2007/12/why_data_testing_is_important.tar.gz">here</a>.
