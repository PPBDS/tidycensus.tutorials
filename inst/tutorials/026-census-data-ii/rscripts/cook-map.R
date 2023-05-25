library(tidyverse)
library(tidycensus)

cook_map <- get_acs(geography = "tract",
                    variables = "B06012_002",
                    year = 2018,
                    state = "Illinois",
                    county = "Cook County",
                    geometry = TRUE,
                    summary_var = "B02001_001")

write_rds(cook_map, "inst/tutorials/036-mapping/data/cook-map.rds")
