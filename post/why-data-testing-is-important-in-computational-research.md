---
feed: false
title: Why data testing is important in computational research
tags: post
date: 2007-12-31
---

As a bioinformatician I don't only develop software I also draw conclusions
and further hypothesis from the results of my code. What follows below is
example of why testing the output data may be just as important as testing
the code that produces it.

### Problem

In this example I want to see if the structural stability of a protein
correlates with the number of disulphide bonds. I start by creating two
methods. The first counts the number of cysteine amino acid residues in a
protein sequence and the second returns the mean number of cysteines
per-residue.

```ruby
module CysteineStatistics

  def n_cys
    to_s.downcase.scan('c').length
  end

  def avg_cys
    n_cys / to_s.length.to_f
  end

end

class String
  include CysteineStatistics
end

```

These two methods are mixed into the String class to give me the required
functionality. As I want to be sure my code is doing what I want I'll write
some test cases.

```ruby
class TestCysteineStatistics &lt; Test::Unit::TestCase

  def test_n_cysteines
    small_sequence = 'AAACAAA'
    assert_equal(small_sequence.n_cys,1)
  end

  def test_avg_cysteines
    small_sequence = 'AAACAAA'
    assert_equal(small_sequence.avg_cys,1.0/7.0)
  end

end
```

Both these tests pass though so I feel confident my code is doing what I
expect. Given that my code works I start to analyse a real set of protein
sequences.

```ruby
# Read in each sequence, then print out the average number of cysteines
CSV.open(out_file,'w') do |csv|
  CSV.open(in_file,'r') {|row| csv &lt;&lt; [row[0], row[1].avg_cys]}
end
```

Which gives me a file containing average cysteine count for all my protein
sequences. My next step may be to correlate these values with some structural
stability measure as part of my research. However if I did this I would be
wrong. Here's why.

```ruby
class TestCysteineStatistics &lt; Test::Unit::TestCase

  # A shortcut method to find the entry in the data file
  def entry(id)
    CSV.open('count.csv','r') do |row|
      return row[1].to_f if row[0] == id.to_s
    end
  end

  def test_avg_cysteines_for_2
    assert_equal(0.025,entry(2))
  end

  def test_avg_cysteines_for_3
    assert_equal(0.0392156862745098,entry(3))
  end

end
```

```
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

2 tests, 2 assertions, 2 failures, 0 errors
```

Here I created a second test suite to take two proteins from my calculated data
and compare the average cysteine content by hand with the calculated value.
Both of these tests however failed. So where is the error? The problem is not
in my code which I unit-tested but instead of my expectations of what the input
data is like.

I've divided the number of cysteines by the length of the sequence which is
what I want. Nevertheless, the error however creeps in because the translated
stop codons are included in the analysed protein sequence. So I think my
proteins sequence looks like this:

```
AMTWVCVLI
```

When each protein sequence contains a '\*' character at the end and is actually
n+1 residues in length and looks like this:

```
AMTWVCVLI*
```

This would meant all of my calculations were off by 1 and the degree of my
error would be inversely proportional to the length of each examined sequence.

Unit-testing therefore found the possible errors I could think of while
individually testing the data found the errors I couldn't think of.
