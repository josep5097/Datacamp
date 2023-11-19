# Pure seasonal models ====
#   Often collect data with a known seasonal component
#   Air passengers (1 cycle every S = 12 months)
#   Johnson & Johnson earnings (1 cycle every S = 4 quarters)

# Consider pure seasonal models such as an SAR(P=1)s=12
# Xt=ΦXt−12+Wt

# ACF and PACF of pure Seasonal Models
#          SAR(P)s          SMA(Q)s         SARMA(P,Q)s
#ACF*     Tails off      Cuts off lag QS     Tails off
#PACF*  Cuts off lag PS     Tails off        Tails off
# * The values at the nonseasonal lags are zero
# * All lags are at the seasonal level

# Mixed seasonal models
# 
#   Mixed models: SARIMA(p,d,q) x (P,D,Q)s model
#   Consider a SARIMA(0,0,1) x (1,0,0)12 model
#     Xt=ΦXt−12+Wt+θWt−1
#     SAR(1): value this month related to last year’s value Xt−12
#     MA(1): this month’s value related to last month’s shock Wt−1
# Fit a mixed seasonal model

# Pure seasonal dependence is relatively rare. 
# Most seasonal time series have mixed dependence, meaning only some of 
# the variation is explained by seasonal trends.
# 
# Recall that the full seasonal model is denoted by SARIMA(p,d,q)x(P,D,Q)S 
# where capital letters denote the seasonal orders.

# When we extract the seasonal component, an it barely changes
# from one year to another year, it is called seasonal persistence
# And it can be taken care of by seasonally differencing
# Some events can be repeatedly by per quarter diff(x,4)

library(astsa)
library(pacman)
library(xts)

# Air Passegers 
par(mfrow = c(4,1))
plot(AirPassengers)
plot(log(AirPassengers))
plot(diff(log(AirPassengers)))
plot(diff(diff(log(AirPassengers)),12))

# The variance stabilizes after the log transformation
# There is some trend that the data follow.
# Notice the seasonal persistance where there are 3 cylces per year
# d = 1, D = 1 with S = 12
par(mfrow = c(1,1))
acf2(AirPassengers)
acf2(log(AirPassengers))
acf2(diff(log(AirPassengers)))
acf2(diff(diff(log(AirPassengers)),12))

airpass_fit1 <- sarima(log(AirPassengers), p = 1,
                       d = 1, q=1, P = 0, 
                       D = 1, Q = 1, S = 12)

airpass_fit2 <- sarima(log(AirPassengers), 0,1,1,0,1,1,12)
airpass_fit1$ttable
airpass_fit2$ttable

# Unemployment ====
# Plot unemp 
plot(unemp, main = "Unemployment")

# Difference your data and plot
d_unemp <- diff(unemp)
plot(d_unemp, main = "Differenced Unemployment")

# Plot seasonal differenced diff_unemp
dd_unemp <- diff(d_unemp, lag = 12)   
plot(dd_unemp, main = "Seasonal Differenced Unemployment")

# Remove the trend and the seasonal variation in unemployment
# Data appear to be stationary

# Plot P/ACF pair of the fully differenced data to lag 60
# dd_unemp <- diff(diff(unemp), lag = 12)
# acf2(dd_unemp, max.lag = 60)
# 
# The lag axis in the sample P/ACF plot is in terms of years. 
# Thus, lags 1, 2, 3, … represent 1 year (12 months), 2 years (24 months), 
# 3 years (36 months), and so on


# Fit an appropriate model
sarima(unemp, p = 2, d = 1, q = 0, P = 0, D = 1, Q = 1, S = 12)


# Commodity Prices ====
plot(chicken, ylab = "Cents per Pound", main = "Chicken Prices")

# Plot differenced chicken
plot(diff(chicken))

# Plot P/ACF pair of differenced data to lag 60
acf2(diff(chicken), max.lag = 60)


# Fit ARIMA(2,1,0) to chicken - not so good
sarima(chicken, p = 2, d = 1, q = 0)

# Fit SARIMA(2,1,0,1,0,0,12) to chicken - that works
sarima(chicken, p = 2, d = 1, q = 0, P = 1, D = 0, Q = 0, S = 12)


# Birth rate ====
plot(birth, main="US Birth Rate")


# Plot P/ACF to lag 60 of differenced data
d_birth <- diff(birth)
acf2(d_birth, max.lag=60)

# Plot P/ACF to lag 60 of seasonal differenced data
dd_birth <- diff(d_birth, lag = 12)
acf2(dd_birth, max.lag = 60)

# Fit SARIMA(0,1,1)x(0,1,1)_12. What happens?
sarima(birth, p = 0, d = 1, q = 1, P = 0, D = 1, Q = 1, S = 12)

# Add AR term and conclude
sarima(birth, p = 1, d = 1, q = 1, P = 0, D = 1, Q = 1, S = 12)


# Forecasting ARIMA Processes ====
# Once model is chosen, forecasting is easy because the model
# describes how the dynamics of the time series
# behave over time

# Simply continue the model dynamics into the future.
# In the astsa package, use sarima.for()


# Fit your previous model to unemp and check the diagnostics
sarima(unemp, p = 2, d = 1, q = 0, P = 0, D = 1, Q = 1, S = 12)
# Forecast the data 3 years into the future
sarima.for(unemp, n.ahead = 36, p = 2, d = 1, q = 0, P = 0, D = 1, Q = 1, S = 12)


# Fit the chicken model again and check diagnostics
sarima(chicken, p = 2, d = 1, q = 0, P = 1, D = 0, Q = 0, S = 12)
# Forecast the chicken data 5 years into the future
sarima.for(chicken, n.ahead = 60, p = 2, d = 1, q = 0, P = 1, D = 0, Q = 0, S = 12)
