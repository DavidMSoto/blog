
rm(list = ls())

library(jsonlite) 
library(XML)
library(dplyr) 
library(RCurl)
library(stringr)

library(plyr)




url <- "https://markets.ft.com/data/equities/ajax/get-historical-prices?startDate=2017/08/01&endDate=2017/09/19&symbol=93036175"



ft.xml <- getURL(url) %>% fromJSON() %>%  htmlParse(asText = TRUE) 
xmltop = xmlRoot(ft.xml) #gives content of root
ft.df =ldply(xmlToList(ft.xml[[1]]), data.frame) 

ft.df <- ft.df [-1,c(5,8,9,10,11)]

names(ft.df )<-c("date","open","close","high","close")

ft.df [ , "symbol"] <- "93036175"

