#### Personal Factors: Setup File ####

#### Notes: ####
### Description: Setup file for analysis of personal threats hypotheses ###

#### Files: ####
### In:  data/anes-2012/anes-2012.dta , data/anes-2016/anes-2016.dta , data/anes-2018/anes-2018.dta , data/anes-2019/anes-2019.dta ###
### Out: ###

#### Setup ####
setup <- function(){
  library(haven)
  library(tidyverse)
  library(tidylog)
  library(hrbrthemes)
  library(ggthemes)
  library(here)
  library(stargazer)
  library(GGally)
  here()
}
setup()

dat12o <- read_dta('data/anes-2012/anes-2012.dta')
dat16o <- read_dta('data/anes-2016/anes-2016.dta')
dat18o <- read_dta('data/anes-2018/anes-2018.dta')
dat19o <- read_dta('data/anes-2019/anes-2019.dta')
