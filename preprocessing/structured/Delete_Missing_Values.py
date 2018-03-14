# Delete missing values

# Load libraries
import numpy as np
import pandas as pd

# Create feature matrix
X = np.array([[1.1, 11.1], 
              [2.2, 22.2], 
              [3.3, 33.3], 
              [4.4, 44.4], 
              [np.nan, 55]])

# Remove observations with missing values
X[~np.isnan(X).any(axis=1)]