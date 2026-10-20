`# Week 5: Data Wrangling with dplyr - Part 2
# Estimated time: 45-60 minutes
#
# Learning goals:
# - summarize multiple variables with across()
# - count rows and sum existing counts with count()
# - create categories with case_when()
# - combine and filter related tables using keys and joins
# - clean strings and detect or extract text patterns
# - create date-times and extract date-time components
# - round values, distinguish logarithm bases, and order factor levels
# - combine these tools in a pipeline
#
# Instructions:
# 1. Write code below each question; keep the questions and instructions.
# 2. Use descriptive object names in snake_case.
# 3. Answer interpretation questions using comments (#).
# 4. Run your script from top to bottom before finishing.

	library(tidyverse)
	library(palmerpenguins)
	library(nycflights13)
	library(lubridate)

# We will stick with using the penguins dataset from the
# {palmerpenguins} package for Parts 1-3. For Part 4, 
# we will use the data from the {nycflights13} package. For
# the remainder, we will create data.
	
	
# ============================================================
# Part 1: across() ####
# ============================================================
# 1. What are the median bill length, bill depth, and flipper length of penguins on each island?

# For each island, calculate the median bill_length_mm,
# bill_depth_mm, and flipper_length_mm using across().
# Ignore missing values. Name the columns with the original name
# followed by _median. Save the result as island_medians.

island_medians <- penguins |>
  group_by(island) |>
  summarise(
    across(
      ends_with("mm"),
      ~ median(.x, na.rm = TRUE),
      .names = {"{.col}_median"}
    )
  )

island_medians
	
# 2. What are the mean and standard deviation of bill length and body mass for female penguins of each species?

# Keep only female penguins. For each species, calculate
# the mean and standard deviation of bill_length_mm and body_mass_g.
# Use across() with a named list of functions and ignore missing values.
# Use names such as mean_bill_length_mm and sd_body_mass_g.
# Save the result as female_measurements.

female_measurements <- penguins |>
  filter(sex == "female") |>
  group_by(species) |>
  summarise(
    mean_bill_length_mm = mean(bill_length_mm, na.rm = TRUE),
    sd_bill_length_mm = sd(bill_length_mm, na.rm = TRUE),
    mean_body_mass_g = mean(body_mass_g, na.rm = TRUE),
    sd_body_mass_g = sd(body_mass_g, na.rm = TRUE),
    .groups = "drop"
  )

female_measurements
  

# ============================================================
# Part 2: count() ####
# ============================================================
# 3. How many penguin observations are there for each species in each year, considering only 2008 and 2009?

# Using one pipeline, keep observations from 2008 and 2009
# and count observations for each species-year combination.
# Save the result as species_year_counts.

species_year_counts <- penguins |>
  filter(year == 2008 | year == 2009) |>
  count(species, year)

species_year_counts

# 4. Create a new summarized dataset that counts penguin observations for each combination of species and sex.
# Save as "penguin_counts".
	
# Hint: count penguin observations for each species-sex combination.
# Save the counts in a column called n_penguins.
# Each row in the resulting dataset represents one group,
# rather than one individual penguin.
# Missing sex values are included as a separate group.
	
penguin_counts <- penguins |>
  count(species, sex, name = "n_penguins")

penguin_counts

# 5. How many penguins of each species are represented in penguin_counts? What would count(species) count if you omitted wt =?

# Hint: starting with penguin_counts, use count() with wt =
# to calculate the total number of penguins represented for each species.
# Save the result as species_totals.
# In a comment, explain what count(species) would count without wt =.

species_totals <- penguin_counts |>
  count(species, wt = n_penguins)

species_totals

# Without wt =. it would count the number of penguins observed for each species.

# ============================================================
# Part 3: case_when() ####
# ============================================================
# 6. Classify each penguin’s flipper length as short, medium, or long based on these thresholds:
# flipper_length_mm >= 210 -> "long"
# flipper_length_mm >= 190 and < 210 -> "medium"
# flipper_length_mm < 190 -> "short"
# Ensure you leave missing flipper lengths as missing categories and save the result as penguin_flipper_size.

penguin_flipper_size <- penguins |>
  mutate(
    flipper_size = case_when(
      flipper_length_mm >= 210 ~ "long",
      flipper_length_mm >= 190 & flipper_length_mm < 210 ~ "medium",
      flipper_length_mm < 190 ~ "short",
      .default = NA_character_
    )
  )

penguin_flipper_size

# 7. How many penguins of each species fall into each flipper-size category? What does an NA in flipper_size mean?

# Starting with penguin_flipper_size, count observations
# by species and flipper_size. Save the result as flipper_counts.
# In a comment, explain what an NA in flipper_size means.

flipper_counts <- penguin_flipper_size |>
  count(species, flipper_size)

flipper_counts

# NA in flipper_size means flipper length was missing.

# ============================================================
# Part 4: joins ####
# ============================================================

# Setup:
# We will use four datasets from {nycflights13}:
# - flights: one row per flight
# - airlines: airline codes (carrier) and full airline names (name)
# - airports: airport codes (faa) and airport names (name)
# - planes: information about aircraft, identified by tailnum
#
# Create a version of flights containing only the columns we need:

	flights_small <- flights |>
	  select(year, time_hour, origin, dest, tailnum, carrier)


# 8. What airline operated each flight?
#
# Start with flights_small and join it to airlines.
# Match flights_small$carrier to airlines$carrier.
#
# Use left_join() to add the full airline name while keeping
# every flight. Explicitly specify the key with join_by().
# Save the result as flights_airlines.
#
# In a comment, identify the key and explain why the same carrier
# code can appear in multiple rows of flights_small.

flights_airlines <- flights_small |>
  left_join(airlines, join_by(carrier))

flights_airlines

# The key is the carrier of the flight for example JetBlue or American Airlines.
# The same carrier code can appear in multiple rows of flights_small because airlines send out many flights.

# 9. What is the full name of each flight's destination airport?
#
# Start with flights_small and join it to airports.
# Match flights_small$dest to airports$faa.
#
# First select faa and name from airports, renaming name
# to destination_name.
# Then use left_join() with join_by(dest == faa).
# Save the result as flights_destinations.
#
# In a comment, explain what an NA in destination_name means.

flights_destinations <- flights_small |>
  left_join(
    airports|>
      select(faa, destination_name = name),
    join_by(dest == faa)
    )

flights_destinations

# An NA in destination_name means that there is no destination airport.


#### The next two questions use a filtering join. ####
	
# 10. Which airlines operated flights in flights_small?
#
# Start with airlines and join it to flights_small.
# Match airlines$carrier to flights_small$carrier.
#
# Use semi_join() to keep only rows of airlines that have
# a matching carrier code in flights_small.
# Explicitly specify the key with join_by().
# Save the result as airlines_used.
#
# In a comment, explain whether semi_join() adds flight columns.

airlines_used <- flights_small |>
  semi_join(flights_small, join_by(carrier))

airlines_used

# 11. Which aircraft identifiers in flights_small are missing
# from the planes dataset?
#
# Start with flights_small and remove rows with missing tailnum.
# Then join it to planes.
# Match flights_small$tailnum to planes$tailnum.
#
# Use anti_join() to keep flights whose tailnum has no match
# in planes. Explicitly specify the key with join_by().
# Finally, use distinct(tailnum) to keep each unmatched
# identifier only once.
# Save the result as unmatched_tail_numbers.


# ============================================================
# Part 5: strings ####
# ============================================================

# For Part 5 and 6, we will work with this dataset. Please read it into R.
	
	fish_records <- tibble(
	  sample_id = c("DE-101", "NJ-205", "MD-310", "DE-412"),
	  species = c(
	    " sandbar shark ",
	    "BLACKTIP SHARK",
	    " Atlantic Sturgeon ",
	    "LEMON SHARK "
	  )
	)

# 12. Starting with fish_records, use one mutate() to:
# a. remove leading and trailing whitespace from species with str_trim()
# b. convert species to title case with str_to_title()
# c. create a column called `state` from the first two characters of sample_id with str_sub()
# Save the result as fish_clean.



# 13. Starting with fish_clean, create contains_shark using
# str_detect(): TRUE if species contains "Shark", FALSE otherwise.
# Then keep only shark records (if TRUE). Save the result as shark_records.




# ============================================================
# Part 6: regular expressions ####
# ============================================================

# 14. Starting with fish_clean, keep rows whose sample_id
# begins with either DE or NJ. Use filter() and str_detect().
# Save the result as de_nj_records.
# Hint: ^ marks the start of a string; | means OR.
# Make sure both alternatives are anchored to the beginning.



# 15. Starting with fish_clean, extract the numeric portion
# of sample_id into a new column called sample_number using str_extract().
# Save the result as fish_numbers.
# Hint: [0-9]+ means one or more digits.
# Check the class of sample_number. Is it numeric or character?


# ============================================================
# Part 7: dates and times ####
# ============================================================


# 16. Starting with sampling_times (code below), use one mutate() to:
# a. convert datetime with ymd_hms(); times are in America/New_York
# b. create a new column `year` from datetime
# c. create a new column `month` with month(..., label = TRUE)
# d. create a new column `hour` from datetime
# Save the result as sampling_times_clean.
	
	sampling_times <- tibble(
	  sample_id = c("DE-101", "NJ-205", "DE-310"),
	  datetime = c(
	    "2026-05-15 08:30:00",
	    "2026-06-20 14:15:00",
	    "2026-07-10 21:45:00"
	  )
	)


# 17. Starting with sampling_dates (code for dataframe below), create sample_date from
# year, month, and day using make_date(). Save as sampling_dates_clean.
# Check the class of sample_date. In a comment, explain how it differs
# from the datetime column in sampling_times_clean.

	sampling_dates <- tibble(
	  year = c(2025, 2026, 2026),
	  month = c(11, 2, 7),
	  day = c(12, 18, 3)
	)


# ============================================================
# Part 8: rounding, logarithms, and factors
# ============================================================

# 18. We will go back to palmerpenguins::penguins for this question. 
# Calculate mean penguin body mass in kilograms, ignoring
# missing values, and round it to two decimal places.
# Save the number as mean_body_mass_kg.


# 19. Calculate log(100) and log10(100).
# In comments: Are the results the same? What base does each use?


# ============================================================
# Factor levels
# ============================================================

# Please read the following vector into R:
	size_class <- c("medium", "small", "large", "small", "medium", "large")

# 20. Convert size_class to a factor with levels in this order:
# small, medium, large. Save it as size_class_factor.
# Use levels() to check the order.



# ============================================================
# Part 9: integrated challenge
# ============================================================

	# For this last part, we will use the following dataset:
	
	survey_data <- tibble(
	  sample_id = c("DE-001", "DE-002", "NJ-003", "NJ-004", "MD-005", "MD-006", "DE-007", "NJ-008"),
	  species = c(
	    " sandbar shark ", "SANDBAR SHARK", "Blacktip Shark ",
	    "BLACKTIP SHARK", " lemon shark", "LEMON SHARK ",
	    "Sandbar Shark ", " blacktip shark "
	  ),
	  datetime = c(
	    "2026-06-01 08:15:00", "2026-06-03 13:30:00",
	    "2026-06-10 19:45:00", "2026-07-02 10:15:00",
	    "2026-07-12 15:30:00", "2026-07-20 21:10:00",
	    "2026-06-08 09:00:00", "2026-06-18 11:45:00"
	  ),
	  length_cm = c(135, 165, 120, 155, 145, 175, 140, 125)
	)

# 21. Starting with survey_data, write ONE pipeline that:
# a. removes leading and trailing whitespace from species
# b. converts species to title case
# c. converts datetime to a date-time (America/New_York)
# d. creates state from the first two characters of sample_id
# e. creates month using month(..., label = TRUE)
# f. creates size_class: "large" for length_cm >= 150, "small" for < 150
# g. counts observations by state, species, month, and size_class
# Save the result as survey_summary.
# In a comment, explain what one row of survey_summary represents.
# Check that the sum of n equals the number of rows in survey_data.


# ------------------------------------------------------------
# Final check
# ------------------------------------------------------------
# Run the entire script from top to bottom.
# Check object names, indentation, and comments.
# Make sure you can explain each step of your pipelines.
