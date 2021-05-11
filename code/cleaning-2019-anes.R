#### 2019 ANES Pilot Cleaning ####
### Notes: ###
## `RECODE TO:` indicates that the variable had been recoded to that new scheme. ##
## Data are filtered to only include white respondents ##

#### Setup ####

here::here()
source('code/personal-threats-setup-file.R')

#### Codebook ####

### ANES 2019 Pilot - Subset to White R's Only###
## White Identity ##
# 1 = Not at all important - 5 = Extremely Important #
dat19 <- dat19o %>%
  filter(race == 1) %>%
  mutate(wid = ifelse(raceid <= 0, NA, raceid))