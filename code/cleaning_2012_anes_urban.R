#### 2012 Congressional District Urban/Rural Cleaning ####

### Notes: ###
## Making long transformation of dataset from US Census.gov ##

#### Setup ####
{
  library(here)
}
source('code/personal-threats-setup-file.R')

urban12cd <- read_csv('data/2012_acs_census_urban/2012_acs_census_urban.csv') %>% 
  slice(-1)
anes12 <- read_dta('data/anes-2012/5_poverty_anes_2012_updated.dta')

#### Cleaning the data ####
urban12cd <- urban12cd %>% 
  separate(GEO_ID, c("front", "fulldistrict"), "US") %>% 
  select("fulldistrict","H002002", "H002005","H002001") %>% 
  rename(total = H002001,
         urban = H002002,
         rural = H002005) %>%
  mutate(district = ifelse(fulldistrict == '0200', '0201', 
                    ifelse(fulldistrict == '1000', '1001', 
                    ifelse(fulldistrict == '1198', '1101', 
                    ifelse(fulldistrict == '3000', '3001', 
                    ifelse(fulldistrict == '3800', '3801', 
                    ifelse(fulldistrict == '4600', '4601', 
                    ifelse(fulldistrict == '5000', '5001', 
                    ifelse(fulldistrict == '5600', '5601', fulldistrict)))))))))

urban12cd[] <- lapply(urban12cd, function(x) as.numeric(as.character(x)))

#### Merge Data ####
urban12cd_combined <- left_join(anes12, urban12cd, by = "district")


#### urban/rural percentage measure ####
urban12cd_combined <- urban12cd_combined %>%
    mutate(ruralpercent = (rural/total)) %>%
    mutate(ruralplurality = ifelse(ruralpercent >= 0.50, 1, 0))
#### Save Data ####
write_dta(urban12cd_combined, "data/anes-2012/6_urbany_anes_2012_updated.dta")
