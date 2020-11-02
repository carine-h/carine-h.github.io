---
title: "blog_pred"
author: "Carine Hajjar"
date: "10/28/2020"
output:
  pdf_document: default
  html_document: default
---
# Assignment

You should report your prediction for the national result (total Electoral College votes and, if you generated it, the national popular vote) and state-level winners and include a description of how you arrived at your prediction.  

Your entry should also include the following elements (not necessarily in this order):
(1) model formula (or procedure for obtaining prediction), 
(2) model description and justification, 
(3) coefficients (if using regression) and/or weights (if using ensemble), 
(4) interpretation of coefficients and/or justification of weights, 
(5) model validation (recommended to include both in-sample and out-of-sample performance unless it is impossible due to the characteristics of model and related data availability), 
(6) uncertainty around prediction (e.g. predictive interval)
(7) graphic(s) showing your prediction






# MY MODELS
## Models for my weighted ensemble: 
  - polls
  - economy/incumbency
  - demographic: already done

## POLLS 
Using polls from 3 weeks out and predicted with 2020 average polls in each state from 10/8 to today (also three weeks)

```r
dat <- state_pv_df %>%
  filter(state != "District of Columbia") %>% 
  full_join(poll_state_df %>% 
              filter(weeks_left <= 10) %>% 
              group_by(year,party,state) %>% 
              summarise(avg_poll=mean(avg_poll)),
            by = c("year" ,"state")) %>%
   filter(state != "District of Columbia", 
         state != "ME-1", 
         state != "ME-2",
         state != "NE-1", 
         state != "NE-2",
         state != "NE-3",
         state != "National", 
         party == "democrat") 
```

```
## `summarise()` regrouping output by 'year', 'party' (override with `.groups` argument)
```

```r
# MODEL
fit_state_poll <- lm(D_pv2p ~ avg_poll + as.factor(state), data = dat)
summary(fit_state_poll)
```

```
## 
## Call:
## lm(formula = D_pv2p ~ avg_poll + as.factor(state), data = dat)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -9.5120 -2.5594 -0.3622  2.2184 11.7276 
## 
## Coefficients:
##                                Estimate Std. Error t value Pr(>|t|)    
## (Intercept)                    13.88210    1.62726   8.531 2.26e-16 ***
## avg_poll                        0.74106    0.02719  27.259  < 2e-16 ***
## as.factor(state)Alaska         -0.95156    1.91938  -0.496 0.620303    
## as.factor(state)Arizona         3.08580    1.79396   1.720 0.086104 .  
## as.factor(state)Arkansas        1.18755    1.79864   0.660 0.509433    
## as.factor(state)California      5.38903    1.69377   3.182 0.001566 ** 
## as.factor(state)Colorado        3.10413    1.71242   1.813 0.070545 .  
## as.factor(state)Connecticut     6.23893    1.68513   3.702 0.000240 ***
## as.factor(state)Delaware        8.14918    1.80132   4.524 7.78e-06 ***
## as.factor(state)Florida         1.39353    1.75309   0.795 0.427095    
## as.factor(state)Georgia         2.84805    1.75644   1.621 0.105617    
## as.factor(state)Hawaii         10.83520    1.82390   5.941 5.70e-09 ***
## as.factor(state)Idaho          -1.09614    1.80934  -0.606 0.544938    
## as.factor(state)Illinois        5.34164    1.69313   3.155 0.001714 ** 
## as.factor(state)Indiana         1.36953    1.84994   0.740 0.459499    
## as.factor(state)Iowa            4.12228    1.71931   2.398 0.016910 *  
## as.factor(state)Kansas          0.28481    1.74997   0.163 0.870788    
## as.factor(state)Kentucky       -0.65350    1.74880  -0.374 0.708816    
## as.factor(state)Louisiana       3.38059    1.79413   1.884 0.060178 .  
## as.factor(state)Maine           7.13893    1.75744   4.062 5.74e-05 ***
## as.factor(state)Maryland        7.61410    1.73144   4.398 1.37e-05 ***
## as.factor(state)Massachusetts   9.37534    1.70600   5.496 6.55e-08 ***
## as.factor(state)Michigan        5.62308    1.71608   3.277 0.001132 ** 
## as.factor(state)Minnesota       5.79974    1.69178   3.428 0.000664 ***
## as.factor(state)Mississippi     1.28284    1.84925   0.694 0.488223    
## as.factor(state)Missouri        3.21574    1.67989   1.914 0.056224 .  
## as.factor(state)Montana         2.59623    1.84917   1.404 0.161012    
## as.factor(state)Nebraska       -1.40831    1.75235  -0.804 0.422013    
## as.factor(state)Nevada          4.19062    1.79527   2.334 0.020024 *  
## as.factor(state)New Hampshire   2.89702    1.79898   1.610 0.108022    
## as.factor(state)New Jersey      5.37194    1.68349   3.191 0.001518 ** 
## as.factor(state)New Mexico      4.79273    1.80349   2.657 0.008154 ** 
## as.factor(state)New York        8.59700    1.70119   5.054 6.33e-07 ***
## as.factor(state)North Carolina  1.10358    1.68093   0.657 0.511822    
## as.factor(state)North Dakota   -0.85474    1.79574  -0.476 0.634320    
## as.factor(state)Ohio            1.80985    1.68453   1.074 0.283226    
## as.factor(state)Oklahoma       -2.51062    1.75137  -1.434 0.152406    
## as.factor(state)Oregon          5.44152    1.68635   3.227 0.001344 ** 
## as.factor(state)Pennsylvania    4.00409    1.71872   2.330 0.020266 *  
## as.factor(state)Rhode Island   10.30050    1.77558   5.801 1.25e-08 ***
## as.factor(state)South Carolina  1.90348    1.79537   1.060 0.289617    
## as.factor(state)South Dakota    1.98418    1.74911   1.134 0.257236    
## as.factor(state)Tennessee      -0.41926    1.79916  -0.233 0.815843    
## as.factor(state)Texas           1.21327    1.74855   0.694 0.488122    
## as.factor(state)Utah           -2.67755    1.76715  -1.515 0.130433    
## as.factor(state)Vermont        10.31667    1.94144   5.314 1.69e-07 ***
## as.factor(state)Virginia        2.83583    1.75026   1.620 0.105887    
## as.factor(state)Washington      6.71293    1.71833   3.907 0.000108 ***
## as.factor(state)West Virginia   1.78903    1.75173   1.021 0.307666    
## as.factor(state)Wisconsin       4.85223    1.75759   2.761 0.006004 ** 
## as.factor(state)Wyoming        -0.51943    2.01572  -0.258 0.796764    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3.806 on 448 degrees of freedom
## Multiple R-squared:  0.837,	Adjusted R-squared:  0.8188 
## F-statistic: 46.02 on 50 and 448 DF,  p-value: < 2.2e-16
```

```r
export_summs(fit_state_poll)
```

```{=latex}
 
  \providecommand{\huxb}[2]{\arrayrulecolor[RGB]{#1}\global\arrayrulewidth=#2pt}
  \providecommand{\huxvb}[2]{\color[RGB]{#1}\vrule width #2pt}
  \providecommand{\huxtpad}[1]{\rule{0pt}{#1}}
  \providecommand{\huxbpad}[1]{\rule[-#1]{0pt}{#1}}

\begin{table}[ht]
\begin{centerbox}
\begin{threeparttable}
 \label{tab:unnamed-chunk-1}
\setlength{\tabcolsep}{0pt}
\begin{tabular}{l l}


\hhline{>{\huxb{0, 0, 0}{0.8}}->{\huxb{0, 0, 0}{0.8}}-}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}c!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\centering \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{c!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\centering \hspace{6pt} Model 1 \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{255, 255, 255}{0.4}}->{\huxb{0, 0, 0}{0.4}}-}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} (Intercept) \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 13.88 *** \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.63)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} avg\_poll \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 0.74 *** \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (0.03)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Alaska \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} -0.95~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.92)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Arizona \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 3.09~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.79)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Arkansas \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 1.19~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.80)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)California \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 5.39 **~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.69)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Colorado \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 3.10~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.71)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Connecticut \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 6.24 *** \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.69)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Delaware \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 8.15 *** \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.80)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Florida \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 1.39~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.75)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Georgia \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 2.85~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.76)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Hawaii \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 10.84 *** \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.82)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Idaho \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} -1.10~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.81)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Illinois \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 5.34 **~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.69)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Indiana \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 1.37~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.85)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Iowa \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 4.12 *~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.72)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Kansas \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 0.28~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.75)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Kentucky \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} -0.65~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.75)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Louisiana \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 3.38~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.79)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Maine \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 7.14 *** \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.76)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Maryland \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 7.61 *** \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.73)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Massachusetts \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 9.38 *** \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.71)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Michigan \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 5.62 **~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.72)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Minnesota \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 5.80 *** \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.69)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Mississippi \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 1.28~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.85)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Missouri \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 3.22~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.68)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Montana \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 2.60~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.85)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Nebraska \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} -1.41~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.75)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Nevada \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 4.19 *~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.80)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)New Hampshire \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 2.90~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.80)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)New Jersey \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 5.37 **~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.68)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)New Mexico \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 4.79 **~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.80)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)New York \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 8.60 *** \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.70)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)North Carolina \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 1.10~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.68)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)North Dakota \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} -0.85~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.80)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Ohio \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 1.81~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.68)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Oklahoma \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} -2.51~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.75)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Oregon \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 5.44 **~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.69)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Pennsylvania \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 4.00 *~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.72)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Rhode Island \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 10.30 *** \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.78)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)South Carolina \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 1.90~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.80)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)South Dakota \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 1.98~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.75)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Tennessee \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} -0.42~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.80)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Texas \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 1.21~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.75)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Utah \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} -2.68~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.77)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Vermont \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 10.32 *** \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.94)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Virginia \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 2.84~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.75)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Washington \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 6.71 *** \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.72)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)West Virginia \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 1.79~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.75)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Wisconsin \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 4.85 **~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (1.76)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} as.factor(state)Wyoming \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} -0.52~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} (2.02)~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{255, 255, 255}{0.4}}->{\huxb{0, 0, 0}{0.4}}-}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} N \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 499~~~~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}

\multicolumn{1}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt} R2 \hspace{6pt}\huxbpad{6pt}} &
\multicolumn{1}{r!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedleft \hspace{6pt} 0.84~~~~ \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{>{\huxb{0, 0, 0}{0.8}}->{\huxb{0, 0, 0}{0.8}}-}
\arrayrulecolor{black}

\multicolumn{2}{!{\huxvb{0, 0, 0}{0}}l!{\huxvb{0, 0, 0}{0}}}{\huxtpad{6pt + 1em}\raggedright \hspace{6pt}  *** p $<$ 0.001;  ** p $<$ 0.01;  * p $<$ 0.05. \hspace{6pt}\huxbpad{6pt}} \tabularnewline[-0.5pt]


\hhline{}
\arrayrulecolor{black}
\end{tabular}
\end{threeparttable}\par\end{centerbox}

\end{table}
 
```

```r
## prediction : take the average for each state
    # average of three weeks ago: October 8
new_data_poll <- poll_2020_state %>%
  filter(candidate_name %in% c("Joseph R. Biden Jr.",  "Convention Bounce for Joseph R. Biden Jr.")) %>%
  filter(state != "District of Columbia", 
         state != "ME-1", 
         state != "ME-2",
         state != "NE-1", 
         state != "NE-2", 
         state != "National") %>%
  mutate(date = as.Date(modeldate, format = "%m/%d/%Y")) %>%
  filter(date >= as.Date("2020-10-08")) %>%
  rename(year = cycle) %>%
  group_by(state) %>%
  summarize(avg_poll = mean(pct_estimate))  ## average poll since 10/8 per state for joe biden
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
plot(dat$avg_poll, dat$D_pv2p,
         main="Overall Relationship Between Vote Share and Polls", xlab="Average Poll for Democratic Candidate", ylab="Democratic Vote Share")
    abline(lm(dat$D_pv2p ~ dat$avg_poll, data = dat)) 
```

![](blog_pred_files/figure-latex/unnamed-chunk-1-1.pdf)<!-- --> 

```r
# 2020 PREDICTION
pred_2020 <- predict(fit_state_poll, newdata = new_data_poll)
poll_pred_2020 <- tibble(state = new_data_poll$state, pred = pred_2020)

poll_pred_2020 %>%  ##`statebins` needs state to be character, not factor!
  ggplot(aes(state = state, fill = (pred >= 50))) +
  geom_statebins() +
  theme_statebins() +
  labs(title = "Poll Model: Electoral Vote Prediction",
       subtitle = "2020 Prediction",
       fill = "", 
       caption = "Date: FiveThirtyEight") +
  theme(legend.position = "none", 
        plot.subtitle = element_text(size = 10, hjust = 0.5),
        plot.title   = element_text(size = 12, hjust = 0.5, face = "bold"))
```

![](blog_pred_files/figure-latex/unnamed-chunk-1-2.pdf)<!-- --> 

```r
poll_pred_2020  %>%
  select(state, pred) %>%
  mutate(state =  state.abb[match(state,state.name)]) %>%
  left_join(electoral, by = "state") %>%
  mutate(state_win = case_when(pred > 50 ~ "Biden",
                            pred < 50 ~ "Trump")) %>%
  group_by(state_win) %>%
  summarise(electoral_votes = sum(`2020`)) %>%
  gt() %>%
  tab_header(title = md("**2020 Electoral Vote Outcome Using Poll Model**"), 
               subtitle = "Biden Wins") %>%
   cols_label(state_win = md("**Candidate**"),
               electoral_votes = md("**Total Electoral Votes**")) %>%
  tab_source_note(md("*Data: FiveThirtyEight*")) 
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

\captionsetup[table]{labelformat=empty,skip=1pt}
\begin{longtable}{lr}
\caption*{
\large \textbf{2020 Electoral Vote Outcome Using Poll Model}\\ 
\small Biden Wins\\ 
} \\ 
\toprule
\textbf{Candidate} & \textbf{Total Electoral Votes} \\ 
\midrule
Biden & 282 \\ 
Trump & 253 \\ 
\bottomrule
\end{longtable}
\begin{minipage}{\linewidth}
\emph{Data: FiveThirtyEight}\\ 
\end{minipage}



# DEMOGRAPHICS

```r
demog <- read_csv("~/Desktop/R studio/carine-h.github.io/data/demographic_1990-2018.csv")
```

```
## Parsed with column specification:
## cols(
##   year = col_double(),
##   state = col_character(),
##   Asian = col_double(),
##   Black = col_double(),
##   Hispanic = col_double(),
##   Indigenous = col_double(),
##   White = col_double(),
##   Female = col_double(),
##   Male = col_double(),
##   age20 = col_double(),
##   age3045 = col_double(),
##   age4565 = col_double(),
##   age65 = col_double(),
##   total = col_double()
## )
```

```r
pvstate_df    <- read_csv("~/Desktop/R studio/carine-h.github.io/data/popvote_bystate_1948-2016.csv")
```

```
## Parsed with column specification:
## cols(
##   state = col_character(),
##   year = col_double(),
##   total = col_double(),
##   D = col_double(),
##   R = col_double(),
##   R_pv2p = col_double(),
##   D_pv2p = col_double()
## )
```

```r
pollstate_df  <- read_csv("~/Desktop/R studio/carine-h.github.io/data/pollavg_bystate_1968-2016.csv")
```

```
## Parsed with column specification:
## cols(
##   year = col_double(),
##   state = col_character(),
##   party = col_character(),
##   candidate_name = col_character(),
##   poll_date = col_date(format = ""),
##   weeks_left = col_double(),
##   days_left = col_double(),
##   before_convention = col_logical(),
##   avg_poll = col_double()
## )
```

```r
hispanic_2020 <- read_csv("~/Desktop/R studio/carine-h.github.io/data/csvData.csv")
```

```
## Parsed with column specification:
## cols(
##   State = col_character(),
##   HispanicTotal = col_double(),
##   HispanicPerc = col_double()
## )
```

```r
race_2020 <- read_csv("~/Desktop/R studio/carine-h.github.io/data/demog_race.csv")
```

```
## Parsed with column specification:
## cols(
##   State = col_character(),
##   WhitePerc = col_double(),
##   BlackPerc = col_double(),
##   NativePerc = col_double(),
##   AsianPerc = col_double(),
##   IslanderPerc = col_double(),
##   OtherRacePerc = col_double(),
##   TwoOrMoreRacesPerc = col_double()
## )
```

```r
electoral_votes <- read_csv("~/Desktop/R studio/carine-h.github.io/data/electoralcollegevotes_1948-2020.csv")
```

```
## Warning: Missing column names filled in: 'X1' [1], 'X22' [22], 'X23' [23],
## 'X24' [24], 'X25' [25], 'X26' [26], 'X27' [27], 'X28' [28]
```

```
## Parsed with column specification:
## cols(
##   .default = col_double(),
##   X1 = col_character(),
##   X22 = col_logical(),
##   X23 = col_logical(),
##   X24 = col_logical(),
##   X25 = col_logical(),
##   X26 = col_logical(),
##   X27 = col_logical(),
##   X28 = col_logical()
## )
```

```
## See spec(...) for full column specifications.
```

```r
# state names and abbreviations
pvstate_df$state <- state.abb[match(pvstate_df$state, state.name)]
pollstate_df$state <- state.abb[match(pollstate_df$state, state.name)]

dat <- pvstate_df %>% 
  full_join(pollstate_df %>% 
              filter(weeks_left == 10) %>% 
              group_by(year,party,state) %>% 
              summarise(avg_poll=mean(avg_poll)),
            by = c("year" ,"state")) %>%
  left_join(demog %>%
              select(-c("total")),
            by = c("year" ,"state"))
```

```
## `summarise()` regrouping output by 'year', 'party' (override with `.groups` argument)
```

```r
# demographics, poll numbers, and popular vote 

dat$region <- state.division[match(dat$state, state.abb)]
demog$region <- state.division[match(demog$state, state.abb)]

dat_change <- dat %>%
  group_by(state) %>%
  mutate(Asian_change = Asian - lag(Asian, order_by = year),
         Black_change = Black - lag(Black, order_by = year),
         Hispanic_change = Hispanic - lag(Hispanic, order_by = year),
         Indigenous_change = Indigenous - lag(Indigenous, order_by = year),
         White_change = White - lag(White, order_by = year),
         Female_change = Female - lag(Female, order_by = year),
         Male_change = Male - lag(Male, order_by = year),
         age20_change = age20 - lag(age20, order_by = year),
         age3045_change = age3045 - lag(age3045, order_by = year),
         age4565_change = age4565 - lag(age4565, order_by = year),
         age65_change = age65 - lag(age65, order_by = year)
  )



## MODEL
mod_demog_change <- lm(D_pv2p ~ Black_change + Hispanic_change + Asian_change +
                         as.factor(state), data = dat_change)



# UPDATED 2020
dat_2020 <- race_2020 %>%
  left_join(hispanic_2020, by = "State") %>%
  mutate(Hispanic = 100*HispanicPerc, 
         state = State, 
         White = 100*WhitePerc, 
         Asian = 100*AsianPerc, 
         Black = 100*BlackPerc) %>%
  select(state, Hispanic, White, Asian, Black) %>%
  mutate(state = state.abb[match(state,state.name)]) %>%
  na.omit() %>%
  mutate(year = 2020)

# 2018 demographics
dat_2018 <- demog %>%
  filter(year == 2018) 

# joining demographics
real_2020_change <- bind_rows(dat_2018, dat_2020)

# calculating percent changes in available demographic groups
## I used 0 percent change with populations that lacked demographic data (age and gender)
real_2020 <- real_2020_change %>%
  filter(year %in% c(2018, 2020)) %>%
  group_by(state) %>%
  mutate(Asian_change = Asian - lag(Asian, order_by = year), # CALCULATING CHANGES IN POPULATION
         Black_change = Black - lag(Black, order_by = year),
         Hispanic_change = Hispanic - lag(Hispanic, order_by = year),
         Indigenous_change = 0,
         White_change = White - lag(White, order_by = year),
         Female_change = 0,
         Male_change = 0,
         age20_change = 0,
         age3045_change = 0,
         age4565_change = 0,
         age65_change = 0) %>%
  filter(year == 2020)

real_2020 <- as.data.frame(real_2020)
rownames(real_2020) <- real_2020$state
real_2020 <- real_2020[state.abb, ]
real_2020$region <- state.division[match(real_2020$state, state.abb)]

#  2020 PREDICTION
demog_pred <- predict(mod_demog_change, newdata = real_2020) 

d <- tibble(demog_pred) %>%
  mutate(state = real_2020$state)


 d%>%  ##`statebins` needs state to be character, not factor!
  ggplot(aes(state = state, fill = (demog_pred >= 50))) +
  geom_statebins() +
  theme_statebins() +
  labs(title = "Demographic Model: Electoral Vote Prediction",
       subtitle = "2020 Prediction",
       fill = "", 
       caption = "Data: World Population Review") +
  theme(legend.position = "none", 
        plot.subtitle = element_text(size = 10, hjust = 0.5),
        plot.title   = element_text(size = 12, hjust = 0.5, face = "bold"))
```

![](blog_pred_files/figure-latex/unnamed-chunk-2-1.pdf)<!-- --> 

```r
d %>%
  select(state, demog_pred) %>%
  left_join(electoral, by = "state") %>%
  mutate(state_win = case_when(demog_pred > 50 ~ "Biden",
                            demog_pred < 50 ~ "Trump")) %>%
  group_by(state_win) %>%
  summarise(electoral_votes = sum(`2020`)) %>%
  gt() %>%
  tab_header(title = md("**2020 Electoral Vote Outcome Using Demographic Model**"), 
               subtitle = "Biden Wins") %>%
   cols_label(state_win = md("**Candidate**"),
               electoral_votes = md("**Total Electoral Votes**")) %>%
  tab_source_note(md("*Data: World Population Review*")) 
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

\captionsetup[table]{labelformat=empty,skip=1pt}
\begin{longtable}{lr}
\caption*{
\large \textbf{2020 Electoral Vote Outcome Using Demographic Model}\\ 
\small Biden Wins\\ 
} \\ 
\toprule
\textbf{Candidate} & \textbf{Total Electoral Votes} \\ 
\midrule
Biden & 292 \\ 
Trump & 243 \\ 
\bottomrule
\end{longtable}
\begin{minipage}{\linewidth}
\emph{Data: World Population Review}\\ 
\end{minipage}


# ECONOMICS

```r
library(readxl)
q2_2020 <- read_excel("pred_data/q2_2020.xlsx") %>%
  na.omit()%>%
  mutate(state = state.abb[match(state,state.name)])
state_gdp <- read_csv("pred_data/state_gdp_quarter.csv")
```

```
## Parsed with column specification:
## cols(
##   GeoFIPS = col_character(),
##   GeoName = col_character(),
##   Region = col_double(),
##   TableName = col_character(),
##   LineCode = col_double(),
##   IndustryClassification = col_character(),
##   Description = col_character(),
##   Unit = col_character(),
##   `2008` = col_double(),
##   `2009` = col_double(),
##   `2010` = col_double(),
##   `2011` = col_double(),
##   `2012` = col_double(),
##   `2013` = col_double(),
##   `2014` = col_double(),
##   `2015` = col_double(),
##   `2016` = col_double(),
##   `2017` = col_double(),
##   `2018` = col_double()
## )
```

```
## Warning: 4 parsing failures.
## row col   expected    actual                              file
## 209  -- 19 columns 1 columns 'pred_data/state_gdp_quarter.csv'
## 210  -- 19 columns 1 columns 'pred_data/state_gdp_quarter.csv'
## 211  -- 19 columns 1 columns 'pred_data/state_gdp_quarter.csv'
## 212  -- 19 columns 1 columns 'pred_data/state_gdp_quarter.csv'
```

```r
econ_update
```

```
## # A tibble: 484 x 31
##    GeoFIPS GeoName Region TableName LineCode IndustryClassif~ Description Unit 
##    <chr>   <chr>    <dbl> <chr>        <dbl> <chr>            <chr>       <chr>
##  1 00000   United~     NA SAGDP1           1 ...              Real GDP (~ Mill~
##  2 00000   United~     NA SAGDP1           2 ...              Chain-type~ Quan~
##  3 00000   United~     NA SAGDP1           3 ...              Current-do~ Mill~
##  4 00000   United~     NA SAGDP1           4 ...              Compensati~ Mill~
##  5 00000   United~     NA SAGDP1           5 ...              Gross oper~ Mill~
##  6 00000   United~     NA SAGDP1           6 ...              Taxes on p~ Mill~
##  7 00000   United~     NA SAGDP1           7 ...              Taxes on p~ Mill~
##  8 00000   United~     NA SAGDP1           8 ...              Subsidies ~ Mill~
##  9 01000   Alabama      5 SAGDP1           1 ...              Real GDP (~ Mill~
## 10 01000   Alabama      5 SAGDP1           2 ...              Chain-type~ Quan~
## # ... with 474 more rows, and 23 more variables: `1997` <dbl>, `1998` <dbl>,
## #   `1999` <dbl>, `2000` <dbl>, `2001` <dbl>, `2002` <dbl>, `2003` <dbl>,
## #   `2004` <dbl>, `2005` <dbl>, `2006` <dbl>, `2007` <dbl>, `2008` <dbl>,
## #   `2009` <dbl>, `2010` <dbl>, `2011` <dbl>, `2012` <dbl>, `2013` <dbl>,
## #   `2014` <dbl>, `2015` <dbl>, `2016` <dbl>, `2017` <dbl>, `2018` <dbl>,
## #   `2019` <dbl>
```

```r
# going to have to use yearly growth
state_econ <- econ_update %>%
  filter(Description == "Real GDP (millions of chained 2012 dollars)") %>%
  select(GeoName, '1997', '1998', '1999','2000', '2001', '2002', '2003', '2004', '2005', '2006', '2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018')%>%
  melt(c("GeoName"), value.name = "GDP") %>%
  mutate(year = as.numeric(as.character(variable))) %>%
  rename(state = GeoName) %>%
  group_by(state) %>%
  mutate(gdp_growth= (GDP - lag(GDP, order_by = year))/lag(GDP, order_by = year)) %>%
  mutate(state = state.abb[match(state,state.name)]) %>%
  select(year, state, gdp_growth) %>%
  na.omit()
  


q3_econ <- pvstate_df %>%
  left_join(state_econ, by = c("year", "state")) %>%
  left_join(popvote_df, by = c("year")) %>%
  na.omit() %>%
  filter(party == "democrat")

# MODEL
econ_fit <- lm(D_pv2p ~ gdp_growth*incumbent + as.factor(state), data = q3_econ)
summary(econ_fit)
```

```
## 
## Call:
## lm(formula = D_pv2p ~ gdp_growth * incumbent + as.factor(state), 
##     data = q3_econ)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -12.1919  -1.9037   0.0077   1.9924  10.7792 
## 
## Coefficients:
##                          Estimate Std. Error t value Pr(>|t|)    
## (Intercept)               38.1650     1.5989  23.870  < 2e-16 ***
## gdp_growth               -29.9112     9.3138  -3.211 0.001542 ** 
## incumbentTRUE              0.3537     0.6640   0.533 0.594849    
## as.factor(state)AL         0.8672     2.2617   0.383 0.701828    
## as.factor(state)AR         3.2325     2.2585   1.431 0.153933    
## as.factor(state)AZ         8.4376     2.2607   3.732 0.000248 ***
## as.factor(state)CA        22.9524     2.2720  10.102  < 2e-16 ***
## as.factor(state)CO        13.0791     2.2651   5.774 2.97e-08 ***
## as.factor(state)CT        20.8874     2.2696   9.203  < 2e-16 ***
## as.factor(state)DE        19.4663     2.2588   8.618 2.21e-15 ***
## as.factor(state)FL        12.0844     2.2634   5.339 2.56e-07 ***
## as.factor(state)GA         7.5603     2.2606   3.344 0.000987 ***
## as.factor(state)HI        27.7259     2.2649  12.242  < 2e-16 ***
## as.factor(state)IA        12.8317     2.2594   5.679 4.80e-08 ***
## as.factor(state)ID        -4.4666     2.2993  -1.943 0.053488 .  
## as.factor(state)IL        20.3558     2.2539   9.031  < 2e-16 ***
## as.factor(state)IN         5.6256     2.2621   2.487 0.013716 *  
## as.factor(state)KS         1.5380     2.2600   0.681 0.496974    
## as.factor(state)KY         1.1419     2.2530   0.507 0.612824    
## as.factor(state)LA         3.8342     2.2568   1.699 0.090905 .  
## as.factor(state)MA        25.9295     2.2663  11.441  < 2e-16 ***
## as.factor(state)MD        23.6211     2.2718  10.397  < 2e-16 ***
## as.factor(state)ME        17.5037     2.2669   7.722 5.67e-13 ***
## as.factor(state)MI        15.1378     2.2516   6.723 1.88e-10 ***
## as.factor(state)MN        15.1504     2.2688   6.678 2.42e-10 ***
## as.factor(state)MO         8.1954     2.2591   3.628 0.000364 ***
## as.factor(state)MS         4.2262     2.2585   1.871 0.062793 .  
## as.factor(state)MT         3.3494     2.2556   1.485 0.139161    
## as.factor(state)NC         9.3230     2.2665   4.113 5.73e-05 ***
## as.factor(state)ND        -0.9875     2.3214  -0.425 0.671019    
## as.factor(state)NE        -0.6513     2.2617  -0.288 0.773659    
## as.factor(state)NH        13.9894     2.2645   6.178 3.66e-09 ***
## as.factor(state)NJ        19.4069     2.2597   8.588 2.67e-15 ***
## as.factor(state)NM        15.7163     2.2618   6.949 5.26e-11 ***
## as.factor(state)NV        14.2156     2.2783   6.240 2.63e-09 ***
## as.factor(state)NY        25.7505     2.2522  11.433  < 2e-16 ***
## as.factor(state)OH        11.3059     2.2555   5.013 1.19e-06 ***
## as.factor(state)OK        -3.5304     2.2546  -1.566 0.118988    
## as.factor(state)OR        17.5964     2.2895   7.686 7.04e-13 ***
## as.factor(state)PA        14.4452     2.2594   6.393 1.15e-09 ***
## as.factor(state)RI        24.6834     2.2584  10.930  < 2e-16 ***
## as.factor(state)SC         5.3597     2.2594   2.372 0.018645 *  
## as.factor(state)SD         2.1645     2.2698   0.954 0.341458    
## as.factor(state)TN         4.0860     2.2573   1.810 0.071806 .  
## as.factor(state)TX         4.0057     2.2568   1.775 0.077453 .  
## as.factor(state)UT        -6.8451     2.2667  -3.020 0.002864 ** 
## as.factor(state)VA        12.3160     2.2645   5.439 1.58e-07 ***
## as.factor(state)VT        26.1969     2.2717  11.532  < 2e-16 ***
## as.factor(state)WA        18.5109     2.2554   8.207 2.91e-14 ***
## as.factor(state)WI        14.1764     2.2562   6.283 2.08e-09 ***
## as.factor(state)WV         1.4166     2.2573   0.628 0.531019    
## as.factor(state)WY        -8.6865     2.2701  -3.826 0.000175 ***
## gdp_growth:incumbentTRUE  40.8028    19.5016   2.092 0.037694 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3.555 on 197 degrees of freedom
## Multiple R-squared:  0.8985,	Adjusted R-squared:  0.8717 
## F-statistic: 33.55 on 52 and 197 DF,  p-value: < 2.2e-16
```

```r
e <- econ_update %>%
  filter(Description == "Real GDP (millions of chained 2012 dollars)") %>%
  select(GeoName, '1997', '1998', '1999','2000', '2001', '2002', '2003', '2004', '2005', '2006', '2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018')%>%
  melt(c("GeoName"), value.name = "GDP") %>%
  mutate(year = as.numeric(as.character(variable))) %>%
  rename(state = GeoName) %>%
  mutate(state = state.abb[match(state,state.name)]) %>%
  select(state, year, GDP) %>%
  filter(year == 2018)


gdp_2019 <- read_excel("pred_data/state_2019_gdp.xlsx")%>%
  na.omit()%>%
  mutate(state = state.abb[match(state,state.name)]) %>%
  mutate(year = 2019)

# new data: ASSUMING SAME GDP GROWTH ACROSS STATES AS IS NATIONALLY 
data_econ <- q2_2020 %>%
  mutate(year = 2020) 

new_data_econ <- rbind(data_econ, gdp_2019) %>%
  mutate(incumbent = FALSE) %>%
  group_by(state) %>%
  mutate(gdp_growth = (GDP - lag(GDP, order_by = year))/lag(GDP, order_by = year)) %>%
  na.omit()
  

# 2020 PREDICTION
econ_pred <- predict(econ_fit, newdata = new_data_econ)

e2 <- tibble(pred = predict(econ_fit, newdata = new_data_econ), state = new_data_econ$state)

e2 %>%  ##`statebins` needs state to be character, not factor!
  ggplot(aes(state = state, fill = (pred >= 50))) +
  geom_statebins() +
  theme_statebins() +
  labs(title = "Fundamentals Model: Electoral Vote Prediction",
       subtitle = "2020 Prediction",
       fill = "", 
       caption = "Data: BEA") +
  theme(legend.position = "none", 
        plot.subtitle = element_text(size = 10, hjust = 0.5),
        plot.title   = element_text(size = 12, hjust = 0.5, face = "bold"))
```

![](blog_pred_files/figure-latex/unnamed-chunk-3-1.pdf)<!-- --> 

```r
e2  %>%
  select(state, pred) %>%
  left_join(electoral, by = "state") %>%
  mutate(state_win = case_when(pred > 50 ~ "Biden",
                            pred < 50 ~ "Trump")) %>%
  group_by(state_win) %>%
  summarise(electoral_votes = sum(`2020`)) %>%
  gt() %>%
  tab_header(title = md("**2020 Electoral Vote Outcome Using Fundamentals Model**"), 
               subtitle = "Biden Wins") %>%
   cols_label(state_win = md("**Candidate**"),
               electoral_votes = md("**Total Electoral Votes**")) %>%
  tab_source_note(md("*Data: FiveThirtyEight, BEA*")) 
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

\captionsetup[table]{labelformat=empty,skip=1pt}
\begin{longtable}{lr}
\caption*{
\large \textbf{2020 Electoral Vote Outcome Using Fundamentals Model}\\ 
\small Biden Wins\\ 
} \\ 
\toprule
\textbf{Candidate} & \textbf{Total Electoral Votes} \\ 
\midrule
Biden & 390 \\ 
Trump & 145 \\ 
\bottomrule
\end{longtable}
\begin{minipage}{\linewidth}
\emph{Data: FiveThirtyEight, BEA}\\ 
\end{minipage}





# PLOT of ALL MODELS
in_sample_poll <- predict(fit_state_poll, newdata = dat)
in_sample_demo <- predict(mod_demog_change, newdata = dat_change)
in_sample_econ <- predict(econ_fit, newdata = q3_econ)


# ENSEMBLE

```r
# ensemble PREDICTION for 2020
ensemble <- 0.25*econ_pred + 0.25*demog_pred + 0.5*poll_pred_2020$pred
ensemble_tibble <- tibble(pred = ensemble, state = new_data_econ$state)

# electoral vote table:
ensemble_tibble %>%
  left_join(electoral, by = "state") %>%
  mutate(state_win = case_when(pred > 50 ~ "Biden",
                            pred < 50 ~ "Trump")) %>%
  group_by(state_win) %>%
  summarise(electoral_votes = sum(`2020`)) %>%
  gt() %>%
  tab_header(title = md("**Poll-Heavy Ensemble: 2020 Electoral Vote Outcome Prediction**"), 
               subtitle = "Biden Wins") %>%
   cols_label(state_win = md("**Candidate**"),
               electoral_votes = md("**Total Electoral Votes**")) %>%
  tab_source_note(md("*Data: FiveThirtyEight*"))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

\captionsetup[table]{labelformat=empty,skip=1pt}
\begin{longtable}{lr}
\caption*{
\large \textbf{Poll-Heavy Ensemble: 2020 Electoral Vote Outcome Prediction}\\ 
\small Biden Wins\\ 
} \\ 
\toprule
\textbf{Candidate} & \textbf{Total Electoral Votes} \\ 
\midrule
Biden & 263 \\ 
Trump & 272 \\ 
\bottomrule
\end{longtable}
\begin{minipage}{\linewidth}
\emph{Data: FiveThirtyEight}\\ 
\end{minipage}

```r
# electoral map table:
ensemble_tibble %>% 
  mutate(state = as.character(state)) %>% ##`statebins` needs state to be character, not factor!
  ggplot(aes(state = state, fill = (pred >= 50))) +
  geom_statebins() +
  theme_statebins() +
  labs(title = "2020 State Prediction",
       subtitle = "Poll-Heavy Ensemble Model",
       fill = "") +
  theme(legend.position = "none", 
        plot.subtitle = element_text(size = 10, hjust = 0.5),
        plot.title   = element_text(size = 12, hjust = 0.5, face = "bold"))
```

![](blog_pred_files/figure-latex/unnamed-chunk-4-1.pdf)<!-- --> 

```r
#Predictive Intervals: POLL Ensemble
in_sample_poll <- predict(fit_state_poll, newdata = new_data_poll, interval = "predict") 
in_sample_demo <- predict(mod_demog_change, newdata = real_2020, interval = "predict")
in_sample_econ <- predict(econ_fit, newdata = new_data_econ, interval = "predict")

tab1 <- as.data.frame(0.5*in_sample_poll + 0.25*in_sample_demo + 0.25*in_sample_econ) %>%
  mutate(state = new_data_poll$state) %>%
  select(state, lwr, fit, upr) %>%
  mutate(lwr = round(lwr,  digits = 2)/100, 
         fit = round(fit, digits = 2)/100, 
         upr = round(upr, digits = 2)/100)%>%
  mutate(winner =  case_when(fit > .50 ~ "Biden",
                            fit < .50 ~ "Trump")) %>%
  gt() %>%
   tab_header(title = md("**Poll-Heavy Ensemble: Projected State Winners and Predictive Intervals for Democratic Vote Share Prediction**"), 
               subtitle = "95% Confidence Intervals") %>%
   fmt_percent(columns = c("lwr", "fit", "upr"), decimals = 1) %>%
   cols_label(lwr = md("**Lower Bound**"),
              fit = md("**Predicted Democratic Vote Share**"),
              upr = md("**Upper Bound**"), 
              state = md("**State**"), 
              winner = md("**Predicted Winner**")) %>%
  tab_source_note(md("*Data: BEA, FiveThirtyEight, World Population Review*")) 







# diff weights - emphasis on fundamentals
ensemble2 <- 0.5*econ_pred + 0.25*demog_pred + 0.25*poll_pred_2020$pred
ensemble_tibble2 <- tibble(pred = ensemble2, state = new_data_poll$state)

ensemble_tibble2 %>%
  mutate(state = state.abb[match(state,state.name)]) %>%
  select(state, pred) %>%
  left_join(electoral, by = "state") %>%
  mutate(state_win = case_when(pred > 50 ~ "Biden",
                            pred < 50 ~ "Trump")) %>%
  group_by(state_win) %>%
  summarise(electoral_votes = sum(`2020`)) %>%
  gt() %>%
  tab_header(title = md("**Fundamentals-Heavy Ensemble: 2020 Electoral Vote Outcome Prediction**"), 
               subtitle = "BIDEN Wins") %>%
   cols_label(state_win = md("**Candidate**"),
               electoral_votes = md("**Total Electoral Votes**")) %>%
  tab_source_note(md("*Data: BEA*"))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

\captionsetup[table]{labelformat=empty,skip=1pt}
\begin{longtable}{lr}
\caption*{
\large \textbf{Fundamentals-Heavy Ensemble: 2020 Electoral Vote Outcome Prediction}\\ 
\small BIDEN Wins\\ 
} \\ 
\toprule
\textbf{Candidate} & \textbf{Total Electoral Votes} \\ 
\midrule
Biden & 403 \\ 
Trump & 132 \\ 
\bottomrule
\end{longtable}
\begin{minipage}{\linewidth}
\emph{Data: BEA}\\ 
\end{minipage}

```r
# electoral map table:
ensemble_tibble2 %>% 
  mutate(state = as.character(state)) %>% ##`statebins` needs state to be character, not factor!
  ggplot(aes(state = state, fill = (pred >= 50))) +
  geom_statebins() +
  theme_statebins() +
  labs(title = "2020 State Prediction",
       subtitle = "Fundamentals-Heavy Ensemble Model",
       fill = "") +
  theme(legend.position = "none", 
        plot.subtitle = element_text(size = 10, hjust = 0.5),
        plot.title   = element_text(size = 12, hjust = 0.5, face = "bold"))
```

![](blog_pred_files/figure-latex/unnamed-chunk-4-2.pdf)<!-- --> 

```r
# fundamentals predictive intervals:
as.data.frame(0.25*in_sample_poll + 0.25*in_sample_demo + 0.5*in_sample_econ) %>%
  mutate(state = new_data_poll$state) %>%
  select(state, lwr, fit, upr) %>%
  mutate(lwr = round(lwr,  digits = 2)/100, 
         fit = round(fit, digits = 2)/100, 
         upr = round(upr, digits = 2)/100)%>%
  mutate(winner =  case_when(fit > .50 ~ "Biden",
                            fit < .50 ~ "Trump")) %>%
  gt() %>%
   tab_header(title = md("**Fundamentals-Heavy Ensemble: Projected State Winners and Predictive Intervals for Democratic Vote Share Prediction**"), 
               subtitle = "95% Confidence Intervals") %>%
   fmt_percent(columns = c("lwr", "fit", "upr"), decimals = 1) %>%
   cols_label(lwr = md("**Lower Bound**"),
              fit = md("**Predicted Democratic Vote Share**"),
              upr = md("**Upper Bound**"), 
              state = md("**State**"), 
              winner = md("**Predicted Winner**")) %>%
  tab_source_note(md("*Data: BEA, FiveThirtyEight, World Population Review*"))
```

\captionsetup[table]{labelformat=empty,skip=1pt}
\begin{longtable}{lrrrl}
\caption*{
\large \textbf{Fundamentals-Heavy Ensemble: Projected State Winners and Predictive Intervals for Democratic Vote Share Prediction}\\ 
\small 95\% Confidence Intervals\\ 
} \\ 
\toprule
\textbf{State} & \textbf{Lower Bound} & \textbf{Predicted Democratic Vote Share} & \textbf{Upper Bound} & \textbf{Predicted Winner} \\ 
\midrule
Alabama & $45.7\%$ & $54.2\%$ & $62.6\%$ & Biden \\ 
Alaska & $35.3\%$ & $43.9\%$ & $52.5\%$ & Trump \\ 
Arizona & $51.1\%$ & $59.8\%$ & $68.4\%$ & Biden \\ 
Arkansas & $41.6\%$ & $50.1\%$ & $58.6\%$ & Biden \\ 
California & $53.4\%$ & $62.2\%$ & $71.0\%$ & Biden \\ 
Colorado & $46.4\%$ & $54.9\%$ & $63.4\%$ & Biden \\ 
Connecticut & $48.0\%$ & $56.5\%$ & $65.0\%$ & Biden \\ 
Delaware & $51.1\%$ & $59.5\%$ & $67.8\%$ & Biden \\ 
Florida & $42.8\%$ & $51.4\%$ & $60.0\%$ & Biden \\ 
Georgia & $46.9\%$ & $55.6\%$ & $64.3\%$ & Biden \\ 
Hawaii & $54.0\%$ & $70.5\%$ & $87.0\%$ & Biden \\ 
Idaho & $37.0\%$ & $45.6\%$ & $54.2\%$ & Trump \\ 
Illinois & $47.9\%$ & $56.4\%$ & $64.8\%$ & Biden \\ 
Indiana & $43.5\%$ & $52.1\%$ & $60.7\%$ & Biden \\ 
Iowa & $50.3\%$ & $58.8\%$ & $67.3\%$ & Biden \\ 
Kansas & $40.2\%$ & $48.6\%$ & $57.0\%$ & Trump \\ 
Kentucky & $41.3\%$ & $49.9\%$ & $58.4\%$ & Trump \\ 
Louisiana & $39.1\%$ & $47.6\%$ & $56.1\%$ & Trump \\ 
Maine & $45.2\%$ & $53.6\%$ & $62.0\%$ & Biden \\ 
Maryland & $45.3\%$ & $54.1\%$ & $62.9\%$ & Biden \\ 
Massachusetts & $52.8\%$ & $61.3\%$ & $69.8\%$ & Biden \\ 
Michigan & $44.6\%$ & $53.2\%$ & $61.8\%$ & Biden \\ 
Minnesota & $50.4\%$ & $59.0\%$ & $67.6\%$ & Biden \\ 
Mississippi & $37.8\%$ & $46.2\%$ & $54.7\%$ & Trump \\ 
Missouri & $45.9\%$ & $54.4\%$ & $62.8\%$ & Biden \\ 
Montana & $38.7\%$ & $47.3\%$ & $55.9\%$ & Trump \\ 
Nebraska & $34.1\%$ & $42.6\%$ & $51.2\%$ & Trump \\ 
Nevada & $36.9\%$ & $45.4\%$ & $53.8\%$ & Trump \\ 
New Hampshire & $40.0\%$ & $48.5\%$ & $56.9\%$ & Trump \\ 
New Jersey & $37.9\%$ & $46.2\%$ & $54.6\%$ & Trump \\ 
New Mexico & $46.5\%$ & $55.0\%$ & $63.5\%$ & Biden \\ 
New York & $45.7\%$ & $54.1\%$ & $62.5\%$ & Biden \\ 
North Carolina & $45.0\%$ & $53.7\%$ & $62.4\%$ & Biden \\ 
North Dakota & $32.3\%$ & $40.6\%$ & $49.0\%$ & Trump \\ 
Ohio & $39.3\%$ & $47.7\%$ & $56.1\%$ & Trump \\ 
Oklahoma & $34.1\%$ & $42.7\%$ & $51.3\%$ & Trump \\ 
Oregon & $48.0\%$ & $56.3\%$ & $64.6\%$ & Biden \\ 
Pennsylvania & $54.3\%$ & $63.2\%$ & $72.0\%$ & Biden \\ 
Rhode Island & $42.1\%$ & $50.5\%$ & $58.9\%$ & Biden \\ 
South Carolina & $44.0\%$ & $52.8\%$ & $61.5\%$ & Biden \\ 
South Dakota & $35.1\%$ & $43.5\%$ & $51.8\%$ & Trump \\ 
Tennessee & $45.0\%$ & $53.6\%$ & $62.1\%$ & Biden \\ 
Texas & $45.1\%$ & $53.7\%$ & $62.3\%$ & Biden \\ 
Utah & $30.9\%$ & $39.3\%$ & $47.6\%$ & Trump \\ 
Vermont & $57.6\%$ & $66.2\%$ & $75.0\%$ & Biden \\ 
Virginia & $38.0\%$ & $46.3\%$ & $54.5\%$ & Trump \\ 
Washington & $42.2\%$ & $50.9\%$ & $59.6\%$ & Biden \\ 
West Virginia & $36.3\%$ & $44.6\%$ & $52.9\%$ & Trump \\ 
Wisconsin & $34.5\%$ & $42.7\%$ & $50.9\%$ & Trump \\ 
Wyoming & $44.0\%$ & $52.9\%$ & $61.8\%$ & Biden \\ 
\bottomrule
\end{longtable}
\begin{minipage}{\linewidth}
\emph{Data: BEA, FiveThirtyEight, World Population Review}\\ 
\end{minipage}
- difference when weighing fundamentals (econ and incumbency) versus polls: 
    - Ohio, Virginia, North Carolina RED with poll-heavy


# CHECKING FIT : can you even do this if it's different years and there are some NAs?
## In Sample

```r
summary(dat)
summary(dat_change)
summary(q3_econ)

# predictions

# R-square is: 0.936


# ALTERNATIVE MODEL PREDICTION

df_poll2 <- dat %>%
  select(state, year, avg_poll)%>% 
  add_predictions(fit_state_poll) %>%
  mutate(state = state.abb[match(state,state.name)])%>%
  mutate(pollpred = 0.25*pred)
df_demo2 <- dat_change %>%
  select(state, year, Black_change, Hispanic_change, Asian_change)%>% 
  add_predictions(mod_demog_change) %>%
  mutate(demopred = 0.25*pred)
df_econ2 <- q3_econ %>%
  select(state, year, gdp_growth, incumbent)%>% 
  add_predictions(econ_fit) %>%
  mutate(econpred = 0.5*pred)

resid2 <- df_demo2%>%
left_join(df_poll2, by = c("state", "year")) %>%
left_join(df_econ2, by = c("state", "year")) %>%
mutate(weighted_pred = pollpred + demopred + econpred) %>%
select(state, year, weighted_pred) %>%
left_join(pvstate_df, c("state", "year")) %>%
mutate(residual = D_pv2p - weighted_pred) %>%
select(state, year, weighted_pred, D_pv2p, residual) %>%
mutate(numerator = residual^2,
       denominator = (D_pv2p - mean(resid$D_pv2p, na.rm = TRUE))^2) %>%
  filter(year >= 2008)

1- (sum(resid2$numerator, na.rm = TRUE)/sum(resid2$denominator, na.rm = TRUE))

# R squared is 0.926
```


Model elements:
fit_state_poll: original poll model 
	uses dat
pred_2020: poll prediction 
	uses new_data_poll
mod_demog_change: original demo model 
	uses dat_change 
demog_pred: demography model prediction
	uses real_2020
	
	
	
You simply have to (1) subset out the data to leave one observation out (ex. 2016)  when you estimate the regression coefficients of each model, (2) run regression and estimate the coefficients for each model, (3) do the prediction using each model with the left out data (ex. 2016) as newdata, (4) do ensemble of that prediction, and (5) compare it with the true value for ex. 2016.
	
## Out of Sample -- can you even do this if it's different years????

```r
true <- dat_change %>%
  left_join(df_econ, by = c("state", "year")) %>%
  filter(year == 2016) %>%
  select(year, state, D_pv2p) %>%
  distinct() %>%
  na.omit()


d <- dat_change[!(dat_change$Asian_change == 0.0000000),] %>%
  na.omit()

all_years <- seq(from=1998, to=2016, by=4)
outsamp_dflist <- lapply(all_years, function(year){
 
  true_inc <- true %>%
    filter(state == "FL")

  ##fundamental model out-of-sample prediction
  fit_out_poll <- lm(D_pv2p ~ avg_poll + as.factor(state), data = dat[dat$year != 2004,])
  fit_out_demo <- lm(D_pv2p ~ Black_change + Hispanic_change + Asian_change +
                         as.factor(state), data = d[d$year != 2004,])
  fit_out_econ <- lm(D_pv2p ~ gdp_growth*incumbent + as.factor(state), data = q3_econ[q3_econ$year != 2004,])

  mod_poll <- 0.5* mean(predict(fit_out_poll, dat[dat$year == 2004 & dat$state == "FL",]), na.rm = TRUE)
  mod_demog <- 0.25*predict(fit_out_demo, d[d$year == 2004 & d$state == "FL",])
  mod_econ <- 0.25*predict(fit_out_econ, q3_econ[q3_econ$year == 2004 & q3_econ$state == "FL",])
  
  mod <- mod_poll + mod_demog + mod_econ
  

  fl_margin_error = mod - true_inc$D_pv2p
        
        
       
        cbind(poll_winner_correct = (mod_poll > 50) == (true_inc$D_pv2p > 50),
        demo_winner_correct = (mod_demog > 50) == (true_inc$D_pv2p > 50),
        econ_winner_correct = (mod_econ > 50) == (true_inc$D_pv2p > 50))
  
})




sum(poll_margin_error, demo_margin_error, econ_margin_error, na.rm = T)


outsamp_df <- do.call(rbind, outsamp_dflist) #
colMeans(abs(outsamp_df[2:4]), na.rm=T) #
colMeans(outsamp_df[5:7], na.rm=T) ### classification accuracy

outsamp_df[,c("year","econ_winner_correct","poll_winner_correct","plus_winner_correct")] #
```

















```r
summary(dat)
summary(dat_change)
summary(q3_econ)

# took 2016 out of the data: 
out_poll <- dat %>%
  filter(year != 2016)
out_demo <- dat_change %>%
  filter(year != 2016)
out_econ <- q3_econ %>%
  filter(year != 2016)

# running regressions without 2016: 
fit_out_poll <- lm(D_pv2p ~ avg_poll + as.factor(state), data = out_poll)
fit_out_demo <- lm(D_pv2p ~ Black_change + Hispanic_change + Asian_change +
                         as.factor(state), data = out_demo)
fit_out_econ <- lm(D_pv2p ~ gdp_growth*incumbent + as.factor(state), data = out_econ)

# predict without 2016
predict(fit_out_poll, newdata = out_poll)
predict(fit_out_demo, newdata = out_demo)
predict(fit_out_econ, newdata = out_econ)







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















outsamp_errors <- sapply(1:1000, function(i){
  # years to omit
years_outsamp <- seq(from=2008, to=2016, by=4)
omit_data <- data[!(data$year %in% years_outsamp),]

# outsample years in each model
outsamp_mod_poll <- lm(D_pv2p ~ avg_poll + as.factor(state), omit_data)
outsamp_mod_demog <- lm(D_pv2p ~ Black_change + Hispanic_change + Asian_change + 
    as.factor(state), omit_data)
outsamp_mod_econ <- lm(D_pv2p ~ gdp_growth + incumbent, omit_data)

# draw predictions from each model
outsamp_pred_poll <- omit_data %>%
  select(state, year, avg_poll)%>% 
  add_predictions(outsamp_mod_poll)%>%
  mutate(pollpred = 0.5*pred)
outsamp_pred_demog <- omit_data %>%
  select(state, year, Black_change, Hispanic_change, Asian_change)%>% 
  add_predictions(outsamp_mod_demog) %>%
  mutate(demopred = 0.25*pred)
outsamp_pred_econ <- omit_data %>%
  select(state, year, gdp_growth, incumbent)%>% 
  add_predictions(outsamp_mod_econ) %>%
  mutate(econpred = 0.25*pred)


outsamp_pred <- 0.5*outsamp_pred_poll$pollpred + 0.25*outsamp_pred_demog$demopred + 0.25*outsamp_pred_econ$econpred

# extract true value
outsamp_true <- omit_data$D_pv2p[omit_data$year %in% years_outsamp]

mean(outsamp_pred - outsamp_true, na.rm = TRUE)
})
```










# Weighted Ensemble
- I am placing the most weight on polls, 
- have as.factor state for each poll 

in sample fit: 
.5(poll)+.25(econ)+.25(demo)
true value - (.5(poll)+.25(econ)+.25(demo))
0.5predict() + 0.25predict() + .25predict()

out of sample fit: 
- exclude 2016 and then do whole process and do regression parameter without 2016
  - predict with ensemble fit (without 2016) and make new data = 2016 data  
- make sure new data has a column named state and states listed 

There should be a column named “state”
And ex. PA? Then your new data should have “state” column with “PA” in that column
True value - (0.5x51 + 0.25x49 + 0.25x50)

you could do ensemble at the electoral college level (0.5x400 + 0.25x390 + 0.25x380)

# Modified Time-For-Change
- economic approval rating 
- state AND national approval
- GDP/RDI Growth 
- Incumbency
- Jobs 
- 2020 demographics 
- predict national pop_vote

polls model and demographic will have popular vote share from state 

- state poll, demo, AND economic model
- maybe add incumbency indicator to either poll or economy 
  - find link on slack 

# DOES THIS ENSEMBLE EVEN WORK IF THERE ARE TONS OF NAs in some predictions and none in others?













```r
pop <- popvote_df %>%
  select(year, party, incumbent)

summary(dat)

poll_demo_model <- dat %>%
  left_join(dat_change, by = c("year", "state")) %>%
  filter(year >= 1992) %>%
  select(state, year, party.x, D_pv2p.x, avg_poll.x, Asian_change, Black_change, Hispanic_change, Indigenous_change, White_change) %>%
  rename(D_pv2p = D_pv2p.x, 
         party = party.x, 
         avg_poll = avg_poll.x)%>%
  left_join(pop, by = c("year", "party")) %>%
  select(state, year, D_pv2p,  party, incumbent, avg_poll, Asian_change, Black_change, Hispanic_change, White_change) %>%
  filter(party == "democrat")

df2<-poll_demo_model[!(poll_demo_model$Asian_change == 0.0000000),]


model <- lm(D_pv2p ~ incumbent + avg_poll + Asian_change + Black_change + Hispanic_change + as.factor(state), data = df2)
summary(model) 

# data frame with new poll and state predictions 
real_2020

new_data_poll %>%
  mutate(state = state.abb[match(state,state.name)]) %>%
  left_join(real_2020) %>%
  mutate(incumbent = FALSE)

main_model_prediction <- predict()
```












# Time-For-Change Model: NATIONAL

```r
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
