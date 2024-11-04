#### Preamble ####
# Purpose: Cleans the data to analysis data that we can use
# Author: Yi Tang
# Date: 26 October 2024
# Contact: zachary.tang@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None

#### Workspace setup ####
library(tidyverse)
library(readr)
library(dplyr)
library(lubridate)

# Read the dataset
data <- read_csv("data/raw_data/raw_president_election.csv", show_col_types = FALSE)

# Select the required columns
analysis_data <- data %>%
  select(poll_id, pollster, state, methodology, start_date, end_date, sample_size, party, answer, pct)

### Clean the data by removing rows with any missing values in the selected columns ###
analysis_data <- analysis_data %>%
  filter(answer == "Trump", 
    !is.na(poll_id) & !is.na(pollster) & !is.na(state) & !is.na(methodology) & 
           !is.na(start_date) & !is.na(end_date) & !is.na(sample_size) & !is.na(party) & !is.na(answer) & !is.na(pct))

# Write the cleaned data to a new CSV file
write_csv(analysis_data, "data/analysis_data/analysis_data.csv")