# DST_01_11_ggvis.R

# INSTALL AND LOAD PACKAGES ################################

install.packages("ggvis")
library(ggvis)
library(datasets)

# LOAD DATA ################################################

head(iris)

# Plots appear in Viewer window, not Plots

# Basic scatterplot
iris %>% 
  ggvis(~Sepal.Length, ~Sepal.Width) %>% 
  layer_points()

# Scatterplot, smoother
iris %>% 
  ggvis(~Sepal.Length, ~Sepal.Width) %>% 
  layer_points() %>%
  layer_smooths(se = T)

# Scatterplot, grouped
iris %>% 
  ggvis(~Sepal.Length, ~Sepal.Width) %>% 
  layer_points(fill = ~Species)

# Scatterplot, grouped, regression
iris %>% 
  ggvis(~Sepal.Length, ~Sepal.Width) %>% 
  layer_points(fill = ~Species) %>%
  group_by(Species) %>% 
  layer_model_predictions(model = "lm")

## Interactivity ###########################################

# ggvis can provide interactive control for 
# 1. arguments to transforms
# 2. properties
#
# ggvis can NOT provide interactive control to 
# 1. add or remove layers
# 2. switch between different datasets

# Color by group vs. no
iris %>% 
  ggvis(~Sepal.Length, ~Sepal.Width) %>% 
  layer_points(fill = ~Species, 
               # Vary size of points
               size := input_slider(0, 400, label = "Size"),
               # Vary opacity of points
               opacity := input_slider(0, 1, label = "Opacity")) %>% 
  # Vary kind of fit (linear vs. loess)
  layer_model_predictions(model = input_radiobuttons(
    choices = c("Linear" = "lm", "LOESS" = "loess"),
    selected = "lm",
    label = "Model type"))

# CLEAN UP #################################################

# Clear packages
detach("package:ggvis", unload = TRUE)
detach("package:datasets", unload = TRUE)

# Clear viewer manually by clicking broom

# Clear console
cat("\014")  # ctrl+L
