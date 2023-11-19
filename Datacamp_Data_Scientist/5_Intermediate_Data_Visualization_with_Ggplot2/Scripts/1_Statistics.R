# Statistics Layer ====
# Two categories of functions_
#   Called from within a geom
#   Called independently
#     stats_

# Library
library(tidyverse)

p <- ggplot(iris, 
            aes(x = Sepal.Width))

p + geom_histogram()
p + geom_bar()


p <- ggplot(mtcars,
            aes(x = factor(cyl),
                fill = factor(am)))
p + geom_bar()
p + stat_count()


ggplot(iris,
       aes(x = Sepal.Length,
           y = Sepal.Width,
           color = Species))+
  geom_point()+
  geom_smooth()

ggplot(iris,
       aes(x = Sepal.Length,
           y = Sepal.Width,
           color = Species))+
  geom_point()+
  geom_smooth(se=F)

ggplot(iris,
       aes(x = Sepal.Length,
           y = Sepal.Width,
           color = Species))+
  geom_point()+
  geom_smooth(method = "lm", #glm, rlm and gam
              se = F)

# Prediction
# The error increases the futher away from our daata set
# we attempt to define an estimation.
ggplot(iris,
       aes(x = Sepal.Length,
           y = Sepal.Width,
           color = Species))+
  geom_point()+
  geom_smooth(method = "lm",
              fullrange = T)


# Other stat_ functions
# stat_           geom_
# stat_boxplot()  geom_boxplot()
# stat_bindot()   geom_dotplot()
# stat_bin2d()    geom_bind2d()
# stat_binhex()   geom_hex()
# stat_contour()  geom_contour()
# stat_quantile() geom_quantile()
# stat_sum()      geom_count()


# View the structure of mtcars
str(mtcars)

# Using mtcars, draw a scatter plot of mpg vs. wt
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point()


# Amend the plot to add a smooth layer
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  geom_smooth()

# Amend the plot. Use lin. reg. smoothing; turn off std err ribbon
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)


# Amend the plot. Swap geom_smooth() for stat_smooth().
ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  stat_smooth(method = "lm", se = FALSE)

## Grouping Variables ====
# For this we’ll encounter the invisible group aesthetic.
mtcars$fcyl <- as.factor(mtcars$cyl)

# Using mtcars, plot mpg vs. wt, colored by fcyl
ggplot(mtcars, aes(x = wt,
                   y = mpg,
                   color = fcyl)) +
  # Add a point layer
  geom_point() +
  # Add a smooth lin reg stat, no ribbon
  stat_smooth(method = "lm", se = FALSE)

# Amend the plot to add another smooth layer with dummy grouping
ggplot(mtcars, aes(x = wt, y = mpg, color = fcyl)) +
  geom_point() +
  stat_smooth(method = "lm", 
              se = FALSE) +
  stat_smooth(aes(group = 1), 
              method = "lm", 
              se = FALSE)

# Here, we use a dummy variable to calculate the smoothing model for all values.


## Modifying stat_smooth ====

# In the previous exercise we used se = FALSE in stat_smooth() to remove the 95% 
# Confidence Interval. Here we’ll consider another argument, span, used in LOESS smoothing


ggplot(mtcars, aes(x = wt, 
                   y = mpg)) +
  geom_point() +
  # Add 3 smooth LOESS stats, varying span & color
  stat_smooth(color = "red", span = 0.9, se = FALSE) +
  stat_smooth(color = "green", span = 0.6, se = FALSE) +
  stat_smooth(color = "blue", span = 0.3, se = FALSE)

# Amend the plot to color by fcyl
ggplot(mtcars, aes(x = wt, 
                   y = mpg)) +
  geom_point() +
  # Add a smooth LOESS stat, no ribbon
  stat_smooth(se = FALSE) +
  # Add a smooth lin. reg. stat, no ribbon
  stat_smooth(method = "lm", 
              se = FALSE)

# Amend the plot
ggplot(mtcars, aes(x = wt,
                   y = mpg, 
                   color = fcyl)) +
  geom_point() +
  # Map color to dummy variable "All"
  stat_smooth(aes(color = "All"), se = FALSE) +
  stat_smooth(method = "lm", se = FALSE)

# The default span for LOESS is 0.9
# A lower span will result in a better fit with more detail.
# take care of overfitting

# We’ll take a look at the standard error ribbons, which show the 95% 
# confidence interval of smoothing models.

# # Using Vocab, plot vocabulary vs. education, colored by year group
# ggplot(Vocab, aes(x = education, y = vocabulary, color = year_group)) +
#   # Add jittered points with transparency 0.25
#   geom_jitter(alpha = 0.25) +
#   # Add a smooth lin. reg. line (with ribbon)
#   stat_smooth(method = "lm")


# standard error ribbons match the lines, and the lines 
# have more emphasis
# Amend the plot
ggplot(Vocab, aes(x = education,
                  y = vocabulary, 
                  color = year_group)) +
  geom_jitter(alpha = 0.25) +
  # Map the fill color to year_group, set the line size to 2
  stat_smooth(aes(fill = year_group),
              method = "lm", 
              size = 2)

# Stats: Sum and quantile ====
# * geom_count()
# * geom_quantile()


# Case of Over-plotting           Solutions                                     Here
# Large DS                        Alpha-blending, hollow circles, point size    
# Aligned values on a single axis As above, plus change position
# Low-precision data              Position: jitter                              geom_count()
# Integer data                    Position: jitter                              geom_count()

p <- ggplot(iris, aes(Sepal.Length,
                      Sepal.Width))
p+geom_point()

# jittering may give a wrong impressions
p+geom_jitter(alpha = 0.5,
              width = 0.1,
              height = 0.1)

# To avoid this problem, we can use another variant of geom_point()
p+geom_count()
# geom_count() counts the number of observations at each location
# and then maps the count onto size as the point area

# All these geoms are associated with stats functions that can be called
# directly:
# geom_         stat_
# geom_count()  stat_sum()

p + geom_count()
p + stat_sum()

# We can still encounter over-plotting if the points are colored
# according to another variable
ggplot(iris, aes(Sepal.Length,
                 Sepal.Width,
                 color = Species))+
  geom_count(alpha = 0.4)

# Model quantiles, which are robust, as oppsed to LM,
# which model the non-robust mean

# We can choose any quantile we're interested in, such as:
# the median, which is the 2nd quartile

library(AER)
data(Journals)

p <- ggplot(Journals,
            aes(log(price/citations),
                log(subs)))+
  geom_point(alpha=0.5)

p

# We can use geom_quantile to model the 5th and the 95th
# percentile as well as the median, the 50th percentile
p + geom_quantile(quantiles = c(0.05,0.50,0.95))

# geom_           stat_
# geom_count()    stat_sum()
# geom_quantile() stat_quantile()


# ggplot(Vocab, aes(x = education, y = vocabulary)) +
#   # Replace this with a sum stat
#   stat_sum(alpha = 0.25)
#   # Add a size scale, from 1 to 10
#   scale_size(range = c(1, 10))

# Inside stat_sum(), set size to ..prop.., so cicle size represents
# the proportion of the whole dataset.

# # Amend the stat to use proportion sizes
# ggplot(Vocab, aes(x = education, y = vocabulary)) +
#   stat_sum(aes(size = ..prop..))
# 
# # Amend the plot to group by education
# ggplot(Vocab, aes(x = education, y = vocabulary, group = education)) +
#   stat_sum(aes(size = ..prop..))


# Stats outside geoms ====
# Typical way to summarize this data would be take the mean
# and standard deviation or the 95% conf interval

set.seed(123)
xx <- rnorm(100)
mean(xx)

mean(xx)+(sd(xx)*c(-1,1))


# Using Hmisc
library(Hmisc)
smean.sdl(xx, mult = 1)

# Using ggplot
mean_sdl(xx, mult=1)


ggplot(iris, aes(x = Species,
                 y = Sepal.Length))+
  stat_summary(fun.data = mean_sdl,
               fun.args = list(mult = 1))

# We can use geom_pointrange()
ggplot(iris, aes(x = Species,
                 y = Sepal.Length))+
  stat_summary(fun.y = mean,
               geom = "point")+
  stat_summary(fun.data = mean_sdl,
               fun.args = list(mult = 1),
               geom = "errorbar",
               width = 0.1)

# 95% conf interval
ERR <- qt(0.975, length(xx)-1)*sd(xx)/sqrt(length(xx))
mean(xx)

mean(xx)+(ERR*c(-1,1))

mean_cl_normal(xx)

## Preparations ====
mtcars$fam <- as.factor(mtcars$am)

# Define position objects
# 1. Jitter with width 0.2
posn_j <- position_jitter(width = 0.2)

# 2. Dodge with width 0.1
posn_d <- position_dodge(width = 0.1)

# 3. Jitter-dodge with jitter.width 0.2 and dodge.width 0.1
posn_jd <- position_jitterdodge(jitter.width = 0.2,
                                dodge.width = 0.1)

# Create the plot base: wt vs. fcyl, colored by fam
p_wt_vs_fcyl_by_fam <- ggplot(mtcars,
                              aes(x = fcyl, 
                                  y = wt,
                                  color = fam))

# Add a point layer
p_wt_vs_fcyl_by_fam +
  geom_point()

# Add jittering only
p_wt_vs_fcyl_by_fam_jit <- p_wt_vs_fcyl_by_fam +
  geom_point(position=posn_j)
# Add dodging only
p_wt_vs_fcyl_by_fam +
  geom_point(position=posn_d)
# Add jittering and dodging
p_wt_vs_fcyl_by_fam +
  geom_point(position=posn_jd)


p_wt_vs_fcyl_by_fam_jit +
  # Add a summary stat of std deviation limits
  stat_summary(fun.data = mean_sdl, 
               fun.args = list(mult = 1),
               position = posn_d)

p_wt_vs_fcyl_by_fam_jit +
  # Change the geom to be an errorbar
  stat_summary(fun.data = mean_sdl, 
               fun.args = list(mult = 1), 
               position = posn_d,
               geom="errorbar")

p_wt_vs_fcyl_by_fam_jit +
  # Add a summary stat of normal confidence limits
  stat_summary(fun.data = mean_cl_normal,
               position = posn_d)


