#' Suppose we want to conduct the following regression:
#' $$
#' log(lifeExp_{i}) = \beta_0 + \beta_1log(gdpPercap_i) + u_i
#' $$
#'
#' Remove the # in front of the codes and fill in the blanks.
#' We are using `gapminder` dataset contained in the package `gapminder`. I've already attached relevant libraries.
library(pacman)
p_load(broom, tidyverse, gapminder)

#' 1. Use `lm()` to estimate the above regression model store it as `reg2`.
# reg2 <- lm(______~_____, data = gapminder)


#' 2. Store slope estimate as beta1hat.
# beta1hat <- reg2 %>% tidy() %>% filter(term=="log(gdpPercap)") %>% select(_____) %>% .[[1]]


#' 3. Store the standard error of $\hat{\beta_1}$ as `se_beta1hat`. Use `reg2` object to extract standard error information.
# se_beta1hat <- reg2 %>% tidy() %>% filter(term=="log(gdpPercap)") %>% select(______) %>% .[[1]]


#' 4. Suppose our null hypothesis is that $\beta_1 = 0$. Calculate the t-statistic and call it `t_stat`. **Return the t_stat.**
# t_stat =  (____-0)/______
# t_stat

#' 5. Using `qt()` function to find the 95% critical value for the two-sided test and compare it with the t-statistic you got from Q4. Recall that the degrees of freedom is calculated by the number of observations in the dataset - the number of parameters estimated.
#'
# qt(p=0.975, df=_____)

#' 6. Based on your $t$-stat, what is your conclusion? Do you reject/fail to reject the null hypothesis that GDP per capita has no effect on life expectancy?
#' Since the calculated t_stat is greater than 95% t-critical value, we reject the null hypothesis.

# t_stat > qt(p=0.975, df=_______)
