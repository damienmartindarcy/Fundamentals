library(TSA)
library(forecast)
require(fGarch)


#########################################################################

# Lab4

lab4=scan("lab4.dat")
summary(lab4)
head(lab4)

# We think it is non stationary
tsdisplay(lab4)

# Dickey Fuller - it is difference stationary
adf.test(lab4)

# Dickey Fuller - on the diff version - first diff series is stationary
adf.test(diff(lab4))

# We fit a model to this (IMA 1,1)
fit2 <- auto.arima(lab4)
summary(fit2)
arimaorder(fit2)
m1.lab4=arima(lab4,order=c(0,1,1))

# Isolate the residuals
res.lab4=residuals(m1.lab4)

# Test
McLeod.Li.test(y=res.lab4) 
# all below critical level - this means there is evidence of ARCH behaviour in the model

# We square the residuals - 
# Significant ACF and PACF terms of the squared residuals are clearly visible
tsdisplay(res.lab4^2)

# We can then fit a GARCH (0,1) model - note how we use the diff version as the original series was integrated at order 1
fitx=garchFit(~arma(0,1)+garch(1,0),diff(lab4),include.mean=F)

summary(fitx)
# a series of tests for ARCH of the standardised
# residuals is passed. The final line shows the Li-Mak test, 
# which is passed indicating that we
# successfully modelled out the ARCH behaviour in the series.

# Unstandardised Residuals - clear volatility clustering
plot(fitx@residuals,t='l', ylab='unstandard residuals')

# Standardised Residuals - no longer volatility clustering (apparently)
plot(fitx@residuals/fitx@sigma.t,type='l',ylab='standard residuals')

# Plot conditional variances
plot(fitx@sigma.t^2,type='l',ylab='conditional variances')

# Check that the squared standardised residuals 
# don't exhibit autocorrelation - seems to be ok
acf((fitx@residuals/fitx@sigma.t)^2)

# Test this formally using Ljung Box
Box.test((fitx@residuals/fitx@sigma.t)^2, lag=10, t='Ljung')

##########################################################################

# Questions

# Basics
data("google")

# Demean
google=google-mean(google)
summary(google)
head(google)

#A - we think it is stationary based on plots and ADF
tsdisplay(google)
adf.test(google)

# Besides, diffing makes it more complex
tsdisplay(diff(google))
adf.test(diff(lab4))

# B

# What model would work with this? - (2,0,2)
googlefit <- auto.arima(google)
summary(googlefit)
arimaorder(googlefit)

# Isolate the residuals
res.googlefit=residuals(googlefit)
plot(res.googlefit)

# McLeod Li Test - all residuals below critical level - evidence of ARCH behaviour in the model
McLeod.Li.test(y=res.googlefit)

# Square the residuals
# Significant ACF and PACF terms of the squared residuals are clearly visible
tsdisplay(res.googlefit^2)

#C - initial garch model
fit=garchFit(~arma(2,2)+garch(2,2),google,include.mean=F)
summary(fit)

# Final garch model
fit=garchFit(~arma(2,2)+garch(1,0),google,include.mean=F)
summary(fit)

#D
# Conditional variances / Standardised residuals
# Unstandardised Residuals - clear volatility clustering
plot(fit@residuals,t='l', ylab='unstandard residuals')


# Standardised Residuals - no longer volatility clustering (apparently)
plot(fit@residuals/fit@sigma.t,type='l',ylab='standard residuals')

# Plot conditional variances
plot(fit@sigma.t^2,type='l',ylab='conditional variances')

#E
# Ljung Box test of ACF
# Check that the squared standardised residuals 
# don't exhibit autocorrelation - seems to be ok
acf((fit@residuals/fit@sigma.t)^2)

# Test this formally using Ljung Box
Box.test((fit@residuals/fit@sigma.t)^2, lag=10, t='Ljung')

##################################################################
# garch auto fitting function from github - the range of garch models that it 
# 'accepts' seems to be unusually wide however - though it starts to reject models 
# beyond garch (2,2)

library(quantmod)
source("garchAuto.R")

fity = garchAuto(google, cores=1, trace=TRUE)

garchAutoTryFit = function(
  ll,
  data,
  trace=FALSE,
  forecast.length=1,
  with.forecast=TRUE,
  ic="AIC",
  garch.model="garch" )
{
  formula = as.formula( paste( sep="",
                               "~ arma(", ll$order[1], ",", ll$order[2], ")+",
                               garch.model,
                               "(", ll$order[3], ",", ll$order[4], ")" ) )
  fit = tryCatch( garchFit( formula=formula,
                            data=data,
                            trace=FALSE,
                            cond.dist=ll$dist ),
                  error=function( err ) TRUE,
                  warning=function( warn ) FALSE )
  
  pp = NULL
  
  if( !is.logical( fit ) ) {
    if( with.forecast ) {
      pp = tryCatch( predict( fit,
                              n.ahead=forecast.length,
                              doplot=FALSE ),
                     error=function( err ) FALSE,
                     warning=function( warn ) FALSE )
      if( is.logical( pp ) ) {
        fit = NULL
      }
    }
  } else {
    fit = NULL
  }
  
  if( trace ) {
    if( is.null( fit ) ) {
      cat( paste( sep="",
                  "   Analyzing (", ll$order[1], ",", ll$order[2],
                  ",", ll$order[3], ",", ll$order[4], ") with ",
                  ll$dist, " distribution done.",
                  "Bad model.\n" ) )
    } else {
      if( with.forecast ) {
        cat( paste( sep="",
                    "   Analyzing (", ll$order[1], ",", ll$order[2], ",",
                    ll$order[3], ",", ll$order[4], ") with ",
                    ll$dist, " distribution done.",
                    "Good model. ", ic, " = ", round(fit@fit$ics[[ic]],6),
                    ", forecast: ",
                    paste( collapse=",", round(pp[,1],4) ), "\n" ) )
      } else {
        cat( paste( sep="",
                    "   Analyzing (", ll[1], ",", ll[2], ",", ll[3], ",", ll[4], ") with ",
                    ll$dist, " distribution done.",
                    "Good model. ", ic, " = ", round(fit@fit$ics[[ic]],6), "\n" ) )
      }
    }
  }
  
  return( fit )
}

garchAuto = function(
  xx,
  min.order=c(0,0,1,1),
  max.order=c(5,5,1,1),
  trace=FALSE,
  cond.dists="sged",
  with.forecast=TRUE,
  forecast.length=1,
  arma.sum=c(0,1e9),
  cores=1,
  ic="AIC",
  garch.model="garch" )
{
  require( fGarch )
  require( parallel )
  
  len = NROW( xx )
  
  models = list( )
  
  for( dist in cond.dists )
    for( p in min.order[1]:max.order[1] )
      for( q in min.order[2]:max.order[2] )
        for( r in min.order[3]:max.order[3] )
          for( s in min.order[4]:max.order[4] )
          {
            pq.sum = p + q
            if( pq.sum <= arma.sum[2] && pq.sum >= arma.sum[1] )
            {
              models[[length( models ) + 1]] = list( order=c( p, q, r, s ), dist=dist )
            }
          }
  
  res = mclapply( models,
                  garchAutoTryFit,
                  data=xx,
                  trace=trace,
                  ic=ic,
                  garch.model=garch.model,
                  forecast.length=forecast.length,
                  with.forecast=TRUE,
                  mc.cores=cores )
  
  best.fit = NULL
  
  best.ic = 1e9
  for( rr in res )
  {
    if( !is.null( rr ) )
    {
      current.ic = rr@fit$ics[[ic]]
      if( current.ic < best.ic )
      {
        best.ic = current.ic
        best.fit = rr
      }
    }
  }
  
  if( best.ic < 1e9 )
  {
    return( best.fit )
  }
  
  return( NULL )
}


 







