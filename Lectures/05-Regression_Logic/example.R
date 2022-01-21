library(tidyverse)
tibble(
  y = c(1:5)+rnorm(5),
  x = c(2:6)
) -> hypothetical_data
fitted_y=hypothetical_data %>% lm(y ~ x, data =.) %>% fitted.values(y)
cbind(hypothetical_data, fitted_y) %>% view()
