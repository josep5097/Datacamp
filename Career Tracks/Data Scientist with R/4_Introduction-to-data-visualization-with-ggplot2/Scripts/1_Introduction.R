# Load the ggplot2 package
library(ggplot2)

# Explore the mtcars data frame with str()
str(mtcars)

# Execute the following command
ggplot(mtcars, aes(cyl, mpg)) +
  geom_point()

# Cyl is treated as factor
ggplot(mtcars, aes(factor(cyl), mpg)) +
  geom_point()
# Stellar scatterplotting!. This time the x-axis does
# not contain variables like 5 or 7, only the values
# that are present in the dataset!


# Jargon for each element ====
# The 3 essential grammatical elements
# Data, Aesthetics and Geometries

# Data ---- {Variables of interest}
# aes {x-axis, y-axis, colour, fill, size, alpha
#      line width, labels, shape, line type}
# Geo {point, line, histogram, boxplot}
# Theme / non-data link
#statistics: {bining smoothing descriptive inferential}
# Coordinates: {cartesian, fixed, polar, limits}
# Facets: {colums rows}

# Mapping data columns to aesthetics ====
# Edit to add a color aesthetic mapped to disp
ggplot(mtcars, aes(wt, mpg, color = disp)) +
  geom_point()

# Change the color aesthetic to a size aesthetic
ggplot(mtcars, aes(wt, mpg, size = disp)) +
  geom_point()

# Adding Geometries ====
# Explore the diamonds data frame with str()
str(diamonds)

# Add geom_point() with +
ggplot(diamonds, aes(carat, price)) +
  geom_point()

# Add geom_smooth() with +
ggplot(diamonds, aes(carat, price)) +
  geom_point() +
  geom_smooth()


# Changing one geom or every geom ====
# Map the color aesthetic to clarity
ggplot(diamonds, aes(carat, price, color = clarity)) +
  geom_point() +
  geom_smooth()

# Make the points 40% opaque
ggplot(diamonds, aes(carat,
                     price, 
                     color = clarity)) +
  geom_point(alpha = 0.4) +
  geom_smooth()

