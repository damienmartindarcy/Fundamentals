# Text Mining

# Worth knowing about this - two ways of getting hold of tweets
# Option 1
library(twitteR)
tweets <- userTimeline("fiontrach", n = 3200)

## Option 2: download @RDataMining tweets from RDataMining.com
url <- "http://www.rdatamining.com/data/rdmTweets-201306.RData"
download.file(url, destfile = "./data/rdmTweets-201306.RData")

load("C:/Users/psitlap13/Desktop/tweets.rdata")
(n.tweet <- length(tweets))

tweets.df <- twListToDF(tweets)
dim(tweets.df)

for (i in c(1:2, 320)) {
cat(paste0("[", i, "] "))
writeLines(strwrap(tweets.df$text[i], 60))
}

# Then we use tm to perform data cleaning - content transformer

library(tm)
# build a corpus, and specify the source to be character vectors
myCorpus <- Corpus(VectorSource(tweets.df$text))
# convert to lower case
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
# remove URLs
removeURL <- function(x) gsub("http[^[:space:]]*", "", x)

# Remove punctutation and numbers
# remove anything other than English letters or space
removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeNumPunct))

# Dealing with stopwords
# add two extra stop words: "available" and "via"
myStopwords <- c(stopwords('english'), "available", "via")
# remove "r" and "big" from stopwords
myStopwords <- setdiff(myStopwords, c("r", "big"))
# remove stopwords from corpus
myCorpus <- tm_map(myCorpus, removeWords, myStopwords)
# remove extra whitespace
myCorpus <- tm_map(myCorpus, stripWhitespace)

# keep a copy of corpus to use later as a dictionary for stem completion
myCorpusCopy <- myCorpus
# stem words
myCorpus <- tm_map(myCorpus, stemDocument)

# Lets look at the first 5 tweets
# inspect the first 5 documents (tweets)
inspect(myCorpus[1:5])
# The code below is used for to make text fit for paper width
for (i in c(1:2, 320)) {
cat(paste0("[", i, "] "))
writeLines(strwrap(as.character(myCorpus[[i]]), 60))
}

stemCompletion2 <- function(x, dictionary) {
x <- unlist(strsplit(as.character(x), " "))
# Unexpectedly, stemCompletion completes an empty string to
# a word in dictionary. Remove empty string to avoid above issue.
x <- x[x != ""]
x <- stemCompletion(x, dictionary=dictionary)
x <- paste(x, sep="", collapse=" ")
PlainTextDocument(stripWhitespace(x))
}

myCorpus <- lapply(myCorpus, stemCompletion2, dictionary=myCorpusCopy)
myCorpus <- Corpus(VectorSource(myCorpus))

# count frequency of "mining"
miningCases <- lapply(myCorpusCopy,
                      function(x) { grep(as.character(x), pattern = "\\<mining")} )
sum(unlist(miningCases))

# count frequency of "miner"
minerCases <- lapply(myCorpusCopy,
                     function(x) {grep(as.character(x), pattern = "\\<miner")} )
sum(unlist(minerCases))

# replace "miner" with "mining"
myCorpus <- tm_map(myCorpus, content_transformer(gsub),
                   pattern = "miner", replacement = "mining")

# Time to bring it all together
tdm <- TermDocumentMatrix(myCorpus,
                          control = list(wordLengths = c(1, Inf)))
tdm

# Frequent words and associations
idx <- which(dimnames(tdm)$Terms == "r")
inspect(tdm[idx + (0:5), 101:110])

# inspect frequent words
(freq.terms <- findFreqTerms(tdm, lowfreq = 15))

# Tidy it up
term.freq <- rowSums(as.matrix(tdm))
term.freq <- subset(term.freq, term.freq >= 15)
df <- data.frame(term = names(term.freq), freq = term.freq)

# Then graph it with ggplot2
library(ggplot2)
ggplot(df, aes(x = term, y = freq)) + geom_bar(stat = "identity") +
  xlab("Terms") + ylab("Count") + coord_flip()

# Then we do association rule mapping for specific words
# which words are associated with 'r'?
findAssocs(tdm, "r", 0.2)
# which words are associated with 'mining'?
findAssocs(tdm, "mining", 0.25)

m <- as.matrix(tdm)
# calculate the frequency of words and sort it by frequency
word.freq <- sort(rowSums(m), decreasing = T)

# plot word cloud
library(wordcloud)
wordcloud(words = names(word.freq), freq = word.freq, min.freq = 3,
          random.order = F)


















