# This allows us to compare the favourability of two (or more) twitter accounts

# required packages
library(twitteR)
library(ggplot2)
library(plyr)
library(stringr)
require(doBy)

## Twitter authentication
setup_twitter_oauth("tdGfocBcTNfXTdCSM3GSBMJiV","GA60f5osWiGHubUexI7sUPUkYwp2hsIhBAcDyqagOy8jXtZMLI","817013958976663552-SMjlMIadUYzCremNsfIFXjPyWG3J44v",
                    "WVO6ga7O8LLjT0uhNcmgowVr0kLhFXnPBGvfD0P7qZDeQ")

# Lexicon Time
negative_words = scan("negative-words.txt", what="character", comment.char=";")
positive_words = scan("positive-words.txt", what="character", comment.char=";")

# Create the score sentiment function. The first parameter is the list of tweets.
# The second and third parameters are the lists of positive and negative words.
# The last parameter indicates that we don't want to see a progress bar while the function executes.
score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
  
  # Laply is from the plyr package, and will apply the function passed as second parameter to the
  # list of variables passed as first parameter. The "l" means we pass a list, the "a" that it will
  # return an array, and "ply" is standard for these functions.
  scores = laply(sentences, function(sentence, pos.words, neg.words) {
    
    # Clean up the sentences with gsub() to allow word matching and convert them to lower case
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub("[^[:alnum:]///' ]", '', sentence)
    sentence = gsub('\\d+', '', sentence)
    sentence = tolower(sentence)
    
    # split into words. str_split is in the stringr package
    word.list = str_split(sentence, '\\s+')
    # sometimes a list() is one level of hierarchy too much
    words = unlist(word.list)
    
    # compare our words to the dictionaries of positive & negative terms
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
    
    # Converting matches to True or False
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    
    # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
    score = sum(pos.matches) - sum(neg.matches)
    
    return(score)
  }, pos.words, neg.words, .progress=.progress )
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}

# Pull the tweets 
dbi.tweets <- searchTwitter('@StigAbell', n=3200, lang= 'en')

dbi.text <- laply(dbi.tweets, function(t) t$getText())
dbi.score <- score.sentiment(dbi.text, positive_words, negative_words)
dbi.score$name = 'DBi'
dbi.score$code = 'DBi'

# Now we need something to compare this to
fb.tweets <- searchTwitter('@DPJHodges', n=3200, lang= 'en')
fb.text <- laply(fb.tweets, function(t) t$getText())

fb.score <- score.sentiment(fb.text, positive_words, negative_words)
fb.score$name = 'Facebook'
fb.score$code = 'FB'

all.scores = rbind(fb.score, dbi.score)
g = ggplot(data=all.scores, mapping=aes(x=score, fill=name))
g = g + geom_bar(binwidth=1)
g = g + facet_grid(name~.)
g = g + theme_bw()
g

# Then we head towards a score table
all.scores$very.pos.bool <- all.scores$score < 0
all.scores$very.neg.bool <- all.scores$score > 2

twitter.df <- ddply(all.scores, c('name', 'code'), summarise, very.pos.count=sum( very.pos.bool ), very.neg.count=sum( very.neg.bool ))
twitter.df$very.tot = twitter.df$very.pos.count + twitter.df$very.neg.count
twitter.df$score = round( 100 * twitter.df$very.pos.count / twitter.df$very.tot )

orderBy(~-score, twitter.df)

# Some of the more negative tweets
unique(fb.score[fb.score$score<0,'text'])
unique(dbi.score[dbi.score$score<0,'text'])

