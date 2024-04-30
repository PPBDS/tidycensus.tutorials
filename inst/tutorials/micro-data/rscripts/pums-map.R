# Creates the PUMS map for the NW states and their pct_Senior.

library(tidyverse)
library(tidycensus)

# Defines the states in question
nw_states <- c("OR", "WA", "ID")

# Fetches data from API using tidycensus
nw_pums <- get_pums(variables = c("PUMA", "AGEP"),
                      state = nw_states,
                      recode = TRUE,
                      survey = "acs1",
                      year = 2018)

# Adds the total population and pct_Senior columns to supplement the data
nw_Senior <- nw_pums |>
    group_by(ST, PUMA) |>
    summarize(total_pop = sum(PWGTP),
              pct_Senior = sum(PWGTP[AGEP > 64]) / total_pop,
              .groups = "drop")

# Creates the shape files for the PUMAS
nw_pumas <- map(nw_states,
                tigris::pumas,
                class = "sf",
                cb = TRUE) |>
            reduce(rbind)

# Combines the shape files and our data so that it's one tibble that we can map
nw_final <- nw_pumas |>
    left_join(nw_Senior, by = c("STATEFP10" = "ST", "PUMACE10" = "PUMA"))

# Maps the data using ggplot() and geom_sf()
pums_map <- nw_final |>
              ggplot(aes(fill = pct_Senior)) +
                geom_sf() +
                scale_fill_viridis_b(name = NULL,
                    option = "magma",
                    labels = scales::label_percent(1)) +
                labs(title = "Percentage of population that are Seniors",
                     caption = "Source: American Community Survey 2014-2018") +
                theme_void()

# Saves the map to an RDS file.
write_rds(pums_map, "inst/tutorials/036-mapping/data/pums-map.rds")
