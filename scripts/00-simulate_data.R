#### Preamble ####
# Purpose: Simulates a dataset of Australian electoral divisions, including the 
  #state and party that won each division.
# Author: Rohan Alexander
# Date: 26 September 2024
# Contact: rohan.alexander@utoronto.ca
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
set.seed(123)  # For reproducibility
simulated_data <- data.frame(
  poll_id = 1:n,
  pollster = rep("YouGov", n),
  state = sample(c("California", "Texas", "Florida", "New York", "Pennsylvania"), n, replace = TRUE),
  methodology = sample(c("Online", "Telephone", "Mixed"), n, replace = TRUE),
  start_date = sample(seq(as.Date('2023-01-01'), as.Date('2023-12-31'), by="day"), n, replace = TRUE),
  end_date = sample(seq(as.Date('2023-01-02'), as.Date('2024-01-01'), by="day"), n, replace = TRUE),
  sample_size = sample(500:1500, n, replace = TRUE),
  party = sample(c("Democrat", "Republican"), n, replace = TRUE, prob = c(0.5, 0.5)),
  answer = sample(c("Candidate A", "Candidate B"), n, replace = TRUE),
  pct = runif(n, 40, 60)  # Random percentages between 40 and 60
)

# Adjust dates to ensure end_date is always after start_date
simulated_data <- simulated_data %>%
  mutate(end_date = ifelse(end_date < start_date, start_date + 1, end_date))

# Print the head of the simulated data
head(simulated_data)

# Optionally, write the data to a CSV file for external use
write.csv(simulated_data, "data/00-simulated_data/simulated_data.csv", row.names = FALSE)


