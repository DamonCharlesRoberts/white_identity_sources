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
)
  #* Load stored models
load(
  file = './data/temp/fitted-models.RData'
)
load(
  file = './data/temp/imputed_data.RData'
)
  #* Set color scheme for plots
color_scheme_set("gray")

# Check Imputed Models
    #* 2012
y_rep <- extract(models[["lwd"]][["12"]])$y_rep
y <- list_data[["lwd"]][["12"]][["y"]]
bayesplot::ppc_dens_overlay(y = y, yrep = y_rep)
bayesplot::mcmc_intervals(
  models[["lwd"]][["12"]],
  regex_pars = "beta\\[[1-9]|10:16\\]"
  , prob = 0.89
  , prob_outer = 0.95
) +
  ggplot2::scale_y_discrete(
    labels = c(
      "beta[1]" = "Retrospective Better Off"
      , "beta[2]" = "Economy was better last year"
      , "beta[3]" = "Unemployment was better last year"
      , "beta[4]" = "Education"
      , "beta[5]" = "Income"
      , "beta[6]" = "Know someone who lost job"
      , "beta[7]" = "Immigrants take jobs"
      , "beta[8]" = "Worried about family finances"
      , "beta[9]" = "Worried about losing job"
      , "beta[10]" = "Traditions breaking society"
      , "beta[11]" = "Government Biased against Whites"
      , "beta[12]" = "Whites are influential"
      , "beta[13]" = "Whites are discrimminated against"
      , "beta[14]" = "Party Identification"
      , "beta[15]" = "Female"
      , "beta[16]" = "Racial Resentment"
    )
  )
