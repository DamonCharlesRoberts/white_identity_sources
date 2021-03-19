#### 2012 Congressional District Median Income Cleaning ####

### Notes: ###
## Making long transformation of dataset from US Census.gov ##
## Do gini merging first!! ##

#### Setup ####
{
  library(here)
}
source("code/personal-threats-setup-file.R")

#### Loading Data ####
income12 <- read.csv("data/2012_congressional_district_income_estimates/2012_acs_median_income_data_congressional_district.csv", stringsAsFactors = FALSE) %>%
  slice(-1)
#income10 <- read.csv("data/2010_acs_census_income/2010_acs_census_income.csv", stringsAsFactors = FALSE) %>%
#  slice(-1)
gini12 <- read_dta("data/anes-2012/gini_anes_2012_updated.dta") 

#### Clean the Data ####
#income10 <- income10 %>%
#  separate(GEO_ID, c('front', 'fulldistrict'), 'US') %>%
#  mutate(district = ifelse(fulldistrict == 0200, 0201, 
#                    ifelse(fulldistrict == 1000, 1001, 
#                    ifelse(fulldistrict == 1198, 1101, 
#                    ifelse(fulldistrict == 3000, 3001, 
#                    ifelse(fulldistrict == 3800, 3801, 
#                    ifelse(fulldistrict == 4600, 4601, 
#                    ifelse(fulldistrict == 5000, 5001, 
#                    ifelse(fulldistrict == 5600, 5601, fulldistrict)))))))))


#income10 <- income10 %>%
#  rename(median_income_cd10 = S1901_C01_012E,
#         median_income_error_cd10 = S1901_C01_012M) %>%
#  mutate(incomequartile10 = ifelse(median_income_cd10 == 0 & median_income_cd10 <= 4999, 1,
#                                   ifelse(median_income_cd10 >= 5000 & median_income_cd10 <= 9999, 2,
#                                          ifelse(median_income_cd10 >= 10000 & median_income_cd10 <= 12499, 3,
#                                                 ifelse(median_income_cd10 >= 12500 & median_income_cd10 <= 14999, 4,
#                                                        ifelse(median_income_cd10 >= 15000 & median_income_cd10 <= 17499, 5,
#                                                               ifelse(median_income_cd10 >= 17500 & median_income_cd10 <= 19999, 6,
#                                                                      ifelse(median_income_cd10 >= 20000 & median_income_cd10 <= 22499, 7,
#                                                                             ifelse(median_income_cd10 >= 22500 & median_income_cd10 <= 24999, 8,
                                                                                  #  ifelse(median_income_cd10 >= 25000 & median_income_cd10 <= 27499, 9,
                                                                                  #         ifelse(median_income_cd10 >= 27500 & median_income_cd10 <= 29999, 10,
                                                                                  #                ifelse(median_income_cd10 >= 30000 & median_income_cd10 <= 34999, 11,
                                                                                  #                       ifelse(median_income_cd10 >= 35000 & median_income_cd10 <= 39999, 12,
                                                                                  #                              ifelse(median_income_cd10 >= 40000 & median_income_cd10 <= 44999, 13,
                                                                                  #                                     ifelse(median_income_cd10 >= 45000 & median_income_cd10 <= 49999, 14,
                                                                                  #                                            ifelse(median_income_cd10 >= 50000 & median_income_cd10 <= 54999, 15,
                                                                                  #                                                   ifelse(median_income_cd10 >= 55000 & median_income_cd10 <= 59999, 16,
                                                                                  #                                                          ifelse(median_income_cd10 >= 60000 & median_income_cd10 <= 64999, 17,
                                                                                  #                                                                 ifelse(median_income_cd10 >= 65000 & median_income_cd10 <= 69999, 18,
                                                                                  #                                                                        ifelse(median_income_cd10 >= 70000 & median_income_cd10 <= 74999, 19,
                                                                                  #                                                                               ifelse(median_income_cd10 >= 75000 & median_income_cd10 <= 75000, 20,
                                                                                  #                                                                                      ifelse(median_income_cd10 >= 80000 & median_income_cd10 <= 89999, 21,
                                                                                  #                                                                                             ifelse(median_income_cd10 >= 90000 & median_income_cd10 <= 99999, 22,
                                                                                  #                                                                                                    ifelse(median_income_cd10 >= 90000 & median_income_cd10 <= 99999, 22,
                                                                                  #                                                                                                           ifelse(median_income_cd10 >= 100000 & median_income_cd10 <= 109999, 23,
                                                                                  #                                                                                                                  ifelse(median_income_cd10 >= 110000 & median_income_cd10 <= 124999, 24,
                                                                                  #                                                                                                                         ifelse(median_income_cd10 >= 125000 & median_income_cd10 <= 149999, 25,
                                                                                  #                                                                                                                                ifelse(median_income_cd10 >= 150000 & median_income_cd10 <= 174999, 26,
                                                                                  #                                                                                                                                       ifelse(median_income_cd10 >= 175000 & median_income_cd10 <= 249999, 27,
                                                                                  #                                                                                                                                              ifelse(median_income_cd10 >= 250000, 28, NA)
                                                                                  #                                                                                                                                       )
                                                                                  #                                                                                 #                                               )
                                                                                  #                                                                                 #                                        )
                                                                                  #                                                                                 #                                 )
                                                                                  #                                                                                 #                          )
                                                                                  #                                                                                 #                   )
                                                                                  #                                                                                 #            )
                                                                                                                                                                    #    )
                                                                                  #                                                                               )
                                                                                  #                                                                        )
                                                                                  #                                                                 )
                                                                                  #                                                          )
                                                                                  #                                                   )
                                                                                  #                                            )
                                                                                  #                                     )
                                                                                  #                              )
                                                                                  #                       )
                                                                                  #                )
                                                                                  #         )
                                                                                  #  )
#                                                                             )
#                                                                      )
#                                                               )
#                                                        )
#                                                 )
#                                          )
#                                   )
#  ))






income12 <- income12 %>%
  separate(GEO_ID, c('front', 'fulldistrict'), 'US') %>%
  mutate(district = ifelse(fulldistrict == '0200', '0201', 
                    ifelse(fulldistrict == '1000', '1001', 
                    ifelse(fulldistrict == '1198', '1101', 
                    ifelse(fulldistrict == '3000', '3001', 
                    ifelse(fulldistrict == '3800', '3801', 
                    ifelse(fulldistrict == '4600', '4601', 
                    ifelse(fulldistrict == '5000', '5001', 
                    ifelse(fulldistrict == '5600', '5601', fulldistrict)))))))))

income12[] <- lapply(income12, function(x) as.numeric(as.character(x)))

income12 <- income12 %>%
  rename(median_income_cd = S1901_C01_012E,
         median_income_error_cd = S1901_C01_012M) %>%
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
gini12$district <- as.numeric(gini12$district)
income12$district <- as.numeric(income12$district)
#income10$district <- as.numeric(income10$district)
#income12_combined1 <- full_join(income12, income10, by = "district")
income12_combined <- left_join(gini12, income12, by = "district")


#### Create relative income measure ####
income12_combined <- income12_combined %>%
  mutate(estinc = ifelse(inc_incgroup_pre == -2, NA,
                         ifelse(inc_incgroup_pre == -1, NA,
                                ifelse(inc_incgroup_pre == 0, NA,
                                       ifelse(inc_incgroup_pre == 98, NA,
                                              ifelse(inc_incgroup_pre == -9, NA, 
                                                     ifelse(inc_incgroup_pre == -8, NA, inc_incgroup_pre)))))))
income12_combined <- income12_combined %>%
  mutate(relativeIncome = (estinc - incomequartile))

#### Create Income change measure ####
#income12_combined <- income12_combined %>%
#  mutate(cngIncome = (incomequartile - incomequartile10))
income12_combined <- income12_combined %>%
                      rename(frontx = front.x,
                            fronty = front.y,
                            fulldistrictx = fulldistrict.x, 
                            fulldistricty = fulldistrict.y, 
                            namex = NAME.x, 
                            namey = NAME.y)
write_dta(income12_combined, "data/anes-2012/3_income_anes_2012_updated.dta")
