# Moving Averages / Rolling Mean

# Import pandas
import pandas as pd

# Create data
data = {'score': [1,1,1,2,2,2,3,3,3]}

# Create dataframe
df = pd.DataFrame(data)

# View dataframe
df

# Calculate the moving average. That is, take
# the first two values, average them, 
# then drop the first and add the third, etc.
df.rolling(window=2).mean()
