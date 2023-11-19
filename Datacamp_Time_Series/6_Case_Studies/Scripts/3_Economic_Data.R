
library(xts)
library(zoo)

gdp <- readRDS("Data/us_gdp.RData")

# Get a summary of your GDP data
summary(gdp)

# Convert GDP date column to time object
gdp$date <- as.yearqtr(gdp$date)

# Convert GDP data to xts
gdp_xts <- as.xts(gdp[, -1], order.by = gdp$date)

# Plot GDP data over time
plot.xts(gdp_xts)

# Fill NAs in gdp_xts with the last observation carried forward
gdp_locf <- na.locf(gdp_xts)

# Fill NAs in gdp_xts with the next observation carried backward 
gdp_nocb <- na.locf(gdp_xts, fromLast = TRUE)

# Produce a plot for each of your new xts objects
par(mfrow = c(2,1))
plot.xts(gdp_locf, major.format = "%Y")
plot.xts(gdp_nocb, major.format = "%Y")


# Query for GDP in 1993 in both gdp_locf and gdp_nocb
gdp_locf["1993"]
gdp_nocb["1993"]


# Fill NAs in gdp_xts using linear approximation
gdp_approx <- na.approx(gdp_xts)

# Plot your new xts object
par(mfrow = c(1,1))
plot.xts(gdp_approx, major.format = "%Y")

# Query for GDP in 1993 in gdp_approx
gdp_approx["1993"]



unemployment <- readRDS("Data/unemployment.RData")

# View a summary of your unemployment data
summary(unemployment)

# Use na.approx to remove missing values in unemployment data
unemployment <- na.approx(unemployment)

# Plot new unemployment data
lty <- c(1, 2)
labels <- c("US Unemployment (%)", "MA Unemployemnt (%)")
plot.zoo(unemployment, plot.type = "single", lty = lty)
legend("topright", lty = lty, legend = labels, bg = "white")


# Create a one month lag of US unemployment
us_monthlag <- lag(unemployment$us, k = "1")

# Create a one year lag of US unemployment
us_yearlag <- lag(unemployment$us, k = "12")

# Merge your original data with your new lags 
unemployment_lags <- merge(unemployment, us_monthlag, us_yearlag)

# View the first 15 rows of unemployment_lags
head(unemployment_lags, 15)

# Generate monthly difference in unemployment
unemployment$us_monthlydiff <- diff(unemployment$us, lag = 1, differences = 1)

# Generate yearly difference in unemployment
unemployment$us_yearlydiff <- diff(unemployment$us, lag = 12, differences = 1)

# Plot US unemployment and annual difference
par(mfrow = c(2,1))
plot.xts(unemployment$us)
plot.xts(unemployment$us_yearlydiff, type = "h")
par(mfrow = c(1,1))

gdp <- gdp_approx
gdp <- setNames(gdp, "gdp")

# Add a quarterly difference in gdp
gdp$quarterly_diff <- diff(gdp$gdp , lag = 1, differences = 1)

# Split gdp$quarterly_diff into years
gdpchange_years <- split(gdp$quarterly_diff, f = "years")

# Use lapply to calculate the cumsum each year
gdpchange_ytd <- lapply(gdpchange_years, FUN = cumsum)

# Use do.call to rbind the results
gdpchange_xts <- do.call(rbind, gdpchange_ytd)

# Plot cumulative year-to-date change in GDP
plot.xts(gdpchange_xts, type = "h")


lwd <- c(1, 2)
lty <- c(2, 1)
# Use rollapply to calculate the rolling yearly average US unemployment
unemployment$year_avg <- rollapply(unemployment$us, width = 12, FUN = mean)

# Plot all columns of US unemployment data
plot.zoo(unemployment[, c("us", "year_avg")], plot.type = "single", lty = lty, lwd = lwd)

# Add a one-year lag of MA unemployment
unemployment$ma_yearlag <- lag(unemployment$ma, k = "12")

# Add a six-month difference of MA unemployment
unemployment$ma_sixmonthdiff <- diff(unemployment$ma, lag = 6, differences = 1)

# Add a six-month rolling average of MA unemployment
unemployment$ma_sixmonthavg <- rollapply(unemployment$ma, width = 6, FUN = mean)

# Add a yearly rolling maximum of MA unemployment
unemployment$ma_yearmax <- rollapply(unemployment$ma, width = 12, FUN = max)

# View the last year of unemployment data
tail(unemployment, 12)

