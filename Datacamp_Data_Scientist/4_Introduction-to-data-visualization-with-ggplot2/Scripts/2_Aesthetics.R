# Aesthetic option it is usually written in ggplot,
# but it can be used in the geom_option, only if:
# * All layers should not inherit the same aes
# * Mixing different data source.
# In general, try to keep your data and aes layer in 
# the same ggplot function definition.

# Typical visible aes
# x: X axis pos
# y: Y axis pos
# fill: Fill color
# color: Color of points, outlines of other geoms.
# size: Area or radius of points, thickness of lines
# alpha: Transparency
# linetype: line dash pattern
# labels: text on a plot or axes.
# shape: shape of the point

# Library
library(tidyverse)

# Data ====
mtcars$fcyl <- as.factor(mtcars$cyl)

# Map x to mpg and y to fcyl
ggplot(mtcars, aes(mpg, fcyl)) +
  geom_point()
# Swap mpg and fcyl
ggplot(mtcars, aes(fcyl, mpg)) +
  geom_point()
# Map x to wt, y to mpg and color to fcyl
ggplot(mtcars, aes(wt, mpg, color = fcyl)) +
  geom_point()
ggplot(mtcars, aes(wt, mpg, color = fcyl)) +
  # Set the shape and size of the points
  geom_point(shape = 1, size = 4)

# color aesthetic changes the outline of a geom and 
# the fill aesthetic changes the inside.
mtcars$fam <- as.factor(mtcars$am)

# Map fcyl to fill
ggplot(mtcars, aes(wt, mpg, fill = fcyl)) +
  geom_point(shape = 1, size = 4)+
  # Change point shape; set alpha
  geom_point(shape = 21, size = 4, alpha = 0.6)
# Map color to fam
ggplot(mtcars, aes(wt, mpg, fill = fcyl, color = fam)) +
  geom_point(shape = 21, size = 4, alpha = 0.6)

# Comparing aesthetics ====
# Establish the base layer
plt_mpg_vs_wt <- ggplot(mtcars, aes(wt, mpg))

# Map fcyl to size
plt_mpg_vs_wt +
  geom_point(aes(size = fcyl))

# Map fcyl to shape, not alpha
plt_mpg_vs_wt +
  geom_point(aes(shape = fcyl))

# Use text layer and map fcyl to label
plt_mpg_vs_wt +
  geom_text(aes(label = fcyl))


# Using attributes: Color, shape, size and alpha
# colors in R using hex codes
# A hexadecimal color
my_blue <- "#4ABEFF"

ggplot(mtcars, 
       aes(wt, mpg)) +
  # Set the point color and alpha
  geom_point(color = my_blue, 
             alpha = 0.6)

# Change the color mapping to a fill mapping
ggplot(mtcars, aes(wt,
                   mpg, 
                   fill = fcyl)) +
  # Set point size and shape
  geom_point(color = my_blue, 
             size = 10, 
             shape = 1) # shape 21

# Conflicts with aes ====
## points
ggplot(mtcars, aes(wt, mpg, color = fcyl)) +
  # Add point layer with alpha 0.5
  geom_point(alpha = 0.5)
## text
ggplot(mtcars, aes(wt, mpg, color = fcyl)) +
  # Add text layer with label rownames(mtcars) and color red
  geom_text(label = rownames(mtcars), color = "red")

ggplot(mtcars, 
       aes(wt, 
           mpg,
           color = fcyl)) +
  # Add points layer with shape 24 and color yellow
  geom_point(shape = 24, 
             color = "yellow")

# Using features of the cars 
# 3 aesthetics: qsec vs. mpg, colored by fcyl
ggplot(mtcars, aes(mpg, qsec, 
                   color = fcyl)) +
  geom_point()

# 4 aesthetics: add a mapping of shape to fam
ggplot(mtcars, aes(mpg, qsec, 
                   color = fcyl, 
                   shape = fam)) +
  geom_point()

# 5 aesthetics: add a mapping of size to hp / wt
ggplot(mtcars, aes(mpg, qsec,
                   color = fcyl, 
                   shape = fam, 
                   size = hp / wt)) +
  geom_point()

# Position specifies how ggplot will adjust for overlapping bars
# or points on a single layer
# Positions:
# identity, dodge, stack, fill, jitter, 
# jitterdodge, nudge.

# Position = identity - by default
ggplot(iris,
       aes(x = Sepal.Length,
           y = Sepal.Width,
           color = Species))+
  geom_point()
# Position = jitter
# adding noise
ggplot(iris,
       aes(x = Sepal.Length,
           y = Sepal.Width,
           color = Species))+
  geom_point(position="jitter")


# Scale functions
# scale_x_*(), scale_y_*()
# scale_color_*(), scale_fill_*(), 
# scale_shape_*(), scale_linetype_*()
# scale_size_*()
# use continuous to numerical variable, and discrete to
# to categorical

# Updating aes labels
levels(mtcars$fam) <- c("automatic", "manual")

ggplot(mtcars, aes(fcyl,
                   fill = fam)) +
  geom_bar() +
  # Set the axis labels
  labs(x = "Number of Cylinders",
       y = "Count")

palette <- c(automatic = "#377EB8", 
             manual = "#E41A1C")

ggplot(mtcars, aes(fcyl,
                   fill = fam)) +
  geom_bar() +
  labs(x = "Number of Cylinders",
       y = "Count") +
  # Set the fill color scale
  scale_fill_manual("Transmission", 
                    values = palette)

# Set the position
ggplot(mtcars, 
       aes(fcyl, 
           fill = fam)) +
  geom_bar(position = "dodge") +
  labs(x = "Number of Cylinders", 
       y = "Count") +
  scale_fill_manual("Transmission", 
                    values = palette)

# You can make univariate plots in ggplot2, 
# but you will need to add a fake y axis by 
# mapping y to zero.

# Plot 0 vs. mpg
ggplot(mtcars, 
       aes(mpg, 
                   0)) +
  # Add jitter 
  geom_point(position = "jitter")+
  # Set the y-axis limits
  ylim(c(-2, 2))


