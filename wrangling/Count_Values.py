# Count Values

#Import the pandas module
import pandas as pd

#Create all the columns of the dataframe as series
year = pd.Series([1875, 1876, 1877, 1878, 1879, 1880, 1881, 1882, 1883, 1884, 
                  1885, 1886, 1887, 1888, 1889, 1890, 1891, 1892, 1893, 1894])
guardCorps = pd.Series([0,2,2,1,0,0,1,1,0,3,0,2,1,0,0,1,0,1,0,1])
corps1 = pd.Series([0,0,0,2,0,3,0,2,0,0,0,1,1,1,0,2,0,3,1,0])
corps2 = pd.Series([0,0,0,2,0,2,0,0,1,1,0,0,2,1,1,0,0,2,0,0])
corps3 = pd.Series([0,0,0,1,1,1,2,0,2,0,0,0,1,0,1,2,1,0,0,0])
corps4 = pd.Series([0,1,0,1,1,1,1,0,0,0,0,1,0,0,0,0,1,1,0,0])
corps5 = pd.Series([0,0,0,0,2,1,0,0,1,0,0,1,0,1,1,1,1,1,1,0])
corps6 = pd.Series([0,0,1,0,2,0,0,1,2,0,1,1,3,1,1,1,0,3,0,0])
corps7 = pd.Series([1,0,1,0,0,0,1,0,1,1,0,0,2,0,0,2,1,0,2,0])
corps8 = pd.Series([1,0,0,0,1,0,0,1,0,0,0,0,1,0,0,0,1,1,0,1])
corps9 = pd.Series([0,0,0,0,0,2,1,1,1,0,2,1,1,0,1,2,0,1,0,0])
corps10 = pd.Series([0,0,1,1,0,1,0,2,0,2,0,0,0,0,2,1,3,0,1,1])
corps11 = pd.Series([0,0,0,0,2,4,0,1,3,0,1,1,1,1,2,1,3,1,3,1])
corps14 = pd.Series([ 1,1,2,1,1,3,0,4,0,1,0,3,2,1,0,2,1,1,0,0])
corps15 = pd.Series([0,1,0,0,0,0,0,1,0,1,1,0,0,0,2,2,0,0,0,0])

#Create a dictionary variable that assigns variable names
variables = dict(guardCorps = guardCorps, corps1 = corps1, 
                 corps2 = corps2, corps3 = corps3, corps4 = corps4, 
                 corps5 = corps5, corps6 = corps6, corps7 = corps7, 
                 corps8 = corps8, corps9 = corps9, corps10 = corps10, 
                 corps11 = corps11 , corps14 = corps14, corps15 = corps15)

#Create a dataframe and set the order of the columns using the columns attribute
horsekick = pd.DataFrame(variables, columns = ['guardCorps', 
                                                    'corps1', 'corps2', 
                                                    'corps3', 'corps4', 
                                                    'corps5', 'corps6', 
                                                    'corps7', 'corps8', 
                                                    'corps9', 'corps10', 
                                                    'corps11', 'corps14', 
                                                    'corps15'])

#Set the dataframe’s index to be year
horsekick.index = [1875, 1876, 1877, 1878, 1879, 1880, 1881, 1882, 1883, 1884, 
                  1885, 1886, 1887, 1888, 1889, 1890, 1891, 1892, 1893, 1894]

# View the horsekick dataframe
horsekick