--- 
kind: article
title: Three libraries and a tool to enhance your bioinformatics coding
category: misc
created_at: 2007-03-30 12:32:21
---
Coding is fact of life for bioinformatics. If you work in bioinformatics you probably enjoy coding to some extent. It's our equivalent to PCR, western blots and sequencing. So whether your weapon of choice is Java, Perl, Python or C++, here's three packages and a tool worth a look.

<!--more-->

<strong>Logging</strong>
The most common way to debug a script/application is to include statements that print out the state of a variable. When the variable is not what you expect, this is where the problem is. After all the bugs have been corrected, these print statements are removed, as they are not part of the end product.

Logging takes a different approach. Logging statements are included in the code in the same way as print statements. The difference, however, is that each has a priority. For example DEBUG, INFO, WARN, ERROR, FATAL. Setting log priority to WARN, usually in a config file, will only print the WARN, ERROR and FATAL statements. DEBUG and INFO are a lesser priority than WARN and therefore ignored.

The reason I use logging is so that can liberally scatter DEBUG logging statements, turn them on when there is a problem, then turn them off when it's fixed. Better than adding and deleting lots of print statements.

Examples : Java - <a href="http://logging.apache.org/log4j/docs/index.html">log4j</a>, C++ - <a href="http://logging.apache.org/log4cxx/">log4cxx</a>, Perl - <a href="http://log4perl.sourceforge.net/">Log4perl</a>, Python - <a href="http://docs.python.org/lib/module-logging.html">logging</a>

<strong>Unit testing</strong>
The consequence of in house bioinformatics programs not doing what you expect has recently been in the <a href="http://boscoh.com/protein/a-sign-a-flipped-structure-and-a-scientific-flameout-of-epic-proportions">news</a>. You hope that your program does what you expect, but how do you know for sure? By using unit tests.

A unit testing approach creates a set of routines/methods that test to make sure your program performs as it should. Once these are written you can write your code to the specifications of these tests. If the code doesn't do what you intended, you'll get a message when you run the tests. Even better when in the future you change or add to code, these unit tests will still check it does what you originally intended.

Examples : Java - <a href="http://junit.org/index.htm">Junit</a>, C++ - <a href="http://cppunit.sourceforge.net/cppunit-wiki">CPPUnit</a>, Perl - <a href="http://perlunit.sourceforge.net/">PerlUnit</a>, Python - <a href="http://pyunit.sourceforge.net/">PyUnit</a>

<strong>Object relational mapping</strong>
I think one of the best tips in bioinformatics is to <a href="http://www.bioinformaticszen.com/2007/02/bioinformatics-use-a-database-for-data/">use a database to store all of your data</a>. Accessing a database inside code is often rather cumbersome though, requiring some rather unwieldy generation of SQL statements and an <em>ad hoc</em> knowledge of databases. Enter object relational mapping.

ORM negates the need for these rather ridiculous "in code" SQL statements. Instead every row in a database is treated as an object, and each field or variable of the object is a column entry. Therefore rather than hard coding SQL statements you can create an object for each database entry, and the ORM package will take care of the rest, running the SQL and updating the database in background.

You still need a basic knowledge of relational mapping and databases but ORM takes the drudgery out of using a database in computer programs. I switched to using ORMs a couple of months ago and never looked back.

Examples : Java - <a href="http://www.hibernate.org/">Hibernate</a>, C++ - <a href="http://sourceforge.net/projects/open-orm/">OpenORM</a>, Perl - <a href="http://search.cpan.org/dist/Rose-DB/">Rose::DB</a>, Python - <a href="http://sqlobject.org/">SQLObject</a>

<strong>Automated building</strong>
Not a library or package, but a great way of chaining a set of commands together. For example compile a set of source files. Package them up. Run unit tests. Send logging statements to a specified file, then export them to a web page. Automated building usually becomes more important, the larger the project. But anywhere you repetitively use the same set of commands, it comes in handy. I even use automated building to compile my LaTeX documents. But maybe that's a bit too much geekery!

Examples : Java - <a href="http://ant.apache.org/">Ant</a>/<a href="http://maven.apache.org/">Maven</a>, C++ - <a href="http://www.gnu.org/software/make/manual/html_node/index.html">make</a>, Perl - <a href="http://search.cpan.org/~nkh/PerlBuildSystem-0.35/">PerlBuildSystem</a>, Python - <a href="http://sourceforge.net/projects/pybuild">Scons</a>
