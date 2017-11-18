

######interesante para tomar ideas ... 

#http://amunategui.github.io/wallstreet/

#https://raw.githubusercontent.com/amunategui/quantmod-wallstreet/master/quantmod_wallstreet.R

library(quantmod)
setwd("D:\\repos\\blog\\mfunds\\")
selected <- readRDS("./input/selected50.rds") 

# display a simple bar chart
GB00BYSYZL73=dplyr::filter(selected,  isin == "GB00BYSYZL73")
GB00B7778087=dplyr::filter(selected,  isin == "GB00B7778087")

x <- xts( GB00BYSYZL73$Close ,GB00BYSYZL73$date)

barChart(x,theme='white.mono',bar.type='hlc') 

# display a complex chart

chartSeries(x, subset='last 24 months')
addBBands(n = 20, sd = 2, ma = "SMA", draw = 'bands', on = -1)


# get market data for all symbols making up the Nasdaq 100 index
ft_Symbols <- c("GB00BYSYZL73", "GB00B7778087")



# merge them all together
sele2 <- data.frame(merge(GB00BYSYZL73, GB00B7778087, by = "date", all.x = T))



head(sele2[,1:17],2)

# set outcome variable
outcomeSymbol <- 'FISV.Volume'

# shift outcome value to be on same line as predictors
library(xts)
sele2 <- xts(sele2,order.by=as.Date(rownames(sele2)))

sele2 <- as.data.frame(merge(sele2, lm1=lag(sele2[,outcomeSymbol],-1)))
nasdaq100$outcome <- ifelse(nasdaq100[,paste0(outcomeSymbol,'.1')] > nasdaq100[,outcomeSymbol], 1, 0)

# remove shifted down volume field as we don't care by the value
nasdaq100 <- nasdaq100[,!names(nasdaq100) %in% c(paste0(outcomeSymbol,'.1'))]

# cast date to true date and order in decreasing order
nasdaq100$date <- as.Date(row.names(nasdaq100))
nasdaq100 <- nasdaq100[order(as.Date(nasdaq100$date, "%m/%d/%Y"), decreasing = TRUE),]

# calculate all day differences and populate them on same row
GetDiffDays <- function(objDF,days=c(10), offLimitsSymbols=c('outcome'), roundByScaler=3) {
  # needs to be sorted by date in decreasing order
  ind <- sapply(objDF, is.numeric)
  for (sym in names(objDF)[ind]) {
    if (!sym %in% offLimitsSymbols) {
      print(paste('*********', sym))
      objDF[,sym] <- round(scale(objDF[,sym]),roundByScaler)
      
      print(paste('theColName', sym))
      for (day in days) {
        objDF[paste0(sym,'_',day)] <- c(diff(objDF[,sym],lag = day),rep(x=0,day)) * -1
      }
    }
  }
  return (objDF)
}

# call the function with the following differences
nasdaq100 <- GetDiffDays(nasdaq100, days=c(1,2,3,4,5,10,20), offLimitsSymbols=c('outcome'), roundByScaler=2)

# drop most recent entry as we don't have an outcome
nasdaq100 <- nasdaq100[2:nrow(nasdaq100),]

# take a peek at YHOO features:
dput(names(nasdaq100)[grepl('YHOO.',names(nasdaq100))])

# well use POSIXlt to add day of the week, day of the month, day of the year
nasdaq100$wday <- as.POSIXlt(nasdaq100$date)$wday
nasdaq100$yday <- as.POSIXlt(nasdaq100$date)$mday
nasdaq100$mon<- as.POSIXlt(nasdaq100$date)$mon

# remove date field and shuffle data frame
nasdaq100 <- subset(nasdaq100, select=-c(date))
nasdaq100 <- nasdaq100[sample(nrow(nasdaq100)),]

# let's model
library(xgboost)
predictorNames <- names(nasdaq100)[names(nasdaq100) != 'outcome']

set.seed(1234)
split <- sample(nrow(nasdaq100), floor(0.7*nrow(nasdaq100)))
train <-nasdaq100[split,]
test <- nasdaq100[-split,]

bst <- xgboost(data = as.matrix(train[,predictorNames]),
               label = train$outcome,
               verbose=0,
               eta = 0.1,
               gamma = 50, 
               nround = 50,
               colsample_bytree = 0.1,
               subsample = 8.6,
               objective="binary:logistic")

predictions <- predict(bst, as.matrix(test[,predictorNames]), outputmargin=TRUE)

library(pROC)
auc <- roc(test$outcome, predictions)
print(paste('AUC score:', auc$auc))
