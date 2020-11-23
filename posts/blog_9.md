
CHECK 1. A recap of your model(s) and your predictions 
HOW 2. A description of the accuracy of the model(s), including any apparent patterns in the accuracy. Graphics should be used here.
KINDA 3. Proposed hypotheses for why the model(s) were inaccurate in the estimates or locations where it was inaccurate.  These reasons should not simply be statements of about the quality of the components of the model, e.g., “the polls were not good” or “economic growth was not a good predictor” but should instead be grounded hypotheses on why components of the model may not have been predictive or may not have been predictive in certain cases.
4. Proposed quantitative tests that could test these hypotheses, e.g., what data, if available, could allow you to test whether the reason proposed really did cause the inaccuracy in your model.  If there is no plausible test of the hypothesis, explain why.  You do not need to perform these tests or explain them in great detail (e.g., there is no need to write down an equation showing your exact test), just propose them.  
5. A description of how you might change your model if you were to do it again.  

# Recap of Model and Predictions 
The week before the election I created a predictive model that placed Biden as the victor with **???** electoral votes and Trump with **???.** Here's my state-by-state prediction: 

MAP OF STATE-BY-STATE WITH ENSEMBLE PRED

My prediction, however, did not capture the true outcome of the election. As of November 22nd, 2020, President Elect Biden has ***306*** electoral votes with a popular vote share of 51.1% and President Trump has ***232*** electoral votes with a popular vote share of 47.2%, indicating a decisive Biden victory. 

So how exactly did I build this prediction? 

My predictive model was a weighted ensemble that combined a fundamentals model, a demographic model, and a polls model. The fundamentals and demographics model had 25% weights, each, while the polls model had a 50% weight, making this a **poll-heavy** predictive model. Below are the variables for each of the ensemble components:
- Fundamentals: annual state GDP growth and incumbency
- Demographics: state-by-state demographic changes in the Black, Hispanic, Asian, and White state populations
- Polls: state-by-state presidential polls from 1972 onward

I chose a poll-heavy model for a variety of reasons. First and foremost, I felt that fundamentals, a traditionally robust predictor of elections, would be less useful this time around. The economy, for instance, has gone into an unusual shock from the COVID crisis. Incumbency is also different this time around - there has never been such a polarizing president as Donald Trump. Therefore, I was weary to place heavy weight on fundamentals during such a singular election. I also only placed 25% of the ensemble weight on demographics because I did not want to generalize that demographic groups vote as a monolith. Moreover, I only factored in Black, White, Hispanic, and Asian groups (due to data availability) and did not want to throw the model off with a rather simplistic view of the country's makeup. 


# Where I Went Wrong
I propose two major issues with my model: 
1. The polls fell flat, yet again
2. Some voters presumably considered the strength of the economy independent of the COVID shock, bringing fundamentals back into play 
3. My prediction did not account for the highly polarized nature of this election

### Polls
Currently, a common theme in the media is the issues with polling and the shortcomings in the polls both now and in 2016. After all, the polls did underweigh Trump support in 2016, just as they did this year. 

So, why did I place so much weight on the polls knowing their past flaws? 

For one, I naively assumed that pollsters would have learned their lesson from 2016: they would have cracked the code on detecting Trump support. This assumption was obviously incorrect. I also chose a poll-heavy prediction because I hoped that polls would be a better indicator of electoral preference on the state level while all other traditional indicators are in flux. 

This model composition intuitively made sense  - the economy is a mess and Trump is a one-of-a-kind president so the best thing to do is rely on the polls. However, throughout the process, my gut told me it would be a close race, perhaps even a race that Trump would still win - while it's easy to feel that Biden is a more palatable candidate, I had to remind myself that Harvard's thought bubble is ultra-liberal. So many places around the country still sympathized with Trump and even felt good about his leadership over the past almost-four years. In this context, I hoped my model would reflect a close race. Though it did not in the end, I nonetheless trusted the polls, looking to them as the only possible measure during such an unusual election. 

### Economy 
I used 3rd quarter GDP growth in each state as part of the fundamentals piece in my ensemble. This was problematic for a few reasons. 

For one, the economy is in rather rough shape due to the COVID shock and the 3rd quarter only reflects a snapshot of a presidency that, pre-COVID, had relatively strong economic outcomes. By predicting electoral outcomes with this small, abysmal snapshot of the economy, I may have underestimated Trump's performance. In fact, [exit polls](https://www.vox.com/2020/11/4/21548770/exit-polls-election-trump-voters-economy-pandemic) seem to indicate that voters- mostly on the right- have high approval of Trump's handling of the economy and trust him in repairing it more than Biden. This is indicative of a sort of retrospection on a polarized timeline. 

In other words, Republican voters may be retrospectively voting in a way that looks back at the entire presidency, taking into account the better economic periods. Democratic voters may just be taking into account the recent economic downturn and blaming it fully on Trump. This is more consistent with short term economic voting - many predictive models only take into account the quarters right before an election, reasoning that voters are thinking more about their more recent condition.

### Polarization
Voters are increasingly polarized and it shows in their voting. Take the economic example above - Republican voters somewhat excuse Trump for the COVID downturn while Democrats do not. 

More and more, voters are resorting to their party affiliation to decide their votes. Therefore, it's tough to look at a metric like demography or the economy to measure an election outcome. If two parties look at these metrics in totally different ways, it's hard to make a prediction based on pure metrics without accounting for polarized approaches to these metrics. 

# What to Fix? 

It was a huge surprise when the model produced a Biden landslide. However, I stood by the logic of my model's parameters and hoped that they'd hold some kind of truth. Though I was wrong in the end, the gap between the model and reality signaled the following rather scary reality: there is really no good indicator for presidential outcomes in an election like 2020's. I chalk this up to deeper polarization and partisanship. No matter what the polls say or how much GDP grows/shrinks, it seems that Americans have made their minds up. Fundamentals, public opinion, and even demographics fall to the wayside when Americans have already chosen their "camps."