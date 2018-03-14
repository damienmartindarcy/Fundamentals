import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from pandas import Series, DataFrame

# 1 - Basics *******************************************************************

# Look at first 5 records
diamonds[:5]

# How many diamonds have a cut of 'Ideal' and a price of above $9000
sum((diamonds.cut=='Ideal') & (diamonds.price>9000))

# Calculate a table of the different cuts
diamonds.cut.value_counts()

# Now look at mean price by colour
pd.pivot_table(diamonds, 'price', index='color') # Default aggfunc is mean

# Access the first individual record
diamonds.ix[0]

# Let's look at this record in more detail
diamonds[diamonds.price==diamonds.price.max()]

# Count the number of times something appears
DNA.count('t')

# Create a new variable which is age grouped into 40-50, 50-60, 60-70, 70-80
# The below code creates a new variable called called age_groups which assigns each to a decadal category
prostate['age_groups'] = pd.cut(prostate.age,(40,50,60,70,80))
# Q4 How many men are in the group (50,60)? 17
prostate.age_groups.value_counts() 

# Sorting 
a = ['Peter','Piper','picked','a','peck','of','pickled','peppers']
a.sort()

# Find the words which are of length 5 or less
data = ['alpha','bravo','charlie','delta','echo','foxtrot']

result = []
for i in data:
    if len(i) <= 5:
        result.append(i)
                                
# List comprehension version 
result= [i for i in data if len(i)<=5]

# Some standard ways of creating arrays of zeros and 1s, or empty
np.zeros((5,6)) 
np.ones((10,2))
x = np.random.randn(5,5)

# Column means of a data frame
rand_df.mean()
# Note: ignored the colours variable

# Row standard deviation
rand_df.std(axis=1)

# Finding quantiles always useful to know - 5th quantile
rand_df.quantile(0.05)
rand_df.quantile(0.95)

# Describe
rand_df.describe() # Again ignores the text var
rand_df.colours.describe() # Does a good job with this when specified

# Find locations of min and max - note gives first location of min and max
rand_df.drop('colours',axis=1).idxmin()
rand_df.drop('colours',axis=1).idxmax()

# Find a correlation/covariance matrix
rand_df.drop('colours',axis=1).corr()
rand_df.drop('colours',axis=1).cov()

# Find a specific correlation
rand_df.normal.corr(rand_df.poisson)

# Or find all the correlations with one particular variable
rand_df.drop('colours',axis=1).corrwith(rand_df.normal)

#Rename Column - it was unnamed before - now it is 'area_idili'
olive_oil.rename(columns={olive_oil.columns[0]:'area_idili'}, inplace=True)

#Map - Replace the '1's' at the start of the 'area_idili' column - apply to all values
olive_oil.area_idili=olive_oil.area_idili.map(lambda x: x.split('.')[-1])

# Apply - Divide each value of the acid by 100 .. apply to multiple columns
list_of_acids=['palmitic','stearic','oleic','linoleic','arachidic']
df=olive_oil[list_of_acids].apply(lambda x: x/100.00)

#Shape
olive_oil.shape

#Unique 
olive_oil.region.unique()

#Cross Tab (again) - two versions - same effect
pd.crosstab(olive_oil.area, olive_oil.region)
olive_oil[['palmitic','palmitoleic']].head(5)

#Groupby .. Groups the data into 3 parts (regions 1,2,3)
olive_oil.groupby('region')

# 2 - Missing values **********************************************************

# Note that by default all the above summary functions remove NaNs
salary.mean()

# The isnull method will tell you whether something is missing
salary.isnull()
# notnull will tell you the opposite
salary.notnull()

# Two other useful ways of dealing with missing values is to drop them (dropna) or fill in values (fillna)
# Compare
salary.dropna().mean()
# with
salary.fillna(0).mean()

# When you have a DataFrame things get a bit messier - do you want to drop all the rows with NAs or just some of them?
salary = DataFrame({'salary':[53215, 112454, 22365, np.nan, 30493, None],
    'grade':[5, 7, None, np.nan, 2, 9]},index=['Margaret', 'Stephen', 'Joanne', 'Joe', 'Matthew', 'Nelson'])

# Drop NA drops all rows with NAs - this permits complete case analysis
salary.dropna()

#3 - Wrangling ******************************************************************

#Impute with column mean
salary.fillna(salary.mean())

# Create a design matrix X with 5 columns, the first of which is all 1 the subsequent ones are x_1, x_2, etc
X = np.array(([1]*n,x_1,x_2,x_3,x_4)).T
              
# The below code separates out the data set into two parts. The first part, a DataFrame called X, should contain 
# just the covariate information (i.e. the first 191 columns) standardised to have 
# mean 0 and standard deviation 1. The second part, called y, should contain just
# the RockOrNot variable.
X = (music.drop('RockOrNot',axis=1) - music.drop('RockOrNot',axis=1).mean())/music.drop('RockOrNot',axis=1).std()
y = music.RockOrNot
# Use corrwith and np.where to find which variable has the biggest correlation with y
cors = X.corrwith(y)
np.where(cors==max(cors))

 # So we now want each row to contain their rating and all their details
ratings_and_users = pd.merge(ratings,users) # notice how quick this is!
ratings_and_users.head(10)

# on, left_on, right_on arguments for merge
# Can specify the key on which to merge, but merge will automatically work this out if required
ratings_and_users = pd.merge(ratings,users,on='user_id')

# Suppose we want to join these two together? How might we want to join them?

# First consider stacking them on top of each other using concatenate
pd.concat([iphone_df,galaxy_df])
# What happens when the columns don't match exactly?
pd.concat([iphone_df.drop('Camera_MP',axis=1),galaxy_df])
# Can give it more than two objects
pd.concat([iphone_df,galaxy_df,iphone_df])

# What if instead we wanted it joined by year? Could use join
iphone_df.join(galaxy_df,lsuffix='x')
# Or you could go back to merge
pd.merge(iphone_df,galaxy_df,on='Year',how='outer')

# The cut method
# Let's suppose we had raw ages rather than age groups above and wanted to group
# them in the same way
ages = Series(npr.poisson(lam=40,size=100))
bins = [0,20,40,60]
age_groups = pd.cut(ages,bins)

# Or use qcut which cuts by quantiles
pd.qcut(ages,4) # quartiles
# You can give qcut your own quantiles
pd.qcut(ages,[0.,0.25,0.5,0.75,1.]) 

# 4 - Grouping, aggregate *****************************************************

# How many rows the dataset
data['item'].count()

# What was the longest phone call / data entry?
data['duration'].max()

# How many seconds of phone calls are recorded in total?
data['duration'][data['item'] == 'call'].sum()

# How many entries are there for each month?
data['month'].value_counts()

# Number of non-null unique network entries
data['network'].nunique()

#Split by month
data.groupby(['month']).groups.keys()

# Get the first entry for each month
data.groupby('month').first()

# Get the sum of the durations per month
data.groupby('month')['duration'].sum()

# Get the number of dates / entries in each month
data.groupby('month')['date'].count()

# What is the sum of durations, for calls only, to each network
data[data['item'] == 'call'].groupby('network')['duration'].sum()

# How many calls, texts, and data are sent per month, split by network_type?
data.groupby(['month', 'network_type'])['date'].count()

# Group the data frame by month and item and extract a number of stats from each group
data.groupby(['month', 'item']).agg({'duration':sum,      # find the sum of the durations for each group
                                     'network_type': "count", # find the number of network type entries
                                     'date': 'first'})    # get the first date per group

# 5 - Plotting ****************************************************************

# Let's go back to our default plot and think about adding titles and axis labels
plt.clf() 
plt.plot(diamonds.carat,diamonds.price,'go')
plt.ylabel('Price')
plt.xlabel('Carat')
plt.title('Scatter plot of price vs carat for Diamonds data')

# Let's change the axis limits
plt.clf() 
plt.plot(diamonds.carat,diamonds.price,'go')
plt.axis([0, 10, 0, 30000]) # list of [xmin, xmax, ymin, ymax]

# Sub-plots can be created using plt.subplot 
plt.figure()
plt.subplot(2,1,1) # 2 rows, 1 column, plot 1 (note: no plot zero)
plt.plot(diamonds.carat,diamonds.price,'go')
plt.subplot(2,1,2) # 2 rows, 1 column plot 2
plt.plot(diamonds.depth,diamonds.price,'r+')
# In exactly the same way as above you can edit each plot in whichever order you 
# like by simply calling subplot

# Adding legends to plots
plt.clf()
plt.plot(diamonds.carat,diamonds.price,'go',label='Original')
plt.plot(2*diamonds.carat,diamonds.price,'r+',label='New')
plt.legend(loc=4,numpoints=1)

# 6 - Statistics **************************************************************

# The below command will generate a random list of letters from abcdef of size 10
import numpy.random as npr
npr.choice(list('abcdef'),size=10)
# Suppose I want to generate a password of length 15 using all the letters a-z by joining this list together
# Type the command I should use (make sure the letters are in alphabetical order):
''.join(npr.choice(list('abcdefghijklmnopqrstuvwxyz'),size=15))

# Standardise the data
prostate_numeric = prostate.drop(['Unnamed: 0','train'],axis=1)
prostate_std = (prostate_numeric-prostate_numeric.mean())/prostate_numeric.std()

# Let's look for some outliers, let's say 3 sd from the mean
prostate_std[(np.abs(prostate_std)>3).any(1)] 
# Notice that the any(1) method here finds rows where this at least 1 outside the range
# Mostly these are to do with gleeson, let's have a look at the original data
prostate[(np.abs(prostate_std)>3).any(1)]

# First let's do a two sample test on lpsa vs age>65
lpsa_gt_65 = prostate.lpsa[prostate.age>65]
lpsa_lt_65 = prostate.lpsa[prostate.age<=65]

# The standard two-sample t-test with equal variances
stats.ttest_ind(lpsa_gt_65, lpsa_lt_65)

# Try a qq-plot
import matplotlib.pyplot as plt
fig = plt.figure()
ax = fig.add_subplot(111)
stats.probplot(prostate.lpsa, dist='norm',plot=ax)
# Looks pretty good to me!

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

# Example: create a plot of fitted values vs residuals
mod_summary = DataFrame({'preds':mod6.predict(),'resids':mod6.resid})
mod_summary.plot('preds','resids',kind='scatter')
# Looks like a pretty random scatter

# Note that this has two parts data and target
X_raw = DataFrame(diabetes.data,columns=['age','sex','bmi','bp','S1','S2','S3','S4','S5','S6'])
X_raw.describe() # 10 variables, 442 obs
# Standardise
X_raw_std = (X_raw-X_raw.mean())/X_raw.std()
y = Series(diabetes.target)
y.describe() # 1 response

# Add 100 columns of random noise columns at the end to make it harder
np.random.seed(123)
X = X_raw.join(DataFrame(np.random.randn(len(y), 100)))

# Create a training and test set of size 332 and 110 (approx 75%/25% split)
train_size = 332
np.random.seed(123)
train_select = np.random.permutation(range(len(y)))
X_train = X.ix[train_select[:train_size],:].reset_index(drop=True)
X_test = X.ix[train_select[train_size:],:].reset_index(drop=True)
y_train = y[train_select[:train_size]].reset_index(drop=True)
y_test = y[train_select[train_size:]].reset_index(drop=True)

# Load in the Prostate data and create a DataFrame X which contains the following columns:
# A column of 1s
# The variables lcavol, lweight, age, lbph, svi, lcp, gleason, and pgg45 standardised to have mean 0 and
# standard deviation 1
# Create a Series y which contains the lpsa also standardised
# Which column of X has the smallest correlation with y? age, lpbh, gleason or pgg45
import statsmodels.api as sm
prostate = pd.read_table('http://statweb.stanford.edu/~tibs/ElemStatLearn/datasets/prostate.data')
prostate_numeric = prostate.drop(['Unnamed: 0','train','lpsa'],axis=1)
prostate_std = (prostate_numeric-prostate_numeric.mean())/prostate_numeric.std()
X = sm.add_constant(prostate_std)
y = (prostate.lpsa-prostate.lpsa.mean())/prostate.lpsa.std()
X.corrwith(y) # smallest is age

# Use the OLS function from statsmodels.api to fit a linear regression with y as your response
# variable and The first two columns of X as the explanatory variables. 
# What is the adjusted R-square to 3dp?
mod = sm.OLS(y, X.ix[:,:2])
res = mod.fit()
print res.summary() # 0.535

mod = sm.OLS(y, X.ix[:,[0,1,2,5,4]]) # 184.2
res = mod.fit()
print res.summary() # 0.535
mod = sm.OLS(y, X.ix[:,[0,1,2,5,4,3]]) # 183.7
res = mod.fit()
print res.summary() # 0.535

#7 - Machine Learning    **************************************************************************

card=pd.read_csv('C:/Users/ITS/Desktop/Data_Fraud.csv')
card.head()
card.describe()

# How imbalanced is the dataset?
card['Class'].value_counts()

# Check for missing values
card.isnull().values.any()

# Simple correlation
columns = ['V1', 'V2', 'V3', 'V4', 'V5', 'V6', 'V7', 'V8', 'V9', 'V10',
       'V11', 'V12', 'V13', 'V14', 'V15', 'V16', 'V17', 'V18', 'V19', 'V20',
       'V21', 'V22', 'V23', 'V24', 'V25', 'V26', 'V27', 'V28',
       'Class', 'Time', 'Amount']
correlation = card[columns].corr(method='pearson')

# Test and Training 

card.drop(['Time','Amount'], axis=1, inplace=True)

Y = card['Class']
X = card.drop("Class",axis=1)

# Usoing test_train_split for test and training sets - 70/30 split. Random number generator
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.3, random_state=123)

# Check the relative number of observations

print(X_train.shape, X_test.shape)
print(Y_train.shape, Y_test.shape)

#Random Forest - Attempt 1

rfc = RandomForestClassifier()
rfc.fit(X_train,Y_train)
Y_pred = rfc.predict(X_test) 

# Show classification report, confusion matrix, accuracy score
print(classification_report(Y_pred,Y_test))
print(confusion_matrix(Y_test, Y_pred))
print(accuracy_score(Y_test,Y_pred))

false_positive_rate, true_positive_rate, thresholds = roc_curve(Y_test,Y_pred)
roc_auc=auc(false_positive_rate, true_positive_rate)
print(roc_auc)

plt.title('Receiver Operating Characteristic')
plt.plot(false_positive_rate, true_positive_rate, 'b', label='AUC=%0.2f'% roc_auc)
plt.legend(loc='lower right')
plt.plot([0,1],[0,1],'r--')
plt.xlim([-0.1,1.2])
plt.ylim([-0.1,1.2])
plt.ylabel('True Positive Rate')
plt.xlabel('False Positive Rate')
plt.show()








