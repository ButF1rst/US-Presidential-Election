#### Preamble ####
# Purpose: Cleans the data to analysis data that we can use
# Author: Yi Tang
# Date: 26 October 2024
# Contact: zachary.tang@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None

#### Workspace setup ####
#install.packages("arrow")

library(tidyverse)
library(readr)
library(dplyr)
library(lubridate)
library(arrow)

# Read the dataset
data <- read_csv("data/raw_data/raw_president_election.csv", show_col_types = FALSE)

# Select the required columns and rename 'answer' to 'candidate_name'
analysis_data <- data |>
  select(poll_id, pollster, state, numeric_grade, methodology, start_date, end_date, sample_size, population, party, answer, pct) |>
  rename(candidate_name = answer) |>
  mutate(
    nation_or_state = if_else(is.na(state), 0, 1), # If state is NA, nation or state is equal to 0. Otherwise, it equals to 1. 
    start_date = as.Date(start_date, format="%m/%d/%y"), 
    end_date = as.Date(end_date, format="%m/%d/%y")
  ) |>
  filter(
    !is.na(poll_id) & !is.na(pollster) & !is.na(methodology) & 
      !is.na(start_date) & !is.na(end_date) & !is.na(sample_size) & 
      !is.na(party) & !is.na(candidate_name) & !is.na(pct) & 
      !is.na(numeric_grade)
  )


# Write the DataFrame to a Parquet file
write_parquet(analysis_data, "data/analysis_data/analysis_data.parquet")

# Check to confirm the file is written
file.exists("data/analysis_data/analysis_data.parquet")
