#### 2016 Congressional District Poverty Cleaning ####

### Notes: ###
## Making long transformation of dataset from US Census.gov ##
## Do gini, income, and race merging first!! ##

#### Setup ####
{
  library(here)
}
source("code/personal-threats-setup-file.R")

#### Loading the data ####
poverty16 <- read.csv("data/2016_acs_census_poverty/2016_acs_census_poverty.csv", stringsAsFactors = FALSE) %>% 
  slice(-1)
anes16 <- read_dta("data/anes-2016/4_race_anes_2016_updated.dta")

#### Cleaning the data ####
poverty16 <- poverty16 %>% 
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

poverty16[] <- lapply(poverty16, function(x) as.numeric(as.character(x)))

#### Merge Data ####
poverty16_combined <- left_join(anes16, poverty16, by = "district")

#### Save Data ####
poverty16_combined <- poverty16_combined %>%
                      rename(fulldistrictx4 = fulldistrict.x, 
                            fulldistricty4 = fulldistrict.y)
write_dta(poverty16_combined, "data/anes-2016/5_poverty_anes_2016_updated.dta")
