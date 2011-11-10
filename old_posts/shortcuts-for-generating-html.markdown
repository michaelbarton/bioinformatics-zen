--- 
kind: article
title: Shortcuts for generating HTML
category: misc
created_at: "2008-06-21 18:16:28"
---
Usually at some point youâ€™ll need to produce some web pages. This could be for a group website, or a page to embed a tool in. Writing HTML is an dull way to spend time, so itâ€™s worth knowing some tools that can make HTML generation easier.
<h3>Markdown</h3>
I use markdown to write blog posts, as itâ€™s just the same as writing plain text but with a few extra markups.
<blockquote># A level one heading

Some normal paragraph text

### Three hashes makes a level three heading

<code>
text = 'this is indented'
text &lt;&lt; 'and so will be marked up as code'
puts text
</code></blockquote>
Converting markdown to HTML will produce the following output.
<pre><code>&lt;h1&gt;A level one heading&lt;/h1&gt;

&lt;p&gt;Some normal paragraph text&lt;/p&gt;

&lt;h3&gt;Three hashes makes a level three heading&lt;/h3&gt;

&lt;pre&gt;&lt;code&gt;
text = 'this is indented'
text &lt;&lt; 'and so will be marked up as code'
puts text
&lt;/code&gt;&lt;/pre&gt;
</code></pre>
Writing in markdown means you donâ€™t have to edit HTML. Instead edit the markdown and proof read the resulting HTML in a browser. An analogy for markdown is a more readable syntax that be â€˜compiledâ€™ into HTML. <a href="http://en.wikipedia.org/wiki/Markdown">The Wikipedia entry</a> lists interpreters for all major languages, and there is  <a href="http://daringfireball.net/projects/markdown/">full listing of the markdown syntax</a>. If youâ€™re interested, you can look at the markdown <a href="http://docs.google.com/Doc?id=ddgtztrv_3265psctvd5">I used to write this blog post</a>, which I run through my <a href="http://michaelbarton.tumblr.com/post/35325392/simple-ruby-markdown-script-using-bluecloth-and">Ruby command line markdown parser</a>.
<h3>Textile</h3>
Markdown is great for creating simple HTML content, but sometimes you might need to create more fully featured content, that might include attributes matching a CSS specification. Textileâ€™s syntax is very similar to that of markdown, but also allows a few extra HTML features.
<blockquote>h2(#with-id). Level Two Heading with attribute

p(custom-class). Paragraph text with some extra markup

|<em>. Table |</em>. Heading |
| Table cell | Table cell |</blockquote>
Produces this HTML.
<pre><code>&lt;h2 id="with-id"&gt;Level Two Heading with attribute&lt;/h2&gt;

&lt;p class="custom-class"&gt;Paragraph text with some extra markup&lt;/p&gt;

&lt;table&gt;
    &lt;tr&gt;
        &lt;th&gt;Table &lt;/th&gt;
        &lt;th&gt;Heading &lt;/th&gt;
    &lt;/tr&gt;
    &lt;tr&gt;
        &lt;td&gt; Table cell &lt;/td&gt;
        &lt;td&gt; Table cell &lt;/td&gt;
    &lt;/tr&gt;
&lt;/table&gt;
</code></pre>
Like Markdown, the Wikipedia entry lists <a href="http://en.wikipedia.org/wiki/Textile_(markup_language)">interpreters for the major programming languages</a>. There is also a <a href="http://hobix.com/textile/">full listing of the textile syntax</a>
<h3>Haml</h3>
If Textile isnâ€™t enough, Haml gives you complete control of HTML generation. The downside is that HAML is less readable than Textile or Markdown, but still much easier to edit and maintain than HTML.
<pre><code>#div-with-id
  %custom-tag with enclosed text
  Some normal text here
  %a{'href' =&gt; 'example.com'} A specific tag with attributes
</code></pre>
Produces this HTML
<pre><code>&lt;div id='div-with-id'&gt;
  &lt;custom-tag&gt;with enclosed text&lt;/custom-tag&gt;
  Some normal text here
  &lt;a href='example.com'&gt;A specific tag with attributes&lt;/a&gt;
&lt;/div&gt;
</code></pre>
Haml uses indentation to know when to enclose tags, see the div added on the last line, which means sensitive to how you use whitespace to indent lines. In addition there are only <a href="http://en.wikipedia.org/wiki/Haml#Implementations">a few interpreters </a> at the moment. The full syntax is described on <a href="http://haml.hamptoncatlin.com/docs/">the Haml website</a>
<h3>A note on templating</h3>
Related to HTML generating is templating, which allows code to be embedded and evaluated in text. Hereâ€™s an example using the Ruby templating library - ERB.
<blockquote>There are &lt;%= Gene.all.length %&gt; protein coding genes in this data set. The data set was downloaded in fasta format from the [SGD ftp server][sgd]. The dataset was last modified on &lt;%= File.stat(â€œdata/yeast<em>protein</em>genes.fasta.gzâ€).mtime %&gt;</blockquote>
The section of text &lt;%= Gene.all.length %&gt; is evaluated as Ruby code and returns the result. The Ruby code is looking at the â€˜geneâ€™ table in my database, finding all the entries, then counting the number of records. Using the <a href="http://datamapper.org/why.html">DataMapper ORM</a>, which <a href="http://www.bioinformaticszen.com/2008/05/organised-bioinformatics-experiments/">I discussed previously</a>, this Ruby code is concise and readable, so it makes it easy to know what this ruby code will return, and therefore makes it easier maintain than raw SQL. The second block of code does some providence to identify when I modified the data file. Running this through ERB then markdown will produce this text.
<blockquote>There are 5883 protein coding genes in this data set. The data set was downloaded in fasta format from the <a href="ftp://genome-ftp.stanford.edu/yeast/data_download/sequence/genomic_sequence/orf_dna/">SGD ftp server</a>. The dataset was last modified on Fri May 09 16:25:27 +0100 2008</blockquote>
