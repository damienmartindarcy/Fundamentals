# Exercise 1
# Uninformative priors
# Test 100 / 1000 / 5000 iterations

set.seed(12345)
gibbs1 = function(iters,y,mu=0,tau=1){
  alpha0 = 0.00001
  beta0 =  0.00001
  mu0 = 0.0
  tau0 = 0.00316
  x <-array(0,c(iters+1,2))
  x[1,1] = mu
  x[1,2] = tau
  n = length(y)
  ybar = mean(y)
  for(t in 2:(iters+1)){
    x[t,1] = rnorm(1,(n*ybar*x[t-1,2] + mu0*tau0)/
                     (n*x[t-1,2]+tau0), sqrt(1/(n*x[t-1,2]+tau0)))
    sn = sum((y-x[t,1])^2)
    x[t,2] = rgamma(1,alpha0+n/2)/(beta0+sn/2)
  }
  par(mfrow=c(1,2))
  plot(1:length(x[,1]),x[,1],type='l',lty=1,xlab='t',ylab='mu')
  plot(1:length(x[,2]),1/x[,2],type='l',lty=1,xlab='t',ylab='sigma^2')
}

y = rnorm(10,1,2)

output = gibbs1(5000,y,15,100)
###################################################################################

# Exercise 2 / 3
# Uninformative priors as before
# Mean, var, histograms
# Test 100 / 1000 / 5000 iterations
# Proper Priors

library(coda)

set.seed(12345)
gibbs1_MCMC = function(iters,y,mu=0.0,tau=1){
  alpha0 = 0.00001
  beta0 =  0.00001
  mu0 = 0.0
  tau0 = 0.00316
  x <-array(0,c(iters+1,2))
  x[1,1] = mu
  x[1,2] = tau
  n = length(y)
  ybar = mean(y)
  for(t in 2:(iters+1)){
    x[t,1] = rnorm(1,(n*ybar*x[t-1,2] + mu0*tau0)/
                     (n*x[t-1,2]+tau0), sqrt(1/(n*x[t-1,2]+tau0)))
    sn = sum((y-x[t,1])^2)
    x[t,2] = rgamma(1,alpha0+n/2)/(beta0+sn/2)
  }
  par(mfrow=c(1,2))
  hist(x[,1], xlab='t', ylab='mu')
  hist(x[,2],xlab='t', ylab='sigma^2')
  plot(density(x[,1]),xlab='t', ylab='mu')
  plot(density(x[,2]),xlab='t', ylab='sigma^2')
  print(mean(x[,1]))
  print(var(x[,1]))
  print(mean(x[,2]))
  print(var(x[,2]))
  print(sum(x[,1]>1.5))
  print(sum(x[,2]>2.5))
  print(summary(x[,1]))
  print(summary(x[,2]))
}

y = rnorm(10,1,2)
 
output = gibbs1_MCMC(1000,y,0,100)
summary(output)
plot(output)
############################################################################

# Exercise 4 - 6

data("lynx")
lynx<-as.ts(lynx)

trueA <- 5
trueC <- 0
trueTau <- 10
sampleSize <- 1000

# create independent x-values 
x <- lynx
# create dependent values according to y = ax + b + N(0,sd)
y <-  trueC + (trueA * x(t-1)) + rnorm(trueTau, alpha, beta)

plot(x,y, main="Test Data")

#################################################################
likelihood <- function(param){
  a = param[1]
  c = param[2]
  tau = param[3]
  
  pred = c+a*x + rnorm(tau, alpha, beta)
  singlelikelihoods = dnorm(y, mean = pred, sd = tau, log = T)
  sumll = sum(singlelikelihoods)
  return(sumll)   
}

##################################################################
# Prior distribution
prior <- function(param){
  a = param[1]
  c = param[2]
  tau = param[3]
  aprior = dnorm(a, tau = 0.001, log = T)
  cprior = dnorm(c, tau = 0.001, log = T)
  tauprior = dgamma(tau, alpha=0.01, beta=0.01, log = T)
  return(aprior+cprior+tauprior)
}

posterior <- function(param){
  return (likelihood(param) + prior(param))
}

######## Metropolis algorithm ################

proposalfunction <- function(param){
  return(rnorm(3,mean = param))
}

run_metropolis_MCMC <- function(startvalue, iterations){
  chain = array(dim = c(iterations+1,3))
  chain[1,] = startvalue
  for (i in 1:iterations){
    proposal = proposalfunction(chain[i,])
    
    probab = exp(posterior(proposal) - posterior(chain[i,]))
    if (runif(1) < probab){
      chain[i+1,] = proposal
    }else{
      chain[i+1,] = chain[i,]
    }
  }
  return(mcmc(chain))
}

startvalue = c(0,0,0)
chain = run_metropolis_MCMC(startvalue, 1000)

burnIn = 100
acceptance = 1-mean(duplicated(chain[-(1:burnIn),]))

### Summary: #######################

par(mfrow = c(2,3))
hist(chain[-(1:burnIn),1],nclass=30, , main="Posterior of a", xlab="True value = red line" )
abline(v = mean(chain[-(1:burnIn),1]), col="blue")
abline(v = trueA, col="red" )
hist(chain[-(1:burnIn),2],nclass=30, main="Posterior of c", xlab="True value = red line")
abline(v = mean(chain[-(1:burnIn),2]), col="blue")
abline(v = trueC, col="red" )
hist(chain[-(1:burnIn),3],nclass=30, main="Posterior of tau", xlab="True value = red line")
abline(v = mean(chain[-(1:burnIn),3]), col="blue" )
abline(v = trueTau, col="red" )
plot(chain[-(1:burnIn),1], type = "l", xlab="True value = red line" , main = "Chain values of a", )
abline(h = trueA, col="red" )
plot(chain[-(1:burnIn),2], type = "l", xlab="True value = red line" , main = "Chain values of c", )
abline(h = trueC, col="red" )
plot(chain[-(1:burnIn),3], type = "l", xlab="True value = red line" , main = "Chain values of tau", )
abline(h = trueTau, col="red" )

mean(chain)
var(chain)
summary(chain)
plot(chain)