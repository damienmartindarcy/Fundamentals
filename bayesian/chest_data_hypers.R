# data
chests_data=list(N=6, x = c(3,4,2,1,2,3))

# hyperparameters (parameters for the priors)
chests_hypers=list(phi=4, theta0=38, phi0=9)

# save in a single list
chests=append(chests_data, chests_hypers)
