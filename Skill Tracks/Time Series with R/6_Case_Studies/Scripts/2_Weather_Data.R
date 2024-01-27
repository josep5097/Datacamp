# Merging ====
# When the information is added using rbind(), this is
# ordered by time!

temps_xts <- readRDS("Data/temps_monthly.RData")

wind <- readRDS("Data/wind.RData")

vis <- readRDS("Data/vis.RData")

# Confirm the periodicity and duration of the vis and wind data
periodicity(vis)

periodicity(wind)

# Merge vis and wind with your existing flights_temps data
flights_weather <- merge( temps_xts, vis, wind)

# View the first few rows of your flights_weather data
head(flights_weather)

plot.xts(flights_weather)

lty <-  c(1, 2, 3)
labels <- c("Percent Delay", "Wind", "Visibility")
plot.zoo(flights_weather[,c( "temps_xts", "wind", "vis")], plot.type = "multiple", lty = lty, xlab = "Year", ylab = labels)
