# Dynamic Regression ====
# Previous models can not fit good for weekly or hourly data
# How to handle with more complicated seasonality.

# yt = B0 + B1x1,t + ... + BrXr,t + et
# yt modeled as function of r explanatory variables
# x_1,t ,... x_r,t
# These provide the external information that we wish use when forecasting

# The difference is in the error term 
# In Dynamic Reg: we allow et to be an ARIMA process
# In ordinary reg: We assume that et is WN

# This ARIMA process is where the historical information about the TS
# is incorporated


library(ggfortify)
library(forecast) # has the three series: gold, woolyrnq, and gas
library(ggplot2)
library(fpp2) # datasets: a10, ausbeer


autoplot(uschange[,1:2], facets = T)+
  xlab("Year")+
  ylab("")+
  ggtitle("Quaterly changes in US consumption and personal income")
# We might want to forecast consumption, and use income as a predictor variable

ggplot( aes( x = Income, y = Consumption),
        data = as.data.frame(uschange))+
  geom_point()+
  ggtitle("Quarterly changes in US consumption and personal income")


# There is a positive relationship between them as we expected
# It is not a particularly strong relationship, but it does provide some useful information

# xreg argument contains a matrix of predictor variables
fit <- auto.arima(uschange[,"Consumption"],
                  xreg = uschange[,"Income"])
fit
# origxreg tell us that consumption change 0.25 percentage points when income
# changes by 1 percentage point.
checkresiduals(fit)

# to forecast, we need to provide future values of the predictors


# Either we can forecast these in a separate model, or we can do 
# scenario forecasting where we look at the effect of different values of the
# predictor on the forecast.

fcast <- forecast(fit,
                  xreg = rep(0.8,8))
autoplot(fcast) +
  xlab("Year")+
  ylab("Percentage change")

# Forecasting sales allowing for advertising expenditure ====
# auto.arima() will fit a dynamic reg model with ARIMA errors

# Time plot of both variables
autoplot(advert, facets = TRUE)

# Fit ARIMA model
fit <- auto.arima(advert[, "sales"],
                  xreg = advert[, "advert"], 
                  stationary = TRUE)

# Check model. Increase in sales for each unit increase in advertising
salesincrease <- coefficients(fit)[3]

# Forecast fit as fc
fc <- forecast(fit, xreg = rep(10, 6))

# Plot fc with x and y labels
autoplot(fc) + xlab("Month") + ylab("Sales")


# Forecasting electricity demand - Daily ====
# Model daily electricity demand as a function of temperature
# due to, more electricity is used on hot days, due to air conditioning

# fit a quadratic regression model with an ARMA error
# Because there is weekly seasonality, the freq has been set to 7

# Time plots of demand and temperatures
autoplot(elecdaily[, c("Demand", "Temperature")], 
         facets = TRUE)

# Matrix of regressors
xreg <- cbind(MaxTemp = elecdaily[, "Temperature"],
              MaxTempSq = elecdaily[, "Temperature"]^2, 
              Workday = elecdaily[, "WorkDay"])

# Fit model
fit <- auto.arima(elecdaily[, "Demand"], 
                  xreg = xreg)

# Forecast fit one day ahead
forecast(fit, 
         xreg = cbind(20, 
                      20^2, 1))

# Dynamic Harmonic Regression ====
# This uses Fourier terms to handle seasonality
# Fourier terms come in pairs consisting of a sine and a cosine

# m = Seasonal period
# Every periodic function can be approximated by sums of sin and cos
# terms for large enough k
# Regression coeffs: alpha_k, and gamma_k
# e_t can be modeled as a non-seasonal ARIMA process
# Assumes seasonal pattern is unchanging

# The freq of these terms are called the "Harmonic Freq" and they increase with k

# The fourier terms are predictors in our dynamic regression model 

fit <- auto.arima(auscafe,
                  xreg = fourier(auscafe,
                                 K=1),
                  seasonal = F, # Means that the ARIMA error in the model should be non seasonal
                  lambda = 0)

fit %>%
  forecast(xreg = fourier(auscafe,
                          K = 1, 
                          h = 24)) %>%
  autoplot()+
  ylim(1.6,5.1)

# Modifyinf k
fit <- auto.arima(auscafe,
                  xreg = fourier(auscafe,
                                 K=3),
                  seasonal = F, # Means that the ARIMA error in the model should be non seasonal
                  lambda = 0)

fit %>%
  forecast(xreg = fourier(auscafe,
                          K = 3, 
                          h = 24)) %>%
  autoplot()+
  ylim(1.6,5.1)

# K = 4
fit <- auto.arima(auscafe,
                  xreg = fourier(auscafe,
                                 K=4),
                  seasonal = F, # Means that the ARIMA error in the model should be non seasonal
                  lambda = 0)

fit %>%
  forecast(xreg = fourier(auscafe,
                          K = 4, 
                          h = 24)) %>%
  autoplot()+
  ylim(1.6,5.1)

# K=5
fit <- auto.arima(auscafe,
                  xreg = fourier(auscafe,
                                 K=5),
                  seasonal = F, # Means that the ARIMA error in the model should be non seasonal
                  lambda = 0)

fit %>%
  forecast(xreg = fourier(auscafe,
                          K = 5, 
                          h = 24)) %>%
  autoplot()+
  ylim(1.6,5.1)

# As k increase, it looks like more the past data
# The ARIMA error gets simpler,as there is less signal in the 
# residuals when k is larger

# The best way to select k, is to try a few different 
# values and select the model that gives the lowest AICc Vakue


# The model can include other predictor variables as well as the Fourier terms
# This needs to be added to the xreg matrix

# k can not be more than m/2

# This is particularly useful for weekly data, daily data, and sub daily data.
# For weekly data where m = 52, daily data where m could be 365, if there is annual
# seasonality, and sub-daily data where it could be even higher.

# Forecasting Weekly data ====
# Set up harmonic regressors of order 13
harmonics <- fourier(gasoline, K = 13)

# Fit regression model with ARIMA errors
fit <- auto.arima(gasoline, xreg = harmonics, seasonal = FALSE)

# Forecasts next 3 years
newharmonics <- fourier(gasoline, K = 13, h = 156)
fc <- forecast(fit, xreg = newharmonics)

# Plot forecasts fc
autoplot(fc)

# Harmonic regression for multiple seasonality ====
# auto.arima() would take a long time to fit a long TS, so instead you
# will fit a standard regression model with Fourier terms
# using tslm(), is similar to lm() but designed for TS.

# Fit a harmonic regression using order 10 for each type of seasonality
fit <- tslm(taylor ~ fourier(taylor, K = c(10, 10)))

# Forecast 20 working days ahead
fc <- forecast(fit, newdata = data.frame(fourier(taylor, K = c(10, 10), h = 20 * 48)))

# Plot the forecasts
autoplot(fc)

# Check the residuals of fit
checkresiduals(fit)

# Even the fitted model fail the tests badly, the forecasts are quite good.


# Forecasting call bookings ====
# Plot the calls data
autoplot(calls)

# Set up the xreg matrix
xreg <- fourier(calls, K = c(10, 0))

# Fit a dynamic regression model
fit <- auto.arima(calls, xreg = xreg, seasonal = FALSE, stationary = TRUE)

# Check the residuals
checkresiduals(fit)

# Plot forecast for 10 working days ahead
fc <- forecast(fit, xreg = fourier(calls, c(10, 0), h = 1690))
autoplot(fc)


# TBATS models ====
# Combines many of the components of models we have already used into one single
# automated framework.

# * Trigonometric terms for seasonality> Similar to the Fourier terms we used in harmonic regressions
# * Box-Cox Transformations for heterogeneity
# ARMA errors for short-term dynamics
# Trend (possibly damped)
# Seasonal (including multiple and non-integer periods)

gasoline %>%
  tbats() %>%
  forecast() %>%
  autoplot()+
  xlab("Year")+
  ylab("Thousand barrels per day")

# The title:
# TBATS(1,{0,0},-,{<52.18,14>})
# TBATS(1,xxxx) - Box-Cox parameter, no transformation was required
# TBATS(x, {0,0}, ) - ARMA Error
# The third part, damping parameter: A dash means no damping
# The last par, tells about the Fourir terms
# 52.18, 14> The number of wekks in a year, there were 14 Fourier terms


calls %>%
  window(start = 20) %>%
  tbats() %>%
  forecast() %>%
  autoplot() + xlab("Weeks")+ylab("Calls")



# Plot the gas data
autoplot(gas)

# Fit a TBATS model to the gas data
fit <- tbats(gas)

# Forecast the series for the next 5 years
fc <- forecast(fit, h = 12 * 5)
fc
# Plot the forecasts
autoplot(fc)

# Record the Box-Cox parameter and the order of the Fourier terms
lambda <- 0.082
K <- 5
