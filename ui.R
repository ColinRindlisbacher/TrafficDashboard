#
# file: ui.R
# Author: Colin Rindlisbacher
# Dependencies: shiny, DT
#
# Description: User Interface for Traffic Data Dashboard.
# Creates the layout with the side DateTime slider, the 
# resulting plot and filtered datatable.
#


library(shiny)
library(DT)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Traffic Data Dashboard"),
  
  # Sidebar layout with date range input
  sidebarLayout(
    sidebarPanel(
      # DateTime range slider input
      sliderInput("timeRange", "Select Time Range", 
                  min = as.POSIXct("2024-01-01 00:00:00"),
                  max = as.POSIXct("2024-01-31 23:59:59"),
                  value = c(as.POSIXct("2024-01-01 00:00:00"), as.POSIXct("2024-01-31 23:59:59")),
                  timeFormat = "%Y-%m-%d %H:%M:%S")
    ),
    
    # Main panel to display the plot and data table
    mainPanel(
      plotOutput("trafficPlot"),
      DTOutput("trafficTable")
    )
  )
))