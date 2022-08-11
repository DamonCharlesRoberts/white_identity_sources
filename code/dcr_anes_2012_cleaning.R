# Title: 2012 ANES Cleaning ----

# Notes: ----
    #* Description: Cleaning script for the 2012 ANES ----
    #* Updated: 2022 - 02 - 07 ----
    #* Updated by: dcr -----

# Setup: -----
    #* Modularly load packages -----
box::use(
    haven = haven[read_dta],
    dplyr = dplyr[mutate, filter, case_when]
)
    #* Load original ANES file ----
anes12 = read_dta('data/anes-2012/anes-2012.dta')
# Cleaning ----
anes12Clean = anes12 |>
    #* Filter dataset to include only white respondents ----
    filter(dem_raceeth_x == 1) |>
    mutate(
    #* Female: ----
        #** Coded as: gender_respondent_x - 1 male, 2 female
        #** Recoded to: female - 0 male, 1 female
        female = case_when(gender_respondent_x == 1 ~ 0,
                            gender_respondent_x == 2 ~ 1),
    #* Retrospective better off: ----
        #** Coded as: finance_finpast_x - 1 much better, 5 much worse
        #** Recoded to: rboff - -2 much worse, 2 much better
        rboff = ifelse(finance_finpast_x == 1, 2,
                        ifelse(finance_finpast_x == 2, 1,
                            ifelse(finance_finpast_x == 3, 0,
                                ifelse(finance_finpast_x == 4, -1,
                                    ifelse(finance_finpast_x == 5, -2, NA))))),
    #* Prospective better off: ----
        #** Coded as: finance_finnext_x - 1 much better, 5 much worse
        #** Recoded to: pboff pboff - -2 much worse, 2 much better
        pboff = ifelse(finance_finnext_x == 1, 2,
                    ifelse(finance_finnext_x == 2, 1,
                        ifelse(finance_finnext_x == 3, 0,
                            ifelse(finance_finnext_x == 4, -1,
                                ifelse(finance_finnext_x == 5, -1, NA))))),
    #* Ideology: ----
        #** Coded as: libcpre_self - 1 extremely liberal, 7 extremely conservative
        #** Recoded to: ideo - 1 estremely liberal, 7 extremely conservative
        ideo = ifelse(libcpre_self <= 0, NA, libcpre_self),
    #* Economy better/worse than 1 year ago: ----
        #** Coded as: econ_ecpast_x - 1 much better - 5 much worse
        #** Recoded to: epast - -2 much worse - 2 much better
        epast = ifelse(econ_ecpast_x == 1, 2,
                    ifelse(econ_ecpast_x == 2, 1,
                        ifelse(econ_ecpast_x == 3, 0,
                            ifelse(econ_ecpast_x == 4, -1,
                                ifelse(econ_ecpast_x == 5, -2, NA))))),
    #* Economy will be better/worse next year: ----
        #** Coded as: econ_ecnext_x - 1 much better - 5 much worse
        #** Recoded to: efuture - -2 much worse - 2 much better
        efuture = ifelse(econ_ecnext_x == 1, 2,
                    ifelse(econ_ecnext_x == 2, 1,
                        ifelse(econ_ecnext_x == 3, 0, 
                            ifelse(econ_ecnext_x == 4, -1,
                                ifelse(econ_ecnext_x == 5, -2, NA))))),
    #* Unemployment better/worse than 1 year ago ----
        #** Coded as: econ_unpast_x - 1 much better - 5 much worse
        #** Recoded to: unpast - -2 much worse - 2 much better
        unpast = ifelse(econ_unpast_x == 1, 2,
                    ifelse(econ_unpast_x == 2, 1,
                        ifelse(econ_unpast_x == 3, 0,
                            ifelse(econ_unpast_x == 4, -1,
                                ifelse(econ_unpast_x == 5, -2, NA))))),
    #* Unemployment will be better/worse a year from now ----
        #** Coded as: econ_unnext_x - 1 much better - 5 much worse
        #** Recoded to: unnext - -2 much worse - 2 much better
        unnext = ifelse(econ_unnext == 1, 2,
                    ifelse(econ_unnext == 2, 1,
                        ifelse(econ_unnext == 3, 0,
                            ifelse(econ_unnext == 4, -1,
                                ifelse(econ_unnext == 5, -2, NA))))),
    #* Party Identification ----
        #** Coded as: pid_x - 1 strong democrat - 7 strong republican
        #** Recoded to: pid - 1 strong democrat - 7 strong republican
        pid = ifelse(pid_x <= 0, NA, pid_x),
    #* Age ----
        #** Coded as: dem_age_r_x - 18 - 99
        #** Recoded to: age - 18 - 99
        age = dem_age_r_x,
    #* Education ----
        #** Coded as: dem_edugroup_x - 1 < highschool, 2 hs, 3 some post-hs, 4 Bachelors, 5 graduate
        #** Recoded to: edu -1 < highschool, 2 hs, 3 some post-hs, 4 Bachelors, 5 graduate
        edu = ifelse(dem_edugroup_x <= 0, NA, dem_edugroup_x),
    #* Worried about finding a job ----
        #** Coded as: dem_findjob - 1 not at all - 5 extremely worried
        #** Recoded to: findjob - 1 not at all - 5 extremely worried
        findjob = ifelse(dem_findjob <= 0, NA, dem_findjob),
    #* Worried about losing job ----
        #** Coded as: dem_losejob - 1 not at all - 5 extremely worried
        #** Recoded to: losejob - 1 not at all - 5 extremely worried
        losejob = ifelse(dem_losejob <= 0, NA, dem_losejob),
    #* Worried about being laid off ----
        #** Coded as: dem_offwork - 1 yes, 2 no
        #** Recode to: offwork - 0 no, 1 yes
        offwork = ifelse(dem_offwork == 2, 0,
                    ifelse(dem_offwork == 1, 1, NA)),
    #* Support fair access to jobs for Blacks ----
        #** Coded as: fairjob_opin_x - 1 strongly yes - 5 strongly no
        #** Recoded to: fairjblacks - -2 strongly no, 2 strongly yes
        fairjblacks = ifelse(fairjob_opin_x == 1, 2,
                        ifelse(fairjob_opin_x == 2, 1,
                            ifelse(fairjob_opin_x == 3, 0,
                                ifelse(fairjob_opin_x == 4, -1,
                                    ifelse(fairjob_opin_x == 5, -2, NA))))),
    #* Immigrants take jobs ----
        #** Coded as: immigpo_jobs - 1 extremely - 4 not at all
        #** Recoded to: immtakejobs - 1 not at all - 4 extremely
        immtakejobs = ifelse(immigpo_jobs == 1, 4,
                        ifelse(immigpo_jobs == 2, 3,
                            ifelse(immigpo_jobs == 3, 2,
                                ifelse(immigpo_jobs == 4, 1, NA)))),
    #* Worried about family finances ----
        #** Coded as: ecperil_worry - 1 extremely - 5 not at all
        #** Recoded to: ecfamily - -2 not at all - 2 extremely
        ecfamily = ifelse(ecperil_worry == 1, 2,
                    ifelse(ecperil_worry == 2, 1,
                        ifelse(ecperil_worry == 3, 0,
                            ifelse(ecperil_worry == 4, -1,
                                ifelse(ecperil_worry == 5, -2, NA))))),
    #** Linked fate with other whites ----
        #** Coded as: link_white - 1 yes, 2 no
        #** Recoded to: linked - 0 no, 1 yes
        linked = ifelse(link_white == 2, 0,
                    ifelse(link_white == 1, 1, NA)),
    #** New lifestyles breaking society ----
        #** Coded as: trad_lifestyle - 1 strongly agree - 5 strongly disagree 
        #** Recoded to: tradbreak - -2 strongly disagree - 2 strongly agree
        tradbreak = ifelse(trad_lifestyle == 1, 2,
                        ifelse(trad_lifestyle == 2, 1,
                            ifelse(trad_lifestyle == 3, 0,
                                ifelse(trad_lifestyle == 4, -1,
                                    ifelse(trad_lifestyle == 5, -2, NA))))),
    #** Blacks should work way up ----
        #** Coded as: resent_workway - 1 strongly agree - 5 strongly disagree
        #** Recoded to: blackworkmore - -2 strongly disagree - 2 strongly agree
        blackworkmore = ifelse(resent_workway == 1, 2,
                            ifelse(resent_workway == 2, 1,
                                ifelse(resent_workway == 3, 0,
                                    ifelse(resent_workway == 4, -1,
                                        ifelse(resent_workway == 5, -2, NA))))),
    #** Slavery makes it difficult for Blacks ----
        #** Coded as: resent_slavery - 1 strongly agree - 5 strongly disagree
        #** Recoded to: slavery - -2 strongly disagree - 2 strongly agree
        slavery = ifelse(resent_slavery == 1, 2,
                    ifelse(resent_slavery == 2, 1,
                        ifelse(resent_slavery == 3, 0,
                            ifelse(resent_slavery == 4, -1,
                                ifelse(resent_slavery == 5, -2, NA))))),
    #** Blacks have gotten less than they deserve ----
        #** Coded as: resent_deserve - 1 strongly agree - 5 strongly disagree
        #** Recoded to: resentdeserve - -2 strongly disagree - 2 strongly agree
        resentdeserve = ifelse(resent_deserve == 1, 2,
                            ifelse(resent_deserve == 2, 1,
                                ifelse(resent_deserve == 3, 0,
                                    ifelse(resent_deserve == 4, -1,
                                        ifelse(resent_deserve == 5, -2, NA))))),
    #** Blacks should try harder to get ahead ----
        #** Coded as: resent_try - 1 strongly agree - 5 strongly disagree
        #** Recoded to: tryhard - -2 strongly disagree - 2 strongly agree
        tryhard = ifelse(resent_try == 1, 2,
                    ifelse(resent_try == 2, 1,
                        ifelse(resent_try == 3, 0,
                            ifelse(resent_try == 4, -1,
                                ifelse(resent_try == 5, -2, NA))))),
    #** Support Blacks getting hired ----
        #** Coded as: aapost_hire_x - 1 strongly agree - 5 strongly disagree
        #** Recoded to: blackhire - -2 strongly disagree - 2 strongly agree
        blackhire = ifelse(aapost_hire_x == 1, 2,
                        ifelse(aapost_hire_x == 2, 1,
                            ifelse(aapost_hire_x == 3, 0,
                                ifelse(aapost_hire_x == 4, -1,
                                    ifelse(aapost_hire_x == 5, -2, NA))))),
    #** Racial resentment
        #** Coded as: average of blackworkmore, slavery, resentdeserve, tryhard
        raceResent = ((blackworkmore + slavery + resentdeserve + tryhard)/4),
    #** Equality has gone too far ----
        #** Coded as: egal_toofar - 1 strongly agree - 5 strongly disagree
        #** Recoded to: toofar - -2 strongly disagree - 2 strongly agree
        toofar = ifelse(egal_toofar == 1, 2,
                    ifelse(egal_toofar == 2, 1,
                        ifelse(egal_toofar == 3, 0,
                            ifelse(egal_toofar == 4, -1,
                                ifelse(egal_toofar == 5, -2, NA))))),
    #** Government biased against Blacks ----
        #** Coded as: nonmain_bias - 1 favors whites, 2 favors Blacks, 3 neither
        #** Recoded to: govbias - -1 favors whites, 0 neither, 1 favors Blacks
        govbias = ifelse(nonmain_bias == 1, -1,
                    ifelse(nonmain_bias == 3, 0,
                        ifelse(nonmain_bias == 2, 1, NA))),
    #** Influence whites have on politics ----
        #** Coded as: racecasi_infwhite - 1 too much, 2 just about right, 3 too little
        #** Recoded to: inflwhite - -1 too little, 0 just about right, 1 too much
        inflwhite = ifelse(racecasi_infwhite == 3, -1,
                        ifelse(racecasi_infwhite == 2, 0,
                            ifelse(racecasi_infwhite == 1, 1, NA))),
    #** Influence Blacks have on politics ----
        #** Coded as: racecasi_infblack - 1 too much, 2 just about right, 3 too little
        #** Recoded to: inflblack - -1 too little, 0 just about right, 1 too much
        inflblack = ifelse(racecasi_infblacks == 3, -1,
                        ifelse(racecasi_infblacks == 2, 0,
                            ifelse(racecasi_infblacks == 1, 1, NA))),
    #** Whites are discrimminated against ----
        #** Coded as: discrim_whites - 1 strongly agree - 5 strongly disagree
        #** Recoded to: whitedescrim - -2 strongly disagree - 2 strongly agree
        whitediscrim = ifelse(discrim_whites == 1, 2,
                        ifelse(discrim_whites == 2, 1,
                            ifelse(discrim_whites == 3, 0,
                                ifelse(discrim_whites == 4, -1,
                                    ifelse(discrim_whites == 5, -2, NA))))),
    #** wid - White Identity
        #** Coded as: 1 = Extremely Important - 5 Not at all important
        #** RECODE TO: 1 = Not at all important - 5 = Extremely important
        wid = case_when(ident_whiteid == 1 ~ 5,
                        ident_whiteid == 2 ~ 4,
                        ident_whiteid == 3 ~ 3,
                        ident_whiteid == 4 ~ 2,
                        ident_whiteid == 5 ~ 1)
    )

# Save data
write.csv(anes12Clean, 'data/anes-2012/anes-2012-updated.csv')