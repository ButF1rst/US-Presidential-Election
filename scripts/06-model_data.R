#### Preamble ####
# Purpose: Optimizing Election Forecast Models for 2024 U.S. Presidential Predictions
# Author: Jin Zhang
# Date: 3 November 2024 
# Contact: kry.zhang@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None


library(dplyr) 
library(rstanarm)
library(modelsummary)

analysis_data <- read_parquet("data/analysis_data/analysis_data.parquet")
trump_data <- analysis_data |> filter(candidate_name == "Trump")


# Convert categorical variables to factors if not already
trump_data$state <- as.factor(trump_data$state)
trump_data$state <- as.factor(trump_data$population)

# Model 1: Basic model with pollster and grade
model1 <- lm(pct ~ pollster + nation_or_state , data = trump_data)

# Model 2: Adding state as a factor
model2 <- lm(pct ~ pollster + population + nation_or_state, data = trump_data)

# Model 3: Adding sample_size as a factor
model3 <- lm(pct ~ pollster + numeric_grade + nation_or_state + population, data = trump_data)

# Create an empty dataframe to store model summaries
model_summaries <- data.frame(
  Model = character(),
  AIC = double(),
  BIC = double(),
  R_Squared = double(),
  stringsAsFactors = FALSE
)

append_model_summary <- function(model, model_name) {
  summary <- glance(model)
  model_summaries <<- rbind(model_summaries, data.frame(
    Model = model_name,
    AIC = summary$AIC,
    BIC = summary$BIC,
    R_Squared = summary$r.squared
  ))
}

# Append data for each model
append_model_summary(model1, "Model 1: pollster + party")
append_model_summary(model2, "Model 2: pollster + party + state")
append_model_summary(model3, "Model 3: pollster + numeric_grade + party + state")

# Print the model summaries
print("Model Summaries:")
print(model_summaries)

#### Select the best model ####
# Based on AIC/BIC and R squared results, we select the best model
best_model <- model3

# Use the best model to predict the winner
trump_data <- trump_data %>%
  mutate(final_prediction = predict(best_model, newdata = trump_data))

# Aggregate predictions by candidate to get the overall predicted support
final_results <- trump_data %>%
  group_by(candidate_name) %>%
  summarise(predicted_support = mean(final_prediction, na.rm = TRUE)) %>%
  arrange(desc(predicted_support))

# Print the final predicted results
print("Final Predicted Results:")
print(final_results)

#### Save the best model ####
saveRDS(best_model, file = "models/best_model.rds")

