# Title: Unit testing of stanPrep::stan_prep

# Notes
  #* Description
    #** Unit testing script for stanPrep::stan_prep()
    #** stanPrep::stan_prep() depends on stanPrep::single_df_prep() ...
    #** so run tests for that function if concerned about data.frame conversion to list
  #* Updated
    #** 2023-11-28
    #** dcr

# Setup
  #* Load necessary functions
box::use(
    testthat[...]
    , ../src/R/stanPrep[stan_prep]
)
  #* Load data
load(
    '../data/temp/imputed_data.RData'
)
  #* Run function on two examples
test_list <- list()
test_list[["lwd"]] <- stan_prep(list_df[["anes_2012"]])
test_list[["mice"]] <- stan_prep(list_df[["anes_2012_imputed"]])

# Check that length of test_list is right -- 2
test_that("check length of test_list", 
{
    expect_true(length(test_list) == 2)
})
# Check that length of test_list[["lwd"]] is right -- 1
test_that("check length of test_list[['lwd']]",
{
    expect_true(length(test_list[["lwd"]]) == 5)
})
# Check that object in test_list[["lwd"]] is data.frame
test_that("check that test_list[['lwd']] is list",
{
    expect_true(is.list(test_list[["lwd"]]))
})
# Check that length of test_list[["mice"]] is right -- 10 (unless change num of imputations)
test_that("check length of test_list[['mice']]",
{
    expect_true(length(test_list[["mice"]])== 10)
})
# Check that objects in test_list[["mice"]] are list
test_that("check that test_list[['lwd']][i] is list",
{
    expect_true(all(sapply(test_list[["mice"]], is.list)))
})

