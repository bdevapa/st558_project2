library(shiny)
library(dplyr)
library(readr)
library(ggplot2)
library(DT)

# read and combine the bank data once, when the app starts

train <- read_delim("data/train.csv", delim = ";")
test <- read_delim("data/test.csv", delim = ";")

bank_all <- bind_rows(train, test)
bank <- distinct(bank_all)

numeric_vars <- c("age",
                  "balance",
                  "day",
                  "duration",
                  "campaign",
                  "pdays",
                  "previous")
categorical_vars <- c(
  "job",
  "marital",
  "education",
  "default",
  "housing",
  "loan",
  "contact",
  "month",
  "poutcome",
  "y"
)

ui <- fluidPage(titlePanel("Bank Marketing Explorer"),
                sidebarLayout(
                  sidebarPanel(
                    h3("Subset the data"),
                    radioButtons(
                      inputId = "education_level",
                      label = "Education",
                      choiceNames = c("All", "Primary", "Secondary", "Tertiary", "Unknown"),
                      choiceValues = c("all", "primary", "secondary", "tertiary", "unknown")
                    ),
                    radioButtons(
                      inputId = "marital_status",
                      label = "Marital Status",
                      choiceNames = c("All", "Married", "Single", "Divorced"),
                      choiceValues = c("all", "married", "single", "divorced")
                    ),
                    h4("Select Numeric Variables:"),
                    selectizeInput(
                      inputId = "num_var1",
                      label = "First Numeric Variable",
                      choices = numeric_vars,
                      selected = "age"
                    ),
                    uiOutput("num_slider1"),
                    selectizeInput(
                      inputId = "num_var2",
                      label = "Second Numeric Variable",
                      choices = numeric_vars,
                      selected = "balance"
                    ),
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
                    tabPanel(
                      "Data Download",
                      downloadButton("download_data", "Download data as .csv"),
                      br(),
                      br(),
                      DT::dataTableOutput("data_table")
                    ),
                    tabPanel(
                      "Data Exploration",
                      radioButtons(
                        inputId = "summary_type",
                        label = "What do you want to summarize?",
                        choiceNames = c("Categorical Variables", "Numeric Variables"),
                        choiceValues = c("cat", "num"),
                        inline = TRUE
                      ),
                      conditionalPanel( #dynamic UI requirement 
                        "input.summary_type == 'cat'",
                        selectizeInput(
                          inputId = "cat_var1",
                          label = "Variable 1",
                          choices = categorical_vars,
                          selected = "y"
                        ),
                        selectizeInput(
                          inputId = "cat_var2",
                          label = "Variable 2 (optional)",
                          choices = c("none", categorical_vars),
                          selected = "none"
                        ),
                        h4("Contingency Table"),
                        verbatimTextOutput("cat_table"),
                        radioButtons(
                          inputId = "cat_plot_type",
                          label = "Plot Type",
                          choiceNames = c("Bar Chart", "Heatmap of Subscription Rate"),
                          choiceValues = c("bar", "heatmap"),
                          inline = TRUE
                        ),
                        shinycssloaders::withSpinner(plotOutput("cat_plot"))
                        #plotOutput("cat_plot")
                      ),
                      
                      
                      conditionalPanel(
                        "input.summary_type == 'num'",
                        selectizeInput(
                          inputId = "num_summary_var",
                          label = "Numerical Variable",
                          choices = numeric_vars,
                          selected = "duration"
                        ),
                        selectizeInput(
                          inputId = "group_var",
                          label = "Summarize Across Levels of",
                          choices = categorical_vars,
                          selected = "y"
                        ),
                        h4("Summary Statistics"),
                        tableOutput("num_table"),
                        radioButtons(
                          inputId = "num_plot_type",
                          label = "Plot Type",
                          choiceNames = c("Histogram", "Box Plot"),
                          choiceValues = c("hist","box"),
                          inline = TRUE
                        ),
                        conditionalPanel(
                          "input.num_plot_type == 'hist'",
                          selectizeInput(
                            inputId = "facet_var",
                            label = "Facet By",
                            choices = c("none", categorical_vars),
                            selected = "none"
                          )
                        ),
                        shinycssloaders::withSpinner(plotOutput("num_plot"))
                        #plotOutput("num_plot")
                      )
                      
                    )
                  ))
                ))

server <- function(input, output, session) {
  observeEvent(input$num_var1, {
    num_var1 <- input$num_var1
    num_var2 <- input$num_var2
    choices <- numeric_vars
    if (num_var1 != num_var2) {
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
    if (num_var1 != num_var2) {
      choices <- choices[-which(choices == num_var2)]
      updateSelectizeInput(session,
                           "num_var1",
                           choices = choices,
                           selected = num_var1)
    }
  })
  
  output$num_slider1 <- renderUI({
    values <- bank[[input$num_var1]]
    sliderInput(
      "num_range1",
      paste0("Range of ", input$num_var1),
      min = min(values),
      max = max(values),
      value = c(min(values), max(values))
    )
  })
  
  
  output$num_slider2 <- renderUI({
    values <- bank[[input$num_var2]]
    sliderInput(
      "num_range2",
      paste0("Range of ", input$num_var2),
      min = min(values),
      max = max(values),
      value = c(min(values), max(values))
    )
  })
  
  #define the storage
  bank_subset <- reactiveValues(data = NULL)
  
  observeEvent(input$subset_btn, {
    req(input$num_range1, input$num_range2)
    
    if (input$education_level == "all") {
      edu_subset <- c("primary", "secondary", "tertiary", "unknown")
    } else {
      edu_subset <- input$education_level
    }
    
    if (input$marital_status == "all") {
      marital_subset <- c("married", "single", "divorced")
    } else {
      marital_subset <- input$marital_status
    }
    
    bank_subset$data <- bank |>
      filter(
        education %in% edu_subset,
        marital %in% marital_subset,
        get(input$num_var1) >= input$num_range1[1],
        get(input$num_var1) <= input$num_range1[2],
        get(input$num_var2) >= input$num_range2[1],
        get(input$num_var2) <= input$num_range2[2]
      )
    
  })
  
  
  output$n_rows <- renderText({
    validate(need(
      !is.null(bank_subset$data),
      "Make your selections and click the 'Subset the data' button."
    ))
    paste("Rows in the current data:", nrow(bank_subset$data))
    
  })
  
  output$data_table <- DT::renderDataTable({
    validate(need(
      !is.null(bank_subset$data),
      "Make your selections and click the 'Subset the data' button."
    ))
    bank_subset$data
  })
  
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("bank-subset-", Sys.Date(), '.csv')
    },
    content = function(con) {
      write.csv(bank_subset$data, con)
    }
  )
  
  output$cat_table <- renderPrint({
    validate(need(!is.null(bank_subset$data),"Make your selections and click the 'Subset the data' button."))
    validate(need(nrow(bank_subset$data) > 0, "No rows match your subset. Try wider choices."))
    
    if(input$cat_var2 == "none") {
      table(bank_subset$data[[input$cat_var1]]) #if only one variable, then only 1-way contingency table
    } else {
      table(bank_subset$data[[input$cat_var1]],bank_subset$data[[input$cat_var2]]) #if two variables, then  2-way contingency table
    }
    
  })
  
  output$cat_plot <- renderPlot({
    validate(need(!is.null(bank_subset$data),"Make your selections and click the 'Subset the data' button."))
    validate(need(nrow(bank_subset$data) > 0, "No rows match your subset. Try wider choices."))
    
    if(input$cat_plot_type == "bar") {
      if(input$cat_var2 == "none"){
        #plot regular bar chart
        ggplot(bank_subset$data, aes_string(x = input$cat_var1)) + #cannot use aes directly because variable is decided runtime 
          geom_bar() +
          labs(title = paste("Number of clients by", input$cat_var1),
               x = input$cat_var1, y = "Number of clients")
      } else {
        ggplot(bank_subset$data, aes_string(x = input$cat_var1, fill = input$cat_var2)) + #cannot use aes directly because variable is decided runtime 
          geom_bar(position = "stack") +
          labs(title = paste("Number of clients by", input$cat_var1, "and", input$cat_var2),
               x = input$cat_var1, y = "Number of clients", fill = input$cat_var2)
      }
    } else {
      
      #build extra validation for heatmap
      
      validate(need(
        input$cat_var2 != "none",
        "Choose a Variable 2 to make the heatmap."
      ),
      need(input$cat_var1 != "y" & input$cat_var2 != "y", "Heatmap shows the rate of subscription, so don't pick y as a variable.")
      )
      
      rate_data <- bank_subset$data |> 
        group_by(var1 = get(input$cat_var1), var2 = get(input$cat_var2)) |>
        summarize(rate = mean(y == "yes"), .groups = "drop")
      ggplot(rate_data, aes(x = var1, y= var2, fill = rate)) + 
        geom_tile() + 
        labs(title = paste("Subscription rate by", input$cat_var1, "and", input$cat_var2),
             x = input$cat_var1, y = input$cat_var2, fill = "Subscription rate")
      
    }
    
  })
  
  
  output$num_table <- renderTable({
    validate(need(!is.null(bank_subset$data),"Make your selections and click the 'Subset the data' button."))
    validate(need(nrow(bank_subset$data) > 0, "No rows match your subset. Try wider choices."))
    
    bank_subset$data |> 
      group_by(group = get(input$group_var)) |>
      summarize(n = n(),
                mean = mean(get(input$num_summary_var)),
                median = median(get(input$num_summary_var)),
                sd = sd(get(input$num_summary_var)),
                min = min(get(input$num_summary_var)),
                max = max(get(input$num_summary_var)))
  })
  
  output$num_plot <- renderPlot({
    validate(need(!is.null(bank_subset$data),"Make your selections and click the 'Subset the data' button."))
    validate(need(nrow(bank_subset$data) > 0, "No rows match your subset. Try wider choices."))
    
    if(input$num_plot_type == "hist") {
      
      if(input$facet_var == "none") {
        ggplot(bank_subset$data, aes_string(x = input$num_summary_var)) + 
          geom_histogram(bins = 30, fill = "steelblue", color = "white") + 
          labs(title = paste("Histogram of", input$num_summary_var),
               x = input$num_summary_var, y = "Number of clients")
      } else {
        ggplot(bank_subset$data, aes_string(x = input$num_summary_var)) + 
          geom_histogram(bins = 30, fill = "steelblue", color = "white") + 
          facet_wrap(input$facet_var, scales = "free_y") +
          labs(title = paste("Histogram of", input$num_summary_var, "by", input$facet_var),
               x = input$num_summary_var, y = "Number of clients")
      }
      
    } else if(input$num_plot_type == "box") {
      ggplot(bank_subset$data, aes_string(x = input$group_var, y = input$num_summary_var, fill = input$group_var)) + 
        geom_boxplot() + 
        labs(title = paste("Boxplot of", input$num_summary_var, "by", input$group_var),
             x = input$group_var, y = input$num_summary_var, fill = input$group_var)
    } 
    
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)