# AR and MA models ====
# 
# Identifying model types
# 
#           AR(p)           MA(q)           ARMA(p,q)
# ACF     tails off        cuts off lag q   Tails off
# PACF    cuts off lag p   Tails off        Tails off


# Estimation
# 
# Estimation for time series is similar to using least squares  for regression
# Estimates are obtained numerically using ideas of Gauss and Newton

library(astsa)
library(pacman)
library(xts)

x <- arima.sim(list(order = c(1,0,0), ar = -0.7), n=200)
y <- arima.sim(list(order = c(0,0,1), ma = -0.7), n = 200)

par(mfrow = c(1,2))
plot(x, main = "AR(1)"); plot(y, main = "MA(1)")


x <- arima.sim(list(order = c(2,0,0), ar = c(1.5,-0.75)),
               n = 200)+50
x_fit <- sarima(x, p=2, d=0, q=0)

x_fit$ttable

## Fitting an AR(1) model
# Generate 100 observations from the AR(1) model
x <- arima.sim(model = list(order = c(1, 0, 0), ar = .9), n = 100)

# Plot the generated data  
plot(x)

# Plot the sample P/ACF pair
astsa::acf2(x)

# Fit an AR(1) to the data and examine the t-table
astsa::sarima(x, p = 1, d = 0, q = 0)


## Fitting an AR(2) Model
x <- arima.sim(model = list(order = c(2, 0, 0), ar = c(1.5, -.75)), n = 200)

# Plot x
par(mfrow = c(1,1))
plot(x)

# Plot the sample P/ACF of x
astsa::acf2(x)

# Fit an AR(2) to the data and examine the t-table
astsa::sarima(x, p = 2, d = 0, q = 0)

## Fitting an MA(1)
# astsa is preloaded
x <- arima.sim(model = list(order = c(0, 0, 1), ma = -.8), n = 100)

# Plot x
plot(x)

# Plot the sample P/ACF of x
acf2(x)

# Fit an MA(1) to the data and examine the t-table
sarima(x, p = 0, d = 0, q = 1)


# AR and MA together ====
# Xt=ϕXt−1+Wt+θWt−1 autoregression with correlated errors
# 
# Fitting an ARMA model
# Recall that for ARMA(p,q) models, both the theoretical ACF and PACF tail off.

x <- arima.sim(model = list(order = c(2, 0, 1), ar = c(1, -.9), ma = .8), n = 250)

# astsa is preloaded

# Plot x
plot(x)

# Plot the sample P/ACF of x
astsa::acf2(x)

# Fit an ARMA(2,1) to the data and examine the t-table
astsa::sarima(x, p = 2, d = 0, q = 1)

# Model Choice and Residual analysis ====
# Akaike's Information Criterio (AIC) and Bayesian Information Criterio (BIC)
# As more parameter are included in a model, the error
# gets smaller whether or not the parameters are needed

# Error                             Number of Parameters
# average(observed - predicted)^2 +  k(p+q)

# AIC and BIC measure the error and penalize (differently) for adding parameters
# for example AIC has k = 2 and BIC has k = log(n)
# BIC has a bigger penalty, and tends to choose a model with
# fewer parameters
# Goal: find the model with the smallest AIC or BIC

# Residual Analysis
# 
# The basic goal of residual analysis is the same as in regression
# Make sure the residual are white Gaussian noise
# 
# sarima() includes residual analysis and graphic showing:
#   
#   1. Standardized residuals> should be white noise
#   2. Sample ACF of residuals> points within blue lines indicates normality
#   3. Normal Q-Q plot> points should mostly be on the line / Normality
#   4. Q-statistic p-values> points above blue line indicates normality / Whiteness in the residuals

dl_varve <- diff(log(astsa::varve))

# Fit an MA(1) to dl_varve.   
sarima(dl_varve, p = 0, d = 0, q = 1)

# Fit an MA(2) to dl_varve. Improvement?
sarima(dl_varve, p = 0, d = 0, q = 2)

# Fit an ARMA(1,1) to dl_varve. Improvement?
sarima(dl_varve, p = 1, d = 0, q = 1)

par(mfrow = c(2,1))
plot(astsa::varve) 
plot(dl_varve)

# Fit an MA(1) to dl_varve. Examine the residuals  
sarima(dl_varve, p = 0, d = 0, q = 1)

# Fit an ARMA(1,1) to dl_varve. Examine the residuals
sarima(dl_varve, p = 1, d = 0, q = 1)

par(mfrow = c(1,1))
oil <- ts(astsa::oil, start = 2000, end = 2008, frequency = 52)
plot(oil, main = "Crude Oil - USD per Barrel")

# Calculate approximate oil returns
oil_returns <- diff(log(oil))

# Plot oil_returns. Notice the outliers.
plot(oil_returns)

# Plot the P/ACF pair for oil_returns
acf2(oil_returns)

# Assuming both P/ACF are tailing, fit a model
sarima(oil_returns, p = 1, d = 0, q = 1)
