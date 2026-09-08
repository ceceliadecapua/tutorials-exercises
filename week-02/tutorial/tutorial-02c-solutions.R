#### your turn 1: improve file names ####

# Original: My Homework 1.R
# Revised: my-homework-01.R

# Original: FINAL analysis.r
# Revised: analysis.R

# Original: DataCleaningScript.R
# Revised: data-cleaning-script.R

# Original: figure 2 final.PNG
# Revised: figure-02.png


#### your turn 2: improve object names ####

water_temperature <- 18.5

average_fish_weight <- 2.4

species_names <- c("cod", "haddock", "hake")


#### your turn 3: repair the spacing ####

fish_mass <- c(1.2, 1.5, NA, 1.8, 2.1)

mean_mass <- mean(fish_mass, na.rm = TRUE)

large_mass <- fish_mass > 1.5


#### your turn 6: restyle a function ####

calculate_fish_mean <- function(x) {
  result <- mean(x, na.rm = TRUE)
  result
}


#### final practice: restyle an analysis ####

library(tidyverse)

human_data <- starwars |>
  filter(
    species == "Human",
    !is.na(height),
    !is.na(mass)
  )

summary_data <- human_data |>
  summarise(
    mean_height = mean(height),
    mean_mass = mean(mass),
    sample_size = n()
  )

ggplot(
  human_data,
  aes(
    x = height,
    y = mass
  )
) +
  geom_point(size = 3) +
  labs(
    x = "Height",
    y = "Mass",
    title = "Human characters"
  ) +
  theme_minimal()

summary_data
