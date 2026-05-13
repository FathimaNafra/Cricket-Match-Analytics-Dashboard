library(tidyverse)

# Load datasets
matches <- read.csv("data/matches.csv")
deliveries <- read.csv("data/deliveries.csv")


# Remove duplicates only


matches <- distinct(matches)
deliveries <- distinct(deliveries)


# Remove rows where winner is missing


matches <- matches %>%
  filter(!is.na(winner))


# Check missing values


print(colSums(is.na(matches)))
print(colSums(is.na(deliveries)))


# Save cleaned datasets


write.csv(
  matches,
  "data/cleaned_matches.csv",
  row.names = FALSE
)

write.csv(
  deliveries,
  "data/cleaned_deliveries.csv",
  row.names = FALSE
)

print("Data cleaning completed")