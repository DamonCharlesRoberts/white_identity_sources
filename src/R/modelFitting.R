#' @title single_model_fit
#' 
#' @description
#' This is a function that fits a single stan model
#' 
#' @details
#' 
#' @param
#' 
#' @returns
#' 
#' @example
#' 
single_model_fit <- function(
  file
  , data
  , chains
  , cores
  , iter
  , warmup
  , model_name
) {
  model <- rstan::stan(
    file = file
    , data = data
    , chains = chains
    , cores = cores
    , iter = iter
    , warmup = warmup
    , model_name
  )
  return(model)
}

#' @title model_fitting
#' 
#' @description
#' This is a function that fits the stan models
#' 
#' @details
#' 
#' @param 
#' 
#' @returns
#' 
#' @example 
#' 
model_fitting <- function(
  file = './src/models/STAN/main-penalized-model.stan'
  , data
  , chains = 6
  , cores = 5
  , iter = 2000
  , warmup = 1000
  , model_name = "anon_model"
  , type
) {
  if (type == "lwd") {
    model <- single_model_fit(
      file = file
      , data = data
      , chains = chains
      , cores = cores
      , iter = iter
      , warmup = warmup
      , model_name = model_name
    )
  } else if (type == "mice") {
    model <- lapply(
      1:length(data)
      , FUN = function(x) {
        single_model_fit(
          file = file
          , data = data[[x]]
          , chains = chains
          , cores = cores
          , iter = iter
          , warmup = warmup
          , model_name = model_name
        )
      }
    )
    return(model)
  } else {
    print("Please pass a valid model type as either 'lwd' or 'mice'.")
  }
}