# Apply operations over pandas dataframe

import pandas as pd
import numpy as np

data = {'name': ['Jason', 'Molly', 'Tina', 'Jake', 'Amy'], 
        'year': [2012, 2012, 2013, 2014, 2014], 
        'reports': [4, 24, 31, 2, 3],
        'coverage': [25, 94, 57, 62, 70]}
df = pd.DataFrame(data, index = ['Cochice', 'Pima', 'Santa Cruz', 'Maricopa', 'Yuma'])
df

capitalizer = lambda x: x.upper()

df['name'].apply(capitalizer)

df['name'].map(capitalizer)

# Drop the string variable so that applymap() can run
df = df.drop('name', axis=1)

# Return the square root of every cell in the dataframe
df.applymap(np.sqrt)

# create a function called times100
def times100(x):
    # that, if x is a string,
    if type(x) is str:
        # just returns it untouched
        return x
    # but, if not, return it multiplied by 100
    elif x:
        return 100 * x
    # and leave everything else
    else:
        return
    
df.applymap(times100)    