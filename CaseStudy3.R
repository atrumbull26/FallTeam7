rm(list=ls())
library(MASS)
library(ISLR)
library(tidyverse)
library(lmtest)
library(car)
library(ggfortify)
library(semTools)
library(broom)
library(dplyr)

shapiro_test_for_column <- function(column) {
  shapiro_test_result <- shapiro.test(column)
  return(c(
    "Statistic" = shapiro_test_result$statistic,
    "P-value" = shapiro_test_result$p.value
  ))
}


data = read_csv("Case3.csv")
data = na.omit(data)


ggplot(data, aes(`GarageArea`, SalePrice)) + geom_point()

cols <- data %>% select_if(function(col) is.logical(col) | is.numeric(col)); cols
correlations <- cor(cols, cols$SalePrice)
correlations

hist(data$SalePrice)
hist(log(data$SalePrice))

lmLin <- lm(log(SalePrice)~log(LotArea)+OverallQual+TotalBsmtSF+`1stFlrSF`+GrLivArea+GarageCars+GarageArea+HouseStyle+FullBath, data=data)
summary(lmLin)
autoplot(lmLin)
#614, 398, 969

bptest(lmLin)
hist(lmLin$residuals)

modellmAuto <- augment(lmLin) %>% mutate(index=1:n())
ggplot(modellmAuto, aes(index, .std.resid)) + geom_point()
subset(modellmAuto$index, abs(modellmAuto$.std.resid)>3)
#297  347  398  510  518  614  694  791  882  969  988 1069

vif(lmLin)


newdata = data[-c(398, 614, 969),]

ggplot(newdata, aes(`HouseStyle`, log(SalePrice))) + geom_point()

lmLin2 <- lm(log(SalePrice)~log(LotArea)+OverallQual+TotalBsmtSF+`1stFlrSF`+GrLivArea+GarageCars+GarageArea+HouseStyle+FullBath, data=newdata)
summary(lmLin2)
autoplot(lmLin2)

bptest(lmLin2)
hist(lmLin2$residuals)

modellmAuto2 <- augment(lmLin2) %>% mutate(index=1:n())
ggplot(modellmAuto2, aes(index, .hat)) + geom_point()
ggplot(modellmAuto2, aes(.cooksd, .hat, label=index)) + geom_point() + geom_text()


ggplot(modellmAuto2, aes(index, .resid)) + geom_line()
dwtest(lmLin) 
bgtest(lmLin)
