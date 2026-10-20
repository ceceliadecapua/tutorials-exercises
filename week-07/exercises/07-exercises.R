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

glimpse(mpg)

# b. The response is mean highway fuel economy in miles per gallon.
# The predictor is engine displacement in liters.

mpg |>
  summarize(
    n_rows = n(),
    missing_hwy = sum(is.na(hwy)),
    missing_displ = sum(is.na(displ))
  )

# c. There are 234 rows. There is no missing values in hwy or displ.

cars_dat <- mpg |>
  drop_na(hwy, displ)

cars_dat

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

ggplot(
  data = cars_dat,
  mapping = aes(x = displ, y = hwy))+
  geom_point(alpha = 0.7)+
  labs(x = "Engine Displacement (L)",
       y = "Highway Fuel Economy (mpg)")

# b. The relationship is negative. So higher fuel economy means less engine displacement.

cars_dat |>
  summarize(
    correlation = cor(displ, hwy)
  )

# c. The correlation between engine displacement and highway fuel economy is -0.766.

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

hwy_model <- lm(
  hwy ~ displ,
  data = cars_dat
)

summary(hwy_model)
tidy(hwy_model)

# c. The slope is -3.53 mpg/L.

range(cars_dat$displ)

# d. The intercept is 35.7 mpg. An engine displacement of 0 L is not in the observed range.

glance(hwy_model)|>
  select(nobs, r.squared, sigma)

# e. Nobs stands for number of observations. 234 observations were used.
# The r squared value is 0.587.
# So 58.7% of the variation observed in highway fuel economy is accounted for by the model.
# Sigma tells us the estimate error in standard deviation. Sigma is 3.84 mpg.

# f. The p-value is 2.04e-46. Such a small p-value suggests the model fits well.

# ----------------------------------------------------------------------------
# 4. Fitted values, residuals, predictions, and plot
# ----------------------------------------------------------------------------
# a. Use augment(hwy_model, data = cars_dat) to create a data frame containing
#    fitted values and residuals. Save it as fitted_hwy.
#    Display displ, hwy, .fitted, and .resid for the first six observations.
# b. For the FIRST observation, calculate observed minus fitted fuel economy.
#    Check that your answer matches .resid. Did the model overpredict or
#    underpredict highway fuel economy for this configuration?
#    A positive residual means the model underpredicted;
#    a negative residual means the model overpredicted.
#    Code hints: Start with fitted_hwy |> slice_head(n = 1).
#    Use transmute() to display hwy, .fitted, .resid, and a new column
#    calculated as hwy - .fitted.
# c. Create a tibble called new_engines with 100 evenly spaced displ values
#    spanning the observed range in cars_dat. Use seq().
# d. Use augment() with newdata = new_engines, interval = "confidence", and
#    conf.level = 0.95 to create hwy_predictions.
# e. Plot the original observations, a prediction line, and a shaded 95%
#    confidence band. Use .fitted, .lower, and .upper from hwy_predictions.
# f. Check the observed displ range. Would a prediction at 10 L be outside
#    the range of observed values (extrapolation)?
#
# Your code and answers:

fitted_hwy <- augment(
  hwy_model, data = cars_dat
)

fitted_hwy |>
  select(displ, hwy, .fitted, .resid) |>
  slice_head(n = 6)

fitted_hwy |>
  slice_head(n = 1) |>
  transmute(
    observed_mpg = hwy,
    fitted_mpg = .fitted,
    residual_mpg = .resid,
    observed_minus_fitted_mpg = hwy - .fitted
  )

# b. The observed miles per gallon is 29 and the fitted miles per gallon is 29.3.
# The residual, difference between them, was -0.343 miles per gallon.
# The model overpredicts the miles per gallon.

new_engines <- tibble(
  displ = seq(
    min(cars_dat$displ),
    max(cars_dat$displ),
    length.out = 100
  )
)

hwy_predictions <- augment(
  hwy_model,
  newdata = new_engines,
  interval = "confidence",
  conf.level = 0.95
)

ggplot(
  data = cars_dat,
  mapping = aes(x = displ, y = hwy))+
  geom_ribbon(
    data = hwy_predictions,
    mapping = aes(x = displ, ymin = .lower, ymax = .upper),
    inherit.aes = FALSE,
    fill = "steelblue",
    alpha = 0.2
  )+
  geom_point(alpha = 0.7) +
  geom_line(
    data = hwy_predictions,
    mapping = aes(y = .fitted),
    color = "steelblue",
    linewidth = 1
  )+
  labs(x = "Engine displacement (L)", y = "Highway fuel economy (mpg)")

range(cars_dat$displ)

# f. A prediction of 10L is outside of the range of observed values.

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

plot(hwy_model)

# a. Residuals vs. fitted
# Residuals round zero follow a slightly curved pattern.
# A straight line would miss part of the mean relationship.

#b. Q-Q residuals
# The points in the middle follow the reference line.
# The points on the tail ends do not follow the reference line.
# This means nonnormality. Errors are a reasonable assumption here.

#c. Scale-location
# The spread is not similar among fitted values because the red line is not horizontal.
# Equal-variance cannot be assumed.

# d. Residuals vs. leverage
# Some cars have large leverage and large standardized residuals.
# No points are near or beyond the Cook's distance contours.
# Check for data quality and context.

# ----------------------------------------------------------------------------
# 6. Communicate your conclusion 
# ----------------------------------------------------------------------------
# Write 2-3 sentences about the hwy_model:
#   - State the estimated association with direction, magnitude, and units.
#   - Mention one diagnostic concern and what it means for interpretation.

# Your conclusion:

# The slope tells us that if you increase by 1L in engine displacement,
# you decrease your highway fuel economy by 3.53 miles per gallon.
# Since the residual plot is curved, it's slope should not be totally trusted.

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

transmission_mean <- cars_trans |>
  group_by(transmission_group) |>
  summarize(n_configurations = n(), mean_hwy = mean(hwy))

transmission_mean

ggplot(
  data = cars_trans,
  mapping = aes(x = transmission_group, y = hwy)
)+
  geom_boxplot(outlier.shape = NA)+
  geom_jitter(width = 0.12, height = 0, alpha = 0.5)+
  labs(x = "Transmission group", y = "Highway fuel economy (mpg)")

trans_model <- lm(hwy ~ transmission_group, data = cars_trans)
tidy(trans_model)

# c. Intercept is the mean of the automatic highway fuel economy in miles per gallon.
# This value is 22.3 mpg. transmission_groupmanual is the DIFFERENCE between
# the intercept and the mean highway fuel economy for manual cars in miles per gallon.
# transmission_groupmanual is 3.49 mpg.
# The actual mean for manual cars highway fuel economy in miles per gallon is
# 22.3 + 3.49 so 25.79 mpg. 

trans_predictions <- augment(
  trans_model,
  newdata = tibble(transmission_group = c("automatic", "manual"))
) |>
  select(transmission_group, .fitted)
trans_predictions

trans_predictions |>
  left_join(transmission_mean, by = "transmission_group") |>
  mutate(difference = .fitted - mean_hwy)

plot(trans_model)

# e. The two vertical stacks show the one estimated mean per group.
# The spread of the stacks can be used to determine equal variance.
# Checking for a curved relationship isn't helpful because there is no
# continuous predictor whose relationship needs to be straight.

# f. This model's group difference does not account for engine displacement
# so we can not conclude that switching a car's transmission would change
# its fuel economy.

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
