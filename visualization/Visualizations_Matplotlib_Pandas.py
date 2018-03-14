## Lecture 8 code - Statistical graphics for Python

# We'll cover two main ways for creating graphics in Python, matplotlib and through pandas
# Matplotlib came installed as part of Canopy for me, so hopefully will be for you too
# If you don't have matplotlib go to Tools > Package Manager and install it now
# Later we'll cover the pandas version of this which does many similar things, but
# directly on DataFrames

# We'll cover scatter plots, histograms (and KDE), boxplots, bar charts, line plots, matrix scatter plots
# We'll cover lots of graph customisation options

# This lecture taken from the Matplotlib tutorial at http://matplotlib.org/1.3.1/ and Chapter 8 of McKinney

################################################################################

## Basics: 

# Three things about matplotlib:
# It's based on the plotting functions in MATLAB
# It's stateful, which means that you can adjust the current plot rather than re-creating it every time
# It's imported with:
import matplotlib.pyplot as plt

# We'll use the Diamonds data set here as it has a nice mix of quantitative and categorical data
import numpy as np
import pandas as pd
diamonds = pd.read_csv('/Volumes/MacintoshHD2/Dropbox/Teaching/DPP/Lecture1/Diamonds.csv')
#diamonds = pd.read_csv('/users/andrewparnell/Dropbox/Teaching/DPP/Lecture1/Diamonds.csv')

# Remind outselves of the variables
diamonds[:5]

# Let's start with a simple plot of carat vs price - we'll start by creating a figure
fig = plt.figure()
# This should open up a little grey matplotlib window 
# You can use figsize to set the figure size in inches
# We can now run 
plt.plot(diamonds.carat,diamonds.price)

# We can now close this figure with plt.close(), or clear it with plt.clf()

# Notice the little buttons on top of the matplotlib window - you can have a play around with these

# That plot is very messy - default is a line plot
# If you keep running that command it will overwrite and choose a new colour. Very odd

# The third argument you can add here determines the type of the plot, the default is 'b-' 
# which means blue solid line. To change it to green circles, use
plt.clf() # Clears the current plot window - otherwise overwrites previous plot
plt.plot(diamonds.carat,diamonds.price,'go')

# The third argument, known as the format string, has lots of arguments
# If you're not using something 'obvious' like the above, separate out the arguments to:
plt.clf() 
plt.plot(diamonds.carat,diamonds.price,color='green', marker='o', linestyle='None')
# For more possible specifications, see plt.plot?

# You can combine plots with two separate commands
plt.clf()
plt.plot(diamonds.carat,diamonds.price,'go')
plt.plot(2*diamonds.carat,diamonds.price,'r+')
# try re-running the above two separate and notice how it automatically updates the axes 

################################################################################

## Plotting extras 

# Let's go back to our default plot and think about adding titles and axis labels
plt.clf() 
plt.plot(diamonds.carat,diamonds.price,'go')
plt.ylabel('Price')
plt.xlabel('Carat')
plt.title('Scatter plot of price vs carat for Diamonds data')

# Let's change the axis limits
plt.clf() 
plt.plot(diamonds.carat,diamonds.price,'go')
plt.axis([0, 10, 0, 30000]) # list of [xmin, xmax, ymin, ymax]
# Calling plt.axis() without any arguments gives the current axis limits
# Alternatively call plt.xlim(), etc to get individual axis limits

# Let's change the tickmarks
plt.clf()
plt.plot(diamonds.carat,diamonds.price,'go')
plt.xticks(np.linspace(0,6,13))
plt.yticks(np.linspace(0,20000,21))

# Change the tick labels
plt.yticks(np.linspace(0,20000,5), ['Free!','Cheap','Pricey','Expensive','Ouch!'])

# Let's suppose we wanted to add some text to this
plt.clf()
plt.plot(diamonds.carat,diamonds.price,'go')
plt.text(4, 5000, 'Very big diamonds!')
# You can also do some very rich things here with font changes and even latex integration

# Add some grid lines - b is boolean and turns it off or on
plt.grid(b=True, which='major', color='0.6', linestyle=':')

# Change the horrible grey background - needs to be done by setting up the figure
plt.figure(facecolor='white')
plt.plot(diamonds.carat,diamonds.price,'go')

# Notice that now I have two figures and I can switch between
# Change the axes of figure 1
plt.figure(1)
plt.axis([0, 10, 0, 30000])
# Change the axes of figure 2 to something else
plt.figure(2)
plt.axis([0, 20, 0, 30000])

# Sub-plots can be created using plt.subplot 
plt.figure()
plt.subplot(2,1,1) # 2 rows, 1 column, plot 1 (note: no plot zero)
plt.plot(diamonds.carat,diamonds.price,'go')
plt.subplot(2,1,2) # 2 rows, 1 column plot 2
plt.plot(diamonds.depth,diamonds.price,'r+')
# In exactly the same way as above you can edit each plot in whichever order you 
# like by simply calling subplot

# Adding legends to plots
plt.clf()
plt.plot(diamonds.carat,diamonds.price,'go',label='Original')
plt.plot(2*diamonds.carat,diamonds.price,'r+',label='New')
plt.legend(loc=4,numpoints=1) # Very bizarre default option is numpoints=2

# You can also do some more advanced things with legends for complicated plots
# but we will not cover these until we meet groupby

# Saving plots to file
plt.savefig('my_fig_path.pdf')
# The format is inferred from the file extension
# Note that the figure size is given by the options to the plot when you create it

################################################################################

## Plotting with pandas

# You can do lots of plots with matplotlib but it's easier to link them
# with Pandas so we'll focus on that from now on

# Can create a line plot directly from a Series
plt.clf()
diamonds.price.plot() # Note that it automatically assumes the x-axis is the index

# Most of the other plotting features we've already seen still work
plt.grid(b=True, which='minor', color='0.5', linestyle=':')
plt.yticks(np.linspace(0,20000,21))

# If you just plot a DataFrame it will give you multiple line plots
plt.clf()
diamonds.plot() # Not particularly helpful here

# There are some useful arguments here that are specific to DataFrames
diamonds.plot(subplots=True) # Plots each column in a separate sub-plot
#  See diamonds.plot? for many more arguments

# Let's try a bar chart
plt.clf()
diamonds.color.value_counts().plot(kind='bar')
# Or horizontal
plt.clf()
diamonds.color.value_counts(sort=False).plot(kind='barh',color='r',alpha=0.6)
# Or multiple bar charts
plt.clf()
pd.crosstab(diamonds.cut,diamonds.color).plot(kind='bar')
# Or stacked
pd.crosstab(diamonds.cut,diamonds.color).plot(kind='bar'),stacked=True)

# Histograms and kernel density estimation
plt.clf()
diamonds.price.hist(bins=50) # Very skewed!
# Bins will also accept a list
plt.clf()
diamonds.price.hist(bins=np.linspace(0,20000,21))
# Can add a kernel density estimate over this too
plt.clf()
diamonds.price.hist(bins=30,normed=True,color='b',alpha=0.2)
diamonds.price.plot(kind='kde',style='k--',linewidth=2.0)

# Box plots
plt.clf()
diamonds.boxplot('price')
# Or split by colour
diamonds.boxplot('price',by='color')
# Or by cut, with notched boxplots
diamonds.boxplot('price',by='cut',notch=True)
# Colouring these in is fiddly

# Matrix scatter plots - this one a bit slow
pd.scatter_matrix(diamonds,diagonal='kde',color='g', alpha = 0.4)
# If the above is too slow try:
pd.scatter_matrix(diamonds.ix[:,['x','y','z']],diagonal='kde',color='g', alpha = 0.4)
# Notice the correlation between the different dimension measurements - common diamon cuts?


