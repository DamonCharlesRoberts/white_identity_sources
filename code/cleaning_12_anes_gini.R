#### 2012 Congressional District Gini Cleaning ####

### Notes: ###
## Making long transformation of dataset from US Census.gov ##

#### Setup ####
{
  library(here)
}
source('code/personal-threats-setup-file.R')

#### Loading and Cleaning ####
  ### Loading ###
gini12cd <- read_csv('data/us_gini/2012_gini_census_congressional_district/2012_gini_census_congressional_district_data.csv') %>% 
  slice(-1)

anes12 <- read_dta('data/anes-2012/anes-2012-updated.dta')

  ### Cleaning ###
anes12 <- anes12 %>% 
  mutate(nState = case_when(
    sample_state == 'AL' ~ '01',
    sample_state == 'AK' ~ '02',
    sample_state == 'AZ' ~ '04',
    sample_state == 'AR' ~ '05',
    sample_state == 'CA' ~ '06',
    sample_state == 'CO' ~ '08',
    sample_state == 'CT' ~ '09',
    sample_state == 'DE' ~ '10',
    sample_state == 'DC' ~ '11',
    sample_state == 'FL' ~ '12',
    sample_state == 'GA' ~ '13',
    sample_state == 'HI' ~ '15',
    sample_state == 'ID' ~ '16',
    sample_state == 'IL' ~ '17',
    sample_state == 'IN' ~ '18',
    sample_state == 'IA' ~ '19',
    sample_state == 'KS' ~ '20',
    sample_state == 'KY' ~ '21',
    sample_state == 'LA' ~ '22',
    sample_state == 'ME' ~ '23',
    sample_state == 'MD' ~ '24',
    sample_state == 'MA' ~ '25',
    sample_state == 'MI' ~ '26',
    sample_state == 'MN' ~ '27',
    sample_state == 'MS' ~ '28',
    sample_state == 'MO' ~ '29',
    sample_state == 'MT' ~ '30',
    sample_state == 'NE' ~ '31', 
    sample_state == 'NV' ~ '32',
    sample_state == 'NH' ~ '33', 
    sample_state == 'NJ' ~ '34',
    sample_state == 'NM' ~ '35',
    sample_state == 'NY' ~ '36',
    sample_state == 'NC' ~ '37',
    sample_state == 'ND' ~ '38',
    sample_state == 'OH' ~ '39',
    sample_state == 'OK' ~ '40',
    sample_state == 'OR' ~ '41',
    sample_state == 'PA' ~ '42', 
    sample_state == 'RI' ~ '44',
    sample_state == 'SC' ~ '45',
    sample_state == 'SD' ~ '46',
    sample_state == 'TN' ~ '47',
    sample_state == 'TX' ~ '48',
    sample_state == 'UT' ~ '49',
    sample_state == 'VT' ~ '50',
    sample_state == 'VA' ~ '51',
    sample_state == 'WA' ~ '53',
    sample_state == 'WV' ~ '54',
    sample_state == 'WI' ~ '55',
    sample_state == 'WY' ~ '56',
    sample_state == 'PR' ~ '57'
                            )
         ) %>%
  mutate(nDistrict = case_when(sample_district == 1 ~ '01',
                               sample_district == 2 ~ '02',
                               sample_district == 3 ~ '03',
                               sample_district == 4 ~ '04',
                               sample_district == 5 ~ '05', 
                               sample_district == 6 ~ '06',
                               sample_district == 7 ~ '07',
                               sample_district == 8 ~ '08',
                               sample_district == 9 ~ '09',
                               sample_district == 10 ~ '10',
                               sample_district == 11 ~ '11',
                               sample_district == 12 ~ '12',
                               sample_district == 13 ~ '13',
                               sample_district == 14 ~ '14',
                               sample_district == 15 ~ '15',
                               sample_district == 16 ~ '16',
                               sample_district == 17 ~ '17',
                               sample_district == 18 ~ '18',
                               sample_district == 19 ~ '19',
                               sample_district == 20 ~ '20',
                               sample_district == 21 ~ '21',
                               sample_district == 22 ~ '22',
                               sample_district == 23 ~ '23',
                               sample_district == 24 ~ '24',
                               sample_district == 25 ~ '25',
                               sample_district == 26 ~ '26',
                               sample_district == 27 ~ '27',
                               sample_district == 28 ~ '28',
                               sample_district == 29 ~ '29',
                               sample_district == 30 ~ '30',
                               sample_district == 31 ~ '31',
                               sample_district == 32 ~ '32',
                               sample_district == 33 ~ '33',
                               sample_district == 34 ~ '34',
                               sample_district == 35 ~ '35',
                               sample_district == 36 ~ '36',
                               sample_district == 37 ~ '37',
                               sample_district == 38 ~ '38',
                               sample_district == 39 ~ '39',
                               sample_district == 40 ~ '40',
                               sample_district == 41 ~ '41',
                               sample_district == 42 ~ '42',
                               sample_district == 43 ~ '43',
                               sample_district == 44 ~ '44',
                               sample_district == 45 ~ '45',
                               sample_district == 46 ~ '46',
                               sample_district == 47 ~ '47',
                               sample_district == 48 ~ '48',
                               sample_district == 49 ~ '49',
                               sample_district == 50 ~ '50',
                               sample_district == 51 ~ '51',
                               sample_district == 52 ~ '52',
                               sample_district == 53 ~ '53',
                               sample_district == 54 ~ '54',
                               sample_district == 55 ~ '55',
                               sample_district == 56 ~ '56',
                               sample_district == 57 ~ '57',
                               sample_district == 58 ~ '58',
                               sample_district == 59 ~ '59',
                               
                               
  )
  ) %>%
 mutate(district = paste(nState, nDistrict, sep = ''))

anes12$district <- as.character(anes12$district)


gini12cd <- gini12cd %>%
  separate(GEO_ID, c('front', 'fulldistrict'), 'US') %>%
  mutate(district = ifelse(fulldistrict == '0200', '0201', 
                    ifelse(fulldistrict == '1000', '1001', 
                    ifelse(fulldistrict == '1198', '1101', 
                    ifelse(fulldistrict == '3000', '3001', 
                    ifelse(fulldistrict == '3800', '3801', 
                    ifelse(fulldistrict == '4600', '4601', 
                    ifelse(fulldistrict == '5000', '5001', 
                    ifelse(fulldistrict == '5600', '5601', fulldistrict)))))))))
gini12cd$district <- as.character(gini12cd$district)

#### Merging ####
  ### 2012 ANES loses 155 observations. ###
anes12$district <- as.numeric(anes12$district)
gini12cd$district <- as.numeric(gini12cd$district)
combined12 <- left_join(anes12, gini12cd, by = "district")

combined12 <- combined12 %>%
  rename(gini = B19083_001E,
        gini_error = B19083_001M)

combined12[] <- lapply(combined12, function(x) as.numeric(as.character(x)))

write_dta(combined12, 'data/anes-2012/gini_anes_2012_updated.dta')
