library(tidyverse)
library(tidycensus)
library(ggthemes)

cook_stores <- read_rds("inst/tutorials/036-mapping/data/cook-stores.rds")
cook_map <- read_rds("inst/tutorials/036-mapping/data/cook-map.rds")

cook_clean_map <- cook_map |>
                    mutate(Percent = 100 * (estimate / summary_est))

cook_stores_map <- ggplot(data = cook_clean_map,
                          aes(fill = Percent, color = Percent)) +
                     geom_sf() +
                     scale_fill_viridis_c(direction = -1) +
                     scale_color_viridis_c(direction = -1) +
                     geom_point(data = cook_stores,
                                aes(x = Longitude, y = Latitude),
                                size = 0.5,
                                inherit.aes = FALSE) +
                     labs(title = "Grocery Stores and Income in Cook County",
                          subtitle = "Cook County has a small food desert in the south.",
                          caption = "Source: SNAP Retailer Locator, U.S. Department of Agriculture Food and Nutrition Service")
                     theme_map()
cook_stores_map
