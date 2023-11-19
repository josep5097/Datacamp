# Transformations for variance stabilization ====
# With ETS models, we used multiplicative errors and multiplicative seasonality
# to handle TS that have variance which increases with the level of the series

# An alternative approach is to transform the TS:
# If data show increasing variation as the level of the series increases
# then a transformation can be useful

# y1,...,yn: original observation
# w1,..., wn: transformed observations

# Square root
# Cube root
# logarithm:
# Inverse

library(ggfortify)
library(forecast) # has the three series: gold, woolyrnq, and gas
library(ggplot2)
library(fpp2) # datasets: a10, ausbeer

autoplot(usmelec)+
  xlab("Year")+
  ylab("")+
  ggtitle("US monthly net electricity generation")


# square root
autoplot(usmelec^0.5)+
  xlab("Year")+
  ylab("")+
  ggtitle("US monthly net electricity generation")


# cube root
autoplot(usmelec^0.3333)+
  xlab("Year")+
  ylab("")+
  ggtitle("US monthly net electricity generation")

# log
autoplot(log(usmelec))+
  xlab("Year")+
  ylab("")+
  ggtitle("US monthly net electricity generation")

# The fluctuations at the top end are still larger than the fluctuations
# at the bottom end.

# Inverse transformation
# Stabilize the variance of this series
autoplot(-1/usmelec)+
  xlab("Year")+
  ylab("")+
  ggtitle("US monthly net electricity generation")

# This four transf are closely related to the family Box-Cox transf
# log(yt); lambda=0
# ((yt)^lambd - 1)/lambda; lambda != 0
# BoxCox.lambda(x)
BoxCox.lambda(usmelec)

usmelec %>%
ets(lambda = -0.57) %>%
  forecast(h=60) %>%
  autoplot()


# Use BoxCox transf to stabilize the variance
# -1 <= lambda <= 1

# Plot the series
autoplot(a10)

# Try four values of lambda in Box-Cox transformations
a10 %>% BoxCox(lambda = 0.0) %>% autoplot()
a10 %>% BoxCox(lambda = 0.1) %>% autoplot()
a10 %>% BoxCox(lambda = 0.2) %>% autoplot()
a10 %>% BoxCox(lambda = 0.3) %>% autoplot()

# Compare with BoxCox.lambda()
BoxCox.lambda(a10)

# Non-Seasonal differencing for stationarity ====
# Differencing is a way of makin a TS stationary
# Removing any systematic pattern: trend and seasonality
# With Non-Seasonal data: lag-1 diff rather than the observation directly

# Plot the US female murder rate
autoplot(wmurders)

# Plot the differenced murder rate
autoplot(diff(wmurders))

# Plot the ACF of the differenced murder rate
ggAcf(diff(wmurders))


# With seasonal data, differences are often taken beetween observations in the
# same season of consecutive years.
# Difference between Q1 in one year and Q1 in the previous year

# Plot the data
autoplot(h02)

# Take logs and seasonal differences of h02
difflogh02 <- diff(log(h02), lag = 12)

# Plot difflogh02
autoplot(difflogh02)

# Take another difference and plot
ddifflogh02 <- diff(difflogh02)
autoplot(ddifflogh02)

# Plot ACF of ddifflogh02
ggAcf(ddifflogh02)

# The data does not look like WN after transformation, develop an ARIMA Model

# ARIMA Models ====
# ARIMA: Autoregressive Integrated Moving Average Models

## AR models:
# Multiple regression with lagged observations as predictors
# yt = c + sigma1*yt-1  +sigma2*yt-2 + ... + sigmap*yt-p + et

## MA models:
# Multiple regression with lagged errors as predictors
# yt = c + tetha*et-1  +tetha2*et-2 + ... + tethap*et-p


# ARMA Models can only work with stationary data
# ARIMA(p,d,q):
# Combine ARMA model with d-lots of differencing


autoplot(usnetelec)+
  xlab("Year")+
  ylab("Millions")+
  ggtitle("US net electricity generation")

fit <- auto.arima(usnetelec)
summary(fit)

fit %>%
  forecast() %>%
  autoplot()


# Fit an automatic ARIMA model to the austa series
fit <- auto.arima(austa)

# Check that the residuals look like white noise
checkresiduals(fit)
residualsok <- TRUE

# Summarize the model
summary(fit)

# Find the AICc value and the number of differences used
AICc <- -14.46
d <- 1

# Plot forecasts of fit
fit %>% forecast(h = 10) %>% autoplot()


# Plot forecasts from an ARIMA(0,1,1) model with no drift
austa %>% Arima(order = c(0,1,1), include.constant = FALSE) %>% forecast() %>% autoplot()

# Plot forecasts from an ARIMA(2,1,3) model with drift
austa %>% Arima(order = c(2,1,3), include.constant = TRUE) %>% forecast() %>% autoplot()

# Plot forecasts from an ARIMA(0,0,1) model with a constant
austa %>% Arima(order = c(0,0,1), include.constant = TRUE) %>% forecast() %>% autoplot()

# Plot forecasts from an ARIMA(0,2,1) model with no constant
austa %>% Arima(order = c(0,2,1), include.constant = FALSE) %>% forecast() %>% autoplot()


# We cannot use the AIC from different models to compare, instead
# we can use TS cross validation to compare an ARIMA and an ETS model
# tsCV() requires functions that return forecast objects

# Set up forecast functions for ETS and ARIMA models
fets <- function(x, h) {
  forecast(ets(x), h = h)
}
farima <- function(x, h) {
  forecast(auto.arima(x), h = h)
}

# Compute CV errors for ETS on austa as e1
e1 <- tsCV(austa, fets, h = 1)

# Compute CV errors for ARIMA on austa as e2
e2 <- tsCV(austa, farima, h = 1)

# Find MSE of each model class
mean(e1^2, na.rm = TRUE)
mean(e2^2, na.rm = TRUE)

# Plot 10-year forecasts using the best model class
austa %>% farima(h = 10) %>% autoplot()


# Seasonal ARIMA model ====
# ARIMA         (p,d,q)            (P,D,Q)m
#           Non-Seasonal part   Seasonal part of 
#           of the model        the model

autoplot(debitcards)+
  xlab("Year")+
  ylab("Million ISK")+
  ggtitle("Retail debit card usage in Iceland")

fit <- auto.arima(debitcards, lambda = 0)
fit
# Is both: Seasonal and first differences 

fit %>%
  forecast(h = 36) %>%
  autoplot()+xlab("Years")


# Check that the logged h02 data have stable variance
h02 %>% log() %>% autoplot()

# Fit a seasonal ARIMA model to h02 with lambda = 0
fit <- auto.arima(h02, lambda = 0)

# Summarize the fitted model
summary(fit)
# Record the amount of lag-1 differencing and seasonal differencing used
d <- 1
D <- 1

# Plot 2-year forecasts
fit %>% forecast(h = 24) %>% autoplot()


# Exploring auto.arima() options ====
# To make auto.arima() work harded to find a good model, 
# add the optional arg: stepwise = F
# to look at a much larger collection of models
# Find an ARIMA model for euretail
fit1 <- auto.arima(euretail)

# Don't use a stepwise search
fit2 <- auto.arima(euretail, stepwise = FALSE)

fit1
fit2
# AICc of better model
AICc <- 68.39

# Compute 2-year forecasts from better model
fit2 %>% forecast(h = 8) %>% autoplot()



# Use 20 years of the qcement data beginning in 1988
train <- window(qcement, start = 1988, end = c(2007, 4))

# Fit an ARIMA and an ETS model to the training data
fit1 <- auto.arima(train)
fit2 <- ets(train)

# Check that both models have white noise residuals
checkresiduals(fit1)
checkresiduals(fit2)

# Produce forecasts for each model
fc1 <- forecast(fit1, h = 25)
fc2 <- forecast(fit2, h = 25)

# Use accuracy() to find best model based on RMSE
accuracy(fc1, qcement)
accuracy(fc2, qcement)
bettermodel <- fit2
