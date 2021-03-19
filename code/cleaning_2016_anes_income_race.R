#### 2016 Congressional District Urban/Rural Cleaning ####

### Notes: ###
## Making long transformation of dataset from US Census.gov ##

#### Setup ####
{
  library(here)
}
source('code/personal-threats-setup-file.R')

incomerace16 <- read_csv('data/2016_acs_census_income_by_race/2016_acs_census_income_by_race.csv') %>%
                  slice(-1)
urban16 <- read_dta('data/anes-2016/6_urban_anes_2016_updated.dta')

#### Cleaning the Data ####
incomerace16 <- incomerace16 %>%
                  rename(whiteIncome = S1903_C02_002E,
                        blackIncome = S1903_C02_003E)
incomerace16 <- incomerace16 %>%
  separate(GEO_ID, c('front', 'fulldistrict'), 'US') %>%
  mutate(district = ifelse(fulldistrict == '0200', '0201', 
                    ifelse(fulldistrict == '1000', '1001', 
                    ifelse(fulldistrict == '1198', '1101', 
                    ifelse(fulldistrict == '3000', '3001', 
                    ifelse(fulldistrict == '3800', '3801', 
                    ifelse(fulldistrict == '4600', '4601', 
                    ifelse(fulldistrict == '5000', '5001', 
                    ifelse(fulldistrict == '5600', '5601', fulldistrict)))))))))
incomerace16[] <- lapply(incomerace16, function(x) as.numeric(as.character(x)))

incomerace16 <- incomerace16 %>%
  mutate(whiteIncomequartile = ifelse(whiteIncome == 0 & whiteIncome <= 4999, 1,
    ifelse(whiteIncome >= 5000 & whiteIncome <= 9999, 2,
      ifelse(whiteIncome >= 10000 & whiteIncome <= 12499, 3,
        ifelse(whiteIncome >= 12500 & whiteIncome <= 14999, 4,
          ifelse(whiteIncome >= 15000 & whiteIncome <= 17499, 5,
            ifelse(whiteIncome >= 17500 & whiteIncome <= 19999, 6,
              ifelse(whiteIncome >= 20000 & whiteIncome <= 22499, 7,
                ifelse(whiteIncome >= 22500 & whiteIncome <= 24999, 8,
                  ifelse(whiteIncome >= 25000 & whiteIncome <= 27499, 9,
                    ifelse(whiteIncome >= 27500 & whiteIncome <= 29999, 10,
                      ifelse(whiteIncome >= 30000 & whiteIncome <= 34999, 11,
                        ifelse(whiteIncome >= 35000 & whiteIncome <= 39999, 12,
                          ifelse(whiteIncome >= 40000 & whiteIncome <= 44999, 13,
                            ifelse(whiteIncome >= 45000 & whiteIncome <= 49999, 14,
                              ifelse(whiteIncome >= 50000 & whiteIncome <= 54999, 15,
                                ifelse(whiteIncome >= 55000 & whiteIncome <= 59999, 16,
                                  ifelse(whiteIncome >= 60000 & whiteIncome <= 64999, 17,
                                    ifelse(whiteIncome >= 65000 & whiteIncome <= 69999, 18,
                                      ifelse(whiteIncome >= 70000 & whiteIncome <= 74999, 19,
                                        ifelse(whiteIncome >= 75000 & whiteIncome <= 75000, 20,
                                          ifelse(whiteIncome >= 80000 & whiteIncome <= 89999, 21,
                                            ifelse(whiteIncome >= 90000 & whiteIncome <= 99999, 22,
                                              ifelse(whiteIncome >= 90000 & whiteIncome <= 99999, 22,
                                                ifelse(whiteIncome >= 100000 & whiteIncome <= 109999, 23,
                                                  ifelse(whiteIncome >= 110000 & whiteIncome <= 124999, 24,
                                                    ifelse(whiteIncome >= 125000 & whiteIncome <= 149999, 25,
                                                      ifelse(whiteIncome >= 150000 & whiteIncome <= 174999, 26,
                                                        ifelse(whiteIncome >= 175000 & whiteIncome <= 249999, 27,
                                                          ifelse(whiteIncome >= 250000, 28, NA)
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

incomerace16 <- incomerace16 %>%
  mutate(blackIncomequartile = ifelse(blackIncome == 0 & blackIncome <= 4999, 1,
    ifelse(blackIncome >= 5000 & blackIncome <= 9999, 2,
      ifelse(blackIncome >= 10000 & blackIncome <= 12499, 3,
        ifelse(blackIncome >= 12500 & blackIncome <= 14999, 4,
          ifelse(blackIncome >= 15000 & blackIncome <= 17499, 5,
            ifelse(blackIncome >= 17500 & blackIncome <= 19999, 6,
              ifelse(blackIncome >= 20000 & blackIncome <= 22499, 7,
                ifelse(blackIncome >= 22500 & blackIncome <= 24999, 8,
                  ifelse(blackIncome >= 25000 & blackIncome <= 27499, 9,
                    ifelse(blackIncome >= 27500 & blackIncome <= 29999, 10,
                      ifelse(blackIncome >= 30000 & blackIncome <= 34999, 11,
                        ifelse(blackIncome >= 35000 & blackIncome <= 39999, 12,
                          ifelse(blackIncome >= 40000 & blackIncome <= 44999, 13,
                            ifelse(blackIncome >= 45000 & blackIncome <= 49999, 14,
                              ifelse(blackIncome >= 50000 & blackIncome <= 54999, 15,
                                ifelse(blackIncome >= 55000 & blackIncome <= 59999, 16,
                                  ifelse(blackIncome >= 60000 & blackIncome <= 64999, 17,
                                    ifelse(blackIncome >= 65000 & blackIncome <= 69999, 18,
                                      ifelse(blackIncome >= 70000 & blackIncome <= 74999, 19,
                                        ifelse(blackIncome >= 75000 & blackIncome <= 75000, 20,
                                          ifelse(blackIncome >= 80000 & blackIncome <= 89999, 21,
                                            ifelse(blackIncome >= 90000 & blackIncome <= 99999, 22,
                                              ifelse(blackIncome >= 90000 & blackIncome <= 99999, 22,
                                                ifelse(blackIncome >= 100000 & blackIncome <= 109999, 23,
                                                  ifelse(blackIncome >= 110000 & blackIncome <= 124999, 24,
                                                    ifelse(blackIncome >= 125000 & blackIncome <= 149999, 25,
                                                      ifelse(blackIncome >= 150000 & blackIncome <= 174999, 26,
                                                        ifelse(blackIncome >= 175000 & blackIncome <= 249999, 27,
                                                          ifelse(blackIncome >= 250000, 28, NA)
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
urban16$district <- as.numeric(urban16$district)
incomerace16$district <- as.numeric(incomerace16$district)
income16_combined <- left_join(urban16, incomerace16, by = "district")

#### Create relativeIncomeRace measure ####
income16_combined <- income16_combined %>%
  mutate(relativeIncomeRace = (estinc - blackIncomequartile))
income16_combined <- income16_combined %>%
                      rename(frontx = front.x,
                            fronty = front.y,
                            namex = NAME.x, 
                            namey = NAME.y)
write_dta(income16_combined, "data/anes-2016/7_raceincome_anes_2016_updated.dta")
