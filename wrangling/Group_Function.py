#Apply Functions By Group In Pandas

# import pandas as pd
import pandas as pd

# Create an example dataframe
data = {'Platoon': ['A','A','A','A','A','A','B','B','B','B','B','C','C','C','C','C'],
       'Casualties': [1,4,5,7,5,5,6,1,4,5,6,7,4,6,4,6]}
df = pd.DataFrame(data)
df

# Group df by df.platoon, then apply a rolling mean lambda function to df.casualties
df.groupby('Platoon')['Casualties'].apply(lambda x:x.rolling(center=False,window=2).mean())