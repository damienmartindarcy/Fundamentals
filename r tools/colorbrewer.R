

# INSTALL AND LOAD PACKAGES ################################

# Derived from ColorBrewer 2.0
browseURL("http://colorbrewer2.org/")
install.packages("RColorBrewer")
library(RColorBrewer)
library(datasets)

# EXPLORE RCOLORBREWER #####################################

display.brewer.all()            # See all palettes

# Three kinds of palettes
# 1. Sequential ("seq"): Low to high values 
# 2. Diverging ("div"): Mid vs. extremes
# 3. Qualitative ("qual"): Different classes

brewer.pal.info  # Info on all palettes

# To see colors in individual palette, give number 
# of colors desired and name of palette in quotes.
display.brewer.pal(8, "Accent")  # Individual palette

# LOAD AND EXPLORE DATA ####################################

# Use iris data from datasets package
# Measures for three species of iris
head(iris)               # Quick look at top of data set
data <- iris[, 1:4]      # Save measurements to "data"
species <- iris$Species  # Save species to "species"
summary(species)         # Get frequencies for species
plot(data)               # Get scatterplot matrix

# COLORS FOR PLOT ##########################################

plot(data, col = species)  # Color by species (jarring!)

# RColorBrewer has eight qualitative palettes: 
# Accent, Dark2, Paired, Pastel1, Pastel2,
# Set1, Set2, and Set3. 

# Need to specify number of colors needed, k, which should
# match number of groups. Can specify manually (k = 3 in 
# this case) or use a function: length(unique(species)).
k <- length(unique(species))
k

plot(data, 
     col = brewer.pal(k, "Set2")[species],
     pch = 19)  # Use solid circles

# CLEAN UP #################################################

# Clear workspace
rm(list = ls()) 

# Clear packages
detach("package:RColorBrewer", unload = TRUE)
detach("package:datasets", unload = TRUE)

# Clear plots
dev.off() 

# Clear console
cat("\014")  # ctrl+L
