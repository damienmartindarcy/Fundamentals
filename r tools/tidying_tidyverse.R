library("tidyverse")

transport_data <- read_csv("data/transport_data.csv") %>%
  group_by(receiver.country, receiver.city) %>%
  select(date, number.of.items)






contrived_data <- data_frame(
  name = c(letters, LETTERS),
  group = rep(c("one","two","three","four"), each = 13),
  value = 1:52,
  normal.var = rnorm(52, mean = 100, sd = 5),
  uniform.var = runif(52, min = 1000, max = 2000),
  logical.var = sample(c(TRUE,FALSE), size = 52, replace = TRUE)
)
