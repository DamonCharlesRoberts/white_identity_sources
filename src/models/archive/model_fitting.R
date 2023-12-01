# Title: model fitting

# Notes
  #* Description
    #** fitting the models in the manuscript
  #* Updated
    #** 2023-06-26
    #** dcr

# Setup
  #* execute cleaning scripts
source("./eda/dcr_anes_2012_cleaning.R")
source("./eda/dcr_anes_2016_cleaning.R")
source("./eda/dcr_anes_2020_cleaning.R")
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
data[["anes_2012"]] <- read.csv("../data/clean/anes_2012_updated.csv") |>
  as.data.table()
data[["anes_2012"]] <- data[["anes_2012"]][
  , c(
    "wid", "rboff", "epast", "unpast", "edu", "income", "losejob"
    , "ecfamily", "ecjob", "tradbreak", "govbias", "inflwhite"
    , "whitediscrim", "raceResent", "pid", "female"
    )
]
data[["anes_2012_female"]] <- data[["anes_2012"]][
  female == 1,
]
data[["anes_2012_male"]] <- data[["anes_2012"]][
  female == 0,
]
data[["anes_2012_republican"]] <- data[["anes_2012"]][
  pid > 4,
]
data[["anes_2012_democrat"]] <- data[["anes_2012"]][
  pid < 4,
]
    #** 2016
data[["anes_2016"]] <- read.csv("../data/clean/anes_2016_updated.csv") |>
  as.data.table()
data[["anes_2016"]] <- data[["anes_2016"]][
  , c(
    "wid", "rboff", "epast", "unpast", "edu", "income"
    , "losejob", "ecfamily", "ecjob", "tradbreak"
    , "govbias", "inflwhite", "whitediscrim", "raceResent", "pid", "female"
  )
]
data[["anes_2016_female"]] <- data[["anes_2016"]][
  female == 1,
]
data[["anes_2016_male"]] <- data[["anes_2016"]][
  female == 0,
]
data[["anes_2016_republican"]] <- data[["anes_2016"]][
  pid > 4,
]
data[["anes_2016_democrat"]] <- data[["anes_2016"]][
  pid < 4,
]
    #** 2020
data[["anes_2020"]] <- read.csv("../data/clean/anes_2020_updated.csv") |>
  as.data.table()
data[["anes_2020"]] <- data[["anes_2020"]][
  , c(
    "wid", "rboff", "epast", "unpast", "edu"
    , "income", "losejob", "ecfamily", "ecjob"
    , "govbias", "inflwhite", "whitediscrim"
    , "raceResent", "pid", "female"
  )
]
data[["anes_2020_female"]] <- data[["anes_2020"]][
  female == 1,
]
data[["anes_2020_male"]] <- data[["anes_2020"]][
  female == 0,
]
data[["anes_2020_republican"]] <- data[["anes_2020"]][
  pid > 4,
]
data[["anes_2020_democrat"]] <- data[["anes_2020"]][
  pid < 4,
]
# Impute the data
    #* 2012
data[["anes_2012_imputed"]] <- mice(
  data[["anes_2012"]]
  , m = data_sets
  , method = "rf"
)
data[["anes_2012_imputed_female"]] <- mice(
  data[["anes_2012_female"]]
  , m = data_sets
  , method = "rf"
)
data[["anes_2012_imputed_male"]] <- mice(
  data[["anes_2012_male"]]
  , m = data_sets
  , method = "rf"
)
data[["anes_2012_imputed_republican"]] <- mice(
  data[["anes_2012_republican"]]
  , m = data_sets
  , method = "rf"
)
data[["anes_2012_imputed_democrat"]] <- mice(
  data[["anes_2012_female"]]
  , m = data_sets
  , method = "rf"
)
    #* 2016
data[["anes_2016_imputed"]] <- mice(
  data[["anes_2016"]]
  , m = data_sets
  , method = "rf"
)
data[["anes_2016_imputed_female"]] <- mice(
  data[["anes_2016_female"]]
  , m = data_sets
  , method = "rf"
)
data[["anes_2016_imputed_male"]] <- mice(
  data[["anes_2016_male"]]
  , m = data_sets
  , method = "rf"
)
data[["anes_2016_imputed_republican"]] <- mice(
  data[["anes_2016_republican"]]
  , m = data_sets
  , method = "rf"
)
data[["anes_2016_imputed_democrat"]] <- mice(
  data[["anes_2016_female"]]
  , m = data_sets
  , method = "rf"
)
    #* 2020
data[["anes_2020_imputed"]] <- mice(
  data[["anes_2020"]]
  , m = data_sets
  , method = "rf"
)
data[["anes_2020_imputed_female"]] <- mice(
  data[["anes_2020_female"]]
  , m = data_sets
  , method = "rf"
)
data[["anes_2020_imputed_male"]] <- mice(
  data[["anes_2020_male"]]
  , m = data_sets
  , method = "rf"
)
data[["anes_2020_imputed_republican"]] <- mice(
  data[["anes_2020_republican"]]
  , m = data_sets
  , method = "rf"
)
data[["anes_2020_imputed_democrat"]] <- mice(
  data[["anes_2020_female"]]
  , m = data_sets
  , method = "rf"
)

# Fit models
lasso[["2012_simple"]] <- make_stancode(
  formula = wid ~ rboff + epast + unpast + edu +
    income + losejob + ecfamily + ecjob +
    tradbreak + govbias + whitediscrim +
    raceresent + pid + female
  , data = list_df[["anes_2012"]]
  , prior = set_prior(horseshoe(1), class = "b")
  , family = cumulative(link = "logit")
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

# Store results of fitted models
save(
  lasso
  , file = "../data/temp/fitted_models.RData"
)
