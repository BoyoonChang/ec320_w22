#' ---
#' title: "Introduction to data wrangling"
#' date: "Winter 2022"
#' output:
#'  html_document:
#'    theme: flatly
#'    highlight: tango
#'    toc: true
#'    toc_float:
#'      collapsed: true
#'      smooth_scroll: true
#'---

knitr::opts_chunk$set(echo = T, warning = F, message = F, cache = F)

#' ## The `tidyverse`
#'
#' `tidyverse` package itself includes multiple packages that are useful for different types of data analyses. For example, the package includes `ggplot2`, `dplyr`, `tidyr`, `readr`, `purrr`, etc. Check out [here]("https://www.tidyverse.org/packages/") to find more about the package. Notice that either you use `p_load(tidyverse)` or `library(tidyverse)`, after running the line, on your console, you see something like the following, indicating that it's also attaching several packages that `tidyverse` package holds (ggplot2, dplyr, tidyr, ...).
#'
# ── Attaching packages ────────────────────────────────────────────────────────────────────────────────────────────── tidyverse 1.3.1 ──
# ✓ ggplot2 3.3.5     ✓ dplyr   1.0.7
# ✓ tidyr   1.1.4     ✓ stringr 1.4.0
# ✓ readr   2.1.0     ✓ forcats 0.5.1
# ✓ purrr   0.3.4
# ── Conflicts ───────────────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
# x dplyr::filter() masks stats::filter()
# x dplyr::lag()    masks stats::lag()
#'
#'
#' ## Data
#' Now let's create our own data set containing some information about characters in minions.
library(tidyverse)
tibble(
  # you could also add comment here!
  # Since there's # at the beginning of the line, this line won't run on R.
  # this is good because plain texts wouldn't run on R and it'll throw an error.
  name=c("Bob","Kevin","Stuart","Jerry", "Jorge"),
  # Below is weight information
  weight=c(12,25,18,21,35),
  # Below is height information
  height=c(80,120,94,105,95),
  # Below is number of eyes information
  num_eyes=c(2,2,1,2,2)
) -> minion_d
minion_d
#'
#'
#'
#' ## Pipe operator `%>%`
#'
#' Pipe operator, `%>%`, is the most frequently used function in `tidyverse`. Pipe operator is defined inside `tidyverse` package so make sure to run `library(tidyverse)` before using the pipe operator.
#'
#' - **What is it?** It's an operator that feeds the output of one statement into the input of the next statement. In English, you can consider it as *"and then"*.
#' - **Why do we use it?** By using pipe operator, it lets coders to express nested functions in more readable way. In plain English, you could read it as *"and then"*.
#' Let's look at the examples below.
#'
#' Example 1
# Below three lines return the same output.
## nested function
cos(sin(pi))
## use pipe operator
pi %>% sin() %>% cos()
## use pipe operator and you could also explicitly use `.` as a placeholder
## to indicate the output of the previous statement
pi %>% sin(.) %>% cos(.)
#' Example 2
x <- c(0.110, 0.333, 0.323, 0.944, 0.345, 0.042, 0.127, 0.729, 0.997)
# Below three lines return the same output.
round(exp(diff(log(x))), 1)
x %>% log() %>% diff() %>% exp() %>% round(1)
x %>% log(.) %>% diff(.) %>% exp(.) %>% round(., 1)
#' Example 3
# Below two lines return the same output.
print("hello")
"hello" %>% print()
# Consider creating following function
# that concatenates two input arguments and print that out.
print_fun=function(banana,apple){
  print(paste0(banana, " ", apple))
}
#' Depending on how you place your placeholder `.`,
#' it returns different output.
# Below code returns "world hello"
"hello" %>% print_fun("world", .)
# Below code returns "hello world"
"hello" %>% print_fun(., "world")
#'
#'
#' ## filter(), select(), mutate()
#'
#' ### filter(): Select rows of a dataset by some logical condition.
#' Logical condition means that it returns either `TRUE` or `FALSE` depending on whether it satisfies the stated condition. For example, suppose you want to filter the tibble such that you only have information about Bob. By running `filter(name=="Bob")`, under the hood, it's scanning each observation in the tibble and only collects those that satisfy the condition, or return `TRUE`. For more details,
?filter
# Select observations whose name column is equal to "Bob"
minion_d %>% filter(name == "Bob")
# Select observations whose weight is above 30
minion_d %>% filter(weight > 30)
# Select observations whose height is 50 AND weight is over 30
minion_d %>% filter(height>50 && weight > 30)
# Select observations whose height is 50 OR weight is over 30
minion_d %>% filter(height>50 | weight > 30)

#'
#'
#' ### select(): Select columns of a dataset by name.
# For more details,
?select
# Select weight and num_eyes columns
minion_d %>% select(weight, num_eyes)
#'
#' ### mutate(): Create new columns
#' For more details,
?mutate
# Below code creates a new variable called `fav_food` which has `banana` as values.
minion_d %>% mutate(fav_food=rep("banana", 5))
#'
#'
#' ### arrange(): Sorts the data set by the values of selected columns
#' For more details,
?arrange
#' Below code sorts the `minion_d` by `num_eyes` in ascending order. In other words, it orders the rows of the dataset that has the minimum `num_eyes` to the maximum `num_eyes`.
minion_d %>% arrange(num_eyes)
#' Below code sorts the `minion_d` by `num_eyes` in descending order. In other words, it orders the rows of the dataset that has the maximum `num_eyes` to the minimum `num_eyes`.
minion_d %>% arrange(desc(num_eyes))

#' ## group_by(), summarize(), count(), nrow()
#'
#' ### group_by(): Groups data by certain variable.
#' It is often used together with other functions, such as `summarise()`, `count()`, etc.
#' ### summarise(): Creates a new data frame that summarizes observations
#' ### count(): Counts the number of observations
#' ### nrow(): Counts the number of rows
#' For more details,
?group_by
?summarise
?count
?nrow

#' Below code groups `minion_d` by `num_eyes`, then counts the number of observations for each group
minion_d %>% group_by(num_eyes) %>% count()
#' This is equivalent to 1) filtering the dataset by the number of cases for the values of `num_eyes`, 2) then calculate the number of rows for each case. Since `num_eyes` in `minion_d` only takes either value of 1 or 2, `group_by(num_eyes)` would be grouping the data by those with one eye and those with two eyes, then calculate the number of observations for each group. In other words, this is equivalent to,
minion_d %>% filter(num_eyes==1) %>% count()
minion_d %>% filter(num_eyes==2) %>% count()
#' Now you could use summarize() function to return the same output as `minion_d %>% group_by(num_eyes) %>% nrow()`.
minion_d %>% group_by(num_eyes) %>% summarize(n())
#' Below code groups `minion_d` by `num_eyes`, then returns the summary of height, i.e., mean height, median height, maximum height and minimum height in each group.
minion_d %>%
  group_by(num_eyes) %>%
  summarize(mean_h=mean(height),
            median_h=median(height),
            max_h=max(height),
            min_h=min(height))

#' ## Now your turn

#' Please open up the `03-Exercise.R` and fill out your answer for each question.






