#' ---
#' title: "Mutliple Regression"
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

#+echo=FALSE
knitr::opts_chunk$set(echo = T, warning = F, message = F, cache = F)

#' ## Overview
#' - Calculate confidence interval
#' - Calculate omitted variable bias
#' - Conduct multiple regression using `lm()`
#' - Conduct F - tests
#'

#' ## Start with simple regression
#' ### Load packages
# load pacman
library(pacman)
# use p_load to load multiple packages at once
p_load(AER, tidyverse, huxtable, car)
# data() loads specified data set, in this case "CASchools"
data("CASchools")

#' As usual, we load pacman first and use `p_load` function to attach several packages that we will be using today; `AER` package contains the dataset that we will do our analysis, 2) `tidyverse` contains functions such as pipe operator that are useful for data analysis, 3) `huxtable` contains functions such as `huxreg` which produces nice formatted regression results.


#' ### Learn about the dataset

summary(CASchools)
glimpse(CASchools)
?CASchools

#' This CASchools is a dataset contained in AER package. It is California Test Score Data that contains "data on test performance, school characteristics and student demographic backgrounds for school districts in California," according to R documentation that you see on your help pane if you invoke `?CASchools`.
#'
#' ### Create two new variables
#' Next, we will create two new variables, 1) student to teacher ratio and 2) the average reading and math score for each school district.
CASchools$STR <- CASchools$students/CASchools$teachers
CASchools$score <- (CASchools$read + CASchools$math)/2

#' ### Do a simple regression
#' For the simple linear regression, we will have score as the dependent variable and student-to-teacher ratio as the explanatory variable and store its result as `reg1`. Notice that we defined STR as student to teacher ratio where we divided the number of students by the number of teacher.


reg1 <- lm(score ~ STR, data = CASchools)
summary(reg1)

#' The first regression result, which does not account for any control variables, shows that one unit increase in student-to-teacher ratio is associated with -2 unit decrease in scores. In other words, the reduction in the student-to-teacher ratio by one student per teacher is associated with approximately 2 point increase in average test scores without holding students characteristics constant.
#'
#'

#' ### Confidence Interval
#' Here I want to quickly go over how to calculate the confidence interval manually and using `tidy()` function.
#'
#' 1. Calculating confidence interval manually:
#'
#' Step 1: Find t-critical value for the two-sided test with 5% significance level
#' In a simple regression, $k$ equals to 2, as there are two parameters being estimated, $\beta_0$ and $\beta_1$.
n=nrow(CASchools)
k=2
qt(.05/2, n-k)
#'
#' Step 2: Store the coefficient estimate and its std.error
tidy(reg1) %>% filter(term=="STR") %>% select(std.error) %>% .[[1]] -> se_STR
tidy(reg1) %>% filter(term=="STR") %>% select(estimate) %>% .[[1]] -> est_STR
#'
#' Step 3: Use information from Step 1 and 2 to calculate the lower/upper bound of the confidence interval
est_STR + se_STR*qt(.05/2, n-k)
est_STR - se_STR*qt(.05/2, n-k)
#'
#' 2. Use `tidy()` to report confidence interval
tidy(reg1, conf.int = T)
#' Manual calculation should coincide with what is returned from using `tidy()` function.
# You can also specify the confidence level using conf.level argument
tidy(reg1, conf.int = T, conf.level = .9)

#'
#' ### Goodness of Fit
# mean of avg. test-scores
y_mean <- mean(CASchools$score)
# sum of squared residuals
SSR <- sum(residuals(reg1)^2)
# total sum of squares
TSS <- sum((CASchools$score - y_mean )^2)
# explained sum of squares
ESS <- sum((fitted(reg1) - y_mean)^2)
# R^2
Rsq <- 1 - (SSR / TSS)
Rsq
summary(reg1)$r.squared


#' ## Multiple Regression Using `lm()`
#' Until now, we only considered simply regressing the test score on student-to-teacher ratio without controlling for other factors.
#'
#' Here, we will consider three variables to control for the background characteristics of students in each school that might affect test scores: english, which is the percent of students who are still learning English, lunch, which denotes the percent of students qualifying for reduced-price lunch, and calworks, which denotes the percent of students qualifying for CalWorks (California income assistance program).
#'
#' The latter two variables could serve as indicators for students' economic background and thus be measures for the fraction of the economically disadvantaged children in the district.
#'
#' ### Model specification
#'
#' The first regression model is as follows:
#'
#' $\textrm{Score}_i = \beta_0+\beta_1\textrm{STR}_i + u_i$
reg1 <- lm(score~STR, data = CASchools)
#' The second regression model is as follows:
#'
#' $\textrm{Score}_i = \beta_0+\beta_1\textrm{STR}_i+\beta_2\textrm{English}_i + u_i$
reg2 <- lm(score ~ STR + english, data = CASchools)
#' The third regression model is as follows:
#'
#' $\textrm{Score}_i = \beta_0+\beta_1\textrm{STR}_i+\beta_2\textrm{English}_i +\beta_3\textrm{Lunch}_i+ u_i$
reg3 <- lm(score ~ STR + english + lunch, data = CASchools)
#' The fourth regression model is as follows:
#'
#' $\textrm{Score}_i = \beta_0+\beta_1\textrm{STR}_i+\beta_2\textrm{English}_i +\beta_3\textrm{Calworks}_i+ u_i$
reg4 <- lm(score ~ STR + english + calworks, data = CASchools)
#' The fifth regression model is as follows:
#'
#' $\textrm{Score}_i = \beta_0+\beta_1\textrm{STR}_i+\beta_2\textrm{English}_i +\beta_3\textrm{Lunch}_i+ \beta_4\textrm{Calworks}_i+ u_i$
reg5 <- lm(score ~ STR + english + lunch + calworks, data = CASchools)
# We use `huxreg()` function in `huxtable` package to show five regression results
# side-by-side in one table.
huxreg(reg1,reg2,reg3,reg4,reg5)

#' ### Discussion of the empirical results:
#' 1. Controlling for student characteristics reduces the effect of the student-teacher ratio on test scores approximately in half.
#' 2. The variables that control for student characteristics are useful in predicting test cores. Notice that the goodness of fit (R-squared) from the first regression is only `r round(summary(reg1)$r.squared,2)`. This means that the student-to-teacher ratio alone only explains a small fraction of the variation in test score. However, the goodness of fit increases significantly when student characteristic variables are added as controls.
#' 3. The individual control variable can be not statistically significant. For example, in specification (5), the percentage qualifying for income assistance is not statistically significant, meaning that it fails to reject the null hypothesis that the effect of the variable on the test score equals zero. We may consider `calworks` as redundant since adding `calworks` as an additional control to the base specification (3) does affect only marginally on the estimated coefficient/standard error for the student-to-teacher ratio and it is reported to be not statistically significant in determining the variation of the test score. It could be that its(`calworks`) effect on the test score is likely been already addressed by other control, in this case `lunch`, since both variables are indicators for students' economic background.
#'
#'








#' ## Omitted Variable Bias
#' Recall that under the following two models,
#' Model 1: $Y_i = \beta_0 + \beta_1 X_{1i} + u_i$.
#' Model 2: $Y_i = \beta_0 + \beta_1 X_{1i} + \beta_2 X_{2i} + v_i$,
#'
#' the formula for calculating omitted variable bias is as follows:
#' $${\text{Bias} = \beta_2 \frac{\mathop{\text{Cov}}(X_{1i}, X_{2i})}{\mathop{\text{Var}}(X_{1i})}}.$$
#'
#' Consider the specification (1) and (2) from the `CASchools` example above, and consider the specification (1) as model 1 and (2) as model 2. Then we can calculate the omitted variable bias for $\beta_1$ as follows:
cov(CASchools$STR, CASchools$english)
reg2$coef[3][[1]]*cov(CASchools$STR, CASchools$english)/var(CASchools$STR)
#' There's a negative omitted variable bias, meaning that omitting `english` has amplified the effect of `STR` negatively on the test core.
#' Comparing (reg1 STR coef) with (reg2 STR coef + omv bias)
near(reg2$coef[2][[1]]+reg2$coef[3][[1]]*cov(CASchools$STR, CASchools$english)/var(CASchools$STR), reg1$coef[2][[1]])




#' ## F-tests
#' Let's suppose we want to test to see if the coefficients on the percentage of students receiving lunch at a reduced price AND the percentage of students receiving income assistance are equal to zero at the 5% level. We will use the second and the fifth model specification to conduct an F-test. Recall that
#' the second model specification was as follows:
#'
#' $\textrm{Score}_i = \beta_0+\beta_1\textrm{STR}_i+\beta_2\textrm{English}_i + u_i$ -----(2) ,
#'
#' and the fifth model specification  was as follows:
#'
#' $\textrm{Score}_i = \beta_0+\beta_1\textrm{STR}_i+\beta_2\textrm{English}_i +\beta_3\textrm{Lunch}_i+ \beta_4\textrm{Calworks}_i+ u_i$ -----(5)
#'
#' First we set the null hypothesis, i.e. set up some guess about the unknown population parameters,
#'
#' in this case $\beta_3 = \beta_4 = 0$.
#'
#' We now know what our restricted and unrestricted models are: the restricted model is (2) while the unrestricted model is (5). Notice that we are restricting the model such that $\beta_3$ and $\beta_4$ are both equal 0. If you plug in 0 for $\beta_3$ and $\beta_4$ in model (5), it becomes model (2) and thus, the restricted model is model (2) while the unrestricted one is model (5).
#' Use following formula to calculate F-statistic:
#' \begin{align}
#' F_{q,\,n-k} = \dfrac{\left(\text{RSS}_u - \text{RSS}_r\right)/q}{\text{RSS}_u/(n-k)}
#' \end{align}
## H0: beta3=beta4=0
# unrestricted model's R-squared
summary(reg5)$r.squared
# restricted model's R-squared
summary(reg2)$r.squared
# degrees of freedom for denominator
nrow(CASchools)-nrow(summary(reg5)$coef)
# degrees of freedom for numerator (number of restrictions)
q = 2
# F statistic
((summary(reg5)$r.squared-summary(reg2)$r.squared)/q)/
  ((1-summary(reg5)$r.squared)/(nrow(CASchools)-nrow(summary(reg5)$coef)))
# F critical value
qf(0.95, q, nrow(CASchools)-nrow(summary(reg5)$coef))
# Is F-stat greater than F-critical value?
((summary(reg5)$r.squared-summary(reg2)$r.squared)/q)/
  ((1-summary(reg5)$r.squared)/(nrow(CASchools)-nrow(summary(reg5)$coef)))>
  qf(0.95, q, nrow(CASchools)-nrow(summary(reg5)$coef))
#' Conclusion: Reject the null that $\beta_3$ and $\beta_4$ are all equal to 0
#' Also we could use packaged function `linearHypothesis()` for hypothesis testing.
linearHypothesis(reg5, c("lunch=0", "calworks=0"))

## Now your turn

#' Please open up the `06-Exercise.R` and fill out your answer for each question.










