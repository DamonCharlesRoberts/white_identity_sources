#### 2016 ANES Cleaning ####
### Notes: ###
## `RECODE TO:` indicates that the variable had been recoded to that new scheme. ##
## Data are filtered to only include white respondents ##

#### Setup ####

here::here()
source('code/personal-threats-setup-file.R')

#### Codebook ####

### ANES 2016 - Subset to White R's Only###
## White Identity Ordinal - wid##
# 1 = Extremely Important - 5 Not at All Important #
# RECODE TO: 1 - Not at all Important = 5 Extremely Important #
## White Identity Binary - widb##
# 1 - Not at all Important - 5 = Extremely Important #
# RECODE TO: 0 - No if below 4, 1 - Greater than or equal to 4 #
## Female - female ##
# 1 = Male , 2 = Female #
# RECODE TO: 0 = Male , 1 = Female #
## Retrospective Better Off - rboff ##
# 1 = Much Better - 5 = Much Worse #
# RECODE TO: -2 = Much Worse - 2 Much Better #
## Propsective Better Off - pboff ##
# 1 = Much Better - 5 = Much Worse #
# RECODE TO: -2 = Much Worse - 2 Much Better #
## Ideology - ideo ##
# 1 = Extremely Liberal - 7 = Extremely Conservative #
## External Efficacy - ee ##
# 1 = Agree Strongly - 5 = Disagree Strongly #
# RECODE TO: 1 = Disagree Strongly - 5 = Agree Strongly #
## Public Officials Care - pocare ##
# 1 = A great deal -5 = Not at all #
# 1 = Not at all - 5 = A great Deal #
## Have no say in govt - ie #
# 1 = A great deal -5 = Not at all #
# 1 = Not at all - 5 = A great Deal #
## Economy better/worse than 1 year ago - epast ##
# 1 = Much Better - 5 = Much Worse #
# -2 = Much Worse - 2 = Much Better #
## Economy going to be better/worse in 1 year - efuture ##
# 1 = Much Better - 5 = Much Worse #
# -2 = Much Worse - 2 = Much Better #
## Unemployment better/worse than 1 year ago - unpast ##
# 1 = Much Better - 5 = Much Worse #
# -2 = Much Worse - 2 = Much Better # 
## PID - pid ##
# 1 = Strong Democrat - 7 = Strong Republican #
## Age - age ##
# Continuous - Truncated > 18 #
## Education - edu ##
# Censored: 1 = < high school , 2 = HS , 3 = Some Post-HS , 4 = Bachelors , 5 = Graduate #
## Find Job - findjob #
# 1 = Not at all - 5 = Extremely Worried #
## Lose Job - losejob #
# 1 = Not at all - 5 = Extremely Worried #
## Laid Off - offwork #
# 1 = Yes , 2 = No #
# RECODE TO: 0 = No , 1 = Yes #
## Fair jobs for blacks - fairjblacks ##
# 1 = Strongly Yes - 5 = Strongly No #
# RECODE TO: -2 = Strongly No - 2 = Strongly Yes #
## Immigrants Take Jobs - immtakejobs ##
# 1 = Extremely - 4 = Not at all #
## RECODE TO: 1 = Not at all - 4 = Extremely ##
## Worried about Family Finances - ecfamily ##
# 1 = Extremely - 5 = Not at all #
# -2 = Not at all - 2 = Extremely #
## Know someone lost job - ecjob #
# 1 = Someone lost job , 2 = No, did not lose job #
# RECODE TO: 0 = No , 2 = Yes #
## Linked Fate - linked #
# 1 = Yes , 2 = No #
# RECODE TO: 0 = No , 2 = Yes #
## New lifestyles breaking society - tradbreak ##
# 1 = Strongly Agree - 5 = Strongly Disagree #
# RECODE TO: -2 = Strongly Disagree - 2 = Strongly Agree #
## Blacks should work way up - blackworkmore ##
# 1 = Strongly Agree - 5 = Strongly Disagree #
# RECODE TO: -2 = Strongly Disagree - 2 = Strongly Agree #
## Slavery makes it difficult for blacks - slavery ##
# 1 = Strongly Agree - 5 = Strongly Disagree #
# RECODE TO: -2 = Strongly Disagree - 2 = Strongly Agree #
## Blacks have gotten less than deserve - resentdeserve ##
# 1 = Strongly Agree - 5 = Strongly Disagree #
# RECODE TO: -2 = Strongly Disagree - 2 = Strongly Agree #  
## Blacks should try harder - tryhard ##
# 1 = Strongly Agree - 5 = Strongly Disagree #
# RECODE TO: -2 = Strongly Disagree - 2 = Strongly Agree # 
## Support Blacks getting hired - blackhire ##
# 1 = Strongly Agree - 5 = Strongly Disagree #
# RECODE TO: -2 = Strongly Disagree - 2 = Strongly Agree # 
## Equality has gone too far - toofar #
# 1 = Strongly Agree - 5 = Strongly Disagree #
# RECODE TO: -2 = Strongly Disagree - 2 = Strongly Agree # 
## Gov favor Blacks to whites - govbias ##
# 1 = Favors whites , 2 = Favors blacks , 3 = neither #
# RECODE TO: -1 = Favors whites , 0 = neither , 1 = Favors blacks #
## Influence whites have on politics - inflwhite ##
# 1 = Too much , 2 = Just about right , 3 = Too little #
# RECODE TO: -1 = Too Little , 0 = About Right , 1 = Too Much #
## Influence blacks have on politics - inflblack ##
# 1 = Too much , 2 = Just about right , 3 = Too little #
# RECODE TO: -1 = Too Little , 0 = About Right , 1 = Too Much #
## How much are whites discriminated against - whitediscrim ##
# 1 = A great deal - 5 = None at all #
# RECODE TO: 1 = None at all - 5 = A great deal #
## Do you approve or disapprove of Obama -presapprove ##
# 1 = Approve, 2 = Disaprove #
# RECODE TO: 1 - Strongly Disapprove - 5 = Strongly Approve #
## Feeling Thermometer - Republican Candidate
# 0 - 100 #
## ##Would you say that you are in lower, upper, middle, above middle class? class ##
# RECODE TO: 1 - Lower class/poor - 5- Upper class
## Opportunity to get ahead - V162134 ##
# 1 A great deal - 5 None #
# RECODE TO: 1 None - 5 A great deal #
## Income inequality worse - V161138x ##
# 1 Much Larger - 5 Much Smaller #
# RECODE TO: 1 Much Smaller - 5 Much Larger #
## employment status - employment ##
# 1 Working now, 2 laid off, 4 unemployed, 5 retired, 6 disabled, 7 homemaker, 8 student #
# 0 laid off | unemployed | retired | disabled, 1 Working now | homemaker | student #

#### Recoding Code ####
dat16 <- dat16o %>%
  filter(V161310x == 1) %>%
  mutate(rboff = ifelse(V161110 == 1, 2,
                        ifelse(V161110 == 2, 1, 
                               ifelse(V161110 == 3, 0,
                                      ifelse(V161110 == 4, -1,
                                             ifelse(V161110 == 5, -2, NA)))))) %>%
  mutate(female = ifelse(V161342 == 2, 1,
                         ifelse(V161342 == 1, 0,
                                ifelse(V161342 == 3, 0, NA)))) %>%
  mutate(pboff = ifelse(V161111 == 1, 2,
                        ifelse(V161111 == 2,1,
                               ifelse(V161111 == 3,0,
                                      ifelse(V161111 == 4, -1, 
                                             ifelse(V161111 == 5, -2, NA)))))) %>%
  mutate(ideo = ifelse(V161126 <= 0, NA, V161126)) %>%
  mutate(epast = ifelse(V161140x == 1, 2,
                        ifelse(V161140x == 2,1,
                               ifelse(V161140x == 3, 0, 
                                      ifelse(V161140x == 4, -1, 
                                             ifelse(V161140x == 5, -2, NA)))))) %>%
  mutate(efuture = ifelse(V161141x == 1,2,
                          ifelse(V161141x == 2,1,
                                 ifelse(V161141x == 3, 0,
                                        ifelse(V161141x == 4,-1,
                                               ifelse(V161141x == 5,-2, NA)))))) %>%
  mutate(unpast = ifelse(V161142x == 1, 2,
                         ifelse(V161142x == 2,1,
                                ifelse(V161142x == 3, 0,
                                       ifelse(V161142x == 4, -1,
                                              ifelse(V161142x == 5, -2, NA)))))) %>%
  mutate(pid = ifelse(V161158x <= 0, NA, V161158x)) %>%
  mutate(econsince08 = ifelse(V161235x == 1,2,
                              ifelse(V161235x == 2,1,
                                     ifelse(V161235x == 3, 0,
                                            ifelse(V161235x == 4, -1,
                                                   ifelse(V161235x == 5,-2, NA)))))) %>%
  mutate(age = ifelse(V161267 <= 0, NA, V161267)) %>%
  mutate(edu = ifelse(V161270 <= 0, NA, V161270)) %>%
  mutate(ecfamily = ifelse(V162165 == 1, 2, 
                           ifelse(V162165 == 2,1,
                                  ifelse(V162165 == 3, 0,
                                         ifelse(V162165 == 4, -1,
                                                ifelse(V162165 == 5, -2, NA)))))) %>%
  mutate(ecjob = ifelse(V162167 == 2, 0, 
                        ifelse(V162167 == 1,1, NA))) %>%
  mutate(tradbreak = ifelse(V162208 == 1, 2,
                            ifelse(V162208 == 2,1,
                                   ifelse(V162208 == 3, 0,
                                          ifelse(V162208 == 4, -1,
                                                 ifelse(V162208 == 5, -2, NA)))))) %>%
  mutate(blackworkmore = ifelse(V162211 == 1,2,
                                ifelse(V162211 == 2,1,
                                       ifelse(V162211 == 3, 0,
                                              ifelse(V162211 == 4, -1,
                                                     ifelse(V162211 == 5, -2, NA)))))) %>%
  mutate(slavery = ifelse(V162212 == 1,2,
                          ifelse(V162212 == 2,1,
                                 ifelse(V162212 == 3,0,
                                        ifelse(V162212 == 4, -1, 
                                               ifelse(V162212 == 5, -2, NA)))))) %>%
  mutate(resentdeserve = ifelse(V162213 == 1,2,
                                ifelse(V162213 == 2,1,
                                       ifelse(V162213 == 3, 0,
                                              ifelse(V162213 == 4,-1,
                                                     ifelse(V162213 == 5, -2, NA)))))) %>%
  mutate(tryhard = ifelse(V162214 == 1,2,
                          ifelse(V162214 == 2,1,
                                 ifelse(V162214 == 3,0,
                                        ifelse(V162214 == 4,-1,
                                               ifelse(V162214 == 5,-2, NA)))))) %>%
  mutate(pocare = ifelse(V162215 == 1,2,
                         ifelse(V162215 == 2,1,
                                ifelse(V162215 == 3, 0,
                                       ifelse(V162215 == 4,-1,
                                              ifelse(V162215 == 5,-2, NA)))))) %>%
  mutate(ee = ifelse(V162216 == 1,2,
                     ifelse(V162216 == 2,1,
                            ifelse(V162216 == 3,0,
                                   ifelse(V162216 == 4,-1,
                                          ifelse(V162216 == 5,-2, NA)))))) %>%
  mutate(hireblack = ifelse(V162238x == 1,2,
                            ifelse(V162238x == 2,1,
                                   ifelse(V162238x == 3,0,
                                          ifelse(V162238x == 4,-1,
                                                 ifelse(V162238x == 5, -2,NA)))))) %>%
  mutate(govbias = ifelse(V162318 == 1,-1,
                          ifelse(V162318 == 3,0,
                                 ifelse(V162318 == 2,1, NA)))) %>%
  mutate(inflwhite = ifelse(V162322 == 3, -1,
                            ifelse(V162322 == 2,0,
                                   ifelse(V162322 == 1,1, NA)))) %>%
  mutate(inflblack = ifelse(V162323 == 3,-1,
                            ifelse(V162323 == 2,0,
                                   ifelse(V162323 == 1,1, NA)))) %>%
  mutate(whitediscrim = ifelse(V162360 == 5, 1,
                               ifelse(V162360 == 4, 2,
                                      ifelse(V162360 == 3,3,
                                             ifelse(V162360 == 2,4,
                                                    ifelse(V162360 == 5, 1, NA)))))) %>%
  mutate(wid = ifelse(V162327 <= 0, NA, V162327)) %>%
  mutate(wid = case_when(V162327 == 1 ~ 5,
                         V162327 == 2 ~ 4,
                         V162327 == 3 ~ 3,
                         V162327 == 4 ~ 2,
                         V162327 == 5 ~ 1)) %>%
  mutate(widb = case_when(wid <= 3 ~ 0,
                          wid >= 4 ~ 1,)) %>%
  mutate(resentWorkway = ifelse(V162211 == 1, 2, 
                               ifelse(V162211 == 2, 1,
                                      ifelse(V162211 == 3, 0,
                                             ifelse(V162211 == 4, -1,
                                                    ifelse(V162211 == 5, -2, NA))))))

write_dta(dat16,'data/anes-2016/anes-2016-updated.dta')


#### Additional Cleaning ####

### Racial Resentment Scale ###
dat16 <- dat16 %>%
  mutate(raceResent = ((resentWorkway + slavery + resentdeserve + tryhard)/4))

### getahead ###
dat16 <- dat16 %>%
       mutate(getahead = ifelse(V162134 == 1, 5, 
                            ifelse(V162134 == 2, 4, 
                            ifelse(V162134 == 3, 3,
                            ifelse(V162134 == 4, 2, 
                            ifelse(V162134 == 5, 1, NA))))))
### incomeInequality ###
dat16 <- dat16 %>%
       mutate(incomeInequality = ifelse(V161138x == 1, 5,
                                   ifelse(V161138x == 2, 4,
                                   ifelse(V161138x == 3, 3,
                                   ifelse(V161138x == 4, 2,
                                   ifelse(V161138x == 5, 1, NA))))))

### employement ###
dat16 <- dat16 %>%
       mutate(employment = ifelse(V161277 == 1, 1,
                            ifelse(V161277 == 7, 1,
                            ifelse(V161277 == 8, 1,
                            ifelse(V161277 == 2, 0,
                            ifelse(V161277 == 4, 0,
                            ifelse(V161277 == 5, 0,
                            ifelse(V161277 == 6, 0, NA))))))))




### Merge Census Data ###
#dat16 <- dat16 %>%
#  rename(STATE = V161010d)
#census <- read_dta('data/census_pop_estimates_by_state.dta')
#census <- transform(census, STATE = as.double(STATE))
#dat16_1 <- left_join(dat16, census, by = 'STATE')




#### Calc population proportions ####

#dat16_1 <- dat16_1 %>%
#  mutate(totalpop2010 = (WHITE_CENSUS10POP + NONWHITE_CENUS10POP)) %>%
#  mutate(perwhite10 = (WHITE_CENSUS10POP/totalpop2010)) %>%
#  mutate(totalpop2012 = (WHITE_CENSUS12EST + NONWHITE_CENSUS12EST)) %>%
#  mutate(perwhite12 = (WHITE_CENSUS12EST/totalpop2012)) %>%
#  mutate(totalpop2016 = (WHITE_CENSUS16EST + NONWHITE_CENSUS16EST)) %>%
#  mutate(perwhite16 = (WHITE_CENSUS16EST/totalpop2016)) %>%
#  mutate(estpopdelta = (perwhite16 - perwhite10))

#### Turn WID into a factor ####
likert_flip <- c('Not at all', 'A little', 'Moderately', 'Very', 'Extremely')
#dat16_1 <- dat16_1 %>%
#  mutate(wid = factor(wid, labels = likert_flip), ordered = TRUE)

### presidential approval ###
dat16 <- dat16 %>%
  mutate(presapprove = ifelse(V161082x == 1, 5, 
                              ifelse(V161082x == 2,4,
                                     ifelse(V161082x == 3,3,
                                            ifelse(V161082x == 4, 2,
                                                   ifelse(V161082x == 5,1,NA))))))

#### Trump feeling thermometer control ###
dat16 <- dat16 %>%
  mutate(trumpft = ifelse(as.numeric(V161087) <= -1, NA, V161087))
#### Class ####
dat16 <- dat16 %>%
       mutate(class = ifelse(V161306 == 0, 1,
                     ifelse(V161306 == 3, 2,
                     ifelse(V161306 == 1, 3,
                     ifelse(V161306 == 2, 4,
                     ifelse(V161306 == 4, 5,NA))))))
write_dta(dat16, 'data/anes-2016/anes-2016-updated.dta')
