# Map with all schools
library(dplyr)
library(tidygeocoder)
library(leaflet)
library(xlsx)
library(htmltools)

vestigingen <- read.csv(get_data_file("03-alle-vestigingen-bo.csv"), sep = ";", stringsAsFactors = F)
scores <- xlsx::read.xlsx2(get_data_file("achterstandsscores-scholen-2019.xlsx"), sheetName = "Tabel 1", startRow = 4) %>%
  select(1,2,3) %>%
  `colnames<-`(c("VestigingsNummer", "AantalLeerlingen", "Score")) %>%
  filter(Score != "")

# geocode
df <- vestigingen %>%
  head(5) %>%
  mutate(POSTCODE = gsub(" ", "", POSTCODE)) %>%
  mutate(FULL.ADDRESS = paste(STRAATNAAM, HUISNUMMER.TOEVOEGING, POSTCODE, PLAATSNAAM)) %>%
  geocode(FULL.ADDRESS, method = "osm")

# join
data <- df %>% left_join(scores, by = c("VESTIGINGSNUMMER" = "VestigingsNummer"))

# map
msg <- lapply(seq(nrow(data)), function(i) {
  paste0(data[i, "VESTIGINGSNAAM"], '<br/>',
         'Achterstandsscore: <b>', data[i, "Score"], '</b>')
})

leaflet(data = data) %>% addTiles() %>%
  addMarkers(~long, ~lat, popup = lapply(msg, HTML), label = lapply(msg, HTML))
