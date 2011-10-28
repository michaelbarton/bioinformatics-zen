--- 
kind: article
title: "Bioinformatics : use a database for data"
category: misc
created_at: 2007-02-26 15:21:11
---
Previously, I wrote about <a href="http://www.bioinformaticszen.com/2007/02/organising-yourself-as-a-dry-lab-scientist/">organising your file system</a> to make the relationships between files that produce data, and files containing data more descriptive. One of the best tips I've been given, is to store all my data in a database. Regardless of what the data is, or how <a href="http://www.webinknow.com/2006/10/the_gobbledygoo.html">"mission critical"</a>. Here are some reasons to use a database, rather than files, to store your data.

<!--more-->

<strong>Location independent</strong>
You create a perl script that analyses file A. You later move file A. So you have to update your perl script with the new location. What if you've got a perl script that analyses file A, B, C etc. Or if you've moved the file several months ago, and you can't rember which is the one you need.
Instead, if you have everything as tables in a database, you can pull the data, location independently. The database doesn't even need to be on your computer.

<strong>Databases are clean</strong>
Unless they are XML, data files are messy. Missing commas. Too many commas. Blank lines at the end of file. Bizarre header lines. Binary data files are even worse, you'll need a <a href="http://jakarta.apache.org/poi/">library</a> to parse it. Databases on the other hand are consistent - data is always stored the same way. Named columns in a named table. You'll always use the same methods to pull the data. You'll always use the same program to view the data

<strong>Easier to backup</strong>
Obviously you backup regularly. If you use files to store your data, every time you create a new file you'll have to inform your backup application that the file needs to be included. On the other hand, databases can be <a href="http://dev.mysql.com/doc/refman/5.0/en/mysqldump.html">saved</a> into a single text. If you've 5, 10, or 20 tables in your database, everything can still be backed up into one file.

<strong>Relational meaning</strong>
<a href="http://en.wikipedia.org/wiki/Relational_database">Relational data management</a> is a huge topic and I'm not going into detail here. But a simple illustration is table for organisms and a table for sequences. Each sequence can referenced to the originating organism using SQL, and vice versa. A operation that would more difficult if the two data sets were in separate files.

<strong>Where to get started</strong>
I personally use <a href="http://www.mysql.com/">MySQL</a> for my databases. Not for any particular technical reason, but because this is what I was taught using. I know that <a href="http://www.postgresql.org/">PostgreSQL</a> is popular, <a href="http://hsqldb.org/">HSQLDB</a> also. As for tutorials, this <a href="http://audilab.bmed.mcgill.ca/~funnell/Bacon/DBMS/dbms.html">page</a> has a good explanation on different database types.
