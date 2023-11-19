# Trend Spotting
# Sample transformations: log()
#   filter used to remove or filter some of the common trends
#   Can linearized a rapid growth trend
#   Can also stabilize a series that exhibits increasing variance
#   Defined for positive values

# Sample transformations: diff()
#   can remove a linear trend

# Sample transformations: diff(.., s)
#   For periodic series can remove periodic trends
#    diff(x, s = 4)

# Log rapid_growth
# linear_growth <- log(rapid_growth)

# Generate the first difference of z
# dz <- diff(z)
# Se remueve 1 termino

# Generate a diff of x with n = 4. Save this to dx
dx <- diff(x, lag = 4)
# Se remueven 4 terminos


# The white noise (WN) model
# 
# White noise
#   The simplest example of a stationary process
# A weak white noise process has:
#   A fixed, constant mean
#   A fixed, constant variance
#   No correlation over time

# Arima.sim() can be used to simulate WN time series.
WN_1 <- arima.sim(model = list(order=c(0,0,0)), n=50)
head(WN_1)
ts.plot(WN_1)

WN_2 <- arima.sim(model = list(order = c(0,0,0)),
                  n = 50, mean = 4, sd = 2)
ts.plot(WN_2)


# Estimating White Noise
arima(WN_2,
      order=c(0,0,0))


# Random Walk model ====
# Random walk (RW) is a simple example of a non-stationary process
# A random walk has:
#   No specified mean or variance
#   Strong dependence over time
#   Its changes or increments are white noise (WN)
# The random walk recursion:
#   Today=Yesterday+Noise
#   Yt=Yt−1+ϵt
#      where ϵt is mean zero white noise (WN)
#   Simulation requires an initial point Y0
#   Only one parameter, the WN variance (σ^2)_ϵ
#   as Yt−Yt−1=ϵt -> diff(Y) is WN
#  Random walk with a drift
#   Today=Constant+Yesterday+Noise
#   Yt=c+Yt−1+ϵt
#   two parameters, the constant c, and the WN variance σ2ϵ
#   Yt−Yt−1=? -> WN with mean c

# Generate a RW model using arima.sim
random_walk <- arima.sim(model = list(order = c(0, 1, 0)), n = 100)

# Plot random_walk
ts.plot(random_walk)

# Calculate the first difference series
random_walk_diff <- diff(random_walk)

# Plot random_walk_diff
ts.plot(random_walk_diff)

# This is because a random walk is simply recursive 
# white noise data. By removing the long-term trend, you end up with simple white noise.


# Generate a RW model with a drift uing arima.sim
rw_drift <- arima.sim(model = list(order = c(0, 1, 0)),
                      n = 100, 
                      mean = 1)

# Plot rw_drift
ts.plot(rw_drift)

# Calculate the first difference series
rw_drift_diff <- diff(rw_drift)

# Plot rw_drift_diff
ts.plot(rw_drift_diff)

# The first diff of RW data transformed it back into WN

# Stationary Processes ====
# The arima() command correctly identified the time 
# trend in your original random-walk data.

# Stationary Processes

# Stationarity
#   Stationary models are parsimonious
#   Stationary processes have distributional stability over time
# Observed time series:
#   Fluctuate randomly
#   But behave similarly from one time period to the next
# Weak stationarity
#   Mean, variance, covariance constant over time
#   Y1,Y2,... is a weakly_stationary process if:
#     Mean μ of Yt is same (constant) for all of t
#     Variance σ2 of Yt is same (constant) for all of t
#     Covariance of Yt and Ys is same (constant) for all |t−s|=h for all h
#     e.g., Cov(Y3,Y7)=Cov(Y7,Y11)
#   Estimate μ accurately by y¯
# Stationarity: when?
#   Many financial time series do not exhibit stationarity, however:
#     The changes in the series are often approximately stationary
#     A stationary series should show random oscillation around some fixed level; a phenomenon called mean-reversion


# The white noise (WN) and random walk (RW) models are very closely related. However, 
# only the RW is always non-stationary, both with and without a drift term. 
# 
# Recall that if we start with a mean zero WN process and compute its running or 
# cumulative sum, the result is a RW process. The cumsum() function will make this 
# transformation for you. Similarly, if we create a WN process, but change its mean 
# from zero, and then compute its cumulative sum, the result is a RW process with a drift.


# Use arima.sim() to generate WN data
white_noise <- arima.sim(model = list(order = c(0, 0, 0)), n = 100)

# Use cumsum() to convert your WN data to RW
random_walk <- cumsum(white_noise)

# Use arima.sim() to generate WN drift data
wn_drift <- arima.sim(model = list(order = c(0, 0, 0)), n = 100, mean = 0.4)

# Use cumsum() to convert your WN drift data to RW
rw_drift <- cumsum(wn_drift)

# Plot all four data objects
plot.ts(cbind(white_noise, random_walk, wn_drift, rw_drift))