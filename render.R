library(rmarkdown)
library(palmerpenguins)
library(tidyverse)

oregon_counties <- read_rds("data/life_expectancy.rds") %>% 
  distinct(geography) %>% 
  filter(geography != "Oregon") %>% 
  pull(geography)

reports <- tibble(
  input = "report.Rmd",
  output_file = str_glue("{oregon_counties}.html"),
  params = map(oregon_counties, ~ list(location = .))
)

pwalk(reports, render)
