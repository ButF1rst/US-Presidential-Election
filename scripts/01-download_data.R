#### Preamble ####
# Purpose: Downloads and saves the data from website
# Author: Yi Tang
# Date: 26 September 2024
# Contact: zachary.tang@mail.utoronto.ca
# License: MIT
# Pre-requisites: No
# Any other information needed? None

#### Workspace setup ####
library(readr)
library(here)

# Read the CSV file from the URL
poll_raw <- read_csv(
  file = "https://projects.fivethirtyeight.com/polls/data/president_polls.csv",
  show_col_types = FALSE
)

# Write the CSV file to a local directory
write_csv(
  x = poll_raw,
  file = here("data", "raw_data", "raw_president_election.csv")
)