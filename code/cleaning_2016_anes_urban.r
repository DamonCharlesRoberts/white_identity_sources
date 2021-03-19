#### 2016 Congressional District Urban/Rural Cleaning ####

### Notes: ###
## Making long transformation of dataset from US Census.gov ##

#### Setup ####
{
  library(here)
}
source('code/personal-threats-setup-file.R')

urban16cd <- read_csv('data/2016_acs_census_urban/2016_acs_census_urban.csv') %>% 
  slice(-1)
anes16 <- read_dta('data/anes-2016/5_poverty_anes_2016_updated.dta')

#### Cleaning the data ####
urban16cd <- urban16cd %>% 
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

urban16cd[] <- lapply(urban16cd, function(x) as.numeric(as.character(x)))

#### Merge Data ####
urban16cd_combined <- left_join(anes16, urban16cd, by = "district")


#### urban/rural percentage measure ####
urban16cd_combined <- urban16cd_combined %>%
    mutate(ruralpercent = (rural/total)) %>%
    mutate(ruralplurality = ifelse(ruralpercent >= 0.50, 1, 0))
#### Save Data ####
write_dta(urban16cd_combined, "data/anes-2016/6_urban_anes_2016_updated.dta")
