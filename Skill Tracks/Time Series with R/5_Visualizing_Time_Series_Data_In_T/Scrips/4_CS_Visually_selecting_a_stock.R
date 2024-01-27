library(readr)
library(dplyr)
library(xts)
library(PerformanceAnalytics)
library(quantmod)
library(corrplot)

data <- read_csv("Data/data_4_1.csv")

data <- as.xts(data [, -1], order.by = data$Index)

# Plot the portfolio value
plot(data$value, main = "Portfolio Value")

# Plot the portfolio return
plot(data$return, main = "Portfolio Return")

# Plot a histogram of portfolio return 
hist(data$return,
     probability = TRUE)

# Add a density line
lines(density(data$return),
      lwd = 2,
      col = "red")


data <- read_csv("Data/data_4_3.csv")
data <- as.xts(data [, -1], order.by = data$Index)

# Plot the four stocks on the same graphical window
par(mfrow = c(2, 2),
    mex = 0.8,
    cex = 0.8)
plot(data$GS)
plot(data$KO)
plot(data$DIS)
plot(data$CAT)


library(TTR)
portfolio <- read_csv("Data/old.vs.new.portfolio.csv")

portfolio <- as.xts(portfolio [, -1], order.by = portfolio$Index)
gs <- ROC(coredata(data$GS))
gs <- gs[-1]
ko <- ROC(coredata(data$KO))
ko <- ko[-1]
dis <- ROC(coredata(data$DIS))
dis <- dis[-1]
cat <- ROC(coredata(data$CAT))
cat <- cat[-1]

# Draw the scatterplot of gs against the portfolio
plot(x = gs, y = portfolio$return)

# Add a regression line in red
abline(reg = lm(gs ~portfolio$return),
       col = "red",
       lwd = 2)

# Plot scatterplots and regression lines to a 2x2 window
par(mfrow = c(2, 2))


plot(x = gs, y = portfolio$return)
abline(reg = lm(gs ~ portfolio$return),
       col = "red",
       lwd = 2)


plot(x = ko, y = portfolio$return)
abline(reg = lm(ko ~ portfolio$return),
       col = "red",
       lwd = 2)


plot(x = dis, y = portfolio$return)
abline(reg = lm(dis ~ portfolio$return),
       col = "red",
       lwd = 2)


plot(x = cat, y = portfolio$return)
abline(reg = lm(cat ~ portfolio$return),
       col = "red",
       lwd = 2)

# Plot new and old portfolio values on same chart
old.vs.new.portfolio <- read_csv("Data/old.vs.new.portfolio.csv")

old.vs.new.portfolio <- as.xts(old.vs.new.portfolio [, -1], order.by = old.vs.new.portfolio$Index)

# Plot new and old portfolio values on same chart
par(mfrow = c(1,1))
plot(old.vs.new.portfolio$old.portfolio.value)
lines(old.vs.new.portfolio$new.portfolio.value, col = "red")

# Plot density of the new and old portfolio returns on same chart
plot(density(old.vs.new.portfolio$old.portfolio.rtn))
lines(density(old.vs.new.portfolio$new.portfolio.rtn), col = "red")



# Draw value, return, drawdowns of old portfolio
charts.PerformanceSummary(old.vs.new.portfolio$old.portfolio.rtn)

# Draw value, return, drawdowns of new portfolio
charts.PerformanceSummary(old.vs.new.portfolio$new.portfolio.rtn)

# Draw both portfolios on same chart
charts.PerformanceSummary(old.vs.new.portfolio[, c(3, 4)])

