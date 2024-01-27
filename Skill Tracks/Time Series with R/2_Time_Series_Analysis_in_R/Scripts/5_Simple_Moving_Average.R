# The simple moving average model
# 
# The simple moving average (MA) model:
#   Today=Mean+Noise+Slope∗(Yesterday′s Noise)
#   Yt=μ+ϵt+θϵt−1 where ϵt is mean zero white noise (WN)
# Three parameters:
#   The mean μ
#   The slope θ
#   The WN variance σ2
# if slope θ = 0 then it is a white noise (WN) process
# if slope θ is not zero then Yt depends on both ϵt and ϵt−1
#   The process Yt is autocorrelated
# Large values of slope θ lead to greater autocorrelation
# Negative values of slope θ result in oscillatory time series



# Simulate the simple moving average model ====
# The simple moving average (MA) model is a parsimonious time series model 
# used to account for very short-run autocorrelation.
# It does have a regression like form, but here each observation is regressed 
# on the previous innovation, which is not actually observed. 
# Like the autoregressive (AR) model, the MA model includes the
# white noise (WN) model as special case.
# 
# As with previous models, the MA model can be simulated using the arima.sim() 
# command by setting the model argument to list(ma = theta), where theta is a 
# slope parameter from the interval (-1, 1). 

# Generate MA model with slope 0.5
x <- arima.sim(model = list(ma = 0.5), n = 100)

# Generate MA model with slope 0.9
y <- arima.sim(model = list(ma = 0.9), n = 100)

# Generate MA model with slope -0.5
z <- arima.sim(model = list(ma = -0.5), n = 100)

# Plot all three models together
plot.ts(cbind(x, y, z))

# Note that there is some very short-run persistence for the positive 
# slope values (x and y), and the series has a tendency to alternate 
# when the slope value is negative (z).

# Estimate the ACF for a moving average ====

# Generate MA model with slope 0.4
x <- arima.sim(model = list(ma = 0.4), n = 200)

# Generate MA model with slope 0.9
y <- arima.sim(model = list(ma = 0.9), n = 200)

# Generate MA model with slope -0.75
z <- arima.sim(model = list(ma = -0.75), n = 200)

# Plot all three models together
plot.ts(cbind(x, y, z))

# Calculate ACF for x
acf(x)

# Calculate ACF for y
acf(y)

# Calculate ACF for z
acf(z)

# The series x has positive sample autocorrelation at the first lag, but it 
# is approximately zero at other lags. The series y has a larger sample 
# autocorrelation at its first lag, but it is also approximately zero for 
# the others. The series z has an alternating pattern, and its sample 
# autocorrelation is negative at the first lag. However, similar to the others,
# it is approximately zero for all higher lags.

# Estimate the simple moving average model
# 
# The next step is to fit the simple moving average (MA) model to some data 
# using the arima() command. For a given time series x we can fit the simple 
# moving average (MA) model using arima(..., order = c(0, 0, 1)).
# Note for reference that an MA model is an ARIMA(0, 0, 1) model.

data(Mishkin, package = "Ecdat")
inflation <- as.ts(Mishkin[,1])
# Calculate changes in the inflation rates
inflation_changes <- diff(inflation)
ts.plot(inflation); ts.plot(inflation_changes)

# inflation_changes: Changes in one-month US Inflation rate
acf(inflation_changes, lag.max = 24)

MA_inflation_changes <- arima(inflation_changes,
                              order = c(0,0,1))
print(MA_inflation_changes)

# MA model estimation and forecasting
# ma1 = θ^
# intercept = μ^
# sigma^2 = σ^2ϵ

# MA fitted values:
#   Today^=Mean^+Slope^∗Yesterday′s Noise^
#   Y^t=μ^+θ^ϵ^t−1

# Residuals:
#   Today−Today^
#   ϵ^_t = Y_t - Y^_t

MA_fitted <- inflation_changes - residuals(MA_inflation_changes)
ts.plot(inflation_changes)
points(MA_fitted,
       type = "l",
       col = "red",
       lty = 2)

predict(MA_inflation_changes, n.ahead = 6)$pred

predict(MA_inflation_changes, n.ahead = 6)$se

# Through 2 - 6th pred is the same
# This is because MA model has memory for one time lag.

# Fit the MA model to Nile
MA <- arima(Nile, order = c(0, 0, 1))
print(MA)

# Plot Nile and MA_fit 
ts.plot(Nile)
MA_fit <- Nile - resid(MA)
points(MA_fit, type = "l", col = 2, lty = 2)

# Make a 1-step forecast based on MA
predict_MA <- predict(MA)

# Obtain the 1-step forecast using $pred[1]
predict_MA$pred[1] 

# Make a 1-step through 10-step forecast based on MA
predict(MA, n.ahead = 10)

# Plot the Nile series plus the forecast and 95% prediction intervals
ts.plot(Nile, xlim = c(1871, 1980))
MA_forecasts <- predict(MA, n.ahead = 10)$pred
MA_forecast_se <- predict(MA, n.ahead = 10)$se
points(MA_forecasts, type = "l", col = 2)
points(MA_forecasts - 2*MA_forecast_se, type = "l", col = 2, lty = 2)
points(MA_forecasts + 2*MA_forecast_se, type = "l", col = 2, lty = 2)

# Compare AR and MA models
# 
# Goodness of fit: - information criterion (aic and bic) measures in model 
# fitting outputs help to compare which model best fits - lower values
# indicates better fitting model
# 
# AR vs MA models
# 
# As you’ve seen, autoregressive (AR) and simple moving average (MA) 
# are two useful approaches to modeling time series. But how can you 
# determine whether an AR or MA model is more appropriate in practice?
#   
# To determine model fit, you can measure the Akaike information 
# criterion (AIC) and Bayesian information criterion (BIC) for each model. 
# While the math underlying the AIC and BIC is beyond the scope of this course, 
# for your purposes the main idea is these indicators penalize models with
# more estimated parameters, to avoid overfitting, and smaller values are 
# preferred. All factors being equal, a model that produces a lower AIC 
# or BIC than another model is considered a better fit.

# To estimate these indicators, you can use the AIC() and BIC() commands,
# both of which require a single argument to specify the model in question.