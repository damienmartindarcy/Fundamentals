library("tidyverse")

transport_data <- read_csv("data/transport_data.csv")

item_per_group_summariser <-
  function(df, group, summarise.fn = mean) {
    df %>%
      group_by(group) %>%
      summarise(summary = summarise.fn(number.of.items))
  }
