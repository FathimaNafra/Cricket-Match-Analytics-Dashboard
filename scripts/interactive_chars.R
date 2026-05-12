library(tidyverse)
library(ggplot2)
library(plotly)

matches <- read.csv("data/cleaned_matches.csv")

p <- ggplot(matches, aes(x=season)) +
  geom_bar(fill = "purple") +
  labs(
    title = "Matches per season"
  )

ggplotly(p)

 