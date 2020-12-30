# explore vestigingen
library(dplyr)
library(plotly)


get_vestigingen <- function(type, use_api = TRUE) {
  if (use_api) {
    if (type == PRIMARY_SCHOOL) {
      get_API_data("94f22ef5-cf37-4656-b834-51523e8f3bd1")
    } else {
      get_API_data("70c19ca0-b24b-4596-a077-79c75caab63a")
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
