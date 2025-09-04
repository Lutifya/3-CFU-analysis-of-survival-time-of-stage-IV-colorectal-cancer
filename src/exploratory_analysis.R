# exploratory_analysis.R - Exploratory data analysis functions
# Questo script esegue l'analisi esplorativa dei dati (EDA)
# Obiettivo: comprendere la distribuzione delle variabili e relazioni preliminari

library(ggplot2)
library(dplyr)
library(tidyr)

perform_eda <- function(data) {
  # Calcola statistiche descrittive di base per tutte le colonne
  # Include media, mediana, min, max, quartili per variabili numeriche
  summary_stats <- summary(data)

  # Identifica valori mancanti per colonna
  # Cruciale per capire la qualità dei dati e pianificare l'imputazione
  missing_values <- sapply(data, function(x) sum(is.na(x)))

  # Analizza distribuzione delle variabili numeriche
  # Identifica colonne numeriche escludendo quelle chiaramente categoriche
  numeric_cols <- sapply(data, is.numeric)
  # Escludiamo colonne dummy/binary che sono numeriche ma categoriche
  exclude_cols <- c("gender", "asa3", "dm", "cad", "hf", "cva", "ckd",
                   "laparoscopic", "ea", "rbc", "liver_only", "cell_diff",
                   "mucin_type", "signet_ring", "lymphovascularinvasion",
                   "perineural", "ct", "rt", "nactrt", "death", "progress")
  numeric_cols <- numeric_cols & !(names(data) %in% exclude_cols)

  if (any(numeric_cols)) {
    numeric_data <- data[, numeric_cols]
    distributions <- lapply(numeric_data, function(x) {
      list(
        mean = mean(x, na.rm = TRUE),
        median = median(x, na.rm = TRUE),
        sd = sd(x, na.rm = TRUE),
        min = min(x, na.rm = TRUE),
        max = max(x, na.rm = TRUE),
        # Calcola skewness per identificare distribuzioni asimmetriche
        skewness = ifelse(length(x[!is.na(x)]) > 0,
                         sum((x - mean(x, na.rm = TRUE))^3, na.rm = TRUE) /
                         (length(x[!is.na(x)]) * sd(x, na.rm = TRUE)^3), NA)
      )
    })
  }

  # Analizza variabili categoriche
  # Include sia colonne character che colonne dummy numeriche
  categorical_cols <- sapply(data, is.character) |
                     (sapply(data, is.numeric) & names(data) %in% exclude_cols)

  if (any(categorical_cols)) {
    categorical_data <- data[, categorical_cols]
    frequencies <- lapply(categorical_data, function(x) {
      # Calcola frequenze e percentuali
      freq_table <- table(x, useNA = "ifany")
      prop_table <- prop.table(freq_table)
      list(
        frequencies = freq_table,
        percentages = round(prop_table * 100, 2)
      )
    })
  }

  # Analizza la variabile outcome principale (death)
  # Importante per capire la sopravvivenza nel campione
  if ("death" %in% names(data)) {
    death_analysis <- list(
      total_patients = nrow(data),
      deaths = sum(data$death, na.rm = TRUE),
      survival_rate = 1 - (sum(data$death, na.rm = TRUE) / nrow(data)),
      mean_age_deceased = mean(data$age[data$death == 1], na.rm = TRUE),
      mean_age_survivors = mean(data$age[data$death == 0], na.rm = TRUE)
    )
  }

  # Analizza la variabile di esposizione principale (epidural analgesia - ea)
  if ("ea" %in% names(data)) {
    ea_analysis <- list(
      total_with_ea = sum(data$ea, na.rm = TRUE),
      proportion_with_ea = sum(data$ea, na.rm = TRUE) / nrow(data),
      # Confronta outcome tra gruppi con/senza EA
      death_rate_with_ea = sum(data$death[data$ea == 1], na.rm = TRUE) /
                          sum(data$ea == 1, na.rm = TRUE),
      death_rate_without_ea = sum(data$death[data$ea == 0], na.rm = TRUE) /
                             sum(data$ea == 0, na.rm = TRUE)
    )
  }

  results <- list(
    summary = summary_stats,
    missing = missing_values,
    distributions = if(exists("distributions")) distributions else NULL,
    frequencies = if(exists("frequencies")) frequencies else NULL,
    death_analysis = if(exists("death_analysis")) death_analysis else NULL,
    ea_analysis = if(exists("ea_analysis")) ea_analysis else NULL
  )

  return(results)
}

generate_plots <- function(results, output_dir) {
  # Questa funzione genera visualizzazioni per l'EDA
  # Per ora è un placeholder - può essere espansa con ggplot2

  message("Generazione grafici EDA...")

  # Placeholder per future visualizzazioni:
  # - Istogrammi delle variabili numeriche
  # - Box plots per confrontare gruppi
  # - Grafici di sopravvivenza
  # - Correlazioni tra variabili

  # Esempio futuro:
  # ggsave(file.path(output_dir, "age_distribution.png"),
  #        ggplot(data, aes(x = age)) + geom_histogram())
}
