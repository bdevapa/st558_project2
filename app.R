library(shiny)
library(shinyalert)
library(tidyverse)
library(dplyr)
library(readr)
library(ggplot2)
library(DT)

# read and combine the ban data once, when the app starts 

train <- read_delim("data/train.csv", delim = ";")
test <- read_delim("data/test.csv", delim = ";")

bank_all <- bind_rows(train, test)
bank <- distinct(bank_all)

numeric_vars <- c("age","balance","day","duration","campaign","pdays","previous")
categorical_vars <- c("job","marital","education","default","housing","loan","contact","month","poutcome","y")

ui <- fluidPage(
  titlePanel("Bank Marketing Explorer"),
  sidebarLayout(
    sidebarPanel(
      h3("Subset the data"),
      radioButtons(inputId = "education_level", label = "Education", 
                   choiceNames = c("All","Primary", "Secondary", "Tertiary","Unknown"),
                   choiceValues = c("all","primary","secondary","tertary","unknown")),
      radioButtons(inputId = "marital_status", label = "Marital Status", 
                   choiceNames = c("All","Married", "Single", "Divorced"),
                   choiceValues = c("all","married","single","divorced")),
      h4("Select Numeric Variables:"),
      selectizeInput(input = "num_var1", label = "First Numeric Variable",
                     choices=numeric_vars, select = "age"),
      uiOutput("num_slider1"),
      selectizeInput(input = "num_var2", label = "Second Numeric Variable",
                     choices=numeric_vars, select = "balance"),
      uiOutput("num_slider2"),
      actionButton("subset_btn", "Subset the data"),
      br(),
      textOutput("n_rows")
    ),
    mainPanel(tabsetPanel(
      id = "tabs",
      tabPanel("About", fluidRow(
        column(
          8,
          h3("About this app"),
          p(
            "This app let's you uexplore the data from a Portuguese bank's phone marketing campaigns."
          ),
          p(
            "Data:",
            a("Banking Dataset - Marketing Targets (Kaggle)", href = "https://www.kaggle.com/datasets/prakharrathi25/banking-dataset-marketing-targets")
          ),
          tags$ul(
            tags$li(strong("Sidebar:"), "pick a subset, then click 'Subset the data'."),
            tags$li(
              strong("Data Download:"),
              "view and download the subset as a csv file."
            ),
            tags$li(
              strong("Data Exploration:"),
              "tables, summaries and plots of the subset."
            )
          )
        ), column(
          4,
          img(src = "bank.jpeg", class = "img-responsive", alt = "Picture of a bank")
        )
      )),
      tabPanel("Data Download",
               downloadButton("download_data", "Download data as .csv"),
               br(),
               br(),
               DT::dataTableOutput("data_table")
               ),
      tabPanel("Data Exploration", p("Data Exploration tab goes here"))
    ))
  )
)

server <- function(input, output, session) {
  observeEvent(input$num_var1, {
    num_var1 <- input$num_var1
    num_var2 <- input$num_var2
    choices <- numeric_vars
    if(num_var1 != num_var2){
      choices <- choices[-which(choices == num_var1)]
      updateSelectizeInput(session,
                           "num_var2",
                           choices = choices,
                           selected = num_var2)
    }
  })
  
  observeEvent(input$num_var2, {
    num_var1 <- input$num_var1
    num_var2 <- input$num_var2
    choices <- numeric_vars
    if(num_var1 != num_var2){
      choices <- choices[-which(choices == num_var2)]
      updateSelectizeInput(session,
                           "num_var1",
                           choices = choices,
                           selected = num_var1)
    }
  })
  
  output$num_slider1 <- renderUI({
    values <- bank[[input$num_var1]]
    sliderInput("num_range1", paste0("Range of", input$num_var1),
                min = min(values), max = max(values),
                value = c(min(values), max(values)))
  })
  
  
  output$num_slider2 <- renderUI({
    values <- bank[[input$num_var2]]
    sliderInput("num_range2", paste0("Range of", input$num_var2),
                min = min(values), max = max(values),
                value = c(min(values), max(values)))
  })
  
  #define the storage 
  bank_subset <- reactiveValues(data = NULL)
  
  observeEvent(input$subset_btn, {
    req(input$num_range1, input$num_range2)
    
    if(input$education_level == "all") {
      edu_subset <- c("primary", "secondary", "tertiary", "unknown")
    } else {
      edu_subset <- input$education_level
    }
    
    if(input$marital_status == "all") {
      marital_subset <- c("married", "single", "divorced")
    } else {
      marital_subset <- input$marital_status
    }
    
    bank_subset$data <- bank |>
      filter(education %in% edu_subset,
             marital %in% marital_subset,
             get(input$num_var1) >= input$num_range1[1],
             get(input$num_var1) <= input$num_range1[2],
             get(input$num_var2) >= input$num_range2[1],
             get(input$num_var2) <= input$num_range2[2])
      
  })
  
  
  output$n_rows <- renderText({
    validate(
      need(!is.null(bank_subset$data), "Make your selections and click the 'Subset the data' button.")
    )
    paste("Rows in the current data:", nrow(bank_subset$data))
    
  })
  
  output$data_table <- DT::renderDataTable({
    validate(
      need(!is.null(bank_subset$data), "Make your selections and click the 'Subset the data' button.")
    )
    bank_subset$data
  })
  
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("bank-subset-",Sys.Date(), '.csv')
    },
    content = function(con) {
      write.csv(bank_subset$data,con)
    }
  )
  
}

# Run the application 
shinyApp(ui = ui, server = server)