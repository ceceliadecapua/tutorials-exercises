# One possible solution is shown for each exercise. 
# Other plots meeting the instructions are valid. 

# These exercises use `ggplot2::diamonds`, which comes with {ggplot2}. 
# Each row represents one diamond. 
# We will use a fixed sample of 2,000 diamonds to keep the scatterplots readable.

# Variables used here:
# - `carat`: diamond weight in carats.
# - `price`: price in US dollars.
# - `cut`: cut quality, with categories Fair, Good, Very Good, Premium, and Ideal.
# - `color`: diamond color grade, from D (best) to J (worst).


# I suggest you use `data =` and `mapping =` in your `ggplot()` calls as you learn. 
# Answer interpretation questions in one sentence beneath your code.

	# Setup 
	library(tidyverse)
	library(patchwork)

	# Since the next line of code takes a random sample of rows from the data set,
	# let's set the seed so it will use the same sample each time.
	# set.seed() is a random number generator; run ? set.seed() for more information
	
	set.seed(123)

	diamonds_plot <- ggplot2::diamonds |>
	  slice_sample(n = 2000)
	
	glimpse(diamonds_plot)

	# 1. Build and customize a scatterplot:
		
	# Create a scatterplot with:
	# - `carat` on the x-axis and `price` on the y-axis;
	# - point color mapped to `cut`;
	# - all points set to `alpha = 0.5` and `size = 1.5`.
	
	# Add informative axis labels and a title. 
	# Use a built-in theme of your choice. 
	# Save the plot as `p_scatter`, then display it.
	
	# Write one sentence describing the relationship you see between carat and price. 
	# Identify one aesthetic you mapped and one aesthetic you set.
	
	# Write your code here:
	
	p_scatter <- 
		ggplot(
  		data = diamonds_plot,
  		mapping = aes(x = carat, y = price, color = cut)) +
  		geom_point(alpha = 0.5, size = 1.5) +
  		labs(
  		  title = "Diamond price vs. carat",
  		  x = "Carat",
  		  y = "Price (US dollars)",
  		  color = "Cut") +
  		theme_minimal()

	p_scatter


	# Your response to the questions here:
	# Price generally increases with carat, although prices vary among diamonds 
	# of similar carat. 
	
	# Mny acceptable answers, e.g., color is mapped to cut; 
	# alpha and size are set to fixed values. 

	
	# 2. Explore a distribution 

	# Create a histogram of `price` using `binwidth = 500`. 
	# Set the bar fill to `"steelblue"` and the outline color to `"white"`. 
	# Add informative labels.
	# Then make a second version using `binwidth = 1000`.
	
	# Write one sentence explaining how changing the bin width affects the 
	# appearance of the histogram. 
	# Which version helps you see the distribution more clearly? 

	# Write your code here:
	
	p_hist <- 
		ggplot(
  		data = diamonds_plot,
  		mapping = aes(x = price)) +
  		geom_histogram(
  		  binwidth = 500,
  		  fill = "steelblue",
  		  color = "white") +
  		labs(
  		  title = "Distribution of diamond prices",
  		  x = "Price (US dollars)",
  		  y = "Number of diamonds") +
  		theme_minimal()

	p_hist

	p_hist_bin <- 
		ggplot(
  		data = diamonds_plot,
  		mapping = aes(x = price)) +
  		geom_histogram(
  		  binwidth = 1000,
  		  fill = "steelblue",
  		  color = "white") +
  		labs(
  		  title = "Distribution of diamond prices: wider bins",
  		  x = "Price (US dollars)",
  		  y = "Number of diamonds") +
  		theme_minimal()
	
	p_hist_bin

	# Your response:
	# Wider bins produce fewer, broader bars and show less detail. 

	# 3. Compare groups with two layers 
	
	# Create a boxplot with `cut` on the x-axis and `price` on the y-axis.
	# Map the box fill to `cut`.
	# Add individual observations using `geom_jitter(width = 0.15, height = 0, alpha = 0.15)`.
	# Give all jittered points the fixed color `"grey30"`.
	# Remove the fill legend because the cut categories already appear on the x-axis.
	# Add informative labels and a built-in theme.
	# Save this plot as `p_box`, then display it.
	
	# Hint: put `fill = cut` inside `aes()` in `geom_boxplot()` so it applies 
	# only to the boxplot layer.

	# Write one sentence explaining what the jittered points add to the boxplot.

	# Write your code here:
	p_box <- 
		ggplot(
	  	data = diamonds_plot,
	  	mapping = aes(x = cut, y = price)) +
	  	geom_boxplot(mapping = aes(fill = cut)) +
	  	geom_jitter(
	  	  width = 0.15,
	  	  height = 0,
	  	  alpha = 0.15,
	  	  color = "grey30") +
	  	guides(fill = "none") +
	  	labs(
	  	  title = "Diamond prices by cut",
	  	  x = "Cut",
	  	  y = "Price (US dollars)") +
	  	theme_minimal()
	
	p_box

	# Your response:
	# The points show individual prices and where observations are concentrated, 
	# alongside the boxplot summary. 
	# Height = 0 keeps the plotted prices unchanged vertically. 
	# The default boxplot also draws outliers, so some observations appear in both layers; 
	# suppressing outliers is not required for this exercise.

	
# 4. Compare color and facets 

	# Create a new scatterplot with `carat` on the x-axis and `price` on the y-axis. 
	# Set all points to `alpha = 0.4`.
	# Use `facet_wrap()` to create one panel for each `cut` category. 
	# Keep all points the same color. 
	# Add informative labels and a built-in theme.
	# Write one sentence comparing this plot with `p_scatter`. 
	# What is easier to see when cut categories have their own panels?

	# Write your code here:

	p_facets <- 
		ggplot(
  		data = diamonds_plot,
  		mapping = aes(x = carat, y = price)) +
  		geom_point(alpha = 0.4, color = "steelblue") +
  		facet_wrap(~ cut) +
  		labs(
  		  title = "Diamond price vs. carat, by cut",
  		  x = "Carat",
  		  y = "Price (US dollars)") +
  		theme_minimal()

	p_facets
	
	# Your response:
	# Facets reduce overlap among cut categories and make within-category 
	# patterns easier to inspect. 
	# The original color plot allows direct comparison of categories in the same panel.
	# Accept other accurate comparisons.

	# 5. Assemble and save a figure 
	
	# Use `patchwork` to place `p_scatter` and `p_box` side by side.
	# Add an overall title using `plot_annotation()`.
	# Save the combined figure as an object named `diamond_figure`.
	# Write the object out to display it.
	# Use `ggsave()` to save it as `diamond_figure.png`, with width 10 inches, 
		# height 5 inches, and resolution 300 dpi.
	# Use the `plot =` argument to specify the object to save in ggsave().
	# Find the saved image in your project folder and open it. 
	# Check that the labels and legends are readable.
	# If they are not, play around with the height and width or the font size in theme().
	# Hint: use `p_scatter | p_box` for the side-by-side layout.
	
	# Write your code here
	diamond_figure <- (p_scatter | p_box) +
	  plot_annotation(title = "Price patterns in a sample of diamonds")
	
	diamond_figure
	
	ggsave(
	  filename = "diamond_figure.png",
	  plot = diamond_figure,
	  width = 10,
	  height = 5,
	  units = "in",
	  dpi = 300
	)

	# 6. Practice `facet_grid()` with two grouping variables.
	
	# Create a scatterplot of price (y) against carat (x) with:
	# - rows defined by `cut` and columns defined by the diamond `color` grade, 
	# using `facet_grid()`
	# - all points partly transparent
	# - informative labels and a built-in theme.
	
	# Keep all points the same fixed color. 
	# Note that `color` is a column in this dataset: using it in a facet formula 
	# splits the data by diamond color grade.
	
	# Which layout is easier to read: the five panels from Exercise 4 or this larger grid?
	# Explain your choice in one sentence.
	
	# Write your code here:
	
	ggplot(
	  data = diamonds_plot,
	  mapping = aes(x = carat, y = price)) +
	  geom_point(alpha = 0.4, color = "steelblue") +
	  facet_grid(cut ~ color) +
	  labs(
	    title = "Diamond price by cut and color grade",
	    x = "Carat",
	    y = "Price (US dollars)") +
	  theme_minimal()
	
	# Write your answer here:
	# The larger grid contains 35 panels and can be crowded on a small screen. 
	# Either preference is acceptable with an explanation.
	