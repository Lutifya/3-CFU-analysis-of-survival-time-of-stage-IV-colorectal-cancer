# Script per analizzare il dataset e identificare problemi di pulizia
data <- readRDS('data/2018-07-20/dataset_cleaned.rds')

cat('=== DIMENSIONI DATASET ===\n')
cat('Righe:', nrow(data), 'Colonne:', ncol(data), '\n\n')

cat('=== ANALISI VALORI MANCANTI ===\n')
missing <- sapply(data, function(x) sum(is.na(x)))
missing <- missing[missing > 0]
if(length(missing) > 0) {
  print(missing)
} else {
  cat('Nessun valore mancante!\n')
}

cat('\n=== ANALISI VALORI ANOMALI ===\n')
cat('Età - min:', min(data$age, na.rm=TRUE), 'max:', max(data$age, na.rm=TRUE), '\n')
cat('CEA - min:', min(data$cea, na.rm=TRUE), 'max:', max(data$cea, na.rm=TRUE), '\n')
cat('Tempo anestesia - min:', min(data$anes_time, na.rm=TRUE), 'max:', max(data$anes_time, na.rm=TRUE), '\n')

cat('\n=== VERIFICA CONSISTENZA ===\n')
cat('ASA unici:', sort(unique(data$asa)), '\n')
cat('AJCC unici:', sort(unique(data$ajcc)), '\n')
cat('Gender unici:', sort(unique(data$gender)), '\n')

cat('\n=== VERIFICA VARIABILI CATEGORICHE ===\n')
categorical_vars <- c('gender', 'asa', 'ajcc', 'asa3', 'dm', 'cad', 'hf', 'cva', 'ckd', 
                     'laparoscopic', 'ea', 'rbc', 'liver_only', 'cell_diff', 
                     'mucin_type', 'signet_ring', 'lymphovascularinvasion', 
                     'perineural', 'ct', 'rt', 'nactrt', 'death', 'progress')

for(var in categorical_vars) {
  if(var %in% names(data)) {
    cat(var, '- valori unici:', sort(unique(data[[var]])), '\n')
  }
}

cat('\n=== VERIFICA OUTLIERS CEA ===\n')
# CEA molto alto potrebbe essere outlier
cea_summary <- summary(data$cea)
cat('CEA summary:\n')
print(cea_summary)
cat('CEA > 1000:', sum(data$cea > 1000, na.rm=TRUE), 'casi\n')
cat('CEA > 5000:', sum(data$cea > 5000, na.rm=TRUE), 'casi\n')

cat('\n=== VERIFICA ETA ANOMALA ===\n')
cat('Pazienti < 18 anni:', sum(data$age < 18, na.rm=TRUE), '\n')
cat('Pazienti > 100 anni:', sum(data$age > 100, na.rm=TRUE), '\n')
