
rm(list = ls())

WIN <- TRUE
if (WIN) {setwd("D:\\repos\\blog\\mfunds\\")} else{setwd("~/dataScience/blog/mfunds/")}



library(data.table)
Holdings = fread('./input/AllHoldings.csv')


AllFundFidelity = fread('./input/AllFundFidelity.csv')
colnames(AllFundFidelity)[2] <- "isin" # rename the fund name to merge the datasets
colnames(Holdings)[2]<- "isin"

sele2 <- data.frame(merge(Holdings, AllFundFidelity, by = "isin", all.x = T))




library(lubridate)
library(jsonlite) 
library(XML)
library(RCurl)
library(stringr)
library(plyr)



HoldingsFT<-scrapFT(Holdings)




scrapFT <-function(df) {
end.date <-gsub("-", "/", Sys.Date())
start.date <-gsub("-", "/", Sys.Date()-days(30))

url_ft_base <- paste0("https://markets.ft.com/data/equities/ajax/get-historical-prices?startDate=", start.date, "&endDate=", end.date, "&symbol=" )

return_df <- data.frame(stringsAsFactors=FALSE) 





for (i in 1:nrow(df)){
  
  url_ft = paste0(url_ft_base,df[i,2]) # second column is sthe isnn
  ft.xml <- getURL(url_ft) %>% fromJSON() %>%  htmlParse(asText = TRUE) 
  xmltop = xmlRoot(ft.xml) #gives content of root
  ft.df =ldply(xmlToList(xmltop[[1]]), data.frame) 
  
  ft.df <- ft.df [-1,c(5,8,9,10,11)] # select the columns we need 
  
  names(ft.df )<-c("date","Open","High","Low","Close") # rename de columms
  ft.df [ , "fundsname"] <- df[i,1] #
  ft.df [ , "isin"] <-df[i,2]       #
  ft.df [ , "FundManager"] <-df[i,3]  
  ft.df [ , "FundSize"] <-df[i,4]  
  ft.df [ , "FundSize"] <-df[i,5]  
  ft.df [ , "MarketSector"] <-df[i,6]  
  ft.df [ , "Mcategory"] <-df[i,7]  
  ft.df [ , "AssetClass"] <-df[i,8]  
  return_df <-rbind( return_df ,ft.df )
}
  return(return_df)
}








library(TTR) #  rsi() for calculating simple moving average


vector <- unique(selected$isin)
df <- data.frame(stringsAsFactors=FALSE) 

for (i in vector)
{
  
  data <- dplyr::filter(selected,  isin == i)
  data <- data[order(as.Date(data$date, format="%Y-%m-%d")),]
  rsi <- RSI(GBxx$Close, n=14)
  GBxx$rsi <-rsi
  tail <- tail(GBxx, 1)
  df <-rbind( df ,tail )
  
}




```
