#### 2016 Congressional District Race Cleaning ####

### Notes: ###
## Making long transformation of dataset from US Census.gov ##
## Do gini and income merging first!! ##

#### Setup ####
{
  library(here)
}
source("code/personal-threats-setup-file.R")

#### Loading Data ####
race14 <- read.csv("data/2014_acs_census_race/2014_acs_census_race.csv", stringsAsFactors = FALSE) %>%
  slice(-1)
race16 <- read.csv("data/2016_congressional_district_race_estimates/2016_congressional_district_race_estimates.csv", stringsAsFactors = FALSE) %>%
  slice(-1)
income16 <- read_dta("data/anes-2016/3_income_anes_2016_updated.dta")

#### Cleaning ####

race14 <- race14 %>%
  separate(GEO_ID, c("front", "fulldistrict"), "US") %>%
  rename(
    cdWhiteEstimate14 = DP05_0059E,
    cdWhiteError14 = DP05_0059M,
    cdWhitePercent14 = DP05_0059PE,
    cdWhitePError14 = DP05_0059PM
  ) %>%
  select("fulldistrict", "cdWhiteEstimate14", "cdWhiteError14", "cdWhitePercent14", "cdWhitePError14") %>%
    mutate(district = ifelse(fulldistrict == '0200', '0201', 
                    ifelse(fulldistrict == '1000', '1001', 
                    ifelse(fulldistrict == '1198', '1101', 
                    ifelse(fulldistrict == '3000', '3001', 
                    ifelse(fulldistrict == '3800', '3801', 
                    ifelse(fulldistrict == '4600', '4601', 
                    ifelse(fulldistrict == '5000', '5001', 
                    ifelse(fulldistrict == '5600', '5601', fulldistrict)))))))))

race14[] <- lapply(race14, function(x) as.numeric(as.character(x)))

race16 <- race16 %>%
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


race16[] <- lapply(race16, function(x) as.numeric(as.character(x)))

race16_combined1 <- full_join(race14, race16, by = "district")
race16_combined <- left_join(income16, race16_combined1, by = "district")

#### Create change race measure ####
race16_combined <- race16_combined %>%
  mutate(cngRace = cdWhitePercent - cdWhitePercent14)
#### Save ####

race16_combined <- race16_combined %>%
                      rename(fulldistrictx3 = fulldistrict.x, 
                            fulldistricty3 = fulldistrict.y)
write_dta(race16_combined, "data/anes-2016/4_race_anes_2016_updated.dta")
