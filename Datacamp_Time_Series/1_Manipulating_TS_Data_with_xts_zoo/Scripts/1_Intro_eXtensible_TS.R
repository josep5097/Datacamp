library(xts)
library(zoo)


# First xts object ====
# xts objects are simple -> Matrix of observations combined
# with an index of corresponding dates and times.

# Create the object data using 5 random numbers
data <- rnorm(5)

# Create dates as a Date class object starting from 2016-01-01
dates <- seq(as.Date("2016-01-01"), 
             length = 5, 
             by = "days")

# Use xts() to create smith
smith <- xts(x = data, 
             order.by = dates)

# Create bday (1899-05-08) using a POSIXct date class object
bday <- as.POSIXct("1899-05-08")

# Create hayek and add a new attribute called born
hayek <- xts(x = data, 
             order.by = dates, 
             born = bday)


# Deconstructing xts ====
# Extract the core data of hayek
hayek_core <- coredata(hayek)

# View the class of hayek_core
class(hayek_core)

# Extract the index of hayek
hayek_index <- index(hayek)

# View the class of hayek_index
class(hayek_index)

# Time based indices ====
# Whether POSIXct, Date, or some other class, 
# xts will convert this into an internal form to 
# make subsetting as natural to the user as possible.

# Create dates
dates <- as.Date("2016-01-01") + 0:4

# Create ts_a
ts_a <- xts(x = 1:5, order.by = dates)

# Create ts_b
ts_b <- xts(x = 1:5, order.by = as.POSIXct(dates))

# Extract the rows of ts_a using the index of ts_b
ts_a[index(ts_a)]

# Extract the rows of ts_b using the index of ts_a
ts_a[index(ts_b)]

# Importing, exporting and converting TS ====
data(sunspots)

sunspots_xts <- as.xts(sunspots)
class(sunspots_xts)

head(sunspots_xts)

## Importing external data to xts ====
# read.table, read.csv and read.zoo
# as.xts(read.table("file"))
# as.xts(read.zoo("file"))

## Exporting xts from R ====
# write.zoo(x, "file")

# Convert austres to an xts object called au
au <- as.xts(austres)

# Then convert your xts object (au) into a matrix am
am <- as.matrix(au)

# Inspect the head of am
head(am)

# Convert the original austres into a matrix am2
am2 <- as.matrix(austres)

# Inspect the head of am2
head(am2)


tmp_file <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1127/datasets/tmp_file.csv"

# Create dat by reading tmp_file
dat <- read.csv(tmp_file)

# Convert dat into xts
xts(dat, order.by = as.Date(rownames(dat), "%m/%d/%Y"))

# Read tmp_file using read.zoo
dat_zoo <- read.zoo(tmp_file, index.column = 0, sep = ",", format = "%m/%d/%Y")

# Convert dat_zoo to xts
dat_xts <- as.xts(dat_zoo)



# Convert sunspots to xts using as.xts().
sunspots_xts <- as.xts(sunspots)

# Get the temporary file name
tmp <- tempfile()

# Write the xts object using zoo to tmp 
write.zoo(sunspots_xts, sep = ",", file = tmp)

# Read the tmp file. FUN = as.yearmon converts strings such as Jan 1749 into a proper time class
sun <- read.zoo(tmp, sep = ",", FUN = as.yearmon)

# Convert sun into xts. Save this as sun_xts
sun_xts <- as.xts(sun)