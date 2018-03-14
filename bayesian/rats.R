require(rjags)
source("rats_data.R")

jmodel=jags.model(file="rats.model", data=rats)
samps=jags.samples(jmodel,c("theta","phi"),n.iter=1e5)

cat("JAGS theta 95% C.I. = ", quantile(samps$theta, probs=c(0.025, 0.975)), "\n")
cat("JAGS phi 95% C.I. = ", quantile(samps$phi, probs=c(0.025, 0.975)), "\n")


