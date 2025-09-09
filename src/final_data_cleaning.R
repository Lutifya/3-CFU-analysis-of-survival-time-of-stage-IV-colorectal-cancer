# final_data_cleaning.R - Pulizia finale del dataset
# Questo script applica pulizia avanzata identificando e gestendo:
# - Valori mancanti
# - Outliers estremi
# - Inconsistenze nei dati categorici

library(readxl)
library(dplyr)
library(janitor)

final_clean_dataset <- function(input_path, output_path) {
  # Carica il dataset precedentemente pulito
  data <- readRDS(input_path)

  cat("=== INIZIO PULIZIA FINALE ===\n")
  cat("Dataset originale:", nrow(data), "righe\n")

  # 1. GESTIONE VALORI MANCANTI STRATEGICA
  # ======================================

  # Per CEA e log_CEA (19 NA): usa mediana per mantenere distribuzione
  # Questi sono marker tumorali importanti, meglio non eliminare righe
  cea_median <- median(data$cea, na.rm = TRUE)
  data$cea <- ifelse(is.na(data$cea), cea_median, data$cea)
  data$log_cea <- ifelse(is.na(data$log_cea), log(cea_median), data$log_cea)

  # Per variabili istologiche (cell_diff, mucin_type, signet_ring, perineural, lymphovascularinvasion)
  # Queste hanno ~5-6% di NA, strategia: crea categoria "Unknown" codificata come 9
  histological_vars <- c("cell_diff", "mucin_type", "signet_ring", "perineural", "lymphovascularinvasion")
  for(var in histological_vars) {
    if(var %in% names(data)) {
      data[[var]] <- ifelse(is.na(data[[var]]), 9, data[[var]])
    }
  }

  cat("Valori mancanti gestiti\n")

  # 2. CORREZIONE INCONSISTENZE CATEGORICHE
  # =======================================

  # RBC dovrebbe essere 0/1, ma ha valore 2 - correggi a 1 (trasfusione sì)
  data$rbc <- ifelse(data$rbc == 2, 1, data$rbc)

  # cell_diff: valore 0 non ha senso (dovrebbe essere 1=ben, 2=moderato, 3=scarsamente)
  # Converti 0 in NA poi in 9 (sconosciuto)
  data$cell_diff <- ifelse(data$cell_diff == 0, 9, data$cell_diff)

  cat("Inconsistenze categoriche corrette\n")

  # 3. GESTIONE OUTLIERS
  # ====================

  # CEA: identifica outliers estremi usando IQR method
  # Valori > Q3 + 3*IQR sono considerati outliers estremi
  cea_q3 <- quantile(data$cea, 0.75, na.rm = TRUE)
  cea_iqr <- IQR(data$cea, na.rm = TRUE)
  cea_threshold <- cea_q3 + 3 * cea_iqr

  cat("CEA - soglia outlier:", round(cea_threshold, 2), "\n")
  cat("CEA > soglia:", sum(data$cea > cea_threshold, na.rm = TRUE), "casi\n")

  # Per outliers estremi di CEA, usa winsorization (cap at 99th percentile)
  cea_99th <- quantile(data$cea, 0.99, na.rm = TRUE)
  data$cea <- ifelse(data$cea > cea_99th, cea_99th, data$cea)
  data$log_cea <- log(data$cea)  # Ricalcola log_CEA dopo winsorization

  cat("Outliers CEA gestiti con winsorization\n")

  # 4. CONVERSIONI DI TIPO OTTIMALI
  # ===============================

  # Converti ajcc da factor a numerico (4a = 0, 4b = 1)
  data$ajcc <- as.numeric(as.character(data$ajcc) == "4b")

  cat("Variabile ajcc convertita a numerico binario (4a=0, 4b=1)\n")

  # Converti variabili categoriche a factor per analisi statistica
  categorical_to_factor <- c("gender", "asa", "asa3", "dm", "cad", "hf", "cva", "ckd",
                            "laparoscopic", "ea", "rbc", "liver_only", "cell_diff",
                            "mucin_type", "signet_ring", "lymphovascularinvasion",
                            "perineural", "ct", "rt", "nactrt", "death", "progress")

  for(var in categorical_to_factor) {
    if(var %in% names(data)) {
      data[[var]] <- as.factor(data[[var]])
    }
  }

  # Mantiene bian_ma come numeric (ID paziente)
  # Mantiene age, cea, log_cea, anes_time, log2at, interval, interval_r come numeric

  cat("Tipi di dati ottimizzati\n")

  # 5. VALIDAZIONE FINALE
  # =====================

  cat("=== VALIDAZIONE FINALE ===\n")
  cat("Righe finali:", nrow(data), "\n")
  cat("Valori mancanti rimanenti:", sum(is.na(data)), "\n")

  # Verifica che non ci siano più NA
  final_missing <- sapply(data, function(x) sum(is.na(x)))
  if(any(final_missing > 0)) {
    cat("Attenzione: valori mancanti rimanenti in:\n")
    print(final_missing[final_missing > 0])
  } else {
    cat("✓ Nessun valore mancante rimanente\n")
  }

  # Salva dataset finale pulito
  saveRDS(data, output_path)
  cat("Dataset finale salvato in:", output_path, "\n")

  # Salva anche versione CSV per compatibilità
  write.csv(data, sub("\\.rds$", ".csv", output_path), row.names = FALSE)
  cat("Versione CSV salvata\n")

  return(data)
}

# Esegue la pulizia se script chiamato direttamente
if (!interactive()) {
  final_clean_dataset(
    "data/2018-07-20/dataset_cleaned.rds",
    "results/dataset_final_cleaned.rds"
  )
}
