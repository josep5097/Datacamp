# Library ====
# Libreria de Data
library(gapminder)
library(dplyr)
library(ggplot2)

# Create a summarize column by mean(lifeExp)
gapminder %>%
          summarize(meanLifeExp = mean(lifeExp))

# Summarizing one year
gapminder %>%
          filter(year == 2007) %>%
          summarize(meanLifeExp = mean(lifeExp),
                    totalPop = sum(pop)/1000000)

# Filter for 1957 then summarize 
# the median life expectancy
gapminder %>%
  filter(year == 1957)%>%
  summarize(medianLifeExp = median(lifeExp))

# Filter for 1957 then summarize 
# the median life expectancy and 
# the maximum GDP per capita
gapminder %>%
  filter(year == 1957)%>%
  summarize(medianLifeExp = median(lifeExp),
            maxGdpPercap = max(gdpPercap))

## Group_by ====
# Summarizing by year
gapminder %>%
          group_by(year) %>%
          summarize(medianLifeExp = median(lifeExp),
                    maxGdpPercap = max(gdpPercap),
                    totalPop = sum(pop))

# Summarizing by continent
gapminder %>%
          filter(year == 2007) %>%
          group_by(continent) %>%
          summarize(medianLifeExp = median(lifeExp),
                    maxGdpPercap = max(gdpPercap),
                    totalPop = sum(pop))

# Summarizing by continent and year
gapminder %>%
          group_by(year,continent) %>%
          summarize(medianLifeExp = median(lifeExp),
                    maxGdpPercap = max(gdpPercap),
                    totalPop = sum(pop))

## Visualizing summarized data ====
# Creating object
by_year <- gapminder %>%
                    group_by(year) %>%
                    summarize(totalPop = sum(pop),
                              meanLifeExp = mean(lifeExp))

# Ggplot
ggplot(by_year,
       aes(x = year,
           y = totalPop))+
geom_point()+
expand_limits(y=0)

# Summarizing by year and continent
by_year_continent <- gapminder %>%
                                  group_by(year, continent) %>%
                                  summarize(totalPop = sum(pop),
                                            meanLifeExp = mean(lifeExp))

by_year_continent

ggplot(by_year_continent,
       aes(x = year,
           y = totalPop,
           color = continent))+
geom_point()+
expand_limits(y=0)


## Ex1
# Summarize medianGdpPercap within 
# each continent within each year: 
# by_year_continent
by_year_continent <- gapminder %>%
  group_by(year, continent) %>%
  summarize(medianGdpPercap = median(gdpPercap))

# Plot the change in medianGdpPercap 
# in each continent over time
ggplot(by_year_continent,
       aes(x = year,
           y = medianGdpPercap,
           color = continent))+
  geom_point()+
  expand_limits(y=0)


# Ex2
# Summarize the median GDP and median life expectancy per continent in 2007
by_continent_2007 <- gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(medianLifeExp = median(lifeExp), 
            medianGdpPercap = median(gdpPercap))

# Use a scatter plot to compare the median GDP and median life expectancy
ggplot(by_continent_2007,
       aes(x = medianGdpPercap,
           y = medianLifeExp,
           color = continent))+
  geom_point()+
  expand_limits(y=0)

