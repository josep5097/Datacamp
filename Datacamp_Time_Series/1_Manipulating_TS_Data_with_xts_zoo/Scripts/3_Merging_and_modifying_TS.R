# Merging TS ====
# Combine series by coolumn
#   cbind() and merge()
# xts supports inner, outer, lef and right joins
# merge(..., fill=NA, join="outer")
# merge(x,y) # outer by default
# merge(x,y, join="inner")
# merge(x,y, join="right", fill = na.locf)

# Handling Missingness ====
# l.o.c.f means "last observations carried forward"
# na.locf(object, na.rm = T,
#         fromLast = F, maxgap = Inf)
# na.fill(object, fill, ...)
# na.trim(object, ...)
# na.omit(object, ...)
# na.approx(object) # Linear interpolation between obs based on the distance between time stamps


# Fill missing values in temps using the last observation
# temps_last <- na.locf(temps)  

# Fill missing values in temps using the next observation
# temps_next <- na.locf(temps, fromLast=TRUE)

# Interpolate NAs using linear approximation
#na.approx(AirPass)


# Lags and differences ====
# Seasonality and Stationarity
# Seasonality is a repeating pattern
# Stationarity refers to some bound of the series

# These patterns are often compared
# lag() will shift obs in time
# lag(x, k=1, na.pad=T)
# k .. number of lags
# na.pad controls NA introduction
# with xts, positive k shift values forward
# neg value shift backward

# Differencing series
# diff(x, lag = 1, differences = 1, arithmetic = T, lag = F, na.pad =T)

# Create a leading object called lead_x
#lead_x <- lag(x, k = -1)

# Create a lagging object called lag_x
#lag_x <- lag(x, k = 1)

# Merge your three series together and assign to z
#z = cbind(lead_x, x, lag_x)

# Calculate the first difference of AirPass and assign to diff_by_hand
#diff_by_hand <- AirPass - lag(AirPass, k=1)

# Use merge to compare the first parts of diff_by_hand and diff(AirPass)
#merge(head(diff_by_hand), head(diff(AirPass)))

# Calculate the first order 12 month difference of AirPass
#diff(AirPass, lag = 12, differences = 1)