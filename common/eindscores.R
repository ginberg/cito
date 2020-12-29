# Eindscores dataset
# De gemiddelde scores staan weergegeven voor verschillende eindtoetsen: Centrale Eindtoets (CET), ICE Eindevaluatie Primair Onderwijs (IEP), Route 8, AMN, Cesan en Dia
library(dplyr)

get_eindscore_data <- function(type, api = TRUE) {
  read.csv(get_data_file("gemiddelde-eindscores-bo-sbo-2018-2019.csv", type), sep = ";", stringsAsFactors = F) %>%
    mutate(VESTIGINGSNUMMER = paste0(BRIN_NUMMER, "0", VESTIGINGSNUMMER)) %>%
    mutate(CET_GEM = as.numeric(gsub(",", ".", CET_GEM))) %>%
    mutate(IEP_GEM = as.numeric(gsub(",", ".", IEP_GEM)))
}
