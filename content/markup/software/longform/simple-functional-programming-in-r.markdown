---
  kind: article
  feed: true
  title: Simple functional programming in R
  created_at: "2012-03-19 05:00 GMT"
---

R can be a very unforgiving language. Obtuse error messages and a variety of 
differing but similar data structures leads to a frustrating learning curve. 
Furthermore R is a functional programming language which, if you are used to 
imperative programming (e.g. Java/Perl/Python/Ruby), makes R seem like a crufty 
Perl for statistics.

The functional nature of R however is often understated. Myself when I first 
started to program in R, I programmed as if I was writing Java as this was the 
only language I knew. This lead to frustration at the poor object support and 
the seeming requirement to create large numbers of loops and temporary 
variables.

I've recently started to learn Clojure which has lead me appreciate the 
functional heart of R and how much it can simplify your code. R is almost a 
lisp dialect since it draws much inspiration from Scheme. This, for instance, 
is valid R:

<%= highlight %>
    sqrt(
      '*'(
        '+'(1, 2),
        3))
    #=> 3
<%= endhighlight %>


Having first learnt to program in Java everything I heard about "Functional 
programming" sounded alien and strange. I think this may also be due to 
unhelpful stereotypes associated with functional programming languages such as 
being only for academics. Languages such as Clojure however are proving that 
functional programming can be better than imperative approaches at least in 
terms of concise and clear code. However for the point of this post I'm not 
going to discuss the pros or cons of functional programming but instead give 
some simple functional examples in R which I hope will speak for themselves.

### Converting a character vector to a binary variable

I have the following vector from a [survey of bioinformaticians][survey] 
describing whether each respondent is married or not.

<%= highlight %>
married <- c("Yes","Yes","No","No","Yes","Yes","","No","Yes")
<%= endhighlight %>

What I'd like to do is convert this to a binary variable where `Yes` becomes 
`1` and `No` becomes `0`. Here's how I originally would have solved this 
problem using a loop:

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

This example will perform poorly when the `married` variable is very long since 
the new vector `binary.married` is recreated each time to add a new element 
onto the end. Therefore if you only take one point away from this blog post 
avoid doing using `c` to repeatedly increment a vector and instead do this:

<%= highlight %>
binary.married <- rep(0,length(married))
for(i in 1:length(married)) {
  if(married[i] == "Yes") binary.married[i] <- 1
}
<%= endhighlight %>

This creates the `binary.married` variable beforehand the same size as the 
`married` variable. The loop then replaces each variable with the binary 
version of either `Yes` or `No`. As I initialised the `binary.married` variable 
with `0`s I only needed to replace the entries corresponding to `Yes` in the 
`married` vector.

I think, in general, loops should be avoided in R. If you find yourself using a 
loop there probably is an easier, and possible faster way to do it. For 
instance I could perform a similar operation using vectorisation:

<%= highlight %>
married[married == "Yes"] <- 1
married[married == "No"]  <- 0
<%= endhighlight %>

This finds each instance of `Yes` or `No` and replaces it with the 
corresponding binary value. This approach is also a little safer too as only 
elements that match either `Yes` or `No` are replaced. As an example of this 
you look carefully at the original `married` variable above to see that one of 
the responses is empty. The above code examples therefore produces this:

<%= highlight %>
married #=> c(1,1,0,0,1,1,"",0,1)
<%= endhighlight %>

Therefore I'll probably get an exception if I try to perform a numerical 
calculation on this data. The looping approach above instead replace empty 
response with 0. The index-replace however quickly becomes unwieldy with more 
factors than just `Yes` or `No`. Instead here is better way the `married` 
variable can be converted to binary:

<%= highlight %>
married <- sapply(married,
                  function(x) switch(x, Yes = 1, No = 0, NA))

married #=> c(1,1,0,0,1,1,NA,0,1)
<%= endhighlight %>

Here I'm using an `apply`-family function. These functions perform as you would 
expect and apply a function to element in a vector/list/matrix depending on 
which function is used. Using the apply family of functions is the essence of 
using R well and Neil Saunders has [an excellent overview of the functions in 
the apply family.][neil] To expand on the above code, this applies the defined 
function to each element in `married` and I used the syntactic sugar for 
creating an inline anonymous function which is `function(args) ...`. This 
example can be written more verbosely for illustration:

<%= highlight %>
character.to.binary <- function(x){
  switch(x,
    Yes = 1,
    No  = 0,
    NA)
}
married <- sapply(married,character.to.binary)
<%= endhighlight %>

I think the anonymous function syntax `function(x) ...` is useful for writing 
inline anonymous when writing the complete function definition seems too much.

The above `switch` statement is also worth clarifying too: I define the two 
cases I want to match and the unmatched cases then return the argument which is 
`NA`. Why use `NA` though? I could just leave this blank instead. For example 
when calculating the proportion of respondents married:

<%= highlight %>
married <- sapply(married,
                  function(x) switch(x, Yes = 1, No = 0))
married #=> c(1,1,0,0,1,1,"",0,1)

# Proportion of respondents married
mean(married[married != ""])
<%= endhighlight %>

R however functions often provide an `rm.na` flag. So by following the 
convention of `NA` for missing values this can be simplified:

<%= highlight %>
married <- sapply(married,
                  function(x) switch(x, Yes = 1, No = 0,NA))

# Proportion of respondents married
mean(married, na.rm = TRUE)
<%= endhighlight %>

### A slightly more complex example

Consider I have slightly more complex data. From the same survey, respondents 
were asked to input their gross income from a drop down menu. A sample of the 
responses is as follows:

<%= highlight %>
income <- c("130,000 - 134,999", "55,000 - 59,999", "90,000 - 94,999",
            "70,000 - 74,999",   "10,000 - 14,999", "25,000 - 29,999",
            "20,000 - 24,999",   "25,000 - 29,999", "40,000 - 44,999",
            "20,000 - 24,999")
<%= endhighlight %>

This is again a character vector which I want to convert to numeric data. 
Concretely I would like the numerical value for the midpoint of each entry. 
This might seem somewhat tricky but using `sapply` again I can just apply a 
series of functions to each element to get desired result:

<%= highlight %>
to.numeric.midpoint <- function(x){
  sapply(strsplit(x,' - '),
         function(s) sum(as.numeric(gsub(',','',s))) / 2)
}

to.numeric.midpoint(income)
  #=> 132500  57500  92500  72500  12500  27500  22500  27500  42500  22500

<%= endhighlight %>

There are two parts to this function. The first uses `strsplit` to break up 
each entry on `" - "` into a vector with two elements. The `strsplit` 
automatically vectorises this operation to perform this on each element 
individually. The result of the `strsplit` operation is therefore as follows:

<%= highlight %>
strsplit(income, ' - ')

[[1]]
[1] "130,000" "134,999"

[[2]]
[1] "55,000" "59,999"

[[3]]
[1] "90,000" "94,999"

# reminder omitted
<%= endhighlight %>

A list of vectors is returned and `sapply` then calls the anonymous function on 
each entry in the list. The anonymous function simply removes the `,` 
characters from each element using `gsub`, converts each character element to a 
numeric value using `as.numeric`, then calculates the `sum` of both elements 
and divides the result by 2.

### Further Reading

I hope these simple examples showed how using R functional nature can improve 
code performance and clarity. If you're interested in leaning a little more 
about R I'd recommend two good books: [The R Inferno PDF][inferno] or 
[hardcopy][] and [The Art of R Programming][art]. Both of these have a lot of 
information about the "right" way to program in R.

[survey]: http://bioinfsurvey.org
[neil]: http://nsaunders.wordpress.com/2010/08/20/a-brief-introduction-to-apply-in-r/
[inferno]: http://www.burns-stat.com/pages/Tutor/R_inferno.pdf
[hardcopy]: http://www.lulu.com/shop/patrick-burns/the-r-inferno/paperback/product-18809753.html
[art]: http://www.amazon.com/Art-Programming-Statistical-Software-Design/dp/1593273843
