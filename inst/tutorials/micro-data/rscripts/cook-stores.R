library(tidyverse)
library(jsonlite)

# Use API URL to get JSON file with data
json_url <- "https://services1.arcgis.com/RLQu0rK7h4kbsBq5/arcgis/rest/services/Store_Locations/FeatureServer/0/query?where=State%20%3D%20'IL'%20AND%20County%20%3D%20'COOK'&outFields=Longitude,Latitude,County,State,Store_Name&outSR=4326&f=json"

# Parse JSON file to get R object
cook_stores <- fromJSON(json_url)

# Write RDS file with the features/attributes table of that object (name, state,
# county, latitude, and longitude)
write_rds(cook_stores$features$attributes, "inst/tutorials/036-mapping/data/cook-stores.rds")
