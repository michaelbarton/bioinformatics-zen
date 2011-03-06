---
  kind: article
  created_at: 2009-02-03 00:00 GMT
  title: Why write good software
---
Bioinformatics is far from commercial software development. A bioinformatician's goal is developing novel scientific research or tools. A software developer is judged on delivering software that people will pay to use. A biologist, whether they use Perl, a pipette or both, is evaluated on their publication record.

In bioinformatics, or any science using a computer, software development is a lesser priority than generating new data. Statistical tests for significance outweigh software testing for reliability. A series of Python scripts for interpreting Chip-chip data are a bioinformatician's tools; what is important is the publishable prediction of binding sites.

Compare this with commercial software development, for example development of a hotel online line booking system. The developer talks to the hotel to understand the job. A good developer keeps regular meetings with the hotel, to update the project based on the customer's requirements. The developer maintains the code using common development practices: [unit testing][unit], [automated building][build], and [source control][source].

The situation in bioinformatics is different; a hypothesis is made, implemented, and tested. There are no best practices. Methods of research range from a directory of BLAST results with an Excel spreadsheet, to a full application stack with a database backend, revision control, and unit tests. The choice depends on the bioinformatician's knowledge and experience.

Is good software important for bioinformatics? Either end of the above scenario is rare, and a middle approach is a set of flat files, Perl scripts to parse out required rows, with R scripts to plot the results. If the tools work does the method matter?

Receiving peer review on a manuscript is comparable to getting feedback on delivering a product to a customer. Instead of new feature requests, changes are required as new analyses or the addition of a new data set. Feedback from reviewers is only received after months of work, when the software is developed and mature. The same principles that apply for commercial software can apply for scientific software. Investing 10% extra time in developing versatile and maintainable code saves time later when large changes are required.  Using version control is a safety net for making changes to existing code. Unit testing ensures fewer bugs. Automated building makes execution of linear tasks easier. A database enables easier manipulation of large complex data.

[fisher]: http://en.wikipedia.org/wiki/Fisher%27s_exact_test
[unit]: http://en.wikipedia.org/wiki/Unit_testing
[build]: http://en.wikipedia.org/wiki/Build_Automation
[source]: http://en.wikipedia.org/wiki/Revision_control
