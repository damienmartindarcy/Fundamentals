library("tidyverse")
library("readxl")

info <- read_excel("data-raw/transit-data.xlsx",
                   sheet = "info",
                   range = cell_cols("B:C"))

write_csv(info, path = "data/timeperiods.csv")

transport_data <- read_excel("data-raw/transit-data.xlsx",
                             sheet = "transport data",
                             skip = 1)

colnames(transport_data) <- make.names(colnames(transport_data))

colnames(transport_data)

write_csv(transport_data, path = "data/transport_data.csv")
