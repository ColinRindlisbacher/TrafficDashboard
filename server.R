
#
# file: server.R
# Author: Colin Rindlisbacher
# Dependencies: shiny, dplyr, ggplot2, DT
#
# Description: Server logic for Traffic Data Dashboard.
# Loads in Traffic csv, filters data and renders table 
# and plot to be displayed.
#
# Note: Traffic.csv sourced from:
# https://www.kaggle.com/datasets/hasibullahaman/traffic-prediction-dataset?select=Traffic.csv
#


library(shiny)
library(dplyr)
library(ggplot2)
library(DT)


shinyServer(function(input, output, session) {
  
  trafficData <- reactive({
    data <- read.csv("Traffic.csv")
    
    # data is currently in columns of DATE (int 1 - 31) and Time (HH:MM:SS AM/PM)
    # create new column DateTime that combines them into a datetime we can use a slider
    # to filter data from
    data <- data %>%
      mutate(
        DateTime = as.POSIXct(paste0("2024-01-", Date, " ", Time), format = "%Y-%m-%d %I:%M:%S %p")
      )
    return(data)
  })
  
  # filter data to be within bounds of slider input
  filteredData <- reactive({
    req(trafficData())
    data <- trafficData()
    
    data <- data %>%
      filter(DateTime >= input$timeRange[1] & DateTime <= input$timeRange[2])
    
    return(data)
  })
  
  # plot render
  output$trafficPlot <- renderPlot({
    data<-filteredData()
    ggplot(data, aes(x = DateTime, y = Total)) +
       geom_line() +
       labs(title = "Total Traffic Over Time", x = "DateTime", y = "Total Vehicles") +
      theme_minimal()
  })
  
  # data table render
   output$trafficTable <- renderDT({
     req(filteredData())
     filteredData()
   })
   
   # Update slider range dynamically based on the available data
   observe({
     req(trafficData())
     data <- trafficData()
     updateSliderInput(session, "timeRange", min = min(data$DateTime), max = max(data$DateTime), value = range(data$DateTime))
   })
   
   # TODO: Look for other potential graphs/visuals to add

  
})
