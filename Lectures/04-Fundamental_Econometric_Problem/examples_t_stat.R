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

# load the necessary libraries
library(gapminder)
library(tidyverse)
library(broom)
Y = c(1,5,10,12)
# calculate mean Y
lm(Y~1) %>% tidy()
# calculate the t_stat with the given mean and standard error
t_stat=lm(Y~1) %>% tidy() %>% select(statistic)
# number of obs
n = length(Y)
# x_i: individual observation of gdpPercap column
x_i = Y
# x_bar: mean of x_i
x_bar= mean(Y)
# x_i-x_bar then square it
x_i_xbar_squared=(x_i-x_bar)^2
# calculate standard error of sample mean estimator
se = sqrt(sum(x_i_xbar_squared)/(n*(n-1)))
# calculate manually t-stat using what we have above
t_val=(mean(Y)-0)/se
t_val
# t-critical value with 5% significance level, df=n-1
qt(0.95, df=n-1, lower.tail=FALSE) %>% abs()
# probability of t-stat being that extreme when the null is true,
# i.e. population mean =0
pt(q=t_stat[[1]], df=n-1, lower.tail=FALSE)*2
ggplot() +
  stat_function(fun = dt, args = list(df = n-1), geom = "line") +
  stat_function(fun = dt, args = list(df = n-1), geom = "area",
                fill = "red", xlim = c(qt(.975, df = n-1), 5)) +
  stat_function(fun = dt, args = list(df = n-1), geom = "area",
                fill = "red", xlim = c(-5, qt(.025, df = n-1))) +
  xlim(-5, 5) +
  geom_vline(xintercept = t_stat[[1]], color = "blue") +
  annotate("text", x = t_stat[[1]], y=0.075, label="t-critical value")
```
