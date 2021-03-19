#### 2016 Cumulative ANES: Index Script ####

#### Notes: ####
### Description: Index file for 2016 ANES Cumulative analysis of white group identity over time. ###

#### Files: ####
### In: code/cumulative-2016-anes-setup.R, ###
### Out: ###

#### Setup ####
here::here()

source('code/timeseries-setup.R')



#### Subset Data ####

white_dat2016 <- dat %>%
  filter(VCF0105b == 1) %>%
  filter(VCF0004 >= 1964)


#### Feeling Thermometers over time ####
white_dat2016 %>%
  mutate(VCF0207, 
         case_when(VCF0207 == 98 ~ NA,
            VCF0207 == 99 ~ NA
            )
  )
ggplot(white_dat2016, aes(x = VCF0004, y = VCF0207)) + geom_point()

ts.dat2016 <- white_dat2016 %>%
  select(VCF0004, VCF0207)
temp.df2016 <- ts.dat2016 %>%
  group_by(VCF0004) %>%
  dplyr::summarize(ft = mean(VCF0207, na.rm = TRUE))

#### Merge 2018 Data ####
dat2 %>%
  filter(race == 1)
dat18 <- dat2 %>%
  select(ftwhite)
dat18$VCF0004 <- 2018
dat182 <- dat18 %>%
  mutate(ftwhite = ifelse(ftwhite < 0, NA, ftwhite))
dat218 <- dat182 %>%
  group_by(VCF0004) %>%
  dplyr::summarize(ft = mean(ftwhite, na.rm = TRUE))

cDat <- rbind(temp.df2016, dat218)
#### Figure 1 ####

library(ggthemes)
library(scales)
ts.plot <- ggplot() + 
  geom_line(data = cDat, aes(x = VCF0004, y = ft), size = 2, alpha = 0.9, linetype = 1) + 
  theme_tufte() +
  ggtitle("Figure 8. Mean White Feeling Thermometer Scores of Whites") +
  labs(y = 'Average White Feeling Thermometer Score', x = 'ANES Study',
       caption = "Damon Roberts | Data Source: American National Election Study Cumulative Study (1964-2016).\nNotes: Mean of Feeling Thermometer Scores towards whites among white identifying respondents.") +
  scale_x_continuous(breaks= round(seq(min(cDat$VCF0004), max(cDat$VCF0004), by = 4),1))
ts.plot
ggsave('figures/ft-ts.png')
