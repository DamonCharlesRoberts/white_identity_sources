#### Title: Primary Analyses - White Identity Origins Project ####

#### Notes: #####
  ### Description: CFA analysis, regression and logit analysis and graph creation with predicted probability estimation ###

#### Setup ####
 ### Note to self: Uncomment below if need to source any functions from data cleaning process. Should just run those scripts nativley, though.
 ### source('code/setup-file.R')
 ### source('code/cleaning-2012-anes.R')
 ### source('code/cleaning-2016-anes.R')
{
  here::here()
  library(haven) # read dta files
  library(tidyverse) # wrapper library for tidyverse packages
  library(dplyr) # make sure dplyr is not masked
  library(tidylog) # help with any data manipulation - sends messages making sure any dplyr functions are doing what I think they should.
  library(lavaan) # for CFA
  library(stargazer) # for tables
  library(semTable) # for CFA outputs - convert to latex table
  library(MASS) # for polr function for ordinal logit
  library(reshape) # for `melt` to get pred. probs
  library(ggpubr) # for `ggarrange` to make figures
}

 ### Read in data
anes12 <- read_dta('data/anes-2012/anes-2012-updated.dta')
anes12 <- as_factor(anes12) %>% # need for any logit model
  dplyr::filter(!is.na(pboff) & !is.na(rboff) & !is.na(epast) & !is.na(efuture) & !is.na(unpast) & !is.na(ecjob) & !is.na(ecfamily) & !is.na(tradbreak) & !is.na(govbias) & !is.na(toofar) & !is.na(inflwhite) & !is.na(whitediscrim) & !is.na(raceResent) & !is.na(perwhite10) & !is.na(pid) & !is.na(presapprove)) # listwise deletion for missing vals - ensure models have same number of obs. for robustenss comparisons
anes16 <- read_dta('data/anes-2016/anes-2016-updated.dta')
anes16 <- as_factor(anes16) %>% # need for any logit model
  dplyr::filter(!is.na(pboff) & !is.na(rboff) & !is.na(epast) & !is.na(efuture) & !is.na(unpast) & !is.na(ecjob) & !is.na(ecfamily) & !is.na(tradbreak) & !is.na(govbias) & !is.na(inflwhite) & !is.na(whitediscrim) & !is.na(raceResent) & !is.na(perwhite10) & !is.na(pid) & !is.na(presapprove) & !is.na(trumpft)) # listwise deletion for missing vals - ensure models have same number of obs. for robustness comparisons

#### Determine Factor Loadings - CFA ####

mod12 <- '
##Set latent metric to unit variance
fec12 =~ NA*pboff + rboff + epast + efuture + unpast + ecjob + ecfamily
fec12 ~~ 1*fec12

fper12 =~ NA*pocare + offwork + tradbreak + govbias + toofar + inflwhite + whitediscrim
fper12 ~~ 1*fper12
'
mod12_cfa <- cfa(mod12, data = anes12)
summary(mod12_cfa)

mod12_cfa_fit <- rbind(fitMeasures(mod12_cfa)[c('srmr','rmsea','rmsea.ci.lower','rmsea.ci.upper','cfi','tli')])
mod12_cfa_fit

semTable(mod12_cfa, columns = c('estse', 'p'), paramSets = c('loadings', 'intercepts', 'residualvariances', 'latentcovariances'), fits = c('rmsea', 'srmr', 'cfi', 'tli'), type = 'latex', file = file.path('figures/factor_loadings.tex'), table.float = FALSE, caption = "Factor Loadings of Economic and Personal Factors", label = 'tab:FLoad', longtable = TRUE)


mod16 <- '
##Set latent metric to unit variance
fec16 =~ NA*pboff + rboff + epast + efuture + unpast + ecjob + ecfamily
fec16 ~~ 1*fec16

fper16 =~ NA*pocare  + tradbreak + govbias  + inflwhite + whitediscrim
fper16 ~~ 1*fper16
'

mod16_cfa <- cfa(mod16, data = anes16)
summary(mod12_cfa)

mod16_cfa_fit <- rbind(fitMeasures(mod16_cfa)[c('srmr','rmsea','rmsea.ci.lower','rmsea.ci.upper','cfi','tli')])
mod16_cfa_fit

semTable(mod16_cfa, columns = c('estse', 'p'), paramSets = c('loadings', 'intercepts', 'residualvariances', 'latentcovariances'), fits = c('rmsea', 'srmr', 'cfi', 'tli'), type = 'latex', file = file.path('figures/factor_loadings16.tex'), table.float = TRUE, caption = "Factor Loadings of Economic and Personal Factors", label = 'tab:FLoad', longtable = TRUE)


#### 2012 Ordered Logit Analyses ####

log.12.1 <- polr(wid ~ pboff + rboff + epast + efuture + unpast + ecjob + ecfamily  + tradbreak + govbias + toofar + inflwhite + whitediscrim + raceResent +perwhite10 + pid + presapprove, data = anes12, weights = weight_full, Hess = TRUE, method = 'logistic')

log.12.econ <- polr(wid ~ pboff + rboff + epast + efuture + ecjob + pid + presapprove, data = anes12, weights = weight_full, Hess = TRUE, method = 'logistic')

log.12.personal <- polr(wid ~ unpast + ecfamily + tradbreak + govbias + toofar + inflwhite + whitediscrim + raceResent + pid + presapprove, data = anes12, weights = weight_full, Hess = TRUE, method = 'logistic')

log.12.context <- polr(wid ~ pboff + rboff + epast + efuture + unpast + ecjob + ecfamily  + tradbreak + govbias + toofar + inflwhite + whitediscrim + raceResent + pid + presapprove, data = anes12, weights = weight_full, Hess = TRUE, method = 'logistic')

log.12.1
stargazer(log.12.personal, type = 'text')
stargazer(log.12.1, type = 'text')
stargazer(log.12.econ, log.12.personal, log.12.context, log.12.1,
          keep.stat = c('adj.rsq','n'), 
          add.lines = list(c('BIC', 
                             round(BIC(log.12.econ),1), 
                             round(BIC(log.12.personal),1), 
                             round(BIC(log.12.context),1), 
                             round(BIC(log.12.1)))), 
          style = 'apsr',
          notes = c('Source: 2012 American National Election Study.', 'Ordered Logit Coefficients. Std. Errors in parentheses.', 'Analyses include full sample weights calculated by the 2012 ANES.', '* p < 0.05'),
          title = '2012 Effects of economic, personal, and contextual factors on assuming white political identity',
          covariate.labels = c('Prospective Better Off(-)', 'Retrospective Better Off(+)', 'Economy-Retrospective(-)', 'Economy-Prospective(-)', 'Unemployment Worse(-)', 'Know of Job Loss(+)', 'Family Job Loss(+)', 'Break Traditions(+)','Gov. Biased(+)','Racial Equality - Too Far(+)', 'White Influence(-)','White Discriminated Against(+)', 'Racial Resentment - 4 Item(+)','2010 % White (State)(-)', 'Party ID', 'Presidential Approval'),
          dep.var.labels = 'White Identity Importance',
          notes.append = FALSE, 
          star.cutoffs = c(0.05),
          type = 'latex', out = 'figures/2012-ologit.tex')



### 2016 Ordered Logit Analyses ###
log.16.1 <- polr(as.factor(wid) ~ pboff + rboff + epast + efuture + unpast + ecjob + ecfamily  + tradbreak + govbias + inflwhite + whitediscrim + raceResent + perwhite10 + pid + presapprove, data = anes16, weights = V160102, Hess = TRUE, method = 'logistic')

log.16.econ <- polr(as.factor(wid) ~ pboff + rboff + epast + efuture + ecjob + pid + presapprove, weights = V160102, Hess = TRUE, data = anes16, method = 'logistic')

log.16.personal <- polr(as.factor(wid) ~ unpast + ecfamily + tradbreak + govbias + inflwhite + whitediscrim + raceResent + pid + presapprove, data = anes16, weights = V160102, Hess = TRUE, method = 'logistic')

log.16.context <- polr(as.factor(wid) ~ pboff + rboff + epast + efuture + unpast + ecjob + ecfamily  + tradbreak + govbias + inflwhite + whitediscrim + raceResent + pid + presapprove, data = anes16, weights = V160102, Hess = TRUE, method = 'logistic')


stargazer(log.16.econ, log.16.personal, log.16.context, log.16.1,
          keep.stat = c('adj.rsq','n'), 
          add.lines = list(c('BIC', 
                             round(BIC(log.16.econ),1), 
                             round(BIC(log.16.personal),1), 
                             round(BIC(log.16.context),1), 
                             round(BIC(log.16.1)))), 
          style = 'apsr',
          notes = c('Data Source: 2016 American National Election Study.', 'Notes: Ordered Logit Coefficients. Std. Errors in parentheses.', 'Analyses include full sample weights calculated by the 2016 ANES.', '* p < 0.05'),
          title = '2016 Effects of economic, personal, and contextual factors on assuming white political identity',
          covariate.labels = c('Prospective Better Off(-)', 'Retrospective Better Off(+)', 'Economy-Retrospective(-)', 'Economy-Prospective(-)', 'Unemployment Worse(+)', 'Know of Job Loss(+)',  'Family Job Loss(+)', 'Break Traditions(+)','Gov. Biased(+)', 'White Influence(-)','White Discriminated Against(+)', 'Racial Resentment - 4 Item(+)','2010 % White (State)(-)', 'Party ID', 'Presidential Approval'),
          dep.var.labels = 'White Identity Importance',
          notes.append = FALSE, 
          star.cutoffs = c(0.05),
          type = 'latex', out = 'figures/2016-ologit.tex')

  ### Including Trump Feeling Thermometer ###
log.16.trumpft <- polr(as.factor(wid) ~ pboff + rboff + epast + efuture + unpast + ecjob + ecfamily  + tradbreak + govbias + inflwhite + whitediscrim + raceResent + perwhite10 + pid + presapprove + trumpft, data = anes16, weights = V160102, Hess = TRUE, method = 'logistic')

stargazer(log.16.trumpft,
          keep.stat = c('adj.rsq','n'), 
          add.lines = list(c('BIC', 
                             round(BIC(log.16.trumpft),1))), 
          style = 'apsr',
          notes = c('Data Source: 2016 American National Election Study.', 'Notes: Ordered Logit Coefficients. Std. Errors in parentheses.', 'Analyses include full sample weights calculated by the 2016 ANES.', '* p < 0.05'),
          title = '2016 Effects of economic, personal, and contextual factors on assuming white political identity',
          covariate.labels = c('Prospective Better Off(-)', 'Retrospective Better Off(+)', 'Economy-Retrospective(-)', 'Economy-Prospective(-)', 'Unemployment Worse(+)', 'Know of Job Loss(+)',  'Family Job Loss(+)', 'Break Traditions(+)','Gov. Biased(+)', 'White Influence(-)','White Discriminated Against(+)', 'Racial Resentment - 4 Item(+)','2010 % White (State)(-)', 'Party ID', 'Presidential Approval','Trump Feeling Thermometer'),
          dep.var.labels = 'White Identity Importance',
          notes.append = FALSE, 
          star.cutoffs = c(0.05),
          type = 'latex', out = 'figures/2016-ologit-trumpft.tex')

#### OLS - As Robustness Check ####

ols.12.1 <- lm(as.numeric(wid) ~ pboff + rboff + epast + efuture + unpast + ecjob + ecfamily  + tradbreak + govbias + toofar + inflwhite + whitediscrim + raceResent +perwhite10 + pid + presapprove, data = anes12, weights = weight_full)

ols.16.1 <- lm(as.numeric(wid) ~ pboff + rboff + epast + efuture + unpast + ecjob + ecfamily  + tradbreak + govbias + inflwhite + whitediscrim + raceResent + perwhite10 + pid + presapprove, data = anes16, weights = V160102)

stargazer(ols.12.1, ols.16.1,
          keep.stat = c('adj.rsq','n'), 
          style = 'apsr',
          notes = c('Data Source: 2012 and 2016 American National Election Studies.', 'Notes: Ordinary Least Squares Coefficients. Std. Errors in parentheses.', 'Analyses include full sample weights calculated by the 2012 and 2016 ANES, respectively.', '* p < 0.05'),
          title = 'Alternative Model Specification for 2012 and 2016 Full Models',
          covariate.labels = c('Prospective Better Off(-)', 'Retrospective Better Off(+)', 'Economy-Retrospective(-)', 'Economy-Prospective(-)', 'Unemployment Worse(-)', 'Know of Job Loss(+)', 'Family Job Loss(+)', 'Break Traditions(+)','Gov. Biased(+)','Racial Equality - Too Far(+)', 'White Influence(-)','White Discriminated Against(+)', 'Racial Resentment - 4 Item(+)','2010 % White (State)(-)', 'Party ID', 'Presidential Approval'),
          dep.var.labels = 'White Identity Importance',
          notes.append = FALSE, 
          star.cutoffs = c(0.05),
          type = 'latex', out = 'figures/robust-ols.tex')


#### Predicted Probabilities - 2012 ####

  ### First, set all variables to their mean - except the one calculating the predicted probabilities for.
pred.12.rboff <- data.frame(pboff = mean(anes12$pboff), 
                            epast = mean(anes12$epast),
                            efuture = mean(anes12$efuture),
                            unpast = mean(anes12$unpast),
                            ecjob = mean(anes12$ecjob),
                            ecfamily = mean(anes12$ecfamily), 
                            tradbreak = mean(anes12$tradbreak), 
                            govbias = mean(anes12$govbias),
                            toofar = mean(anes12$toofar),
                            inflwhite = mean(anes12$inflwhite),
                            whitediscrim = mean(anes12$whitediscrim),
                            raceResent = mean(anes12$raceResent),
                            perwhite10 = mean(anes12$perwhite10),
                            pid = mean(anes12$pid),
                            presapprove = mean(anes12$presapprove),
                            rboff = seq(1,5,1))

  ### Make the Predicted Probabilities for the variable of interest
prob.12.rboff <- cbind(pred.12.rboff, predict(log.12.1, pred.12.rboff, type = 'probs'))
  ### "Melt" the dataframe to have a predicted probability per level of analysis
m.prob.12.rboff <- melt(prob.12.rboff, id.vars = c('pboff', 'rboff', 'epast', 'efuture', 'unpast', 'ecjob', 'ecfamily', 'tradbreak','govbias','toofar','inflwhite','whitediscrim','raceResent','perwhite10','pid','presapprove'), variable.name = 'Level', value.name = 'Probability')

  ### Repeat for all variables of interest
pred.12.efuture <- data.frame(pboff = mean(anes12$pboff),
           rboff = mean(anes12$rboff),
           epast = mean(anes12$epast),
           unpast = mean(anes12$unpast),
           ecjob = mean(anes12$ecjob),
           ecfamily = mean(anes12$ecfamily), 
           tradbreak = mean(anes12$tradbreak), 
           govbias = mean(anes12$govbias),
           toofar = mean(anes12$toofar),
           inflwhite = mean(anes12$inflwhite),
           whitediscrim = mean(anes12$whitediscrim),
           raceResent = mean(anes12$raceResent),
           perwhite10 = mean(anes12$perwhite10),
           pid = mean(anes12$pid),
           presapprove = mean(anes12$presapprove),
           efuture = seq(1,5,1))

prob.12.efuture <- cbind(pred.12.efuture, predict(log.12.1, pred.12.efuture, type = 'probs'))
m.prob.12.efuture<- melt(prob.12.efuture, id.vars = c('pboff', 'rboff', 'epast', 'efuture', 'unpast', 'ecjob', 'ecfamily', 'tradbreak','govbias','toofar','inflwhite','whitediscrim','raceResent','perwhite10','pid','presapprove'), variable.name = 'Level', value.name = 'Probability')

pred.12.unpast <- data.frame(pboff = mean(anes12$pboff),
           rboff = mean(anes12$rboff),
           epast = mean(anes12$epast),
           efuture = mean(anes12$efuture),
           ecjob = mean(anes12$ecjob),
           ecfamily = mean(anes12$ecfamily), 
           tradbreak = mean(anes12$tradbreak), 
           govbias = mean(anes12$govbias),
           toofar = mean(anes12$toofar),
           inflwhite = mean(anes12$inflwhite),
           whitediscrim = mean(anes12$whitediscrim),
           raceResent = mean(anes12$raceResent),
           perwhite10 = mean(anes12$perwhite10),
           pid = mean(anes12$pid),
           presapprove = mean(anes12$presapprove),
           unpast = seq(1,5,1))
prob.12.unpast <- cbind(pred.12.unpast, predict(log.12.1, pred.12.unpast, type = 'probs'))
m.prob.12.unpast <- melt(prob.12.unpast, id.vars = c('pboff', 'rboff', 'epast', 'efuture', 'unpast', 'ecjob', 'ecfamily', 'tradbreak','govbias','toofar','inflwhite','whitediscrim','raceResent','perwhite10','pid','presapprove'), variable.name = 'Level', value.name = 'Probability')

pred.12.ecfamily <- data.frame(pboff = mean(anes12$pboff),
           rboff = mean(anes12$rboff),
           epast = mean(anes12$epast),
           efuture = mean(anes12$efuture),
           unpast = mean(anes12$unpast),
           ecjob = mean(anes12$ecjob),
           tradbreak = mean(anes12$tradbreak), 
           govbias = mean(anes12$govbias),
           toofar = mean(anes12$toofar),
           inflwhite = mean(anes12$inflwhite),
           whitediscrim = mean(anes12$whitediscrim),
           raceResent = mean(anes12$raceResent),
           perwhite10 = mean(anes12$perwhite10),
           pid = mean(anes12$pid),
           presapprove = mean(anes12$presapprove),
           ecfamily = seq(1,5,1))
prob.12.ecfamily <- cbind(pred.12.ecfamily, predict(log.12.1, pred.12.ecfamily, type = 'probs'))
m.prob.12.ecfamily <- melt(prob.12.ecfamily, id.vars = c('pboff', 'rboff', 'epast', 'efuture', 'unpast', 'ecjob', 'ecfamily', 'tradbreak','govbias','toofar','inflwhite','whitediscrim','raceResent','perwhite10','pid','presapprove'), variable.name = 'Level', value.name = 'Probability')

pred.12.tradbreak <- data.frame(pboff = mean(anes12$pboff),
           rboff = mean(anes12$rboff),
           epast = mean(anes12$epast),
           efuture = mean(anes12$efuture),
           unpast = mean(anes12$unpast),
           ecjob = mean(anes12$ecjob),
           ecfamily = mean(anes12$ecfamily), 
           govbias = mean(anes12$govbias),
           toofar = mean(anes12$toofar),
           inflwhite = mean(anes12$inflwhite),
           whitediscrim = mean(anes12$whitediscrim),
           raceResent = mean(anes12$raceResent),
           perwhite10 = mean(anes12$perwhite10),
           pid = mean(anes12$pid),
           presapprove = mean(anes12$presapprove),
           tradbreak = seq(1,5,1))
prob.12.tradbreak <- cbind(pred.12.tradbreak, predict(log.12.1, pred.12.tradbreak, type = 'probs'))
m.prob.12.tradbreak <- melt(prob.12.tradbreak, id.vars = c('pboff', 'rboff', 'epast', 'efuture', 'unpast', 'ecjob', 'ecfamily', 'tradbreak','govbias','toofar','inflwhite','whitediscrim','raceResent','perwhite10','pid','presapprove'), variable.name = 'Level', value.name = 'Probability')

pred.12.govbias <- data.frame(pboff = mean(anes12$pboff),
           rboff = mean(anes12$rboff),
           epast = mean(anes12$epast),
           efuture = mean(anes12$efuture),
           unpast = mean(anes12$unpast),
           ecjob = mean(anes12$ecjob),
           ecfamily = mean(anes12$ecfamily), 
           tradbreak = mean(anes12$tradbreak),
           toofar = mean(anes12$toofar),
           inflwhite = mean(anes12$inflwhite),
           whitediscrim = mean(anes12$whitediscrim),
           raceResent = mean(anes12$raceResent),
           perwhite10 = mean(anes12$perwhite10),
           pid = mean(anes12$pid),
           presapprove = mean(anes12$presapprove),
           govbias = seq(-1, 1, 1))
prob.12.govbias <- cbind(pred.12.govbias, predict(log.12.1, pred.12.govbias, type = 'probs'))
m.prob.12.govbias <- melt(prob.12.govbias, id.vars = c('pboff', 'rboff', 'epast', 'efuture', 'unpast', 'ecjob', 'ecfamily', 'tradbreak','govbias','toofar','inflwhite','whitediscrim','raceResent','perwhite10','pid','presapprove'), variable.name = 'Level', value.name = 'Probability')

pred.12.inflwhite <- data.frame(pboff = mean(anes12$pboff),
           rboff = mean(anes12$rboff),
           epast = mean(anes12$epast),
           efuture = mean(anes12$efuture),
           unpast = mean(anes12$unpast),
           ecjob = mean(anes12$ecjob),
           ecfamily = mean(anes12$ecfamily), 
           tradbreak = mean(anes12$tradbreak), 
           govbias = mean(anes12$govbias),
           toofar = mean(anes12$toofar),
           whitediscrim = mean(anes12$whitediscrim),
           raceResent = mean(anes12$raceResent),
           perwhite10 = mean(anes12$perwhite10),
           pid = mean(anes12$pid),
           presapprove = mean(anes12$presapprove),
           inflwhite = seq(-1,0,1))
prob.12.inflwhite <- cbind(pred.12.inflwhite, predict(log.12.1, pred.12.inflwhite, type = 'probs'))
m.prob.12.inflwhite <- melt(prob.12.inflwhite, id.vars = c('pboff', 'rboff', 'epast', 'efuture', 'unpast', 'ecjob', 'ecfamily', 'tradbreak','govbias','toofar','inflwhite','whitediscrim','raceResent','perwhite10','pid','presapprove'), variable.name = 'Level', value.name = 'Probability')

pred.12.raceResent <- data.frame(pboff = mean(anes12$pboff),
           rboff = mean(anes12$rboff),
           epast = mean(anes12$epast),
           efuture = mean(anes12$efuture),
           unpast = mean(anes12$unpast),
           ecjob = mean(anes12$ecjob),
           ecfamily = mean(anes12$ecfamily), 
           tradbreak = mean(anes12$tradbreak), 
           govbias = mean(anes12$govbias),
           toofar = mean(anes12$toofar),
           inflwhite = mean(anes12$inflwhite),
           whitediscrim = mean(anes12$whitediscrim),
           perwhite10 = mean(anes12$perwhite10),
           pid = mean(anes12$pid),
           presapprove = mean(anes12$presapprove),
           raceResent = seq(1,5,1))
prob.12.raceResent <- cbind(pred.12.raceResent, predict(log.12.1, pred.12.raceResent, type = 'probs'))
m.prob.12.raceResent <- melt(prob.12.raceResent, id.vars = c('pboff', 'rboff', 'epast', 'efuture', 'unpast', 'ecjob', 'ecfamily', 'tradbreak','govbias','toofar','inflwhite','whitediscrim','raceResent','perwhite10','pid','presapprove'), variable.name = 'Level', value.name = 'Probability')

pred.12.pid <- data.frame(pboff = mean(anes12$pboff),
           rboff = mean(anes12$rboff),
           epast = mean(anes12$epast),
           efuture = mean(anes12$efuture),
           unpast = mean(anes12$unpast),
           ecjob = mean(anes12$ecjob),
           ecfamily = mean(anes12$ecfamily), 
           tradbreak = mean(anes12$tradbreak), 
           govbias = mean(anes12$govbias),
           toofar = mean(anes12$toofar),
           inflwhite = mean(anes12$inflwhite),
           whitediscrim = mean(anes12$whitediscrim),
           raceResent = mean(anes12$raceResent),
           perwhite10 = mean(anes12$perwhite10),
           presapprove = mean(anes12$presapprove),
           pid = seq(1,7,1))
prob.12.pid <- cbind(pred.12.pid, predict(log.12.1, pred.12.pid, type = 'probs'))
m.prob.12.pid <- melt(prob.12.pid, id.vars = c("pboff", "rboff", "epast", "efuture", "unpast", "ecjob", "ecfamily", "tradbreak","govbias","toofar","inflwhite","whitediscrim","raceResent","perwhite10","pid","presapprove"), variable.name = "Level", value.name = "Probability")


  ### Create Graphs to present predicted probabilities for variables of interest
col_scale<-colorRampPalette(c("#FF0000","#228B22"))(6)
pred.prob.12.plot.rboff <- ggplot() +
  geom_line(data=  m.prob.12.rboff, aes(x = rboff, y = value, colour = variable), size = 1, linetype = 1) + 
  scale_color_grey() + 
  theme_minimal() +
  labs(colour = "White Identity", y = "Predicted Probability", x = "Retrospective - Better Off")
  
  

pred.prob.12.plot.efuture <- ggplot() +
  geom_line(data=  m.prob.12.efuture, aes(x = efuture, y = value, colour = variable), size = 1, linetype = 2) + 
  scale_color_grey() + 
  theme_minimal() + 
  labs(colour = "White Identity", y = "Predicted Probability", x = "Economy - Prospective")

pred.prob.12.plot.unpast <- ggplot() +
  geom_line(data=  m.prob.12.unpast, aes(x = unpast, y = value, colour = variable), size = 1, linetype = 3) + 
  scale_color_grey() + 
  theme_minimal() + 
  labs(colour = "White Identity", y = "Predicted Probability", x = "Unemployment Worse")
pred.prob.12.plot.ecfamily <- ggplot() +
  geom_line(data=  m.prob.12.ecfamily, aes(x = ecfamily, y = value, colour = variable), size = 1, linetype = 1) + 
  scale_color_grey() + 
  theme_minimal() + 
  labs(colour = "White Identity", y = "Predicted Probability", x = "Family Job Loss")
pred.prob.12.plot.tradbreak <- ggplot() +
  geom_line(data=  m.prob.12.tradbreak, aes(x = tradbreak, y = value, colour = variable), size = 1, linetype = 2) + 
  scale_color_grey() + 
  theme_minimal() +
  labs(colour = "White Identity", y = "Predicted Probability", x = "Break Traditions")
pred.prob.12.plot.govbias <- ggplot() +
  geom_line(data=  m.prob.12.govbias, aes(x = govbias, y = value, colour = variable), size = 1, linetype = 3) + 
  scale_color_grey() + 
  theme_minimal() +
  labs(colour = "White Identity", y = "Predicted Probability", x = "Government Bias")
pred.prob.12.plot.inflwhite <- ggplot() +
  geom_line(data=  m.prob.12.inflwhite, aes(x = inflwhite, y = value, colour = variable), size = 1, linetype = 4) + 
  scale_color_grey() + 
  theme_minimal() +
  labs(colour = "White Identity", y = "Predicted Probability", x = "White Influence")
pred.prob.12.plot.raceResent <- ggplot() +
  geom_line(data=  m.prob.12.raceResent, aes(x = raceResent, y = value, colour = variable), size = 1, linetype = 1) + 
  scale_color_grey() + 
  theme_minimal() +
  labs(colour = "White Identity", y = "Predicted Probability", x = "Racial Resentment")
pred.prob.12.plot.pid <- ggplot() +
  geom_line(data=  m.prob.12.pid, aes(x = pid, y = value, colour = variable), size = 1, linetype = 2) + 
  scale_color_grey() + 
  theme_minimal() +
  labs(colour = "White Identity", y = "Predicted Probability", x = "Party ID")
 
  ### Combine all predicted probability figures from above and put them in one big figure
pred.prob.12.plot <- ggarrange(pred.prob.12.plot.rboff, pred.prob.12.plot.efuture, pred.prob.12.plot.unpast,pred.prob.12.plot.ecfamily,pred.prob.12.plot.tradbreak,pred.prob.12.plot.govbias,pred.prob.12.plot.inflwhite,pred.prob.12.plot.raceResent,pred.prob.12.plot.pid, common.legend = TRUE, legend = "bottom")
  
    ## Facet each of the economic factor predicted probability graphs into one figure
pred.prob.12.plot.econ <- ggarrange(pred.prob.12.plot.rboff,pred.prob.12.plot.efuture, pred.prob.12.plot.unpast, common.legend = TRUE, legend = 'bottom')
    # Annotate the figure. Add titles, and notes
pred.prob.12.plot.econ.a <- annotate_figure(pred.prob.12.plot.econ,
                                            top = text_grob("Figure 2. Predicted Probabilities of Economic Factors on White Identity"),
                                            bottom = text_grob("Damon Roberts | Data Source: 2012 ANES"),
                                            fig.lab.face = "bold")
   # Save the graph
ggsave(plot = pred.prob.12.plot.econ.a, 'figures/2012-econ-predicted-probs.png')

   ## Facet each of the personal factor predicted probability graphs into one figure
pred.prob.12.plot.personal <- ggarrange(pred.prob.12.plot.ecfamily, pred.prob.12.plot.tradbreak, pred.prob.12.plot.govbias, pred.prob.12.plot.inflwhite, common.legend = TRUE, legend = 'bottom')
     # Annotate the figure
pred.prob.12.plot.personal.a <- annotate_figure(pred.prob.12.plot.personal,
                                                top = text_grob("Figure 3. Predicted Probabilities of Personal Factors on White Identity"),
                                                bottom = text_grob("Damon Roberts | Data Source: 2012 ANES"),
                                                fig.lab.face = "bold")
     # Save the figure
ggsave(plot=pred.prob.12.plot.personal.a, 'figures/2012-personal-predicted-probs.png')
  ## Facet each of the control item predicted probability graphs into one figure
pred.prob.12.plot.control <- ggarrange(pred.prob.12.plot.raceResent, pred.prob.12.plot.pid, common.legend = TRUE, legend = "bottom")
    # Annotate the figure
pred.prob.12.plot.control.a <- annotate_figure(pred.prob.12.plot.control,
                                               top = text_grob("Figure 4. Predicted Probabilities of Controls on White Identity"),
                                               bottom = text_grob("Damon Roberts | Data Source: 2012 ANES"),
                                               fig.lab.face = "bold")
    # Save the figure
ggsave(plot=pred.prob.12.plot.control.a, 'figures/2012-controls-predicted.probs.png')


#### Predicted Probabilities - 2016 ####
  ### First, set all variables to their mean - except the one calculating the predicted probabilities for.
pred.16.epast <- data.frame(pboff = mean(anes16$pboff),
                            rboff = mean(anes16$rboff),
                            efuture = mean(anes16$efuture),
                            unpast = mean(anes16$unpast),
                            ecjob = mean(anes16$ecjob),
                            ecfamily = mean(anes16$ecfamily), 
                            tradbreak = mean(anes16$tradbreak), 
                            govbias = mean(anes16$govbias),
                            inflwhite = mean(anes16$inflwhite),
                            whitediscrim = mean(anes16$whitediscrim),
                            raceResent = mean(anes16$raceResent),
                            perwhite10 = mean(anes16$perwhite10),
                            pid = mean(anes16$pid),
                            presapprove = mean(anes16$presapprove),
                            epast = seq(1,5,1)
)
  ### Make the Predicted Probabilities for the variable of interest
prob.16.epast <- cbind(pred.16.epast, predict(log.16.1, pred.16.epast, type = 'probs'))
  ### "Melt" the dataframe to have a predicted probability per level of analysis
m.prob.16.epast <- melt(prob.16.epast, id.vars = c("pboff", "rboff","epast","efuture","unpast","ecjob","ecfamily","tradbreak","govbias","inflwhite","whitediscrim","raceResent","perwhite10","pid","presapprove"), variable.name = "Level", value.name = "Probability")
pred.16.efuture <- data.frame(pboff = mean(anes16$pboff),
           rboff = mean(anes16$rboff),
           epast = mean(anes16$epast),
           unpast = mean(anes16$unpast),
           ecjob = mean(anes16$ecjob),
           ecfamily = mean(anes16$ecfamily), 
           tradbreak = mean(anes16$tradbreak), 
           govbias = mean(anes16$govbias),
           inflwhite = mean(anes16$inflwhite),
           whitediscrim = mean(anes16$whitediscrim),
           raceResent = mean(anes16$raceResent),
           perwhite10 = mean(anes16$perwhite10),
           pid = mean(anes16$pid),
           presapprove = mean(anes16$presapprove),
           efuture = seq(1,5,1)
)

  ### Repeat for all variables of interest
prob.16.efuture <- cbind(pred.16.efuture, predict(log.16.1, pred.16.efuture, type = 'probs'))
m.prob.16.efuture <- melt(prob.16.efuture, id.vars = c("pboff", "rboff","epast","efuture","unpast","ecjob","ecfamily","tradbreak","govbias","inflwhite","whitediscrim","raceResent","perwhite10","pid","presapprove"), variable.name = "Level", value.name = "Probability")
pred.16.tradbreak <- data.frame(pboff = mean(anes16$pboff),
           rboff = mean(anes16$rboff),
           epast = mean(anes16$epast),
           efuture = mean(anes16$efuture),
           unpast = mean(anes16$unpast),
           ecjob = mean(anes16$ecjob),
           ecfamily = mean(anes16$ecfamily),
           govbias = mean(anes16$govbias),
           inflwhite = mean(anes16$inflwhite),
           whitediscrim = mean(anes16$whitediscrim),
           raceResent = mean(anes16$raceResent),
           perwhite10 = mean(anes16$perwhite10),
           pid = mean(anes16$pid),
           presapprove = mean(anes16$presapprove),
           tradbreak = seq(1,5,1)
)
prob.16.tradbreak<- cbind(pred.16.tradbreak, predict(log.16.1, pred.16.tradbreak, type = 'probs'))
m.prob.16.tradbreak <- melt(prob.16.tradbreak, id.vars = c("pboff", "rboff","epast","efuture","unpast","ecjob","ecfamily","tradbreak","govbias","inflwhite","whitediscrim","raceResent","perwhite10","pid","presapprove"), variable.name = "Level", value.name = "Probability")
pred.16.inflwhite <- data.frame(pboff = mean(anes16$pboff),
           rboff = mean(anes16$rboff),
           epast = mean(anes16$epast),
           efuture = mean(anes16$efuture),
           unpast = mean(anes16$unpast),
           ecjob = mean(anes16$ecjob),
           ecfamily = mean(anes16$ecfamily), 
           tradbreak = mean(anes16$tradbreak), 
           govbias = mean(anes16$govbias),
           whitediscrim = mean(anes16$whitediscrim),
           raceResent = mean(anes16$raceResent),
           perwhite10 = mean(anes16$perwhite10),
           pid = mean(anes16$pid),
           presapprove = mean(anes16$presapprove),
           inflwhite = seq(-1,1,1)
)
prob.16.inflwhite <- cbind(pred.16.inflwhite, predict(log.16.1, pred.16.inflwhite, type = 'probs'))
m.prob.16.inflwhite <- melt(prob.16.inflwhite, id.vars = c("pboff", "rboff","epast","efuture","unpast","ecjob","ecfamily","tradbreak","govbias","inflwhite","whitediscrim","raceResent","perwhite10","pid","presapprove"), variable.name = "Level", value.name = "Probability")
pred.16.raceResent <- data.frame(pboff = mean(anes16$pboff),
           rboff = mean(anes16$rboff),
           epast = mean(anes16$epast),
           efuture = mean(anes16$efuture),
           unpast = mean(anes16$unpast),
           ecjob = mean(anes16$ecjob),
           ecfamily = mean(anes16$ecfamily), 
           tradbreak = mean(anes16$tradbreak), 
           govbias = mean(anes16$govbias),
           inflwhite = mean(anes16$inflwhite),
           whitediscrim = mean(anes16$whitediscrim),
           perwhite10 = mean(anes16$perwhite10),
           pid = mean(anes16$pid),
           presapprove = mean(anes16$presapprove),
           raceResent = seq(1,5,1)
)
prob.16.raceResent <- cbind(pred.16.raceResent, predict(log.16.1, pred.16.raceResent, type = 'probs'))
m.prob.16.raceResent <- melt(prob.16.raceResent, id.vars = c("pboff", "rboff","epast","efuture","unpast","ecjob","ecfamily","tradbreak","govbias","inflwhite","whitediscrim","raceResent","perwhite10","pid","presapprove"), variable.name = "Level", value.name = "Probability")

### Create Graphs to present predicted probabilities for variables of interest

pred.prob.16.plot.epast <- ggplot() +
  geom_line(data=  m.prob.16.epast, aes(x = epast, y = value, colour = variable), size = 1, linetype = 1) + 
  scale_color_grey() + 
  theme_minimal() +
  labs(colour = "White Identity", y = "Predicted Probability", x = "Economy - Retrospective")

pred.prob.16.plot.efuture <- ggplot() +
  geom_line(data=  m.prob.16.efuture, aes(x = efuture, y = value, colour = variable), size = 1, linetype = 2) + 
  scale_color_grey() + 
  theme_minimal() +
  labs(colour = "White Identity", y = "Predicted Probability", x = "Economy - Prospective")

pred.prob.16.plot.tradbreak <- ggplot() +
  geom_line(data=  m.prob.16.tradbreak, aes(x = tradbreak, y = value, colour = variable), size = 1, linetype = 1) + 
  scale_color_grey() + 
  theme_minimal() +
  labs(colour = "White Identity", y = "Predicted Probability", x = "Break Traditions")

pred.prob.16.plot.inflwhite <- ggplot() +
  geom_line(data=  m.prob.16.inflwhite, aes(x = inflwhite, y = value, colour = variable), size = 1, linetype = 2) + 
  scale_color_grey() + 
  theme_minimal() +
  labs(colour = "White Identity", y = "Predicted Probability", x = "White Influence")

pred.prob.16.plot.raceResent <- ggplot() +
  geom_line(data=  m.prob.16.raceResent, aes(x = raceResent, y = value, colour = variable), size = 1, linetype = 1) + 
  scale_color_grey() + 
  theme_minimal() +
  labs(colour = "White Identity", y = "Predicted Probability", x = "Racial Resentment")

ggsave(plot = pred.prob.16.plot.raceResent, 'figures/2016-raceResent-predicted-prob.png')

   ## Facet each of the economic factor predicted probability graphs into one figure
pred.prob.16.plot.econ <- ggarrange(pred.prob.16.plot.epast,pred.prob.16.plot.efuture, common.legend = TRUE, legend = 'bottom')
     # Annotate the Figure
pred.prob.16.plot.econ.a <- annotate_figure(pred.prob.16.plot.econ,
                                            top = text_grob("Figure 5. Predicted Probabilities of Economic Factors on White Identity"),
                                            bottom = text_grob("Damon Roberts | Data Source: 2016 ANES"),
                                            fig.lab.face = "bold")
      # Save the Figure
ggsave(plot = pred.prob.16.plot.econ.a, 'figures/2016-econ-predicted-probs.png')

  ## Facet each of the personal factor predicted probability graphs into one figure
pred.prob.16.plot.personal <- ggarrange(pred.prob.16.plot.tradbreak, pred.prob.16.plot.inflwhite, common.legend = TRUE, legend = 'bottom')
    # Annotate the Figure
pred.prob.16.plot.personal.a <- annotate_figure(pred.prob.16.plot.personal,
                                            top = text_grob("Figure 6. Predicted Probabilities of Personal Factors on White Identity"),
                                            bottom = text_grob("Damon Roberts | Data Source: 2016 ANES"),
                                            fig.lab.face = "bold")
    # Save the Figure
ggsave(plot = pred.prob.16.plot.personal.a, 'figures/2016-personal-predicted-probs.png')
  
  ## Facet each of the control item predicted probability graphs into one figure
pred.prob.16.plot.control <- ggarrange(pred.prob.16.plot.raceResent, common.legend = TRUE, legend = 'bottom')
    # Annotate the figure
pred.prob.16.plot.control.a <- annotate_figure(pred.prob.16.plot.control,
                                            top = text_grob("Figure 7. Predicted Probabilities of Controls on White Identity"),
                                            bottom = text_grob("Damon Roberts | Data Source: 2016 ANES"),
                                            fig.lab.face = "bold")
    # Save the figure
ggsave(plot = pred.prob.16.plot.control.a, 'figures/2016-controls-predicted-probs.png')
