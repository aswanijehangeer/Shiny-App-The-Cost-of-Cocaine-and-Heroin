library(shiny)


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
    
    # Show a plot
    mainPanel(
      plotOutput("scatter_bar_plot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$scatter_bar_plot <- renderPlot({
  })
}

# Run the application 
shinyApp(ui = ui, server = server)