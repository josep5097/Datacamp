# Librerias ====
library(dplyr)

# Data ====
counties <- readRDS("Data/counties.rds")

# Selection Data ====
# Using the function select()
counties_selected <- counties %>%
  select(region, state, population, citizens)

# Counting ====
# Use count to find the number of counties in each region
counties_selected %>%
  count(region, 
        sort = TRUE)
# The South has the greatest number of counties.

# Counting citizens by state ====
# Adding the argument wt, which stands for Weight 
# Find number of counties per state,
# weighted by citizens
counties_selected %>%
  count(state, wt = citizens, sort = TRUE)
# California is the state with the most citizens.

# Ex1
counties_selected <- counties %>%
  select(region, state, population, walk)

# Add population_walk containing the total number of people who walk to work 
# Formula: population_walk = population * walk / 100)
# Walk: % people in each county that walk to work
counties_selected %>%
  mutate(population_walk = population * walk / 100) %>%
  # Count weighted by population_walk
  count(state, wt = population_walk, sort = TRUE)

# Group_by, summarize, and ungroup ====
## Summarize ====
# Summary functions

# sum()
# mean()
# median()
# min()
# max()
# n()

## Group by ====
counties_selected <- counties %>%
  select(state, metro, county, population)

# Obtain the total population per state in metro and nonmetro areas.
counties %>%
  group_by(state, metro) %>%
  summarize(totalPop = sum(population))

# Ex
counties_selected <- counties %>%
  select(county, population, income, unemployment)
# Summarize to find minimum population, maximum unemployment, and average income
counties_selected %>%
  summarize(min_population = min(population),
            max_unemployment = max(unemployment),
            average_income = mean(income))

# Ex
# Summarizing by state
counties_selected <- counties %>%
  select(state, county, population, land_area)

# Group by state, find the total area and population
counties_selected %>%
  group_by(state) %>%
  summarize(total_area = sum(land_area),
            total_population = sum(population)) %>%
  # density = #totalPop / #totalArea
  mutate(density = total_population / total_area) %>%
  arrange(desc(density))
# New Jersey and Rhode Island are the most crowded on the US State
# >than a thousand people per square mile.

# Ex
# Summarizing by state and region
counties_selected <- counties %>%
  select(region, state, county, population)

# Summarize to find the total population
counties_selected %>%
  group_by(region, state) %>%
  summarize(total_pop = sum(population)) %>%
  
  # Calculate the average_pop and median_pop columns 
  summarize(average_pop = mean(total_pop),
            median_pop = median(total_pop))
# South has the highest average population, while North Central
# has the highest median population.

# Top ====
# top_n takes 2 args: #Observations for each group
# and the column you want to weight by.
counties_selected <- counties %>%
  select(state, county, population, unemployment, income)

# Find the county with the highest pop in each state.
counties_selected %>%
  group_by(state) %>%
  top_n(1, population)
# Jefferson is the highest population county in Alabama

# Changing the number of Observations
# Obtain the 3 counties with the highest unemployment rate.
counties_selected %>%
  group_by(state) %>%
  top_n(3, unemployment)

# EX
counties_selected <- counties %>%
  select(region, state, county, metro, population, walk)

# Group by region, find the greatest number of 
# citizens who walk to work
counties_selected %>%
  group_by(region) %>%
  top_n(1, walk)
# The top 1 from 3 regions where most citizens walks to
# work are nonmetro. And New York which is in metro area.

# EX
# Finding the highest-income state in each region
counties_selected <- counties %>%
  select(region, state, county, population, income)

counties_selected %>%
  group_by(region, state) %>%
  # Calculate average income -> mean income
  summarize(average_income = mean(income)) %>%
  # Find the highest income state in each region
  top_n(1, average_income)
# New Jersey from Northeast region is the state with the
# highest average income!


# EX
# Using summarize, top_n, and count together
counties_selected <- counties %>%
  select(state, metro, population)

# Find the total population for each combination of state and metro
counties_selected %>%
  group_by(state, metro) %>%
  summarize(total_pop = sum(population)) %>%
  
  # Extract the most populated row for each state
  # Metro>NonMetro or NonMetro>Metro?
  top_n(1, total_pop) %>%
  
  # Count the states with more people in Metro or Nonmetro areas
  # We need to ungroup data to obtain the total 
  ungroup() %>% 
  count(metro)
# 44 states hace more people living in Metro areas
# and 6 states that are from Nonmetro areas.