# Damien Darcy 15202834 - STAT 40850 - Bayesian Analysis - Lab2

# Question 1

require(rjags)
set.seed(101)

# Misprints data
misprints1 <- list(N=6, x = c(3, 4, 2, 1, 2, 3))

# JAGS model inline
model1<-"model{
  
  # likelihood: poisson
  for(i in 1:N) {
    x[i] ~ dpois(lambda)
  }
  
  # prior: gamma
  lambda ~ dgamma(9,6)
}"

# Call to model
jmodel1 <- jags.model(textConnection(model1), data=misprints1)
samps1 <- jags.samples(jmodel1, "lambda", n.iter=100000)

# Summary Stats
mean(samps1$lambda)
var(samps1$lambda)

# Mean = 1.999 , variance = 0.1677

plot(density(samps1$lambda))

########################################################################

# Question 2

# Use runjags package
library('runjags')
set.seed(123)

# JAGS model inline
model2 <- '
data { # create 3 (identical() data sets for 3 different priors
for (k in 1:3) {
for (j in 1:2) {
for (i in 1:N) {
x2[i,j,k] <- x[i]
}
}
}
}


model {
# likelihood
for (k in 1:3) {
for (j in 1:2) {
for (i in 1:N) {
x2[i,j,k] ~ dpois(lambda[k]) 
}
}
}

# priors
lambda[1] ~ dgamma(9, 6) # 1 - Original Gamma prior
lambda[2] ~ dunif(0, 10) # 2 - Uniform
lambda[3] ~ dgamma(0.001, 0.001) # 3 - Jeffreys prior
}
#data# N, x
#monitor# lambda
'

# R section
N <- 6
x <- c(3, 4, 2, 1, 2, 3)

# Run jags model
results2<-run.jags(model2)
results2

# Results Plot
plot(results2)

#######################################################################

# Question 3

# Case 1 - New data only
# MASS for parameter fitting
library(MASS)
set.seed(101)
require(rjags)

# New data
misprints2 <- list(N=4, x = c(2, 1, 6, 0))

# Parameter fitting to results of Q1
parms<-fitdistr(samps1$lambda,"gamma")
# Approx Gamma (24.21,12.11)
parms

testmodel3<-"model{

# likelihood: poisson
for(i in 1:N) {
x[i] ~ dpois(lambda)
}

# prior: Posterior from question 1
lambda ~ dgamma (24.21, 12.11)
}"

# Call to modified model
jmodel2 <- jags.model(textConnection(testmodel3), data=misprints2)
samps2 <- jags.samples(jmodel2, "lambda", n.iter=1e5)

# Summary Stats
mean(samps2$lambda)
var(samps2$lambda)

# mean = 2.06, var = 0.127

# ----------------------------------------------------

# Case 2 - Old + new data - all simultaneously

# New data
misprints3 <- list(N=10, x = c(3, 4, 2, 1, 2, 3, 2, 1, 6, 0))

# Parameter fitting to results of Q1
parms<-fitdistr(samps1$lambda,"gamma")
# Approx Gamma (24.21,12.11)
parms

testmodel3<-"model{

# likelihood: poisson
for(i in 1:N) {
x[i] ~ dpois(lambda)
}

# prior: Posterior from question 1
lambda ~ dgamma (24.21, 12.11)
}"

# Call to modified model
jmodel3 <- jags.model(textConnection(testmodel3), data=misprints3)
samps3 <- jags.samples(jmodel3, "lambda", n.iter=1e5)

# Summary Stats
mean(samps3$lambda)
var(samps3$lambda)

# mean = 2.18, var = 0.099

#########################################################################
