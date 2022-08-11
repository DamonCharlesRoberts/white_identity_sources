# Title: White identity analyses

# Notes:
    #* Description: R script for 2012 & 2016 ANES and 2016-2020 ANES panel analyses
    #* Updated: 2022-07-19
    #* Updated by: dcr

# Setup
    #* Set seed
set.seed(90210)
    #* Source cleaning scripts
source('code/dcr_anes_2012_cleaning.R')
source('code/dcr_anes_2016_cleaning.R')
    #* Modularly load functions and packages
box::use(
    dplyr = dplyr[select, filter, mutate, case_when],
    tidyr = tidyr[drop_na],
    mice = mice[mice, pool],
    miceadds = miceadds[mids2datlist],
    #future = future[plan, multisession],
    #glmnet = glmnet[cv.glmnet],
    #rstanarm = rstanarm[...],
    brms = brms[brm, brm_multiple, set_prior, lasso, cumulative, prior],
    #bayesreg = bayesreg[bayesreg],
    tibble = tibble[tribble],
    modelsummary = modelsummary[modelsummary],
    parameters = parameters[parameters, standardize_names],
    ggplot2 = ggplot2[ggplot, aes, position_dodge, theme_minimal, geom_vline, labs, theme, element_text, ggsave],
    tidybayes = tidybayes[geom_pointinterval]
)
    #* Make sure the data you have loaded is the clean data
        #** 2012
anes_2012 = read.csv('data/anes-2012/anes-2012-updated.csv') |>
    select(wid, female, rboff, pboff, ideo, epast, efuture, unpast, unnext, pid, age, edu, findjob, losejob, offwork, fairjblacks, immtakejobs, raceResent, ecfamily, linked, tradbreak, toofar, govbias, inflwhite, inflblack, whitediscrim)
        #** 2016
anes_2016 = read.csv('data/anes-2016/anes-2016-updated.csv') |>
    select(rboff, pboff, epast, efuture, unpast, ecfamily, ecjob, tradbreak, pocare, ee, inflwhite, inflblack, govbias, whitediscrim, wid, raceResent, getahead, employment, pid, female, ideo, age, edu)

# Descriptive analyses

# Imputation
data_sets = 10
    #* 2012
anes_2012_imputed = mice(anes_2012, m = data_sets, method = 'rf')
saveRDS(anes_2012_imputed, file = 'data/anes-2012/anes-2012-imputed.rds')
    #* 2016
anes_2016_imputed = mice(anes_2016, m = data_sets, method = 'rf')
saveRDS(anes_2016_imputed, file = 'data/anes-2016/anes-2016-imputed.rds')
# LASSO
rstan::rstan_options(auto_write = TRUE)
rstan::rstan_options(threads_per_chain = 1)
    #* 2012
lasso_2012_simple = brm(wid ~ rboff + pboff + unpast + ecfamily + inflwhite + govbias + tradbreak + whitediscrim + raceResent + pid + female + age + edu, data = anes_2012, prior = set_prior(lasso(1)), chains = 6, iter = 2000, family = cumulative(link = 'logit'))
saveRDS(lasso_2012_simple, file = 'data/lasso_2012_simple.rds')

lasso_2012_ordinal = brm_multiple(wid ~ rboff + pboff + unpast + ecfamily + inflwhite + govbias + tradbreak + whitediscrim + raceResent + pid + female + age + edu, data = anes_2012_imputed, prior = set_prior(lasso(1)), chains = 6, iter = 2000, family = cumulative(link = 'logit'))
saveRDS(lasso_2012_ordinal, file = 'data/lasso_2012_ordinal.rds')
    #* 2016
lasso_2016_simple = brm(wid ~ rboff + pboff + unpast + ecfamily + inflwhite + govbias + whitediscrim + tradbreak + raceResent + pid + female + age + edu, data = anes_2016, prior = set_prior(lasso(1)), chains = 6, iter = 2000, family = cumulative(link = 'logit'))
saveRDS(lasso_2016_simple, file = 'data/lasso_2016_simple.rds')

lasso_2016_ordinal = brm_multiple(wid ~ rboff + pboff + unpast + ecfamily + inflwhite + govbias + whitediscrim + tradbreak + raceResent + pid + female + age + edu, data = anes_2016_imputed, prior = set_prior(lasso(1)), chains = 6, iter = 2000, family = cumulative(link = 'logit'))
saveRDS(lasso_2016_ordinal, file = 'data/lasso_2016_ordinal.rds')

# Graphs
    #* Posterior draws
lasso_2012_ordinal_tidy = parameters(lasso_2012_ordinal, conf.int = 0.95, verbose = FALSE) |>
    standardize_names(style = 'broom') |>
    data.frame() |>
    mutate(model = '2012') |>
    mutate(term = case_when(term == 'b_rboff' ~ 'Retrospective Better off', term == 'b_pboff' ~ 'Prospective Better off', term == 'b_unpast' ~ 'Unemployment better', term == 'b_ecfamily' ~ 'Worried about family finances', term == 'b_inflwhite' ~ 'Whites too much influence', term == 'b_govbias' ~ 'Gov. favor Blacks', term == 'b_raceResent' ~ 'Racial resentment', term == 'b_whitediscrim' ~ 'Whites discriminated against', term == 'b_tradbreak' ~ 'Traditions are breaking', term == 'b_pid' ~ 'Party ID', term == 'b_female' ~ 'Female', term == 'b_age' ~ 'Age', term == 'b_edu' ~ 'Education')) |>
    filter(!is.na(term))

lasso_2016_ordinal_tidy = parameters(lasso_2016_ordinal, conf.itn = 0.95, verbose = FALSE) |>
    standardize_names(style = 'broom') |>
    data.frame() |>
    mutate(model = '2016') |>
    mutate(term = case_when(term == 'b_rboff' ~ 'Retrospective Better off', term == 'b_pboff' ~ 'Prospective Better off', term == 'b_unpast' ~ 'Unemployment better', term == 'b_ecfamily' ~ 'Worried about family finances', term == 'b_inflwhite' ~ 'Whites too much influence', term == 'b_govbias' ~ 'Gov. favor Blacks', term == 'b_raceResent' ~ 'Racial resentment', term == 'b_whitediscrim' ~ 'Whites discriminated against', term == 'b_tradbreak' ~ 'Traditions are breaking', term == 'b_pid' ~ 'Party ID', term == 'b_female' ~ 'Female', term == 'b_age' ~ 'Age', term == 'b_edu' ~ 'Education')) |>
    filter(!is.na(term))

lasso_ordinal_tidy = rbind(lasso_2012_ordinal_tidy, lasso_2016_ordinal_tidy)

lasso_2012_2016_ordinal_plot = ggplot(data = lasso_ordinal_tidy, aes(y = term, x = estimate, xmin = conf.low, xmax = conf.high, linetype = factor(model))) +
    geom_pointinterval(position = position_dodge(width = 0.4), size = 3) +
    geom_vline(xintercept = 0, linetype = 2) +
    theme_minimal() +
    labs(linetype = 'Model', x = 'Estimate', y = '', caption = 'Data Source: 2012 & 2016 ANES.\n Dots represent median draw from posterior distribution.\n Bars represent 95% credible intervals.') + 
    theme(text=element_text(size=16, family = 'sans'))
ggsave(lasso_2012_2016_ordinal_plot, file = 'figures/2012_2016_ordinal_lasso_plot.pdf', height = 10, width = 15, units = 'in')


# Tables
gm = list(
    list('raw' = 'nobs', 'clean' = 'N', 'fmt' = 0)
)
    #* 2012 Simple
model = list(
    '2012 LWD' = lasso_2012_simple
)
rows = tribble(~term, ~`2012 LWD`, 'Economic', '', 'Non-material', '', 'Demographics', '', 'Thresholds', '')
attr(rows, 'position') = c(1, 8, 17, 26)
lasso_2012_simple_table = modelsummary(model, coef_map = c('b_rboff' = 'Retrospective Better Off', 'pboff' ~ 'Prospective Better off', 'b_unpast' = 'Unemployment better', 'b_ecfamily' = 'Worried about family finances', 'b_inflwhite' = 'Whites too much influence', 'b_govbias' = 'Gov. favor Blacks', 'b_raceResent' = 'Racial Resentment', 'b_whitediscrim' = 'Whites discriminated against', 'b_tradbreak' = 'Traditions are breaking', 'b_pid' = 'Party ID', 'b_female' = 'Female', 'b_age' = 'Age', 'b_edu' = 'Education', 'b_Intercept[1]' = 'Threshold 1', 'b_Intercept[2]' = 'Threshold 2', 'b_Intercept[3]' = 'Threshold 3', 'b_Intercept[4]' = 'Threshold 4'), statistic = 'conf.int', gof_map = gm, add_rows = rows, notes = list('Median estimate from fitted model with 6 chains and 2000 iterations.', '$95\\%$ Credible intervals in brackets.', 'Data source: 2012 American National Election Study.'), title = '2012 LASSO with Listwise Deletion \\label{tab:2012_lasso_simple}', output = 'figures/2012_simple_lasso_table.tex')
    #* 2016 Simple
model = list(
    '2016 LWD' = lasso_2016_simple
)
rows = tribble(~term, ~`2016 LWD`, 'Economic', '', 'Non-material', '', 'Demographics', '', 'Thresholds', '')
attr(rows, 'position') = c(1, 8, 17, 26)
lasso_2016_simple_table = modelsummary(model, coef_map = c('b_rboff' = 'Retrospective Better Off', 'b_pboff' = 'Prospective Better off', 'b_unpast' = 'Unemployment better', 'b_ecfamily' = 'Worried about family finances', 'b_inflwhite' = 'Whites too much influence', 'b_govbias' = 'Gov. favor Blacks', 'b_raceResent' = 'Racial Resentment', 'b_whitediscrim' = 'Whites discriminated against', 'b_tradbreak' = 'Traditions are breaking', 'b_pid' = 'Party ID', 'b_female' = 'Female', 'b_age' = 'Age', 'b_edu' = 'Education', 'b_Intercept[1]' = 'Threshold 1', 'b_Intercept[2]' = 'Threshold 2', 'b_Intercept[3]' = 'Threshold 3', 'b_Intercept[4]' = 'Threshold 4'),statistic = 'conf.int', gof_map = gm, add_rows = rows, notes = list('Median estimate from fitted model with 6 chains and 2000 iterations.', '$95\\%$ Credible intervals in brackets.', 'Data source: 2016 American National Election Study.'), title = '2016 LASSO with Listwise Deletion \\label{tab:2016_lasso_simple}', output = 'figures/2016_simple_lasso_table.tex')
    #* 2012 & 2016 Ordinal
model = list(
    '2012 ANES' = lasso_2012_ordinal,
    '2016 ANES' = lasso_2016_ordinal
)
rows = tribble(~term, ~`2012 ANES`, ~`2016 ANES`, 'Economic', '', '', 'Non-material', '', '', 'Demographics', '', '', 'Thresholds', '','')
attr(rows, 'position') = c(1, 8, 17, 26)
lasso_ordinal_table = modelsummary(model, coef_map = c('b_rboff' = 'Retrospective Better Off', 'b_pboff' = 'Prospective Better off', 'b_unpast' = 'Unemployment better', 'b_ecfamily' = 'Worried about family finances', 'b_inflwhite' = 'Whites too much influence', 'b_govbias' = 'Gov. favor Blacks', 'b_raceResent' = 'Racial Resentment', 'b_whitediscrim' = 'Whites discriminated against', 'b_tradbreak' = 'Traditions are breaking', 'b_pid' = 'Party ID', 'b_female' = 'Female', 'b_age' = 'Age', 'b_edu' = 'Education', 'b_Intercept[1]' = 'Threshold 1', 'b_Intercept[2]' = 'Threshold 2', 'b_Intercept[3]' = 'Threshold 3', 'b_Intercept[4]' = 'Threshold 4'), statistic = 'conf.int', gof_map = gm, add_rows = rows, title = 'The predictive influence of non-matieral factors on White Identity \\label{tab:2012_2016_ordinal_lasso}', notes = list('Median estimate from fitted model with 6 chains and 2000 iterations.', '$95\\%$ Credible intervals in brackets.' ,'Data Source: 2012 and 2016 American National Election Study.'), output = 'figures/2012_2016_ordinal_lasso_table.tex')