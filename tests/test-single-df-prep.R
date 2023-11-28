# Title: Unit testing of stanPrep::single_df_prep

# Notes
  #* Description
    #** Unit testing script for stanPrep::single_df_prep()
  #* Updated
    #** 2023-11-28
    #** dcr

# Setup
  #* Load necessary functions
box::use(
    testthat[...]
    , ../src/R/stanPrep[single_df_prep]
)
  #* Load data
load(
    '../data/temp/imputed_data.RData'
)
  #* Run function on example
test_df <- na.omit(list_df[["anes_2012"]])
test_df <- single_df_prep(df = test_df)

# Check to make sure length of new object is 5 if model="main"
test_that("check length of list for main model", {
    expect_true(length(test_df) == 5)
})
# Check to make sure that y is an array
test_that("check that y is vector",
{
    expect_true(is.vector(test_df$y))
})
# Check to make sure that x is a data.frame
test_that("check that x is data.frame",
{
    expect_true(is.data.frame(test_df$x))
})
# Check to make sure that N is an integer
test_that("check that N is an integer",
{
    expect_true(is.integer(test_df$N))
})
# Check to make sure that K is a numeric value
test_that("check that K is a numeric value",
{
    expect_true(is.numeric(test_df$K))
})
# Check to make sure that D is an integer
test_that("check that D is an integer",
{
    expect_true(is.integer(test_df$D))
})