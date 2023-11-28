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
    return_obj <- miceadds::mids2datlist(x)
    return_obj <- lapply(
        1:length(return_obj)
        , function(i) single_df_prep(df=return_obj[[i]])
    )
    return(return_obj)
  } else if (is.data.frame(x)) {
    return_obj <- stats::na.omit(x)
    return_obj <- single_df_prep(x)
    return(return_obj)
  } else {
    print("Please enter a list of data.frame or data.frame objects.")
  }
}
