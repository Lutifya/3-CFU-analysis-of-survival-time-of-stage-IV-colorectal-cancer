# advanced_analysis.R - Analisi statistica avanzata
# Questo script esegue analisi statistiche più sofisticate:
# - Test di ipotesi
# - Analisi di sopravvivenza
# - Modelli di regressione
# - Analisi di confounding

library(dplyr)
library(survival)
library(ggplot2)
library(broom)

advanced_analyze_dataset <- function(data_path, output_dir) {
  # Carica il dataset pulito
  data <- readRDS(data_path)

  cat("=== ANALISI STATISTICA AVANZATA ===\n")
  cat("Dataset:", nrow(data), "osservazioni\n\n")

  # 1. TEST STATISTICI PER CONFRONTARE GRUPPI EA vs NO-EA
  # ===================================================

  cat("=== 1. TEST STATISTICI TRA GRUPPI ===\n")

  # Test t per età
  age_test <- t.test(age ~ ea, data = data)
  cat("Test t per età tra gruppi EA:\n")
  cat("Media senza EA:", round(age_test$estimate[1], 1), "anni\n")
  cat("Media con EA:", round(age_test$estimate[2], 1), "anni\n")
  cat("p-value:", round(age_test$p.value, 3), "\n\n")

  # Test Fisher per ASA score (più appropriato per tabelle con frequenze basse)
  asa_test <- fisher.test(table(data$ea, data$asa))
  cat("Test Fisher per ASA score:\n")
  cat("p-value:", round(asa_test$p.value, 3), "\n\n")

  # Test per comorbidità
  comorbidities <- c("dm", "cad", "hf", "cva", "ckd")
  cat("Test chi-quadro per comorbidità:\n")
  for(comorb in comorbidities) {
    test <- chisq.test(table(data$ea, data[[comorb]]))
    cat(comorb, "- p-value:", round(test$p.value, 3), "\n")
  }
  cat("\n")

  # 2. ANALISI DI SOPRAVVIVENZA (Kaplan-Meier)
  # ==========================================

  cat("=== 2. ANALISI DI SOPRAVVIVENZA ===\n")

  # Converti variabili per survival analysis
  data_surv <- data %>%
    mutate(
      ea_num = as.numeric(as.character(ea)),
      death_num = as.numeric(as.character(death)),
      time = interval  # tempo fino all'evento
    )

  # Kaplan-Meier per confronto tra EA e no-EA
  km_fit <- survfit(Surv(time, death_num) ~ ea_num, data = data_surv)

  # Log-rank test
  logrank_test <- survdiff(Surv(time, death_num) ~ ea_num, data = data_surv)
  logrank_p <- 1 - pchisq(logrank_test$chisq, length(logrank_test$n) - 1)

  cat("Analisi Kaplan-Meier:\n")
  cat("Gruppi confrontati: Senza EA vs Con EA\n")
  cat("Log-rank test p-value:", round(logrank_p, 3), "\n\n")

  # 3. REGRESSIONE LOGISTICA PER MORTALITA
  # =====================================

  cat("=== 3. REGRESSIONE LOGISTICA ===\n")

  # Modello base: EA come unico predittore
  model1 <- glm(death_num ~ ea_num, data = data_surv, family = binomial)
  cat("Modello 1 - Solo EA:\n")
  cat("OR per EA:", round(exp(coef(model1)[2]), 2), "\n")
  cat("IC 95%:", round(exp(confint(model1)[2,]), 2), "\n")
  cat("p-value:", round(summary(model1)$coefficients[2,4], 3), "\n\n")

  # Modello aggiustato: controllando per confondenti
  model2 <- glm(death_num ~ ea_num + age + asa + dm + cad + hf + cva + ckd + cea,
                data = data_surv, family = binomial)
  cat("Modello 2 - EA aggiustato per confondenti:\n")
  cat("OR per EA:", round(exp(coef(model2)[2]), 2), "\n")
  cat("IC 95%:", round(exp(confint(model2)[2,]), 2), "\n")
  cat("p-value:", round(summary(model2)$coefficients[2,4], 3), "\n\n")

  # 4. ANALISI STRATIFICATA PER STADIO AJCC
  # ======================================

  cat("=== 4. ANALISI STRATIFICATA PER STADIO ===\n")

  # Effetto EA stratificato per stadio AJCC
  for(stage in unique(data$ajcc)) {
    subset_data <- data_surv[data_surv$ajcc == stage, ]
    if(nrow(subset_data) > 10) {  # Solo se ci sono abbastanza osservazioni
      km_stage <- survfit(Surv(time, death_num) ~ ea_num, data = subset_data)
      logrank_stage <- survdiff(Surv(time, death_num) ~ ea_num, data = subset_data)
      logrank_p_stage <- 1 - pchisq(logrank_stage$chisq, length(logrank_stage$n) - 1)

      cat("Stadio", stage, "- pazienti:", nrow(subset_data), "\n")
      cat("Log-rank p-value:", round(logrank_p_stage, 3), "\n")
    }
  }
  cat("\n")

  # 5. ANALISI CEA E SUA RELAZIONE CON EA
  # ====================================

  cat("=== 5. ANALISI CEA ===\n")

  # CEA per gruppo EA
  cea_by_ea <- tapply(data$cea, data$ea, summary)
  cat("CEA per gruppo EA:\n")
  cat("Senza EA - Mediana:", round(cea_by_ea$"0"["Median"], 2), "\n")
  cat("Con EA - Mediana:", round(cea_by_ea$"1"["Median"], 2), "\n")

  # Test per differenza CEA
  cea_test <- wilcox.test(cea ~ ea, data = data)
  cat("Test Wilcoxon per CEA tra gruppi: p-value =", round(cea_test$p.value, 3), "\n\n")

  # 6. SALVATAGGIO RISULTATI
  # =======================

  results <- list(
    age_test = tidy(age_test),
    asa_test = tidy(asa_test),
    km_fit = km_fit,
    model1 = tidy(model1),
    model2 = tidy(model2),
    cea_test = tidy(cea_test)
  )

  saveRDS(results, file.path(output_dir, "advanced_analysis_results.rds"))
  cat("Risultati salvati in:", file.path(output_dir, "advanced_analysis_results.rds"), "\n")

  return(results)
}

# Esegue l'analisi se script chiamato direttamente
if (!interactive()) {
  advanced_analyze_dataset(
    "results/dataset_final_cleaned.rds",
    "results/"
  )
}
