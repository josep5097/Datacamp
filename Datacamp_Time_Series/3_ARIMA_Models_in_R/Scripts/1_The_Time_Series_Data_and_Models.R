# ARIMA Models in R ====

# Time Series regression models ====
# Regression: Yi=βXi+ϵi,where ϵi is white noise 
#   - assumptions about errors: 
#     - independent 
#     - normally distributed 
#     - homoscedastic - i.e., white noise 
#         - white noise: 
#           - independent normals with common variance 
#           - is basic building block of time series
# 
# AutoRegression: Xt=ϕXt−1+ϵt (ϵt is white noise) 
#   - assuming that t and t−1 are not correlated 
#   - may lead to bad forecasts
# 
# Moving Average: ϵt=Wt+θWt−1 (Wt is white noise)
#   - moving average assumes t and t−1 are correlated
# 
# ARMA: Xt=ϕXt−1+Wt+θWt−1 
#   - AutoRegression + Moving Average
#     - i.e., AutoRegression with autocorrelated errors

# Time Series Data - I
library(astsa)
library(pacman)
library(xts)

plot(jj, 
     main = "Johson & Johnson Quartely Earnings per Share",
     type = "c")
text(jj, labels = 1:4, col = 1:4)
# In Series I, there is heteroscedasticity

# Time Series Data - II
plot(globtemp,
     main = "Global Temperature Deviations",
     type = "o"
     )
# This series does not have seasonal component and it is homoscedatic

# Time Series Data - III
plot(sp500w,
     main = "S&P 500 Weekly Returns")
# This series does not have any trend or seasonality.
# This is a particular case / Noise

# View a detailed description of AirPassengers
help(AirPassengers)

# Plot AirPassengers
plot(AirPassengers)

# Plot the DJIA daily closings
plot(astsa::djia$Close)

# Plot the Southern Oscillation Index (soi)
plot(astsa::soi)

# The AirPassengers data show a handful of important qualities, including 
# seasonality, trend, and heteroscedasticity, which distinguish the data
# from standard white noise.


# Stationarity and nonstationarity ====
# A time series is stationary when it is “stable”, meaning: 
#   - the mean is constant over time (no trend) 
#   - the correlation structure remains constant over time


# Stationarity
# Given data, x1,...,xn we can estimate by averaging
# - If mean is constant, we can estimate it by the sample average

# Pairs can be used to estimate correlation on different lags: 
#   - (x1,x2),(x2,x3),(x3,x4), for lag 1 
#   - (x1,x3),(x2,x4),(x3,x5), for lag 2
# 
# Random Walk trend
# Not stationary, but differenced data are stationary 
#   - e.g., Xt for global temperatures trends upwards 
#   - Xt−Xt−1 is stationary with random movement
# 
# Trend Stationarity
# Stationary around a trend, differencing still works like Random Walk!
#   
# 
# Nonstationarity in trend and variability 
#   - First log (stabilize variance and/or linearize trend), 
#   then difference 
#     - Xt 
#     - log(Xt) ... stabilize the variance
#     - log(Xt)−log(Xt−1) ... detrend it
# 
# # Plot globtemp and detrended globtemp

# Differencing
# When a time series is trend stationary, it will have stationary behavior 
# around a trend. A simple example is Yt=α+βt+Xt where Xt is stationary.
# 
# A different type of model for trend is random walk, which has the 
# form Xt=Xt−1+Wt, where Wt is white noise. It is called a random walk 
# because at time t the process is where it was at time t−1 plus a 
# completely random movement. 
# For a random walk with drift, a constant is added to the model and 
# will cause the random walk to drift in the direction 
# (positive or negative) of the drift.

par(mfrow = c(2,1))
plot(globtemp) 
plot(diff(globtemp))

# Plot cmort and detrended cmort
par(mfrow = c(2,1))
plot(cmort)
plot(diff(cmort))


# Dealing with trend and heteroscedasticity ====
# Often time series are generated as
#   Xt=(1+pt)Xt−1
# 
# meaning that the value of the time series observed at time t 
# equals the value observed at time t−1 and a small percent
# change pt at time t.
# 
# A simple deterministic example is putting money into a bank 
# with a fixed interest p.
# Typically, pt is referred to as the return or growth rate 
# of a time series, and this process is often stable.
# 
# It can be shown that the growth rate pt can be approximated by:
#   Yt=logXt−logXt−1≈pt

# Plot GNP series (gnp) and its growth rate
par(mfrow = c(2,1))
plot(gnp)
plot(diff(log(gnp)))

# Plot DJIA closings (djia$Close) and its returns
par(mfrow = c(2,1))
plot(djia$Close)
plot(diff(log(djia$Close)))


# Stationary time series: ARMA ====
# Wold Decomposition
# 
# Wold proved that any stationary time series may be represented 
# as a linear combination of white noise:
#   
#   Xt=Wt+a1Wt−1+a2Wt−2+...
# 
# Any ARMA model has this form, which means they are suited to
# modeling time series

# Generate and plot white noise
par(mfrow = c(3,1))
WN <- arima.sim(model = list(order = c(0, 0, 0)), n = 200)
plot(WN)


# Generate and plot an MA(1) with parameter .9
MA <- arima.sim(model = list(order = c(0, 0, 1), ma = .9), n = 200)  
plot(MA)

# Generate and plot an AR(1) with parameters 1.5 and -.75
AR <- arima.sim(model = list(order = c(2, 0, 0), ar = c(1.5, -.75)), n = 200) 
plot(AR)