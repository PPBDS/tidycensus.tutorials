library(learnr)
library(tutorial.helpers)
library(tidyverse)
library(stringr)
library(tidycensus)
library(ipumsr)
library(ggthemes)
library(knitr)
library(stringr)
library(tigris)
library(tmap)
library(mapview)
library(leaflet)
library(ggplot2)
library(patchwork)
library(glue)
library(idbr)
library(ggiraph)
library(purrr)
library(sf)

# I Put these in rscript for cleanliness in the tutorial, it makes it easier for the author of said tutorial to write the tutorial, instead of going through lots and lots of scrolling every time they want to go to the actual tutorial. This also organizes the data better, there is no extra code and you can clearly see where the code is, instead of having a big, hard to read block of code.

 dc_income <- get_acs(
  geography = "tract",
   variables = "B19013_001",
   state = "DC",
   year = 2021,
   geometry = TRUE
 )

write_rds(dc_income, "data/dc_income.rds")


 # Needed for chapter 6

 dallas_bachelors <- get_acs(
   geography = "tract",
   variables = "DP02_0068P",
   year = 2021,
   state = "TX",
   county = "Dallas",
   geometry = TRUE
 )

write_rds(dallas_bachelors, "data/dallas_bachelors.rds")


# Needed for chapter 6

 hennepin_race <- get_decennial(
   geography = "tract",
  state = "MN",
  county = "Hennepin",
   variables = c(
     Hispanic = "P2_002N",
     White = "P2_005N",
     Black = "P2_006N",
     Native = "P2_007N",
     Asian = "P2_008N"
   ),
   summary_var = "P2_001N",
   year = 2021,
   geometry = TRUE
 ) |>
   mutate(percent = 100 * (value / summary_value))

 # Whenever you run this with year = 2021, it says error in UseMethod("gather") :
 # no applicable method for 'gather' applied to an object of class "character", It works for 2020 and all previous years, not 2021 though.

write_rds(hennepin_race, "data/hennepin_race.rds")

# Needed for chapter 6

 us_median_age <- get_acs(
   geography = "state",
   variables = "B01002_001",
  year = 2021,
   survey = "acs1",
  geometry = TRUE,
  resolution = "20m"
) |>
   shift_geometry()

 write_rds(us_median_age, "data/us_median_age.rds")

# Needed for chapter 12

 fertility_data <- get_idb(
   country = "all",
   year = 2021,
   variables = "tfr",
   geometry = TRUE,
 )

 write_rds(fertility_data, "data/fertility_data.rds")

 years <- 2005:2019
 names(years) <- years

 dekalb_years <- map_dfr(years, ~{
   get_acs(geography = "county",
           variables = "B25077_001",
           state = "GA",
           county = "Dekalb",
           survey = "acs1",
           year = .x,)
 },.id = "Year")

 write_rds(dekalb_years, "inst/tutorials/025-census-data-i/data/dekalb_years.rds")

