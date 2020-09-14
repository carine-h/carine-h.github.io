# BLOG FIGURES
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(tidyverse)
library(ggplot2)
library(usmap)
library(rstanarm)
library(gt)
library(broom.mixed)
library(gtsummary)

popvote_df <- read_csv("popvote_1948-2016.csv")
pvstate_df <- read_csv("popvote_bystate_1948-2016.csv")
```


```{r}
#################
# ORIGINAL: win margin map 2000-2016 
#################
pv_margins_map <- pvstate_df %>%
  filter(year >= 1996)%>%
  mutate(win_margin = (R_pv2p-D_pv2p))

plot_usmap(data = pv_margins_map, regions = "states", values = "win_margin") +
  scale_fill_gradient2(
    high = "red", 
    mid = "white",
    low = "blue", 
    breaks = c(-50,-25,0, 25,50), 
    limits = c(-50, 50),
    name = "Win Margin"
  ) +
  facet_wrap(facet = year ~.)+
  theme_void()+
  labs(title = "Win Margin Map: 1996-2016",
       subtitle = md("Win margin by two party vote")) + 
  theme(panel.background = element_rect(color = "black", fill = "grey"))+
  theme(plot.title = element_text(face = "bold"), 
        plot.subtitle = element_text(face = "italic"))

ggsave("pop_vote_margin_1996_2016.png", height = 4, width = 8)
```


```{r}
#################
# SWING CALCULATIONS
#################
swing_data <- pvstate_df %>%
  select(year, state, D_pv2p) %>% 
  group_by(state) %>% ## need to do this lag WITHIN state
  mutate(D_pv2p_lastyr = lag(D_pv2p, n = 1, order_by = year),
         D_pv2p_lastlastyr = lag(D_pv2p, n = 2, order_by = year),
         swing = D_pv2p - D_pv2p_lastyr) %>%
  ungroup()

swing_data %>%
  filter(year == 2016) %>%
  arrange(swing)

```

```{r}
#SWING MAPS
#################
# ORIGINAL:SWING margin map 2000-2016 
#################
swing_plot_1 <- swing_data %>%
  filter(year >= 1996)

plot_usmap(data = swing_plot_1, regions = "states", values = "swing") +
  scale_fill_gradient2(
    high = "blue", 
    mid = "white",
    low = "red", 
    breaks = c(-50,-25,0,25,50), 
    limits = c(-50,50),
    name = "Swing Margin"
  ) +
  facet_wrap(facet = year ~.)+
  theme_void()+
  labs(title = "Swing Map: 2000-2016",
       subtitle = md("Measure of a state's tendency to swing from one election to the next")) + 
  theme(panel.background = element_rect(color = "black", fill = "grey"))+
  theme(plot.title = element_text(face = "bold"), 
        plot.subtitle = element_text(face = "italic"))

ggsave("swing_margin_1996-2016.png", height = 4, width = 8)

#################
# ORIGINAL:SWING margin map 2016 
#################
swing_plot_2 <- swing_data %>%
  filter(year >= 2012)

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
  facet_wrap(facet = year ~.)+
  theme_void()+
  labs(title = "Swing Map: 2012 and 2016",
       subtitle = md("Measure of a state's tendency to swing from one election to the next")) + 
  theme(panel.background = element_rect(color = "black", fill = "grey"))+
  theme(plot.title = element_text(face = "bold"), 
        plot.subtitle = element_text(face = "italic"))

ggsave("swing_margin_2012_2016.png", height = 4, width = 8)

```

```{r}
#################
# TEXAS AND US MARGINS
#################

x <- popvote_df%>%
  select(year, party, pv2p)%>%
  spread(party, pv2p)%>%
  mutate(overall_pv2_margin = republican - democrat)

y <- pvstate_df%>%
  filter(state == "Texas")

a <- left_join(x, y)%>%
  select(year, state, vote_margin, overall_pv2_margin)%>% 
  rename(TX_pv2_margin = vote_margin) %>%
  filter(year >= 1960)

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
library(directlabels)

ggplot(data = a, aes(x = year, y = TX_pv2_margin))+
  geom_line(aes(x = year, y = TX_pv2_margin),colour = "black", linetype = "dotted")+
  geom_line(aes(x = year, y = overall_pv2_margin), colour = "black")+
  geom_rect(aes(ymin = -30, ymax = 0, xmin = 1960, xmax = 2016, fill = 'blue'), alpha = .01)+
  geom_rect(aes(ymin = 0, ymax = 40, xmin = 1960, xmax = 2016, fill = 'red'), alpha = .01)+
  scale_fill_manual(values = alpha(c("blue", "red")))+
  labs(title = "Two Party Vote Share Margin: The U.S. and Texas", 
       subtitle = "Vote margin from 1960-2000", 
       x = "Year", 
       y = "Two Party Vote Margin")+
  my_pretty_theme+
  theme(plot.title = element_text(face = "bold"), 
        legend.position = "none")+
  scale_x_continuous(breaks = seq(from = 1960, to = 2016, by = 4))+
  geom_dl(aes(label = state), method = list(dl.trans(x = x + 0.05), "last.points", cex = 0.6))

ggsave("pop_vote_texas.png", height = 4, width = 8)


```

