# ASK HOW TO MERGE DATA HERE - making a state-by-state prediction
## POLL PREDICTION
summary(pollstate_df) # 1972-201
# going to use 10 weeks and under - better predictions 
summary(state_pv_df) # 1948-2016 

# to insert incumbency for each year
x <- popvote_df %>%
  mutate(party = ifelse(party == "democrat", "D", "R"))

# poll data
poll_state <- poll_state_df %>%
  filter(weeks_left <= 10) %>%
  select(year, state, party, poll_date, weeks_left, avg_poll) %>%
  left_join(popvote_df, c("year", "party")) %>%
  mutate(party = ifelse(party == "democrat", "D", "R")) %>%
  select(year, state, party, weeks_left, avg_poll, winner, candidate, incumbent)

# state pv data made longer with incumbency
state_pv <- state_pv_df %>%
  select(year, state, D, R, R_pv2p, D_pv2p) %>%
  melt(id.vars = c("year", "state"), 
       measure.vars = c("R_pv2p", "D_pv2p")) %>%
  mutate(variable = as.character(variable)) %>%
  mutate(party = ifelse(variable == "R_pv2p", "R", "D")) %>%
  select(year, state, party, value) %>%
  rename("pv2" = "value") %>%
  left_join(x, c("year", "party")) %>%
  select(year, state, party, pv2, incumbent, winner, candidate) %>%
  left_join(poll_state, c("year", "party", "state", "candidate", "incumbent", "winner")) %>%
  select(year, state, party, pv2, avg_poll, weeks_left, incumbent) 
## model 
poll_fit <- lm(pv2 ~ avg_poll + state, data = state_pv)
summary(poll_fit)

## prediction : take the average for each state
new_data_poll <- poll_2020_state %>%
  rename(year = cycle) %>%
  group_by(state) %>%
  summarize(avg_poll = mean(pct_estimate)) %>%
  filter(state != "ME-1", 
         state != "ME-2",
         state != "NE-1", 
         state != "NE-2", 
         state != "National")

pred_2020 <- predict(poll_fit, newdata = new_data_poll)


plot(state_pv$avg_poll, state_pv$pv2,
     xlim= c(0,100))
line(state_pv$pv2)

dem_poll <- poll_state %>%
  subset(subset = party == "D") %>%
  rename(D_poll = avg_poll)
rep_poll <- poll_state %>%
  subset(subset = party == "R") %>%
  rename(R_poll = avg_poll)

poll <- dem_poll %>%
  left_join(rep_poll, by = c("year", "state", "weeks_left")) %>%
  mr(year, state, weeks_left, D_pv2p, R_pv2p, )