library(tidyverse)
library(randomForest)

# Load dataset
matches <- read.csv("data/cleaned_matches.csv")

# Select useful columns
ml_data <- matches %>%
  select(
    winner,
    toss_winner,
    toss_decision
  )

# Remove rows with missing winner
ml_data <- ml_data %>%
  filter(
    winner != "",
    toss_winner != "",
    toss_decision != ""
  )

# Remove NA values only in selected columns
ml_data <- ml_data %>%
  drop_na()

# Convert to factors
ml_data[] <- lapply(ml_data, as.factor)

# Check classes
table(ml_data$winner)

# Split data
set.seed(123)

sample_rows <- sample(
  1:nrow(ml_data),
  0.8 * nrow(ml_data)
)

train_data <- ml_data[sample_rows, ]
test_data <- ml_data[-sample_rows, ]

# Train model
model <- randomForest(
  winner ~ toss_winner + toss_decision,
  data = train_data
)

# Predictions
predictions <- predict(model, test_data)

# Accuracy
accuracy <- mean(predictions == test_data$winner)

print(paste("Accuracy:", accuracy))

# Save model
saveRDS(
  model,
  "model/win_predictor.rds"
)

print("Model Trained Successfully")