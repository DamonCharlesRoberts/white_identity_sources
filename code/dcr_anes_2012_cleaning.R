# Title: 2012 ANES Cleaning ----

# Notes: ----
    #* Description: Cleaning script for the 2012 ANES ----
    #* Updated: 2022-10-01 ----
    #* Updated by: dcr -----

# Setup: -----
    #* Modularly load packages -----
box::use(
    haven = haven[read_dta],
    dplyr = dplyr[mutate, filter, case_when]
)
    #* create list object
anes_2012 = list()
    #* Load original ANES file ----
anes_2012[['original']] = read_dta('../data/anes-2012/anes-2012.dta')
# Cleaning ----
anes_2012[['clean']] = anes_2012[['original']] |>
    #* Filter dataset to include only white respondents ----
    filter(dem_raceeth_x == 1) |>
    mutate(
    #* wid - White Identity
        #** Coded as: ident_whiteid - 1 = Extremely Important - 5 Not at all important, < 1 Missing, not asked, etc
        #** Recoded to: wid - 1 = Not at all important - 5 = Extremely important, NA = Missing, not asked, etc
        wid = case_when(ident_whiteid == 1 ~ 5,
                        ident_whiteid == 2 ~ 4,
                        ident_whiteid == 3 ~ 3,
                        ident_whiteid == 4 ~ 2,
                        ident_whiteid == 5 ~ 1),
    #* rboff - Retrospective better off: ----
        #** Coded as: finance_finpast_x - 1 much better, 5 much worse, < 1 Missing, not asked, etc
        #** Recoded to: rboff - -2 much worse, 2 much better, NA = missing, not asked, etc.
        rboff = ifelse(finance_finpast_x == 1, 2,
                        ifelse(finance_finpast_x == 2, 1,
                            ifelse(finance_finpast_x == 3, 0,
                                ifelse(finance_finpast_x == 4, -1,
                                    ifelse(finance_finpast_x == 5, -2, NA))))),
    #* epast - Economy better/worse than 1 year ago: ----
        #** Coded as: econ_ecpast_x - 1 much better - 5 much worse, < 1 Missing, not asked, etc
        #** Recoded to: epast - -2 much worse - 2 much better, NA = missing, not asked, etc
        epast = ifelse(econ_ecpast_x == 1, 2,
                    ifelse(econ_ecpast_x == 2, 1,
                        ifelse(econ_ecpast_x == 3, 0,
                            ifelse(econ_ecpast_x == 4, -1,
                                ifelse(econ_ecpast_x == 5, -2, NA))))),
    #* unpast - Unemployment better/worse than 1 year ago
        #** Coded as: econ_unpast_x - 1 much better - 5 much worse, < 1 Missing, not asked, etc
        #** Recoded to: unpast - -2 much worse - 2 much better, NA = missing, not asked, etc
        unpast = ifelse(econ_unpast_x == 1, 2,
                    ifelse(econ_unpast_x == 2, 1,
                        ifelse(econ_unpast_x == 3, 0,
                            ifelse(econ_unpast_x == 4, -1,
                                ifelse(econ_unpast_x == 5, -2, NA))))),
    #* edu - Education
        #** Coded as: dem_edugroup_x - 1 < highschool, 2 hs, 3 some post-hs, 4 Bachelors, 5 graduate, < 1 Missing not asked, etc.
        #** Recoded to: edu - 1 < highschool, 2 hs, 3 some post-hs, 4 Bachelors, 5 graduate, NA = missing, not asked, etc
        edu = ifelse(dem_edugroup_x <= 0, NA, dem_edugroup_x),
    #* losejob - Worried about losing job
        #** Coded as: dem_losejob - 1 not at all - 5 extremely worried, < 1 missing, not asked, etc
        #** Recoded to: losejob - -2 = not at all - 2  = extremely worried, NA = missing, not asked, etc
        losejob = ifelse(dem_losejob == 1, -2, 
                    ifelse(dem_losejob == 2, -1,
                        ifelse(dem_losejob == 3, 0, 
                            ifelse(dem_losejob == 4, 1,
                                ifelse(dem_losejob == 5, 2, NA))))),
    #* immtakejobs - Immigrants take jobs
        #** Coded as: immigpo_jobs - 1 extremely - 4 not at all, < 1 Missing, not asked, etc
        #** Recoded to: immtakejobs - 1 not at all - 4 extremely, NA = missing, not asked, etc
        immtakejobs = ifelse(immigpo_jobs == 1, 4,
                        ifelse(immigpo_jobs == 2, 3,
                            ifelse(immigpo_jobs == 3, 2,
                                ifelse(immigpo_jobs == 4, 1, NA)))),
    #* ecfamily - Worried about family finances
        #** Coded as: ecperil_worry - 1 extremely - 5 not at all, < 1 Missing, not asked, etc
        #** Recoded to: ecfamily - -2 not at all - 2 extremely, NA = missing, not asked, etc
        ecfamily = ifelse(ecperil_worry == 1, 5,
                    ifelse(ecperil_worry == 2, 4,
                        ifelse(ecperil_worry == 3, 3,
                            ifelse(ecperil_worry == 4, 2,
                                ifelse(ecperil_worry == 5, 1, NA))))),
    #* ecjob - Know someone who lost job 
        #** Coded as: ecperil_lostjobs - 1 = Someone lost job, 2 = No one lost job , <1 Missing, not asked, etc
        #** Recoded to: 0 = No one lost job, 1 = Someone lost job, NA = Missing, not asked, etc
        ecjob = ifelse(ecperil_lostjobs == 1, 1, 
                    ifelse(ecperil_lostjobs == 2, 0, NA)),
    #* tradbreak - New lifestyles breaking society
        #** Coded as: trad_lifestyle - 1 strongly agree - 5 strongly disagree, <1 Missing, not asked, etc
        #** Recoded to: tradbreak - -2 strongly disagree - 2 strongly agree, NA = missingnot asked, etc
        tradbreak = ifelse(trad_lifestyle == 1, 2,
                        ifelse(trad_lifestyle == 2, 1,
                            ifelse(trad_lifestyle == 3, 0,
                                ifelse(trad_lifestyle == 4, -1,
                                    ifelse(trad_lifestyle == 5, -2, NA))))),
    #* govbias - Government biased against Whites
        #** Coded as: nonmain_bias - 1 favors whites, 2 favors Blacks, 3 neither, < 1 Missing, not asked, etc
        #** Recoded to: govbias - -1 favors whites, 0 neither, 1 favors Blacks, NA = missing, not asked, etc
        govbias = ifelse(nonmain_bias == 1, -1,
                    ifelse(nonmain_bias == 3, 0,
                        ifelse(nonmain_bias == 2, 1, NA))),
    #* inflwhite - Influence whites have on politics
        #** Coded as: racecasi_infwhite - 1 too much, 2 just about right, 3 too little, < 1 Missing, not asked, etc
        #** Recoded to: inflwhite - -1 too little, 0 just about right, 1 too much, NA = missing, not asked, etc
        inflwhite = ifelse(racecasi_infwhite == 3, -1,
                        ifelse(racecasi_infwhite == 2, 0,
                            ifelse(racecasi_infwhite == 1, 1, NA))),
    #* whitediscrim - Whites are discrimminated against
        #** Coded as: discrim_whites - 1 strongly agree - 5 strongly disagree, < 1 Missing, not asked, etc
        #** Recoded to: whitedescrim - 5 strongly disagree - 2 strongly agree, NA = Missing, not asked, etc
        whitediscrim = ifelse(discrim_whites == 1, 5,
                        ifelse(discrim_whites == 2, 4,
                            ifelse(discrim_whites == 3, 3,
                                ifelse(discrim_whites == 4, 2,
                                    ifelse(discrim_whites == 5, 1, NA))))),
    #* resentWorkway - Blacks should work way up
        #** Coded as: resent_workway - 1 strongly agree - 5 strongly disagree, <1 Missing, not asked, etc
        #** Recoded to: resentWorkway - -2 strongly disagree - 2 strongly agree, NA = Missing, not asked, etc
        blackworkmore = ifelse(resent_workway == 1, 2,
                            ifelse(resent_workway == 2, 1,
                                ifelse(resent_workway == 3, 0,
                                    ifelse(resent_workway == 4, -1,
                                        ifelse(resent_workway == 5, -2, NA))))),
    #* resentslavery - Slavery makes it difficult for Blacks
        #** Coded as: resent_slavery - 1 strongly agree - 5 strongly disagree, < 1 Missing, not asked, etc
        #** Recoded to: slavery - -2 strongly disagree - 2 strongly agree, NA = missing, not asked, etc
        slavery = ifelse(resent_slavery == 1, 2,
                    ifelse(resent_slavery == 2, 1,
                        ifelse(resent_slavery == 3, 0,
                            ifelse(resent_slavery == 4, -1,
                                ifelse(resent_slavery == 5, -2, NA))))),
    #* resentdeserve - Blacks have gotten less than they deserve
        #** Coded as: resent_deserve - 1 strongly agree - 5 strongly disagree, < 1 Missing, not asked, etc
        #** Recoded to: resentdeserve - -2 strongly disagree - 2 strongly agree, NA = Missing not asked, etc
        resentdeserve = ifelse(resent_deserve == 1, 2,
                            ifelse(resent_deserve == 2, 1,
                                ifelse(resent_deserve == 3, 0,
                                    ifelse(resent_deserve == 4, -1,
                                        ifelse(resent_deserve == 5, -2, NA))))),
    #* resenttryhard - Blacks should try harder to get ahead
        #** Coded as: resent_try - 1 strongly agree - 5 strongly disagree, < 1 Missing, not asked, etc
        #** Recoded to: tryhard - -2 strongly disagree - 2 strongly agree, NA = missing, not asked, etc
        tryhard = ifelse(resent_try == 1, 2,
                    ifelse(resent_try == 2, 1,
                        ifelse(resent_try == 3, 0,
                            ifelse(resent_try == 4, -1,
                                ifelse(resent_try == 5, -2, NA))))),
    #** raceResent - Racial resentment
        #** Coded as: average of blackworkmore, slavery, resentdeserve, tryhard
        raceResent = ((blackworkmore + slavery + resentdeserve + tryhard)/4),
    #* pid - Party identification
        #** Coded as: pid_x - 1 strong democrat - 7 strong republican, < 1 Missing, not asked, etc
        #** Recoded to: pid - 1 strong democrat - 7 strong republican, NA = missing, not asked, etc
        pid = ifelse(pid_x <= 0, NA, pid_x),
    #* female
        #** Coded as: gender_respondent_x - 1 male, 2 female, missing, not asked, etc
        #** Recoded to: female - 0 male, 1 female, NA = Missing, not asked, etc
        female = case_when(gender_respondent_x == 1 ~ 0,
                            gender_respondent_x == 2 ~ 1),
    )

# Save data
write.csv(anes_2012[['clean']], '../data/anes-2012/anes-2012-updated.csv')