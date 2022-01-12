#' Below minion_d is given. Use `%>%` to answer the following questions.
#' 
library(tidyverse)
tibble(
  name=c("Bob","Kevin","Stuart","Jerry", "Jorge"),
  weight=c(12,25,18,21,35),
  height=c(80,120,94,105,95),
  num_eyes=c(2,2,1,2,2)
) -> minion_d


# 1. Filter minion whose height is below 90.





# 2. Select height and num_eyes from minion_d




# 3. Create another column(variable) called `fav_color` which includes following information.
# Bob likes "red", 
# Kevin likes "orange"
# Stuart likes "green"
# Jerry likes "yellow"
# Jorge likes "grey"




# 4. Arrange `minion_d` by height in descending order






# 5. Group minions by number of eyes and then calculate the min, mean, max of weight as well as the number of observations for each group.







#' Submit the knitted html document on Canvas. You could click `File`>`Knit Document` or simply use shortcut, `Ctrl` `Shift` `K` to knit the Rmarkdown or R scripts. You may able to see the knitted document in the same folder that this .Rmd file is located (If you've downloaded the file directly from Canvas, the .Rmd may be located in `Downloads` folder by default and thus you may want to look for the knitted document there).

