# dplyr in action

attach(airquality)
summary(airquality)

library(dplyr)

#Use the filter function to get all observations for the month of May
filter(airquality,Month==5)

#Use the filter function to get all observations when Ozone is less than the 1st quartile for the month of May
filter(airquality,Month==5 & Ozone<18)

#Use the filter function to get all observations when Ozone is less than the 1st quartile except for the month of May
filter(airquality,Month!=5 & Ozone<18)

#using the arrange function piped with filter function
airquality %>% 
filter(Month!=5 & Ozone<18) %>% 
arrange(Ozone)

#using the select function piped with arrange function to see if there is any relation with wind and temp for the first ten days of May
airquality %>% 
filter(Month==5 & Day<=10) %>%
select(Wind,Temp) %>% 
arrange(Wind)

#Using the filter(), mutate(), select() and arrange() functions to get Wind and TempC where TempC is the temperature in Celsius
airquality %>% 
filter(Month==5 & Day<=10) %>%
mutate(TempC = (Temp - 32) * 5 / 9) %>%
select(Wind,TempC) %>% 
arrange(Wind)

#Find the mean temp for each month
airquality	%>%
group_by(Month) %>%
summarize(mean_temp=mean(Temp))

#Create a new dataset with mean_temp from each month
airquality2 = airquality %>%
group_by(Month)	%>%
mutate(mean_temp=mean(Temp))

head(airquality2)


