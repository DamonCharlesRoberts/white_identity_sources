#### 2012 Congressional District Race Cleaning ####

### Notes: ###
## Making long transformation of dataset from US Census.gov ##
## Do gini and income merging first!! ##

#### Setup ####
{
  library(here)
}
source("code/personal-threats-setup-file.R")

#### Loading Data ####
#race10 <- read.csv('data/2010_acs_census_race/2010_acs_census_race.csv', stringsAsFactors = FALSE) %>%
#  slice(-1)
race12 <- read.csv("data/2012_congressional_district_race_estimates/2012_congressional_district_race_estimates.csv") %>%
  slice(-1)
income12 <- read_dta("data/anes-2012/3_income_anes_2012_updated.dta")

#### Cleaning ####

#race10 <- race10 %>%
#  separate(GEO_ID, c("front", "district"), "US") %>%
#  rename(
#    cdWhiteEstimate10 = DP05_0059E,
#    cdWhiteError10 = DP05_0059M,
#    cdWhitePercent10 = DP05_0059PE,
#    cdWhitePError10 = DP05_0059PM
#  ) %>%
#  select("district", "cdWhiteEstimate10", "cdWhiteError10", "cdWhitePercent10", "cdWhitePError10")

#race10[] <- lapply(race10, function(x) as.numeric(as.character(x)))

race12 <- race12 %>%
  separate(GEO_ID, c("front", "fulldistrict"), "US") %>%
  rename(
    cdWhiteEstimate = DP05_0059E,
    cdWhiteError = DP05_0059M,
    cdWhitePercent = DP05_0059PE,
    cdWhitePError = DP05_0059PM
  ) %>%
  select("fulldistrict", "cdWhiteEstimate", "cdWhiteError", "cdWhitePercent", "cdWhitePError") %>%
    mutate(district = ifelse(fulldistrict == '0200', '0201', 
                    ifelse(fulldistrict == '1000', '1001', 
                    ifelse(fulldistrict == '1198', '1101', 
                    ifelse(fulldistrict == '3000', '3001', 
                    ifelse(fulldistrict == '3800', '3801', 
                    ifelse(fulldistrict == '4600', '4601', 
                    ifelse(fulldistrict == '5000', '5001', 
                    ifelse(fulldistrict == '5600', '5601', fulldistrict)))))))))

race12[] <- lapply(race12, function(x) as.numeric(as.character(x)))

race12_combined <- left_join(race12, income12, by = "district")
#race12_combined <- left_join(race10, race12_combined1, by = "district")

#### Create change in race measure ####
#race12_combined <- race12_combined %>%
#  mutate(cngRace = cdWhitePercent - cdWhitePercent10)
#### Save ####
write_dta(race12_combined, "data/anes-2012/4_race_anes_2012_updated.dta")
