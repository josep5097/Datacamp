
# Library ====
library(readxl)
library(ggfortify)
library(forecast) # has the three series: gold, woolyrnq, and gas
library(ggplot2)
library(fpp2) # datasets: a10, ausbeer

# Data ====
# Read the data from Excel into R
mydata <- read_excel("Data/exercise1.xlsx")

# Look at the first few lines of mydata
head(mydata)

# Create a ts object called myts
myts <- ts(mydata[, 2:4], start = c(1981, 1), frequency = 4)

# You can use the autoplot() function to produce a time plot 
# of the data with or without facets.

# Plot the data with facetting
autoplot(myts, facets = TRUE)

# Plot the data without facetting
autoplot(myts, facets = FALSE)

# Plot the three series
autoplot(gold)
autoplot(woolyrnq)
autoplot(gas)

# Find the outlier in the gold series
goldoutlier <- which.max(gold)

# Look at the seasonal frequencies of the three series
frequency(gold)
frequency(woolyrnq)
frequency(gas)


# Seasonal plots ====
# There are other useful ways of plotting data to emphasize seasonal
# patterns and show changes.
#   Seasonal plot: the data are plotted agains the individual "seasons"
#                  can be created using ggseasonplot()
#   A variant is using polar coordinates, where time axis is circular.
#                   adding polar = T, in arguments
#   subseries plot: comprises mini time plots for each season.

# Create plots of the a10 data
autoplot(a10)
ggseasonplot(a10)

# Produce a polar coordinate season plot for the a10 data
ggseasonplot(a10, polar = TRUE)

# Restrict the ausbeer data to start in 1992
beer <- window(ausbeer, start = 1992)

# Make plots of the beer data
autoplot(beer)
ggsubseriesplot(beer)


# Trends, seasonality, and cyclicity ====
# Trend: A pattern exists involving a long-term increase or decrease in the data
# Seasonality: A periodic pattern according to the calendar.
# Cyclic: A pattern exists where the data exhibits rises and falls, are not fixed period.

# Seasonal pattern constan length vs cyclic pattern variable length
# Average length of cycle longer than lenght of seasonal pattern
# Magnitude of cycle more variable than magnitude of seasonal pattern.

# The timing of peaks and troughs is predictable with seasonal data,
# but unpredictable in the long term with cyclic data.


# Autocorrelation of non-seasonal time series ====
# Another way to look at time series data is to plot watch wach obs
# agains another obs -- Using gglagplot()
# plot: Yt vs Yt-1

# The correlations associated with the lag plots form: ACF
# ggAcf()

# Create an autoplot of the oil data
autoplot(oil)

# Create a lag plot of the oil data
gglagplot(oil)

# Create an ACF plot of the oil data
ggAcf(oil)

# Autocorrelation of seasonal and cyclic TS
# When data are either seasonal or cyclic, the ACF will peak
# around the seasonal lag or at the average cycle length.

# Plots of annual sunspot numbers
autoplot(sunspot.year)
ggAcf(sunspot.year)

# Save the lag corresponding to maximum autocorrelation
maxlag_sunspot <- 1

# Plot the traffic on the Hyndsight blog
autoplot(hyndsight)
ggAcf(hyndsight)

# Save the lag corresponding to maximum autocorrelation
maxlag_hyndsight <- 7

# White noise ====
# Ljung-Box test:
# Considers the first h autocorrelation values together.
# A significant test (small p-value) indicates the data are 
# probably not white noise
Box.test(pigs, lag = 24, fitdf = 0, type = "Lj")
# This is not a white noise series

# Plot the original series
autoplot(goog)

# Plot the differenced series
autoplot(diff(goog))

# ACF of the differenced series
ggAcf(diff(goog))

# Ljung-Box test of the differenced series
Box.test(diff(goog), lag = 10, type = "Ljung")

