# Title: 2016 ANES cleaning

# Notes:
    #* Description: R script for cleaning the 2016 ANES 
    #* Updated: 2022-07-19
    #* Updated by: dcr 

# Setup
    #* modularly load functions
box::use(
    haven = haven[read_dta],
    dplyr = dplyr[filter, mutate, case_when, rename]
)
    #* create list object
anes_2016 = list()
    #* load dataset
anes_2016[['original']] = read_dta('data/anes-2016/anes-2016.dta')

# Cleaning
anes_2016[['clean']] = anes_2016[['original']] |>
    #* Filter only white respondents
    filter(V161310x == 1) |>
    mutate(
    #* rboff - Retrospective better off
        #** 1 = Much Better - 5 Much Worse
        #** RECODE TO: -2 = Much worse - 2 Much better
    rboff = ifelse(V161110 == 1, 2,
                        ifelse(V161110 == 2, 1, 
                               ifelse(V161110 == 3, 0,
                                      ifelse(V161110 == 4, -1,
                                             ifelse(V161110 == 5, -2, NA))))),
    #* pboff - Prospective better off
        #** 1 = Much better - 5 = Much worse
        #** RECODE TO: -2 = Much worse - 2 Much better
    pboff = ifelse(V161111 == 1, 2,
                        ifelse(V161111 == 2,1,
                               ifelse(V161111 == 3,0,
                                      ifelse(V161111 == 4, -1, 
                                             ifelse(V161111 == 5, -2, NA))))),
    #* epast - Economy better/worse than 1 year ago
        #** 1 = Much better - 5 = Much worse
        #** RECODE TO: -2 = Much worse - 2 = Much better
    epast = ifelse(V161140x == 1, 2,
                        ifelse(V161140x == 2,1,
                               ifelse(V161140x == 3, 0, 
                                      ifelse(V161140x == 4, -1, 
                                             ifelse(V161140x == 5, -2, NA))))),
    #* efuture - Economy going to be better/worse in 1 year
        #** 1 = Much better - 5 = Much worse
        #** RECODE TO: -2 = Much worse - 2 = Much better
    efuture = ifelse(V161141x == 1,2,
                          ifelse(V161141x == 2,1,
                                 ifelse(V161141x == 3, 0,
                                        ifelse(V161141x == 4,-1,
                                               ifelse(V161141x == 5,-2, NA))))),
    #* unpast - Unemployment better/worse than 1 year ago
        #** 1 = Much better - 5 = Much worse
        #** RECODE TO: -2 = Much worse - 2 = Much better
    unpast = ifelse(V161142x == 1, 2,
                         ifelse(V161142x == 2,1,
                                ifelse(V161142x == 3, 0,
                                       ifelse(V161142x == 4, -1,
                                              ifelse(V161142x == 5, -2, NA))))),
    #* ecfamily - Worried about family finances
        #** 1 = Extremely - 5 = Not at all
        #** RECODE TO: -2 Not at all - 2 = Extremely
    ecfamily = ifelse(V162165 == 1, 2, 
                           ifelse(V162165 == 2,1,
                                  ifelse(V162165 == 3, 0,
                                         ifelse(V162165 == 4, -1,
                                                ifelse(V162165 == 5, -2, NA))))),
    #* ecjob - Know someone lost job
        #** 1 = Someone lost job, 2 = No, did not lose job
        #** RECODE TO: 0 = No, 1 = Yes
    ecjob = ifelse(V162167 == 2, 0, 
                        ifelse(V162167 == 1,1, NA)),
    #* tradbreak - New lifestyles breaking society
        #** 1 = Strongly agree - 5 = Strongly disagree
        #** RECODE TO: -2 = Strongly disagree - 2 = Strongly agree
    tradbreak = ifelse(V162208 == 1, 2,
                            ifelse(V162208 == 2,1,
                                   ifelse(V162208 == 3, 0,
                                          ifelse(V162208 == 4, -1,
                                                 ifelse(V162208 == 5, -2, NA))))),
    #* blackworkmore - Blacks should work way up
        #** 1 = Strongly agree - 5 = Strongly disagree
        #** RECODE TO: -2 = Strongly disagree - 2 = Strongly agree
    blackworkmore = ifelse(V162211 == 1,2,
                                ifelse(V162211 == 2,1,
                                       ifelse(V162211 == 3, 0,
                                              ifelse(V162211 == 4, -1,
                                                     ifelse(V162211 == 5, -2, NA))))),
    #* slavery - Slavery makes it difficult for blacks
        #** 1 = Strongly agree - 5 = Strongly disagree
        #** RECODE TO: -2 = Strongly disagree - 2 = Strongly agree
    slavery = ifelse(V162212 == 1,2,
                          ifelse(V162212 == 2,1,
                                 ifelse(V162212 == 3,0,
                                        ifelse(V162212 == 4, -1, 
                                               ifelse(V162212 == 5, -2, NA))))),
    #* resentdeserve - Blacks have gotten less than deserve
        #** 1 = Strongly agree - 5 = Strongly disagree
        #** RECODE TO: -2 = Strongly disagree - 2 = Strongly agree
    resentdeserve = ifelse(V162213 == 1,2,
                                ifelse(V162213 == 2,1,
                                       ifelse(V162213 == 3, 0,
                                              ifelse(V162213 == 4,-1,
                                                     ifelse(V162213 == 5, -2, NA))))),
    #* tryhard - Blacks should try harder
        #** 1 = Strongly agree - 5 = Strongly disagree
        #** RECODE TO: -2 = Strongly disagree - 2 = Strongly agree
    tryhard = ifelse(V162214 == 1,2,
                          ifelse(V162214 == 2,1,
                                 ifelse(V162214 == 3,0,
                                        ifelse(V162214 == 4,-1,
                                               ifelse(V162214 == 5,-2, NA))))),
    #* pocare - Public officials care
        #** 1 = A great deal - 5 = Not at all
        #** RECODE TO: -2 = Not at all - 2 = A great deal
    pocare = ifelse(V162215 == 1,2,
                         ifelse(V162215 == 2,1,
                                ifelse(V162215 == 3, 0,
                                       ifelse(V162215 == 4,-1,
                                              ifelse(V162215 == 5,-2, NA))))),
    #* ee - External efficacy
        #** 1 = Agree strongly - 5 = Disagree strongly
        #** RECODE TO: -2 = Disagree strongly - 2 = Agree strongly
    ee = ifelse(V162216 == 1,2,
                     ifelse(V162216 == 2,1,
                            ifelse(V162216 == 3,0,
                                   ifelse(V162216 == 4,-1,
                                          ifelse(V162216 == 5,-2, NA))))),
    #* hireblack - Support Blacks getting hired
        #** 1 = Strongly agree - 5 = Strongly disagree
        #** RECODE TO: -2 = Strongly disagree - 2 = Strongly agree
    hireblack = ifelse(V162238x == 1,2,
                            ifelse(V162238x == 2,1,
                                   ifelse(V162238x == 3,0,
                                          ifelse(V162238x == 4,-1,
                                                 ifelse(V162238x == 5, -2,NA))))),
    #* inflwhite - Influence whites have on politics
        #** 1 = Too much, 2 = Just about right, 3 = Too little
        #** RECODE TO: -1 = Too little, 0 = About right, 1 = Too much
    inflwhite = ifelse(V162322 == 3, -1,
                            ifelse(V162322 == 2,0,
                                   ifelse(V162322 == 1,1, NA))),
    #* inflblack - Influence blacks have on politics
        #** 1 = Too much, 2 = Just about right, 3 = Too little
        #** RECODE TO: -1 = Too little, 0 = About right, 1 = Too much
    inflblack = ifelse(V162323 == 3,-1,
                            ifelse(V162323 == 2,0,
                                   ifelse(V162323 == 1,1, NA))),
    #* govbias - Government favor Blacks to whites
        #** 1 = Favors whites, 2 = Favors blacks, 3 = Neither
        #** RECODE TO: -1 = Favors whites, 0 = neither, 1 = Favors blacks
    govbias = ifelse(V162318 == 1,-1,
                          ifelse(V162318 == 3,0,
                                 ifelse(V162318 == 2,1, NA))),
    #* whitediscrim - How much are whites discriminated against
        #** 1 = A great deal - 5 = None at all
        #** RECODE TO: 1 = None at all - 5 = A great deal
    whitediscrim = ifelse(V162360 == 5, 1,
                               ifelse(V162360 == 4, 2,
                                      ifelse(V162360 == 3,3,
                                             ifelse(V162360 == 2,4,
                                                    ifelse(V162360 == 5, 1, NA))))),
    #* wid - How important is being white to identity
        #** 1 = Extremely important - 5 = Not at all important
        #** RECODE TO: 1 = Not at all important - 5 = Extremely important
    wid = ifelse(V162327 <= 0, NA, V162327),
    wid = case_when(V162327 == 1 ~ 5,
                         V162327 == 2 ~ 4,
                         V162327 == 3 ~ 3,
                         V162327 == 4 ~ 2,
                         V162327 == 5 ~ 1),
    resentWorkway = ifelse(V162211 == 1, 2, 
                               ifelse(V162211 == 2, 1,
                                      ifelse(V162211 == 3, 0,
                                             ifelse(V162211 == 4, -1,
                                                    ifelse(V162211 == 5, -2, NA))))),
    raceResent = ((resentWorkway + slavery + resentdeserve + tryhard)/4),
    getahead = ifelse(V162134 == 1, 5, 
                            ifelse(V162134 == 2, 4, 
                            ifelse(V162134 == 3, 3,
                            ifelse(V162134 == 4, 2, 
                            ifelse(V162134 == 5, 1, NA))))),
    incomeInequality = ifelse(V161138x == 1, 5,
                                   ifelse(V161138x == 2, 4,
                                   ifelse(V161138x == 3, 3,
                                   ifelse(V161138x == 4, 2,
                                   ifelse(V161138x == 5, 1, NA))))),
    #* employment - Employment status
        #* 1 = Working now, 2 = Laid off, 4 = Unemployed, 5 = Retired, 6 = disabled, 7 = homemaker, 8 = student
        #* 0 = laid off | unemployed | retired | disabled, 1 = Working now | homemaker | student
    employment = ifelse(V161277 == 1, 1,
                            ifelse(V161277 == 7, 1,
                            ifelse(V161277 == 8, 1,
                            ifelse(V161277 == 2, 0,
                            ifelse(V161277 == 4, 0,
                            ifelse(V161277 == 5, 0,
                            ifelse(V161277 == 6, 0, NA))))))),
    #* class - Would you say that you are in lower, upper, middle, above middle class?
        #** 0 = Lower - 4 = Upper
        #** RECODE TO: 1 = lower class/poor - 5 = Upper class
    class = ifelse(V161306 == 0, 1,
                     ifelse(V161306 == 3, 2,
                     ifelse(V161306 == 1, 3,
                     ifelse(V161306 == 2, 4,
                     ifelse(V161306 == 4, 5,NA))))),
    #* trumpft - Trump feeling thermometer
        #** 0 - 100
        #** RECODE TO: NA
    trumpft = ifelse(as.numeric(V161087) <= -1, NA, V161087),
    #* presapprove - Do you approve of how the president has handled their job?
        #** 1 = A great deal - 5 = Not at all
        #** RECODE TO: 1 = Not at all - 5 = A great deal
    presapprove = ifelse(V161082x == 1, 5, 
                              ifelse(V161082x == 2,4,
                                     ifelse(V161082x == 3,3,
                                            ifelse(V161082x == 4, 2,
                                                   ifelse(V161082x == 5,1,NA))))),
    #* pid - Partisan identification
        #** 1 = Strong Democrat - 7 = Strong Republican
    pid = ifelse(V161158x <= 0, NA, V161158x),
    #* female - Is respondent female or male
        #** 1 = Male, 2 = Female
        #** RECODE TO: 0 = Male, 1 = Female
    female = ifelse(V161342 == 2, 1,
                         ifelse(V161342 == 1, 0,
                                ifelse(V161342 == 3, 0, NA))),
    #* ideo - Ideology
        #** 1 = Extremely liberal - 7 = Extremely conservative
        #** RECODE TO: NA
    ideo = ifelse(V161126 <= 0, NA, V161126),
    #* age - Age
        #** Continuous variable of age
    age = ifelse(V161267 <= 0, NA, V161267),
    #* edu - Education
        #** 1 = < high school, 2 = HS, 3 = Some post-HS, 4 = Bachelors, 5 = Graduate
    edu = ifelse(V161270 <= 0, NA, V161270),
    ) |>
    rename(state = V161010d)

    #* Merge census data
#census = read_dta('data/census_pop_estimates_by_state.dta') |>
#    transform(state = as.double(STATE))
#
#anes_2016_clean = left_join(anes_2016_clean, census, by = 'state') |>
#    mutate(
#        total_pop_2010 = (WHITE_CENSUS10POP + NONWHITE_CENSUS10POP),
#        per_white_10 = (WHITE_CENSUS10POP/total_pop_2010),
#        total_pop_2012 = (WHITE_CENSUS12EST + NONWHITE_CENSUS12EST),
#        per_white_12 = (WHITE_CENSUS12EST/total_pop_2012),
#        total_pop_2016 = (WHITE_CENSUS16EST + NONWHITE_CENSUS16EST),
#        per_white_16 = (WHITE_CENSUS16EST/total_pop_2016),
#        est_pop_delta = (per_white_16 - per_white_10)
#    )

# Save clean data
write.csv(anes_2016[['clean']], 'data/anes-2016/anes-2016-updated.csv')