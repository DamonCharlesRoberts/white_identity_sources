#### Title: Primary Analyses - White Identity Origins Project ####

#### Notes: #####
### Description: CFA analysis, regression and logit analysis and graph creation with predicted probability estimation ###

#### Setup ####
### Note to self: Uncomment below if need to source any functions from data cleaning process. Should just run those scripts nativley, though.
### source('code/setup-file.R')
### source('code/cleaning-2012-anes.R')
### source('code/cleaning-2016-anes.R')
box::use(
  here,
  haven = haven[read_dta],
  dplyr = dplyr[...],
  stargazer = stargazer[stargazer],
  lme4 = lme4[lmer],
  texreg = texreg[screenreg],
  ggeffects = ggeffects[ggpredict],
  ggplot2 = ggplot2[...],
  ggthemes = ggthemes[theme_tufte],
  GGally = GGally[...]
)

{
  here::here()
  library(haven) # read dta files
#  library(dplyr) # for tibble management
#  library(stargazer) # for tables
#  library(pglm) # for polr function for ordinal logit
#  library(reshape) # for `melt` to get pred. probs
#  library(ggpubr) # for `ggarrange` to make figures
#  library(lme4) # for mixed effects models
#  library(rstanarm) # for bayesian inference
#  library(texreg) #for screenreg function to display results
}

### Read in data
anes12 <- read_dta('data/anes-2012/7_raceincome_anes_2012_updated.dta') %>%
  filter(dem_raceeth_x == 1) %>%
  rename(employment = dem_emptype_work,
        news = prmedia_wkrdnws)
#likert_flip <- c('Not at all', 'A little', 'Moderately', 'Very', 'Extremely')
#anes12 <- anes12 %>%
#  mutate(wid = factor(wid, labels = likert_flip), ordered = TRUE)
#anes12 <- as_factor(anes12)
anes16 <- read_dta('data/anes-2016/7_raceincome_anes_2016_updated.dta') %>%
  filter(V161310x == 1) %>%
  rename(news = V161008)
#likert_flip <- c('Not at all', 'A little', 'Moderately', 'Very', 'Extremely')
#anes16 <- anes16 %>%
#  mutate(wid = factor(wid, labels = likert_flip), ordered = TRUE)
#anes16 <- as_factor(anes16)
#### Draft 4 Models ####
model12 <- lmer(wid ~ estinc + edu + employment + percentBelowPoverty + rboff + pboff + epast + efuture + incomeInequality + news + ruralplurality + raceResent + age + female + cdWhitePercent + pid + ideo + (1|district), data = anes12)
model16 <- lmer(wid ~ estinc + edu + employment + percentBelowPoverty + getahead + rboff + pboff + epast + efuture + incomeInequality + news + ruralplurality + raceResent + age + female + cdWhitePercent + pid + ideo + (1|district), data = anes16)

model12a <- lmer(wid ~ relativeIncome + edu + employment + percentBelowPoverty + rboff + pboff + epast + efuture + incomeInequality + news + ruralplurality + raceResent + age + female + cdWhitePercent + pid + ideo + (1|district), data = anes12)
model16a <- lmer(wid ~ relativeIncome + edu + employment + percentBelowPoverty + getahead + rboff + pboff + epast + efuture + incomeInequality + news + ruralplurality + raceResent + age + female + cdWhitePercent + pid + ideo + (1|district), data = anes16)

model12a2 <- lmer(wid ~ relativeIncomeRace + edu + employment + percentBelowPoverty + rboff + pboff + epast + efuture + incomeInequality + news + ruralplurality + raceResent + age + female + cdWhitePercent + pid + ideo + (1|district), data = anes12)
model16a2 <- lmer(wid ~ relativeIncomeRace + edu + employment + percentBelowPoverty + getahead + rboff + pboff + epast + efuture + incomeInequality + news + ruralplurality + raceResent + age + female + cdWhitePercent + pid + ideo + (1|district), data = anes16)


### Tables ###
keymodelstable <- stargazer(model12, model16, 
                            style = 'apsr',
                            notes = c("Source: 2012 and 2016 American National Election Studies.", "Coefficients from regression with random intercepts by congressional district.", "Standard errors in parentheses.", "* p < 0.05"),
                            title = "Effects of actual and percieved material status loss on predicting white identity adoption", 
                            dep.var.labels = "White Identity Importance",
                            covariate.labels = c("Income", "Education", "Employment Status", "% below poverty", "Opportunity to get ahead", "Retrospective - better off", "Prospective - better off", "Economy Better - Past", "Economy Better - Future", "Get ahead - Income Inequality", "Frequency of news consumption", "Rural", "Racial Resentment", "Age", "Female", "% White", "Party Identification", "Ideology"),
                            notes.append = FALSE, 
                            star.cutoffs = c(0.05),
                            column.labels = c("2012", "2016"),
                            model.numbers = FALSE,
                            add.lines = list(c("Num. groups: District", "407", "399"), 
                                            c("Variance: District(Intercept)", "0.01", "0.03"),
                                            c("Variance: Residual", "1.57", "1.67")),
                            type = "latex", 
                            out = "figures/context_key_model_draft4.tex")
altmodelstable <- stargazer(model12a, model16a, 
                            style = 'apsr',
                            notes = c("Source: 2012 and 2016 American National Election Studies.", "Coefficients from regression with random intercepts by congressional district.", "Standard errors in parentheses.", "* p < 0.05"),
                            title = "Effects of actual and percieved material status loss on predicting white identity adoption", 
                            dep.var.labels = "White Identity Importance",
                            covariate.labels = c("Relative Income", "Education", "Employment Status", "% below poverty", "Opportunity to get ahead", "Retrospective - better off", "Prospective - better off", "Economy Better - Past", "Economy Better - Future", "Get ahead - Income Inequality", "Frequency of news consumption", "Rural", "Racial Resentment", "Age", "Female", "% White", "Party Identification", "Ideology"),
                            notes.append = FALSE, 
                            star.cutoffs = c(0.05),
                            column.labels = c("2012", "2016"),
                            model.numbers = FALSE,
                            add.lines = list(c("Num. groups: District", "407", "399"), 
                                            c("Variance: District(Intercept)", "0.01", "0.03"),
                                            c("Variance: Residual", "1.57", "1.67")),
                            type = "latex", 
                            out = "figures/context_key_model_draft4a1.tex")
altmodelstable2 <- stargazer(model12a2, model16a2, 
                            style = 'apsr',
                            notes = c("Source: 2012 and 2016 American National Election Studies.", "Coefficients from regression with random intercepts by congressional district.", "Standard errors in parentheses.", "* p < 0.05"),
                            title = "Effects of actual and percieved material status loss on predicting white identity adoption", 
                            dep.var.labels = "White Identity Importance",
                            covariate.labels = c("Relative Income", "Education", "Employment Status", "% below poverty", "Opportunity to get ahead", "Retrospective - better off", "Prospective - better off", "Economy Better - Past", "Economy Better - Future", "Get ahead - Income Inequality", "Frequency of news consumption", "Rural", "Racial Resentment", "Age", "Female", "% White", "Party Identification", "Ideology"),
                            notes.append = FALSE, 
                            star.cutoffs = c(0.05),
                            column.labels = c("2012", "2016"),
                            model.numbers = FALSE,
                            add.lines = list(c("Num. groups: District", "407", "399"), 
                                            c("Variance: District(Intercept)", "0.01", "0.03"),
                                            c("Variance: Residual", "1.57", "1.67")),
                            type = "latex", 
                            out = "figures/context_key_model_draft4a2.tex")
#### Draft 3 Models ####
#model12 <- lmer(wid ~ relativeIncome + edu + employment + percentBelowPoverty + rboff + pboff + epast + efuture + incomeInequality +  news + ruralplurality + raceResent + age + female + cdWhitePercent + pid + ideo + (1|district), data = anes12)
#
#model16 <- lmer(wid ~ relativeIncome + edu + employment + percentBelowPoverty + rboff + pboff + epast + efuture + incomeInequality + news + ruralplurality + raceResent + age + female + cdWhitePercent + pid + ideo + (1|district), data = anes16)
#
#model12a <- lmer(wid ~ relativeIncomeRace + edu + employment + percentBelowPoverty + rboff + pboff + epast + efuture + incomeInequality +  news + ruralplurality + raceResent + age + female + cdWhitePercent + pid + ideo + (1|district), data = anes12)
#
#model16a <- lmer(wid ~ relativeIncomeRace + edu + employment + percentBelowPoverty + rboff + pboff + epast + efuture + incomeInequality + news + ruralplurality + raceResent + age + female + cdWhitePercent + pid + ideo + (1|district), data = anes16)
#
  ### Tables ###
#keymodelstable <- stargazer(model12, model16, 
#                            style = 'apsr',
#                            notes = c("Source: 2012 and 2016 American National Election Studies.", "Coefficients from regression with random intercepts by congressional district.", "Standard errors in parentheses.", "* p < 0.05"),
#                            title = "Effects of actual and percieved material status loss on predicting white identity adoption", 
#                            dep.var.labels = "White Identity Importance",
#                            covariate.labels = c("Relative Income", "Education", "Employment Status", "% below poverty", "Retrospective - better off", "Prospective - better off", "Economy Better - Past", "Economy Better - Future", "Get ahead - Income Inequality", "Frequency of news consumption", "Rural", "Racial Resentment", "Age", "Female", "% White", "Party Identification", "Ideology"),
#                            notes.append = FALSE, 
#                            star.cutoffs = c(0.05),
#                            column.labels = c("2012", "2016"),
#                            model.numbers = FALSE,
#                            add.lines = list(c("Num. groups: District", "407", "399"), 
#                                            c("Variance: District(Intercept)", "0.01", "0.03"),
#                                            c("Variance: Residual", "1.57", "1.67")),
#                            type = "latex", 
#                            out = "figures/context_key_model_draft3.tex")
#
#amodelstable <- stargazer(model12a, model16a, 
#                            style = 'apsr',
#                            notes = c("Source: 2012 and 2016 American National Election Studies.", "Coefficients from regression with random intercepts by congressional district.", "Standard errors in parentheses.", "* p < 0.05"),
#                            title = "Effects of actual and percieved material status loss on predicting white identity adoption", 
#                            dep.var.labels = "White Identity Importance",
#                            covariate.labels = c("Relative Income to Black", "Education", "Employment Status", "% below poverty", "Retrospective - better off", "Prospective - better off", "Economy Better - Past", "Economy Better - Future", "Get ahead - Income Inequality", "Frequency of news consumption", "Rural", "Racial Resentment", "Age", "Female", "% White", "Party Identification", "Ideology"),
#                            notes.append = FALSE, 
#                            star.cutoffs = c(0.05),
#                            column.labels = c("2012", "2016"),
#                            model.numbers = FALSE,
#                            add.lines = list(c("Num. groups: District", "407", "399"), 
#                                            c("Variance: District(Intercept)", "0.00", "0.03"),
#                                            c("Variance: Residual", "1.58", "1.65")),
#                            type = "latex", 
#                            out = "figures/context_key_model_draft3a.tex")
  ### Figures ###
likert_flip <- c('Not at all', 'A little', 'Moderately', 'Very', 'Extremely')
anes12graph <- anes12 %>%
  mutate(wid = factor(wid, labels = likert_flip), ordered = TRUE)
anes16graph <- anes16 %>%
  mutate(wid = factor(wid, labels = likert_flip), ordered = TRUE)
dvfigure <- ggplot() +
  geom_histogram(data = anes12, aes(x = wid, y = ..density..), fill = '#808080') +
  geom_label(aes(x=5, y=2, label = "2012"), color = '#808080') +
  geom_histogram(data = anes16, aes(x = wid, y = -..density..), fill = '#484848') +
  geom_label(aes(x=5, y=-2, label = "2016"), color = '#484848') +
  theme_tufte(base_size = 20) + 
  labs(caption = "Data Source: 2012 and 2016 American National Election Studies.\nNote: Density of responses flipped about y-axis.", y = "Density of responses per option", x = "Importance of white identity to respondent") +
  scale_x_continuous(labels = likert_flip) +
  ggtitle("Figure 1. Density of responses to white identity importance") + 
  ggsave('figures/2012_2016_dv_fig.png')

corrplot2012 <- anes12 %>%
  select(relativeIncome, estinc, edu, employment, percentBelowPoverty, rboff, pboff, epast, efuture, incomeInequality, news, ruralplurality, raceResent, age, female, cdWhitePercent, pid, ideo)
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrmatrix <- ggcorr(corrplot2012, method = c("everything", "pearson"), )


#### Draft 2 Models ####
keymodel12 <- lmer(wid ~ relativeIncome + rboff + pboff + incomeInequality + edu + employment + raceResent + age + female + cdWhitePercent + gini + percentBelowPoverty + pid + ideo + (1|district), 
                  data = anes12)
alternative12 <- lmer(wid ~ relativeIncome + rboff + pboff + efuture + epast + incomeInequality + edu + employment + raceResent + age + female + cdWhitePercent + gini + percentBelowPoverty + pid + ideo + (1|district),
                  data = anes12)
alternative212 <- lmer(wid ~ relativeIncome + rboff + pboff + news + incomeInequality + edu + employment + raceResent + age + female + cdWhitePercent + gini + percentBelowPoverty + pid + ideo + (1|district),
                  data = anes12)
ruralmodel12 <- lmer(wid ~ relativeIncome + rboff + pboff + incomeInequality + edu + employment +  raceResent + ruralplurality + age + female + cdWhitePercent + gini + percentBelowPoverty + pid + ideo + (1|district), 
                  data = anes12)
 
keymodel16 <- lmer(wid ~ relativeIncome + rboff + pboff + incomeInequality + edu + employment + getahead + raceResent + age + female + cdWhitePercent + gini + percentBelowPoverty + pid + ideo + V161125 + (1|district),
              data = anes16)
alternative16 <- lmer(wid ~ relativeIncome + rboff + pboff + efuture + epast + incomeInequality + edu + employment + getahead + raceResent + age + female + cdWhitePercent + gini + percentBelowPoverty + pid + ideo + V161125 + (1|district),
              data = anes16)
alternative216 <- lmer(wid~ relativeIncome + rboff + pboff + news + incomeInequality + edu + employment + getahead + raceResent + age + female + cdWhitePercent + gini + percentBelowPoverty + pid + ideo + V161125 + (1|district),
                  data = anes16)
ruralmodel16 <- lmer(wid ~ relativeIncome + rboff + pboff + incomeInequality + edu + employment + getahead + raceResent + ruralplurality + age + female + cdWhitePercent + gini + percentBelowPoverty + pid + ideo + V161125 + (1|district),
              data = anes16)

### Tables ###
descriptivesdvdf12 <- anes12 %>%
  select(wid) %>%
  rename(wid12 = wid)
descriptivesdvdf16 <- anes16 %>%
  select(wid) %>%
  rename(wid16 = wid)
descriptivesdvdf12 <- as.data.frame(descriptivesdvdf12)
descriptivesdvdf16 <- as.data.frame(descriptivesdvdf16)
descriptivesdv12 <- mean(descriptivesdvdf12$wid12)
descriptivesdv16 <- mean(descriptivesdvdf16$wid16)

descriptivesdv12 <- stargazer(descriptivesdvdf12, 
                            style = 'apsr',
                            covariate.labels = c("2012 White Identity"),
                            notes = c("Source: 2012 American National Election Studies.", "Descriptive statistics of importance of being white to identity."),
                            title = "Table 1. Descriptive statistics of white identity.",
                            type = "latex",
                            out = "figures/descriptive_statistics_context_2012.tex")
descriptivesdv16 <- stargazer(descriptivesdvdf16, 
                            style = 'apsr',
                            covariate.labels = c("2016 White Identity"),
                            notes = c("Source: 2016 American National Election Studies.", "Descriptive statistics of importance of being white to identity."),
                            title = "Table 2. Descriptive statistics of white identity.",
                            type = "latex",
                            out = "figures/descriptive_statistics_context_2016.tex")

#descriptivesivdf12 <- anes12 %>%
#  filter(wid >= 4) %>%
#  select(relativeIncome, rboff, pboff, epast, efuture, news, ruralplurality, cdWhitePercent, gini, percentBelowPoverty, incomeInequality, , employment, raceResent, age, female, edu, pid, ideo)
#descriptivesivdf12 <- as.data.frame(descriptivesivdf12)
#descriptivesivdf12low <- anes12 %>%
#  filter(wid <= 3) %>%
#  select(relativeIncome, rboff, pboff, epast, efuture, news, ruralplurality, cdWhitePercent, gini, percentBelowPoverty, incomeInequality, , employment, raceResent, age, female, edu, pid, ideo)
#descriptivesivdf12low <- as.data.frame(descriptivesivdf12low)
#ivtable12highwid <- stargazer(descriptivesivdf12, 
#                            style = 'apsr',
#                            covariate.labels = c("Relative Income", "Retrospective - better off", "Prospective - better off", "Retrospective - economy", "Prospective - economy", "News", "Rural", "% White", "Gini", "% below poverty", "Income Inequality", "Employment Status", "Racial Resentment", "Age", "Female", "Education", "Party Identification", "Ideology"),
#                            notes = c("Source: 2012 American National Election Studies.", "Descriptive statistics of predictor variables among high white identifiers."),
#                            title = "Table 3. Descriptive statistics predictor variables.",
#                            type = "latex",
#                            out = "figures/descriptive_statistics_context_iv_high_2012.tex")
#ivtable12lowwid <- stargazer(descriptivesivdf12low, 
#                            style = 'apsr',
#                            covariate.labels = c("Relative Income", "Retrospective - better off", "Prospective - better off", "Retrospective - economy", "Prospective - economy", "News", "Rural", "% White", "Gini", "% below poverty", "Income Inequality", "Employment Status", "Racial Resentment", "Age", "Female", "Education", "Party Identification", "Ideology"),
#                            notes = c("Source: 2012 American National Election Studies.", "Descriptive statistics of predictor variables among high white identifiers."),
#                            title = "Table 4. Descriptive statistics of predictor variables.",
#                            type = "latex",
#                            out = "figures/descriptive_statistics_context_iv_low_2012.tex")
#descriptivesivdf16 <- anes16 %>%
#  filter(wid >= 4) %>%
#  select(relativeIncome, rboff, pboff, epast, efuture, news, ruralplurality, cdWhitePercent, gini, percentBelowPoverty, incomeInequality, employment, getahead, raceResent, age, female, edu, pid, ideo, V161125)
#descriptivesivdf16 <- as.data.frame(descriptivesivdf16)
#descriptivesivdf16low <- anes16 %>%
#  filter(wid <= 3) %>%
#  select(relativeIncome, rboff, pboff, epast, efuture, news, ruralplurality, cdWhitePercent, gini, percentBelowPoverty, incomeInequality, employment, getahead, raceResent, age, female, edu, pid, ideo, V161125)
#descriptivesivdf16low <- as.data.frame(descriptivesivdf16low)
#ivtable16highwid <- stargazer(descriptivesivdf16, 
#                            style = 'apsr',
#                            covariate.labels = c("Relative Income", "Retrospective - better off", "Prospective - better off", "Retrospective - economy", "Prospective - economy", "News", "Rural", "% White", "Gini", "% below poverty", "Income Inequality", "Employment Status", "Opportunity to get ahead", "Racial Resentment", "Age", "Female", "Education", "Party Identification", "Ideology", "Disgust - Trump"),
#                            notes = c("Source: 2016 American National Election Studies.", "Descriptive statistics of predictor variables among high white identifiers."),
#                            title = "Table 5. Descriptive statistics predictor variables.",
#                            type = "latex",
#                            out = "figures/descriptive_statistics_context_iv_high_2016.tex")
#ivtable16lowwid <- stargazer(descriptivesivdf16low, 
#                            style = 'apsr',
#                            covariate.labels = c("Relative Income", "Retrospective - better off", "Prospective - better off", "Retrospective - economy", "Prospective - economy", "News", "Rural", "% White", "Gini", "% below poverty", "Income Inequality", "Employment Status", "Opportunity to get ahead", "Racial Resentment", "Age", "Female", "Education", "Party Identification", "Ideology", "Disgust - Trump"),
#                            notes = c("Source: 2016 American National Election Studies.", "Descriptive statistics of predictor variables among low white identifiers."),
#                            title = "Descriptive statistics predictor variables.",
#                            type = "latex",
#                            out = "figures/descriptive_statistics_context_iv_low_2016.tex")

keymodelstable <- stargazer(keymodel12, keymodel16, 
                            style = 'apsr',
                            notes = c("Source: 2012 and 2016 American National Election Studies.", "Coefficients from regression with random intercepts by congressional district.", "Standard errors in parentheses.", "* p < 0.05"),
                            title = "Effects of actual and percieved material status loss on predicting white identity adoption", 
                            dep.var.labels = "White Identity Importance",
                            covariate.labels = c("Relative Income", "Retrospective - better off", "Prospective - better off", "Income Inequality", "Education", "Employment", "Opportunity to get ahead", "Racial Resentment", "Age", "Female", "% White", "Gini", "% below poverty", "Party Identification", "Ideology", "Disgust - Trump"),
                            notes.append = FALSE, 
                            star.cutoffs = c(0.05),
                            column.labels = c("2012", "2016"),
                            model.numbers = FALSE,
                            add.lines = list(c("Num. groups: District", "407", "399"), 
                                            c("Variance: District(Intercept)", "0.01", "0.02"),
                                            c("Variance: Residual", "1.58", "1.67")),
                            type = "latex", 
                            out = "figures/context_key_model_draft2.tex")
alternativemodelstable <- stargazer(alternative12, alternative16, 
                            style = 'apsr',
                            notes = c("Source: 2012 and 2016 American National Election Studies.", "Coefficients from regression with random intercepts by congressional district.", "Standard errors in parentheses.", "* p < 0.05"),
                            title = "Effects of actual and percieved material status loss on predicting white identity adoption", 
                            dep.var.labels = "White Identity Importance",
                            covariate.labels = c("Relative Income", "Retrospective - better off", "Prospective - better off", "Prospective - economy", "Retrospective - economy", "Income Inequality", "Education", "Employment", "Opportunity to get ahead", "Racial Resentment", "Age", "Female", "% white", "Gini", "% below poverty", "Party Identification", "Ideology", "Disgust - Trump"),
                            notes.append = FALSE, 
                            star.cutoffs = c(0.05),
                            column.labels = c("2012", "2016"),
                            model.numbers = FALSE,
                            add.lines = list(c("Num. groups: District", "407", "399"), 
                                            c("Variance: District(Intercept)", "0.01", "0.03"),
                                            c("Variance: Residual", "1.58", "1.65")),
                            type = "latex", 
                            out = "figures/context_alternative_model_draft2.tex")
alternativemodels2table <- stargazer(alternative212, alternative216, 
                            style = 'apsr',
                            notes = c("Source: 2012 and 2016 American National Election Studies.", "Coefficients from regression with random intercepts by congressional district.", "Standard errors in parentheses.", "* p < 0.05"),
                            title = "Effects of actual and percieved material status loss on predicting white identity adoption", 
                            dep.var.labels = "White Identity Importance",
                            covariate.labels = c("Relative Income", "Retrospective - better off", "Prospective - better off", "News", "Income Inequality", "Education", "Employment", "Opportunity to get ahead", "Racial Resentment", "Age", "Female", "% white", "Gini", "% below poverty", "Party Identification", "Ideology", "Disgust - Trump"),
                            notes.append = FALSE, 
                            star.cutoffs = c(0.05),
                            column.labels = c("2012", "2016"),
                            model.numbers = FALSE,
                            add.lines = list(c("Num. groups: District", "407", "399"), 
                                            c("Variance: District(Intercept)", "0.01", "0.02"),
                                            c("Variance: Residual", "1.58", "1.67")),
                            type = "latex", 
                            out = "figures/context_alternative_model_2_draft2.tex")
ruraltable <- stargazer(ruralmodel12, ruralmodel16, 
                            style = 'apsr',
                            notes = c("Source: 2012 and 2016 American National Election Studies.", "Coefficients from regression with random intercepts by congressional district.", "Standard errors in parentheses.", "* p < 0.05"),
                            title = "Effects of actual and percieved material status loss on predicting white identity adoption", 
                            dep.var.labels = "White Identity Importance",
                            covariate.labels = c("Relative Income", "Retrospective - better off", "Prospective - better off", "Income Inequality", "Education", "Employment", "Opportunity to get ahead", "Racial Resentment", "Rural", "Age", "Female", "% white", "Gini", "% below poverty", "Party Identification", "Ideology", "Disgust - Trump"),
                            notes.append = FALSE, 
                            star.cutoffs = c(0.05),
                            column.labels = c("2012", "2016"),
                            model.numbers = FALSE,
                            add.lines = list(c("Num. groups: District", "407", "399"), 
                                            c("Variance: District(Intercept)", "0.01", "0.02"),
                                            c("Variance: Residual", "1.58", "1.67")),
                            type = "latex", 
                            out = "figures/context_rural_model_draft2.tex")
  ### Figures ###

#### Proposed Model in settling-on-models Memo ####
#proposedmodel12 <- lmer(wid ~ relativeIncome + rboff + raceResent + ruralplurality + cdWhitePercent + gini + percentBelowPoverty + pid + ideo + (1|district), 
#                  data = anes12)
#proposedmodel16 <- lmer(wid ~ relativeIncome + rboff + raceResent + ruralplurality + cdWhitePercent + gini + percentBelowPoverty + pid + ideo + V161125 + (1|district),
#                    data = anes16)
#
#proposedmodels <- stargazer(proposedmodel12, proposedmodel16,
#                            style = 'apsr',
#                            notes = c('Source: 2012 and 2016 American National Election Studies.', 'Coefficients from regression with random intercepts by congressional district.', 'Standard errors in parenthases.', '* p < 0.05'),
#                            title = "Effects of actual and percieved material status loss on predicting adopting a white identity",
#                            dep.var.labels = "White Identity Importance",
#                            covariate.labels = c("Relative Income", "Retrospective - Better Off", "Racial Resentment", 
#                            "Percent of District White", "Rurality", "Gini Coefficient", "Percent Below Poverty", "Party Identification", "Ideology", "Disgust - Trump"),
#                            notes.append = FALSE,
#                            star.cutoffs = c(0.05),
#                            column.labels = c("2012", "2016"),
#                            model.numbers = FALSE,
#                            add.lines = list(c("Num. groups: District", "407", "395"), 
#                                        c("Variance: District(Intercept)", "0.02", "0.02"),
#                                        c("Variance: Residual", "1.61", "1.72")),
#                            type = "latex",
#                            out = "figures/proposed-models.tex")
#### The model vortex ####
#urbanresent <- lm(wid ~ relativeIncome + ruralplurality + relativeIncome*ruralplurality + cdWhitePercent + percentBelowPoverty + unpast + pid + ideo,
#                data = anes16)
#urbanresent.pred.probs <- ggpredict(urbanresent, terms = c("relativeIncome", "ruralplurality"))
#urbanresent.plot <- plot(urbanresent.pred.probs)

#urbanresent <- lmer(wid ~ relativeIncome + ruralpercent + cdWhitePercent + percentBelowPoverty + unpast + pid + ideo + (1|district),
#              data =anes16)
#### Racial Resentment and not white identity? ####
#raceresent12 <- lm(raceResent ~ relativeIncome + cdWhitePercent + percentBelowPoverty + ruralpercent + unpast + pid + ideo, 
#                data = anes12)
#screenreg(raceresent12)
#raceresent12cd <- lmer(wid ~ raceResent*cdWhitePercent + relativeIncome + percentBelowPoverty + ruralpercent + unpast + pid + ideo +(raceResent|district),
#                    data = anes12)
#screenreg(raceresent12cd)
#raceresent16 <- lm(raceResent ~ relativeIncome + cdWhitePercent + percentBelowPoverty + ruralpercent + unpast + pid + ideo, 
#                  data = anes16)
#screenreg(raceresent16)
#raceresent16cd <- lmer(wid ~ raceResent * cdWhitePercent + relativeIncome + percentBelowPoverty + ruralpercent + unpast + pid + ideo + (raceResent|district),
#                    data = anes16)
#screenreg(raceresent16cd)

#### White Identity and Sociotropics ####
  ### OLS MODEL###
#ols12 <- lm(wid ~ relativeIncome * cdWhitePercent + percentBelowPoverty + pboff + rboff + epast + efuture + unpast + pid + ideo,
#data = anes12)
#summary(ols12)
  ## Checking model assumptions ##
#ols12.res <- residuals(ols12)
#plot(fitted(ols12), ols12.res)
#abline(0,0)
#qqnorm(ols12.res)
#qqline(ols12.res)
#plot(density(ols12.res))

#ols16 <- lm(wid ~ cngIncome * cngRace + percentBelowPoverty + pboff + rboff + epast + efuture + unpast + pid + ideo + V161125,
#data = anes16)
#summary(ols16)
  ## checking model assumptions ##
#ols16.res <- residuals(ols16)
#plot(fitted(ols16), ols16.res)
#abline(0,0)
#qqnorm(ols16.res)
#qqline(ols16.res)
#plot(density(ols16.res))


#### Linear Mixed Effects Model ####
  ### 2012 ###
    ## LMM ##
#intercept12 <- lmer(wid ~ relativeIncome * cdWhitePercent + percentBelowPoverty + pboff + rboff + epast + efuture + unpast + pid + ideo + (1|district),
#                data = anes12)
#summary(intercept12)
#screenreg(intercept12)
  ### 2016 ###
    ## LMM ##
#intercept16 <- lmer(wid ~ cngIncome * cngRace + percentBelowPoverty + pboff + rboff + epast + efuture + unpast + pid + ideo + V161125 + (1|district),
#data = anes16)
#summary(intercept16)
#screenreg(intercept16)
#    ## Bayesian LMM ##
#      # Selecting priors # - Can just use a prior predictive check
#anes12priors <- anes12 %>%
#    dplyr::select(wid, relativeIncome, cdWhitePercent, percentBelowPoverty, pboff, rboff, epast, efuture, unpast, pid, ideo, district)
#anes12priorstable <- stargazer(anes12priors, type = 'text', summary.stat = c("n", "mean", "sd"))
#dvsigma <- (1.303^2)
#print(dvsigma)

#interceptsigma <- (10.399^2)
#print(interceptsigma)

#stan12 <- stan_lmer(formula = wid ~ relativeIncome + cdWhitePercent + percentBelowPoverty + pboff + rboff + epast + efuture + unpast + pid + ideo + (1 + relativeIncome + cdWhitePercent | district), 
#                data = anes12)
  
  ### 2016 ###
    
#### Draft 1 Models - totally incorrect package####
#  ### Differences in income and race ###
#ols12gini <- plm(wid ~ cngIncome * cngRace + gini + pboff + rboff + epast + efuture + unpast + pid + ideo, 
#             data = anes12,
#             index = "district",
#             model = "between")
#summary(ols12gini)
#
#
#ols16gini <- plm(wid ~ cngIncome * cngRace + gini + pboff + rboff + epast + efuture + unpast + pid + ideo + V161125, 
#            data = anes16,
#            index = "district",
#            model = "between")
#summary(ols16gini)
#
#  ### With Poverty Level ###
#ols12poverty <- plm(wid ~ cngIncome * cngRace + percentBelowPoverty + pboff + rboff + epast + efuture + unpast + pid + ideo, 
#             data = anes12,
#             index = "district",
#             model = "between")
#summary(ols12)
#
#ols16poverty <- plm(wid ~ cngIncome * cngRace + percentBelowPoverty + pboff + rboff + epast + efuture + unpast + pid + ideo + V161125, 
#             data = anes16,
#             index = "district",
#             model = "between")
#summary(ols16)
#
#  ### Create Table ###
#
#contextTable <- stargazer(ols12gini, ols16gini,ols12poverty,ols16poverty, 
#                          type = 'latex',
#                          keep.stat = c('adj.rsq', 'n'),
#                          style = 'apsr',
#                          notes = c('Source: 2012 and 2016 American National Election Studies.', 'Ordinary Least Squares with Congressional District Random Effects Coefficients.','Standard. Errors in parentheses.','* p <0.05'),
#                          title = '2012 and 2016 Effects of Context on assuming white political identity',
#                          covariate.labels = c("delta Income", "delta Race","Gini Coefficient","% Below Poverty", "Prospective Better Off", "Retrospective Better Off", "Economy - Past", "Economy - Future", "Unemployed in Past", "Partisanship", "Ideology", "Disgust with Trump", "delta Income x delta Race"),
#                          dep.var.labels = 'White Identity Importance',
#                          notes.append = FALSE,
#                          star.cutoffs = c(0.05),
#                          out = 'figures/2012-2016-context-table.tex')
