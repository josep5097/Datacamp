# Librerias ====
library(dplyr)

# Data ====
counties <- readRDS("Data/counties.rds")

counties %>%
  # Select state, county, population, and industry-related columns
  select(state, county, population, professional:production) %>%
  # Arrange service in descending order 
  arrange(desc(service))

# Another select helper is ends_with(), which finds the columns 
# that end with a particular string.

counties %>%
  # Select the state, county, population, and those ending with "work"
  select(state, county, population, ends_with("work")) %>%
  # Filter for counties that have at least 50% of people engaged in public work
  filter(public_work >= 50)

# The rename() verb is often useful for changing the name of a column that comes 
# out of another verb, such as count().
# Count the number of counties in each state
counties %>%
  count(state)%>%
  # Rename the n column to num_counties
  rename(num_counties = n)


# rename() isn’t the only way you can choose a new name for a column: you can
# also choose a name as part of a select().

# Select state, county, and poverty as poverty_rate
counties %>%
  select(state, county, poverty_rate = poverty)

# Transmute ====
# combination: select & mutate
# returns a subset of columns that are transformed and changed
counties %>%
  # Keep the state, county, and populations columns, and add a density column
  transmute(state, county, population, density = population / land_area) %>%
  # Filter for counties with a population greater than one million 
  filter(population > 1000000) %>%
  # Sort density in ascending order 
  arrange(density)


# Choose the appropriate verb for each situation ====
# Change the name of the unemployment column
counties %>%
  rename(unemployment_rate = unemployment)

# Keep the state and county columns, and the columns containing poverty
counties %>%
  select(state, county, contains("poverty"))

# Calculate the fraction_women column without dropping the other columns
counties %>%
  mutate(fraction_women = women / population)

# Keep only the state, county, and employment_rate columns
counties %>%
  transmute(state, county, employment_rate = employed / population)
