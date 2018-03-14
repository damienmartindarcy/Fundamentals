# Drop rows and columns

import pandas as pd

data = {'name': ['Jason', 'Molly', 'Tina', 'Jake', 'Amy'], 
        'year': [2012, 2012, 2013, 2014, 2014], 
        'reports': [4, 24, 31, 2, 3]}
df = pd.DataFrame(data, index = ['Cochice', 'Pima', 'Santa Cruz', 'Maricopa', 'Yuma'])
df

df.drop(['Cochice', 'Pima'])

df.drop('reports', axis=1)

df[df.name != 'Tina']

df.drop(df.index[2])

df.drop(df.index[[2,3]])

df.drop(df.index[-2])

df[:3] #keep top 3

df[:-3] #drop bottom 3 