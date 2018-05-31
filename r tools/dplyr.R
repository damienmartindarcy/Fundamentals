# DST_01_07_dplyr.R

# INSTALL AND LOAD PACKAGES ################################

install.packages("dplyr")
library(dplyr)
library(datasets)

# LOAD DATA ################################################

?swiss
head(swiss)  # Only shows first 10 cases by default

## Explore Data ############################################

# Multiple histograms
oldpar <- par()     # Save graphical parameters
par(mfrow=c(2, 3))  # Change graphics to 2 rows & 3 col
colnames <- dimnames(swiss)[[2]]  # Save variable names
# Loop through variables
for (i in 1:ncol(swiss)) {
  hist(swiss[, i],
       main = colnames[i])
}
par <- oldpar       # Restore graphical parameters
plot(swiss)         # Scatterplot matrix

# BASIC "VERBS" OF DPLYR ###################################

# filter() (and slice())
# arrange()
# select() (and rename())
# distinct()
# mutate() (and transmute())
# summarise() (or summarize())
# sample_n() and sample_frac()

## Filter & Sort Data ######################################

filter(swiss, Catholic > 60)
# Same as swiss[swiss$Catholic > 60, ]

# Sort with arrange()
arrange(swiss, desc(Education), Catholic)

# Select columns
select(swiss, Education, Examination, Agriculture)

# Select adjacent columns, inclusive
select(swiss, Agriculture:Education)

# Exclusive selection
select(swiss, -(Catholic:Infant.Mortality))

# Extract distinct (unique) rows
distinct(select(swiss, Education))

## Calculate Columns #######################################

swiss1 <- swiss
swiss1 <- mutate(swiss1,
                 rank_Catholic = rank(-Catholic),  # Reverse for ranking
                 majority_Catholic = ifelse(Catholic > 50, "True", "False")
)

swiss1 %>%
  select(Catholic, rank_Catholic, majority_Catholic) %>%
  arrange(desc(Catholic))

# Keep only the new variables
swiss2 <- swiss
swiss2 <- transmute(swiss2,
                    rank_Catholic = rank(-Catholic),  # Reverse for ranking
                    majority_Catholic = ifelse(Catholic > 50, "True", "False")
)
swiss2

## Sample Cases ############################################

# Randomly sample rows with sample_n() and sample_frac()
# Use replace = TRUE to perform a bootstrap sample.
sample_n(swiss, 10)
sample_frac(swiss, 0.20)

# GROUPED OPERATIONS #######################################

by_majority <- group_by(swiss1, majority_Catholic)
summarize(by_majority,
          count = n(),
          ag_mean = mean(Agriculture))

# CLEAN UP #################################################

# Clear workspace
rm(list = ls()) 

# Clear packages
detach("package:dplyr", unload = TRUE)
detach("package:datasets", unload = TRUE)

# Clear plots
dev.off() 

# Clear console
cat("\014")  # ctrl+L
