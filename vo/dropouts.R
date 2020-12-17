# Vroegtijdige schoolverlaters
library(dplyr)
library(xlsx)

get_dropout_data <- function(type) {
 read.csv(glue(get_data_file("vsv-per-swv-2015.csv", type)), sep = ";", stringsAsFactors = F) %>%
    mutate(vsg_num = paste0(brin_nummer, "0", vestigings_nummer)) %>%
    select(vsg_num, aantal_leerlingen, vsv_totaal) %>%
    `colnames<-`(c("VestigingsNummer", "AantalLeerlingen", "Score"))
}

get_dropout_scores <- function(data) {
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

