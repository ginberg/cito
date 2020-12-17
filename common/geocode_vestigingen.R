# create vestigingen geocode cache
library(dplyr)
library(glue)
library(tidygeocoder)

PRIMARY_SCHOOL   <- "bo"
SECONDARY_SCHOOL <- "vo"
SCHOOL_TYPE      <- SECONDARY_SCHOOL

DO_GEOCODE    <- TRUE
#GEOCODE_COUNT <- 10
vestigingen   <- read.csv(glue(get_data_file("alle-vestigingen-{SCHOOL_TYPE}.csv", SCHOOL_TYPE)), sep = ";", stringsAsFactors = F)

if (DO_GEOCODE) {
  vestigingen <- vestigingen %>%
    #head(GEOCODE_COUNT) %>%
    mutate(POSTCODE = gsub(" ", "", POSTCODE)) %>%
    mutate(FULL.ADDRESS = paste(STRAATNAAM, HUISNUMMER.TOEVOEGING, POSTCODE, PLAATSNAAM)) %>%
    geocode(FULL.ADDRESS, method = "osm")
  saveRDS(vestigingen, glue(get_data_file("vestigingen_{SCHOOL_TYPE}_all.rds", SCHOOL_TYPE)))
}
