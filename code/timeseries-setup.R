#### Timeseries: Setup ####

#### Notes: ####
  ### Description: Set up file for 2016 ANES Cumulative analysis of white group identity over time. ###

#### Files: ####
  ### In: data/Cumulative_ANES/anes_timeseries_cdf.dta ###
  ### Out: ###

#### Load Libraries ####
setup <- function(){
  library(haven)
  library(tidyverse)
  here::here()
}
setup()
dat <- read_dta('data/Cumulative_ANES/anes_timeseries_cdf.dta')
dat2 <- read_dta('data/anes-2018/anes-2018.dta')
