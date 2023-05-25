library(tidyverse)
library(stringr)
library(jsonlite)
library(tidycensus)
library(ggthemes)

json_url <- "https://services1.arcgis.com/RLQu0rK7h4kbsBq5/arcgis/rest/services/Store_Locations/FeatureServer/0/query?where=State%20%3D%20'IL'%20AND%20County%20%3D%20'COOK'&outFields=Longitude,Latitude,County,State,Store_Name&outSR=4326&f=json"

cook_stores <- fromJSON(json_url)$features$attributes
# write_rds(cook_stores$features$attributes, "data/stores.rds")

# cook_stores <- read_rds("data/stores.rds")

cook_map <- get_acs(geography = "tract",
                    variables = "B06012_002E",
                    year = 2018,
                    state = "Illinois",
                    county = "Cook County",
                    geometry = TRUE,
                    summary_var = "B02001_001")

cook_map_clean <- cook_map |>
  mutate(Percent = 100 * (estimate / summary_est))

cook_stores_map <- cook_map_clean |>
  ggplot(aes(fill = Percent, color = Percent)) +
  geom_sf() +
  scale_fill_viridis_c(direction = -1) +
  scale_color_viridis_c(direction = -1) +
  theme_map()

cook_stores_map +
  geom_point(data = cook_stores,
             aes(x = Longitude,
                 y = Latitude),
             stroke = 0,
             size = 0.5)

cook_stores_map
