## Data harvested from http://www.metoffice.gov.uk/public/weather/climate-historic/#?tab=climateHistoric

library("tidyverse")


oxford_weather <-
  read_table(file = "http://www.metoffice.gov.uk/pub/data/weather/uk/climate/stationdata/oxforddata.txt",
             skip = 5,
             col_names = TRUE) %>%
  slice(-1) %>%
  mutate(
    sun = gsub("\\**", "", sun),
    sun = gsub("Provisional", "", sun),
    sun = gsub("---", NA, sun),
    sun = as.numeric(sun)
  ) %>%
  mutate_if(is.character, as.numeric) %>%
  mutate(airport = "oxford")


bradford_weather <-
  read_table(file = "http://www.metoffice.gov.uk/pub/data/weather/uk/climate/stationdata/bradforddata.txt",
             skip = 5,
             col_names = TRUE) %>%
  slice(-1) %>%
  mutate(
    sun = gsub("\\**", "", sun),
    sun = gsub("Provisional", "", sun),
    sun = gsub("---", NA, sun),
    sun = as.numeric(sun)
  ) %>%
  mutate_if(is.character, as.numeric) %>%
  mutate(airport = "bradford")

heathrow_weather <-
  read_table(file = "http://www.metoffice.gov.uk/pub/data/weather/uk/climate/stationdata/heathrowdata.txt",
             skip = 5,
             col_names = TRUE) %>%
  slice(-1) %>%
  mutate(
    sun = gsub("\\**", "", sun),
    sun = gsub("Provisional", "", sun),
    sun = gsub("---", NA, sun),
    sun = as.numeric(sun)
  ) %>%
  mutate_if(is.character, as.numeric) %>%
  mutate(airport = "heathrow")


stornoway_weather <-
  read_table(file = "http://www.metoffice.gov.uk/pub/data/weather/uk/climate/stationdata/stornowaydata.txt",
             skip = 5,
             col_names = TRUE) %>%
  slice(-1) %>%
  mutate(
    sun = gsub("\\**", "", sun),
    sun = gsub("Provisional", "", sun),
    sun = gsub("---", NA, sun),
    sun = as.numeric(sun)
  ) %>%
  mutate_if(is.character, as.numeric) %>%
  mutate(airport = "stornoway")

british_weather <- oxford_weather %>%
  full_join(bradford_weather) %>%
  full_join(heathrow_weather) %>%
  full_join(stornoway_weather)

monthly_tdiff <- british_weather %>%
  mutate(tdiff = tmax - tmin) %>%
  group_by(airport, mm) %>%
  summarise(avg.tdiff = mean(tdiff, na.rm = TRUE)) %>%
  rename(month = mm)

wide_monthly_tdiff <- monthly_tdiff %>%
  spread(airport, avg.tdiff) 

colnames(wide_monthly_tdiff) <- c("month","bradford.tdiff","heathrow.tdiff", "oxford.tdiff","stornoway.tdiff")

write_csv(wide_monthly_tdiff, path = "data/wide_monthly_tdiff.csv")
write_csv(monthly_tdiff, path = "data/long_monthly_tdiff.csv")

write_csv(british_weather, path = "data/british_weather.csv")



