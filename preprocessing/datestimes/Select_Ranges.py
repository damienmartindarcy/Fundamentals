# Select date and time ranges

# Load library
import pandas as pd

# Create data frame
df = pd.DataFrame()

# Create datetimes
df['date'] = pd.date_range('1/1/2001', periods=100000, freq='H')

# Method 1 - if not indexed by time

# Select observations between two datetimes
df[(df['date'] > '2002-1-1 01:00:00') & (df['date'] <= '2002-1-1 04:00:00')]

# Method 2 - if indexed by time
# Set index
df = df.set_index(df['date'])

# Select observations between two datetimes
df.loc['2002-1-1 01:00:00':'2002-1-1 04:00:00']