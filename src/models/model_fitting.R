# Title: model fitting

# Notes
  #* Description
    #** fitting the models in the manuscript
  #* Updated
    #** 2023-06-26
    #** dcr

# Setup
  #* execute cleaning scripts
source("./src/eda/dcr_anes_2012_cleaning.R")
source("./src/eda/dcr_anes_2016_cleaning.R")
source("./src/eda/dcr_anes_2020_cleaning.R")
  #* modularly load handy functions
box::use(
  , mice[
    mice
  ]
  , brms[
    brm
    , brm_multiple
    , bf
    , set_prior
    , lasso
    , cumulative
  ]
)
library(data.table)
  #* define number of datasets to impute
data_sets <- 10
  #* create empty list objects
data <- list()
lasso <- list()
  #* load cleaned data
    #** 2012
data[["anes_2012"]] <- read.csv("./data/clean/anes_2012_updated.csv")
data[["anes_2012"]] <- data[["anes_2012"]][
  , c(
    "wid", "rboff", "epast", "unpast", "edu", "income", "losejob"
    , "ecfamily", "ecjob", "tradbreak", "govbias", "inflwhite"
    , "whitediscrim", "raceResent", "pid", "female"
    )
]
    #** 2016
data[["anes_2016"]] <- read.csv("./data/clean/anes_2016_updated.csv")
data[["anes_2016"]] <- data[["anes_2016"]][
  , c(
    "wid", "rboff", "epast", "unpast", "edu", "income"
    , "losejob", "ecfamily", "ecjob", "tradbreak"
    , "govbias", "inflwhite", "whitediscrim", "raceResent", "pid", "female"
  )
]
    #** 2020
data[["anes_2020"]] <- read.csv("./data/clean/anes_2020_updated.csv")
data[["anes_2020"]] <- data[["anes_2020"]][
  , c(
    "wid", "rboff", "epast", "unpast", "edu"
    , "income", "losejob", "ecfamily", "ecjob"
    , "govbias", "inflwhite", "whitediscrim"
    , "raceResent", "pid", "female"
  )
]

# Impute the data
    #* 2012
data[["anes_2012_imputed"]] <- mice(
  data[["anes_2012"]]
  , m = data_sets
  , method = "rf"
)
    #* 2016
data[["anes_2016_imputed"]] <- mice(
  data[["anes_2016"]]
  , m = data_sets
  , method = "rf"
)
    #* 2020
data[["anes_2020_imputed"]] <- mice(
  data[["anes_2020"]]
  , m = data_sets
  , method = "rf"
)

# Fit models
lasso[["2012_simple"]] <- brm(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    tradbreak + govbias + whitediscrim +
    raceResent + pid + female
  )
  , data = data[["anes_2012"]]
  , prior = set_prior(lasso(1))
  , chains = 6
  , iter = 2000
  , threads = 5
  , family = cumulative(link = "logit")
  , backend = "cmdstanr"
)

lasso[["2012_ordinal"]] <- brm_multiple(
  formula = bf(
    wid ~ rboff + epast + unpast + edu +
    income + losejob +  ecfamily + ecjob +
    tradbreak + govbias + whitediscrim +
    raceResent + pid + female
  )
  , data = data[["anes_2012_imputed"]]
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

# Store results of fitted models
save(
  lasso
  , file = "./data/temp/fitted_models.RData"
)