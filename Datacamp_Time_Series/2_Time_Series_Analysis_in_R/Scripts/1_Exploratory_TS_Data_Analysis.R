# Time series data
#   Time series data is dated or time stamped in R
#   print(Time_Series)
# Time series plots
#   plot(Time_Series)
#   Time is indexed on horizontal axis
#   Observations in time from first on left to last on right
#   Line connects neighboring observations
# Basic time series models
#   White Noise (WN)
#   Random Walk (RW)
#   Autoregression (AR)
#   Simple Moving Average (MA)

# Print the Nile dataset
print(Nile)

# List the number of observations in the Nile dataset
length(Nile)

# Display the first 10 elements of the Nile dataset
head(Nile, n = 10)

# Display the last 12 elements of the Nile dataset
tail(Nile, n = 12)

# Basic Time Series Plots ====
# Plot the Nile data
plot(Nile)
# Plot the Nile data with xlab and ylab arguments
plot(Nile, xlab = "Year", ylab = "River Volume (1e9 m^{3})")

# Plot the Nile data with xlab, ylab, main, and type arguments
plot(Nile, xlab = "Year", 
     ylab = "River Volume (1e9 m^{3})", 
     main = "Annual River Nile Volume at Aswan, 1871-1970", 
     type = "b")

# Discrete and Continuous data ====
continuous_time_index <- c(1.210322, 1.746137,  2.889634,  3.591384,  5.462065,  5.510933,  7.074295, 8.264398,  9.373382,
                           9.541063, 11.161122, 12.378371, 13.390559, 14.066280, 15.093547, 15.864515, 16.857413, 18.091457,                            19.365451, 20.180524)

continuous_series <- c(0.56889468, 0.76630408, 0.99207512, 0.97481741, 0.39912320, 0.37660246, -0.38532033, -0.83635852, 
                       -0.99966983, -0.99831019, -0.64622280, -0.09386151, 0.40052909,  0.68160578,  0.95318159,  
                       0.99693803,  0.83934194,  0.37003754, -0.25509676, -0.61743983)

# Plot the continuous_series using continuous time indexing
par(mfrow=c(2,1))
plot(continuous_time_index, continuous_series, type = "b")

# Make a discrete time index using 1:20 
discrete_time_index <- 1:20

# Now plot the continuous_series using discrete time indexing
plot(discrete_time_index, continuous_series, type = "b")

# Sampling Frequency ====

# Sampling frequency

# Basic simplifying assumptions for time series:
#  Consecutive observations are equally spaced
#  Apply discrete-time observation index
#  This may only hold approximatetely
# R functions:
#  start()
#  end()
#  frequency()
#  deltat()

# Plot AirPassengers
par(mfrow=c(1,1))
plot(AirPassengers)
# View the start and end dates of AirPassengers
start(AirPassengers)
end(AirPassengers)

# Use time(), deltat(), frequency(), and cycle() with AirPassengers 
time(AirPassengers)
deltat(AirPassengers)
frequency(AirPassengers)
cycle(AirPassengers)


# Plot the AirPassengers data
plot(AirPassengers, type = "l")
# Compute the mean of AirPassengers
mean(AirPassengers, na.rm = TRUE)

# Impute mean values to NA in AirPassengers
AirPassengers[85:96] <- mean(AirPassengers, na.rm = TRUE)

# Generate another plot of AirPassengers
plot(AirPassengers)

# Add the complete AirPassengers data to your plot
rm(AirPassengers)
points(AirPassengers, 
       type = "l", 
       col = 2, 
       lty = 3)

#Basic time series objects

# Building ts() objects
#   Start with a vector of data
#   Apply the ts() function
#   Specify the start date and observation frequency
#   Time_series <- ts(data_vector, start = 2001, frequency = 1)
# Why ts() objects?
#   Improved plotting
#   Access to time index information
#   Model estimation and forecasting 


data_vector <- c(2.0521941073, 4.2928852797, 3.3294132944, 3.5085950670, 0.0009576938, 
                1.9217186345, 0.7978134128, 0.2999543435,  0.9435687536,  0.5748283388,
                -0.0034005903,  0.3448649176,  2.2229761136,  0.1763144576,  2.7097622770,
                1.2501948965, -0.4007164754,  0.8852732121, -1.5852420266, -2.2829278891,
                -2.5609531290, -3.1259963754, -2.8660295895, -1.7847009207, -1.8894912908,
                -2.7255351194,  -2.1033141800, -0.0174256893, -0.3613204151, -2.9008403327,
                -3.2847440927, -2.8684594718, -1.9505074437, -4.8801892525, -3.2634605353,
                -1.6396062522, -3.3012575840, -2.6331245433, -1.7058354022, -2.2119825061,
                -0.5170595186,  0.0752508095, -0.8406994716, -1.4022683487, -0.1382114230,
                -1.4065954703, -2.3046941055,  1.5073891432, 0.7118679477, -1.1300519022 )

# Use print() and plot() to view data_vector
print(data_vector)
plot(data_vector)

# Convert data_vector to a ts object with start = 2004 and frequency = 4
time_series <- ts(data_vector, start = 2004, frequency = 4)

# Use print() and plot() to view time_series
print(time_series)
plot(time_series)


eu_stocks <- EuStockMarkets

# Check whether eu_stocks is a ts object
is.ts(eu_stocks)
 
# View the start, end, and frequency of eu_stocks
start(eu_stocks)
end(eu_stocks)
frequency(eu_stocks)

# Generate a simple plot of eu_stocks
plot(eu_stocks)

# Use ts.plot with eu_stocks
ts.plot(eu_stocks, 
        col = 1:4, 
        xlab = "Year", 
        ylab = "Index Value", 
        main = "Major European Stock Indices, 1991-1998")

# Add a legend to your ts.plot
legend("topleft", 
       colnames(eu_stocks), 
       lty = 1, 
       col = 1:4, 
       bty = "n")