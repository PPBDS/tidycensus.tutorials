# Creates data for the percentage of rural populations in the contiguous US

library(tidyverse)
library(tidycensus)

# Fetches data from API using tidycensus
rural <- get_decennial(geography = "state",
                       variables = c("P001001", "P002005"),
                       year = 2010,
                       output = "wide",
                       geometry = TRUE)

# Saves the data to an RDS file.
write_rds(rural, "inst/tutorials/036-mapping/data/rural.rds")
