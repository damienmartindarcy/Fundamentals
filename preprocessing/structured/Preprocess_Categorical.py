# Preprocess categorical labels

from sklearn import preprocessing
from sklearn.pipeline import Pipeline
import pandas as pd

raw_data = {'first_name': ['Jason', 'Molly', 'Tina', 'Jake', 'Amy'], 
        'last_name': ['Miller', 'Jacobson', 'Ali', 'Milner', 'Cooze'], 
        'age': [42, 52, 36, 24, 73], 
        'city': ['San Francisco', 'Baltimore', 'Miami', 'Douglas', 'Boston']}
df = pd.DataFrame(raw_data, columns = ['first_name', 'last_name', 'age', 'city'])
df

# Create dummy variables for every unique category in df.city
pd.get_dummies(df["city"])

# Convert strings categorical names to integers
integerized_data = preprocessing.LabelEncoder().fit_transform(df["city"])

# View data
integerized_data

# Convert integer categorical representations to OneHot encodings
preprocessing.OneHotEncoder().fit_transform(integerized_data.reshape(-1,1)).toarray()

