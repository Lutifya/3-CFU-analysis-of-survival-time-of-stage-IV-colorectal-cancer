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

## Workflow Followed (Chicco & Coelho, 2025)

Following the flowchart from "A teaching proposal for a short course on biomedical data science" (PLOS Comput Biol 21(4): e1012946):

### Step 2: Data Preprocessing
- ✅ Data loading from Excel format
- ✅ Column name standardization (janitor::clean_names)
- ✅ Missing value identification and handling
- ✅ Data type conversions
- ✅ Outlier detection and management (winsorization)
- ✅ Categorical variable consistency checks

### Step 3: Exploratory Data Analysis
- ✅ Descriptive statistics for all variables
- ✅ Distribution analysis (histograms, boxplots)
- ✅ Correlation analysis between variables
- ✅ Group comparisons (EA vs non-EA patients)
- ✅ Missing value patterns analysis
- ✅ Outlier identification and treatment

### Step 4: Statistical Analysis
- ✅ Survival analysis (Kaplan-Meier curves)
- ✅ Cox proportional hazards models
- ✅ Logistic regression for binary outcomes
- ✅ Confounder adjustment
- ✅ Propensity score analysis
- ✅ Model validation and diagnostics

## Dataset

**Source**: Colorectal cancer EHRs, Taipei 2018 Dataset
- **DOI**: https://doi.org/10.1371/journal.pone.0200893
- **Figshare**: https://figshare.com/articles/dataset/The_effect_of_epidural_analgesia_on_cancer_progression_in_patients_with_stage_IV_colorectal_cancer_after_primary_tumor_resection_A_retrospective_cohort_study/6846365
- **Original Study**: PLOS ONE 13(7): e0200893

## Deliverables

- **Clean CSV**: `results/dataset_final_cleaned.csv` (999 obs, 32 vars, 0 missing)
- **Analysis Report**: `results/report.pdf` (comprehensive analysis report)
- **GitHub Repository**: https://github.com/Lutifya/3-CFU-analysis-of-survival-time-of-stage-IV-colorectal-cancer
