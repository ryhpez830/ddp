
library(shiny)
library(plotly)
library(dplyr)
library(shinyalert) 

shinyUI(fluidPage(
  titlePanel("Generating Prime Numbers"),
  sidebarLayout(
    sidebarPanel(
      actionButton("Help1","?"),
      numericInput("Minimum", "Minimum (1 <= n <= 5000)" ,value = 1, min = 1, max = 5000, step=1), 
      numericInput("Maximum", "Maximum (1 <= n <= 5000)" ,value = 100, min = 1, max = 5000, step=1),
      actionButton("PlotButton","Plot")
    ),

    mainPanel( 
      plotlyOutput("plot1"),
      h3("Check for primality"),
      actionButton("Help2","?"),
      numericInput("X","Enter a natural number (1 <= n <= 10000)",value=1, min=1, max=10000, step=1),
      textOutput("question"),
      textOutput("answer")
    )
  )
))