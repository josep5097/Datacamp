# ARIMA - integrated ARMA
# 
# Identifying ARIMA
#   A time series exhibits ARIMA behavior if the differenced 
#   data has ARMA behavior
# 
# ACF and PCF of an integrated ARMA
#   ACF has a linear decay
#   PCF is close to 1 at lag one, and zero afterwards.

library(astsa)
library(pacman)
library(xts)


x <- arima.sim(model = list(order = c(1, 1, 0), ar = .9), n = 200)

# Plot x
plot(x)


# Plot the P/ACF pair of x
acf2(x)

# Plot the differenced data
plot(diff(x))

# Plot the P/ACF pair of the differenced data
acf2(diff(x))


x <- arima.sim(model = list(order = c(2, 1, 0), ar = c(1.5,-.75)), n = 250)
plot(x)
y <- diff(x)
plot(y)
# Plot sample P/ACF of differenced data and determine model
acf2(diff(x))

# Estimate parameters and examine output
sarima(x, p = 2, d = 1, q = 0)


## Global warming ====
par(mfrow = c(2,1))
plot(astsa::globtemp) 
plot(diff(astsa::globtemp))

# Plot the sample P/ACF pair of the differenced data 
acf2(diff(globtemp))

# Fit an ARIMA(1,1,1) model to globtemp
sarima(globtemp, p = 1, d = 1, q = 1)

# Fit an ARIMA(0,1,2) model to globtemp. Which model is better?
sarima(globtemp, p = 0, d = 1, q = 2)

# Judging by the AIC and BIC, the ARIMA(0,1,2) model performs better 
# than the ARIMA(1,1,1) model on the globtemp data.


# ARIMA diagnostics ====
# Diagnostic for ARIMA models is no different than ARMA Models

# Diagnostics - simulated overfitting
#   One way to check an analysis is to overfit the model by adding an extra 
#   parameter to see if it makes a difference in the results. If adding parameters 
#   changes the results drastically, then you should rethink your model. If, however,
#   the results do not change by much, you can be confident that your fit is correct.

x <- arima.sim(model = list(order = c(0, 1, 1), ma = .9), n = 250)

par(mfrow = c(2,1))
plot(x) 
plot(diff(x))

# Plot sample P/ACF pair of the differenced data
acf2(diff(x))

# Fit the first model, compare parameters, check diagnostics
astsa::sarima(x, p = 0, d = 1, q = 1)

# Fit the second model and compare fit
astsa::sarima(x, p = 0, d = 1, q = 2)  

# The second parameter added in the second model, is not significant, and the first 
# term is not mutable.
# The BIC and the AIC is incremented by more terms are added.


par(mfrow = c(1,1))
plot(astsa::globtemp, ylab = "globtemp", main = "Global Temperature Deviations")

# Fit ARIMA(0,1,2) to globtemp and check diagnostics  
sarima(globtemp, p = 0, d = 1, q = 2)

# Fit ARIMA(1,1,1) to globtemp and check diagnostics
sarima(globtemp, p = 1, d = 1, q = 1)


# Which is the better model?
"ARIMA(0,1,2)"

# Forecasting ARIMA ====
#   The model describes how the dynamics of the time series behave over time.
#   Forecasting simply continues the mdoel dynamics into the future.
#   Use sarima.for() to forecast in the astsa-package
#     red plotted area is predicted values
#     dark gray band is 1 * RMSPE
#     light gray band is 2 * RMSPE

y <- arima.sim(model = list(order = c(1, 1, 0), ar = .9), n = 120)
x <- ts(y, start = 1, end = 100, frequency = 1)

par(mfrow = c(2,1))
plot(x) 
plot(diff(x))

# Plot P/ACF pair of differenced data 
astsa::acf2(diff(x))

# Fit model - check t-table and diagnostics
astsa::sarima(x, p = 1, d = 1, q = 0)

# Forecast the data 20 time periods ahead
astsa::sarima.for(x, n.ahead = 20, p = 1, d = 1, q = 0) 

lines(y)


plot(astsa::globtemp, ylab = "globtemp", main = "Global Temperature Deviations")

# Fit an ARIMA(0,1,2) to globtemp and check the fit
sarima(globtemp, p = 0, d = 1, q = 2)

# Forecast data 35 years into the future
sarima.for(globtemp, n.ahead = 35, p = 0, d = 1, q = 2) 
