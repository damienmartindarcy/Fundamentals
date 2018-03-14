# Data Cleaning on the airbnb dataset

import pandas as pd
import numpy as np

# 1 - Import data
print("Reading in data...")
tr_filepath = "./train_users_2.csv"
df_train = pd.read_csv(tr_filepath, header=0, index_col=None)
te_filepath = "./test_users.csv"
df_test = pd.read_csv(te_filepath, header=0, index_col=None)

# Combine into one dataset
df_all = pd.concat((df_train, df_test), axis=0, ignore_index=True)

# 2 - Change Dates to consistent format
print("Fixing timestamps...")
df_all['date_account_created'] = pd.to_datetime(df_all['date_account_created'], format='%Y-%m-%d')
df_all['timestamp_first_active'] = pd.to_datetime(df_all['timestamp_first_active'], format='%Y%m%d%H%M%S')
df_all['date_account_created'].fillna(df_all.timestamp_first_active, inplace=True)

# 3 - Remove date_first_booking column
df_all.drop('date_first_booking', axis=1, inplace=True)

# 4 - Clean the age column
# Remove outliers function
def remove_outliers(df, column, min_val, max_val): 
    col_values = df[column].values
    df[column] = np.where(np.logical_or(col_values<=min_val, col_values>=max_val), np.NaN, col_values)
    return df

# Fixing age column
print("Fixing age column...")
df_all = remove_outliers(df=df_all, column='age', min_val=15, max_val=90)
df_all['age'].fillna(-1, inplace=True)

# 5 - Identify other columns with missing values
# Fill first_affiliate_tracked column
print("Filling first_affiliate_tracked column...")
df_all['first_affiliate_tracked'].fillna(-1, inplace=True)

