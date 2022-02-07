#' ---
#' title: "Simple Linear Regression Revisited"
#' date: "Winter 2022"
#' output:
#'  html_document:
#'    theme: flatly
#'    highlight: tango
#'    toc: true
#'    toc_float:
#'      collapsed: true
#'      smooth_scroll: true
#' ---



knitr::opts_chunk$set(echo = T, warning = F, message = F, cache = F)

#' ## Load the necessary packages
#' 
library(pacman)
p_load(gapminder, tidyverse,broom)
#' As always, we first load pacman, then use `p_load` function which allows loading multiple packages all at once. This week, we'll use `gapminder` package which contains the dataset that we'll use in the lab, `tidyverse` package which contains all the functions necessary to wrangle/summarize data, and `broom` which contains functions to produce regression results in tidy format.
#'
#' ## Recap function
#' 
# summ_fun <- function(x){
#   state_data %>% 
#   summarize(min = min(x),
#             max = max(x),
#             median = median(x),
#             mean = mean (x),
#             sd = sd(x))
# }
#' 
#' Last time, we have created our own function called `summ_fun` that summarizes a certain variable in the observational data which we called `state_data`, whose raw data is retrieved from the [CDC](https://www.cdc.gov/drugoverdose/data/index.html) the [University of Kentucky Poverty Research Center](http://ukcpr.org/resources/national-welfare-data). This time, we would like to alter some arguments that goes inside the `summ_fun` to allow using the function for not just the `state_data`, but for a variety of datasets. Take a closer look at the following function that redefined the existing function `summ_fun`. 
#' 
summ_fun <- function(data, summarize_var){
  data %>% 
  summarize(min = min(summarize_var),
            max = max(summarize_var),
            median = median(summarize_var),
            mean = mean (summarize_var),
            sd = sd(summarize_var))
}
#' Now `summ_fun` takes in two arguments, one which takes the name of the data as the argument and the other takes the name of the variable that we would like to summarize as the argument. Now we've redefined `summ_fun`, we want to test out whether this function actually works. 
#' 
#' Let's invoke the function with putting `gapminder` as the argument for `data` and `lifeExp` as the argument for `summarize_var`.
#' 
# summ_fun(gapminder, lifeExp)
#' However the above code would throw you an error. Why? 
#' 
#' Our function would find the data called `gapminder`, however it won't find `lifeExp` variable because R does not know if this variable is contained in the `gapminder` dataset. The quick fix is denote a variable contained in a specific dataset by adding a set of double braces `{{var}}` in the function body. 
summ_fun <- function(data, summarize_var){
  data %>% 
  summarize(min = min({{summarize_var}}),
            max = max({{summarize_var}}),
            median = median({{summarize_var}}),
            mean = mean ({{summarize_var}}),
            sd = sd({{summarize_var}}))
}
summ_fun(gapminder, lifeExp)
#' Now it works!
#' 
#' 
#'
#' ## Recap linear regression
#' Last time we looked at how to use `lm()` to return linear regression results from using OLS estimator. Then we manually calculated $\hat{\beta_0}$, $\hat{\beta_1}$ to in fact confirm that the `lm()` is not a magic function but in fact something that could be calculated manually using the formulas.  
#' To give you more hints about how `lm()` function operates, following function that is defined just now produces the same OLS estimates as `lm()`. 
simple_lm <- function(data, y, x){
  estimates=data %>%
      summarize(
        beta_1 = sum(({{ x }} - mean({{ x }}))*({{ y }} - mean({{ y }})))/sum(({{ x }} - mean({{ x }}))^2),
        beta_0 = mean({{ y }}) - mean({{ x }})*beta_1
      )
  return(c(beta_0=estimates$beta_0, beta_1=estimates$beta_1))
}
simple_lm(gapminder, lifeExp, log(gdpPercap))
lm(lifeExp ~ log(gdpPercap), data = gapminder)

#' You might be wondering what `gapminder` dataset is and what variables this dataset contains. 

?gapminder

#' `gapminder` is an "excerpt of the Gapminder data on life expectancy, GDP per capita, and population by country". It contains six variables: country name, continent, year of the observation, life expectancy in years, population and GDP per capita. 
#' 
#' Suppose we want to conduct the following regression:
#' $$
#' lifeExp_{i} = \beta_0 + \beta_1gdpPercap + u_i
#' $$
#' We could estimate this regression model using `lm()`.
lm(lifeExp~gdpPercap, data=gapminder)
#' We could put tidy() or summary() to know more about the regression results.
lm(lifeExp~gdpPercap, data=gapminder) %>% tidy()
lm(lifeExp~gdpPercap, data=gapminder) %>% summary()

#' ## Calculate the fitted values of y
?fitted()
# "fitted is a generic function which extracts fitted values from objects returned by modeling functions" (Check your help pane)
#'
#' The first argument that `fitted()` takes is `object`. This is the regression object or the object that is returned from using `lm()` function. For now we'll store the regression results where the outcome variable is lifeExp and the treatment variable is gdpPercap as `reg1`. 


reg1 <- lm(lifeExp~gdpPercap, data=gapminder)
# to calculate the fitted values of lifeExp, simply use `fitted()`.
fitted(reg1) %>% head(10) # just shows the first 10 fitted Y
#' ## Calculate the residuals 
?residuals()
residuals(reg1) %>% head(10) # just shows the first 10 residuals
#'
#' ## Classical assumptions
#' 
#' Up until now, we really didn't think about the relationship between life expectancy and GDP per capita, whether or not it is linear (A1), or whether the error is normally distributed (A6) or whether the data is homoskedastic (A4). We didn't consider any of these things before assuming a nice linear model with normal errors. Recall that if classical assumptions are violated, Ordinary Least Squares estimator is no longer BLUE, best linear unbiased estimator. 
#' To see where we went wrong, consider the following plot of the `gapminder` data
gapminder %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent), alpha = 0.4) +
  geom_smooth(method = 'lm', color = "black") +
  labs(title = "Life Expectancy by GDP Per Capita",
       subtitle = "1952-2007",
       x = "GDP Per Capita (USD)",
       y = "Life Expectancy (years)",
       color = "Continent")


#' Does this data look linear?
#' This should make sense. You might expect that doubling someone's income, say from \$1000 to \$2000 might raise their life expectancy from for example 40 to 50. However when you reach an income of \$50,000, your maximum life expectancy is against a limit and therefore, we should expect that the relationship between life expectancy and GDP per capita is non-linear.
#'
#' It just so happens that relationships that follow that "Crashing Wave" pattern when plotted tend to be linear in the logs, meaning if we instead estimate
#'$$
#'  \log(lifeExp_{i}) = \beta_0 + \beta_1\log(gdpPercap_i) + u_i
#'$$
#'The underlying data generating process is $lifeExp = \gamma_1* gdpPercap^{\gamma_2}*e_i$. Taking the log of both sides makes it linear so that we can estimate with OLS. Let's take log on both lifeExp and gdpPercap by using `log()` function, then regress log(lifeExp) on log(gdpPercap) and call the resulting regression object `reg2`. 
reg2 = lm(log(lifeExp)~log(gdpPercap), data = gapminder)
#'Let's visualize our second regression superimposed on the logged data.

gapminder %>%
  ggplot(aes(x = log(gdpPercap), y = log(lifeExp))) +
  geom_point(aes(color = continent), alpha = 0.4) +
  geom_smooth(method = 'lm', color = "black") +
  labs(title = "Life Expectancy by GDP Per Capita",
       subtitle = "1952-2007",
       x = "GDP Per Capita (USD)",
       y = "Life Expectancy (years)",
       color = "Continent")


#'## Hypothesis Testing

#'We wish to test whether GDP per capita has **any impact** on life expectancy my testing the null hypothesis
#'$$ H_0:\; \beta_1 = \beta_1^0$$
#' For this t-test, we set $\beta_1^0$ equal to 0, because we are interested in testing whether GDP per capita has **any effect** on life expectancy. 

#'  Recall that our $t$-test statistic is given by
#'$$
#'  t = \frac{\hat{\beta}_1 - \beta_1^0}{\textrm{s.e.}(\hat{\beta_1})}
#'$$
#'First we need to pull out our estimate from `reg2`. Let's create an object called `beta1hat` that stores the estimated value.
beta1hat=0.146549
#' You could also store the slope estimate as the following:
# Step by step
reg2 %>% tidy() 
reg2 %>% tidy() %>% filter(term=="log(gdpPercap)") 
reg2 %>% tidy() %>% filter(term=="log(gdpPercap)") %>% select(estimate) 
reg2 %>% tidy() %>% filter(term=="log(gdpPercap)") %>% select(estimate) %>% .[[1]]
beta1hat = reg2 %>% tidy() %>% filter(term=="log(gdpPercap)") %>% select(estimate) %>% .[[1]]


#'Now we need is $\textrm{s.e.}(\hat{\beta}_1)$. Recall that the formula for $\textrm{s.e.}(\hat{\beta}_1)$ is given by
#'$$
#'\textrm{s.e.}(\hat{\beta}_1) = \sqrt{\frac{\hat{\sigma}_u^2}{\sum_i(X_i - \bar{X})^2}}
#'$$
#'where
#'$$
#'\hat{\sigma}_u^2 = \frac{1}{n-2}\sum_i \hat{u}_i^2
#'$$
#'Here we need two piece of information: $n$ and $\sum_i \hat{u}_i^2$. You can find $n$ using the `nrow()` function on `gapminder`. Let's store this value as $n$.
n = nrow(gapminder)
#'We can obtain a vector of our residuals from `reg2` using the `resid()` function; we can then square those residuals using `^2` and sum them up using `sum()`. 
sigmahat = sum(resid(reg2)^2)/(n-2)
se_beta1hat=sqrt(sigmahat/sum((log(gapminder$gdpPercap)-mean(log(gapminder$gdpPercap)))^2)) 
#'Now we have all the pieces for the standard error of $\hat{\beta}_1$. The #'following code chunk should assemble them:

#'Now that we have all the pieces of `t`, we can calculate the $t$-stat.
t_stat=(beta1hat-0)/se_beta1hat
t_stat

#' Notice that t_stat that you calculated manually is equivalent to the regression results.
#'Use the `qt()` function to find the 95% critical value for the test. `qt()` takes two arguments, the first is the fraction of distribution you want to be less than your $t$-stat, and the second is the degrees of freedom.
t_stat > qt(p=0.975, df = n-2)



#'Finally, use the `pt()` function to find the attained significance for $\hat{\beta}_1$. `pt()` takes a $t$-stat as its first argument and degrees of freedom as the second argument, then returns *the proportion of t-scores below that t-score*. However, if you specify the argument `lower.tail=FALSE`, then this returns the proportion of t-score that is above that t-score. 
pt(t_stat , df=n-2, lower.tail=FALSE)

## Now your turn

#' Please open up the `05-Exercise.R` and fill out your answer for each question.

