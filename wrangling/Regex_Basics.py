# Regular Expression Basics

# Import the regex (re) package
import re
# Import sys
import sys
# Create a simple text string.
text = 'The quick brown fox jumped over the lazy black bear.'

# Create a pattern to match
three_letter_word = '\w{3}'

#Convert the string into a regex object
pattern_re = re.compile(three_letter_word); pattern_re
re.compile(r'\w{3}', re.UNICODE)

#Does a three letter word appear in text?
re_search = re.search('..own', text)

#If the search query is at all true,

if re_search:
    # Print the search results
    print(re_search.group())
#brown

re.match
# re.match() is for matching ONLY the beginning of a string or the whole string For anything else, use re.search

# Match all three letter words in text
re_match = re.match('..own', text)

#If re_match is true, print the match, else print “No Matches”
if re_match:
    # Print all the matches
    print(re_match.group())
else:
    # Print this
    print('No matches')
# No matches

re.split

#Split up the string using “e” as the seperator.
re_split = re.split('e', text); re_split
['Th', ' quick brown fox jump', 'd ov', 'r th', ' lazy black b', 'ar.']
re.sub

#Replaces occurrences of the regex pattern with something else
re_sub = re.sub('e', 'E', text, 3); print(re_sub)