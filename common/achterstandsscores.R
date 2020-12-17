# Achterstandsscores
library(dplyr)
library(xlsx)

get_achtergrond_data <- function(type) {
  xlsx::read.xlsx2(get_data_file("achterstandsscores-scholen-2019.xlsx", type), sheetName = "Tabel 1", startRow = 4) %>%
    select(1,2,3) %>%
    `colnames<-`(c("VestigingsNummer", "AantalLeerlingen", "Score"))
}

get_achtergrond_scores <- function(data) {
  data %>%
    filter(Score != "") %>%
    mutate(Score = as.numeric(Score)) %>%
    filter(Score > 0)
}

get_aantal_leerlingen <- function(data) {
  data %>%
    mutate(AantalLeerlingen = as.numeric(AantalLeerlingen)) %>%
    filter(AantalLeerlingen > 0)
}

