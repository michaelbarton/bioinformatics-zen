---
tags: post
feed: false
title: Data analysis using R functions as objects
date: 2009-10-02
---

https://www.youtube.com/watch?v=0FwXSgBzo_Q

The R language is useful because of the available statistical and plotting functions in the base and addon packages. Before using any function though it's usually necessary to get your input data into the format that the function expects. Performing complicated data manipulations with R's standard methods for accessing and subsetting data can however quickly lead to complex and confusing R scripts.

Processing a complex dataset in someway, for example to find the mean for a range of subsets, generally means creating variables to keep track of a series of levels to subset the data by, then creating a new variable for each subset. Creating many new variables can lead to complex R scripts that are difficult to understand. I'm going to try an outline here an interesting feature of R that allows functions to be treated as objects and can make for much cleaner and shorter R code. For example when I'm discussing "functions as objects" here I mean that the function for calculating standard deviation can be treated in the same was the array of data it works on.

In the examples here I'm using the crab which is part of the MASS package. This data contains morphological measurements on both sexes of two crab species.

```r
library(MASS)
data(crabs)
head(crabs)
   sp sex index   FL  RW   CL   CW  BD
1   B   M     1  8.1 6.7 16.1 19.0 7.0
2   B   M     2  8.8 7.7 18.1 20.8 7.4
3   B   M     3  9.2 7.8 19.0 22.4 7.7
4   B   M     4  9.6 7.9 20.1 23.1 8.2
5   B   M     5  9.8 8.0 20.3 23.0 8.2
```

### Performing functions on subsets of data

I have a function called _do_something_ which I want to use to analyse two columns in the crab data. First I want to subset for each sex in each species and call my function on each data subset. In the example below I'm getting the data for the orange female crabs then calling my function on two of the columns in the data.

```r
do_something <- function(x,y){
  # Function code goes here ...
}

# Subset my data
orange_girls <- subset(crabs,
  sex == 'F' & sp == 'O')

# Call my function
do_something(orange_girls$CW,orange_girls$CL)
```

I dislike this code because I have to first create a new variable as a subset of the data before I call my function on it. Secondly when I call the _do_something_ function I have to specify the the columns in data I want using the _$_ symbol. Instead compare the same functionality but using the _with_ command.

```r
with(subset(crabs, sex == 'F' & sp == 'O'),
  do_something(CW,CL))
```

Here I'm doing exactly the same thing, but the _do_something_ command is called in the context of the data subset which means I don't have to specify the columns using _$_. I also don't have to create a new subset variable beforehand, I can just pass the subset of data as the first argument to the _with_ command. I'm not restricted to just running one function either.

```r
# Same thing but using a multi-line code
# block via curly braces
with(subset(crabs, sex == 'F' & sp == 'O'),{
  do_something(CW,CL)

  # Use more functions on the same subset
  lm(CW ~ CL)
})
```

By using curly braces _{ }_ I can call multiple functions as part of the same command. I can do this because the curly braced expression is an argument to the _with_ function.

### Looping through subsets of data

So far I'm using just a single subset of the crab data, but I will want to call a function on all combinations of sex and species. Usually this means using _for_ loops to iterate through each combination of sex and species to break the data into smaller chunks.

```r
# Arrays of values for each type of species
# and sex
species <- unique(crabs$sp)
sexes   <- unique(crabs$sex)

# Loop through species ...
for(i in 1:length(species)){

  # ... loop through sex ..
  for(j in 1:length(sexes)){

    # ... and call a function on the subset
    something_else(subset(crabs,
      sp == species[i] & sex == sexes[j]))
  }
}
```

This is messy because I've had to create two arrays just to keep track of the unique values for each species and sex. Furthermore I've got two variables _i_ and _j_ which, if I change my loops at some point or add more loops, make the code more fragile and difficult to understand. Furthermore when you look at this code you can see there are nine lines just to get which subset I'm interested in but only one line actually calls my function. Instead of this I can create my own function to automatically iterate through the dataset and call any function I want.

```r
each <- function(.column,.data,.lambda){

  # Find the column index from it's name
  column_index <- which(
    names(.data) == .column)

  # Find the unique values in the column
  column_levels <- unique(.data[,column_index])

  # Loop over these values
  for(i in 1:length(column_levels)){

    # Subset the data and call the function
    .lambda(.data[
      .data[,column_index] == column_levels[i],
    ])
  }
}
```

The first two arguments of this function are the name of the column I want to subset the data by, and the data frame I want to iterate over. What's interesting though is that the last argument _.lambda_ is an R function, because R treats functions as objects this allows them to be passed as arguments to other functions.

```r
# Another function as the last argument
# to this function
each("sp", crabs, something_else)

# Or create a new anonymous function ...
each("sp", crabs, function(x){

  # ... and run multiple lines of code here
  something_else(x)
  with(x,lm(CW ~ CL))

})
```

I'm still looping through each subset of the data but I've now moved all the messy code to a separate function which makes the code more readable. Moving repetitive code like this to a separate function is good programming practice as it keeps your code [DRY][dry] and also avoids the temptation for [copy and paste anti-patterns][cap].

My example function isn't very sophisticated though and can't create loops for subsets of more than one column. Nevertheless as you might expect there are methods exactly for doing this type of loop-each-subset approach to data analysis. An example is the _lapply_ function in R base, however I find the syntax of this function hard to remember. Instead I prefer to use [Hadly Wickham's][hadly] excellent [plyr package][plyr]. Plyr is very simple to use, for example:

```r
library(plyr)

# Three arguments
# 1. The dataframe
# 2. The name of columns to subset by
# 3. The function to call on each subset
d_ply(crabs, .(sp, sex), something_else)
```

Again this is an example of how one function can accept another function as an argument. Compare how concise this code is with the code a few paragraphs up which uses for loops to do the same thing. The plyr package has more functionality than this though and is worth spending some time looking at. Also worth checking out are the [foreach][foreach] and [iterators][iter] packages which provide similar functionality.

[dry]: https://en.wikipedia.org/wiki/Don%27t_repeat_yourself
[cap]: http://en.wikipedia.org/wiki/Copy_and_paste_programming
[hadly]: http://had.co.nz/
[plyr]: http://plyr.had.co.nz/
[foreach]: http://cran.r-project.org/web/packages/foreach/index.html
[iter]: http://cran.r-project.org/web/packages/iterators/index.html
