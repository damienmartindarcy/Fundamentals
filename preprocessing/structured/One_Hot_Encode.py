# One hot encode - multiple labels

# Load libraries
from sklearn.preprocessing import MultiLabelBinarizer
import numpy as np

# Create NumPy array
y = [('Texas', 'Florida'), 
    ('California', 'Alabama'), 
    ('Texas', 'Florida'), 
    ('Delware', 'Florida'), 
    ('Texas', 'Alabama')]

# Create MultiLabelBinarizer object
one_hot = MultiLabelBinarizer()

# One-hot encode data
one_hot.fit_transform(y)

# View classes
one_hot.classes_