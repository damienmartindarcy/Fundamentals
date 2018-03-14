# Counter

#Create Counts Of Items

from collections import Counter
# Create A Counter

# Create a counter of the fruits eaten today
fruit_eaten = Counter(['Apple', 'Apple', 'Apple', 'Banana', 'Pear', 'Pineapple'])

# View counter
fruit_eaten
Counter({'Apple': 3, 'Banana': 1, 'Pear': 1, 'Pineapple': 1})

#Update The Count For An Element
# Update the count for 'Pineapple' (because you just ate an pineapple)
fruit_eaten.update(['Pineapple'])

# View the counter
fruit_eaten
Counter({'Apple': 3, 'Banana': 1, 'Pear': 1, 'Pineapple': 2})

#View The Items With The Highest Counts
# View the items with the top 3 counts
fruit_eaten.most_common(3)
