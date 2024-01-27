# Forecasts and potential futures
# Forecast intervals:
# 80% forecast intervals should contain 80% of future obs
# 95% forecast intervals should contain 95% of future obs

# A forecast is the mean or median of simulated futures of a TS
# The simpliest method: The most recent observation, this method
# is known as naive forecast.
# This is the best that can be done for many TS, this can be useful
# benchmark for other forecasting methods.

# For seasonal data, if you want to forecast the sales volume for next 
# March, you would use the sales volumne form the previous March.
#     This is implement with snaive()
#     snaive(y, h = 2 * frequency(x))

library(ggfortify)
library(forecast) # has the three series: gold, woolyrnq, and gas
library(ggplot2)
library(fpp2) # datasets: a10, ausbeer

# Use naive() to forecast the goog series
fcgoog <- naive(goog, h = 20)

# Plot and summarize the forecasts
autoplot(fcgoog)
summary(fcgoog)

# Use snaive() to forecast the ausbeer series
fcbeer <- snaive(ausbeer, h = 16)

# Plot and summarize the forecasts
autoplot(fcbeer)
summary(fcbeer)

# Fitted Values and residuals ====
# One way to check if our forecasting method is good, a good way
# is to try forecast what we have already seen

# One-step-ahead forecasts of the data already seen are called "fitted values"
# A fitted value is the forecast of an observation using all previous observations

# A residual is the difference between an observation and its fitted value

# If our forecasting method is good, the residual should look like WN

fc <- naive(oil)

autoplot(oil, series = "Data")+xlab("Year")+
  autolayer(fitted(fc), series = "Fitted")+
  ggtitle("Oil production in SA")


# Essential Assumptions ====
#   They should be uncorrelated
#   They should have mean zero
#   They should have constant variance
#   They should be normally distributed
# We can test these assumptions using: checkresiduals()

checkresiduals(fc)
# p-value is abouve 0.05, so there is no problem with the autocorrelation
# They look like WN.

# Checking time series residuals ====
# When applying a forecasting method is important to always check
# the residuals -- No outliers or patterns
# The pred intervals are computed assuming that the residuals are also
# normally distributed.
# checkresiduals() will give the result of Ljung-Box test

# Check the residuals from the naive forecasts applied to the goog series
goog %>% naive() %>% checkresiduals()

# Do they look like white noise (TRUE or FALSE)
googwn <- TRUE

# Check the residuals from the seasonal naive forecasts applied to the ausbeer series
ausbeer %>% 
  snaive() %>% 
  checkresiduals()

# Do they look like white noise (TRUE or FALSE)
beerwn <- FALSE

# Training and test sets ====
training <- window(oil, end = 2003)
test <- window(oil, start = 2004)
fc <- naive(training, h = 10)
autoplot(fc)+
  autolayer(test, series = "Test Data")

# Forecast errors ====
# Forecast "error" = the difference between observed value and its
# forecast in the test set
# This is different than residuals

# Residuals are on the training set, while forecast errors are
# on the test set
# Residuals are based on one-steo forecast, while forecast errors can be from
# any forecast horizon

# We compute the accuracy of our method using the forecast errors calculated
# on the test data

# Measures of forecast Accuracy
# observation: Y_t
# forcast: Y_t^
# Forecast error: e_t = Y_t - Y_t^

# Accuray measure                 Calculation
# Mean absolute error             MAE == avg(|e_t)
# Mean squared error              MSE == avg((e_t)^2)
# Mean absolute percentage error  MAPE == 100*(avg(e_t/y_t))
# Mean absolute scaled error      MASE == MAE/Q, Q is the scaling constant

# You cant compare two series with MAE or MSE, because their size depends on the scale of the data
# MAPE is better for camparisons, but only if our data are all positive, and have no zeros or
# small values

# The solution is to use the MASE

# In all cases, a small value indicates a better forecast
# The accuracy command computes all of these measures and few others

# Evaluating forecast accuracy of non seasonal methods ====
# One way to create training and test sets is: 
# subset.ts()

# accuracy(f,x)
# f: object forecast
# x: numerical vector or TS

# Create the training data as train
train <- subset(gold, end = 1000)

# Compute naive forecasts and save to naive_fc
naive_fc <- naive(train, h = 108)

# Compute mean forecasts and save to mean_fc
mean_fc <- meanf(train, h = 108)

# Use accuracy() to compute RMSE statistics
accuracy(naive_fc, gold)
accuracy(mean_fc, gold)

# Assign one of the two forecasts as bestforecasts
bestforecasts <- naive_fc

# Evaluationg forecast accuracy of seasonal methods ====
# Create three training series omitting the last 1, 2, and 3 years
train1 <- window(vn[, "Melbourne"], end = c(2014, 4))
train2 <- window(vn[, "Melbourne"], end = c(2013, 4))
train3 <- window(vn[, "Melbourne"], end = c(2012, 4))

# Produce forecasts using snaive()
fc1 <- snaive(train1, h = 4)
fc2 <- snaive(train2, h = 4)
fc3 <- snaive(train3, h = 4)

# Use accuracy() to compare the MAPE of each series
accuracy(fc1, vn[, "Melbourne"])["Test set", "MAPE"]
accuracy(fc2, vn[, "Melbourne"])["Test set", "MAPE"]
accuracy(fc3, vn[, "Melbourne"])["Test set", "MAPE"]

# Time series cross-validation ====
# We have a series of training and test sets
# Forecast evaluation on a rolling origin

# We can use:
# tsCV function
e <- tsCV(oil, forecastfunction = naive, h = 1)
# Is necessary to compute your own error measures when this funct is used
mean(e^2, na.rm = T)
# When there are no parameters to be estimated,
#tsCV with h=1 will give teh same values as residuals.


sq <- function(u){ u^2}
for (h in 1:10){
  oil %>%
    tsCV(forecastfunction = naive,
         h = h) %>%
    sq() %>%
    mean(na.rm = T) %>%
    print()
}



# Compute cross-validated errors for up to 8 steps ahead
e <- tsCV(goog, forecastfunction = naive, h = 8)
plot.ts(e)
# Compute the MSE values and remove missing values
mse <- colMeans(e^2, na.rm = TRUE)
mse
# Plot the MSE values against the forecast horizon
data.frame(h = 1:8, MSE = mse) %>%
  ggplot(aes(x = h, y = MSE)) + geom_point()
