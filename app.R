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

# Server logic 
server <- function(input, output) {
  
  # Filter the data based on user inputs
  filtered_data <- reactive({
    filter(cocaine_data, drug == input$drug, country == input$country)
  })
  
  # Calculate the overall average across years
  overall_average <- reactive({
    cocaine_data %>%
      group_by(year) %>%
      summarise(average_price = mean(switch(input$price, Retail = retail_price, Wholesale = wholesale_price)))
    
  })
  
  # Generating the line chart plot
  output$line_chart <- renderPlotly({
    req(input$drug, input$country)
    
    # Custom hover info
    hover_info <- paste("<b>Year:", filtered_data()$year, "</b><br>",
                        ifelse(input$price == "Retail", "<b>Retail Price: </b>", "<b>Wholesale Price: </b>"), 
                        sprintf("<b>%.2f</b>", ifelse(input$price == "Retail", filtered_data()$retail_price, filtered_data()$wholesale_price)))
    
    # Custom title
    custom_title <- paste("<b>The", input$price, "of", input$drug, "in", input$country, "[1990 - 2022]", "</b>")

    # Plotly line chart
    plot_ly(data = filtered_data(), x = ~year, type = 'scatter', mode = 'lines',
            y = ~switch(input$price, Retail = retail_price, Wholesale = wholesale_price),
            name = input$price, hoverinfo = "text", text = hover_info) %>%
      # Add a line for the overall average
      add_trace(data = overall_average(), x = ~year, y = ~average_price,
                type = 'scatter', mode = 'lines', name = 'Overall Average',
                line = list(color = 'black', width = 2)) |> 
      layout(title = custom_title,
             xaxis = list(title = " "),
             yaxis = list(title = input$price)) |> 
      config(displayModeBar = FALSE)
  })
}


# Run the application 
shinyApp(ui = ui, server = server)