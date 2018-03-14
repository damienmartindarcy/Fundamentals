# required packages
library(twitteR)
library(ggplot2)
library(plyr)
library(stringr)
library(wordcloud)
library(tm)
require(doBy)
library (syuzhet)

## Twitter authentication
setup_twitter_oauth("tdGfocBcTNfXTdCSM3GSBMJiV","GA60f5osWiGHubUexI7sUPUkYwp2hsIhBAcDyqagOy8jXtZMLI","817013958976663552-SMjlMIadUYzCremNsfIFXjPyWG3J44v",
                    "WVO6ga7O8LLjT0uhNcmgowVr0kLhFXnPBGvfD0P7qZDeQ")

# retrieve the first 100 tweets (or all tweets if fewer than 100) from the
# user timeline of @rdatammining
tweets <- userTimeline("trump", n=100)
nDocs <- length(tweets)

##convert tweets to data frame
df <- do.call("rbind", lapply(tweets, as.data.frame))
dim(df)

myCorpus <- Corpus(VectorSource(df$text))
myCorpus <- tm_map(myCorpus, removePunctuation)
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
myCorpus <- tm_map(myCorpus, removeWords, stopwords("english")) #removes common prepositions and conjunctions 
myCorpus <- tm_map(myCorpus, removeWords, c("example"))
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
myCorpus <- tm_map(myCorpus, removeURL)
myCorpus <- tm_map(myCorpus, stripWhitespace)
corpus_clean <- tm_map(myCorpus, PlainTextDocument) ##this ensures the corpus transformations final output is a PTD
##optional, remove word stems (cleaning, cleaned, cleaner all would become clean): 
##wordCorpus <- tm_map(wordCorpus, stemDocument)


#create term document matrix for analysis
myTdm <- TermDocumentMatrix(corpus_clean, control=list(wordLengths=c(1,Inf)))
myTdm


##or create a word cloud from the corpus_clean data 
pal <- brewer.pal(9,"YlGnBu")
pal <- pal[-(1:4)]
set.seed(123)
wordcloud(words = corpus_clean, scale=c(4,0.5), max.words=50, random.order=FALSE, 
          rot.per=0.35, use.r.layout=TRUE, colors=pal)

# But what are the sentiments behind this?

mySentiment <- get_nrc_sentiment(df$text)

df <- cbind(df, mySentiment)

sentimentTotals <- data.frame(colSums(df[,c(17:25)])) ##select columns with sentiment data
names(sentimentTotals) <- "count" 
sentimentTotals <- cbind("sentiment" = rownames(sentimentTotals), sentimentTotals)
rownames(sentimentTotals) <- NULL ##graph would be messy if these were left when plotting
ggplot(data = sentimentTotals, aes(x = sentiment, y = count)) +
  geom_bar(aes(fill = sentiment), stat = "identity") +
  theme(legend.position = "none") +
  xlab("Sentiment") + ylab("Total Count") + ggtitle("Total Sentiment Score")