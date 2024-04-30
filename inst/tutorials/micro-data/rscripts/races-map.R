# Creates the full US map of people who are 2 or more races

library(tidyverse)
library(tidycensus)

# Filters the states so that it's only the contiguous ones
continental <- state.name[! state.name %in% c("Alaska", "Hawaii")]

# Fetches data from API using tidycensus
races_data <- get_acs(geography = "tract",
                 state = continental,
                 variables = "B02001_008",
                 year = 2018,
                 summary_var = "B02001_001",
                 geometry = TRUE)

# Creates map using data, adding a column for the percentage along the way.
races_map <- races_data  |>
                 mutate(Percent = 100 * (estimate / summary_est)) |>
                 ggplot(aes(fill = Percent)) +
                 geom_sf(size = 0.003) +
                 scale_fill_viridis_c(direction = -1, option = "inferno") +
                 labs(title = "Percent of People Who are Two or More Races by Census Tract",
                      caption = "Source: American Community Survey 2014-2018") +
                 theme_void()

# Saves map as a png file.
png(filename = "inst/tutorials/036-mapping/images/races-map.png")
races_map
dev.off()
