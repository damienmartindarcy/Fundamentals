# Lab 3 - Decomposition and Forecasting

# Decomposition of air passenger data

library(forecast)
library(tseries)

y=AirPassengers

# Note the ACF
tsdisplay(y)

# ADF to check for unit roots
# We obtain a p-value here of less than 0.01 so we reject the null hypothesis that w = 0 i.e. phi1 = 1.
# Thus there is no unit root and the series does not require differencing to get to stationarity.
adf.test(y)

# We estimate the trend component by smoothing out the seasonal component first
TC=ma(y,12)

# We try to fit a linear model to this 
linear_tc=lm(TC~time(y))

# We get an even clearer picture of the seasonal trend by plotting a detrended timer series
tsdisplay(y~TC)

# Taking the average of the resulting series 
# for corresponding months gives us an estimate of the seasonal component.

pseudo_s = y/TC
matrix_s = matrix(pseudo_s,nrow=12)
s = rowMeans(matrix_s,na.rm=TRUE)
S = rep(s,length(y)/12)

# We centre our seasonal component
S = S/mean(S)

# Finally, we can estimate our random component
R=y/(TC*S)

# We can use decompose()

#################################################################################

# Forecasting

# Extrapolate the trend x seasonal components 2 years ahead
ftime=seq(time(y)[length(y)]+deltat(y),length=24,by=deltat(y)) # future times
d_fy=(linear_tc$coef[1]+linear_tc$coef[2]*ftime)*rep(S[1:12],2)

# Predict 2 years ahead for the random component
fit=Arima(R,order=c(2,0,1))
fy=forecast(fit,h=24)

# Multiply the trend prediction, seasonal prediction, and 
# random prediction mean to get your mean forecast.
msef=d_fy*fy$mean

# Upper and lower 95% CI for the forecast
y.low95=d_fy*fy$lower[,2]
y.high95=d_fy*fy$upper[,2]

# Then plot the forecast
plot(y,xlim=c(time(y)[1],ftime[length(ftime)]),ylim=c(0,700))
lines(ftime, msef, col=4)
polygon(c(ftime, rev(ftime)), c(y.high95, rev(y.low95)),
        col=rgb(0,0,1,alpha=0.1),border=NA)

###############################################################################

library(TSA)
data(beersales)
summary(beersales)

# Exercise 1

x <- ts(beersales, start = c(1975, 1), end = c(1990, 12), frequency = 12)
tsdisplay(beersales)
adf.test(beersales)

# Exercise 2

# Detrend using additive model and decompose()

x <- beersales

#A
TC=ma(x,12)
plot(TC)

#B

x = ts(x, freq = 12).
decompose_x = decompose(x,"additive")

plot(as.ts(decompose_x$seasonal))
plot(as.ts(decompose_x$trend))
plot(as.ts(decompose_x$random))
plot(decompose_x)

# Exercise 3

# Basics
# US monthly electricity production between 1973-2005 
data("electricity")
head(electricity)
y<-electricity
plot(y)

decompose_y = decompose(y, type = "additive")
plot(decompose_y)

#A

fit<-forecast(decompose_y$seasonal+decompose_y$trend, h=24, level=0.95)
plot(fit)

#B
# Plot random component for next 2 years
plot(decompose_y$random)
plot(forecast(decompose_y$random, h=24))

#C
# plot the forecast @ 95% CI
plot(forecast(y, h=24, level=0.95))

#######

# Extrapolate the trend + seasonal components 2 years ahead
ftime=seq(time(y)[length(y)]+deltat(y),length=24,by=deltat(y)) # future times
d_fy=(linear_tc$coef[1]+linear_tc$coef[2]+ftime)*rep(S[1:12],2)
plot(forecast(d_fy, h=24))

# Predict 2 years ahead for the random component
fit=Arima(R,order=c(2,0,1))
fy=forecast(fit,h=24)
plot(fit)
plot(tsrandom(y))



# Then plot the forecast
fcast<-plot(forecast(y, h=24, level=0.95))
autoplot(forecast(y)) +
  ylab="New orders index")
TC=ma(y,12) 
linear_tc=lm(TC~time(y))
tsdisplay(y-TC)


library(TSA)
library(forecast)


###########################################################################

# A test of decomposition and forecasting

install.packages("fpp")
library(fpp)
data("electricity")
y = electricity
plot(as.ts(y))

# Detect the trend

install.packages("forecast")
library(forecast)
trend_y = ma(y, order = 12, centre = T)
plot(as.ts(y))
lines(trend_y)
plot(as.ts(trend_y))

# Now detrend to check seasonality
detrend_y = y - trend_y
plot(as.ts(detrend_y))

# Average seasonality
m_y = t(matrix(data = detrend_y, nrow = 12))
seasonal_y = colMeans(m_y, na.rm = T)
plot(as.ts(rep(seasonal_y,16)))

# Random noise remaining
random_y = y - trend_y - seasonal_y
plot(as.ts(random_y))

# Reconstruct original signal
recomposed_y = trend_y+seasonal_y+random_y
plot(as.ts(recomposed_y))

# Finally - using decompose()

y = ts(y, frequency = 12)
decompose_y = decompose(y, "additive")

plot(as.ts(decompose_y$seasonal))
plot(as.ts(decompose_y$trend))
plot(as.ts(decompose_y$random))
plot(decompose_y)
