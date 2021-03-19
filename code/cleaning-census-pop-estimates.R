##### Title: Census State-Level Population Data Cleaning ####

#### Notes: ####
  ### Description: Cleaning and constructing measures of population estimates with racial composition ###

#### Setup ####

{
  here::here()
  library(readr)
  library(dplyr)
}

census <- read_csv('data/census_pop_estimates.csv')

#### Data frame manipulaton and cleaning ####

census2 <- census %>%
  dplyr::select(STATE, RACE, CENSUS2010POP, POPESTIMATE2012, POPESTIMATE2016) %>%
  group_by(STATE) %>%
  summarise(WHITE_CENSUS10POP = sum(CENSUS2010POP[RACE == 1]),
            NONWHITE_CENUS10POP = sum(CENSUS2010POP[RACE >= 2]),
            WHITE_CENSUS12EST = sum(POPESTIMATE2012[RACE == 1]),
            NONWHITE_CENSUS12EST = sum(POPESTIMATE2012[RACE >= 2]),
            WHITE_CENSUS16EST = sum(POPESTIMATE2016[RACE == 1]),
            NONWHITE_CENSUS16EST = sum(POPESTIMATE2016[RACE >=2]),
            .groups = 'drop')

#### SAVE CENSUS DATA ####
write_dta(census2, 'data/census_pop_estimates_by_state.dta')
