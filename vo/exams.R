# Examenenkandidaten en geslaagden
library(dplyr)
library(tidyr)


get_exam_data <- function(type) {
  read.csv(get_data_file("examenkandidaten-en-geslaagden-2014-2019.csv", "vo"), sep = ";", stringsAsFactors = F)
}

get_slaagpercentages_per_sex <- function(df) {
  df %>%
    select(starts_with("SLAAGPERC") & (ends_with("MAN") | ends_with("VROUW"))) %>%
    mutate_all(funs(gsub("%", "", .))) %>%
    mutate_all(funs(gsub(",", ".", .))) %>%
    mutate_all(funs(as.numeric(.))) %>%
    filter_all(all_vars(. > 0)) %>%
    summarise_all(mean) %>%
    gather(year, value) %>%
    mutate(sex = gsub("\\.", "", substr(year, nchar(year)-4, nchar(year)))) %>%
    mutate(year = as.factor(gsub('.*\\.([0-9]+).*','\\1', year))) %>%
    spread(sex, value) %>%
    `colnames<-`(c("year", "man", "vrouw"))
}

get_slaagpercentages_per_school_type <- function(df) {
  df %>%
    select("ONDERWIJSTYPE.VO", starts_with("SLAAGPERC") & (ends_with("MAN") | ends_with("VROUW"))) %>%
    mutate_at(vars(matches("SLAAGPERC")), funs(gsub("%", "", .))) %>%
    mutate_at(vars(matches("SLAAGPERC")), funs(gsub(",", ".", .))) %>%
    mutate_at(vars(matches("SLAAGPERC")), funs(as.numeric(.))) %>%
    filter_at(vars(matches("SLAAGPERC")), all_vars(. > 0)) %>%
    group_by(ONDERWIJSTYPE.VO) %>%
    summarise_at(vars(matches("SLAAGPERC")), mean) %>%
    gather(year, value, -c("ONDERWIJSTYPE.VO")) %>%
    mutate(sex = gsub("\\.", "", substr(year, nchar(year)-4, nchar(year)))) %>%
    mutate(year = as.factor(gsub('.*\\.([0-9]+).*','\\1', year))) %>%
    group_by(ONDERWIJSTYPE.VO, year) %>%
    summarise(value = mean(value)) %>%
    spread(ONDERWIJSTYPE.VO, value) %>%
    select(1, 3, 2, 4)
}
