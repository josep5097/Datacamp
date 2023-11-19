# Exponentially weighted forecast ====
# Two simple forecasting methods are the naive and the mean methods

# The naive method use only the most recent observation as the forecast
# for all future periods.
# The mean method uses the average of all observations as the forecast 
# for all future periods.

# Simple exponential smoothing ====
# Y^_(t+h|t) = point forecast of Y_t+h given data y1...yt

# Forecsat Equation:
# Y^_(t+h|t) = alpha*y_t + alpha(1- alpha)*y_(t-1)+
# +(alpha)((1-alpha)^2)*Y_t-2 + ... ; where 0<=alpha <=1

# A weighted average of all the data up to time t, where the weights
# decrease exponentially.

# The alpha parameter determines how much weight is placed on

# Observation     alpha=0.2     alpha=0.4     alpha=0.6     alpha=0.8
# Yt                0.2           0.4             0.6           0.8
# Yt-1              0.16          0.24            0.24          0.16
# Yt-2              0.128         0.144           0.096         0.032
# Yt-3              0.1024        0.0864          0.0384        0.0064
# Yt-4              0.2*(0.8)^2   (0.4)*(0.6)^2   (0.6)(0.4)^2  (0.8)(0.2)^2

# A small value of alpha - Smaller weight is placed on the most recent observation
# And the weights decay away more slowly


# Forecast Eq: Y^_(t+h|t) = l_t
# Smoothing Eq: l_t = alpha*Y_t + (1-alpha)*l_(t-1)

# l_t is the level (or the smoothed value) of the series at time t
# as the unobserved level component
# The level itself evolves over time based on the most recent observation and the previous
# estimate of the level.

# In regression, parameters are estimated by minizing the sum of
# squared errors, SSE


oildata <- window(oil, start=1996)
fc = ses(oildata, h =5)

summary(fc)



# Use ses() to forecast the next 10 years of winning times
fc <- ses(marathon, h = 10)

# Use summary() to see the model parameters
summary(fc)

# Use autoplot() to plot the forecasts
autoplot(fc)

# Add the one-step forecasts for the training data to the plot
autoplot(fc) + autolayer(fitted(fc))

# Create a training set using subset()
train <- subset(marathon, end = length(marathon) - 20)

# Compute SES and naive forecasts, save to fcses and fcnaive
fcses <- ses(train, h = 20)
fcnaive <- naive(train, h = 20)

# Calculate forecast accuracy measures
accuracy(fcses, marathon)
accuracy(fcnaive, marathon)

# Save the best forecasts as fcbest
fcbest <- fcnaive

# Exponential smoothing methods with trend ====
# Simple exponential smoothing works fine provided your data have no trend
# or seasonality

# To handle trends or seasonality:
## Holt´s linear trend
# Forecast Eq: Y^_(t+h|t) = l_t + h*b_t
# Smoothing Eq: l_t = alpha*Y_t + (1-alpha)*(l_(t-1)+b_(t-1))
# Trend: b_t = Beta*(l_t = l_t-1)+(1-beta*)*(b_t-1)

# The third equation describe the slope changes over time
# 0<=alpha and Beta* <=1
# Large beta* means the slope changes rapidly -- allowing nonlinear trend
# Small beta* means that the slope hardly changes -- close to linear 

# Choose alpha, beta*, l0, b0 to minimize SSE
# |--> Holt's method: holt(h=5)

AirPassengers %>%
  holt(h=5)%>%
  autoplot()

# Holt's method will produce forecast where the trend continues at the same 
# slope indefinitely into the future

# A variation: Damped trend method
# Allow the trend to dampen over time, levels off to a constant value
# phi control the damping / 0<phi<1
# if phi = 1, identical to holt's linear trend


fc1 <- holt(AirPassengers, h=15, PI = F)
fc2 <- holt(AirPassengers,
            damped = T,
            h=15,
            PI = F)
autoplot(AirPassengers)+ xlab("Year")+ylab("Millions")+
  autolayer(fc1, series = "Linear Trend")+
  autolayer(fc2, series = "Damped trend")


# Produce 10 year forecasts of austa using holt()
fcholt <- holt(austa, h = 10)

# Look at fitted model using summary()
summary(fcholt)

# Plot the forecasts
autoplot(fcholt)

# Check that the residuals look like white noise
checkresiduals(fcholt)

# Exponential Smoothing methods with trend and seasonality ====
# There is 2 versions: Additive version and the multiplicative version
# m=period of seasonality (m=4 for quartely data)

# Example: Visitor Nigths
# Using Holt-Winters' Method
aust <- window(austourists, start = 2005)
fc1 <- hw(aust,
          seasonal = "additive")
fc2 <- hw(aust,
          seasonal = "multiplicative")
autoplot(austourists)+ xlab("Year")+ylab("Millions")+
  autolayer(austourists, series = "Data")+
  autolayer(fc1, series = "Linear Trend")+
  autolayer(fc2, series = "Damped trend")
# In cases where the seasonal variation increases with the 
# level of the series, we would want to use the multiplicative method.

#                     |             Seasonal Component
# Trend Component     | N(None)     A(Additive)      M(Multiplicative)
# ----------------------------------------------------------------------
# N(None)             | (N,N)       (N,A)             (N,M)
# A(Additive)         | (A,N)       (A,A)             (A,M)
# Ad(Additive Damped) | (Ad,N)      (Ad,A)            (Ad,M)      

# N,N   Simple exponential smoothing         ses()
# A,N   Holts linear method                  holt()
# Ad,N  Additive damped trend method         hw()
# A,A   Additive Holt-Winters' method        hw()
# A,M   Multiplicative Holt-Winters' method  hw()
# Ad,N  Damped Multiplicative H-W method     hw()

# Plot the data
autoplot(a10)

# Produce 3 year forecasts
fc <- hw(a10, seasonal = "multiplicative", h = 36)

# Check if residuals look like white noise
checkresiduals(fc)
whitenoise <- FALSE

# Plot forecasts
autoplot(fc)

# Holt-Winters Method with Daily Data ====
# This can be used for daily data, where the seasonal pattern is of lenght
# 7, and the appropriate unit of time for h is in days.


# Create training data with subset()
train <- subset(hyndsight, end = length(hyndsight) - 28)

# Holt-Winters additive forecasts as fchw
fchw <- hw(train, 
           seasonal = "additive", 
           h = 28)

# Seasonal naive forecasts as fcsn
fcsn <- snaive(train,
               h = 28)

# Find better forecasts with accuracy()
accuracy(fchw, hyndsight)
accuracy(fcsn, hyndsight)

# Plot the better forecasts
autoplot(fchw)

# State Space models for exponential smoothing ====
## Innovations state space models ====
# Trend = {N, A, Ad}
# Seasona = {N, A, Ad}  
# |---> 9 possible exponential smoothing methods

# Error = {A, M} with Additive and multiplicative methods
# |---> 9x2 = 18 possible state space models

# |---> ETS models: Error, Trend, Seasonal
# We can then use maximun likelihood estimation to optimize the parameters

# For additive errors: Equivalent to minimizing SSE
# Choose the best modle by minimizing a corrected version
# of AIC
# Using: ets()

# To produce the model
ets(ausair)

# To predict 
ausair %>%
  ets() %>%
  forecast() %>%
  autoplot()


ets(h02)

h02 %>%
  ets() %>%
  forecast() %>%
  autoplot()

h02 %>%
  ets() %>%
  forecast() %>%
  checkresiduals()


# Fit ETS model to austa in fitaus
fitaus <- ets(austa)

# Check residuals
checkresiduals(fitaus)

# Plot forecasts
autoplot(forecast(fitaus))

# Repeat for hyndsight data in fiths
fiths <- ets(hyndsight)
checkresiduals(fiths)
autoplot(forecast(fiths))


# Which model(s) fails test? (TRUE or FALSE)
fitausfail <- FALSE
fithsfail <- TRUE


data(cement)

# Function to return ETS forecasts
fets <- function(y, h) {
  forecast(ets(y), h = h)
}

# The second argument for tsCV() must return a forecast object,
# so it is needed a function to fit a model
# Apply tsCV() for both methods
#e1 <- tsCV(cement, fets, h = 4)
#e2 <- tsCV(cement, snaive, h = 4)

# Compute MSE of resulting errors (watch out for missing values)
#mean(e1^2, na.rm = TRUE)
#mean(e2^2, na.rm = TRUE)

# Copy the best forecast MSE
#bestmse <- mean(e2^2, na.rm = TRUE)


# Plot the lynx series
autoplot(lynx)

# Use ets() to model the lynx series
fit <- ets(lynx)

# Use summary() to look at model and parameters
summary(fit)

# Plot 20-year forecasts of the lynx series
fit %>% forecast(h = 20) %>% autoplot()
