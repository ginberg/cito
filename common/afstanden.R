# gemiddelde afstand woonadres en schoolvestiging
library(dplyr)

get_afstanden <- function(type) {
  read.csv(get_data_file("gemiddelde-afstand-tussen-woonadres-leerling-en-schoolvestiging-2019-2020.csv", type), sep = ";", stringsAsFactors = F) %>%
    mutate(VESTIGINGSNUMMER = paste0(BRIN_NUMMER, "0", VESTIGINGSNUMMER)) %>%
    mutate(AFSTAND = as.numeric(gsub(",", ".", AFSTAND)) / 1000)
}

# BRIN + VESTIGINGSNUMMER om te matchen?


