library(shiny)
library(shinyalert)
library(tidyverse)
library(dplyr)
library(readr)
library(ggplot2)

# read and combine the ban data once, when the app starts 

train <- read_delim("data/train.csv", delim = ";")
test <- read_delim("data/test.csv", delim = ";")

bank_all <- bind_rows(train, test)
bank <- distinct(bank_all)

ui <- fluidPage(
  titlePanel("Bank Marketing Explorer"),
  sidebarLayout(
    sidebarPanel(
      h4("Subset the data"),
      p("Widgets go here")
    ),
    mainPanel(
      tabsetPanel(
        id = "tabs",
        tabPanel("About",
          p("About tab goes here")
        ),
        tabPanel("Data Download",
                 p("Data Download tab goes here")
        ),
        tabPanel("Data Exploration",
                 p("Data Exploration tab goes here")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
}

# Run the application 
shinyApp(ui = ui, server = server)