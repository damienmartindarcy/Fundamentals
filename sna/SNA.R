# Twitter 2 - and social network analysis - Stig Abells tweets

library(twitteR)
library(ROAuth)
## Twitter authentication
setup_twitter_oauth("tdGfocBcTNfXTdCSM3GSBMJiV","GA60f5osWiGHubUexI7sUPUkYwp2hsIhBAcDyqagOy8jXtZMLI","817013958976663552-SMjlMIadUYzCremNsfIFXjPyWG3J44v",
"WVO6ga7O8LLjT0uhNcmgowVr0kLhFXnPBGvfD0P7qZDeQ")
## 3200 is the maximum to retrieve
tweets <- userTimeline("StigAbell", n = 3200)

(n.tweet <- length(tweets))

# convert tweets to a data frame
tweets.df <- twListToDF(tweets)

# tweet #2
tweets.df[150, c("id", "created", "screenName", "replyToSN",
                 "favoriteCount", "retweetCount", "longitude", "latitude", "text")]

# Tweet #2  - fit for slide width
writeLines(strwrap(tweets.df$text[150], 60))

# Text Cleaning - again
library(tm)
# build a corpus, and specify the source to be character vectors
myCorpus <- Corpus(VectorSource(tweets.df$text))
# convert to lower case
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
# remove URLs
removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeURL))
# remove anything other than English letters or space
removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeNumPunct))
# remove stopwords
myStopwords <- c(setdiff(stopwords('english'), c("TLS", "Trump")),
                 "use", "see", "used", "via", "amp")
myCorpus <- tm_map(myCorpus, removeWords, myStopwords)
# remove extra whitespace
myCorpus <- tm_map(myCorpus, stripWhitespace)
# keep a copy for stem completion later
myCorpusCopy <- myCorpus

myCorpus <- tm_map(myCorpus, stemDocument) # stem words
writeLines(strwrap(myCorpus[[2]]$content, 60))

stemCompletion2 <- function(x, dictionary) {
x <- unlist(strsplit(as.character(x), " "))
x <- x[x != ""]
x <- stemCompletion(x, dictionary=dictionary)
x <- paste(x, sep="", collapse=" ")
PlainTextDocument(stripWhitespace(x))
}
myCorpus <- lapply(myCorpus, stemCompletion2, dictionary=myCorpusCopy)
myCorpus <- Corpus(VectorSource(myCorpus))
writeLines(strwrap(myCorpus[[2]]$content, 60))

# count word frequence
wordFreq <- function(corpus, word) {
results <- lapply(corpus,
                  function(x) { grep(as.character(x), pattern=paste0("\\<",word)) }
)
sum(unlist(results))
}
n.TLS <- wordFreq(myCorpusCopy, "broadband")
n.Trump <- wordFreq(myCorpusCopy, "facebook")
cat(n.TLS, n.Trump)

# Word Frequency
tdm <- TermDocumentMatrix(myCorpus,
                          control = list(wordLengths = c(1, Inf)))
tdm

idx <- which(dimnames(tdm)$Terms %in% c("Trump", "media", "gay"))
as.matrix(tdm[idx, 1:30])

# Top frequent terms
# inspect frequent words
(freq.terms <- findFreqTerms(tdm, lowfreq = 5))

term.freq <- rowSums(as.matrix(tdm))
term.freq <- subset(term.freq, term.freq >= 5)
df <- data.frame(term = names(term.freq), freq = term.freq)

library(ggplot2)
ggplot(df, aes(x=term, y=freq)) + geom_bar(stat="identity") +
  xlab("Terms") + ylab("Count") + coord_flip() +
  theme(axis.text=element_text(size=7))

# Wordcloud
m <- as.matrix(tdm)
# calculate the frequency of words and sort it by frequency
word.freq <- sort(rowSums(m), decreasing = T)

# plot word cloud
library(wordcloud)
wordcloud(words = names(word.freq), freq = word.freq, min.freq = 3,
          random.order = F)

# Word Association - trump
# which words are associated with 'trump'?
findAssocs(tdm, "trump", 0.2)

# which words are associated with 'gay'?
findAssocs(tdm, "gay", 0.2)

# install package sentiment140
require(devtools)
install_github("sentiment140", "okugami79")
# sentiment analysis - need to know a lot more about how this works!
library(sentiment)
sentiments <- sentiment(tweets.df$text)
plot(table(sentiments$polarity))

# Friends and Followers
user <- getUser("StigAbell")
user$toDataFrame()
friends <- user$getFriends() # who this user follows
followers <- user$getFollowers() # this user's followers
followers2 <- followers[[1]]$getFollowers() # a follower's followers

# select top retweeted tweets
table(tweets.df$retweetCount)
selected <- which(tweets.df$retweetCount >= 9)
# plot them
dates <- strptime(tweets.df$created, format="%Y-%m-%d")
plot(x=dates, y=tweets.df$retweetCount, type="l", col="grey",
     xlab="Date", ylab="Times retweeted")
colors <- rainbow(10)[1:length(selected)]
points(dates[selected], tweets.df$retweetCount[selected],
       pch=19, col=colors)
text(dates[selected], tweets.df$retweetCount[selected],
     tweets.df$text[selected], col=colors, cex=.9)

# Tracking message propagation
tweets[[3]]
retweeters(tweets[[3]]$id)
retweets(tweets[[3]]$id)