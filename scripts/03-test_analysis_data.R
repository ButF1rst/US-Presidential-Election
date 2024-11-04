#### Preamble ####
# Purpose: Test the analysis data to the data that we can use to analyze.
# Author: Yi Tang
# Date: 26 October 2024
# Contact: zachary.tang@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None

#### Workspace setup ####
library(dplyr)
library(arrow)
library(testthat)

# Load the dataset from a Parquet file
analysis_data <- read_parquet("data/analysis_data/analysis_data.parquet")

# Tests for the dataset

# Test if there are any missing values in key outcome variables
test_that("No missing values in key outcome variables", {
  expect_true(all(complete.cases(analysis_data[c("candidate_name", "pct")])),
              "There are missing values in candidate_name or pct")
})

# Test if all pct values are within the expected range (0-100)
test_that("Percentage values are within the expected range", {
  expect_true(all(analysis_data$pct >= 0 & analysis_data$pct <= 100),
              "pct values are outside the range of 0 to 100")
})

# Test if 'nation_or_state' only contains 0 and 1
test_that("nation_or_state contains only 0 and 1", {
  expect_true(all(analysis_data$nation_or_state %in% c(0, 1)))
})

