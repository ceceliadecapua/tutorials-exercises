# 01-tutorial solutions

# your turn 1

(12 + 18 + 27) / 3

pi * 4^2

sqrt(225)

2^5

# your turn 2
first_name <- "Jennifer"
current_year <- 2026
water_temp_c <- 14.5
water_temp_f <- water_temp_c * 9 / 5 + 32

first_name
current_year
water_temp_f

# your turn 3

length(temperatures)

mean(temperatures)

min(temperatures)
max(temperatures)

sum(temperatures > 11)

temperatures[temperatures > 11]

# your turn 3

mean(survey_catch, na.rm = TRUE)

sum(survey_catch, na.rm = TRUE)

sum(is.na(survey_catch))

sum(!is.na(survey_catch))

# your turn 5

max(fish_data$length_cm)

sum(fish_data$region == "south")

fish_data[fish_data$length_cm >= 35, ]

fish_data[fish_data$species == "cod", ]

# your turn 6

survey_data <- data.frame(
  station = c("A", "B", "C", "D", "E"),
  species = c("cod", "haddock", "cod", "hake", "haddock"),
  length_cm = c(41, 33, 38, 27, 36),
  caught = c(TRUE, TRUE, FALSE, TRUE, TRUE)
)

mean(survey_data$length_cm)

sum(survey_data$caught)

survey_data[survey_data$species == "cod", ]

mean_length <- mean(survey_data$length_cm)

survey_data[survey_data$length_cm > mean_length, ]

mean(
  survey_data$length_cm[survey_data$caught]
)
