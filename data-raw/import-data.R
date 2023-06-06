

# Load Packages -----------------------------------------------------------

library(tidyverse)
library(janitor)
library(readxl)

# Life Expectancy ---------------------------------------------------------

import_life_expectancy_data <- function(data_year) {
  read_excel(str_glue("data-raw/{data_year}-obtn-by-county.xlsx"),
             sheet = "Life Expectancy") %>%
    clean_names() %>%
    pivot_longer(-geography,
                 names_to = "gender") %>%
    mutate(gender = case_when(
      str_detect(gender, "_overall") ~ "Total",
      str_detect(gender, "_male") ~ "Men",
      str_detect(gender, "_female") ~ "Women"
    )) %>%
    mutate(year = data_year)
}

import_life_expectancy_data(2020)

years <- c(2020, 2021, 2022, 2023)

life_expectancy <- map(years, import_life_expectancy_data) %>% 
  bind_rows()

life_expectancy %>% 
  write_rds("data/life_expectancy.rds")
