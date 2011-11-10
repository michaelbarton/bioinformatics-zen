--- 
kind: article
title: How to avoid errors when processing CSV files
category: misc
created_at: "2007-11-01 18:44:49"
---
A lot of bioinformatics involves <a href="http://nsaunders.wordpress.com/2007/09/19/where-n-is-an-arbitrarily-large-fraction-approaching-one/">reading data from files</a> to manipulate them for our analysis. For example, I spend a lot of time importing data from CSV files into my database. Doing this involves creating a script to iterate over each line of the file, then referencing each token in the row by its column number.

However this is bad for two reasons. The first reason is because it introduces a dependency on the column number, which may feasibly change. You can fix this by changing the script though, so this is not too bad.

The second reason is much more worse, because it could introduce a silent error. If the column number was wrong, then the wrong entry would be referenced. If correct and wrong entry where both of the same type, e.g. floats, then there is a chance you would miss the mistake, which is very bad.

One approach to fix this is to treat each row as a hash or map. I've laid out two examples in Ruby using the gem FasterCSV. They're quite simple, so you should get the idea whatever language you use, hopefully there are equivalent libraries too.

<strong>Bad example</strong>
<code>
FasterCSV.foreach(file_path) do |row|</code>
<code>
# In this instance the row is an array
# and has to accessed by the column number.
# Bad, because this introduces a dependency
# on the position of the column and doesn't
# throw an error if you are using the wrong column
row[column_number] # Do something here</code>
<code>
end</code>

<strong>Good example</strong>
<code>
#Set the header processing option...
FasterCSV.foreach(data_path, :headers =&gt; true) do |row|</code>
<code>
# ...each row is now a hash, and the
# data can be accessed using a key
row['column_name']
</code><code>
# This is dependent on the column
# name, but not its position.
# Also you will get an error if
# the column doesn't exist and you
# will always reference the column you expect
</code><code>
end</code>

Importantly by using a third party library, you implement another programming best practice which is, <a href="http://www.bioinformaticszen.com/2007/02/reinventing-the-wheel/">don't reinvent the wheel</a>.
