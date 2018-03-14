# -*- coding: utf-8 -*-
# Lecture 10 code - statistics in Python

# We're going to use the scipy.stats and statsmodels packages. 
# Scipy is already installed. Install statsmodels using tools -> package manager

# We're going to cover:
# Revision, basic stats already in Pandas
# Statistical tests, t-tests, chi-square tests in scipy
# In statsmodels:
# Linear regression
# Logistic regression

# For further reading see http://docs.scipy.org/doc/scipy/reference/tutorial/stats.html
# and http://statsmodels.sourceforge.net/stable/index.html

# We're going to use a few standard data sets taken from the amazing Elements of Statistical Learning
# By Hastie, Tibshirani and Friedman available here: http://statweb.stanford.edu/~tibs/ElemStatLearn/
# Prostate data come from here: http://statweb.stanford.edu/~tibs/ElemStatLearn/datasets/prostate.data
# South African heart rate data from here: http://statweb.stanford.edu/~tibs/ElemStatLearn/datasets/SAheart.data

# Start by loading in the usual packages
from pandas import Series, DataFrame
import pandas as pd
import numpy as np
import numpy.random as npr

################################################################################

# Let's load in the prostate cancer data set from the book
prostate = pd.read_table('http://statweb.stanford.edu/~tibs/ElemStatLearn/datasets/prostate.data')

# Data has 11 columns including:
# Unnamed: 0 - just the original index
# lcavol - log(cancer volume)
# lweight - log(weight)
# age - age
# lbph - log(benign prostatic hyperplasia amount)
# svi - seminal vesicle invasion
# lcp - log(capsular penetration)
# gleason - grade of cancer
# pgg45 - percentage Gleason scores 4 or 5
# lpsa - outcome - log prostate specific antigen. All the others are explanatory variables
# train - training data or test data
# From Stamey et al (1989)

# Let's start with revision 
# What kind of things do we want to do wiht these data?
# Summarise it with means and standard deviations
# Look at correlation structure
# Standardise the variables ready for a modelling run
# Look for any obvious outliers
# We can do these with Pandas
# We should also do lots of graphical summaries of the data, but we will not do this here

# Let's describe the data set
prostate.describe()
# All but one variables numeric so only training misses out
prostate.train.describe()

# Look at correlation structure - in particular with lpsa
prostate.corr()
# Lots of positive correlations. In particular lpsa has high correlations with lcavol
# though remember these are all linear correlations

# Standardise the data
prostate_numeric = prostate.drop(['Unnamed: 0','train'],axis=1)
prostate_std = (prostate_numeric-prostate_numeric.mean())/prostate_numeric.std()

# Let's look for some outliers, let's say 3 sd from the mean
prostate_std[(np.abs(prostate_std)>3).any(1)] 
# Notice that the any(1) method here finds rows where this at least 1 outside the range
# Mostly these are to do with gleeson, let's have a look at the original data
prostate[(np.abs(prostate_std)>3).any(1)]
# Look very high gleeson percentages - first guy is an outlier because he is very young

# Should do graphical summaries here as well

################################################################################

# Next up simple tests and summary state with scipy.stats
# Note that this is a large module and I'm only going to show the kind of things
# I normally do with data
import scipy.stats as stats

# What kind of tests might we want to run?
# Some examples:
# A two-sample t-test on lpsa vs age>65 or age<=65
# A test to see which of the variables might be considered normally distributed
# Perhaps some qq plots

# First let's do a two sample test on lpsa vs age>65
lpsa_gt_65 = prostate.lpsa[prostate.age>65]
lpsa_lt_65 = prostate.lpsa[prostate.age<=65]

# The standard two-sample t-test with equal variances
stats.ttest_ind(lpsa_gt_65, lpsa_lt_65)
# First value here is t-value, second is p-value
# Just sig at the 5% level
# Over 65s have higher lpsa

# What about unequal variances version
lpsa_gt_65.std()
lpsa_lt_65.std()
stats.ttest_ind(lpsa_gt_65, lpsa_lt_65 ,equal_var=False)
# Slightly more significant!

# 1 sample t-test with ttest_1samp which has argument for popmean

# Suppose want to check the distribution of lpsa itself
prostate.lpsa.hist() # Looks pretty symmetrical
stats.kstest(prostate.lpsa, 'norm')
# Gives the ks-test value and then p-value
# Seems miles different from the normal distribution

# Try a qq-plot
import matplotlib.pyplot as plt
fig = plt.figure()
ax = fig.add_subplot(111)
stats.probplot(prostate.lpsa, dist='norm',plot=ax)
# Looks pretty good to me!

################################################################################

# Let's now move on to statsmodels
# statsmodels works a lot like R in the way you specify formulae

# Revision: linear regression works by fitting the model 
# y = XB + e
# where e ~ N(0,s^2)
# We want to estimate B and s.
# The usual way to do this is Ordinary Least Squares. 

# statsmodels seems to work mostly with endogenous and exogenous variables
# I think these come from the economics literature. In general
# Endogenous means the response variable y 
# Exogenous means the explanatory variables X
# Tip exogenous has an X in it

# Linear regression very simple to run
import statsmodels.api as sm
mod = sm.OLS(prostate_std.lpsa, prostate_std.drop('lpsa',axis=1))
res = mod.fit()
print res.summary()
# Lots of fitting detail - be careful no intercept!

# Can add an intercept this way
X_with_const = sm.add_constant(prostate_std.drop('lpsa',axis=1))

# Fitting with R style formulae
import statsmodels.formula.api as smf
mod2 = smf.ols(formula='lpsa ~ lcavol + lweight + age', data=prostate_std)
res2 = mod2.fit()
print res2.summary() # Note that this includes an intercept

# It also allows to do things like simple interactions
mod3 = smf.ols(formula='lpsa ~ lcavol * lweight * age', data=prostate_std).fit()
print mod3.summary() # None of these interactions seem important
# There are added options in smf.ols for using subsets
# Also options in .fit() for fitting method: I think this might use a different fitting method than R - use Moore-Penrose rather than QR

# You can also add things in which are categorical
prostate_std['age_lt_65'] = prostate.age>65
mod4 = smf.ols(formula='lpsa ~ lcavol + lweight + C(age_lt_65)', data=prostate_std).fit()
print mod4.summary()
# Note that it dropped one of the categories in age_lt_65 so that the model was fully determined

# You can also drop the intercept
mod5 = smf.ols(formula='lpsa ~ lcavol + lweight + C(age_lt_65) -1', data=prostate_std).fit()
print mod5.summary() # Now it can use both age_lt_65 values

# Or add in your own functions
mod6 = smf.ols(formula='lpsa ~ lcavol + pow(lcavol,2)', data=prostate_std).fit()
print mod6.summary() # Now it can use both age_lt_65 values

# You can actually get loads more than just the summary
dir(mod6)
# Huge list

# Example: create a plot of fitted values vs residuals
mod_summary = DataFrame({'preds':mod6.predict(),'resids':mod6.resid})
mod_summary.plot('preds','resids',kind='scatter')
# Looks like a pretty random scatter

################################################################################

# Logistic regression

# Revision(?): logistic regression same as standard linear regression except for 
# response variable is binary and assumed Bernoulli distributed
# Model:
# y_i ~ Bernoulli(p_i)
# logit(p_i) = XB
# where logit(z) = log(z/(1-z))

# Let's load in a new dataset for this:
SA = pd.read_csv('http://statweb.stanford.edu/~tibs/ElemStatLearn/datasets/SAheart.data')

# Columns are 
# sbp - systolic blood pressure
# tobacco - cumulative tobacco (kg)
# ldl - low densiity lipoprotein cholesterol
# adiposity
# famhist - family history of heart disease (Present, Absent)
# typea - type-A behavior
# obesity
# alcohol - current alcohol consumption
# age - age at onset
# chd - response, coronary heart disease

# Lets describe the data
SA.describe()

# Missing famhist
SA.famhist.describe()

# Standardise
SA_numeric = SA.drop(['famhist','chd'],axis=1)
SA_std = (SA_numeric-SA_numeric.mean())/SA_numeric.std()
SA_std_const = sm.add_constant(SA_std)

# Run the logistic regression
logit1 = sm.Logit(SA.chd, SA_std_const).fit()
# Note: this is usually fitted via maximum likelihood
print logit1.summary()

# As before loads of other stuff you can get
dir(logit1)

# Age seems to be the most important variable; perhaps re-fit and plot effect
logit2 = sm.Logit(SA.chd, SA_std_const['age']).fit()
print logit2.summary()
new_age = DataFrame({'age':np.linspace(-3,3,100)})
new_preds = logit2.predict(new_age)
# Turn into a DataFrame
preds_df = DataFrame({'age':new_age.values[:,0],'preds':new_preds})

# Plot
fig = plt.figure()
preds_df.plot('age','preds')
# Add in data points
plt.plot(SA_std_const['age'],SA.chd,'r+')
plt.ylim(-0.05,1.05)
# Might need a bit of jitter too


