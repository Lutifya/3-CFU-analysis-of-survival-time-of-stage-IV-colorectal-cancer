# ms-analysis.R - Main analysis script

# Load required libraries
library(readxl)
library(dplyr)
library(ggplot2)
library(tidyverse)

# Source helper functions
source("src/data_cleaning.R")
source("src/exploratory_analysis.R")

# Main function
main <- function() {
  # Load and clean data
  data <- load_and_clean_data("data/2018-07-20/dataset.xls")

  # Perform exploratory analysis
  results <- perform_eda(data)

  # Save results
  saveRDS(results, "results/analysis_results.rds")

  # Generate plots
  generate_plots(results, "results/")

  message("Analysis complete. Results saved in results/ directory.")
}

# Run main if script is executed directly
if (!interactive()) {
  main()
}
