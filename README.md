# README.md

# Data Cleaning and Analysis Project

This project performs data cleaning, preparation, and exploratory data analysis on a dataset about the effect of epidural analgesia on cancer progression in patients with stage IV colorectal cancer.

## Project Structure

- `data/2018-07-20/`: Raw dataset
- `src/`: Source code for analysis
- `bin/`: Executable scripts
- `results/`: Output files and reports

## Usage

1. Run data cleaning: `make data`
2. Perform analysis: `make analysis`
3. Generate report: `make report`
4. Run all: `make`

## Dependencies

- R
- Required packages: readxl, dplyr, ggplot2, tidyr, janitor, rmarkdown

Install dependencies with:
```r
install.packages(c("readxl", "dplyr", "ggplot2", "tidyr", "janitor", "rmarkdown"))
```
