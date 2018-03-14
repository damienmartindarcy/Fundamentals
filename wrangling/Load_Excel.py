# Load Excel

# Load library
import pandas as pd

# Load Excel File
# Create URL to Excel file (alternatively this can be a filepath)
url = 'https://raw.githubusercontent.com/chrisalbon/simulated_datasets/master/data.xlsx'

# Load the first sheet of the Excel file into a data frame
df = pd.read_excel(url, sheetname=0, header=1)

# View the first ten rows
df.head(10)