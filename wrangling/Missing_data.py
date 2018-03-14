# Missing Data

import pandas as pd
import numpy as np

#Create dataframe with missing values
raw_data = {'first_name': ['Jason', np.nan, 'Tina', 'Jake', 'Amy'], 
        'last_name': ['Miller', np.nan, 'Ali', 'Milner', 'Cooze'], 
        'age': [42, np.nan, 36, 24, 73], 
        'sex': ['m', np.nan, 'f', 'm', 'f'], 
        'preTestScore': [4, np.nan, np.nan, 2, 3],
        'postTestScore': [25, np.nan, np.nan, 62, 70]}
df = pd.DataFrame(raw_data, columns = ['first_name', 'last_name', 'age', 'sex', 'preTestScore', 'postTestScore'])
df

df_no_missing = df.dropna()
df_no_missing

df_cleaned = df.dropna(how='all')
df_cleaned

df['location'] = np.nan
df

df.dropna(axis=1, how='all')

df.dropna(thresh=5)

df.fillna(0)

df["preTestScore"].fillna(df["preTestScore"].mean(), inplace=True)
df

df["postTestScore"].fillna(df.groupby("sex")["postTestScore"].transform("mean"), inplace=True)
df

# Select the rows of df where age is not NaN and sex is not NaN
df[df['age'].notnull() & df['sex'].notnull()]
