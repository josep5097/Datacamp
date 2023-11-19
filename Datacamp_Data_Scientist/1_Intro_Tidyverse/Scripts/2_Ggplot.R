# Library ====
# Libreria de Data
library(gapminder)
library(dplyr)
library(ggplot2)

# New Object to visualize
# gapminder_1952
gapminder_1952 <- gapminder %>% filter(year == 1952)
gapminder_1952
attach(gapminder_1952)

# Scatter plot lifeExp vs gdpPercap 
ggplot(gapminder_1952, 
       aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

# Scatter plot gdpPercap Vs pop
ggplot(gapminder_1952, 
       aes(x = pop, y = gdpPercap)) +
  geom_point()

# Scatter plot LifeExp vs pop
ggplot(gapminder_1952, 
       aes(x = pop, y = lifeExp)) +
  geom_point()

# Is better use a log scale
ggplot(gapminder_1952, 
       aes(x = pop, y = lifeExp)) +
  geom_point()+
  scale_x_log10()

# Comparing gdpPercap Vs Pop both in log scale
ggplot(gapminder_1952, 
       aes(x = pop, y = gdpPercap)) +
  geom_point()+
  scale_x_log10()+
  scale_y_log10()

## Additional aesthetics ====
# Color the points by continents, 
# Size of the points represented by population
ggplot(gapminder_1952, 
       aes(x = gdpPercap, 
           y = lifeExp, 
           color = continent,
           size = pop)) +
  geom_point()+
  scale_x_log10()

### Faceting ====
ggplot(gapminder_1952, 
       aes(x = gdpPercap, 
           y = lifeExp,
           size = pop)) +
  geom_point()+
  scale_x_log10()+
  facet_wrap(~continent)

# Scatter plot comparing gdpPercap and lifeExp, 
# with color representing continent
# and size representing population, 
# faceted by year
ggplot(gapminder, 
       aes(x = gdpPercap, 
           y = lifeExp,
           size = pop,
           color = continent)) +
  geom_point()+
  scale_x_log10()+
  facet_wrap(~year)
