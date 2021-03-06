
knitr::opts_chunk$set(echo = TRUE)
library(tidyverse)
library(ggplot2)
library(usmap)
library(rstanarm)
library(gt)
library(broom.mixed)
library(gtsummary)



# read in national pop vote 
popvote_df <- read_csv("popvote_1948-2016.csv")

# read in state pop vote
pvstate_df <- read_csv("popvote_bystate_1948-2016.csv")


#################
# Vote margins 2000, 2016
#################
## map: win-margins 2000
# I found the win margins for 2000
pv_margins_map2000 <- pvstate_df %>%
  filter(year == 2000) %>%
  mutate(win_margin = (R_pv2p-D_pv2p))

# I plotted the 2000 win margin using plot_usmap()
plot_usmap(data = pv_margins_map2000, regions = "states", values = "win_margin") +
  scale_fill_gradient2(
    high = "red", 
    # mid = scales::muted("purple"), ##TODO: purple or white better?
    mid = "white",
    low = "blue", 
    breaks = c(-50,-25,0,25,50), 
    limits = c(-50,50),
    name = "win margin"
  ) +
  theme_void()

## map: win-margins 2016
# I found the win margins for 2016
pv_margins_map2016 <- pvstate_df %>%
  filter(year == 2016) %>%
  mutate(win_margin = (R_pv2p-D_pv2p))

# I plotted the 2016 win margin using plot_usmap()
plot_usmap(data = pv_margins_map2016, regions = "states", values = "win_margin") +
  scale_fill_gradient2(
    high = "red", 
    mid = "white",
    low = "blue", 
    breaks = c(-50,-25,0,25,50), 
    limits = c(-50,50),
    name = "win margin"
  ) +
  theme_void()+
  # I added titles and refined the theme
  labs(title = "Win Margin Map: 2000",
       subtitle = md("Win margin by two party popular vote")) + 
  theme(panel.background = element_rect(color = "black", fill = "grey"))+
  theme(plot.title = element_text(face = "bold"), 
        plot.subtitle = element_text(face = "italic"))


#################
# party winners 
#################
# party winners based on popular vote from 1996 to 2016
pv_map_grid <- pvstate_df %>%
  filter(year >= 1996) %>%
  mutate(winner = ifelse(R_pv2p > D_pv2p, "republican", "democrat"))  # the winner is designated as the one with most of vote share 

# This plots the party winners based on the two party popular vote
plot_usmap(data = pv_map_grid, regions = "states", values = "winner", color = "white") +
  facet_wrap(facets = year ~.) + 
  scale_fill_manual(values = c("blue", "red"), name = "Two Party Popular Vote Winner") +
  theme_void() +
  theme(strip.text = element_text(size = 12),
        aspect.ratio=1) +
  theme_void()+
  # I refined the theme here 
  labs(title = "Two Party Popular Vote: 1996-2016",
       subtitle = md("Party with larger two party popular vote")) + 
  theme(panel.background = element_rect(color = "black", fill = "grey"))+
  theme(plot.title = element_text(face = "bold"), 
        plot.subtitle = element_text(face = "italic"))


#################
# ORIGINAL: win margin map 2000-2016 
#################
# I found the win margin for each election in each state from 1996-2016
pv_margins_map <- pvstate_df %>%
  filter(year >= 1996)%>%
  mutate(win_margin = (R_pv2p-D_pv2p))

# I plotted the win margin using plot_usmap
plot_usmap(data = pv_margins_map, regions = "states", values = "win_margin") +
  scale_fill_gradient2(
    high = "red", 
    mid = "white",
    low = "blue", 
    breaks = c(-50,-25,0, 25,50), 
    limits = c(-50, 50),
    name = "Win Margin"
  ) +
  # I facetted by year to show the change over time
  facet_wrap(facet = year ~.)+
  theme_void()+
  # I refined the title and general display
  labs(title = "Win Margin Map: 1996-2016",
       subtitle = md("Win margin by two party vote")) + 
  theme(panel.background = element_rect(color = "black", fill = "grey"))+
  theme(plot.title = element_text(face = "bold"), 
        plot.subtitle = element_text(face = "italic"))

# I save the image 
ggsave("pop_vote_margin_1996_2016.png", height = 2, width = 4)


#################
# SWING CALCULATIONS
#################

# Here I calculate the year by year "swing" in each state overtime 
swing_data <- pvstate_df %>%
  select(year, state, D_pv2p) %>% 
  group_by(state) %>% ## need to do this lag WITHIN state
  mutate(D_pv2p_lastyr = lag(D_pv2p, n = 1, order_by = year),
         D_pv2p_lastlastyr = lag(D_pv2p, n = 2, order_by = year),
         swing = D_pv2p - D_pv2p_lastyr) %>%  ## the swing is the change in pop vote share one year to next 
  ungroup()

# I arrange the swing in order to see which states swung left and right the most
swing_data %>%
  filter(year == 2016) %>%
  arrange(swing)


#################
# ORIGINAL:SWING margin map 2000-2016 
#################
# this is the data for a swing plot for 1996-2016
swing_plot_1 <- swing_data %>%
  filter(year >= 1996)

# I plotted the swing margin using plot_usmap
plot_usmap(data = swing_plot_1, regions = "states", values = "swing") +
  scale_fill_gradient2(
    high = "blue", 
    mid = "white",
    low = "red", 
    breaks = c(-50,-25,0,25,50), 
    limits = c(-50,50),
    name = "Swing Margin"
  ) +
  # I facetted by year to show the progression overtime
  facet_wrap(facet = year ~.)+
  # I refined the titles and display
  theme_void()+
  labs(title = "Swing Map: 2000-2016",
       subtitle = md("Measure of a state's tendency to swing from one election to the next")) + 
  theme(panel.background = element_rect(color = "black", fill = "grey"))+
  theme(plot.title = element_text(face = "bold"), 
        plot.subtitle = element_text(face = "italic"))

# I saved the image 
ggsave("swing_margin_1996-2016.png", height = 2, width = 4)

#################
# ORIGINAL:SWING margin map 2012 - 2016 
#################
# this is the data for a swing plot for 2012-2016
swing_plot_2 <- swing_data %>%
  filter(year >= 2012)

# I plotted the swing margin using plot_usmap
plot_usmap(data = swing_plot_2, regions = "states", values = "swing") +
  scale_fill_gradient2(
    high = "blue", 
    # mid = scales::muted("purple"), ##TODO: purple or white better?
    mid = "white",
    low = "red", 
    breaks = c(-50,-25, 0, 25, 50), 
    limits = c(-50, 50),
    name = "Swing Margin"
  ) +
  # I facetted by year to show the progression overtime
  facet_wrap(facet = year ~.)+
  # I refined the titles and display
  theme_void()+
  labs(title = "Swing Map: 2012 and 2016",
       subtitle = md("Measure of a state's tendency to swing from one election to the next")) + 
  theme(panel.background = element_rect(color = "black", fill = "grey"))+
  theme(plot.title = element_text(face = "bold"), 
        plot.subtitle = element_text(face = "italic"))

# I saved the resulting image
ggsave("swing_margin_2012_2016.png", height = 2, width = 4)


#################
# TEXAS AND US MARGINS
#################

# I found the annual win margin on the national basis
x <- popvote_df%>%
  select(year, party, pv2p)%>%
  spread(party, pv2p)%>%
  mutate(overall_pv2_margin = republican - democrat)

# I shrunk the data to just Texas figures, including the Texas win margin
y <- pvstate_df%>%
  filter(state == "Texas")

# I joined the two data sets to compare national and Texas vote margins 
a <- left_join(x, y)%>%
  select(year, state, R_pv2p, D_pv2p, overall_pv2_margin)%>% 
  rename(TX_pv2_margin = R_pv2p - Dpv2p) %>%
  filter(year >= 1960)

# I updated my_pretty_theme 
my_pretty_theme <- theme_bw() + 
  theme(panel.border = element_blank(),
        plot.subtitle = element_text(hjust = 0.5),
        plot.title   = element_text(size = 15, hjust = 0.5), 
        axis.text.x  = element_text(angle = 45, hjust = 1),
        axis.text    = element_text(size = 12),
        strip.text   = element_text(size = 18),
        axis.line    = element_line(colour = "black"),
        legend.position = "top",
        legend.text = element_text(size = 12))

# This library allows me to label the Texas line
library(directlabels)

# I plotted the Texas and the national vote margin from 1960-2000
ggplot(data = a, aes(x = year, y = TX_pv2_margin))+
  geom_line(aes(x = year, y = TX_pv2_margin),colour = "black", linetype = "dotted")+
  geom_line(aes(x = year, y = overall_pv2_margin), colour = "black")+
  # This highlighted the graph to denote a R or D vote share majority
  geom_rect(aes(ymin = -30, ymax = 0, xmin = 1960, xmax = 2016, fill = 'blue'), alpha = .01)+
  geom_rect(aes(ymin = 0, ymax = 40, xmin = 1960, xmax = 2016, fill = 'red'), alpha = .01)+
  scale_fill_manual(values = alpha(c("blue", "red")))+
  # I entitled the axes
  labs(title = "Two Party Vote Share Margin: The U.S. and Texas", 
       subtitle = "Vote margin from 1960-2000", 
       x = "Year", 
       y = "Two Party Vote Margin")+
  my_pretty_theme+
  theme(plot.title = element_text(face = "bold"), 
        legend.position = "none")+
  # I labelled each year
  scale_x_continuous(breaks = seq(from = 1960, to = 2016, by = 4))+
  # This labels the Texas line
  geom_dl(aes(label = state), method = list(dl.trans(x = x + 0.05), "last.points", cex = 0.6))

# I saved the figure
ggsave("pop_vote_texas.png", height = 2, width = 4)


