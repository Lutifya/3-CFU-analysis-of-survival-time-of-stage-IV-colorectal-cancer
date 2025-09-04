# Makefile for data cleaning and analysis project

.PHONY: all clean data analysis report

# Default target
all: data analysis report

# Clean data
data: data/2018-07-20/dataset_cleaned.rds
data/2018-07-20/dataset_cleaned.rds: data/2018-07-20/dataset.xls src/data_cleaning.R
	Rscript src/data_cleaning.R

# Perform analysis
analysis: results/analysis_results.rds
results/analysis_results.rds: data/2018-07-20/dataset_cleaned.rds src/exploratory_analysis.R
	Rscript src/exploratory_analysis.R

# Generate report
report: results/report.pdf
results/report.pdf: results/analysis_results.rds src/generate_report.R
	Rscript src/generate_report.R

# Clean up
clean:
	rm -f data/2018-07-20/dataset_cleaned.rds
	rm -f results/analysis_results.rds
	rm -f results/report.pdf
