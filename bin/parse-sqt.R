# parse-sqt.R - Data parsing and preprocessing script

# This script handles initial data parsing and preprocessing

parse_data <- function(file_path) {
  # Read Excel file
  data <- readxl::read_excel(file_path)

  # Basic preprocessing
  data <- data %>%
    # Remove rows with all NA
    filter(rowSums(is.na(.)) != ncol(.)) %>%
    # Convert column names to snake_case
    rename_with(~ tolower(gsub(" ", "_", .x)))

  return(data)
}

# Example usage
# parsed_data <- parse_data("data/2018-07-20/dataset.xls")
