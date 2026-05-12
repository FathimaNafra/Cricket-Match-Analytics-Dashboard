library(tidyverse)

matches <- read.csv("data/matches.csv")
deliveries <- read.csv("data/deliveries.csv")

print(head(matches))
print(head(deliveries))

print(str(matches))
print(str(deliveries))

print(summary(matches))
print(summary(deliveries))