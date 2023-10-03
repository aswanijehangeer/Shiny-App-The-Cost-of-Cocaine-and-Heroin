# install.packages("tidyverse")
# install.packages("janitor")
# install.packages("readxl")

library(tidyverse)
library(janitor)
library(readxl)
library(ggtext)
library(plotly)

# Theme Set
theme_set(theme_minimal(base_size = 12, base_family = "Open Sans"))

# Theme update
theme_update(
  axis.ticks = element_line(color = "grey9"),
  axis.ticks.length = unit(0.5, "lines"),
  panel.grid.minor = element_blank(),
  legend.title = element_text(size = 12),
  legend.text = element_text(color = "grey9"),
  plot.title = element_text(size = 18, face = "bold"),
  plot.subtitle = element_text(size = 12, color = "grey9"),
  plot.caption = element_text(size = 9, margin = margin(t = 15))
)



cocaine_data <- read_xlsx("data/Cocaine and Heroin Prices.xlsx") |> 
  clean_names()

# Filter the data for "Cocaine" in the USA
cocaine_data_filtered <- cocaine_data %>%
  filter(drug == "Cocaine", country == "United States of America")


# Calculate average retail price per year
average_price <- cocaine_data %>%
  filter(drug == "Cocaine") |> 
  group_by(year) %>%
  summarize(avg_price = round(mean(retail_price), 1))

# Plotting using ggplot

g <- ggplot() +
  geom_line(data = cocaine_data_filtered, aes(x = year, y = retail_price), 
            color = "#0f9233") + 
  geom_line(data = average_price, aes(x = year, y = avg_price),
            color = "#882f20") +
  labs(title = "Cocaine Retail Price and Average Retail Price Over Years",
       subtitle = "Cocaine Retail Price",
       caption = "Data Source: UNDOC created by: aswanijehangeer",
       x = "", y = "Retail Price") + 
  theme(
    plot.title.position = "plot",
    plot.title = element_markdown(face = 'bold'),
    plot.caption = element_textbox(
      size = 10,
      padding = margin(5.5, 5.5, 5.5, 5.5),
      margin = margin(0, 0, 5, 0),
    ),
    axis.title.x = element_markdown(),
    axis.title.y = element_markdown(),
    plot.margin = margin(10, 10, 10, 10)
  )

g <- g + aes(text = paste("Year: ", cocaine_data_filtered$year, "<br>",
                          "Retail Price: $", cocaine_data_filtered$retail_price, "<br>",
                          "Average Price: $", average_price$avg_price))


ggplotly(g) |>  
  layout(
  annotations = list(
    text = "Data Source: UNDOC created by: aswanijehangeer",
    x = 1,  # X position (0-1 range)
    y = -0.099,  # Y position (0-1 range)
    xref = "paper",
    yref = "paper",
    showarrow = FALSE
  )
)

