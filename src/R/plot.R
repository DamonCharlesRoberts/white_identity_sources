#' @title plotting LASSO results
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
lasso_plot <- function (
  model
  , level = 0.95
  , year = "2012"
) {
  #* grab the posterior draws
  df_posterior <- parameters(
    model = model
    , level = level
    , verbose = FALSE
  ) |>
  standardize_names(style = "broom") |>
  data.frame() |>
  mutate(model = year) |>
  filter(!is.na(term))

}