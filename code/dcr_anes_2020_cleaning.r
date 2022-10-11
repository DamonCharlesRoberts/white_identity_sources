# Title: 2020 ANES Cleaning for White Identity Project

# Notes:
    #* Description: R Script to do the cleaning for the 2020 ANES 
    #* Updated: 2022-10-01
    #* Updated by: dcr

# Setup
    #* Create list object
anes_2020 = list()
    #* Load dataset
anes_2020[['original']] = read_dta('../../data/anes-2020/anes_2020_original.dta')

# Clean the data
anes_2020[['cleaned']] = anes_2020[['original']] |>
    #* Filter only white respondents
    filter(V201549x == 1) |>
    mutate(
    #* wid - White Identity
        #** Coded as: V202499x - 1 = Extremely Important - 5 Not at all important, < 1 Missing, not asked, etc
        #** Recoded to: wid - 1 = Not at all important - 5 = Extremely important, NA = Missing, not asked, etc
        wid = ifelse(V202499x == 1, 5,
                ifelse(V202499x == 2, 4,
                    ifelse(V202499x == 3, 3,
                        ifelse(V202499x == 4, 2,
                            ifelse(V202499x == 5, 1, NA))))),
    #* rboff - Retrospective better off: ----
        #** Coded as: V201502 - 1 much better, 5 much worse, < 1 Missing, not asked, etc
        #** Recoded to: rboff - -2 much worse, 2 much better, NA = missing, not asked, etc.
        rboff = ifelse(V201502 == 1, 2,
                    ifelse(V201502 == 2, 1,
                        ifelse(V201502 == 3, 0,
                            ifelse(V201502 == 4, -1,
                                ifelse(V201502 == 5, -2, NA))))),
    #* epast - Economy better/worse than 1 year ago: ----
        #** Coded as: V201327x - 1 much better - 5 much worse, < 1 Missing, not asked, etc
        #** Recoded to: epast - -2 much worse - 2 much better, NA = missing, not asked, etc
        epast = ifelse(V201327x == 1, 2,
                    ifelse(V201327x == 2, 1,
                        ifelse(V201327x == 3, 0,
                            ifelse(V201327x == 4, -1,
                                ifelse(V201327x == 5, -2, NA))))),
    #* unpast - Unemployment better/worse than 1 year ago
        #** Coded as: V201333x - 1 much better - 5 much worse, < 1 Missing, not asked, etc
        #** Recoded to: unpast - -2 much worse - 2 much better, NA = missing, not asked, etc
        unpast = ifelse(V201333x == 1, 2,
                    ifelse(V201333x == 2, 1,
                        ifelse(V201333x == 3, 0,
                            ifelse(V201333x == 4, -1,
                                ifelse(V201333x == 5, -2, NA))))),
    #* edu - Education
        #** Coded as: V201511x - 1 < highschool, 2 hs, 3 some post-hs, 4 Bachelors, 5 graduate, < 1 Missing not asked, etc.
        #** Recoded to: edu - 1 < highschool, 2 hs, 3 some post-hs, 4 Bachelors, 5 graduate, NA = missing, not asked, etc
        edu = ifelse(V201511x <= 0, NA, V201511x),
    #* income - Income
        #** Coded as: V202468x - < 1 Missing, not asked, etc
        #** Recoded to: NA = < 1 Missing, not asked, etc
        income = ifelse(V202468x >= 1, V202468x, NA),
    #* losejob - Worried about losing job
        #** Coded as: V201540 - 1 not at all - 5 extremely worried, < 1 missing, not asked, etc
        #** Recoded to: losejob - -2 = not at all - 2  = extremely worried, NA = missing, not asked, etc
        losejob = ifelse(V201540 == 1, -2,
                    ifelse(V201540 == 2, -1,
                        ifelse(V201540 == 3, 0,
                            ifelse(V201540 == 4, 1,
                                ifelse(V201540 == 5, 2, NA))))),
    #* immtakejobs - Immigrants take jobs
        #** Coded as: V202233 - 1 extremely - 4 not at all, < 1 Missing, not asked, etc
        #** Recoded to: immtakejobs - 1 not at all - 4 extremely, NA = missing, not asked, etc
        immtakejobs = ifelse(V202233 == 1, 4,
                        ifelse(V202233 == 2, 3,
                            ifelse(V202233 == 3, 2,
                                ifelse(V202233 == 4, 1, NA)))),
    #* ecfamily - Worried about family finances
        #** Coded as: V201594 - 1 extremely - 5 not at all, < 1 Missing, not asked, etc
        #** Recoded to: ecfamily - -2 not at all - 2 extremely, NA = missing, not asked, etc
        ecfamily = ifelse(V201594 == 1, 5,
                    ifelse(V201594 == 2, 4, 
                        ifelse(V201594 == 3, 3,
                            ifelse(V201594 == 4, 2,
                                ifelse(V201594 == 5, 1, NA))))),
    #** ecjob - Know someone who lost job 
        #** Coded as: V201596 - 1 = Someone lost job, 2 = No one lost job , <1 Missing, not asked, etc
        #** Recoded to: 0 = No one lost job, 1 = Someone lost job, NA = Missing, not asked, etc
        ecjob = ifelse(V201596 == 1, 1, 
                    ifelse(V201596 == 2, 0, NA)),
    #** govbias - Government biased against Whites
        #** Coded as: V202488 - 1 favors whites, 2 favors Blacks, 3 neither, < 1 Missing, not asked, etc
        #** Recoded to: govbias - -1 favors whites, 0 neither, 1 favors Blacks, NA = missing, not asked, etc
        govbias = ifelse(V202488 == 1, -1, 
                    ifelse(V202488 == 2, 0,
                        ifelse(V202488 == 3, 1, NA))),
    #** inflwhite - Influence whites have on politics
        #** Coded as: V202494 - 1 too much, 2 just about right, 3 too little, < 1 Missing, not asked, etc
        #** Recoded to: inflwhite - -1 too little, 0 just about right, 1 too much, NA = missing, not asked, etc
        inflwhite = ifelse(V202494 == 3, -1,
                        ifelse(V202494 == 2, 0,
                            ifelse(V202494 == 1, 1, NA))),
    #** whitediscrim - Whites are discrimminated against
        #** Coded as: V202530 - 1 strongly agree - 5 strongly disagree, < 1 Missing, not asked, etc
        #** Recoded to: whitedescrim - 5 strongly disagree - 2 strongly agree, NA = Missing, not asked, etc
        whitediscrim = ifelse(V202530 == 1, 5,
                        ifelse(V202530 == 2, 4,
                            ifelse(V202530 == 3, 3,
                                ifelse(V202530 == 4, 2,
                                    ifelse(V202530 == 5, 1, NA))))),
    #** resentWorkway - Blacks should work way up
        #** Coded as: V202300 - 1 strongly agree - 5 strongly disagree, <1 Missing, not asked, etc
        #** Recoded to: resentWorkway - -2 strongly disagree - 2 strongly agree, NA = Missing, not asked, etc
        resentWorkway = ifelse(V202300 == 1, 2,
                            ifelse(V202300 == 2, 1,
                                ifelse(V202300 == 3, 0,
                                    ifelse(V202300 == 4, -1,
                                        ifelse(V202300 == 5, -2, NA))))),
    #** resentslavery - Slavery makes it difficult for Blacks
        #** Coded as: V202301 - 1 strongly agree - 5 strongly disagree, < 1 Missing, not asked, etc
        #** Recoded to: slavery - -2 strongly disagree - 2 strongly agree, NA = missing, not asked, etc
        resentslavery = ifelse(V202301 == 1, 2,
                    ifelse(V202301 == 2, 1,
                        ifelse(V202301 == 3, 0,
                            ifelse(V202301 == 4, -1,
                                ifelse(V202301 == 5, -2, NA))))),
    #** resenttryhard - Blacks should try harder to get ahead
        #** Coded as: V202303 - 1 strongly agree - 5 strongly disagree, < 1 Missing, not asked, etc
        #** Recoded to: tryhard - -2 strongly disagree - 2 strongly agree, NA = missing, not asked, etc
        resenttryhard = ifelse(V202303 == 1, 2,
                    ifelse(V202303 == 2, 1,
                        ifelse(V202303 == 3, 0,
                            ifelse(V202303 == 4, -1,
                                ifelse(V202303 == 5, -2, NA))))),
    #** resentdeserve - Blacks have gotten less than they deserve
        #** Coded as: V202302 - 1 strongly agree - 5 strongly disagree, < 1 Missing, not asked, etc
        #** Recoded to: resentdeserve - -2 strongly disagree - 2 strongly agree, NA = Missing not asked, etc
        resentdeserve = ifelse(V202302 == 1, 2,
                            ifelse(V202302 == 2, 1,
                                ifelse(V202302 == 3, 0,
                                    ifelse(V202302 == 4, -1,
                                        ifelse(V202302 == 5, -2, NA))))),
    #** raceResent - Racial resentment
        #** Coded as: average of blackworkmore, slavery, resentdeserve, tryhard
        raceResent = ((resentWorkway + resentslavery + resentdeserve + resenttryhard)/4),
    #* pid - Party identification
        #** Coded as: V201231x - 1 strong democrat - 7 strong republican, < 1 Missing, not asked, etc
        #** Recoded to: pid - 1 strong democrat - 7 strong republican, NA = missing, not asked, etc
        pid = ifelse(V201231x <= 0, NA, V201231x),
    #* female
        #** Coded as: V201600 - 1 male, 2 female, missing, not asked, etc
        #** Recoded to: female - 0 male, 1 female, NA = Missing, not asked, etc
        female = ifelse(V201600 == 1, 0, 
                    ifelse(V201600 == 2, 1, NA)),
    )

# Save the clean data
write.csv(anes_2020[['cleaned']], '../../data/anes-2020/anes-2020-updated.csv')