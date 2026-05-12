library(ggplot2)
library(tidyverse)

matches <- read.csv("data/cleaned_matches.csv")
deliveries <- read.csv("data/cleaned_deliveries.csv")

# Create outputs folder if it doesn't exist
if (!dir.exists("outputs")) {
  dir.create("outputs")
}

#matches per season
p1 <- ggplot(matches,aes(x=season)) +
  geom_bar(fill="steelblue")+
  labs(
    title="Matches per season",
    x="Season",
    y="Number of matches"
  )
ggsave("outputs/matches_per_season.png", p1, width=10, height=6)
print(p1)

#top winning teams

top_teams <- matches %>%
    count(winner,sort=TRUE) %>%
    head(10)

p2 <- ggplot(top_teams,aes(x=reorder(winner,n),y=n))+
  geom_col(fill="darkgreen")+
  coord_flip()+
  labs(
    title="Top Winning Teams",
    x="Team",
    y="Wins"
  )
ggsave("outputs/top_winning_teams.png", p2, width=10, height=6)
print(p2)

# Top run scores

top_batsman <- deliveries %>%
  group_by(batsman) %>% 
  summarise(total_runs=sum(batsman_runs)) %>%
  arrange(desc(total_runs))%>%
  head(10)

p3 <- ggplot(top_batsman,aes(x=reorder(batsman,total_runs),y=total_runs))+
 geom_col(fill="orange")+
 coord_flip()+
 labs(
    title="Top Run Scores",
    x="Player",
    y="Runs"
 )
ggsave("outputs/top_run_scores.png", p3, width=10, height=6)
print(p3)
