# data_cleaning.R - Data cleaning functions
# Questo script pulisce il dataset del progetto di ricerca sull'effetto
# dell'analgesia epidurale sulla progressione del cancro al colon-retto

library(readxl)
library(dplyr)
library(janitor)

load_and_clean_data <- function(file_path) {
  # Carica il dataset Excel grezzo
  # Il dataset contiene dati clinici di pazienti con carcinoma del colon-retto stadi IV
  data <- read_excel(file_path)

  # Pulisce i nomi delle colonne: converte a snake_case e rimuove caratteri speciali
  # Esempio: "Patient ID" diventa "patient_id"
  data <- clean_names(data)

  # Gestisce valori mancanti:
  # - Converte stringhe vuote "" in NA
  # - Converte stringhe "NA" in NA
  # Questo è importante per l'analisi statistica
  data <- data %>%
    mutate(across(where(is.character), ~ na_if(.x, ""))) %>%
    mutate(across(where(is.character), ~ na_if(.x, "NA")))

  # Nota: conversioni di date commentate perché non presenti nel dataset
  # data <- data %>% mutate(date_column = as.Date(date_column, format = "%Y-%m-%d"))

  # Rimuove duplicati basati su tutte le colonne
  # Importante per evitare bias nell'analisi
  data <- distinct(data)

  # Salva il dataset pulito in formato RDS per efficienza
  # RDS preserva i tipi di dati R e permette caricamento veloce
  saveRDS(data, "data/2018-07-20/dataset_cleaned.rds")

  return(data)
}

# Esegue la pulizia quando lo script viene chiamato direttamente
if (!interactive()) {
  load_and_clean_data("data/2018-07-20/dataset.xls")
}
