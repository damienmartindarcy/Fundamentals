# Descriptive Statistics

import pandas as pd

data = {'name': ['Jason', 'Molly', 'Tina', 'Jake', 'Amy'], 
        'age': [42, 52, 36, 24, 73], 
        'preTestScore': [4, 24, 31, 2, 3],
        'postTestScore': [25, 94, 57, 62, 70]}
df = pd.DataFrame(data, columns = ['name', 'age', 'preTestScore', 'postTestScore'])
df

df['age'].sum()

df['preTestScore'].mean()

df['preTestScore'].cumsum()

df['preTestScore'].describe()

df['preTestScore'].count()

df['preTestScore'].min()

df['preTestScore'].max()

df['preTestScore'].median()

df['preTestScore'].var()

df['preTestScore'].std()

df['preTestScore'].skew()

df['preTestScore'].kurt()

df.corr()

df.cov()