library(dplyr)

matches <- matches %>%
      drop_na()

deliveries <- deliveries %>%
      drop_na()