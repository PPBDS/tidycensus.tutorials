# Creates the data necessary to create a faceted map of Harris County

library(tidyverse)
library(tidycensus)

# Defines the census variables to pull information from
racevars <- c(White = "B02001_002",
              Black = "B02001_003",
              Asian = "B02001_005",
              Hispanic = "B03003_003")

# Fetches data from API using tidycensus
county_data <- get_acs(geography = "tract",
                       variables = racevars,
                       year = 2018,
                       state = "TX",
                       county = "Harris County",
                       geometry = TRUE,
                       summary_var = "B02001_001")

# Saves the data to an RDS file.
write_rds(county_data, "inst/tutorials/036-mapping/data/county-data.rds")
