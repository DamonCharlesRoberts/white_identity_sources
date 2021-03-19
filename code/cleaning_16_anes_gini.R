#### 2016 Congressional District Gini Cleaning ####

### Notes: ###
## Making long transformation of dataset from US Census.gov ##

#### Setup ####
{
  library(here)
}
source("code/personal-threats-setup-file.R")

#### Loading and Cleaning ####
### Loading ###

gini16cd <- read_csv("data/us_gini/2016_gini_census_congressional_district/2016_gini_census_congressional_district_data.csv") %>%
  slice(-1)

anes16 <- read_dta("data/anes-2016/anes-2016-updated.dta")

### Cleaning ###
anes16 <- anes16 %>%
  rename(sample_state = V163001a) %>%
  rename(sample_district = V163002)
anes16$sample_state <- as.numeric(anes16$sample_state)
anes16$sample_district <- as.numeric(anes16$sample_district)
anes16 <- anes16 %>%
  mutate(nState = case_when(
    sample_state == 1 ~ "01", #AL
    sample_state == 2 ~ "02", #AK
    sample_state == 4 ~ "04", #AZ
    sample_state == 5 ~ "05", #AR
    sample_state == 6 ~ "06", #CA
    sample_state == 8 ~ "08", #CO
    sample_state == 9 ~ "09", #CT
    sample_state == 10 ~ "10", #DE
    sample_state == 11 ~ "11", #DC
    sample_state == 12 ~ "12", #FL
    sample_state == 13 ~ "13", #GA
    sample_state == 15 ~ "15", #HI
    sample_state == 16 ~ "16", #ID
    sample_state == 17 ~ "17", #IL
    sample_state == 18 ~ "18", #IN
    sample_state == 19 ~ "19", #IA
    sample_state == 20 ~ "20", #KS
    sample_state == 21 ~ "21", #KY
    sample_state == 22 ~ "22", #LA
    sample_state == 23 ~ "23", #ME
    sample_state == 24 ~ "24", #MD
    sample_state == 25 ~ "25", #MA
    sample_state == 26 ~ "26", #MI
    sample_state == 27 ~ "27", #MN
    sample_state == 28 ~ "28", #MS
    sample_state == 29 ~ "29", #MO
    sample_state == 30 ~ "30", #MT
    sample_state == 31 ~ "31", #NE
    sample_state == 32 ~ "32", #NV
    sample_state == 33 ~ "33", #NH
    sample_state == 34 ~ "34", #NJ
    sample_state == 35 ~ "35", #NM
    sample_state == 36 ~ "36", #NY
    sample_state == 37 ~ "37", #NC
    sample_state == 38 ~ "38", #ND
    sample_state == 39 ~ "39", #OH
    sample_state == 40 ~ "40", #OK
    sample_state == 41 ~ "41", #OR
    sample_state == 42 ~ "42", #PA
    sample_state == 44 ~ "44", #RI
    sample_state == 45 ~ "45", #SC
    sample_state == 46 ~ "46", #SD
    sample_state == 47 ~ "47", #TN
    sample_state == 48 ~ "48", #TX
    sample_state == 49 ~ "49", #UT
    sample_state == 50 ~ "50", #VT
    sample_state == 51 ~ "51", #VA
    sample_state == 53 ~ "53", #WA
    sample_state == 54 ~ "54", #WV
    sample_state == 55 ~ "55", #WI
    sample_state == 56 ~ "56", #WY
  )) %>%
  mutate(nDistrict = case_when(
    sample_district == 1 ~ "01",
    sample_district == 2 ~ "02",
    sample_district == 3 ~ "03",
    sample_district == 4 ~ "04",
    sample_district == 5 ~ "05",
    sample_district == 6 ~ "06",
    sample_district == 7 ~ "07",
    sample_district == 8 ~ "08",
    sample_district == 9 ~ "09",
    sample_district == 10 ~ "10",
    sample_district == 11 ~ "11",
    sample_district == 12 ~ "12",
    sample_district == 13 ~ "13",
    sample_district == 14 ~ "14",
    sample_district == 15 ~ "15",
    sample_district == 16 ~ "16",
    sample_district == 17 ~ "17",
    sample_district == 18 ~ "18",
    sample_district == 19 ~ "19",
    sample_district == 20 ~ "20",
    sample_district == 21 ~ "21",
    sample_district == 22 ~ "22",
    sample_district == 23 ~ "23",
    sample_district == 24 ~ "24",
    sample_district == 25 ~ "25",
    sample_district == 26 ~ "26",
    sample_district == 27 ~ "27",
    sample_district == 28 ~ "28",
    sample_district == 29 ~ "29",
    sample_district == 30 ~ "30",
    sample_district == 31 ~ "31",
    sample_district == 32 ~ "32",
    sample_district == 33 ~ "33",
    sample_district == 34 ~ "34",
    sample_district == 35 ~ "35",
    sample_district == 36 ~ "36",
    sample_district == 37 ~ "37",
    sample_district == 38 ~ "38",
    sample_district == 39 ~ "39",
    sample_district == 40 ~ "40",
    sample_district == 41 ~ "41",
    sample_district == 42 ~ "42",
    sample_district == 43 ~ "43",
    sample_district == 44 ~ "44",
    sample_district == 45 ~ "45",
    sample_district == 46 ~ "46",
    sample_district == 47 ~ "47",
    sample_district == 48 ~ "48",
    sample_district == 49 ~ "49",
    sample_district == 50 ~ "50",
    sample_district == 51 ~ "51",
    sample_district == 52 ~ "52",
    sample_district == 53 ~ "53",
    sample_district == 54 ~ "54",
    sample_district == 55 ~ "55",
    sample_district == 56 ~ "56",
    sample_district == 57 ~ "57",
    sample_district == 58 ~ "58",
    sample_district == 59 ~ "59"
  )) %>%
  mutate(district = paste(nState, nDistrict, sep = ""))

anes16$district <- as.character(anes16$district)


gini16cd <- gini16cd %>%
  separate(GEO_ID, c("front", "fulldistrict"), "US") %>%
    mutate(district = ifelse(fulldistrict == '0200', '0201', 
                    ifelse(fulldistrict == '1000', '1001', 
                    ifelse(fulldistrict == '1198', '1101', 
                    ifelse(fulldistrict == '3000', '3001', 
                    ifelse(fulldistrict == '3800', '3801', 
                    ifelse(fulldistrict == '4600', '4601', 
                    ifelse(fulldistrict == '5000', '5001', 
                    ifelse(fulldistrict == '5600', '5601', fulldistrict)))))))))

#### Merging ####
### 2016 ANES loses ### observations. ###

combined16 <- left_join(anes16, gini16cd, by = "district")
nonMatched16 <- anti_join(anes16, gini16cd, by = "district")

combined16 <- combined16 %>%
  rename(gini = B19083_001E) %>%
  rename(gini_error = B19083_001M)


combined16[] <- lapply(combined16, function(x) as.numeric(as.character(x)))

write_dta(combined16, "data/anes-2016/gini_anes_2016_updated.dta")
