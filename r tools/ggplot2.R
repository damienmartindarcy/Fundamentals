# DST_01_09_ggplot2.R

# INSTALL AND LOAD PACKAGES ################################

install.packages("ggplot2")
library(ggplot2)
library(datasets)

# LOAD DATA ################################################

## qplot: Quick Plot #######################################

# Basic dotplot by group.
qplot(Species, Petal.Length, data = iris)

# Dotplot, colored by group.
qplot(Species, 
      Petal.Length, 
      col  = Species, 
      data = iris)

# Dotplot, colored by group, jittered w/boxplots
qplot(Species, 
      Petal.Length, 
      col  = Species, 
      geom = c("boxplot", "jitter"), 
      data = iris)

## ggplot ##################################################

# Basic scatterplot
ggplot(iris, 
       aes(Petal.Width, Petal.Length)) +
  geom_point()

# Scatterplot, jittered
ggplot(iris, 
       aes(Petal.Width, Petal.Length)) +
  geom_jitter()

# Scatterplot, jittered, colored by species
ggplot(iris, 
       aes(Petal.Width, Petal.Length,
           size = Sepal.Length,
           color = Species)) +
  geom_jitter(alpha = .5)

# Scatterplot, colored by species, fit line
ggplot(iris, 
       aes(Petal.Width, Petal.Length,
           color = Species)) +
  geom_point(size = 3) +
  geom_smooth(method = lm)

# Scatterplot, colored by species, fit line, density
ggplot(iris, 
       aes(Petal.Width, Petal.Length,
           color = Species)) +
  geom_point(size = 3) +
  geom_smooth(method = lm) +
  geom_density2d(alpha = .5)

# Scatterplot, colored by species, fit line, density, facet
ggplot(iris, 
       aes(Petal.Width, Petal.Length,
           color = Species)) +
  geom_point(size = 3) +
  geom_smooth(method = lm) +
  facet_grid(Species ~ .) +
  geom_density2d(alpha = .5)

# CLEAN UP #################################################

# Clear workspace
rm(list = ls()) 

# Clear packages
detach("package:ggplot2", unload = TRUE)

# Clear plots
dev.off() 

# Clear console
cat("\014")  # ctrl+L
