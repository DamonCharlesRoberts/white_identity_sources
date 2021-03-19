#### 2012 Congressional District Poverty Cleaning ####

### Notes: ###
## Making long transformation of dataset from US Census.gov ##
## Do gini, income, and race merging first!! ##

#### Setup ####
{
  library(here)
}
source("code/personal-threats-setup-file.R")

#### Loading the data ####
poverty12 <- read.csv("data/2012_acs_census_poverty/2012_acs_census_poverty.csv", stringsAsFactors = FALSE) %>% 
  slice(-1)
anes12 <- read_dta("data/anes-2012/4_race_anes_2012_updated.dta")

#### Cleaning the data ####
poverty12 <- poverty12 %>% 
  separate(GEO_ID, c("front", "fulldistrict"), "US") %>% 
  select("fulldistrict","S1701_C03_011E", "S1701_C03_011M") %>% 
  rename(percentBelowPoverty = S1701_C03_011E,
         percentBelowPovertyME = S1701_C03_011M) %>%
  mutate(district = ifelse(fulldistrict == '0200', '0201', 
                    ifelse(fulldistrict == '1000', '1001', 
                    ifelse(fulldistrict == '1198', '1101', 
                    ifelse(fulldistrict == '3000', '3001', 
                    ifelse(fulldistrict == '3800', '3801', 
                    ifelse(fulldistrict == '4600', '4601', 
                    ifelse(fulldistrict == '5000', '5001', 
                    ifelse(fulldistrict == '5600', '5601', fulldistrict)))))))))

poverty12[] <- lapply(poverty12, function(x) as.numeric(as.character(x)))

#### Merge Data ####
poverty12_combined <- left_join(anes12, poverty12, by = "district")
poverty12_combined <- poverty12_combined %>%
                      rename(fulldistrictx2 = fulldistrict.x, 
                            fulldistrictyy = fulldistrict.y)
#### Save Data ####
write_dta(poverty12_combined, "data/anes-2012/5_poverty_anes_2012_updated.dta")
