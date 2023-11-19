# Library ====
# Data
library(gapminder)
library(dplyr)

# Data ====
gapminder

# filter ====
gapminder %>% filter(year == 1957)

gapminder %>% filter(country == "China", year == 2002)

# arrange ====
# Ascendente 
gapminder %>% arrange(gdpPercap)
# Descendente 
gapminder %>% arrange(desc(gdpPercap))

## Combinando ====
gapminder %>% 
              filter (year == 2002) %>%
              arrange(lifeExp)

# Filter for the year 1957, then arrange in descending order of population
gapminder %>%
              filter(year == 1957) %>%
              arrange(desc(pop))        

# Mutate ====
# Change the population represented in 1000000 times
gapminder %>%
              mutate(pop = pop/1000000)

# gdpPercap = Gross Domestic Product / current population
# TotalGDP = gdpPerCap x population 
# Determine countries with the highest total gdp in 2007
gapminder %>%
              mutate(gdp = gdpPercap*pop) %>%
              filter(year == 2007) %>%
              arrange(desc(gdp))

# Represent lifeExp in months
gapminder %>% mutate(lifeExpMonths = lifeExp*12)

# Find the countries with the highest life expectancy, in months, in the year 2007.
gapminder %>% 
              filter(year == 2007) %>%
              mutate(lifeExpMonths = lifeExp*12) %>%
              arrange(desc(lifeExpMonths))