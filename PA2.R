setwd("~/Desktop/Rstudio/RepData_PeerAssessment2")
Data <- read.csv("repdata-data-StormData.csv")

library(dplyr)

FataData <- Data %>% group_by(EVTYPE) %>% 
  summarise(FATAL=sum(FATALITIES)+sum(INJURIES)) %>% 
  arrange(desc(FATAL))
FataDataClean <- FataData[1:20,]

# Order the dataframe with the right factor level.  If not, ggplot will order them alphabetically
FataDataClean$EVTYPE <- factor(FataDataClean$EVTYPE, levels = FataDataClean$EVTYPE[order(FataDataClean$FATAL)])

# plot
library(ggplot2)
plot <- ggplot(FataDataClean, aes(x=FataDataClean$EVTYPE, y=FataDataClean$FATAL)) +
  geom_bar(stat = "identity") + 
  # Flip the x-y so that the "Type" is easier to read
  coord_flip() +
  xlab("") + ylab("Number of Fatality") + ggtitle("Top 20 Fatal Weather Events in the United States")
plot

# Calculate economic damages: total of property and crop damages
# Create a data frame of Economic Damage Data.Where PROPDMG and CROPDMG both has values, convert "K, M, B" to appropiate amount, total and rank them
EconData <- Data %>%
  filter(PROPDMG>0 | Data$CROPDMG>0) %>%
  select(EVTYPE,PROPDMG,PROPDMGEXP,CROPDMG,CROPDMGEXP) %>%
  mutate(PROPDMG = PROPDMG*(ifelse(PROPDMGEXP == "K",1000, ifelse(PROPDMGEXP == "M",1000000,ifelse(PROPDMGEXP == "B",1000000000,1))))) %>%
  mutate(CROPDMG = CROPDMG*(ifelse(CROPDMGEXP == "K",1000, ifelse(CROPDMGEXP == "M",1000000,ifelse(CROPDMGEXP == "B",1000000000,1))))) %>%
  mutate(TOTDMG = PROPDMG+CROPDMG)

# Get the total damage by type of weather event, rank and take the top 20
EconDataSum <- EconData %>% group_by(EVTYPE) %>% 
  summarise(TOTECONDMG = sum(TOTDMG)) %>%
  arrange(desc(TOTECONDMG)) %>%
  slice(1:20)

# Get the right factor level before ggplot
EconDataSum$EVTYPE <- factor(EconDataSum$EVTYPE, levels = EconDataSum$EVTYPE[order(EconDataSum$TOTECONDMG)])

# plot
plot <- ggplot(EconDataSum, aes(x=EconDataSum$EVTYPE, y=EconDataSum$TOTECONDMG)) +
  geom_bar(stat = "identity") +
  # Flip the x-y so that the "Type" is easier to read
  coord_flip() + 
  xlab("") + ylab("Economic Cost ") + ggtitle("Top 20 Most Costly Weather Events (USA)")
plot

