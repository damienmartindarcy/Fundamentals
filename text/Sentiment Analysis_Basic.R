# Read in the training and test data - convert to dataframes

library(RCurl)

test_data_url<-"https://dl.dropboxusercontent.com/u/8082731/datasets/UMICH-SI650/testdata.txt"
train_data_url<-"https://dl.dropboxusercontent.com/u/8082731/datasets/UMICH-SI650/training.txt"

test_data_file<- getURL (test_data_url)
train_data_file<-getURL (train_data_url)

train_data_df<-read.csv(
  text=train_data_file,
  sep='\t',
  header=FALSE,
  quote="",
  stringsAsFactors = F,
  col.names=c("Sentiment","Text"))
test_data_df<-read.csv(
  text=test_data_file,
  sep='\t',
  header=FALSE,
  quote="",
  stringsAsFactors = F,
  col.names=c("Text"))

# We need to convert Sentiment to factor
train_data_df$Sentiment<-as.factor(train_data_df$Sentiment)

head(train_data_df)
table(train_data_df$Sentiment)
mean(sapply(sapply(train_data_df$Text, strsplit, " "), length))

# Preparing a corpus

library(tm)
library(SnowballC)

corpus<-Corpus(VectorSource(c(train_data_df$Text, test_data_df$Text)))

corpus[1]$content

# Then we transform it

corpus<-tm_map(corpus, content_transformer(tolower))
corpus<-tm_map(corpus, PlainTextDocument)
corpus<-tm_map(corpus, removePunctuation)
corpus<-tm_map(corpus, removeWords, stopwords("english"))
corpus<-tm_map(corpus, stripWhitespace)
corpus<-tm_map(corpus, stemDocument)

dtm<-DocumentTermMatrix(corpus)
dtm

# Terms that appear in at least 1% of the documents - down to 85 terms
sparse<-removeSparseTerms(dtm, 0.99)
sparse

# Then we convert this into a dataframe
important_words_df<-as.data.frame(as.matrix(sparse))
colnames(important_words_df)<-make.names(colnames(important_words_df))

# Split into train and test
important_words_train_df<-head(important_words_df, nrow(train_data_df))
important_words_test_df<-tail(important_words_df, nrow(test_data_df))

# Add to original dataframes
train_data_words_df<-cbind(train_data_df, important_words_train_df)
test_data_words_df<-cbind(test_data_df, important_words_test_df)

# Get rid of the original Text field
train_data_words_df$Text<-NULL
test_data_words_df$Text<-NULL

# Then the classifier

library(caTools)
set.seed(1234)

# First we create an index with 80% true values based on Sentiment
spl<-sample.split(train_data_words_df$Sentiment, 0.85)
eval_train_data_df<-train_data_words_df[spl==T,]
eval_test_data_df<-train_data_words_df[spl==F,]

log_model<-glm(Sentiment~., data=eval_train_data_df, family=binomial)
summary(log_model)

log_pred<-predict(log_model, newdata=eval_test_data_df, type="response")
table(eval_test_data_df$Sentiment, log_pred>.5)
(453+590)/nrow(eval_test_data_df)









