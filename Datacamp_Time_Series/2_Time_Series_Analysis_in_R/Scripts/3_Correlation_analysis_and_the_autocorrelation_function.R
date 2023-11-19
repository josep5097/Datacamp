# Scatterplots ====
# Log returns, also called continuously compounded returns, are also commonly
# used in financial time series analysis. They are the log of gross returns, 
# or equivalently, the changes (or first differences) in the logarithm of prices.
# 
# The change in appearance between daily prices and daily returns is typically 
# substantial, while the difference between daily returns and log returns is 
# usually small. As you’ll see later, one advantage of using log returns is that 
# calculating multi-period returns from individual periods is greatly simplified

eu_stocks <- EuStockMarkets

# Plot eu_stocks
plot(eu_stocks)

# Use this code to convert prices to returns
returns <- eu_stocks[-1,] / eu_stocks[-1860,] - 1

# Convert returns to ts
returns <- ts(returns, start = c(1991, 130), frequency = 260)

# Plot returns
plot(returns)

# Use this code to convert prices to log returns
logreturns <- diff(log(eu_stocks))

# Plot logreturns
plot(logreturns)

# Daily net return and daily log returns are two valuable
# metrics for financial data

# Returns over one day are typically small, and their average is 
# close to zero. At the same time, their variances and standard 
# deviations can be relatively large. Over the course of a few years, 
# several very large returns (in magnitude) are typically observed.

eu_percentreturns <- returns * 100

# Generate means from eu_percentreturns
colMeans(eu_percentreturns) 

# Use apply to calculate sample variance from eu_percentreturns
apply(eu_percentreturns, 
      MARGIN = 2, 
      FUN = var)

# Use apply to calculate standard deviation from eu_percentreturns
apply(eu_percentreturns, 
      MARGIN = 2, 
      FUN = sd)

# Display a histogram of percent returns for each index
par(mfrow = c(2,2))
apply(eu_percentreturns, 
      MARGIN = 2, FUN = hist, 
      main = "", 
      xlab = "Percentage Return")

# Display normal quantile plots of percent returns for each index
par(mfrow = c(2,2))
apply(eu_percentreturns, 
      MARGIN = 2,
      FUN = qqnorm, 
      main = "")
qqline(eu_percentreturns)

# Plotting pairs of data 
# It is also useful to examine the bivariate relationship 
# between pairs of time series.

# The plot(a, b) function will produce a scatterplot when two 
# time series names a and b are given as input.
# 
# To simultaneously make scatterplots for all pairs of several 
# assets the pairs() function can be applied to produce a scatterplot matrix. 

par(mfrow = c(1,1))
# Make a scatterplot of DAX and FTSE
plot(eu_stocks[,'DAX'], eu_stocks[,'FTSE'])

# Make a scatterplot matrix of eu_stocks
pairs(eu_stocks)

# Convert eu_stocks to log returns
logreturns <- diff(log(eu_stocks))

# Plot logreturns
plot(logreturns)

# Make a scatterplot matrix of logreturns
pairs(logreturns)

# Covariance and correlation ====
# Covariance
#   relationship between two variables that is scale dependent
# Correlation
#   standardized version of covariance
#   +1: perfectly positive linear relationship
#   -1: perfectly negative linear relationship
#   0 : no linear relationship
#   cov(A, B) / (sd(A)*sd(B))

# Sample covariances measure the strength of the linear relationship between 
# matched pairs of variables. The cov() function can be used to calculate 
# covariances for a pair of variables, or a covariance matrix when a matrix 
# containing several variables is given as input.

# Covariances are very important throughout finance, but they are not scale free 
# and they can be difficult to directly interpret. Correlation is the standardized
# version of covariance that ranges in value from -1 to 1, where values close to 1
# in magnitude indicate a strong linear relationship between pairs of variables.
# The cor() function can be applied to both pairs of variables as well as a matrix 
# containing several variables

DAX_logreturns <- diff(log(eu_stocks[,'DAX']))
FTSE_logreturns <- diff(log(eu_stocks[,'FTSE']))

# Use cov() with DAX_logreturns and FTSE_logreturns
cov(DAX_logreturns, FTSE_logreturns)
# Use cov() with logreturns
cov(logreturns)

# Use cor() with DAX_logreturns and FTSE_logreturns
cor(DAX_logreturns, FTSE_logreturns)
# Use cor() with logreturns
cor(logreturns)

# Autocorrelation
# Autocorrelations or lagged correlations are used to assess whether a time 
# series is dependent on its past.
# The lag-1 autocorrelation of x can be estimated as the sample correlation 
# of these (x[t], x[t-1]) pairs.
# 
# Luckily, the acf() command provides a shortcut. 
# Applying acf(..., lag.max = 1, plot = FALSE) to a series x automatically 
# calculates the lag-1 autocorrelation.

# Estimating the autocorrelation function (ACF) at many lags allows us to assess
# how a time series x relates to its past. The numeric estimates are important 
# for detailed calculations, but it is also useful to visualize the ACF as a 
# function of the lag.
# 
# each ACF figure includes a pair of blue, horizontal, dashed lines representing
# lag-wise 95% confidence intervals centered at zero.