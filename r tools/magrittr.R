# DST_01_06_magrittr.R

# INSTALL AND LOAD PACKAGES ################################

install.packages("magrittr")
library(magrittr)
library(datasets)

# LOAD DATA ################################################

?UCBAdmissions
UCBAdmissions

# PIPES VS NESTING #########################################

# Nested Commands ##########################################

# Conventional, nested command; read inner to outer.
# Percentage of applicants admitted to each program.
round(prop.table(margin.table(UCBAdmissions, 3)), 2) * 100

# Piped/Chained Commands ###################################

# Same command with pipes. Commands are read top to bottom. 
# Read "%>%" as "then." Uses aliases for most operators. 
# Note: Wrapping functions in percent signs is R's method
# for creating user-defined infix operators.

UCBAdmissions       %>%
  margin.table(3)   %>%
  prop.table        %>%
  round(2)          %>%
  multiply_by(100)       # Magrittr alias for *
# `*`(100)             # Alternative alias for *

?add  # Full list of magrittr aliases

# PIPES VS MULTIPLE VARIABLES ##############################

# Common approach to building analyses by creating multiple 
# variables. Note that by putting commands in parentheses, 
# R will save AND display the results.
(x1 <- 1:11)     # x gets numbers 1 through 11
(x2 <- x1 + 1)   # Add 1
(x3 <- x2 * 2)   # Multiply by 2
(x4 <- x3^2)     # Square
(x5 <- sum(x4))  # Sum

# Compound assignment operator "%<>%" avoids duplicating
# names in commands by simultaneously specifying source and
# output (which overwrites source).
y <- 1:11
y %<>%
  add(1) %>%
  multiply_by(2) %>%
  raise_to_power(2) %>%
  sum %>%
  print

# Alternative magrittr method with same result, although
# this method does not overwrite the original variable.
z <- 1:11
z %>%
  `+`(1) %>%
  `*`(2) %>%
  `^`(2) %>%
  sum

# PIPING TO OTHER ARGUMENTS ################################

# By default, data is piped to first argument but a dot "."
# can be used to specify other locations for piping data.
10:12 %>% paste(., ":", month.name[.])

# CLEAN UP #################################################

# Clear workspace
rm(list = ls()) 

# Clear packages
detach("package:magrittr", unload = TRUE)
detach("package:datasets", unload = TRUE)

# Clear console
cat("\014")  # ctrl+L
