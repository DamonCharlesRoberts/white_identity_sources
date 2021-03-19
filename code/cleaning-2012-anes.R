#### 2012 ANES Cleaning ####

### Notes: ###
## `RECODE TO:` indicates that the variable had been recoded to that new scheme. ##
## Data are filtered to only include white respondents ##

#### Setup ####

here::here()
source('code/personal-threats-setup-file.R')

#### Codebook ####

### ANES 2012 - Subset to White R's Only###
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
##
##Would you say that you are in lower, upper, middle, above middle class? class ##
# RECODE TO: 1 - Lower class/poor - 5- Upper class
## Income gap size compared to 20 years ago - incomeInequality ##
# 1 Much Larger - 5 Much Smaller #
# RECODE TO: 1 Much Smaller - 5 Much Larger #
## Opportunity to get ahead - V162134 ##
# 1 A great deal - 5 None #
# RECODE TO: 1 None - 5 A great deal #
## employment status - employment ##
# 1 Working now, 2 laid off, 4 unemployed, 5 retired, 6 disabled, 7 homemaker, 8 student #
# 0 laid off | unemployed | retired | disabled, 1 Working now | homemaker | student #
#### Recoding Code ####
dat12 <- dat12o %>%
  filter(dem_raceeth_x == 1) %>%
  mutate(female = case_when(gender_respondent_x == 1 ~ 0,
                            gender_respondent_x == 2 ~ 1)) %>%
  mutate(rboff = ifelse(finance_finpast_x == 1, 2, 
                        ifelse(finance_finpast_x == 2, 1, 
                               ifelse(finance_finpast_x == 3, 0, 
                                      ifelse(finance_finpast_x == 4, -1,
                                             ifelse(finance_finpast_x == 5, -2, NA)))))) %>%
  mutate(pboff = ifelse(finance_finnext_x == 1, 2,
                        ifelse(finance_finnext_x == 2, 1,
                               ifelse(finance_finnext_x == 3, 0,
                                      ifelse(finance_finnext_x == 4, -1,
                                             ifelse(finance_finnext_x == 5, -2, NA)))))) %>%
  mutate(ideo = ifelse(libcpre_self <= 0, NA, libcpre_self)) %>%
  mutate(ee = ifelse(effic_saystd == 1, 5, 
                     ifelse(effic_saystd == 2, 4,
                            ifelse(effic_saystd == 3, 3, 
                                   ifelse(effic_saystd == 4, 2, 
                                          ifelse(effic_saystd == 5, 1 , NA)))))) %>%
  mutate(pocare = ifelse(effic_carerev == 1, 5, 
                         ifelse(effic_carerev == 2, 4,
                                ifelse(effic_carerev == 3, 3,
                                       ifelse(effic_carerev == 4, 2,
                                              ifelse(effic_carerev == 5, 1, NA)))))) %>%
  mutate(ie = ifelse(effic_sayrev == 1, 5, 
                     ifelse(effic_sayrev == 2, 4,
                            ifelse(effic_sayrev == 3, 3,
                                   ifelse(effic_sayrev == 4, 2, 
                                          ifelse(effic_sayrev == 5, 1, NA)))))) %>%
  mutate(epast = ifelse(econ_ecpast_x == 1, 2,
                        ifelse(econ_ecpast_x == 2, 1,
                               ifelse(econ_ecpast_x == 3, 0,
                                      ifelse(econ_ecpast_x == 4, -1, 
                                             ifelse(econ_ecpast_x == 5, -2, NA)))))) %>%
  mutate(efuture = ifelse(econ_ecnext_x == 1, 2, 
                          ifelse(econ_ecnext_x == 2, 1,
                                 ifelse(econ_ecnext_x == 3, 0,
                                        ifelse(econ_ecnext_x == 4, -1,
                                               ifelse(econ_ecnext_x == 5, -2, NA)))))) %>%
  mutate(unpast = ifelse(econ_unpast_x == 1, 2,
                         ifelse(econ_unpast_x == 2, 1,
                                ifelse(econ_unpast_x == 3, 0,
                                       ifelse(econ_unpast_x == 4, -1,
                                              ifelse(econ_unpast_x == 5, -2, NA)))))) %>%
  mutate(unnext = ifelse(econ_unnext == 1, 2, 
                         ifelse(econ_unnext == 2, 1, 
                                ifelse(econ_unnext == 3, 0, 
                                       ifelse(econ_unnext == 4, -1,
                                              ifelse(econ_unnext == 5, -2, NA)))))) %>%
  mutate(pid = ifelse(pid_x <= 0, NA, pid_x)) %>%
  mutate(age = dem_age_r_x) %>%
  mutate(edu = ifelse(dem_edugroup_x <= 0,NA, dem_edugroup_x)) %>%
  mutate(findjob = ifelse(dem_findjob <= 0,NA, dem_findjob)) %>%
  mutate(losejob = ifelse(dem_losejob <= 0,NA, dem_losejob)) %>%
  mutate(offwork = ifelse(dem_offwork == 1, 1, 
                          ifelse(dem_offwork == 2, 0, NA))) %>%
  mutate(fairjblacks = ifelse(fairjob_opin_x == 1, 2,
                              ifelse(fairjob_opin_x == 2, 1, 
                                     ifelse(fairjob_opin_x == 3, 0,
                                            ifelse(fairjob_opin_x == 4, -1, 
                                                   ifelse(fairjob_opin_x == 5, -2 , NA)))))) %>%
  mutate(immtakejobs = ifelse(immigpo_jobs == 1, 4,
                              ifelse(immigpo_jobs == 2, 3,
                                     ifelse(immigpo_jobs == 1, 4, NA)))) %>%
  mutate(ecfamily = ifelse(ecperil_worry == 1, 2, 
                           ifelse(ecperil_worry == 2, 1,
                                  ifelse(ecperil_worry == 3, 0, 
                                         ifelse(ecperil_worry == 4, -1,
                                                ifelse(ecperil_worry == 5, -2, NA)))))) %>%
  mutate(ecjob = ifelse(ecperil_lostjobs == 1, 1, 
                        ifelse(ecperil_lostjobs == 2, 0, NA))) %>%
  mutate(linked = ifelse(link_white == 1, 1,
                         ifelse(link_white == 2, 0, NA))) %>%
  mutate(tradbreak = ifelse(trad_lifestyle == 1, 2, 
                            ifelse(trad_lifestyle == 2, 1,
                                   ifelse(trad_lifestyle == 3, 0,
                                          ifelse(trad_lifestyle == 4, -1,
                                                 ifelse(trad_lifestyle == 5, -2, NA)))))) %>%
  mutate(blackworkmore = ifelse(resent_workway == 1, 2,
                                ifelse(resent_workway == 2, 1,
                                       ifelse(resent_workway == 3, 0,
                                              ifelse(resent_workway == 4, -1, 
                                                     ifelse(resent_workway == 5, -2, NA)))))) %>%
  mutate(slavery = ifelse(resent_slavery == 1,2,
                          ifelse(resent_slavery == 2, 1, 
                                 ifelse(resent_slavery == 3, 0,
                                        ifelse(resent_slavery == 4, -1,
                                               ifelse(resent_slavery == 5, -2, NA)))))) %>%
  mutate(resentdeserve = ifelse(resent_deserve == 1, 2, 
                                ifelse(resent_deserve == 2, 1, 
                                       ifelse(resent_deserve == 3, 0,
                                              ifelse(resent_deserve == 4, -1,
                                                     ifelse(resent_deserve == 5, -2, NA)))))) %>%
  mutate(tryhard = ifelse(resent_try == 1, 2, 
                          ifelse(resent_try == 2, 1, 
                                 ifelse(resent_try == 3, 0,
                                        ifelse(resent_try == 4, -1,
                                               ifelse(resent_try == 5, -2, NA)))))) %>%
  mutate(blackhire = ifelse(aapost_hire_x == 1, 2, 
                            ifelse(aapost_hire_x == 2, 1, 
                                   ifelse(aapost_hire_x == 3, 0,
                                          ifelse(aapost_hire_x == 4, -1,
                                                 ifelse(aapost_hire_x == 5, -2, NA)))))) %>%
  mutate(toofar = ifelse(egal_toofar == 1, 2, 
                         ifelse(egal_toofar == 2, 1, 
                                ifelse(egal_toofar == 3, 0,
                                       ifelse(egal_toofar == 4, -1,
                                              ifelse(egal_toofar == 5, -2, NA)))))) %>%
  mutate(govbias = ifelse(nonmain_bias == 1, -1,
                          ifelse(nonmain_bias == 3, 0,
                                 ifelse(nonmain_bias == 2,1,NA)))) %>%
  mutate(inflwhite = ifelse(racecasi_infwhite == 3, -1,
                            ifelse(racecasi_infwhite == 2, 0,
                                   ifelse(racecasi_infwhite == 1,1, NA)))) %>%
  mutate(inflblack = ifelse(racecasi_infblacks == 3, -1,
                            ifelse(racecasi_infblacks == 2, 0,
                                   ifelse(racecasi_infblacks == 1,1,NA)))) %>%
  mutate(whitediscrim = ifelse(discrim_whites == 1, 5, 
                               ifelse(discrim_whites == 2, 4,
                                      ifelse(discrim_whites == 3, 3, 
                                             ifelse(discrim_whites == 4, 2, 
                                                    ifelse(discrim_whites == 5, 1, NA)))))) %>%
  mutate(wid = ifelse(ident_whiteid <= 0, NA, ident_whiteid)) %>%
  mutate(wid = case_when(ident_whiteid == 1 ~ 5,
                         ident_whiteid == 2 ~ 4,
                         ident_whiteid == 3 ~ 3,
                         ident_whiteid == 4 ~ 2,
                         ident_whiteid == 5 ~ 1)) %>%
  mutate(widb = case_when(
    wid <= 3 ~ 0,
    wid >= 4 ~ 1
  )) %>%
  mutate(resentWorkway = ifelse(resent_workway == 1, 2,
                                ifelse(resent_workway == 2,1,
                                       ifelse(resent_workway == 3, 0,
                                              ifelse(resent_workway == 4, -1, 
                                                     ifelse(resent_workway == 5, -2, NA))))))


#### Additional Cleaning ####

### Racial Resentment Scale ###
dat12 <- dat12 %>%
  mutate(raceResent = ((resentWorkway + slavery + resentdeserve + tryhard)/4))
### Class ###
dat12 <- dat12 %>%
       mutate(class = ifelse(dem_avgclass == 0, 1,
                     ifelse(dem_avgclass == 1, 2,
                     ifelse(dem_avgclass == 2,3,
                     ifelse(dem_avgclass == 3,4, 
                     ifelse(dem_avgclass == 4,5, NA))))))

### Salience of Income inequality and status ###
dat12 <- dat12 %>%
       mutate(incomeInequality = ifelse(ineq_incgap_x == 1, 5,
                                   ifelse(ineq_incgap_x == 2, 4,
                                   ifelse(ineq_incgap_x == 3, 3,
                                   ifelse(ineq_incgap_x == 4, 2,
                                   ifelse(ineq_incgap_x == 5, 1, NA))))))

### Opportunity to get ahead ###
dat12 <- dat12 %>%
       mutate(getahead = ifelse(egal_equal == 1, 5,
                         ifelse(egal_equal == 2, 4,
                         ifelse(egal_equal == 3, 3,
                         ifelse(egal_equal == 4, 2,
                         ifelse(egal_equal == 5, 1, NA))))))
### Merge Census Data ###
#dat12 <- dat12 %>%
#  mutate(STATE = case_when(sample_state == 'AL' ~ 01,
#                           sample_state == 'AK' ~ 02,
#                           sample_state == 'AZ' ~ 04,
#                           sample_state == 'AR' ~ 05,
#                           sample_state == 'CA' ~ 06,
#                           sample_state == 'CO' ~ 08,
#                           sample_state == 'CT' ~ 09,
#                           sample_state == 'DE' ~ 10,
#                           sample_state == 'DC' ~ 11,
#                           sample_state == 'FL' ~ 12,
#                           sample_state == 'GA' ~ 13,
#                           sample_state == 'HI' ~ 15,
#                           sample_state == 'ID' ~ 16,
#                           sample_state == 'IL' ~ 17,
#                           sample_state == 'IN' ~ 18,
#                           sample_state == 'IA' ~ 19,
#                           sample_state == 'KS' ~ 20,
#                           sample_state == 'KY' ~ 21,
#                           sample_state == 'LA' ~ 22,
#                           sample_state == 'ME' ~ 23,
#                           sample_state == 'MD' ~ 24,
#                           sample_state == 'MA' ~ 25,
#                           sample_state == 'MI' ~ 26,
#                           sample_state == 'MN' ~ 27,
#                           sample_state == 'MS' ~ 28,
#                           sample_state == 'MO' ~ 29,
#                           sample_state == 'MT' ~ 30,
#                           sample_state == 'NE' ~ 31,
#                           sample_state == 'NV' ~ 32,
#                           sample_state == 'NH' ~ 33,
#                           sample_state == 'NJ' ~ 34,
#                           sample_state == 'NM' ~ 35,
#                           sample_state == 'NY' ~ 36,
#                           sample_state == 'NC' ~ 37,
#                           sample_state == 'ND' ~ 38,
#                           sample_state == 'OH' ~ 39,
#                           sample_state == 'OK' ~ 40,
#                           sample_state == 'OR' ~ 41,
#                           sample_state == 'PY' ~ 42,
#                           sample_state == 'RI' ~ 44,
#                           sample_state == 'SC' ~ 45,
#                           sample_state == 'SD' ~ 46,
#                           sample_state == 'TN' ~ 47,
#                           sample_state == 'TX' ~ 48,
#                           sample_state == 'UT' ~ 49,
#                           sample_state == 'VT' ~ 50,
#                           sample_state == 'VA' ~ 51,
#                           sample_state == 'WA' ~ 53,
#                           sample_state == 'WV' ~ 54,
#                           sample_state == 'WI' ~ 55,
#                           sample_state == 'WY' ~ 56))
#census <- read_dta('data/census_pop_estimates_by_state.dta')
#census <- transform(census, STATE = as.double(STATE))
#dat12_1 <- left_join(dat12, census, by = 'STATE')




#### Calc population proportions ####

#dat12_1 <- dat12_1 %>%
#  mutate(totalpop2010 = (WHITE_CENSUS10POP + NONWHITE_CENUS10POP)) %>%
 # mutate(perwhite10 = (WHITE_CENSUS10POP/totalpop2010)) %>%
 # mutate(totalpop2012 = (WHITE_CENSUS12EST + NONWHITE_CENSUS12EST)) %>%
 # mutate(perwhite12 = (WHITE_CENSUS12EST/totalpop2012)) %>%
 # mutate(estpopdelta = (perwhite12 - perwhite10))

#### Turn WID into a factor ####
likert_flip <- c('Not at all', 'A little', 'Moderately', 'Very', 'Extremely')
dat12_1 <- dat12_1 %>%
  mutate(wid = factor(wid, labels = likert_flip), ordered = TRUE)
  
### Presidential Approval control ###
#dat12_1 <- dat12_1 %>%
#  mutate(presapprove = ifelse(presapp_job_x == 1, 5, 
#                              ifelse(presapp_job_x == 2, 4, 
#                                     ifelse(presapp_job_x == 3, 3,
#                                            ifelse(presapp_job_x == 4,2,
#                                                   ifelse(presapp_job_x == 5, 1, NA))))))


write_dta(dat12, 'data/anes-2012/anes-2012-updated.dta')
