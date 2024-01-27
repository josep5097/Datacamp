# Facets ====
# Straight-forward yet useful
# Based on the concept of small multiples
# Split up a large, complex plot, to produce multiple 
# smaller plots that have the exact same coordinate system

# Other options:
# Split according to row and columns, using two different
# variables, if have many levels in the cat variable, this can 
# wrap the subplots into a defined number of columns

library(tidyverse)
# For splitting the data by one or two cat variables,
# facet_grid() is best

# plot + facet_grid(rows = vars(A), cols = vars(B))

ggplot(mtcars, aes(wt, mpg)) + 
  geom_point() +
  # Facet rows by am
  facet_grid(rows=vars(am))

ggplot(mtcars, aes(wt, mpg)) + 
  geom_point() +
  # Facet columns by cyl
  facet_grid(cols=vars(cyl))

ggplot(mtcars, aes(wt, mpg)) + 
  geom_point() +
  # Facet rows by am and columns by cyl
  facet_grid(rows=vars(am), cols=vars(cyl))


# Many variables 
# facets are another way of encoding factor variables 
# the can be used to reduce the complexity of plots with
# many variables 

# Plot in the viewer, which contains 7 variables 

# Two variables are mapped onto the color aesthetic, using
# hue and lightness.
# Combine fcyl and fam into a single interaction variable.

# Using interaction() ====
mtcars$fcyl_fam <- interaction(mtcars$fcyl, 
                               mtcars$fam, 
                               sep=":")

# See the interaction column
mtcars$fcyl_fam
mtcars

# Color the points by fcyl_fam
ggplot(mtcars, aes(x = wt, 
                   y = mpg,
                   color = fcyl_fam)) +
  geom_point() +
  # Use a paired color palette
  scale_color_brewer(palette = "Paired")

# Update the plot to map disp to size
ggplot(mtcars, aes(x = wt, 
                   y = mpg,
                   color = fcyl_fam, 
                   size = disp)) +
  geom_point() +
  scale_color_brewer(palette = "Paired")

# Update the plot
ggplot(mtcars, aes(x = wt,
                   y = mpg, 
                   color = fcyl_fam, 
                   size = disp)) +
  geom_point() +
  scale_color_brewer(palette = "Paired") +
  # Grid facet on gear and vs
  facet_grid(rows = vars(gear), cols = vars(vs))


# Modern notation	                              |Formula notation
# ----------------------------------------------------------------
# facet_grid(rows = vars(A))	                  |facet_grid(A ~ .)
# facet_grid(cols = vars(B))              	    |facet_grid(. ~ B)
# facet_grid(rows = vars(A), cols = vars(B))	  |facet_grid(A ~ B)

ggplot(mtcars, aes(wt, mpg)) + 
  geom_point() +
  # Facet rows by am using formula notation
  facet_grid(am ~ .)

ggplot(mtcars, aes(wt, mpg)) + 
  geom_point() +
  # Facet columns by cyl using formula notation
  facet_grid(. ~ cyl)

# Facet Labels and order ====
# To make sure that you can read the labels we will periodically zoom in

# To typical problems with facets
#   Poorly labeled
#   Wrong or inappropiate order

# Solutions ====
# Easy: Add labels in ggplot
# Better: Relabel and rearrange factor variables in your DF

# forcats package contains some really useful functions
# fct_recode()
# fct_relevel()


# Labeling facets
# 
# If your factor levels are not clear, your facet labels may be confusing. 
# You can assign proper labels in your original data before plotting, or 
# you can use the labeller argument in the facet layer.

# The defult value is>
#   label_value> Default, displays only the value
# Alternatives>
#   label_both> Displays both, value and variable name
#   label_context> Displays only the values or both the values and variables
#   depending on whether multiple factors are faceted.

# Plot wt by mpg
ggplot(mtcars, 
       aes(wt,
           mpg)) +
  geom_point() +
  # The default is label_value
  facet_grid(cols = vars(cyl))

# Plot wt by mpg
ggplot(mtcars, 
       aes(wt, 
           mpg)) +
  geom_point() +
  # Displaying both the values and the variables
  facet_grid(cols = vars(cyl), 
             labeller = label_both)

# Plot wt by mpg
ggplot(mtcars, 
       aes(wt, 
           mpg)) +
  geom_point() +
  # Label context
  facet_grid(cols = vars(cyl), 
             labeller = label_context)

# Plot wt by mpg
ggplot(mtcars, 
       aes(wt, 
           mpg)) +
  geom_point() +
  # Two variables
  facet_grid(cols = vars(vs, 
                         cyl), 
             labeller = label_context)


# If you want to change the order of your facets, it’s best to properly 
# define your factor variables before plotting.
# 
# Let’s see this in action with the mtcars transmission variable am. 
# In this case, 0 = “automatic” and 1 = “manual”.

# Make factor, set proper labels explictly
mtcars$fam <- factor(mtcars$am, 
                     labels = c(`0` = "automatic",
                                `1` = "manual"))

# Default order is alphabetical
ggplot(mtcars, aes(wt,
                   mpg)) +
  geom_point() +
  facet_grid(cols = vars(fam))


# Make factor, set proper labels explictly, and
# manually set the label order
mtcars$fam <- factor(mtcars$am,
                     levels = c(1, 0),
                     labels = c("manual", 
                                "automatic"))

# View again
ggplot(mtcars, aes(wt,
                   mpg)) +
  geom_point() +
  facet_grid(cols = vars(fam))

# Facet plotting spaces ====
# The major advantage of facets is that every plot is drawn
# on the same plotting space - Comparable between graphs

# Nonetheless, you may encounter situations in which you actually do not 
# want this

#   Continuous vars> Wildly different ranges
#   Categorical>     Different groups

# We can establish in facet_grid(scales = "free_x")
# We cant use a fixed coordinate space and free axes on the same time
# Once we remove the fixed coordinate space, then we can adjust the x axis
# for each column

# We can have a "free_y" 

# Or both using> scales = "free"

# For spaces of graphs> space = "free_*"  x or y

# For cat vars we can rearrange the DF according to the weight and
# then redefine the factor levels according to the order in which they appear.

ggplot(mtcars, aes(wt, mpg)) +
  geom_point() + 
  # Facet columns by cyl 
  facet_grid(cols = vars(cyl))

ggplot(mtcars, aes(wt, mpg)) +
  geom_point() + 
  # Update the faceting to free the x-axis scales
  facet_grid(cols = vars(cyl),
             scales = "free_x")

ggplot(mtcars, aes(wt, mpg)) +
  geom_point() + 
  # Swap cols for rows; free the y-axis scales
  facet_grid(rows = vars(cyl), scales = "free_y")

# Cat variables
ggplot(mtcars, aes(x = mpg,
                   y = car, 
                   color = fam)) +
  geom_point() +
  # Facet rows by gear
  facet_grid(rows=vars(gear))


ggplot(mtcars, aes(x = mpg, 
                   y = car, 
                   color = fam)) +
  geom_point() +
  # Free the y scales and space
  facet_grid(rows = vars(gear),              
             scales = "free_y",
             space = "free_y")


# Facet wrap & margins
# using facet_wrap()
# Use cases:
# 1. When you want both x, and y axes to be free on every individual plot

# 2. When your cat variable has many groups(levels)
library(car)

ggplot(Vocab, aes(x = education,
                  y = vocabulary)) +
  stat_smooth(method = "lm", 
              se = FALSE) +
  # Create facets, wrapping by year, using vars()
  facet_wrap(vars(year))

ggplot(Vocab, aes(x = education, 
                  y = vocabulary)) +
  stat_smooth(method = "lm", 
              se = FALSE) +
  # Create facets, wrapping by year, using a formula
  facet_wrap(~ year)


ggplot(Vocab, 
       aes(x = education,
           y = vocabulary)) +
  stat_smooth(method = "lm",
              se = FALSE) +
  # Update the facet layout, using 11 columns
  facet_wrap(~ year,
             ncol = 11)

library(forcats)
# Make factor, set proper labels explictly
mtcars$fam <- factor(mtcars$am,
                     labels = c('0' = "automatic",
                                '1' = "manual"))
mtcars$fvs <- factor(mtcars$vs,
                     labels = c('0' = "V-shaped",
                                '1' = "straight"))

ggplot(mtcars, aes(x = wt, y = mpg)) + 
  geom_point() +
  # Facet rows by fvs and cols by fam
  facet_grid(rows = vars(fvs, fam), 
             col = vars(gear))

ggplot(mtcars, aes(x = wt, 
                   y = mpg)) + 
  geom_point() +
  # Update the facets to add margins
  facet_grid(rows = vars(fvs, fam),
             cols = vars(gear), 
             margins = TRUE)

ggplot(mtcars, aes(x = wt, 
                   y = mpg)) + 
  geom_point() +
  # Update the facets to only show margins on gear and fvs
  facet_grid(rows = vars(fvs, 
                         fam), 
             cols = vars(gear), 
             margins = c("gear", 
                         "fvs"))