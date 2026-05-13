library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(DT)
library(randomForest)

matches <- read.csv("data/cleaned_matches.csv")
deliveries <- read.csv("data/cleaned_deliveries.csv")

# Load trained model
model <- readRDS("model/win_predictor.rds")

# Get unique teams and prepare valid factor levels from actual data
teams <- sort(unique(matches$toss_winner[matches$toss_winner != ""]))
toss_decisions <- sort(unique(matches$toss_decision[matches$toss_decision != ""]))

# Top teams data
top_teams <- matches %>%
  count(winner, sort = TRUE) %>%
  head(10)

# Top batsman data
top_batsman <- deliveries %>%
  group_by(batsman) %>% 
  summarise(total_runs = sum(batsman_runs)) %>%
  arrange(desc(total_runs)) %>%
  head(10)

# UI
ui <- dashboardPage(
  
  dashboardHeader(
    title = "Cricket Analytics Dashboard"
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home"),
      menuItem("Team Analysis", tabName = "teams"),
      menuItem("Player Stats", tabName = "players"),
      menuItem("Match Prediction", tabName = "prediction")
    )
  ),
  
  dashboardBody(
    
    tabItems(
      
      # HOME TAB
      tabItem(
        tabName = "home",
        
        fluidRow(
          box(
            title = "Matches Per Season",
            width = 12,
            plotlyOutput("seasonPlot")
          )
        )
      ),
      
      # TEAM TAB
      tabItem(
        tabName = "teams",
        
        fluidRow(
          box(
            title = "Top Winning Teams",
            width = 12,
            plotlyOutput("teamPlot")
          )
        )
      ),
      
      # PLAYER TAB
      tabItem(
        tabName = "players",
        
        fluidRow(
          box(
            title = "Top Run Scorers",
            width = 12,
            plotlyOutput("batmanPlot")
          )
        ),
        
        fluidRow(
          box(
            title = "Delivery Details",
            width = 12,
            dataTableOutput("playerTable")
          )
        )
      ),
      
      # PREDICTION TAB
      tabItem(
        tabName = "prediction",
        
        fluidRow(
          box(
            title = "Match Winner Prediction",
            width = 6,
            selectInput("toss_winner", "Toss Winner:", choices = teams),
            selectInput("toss_decision", "Toss Decision:", choices = toss_decisions),
            actionButton("predict_btn", "Predict Winner", class = "btn-primary")
          )
        ),
        
        fluidRow(
          box(
            title = "Prediction Result",
            width = 6,
            uiOutput("predictionResult")
          )
        )
      )
    )
  )
)

# SERVER
server <- function(input, output) {
  
  # Season Plot
  output$seasonPlot <- renderPlotly({
    
    p <- ggplot(matches, aes(x = factor(season))) +
      geom_bar(fill = "steelblue") +
      labs(title = "Matches Per Season", x = "Season")
    
    ggplotly(p)
  })
  
  # Team Plot
  output$teamPlot <- renderPlotly({
    
    p <- ggplot(top_teams,
                aes(x = reorder(winner, n),
                    y = n)) +
      geom_col(fill = "darkgreen") +
      coord_flip() +
      labs(
        title = "Top Winning Teams",
        x = "Team",
        y = "Wins"
      )
    
    ggplotly(p)
  })
  
  # Batsman Plot
  output$batmanPlot <- renderPlotly({
    
    p <- ggplot(top_batsman, aes(x = reorder(batsman, total_runs), y = total_runs)) +
      geom_col(fill = "orange") +
      coord_flip() +
      labs(
        title = "Top Run Scorers",
        x = "Player",
        y = "Total Runs"
      )
    
    ggplotly(p)
  })
  
  # Table
  output$playerTable <- renderDataTable({
    deliveries
  })
  
  # Prediction
  observeEvent(input$predict_btn, {
    
    # Create prediction data with correct factor levels matching training data
    prediction_data <- data.frame(
      toss_winner = factor(input$toss_winner, levels = teams),
      toss_decision = factor(input$toss_decision, levels = toss_decisions)
    )
    
    tryCatch({
      predicted_winner <- predict(model, prediction_data)
      
      output$predictionResult <- renderUI({
        tags$h3(
          style = "color: green;",
          paste("Predicted Winner:", as.character(predicted_winner))
        )
      })
    }, error = function(e) {
      output$predictionResult <<- renderUI({
        tags$h3(
          style = "color: red;",
          "Error in prediction. Please check input values."
        )
      })
    })
  })
}

# Run app
shinyApp(ui, server)