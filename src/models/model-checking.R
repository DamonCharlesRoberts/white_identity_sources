# Title: Model Checking

# Notes
  #* Description
    #** R Script to check the performance of the models that I fit.
  #* Updated
    #** 2023-11-29
    #** dcr
  #* Other Notes
    #** Make sure to run ./src/models/model-fitting.R first if wanting to do full replication

# Setup
  #* Load useful functions
box::use(
    bayesplot[...]
    , modelsummary[...]
    , ggplot2[...]
    , ./src/R/stanPrep[stan_prep]
    , ./src/R/plot[...]
)
  #* Load stored models
load(
  file = './data/temp/fitted-models.RData'
)
load(
  file = './data/temp/imputed_data.RData'
)
  #* Load Stan formatted data
list_data <- list("lwd" = list(), "mice" = list())
list_data[["lwd"]][["12"]] <- stan_prep(x = list_df[["anes_2012"]])
list_data[["mice"]][["12"]] <- stan_prep(x = list_df[["anes_2012_imputed"]])

list_data[["lwd"]][["16"]] <- stan_prep(x = list_df[["anes_2016"]])
list_data[["mice"]][["16"]] <- stan_prep(x = list_df[["anes_2016_imputed"]])

list_data[["lwd"]][["20"]] <- stan_prep(x = list_df[["anes_2020"]])
list_data[["mice"]][["20"]] <- stan_prep(x = list_df[["anes_2020_imputed"]])

  #* Set color scheme for plots
color_scheme_set("gray")
  #* Make empty plot objects
plot <- list("lwd" = list(), "mice" = list())
  #* Make labels list
labels = c(
  "beta[1]" = "Retrospective better off"
  , "beta[2]" = "Economy better"
  , "beta[3]" = "Unemployment better"
  , "beta[4]" = "Education"
  , "beta[5]" = "Income"
  , "beta[6]" = "Worried about losing job"
  , "beta[7]" = "Immigrants take jobs"
  , "beta[8]" = "Worried about family finances"
  , "beta[9]" = "Know someone lost job"
  , "beta[10]" = "New lifestyles breaking society"
  , "beta[11]" = "Gov. biased against whites"
  , "beta[12]" = "Whites influence politics"
  , "beta[13]" = "Whites are discriminated against"
  , "beta[14]" = "Party ID"
  , "beta[15]" = "Female"
  , "beta[16]" = "Racial resentment"
)
# Check Imputed Models
    #* 2012
plot[["lwd"]][["12"]] <- rstan_intervals(
  model = models[["lwd"]][["12"]]
  , labels = labels
)
plot[["lwd"]][["12"]] <- rstan_ppc(
  models[["lwd"]][["12"]]
  , data = list_data[["lwd"]][["12"]]
)
  #* 2016
plot[["lwd"]][["16"]] <- rstan_intervals(
  model = models[["lwd"]][["16"]]
  , labels = labels
)
plot[["lwd"]][["16"]] <- rstan_ppc(
  models[["lwd"]][["16"]]
  , data = list_df[["anes_2016"]]
)
  #* 2020
plot[["lwd"]][["20"]] <- rstan_intervals(
  model = models[["lwd"]][["20"]]
  , labels = labels
)
plot[["lwd"]][["20"]] <- rstan_ppc(
  models[["lwd"]][["20"]]
  , data = list_data[["lwd"]][["20"]]
)
