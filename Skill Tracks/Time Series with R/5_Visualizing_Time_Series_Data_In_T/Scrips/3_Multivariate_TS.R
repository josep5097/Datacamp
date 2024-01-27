library(readr)
library(dplyr)
library(xts)
library(PerformanceAnalytics)
library(quantmod)
library(corrplot)

startDate <- as.Date("2016-01-01")
endDate <- as.Date("2016-12-01")
date <- seq.Date(startDate, endDate, by = "month")
portfolio <- matrix(c(0.1, 0.4, 0.5, 0.5, 0.2, 0.3, 0.7, 0.8, 0.7, 0.2, 
                      0.1, 0.2, 0.9, 0.6, 0.5, 0.5, 0.8, 0.7, 0.3, 0.2, 0.3, 0.8, 0.9, 
                      0.8),
                    ncol = 2)
colnames(portfolio) <- c("stocka", "stockb")
portfolio <- xts(portfolio, order.by = date)
portfolio

par(mfrow = c(1 , 1))
# Plot stacked barplot
barplot(portfolio)

# Plot grouped barplot
barplot(portfolio,
        beside = TRUE)

my_data <- read_csv("Data/data_3_2.csv")
#my_data$index <- as.Date(my_data$index)
my_data <- as.xts(my_data [, -1], order.by = my_data$Index)

# Create correlation matrix using Pearson method
cor(my_data, method = "pearson")

# Create correlation matrix using Spearman method
cor(my_data, method = "spearman")                    


# Create scatterplot matrix
pairs(coredata(my_data))
# Create upper panel scatterplot matrix
pairs(coredata(my_data), lower.panel = NULL)


cor_mat <- cor(my_data, method = "pearson")

# Create correlation matrix
corrplot(cor_mat)

# Create correlation matrix with numbers
corrplot(cor_mat, method = "number")

# Create correlation matrix with colors
corrplot(cor_mat, method = "color")

# Create upper triangle correlation matrix
corrplot(cor_mat, method = "number", type = "upper")



# Draw heatmap of cor_mat
corrplot(cor_mat, method = "color")

# Draw upper heatmap
corrplot(cor_mat, method = "color", type = "upper")

# Draw the upper heatmap with hclust
corrplot(cor_mat, method = "color", type = "upper", order = "hclust")

