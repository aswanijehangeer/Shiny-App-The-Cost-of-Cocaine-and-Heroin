# install.packages("tidyverse")
# install.packages("janitor")
# install.packages("readxl")

library(tidyverse)
library(janitor)
library(readxl)


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

