library(ggplot2)
library(tidyverse)

matches <- read.csv("data/cleaned_matches.csv")
deliveries <- read.csv("data/cleaned_deliveries.csv")

#matches per season
ggplot(matches,aes(x=season)) +
  geom_bar(fill="steelblue")+
  labs(
    title="Matches per season",
    x="Season",
    y="Number of matches"
  )

#top winning teams

top_teams <- matches %>%
    count(winner,sort=TRUE) %>%
    head(10)

ggplot(top_teams,aes(x=reorder(winner,n),y=n))+
  geom_col(fill="darkgreen")+
  coord_flip()+
  labs(
    title="Top Winning Teams",
    x="Team",
    y="Wins"
  )

# Top run scores

top_batsman <- deliveries %>%
  group_by(batsman) %>% 
  summarise(total_runs=sum(batsman_runs)) %>%
  arrange(desc(total_runs))%>%
  head(10)

ggplot(top_batsman,aes(x=reorder(batsman,total_runs),y=total_runs))+
 geom_col(fill="orange")+
 coord_flip()+
 labs(
    title="Top Run Scores",
    x="Player",
    y="Runs"
 )
