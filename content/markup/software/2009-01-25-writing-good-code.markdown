---
  kind: article
  created_at: 2009-01-25
---
Writing good code makes life easier. If there's a common theme in bioinformatics, it is this: you will write a script, move on to something else, then return to the script in a few months or years time and try to remember how it works. The clearer the code is originally written, the better to remember how it works. Here is a quote ["All programming is maintenance programming, because you are rarely writing original code"][maintain]. This means that most of your time will be spent fixing and improving code, rather than writing fresh. Writing code is personal, and discussing what makes good code is controversial. But I'm going do it anyway and describes what I think are a few basic principles that can help to make code easier to maintain.

### Be too descriptive

I think code should err on the side of being too descriptive, rather than being too concise. I mean that code should be loud and expressive about its purpose. An example is choosing variable names.

{% highlight ruby %}
    # Concise
    seq = File.read('gene.fasta')
    
    # Descriptive
    fasta_gene_sequence = File.read('gene.fasta')
{% endhighlight %}

The second example is longer, but leaves no doubt as to what the variable contains. The same can be applied to method names. The more specific a method name the better to remember the function and what is returned.


{% highlight ruby %}
    # Concise
    def get_seq(file)
      # ...
    end

    # Descriptive
    def read_fasta_from(file)
      # ...
    end
{% endhighlight %}

Next are magic numbers, numbers that appear in code, but have no explanation to their meaning. These can particularly annoying if you can't remember why you used the number and there is no other reference to it.

{% highlight ruby %}
    # Three, its the magic number
    dna_sequence.scan(3)

    # Descriptive
    nucleotides_per_codon = 3
    dna_sequence.scan(nucleotides_per_codon)
{% endhighlight %}

Comments never hurt either, as long as they are correct. Incorrect comments are generally not considered useful. Comments are especially useful when the meaning of the code is not obvious, but going too much commenting can sometimes make code less easy to read

{% highlight ruby %}
    # Why the chop?
    protein = dna_sequence.translate.chop

    # Some of wikipedia in here...
    # In the genetic code, a stop codon (or termination 
    # codon) is a nucleotide triplet within messenger RNA
    # that signals a termination of translation. Proteins 
    # are unique sequences of amino acids, and most 
    # codons in messenger RNA correspond to the addition
    # of an amino acid to a growing protein chain, stop
    # codons signal the termination of this process,
    # releasing the amino acid chain.
    # Here I am removing the stop codon after translation
    protein = dna_sequence.translate.chop

    # Remove the stop codon after translating
    protein = dna_sequence.translate.chop
{% endhighlight %}

Try to follow the indentation guidelines for the language you're writing in. Indentation makes code easier to read for you and anyone you share the code with.

### DRY

DRY means don't repeat yourself. Code for a single function should exist in a single place. When code needs fixing or maintaining, it only needs to changed once in the one place that it resides. In the short term it's tempting to copy and paste to save time, but this will be time consuming in the long term when debugging.

For example a common function such as system specific BLAST settings, used across a variety of scripts can be kept in a single file. The can then be called by any script when required. By moving all the common code to a single file, if the BLAST settings change, this is done in just one place.

### Books and frameworks

When I used Java, Joshua Bloch's [Effective Java][effective] book helped me learn a great deal about how to programme well. When learning Ruby I found the [Ruby Way][way] book had many useful examples of how to write in Ruby. I might guess for any popular programming language there is a respected book that illustrates the best practices in the language. These are not the most useful if you're just starting to learn the language, but as you get more confident they are great for helping to write better, more maintainable code.

In addition to good books, examples of the best practices in a language can be found in popular open source libraries. [Rails][rails] is a Ruby framework for creating dynamic website. Knowing Rails will come in handy if I ever need to create an interactive website, but practising with Rails also gives an opinionated view of the best way to organise a Ruby project, from people who are experienced in creating them.

### Further reading

 * [How to write maintainable code](http://seanskti.wordpress.com/2006/10/08/six-easy-tips-for-more-maintainable-code/)
 * [Twelve steps to better code](http://www.joelonsoftware.com/articles/fog0000000043.html)
 * [Strategies for commenting code](http://particletree.com/features/successful-strategies-for-commenting-code/)
 * [Common types of bad design](http://sourcemaking.com/antipatterns/software-development-antipatterns)
 * [How to write unmaintainable code](http://www.freevbcode.com/ShowCode.Asp?ID=2547)

[maintain]: http://www.artima.com/intv/dry.html
[effective]: http://java.sun.com/docs/books/effective/
[way]: http://rubyhacker.com/
[rails]: http://rubyonrails.org/
