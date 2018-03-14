# TSA - Lab 2

tail(lab2)
names(lab2)
summary(lab2)
lab2data = read.csv("lab2.csv", header=TRUE)

library(forecast)

##########################################################################
# ARIMA Simulation
x=arima.sim(list(ar=0.5, order=c(1,0,0)), 200)
tsdisplay(x)

#AR(1) for various ar parameters.
x=arima.sim(list(ar=0.8, order=c(1,0,0)), 200)
var(x)
tsdisplay(x)
#AR(2) for various ar parameters.
x=arima.sim(list(ar=c(0.5,0.1),order=c(2,0,0)), 200)
tsdisplay(x)
#MA(1) for various ma parameters.
x=arima.sim(list(ma=0.5, order=c(0,0,1)), 200)
tsdisplay(x)
# I(1)
x=arima.sim(list(order=c(0,1,0)), 200)
tsdisplay(x)
# ARIMA(0,1,1) for various ma parameters.
x=arima.sim(list(ma=0.5, order=c(0,1,1)), 200)
tsdisplay(x)
# ARIMA(1,1,1) for various ar and ma parameters
x=arima.sim(list(ar=0.5, ma=0.5, order=c(1,1,1)), 200)
tsdisplay(x)

# Model for series 7
# Plot
plot(lab2data$Series7, type="l")

# Difference
series7diff = diff(lab2data[,1], lag=1)

#ARMAacf - returns theoretical ACF / PACF
ARMAacf(ar=0.2, ma=-0.2679492, lag.max=2)
ARMAacf(ar=0.3, ma=-0.2679492, lag.max=2, pacf=TRUE)

# Fitting a model
model7 = arima(lab2data$Series7, order=c(3,0,0))

# Significance test on parameter estimation
# Parameters with non significent p values should be considered for removal
require(lmtest)
coeftest(model7)

# Diagnostics

# Examine normality of the residuals - add a (0,1) line
qqnorm(residuals(model7))
qqline(residuals(model7)) 

# Formal test for normality
shapiro.test(residuals(model7))

# Box test of residuals
Box.test(residuals(model7),type="Ljung-Box", lag=1, df=1)
Box.test(residuals(model7),type="Ljung-Box",lag=p+q+10,fitdf=p+q)

############################################################################

# Exercise 1

# A - For Series 8, identify the number of differences (if any) and order of the ARMA model for
# the stationary series based on the results of tsdisplay(). Give reasons for your answers.

tsdisplay(lab2data$Series8)
series8diff = diff(lab2data$Series8, lag=1)
tsdisplay(series8diff)


# B - Report the AR and / or MA parameter estimates for Series 7 and 8, with no drift by using
# include.mean=FALSE. Are they statistically significant?

model7=arima(lab2data$Series7, order=c(1,1,1),include.mean=FALSE)
coeftest(model7)

model8=arima(lab2data$Series8, order=c(0,1,1),include.mean=FALSE)
coeftest(model8)

# C - Look at Series 9. What type of model should you choose and why? Again, focus on models
# without drift (i.e. mean zero).

tsdisplay(lab2data$Series9)

series9diff = diff(lab2data$Series9, lag=1)
tsdisplay(series9diff)

model9=arima(lab2data$Series9, order=c(1,0,2),include.mean=FALSE)
coeftest(model9)

# D -  Now try ARMA(1,1), ARMA(1,2) and ARMA(2,1) models fit to Series 9. Do the parameters
#come out to be statistically significant? Why?

model9=arima(lab2data$Series9, order=c(1,0,1),include.mean=FALSE)
coeftest(model9)
model9=arima(lab2data$Series9, order=c(1,0,2),include.mean=FALSE)
coeftest(model9)
model9=arima(lab2data$Series9, order=c(2,0,1),include.mean=FALSE)
coeftest(model9)

############################################################################
# Exercise 2
# Examine the residuals of an ARMA(1,1) model fit to Series 9 and the ACFs of
#the residuals of an AR(2) fit to Series 9. Describe what you find.

# ARMA(1,1)
model9=arima(lab2data$Series9, order=c(1,0,1),include.mean=FALSE)
model9=arima(lab2data$Series9, order=c(2,0,0),include.mean=FALSE)

plot(fitted(model9), residuals(model9),
     xlab="Fitted Values", ylab="Residuals")
plot(resid(model10))  
qqnorm(residuals(model9))
qqline(residuals(model9)) 
shapiro.test(residuals(model9))

# AR(2)
model9=arima(lab2data$Series9, order=c(2,0,0),include.mean=FALSE)
acf(residuals(model9))


#############################################################################
# Exercise 3
# Now fit an AR(10) model to Series 9. Are the parameters significant? Examine
# the residuals. Why might this model fit the Series well?

model10=arima(lab2data$Series9, order=c(10,0,0),include.mean=FALSE)
coeftest(model10)

par(mfrow=c(2,1))
plot(fitted(model10), residuals(model10),
     xlab="Fitted Values", ylab="Residuals")
qqnorm(residuals(model10))
qqline(residuals(model10)) 

shapiro.test(residuals(model10))

#########################################################################









