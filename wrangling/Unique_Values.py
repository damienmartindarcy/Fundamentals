# Find unique values

import pandas as pd
import numpy as np
raw_data = {'regiment': ['51st', '29th', '2nd', '19th', '12th', '101st', '90th', '30th', '193th', '1st', '94th', '91th'], 
            'trucks': ['MAZ-7310', np.nan, 'MAZ-7310', 'MAZ-7310', 'Tatra 810', 'Tatra 810', 'Tatra 810', 'Tatra 810', 'ZIS-150', 'Tatra 810', 'ZIS-150', 'ZIS-150'],
            'tanks': ['Merkava Mark 4', 'Merkava Mark 4', 'Merkava Mark 4', 'Leopard 2A6M', 'Leopard 2A6M', 'Leopard 2A6M', 'Arjun MBT', 'Leopard 2A6M', 'Arjun MBT', 'Arjun MBT', 'Arjun MBT', 'Arjun MBT'],
            'aircraft': ['none', 'none', 'none', 'Harbin Z-9', 'Harbin Z-9', 'none', 'Harbin Z-9', 'SH-60B Seahawk', 'SH-60B Seahawk', 'SH-60B Seahawk', 'SH-60B Seahawk', 'SH-60B Seahawk']}

df = pd.DataFrame(raw_data, columns = ['regiment', 'trucks', 'tanks', 'aircraft'])

# View the top few rows
df.head()

# Create a list of unique values by turning the
# pandas column into a set
list(set(df.trucks))

# Create a list of unique values in df.trucks
list(df['trucks'].unique())