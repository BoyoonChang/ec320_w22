#'---
#'title: "Introduction to a function"
#'author: | 
#'        | EC 320: Introduction to Econometrics
#'        | University of Oregon
#' date: "Winter 2022"
#' output: 
#'   html_document:
#'     theme: flatly  
#'     highlight: tango
#'     toc: true
#'     toc_float:
#'       collapsed: true
#'       smooth_scroll: true    
#' ---
#'
#' ## Functions and arguments

### Basics

#' What is a function? A function is a rule that defines a relationship between one variable to another. Most of the codes defined in R are could be considered as functions. For example, let's inspect `library()` function by running the below code. Again, if you want to find out more about a specific function and how it's being defined, you could simply put `?name.of.the.function()`.

?library()

#' As you can see from the help pane, `library()` "load and attach add-on packages". You could also notice that it takes multiple arguments. We will discuss what arguments mean but before that, we will investigate the structure of a function.

#' ### Function structure

#' A function is structured as below.


somefunction <- function(arg1,arg2, ...) {
  statements
  return(object)
}


#' Notice that a function has **input parameters**, **statements** that are executed when it runs, and **output** of the function in the return statement. **Parameters** simply mean placeholders that are used inside the function body. Let's look at the example.


fahrenheit_to_celsius <- function(temp_F) {
  temp_C <- (temp_F - 32) * 5 / 9
  return(temp_C)
}


#' Here, we are defining a function called `fahrenheit_to_celsius` that converts temperatures from Fahrenheit to Celsius. We are assigning the function itself as `farenheit-to-celsius` using `<-`. The list of parameters are contained within parenthesis, the body of the function is contained within curly braces, `{}`, and the output of the function is contained within parenthesis of the `return`. `temp_F` is considered an input parameter, `temp_C` within `return()` is considered an output. `temp_C <- (temp_F - 32) * 5 / 9` is considered the body of the function or the statements that are executed when we call this function.

#' **Side note**: In R, you don't necessarily have to include the return statement to indicate the output of the function call. R automatically returns whichever is indicated on the last line of the body of the function. This implies that R will still return `temp_C` as the output of `fahrenheit_to_celsius` function even if you omit `return(temp_C)`.


fahrenheit_to_celsius

#' You could see now the structure of this function by running `fahrenheit_to_celsius` like above. You could actually put a specific value as an input to this function. Suppose we want to know what temperature in Celsius corresponds to 100 degrees in Fahrenheit. You could put 100 as an **argument** to `fahrenheit_to_celsius function`. Arguments here could be considered specific values which are passed to the function. In this case, `100` corresponds to an argument to the function `fahrenheit_to_celsius`.


fahrenheit_to_celsius(temp_F=100)

#' What if the function you are using has multiple parameters? **Argument order matters**. The order of arguments supplied to a function matters. Look at the example below. Depending on how you supply the arguments, the output differs. By default, unless explicitly specifying the names of the parameters, R considers the first argument be the the argument for the first parameter, the second argument be the argument for the second parameter, and so on. You could however specify the name of the parameter and match it with the corresponding argument and change the order of the arguments. 
#' 
print_fun=function(banana,apple){
  print(paste0("hello ", banana, " ", apple))
}
# Below three lines return same outputs
print_fun("not","me") 
print_fun(banana="not", apple="me")
print_fun(apple="me", banana="not")
# Below line does not return the same output as above
print_fun("me","not") 



#' ### Takeaways

#' The idea to show what a function is and how it is defined, was to give you a sense that all we are using from now on are these functions that are predefined by other programmers. We will get down to these functions further when we are learning `tidyverse` package.

#' ## Vector

#'In R, data is held in vectors. You could construct a vector by using `c()` function. `c()` is short for combine.

### Numeric vectors
#'If you would like to create a vector containing four numeric values 1,2,3 and 4, simply put them all inside the parenthesis of `c()` function.

c(1,2,3,4)


#'You could do all kinds of calculations on numeric vectors.

c(1,2,3,4)+c(2,3,4,5)
c(1,2,3,4)*c(2,3,4,5)
c(1,2,3,4)/c(2,3,4,5)


#'You could also have the vector nested in another function.

min(c(1,2,3,4))
max(c(1,2,3,4))
sum(c(1,2,3,4))

#' You could also create a vector that does random sampling using `sample()` function.

sample(c(0,1), size=10, replace=TRUE)


#' You could create a vector whose elements repeat several times.

rep(c(1,2,3), each=5)


#' ### Logical vectors
#' You could also create a vector of logical values.

c(TRUE, TRUE, FALSE, TRUE)


#' ### Character vectors
#' You could also create a vector of character values.

c("A","B","C", "D","E")


#' What happens if you create a vector containing both numeric and character values?

c(1,2,3, "apple", "orange","banana")


#' You could notice from above that the vector now turns all the elements including the numeric values into **character** values. Character values are put in quotes.

#' ### Index

#' Index indicates the position of a specific element within a vector or a matrix or a dataset. A vector which is typically one dimension, has one index per element. For example, the index of "apple" from the above example is 4, the index of "orange" is 5, the index of "banana" is 6. Suppose you would want to select "apple" in the previously defined vector. You could simply put a specific numeric value that indicates the index of "apple" inside the square bracket.


c(1,2,3, "apple", "orange","banana")[4]


#' ## Matrices

#' Can we create a two dimensional vector? Yes. Here's how we do it.

#' ### Creating a matrix

#' You could either bind rows or columns of multiple vectors with the same length like below.


x <- c(1,23)
y <- c(2,24)
z <- c(3,25)
rbind(x,y,z) # short for row bind
cbind(x,y,z) # short for column bind


#' Or you could use the matrix function.


matrix(c(1,2,3,23,24,25), nrow=3, ncol=2) # equivalent to rbind(x,y,z)
matrix(c(1,2,3,23,24,25), nrow=2, ncol=3, byrow=TRUE) # equivalent to cbind(x,y,z)


#' ### Indexing element in a matrix

#' You could select a specific element in a matrix by specifying the coordinate of the element in a square bracket. On the left of the comma in a square bracket comes the row index and on the right of the comma in a square bracket comes the column index.


# If you'd like to select 2,
# you specify the coordinate of it which is the second row and the first column.
matrix(c(1,2,3,23,24,25), nrow=3, ncol=2)[2,1]
# If you'd like to select 25,
# you specify the coordinate of it which is the third row and the second column.
matrix(c(1,2,3,23,24,25), nrow=3, ncol=2)[3,2]


#' ## Tibble

#' You could create a dataset using `tibble()` function. You could consider a tibble as binding columns of named vectors. Two rules to follow when using `tibble()`: 1) each column should be named, and 2) each column should have the same number of rows. If the number of rows does not match across columns, `tibble` will either recycle the values until all columns have the same number of rows or it will throw an error.

#' Try using `tibble()` function yourself.


# load tidyverse first because tibble() function is defined in this package.
library(tidyverse)
# Below codes will create two columns, x and y each of which will have four rows.
tibble(
  x = c(1,2,3,4),
  y = c(10,11,12,13)
)


#' Suppose we would like to build our own dataset that shows monthly average high temperature in Eugene in Fahrenheit and in Celsius from September to December. We could construct the dataset by having three columns each denoting month, avg_temp_F_eugene, and avg_temp_C_eugene. At this point, suppose the avg temperatures in Eugene in Fahrenheit are given (Sep: 77, Oct: 65, Nov: 53, Dec: 46). We could also use `fahrenheit_to_celsius()` function we've created to convert the temperatures from Fahrenheit to Celsius.


tibble(
  month=c(9,10,11,12),
  avg_temp_F_eugene=c(77,65,53,46),
  avg_temp_C_eugene=fahrenheit_to_celsius(avg_temp_F_eugene),
)


#' ## Now your turn

#' Please open up the `02-Exercise.R` and fill out your answer for each question.

## Reference

#' For more information about the lab material covered this week, see below links.
#'
#' - https://swcarpentry.github.io/r-novice-inflammation/02-func-R/index.html
#' - https://datascienceplus.com/vectors-and-functions-in-r/
