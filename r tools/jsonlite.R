# DST_01_04_jsonlite.R

# INSTALL AND LOAD PACKAGES ################################

install.packages("jsonlite")
library(jsonlite)

# GET JSON DATA ############################################

# Data from http://ergast.com/mrd/
# File: http://ergast.com/api/f1/1954/results/1.json
# Page shows raw, unstructured JSON data

url <- "http://ergast.com/api/f1/1954/results/1.json"
obs <- fromJSON(url)  # Put data into list

# See entire list (it's huge)
obs

# See nested JSON stucture
toJSON(obs, pretty = T)

# LOCATE DATA ##############################################

# Want four pieces of data for each race:
# 1. Name of race,
# 2 & 3. Winning driver's first & last name
# 4. Winning team.

# Race name is in:
obs$MRData$RaceTable$Races

# Name of winning driver and team are in:
obs$MRData$RaceTable$Races$Results

# Need to give index numbers for three layers of objects
# First number is race (index 1-9 in this case)
# Second number gets to driver data frame (always index 5)
# Third number gets driver info:
#   First name: Index 3
#   Last name:  Index 4
# Example: Third race, driver info, last name:
obs$MRData$RaceTable$Races$Results[[3]][[5]][[4]]

# CREATE LOOP TO EXTRACT DATA ##############################

# Make identifiers a little shorter
races <- obs$MRData$RaceTable$Races

# Count number of races in season (9 in this case)
race_n <- length(races$Results)
race_n

# Create empty vectors to hold values
race <- name1 <- name2 <- team <- NULL

# For loop to extract data & place in separate vectors
for (i in 1:race_n) {
  race[i]  <- races$raceName[[i]]
  name1[i] <- races$Results[[i]][[5]][[3]]
  name2[i] <- races$Results[[i]][[5]][[4]]
  team[i]  <- races$Results[[i]][[6]][[3]]
}

# COMBINE DATA #############################################

# Combine vectors into single data frame
win <- data.frame(race, name1, name2, team)

# Rename columns in data frame
colnames(win) <- c('Race', 'FirstName', 'LastName', 'Team')

# PRINT DATA ###############################################

win  # Right justified by default
print(win, right = F)  # Left justify

# CLEAN UP #################################################

# Clear workspace
rm(list = ls()) 

# Clear packages
detach("package:jsonlite", unload = TRUE)

# Clear console
cat("\014")  # ctrl+L
