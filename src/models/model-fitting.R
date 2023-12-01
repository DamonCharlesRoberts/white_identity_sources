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
  , ./src/R/modelFitting[model_fitting]
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

models[["lwd"]][["12"]] <- model_fitting(
  data = list_data[["lwd"]][["12"]]
  , type = "lwd"
  , model_name = "ANES 2012 LWD"
)

models[["mice"]][["16"]] <- model_fitting(
  data = list_data[["mice"]][["12"]]
  , type = "mice"
  , model_name = "ANES 2012 MICE"
)

models[["lwd"]][["16"]] <- model_fitting(
  data = list_data[["lwd"]][["16"]]
  , type = "lwd"
  , model_name = "ANES 2016 LWD"
)

models[["mice"]][["16"]] <- model_fitting(
  data = list_data[["mice"]][["16"]]
  , type = "mice"
  , model_name = "ANES 2016 MICE"
)

models[["lwd"]][["20"]] <- model_fitting(
  data = list_data[["lwd"]][["20"]]
  , type = "lwd"
  , model_name = "ANES 2020 LWD"
)

models[["mice"]][["16"]] <- model_fitting(
  data = list_data[["mice"]][["20"]]
  , type = "mice"
  , model_name = "ANES 2020 MICE"
)

# Save results of model
save(
  models
  , file = './data/temp/fitted-models.RData'
)