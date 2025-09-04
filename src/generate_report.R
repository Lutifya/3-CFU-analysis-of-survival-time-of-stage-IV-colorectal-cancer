# generate_report.R - Report generation script

library(rmarkdown)

generate_report <- function() {
  # Render R Markdown report
  rmarkdown::render("src/report.Rmd",
                    output_file = "results/report.pdf",
                    output_dir = "results/")
}

# If run directly
if (!interactive()) {
  generate_report()
}
