library(tidyverse)
library(dplyr)
library(readr)
library(stringr)
library(lubridate)
setwd("D:/kyle_datalab/datalab_2024v2/cleaning_practice")
wdclean <- read_csv("D:/kyle_datalab/datalab_2024v2/cleaning_practice/whales-dives.csv")
wdmessy <- read_csv("D:/kyle_datalab/datalab_2024v2/cleaning_practice/whales-dives-messy.csv")

whales_dives_cleaned <- wdmessy %>% mutate(YEAR = case_when(
    YEAR==(15) ~ 2015,
    TRUE ~ YEAR  # keep the value unchanged if it doesn't match any condition
  ))

whales_dives_cleaned <- whales_dives_cleaned %>%
  mutate(
    #Changing month column to add a 0 in front of single character months
    Month=str_pad(whales_dives_cleaned$Month,width=2,side="left",pad="0"),
    #Changes days to add leading 0 if before the 10th of the month.
    Day=str_pad(whales_dives_cleaned$Day,width=2,side="left",pad="0")
  )

##remove the word sighting from sighting as well as any succeeding spaces
whales_dives_cleaned <- whales_dives_cleaned %>% mutate(sit = str_remove(whales_dives_cleaned$sit, "Sighting\\s*"
))

#renames all columns to correct version
names(whales_dives_cleaned) <- c("species", "behavior", "prey.volume", "prey.depth",
                                 "dive.time", "surface.time", "blow.interval",
                                 "blow.number", "year", "month", "day", "sit")

#paste columns together without spaces
whales_dives_cleaned$id <- paste0(whales_dives_cleaned$year, whales_dives_cleaned$month, whales_dives_cleaned$day, whales_dives_cleaned$sit)

#cuts off every character in behavior past the first
whales_dives_cleaned$behavior <- substr(whales_dives_cleaned$behavior, 1, 1)

#renames F to FEED and O to OTHER
whales_dives_cleaned <- whales_dives_cleaned %>% mutate(behavior = case_when(
  behavior %in% c("F") ~ "FEED",
  behavior %in% c("O") ~ "OTHER",
  TRUE ~ behavior  # keep the value unchanged if it doesn't match any condition
))
## removes all rows with NA and then keeps distinct observations
whales_dives_cleaned <- na.omit(whales_dives_cleaned)
whales_dives_cleaned <- whales_dives_cleaned %>% distinct()

## but how to remove columns that we wanted to MERGE...? drop columns
whales_dives_cleaned <- subset(whales_dives_cleaned, select = -c(year, month, day, sit))

#corrects misspellings in species column
whales_dives_cleaned <- whales_dives_cleaned %>% mutate(species = case_when(
  species == "FinW" ~ "FW",
  species == "FinWhale" ~ "FW",
  species == "Hw" ~ "HW",
  species=="fin" ~ "FW",
  species=="finderbender"~"FW",
  TRUE ~ species  # Keep other values unchanged
))

# removes 2 observations that were called finderbender
# because they do not show up in the clean version

# need to convert id in ours to be numeric, bc it is originally character value
whales_dives_cleaned$id <- as.numeric(whales_dives_cleaned$id)

#compare which observations in our data is not in the clean one, and then we can filter them out
whalesdives_diff1 <- anti_join(whales_dives_cleaned, wdclean, by = "id")

# removing every unnecessary id

all.equal(wdclean,whales_dives_cleaned)

#moves id column to the left
whales_dives_cleaned <- whales_dives_cleaned[, c("id", setdiff(names(whales_dives_cleaned), "id"))]

whales_dives_cleaned <- whales_dives_cleaned %>% arrange
