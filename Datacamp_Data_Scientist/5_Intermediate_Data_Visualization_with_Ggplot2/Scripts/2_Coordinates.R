# The Coordinates Layer ====
# The coord layer controls the dimensions of your plot
# Is composed of functions named cood_: 
# coord_cartesian(): controls the x-y Cartesian plane
# We can use coord_cartesian to zoom in on a specific part 
# of a plot
library(tidyverse)

iris.smooth <- ggplot(iris,
                      aes(x = Sepal.Length,
                          y = Sepal.Width,
                          color = Species)
                      )+
  geom_point(alpha = 0.7)+
  geom_smooth()
iris.smooth

# When we zoom in with scale_X_continuous()
iris.smooth +
  scale_x_continuous(limits = c(4.5, 5.5))
# We obtain some important warning messages

# using xlim()
iris.smooth +
  xlim(c(4.5, 5.5))
# The same effect
# We lose information 

iris.smooth +
  coord_cartesian(xlim = c(4.5, 5.5))
# We have not filtered the data set.


# Aspect Ratio ====
# Referring to the height-to-width aspect ratio
# Is important whe it changes our perception or interpretation
# of the data

library(zoo)

sunspots.m <- data.frame(
  year = index(sunspot.month),
  value = reshape2::melt(sunspot.month)$value
)

ggplot(sunspots.m,
       aes(x = year,
           y = value))+
  geom_line()+
  coord_fixed() # default 1:1 aspect

# Reducing the aspect ratio to something very low
ggplot(sunspots.m,
       aes(x = year,
           y = value))+
  geom_line()+
  coord_fixed(0.0555)


ggplot(mtcars, aes(x = wt,
                   y = hp, 
                   color = fam)) +
  geom_point() +
  geom_smooth() 


ggplot(mtcars, aes(x = wt, 
                   y = hp, 
                   color = fam)) +
  geom_point() +
  geom_smooth() +
  # Add a continuous x scale from 3 to 6
  scale_x_continuous(limits=c(3, 6))


ggplot(mtcars, aes(x = wt,
                   y = hp, 
                   color = fam)) +
  geom_point() +
  geom_smooth() +
  # Add Cartesian coordinates with x limits from 3 to 6
  coord_cartesian(xlim = c(3, 6))


ggplot(iris, 
       aes(x = Sepal.Length, 
           y = Sepal.Width, 
           color = Species)) +
  geom_jitter() +
  geom_smooth(method = "lm", se = FALSE) +
  # Fix the coordinate ratio
  coord_fixed()


# Expand and clip ====
# expand sets a buffer margin around the plot, so data and axes don’t overlap. Setting expand to 0 draws the axes to the limits of the data.
# clip decides whether plot elements that would lie outside the plot panel 
# are displayed or ignored (“clipped”).
# When done properly this can make a great 
# visual effect!
ggplot(mtcars, 
       aes(wt, mpg)) +
  geom_point(size = 2) +
  theme_classic() +
  # Add Cartesian coordinates with zero expansion
  coord_cartesian(expand = 0)

# Setting expand to 0 caused points at the edge of the plot
# panel to be cut off.
# Setting the clip arg to "off" prevent this.
# 
ggplot(mtcars, aes(wt, mpg)) +
  geom_point(size = 2) +
  # Turn clipping off
  coord_cartesian(expand = 0, clip = "off") +
  theme_classic() +#
  # Remove axis lines
  theme(axis.line = element_blank())


# Coordinates vs Scales ====
ggplot(msleep,
       aes(bodywt,
           y = 1))+
  geom_jitter()+
  scale_x_continuous(limits = c(0,7000),
                     breaks = seq(0, 7000, 1000))

# we can add logtick annotation
ggplot(msleep,
       aes(log10(bodywt),
           y = 1))+
  geom_jitter()+
  scale_x_continuous(limits = c(-3,4),
                     breaks = seq(-3:4))+
  annotation_logticks(sides = "b")


# using scale_*_log10()
ggplot(msleep,
       aes(bodywt,
           y = 1))+
  geom_jitter()+
  scale_x_log10(limits = c(1e-03,1e+4))


ggplot(msleep,
       aes(bodywt,
           y = 1))+
  geom_jitter()+
  coord_trans(x="log10")


# Produce a scatter plot of brainwt vs. bodywt
ggplot(msleep, 
       aes(x=bodywt, 
           y=brainwt)) +
  geom_point() +
  ggtitle("Raw Values")

# Add scale_*_*() functions
ggplot(msleep,
       aes(bodywt, 
           brainwt)) +
  geom_point() +
  scale_x_log10() +
  scale_y_log10() +
  ggtitle("Scale_ functions")


# Perform a log10 coordinate system transformation
ggplot(msleep, 
       aes(bodywt, 
           brainwt)) +
  geom_point() +
  coord_trans(x = "log10", 
              y = "log10")

# Plot with transformed coordinates
ggplot(msleep, aes(bodywt, brainwt)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  # Add a log10 coordinate transformation for x and y axes
  coord_trans(x = "log10", y = "log10")

# Adding stats to transformed scales ====
# Plot with a scale_*_*() function:
ggplot(msleep, aes(bodywt, brainwt)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  # Add a log10 x scale
  scale_x_log10() +
  # Add a log10 y scale
  scale_y_log10() +
  ggtitle("Scale functions")

# Plot with transformed coordinates
ggplot(msleep, aes(bodywt, brainwt)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  # Add a log10 coordinate transformation for x and y axes
  coord_trans(x = "log10", y = "log10")
# The smooth trend line is calculated after scale transformations,
# so the second plot does not make sense =.


# Double and flipped axes ====
# Double x or y axes> Add raw and transformed values
# Flipped axes> Change direction of dependencies, change geometry orientation

ggplot(iris, 
       aes(x = Sepal.Length,
           y = Sepal.Width,
           color = Species))+
  geom_point()+
  geom_smooth(method = "lm",
              se = F)

ggplot(iris, 
       aes(x = Sepal.Length,
           y = Sepal.Width,
           color = Species))+
  geom_point()+
  geom_smooth(method = "lm",
              se = F)+
  coord_flip()


# Useful double axes ====
airquality$Date <- as.Date(paste('1973',
                                 airquality$Month,
                                 airquality$Day),
                           '%Y %m %d')

# Using airquality, plot Temp vs. Date
ggplot(airquality, 
       aes(x=Date,
           y=Temp)) +
  # Add a line layer
  geom_line() +
  labs(x = "Date (1973)", 
       y = "Fahrenheit")


# Define breaks (Fahrenheit)
y_breaks <- c(59, 68, 77, 86, 95, 104)

# Convert y_breaks from Fahrenheit to Celsius
y_labels <- (y_breaks - 32) * 5 / 9

# Create a secondary x-axis
secondary_y_axis <- sec_axis(
  # Use identity transformation
  trans = identity,
  name = "Celsius",
  # Define breaks and labels as above
  breaks = y_breaks,
  labels = y_labels
)

# Examine the object
secondary_y_axis

# Update the plot
ggplot(airquality, 
       aes(Date, 
           Temp)) +
  geom_line() +
  # Add the secondary y-axis 
  scale_y_continuous(sec.axis = secondary_y_axis) +
  labs(x = "Date (1973)",
       y = "Fahrenheit")


# Flipping Axes ====
# Plot fcyl bars, filled by fam
ggplot(mtcars, aes(fcyl, fill = fam)) +
  # Place bars side by side
  geom_bar(position = "dodge")

ggplot(mtcars, aes(fcyl, fill = fam)) +
  geom_bar(position = "dodge") +
  # Flip the x and y coordinates
  coord_flip()

# Partially overlapping bars are popular with "infoxiz"
# in magazines.
ggplot(mtcars, aes(fcyl, 
                   fill = fam)) +
  # Set a dodge width of 0.5 for partially overlapping bars
  geom_bar(position = position_dodge(width=0.5)) +
  coord_flip()


mtcars$car <- row.names(mtcars)

# Plot of wt vs. car
ggplot(mtcars, aes(x=car, y=wt)) +
  # Add a point layer
  geom_point() +
  labs(x = "car", y = "weight")

# Flip the axes to set car to the y axis
ggplot(mtcars, aes(car, wt)) +
  geom_point() +
  labs(x = "car", y = "weight") +
  coord_flip()


# Pie Charts ====
# The coord_polar() function converts a planar x-y Cartesian 
# plot to polar coordinates. This can be useful if you are
# producing pie charts.

# Pie charts are not really better than stacked bar charts

ggplot(mtcars, aes(x = 1, 
                   fill = fcyl)) +
  geom_bar()

ggplot(mtcars, aes(x = 1, 
                   fill = fcyl)) +
  geom_bar() +
  # Add a polar coordinate system
  coord_polar(theta="y")


# Reducing the width of the bar and make it a ring plot
ggplot(mtcars, aes(x = 1, fill = fcyl)) +
  # Reduce the bar width to 0.1
  geom_bar(width=0.1) +
  coord_polar(theta = "y") +
  # Add a continuous x scale from 0.5 to 1.5
  scale_x_continuous(limits=c(0.5, 
                              1.5))


library(openair)
library(forcats)

rose_breaks <- c(0,
                 360/32, 
                 (1/32 + 
                    (1:15 / 16)) * 360, 
                 360)
rose_labs <- c(
  "N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N")
ws_labs <- c("0 - 2", "2 - 4", "4 - 6", "6 - 8", "8 - 10", "10 - 12", "12 - 14")
wind <- selectByDate(mydata[c("date", "ws", "wd")], start = "2003-01-01", end = "2003-12-31")
wind$ws <- as.factor(cut(wind$ws, breaks = c(0,2,4,6,8,10,12,14), labels = ws_labs))
wind$wd <- as.factor(cut(wind$wd, breaks = rose_breaks, labels = rose_labs))
wind <- wind[complete.cases(wind),]

# Using wind, plot wd filled by ws
ggplot(wind, aes(x=wd, fill=ws)) +
  # Add a bar layer with width 1
  geom_bar(width=1)


# Convert to polar coordinates:
ggplot(wind, aes(wd, fill = ws)) +
  geom_bar(width = 1) +
  coord_polar()

# Convert to polar coordinates:
ggplot(wind, aes(wd, fill = ws)) +
  geom_bar(width = 1) +
  coord_polar(start = -pi/16)
