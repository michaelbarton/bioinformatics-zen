---
  kind: article
  title: Simple command-line clojure scripts
  created_at: "2012-03-13 05:00 GMT"
---

You can write short command line scripts in clojure as you would in any other 
scripting language. The information on how to do this is however a little hard 
to find, where much of the documentation I found through Google suggests using 
the `java` command with a call to `clojure.main`. See here for documentation on 
using the [REPL and main](http://clojure.org/repl_and_main)

Below is a simpler example made possible through the `clj` shebang and the CLI 
arguments stored in the `*command-line-args*` var. This script prints the first 
argument. Make sure to `chmod 755` so you can call this like any other script.

<%= highlight %>
    #!/usr/bin/env clj

    (println (first *command-line-args*))
<%= endhighlight %>
