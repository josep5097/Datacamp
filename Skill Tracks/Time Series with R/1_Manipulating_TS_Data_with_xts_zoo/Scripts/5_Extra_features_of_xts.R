# Index, attributes, and time zones ====
# * tclass or indexClass: Attribute for extraction
# * tzone or indexTZ: Attribute for time zones
# * indexFormat: optinonal display preferences
library(xts)
library(PerformanceAnalytics)

temp <- read.csv("Data/temps.csv")
temps <- as.xts(temp)

indexClass(temps)
indexTZ(temps)
indexFormat(temps) <- "%b %d, %Y"
temps

# Change the format of the time display
indexFormat(temps) <- "%b-%d-%Y"

# Time Zones ====
# Construct times_xts with tzone set to America/Chicago
times_xts <- xts(1:10, order.by = times, tzone = "America/Chicago")

# Change the time zone of times_xts to Asia/Hong_Kong
tzone(times_xts) <- "Asia/Hong_Kong"

# Extract the current time zone of times_xts
indexTZ(times_xts)

# Periods, periodicity and timestamps ====
# Find the time an object covers
# Find periods within your object
# Account for duplicates and false precision

# periodicity()
#   Identifies the regularity of data
#   Answers what type of data is present
#   Less useful for irregular timestamps
#   Summary measure for the index
periodicity(edhec)
periodicity(to.yearly(edhec))

# Counting periods
#   Estimate number of periods
#   Irregular series equals irregular counting
#   Counts periods greater than periodicity
#   nseconds(x), nmminutes(x), nhours(x), ... days, weeks, months, quarters, years
ndays(edhec)
nweeks(edhec)
nyears(edhec)

# Time expressed as POSIXit components:
#   sec, min, hour, mday, mon, year, wday, ydar, isdst

# Modifying timestamps 
# Use align.time() to round time stamps to another period
align.time(temps, n=60) # n is in seconds

# Useful to remove observations of duplicate timestamps
make.index.unique(temps)

# Find the number of periods in your data ====
# Count the months
nmonths(edhec)

# Count the quarters
nquarters(edhec)

# Count the years
nyears(edhec)

# Secret index tools ====
# Explore underlying units of temps in two commands: .index() and .indexwday()
.index(temps)
.indexwday(temps)


# Create an index of weekend days using which()
index <- which(.indexwday(temps) == 0 | .indexwday(temps) == 6)

# Select the index
temps[index]

# Modifying timestamps ====
# Make z have unique timestamps
z_unique <- make.index.unique(z, eps = 1e-4)

# Remove duplicate times in z
z_dup <- make.index.unique(z, drop = TRUE)

# Round observations in z to the next hour
z_round <- align.time(z, n = 3600)
