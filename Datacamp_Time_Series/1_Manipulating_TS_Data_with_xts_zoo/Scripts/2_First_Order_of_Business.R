# Time based queries ====
# xts support ISO 8601:2004
# Representations:
# One and two sided intervals: "2004" & "2001/2015"
# Time support: "2014-02-22 08:30:00"
# Repeating intervals "T08:00/T09:00"

# For one&two sided intervals:
# data(edhec, package= "PerformanceAnalytics")
# Extracting:
# head(edhec["2007-01",1])
# head(edhec["2007-01/2007-03",1])

# For truncated dates:
# head(edhec["200701/03",1])

# For Time support:
#formatiday["20160808T2213"]

# For Repeating intraday intervals
# iday["T05:30/T06:30"]

# ex
# Select all of 2016 from x
#x_2016 <- x["2016"]

# Select January 1, 2016 to March 22, 2016
#jan_march <- x["20160101/20160322"]

# Verify that jan_march contains 82 rows
#82 == length(jan_march)

# Alternative extraction techniques:
# Interger Indexing> x[c(1,2,3),]
# Logical Vectors> x[index(x) > "2016-08-20"] --- for external criteria
# Using Date objects (Date,POSIXct, etc)> 
#     dates <- as.POSIXct(c("2016-06-25","2016-06-27"))
#     x[dates]


# Modifying TS ====
# Same flexibility as subsetting> ISO 8601, int, logicals, and date objects
# which.i = TRUE  -- CREATES AN INT VECTOR CORRESPONDIG TO TIMES
# index <- x["2007-06-26/2007-06-28", which.i = T]

# Subset x using the vector dates
# x[dates]

# Subset x using dates as POSIXct
# x[as.POSIXct(dates)]


# Finding times of interes ====
# R uses head() and tail() to look at the start or end of series
# xts implemts 2 similar functions 
#   Uses a flexible notion of time
#   i.e "last 3 days" or "first 6 weeks"
#   first() and last() functions

# last(edhec[,"Funds of Funds"], "1 year")
# first(edhec[, "Funds of Funds"], "4 months")

# n can also be an int
# first(x, n = 1, keep=F)
# last(x, n=1, keep=F)

# The first 5M of the 2nd to last calendar year in edhec
# first(last(edhec[,"Merger Arbitrage"], "2 years"), "5 months")

library(xts)
library(zoo)

# Create lastweek using the last 1 week of temps
#lastweek <- last(Temps, "1 week")

# Print the last 2 observations in lastweek
#last(lastweek, 2)

# Extract all but the first two days of lastweek
#first(lastweek, "-2 days")

# Last 3 days of first week
#last(first(Temps, '1 week'), '3 days') 
# Extract the first three days of the second week of temps
#first(last(first(temps, "2 weeks"), "1 week"), "3 days")


# Math operations using xts ====
# xts is naturally a matrix
# Math opeartions are on the intersection of times
#   Only these intersections will be used
# Sometimes it is necessary to drop the xts class
#   arguments> drop = T, coredata(), or as.numeric()
# Special handling required for union of dates
#   Out of the box ops(+,-,*,/)
#   Operations on the union>
#     x_union <- merge(x, index(y), fill = 0)
#     y_union <- merge(y, index(x), fill = 0)

# Add a and b
#a+b

# Add a with the numeric value of b
#a + as.numeric(b)

# Add a to b, and fill all missing rows of b with 0
#a + merge(b, index(a), fill = 0)

# Add a to b and fill NAs with the last observation
#a + merge(b, index(a), fill = na.locf)