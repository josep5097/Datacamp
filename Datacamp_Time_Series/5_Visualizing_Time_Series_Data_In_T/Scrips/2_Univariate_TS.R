library(readr)
library(dplyr)
library(xts)
library(PerformanceAnalytics)
library(TTR)

data <- read_table2("Data/dataset_2_1.csv")

data <- rename(data, index = `"Index"`, 
               apple = `"Apple"`)
data$index <- as.Date(data$index)
data <- as.xts(data [, -1], order.by = data$index)

# Plot Apple's stock price 
plot(data$apple, main = "Apple stock price")

# Create a time series called rtn
rtn <- ROC(data$apple)

# Plot Apple daily price and daily returns 
par(mfrow = c(1, 2))
plot(data$apple, main = "Apple stock price")
plot(rtn)

par(mfrow = c(1, 1))
# Create a histogram of Apple stock returns
hist(rtn,
     main = "Apple stock return distribution",
     probability = TRUE)

# Add a density line
lines(density(rtn[-1,]))

# Redraw a thicker, red density line
lines(density(rtn[-1,]), lwd = 2, col = "red")


rtn <- as.data.frame(rtn[-1, ])
# Draw box and whisker plot for the Apple returns
boxplot(rtn,
        horizontal = TRUE)

# Draw a box and whisker plot of a normal distribution
boxplot(rnorm(1000),
        horizontal = TRUE)

# Redraw both plots on the same graphical window
par(mfrow = c(2, 1))
boxplot(rtn,
        horizontal = TRUE)
boxplot(rnorm(1000),
        horizontal = TRUE)

par(mfrow = c(1, 1))
# Draw autocorrelation plot
acf(rtn, main = "Apple return autocorrelation")

# Redraw with a maximum lag of 10
acf(rtn, main = "Apple return autocorrelation", lag.max = 10)

# Create q-q plot
qqnorm(rtn[[1]],
       main = "Apple return QQ-plot")

# Add a red line showing normality
qqline(rtn[[1]], col = "red")



rtn <- rtn[[1]]
# Draw histogram and add red density line
hist(rtn,
     probability = TRUE)
lines(density(rtn),
      col = "red")

# Draw box and whisker plot
boxplot(rtn)

# Draw autocorrelogram
acf(rtn)

# Draw q-q plot and add a red line for normality
qqnorm(rtn)
qqline(rtn, col = "red")



# Set up 2x2 graphical window
par(mfrow = c(2, 2))

# Recreate all four plots
hist(rtn, probability = TRUE)
lines(density(rtn), col = "red")

boxplot(rtn)

acf(rtn)

qqnorm(rtn)
qqline(rtn, col = "red")
