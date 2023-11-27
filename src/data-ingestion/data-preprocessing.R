# Title: Data Pre-processing

# Notes
  #* Description
    #** R Script to do multiple imputation on datasets
  #* Updated
    #** 2023-11-27
    #** dcr

# Setup
  #* Set seed
set.seed(121022)

  #* Define number of datasets to impute
n <- 10

  #* Define list object to store datasets in
list_df <- list()

  #* Modularly load handy functions
box::use(
  , duckdb[...]
  , DBI[...]
  , mice[
    mice
  ]
)

  #** Execute data ingestion
system("poetry run python3 ./src/data-ingestion/ingestion.py")

  #** Connect to database and load data
con <- dbConnect(
  duckdb()
  , dbdir='./data/clean/project-data.db'
)

# Load cleaned data
  #* 2012
list_df[["anes_2012"]] <- dbGetQuery(
    con
    , 'SELECT * FROM Clean12'
)
  #* 2016
list_df[["anes_2016"]] <- dbGetQuery(
    con
    , 'SELECT * FROM Clean16'
)
  #* 2020
list_df[["anes_2020"]] <- dbGetQuery(
    con
    , 'SELECT * FROM Clean20'
)

# Impute Missing Data
  #* 2012
list_df[["anes_2012_imputed"]] <- mice(
    list_df[["anes_2012"]]
    , m = n
    , method = "rf"
)
  #* 2016
list_df[["anes_2016_imputed"]] <- mice(
    list_df[["anes_2016"]]
    , m = n
    , method = "rf"
)
  #* 2020
list_df[["anes_2020_imputed"]] <- mice(
    list_df[["anes_2020"]]
    , m = n
    , method = "rf"
)

# Create temp RData file with dataframes
save(
    list_df
    , file = "./data/temp/imputed_data.RData"
)

# Close connection
dbDisconnect(
  con
  , shutdown=TRUE
)
