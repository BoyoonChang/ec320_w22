# load the necessary libraries
library(gapminder)
library(tidyverse)
library(broom)
# calculate mean gdpPercap in the gapminder dataset
gapminder %>% lm(gdpPercap ~ 1, .) %>% tidy()
# calculate the t_stat with the given mean and standard error
t_stat=gapminder %>% lm(gdpPercap ~ 1, .) %>% tidy() %>% select(statistic)
# number of obs
n = nrow(gapminder)
# x_i: individual observation of gdpPercap column
x_i = gapminder$gdpPercap
# x_bar: mean of x_i
x_bar= mean(gapminder$gdpPercap)
# x_i-x_bar then square it
x_i_xbar_squared=(x_i-x_bar)^2
# calculate standard error of sample mean estimator
se = sqrt(sum(x_i_xbar_squared)/(n*(n-1)))
# calculate manually t-stat using what we have above
(mean(gapminder$gdpPercap)-0)/se
# t-critical value with 5% significance level, df=n-1
qt(0.95, df=n-1, lower.tail=FALSE) %>% abs()
# probability of t-stat being that extreme when the null is true,
# i.e. population mean =0
pt(q=t_val[[1]], df=n-1, lower.tail=FALSE)*2

