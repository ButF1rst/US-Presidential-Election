#### Preamble ####
# Purpose: Simulates a dataset of US president election results
# Author: Yi Tang
# Date: 26 October 2024
# Contact: zachary.tang@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)
library(dplyr)
set.seed(29)


# Define the number of samples to simulate
n <- 100

# Create a data frame
set.seed(29)  # For reproducibility
simulated_data <- data.frame(
  poll_id = 1:n,
  pollster = rep("YouGov", n),
  state = sample(c("California", "Texas", "Florida", "New York", "Pennsylvania"), n, replace = TRUE),
  methodology = rep("Online panel", n),  # Only 'Online panel' methodology
  start_date = sample(seq(as.Date('2023-10-05'), as.Date('2024-10-11'), by="day"), n, replace = TRUE),
  end_date = sample(seq(as.Date('2023-10-17'), as.Date('2024-10-16'), by="day"), n, replace = TRUE),
  sample_size = sample(500:1500, n, replace = TRUE),
  party = sample(c("Democrat", "Republican"), n, replace = TRUE, prob = c(0.5, 0.5)),
  answer = sample(c("Candidate A", "Candidate B"), n, replace = TRUE),
  pct = runif(n, 40, 60)  # Random percentages between 40 and 60
)

# Ensure the end_date is always after the start_date
simulated_data <- simulated_data %>%
  mutate(end_date = ifelse(end_date < start_date, start_date + 1, end_date))

# Convert numeric date to date format
simulated_data$start_date <- as.Date(simulated_data$start_date, origin = "1970-01-01")
simulated_data$end_date <- as.Date(simulated_data$end_date, origin = "1970-01-01")

# Write the data to a CSV file for external use
write.csv(simulated_data, "data/00-simulated_data/simulated_data.csv", row.names = FALSE)



