#### Preamble ####
# Purpose: Test the analysis data to the data that we can use to analyze.
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
library(testthat)

# Load the dataset
analysis_data <- read_csv("data/analysis_data/analysis_data.csv", show_col_types = FALSE)

# Convert date columns
analysis_data <- analysis_data %>%
  mutate(
    start_date = as.Date(start_date, format = "%m/%d/%Y"),
    end_date = as.Date(end_date, format = "%m/%d/%Y")
  )

# Re-test for missing values
test_that("No missing values in critical columns", {
  expect_true(all(complete.cases(analysis_data)), "There are still missing values after cleaning")
})

# Test that all answers are 'Trump'
test_that("All answers are 'Trump'", {
  expect_true(all(analysis_data$answer == "Trump"))
})

# Test to ensure 'pct' values are not negative
test_that("Percentage values are not negative", {
  expect_true(all(analysis_data$pct >= 0), "There are negative values in pct")
})