# Title: 2020 ANES Cleaning for White Identity Project

# Notes:
    #* Description: R Script to do the cleaning for the 2020 ANES 
    #* Updated: 2022-08-12
    #* Updated by: dcr

# Setup
    #* Modularly load functions
box::use(
    haven = haven[read_dta],
    dplyr = dplyr[filter, mutate,]
)
    #* Create list object
anes_2020 = list()
    #* Load dataset
anes_2020[['original']] = read_dta('data/anes-2020/anes_2020_original.dta')

# Clean the data
anes_2020[['cleaned']] = anes_2020[['original']] |>
    #* Filter only white respondents
    filter(V201549x == 1) |>
    mutate(
        #* rboff - Retrospective better off
            #** 1 = Much better - 5 = Much worse
            #** RECODE TO: -2 = Much worse - 2 = Much better
        rboff = ifelse(V201502 == 1, 2,
                    ifelse(V201502 == 2, 1,
                        ifelse(V201502 == 3, 0,
                            ifelse(V201502 == 4, -1,
                                ifelse(V201502 == 5, -2, NA))))),
        #* pboff - Prospective better off
            #** 1 = Much better - 5 = Much worse
            #** RECODE TO: -2 = Much worse - 2 = Much better
        pboff = ifelse(V201503 == 1, 2,
                    ifelse(V201503 == 2, 1,
                        ifelse(V201503 == 3, 0,
                            ifelse(V201503 == 4, -1,
                                ifelse(V201503 == 5, -2, NA))))),
        #* unpast - Unemployment better/worse than 1 year ago
            #** 1 = Much better - 5 = Much worse
            #** RECODE TO: -2 = Much worse - 2 = Much better
        unpast = ifelse(V201333x == 1, 2,
                    ifelse(V201333x == 2, 1,
                        ifelse(V201333x == 3, 0,
                            ifelse(V201333x == 4, -1,
                                ifelse(V201333x == 5, -2, NA))))),
        #* ecfamily - Worried about family finances
            #** 1 = Extremely worried - 5 = Not at all worried
            #** RECODE TO: -2 = Not at all - 2 = Extremely worried
        ecfamily = ifelse(V201594 == 1, 2,
                    ifelse(V201594 == 2, 1, 
                        ifelse(V201594 == 3, 0,
                            ifelse(V201594 == 4, -1,
                                ifelse(V201594 == 5, -2, NA))))),
        #* inflwhite - Influence whites have on politics
            #** 1 = Too much, 2 = Just about right, 3 = Too little
            #** RECODE TO: -1 = Too little, 0 = About right, 1 = Too much
        inflwhite = ifelse(V202494 == 3, -1,
                        ifelse(V202494 == 2, 0,
                            ifelse(V202494 == 1, 1, NA))),
        #* govbias - Government favor Blacks to whites
            #** 1 = Treat whites better, 2 = treat both the same, 3 = treat Blacks better
            #** RECODE TO: -1 = treat whites better, 0 = treat both the same, 1 = treat blacks better
        govbias = ifelse(V202488 == 1, -1, 
                    ifelse(V202488 == 2, 0,
                        ifelse(V202488 == 3, 1, NA))),
        #* whitediscrim - How much are whites discriminated against
            #** 1 = a great deal - 5 = none at all
            #** RECODE TO: 1 = None at all - 5 = A great deal
        whitediscrim = ifelse(V202530 == 1, 5,
                        ifelse(V202530 == 2, 4,
                            ifelse(V202530 == 3, 3,
                                ifelse(V202530 == 4, 2,
                                    ifelse(V202530 == 5, 1, NA))))),
        #* racial resentment
        resentWorkway = ifelse(V202300 == 1, 2,
                            ifelse(V202300 == 2, 1,
                                ifelse(V202300 == 3, 0,
                                    ifelse(V202300 == 4, -1,
                                        ifelse(V202300 == 5, -2, NA))))),
        slavery = ifelse(V202301 == 1, 2,
                    ifelse(V202301 == 2, 1,
                        ifelse(V202301 == 3, 0,
                            ifelse(V202301 == 4, -1,
                                ifelse(V202301 == 5, -2, NA))))),
        tryhard = ifelse(V202303 == 1, 2,
                    ifelse(V202303 == 2, 1,
                        ifelse(V202303 == 3, 0,
                            ifelse(V202303 == 4, -1,
                                ifelse(V202303 == 5, -2, NA))))),
        resentdeserve = ifelse(V202302 == 1, 2,
                            ifelse(V202302 == 2, 1,
                                ifelse(V202302 == 3, 0,
                                    ifelse(V202302 == 4, -1,
                                        ifelse(V202302 == 5, -2, NA))))),
        raceResent = ((resentWorkway + slavery + resentdeserve + tryhard)/4),
        #* wid - How important is being white to identity
            #** 1 = Extremely important - 5 = Not at all important
            #** RECODE TO: 1 = Not at all important - 5 = Extremely important
        wid = ifelse(V202499x == 1, 5,
                ifelse(V202499x == 2, 4,
                    ifelse(V202499x == 3, 3,
                        ifelse(V202499x == 4, 2,
                            ifelse(V202499x == 5, 1, NA))))),
        #* pid - Partisan identification
            #** 1 = Strong Republican - 7 = Strong democrat
        pid = ifelse(V201231x <= 0, NA, V201231x),
        #* female - Respondent sex
            #** 1 = Male, 2 = Female
            #** RECODE TO: 0 = Male, 1 = Female
        female = ifelse(V201600 == 1, 0, 
                    ifelse(V201600 == 2, 1, NA)),
        #* age - Respondent age
        age = ifelse(V201507x <= 0, NA, V201507x),
        #* edu - Education
            #** 1 = < high school, 2 = HS, 3 = Some post-HS, 4 = Bachelors, 5 = Graduate
        edu = ifelse(V201511x <= 0, NA, V201511x)
    )

# Save the clean data
write.csv(anes_2020[['cleaned']], 'data/anes-2020/anes-2020-updated.csv')