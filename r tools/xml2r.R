# xml2r

# INSTALL AND LOAD PACKAGES ################################

install.packages("XML2R")
library(XML2R)

# GET DATA & RESTRUCTURE ###################################

# Data from http://ergast.com/mrd/
# File: http://ergast.com/api/f1/1954/results/1.xml
# Right click to "View page source" and see raw XML

url <- "http://ergast.com/api/f1/1954/results/1.xml"
obs <- XML2Obs(url)
tab <- collapse_obs(obs)
tab  # Lots of printout

# Can write in one line (but use full URL)
# tables <- collapse_obs(XML2Obs("http:..."))

# EXTRACT & COMBINE DATA ###################################

race <- tab[["MRData//RaceTable//Race//RaceName"]]
race  # Check data

# Use "paste" to split a single identifier across lines
name1 <- tab[[paste("MRData//RaceTable//Race//",
                    "ResultsList//Result//",
                    "Driver//GivenName", sep = "")]]

name2 <- tab[[paste("MRData//RaceTable//Race//",
                    "ResultsList//Result//",
                    "Driver//FamilyName", sep = "")]]

team <- tab[[paste("MRData//RaceTable//Race//",
                   "ResultsList//Result//",
                   "Constructor//Name", sep = "")]]

# Combine matrices into a single data frame
win <- cbind.data.frame(race[ ,1], name1[, 1], 
                        name2[ ,1], team[ ,1])

# Rename columns in data frame
colnames(win) <- c('Race', 'FirstName', 'LastName', 'Team')

# PRINT DATA ###############################################

win
print(win, right = F)  # Left justify

# CLEAN UP #################################################

# Clear workspace
rm(list = ls()) 

# Clear packages
detach("package:XML2R", unload = TRUE)

# Clear console
cat("\014")  # ctrl+L
