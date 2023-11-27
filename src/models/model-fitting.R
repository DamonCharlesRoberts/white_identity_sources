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
)
  #* Load data
load(
    './data/temp/imputed_data.RData'
)

# Fit models
anes_2012_df <- na.omit(list_df[["anes_2012"]])
anes_2012 <- list(
    y = anes_2012_df$wid
    , x = anes_2012_df[, -1:-3]
    , N = nrow(anes_2012_df)
    , K = 5
    , D = ncol(anes_2012_df[, -1:-3])
)
model[["2012"]] <- stan(
    file = "./src/models/2012-model.stan"
    , data = anes_2012
    , chains = 6
    , cores = 5
    , iter = 2000
    , warmup = 1000
)
