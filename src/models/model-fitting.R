# Title: Model fitting

# Notes
  #* Description
    #** R script for fitting models in paper
  #* Updated
    #** 2023-11-27
    #** dcr

# Set up
  #* Set seed
set.seed(121022)
  #* Load handy functions
box::use(
  rstan[...]
)
  #* Load data
load(
    './data/temp/imputed_data.RData'
)

# Fit models

example <- brms::make_stancode(
  formula = 
    factor(wid) ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    tradbreak + govbias + whitediscrim +
    raceresent + pid + female
  , data = list_df[["anes_2012"]]
  , prior = set_prior(horseshoe(df=1), class = "b")
  , family = cumulative(link="logit")
)

lasso[["2012_ordinal"]] <- brm_multiple(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob +  ecfamily + ecjob +
    tradbreak + govbias + whitediscrim +
    raceresent + pid + female
  )
  , data = list_df[["anes_2012_imputed"]]
  , prior = set_prior(horseshoe(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  #, backend = "cmdstanr"
)

lasso[["2012_female"]] <- brm_multiple(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    tradbreak + govbias + whitediscrim +
    raceResent + pid
  )
  , data = data[["anes_2012_imputed_female"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)

lasso[["2012_male"]] <- brm_multiple(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    tradbreak + govbias + whitediscrim +
    raceResent + pid
  )
  , data = data[["anes_2012_imputed_male"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)

lasso[["2012_republican"]] <- brm_multiple(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    tradbreak + govbias + whitediscrim +
    raceResent + female
  )
  , data = data[["anes_2012_imputed_republican"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)

lasso[["2012_democrat"]] <- brm_multiple(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    tradbreak + govbias + whitediscrim +
    raceResent + female
  )
  , data = data[["anes_2012_imputed_democrat"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)

lasso[["2016_simple"]] <- brm(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    tradbreak + govbias + whitediscrim +
    raceResent + pid + female
  )
  , data = data[["anes_2016"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)

lasso[["2016_ordinal"]] <- brm_multiple(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    tradbreak + govbias + whitediscrim +
    raceResent + pid + female
  )
  , data = data[["anes_2016_imputed"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)
lasso[["2016_female"]] <- brm_multiple(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    tradbreak + govbias + whitediscrim +
    raceResent + pid
  )
  , data = data[["anes_2016_imputed_female"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)

lasso[["2016_male"]] <- brm_multiple(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    tradbreak + govbias + whitediscrim +
    raceResent + pid
  )
  , data = data[["anes_2016_imputed_male"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)

lasso[["2016_republican"]] <- brm_multiple(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    tradbreak + govbias + whitediscrim +
    raceResent + female
  )
  , data = data[["anes_2016_imputed_republican"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)

lasso[["2016_democrat"]] <- brm_multiple(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    tradbreak + govbias + whitediscrim +
    raceResent + female
  )
  , data = data[["anes_2016_imputed_democrat"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)

lasso[["2020_simple"]] <- brm(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    govbias + whitediscrim +
    raceResent + pid + female
  )
  , data = data[["anes_2020"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)

lasso[["2020_ordinal"]] <- brm_multiple(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    govbias + whitediscrim +
    raceResent + pid + female
  )
  , data = data[["anes_2020_imputed"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)

lasso[["2020_female"]] <- brm_multiple(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    govbias + whitediscrim +
    raceResent + pid
  )
  , data = data[["anes_2020_imputed_female"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)

lasso[["2020_male"]] <- brm_multiple(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    govbias + whitediscrim +
    raceResent + pid
  )
  , data = data[["anes_2020_imputed_male"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)

lasso[["2020_republican"]] <- brm_multiple(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    govbias + whitediscrim +
    raceResent + female
  )
  , data = data[["anes_2020_imputed_republican"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)

lasso[["2020_democrat"]] <- brm_multiple(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    govbias + whitediscrim +
    raceResent + female
  )
  , data = data[["anes_2020_imputed_democrat"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)