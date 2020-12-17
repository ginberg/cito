# Eindscores VO dataset
library(dplyr)


# Notice: this file has some text in the wrong columns. Luckily this can be fixed quite easily with below function
clean_dataset <- function(filename) {
  f <- readLines(get_data_file(filename, type = "vo"), -1)
  f_clean <- unlist(lapply(f, FUN = function(x) { if (grepl(", ", x)) { gsub(", ", "", x) } else {x} }))
  out_filename <- gsub("_raw", "", filename)
  writeLines(f_clean, get_data_file(out_filename, type = "vo"))

}
#clean_dataset("geslaagden-gezakten-en-cijfers-2018-2019_raw.csv")

get_eindscore_data <- function(type) {
  read.csv(get_data_file("geslaagden-gezakten-en-cijfers-2018-2019.csv", type), sep = ";", stringsAsFactors = F) %>%
    rename(PROVINCIE = PROVINCIE.VESTIGING) %>%
    rename(GEMEENTENAAM = GEMEENTENAAM.VESTIGING) %>%
    mutate_at(vars(matches("GEMIDDELD.CIJFER")), funs(as.numeric(gsub(",", ".", .))))
}

# per subject
get_eindscores_vakken_data <- function(filename, school_type) {
  data <- read.csv(get_data_file(filename, type = "vo"), sep = ";", stringsAsFactors = F) %>%
    mutate(VESTIGINGSNUMMER = paste0(BRIN.NUMMER, "0", VESTIGINGSNUMMER)) %>%
    mutate(Cijfer = as.numeric(gsub(",", ".", GEM..CIJFER.CIJFERLIJST))) %>%
    select(VESTIGINGSNUMMER, VAKNAAM, Cijfer)
  if (school_type == "vmbo") {
    data <- data %>% filter(VAKNAAM %in% c("Nederlandse taal", "Engelse taal", "wiskunde"))
  } else {
    data <- data %>%
      filter(VAKNAAM %in% c("Nederlandse taal en literatuur", "Engelse taal en literatuur", "wiskunde A", "wiskunde B")) %>%
      mutate(VAKNAAM = ifelse(startsWith(VAKNAAM, "Nederlandse taal"), "Nederlandse taal", VAKNAAM)) %>%
      mutate(VAKNAAM = ifelse(startsWith(VAKNAAM, "Engelse taal"), "Engelse taal", VAKNAAM))
  }
  data
}

get_eindscores_vakken_df <- function(data, var) {
  data %>%
    mutate(VAKNAAM = ifelse(startsWith(VAKNAAM, "wiskunde"), "Wiskunde", VAKNAAM)) %>%
    group_by(VAKNAAM) %>%
    summarise(Cijfer = mean(Cijfer), .groups = 'drop') %>%
    rename(!!var := Cijfer)
}

get_eindscores_vakken <- function(school_type) {
  if (school_type == "vmbo") {
    data <- get_eindscores_vakken_data("examenkandidaten-vmbo-en-examencijfers-2018-2019.csv", "vmbo")
  } else if (school_type == "havo") {
    data <- get_eindscores_vakken_data("examenkandidaten-havo-en-examencijfers-2018-2019.csv", "havo")
  } else if (school_type == "vwo") {
    data <- get_eindscores_vakken_data("examenkandidaten-vwo-en-examencijfers-2018-2019.csv", "vwo")
  }
  df_total  <- get_eindscores_vakken_df(data, "totaal")
  df_sample <- get_eindscores_vakken_df(get_data_sample(data), "sample")
  df <- df_sample %>% left_join(df_total, by = c("VAKNAAM" = "VAKNAAM"))
  df

}
