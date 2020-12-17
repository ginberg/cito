# explore vestigingen
library(dplyr)
library(leaflet)
library(htmltools)
source("common.R")
source("vestigingen.R")
source("achterstandsscores.R")

PRIMARY_SCHOOL   <- "bo"
SECONDARY_SCHOOL <- "vo"
SCHOOL_TYPE      <- PRIMARY_SCHOOL


vestigingen_locations <- get_vestigingen("bo")
achtergrond <- get_achtergrond_data()
scores      <- get_achtergrond_scores(achtergrond)


data <- vestigingen_locations %>%
    left_join(scores, by = c("VESTIGINGSNUMMER" = "VestigingsNummer")) %>%
    mutate(Score = ifelse(is.na(Score), 0, Score))
df <- data %>% select(PROVINCIE, Score) %>% group_by(PROVINCIE) %>% summarise(Score = mean(Score), .groups = 'drop')

# create_score_map(data,
#                  colors = c("white", "lightblue", "blue", "darkblue"),
#                  breaks = c(0, 50, 100, 500, Inf),
#                  labels = c("0-50", "50-100", "100-500", "500+"),
#                  title = glue("Achterstandsscore per {SCHOOL_TYPE} vestiging"),
#                  legend_title = "Achterstandsscore",
#                  popup = function(i) { paste0(data[i, "VESTIGINGSNAAM"], '<br/>',
#                                      'Achterstandsscore: <b>', data[i, "Score"], '</b>')})

library(rgdal)
provinces <- rgdal::readOGR("map/provinces.geojson")
df <- df %>% arrange(PROVINCIE = provinces$name)
provinces$score <- df$Score
#pal <- colorNumeric("viridis", NULL)
pal <- colorNumeric(c("white", "lightblue", "blue", "darkblue"), NULL)


leaflet(provinces) %>%
  addTiles() %>%
  addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = 1,
    fillColor = ~pal(score),
    label = ~paste0(name, ": ", formatC(score, big.mark = ","))) %>%
  addLegend(pal = pal, values = ~score, opacity = 1.0,
    labFormat = labelFormat(transform = function(x) x)) %>%
  setView(lng = 5.1, lat = 52.5, zoom = 7)

