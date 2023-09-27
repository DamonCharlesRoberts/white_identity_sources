# Title: Exploratory PCA Model creation

# Notes:
  #* Description:
    #** Checking out whether a PCA approach to handling the correlates with WID work
  #* Updated:
    #** 2023-09-27
    #** dcr

# Setup
  #* Set seed
set.seed(121022)
  #* Source cleaning scripts
source('./eda/dcr_anes_2012_cleaning.R')
source('./eda/dcr_anes_2016_cleaning.R')
source('./eda/dcr_anes_2020_cleaning.R')
  #* Modularly load needed functions
box::use(
  FactoMineR[...]
  , factoextra[...]
  , data.table[...]
)

# PCA models
data[['anes_2012_sub']] <- data[['anes_2012']][
  , -c("wid", "pid", "female")
]
pca_2012 <- PCA(data[['anes_2012_sub']], ncp=2) # at most, there are like 5 dimensions and they all have weird components
fviz_cos2(pca_2012, choice = "var", addlabels = TRUE)
