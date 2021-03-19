#### 2016 Congressional District Income Cleaning ####

### Notes: ###
## Making long transformation of dataset from US Census.gov ##
## Run Gini cleaning code first!! ##

#### Setup ####
{
  library(here)
}
source("code/personal-threats-setup-file.R")

#### Loading and Cleaning ####
### Loading ###
gini16 <- read_dta("data/anes-2016/gini_anes_2016_updated.dta")
income14 <- read.csv("data/2014_acs_census_income/2014_acs_census_income.csv", stringsAsFactors = FALSE) %>%
  slice(-1)
income16 <- read.csv("data/2016_congressional_district_income_estimates/2016_acs_congressional_district_income.csv") %>%
  slice(-1)

### Cleaning ###

income14 <- income14 %>%
  separate(GEO_ID, c("front", "fulldistrict"), "US") %>%
  select("fulldistrict", "S1901_C01_012E", "S1901_C01_012M") %>%
      mutate(district = ifelse(fulldistrict == '0200', '0201', 
                    ifelse(fulldistrict == '1000', '1001', 
                    ifelse(fulldistrict == '1198', '1101', 
                    ifelse(fulldistrict == '3000', '3001', 
                    ifelse(fulldistrict == '3800', '3801', 
                    ifelse(fulldistrict == '4600', '4601', 
                    ifelse(fulldistrict == '5000', '5001', 
                    ifelse(fulldistrict == '5600', '5601', fulldistrict)))))))))

income14[] <- lapply(income14, function(x) as.numeric(as.character(x)))

income14 <- income14 %>%
  rename(median_income_cd14 = S1901_C01_012E) %>%
  rename(median_income_error_cd14 = S1901_C01_012M) %>%
  mutate(incomequartile14 = ifelse(median_income_cd14 == 0 & median_income_cd14 <= 4999, 1,
                                   ifelse(median_income_cd14 >= 5000 & median_income_cd14 <= 9999, 2,
                                          ifelse(median_income_cd14 >= 10000 & median_income_cd14 <= 12499, 3,
                                                 ifelse(median_income_cd14 >= 12500 & median_income_cd14 <= 14999, 4,
                                                        ifelse(median_income_cd14 >= 15000 & median_income_cd14 <= 17499, 5,
                                                               ifelse(median_income_cd14 >= 17500 & median_income_cd14 <= 19999, 6,
                                                                      ifelse(median_income_cd14 >= 20000 & median_income_cd14 <= 22499, 7,
                                                                             ifelse(median_income_cd14 >= 22500 & median_income_cd14 <= 24999, 8,
                                                                                    ifelse(median_income_cd14 >= 25000 & median_income_cd14 <= 27499, 9,
                                                                                           ifelse(median_income_cd14 >= 27500 & median_income_cd14 <= 29999, 10,
                                                                                                  ifelse(median_income_cd14 >= 30000 & median_income_cd14 <= 34999, 11,
                                                                                                         ifelse(median_income_cd14 >= 35000 & median_income_cd14 <= 39999, 12,
                                                                                                                ifelse(median_income_cd14 >= 40000 & median_income_cd14 <= 44999, 13,
                                                                                                                       ifelse(median_income_cd14 >= 45000 & median_income_cd14 <= 49999, 14,
                                                                                                                              ifelse(median_income_cd14 >= 50000 & median_income_cd14 <= 54999, 15,
                                                                                                                                     ifelse(median_income_cd14 >= 55000 & median_income_cd14 <= 59999, 16,
                                                                                                                                            ifelse(median_income_cd14 >= 60000 & median_income_cd14 <= 64999, 17,
                                                                                                                                                   ifelse(median_income_cd14 >= 65000 & median_income_cd14 <= 69999, 18,
                                                                                                                                                          ifelse(median_income_cd14 >= 70000 & median_income_cd14 <= 74999, 19,
                                                                                                                                                                 ifelse(median_income_cd14 >= 75000 & median_income_cd14 <= 75000, 20,
                                                                                                                                                                        ifelse(median_income_cd14 >= 80000 & median_income_cd14 <= 89999, 21,
                                                                                                                                                                               ifelse(median_income_cd14 >= 90000 & median_income_cd14 <= 99999, 22,
                                                                                                                                                                                      ifelse(median_income_cd14 >= 90000 & median_income_cd14 <= 99999, 22,
                                                                                                                                                                                             ifelse(median_income_cd14 >= 100000 & median_income_cd14 <= 109999, 23,
                                                                                                                                                                                                    ifelse(median_income_cd14 >= 110000 & median_income_cd14 <= 124999, 24,
                                                                                                                                                                                                           ifelse(median_income_cd14 >= 125000 & median_income_cd14 <= 149999, 25,
                                                                                                                                                                                                                  ifelse(median_income_cd14 >= 150000 & median_income_cd14 <= 174999, 26,
                                                                                                                                                                                                                         ifelse(median_income_cd14 >= 175000 & median_income_cd14 <= 249999, 27,
                                                                                                                                                                                                                                ifelse(median_income_cd14 >= 250000, 28, NA)
                                                                                                                                                                                                                         )
                                                                                                                                                                                                                  )
                                                                                                                                                                                                           )
                                                                                                                                                                                                    )
                                                                                                                                                                                             )
                                                                                                                                                                                      )
                                                                                                                                                                               )
                                                                                                                                                                        )
                                                                                                                                                                 )
                                                                                                                                                          )
                                                                                                                                                   )
                                                                                                                                            )
                                                                                                                                     )
                                                                                                                              )
                                                                                                                       )
                                                                                                                )
                                                                                                         )
                                                                                                  )
                                                                                           )
                                                                                    )
                                                                             )
                                                                      )
                                                               )
                                                        )
                                                 )
                                          )
                                   )
  ))


income16 <- income16 %>%
  separate(GEO_ID, c("front", "fulldistrict"), "US") %>%
  select("fulldistrict", "S1901_C01_012E", "S1901_C01_012M") %>%
      mutate(district = ifelse(fulldistrict == '0200', '0201', 
                    ifelse(fulldistrict == '1000', '1001', 
                    ifelse(fulldistrict == '1198', '1101', 
                    ifelse(fulldistrict == '3000', '3001', 
                    ifelse(fulldistrict == '3800', '3801', 
                    ifelse(fulldistrict == '4600', '4601', 
                    ifelse(fulldistrict == '5000', '5001', 
                    ifelse(fulldistrict == '5600', '5601', fulldistrict)))))))))

income16[] <- lapply(income16, function(x) as.numeric(as.character(x)))

income16 <- income16 %>%
  rename(median_income_cd = S1901_C01_012E) %>%
  rename(median_income_error_cd = S1901_C01_012M) %>%
  mutate(incomequartile = ifelse(median_income_cd == 0 & median_income_cd <= 4999, 1,
    ifelse(median_income_cd >= 5000 & median_income_cd <= 9999, 2,
      ifelse(median_income_cd >= 10000 & median_income_cd <= 12499, 3,
        ifelse(median_income_cd >= 12500 & median_income_cd <= 14999, 4,
          ifelse(median_income_cd >= 15000 & median_income_cd <= 17499, 5,
            ifelse(median_income_cd >= 17500 & median_income_cd <= 19999, 6,
              ifelse(median_income_cd >= 20000 & median_income_cd <= 22499, 7,
                ifelse(median_income_cd >= 22500 & median_income_cd <= 24999, 8,
                  ifelse(median_income_cd >= 25000 & median_income_cd <= 27499, 9,
                    ifelse(median_income_cd >= 27500 & median_income_cd <= 29999, 10,
                      ifelse(median_income_cd >= 30000 & median_income_cd <= 34999, 11,
                        ifelse(median_income_cd >= 35000 & median_income_cd <= 39999, 12,
                          ifelse(median_income_cd >= 40000 & median_income_cd <= 44999, 13,
                            ifelse(median_income_cd >= 45000 & median_income_cd <= 49999, 14,
                              ifelse(median_income_cd >= 50000 & median_income_cd <= 54999, 15,
                                ifelse(median_income_cd >= 55000 & median_income_cd <= 59999, 16,
                                  ifelse(median_income_cd >= 60000 & median_income_cd <= 64999, 17,
                                    ifelse(median_income_cd >= 65000 & median_income_cd <= 69999, 18,
                                      ifelse(median_income_cd >= 70000 & median_income_cd <= 74999, 19,
                                        ifelse(median_income_cd >= 75000 & median_income_cd <= 75000, 20,
                                          ifelse(median_income_cd >= 80000 & median_income_cd <= 89999, 21,
                                            ifelse(median_income_cd >= 90000 & median_income_cd <= 99999, 22,
                                              ifelse(median_income_cd >= 90000 & median_income_cd <= 99999, 22,
                                                ifelse(median_income_cd >= 100000 & median_income_cd <= 109999, 23,
                                                  ifelse(median_income_cd >= 110000 & median_income_cd <= 124999, 24,
                                                    ifelse(median_income_cd >= 125000 & median_income_cd <= 149999, 25,
                                                      ifelse(median_income_cd >= 150000 & median_income_cd <= 174999, 26,
                                                        ifelse(median_income_cd >= 175000 & median_income_cd <= 249999, 27,
                                                          ifelse(median_income_cd >= 250000, 28, NA)
                                                        )
                                                      )
                                                    )
                                                  )
                                                )
                                              )
                                            )
                                          )
                                        )
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          )
                        )
                      )
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
  ))


#### Merge the data ####
income16_combined1 <- full_join(income14, income16, by = "district")
income16_combined <- left_join(gini16, income16_combined1, by = "district")


#### Create relative income measure ####
income16_combined <- income16_combined %>%
  mutate(estinc = ifelse(V161361x == -2, NA,
                         ifelse(V161361x == -1, NA,
                                ifelse(V161361x == 0, NA,
                                       ifelse(V161361x == 98, NA,
                                              ifelse(V161361x == -9, NA, 
                                                     ifelse(V161361x == -8, NA, V161361x)))))))
income16_combined <- income16_combined %>%
  mutate(relativeIncome = (estinc - incomequartile))

#### Create income change measure ####
income16_combined <- income16_combined %>%
  mutate(cngIncome = (incomequartile - incomequartile14))

#### Save Data ####
income16_combined <- income16_combined %>%
                      rename(fulldistrictx2 = fulldistrict.x, 
                            fulldistrictyy = fulldistrict.y)
write_dta(income16_combined, "data/anes-2016/3_income_anes_2016_updated.dta")
