# Create the plot seen in the Downloading Census Data tutorial

# Load libraries
library(tidyverse)
library(ipumsr)
library(ggthemes)

# Load data (stolen from the R command file that came with the data extract)

# THIS NEEDS A .dat AND .xml FILE FOUND HERE:
# https://github.com/AnmayG/lfs-storage/blob/main/usa_00001.dat
# DO NOT RUN WITHOUT THE .dat and .xml FILES

ddi <- read_ipums_ddi("inst/tutorials/035-downloading-census-data/data/usa_00001.xml")
data <- read_ipums_micro(ddi)

# Clean up data by getting rid of haven labelled variables and peculiarities
clean_data <- data |>
  select(INCTOT, EMPSTAT) |>
  mutate(empstat = as.factor(EMPSTAT)) |>
  mutate(empstat = case_when(empstat == 0 ~ "NA",
                             empstat == 1 ~ "Employed",
                             empstat == 2 ~ "Unemployed",
                             empstat == 3 ~ "Not in labor force")) |>
  mutate(inctot = as.integer(INCTOT)) |>
  mutate(inctot = na_if(inctot, 9999999)) |>
  mutate(inctot = inctot/100000)

# Plot and change labels
# ..scaled.. source from https://stackoverflow.com/questions/51385455/geom-density-y-axis-goes-above-1
ipums_plot <- clean_data |>
  ggplot(aes(x = inctot, y = ..scaled.., fill = empstat, color = empstat)) +
  geom_density(alpha = 0.3, na.rm = TRUE) +
  xlim(0, 8) +
  scale_y_continuous(labels = scales::label_number()) +
  scale_fill_discrete(name = "Employment Status") +
  scale_color_discrete(name = "Employment Status") +
  theme_economist(dkpanel=TRUE) +
  labs(title = "2019 Income Distribution by Employment Status",
       x = "Income: Values Scaled by 1/100000",
       y = NULL,
       caption = "Source: IPUMS, 2019")
ipums_plot

# Save image to a png because nobody's dealing with a 280 MB file
ggsave("images/ipums_plot.png", ipums_plot)
