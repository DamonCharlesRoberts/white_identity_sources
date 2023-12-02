#' @title rstan_ppc
#' 
#' @description
#' This is a function that takes the results from the fitted LASSO models
#' and makes a plot of the posterior distributions.
#' 
#' @details
#' 
#' @param
#' 
#' @returns
#' 
#' @example
#' 
rstan_ppc <- function (
  model
  , data
) {
  y_rep <- rstan::extract(model)$y_rep
  y <- data[["y"]]
  plot <- bayesplot::ppc_dens_overlay(y = y, yrep = y_rep)
  return(plot)
}

#' @title rstan_intervals
#' 
#' @description
#' Function for plotting the credible intervals of the model
#' 
#' @details 
#' 
#' @param
#' 
#' @return 
#' 
#' @example 
#' 
rstan_intervals <- function(
  model
  , prob = 0.89
  , prob_outer = 0.95
  , regex_pars = "beta\\[[1-9]|10:16\\]"
  , labels = c()
) {
  plot <- bayesplot::mcmc_intervals(
    model
    , regex_pars = regex_pars
    , prob = prob
    , prob_outer = prob_outer
  )
  if (length(labels) != 0) {
    plot <- plot + ggplot2::scale_y_discrete(
      labels = labels
    )

  }
  return(plot)
}