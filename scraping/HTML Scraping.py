# Import required modules
import requests
from bs4 import BeautifulSoup

# Scrape and turn url into Beautiful Soup Object
# Create a variable with the url
url = 'http://chrisralbon.com'

# Use requests to get the contents
r = requests.get(url)

# Get the text of the contents
html_content = r.text

# Convert the html content into a beautiful soup object
soup = BeautifulSoup(html_content, 'lxml')

# View the title tag of the soup object
soup.title

# View the string within the title tag
soup.title.string

# view the paragraph tag of the soup
soup.p

soup.title.parent.name

soup.a

soup.find_all('a')[0:5]

soup.p.string

#Find all the h2 tags and list the first five
soup.find_all('h2')[0:5]

# Find all the links on the page and list the first five
soup.find_all('a')[0:5]
