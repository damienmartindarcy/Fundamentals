# Question 1

install.packages(rjags)
library(rjags)

misprints <- list(N=6, x = c(3, 4, 2, 1, 2, 3))

jmodel <- jags.model(file = "test.model", data = misprints)
samps <- jags.samples(jmodel, "lambda", n.iter=1e5)

mean(samps$lambda)
sd(samps$lambda)
var(samps$lambda)

plot(density(samps$lambda))
x<-density(samps$lambda)

# Question 2


model<-'
data { # create 3 identical data sets for different priors
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
x2[i,j,k] ~ dpois(lambda[i]) 
}
}
}

# priors
lambda[1] ~ dgamma(9, 6)
lambda[2] ~ dunif(0, 10)
lambda[3] ~ dgamma(0.5, 0.001) # Jeffreys prior
}

'
library(runjags)

N <- 6
x <- c(3, 4, 2, 1, 2, 3)
results<-run.jags(model, monitor = c('gamma', 'beta'))

# Question 3


