# TSA - Lab1

install.packages("TSA")

require(TSA)
library(forecast)
install.packages("fpp")
library(fpp)
lab1data = read.csv("lab1.csv", header=TRUE)

names(lab1data)

summary(lab1data)

# Plot
plot(lab1data[,3], type="l")

# Difference
series1diff = diff(lab1data[,1], lag=1)

# ACF / PACF
par(mfrow=c(2,1)) # par sets plotting options; here we set 2 plots
acf(lab1data[,2])
pacf(lab1data[,2])

# Removal of linear trend for series 4
tt=1:nrow(lab1data)
TC=lm(lab1data[,4]~tt)


############################################################################

require(TSA)

# Exercise1

# Plot of series 1 - Weakly stationary? / Why?
par(mfrow=c(1,1))
plot(lab1data[,1], type="l")
Box.test(lab1data[,1], lag=20, type='Ljung-Box')
adf.test(lab1data[,1], alternative = "stationary")
kpss.test(lab1data[,1])

# Exercise2

# Plot series 2 and series 3
plot(lab1data[,2], type="l")
plot(lab1data[,3], type="l")

# ACF / PACF - Series 2
par(mfrow=c(2,1)) 
acf(lab1data[,2])
pacf(lab1data[,2])

# ACF / PACF - Series 3
par(mfrow=c(2,1)) 
acf(lab1data[,3])
pacf(lab1data[,3])

# Exercise3

# Plot - Series 4, 5, 6 - Linear trend?
par(mfrow=c(3,1))
plot(lab1data[,4], type="l")
plot(lab1data[,5], type="l")
plot(lab1data[,6], type="l")

# Exercise4

# Difference each series (4,5,6) once - linear or did it just require differencing?
series4diff = diff(lab1data[,4], lag=1)
series5diff = diff(lab1data[,5], lag=1)
series6diff = diff(lab1data[,6], lag=1)

# Plot of diff versions
par(mfrow=c(3,1))
plot(series4diff, type="l")
plot(series5diff, type="l")
plot(series6diff, type="l")

# Exercise5

# Removal of linear trend from series 4 - what does this tell us?
tt=1:nrow(lab1data)
TC=lm(lab1data[,4]~tt)
plot(TC)
plot(resid(TC), type='o', main="Detrended")






