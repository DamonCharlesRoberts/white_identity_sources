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
  , miceadds[mids2datlist]
  , ./src/R/stanPrep[stan_prep]
)
  #* Load data
load(
    './data/temp/imputed_data.RData'
)
  #* Create empty model list object
list_data <- list("lwd" = list(), "mice" = list())
models <- list("lwd" = list(), "mice" = list())

# Put data in lists for Stan
  #* 2012
list_data[["lwd"]][["12"]] <- stan_prep(x = list_df[["anes_2012"]])
list_data[["mice"]][["12"]] <- stan_prep(x = list_df[["anes_2012_imputed"]])

list_data[["lwd"]][["16"]] <- stan_prep(x = list_df[["anes_2016"]])
list_data[["mice"]][["16"]] <- stan_prep(x = list_df[["anes_2016_imputed"]])

list_data[["lwd"]][["20"]] <- stan_prep(x = list_df[["anes_2020"]])
list_data[["mice"]][["20"]] <- stan_prep(x = list_df[["anes_2020_imputed"]])


# Fit models
models[["lwd"]][["12"]] <- stan(
    file = "./src/models/main-penalized-model.stan"
    , data = list_data[["lwd"]][["12"]]
    , chains = 6
    , cores = 5
    , iter = 2000
    , warmup = 1000
    , model_name = "ANES 2012 LWD"
)

models[["mice"]][["12"]] <- lapply(
  1:length(list_data[["mice"]][["12"]])
  , function (x) {
    stan(
      file = "./src/models/main-penalized-model.stan"
      , data = list_data[["mice"]][["12"]][[x]]
      , chains = 6
      , cores = 5
      , iter = 100
      , warmup = 1
      , model_name = "ANES 2012 MICE"
    )
  }
)

models[["lwd"]][["16"]] <- stan(
    file = "./src/models/main-penalized-model.stan"
    , data = list_data[["lwd"]][["16"]]
    , chains = 6
    , cores = 5
    , iter = 2000
    , warmup = 1000
    , model_name = "ANES 2016 LWD"
)

models[["mice"]][["16"]] <- stan(
    file = "./src/models/main-penalized-model.stan"
    , data = list_data[["mice"]][["16"]]
    , chains = 6
    , cores = 5
    , iter = 2000
    , warmup = 1000
    , model_name = "ANES 2016 MICE"
)

models[["lwd"]][["20"]] <- stan(
    file = "./src/models/main-penalized-model.stan"
    , data = list_data[["lwd"]][["20"]]
    , chains = 6
    , cores = 5
    , iter = 2000
    , warmup = 1000
    , model_name = "ANES 2020 LWD"
)

models[["mice"]][["20"]] <- stan(
    file = "./src/models/main-penalized-model.stan"
    , data = list_data[["mice"]][["20"]]
    , chains = 6
    , cores = 5
    , iter = 2000
    , warmup = 1000
    , model_name = "ANES 2020 MICE"
)