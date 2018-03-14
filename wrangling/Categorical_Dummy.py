# Categorical to dummy conversion

# import modules
import pandas as pd

# Create a dataframe
raw_data = {'first_name': ['Jason', 'Molly', 'Tina', 'Jake', 'Amy'], 
        'last_name': ['Miller', 'Jacobson', 'Ali', 'Milner', 'Cooze'], 
        'sex': ['male', 'female', 'male', 'female', 'female']}
df = pd.DataFrame(raw_data, columns = ['first_name', 'last_name', 'sex'])
df

# Create a set of dummy variables from the sex variable
df_sex = pd.get_dummies(df['sex'])
# Join the dummy variables to the main dataframe
df_new = pd.concat([df, df_sex], axis=1)
df_new

# Alterative for joining the new columns
df_new = df.join(df_sex)
df_new