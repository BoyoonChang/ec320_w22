
#' We continue to use `CASchools` dataset to do the regressions.
#' Let's consider different specifications of the regression model as shown below:
#'
library(pacman)
p_load(AER, tidyverse, huxtable, car)
data("CASchools")
CASchools$STR <- CASchools$students/CASchools$teachers
CASchools$score <- (CASchools$read + CASchools$math)/2
reg1 <- lm(score ~ STR, data = CASchools)
reg2 <- lm(score ~ STR + english, data = CASchools)
reg3 <- lm(score ~ STR + english + lunch, data = CASchools)
reg4 <- lm(score ~ STR + english + calworks, data = CASchools)
reg5 <- lm(score ~ STR + english + lunch + calworks, data = CASchools)
huxreg(reg1,reg2,reg3,reg4,reg5)
#' Remove the # in front of the codes and fill in the blanks.
#'
#'
#'
# 1. Calculate the bias on the estimate of `STR` by omitting `english` variable.
#___$coef[3][[1]]*cov(CASchools$___, CASchools$___)/var(CASchools$___)




# Suppose we'd like to test hypotheses that involves multiple parameters.
# Let's set our null hypothesis such that beta2=beta3=0, where
# beta2 is coefficient of `english` and beta3 is coefficient of `lunch`.
# Hint: Your unrestricted and restricted models are related to `reg1` and `reg3`


# 2. Calculate the unrestricted model's R-squared
#summary(___)$r.squared



# 3. Calculate the restricted model's R-squared
#summary(___)$r.squared



# 4. Calculate the degrees of freedom for denominator
#nrow(CASchools)-nrow(summary(___)$coef)



# 5. Calculate the degrees of freedom for numerator (number of restrictions)
#q = ___



# 6. Calculate the F statistic
#((summary(___)$r.squared-summary(___)$r.squared)/q)/
#  ((1-summary(___)$r.squared)/(nrow(CASchools)-nrow(summary(reg3)$coef)))



# 7. Is F-stat greater than F-critical value (95% one-sided test)?
#((summary(___)$r.squared-summary(___)$r.squared)/q)/
#  ((1-summary(___)$r.squared)/(nrow(CASchools)-nrow(summary(reg3)$coef)))>
#  qf(0.95, q, nrow(CASchools)-nrow(summary(reg3)$coef))



# 8. What's your conclusion? Do you reject the null or fail to reject the null?




# Go ahead and compare your results with the one using the packaged function `linearHypothesis()`
linearHypothesis(reg3, c("english=0", "lunch=0"))
