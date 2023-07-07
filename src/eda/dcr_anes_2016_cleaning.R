# Title: 2016 ANES cleaning

# Notes:
    #* Description: R script for cleaning the 2016 ANES 
    #* Updated: 2022-10-01
    #* Updated by: dcr 

# Setup
    #* Modularly load packages -----
box::use(
    haven = haven[read_dta],
    dplyr = dplyr[
      case_when
      , filter
      , mutate
    ]
)
    #* create list object
anes_2016 <- list()
    #* load dataset
anes_2016[["original"]] <- read_dta("../data/original/anes_2016/anes-2016.dta")

# Cleaning
anes_2016[["clean"]] <- anes_2016[["original"]] |>
    #* Filter only white respondents
    filter(V161310x == 1) |>
    mutate(
    #* wid - White Identity
        #** Coded as: V162327 - 1 = Extremely Important - 5 Not at all important, < 1 Missing, not asked, etc
        #** Recoded to: wid - 1 = Not at all important - 5 = Extremely important, NA = Missing, not asked, etc
    wid = ifelse(V162327 == 1, 5,
            ifelse(V162327 == 2, 4,
                ifelse(V162327 == 3, 3,
                    ifelse(V162327 == 4, 2,
                        ifelse(V162327 == 5, 1, NA))))),
    #* rboff - Retrospective better off: ----
        #** Coded as: V161110 - 1 much better, 5 much worse, < 1 Missing, not asked, etc
        #** Recoded to: rboff - -2 much worse, 2 much better, NA = missing, not asked, etc.
    rboff = ifelse(V161110 == 1, 2,
                        ifelse(V161110 == 2, 1, 
                               ifelse(V161110 == 3, 0,
                                      ifelse(V161110 == 4, -1,
                                             ifelse(V161110 == 5, -2, NA))))),
    #* epast - Economy better/worse than 1 year ago: ----
        #** Coded as: V161140x - 1 much better - 5 much worse, < 1 Missing, not asked, etc
        #** Recoded to: epast - -2 much worse - 2 much better, NA = missing, not asked, etc
    epast = ifelse(V161140x == 1, 2,
                        ifelse(V161140x == 2,1,
                               ifelse(V161140x == 3, 0, 
                                      ifelse(V161140x == 4, -1, 
                                             ifelse(V161140x == 5, -2, NA))))),
    #* unpast - Unemployment better/worse than 1 year ago
        #** Coded as: V161142x - 1 much better - 5 much worse, < 1 Missing, not asked, etc
        #** Recoded to: unpast - -2 much worse - 2 much better, NA = missing, not asked, etc
    unpast = ifelse(V161142x == 1, 2,
                         ifelse(V161142x == 2,1,
                                ifelse(V161142x == 3, 0,
                                       ifelse(V161142x == 4, -1,
                                              ifelse(V161142x == 5, -2, NA))))),
    #* edu - Education
        #** Coded as: V161270 - 1 = < high school - 16 = Doctorate degree, < 1 missing, not asked, etc
        #** Recoded to: 1 = < high school - 16 = Doctorate degree, NA = missing, not asked, etc
    edu = ifelse(V161270 <= 0, NA, V161270),
    #* income - Income
        #** Coded as: V161361x - < 1 Missing, not asked, etc
        #** Recoded to: NA = Missing, not asked, etc
    income = ifelse(V161361x >= 1, V161361x, NA),
    #* losejob - Worried about losing job
        #** Coded as: V161297 - 1 not at all - 5 extremely worried, < 1 missing, not asked, etc
        #** Recoded to: losejob - -2 = not at all - 2  = extremely worried, NA = missing, not asked, etc
    losejob = ifelse(V161297 == 1, -2,
                ifelse(V161297 == 2, -1,
                    ifelse(V161297 == 3, 0,
                        ifelse(V161297 == 4, 1,
                            ifelse(V161297 == 5, 2, NA))))),
    #* immtakejobs - Immigrants take jobs
        #** Coded as: V162158 - 1 extremely - 4 not at all, < 1 Missing, not asked, etc
        #** Recoded to: immtakejobs - 1 not at all - 4 extremely, NA = missing, not asked, etc
    immtakejobs = ifelse(V162158 == 1, 4,
                    ifelse(V162158 == 2, 3,
                        ifelse(V162158 == 3, 2,
                            ifelse(V162158 == 4, 1, NA)))),
    #* ecfamily - Worried about family finances
        #** Coded as: V162165 - 1 extremely - 5 not at all, < 1 Missing, not asked, etc
        #** Recoded to: ecfamily - -2 not at all - 2 extremely, NA = missing, not asked, etc
    ecfamily = ifelse(V162165 == 1, 5, 
                           ifelse(V162165 == 2, 4,
                                  ifelse(V162165 == 3, 3,
                                         ifelse(V162165 == 4, 2,
                                                ifelse(V162165 == 5, 1, NA))))),
    #* ecjob - Know someone who lost job 
        #** Coded as: V162167 - 1 = Someone lost job, 2 = No one lost job , <1 Missing, not asked, etc
        #** Recoded to: 0 = No one lost job, 1 = Someone lost job, NA = Missing, not asked, etc
    ecjob = ifelse(V162167 == 2, 0, 
                        ifelse(V162167 == 1,1, NA)),
    #* tradbreak - New lifestyles breaking society
        #** Coded as: V162208 - 1 strongly agree - 5 strongly disagree, <1 Missing, not asked, etc
        #** Recoded to: tradbreak - -2 strongly disagree - 2 strongly agree, NA = missingnot asked, etc
    tradbreak = ifelse(V162208 == 1, 2,
                            ifelse(V162208 == 2,1,
                                   ifelse(V162208 == 3, 0,
                                          ifelse(V162208 == 4, -1,
                                                 ifelse(V162208 == 5, -2, NA))))),
    #* govbias - Government biased against Whites
        #** Coded as: V162318 - 1 favors whites, 2 favors Blacks, 3 neither, < 1 Missing, not asked, etc
        #** Recoded to: govbias - -1 favors whites, 0 neither, 1 favors Blacks, NA = missing, not asked, etc
    govbias = ifelse(V162318 == 1,-1,
                          ifelse(V162318 == 2, 0,
                                 ifelse(V162318 == 3, 1, NA))),
    #* inflwhite - Influence whites have on politics
        #** Coded as: V162322 - 1 too much, 2 just about right, 3 too little, < 1 Missing, not asked, etc
        #** Recoded to: inflwhite - -1 too little, 0 just about right, 1 too much, NA = missing, not asked, etc
    inflwhite = ifelse(V162322 == 3, -1,
                            ifelse(V162322 == 2,0,
                                   ifelse(V162322 == 1,1, NA))),
    #* whitediscrim - Whites are discrimminated against
        #** Coded as: V162360 - 1 strongly agree - 5 strongly disagree, < 1 Missing, not asked, etc
        #** Recoded to: whitedescrim - 5 strongly disagree - 2 strongly agree, NA = Missing, not asked, etc
    whitediscrim = ifelse(V162360 == 5, 1,
                               ifelse(V162360 == 4, 2,
                                      ifelse(V162360 == 3,3,
                                             ifelse(V162360 == 2,4,
                                                    ifelse(V162360 == 5, 1, NA))))),
    #* blackworkmore - Blacks should work way up
        #** V162211 - 1 = Strongly agree - 5 = Strongly disagree, < 1 missing, not asked, etc
        #** Recoded to: blackworkmore - -2 = Strongly disagree - 2 = Strongly agree, NA = missing, not asked, etc
    blackworkmore = ifelse(V162211 == 1,2,
                                ifelse(V162211 == 2,1,
                                       ifelse(V162211 == 3, 0,
                                              ifelse(V162211 == 4, -1,
                                                     ifelse(V162211 == 5, -2, NA))))),
    #* resentslavery - Slavery makes it difficult for Blacks
        #** Coded as: V162212 - 1 strongly agree - 5 strongly disagree, < 1 Missing, not asked, etc
        #** Recoded to: slavery - -2 strongly disagree - 2 strongly agree, NA = missing, not asked, etc
    slavery = ifelse(V162212 == 1,2,
                          ifelse(V162212 == 2,1,
                                 ifelse(V162212 == 3,0,
                                        ifelse(V162212 == 4, -1, 
                                               ifelse(V162212 == 5, -2, NA))))),
    #* resentdeserve - Blacks have gotten less than they deserve
        #** Coded as: V162213 - 1 strongly agree - 5 strongly disagree, < 1 Missing, not asked, etc
        #** Recoded to: resentdeserve - -2 strongly disagree - 2 strongly agree, NA = Missing not asked, etc
    resentdeserve = ifelse(V162213 == 1,2,
                                ifelse(V162213 == 2,1,
                                       ifelse(V162213 == 3, 0,
                                              ifelse(V162213 == 4,-1,
                                                     ifelse(V162213 == 5, -2, NA))))),
    #* resenttryhard - Blacks should try harder to get ahead
        #** Coded as: V162214 - 1 strongly agree - 5 strongly disagree, < 1 Missing, not asked, etc
        #** Recoded to: tryhard - -2 strongly disagree - 2 strongly agree, NA = missing, not asked, etc
    tryhard = ifelse(V162214 == 1,2,
                          ifelse(V162214 == 2,1,
                                 ifelse(V162214 == 3,0,
                                        ifelse(V162214 == 4,-1,
                                               ifelse(V162214 == 5,-2, NA))))),
    #* resentWorkway - Blacks should work way up
        #** Coded as: V162211 - 1 strongly agree - 5 strongly disagree, <1 Missing, not asked, etc
        #** Recoded to: resentWorkway - -2 strongly disagree - 2 strongly agree, NA = Missing, not asked, etc
    resentWorkway = ifelse(V162211 == 1, 2, 
                               ifelse(V162211 == 2, 1,
                                      ifelse(V162211 == 3, 0,
                                             ifelse(V162211 == 4, -1,
                                                    ifelse(V162211 == 5, -2, NA))))),
    #** raceResent - Racial resentment
        #** Coded as: average of blackworkmore, slavery, resentdeserve, tryhard
    raceResent = ((resentWorkway + slavery + resentdeserve + tryhard)/4),
    #* pid - Party identification
        #** Coded as: V161158x - 1 strong democrat - 7 strong republican, < 1 Missing, not asked, etc
        #** Recoded to: pid - 1 strong democrat - 7 strong republican, NA = missing, not asked, etc
    pid = ifelse(V161158x <= 0, NA, V161158x),
    #* female
        #** Coded as: V161342 - 1 male, 2 female, missing, not asked, etc
        #** Recoded to: female - 0 male, 1 female, NA = Missing, not asked, etc
    female = ifelse(V161342 == 2, 1,
                         ifelse(V161342 == 1, 0,
                                ifelse(V161342 == 3, 0, NA))),
    )

# Save clean data
write.csv(anes_2016[["clean"]], "../data/clean/anes_2016_updated.csv")