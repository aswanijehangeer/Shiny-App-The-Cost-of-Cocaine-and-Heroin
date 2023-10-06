
# Server logic 
server <- function(input, output, session) {
  
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
    
    hover_info <- lapply(1:nrow(filtered_data()), function(i) {
      year <- filtered_data()$year[i]
      price <- ifelse(input$price == "Retail", 
                      sprintf("<b>%.2f</b>", filtered_data()$retail_price[i]), 
                      sprintf("<b>%.2f</b>", filtered_data()$wholesale_price[i]))
      overall_avg <- overall_average()$average_price[i]
      paste(
        "<b>Year:", year, "</b><br>",
        "<b>", ifelse(input$price == "Retail", "Retail", "Wholesale"), " Price: </b>", price, "<br>",
        "<b>Overall Avg:</b> ", sprintf("<b>%.2f</b>", overall_avg)
      )
    })
    
    
    
    
    # Custom title
    custom_title <- paste("<b>The", input$price, "of", input$drug, "in", input$country, "[1990 - 2022]", "</b>")
    
    # Plotly line chart
    plot_ly(data = filtered_data(), x = ~year, type = 'scatter', mode = 'lines',
            y = ~switch(input$price, Retail = retail_price, Wholesale = wholesale_price),
            name = input$price, hoverinfo = "text", text = hover_info) %>%
      # Add a line for the overall average
      add_trace(data = overall_average(), x = ~year, y = ~average_price,
                type = 'scatter', mode = 'lines', name = 'Overall Average',
                line = list(color = 'red', width = 2)) |> 
      layout(title = custom_title,
             xaxis = list(title = " "),
             yaxis = list(title = input$price),
             legend = list(orientation = "h",   # show entries horizontally
                           xanchor = "center",  # use center of legend as anchor
                           x = 0.5)) |> 
      config(displayModeBar = FALSE)
  })
}