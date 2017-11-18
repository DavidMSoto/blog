
rm(list = ls())

library(jsonlite)  
library(XML)       
library(RCurl)     
library(stringr)   
library(plyr)      
library(dplyr)     
library(lubridate) 






getFinancialtimesHistoricalData <-function(products,months) {
  
  df.return <- data.frame(stringsAsFactors=FALSE) 
  start.time <- Sys.time() # let's see how much time we are going to spend in this 
  
  
  url.ft.base <- paste0("https://markets.ft.com/data/equities/ajax/get-historical-prices?startDate=", 
                        gsub("-", "/", Sys.Date()-months(months)) , "&endDate=", 
                        gsub("-", "/", Sys.Date()) , "&symbol=" )
  
  for (i in 1:nrow(products)){
    url.ft = paste0(url.ft.base,products[i,"isin"]) # 
    ft.xml <- getURL(url.ft) %>% fromJSON() %>%  htmlParse(asText = TRUE) 
    
    xmltop = xmlRoot(ft.xml) #gives content of root
    ft.df =ldply(xmlToList(xmltop[[1]]), data.frame) 
    
    if (nrow(ft.df) > 2 ) # not all the products have data in financial times, 
    {
      
      ft.df <- ft.df [-1,c(5,8,9,10,11,12)] # select the columns we need and remove the first row
      names(ft.df )<-c("date","Open","High","Low","Close","Volumen") # rename de columms
      
      ft.df<-merge(ft.df,products [i,] )
      
      df.return <-rbind( df.return ,ft.df )
      
    } else {   print( paste0( "the product ", products[i,"isin"], "Does not have any data in financial times API")) }
    
  }
  
  print( Sys.time() - start.time)
  
  return(df.return)
  
}


eim <- readRDS("~/dataScience/blog/mfunds/input/eim20171117.rds")  

ETFEI <-eim %>% filter (subUniverseId =='ETFEI')


dETFEI<-getFinancialtimesHistoricalData(ETFEI,60)

saveRDS( dETFEI, file.path("./input/historical.prices.dETFEI.date.rds") )

ITEI <-eim %>% filter (subUniverseId =='ITEI')
dITEI<-getFinancialtimesHistoricalData(ITEI,60)
saveRDS( dITEI, file.path("./input/historical.prices.dITEI.date.rds") )


MFEI <-eim %>% filter (subUniverseId =='MFEI')   %>% filter  (kind =='Inc')

dMFEI<-getFinancialtimesHistoricalData(MFEI,60)
saveRDS( dMFEI, file.path("./input/historical.prices.dMFEI.date.rds") )


ETFEI <-eim %>% filter (subUniverseId =='MFEI') %>% filter (CustomCategoryId3Name =='Bonds')   %>%  filter(grepl("Black",LegalName) )



