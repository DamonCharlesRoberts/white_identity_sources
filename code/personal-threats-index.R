#### Personal Factors: Index File ####

#### Notes: ####
### Description: Index file for analysis of personal threats hypotheses ###

#### Files: ####
### In:  'code/personal-threats-setup-file.R' ###
### Out: ###

#### Setup ####
here::here()
source('code/personal-threats-setup-file.R')
rm(dat12o,dat16o,dat18o,dat19o)

load12anes <- function(){
  read_dta('data/anes-2012/anes-2012-updated.dta')
}
load16anes <- function(){
  read_dta('data/anes-2016/anes-2016-updated.dta')
}

anes12 <- load12anes()
anes16 <- load16anes()

#### Descriptives of Variables ####
  ### Total Dataset ###
skimr::skim(anes12$wid)
skimr::skim(anes16$wid)
skimr::skim(anes12$female)
skimr::skim(anes16$female)
skimr::skim(anes12$rboff)
skimr::skim(anes16$rboff)
skimr::skim(anes12$govbias)
skimr::skim(anes16$govbias)
skimr::skim(anes12$inflwhite)
skimr::skim(anes16$inflwhite)
skimr::skim(anes12$whitediscrim)
skimr::skim(anes16$whitediscrim)

  ### High on White Identity - 4 or greater = very or extremely important, see Jardina 2019 Ch. 3
anes12High <- anes12 %>%
  filter(wid >= 4)
anes16High <- anes16 %>%
  filter(wid >= 4)

skimr::skim(anes12High$wid)
skimr::skim(anes16High$wid)
skimr::skim(anes12High$female)
skimr::skim(anes16High$female)
skimr::skim(anes12High$rboff)
skimr::skim(anes16High$rboff)
skimr::skim(anes12High$govbias)
skimr::skim(anes16High$govbias)
skimr::skim(anes12High$inflwhite)
skimr::skim(anes16High$inflwhite)
skimr::skim(anes12High$whitediscrim)
skimr::skim(anes16High$whitediscrim)


#### Regression Models ####

corr12 <- anes12 %>%
  select(widb, rboff, pboff, ideo, ee, pocare, epast, efuture, unpast, pid, edu, findjob, losejob, offwork, ecfamily, toofar, govbias, inflwhite, inflblack, whitediscrim)
corr12Fig <- ggcorr(corr12, label = TRUE) + ggplot2::labs(title = "Figure #.  2012 PEARSON'S R Correlations", caption = "Damon Roberts | Data Source: 2012 American National Election Study") + ggplot2::theme(legend.position = 'bottom')
corr12Fig

corr16 <- anes16 %>%
  select(widb, rboff, pboff, ideo, ee, pocare, epast, efuture, unpast, pid, edu, ecfamily, govbias, inflwhite, inflblack, whitediscrim)
corr16Fig <- ggcorr(corr16, label = TRUE) + ggplot2::labs(title = "Figure #. 2016 Pearson's R Correlations", caption = "Damon Roberts | Data Source: 2016 American National Election Study") + ggplot2::theme(legend.position = 'bottom')
corr16Fig
