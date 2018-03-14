import numpy as np
from scipy import stats
import pandas as pd
import matplotlib.pyplot as plt
from statsmodels.tsa.stattools import adfuller
import statsmodels.api as sm
import statsmodels as smx

dta= pd.read_csv("C:/Udemy/Pro Data Science in Python/House_Prices_london/new_houses_london.csv",dtype={'New Dwellings London': np.float64})
dta.index = sm.tsa.datetools.dates_from_range('2002M2', "2015M6")
del dta["Year"]
del dta["Month"]


##########################################################################


#fig = plt.figure(figsize=(12,8))
#ax1 = fig.add_subplot(211)
#fig = sm.graphics.tsa.plot_acf(dta.values.squeeze(), lags=40, ax=ax1)
#ax2 = fig.add_subplot(212)
#fig = sm.graphics.tsa.plot_pacf(dta, lags=40, ax=ax2)
#fig.show()

#adfuller(dta.values.ravel(),autolag ="AIC")


#diff_s = (dta.values - dta.shift(1))
#diff_s = diff_s.dropna(axis=0)
#fig = plt.figure(figsize=(12,8))
##ax1 = fig.add_subplot(211)
##fig = sm.graphics.tsa.plot_acf(diff_s.squeeze(), lags=20, ax=ax1)
#ax2 = fig.add_subplot(212)
#fig = sm.graphics.tsa.plot_pacf(diff_s.squeeze(), lags=20, ax=ax2)
#fig.show()


#adfuller(diff_s.values.ravel(),autolag ="AIC")

#it seems like an AR4,MA5 would be ok

##########################################################################

#gf = np.arange(dta.values.size)


arma_mod20 = sm.tsa.ARIMA(dta, (12,1,0)).fit()
arma_mod20.summary()


fig, ax = plt.subplots(figsize=(12, 8))
ax = dta.plot(ax=ax)
fig = arma_mod20.plot_predict('2015M7', '2027M1', dynamic=True, ax=ax, plot_insample=False)
fig.show()

resid = arma_mod20.resid
stats.normaltest(resid)

fig, ax = plt.subplots(figsize=(12, 8))
plt.figure(figsize=(12,8))
ax1 = fig.add_subplot(211)
fig = sm.graphics.tsa.plot_acf(resid.values.squeeze(), lags=10, ax=ax1)
ax2 = fig.add_subplot(212)
fig = sm.graphics.tsa.plot_pacf(resid, lags=10, ax=ax2)
fig.show()


#########################################################################
