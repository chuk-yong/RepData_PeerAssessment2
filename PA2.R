setwd("~/Desktop/Rstudio/RepData_PeerAssessment2")
Data <- read.csv("repdata-data-StormData.csv")

library(dplyr)

FataData <- Data %>% group_by(EVTYPE) %>% summarise(FATAL=sum(FATALITIES)+sum(INJURIES)) %>% arrange(desc(FATAL))
FataDataClean <- FataData[1:20,]

# Order the dataframe with the right factor level.  If not, ggplot will order them alphabetically
FataDataClean$EVTYPE <- factor(FataDataClean$EVTYPE, levels = FataDataClean$EVTYPE[order(FataDataClean$FATAL)])

#
library(ggplot2)
plot <- ggplot(FataDataClean, aes(x=FataDataClean$EVTYPE, y=FataDataClean$FATAL)) +
  geom_bar(stat = "identity") + 
  # Flip the x-y so that the "Type" is easier to read
  coord_flip() +
  xlab("Type of Event") + ylab("Number of Fatality") + ggtitle("Top 20 Fatal Weather Events in the United States")
plot

