#### Preamble ####
# Purpose: Simulates a dataset of Australian electoral divisions, including the state and party that won each division.
# Author: Yi Tang
# Date: 26 September 2024
# Contact: zachary.tang@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? No


#### Workspace setup ####
library(tidyverse)
library(lubridate)

set.seed(29)  # Ensure reproducibility

# Define the number of rows to simulate
n <- 1000

# Simulate data
simulated_data <- tibble(
  poll_id = 1:n,
  pollster = sample(c("Gallup", "YouGov", "Ipsos", "Pew Research"), n, replace = TRUE),
  state = sample(state.name, n, replace = TRUE),
  methodology = sample(c("Online Panel", "Telephone", "Mixed Mode"), n, replace = TRUE),
  start_date = as.Date('2024-01-01') + days(sample(0:300, n, replace = TRUE)),
  end_date = start_date + days(sample(1:14, n, replace = TRUE)), 
  sample_size = sample(500:1500, n, replace = TRUE),
  party = sample(c("DEM", "REP", "IND"), n, replace = TRUE, prob = c(0.4, 0.4, 0.2)),
  answer = rep("Trump", n), 
  pct = runif(n, 40, 60)
)

# Print the head of the simulated dataset
head(simulated_data)

#### Save data ####
write_csv(simulated_data, "data/simulated_data/simulated_data.csv")

# Read in the data
simulated_data <- read_csv("data/simulated_data/simulated_data.csv", show_col_types = FALSE)

# Assuming the date columns are in a format that as.Date can parse directly; otherwise specify the format
# Convert start_date and end_date to Date objects if not already
simulated_data <- simulated_data %>%
  mutate(
    start_date = as.Date(start_date, format = "%Y-%m-%d"),
    end_date = as.Date(end_date, format = "%Y-%m-%d")
  )

# Basic Consistency Check for missing values
missing_values_check <- sum(is.na(simulated_data))
print(paste("Total missing values in the dataset:", missing_values_check))

# Unique Values Test for poll_id
unique_poll_ids <- n_distinct(simulated_data$poll_id)
print(paste("Number of unique poll IDs:", unique_poll_ids))

# Range checks
if (all(simulated_data$pct >= 0 & simulated_data$pct <= 100)) {
  print("All percentage values are within the range 0-100.")
} else {
  print("There are percentage values outside the range 0-100.")
}

if (all(year(simulated_data$start_date) == 2024 & year(simulated_data$end_date) == 2024)) {
  print("All dates are within the year 2024.")
} else {
  print("There are dates outside the year 2024.")
}

# Check for correct answers
if (all(simulated_data$answer == "Trump")) {
  print("All answers correctly set to 'Trump'.")
} else {
  print("There are non-'Trump' answers in the dataset.")
}