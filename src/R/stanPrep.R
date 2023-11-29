#' @title single_df_prep
#' 
#' @description
#' This is a function that prepares a data.frame for Stan.
#' 
#' @details 
#' 
#' @param
#' 
#' @returns
#' 
#' @example 
#'
single_df_prep <- function (
  df
  , model = "main"
) {
  if (model == "main") {
    list_temp <- list(
      y = df$wid
      , x = df[, -1:-3]
      , N = nrow(df)
      , K = 5
      , D = ncol(df[, -1:-3])
    )

    return(list_temp)
  } else {
    print("Please specify whether the model is 'main' or 'multilevel'.")
  }
}

#' @title stan_prep
#' 
#' @description
#' This is a function that prepares a data.frame or list of data.frames for Stan.
#' 
#' @details 
#' 
#' @param
#' 
#' @returns
#' 
#' @example 
#'
stan_prep <- function(
  x
  , model = "main"
) {
  #if (is.list(x) && !inherits(x, "data.frame")) {
  if ('mids' %in% class(x)) {
    complete_mice_df <- mice::complete(x, action = "long")
    list_mice_df <- base::split(complete_mice_df, f = complete_mice_df$`.imp`)
    return_obj <- lapply(
        1:length(list_mice_df)
        , function(i) single_df_prep(df=list_mice_df[[i]])
    )
    return(return_obj)
  } else if (is.data.frame(x)) {
    omit_na_df <- stats::na.omit(x)
    return_obj <- single_df_prep(omit_na_df)
    return(return_obj)
  } else {
    print("Please enter a list of data.frame or data.frame objects.")
  }
}
