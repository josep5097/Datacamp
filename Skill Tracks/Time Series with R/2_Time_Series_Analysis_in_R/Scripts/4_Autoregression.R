# The Autoregressive (AR) recursion:
#   Today=Constant+Slope∗Yesterday+Noise
# In R we operate with:
# Mean centered version
#   (Today−Mean)=Slope∗(Yesterday−Mean)+Noise
#   Yt−μ=ϕ(Yt−1−μ)+ϵt where ϵt is mean zero white noise (WN)
#     The mean μ
#     The slope ϕ
#     The WN variance σ2
# If ϕ = 0 then Yt=μ+ϵ_t  and Yt is WN(μ,σ2)
# If ϕ =! 0 then Yt depends on both ϵ_t and Yt-1 and
# the process {Yt} is autocorrelated

#   Large values of ϕ lead to greater autocorrelation
#   Negative values of ϕ result in oscillatory time series

# If μ = 0 and slope ϕ = 1, then:
#   Yt=(Yt−1)+ϵ_t
#   Random Walk (RW) and Yi i not stationary in this case
#   
#   Simulate the autoregressive model The autoregressive (AR) model is arguably
#   the most widely used time series model.
#   
#   The versatile arima.sim() function can also be used to simulate data from
#   an AR model by setting the model argument equal to list(ar = phi) , 
#   in which phi is a slope parameter from the interval (-1, 1).
#   We also need to specify a series length n.

# Simulate an AR model with 0.5 slope
# Moderate amount of autocorrelation
x <- arima.sim(model = list(ar = 0.5), n = 100)

# Simulate an AR model with 0.9 slope
# Large amount of autocorrelation
y <- arima.sim(model = list(ar = 0.9), n = 100)

# Simulate an AR model with -0.75 slope
# Z tends to oscillate from one observation to the next
z <- arima.sim(model = list(ar = -0.75), n = 100)

# Plot your simulated data
plot.ts(cbind(x, y, z))

# Estimate the autocorrelation function (ACF) for an autoregression ====
# Simulate an AR model with 0.5 slope
x <- arima.sim(model = list(ar = 0.5), n = 200)

# Simulate an AR model with 0.9 slope
y <- arima.sim(model = list(ar = 0.9), n = 200)

# Simulate an AR model with -0.75 slope
z <- arima.sim(model = list(ar = -0.75), n = 200)

# Calculate the ACF for x
acf(x)
# Positive autocorrelation for the first couple lags
# but quickly approach zero.

# Calculate the ACF for y
acf(y)
# Positive autocorrelation for many lags,  but
# they also decay to zero

# Calculate the ACF for z
acf(z)
# Has an alternative pattern, but still quickly decays to zero

# Persistence and anti-persistence
# Autoregressive processes can exhibit varying levels of persistence as well 
# as anti-persistence or oscillatory behavior. 
# Persistence is defined by a high correlation between an observation and its
# lag, while anti-persistence is defined by a large amount of variation
# between an observation and its lag.


# Compare RW and AR Model ====
# The random walk (RW) model is a special case of the autoregressive (AR) model,
# in which the slope parameter is equal to 1.
# RW model is not stationary and exhibits very strong persistence.
# Its sample autocovariance function (ACF) also decays to zero very slowly, 
# meaning past values have a long lasting impact on current values.
# 
# The stationary AR model has a slope parameter between -1 and 1. 
# The AR model exhibits higher persistence when its slope parameter is closer 
# to 1, but the process reverts to its mean fairly quickly. Its sample ACF also
# decays to zero at a quick (geometric) rate, indicating that values far in the 
# past have little impact on future values of the process.

# Simulate and plot AR model with slope 0.9 
x <- arima.sim(model = list(ar = 0.9), n = 200)
ts.plot(x)
acf(x)

# Simulate and plot AR model with slope 0.98
y <- arima.sim(model = list(ar = 0.98), n = 200)
ts.plot(y)
acf(y)

# Simulate and plot RW model
z <- arima.sim(model = list(order=c(0,1,0)), n = 200)
ts.plot(z)
acf(z) 

# AR Model Estimation and forecasting ====

# Estimate the autoregressive (AR) model For a given time series x we can 
# fit the autoregressive (AR) model using the arima() command and setting order 
# equal to c(1, 0, 0). Note for reference that an AR model is an ARIMA(1, 0, 0)
# model.

# AR Processes: Inflation rate
data(Mishkin, package = "Ecdat")
inflation <- as.ts(Mishkin[,1])
ts.plot(inflation); acf(inflation)
# The AR Model may provide a good fit to these data
AR_inflation <- arima(inflation, order = c(1,0,0))
print(AR_inflation)

# ar1 = slope ϕ^ 
# intercept = μ^ 
# sigma^2 = σ^2_ϵ

# AR processes: fitted values
# Today^=Mean^+Slope^∗(Yesterday−Mean^)
# Y^_t=μ^+(ϕ^)(Yt−1−μ^)
# Residuals = Today−Today^
#   ϵ^t=Yt−Y^t

ts.plot(inflation)
AR_inflation_fitted <- inflation - residuals(AR_inflation)
points(AR_inflation_fitted,
       type = "l",
       col = "red",
       lty = 2)

# Forecasting ====
predict(AR_inflation)$pred
predict(AR_inflation)$se

# h-step ahead forecasts
predict(AR_inflation,
        n.ahead = 6)$pred

predict(AR_inflation,
        n.ahead = 6)$se


# Fit the AR model to AirPassengers
AR <- arima(AirPassengers, order = c(1, 0, 0))
print(AR)

# Run the following commands to plot the series and fitted values
ts.plot(AirPassengers)
AR_fitted <- AirPassengers - residuals(AR)
points(AR_fitted, type = "l", col = 2, lty = 2)


# Fit an AR model to Nile
AR_fit <- arima(Nile, order = c(1,0,0))
print(AR)

# Use predict() to make a 1-step forecast
predict_AR <- predict(AR)

# Obtain the 1-step forecast using $pred[1]
predict_AR$pred[1]

# Use predict to make 1-step through 10-step forecasts
predict(AR, n.ahead = 10)

# Run to plot the Nile series plus the forecast and 95% prediction intervals
ts.plot(Nile, xlim = c(1871, 1980))
AR_forecast <- predict(AR, n.ahead = 10)$pred
AR_forecast_se <- predict(AR, n.ahead = 10)$se
points(AR_forecast, type = "l", col = 2)
points(AR_forecast - 2*AR_forecast_se, type = "l", col = 2, lty = 2)
points(AR_forecast + 2*AR_forecast_se, type = "l", col = 2, lty = 2)
