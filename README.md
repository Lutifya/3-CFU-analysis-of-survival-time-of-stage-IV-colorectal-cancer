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
- ✅ **AJCC staging conversion**: Converted from categorical to numeric (4a→0, 4b→1) for statistical modeling

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

## Variable Coding

**Key Variables for Analysis:**
- **ea** (Epidural Analgesia): 0 = No, 1 = Yes
- **ajcc** (AJCC Stage - converted to numeric): 0 = Stage 4a (single organ metastasis), 1 = Stage 4b (multiple organ metastasis)
- **death**: 0 = Alive, 1 = Dead
- **asa**: ASA physical status score (1-5)
- **gender**: 1 = Male, 2 = Female

**Clinical Variables:**
- **dm, cad, hf, cva, ckd**: Comorbidities (0 = No, 1 = Yes)
- **cea**: Carcinoembryonic antigen level (ng/mL)
- **cell_diff**: Cell differentiation (1 = Well, 2 = Moderate, 3 = Poor, 9 = Unknown)

## Deliverables

- **Clean CSV**: `results/dataset_final_cleaned.csv` (999 obs, 32 vars, 0 missing)
- **Analysis Report**: `results/report.pdf` (comprehensive analysis report)
- **Report PDF Link**: https://github.com/Lutifya/3-CFU-analysis-of-survival-time-of-stage-IV-colorectal-cancer/blob/main/results/report.pdf
- **GitHub Repository**: https://github.com/Lutifya/3-CFU-analysis-of-survival-time-of-stage-IV-colorectal-cancer
