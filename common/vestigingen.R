# explore vestigingen
library(dplyr)
library(plotly)

PRIMARY_SCHOOL_RESOURCE_ID   <- "71c229ed-7737-40d4-b610-765c2b1345c8"
SECONDARY_SCHOOL_RESOURCE_ID <- "7672deaf-fce7-409e-9fc9-58bbddbe33c2"


get_vestigingen_API_URL <- function(type) {
  if (type == PRIMARY_SCHOOL) {
      get_API_URL(PRIMARY_SCHOOL_RESOURCE_ID)
  } else {
      get_API_URL(SECONDARY_SCHOOL_RESOURCE_ID)
  }
}

get_vestigingen <- function(type, use_api = TRUE) {
  if (use_api) {
    if (type == PRIMARY_SCHOOL) {
      get_API_data(PRIMARY_SCHOOL_RESOURCE_ID)
    } else {
      get_API_data(SECONDARY_SCHOOL_RESOURCE_ID)
    }
  } else {
    read.csv(glue(get_data_file("alle-vestigingen-{type}.csv", type)), sep = ";", stringsAsFactors = F)
  }
}

get_vestigingen_locations <- function(type) {
  readRDS(glue(get_data_file("vestigingen_{type}_all.rds", type)))
}

# aantal vestigingen per provincie
get_aantal_provincie <- function(df, var) {
  df %>%
    group_by(PROVINCIE) %>%
    summarise(aantal = n(), .groups = 'drop') %>%
    mutate(!!var := aantal / sum(aantal) * 100) %>%
    select(!aantal)
}

# top n vestigingen per gemeente/plaats
get_aantal_plaatsen <- function(df, var) {
  df %>%
    group_by(PLAATSNAAM) %>%
    summarise(aantal = n(), .groups = 'drop') %>%
    mutate(!!var := aantal / sum(aantal) * 100) %>%
    select(!aantal)
}

# vestigingsnaam -> uitsplitsen per type
get_school_types <- function(df, var, school_type = "bo") {
  school_types <- data.frame(type = character(0), aantal = numeric(0))
  if (school_type == "bo") {
    types <- c("Kindcentrum", "Katholiek", "Protestant", "Openbare", "Montessori", "Dalton")
  } else {
    types <- c("Katholiek", "Protestant", "Openbare", "Montessori", "Dalton")
  }
  for (type in types) {
    aantal <- df %>% filter(grepl(type, VESTIGINGSNAAM, useBytes = TRUE)) %>% nrow()
    school_types[nrow(school_types) + 1,] <- c(type, aantal)
  }
  school_types %>%
    mutate(aantal = as.numeric(aantal)) %>%
    mutate(!!var := aantal / sum(aantal) * 100) %>%
    select(!aantal) %>%
    mutate(type = factor(type,levels = type))
}
