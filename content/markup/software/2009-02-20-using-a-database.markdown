---
  kind: article
  created_at: 2009-02-20
  title: Using a database
---
My best recommendation for any computational biologist is to learn to use a relational database with a corresponding object relational mapping system (ORM). This sounds complicated, but doesn't have to be. In bioinformatics, data are distributed as files. Supplementary data are available from journal websites, and a file is easy to attached to an email. The use of data files in programming, however, should be limited wherever possible. A bioinformatics project should instead be built using a database.

Using a database allows all data to be accessed in the same way, whether in a script, at the command line, or through third-party database software. Databases are fast and optimised for searching and joining datasets. Joins between two sets of data that would be difficult when merging two files are made much easier using database relationships.

A simple database workflow first loads all data into the database. Each file usually becomes a table in the database, where each file row is a table row. Analytical scripts make database calls to pull and join different data sets together. Adding indices to a database further increases the speed at which joins are made and data searched.

In contrast using files as the base of the project results in errors when file paths change. Scripts need rewriting if a file format is altered. If the data file has a missing bracket or comma, the resulting script will throw an exception and break. The worst thing about using flat files though, is that they must be parsed and joined at the start of each script. This is repetitive and leads to code duplication across scripts.

### SQL is hard

What I haven't mentioned is that learning to use a database takes time. Understanding how to structure tables and the language to join them together requires effort. Furthermore, writing SQL join statements in scripts requires attaching strings together to create the SQL query, which is complex, hard to maintain, and produces ugly code.

Using object relational mapping (ORM) makes using a database easy and code simpler to write. The phrase "object relational mapping" is jargon for what allows database tables and rows to be treated as in-code variables. Instead of creating verbose SQL statements or reading to the required line in a file, the required data are called in the familiar programming syntax of the language you are used to. This combines the best of efficient data storage, with the language you are skilled in.
