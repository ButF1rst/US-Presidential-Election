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
  select(poll_id, pollster, state, numeric_grade, methodology, start_date, end_date, sample_size, party, answer, pct) %>%
  rename(candidate_name = answer)

# Clean the data by removing rows with any missing values in the selected columns
# and correct the date format issue by adjusting the year

analysis_data <- analysis_data |>
  filter(!is.na(poll_id) & !is.na(pollster) & !is.na(state) & !is.na(methodology) & 
           !is.na(start_date) & !is.na(end_date) & !is.na(sample_size) & !is.na(party) & 
           !is.na(candidate_name) & !is.na(pct)) |>
  mutate(
    start_date = as.Date(start_date, format = "%Y-%m-%d"),
    end_date = as.Date(end_date, format = "%Y-%m-%d"),
    # Correct the year assuming it is written as '0024' and should be '2024'
    start_date = if_else(year(start_date) == 24, update(start_date, year = 2024), start_date),
    end_date = if_else(year(end_date) == 24, update(end_date, year = 2024), end_date)
  )

# Write the DataFrame to a Parquet file
write_parquet(analysis_data, "data/analysis_data/analysis_data.parquet")

# Check to confirm the file is written
file.exists("data/analysis_data/analysis_data.parquet")
