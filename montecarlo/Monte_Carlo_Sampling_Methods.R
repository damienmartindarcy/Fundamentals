# MCO - Lab / Assignment 1

# Method of Inversion
lambda <-1 
u <- runif ( 1 ) # Generate a u(0,1) number
x <- -log(1-u)/lambda # Transform to an exponential
x

# Method of Inversion - More than one realisation
n<-20
lambda <-1 
u <- runif (n) # Generate a u(0,1) number
x <- -log(1-u)/lambda # Transform to an exponential
x

# Method of Inversion - as a function
inv.exp <- function (n,lambda) {
  lambda <-1 
  u <- runif (n) # Generate a u(0,1) number
  x <- -log(1-u)/lambda # Transform to an exponential
  x}
inv.exp ( n=20, lambda=1)

# Compare histogram of sampled values to plot of the density
x <- inv.exp ( n=1000, lambda =0.5) # Generate Large Sample
hist (x , freq=FALSE) 

t <- 0:150/10 # Create a sequence
lines ( t , dexp ( t , rate =0.5) , lwd=2) # Add the density to the histogram

# KS test to test the null hypothesis from our sample is  from an EX (0.5) distribution
ks.test ( x , pexp , rate=0.5)

###############################################################################

# Gamma Distribution
k <-4
lambda <- 1
x <- inv.exp ( n=k , lambda=lambda ) # Draw an exp number
y <- sum( x )
y

# Gamma Distribution - Draw n random numbers
n <-20  
k<-4  
lambda <- 1  
x <- matrix (inv.exp ( n=n*k , lambda=lambda ) , ncol=k )
y <- apply ( x , 1 , sum) # sum up each row
y 

# Gamma Distribution - Inside a Function

inv.gamma.int <- function ( n, k , lambda ) {
x <- matrix ( inv.exp ( n=n*k , lambda=lambda ) , ncol=k )
apply ( x , 1 , sum)
 }
y <- inv.gamma.int ( 20 , 4 , 1 )
y

################################################################

# Gamma - apparently

fx<-dgamma(0.5,shape=2.5,rate=3)
hx<-dgamma(0.5,shape=2,rate=2)
m<-fx/hx
m

V=NULL
while(length(V)<100){
  U<-runif(1)
  X<-inv.gamma.int(1,2,2)
  Y<-U*m*dgamma(X,shape=2,rate=2)
  fx<-dgamma(X,shape=2.5,rate=3)
  if (Y<fx){
    V=append(V,X)
  }
}

#########################################################

set.seed(0)
x <- rexp(1000)  ## samples from proposal density
f <- function(x) 2 * x *exp(-x^2)  ## target density
w <- f(x) / dexp(x)  ## importance weights

mean(x)  ## non-weighted sample mean
# [1] 1.029677

mean(w * x)  ## weighted sample mean
# [1] 0.9380861

lambdas = rexp(100, 0.5)
samples = rep(0, 100)
for (i in 1:100)
  samples[i] = rpois(1, lambdas[i])

# Importance Sampling
x<-rexp(n=1000,r=1)
fx<-function(x){
  return(x^2*exp(-(x^2)))
}
gx<-function(x){
  return(exp(-x))
}

Ex=mean(x*fx(x)/gx(x))
##################################################################
# Rejection Sampling
rz1<-function () 
{
  repeat {
    x <- runif(1, 0, 1)
    y <- runif(1, 0, 3/2)
    fx <- 6 * x * (1 - x)
    if (y < fx) 
      return(x)
  }
}

rz2<-function (n) 
{
  zvector <- vector("numeric", n)
  for (i in 1:n) {
    zvector[i] <- rz1()
  }
  zvector
}

rz3<-function (n) 
{
  xvec <- runif(n, 0, 1)
  yvec <- runif(n, 0, 3/2)
  fvec <- 6 * xvec * (1 - xvec)
  xvec[yvec < fvec]
}

rz4<-function (n) 
{
  x <- rz3(n)
  len <- length(x)
  aprob <- len/n
  shortby <- n - len
  n2 <- round(shortby/aprob)
  x2 <- rz3(n2)
  x3 <- c(x, x2)
  x3
}

hist(rz4(10000),30)

####################################################################

# Rejection Sampling - apparently

# 1. Define a density of interest that will be approximated by "REJECTION SAMPLING"
minRgDensity <- 0
maxRgDensity <- 10
maxDensityValue <- 1
sampleSize <- 3000
knownDensity <- function(x)
{ minRgDensity <- 0
maxRgDensity <- 20
maxDensityValue <- 1
return(dbeta(x, 3, 10))
}
rawDensity <- rbeta(sampleSize, 3, 10)

# 2. Rejection sampling method
RejectionSampling <- function(n)
{
  RN <- NULL
  for(i in 1:n)
  {
  OK <- 0
  while(OK<1)
  {
  T <- runif(1,min = minRgDensity, max = maxRgDensity )
  U <- runif(1,min = 0, max = 1)
  if(U*maxDensityValue <= knownDensity(T))
  {
  OK <- 1
  RN <- c(RN,T)
  }
  }
  }
  return(RN)
}
# 3. Generate n=sampleSize samples from the model-simulation density
(RejectionSampling)
simulatedDensity <- RejectionSampling(sampleSize)
# 4. Calculate the two histograms
histoRaw <- hist(rawDensity)
histoSimulated <- hist(simulatedDensity)
# 5. Q-Q plot raw vs simulated densities
plot( rawDensity )
plot( simulatedDensity, rawDensity )
qqplot(simulatedDensity, rawDensity )
qqline(simulatedDensity, col = 2)
# qqplot( rawDensity, simulatedDensity);
# abline(0,1) 

##################################################################
# Poisson from exponential

Nsim = 10^4

# small/large values for lambda (the value of 1/mean)
#
lambda = 2

X = NULL
for( ii in 1:Nsim ){
  k = 0
  v = rexp(1,rate=lambda)
  while( v < 1 ){
    v = v + rexp(1,rate=lambda)
    k = k+1
  }
  X[ii]=k  
}

xRng = seq(min(X),max(X),1)
brks = c( xRng[1] - 0.5, xRng + 0.5 )
hist(X,freq=F,breaks=brks,main="Poisson from Exponential")
lines( xRng, dpois(xRng,lambda), col="Blue" )

####################################################################
# Poisson from exponential again

lambda <- 0.5
tMax <- 100

## find the number 'n' of exponential r.vs required by imposing that
## Pr{N(t) <= n} <= 1 - eps for a small 'eps'
n <- qpois(1 - 1e-8, lambda = lambda * tMax)

## simulate exponential interarrivals the
X <- rexp(n = n, rate = lambda)
S <- c(0, cumsum(X))
plot(x = S, y = 0:n, type = "s", xlim = c(0, tMax)) 

## several paths?
nSamp <- 50
## simulate exponential interarrivals
X <- matrix(rexp(n * nSamp, rate = lambda), ncol = nSamp,
            dimnames = list(paste("S", 1:n, sep = ""), paste("samp", 1:nSamp)))
## compute arrivals, and add a fictive arrival 'T0' for t = 0
S <- apply(X, 2, cumsum)
S <- rbind("T0" = rep(0, nSamp), S)
head(S)
## plot using steps
matplot(x = S, y = 0:n, type = "s", col = "darkgray",
        xlim = c(0, tMax),
        main = "Homogeneous Poisson Process paths", xlab = "t", ylab = "N(t)")

############################################################################

# Rejection Sampling - Examples from book

a = 3 # a large value that makes naive simulation from the truncated normal distribution hard 

# Part (c):
#
M = sqrt( 2 * pi ) * exp( -0.5*a^2 ) # this is *not* the reciprical of the acceptance rate since the densities are not correctly normalized 

mu_bar = a 

# Plot the two densities f(x) and M*g(x) to make sure that f(x) < M*g(x):
# 
xRange = seq( a, 4*a, length.out=100 )
f = exp( -0.5*xRange^2 )
plot( xRange, f )
g = (1/sqrt(2*pi)) * exp( -0.5*(xRange - mu_bar)^2 )
lines( xRange, M*g )

gFunc = function(x,mu_bar){ # don't do the truncation when x<a here
  (1/sqrt(2*pi)) * exp( -0.5*(x - mu_bar)^2 )
}
fFunc = function(x){ # don't do the truncation when x<a here
  exp( -0.5*x^2 )
}

Nsim = 2500

x=NULL
while( length(x)<Nsim ){
  
  y = rnorm( Nsim, mean=mu_bar, sd=1. ) # generate samples from the candidate density
  
  yKeep = y[ y > a ] # these are possible candidates (other points have f(y)=0 will not pass the acceptance phase)
  nKeep = length(yKeep)
  
  y = yKeep
  
  x = c(x, y[ runif(nKeep)*M < fFunc(y)/gFunc(y,mu_bar) ])
}
x = x[1:Nsim]


##postscript("../../WriteUp/Graphics/Chapter2/ex_2_21_pt_trunc_norm_dist.eps", onefile=FALSE, horizontal=FALSE)

# Plot this as a normalized density:
# 
hist(x,freq=F,main="truncated normal dist. via normal")
xRng = seq( min(x), max(x), length.out=100 )
normConstant = sqrt(2*pi) * ( 1 - pnorm(a) )
lines(xRng,fFunc(xRng)/normConstant,lwd=2,col="sienna")

##dev.off()



# Part (d):
#
alpha = ( a + sqrt( a^2 + 4 ) )/2 # the optimal value for the translated exponential density
MTilde = (1/alpha)*exp( 0.5*alpha^2 - alpha*a ) # the optimal value for MTilde 

# Plot the two densities f(x) and M*g(x) to make sure that f(x) < M*g(x):
# 
xRange = seq( a, 4*a, length.out=100 )
f = exp( -0.5*xRange^2 )
plot( xRange, f )
g = alpha * exp( -alpha*(xRange - a) )
lines( xRange, M*g )

gFunc = function(x,alpha,a){ # don't do the truncation when x<a here
  alpha * exp( -alpha*(x - a) )
}
fFunc = function(x){ # don't do the truncation when x<a here
  exp( -0.5*x^2 )
}

Nsim = 2500

x=NULL
while( length(x)<Nsim ){
  
  y = rexp( Nsim, rate=alpha ) # generate samples from the candidate density
  y = y + a # now tranlate 
  
  x = c(x, y[ runif(Nsim)*MTilde < fFunc(y)/gFunc(y,alpha,a) ])
}
x = x[1:Nsim]


##postscript("../../WriteUp/Graphics/Chapter2/ex_2_21_pt_trans_exp_density.eps", onefile=FALSE, horizontal=FALSE)

# Plot this as a normalized density:
# 
hist(x,freq=F,main="truncated normal dist. via translated exponential")
xRng = seq( min(x), max(x), length.out=100 )
normConstant = sqrt(2*pi) * ( 1 - pnorm(a) )
lines(xRng,fFunc(xRng)/normConstant,lwd=2,col="sienna")

##dev.off()

##################################################################

# Other examples of accept-reject algorithm
# Part (a):
# 

# Find the largest value of f(y)/g(y) (note the Gaussian exponential factor cancels):
# 
M = optimize(f=function(x){
  num = ( sin(6*x)^2 + 3*( cos(x)^2 ) * (sin(4*x))^2 + 1 )
  den = ( 1/sqrt(2*pi) )
  num/den 
}, interval=c(0,+1.),maximum=T)$objective


# Here we will plot the density f and the upper bounding density $M g(x)$.
# 
###postscript("../../WriteUp/Graphics/Chapter2/ex_2_18_f_function.eps", onefile=FALSE, horizontal=FALSE)
x = seq(-5,+5,length.out=1000)
f = exp(-0.5*x^2)*( sin(6*x)^2 + 3*( cos(x)^2 ) * (sin(4*x))^2 + 1 )

plot( x, f )
lines( x, f, lwd=2, col="black")

g = M * exp(-0.5*x^2)/sqrt(2*pi)
lines( x, g )

###dev.off() 

# Generate Nsim random variables from f and estimate the acceptance rate of this proceedure 
#
Nsim = 2500

fFunc = function(x){
  exp(-.5*x^2)*( sin(6*x)^2 + 3*( cos(x)^2 ) * (sin(4*x))^2 + 1 )
}
gFunc = function(x){
  exp(-.5*x^2)/sqrt( 2*pi ) 
}

X = NULL
U = NULL
numDrawsFound = 0
while( numDrawsFound<Nsim ){
  X = c(X,rnorm(Nsim)) # extract some draws from our proposal distribution 
  U = c(U,runif(Nsim)) # extract the corresponding uniform random variable 
  numDrawsFound = sum( fFunc(X)/(M*gFunc(X)) >= U ) # find out which draws passed the accept-reject threshold
}

prob_acceptance = numDrawsFound/length(X)
hat_f = 1/(prob_acceptance*M) # the nomalizing factor for the f(x) density 

# extract out the true samples from f(x) and estimate the probability of acceptance (1/M):
#
inds = fFunc(X)/(M*gFunc(X)) >= U 
X = X[inds]

###postscript("../../WriteUp/Graphics/Chapter2/ex_2_18_normalized_f_density.eps", onefile=FALSE, horizontal=FALSE)

hist(X,freq=F,breaks=100)
xRng = seq( min(X), max(X), length.out=100 )
#lines(xRng,fFunc(xRng)/(prob_acceptance*M),lwd=2,col="sienna")
lines(xRng,hat_f * fFunc(xRng),lwd=2,col="sienna")

###dev.off()

######################################################################
# Odds and Sods

# Gamma - apparently

fx<-dgamma(0.5,shape=2.5,rate=3)
hx<-dgamma(0.5,shape=2,rate=2)
m<-fx/hx
m

V=NULL
while(length(V)<100){
  U<-runif(1)
  X<-inv.gamma.int(1,2,2)
  Y<-U*m*dgamma(X,shape=2,rate=2)
  fx<-dgamma(X,shape=2.5,rate=3)
  if (Y<fx){
    V=append(V,X)
  }
}

#########################################################

set.seed(0)
x <- rexp(1000)  ## samples from proposal density
f <- function(x) 2 * x *exp(-x^2)  ## target density
w <- f(x) / dexp(x)  ## importance weights

mean(x)  ## non-weighted sample mean
# [1] 1.029677

mean(w * x)  ## weighted sample mean
# [1] 0.9380861

lambdas = rexp(100, 0.5)
samples = rep(0, 100)
for (i in 1:100)
  samples[i] = rpois(1, lambdas[i])

# Importance Sampling
x<-rexp(n=1000,r=1)
fx<-function(x){
  return(x^2*exp(-(x^2)))
}
gx<-function(x){
  return(exp(-x))
}

Ex=mean(x*fx(x)/gx(x))
##################################################################
# Rejection Sampling
rz1<-function () 
{
  repeat {
    x <- runif(1, 0, 1)
    y <- runif(1, 0, 3/2)
    fx <- 6 * x * (1 - x)
    if (y < fx) 
      return(x)
  }
}

rz2<-function (n) 
{
  zvector <- vector("numeric", n)
  for (i in 1:n) {
    zvector[i] <- rz1()
  }
  zvector
}

rz3<-function (n) 
{
  xvec <- runif(n, 0, 1)
  yvec <- runif(n, 0, 3/2)
  fvec <- 6 * xvec * (1 - xvec)
  xvec[yvec < fvec]
}

rz4<-function (n) 
{
  x <- rz3(n)
  len <- length(x)
  aprob <- len/n
  shortby <- n - len
  n2 <- round(shortby/aprob)
  x2 <- rz3(n2)
  x3 <- c(x, x2)
  x3
}

hist(rz4(10000),30)

####################################################################

# Rejection Sampling - apparently

