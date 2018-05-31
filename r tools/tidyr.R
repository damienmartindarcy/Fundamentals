# DST_01_08_tidyr.R

# INSTALL AND LOAD PACKAGES ################################

install.packages("tidyr")
library(tidyr)

# CREATE WIDE DATA #########################################

# For this demonstation, we'll create artificial data with
# two within-subjects conditions and two time points for
# each condition.
n <- 10  # Number of cases
data0 <- data.frame(
  id = 1:n,                              # Case ID
  t1_a = sample(0:100, n, replace = T),  # Time 1, cond A
  t1_b = sample(0:100, n, replace = T),  # Time 1, cond B
  t2_a = sample(0:100, n, replace = T),  # Time 2, cond A
  t2_b = sample(0:100, n, replace = T)   # Time 2, cond B
)
data0  # See the complete data set

# CONVERT TO TALL DATA #####################################

# Use tidyr's "gather()" to convert from wide to tall data. 

data1 <- data0 %>%
  gather(time_cond, score, -id)
head(data1, 15)

## Split Key Variable ######################################

# In this example data set, the key variable and its values
# represents TWO variables: time AND condition. For proper
# analysis, these need to show as separate variables. Use
# tidyr's "separate()" to split them.

data2 <- data1 %>%
  separate(time_cond, into = c("time", "cond"), sep = "_") 
head(data2)

# CONVERT TO WIDE DATA #####################################

# Use tidyr's "spread()" to convert from wide to tall data.

# Use "unite()" to get two key variables back into single
# variable
data3 <- data2 %>%
  unite(time_cond, time, cond) %>%
  spread(time_cond, score) %>%
  print  # Show the resulting data in the console.
