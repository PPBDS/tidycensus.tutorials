# Creates data for the percentage of rural populations in the entire US

library(tidyverse)
library(tidycensus)

# Fetches data from API using tidycensus
rural_shifted <- get_decennial(geography = "state",
                               variables = c("P001001", "P002005"),
                               year = 2010,
                               output = "wide",
                               geometry = TRUE)

# Shifts geometry of non-continental US states so that they fit on the map
rural_shifted <- tigris::shift_geometry(rural_shifted)

# Saves the data to an RDS file.
write_rds(rural_shifted, "inst/tutorials/036-mapping/data/rural-shifted.rds")
