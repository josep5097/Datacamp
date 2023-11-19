
# libreries
library(tidyverse)

# Overplotting 1: large datasets ====
# We must always consider overplotting, particularly 
# in the following four situations:
# Large datasets
# Aligned values on a single axis
# Low-precision data
# Integer data

# Plot price vs. carat, colored by clarity
plt_price_vs_carat_by_clarity <- ggplot(diamonds, 
                                        aes(carat, 
                                                      price, 
                                                      color = clarity))

# Add a point layer with tiny points
plt_price_vs_carat_by_clarity + 
  geom_point(alpha = 0.5, shape = ".")

# Set shape to 16
plt_price_vs_carat_by_clarity + 
  geom_point(alpha = 0.5, shape = 16)


# Overplotting 2: Aligned values ====
# Plot base
mtcars$fcyl <- as.factor(mtcars$cyl)
mtcars$fam <- as.factor(mtcars$am)

plt_mpg_vs_fcyl_by_fam <- ggplot(mtcars, 
                                 aes(fcyl, mpg, color = fam))

# Default points are shown for comparison
plt_mpg_vs_fcyl_by_fam + 
  geom_point()

# Overplotting 3: Low-precision data ====
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  # Swap for jitter layer with width 0.1
  geom_jitter(alpha = 0.5, 
              width = 0.1)


ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  # Set the position to jitter
  geom_point(alpha = 0.5, position = "jitter")

ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  # Use a jitter position function with width 0.1
  geom_point(alpha = 0.5, position = position_jitter(0.1))

# Overplotting 4: Integer data ====
Vocab <- carData::Vocab
str(Vocab)

# Plot vocabulary vs. education
ggplot(Vocab, aes(education, vocabulary)) +
  # Add a point layer
  geom_point()

ggplot(Vocab, aes(education, vocabulary)) +
  # Change to a jitter layer
  geom_jitter()

ggplot(Vocab, aes(education, vocabulary)) +
  # Set the shape to 1
  geom_jitter(alpha = 0.2, shape = 1)


# Histograms ====
# Cut up a continuous variable into discrete bins
# An internal variable called density can be accessed by using the .. notation, i.e. ..density..

# Plot mpg
ggplot(mtcars, aes(mpg)) +
  # Add a histogram layer
  geom_histogram()

## Set the hist bindwidth to 1
ggplot(mtcars, aes(mpg)) +
  # Set the binwidth to 1
  geom_histogram(binwidth = 1)

## Map y to the internal var ..density.. to show freq densities
# Map y to ..density..
ggplot(mtcars, aes(mpg, ..density..)) +
  geom_histogram(binwidth = 1)

## Set the fill color of the hist bars 
datacamp_light_blue <- "#51A8C9"
ggplot(mtcars, aes(mpg, ..density..)) +
  # Set the fill color to datacamp_light_blue
  geom_histogram(binwidth = 1, fill = datacamp_light_blue)

## Positions in histograms
# stack (the default): Bars for different groups are stacked on top of each other.
# dodge: Bars for different groups are placed side by side.
# fill: Bars for different groups are shown as proportions.
# identity: Plot the values as they appear in the dataset.

# Update the aesthetics so the fill color is by fam
ggplot(mtcars, aes(mpg, fill = fam)) +
  geom_histogram(binwidth = 1)

# Update the histogram layer to position the bars side by side
ggplot(mtcars, aes(mpg, fill = fam)) +
  # Change the position to dodge
  geom_histogram(binwidth = 1, position = "dodge")

## Update the histogram layer so the bas position fill y axis
ggplot(mtcars, aes(mpg, fill = fam)) +
  # Change the position to fill
  geom_histogram(binwidth = 1, position = "fill")

## Update the histogram layer so bars are top of each other
ggplot(mtcars, aes(mpg, fill = fam)) +
  # Change the position to identity, with transparency 0.4
  geom_histogram(binwidth = 1, position = "identity", alpha = 0.4)

# Barplots ====
# Use geom_bar or geom_col
# Geom        Stat      Action
# geom_bar()  count     Counts the number of cases at each x pos
# geom_col()  identity  Plot actual values

# Two type:
#   Absolute counts
#   Distributions

iris %>%
  select(Species, Sepal.Width) %>%
  gather(key, value, -Species) %>%
  group_by(Species) %>%
  summarise(avg = mean(value),
            stdev = sd(value)) -> iris_summ_long

ggplot(iris_summ_long,
       aes(x=Species,
           y=avg))+
  geom_col()+
  geom_errorbar(aes(ymin=avg-stdev,
                    ymax=avg+stdev),
                width=0.1)

## Geom_bar ====
# three positions> Stack:(def), dodge:(preferred), fill:(Show proportions)
# Plot fcyl, filled by fam
ggplot(mtcars, aes(fcyl, fill = fam)) +
  # Add a bar layer
  geom_bar()

ggplot(mtcars, aes(fcyl, fill = fam)) +
  # Set the position to "fill"
  geom_bar(position = "fill")


ggplot(mtcars, aes(fcyl, fill = fam)) +
  # Change the position to "dodge"
  geom_bar(position = "dodge")


## Overlaping bar plots ====
# Using position_dodge() is to specify how much dodging you want

ggplot(mtcars, aes(cyl, fill = fam)) +
  # Change position to use the functional form, with width 0.2
  geom_bar(position = position_dodge(width = 0.2))


ggplot(mtcars, aes(cyl, fill = fam)) +
  # Set the transparency to 0.6
  geom_bar(position = position_dodge(width = 0.2), alpha = 0.6)


## Bar plots: Sequential color palette ====
# Each segment will be fill according to an ordinal variable
# Best way> Sequential color palette.
ggplot(mtcars, aes(fcyl, fill = fam)) +
  geom_bar() +
  scale_fill_brewer(palette = "Set1")


Vocab$education <- as.factor(Vocab$education)
Vocab$vocabulary <- as.factor(Vocab$vocabulary)

# Plot education, filled by vocabulary
ggplot(Vocab,
       aes(education, 
                  fill = vocabulary)) +
  # Add a bar layer with position "fill"
  geom_bar(position = "fill")


# Plot education, filled by vocabulary
ggplot(Vocab, aes(education, fill = vocabulary)) +
  # Add a bar layer with position "fill"
  geom_bar(position = "fill") +
  # Add a brewer fill scale with default palette
  scale_fill_brewer()


# Basi line plots ====
# Print the head of economics
head(economics)

# Using economics, plot unemploy vs. date
ggplot(economics, aes(date, unemploy)) +
  # Make it a line plot
  geom_line()

# Change the y-axis to the proportion of the population that is unemployed
ggplot(economics, aes(date, unemploy / pop)) +
  geom_line()


# Multiple time series ====
load("Data/fish.RData")
str(fish.species)

# Plot the Rainbow Salmon time series
ggplot(fish.species, aes(x = Year,
                         y = Rainbow)) +
  geom_line()
# Plot the Rainbow Salmon time series
ggplot(fish.species, aes(x = Year, 
                         y = Pink)) +
  geom_line()

# Plot multiple time-series by grouping by species
ggplot(fish.tidy, aes(Year, 
                      Capture)) +
  geom_line(aes(group = Species))

# Plot multiple time-series by coloring by species
ggplot(fish.tidy, 
       aes(Year, 
                      Capture, 
                      color = Species)) +
  geom_line(aes(group = Species))

