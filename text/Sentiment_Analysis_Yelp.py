# NLP

# Yelp data set from Kaggle - attempting to identify reviews from 1 to 5 stars

import numpy as np
import pandas as pd

yelp = pd.read_csv('yelp.csv')

yelp.head()

yelp.info()
yelp.describe()

yelp['text length'] = yelp['text'].apply(len)

# EDA
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_style('white')

g = sns.FacetGrid(yelp,col='stars')
g.map(plt.hist,'text length')

sns.boxplot(x='stars',y='text length',data=yelp,palette='rainbow')

sns.countplot(x='stars',data=yelp,palette='rainbow')

stars = yelp.groupby('stars').mean()
stars

stars.corr()

sns.heatmap(stars.corr(),cmap='coolwarm',annot=True)

# Approach 1 - Countvectorizer and multinomialNB

yelp_class = yelp[(yelp.stars==1) | (yelp.stars==5)]

X = yelp_class['text']
y = yelp_class['stars']

from sklearn.feature_extraction.text import CountVectorizer
cv = CountVectorizer()

X = cv.fit_transform(X)

from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(X, y,test_size=0.3,random_state=101)

# Train model
from sklearn.naive_bayes import MultinomialNB
nb = MultinomialNB()

nb.fit(X_train,y_train)

predictions = nb.predict(X_test)

from sklearn.metrics import confusion_matrix,classification_report

print(confusion_matrix(y_test,predictions))
print('\n')
print(classification_report(y_test,predictions))

# Approach 2 - Text Processing / TF-IDF

from sklearn.feature_extraction.text import  TfidfTransformer

from sklearn.pipeline import Pipeline

pipeline = Pipeline([
    ('bow', CountVectorizer()),  # strings to token integer counts
    ('tfidf', TfidfTransformer()),  # integer counts to weighted TF-IDF scores
    ('classifier', MultinomialNB()),  # train on TF-IDF vectors w/ Naive Bayes classifier
])

X = yelp_class['text']
y = yelp_class['stars']
X_train, X_test, y_train, y_test = train_test_split(X, y,test_size=0.3,random_state=101)

# May take some time
pipeline.fit(X_train,y_train)

predictions = pipeline.predict(X_test)

print(confusion_matrix(y_test,predictions))
print(classification_report(y_test,predictions))


