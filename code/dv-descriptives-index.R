#### White Identity Descriptives: Index File####

#### Notes: ####
### Description: Index file for creaing a table of descriptive statistics of my DV ###

#### Files: ####
### In:  ###
### Out: ###

#### Setup ####
{
  here::here()
  library(tidyverse)
  library(stargazer)
  library(haven)
  library(hrbrthemes)
}

dat16 <- read_dta('data/anes-2016/anes-2016-updated.dta')

dat12 <- read_dta('data/anes-2012/anes-2012-updated.dta')

#### Descriptive Statistics - 2012 ####

tab12 <- stargazer(as.data.frame(dat12[c("wid")]), type = "latex", title = "Descriptive Statistics of White Identity - 2012", digits = 2, covariate.labels = "White Identity", notes =c("2012 American National Election Study.", "Statistics from Likert Scale of White Identity Importance Question."), notes.align = "r")
tab12

tab16 <- stargazer(as.data.frame(dat16[c("wid")]), type = 'latex', title = "Descriptive Statistics of White Identity - 2016", digits = 2, covariate.labels = "White Identity",notes = c("2012 American National Election Study.","Statistics from Likert Scale of White Identity Importance Question."), notes.align = "r")

annotation <- data.frame(
  x = c(3.5, 1.5),
  y = c(0.45, 0.4),
  label = c('2016', '2012')
)
hist <- ggplot() +
  geom_density(data = dat12, aes(x=wid),fill = "#0066ff", color = "#0066ff", alpha = 0.4) +
  geom_density(data = dat16, aes(x=wid), fill = "#ff0000", color = "#ff0000", alpha = 0.4) + 
  theme_ipsum() +
  labs(title = "Figure 1. White Identity in 2012 and 2016", y = "Density", x = "White Identity Response", caption = 'Damon Roberts | Data Source: 2012 and 2016 American National Election Study.\nDensity of Responses to White Identity Importance Question.') +
  geom_text(data = annotation, aes(x=x,y=y, label=label), color="#000000", size = 4, frontface = 'bold')
hist
