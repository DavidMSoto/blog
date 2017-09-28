

library(jsonlite) 
library(XML)

library(RCurl)
library(stringr)
library(plyr)
rm(list = ls())


baseURL  = "https://markets.ft.com/data/equities/ajax/get-historical-prices?startDate=2015/08/01&endDate=2017/09/19&symbol=GB00B5ZNJ896"

ft.xml <- getURL(baseURL) %>% fromJSON() %>%  htmlParse(asText = TRUE) 

xmltop = xmlRoot(ft.xml) #gives content of root
ft.df =ldply(xmlToList(xmltop[[1]]), data.frame) 

ft.df.min <- ft.df [-1,c(5,8,9,10,11)] # select the columns we need 

names(ft.df.min )<-c("date","open","close","high","low") # rename de columms

df <-ft.df.min
df$fecha_dato <- as.Date(df$date, format="%a, %b %d, %Y")


p <- plot_ly(df, x = ~fecha_dato, y = ~close, type = 'scatter', mode = 'lines')
p