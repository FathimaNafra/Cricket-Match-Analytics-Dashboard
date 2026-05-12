library(tidyverse)


matches<-read.csv("data/matches.csv")
deliveries <- read_csv("data/deliveries.csv")

#remove missing values

matches<-na.omit(matches)
deliveries<-na.omit(deliveries)

#remove duplicates

matches <- distinct(matches)
deliveries <- distinct(deliveries)

#check missing values
colSums(is.na(matches))
colSums(is.na(deliveries))

#save cleaned data
write.csv(matches,"data/cleaned_matches.csv",row.names=FALSE)
write.csv(deliveries,"data/cleaned_deliveries.csv",row.names=FALSE)

print("Data cleaning completed")
