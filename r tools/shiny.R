# DST_01_12_Shiny
# app.R

# LOAD SHINY ###############################################

library(shiny)

# DEFINE SERVER FUNCTION ###################################

server <- function(input, output) {
  # Define histogram output
  output$irisHist <- renderPlot({  # "irisHist" in UI also
    ic   <- as.numeric(input$var)  # ic = "iris column"
    x    <- iris[, ic]
    bins <- seq(min(x), 
                max(x), 
                length.out = input$bins + 1)
    hist(x, 
         breaks = bins, 
         col    = '#8DC13D',  # Green 
         border = 'white',
         xlab   = "Centimeters",
         main   = paste("Histogram of", names(iris[ic]))
    )
  })
}

# DEFINE UI FUNCTION #######################################

ui <- fluidPage(
  titlePanel("Charting Iris Data"),
  sidebarLayout(
    sidebarPanel(
      # Dropdown menu for selecting variable from iris data.
      selectInput("var",
                  label = "Select variable",
                  choices = c("Sepal.Length" = 1,
                              "Sepal.Width"  = 2,
                              "Petal.Length" = 3,
                              "Petal.Width"  = 4),
                  selected = 1),  # Default selection
      # Slider to set bin width in histogram
      sliderInput("bins",
                  "Number of bins",
                  min   = 1,
                  max   = 30,
                  value = 15)
    ),
    mainPanel(
      plotOutput("irisHist")  # "irisHist" in server also
    )
  )
)

# CALL THE SHINY APP #######################################

shinyApp(ui = ui, server = server)

# NOTES ####################################################

# Run app by clicking "Run App" in top right of window.
# - Run in Window (opens new RStudio window; default)
# - Run in Viewer Pane
# - Run External (runs in local browser)

# Publish app by clicking on button in top right.
# - Need to create account at shinyapps.io and sign in.
# - When logging in from a new machine, will need to copy
#   and paste tokens into pop up window.
# - Give app name and click publish.
# - This app is called "DST_01_12_Shiny_App" and is at
#   https://bartonpoulson.shinyapps.io/DST_01_12_Shiny_App/
