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




filter(data, year == 1996 & party == “” |year == 2000 & party == “” | …)
|
OR
data_inc <- filter(~~)
mutate(data, inc = ~~~)
filter(data, inc == TRUE)

# Fundamentals Model: Modified time for change
- I'm going to use 2nd and 3rd quarter data from 
```{r}
# HOW DO I APPLY TO STATE?
tfc_df <- popvote_df %>%
  filter(incumbent_party) %>%
  select(year, candidate, party, pv, pv2p, incumbent) %>%
  inner_join(
    approval_df %>% 
      group_by(year, president) %>% 
      slice(1) %>% 
      # this is a NET APPROVAL
      mutate(net_approve=approve-disapprove) %>% 
      select(year, incumbent_pres=president, net_approve, poll_enddate),
    by="year"
  ) %>%
  inner_join(
    econ_update %>%
      # THIRD QUARTER GDP
      filter(quarter == 3) %>%
      mutate(stock_change = stock_close - stock_open) %>%
      select(GDP_growth_qt, year, RDI_growth, quarter, unemployment, stock_change),
    by="year") 

modi_tfc_fit <- lm(pv2p ~ GDP_growth_qt + RDI_growth + unemployment + incumbent + net_approve, data = tfc_df)
summary(econ_fit)


# prediction data
econ_2020 <- econ_update %>%
  filter(year == 2020, 
         quarter == 3) %>%
  select(year, GDP_growth_qt, RDI_growth, unemployment) %>%
  mutate(incumbent = TRUE, 
         net_approve = -8.8) # got from 538, latest

predict(modi_tfc_fit, new_data = econ_2020)

# how can I split this up to be Dpv2p and Rpv2p ???
# what are all these values??/
tfc_df
```

WHY do many values, WHAT about states?








## Full stuff 
```{r setup, include=FALSE}

library(tidyverse)
library(ggplot2)
library(statebins)
library(stargazer)
library(cowplot)
library(gt)
library(readr)
library(reshape2)
library(statebins)
library(jtools)


knitr::opts_chunk$set(echo = TRUE)
popvote_df    <- read_csv("/Users/carinehajjar/Desktop/R studio/carine-h.github.io/data/popvote_1948-2016.csv")
# 538
pvstate_df    <- read_csv("/Users/carinehajjar/Desktop/R studio/carine-h.github.io/data/popvote_bystate_1948-2016.csv")
economy_df    <- read_csv("/Users/carinehajjar/Desktop/R studio/carine-h.github.io/data/econ.csv")
approval_df   <- read_csv("/Users/carinehajjar/Desktop/R studio/carine-h.github.io/data/approval_gallup_1941-2020.csv")
# 538
pollstate_df  <- read_csv("/Users/carinehajjar/Desktop/R studio/carine-h.github.io/data/pollavg_bystate_1968-2016.csv")
state_pv_df<- read_csv("pred_data/popvote_bystate_1948-2016 copy 2.csv")
app <- read_csv("data/approval_gallup_1941-2020.csv")
# 538: 2020 poll averages per state 
poll_2020_state <- read_csv("/Users/carinehajjar/Desktop/R studio/carine-h.github.io/pred_data/presidential_poll_averages_2020.csv")
econ_update <- read_csv("pred_data/econ_update.csv")
demog <- read_csv("~/Desktop/R studio/carine-h.github.io/data/demographic_1990-2018.csv")
pvstate_df    <- read_csv("~/Desktop/R studio/carine-h.github.io/data/popvote_bystate_1948-2016.csv")
pollstate_df  <- read_csv("~/Desktop/R studio/carine-h.github.io/data/pollavg_bystate_1968-2016.csv")
hispanic_2020 <- read_csv("~/Desktop/R studio/carine-h.github.io/data/csvData.csv")
race_2020 <- read_csv("~/Desktop/R studio/carine-h.github.io/data/demog_race.csv")
electoral_votes <- read_csv("~/Desktop/R studio/carine-h.github.io/data/electoralcollegevotes_1948-2020.csv")

# tidyinig electoral votes for my purposes 
electoral <- electoral_votes %>%
  select(X1, '2020') %>%
  rename(state = X1) %>%
  mutate(state = state.abb[match(state,state.name)]) %>%
  na.omit() 
```


# Time-For-Change Model: NATIONAL

# cleaning and joining data 
tfc_df <- popvote_df %>%
  filter(incumbent_party) %>%
  select(year, candidate, party, pv, pv2p, incumbent) %>%
  inner_join(
    approval_df %>% 
      group_by(year, president) %>% 
      slice(1) %>% 
      # this is a NET APPROVAL
      mutate(net_approve=approve-disapprove) %>% 
      select(year, incumbent_pres=president, net_approve, poll_enddate),
    by="year"
  ) %>%
  inner_join(
    economy_df %>%
      # SECOND QUARTER GDP
      filter(quarter == 2) %>%
      select(GDP_growth_qt, year, RDI_growth, quarter),
    by="year"
  )


fit_tfc <- lm(pv2p ~ GDP_growth_qt + net_approve + incumbent, data = tfc_df)
summary(fit_tfc)

approval_df

export_summs(fit_tfc, model.names = "Time-for-Change Model: \n Relationship Between Popular Vote, \n GDP Growth, Net Approval, and Incumbency")

# 2020 second-quarter GDP
economy_df %>%
  select(year, quarter, GDP_growth_qt, RDI_growth) %>%
  filter(year == 2020, 
         quarter == 3)
# 2020 second quarter approval
approval_df %>%
  filter(year == 2020) %>%
  unique() %>%
  filter(poll_startdate >= as.POSIXct("2020-04-01"), 
         poll_enddate <= as.POSIXct("2020-06-30")) %>%
  mutate(net_approval = approve - disapprove) %>%
  summarise(net = mean(net_approval))


# Time for Change Prediction 
a <- -9.494716	
b <- -8.5 # according to Gallup in 2nd quarter
c <- TRUE

new_data <- data.frame(year = 2020, candidate = "Donald J. Trump", party = "republican", pv = NA, pv2p = NA, incumbent = TRUE, incumbent_pres = NA, net_approve = b, poll_enddate = NA, GDP_growth_qt = a, RDI_growth = NA, quarter = 2, color = "red")
  # - 31.4 decline 
  # net approval: -10.2



predict(fit_tfc, newdata = new_data)

# Model Predicts Trump will get 32.43% of the vote share which is almost certainly a loss 


# IN SAMPLE: adjusted R squared is 0.62: 62% of variance is explained by the model 

# OUT OF SAMPLE: 
# creating color vector for party id 
tfc_df$color[tfc_df$party== "republican"]="red"
tfc_df$color[tfc_df$party== "democrat"]="blue"

# plotting residuals of TFC
plot(tfc_df$year, tfc_df$pv2p, type = "l", 
     main = "Time-For-Change Model: \n True Popular Vote vs. Predicted Popular Vote", 
     xlab = "Year", 
     ylab = "Popular Vote Share",
     ylim = c(40, 65), 
     xlim = c(1950, 2020))
# predicted points
points(tfc_df$year, predict(fit_tfc, tfc_df), 
       col = tfc_df$color)
# legend formatting
legend("topright", 
       legend = c("Actual Outcomes", "Predicted Outcomes", "   Republican", "   Democrat"), 
       col = c("black", "black", "red", "blue"), 
       lwd=1, 
       lty=c(1,NA,NA,NA), 
       pch=c(NA,1,1,1), 
       merge=FALSE, 
       cex = 0.7)

# outsample errors for tfc model
outsamp_errors <- sapply(1:1000, function(i){
years_outsamp <- sample(tfc_df$year, 8)
outsamp_mod <- lm(pv2p ~ GDP_growth_qt + net_approve + incumbent, tfc_df[!(tfc_df$year %in% years_outsamp),])
outsamp_pred <- predict(outsamp_mod, 
                        newdata = tfc_df[tfc_df$year %in% years_outsamp,])
outsamp_true <- tfc_df$pv2p[tfc_df$year %in% years_outsamp]
mean(outsamp_pred - outsamp_true)
})

# visualize in histogram
hist(outsamp_errors,
     xlab = "Out-of-Sample Residual",
     main = "Time-for-Change Model: \n Mean Out-of-Sample Residual (1000 Runs)",
     xlim = c(-15, 15), 
     ylim = c(0, 270))

# quantify by taking the means of the outsample errors 
mean(abs(outsamp_errors))
```






# COMPARINIG MODELS 
```{r}
# ELECTORALS
electoral_votes <- read_csv("~/Desktop/R studio/carine-h.github.io/data/electoralcollegevotes_1948-2020.csv")
# tidyinig electoral votes for my purposes 
electoral <- electoral_votes %>%
  select(X1, '2020') %>%
  rename(state = X1) %>%
  mutate(state = state.abb[match(state,state.name)]) %>%
  na.omit() 


#################
# compare models
#################  
# POLL MODEL
export_summs(fit_state_poll)

poll_pred_2020 %>%
  rename("pred" = "predict(poll_fit, newdata = new_data_poll)") %>%
  mutate(state = rownames(poll_pred_2020), 
         state = state.abb[match(state,state.name)])%>%
  select(state, pred) %>%
  left_join(electoral, by = "state") %>%
  mutate(state_win = case_when(pred > 50 ~ "Biden",
                            pred < 50 ~ "Trump")) %>%
  na.omit()%>%
  group_by(state_win) %>%
  summarise(electoral_votes = sum(`2020`)) %>%
  gt() %>%
  tab_header(title = md("**2020 Electoral Vote Outcome Using 2020 3 Week Poll Model**"), 
               subtitle = "Biden Wins") %>%
   cols_label(state_win = md("**Candidate**"),
               electoral_votes = md("**Total Electoral Votes**")) %>%
  tab_source_note(md("*Data: World Population Review*"))

# DEMOG MODEL
export_summs(mod_demog_change)

demo_pred_2020 %>%
  rename("pred" = "predict(mod_demog_change, newdata = real_2020)") %>%
  select(state, pred) %>%
  left_join(electoral, by = "state") %>%
  mutate(state_win = case_when(pred > 50 ~ "Biden",
                            pred < 50 ~ "Trump")) %>%
  na.omit()%>%
  group_by(state_win) %>%
  summarise(electoral_votes = sum(`2020`)) %>%
  gt() %>%
  tab_header(title = md("**2020 Electoral Vote Outcome Using 2020 Demographic Model**"), 
               subtitle = "Biden Wins") %>%
   cols_label(state_win = md("**Candidate**"),
               electoral_votes = md("**Total Electoral Votes**")) %>%
  tab_source_note(md("*Data: World Population Review*"))

# MODIFIED TFC
export_summs(econ_fit)

```
