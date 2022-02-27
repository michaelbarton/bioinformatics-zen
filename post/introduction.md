---
tags: post
feed: false
title: Keyboard, command line, and text files
date: 2009-09-09
---

Here I'm outlining an approach to bioinformatics focusing on using three tools:
the keyboard to enter commands, the wide range of functions available at the
command line, and storing data in easily searched and manipulated text files.
The combination of these three can make bioinformatics analysis faster than
using graphical user interfaces (GUIs) because typing into the command line is
faster than clicking buttons and selecting menus with a mouse. A series text
commands is also easier to reproduce and automate than remembering a sequence
of GUI commands.

### The Keyboard

The best reason for using the keyboard is that it's faster to type a command
compared with doing the same thing with a mouse and GUI. If you're using the
keyboard to write code the more you can also use the keyboard for other actions
such as saving the current document the less your "working flow" is broken by
reaching for the mouse. Finally once you know the keyboard shortcuts to do your
work learning to touch type will also make you work faster.

### The Command Line

The command line gives predictable and reproducible results unlike a graphical
interface. A workflow in the command line is easier for someone else to test
and execute than a list screenshots of which buttons and menu items to click.

The Linux command line has a wide variety of tools ranging from interacting
with the operating system to manipulating entries in a text file. Many
bioinformatics applications can also be run at the command line and the benefit
of using the command line version is that sequences of commands can be chained
together. The output of one command becomes the input of the next command to
filter and parse the results. In this way sequences of simple commands can be
combined together to perform more complex bioinformatics analysis. As these
tasks do not require a user with a mouse either they can be performed
simultaneously across multiple machines or scheduled to run overnight.

### Text Files

Binary files in specific formats can usually only be searched and edited by the
program that created them. Plain text files are however open to being searched
or manipulated by any tool or program. Therefore different data text formats
such as CSV, JSON, YAML, and XML can still be searched and edited using similar
command line approaches. Combining the command line with text files makes it
relatively simple to perform simultaneous large searches or manipulations
across many text based files.
