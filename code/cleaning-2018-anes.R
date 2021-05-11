#### 2018 ANES Pilot Cleaning ####
### Notes: ###
## `RECODE TO:` indicates that the variable had been recoded to that new scheme. ##
## Data are filtered to only include white respondents ##

#### Setup ####

here::here()
source('code/personal-threats-setup-file.R')

#### Codebook ####

### ANES 2018 Pilot - Subset to White R's Only###

## Economy better/worse than 1 year ago - epast ##
# 1 = Much Better - 5 = Much Worse #
# -2 = Much Worse - 2 = Much Better #

## White Identity ##
# 1 = Not at all important - 5 = Extremely Important #

#### Recoding Code ####
dat18 <- dat18o %>%
  filter(race == 1) %>%
  mutate(epast = ifelse(econ12mo == 1, 5, 
                        ifelse(econ12mo == 2, 4,
                               ifelse(econ12mo == 3,3, 
                                      ifelse(econ12mo == 4, 2,
                                             ifelse(econ12mo == 5, 1, NA)))))) %>%
  
  mutate(wid = ifelse(whiteid <= 0, NA, whiteid)) 