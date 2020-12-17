# Eindscores dataset
# De gemiddelde scores staan weergegeven voor verschillende eindtoetsen: Centrale Eindtoets (CET), ICE Eindevaluatie Primair Onderwijs (IEP), Route 8, AMN, Cesan en Dia
library(dplyr)

get_eindscore_data <- function(type) {
  read.csv(get_data_file("gemiddelde-eindscores-bo-sbo-2018-2019.csv", type), sep = ";", stringsAsFactors = F) %>%
    mutate(VESTIGINGSNUMMER = paste0(BRIN_NUMMER, "0", VESTIGINGSNUMMER)) %>%
    mutate(CET_GEM = as.numeric(gsub(",", ".", CET_GEM))) %>%
    mutate(IEP_GEM = as.numeric(gsub(",", ".", IEP_GEM)))
}

# # CET
# area_chart(eindscores$CET_GEM[complete.cases(eindscores$CET_GEM)], title = 'Gemiddelde Centrale Eindtoets Score', xaxis_title = "Score")
#
# # IEP
# area_chart(eindscores$IEP_GEM[complete.cases(eindscores$IEP_GEM)], title = 'Gemiddelde Eindevaluatie Primair Onderwijs Score', xaxis_title = "Score")
#
# #MAP
# data <- eindscores %>% mutate(Score = CET_GEM) %>%
#           filter(!is.na(Score))
#
# create_map(data,
#            colors = c("white", "lightblue", "blue", "darkblue"),
#            breaks = c(500, 515, 530, 545, Inf),
#            labels = c("500-515", "515-530", "530-545", "545+"),
#            title = glue("Centrale Eindtoets Score"),
#            legend_title = "Centrale Eindtoets Score",
#            popup = function(i) { paste0(data[i, "INSTELLINGSNAAM_VESTIGING"], '<br/>',
#                                  'Centrale Eindtoets Score: <b>', data[i, "Score"], '</b>')})
