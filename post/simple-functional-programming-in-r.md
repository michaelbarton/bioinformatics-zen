---
tags: post
feed: false
title: Simple functional programming in R
date: 2012-03-19
---

R can be a very unforgiving language. Obtuse error messages and a variety of
differing yet similar data structures leads to a frustrating learning curve.
Furthermore R is a functional programming language which, if you are used to
imperative programming (e.g. Java/Perl/Python/Ruby), makes R seem like a crufty
Perl for statistics.

The functional nature of R however is often understated. Myself when I first
started to program in R, I programmed as if I was writing Java since this was
the only other language I knew. This led to frustration at the poor object
support and the seeming requirement to create large numbers of loops and
temporary variables.

I've recently started to learn Clojure which has lead me appreciate the
functional heart of R and how much it can simplify your code. R is almost a
lisp dialect since it draws much inspiration from Scheme. This, for instance,
is valid R:

```r
sqrt(
  '*'(
    '+'(1, 2),
    3))
#=> 3
```

Having first learnt to program in Java everything I heard about "Functional
programming" sounded alien and strange. I think this is in part due to the
academic stereotype associated with functional programming. Languages such as
Clojure however are proving that functional programming can be better than
imperative approaches in terms of concise, clear code and for simplifying
parallelisation. However for the point of this post I'm not going to discuss
the pros or cons of functional programming but instead give two simple examples
in R.

### Converting a character vector to a binary variable

I have the following vector from a survey describing whether each respondent is
married or not.

```r
married <- c("Yes","Yes","No","No","Yes","Yes","","No","Yes")
```

What I'd like to do is convert this to a binary variable where `Yes` becomes
`1` and `No` becomes `0`. Here's how I originally would have solved this
problem using a loop:

```r
binary.married <- c()
for(i in 1:length(married)) {
  if(married[i] == "Yes"){
    binary.married <- c(binary.married,1)
  } else {
    binary.married <- c(binary.married,0)
  }
}
```

This example will perform poorly when the `married` variable is very long since
the new vector `binary.married` is recreated each time to add a new element
onto the end. If you only take one point away from this post; avoid using `c`
to repeatedly increment a vector and instead do this:

```r
binary.married <- rep(0,length(married))
for(i in 1:length(married)) {
  if(married[i] == "Yes") binary.married[i] <- 1
}
```

This creates the same sized `binary.married` variable beforehand and the loop
then replaces each variable with the binary version of either `Yes` or `No`. As
I initialised the `binary.married` variable with `0`s I only needed to replace
the entries corresponding to `Yes` in the `married` vector.

I think however, in general, loops should be avoided in R. If you find yourself
using a loop there is probably an easier, and possible faster way to do it. For
instance I could perform a similar operation using vectorisation:

```r
married[married == "Yes"] <- 1
married[married == "No"]  <- 0
```

This finds each index of `Yes` or `No` values and replaces them with the
corresponding binary value. This approach is also a little safer too as only
elements that match either `Yes` or `No` are replaced. As an example the
original `married` variable contained an empty response, this code ignores this
and produces:

```r
married #=> c(1,1,0,0,1,1,"",0,1)
```

Therefore I'll probably get an exception if I try to perform this numerical
calculation on this data. The looping approach in contrast replaced the empty
response with 0. The manual index-replace method however quickly becomes
unwieldy with more factors than just `Yes` or `No`. Instead here is better way
the `married` variable can be converted to binary:

```r
married <- sapply(married,
                  function(x) switch(x, Yes = 1, No = 0, NA))

married #=> c(1,1,0,0,1,1,NA,0,1)
```

Here I'm using an `apply`-family function. These functions perform as you would
expect and apply a function to each element in a vector/list/matrix depending
on which apply is used. Using the apply family of functions is the essence of
using R well and Neil Saunders has [an excellent overview of the functions in
the `apply` family.][neil] To expand on the code, this applies the defined
function to each element in `married` and I used the syntactic sugar for
creating an inline anonymous function (e.g. `function(args) ...`). This example
can be written more verbosely for illustration:

```r
character.to.binary <- function(x){
  switch(x,
    Yes = 1,
    No  = 0,
    NA)
}
married <- sapply(married,character.to.binary)
```

I think the previous anonymous function syntax `function(x) ...` is useful for
writing inline anonymous when writing a complete function definition seems too
much.

The `switch` statement is also worth clarifying too: I define the cases I want
to match and the unmatched cases then return the default which is `NA`. Why use
`NA` though? I could just leave this blank instead. For example when
calculating the proportion of respondents married:

```r
married <- sapply(married,
                  function(x) switch(x, Yes = 1, No = 0)) # No default case
married #=> c(1,1,0,0,1,1,"",0,1)

# Proportion of respondents married
mean(married[married != ""])
```

R functions however often provide an `rm.na` flag. So by following the
convention of using `NA` for missing values this can be simplified to:

```r
married <- sapply(married,
                  function(x) switch(x, Yes = 1, No = 0,NA))

# Proportion of respondents married
mean(married, na.rm = TRUE)
```

### A slightly more complex example

Consider I have slightly more complex data. From the same survey, respondents
were asked to input their gross income from a drop down menu. A sample of the
responses is as follows:

```r
income <- c("130,000 - 134,999", "55,000 - 59,999", "90,000 - 94,999",
            "70,000 - 74,999",   "10,000 - 14,999", "25,000 - 29,999",
            "20,000 - 24,999",   "25,000 - 29,999", "40,000 - 44,999",
            "20,000 - 24,999")
```

This is again a character vector which I want to convert to numeric data.
Concretely I would like the numerical value for the midpoint of each entry.
This might seem somewhat tricky but using `sapply` again I can just apply a
series of functions to each element to get desired result:

```r
to.numeric.midpoint <- function(x){
  sapply(strsplit(x,' - '),
         function(s) sum(as.numeric(gsub(',','',s))) / 2)
}

to.numeric.midpoint(income)
  #=> 132500  57500  92500  72500  12500  27500  22500  27500  42500  22500

```

There are two parts to this function. The first uses `strsplit` to break up
each entry on `" - "` into a vector with two elements. The `strsplit`
automatically vectorises this operation to perform this element-wise. The
result of the `strsplit` operation is therefore as follows:

```r
strsplit(income, ' - ')

[[1]]
[1] "130,000" "134,999"

[[2]]
[1] "55,000" "59,999"

[[3]]
[1] "90,000" "94,999"

# reminder omitted
```

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

[neil]: https://nsaunders.wordpress.com/2010/08/20/a-brief-introduction-to-apply-in-r/
[inferno]: http://www.burns-stat.com/pages/Tutor/R_inferno.pdf
[hardcopy]: http://www.lulu.com/shop/patrick-burns/the-r-inferno/paperback/product-18809753.html
[art]: http://www.amazon.com/Art-Programming-Statistical-Software-Design/dp/1593273843
