# Librerias ====
library(dplyr)

# Data ====
counties <- readRDS("Data/counties.rds")

# Selection Data ====
# Using the function select()
counties %>%
  select(state, county, population, poverty)

# Adding to an object
counties_selected <- counties %>%
  select(state, county, population, private_work, public_work, self_employed, unemployment)

# Arrange ====
# Arraging by population
counties_selected %>%
  arrange(population)
# The lowest population is in Kalawao - Hawaii

# Arrange: descending population
counties_selected %>%
  arrange(desc(population))
# The highest population is in Los Angeles - CA

# Arranging by public work
counties_selected %>%
  arrange(desc(public_work))
# Kalawao has more % of public work.

# Filter ====
# Obtain data only from New York and with umemployment 
# under 6%.
counties_selected %>%
  arrange(desc(population)) %>%
  filter(state == "New York",
         unemployment < 6) 

# Filter for counties with a population above 1000000
counties_selected %>%
  filter(population > 1000000)

# Filter for counties in the state of California 
# that have a population above 1000000
counties_selected %>%
  filter(state == "California",
         population > 1000000)

# Filter for Texas and more than 10000 people; 
# sort in descending order of private_work
counties_selected %>%
  filter(state == "Texas",
         population > 10000) %>%
  arrange(desc(private_work))

# Mutate ====
# Determine the total number of unemployed people in a county %
# Formula: 
# #unemployedPeople = population*unemployment /100
counties_selected %>%
  mutate(unemployed_population = population*unemployment/100) %>%
  arrange(desc(unemployed_population))

# New column public_workers with the number of people employed in public work
# Sort in descending order of the public_workers column
counties_selected %>%
  mutate(public_workers = public_work * population / 100) %>%
  arrange(desc(public_workers))
# Los Angeles is the county with the most government employees.

# Calculating the percentage of women in a county
# Using columns state, county, population, men, and women
counties_selected <- counties %>%
  select(state, county, population, men, women)

# Calculating propotion_women = women/population
counties_selected %>%
  mutate(proportion_women = women / population)