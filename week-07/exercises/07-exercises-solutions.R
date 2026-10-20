# ============================================================================
# Skill Building in R: Independent linear regression exercises
# Estimated time: 60 minutes
# Dataset: ggplot2::mpg
# ============================================================================
#
# Write code below each prompt and write your interpretations as comments 
# beginning with #. 
#
# Goal: apply the complete single-predictor regression workflow to a new dataset.
# We will fit TWO SEPARATE models of highway fuel economy:
#   1. A numeric predictor: engine displacement.
#   2. A categorical predictor: transmission group.
#
# All code required for these tasks appeared in the tutorial. Adapt it to the
# variable names below. 

library(tidyverse)
library(broom)

theme_set(theme_bw(base_size = 12))

# DATA 
# mpg contains 234 vehicle configurations for 38 car models, using EPA fuel
# economy data for model years 1999 and 2008. A row is a vehicle configuration,
# not a unique individual car or an independently sampled manufacturer.
#
# Variables used here:
#   hwy       = highway fuel economy, in miles per gallon (mpg).
#               Higher values mean a vehicle travels farther per gallon.
#   displ     = engine displacement (engine size), in liters (L).
#   trans     = detailed transmission description.
#   model     = car model name.
#   manufacturer = manufacturer name.
#
# Documentation: https://ggplot2.tidyverse.org/reference/mpg.html
# To open the help page in R: ?ggplot2::mpg

cars_dat <- ggplot2::mpg

# ----------------------------------------------------------------------------
# 1. Inspect and prepare the data 
# ----------------------------------------------------------------------------
# Research question:
# How does mean highway fuel economy vary with engine displacement?
#
# a. Use glimpse() to inspect mpg.
# b. Identify the response and predictor indicated by the question in a comment. Give their units.
# c. Use summarize() to count the total rows and missing values in hwy and displ.
# d. Create cars_dat by removing rows missing hwy or displ. Retain all columns.
#    State how many rows remain. Explain why missing values in an unused
#    variable would not require removal of a row for this model.

# Your code and answers:

# ANSWER
# a.
glimpse(mpg)

# b. Each row is a vehicle configuration. Response: hwy, highway fuel economy
# in miles per gallon. Predictor: displ, engine displacement in liters.

# c.
mpg |>
  summarize(
    n_rows = n(),
    missing_hwy = sum(is.na(hwy)),
    missing_displ = sum(is.na(displ))
  )
# 234 rows; zero missing values in either model variable.

# d.
cars_dat <- mpg |>
  drop_na(hwy, displ)

nrow(cars_dat)
# 234 rows remain. This model uses only hwy and displ, so missing values in an
# unused column do not prevent fitting this model to that row.


# ----------------------------------------------------------------------------
# 2. Explore the numeric association 
# ----------------------------------------------------------------------------
# a. Make a scatterplot of highway fuel economy versus engine displacement.
# 	 Put the predictor on the x-axis, label both axes with units, 
# 	 and use alpha to reduce overlap.
# b. Describe the direction, approximate shape, and scatter in 1-2 sentences.
#    Does a straight-line model look like a reasonable starting point?
# c. Calculate the correlation between engine displacement and highway fuel economy.

# Your code and answers:

# ANSWER
# a.
ggplot(
  data = cars_dat,
  mapping = aes(x = displ, y = hwy)
) +
  geom_point(alpha = 0.6) +
  labs(x = "Engine displacement (L)", y = "Highway fuel economy (mpg)")

# b. Larger engines tend to have lower highway fuel economy. There is a strong
# negative association with scatter and some curvature/grouping; a straight
# line is a useful starting description but diagnostics may reveal limitations.

# c.
cars_dat |>
  summarize(correlation = cor(displ, hwy))
# Approximately -0.7660: a strong negative linear association.




# ----------------------------------------------------------------------------
# 3. Fit and interpret a linear model with a single numeric predictor 
# ----------------------------------------------------------------------------
# a. Fit an lm() model using highway fuel economy as the response and 
#		 engine displacement as the predictor.
#    Name it hwy_model. 
# b. View summary(hwy_model) and tidy(hwy_model).
# c. Interpret the slope in a sentence with units. 
# d. Interpret the intercept. Is an engine displacement of 0 L in the observed
#    range? 
# e. Use glance() and select() to display nobs, r.squared, and sigma.
#    Interpret R-squared and sigma in words, including sigma's units.
# f. Use the coefficient table to assess the evidence against a zero slope.
#    Does a small p-value show the model fits well?

# Your code and answers:

# ANSWER
# a-b.
hwy_model <- lm(hwy ~ displ, data = cars_dat)
summary(hwy_model)
tidy(hwy_model)

# c. A 1 L increase in engine displacement is associated with about 3.53 mpg
# LOWER predicted mean highway fuel economy in these configurations.

# d. The intercept, about 35.70 mpg, is the predicted mean at displ = 0 L.
# Zero is outside the observed 1.6-7.0 L range and does not describe one of
# the engine configurations sampled here. 
range(cars_dat$displ)

# e.
glance(hwy_model) |>
  select(nobs, r.squared, sigma)
# nobs = 234, R-squared approximately 0.5868, sigma approximately 3.836 mpg.
# The fitted model accounts for about 58.7% of observed hwy variation relative
# to predicting its overall mean. The estimated error SD is about 3.84 mpg.
# This is not 58.7% prediction accuracy, and sigma is not the slope SE.

# f. The slope's p-value is approximately 2.04e-46: strong evidence against
# a zero population slope under the model assumptions. This does not establish
# causation or verify model form, independence, constant variance, or normality.




# ----------------------------------------------------------------------------
# 4. Fitted values, residuals, predictions, and plot 
# ----------------------------------------------------------------------------
# a. Use augment(hwy_model, data = cars_dat) to create a data frame containing
#    fitted values and residuals. Save it as fitted_hwy.
#    Display displ, hwy, .fitted, and .resid for the first six observations.
#
# b. For the FIRST observation, calculate observed minus fitted fuel economy.
#    Check that your answer matches .resid. Did the model overpredict or
#    underpredict highway fuel economy for this configuration?
#    A positive residual means the model underpredicted;
#    a negative residual means the model overpredicted.
#    Code hints: Start with fitted_hwy |> slice_head(n = 1).
#    Use transmute() to display hwy, .fitted, .resid, and a new column
#    calculated as hwy - .fitted.
#
# c. Create a tibble called new_engines with 100 evenly spaced displ values
#    spanning the observed range in cars_dat. Use seq().
#
# d. Use augment() with newdata = new_engines, interval = "confidence", and
#    conf.level = 0.95 to create hwy_predictions.
#
# e. Plot the original observations, a prediction line, and a shaded 95%
#    confidence band. Use .fitted, .lower, and .upper from hwy_predictions.
#
# f. Check the observed displ range. Would a prediction at 10 L be outside
#    the range of observed values (extrapolation)?
#
# Your code and answers:

# ANSWER
# a. augment() returns the data AND additional model columns.
fitted_hwy <- augment(hwy_model, data = cars_dat)

fitted_hwy |>
  select(displ, hwy, .fitted, .resid) |>
  slice_head(n = 6)

# b.
fitted_hwy |>
  slice_head(n = 1) |>
  transmute(
    observed_mpg = hwy,
    fitted_mpg = .fitted,
    residual_mpg = .resid,
    observed_minus_fitted_mpg = hwy - .fitted
  )
# First observation: observed 29 mpg, fitted about 29.343 mpg,
# residual about -0.343 mpg. The model OVERPREDICTS this configuration's hwy.

# c.
new_engines <- tibble(
  displ = seq(
    min(cars_dat$displ),
    max(cars_dat$displ),
    length.out = 100
  )
)

# d.
hwy_predictions <- augment(
  hwy_model,
  newdata = new_engines,
  interval = "confidence",
  conf.level = 0.95
)

# e.
ggplot(
  data = cars_dat,
  mapping = aes(x = displ, y = hwy)
) +
  geom_ribbon(
    data = hwy_predictions,
    mapping = aes(x = displ, ymin = .lower, ymax = .upper),
    inherit.aes = FALSE,
    fill = "steelblue", alpha = 0.2
  ) +
  geom_point(alpha = 0.6) +
  geom_line(
    data = hwy_predictions,
    mapping = aes(y = .fitted),
    color = "steelblue", linewidth = 1
  ) +
  labs(x = "Engine displacement (L)", y = "Highway fuel economy (mpg)")

# The band is a pointwise 95% confidence interval for the MEAN response.
# It is not an interval for an individual vehicle configuration. Interpretation
# of its uncertainty depends on the regression assumptions.

# f.
range(cars_dat$displ)
# 10 L is outside 1.6-7.0 L, so a prediction there is extrapolation. Calculation
# is possible, but the data do not establish that the line continues at 10 L.




# # ----------------------------------------------------------------------------
# 5. Diagnostics
# ----------------------------------------------------------------------------
# Run plot(hwy_model) to inspect the four default diagnostic plots.
# In the Console, you may need to press Enter to advance through the plots.
#
# a. RESIDUALS VERSUS FITTED — Linearity
#    Are residuals scattered around zero without a clear curved pattern?
#    Use the red smooth line to help identify patterns.
#    What would systematic curvature suggest about whether a straight line
#    adequately describes the mean relationship?
#
# b. NORMAL Q-Q — Normality of errors
#    Do the points roughly follow the reference line?
#    Describe any departures, particularly in the tails.
#    Are normally distributed errors a reasonable assumption here?
#    Remember: the response variable itself does not need to be normal.
#
# c. SCALE-LOCATION — Equal variance of errors
#    Is the spread roughly similar across fitted values, with a roughly
#    horizontal red smooth line?
#    Does the plot show an increasing or decreasing spread?
#    What would this suggest about the equal-variance assumption?
#
# d. RESIDUALS VERSUS LEVERAGE — Potentially influential observations
#    Look for observations with both high leverage and large standardized
#    residuals. Are any points near or beyond the Cook's distance contours,
#    if shown?
#    These points may strongly affect the fitted model. This is an influence
#    check, rather than a separate assumption of linear regression.
#    Why should you investigate flagged observations rather than
#    automatically delete them?
#
# Your code and answers:

# ANSWER
plot(hwy_model)

# a. Residuals versus fitted: the smooth line shows systematic curvature.
# A single straight line misses part of the mean relationship; differences
# among vehicle types may also contribute to the pattern.

# b. Normal Q-Q: points are closer to the reference line in the center but
# depart in the tails, particularly the upper tail. The normal-error
# assumption is questionable for this fitted model. This does not require
# hwy itself to have a normal distribution.

# c. Scale-Location: the smoother is not flat and residual magnitudes vary
# across fitted values, raising concern about constant error variance.
# Curvature in the mean relationship can also create this pattern, so consider
# this plot together with residuals versus fitted rather than in isolation.

# d. Residuals versus leverage: some large-engine configurations, including
# Chevrolet Corvettes, combine relatively high leverage with sizable residuals.
# They are worth investigating even if none crosses the displayed Cook's
# distance contours. A point need not cross a contour to affect the fit.
# Check data quality and context; a valid unusual observation should not be
# removed simply because it is influential. A sensitivity analysis can help
# assess how much the conclusions depend on it.



# ----------------------------------------------------------------------------
# 6. Communicate your conclusion 
# ----------------------------------------------------------------------------
# Write 2-3 sentences about the hwy_model:
#   - State the estimated association with direction, magnitude, and units.
#   - Mention one diagnostic concern and what it means for interpretation.

# Your conclusion:

# Across these sampled vehicle configurations, a 1 L increase in engine
# displacement is associated with about 3.53 mpg lower predicted mean highway
# fuel economy. Curvature in the residual plot suggests that the straight-line
# model misses structure, so its slope is a simplified summary of the pattern
# and its conventional uncertainty should be interpreted cautiously.



# ----------------------------------------------------------------------------
# 7. A categorical predictor: transmission group 
# ----------------------------------------------------------------------------
# How does mean highway fuel economy differ between automatic
# and manual transmission configurations in this dataset?
#
# Run this supplied preparation code. It creates a two-level factor from the
# detailed transmission descriptions. Automatic is explicitly the reference.
# It uses the SAME source dataset as the numeric model.

cars_trans <- cars_dat |>
  filter(!is.na(trans)) |>
  mutate(
    transmission_group = case_when(
      str_starts(trans, "auto") ~ "automatic",
      str_starts(trans, "manual") ~ "manual",
      .default = NA_character_
    ),
    transmission_group = factor(
      transmission_group,
      levels = c("automatic", "manual")
    )
  ) |>
  drop_na(transmission_group)

# a. Summarize sample size and mean hwy for each transmission_group.
#    Make a boxplot of hwy by transmission_group, with jittered observations.
# b. Fit trans_model: hwy ~ transmission_group. Display tidy(trans_model).
# c. Interpret (Intercept) and transmission_groupmanual in words and mpg units.
#    Is transmission_groupmanual the manual-group mean or a difference?
# d. Use augment() with newdata = tibble(transmission_group =
#    c("automatic", "manual")) to obtain predictions for both groups.
# e. Run plot(trans_model). Why does residuals-versus-fitted show two vertical
#    stacks? What can their spread tell us? Why is checking for a curved
#    relationship less useful than in the numeric-predictor model?
# f. Does this model's group difference account for engine displacement?
#    Can we conclude switching a car's transmission would change its fuel
#    economy by this amount? Explain in one sentence.

# Your code and answers:

# ANSWER
# a.
transmission_means <-cars_trans |>
  group_by(transmission_group) |>
  summarize(n_configurations = n(), mean_hwy = mean(hwy))
transmission_means
# Automatic: n = 157, mean about 22.293 mpg.
# Manual: n = 77, mean about 25.779 mpg.

ggplot(
  data = cars_trans,
  mapping = aes(x = transmission_group, y = hwy)
) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.12, height = 0, alpha = 0.5) +
  labs(x = "Transmission group", y = "Highway fuel economy (mpg)")

# b.
trans_model <- lm(hwy ~ transmission_group, data = cars_trans)
tidy(trans_model)

# c. Intercept: predicted mean for automatic configurations, about 22.293 mpg.
# transmission_groupmanual: manual-minus-automatic mean difference, about
# +3.486 mpg. It is NOT the manual-group mean. Add it to the intercept to obtain
# the manual-group mean, about 25.779 mpg.

# d.
trans_predictions <- augment(
  trans_model,
  newdata = tibble(transmission_group = c("automatic", "manual"))
) |>
  select(transmission_group, .fitted)
trans_predictions

trans_predictions |>
  left_join(transmission_means, by = "transmission_group") |>
  mutate(difference = .fitted - mean_hwy)
# Differences should be zero up to floating-point rounding.

# e.
plot(trans_model)
# There are two fitted values, one estimated mean per group. Thus residuals
# versus fitted has two vertical stacks. Compare spread to assess equal
# variance. There is no continuous predictor on which to check curvature.
# The Q-Q plot is still relevant; look for tail departures and consider whether
# pooling groups hides different shapes. Scale-Location compares residual
# magnitudes in the two groups. Leverage equals 1/group size in this model:
# manual configurations have greater leverage because their group is smaller.

# f. This model does NOT adjust for engine displacement or vehicle class;
# its unadjusted observational difference cannot establish the effect of
# switching a configuration from automatic to manual transmission.




# ============================================================================
# OPTIONAL CHALLENGES: outside the 60-minute core
# ============================================================================
# A. Predict mean hwy at displ = 3 L, with a 95% confidence interval. Then obtain
#    a 95% prediction interval for an individual configuration at 3 L.
#    Which interval is wider, and why?
#
# B. Add .fitted and .resid to cars_trans using augment(trans_model,
#    data = cars_trans). Plot residuals by transmission_group and make a normal
#    Q-Q plot faceted by transmission_group. What does each plot assess?
#
# C. Color the original hwy-versus-displ scatterplot by class. What structure
#    does the pooled numeric model omit? Discuss without fitting a new model.
#
# Data reference: ggplot2::mpg (EPA fuel economy data).
# https://ggplot2.tidyverse.org/reference/mpg.html


# ============================================================================
# OPTIONAL CHALLENGES: ANSWERS
# ============================================================================

# A. Confidence interval for a mean versus prediction interval for an individual.
mean_at_3 <- augment(
  hwy_model,
  newdata = tibble(displ = 3),
  interval = "confidence",
  conf.level = 0.95
)
individual_at_3 <- augment(
  hwy_model,
  newdata = tibble(displ = 3),
  interval = "prediction",
  conf.level = 0.95
)
mean_at_3
individual_at_3
# Both have the same predicted mean (about 25.106 mpg). The individual
# prediction interval is wider because it includes individual error variation
# as well as uncertainty in the estimated mean. Assumptions still matter.

# B. Residuals and separate Q-Q plots for transmission groups.
trans_results <- augment(trans_model, data = cars_trans)

ggplot(
  data = trans_results,
  mapping = aes(x = transmission_group, y = .resid)
) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(width = 0.12, height = 0, alpha = 0.5) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  labs(x = "Transmission group", y = "Residual (mpg)")

ggplot(
  data = trans_results,
  mapping = aes(sample = .std.resid)
) +
  stat_qq(alpha = 0.7) +
  stat_qq_line(color = "steelblue") +
  facet_wrap(~ transmission_group) +
  labs(x = "Theoretical normal quantile", y = "Standardized residual quantile")
# First plot: compare group spread and unusual observations. Group residual
# means are zero by construction. Q-Q facets: assess approximate normal shape
# within each group, including tail departures. Neither checks independence.

# C. Color the original scatterplot by vehicle class.
ggplot(
  data = cars_dat,
  mapping = aes(x = displ, y = hwy, color = class)
) +
  geom_point(alpha = 0.7) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    color = "Vehicle class"
  )
# Vehicle classes differ in engine-size ranges and fuel-economy patterns.
# The pooled line combines within-class and between-class differences, without
# accounting for class. This is a reason to investigate model structure, not
# a conclusion that any particular expanded model must be correct.
