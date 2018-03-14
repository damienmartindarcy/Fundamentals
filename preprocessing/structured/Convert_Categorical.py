# Convert categorical for scikit learn

# Import required packages
from sklearn import preprocessing
import pandas as pd

raw_data = {'patient': [1, 1, 1, 2, 2],
        'obs': [1, 2, 3, 1, 2],
        'treatment': [0, 1, 0, 1, 0],
        'score': ['strong', 'weak', 'normal', 'weak', 'strong']}
df = pd.DataFrame(raw_data, columns = ['patient', 'obs', 'treatment', 'score'])

# Create a label (category) encoder object
le = preprocessing.LabelEncoder()
# Fit the encoder to the pandas column
le.fit(df['score']

# Apply the fitted encoder to the pandas column
le.transform(df['score']) 

# Convert some integers into their category names
list(le.inverse_transform([2, 2, 1]))