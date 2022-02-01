#' Answer the following questions.
#'
library(tidyverse)
some_data <- tibble(
  X = 1:100 + rnorm(100,0,1),
  Y = 0.5*X + rnorm(100,0,10)
)

#' 1. Use `lm()` function to regress Y on X defined in some_data.





#' 2. Write out codes to produce $\beta_1$ using the formula.
#' Make sure it produces the same estimate with that when using `lm()`.
#'
#' Formula for slope coefficient:
#' $$\hat{\beta}_1 = \dfrac{\sum_{i=1}^n (Y_i - \bar{Y})(X_i - \bar{X})}{\sum_{i=1}^n  (X_i - \bar{X})^2}$$






#' 3. Write out codes to produce $\beta_0$ using the formula.
#' Make sure it produces the same estimate with that when using `lm()`.
#'
#' Formula for intercept coefficient:
#' $$ \hat{\beta}_0 = \bar{Y} - \hat{\beta}_1 \bar{X} $$






#' 4. Create a scatter plot about `some_data` that shows the relationship between $X$ and $Y$.
#' Then add a layer using `geom_smooth()` to create a fitted line that uses `lm` method.




