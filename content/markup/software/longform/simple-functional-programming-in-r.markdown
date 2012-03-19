---
  kind: article
  feed: true
  title: Simple functional programming in R
  created_at: "2012-03-19 05:00 GMT"
---

R can be a very unforgiving language at times. Obtuse error messages and a 
variety of similar data types such as vectors, lists, matrices and arrays lead 
to a frustrating learning curve. Furthermore R is a functional programming 
language which if you are used to and imperative approach (e.g. 
Java/Perl/Python/Ruby) can make R seem like a crufty version of Perl for 
statistics.

The functional nature of R however often seems understated in the 
documentation. Myself, when I first started to program in R, I programed as if 
I was writing Java as this was the only other language I knew. This lead to
frustration at the poor object support and the fact I have to create large 
numbers of loops and temporary variables.

I've recently started to learn Clojure begun to appreciate the functional heart 
of R and how it can simplify your code. I might also go as far to say that R is 
almost a lisp dialect but where the key work is on the otherside of the 
brackets. For instance this example is valid R:

<%= highlight %>
sqrt(
  '*'(
    '+'(1, 2),
    3))
#=> 3
<%= endhighlight %>


Having first learnt to program in Java everything I heard about "Functional 
programming" sounded alien and strange. I think this may also be due to 
unhelpful sterotypes associated with functional programming languages as being 
only for academics. I think languages such as Clojure are proving that 
functional programming can be better than an imperative or OO approach at least 
in terms of concise and clear code. However for the point of this I'm not going 
to discuss functional programming any further and instead give some simple 
examples which I hope will speak for themselves.

### Converting a character vector to a binary variable

I have the following vector from a [survey of bioinformaticians][survey] 
describing whether or not each respondent is married or not.

<%= highlight %>
married <- c("Yes","Yes","No","No","Yes","Yes","","No","Yes")
<%= endhighlight %>

What I'd like to do is convert this to a binary variable where `Yes` becomes 
`1` and `No` becomes `0`. Here's how I originally would have solved this 
problem:

<%= highlight %>
binary.married <- c()
for(i in 1:length(married)) {
  if(married[i] == "Yes"){
    binary.married <- c(binary.married,1)
  } else {
    binary.married <- c(binary.married,0)
  }
}
<%= endhighlight %>

The first example will perform poorly when the `married` variable is very long 
the new vector `binary.married` is recreated each time a new entry is 
concatenated onto the end. If you only take one point away from this blog post 
avoid doing using `c` to repeatedly increament and vecter and instead do this:

<%= highlight %>
binary.married <- rep(0,length(married))
for(i in 1:length(married)) {
  if(married[i] == "Yes") binary.married[i] <- 1
}
<%= endhighlight %>

This creates the `binary.married` variable to the required size beforehand and 
the loop then replaces each variable with the binary version of either `Yes` or 
`No`. I initialized the `binary.married` variable with `0`s so I only needed to 
replace those that correpond to `Yes` in the married vector.

Now I think generally loops should be avoided in R. If you find yourself using 
a loop there probably is an easier, and possible faster way to do it. For 
instance:

<%= highlight %>
married[married == "Yes"] <- 1
married[married == "No"]  <- 0
<%= endhighlight %>

This example finds each instance or either `Yes` or `No` and correspondingly 
replaces it. You'll also find that this is a little safer too because only 
instances that match either `Yes` or `No` are replaced and if you look 
carefully at the `married` variable I've defined above one of the responses in 
empty so the above code gives us this:

<%= highlight %>
married #=> c(1,1,0,0,1,1,"",0,1)
<%= endhighlight %>

This will at least throw an error and tell me something is wrong when I try to 
perform a numerical calculation on the data. The looping approach above instead 
would just have replaced the empty response with a 0. This approach while 
better than using a loop quickly becomes unweildy with more factors than just 
`Yes` or `No`. Here instead is they way I think this should be done:

<%= highlight %>
married <- sapply(married,
                  function(x) switch(x, Yes = 1, No = 0, NA))

married #=> c(1,1,0,0,1,1,NA,0,1)
<%= endhighlight %>

Here I'm using an `apply`-family function. These functions perform as you would 
expect and apply a function to element in a vector/list/matrix depending on 
which function is used. Neil Saunders has [an exellent overview of the 
functions in the apply family.][neil] The above example applies the same 
funtion to each element in the married vector. I used the R syntatic sugar for 
creating an inline anonymous function with a terse switch statement. This 
example can be written more verbosely for clarity:

<%= highlight %>
character.to.binary <- function(x){
  switch(x,
    Yes = 1,
    No  = 0,
    NA)
}
married <- sapply(married,character.to.binary)
<%= endhighlight %>

I think the R syntax `function(x) do.something(x) + 2` however can be very 
useful for writing one line anonymous functions when writing a out a complete 
function definition seems too much.

The `switch` statement is also worth clarifying: I define the two cases I want 
to match then all unmatched results are set to the last, default case which in 
this instance is `NA`. Why use `NA` though? I could just leave this blank 
instead. For example calculating the proportion of respondents married:

<%= highlight %>
married <- sapply(married,
                  function(x) switch(x, Yes = 1, No = 0))
married #=> c(1,1,0,0,1,1,"",0,1)

# Proportion of respondants married
mean(married[married != ""])
<%= endhighlight %>

However R functions often provide an `rm.na` flag. So by following the 
convention for using NA for missing values you can do this instead:

<%= highlight %>
married <- sapply(married,
                  function(x) switch(x, Yes = 1, No = 0,NA))

# Proportion of respondants married
mean(married, na.rm = TRUE)
<%= endhighlight %>

### A slightly more complex example

Consider I have a slightly more complex data. From the same survey respondents 
were asked to select their gross income from a drop down menu and responses 
look as follows:

<%= highlight %>
income <- c("130,000 - 134,999", "55,000 - 59,999", "90,000 - 94,999",
            "70,000 - 74,999",   "10,000 - 14,999", "25,000 - 29,999",
            "20,000 - 24,999",   "25,000 - 29,999", "40,000 - 44,999",
            "20,000 - 24,999")
<%= endhighlight %>

This is again a character vector and I need to convert this to numeric data. 
Concretely I would like the numerical value of the midpoint of each entry. This 
might seem somewhat tricky but using `sapply` again I can just apply a series 
of functions to each element to get the result I would like:

<%= highlight %>
to.numeric.midpoint <- function(x){
  sapply(strsplit(x,' - '),
         function(s) sum(as.numeric(gsub(',','',s))) / 2)
}

to.numeric.midpoint(income)
  #=> 132500  57500  92500  72500  12500  27500  22500  27500  42500  22500

<%= endhighlight %>

There are two parts to this function. The first uses `strsplit` to break up 
each element on `" - "` into a vector with two elements. The `strsplit` 
automatically performs on each vector element individually. The result of this 
part of the function therefore looks as follows:

<%= highlight %>
[[1]]
[1] "130,000" "134,999"

[[2]]
[1] "55,000" "59,999"

[[3]]
[1] "90,000" "94,999"

# reminder omitted
<%= endhighlight %>

As you can see, this is a list of vectors. When I then use `sapply` on this 
list my anonymous function is applied to the each vector in the list. The 
anonymous function then simply removes the `,` characters from each element 
using `gsub`, converts each character element to a numeric using `as.numeric`, 
then calculates the `sum` of both elements and divides the result by two.

### Further Reading

If you're interested in leaning a little more about R I'd recommend two great 
books: [The R Inferno PDF][inferno] or [hardcopy][] and [The Art of R 
Programming][]. Both of these have very good information about the "right" way 
to program in R.

[survey]: http://bioinfsurvey.org
[neil]: http://nsaunders.wordpress.com/2010/08/20/a-brief-introduction-to-apply-in-r/
[inferno]: http://www.burns-stat.com/pages/Tutor/R_inferno.pdf
[hardcopy]: http://www.lulu.com/shop/patrick-burns/the-r-inferno/paperback/product-18809753.html
[art]: http://www.amazon.com/Art-Programming-Statistical-Software-Design/dp/1593273843
