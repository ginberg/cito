# Aantal leerlingen per onderwijstype en vestiging
library(dplyr)
library(tidyr)

get_leerlingen_data <- function(type) {
  read.csv(get_data_file("leerlingen-vo-per-vestiging-naar-onderwijstype-2019.csv", "vo"), sep = ";", stringsAsFactors = F) %>%
    mutate(VESTIGINGSNUMMER = paste0(BRIN.NUMMER, "0", VESTIGINGSNUMMER))
}

get_leerlingen_per_vestiging <- function(df) {
  df %>%
    select_at(vars(matches("MAN|VROUW|VESTIGINGSNUMMER"))) %>%
    mutate(total=rowSums(.[, sapply(., is.numeric)])) %>%
    select(VESTIGINGSNUMMER, total) %>%
    group_by(VESTIGINGSNUMMER, .drop = "groups") %>%
    summarise(total = sum(total))
}

