library(shiny)
library(plotly)

source("global.R")

# Define UI for application 
ui <- fluidPage(
  
  
  titlePanel("The Cost of Cocaine and Heroin"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("country", "Country", choices = unique(cocaine_data$country)),
      radioButtons("drug", "Drug Type", choices = unique(cocaine_data$drug),
                   selected = "Cocaine"),
      radioButtons("price", "Price Type", choices = c("Retail", "Wholesale"),
                   selected = "Retail")
      
    ),
    
    # Plot
    mainPanel(
      plotlyOutput("line_chart")
    )
  )
)