import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from pandas import Series, DataFrame
import statsmodels.formula.api as smf
import statsmodels.api as sm
import sklearn
from sklearn.cross_validation import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import confusion_matrix
from sklearn.metrics import classification_report
from sklearn.metrics import accuracy_score

#Q1 ******* Air Quality

air=pd.read_csv('C:/Users/ITS/Desktop/airquality.csv')

#A
air.corr()

#B
air.Ozone.isnull().sum()

#C

def sd_impute(x, imp):
answer = Series(np.zeros(len(x)))
for i in range(len(x)):
if imp == 'y':
answer.ix[i] = 1
elif x.ix[i] == 'n':
answer.ix[i] = -1
else:
answer.ix[i] = 0
return answer

salary.fillna(salary.mean())

air.Ozone.std(axis=0, skipna=False)
Ozone2=air.Ozone.fillna(0)
Ozone2.std()

#D
airquality2=air.drop(['Solar.R','Wind'],axis=1)
airquality2=airquality2.dropna()

plt.clf() 
plt.plot(airquality2.Temp,airquality2.Ozone,'go')
plt.ylabel('Ozone')
plt.xlabel('Temp')
plt.title('Scatter plot of Ozone vs Temp for Wind data')

#E

import statsmodels.formula.api as smf
import seaborn as sns

mod2 = smf.ols(formula='Ozone ~ Temp',data=airquality2)
res2 = mod2.fit()
res2.summary()

plt.figure()
plt.subplot(2,1,1)
sns.residplot('Ozone','Temp', data=airquality2)
plt.subplot(2,1,2)
plt.plot(airquality2.Temp,airquality2.Ozone,'go')
plt.ylabel('Ozone')
plt.xlabel('Temp')
plt.title('Scatter plot of Ozone vs Temp for Wind data')

#Q2 ******* Votes

votes=pd.read_csv('C:/Users/ITS/Desktop/HouseVotes84.csv')

#A

z=votes.Class
z=z.replace(['republican','democrat'],[0,1])
z.value_counts()

#B

x=votes.V16.replace(['y','n','nan'],['1','-1','0'])
y=x.fillna(0)
y.value_counts()

#C
votes=votes.drop('Class', axis=1)
votes=votes.replace(['y','n','nan'],[1,-1,0])
votes=votes.fillna(0)
votes=statsmodels.tools.tools.add_constant(votes, prepend=True)
votes.as_matrix # If you have to

#D

train_size = 326
np.random.seed(123)
train_select = np.random.permutation(range(len(votes)))
X_train = votes.ix[train_select[:train_size],:].reset_index(drop=True)
X_test = votes.ix[train_select[train_size:],:].reset_index(drop=True)
y_train = z[train_select[:train_size]].reset_index(drop=True)
y_test = z[train_select[train_size:]].reset_index(drop=True)

#E
from sklearn.linear_model import LogisticRegression
logreg = LogisticRegression()
logreg.fit(X_train, y_train) 
logreg_test_pred = logreg.predict(X_test)
logreg_cross = pd.crosstab(logreg_test_pred,y_test).astype('float')
(logreg_cross.ix[0,1]+logreg_cross.ix[1,0])/np.sum(logreg_cross.values)

#F

#Q3 ******* Results

students=pd.read_csv('C:/Users/ITS/Desktop/students.csv')
comments=pd.read_csv('C:/Users/ITS/Desktop/comments.csv')
marks=pd.read_csv('C:/Users/ITS/Desktop/marks.csv')

#A - Merge

students_and_marks = pd.merge(students,marks,left_on='Student ID',right_on='StudentID') # notice how quick this is!
students_and_marks.describe()
students_and_marks.sort_values(by='Exam', axis=0, ascending=False)

#B - Calculated Column

students_and_marks['final_percentage']=students_and_marks.Coursework+students_and_marks.Project*0.2+students_and_marks.Exam*0.7
pd.qcut(students_and_marks.final_percentage,[0.,0.25,0.5,0.75,1.]) 
students_and_marks.describe()

#C - Binning 
bins = [0, 30, 40, 50, 60, 70, 100]
group_names = ['F', 'E', 'D', 'C', 'B', 'A']
categories = pd.cut(students_and_marks['final_percentage'], bins, labels=group_names)
students_and_marks['Final_grade'] = pd.cut(students_and_marks['final_percentage'], bins, labels=group_names)
categories
pd.value_counts(students_and_marks['Final_grade'])

#D

students_and_marks[students_and_marks['Comments'].str.contains("lecturer|Lecturer")==True]

#E

import re
good_re = re.compile('enjoy|good|excellent|love|great',flags=re.IGNORECASE)
answer = np.zeros(len(students_and_marks.Comments)).astype('int')
for i in range(len(students_and_marks.Comments)):
    a = good_re.search(students_and_marks.Comments[i])
    if a!=None:
        answer[i] = 1

#F

answer.mean()




