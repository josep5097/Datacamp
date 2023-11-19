# Apply functions by time ====
#   One discrete periods or intervals
#   Two main approaches: period.apply(), split()
#     period.apply(x, INDEX, FUN, ...)
#       x, object
#       INDEX, end points of a period
#       FUN, function to apply

#     Define endpoints: endpoints(x, on="years")
#       Intervals: "days", "years", "quarters", etc

library(xts)
library(zoo)
library(PerformanceAnalytics)

edhec_4yr <- edhec["1997/2001"]
ep <- endpoints(edhec_4yr, "years")
mean_ed <- period.apply(edhec_4yr, INDEX=ep, FUN=mean)

# Shortcut funct:apply.monthly(), apply.yeaerly(), apply.quarterly()

# split.xts:
#   Split data into chunks of time
#   Control for discrete periods
#   Uses standard period names
library(readr)
temps <- read.csv("Data/temps.csv")
temps <- as.xts(temps)

# The arg on supports a variety of periods, as well
# as intraday intervals such as "hours" and "minutes"
# We can find the Kth period by utilizing the k arg

# Locate the weeks
endpoints(temps, on = "weeks")

# Locate every two weeks
endpoints(temps, on = "weeks", k = 2)

# Calculate the weekly endpoints
ep <- endpoints(temps, on = "weeks")

# Now calculate the weekly mean and display the results
period.apply(temps[, "Temp.Mean"], INDEX = ep, FUN = mean)

# Usinglapply() and split to apply functions on intervals ====
# Split the data into disjoint chunks by time

# Split temps by week
temps_weekly <- split(temps, f = "weeks")

# Create a list of weekly means, temps_avg, and print this list
temps_avg <- lapply(X = temps_weekly, 
                    FUN = mean)
temps_avg


# Use the proper combination of split, lapply and rbind
temps_1 <- do.call(rbind, 
                   lapply(split(temps, 
                                "weeks"), 
                          function(w) last(w, 
                                           n = "1 day")))

# Create last_day_of_weeks using endpoints()
last_day_of_weeks <- endpoints(temps, "weeks")

# Subset temps using last_day_of_weeks 
temps_2 <- temps[last_day_of_weeks]


# Converting periodicity ====
# Time series aggregation 
#   Convert a univariate series to range bars
#    OHLC: Open, High, Low, and Close
#   Summary of a particular period
#    Starting, minimum, maximum, and ending value.

# to.period(x, period= "months", k=1)
#   period, controls a aggregation period
#   name, strin renames column roots
#   indexAt,allow for index aligment

to.period(edhec["1997/2001",1], "years", name = "EDHEC")
to.period(edhec["1997/2001",1], "years", name = "EDHEC", indexAt = "firsof")

# Aggregate without range bars
#  force a univariate series in to.period()
to.period(edhec[,1], period = "years", name = "EDHEC", OHLC = F)

# extract directly
edhec[endpoints(edhec, "years"),1]


usd_eur <- read.csv("Data/usd_eur.csv")
usd_eur <- as.xts(usd_eur)


# Convert univariate series to OHLC data ====

# Convert usd_eur to weekly and assign to usd_eur_weekly
usd_eur_weekly <- to.period(usd_eur, period = "weeks")

# Convert usd_eur to monthly and assign to usd_eur_monthly
usd_eur_monthly <- to.period(usd_eur, period = "months")

# Convert usd_eur to yearly univariate and assign to usd_eur_yearly
usd_eur_yearly <- to.period(usd_eur, period = "years", OHLC = FALSE)


# Convert a series to a lower freq ====
# to.period() also lets you convert OHLC to lower regularized
# frequency - something like subsampling your data.
eq_mkt <- edhec[, "Equity Market Neutral"]
dim(eq_mkt)

# Convert eq_mkt to quarterly OHLC
mkt_quarterly <- to.period(eq_mkt, period = "quarters")

# Convert eq_mkt to quarterly using shortcut function
mkt_quarterly2 <- to.quarterly(eq_mkt, name = "edhec_equity", indexAt = "firstof")

# rolling Functions ====
# Rolling windows:
#   Discrete> lapply(), split()
#   Continuous> rollapply()

# For Discrete rolling windows:
#   split(), to break up by periods
#   lapply(), cumulative functions --> cumulative sum, cumulative max value
#     cumsum(), cumprod(), cummin(), cummax()

x <- xts(c(1,2,3), 
         as.Date("2016-01-01")+0:2)

cbind(x, cumsum(x))

edhec.yrs <- split(edhec[,1], f = "years")
edhec.yrs <- lapply(edhec, cumsum)
edhec.ytd <- do.call(rbind, edhec.yrs)

cbind(edhec.ytd,
      edhec[,1])["2007-10/2008-03"]
# Continuous rolling windows
rollapply(edhec["200701/08", 1],
          3,
          mean)

# Calculate basic rolling value of series by month ====
# Split edhec into years
edhec_years <- split(edhec , f = "years")

# Use lapply to calculate the cumsum for each year in edhec_years
edhec_ytd <- lapply(edhec_years, FUN = cumsum)

# Use do.call to rbind the results
edhec_xts <- do.call(rbind, edhec_ytd)
# Calculate the rolling standard deviation of a time series ====
# Use rollapply to calculate the rolling 3 period sd of eq_mkt
eq_sd <- rollapply(eq_mkt, width=3, FUN = sd)
