# Hotellings t test

# Main Code

# EDA
summary(prices)
par(mfrow = c(3, 1))
boxplot(AskingPrice ~ Area, prices, main = "Asking Price", horizontal = T)
boxplot(NoBedrooms ~ Area, prices, main = "No of bedrooms",horizontal = T)
boxplot(SqFoot ~ Area, prices, main = "Square Footage",horizontal = T)

# Segment dataset
PA = subset(prices, prices$Area=="PA")
MP = subset(prices, prices$Area=="MP")
summary(PA)
summary(MP)

# Remove non numerical variables
PA$Area<-NULL
MP$Area<-NULL


# Main Function
hotelling = function(y1, y2) {
  
  # calculate sample size and observed means
  k = ncol(y1)
  n1 = nrow(y1)
  n2 = nrow(y2)   
  ybar1= apply(y1, 2, mean); ybar2= apply(y2, 2, mean)
  bardiff = ybar1-ybar2
  
  # calculate the variance of the difference in means
  v = ((n1-1)*var(y1)+ (n2-1)*var(y2)) /(n1+n2-2)
  
  # calculate the test statistic and associated quantities
  t2 = n1*n2*bardiff%*%solve(v)%*%bardiff/(n1+n2)
  f = (n1+n2-k-1)*t2/((n1+n2-2)*k)
  pvalue = 1-pf(f, k, n1+n2-k-1)
  
  # return the list of results
  return(list(pvalue=pvalue, f=f, t2=t2, diff=bardiff))
}


# Run function
res1 = hotelling(PA, MP)
res1

# Compare with the inbuilt R function

library(Hotelling)

res2<-hotelling.test(.~Area, data = prices)
res2