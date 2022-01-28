#' Read in the data and answer the following questions.
#' Interpreting the regression results.
#'
state_data <- read_csv("03-Introduction_tidyverse_data.csv")
state_data_2017 <- state_data %>%
  filter(year == 2017)
some_data <- tibble(
  X = 1:100 + rnorm(100,0,1),
  Y = 0.5*X + rnorm(100,0,1)
)

#' 1. Run a linear regression.
library(broom)
lm(Y~X, some_data) %>% tidy()


#' 2. Write out codes to produce the same estimate for the $\beta_0$ and $\beta_1$.
#' 3. Write out codes to produce the statistic for the $\beta_0$ and $\beta_1$.

#' 4. Interpret the t-statistics and p-value.
