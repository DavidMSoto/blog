https://rpubs.com/shyambv/extract_htmljsonxml_data

library(jsonlite)
library(XML)
library(dplyr)
library(RCurl)
library(stringr)
library(plyr)
ft <- getURL("https://markets.ft.com/data/equities/ajax/get-historical-prices?startDate=2017/09/18&endDate=2017/09/19&symbol=93036175") %>%  htmlParse(asText = TRUE)
tbl<-rbind(readHTMLTable(ft))



bookshtml.link <- getURL("https://msdn.microsoft.com/en-us/library/ms762258(v=vs.85).aspx") %>%  htmlParse(asText = TRUE)

bookshtml.xml <- xpathSApply(bookshtml.link,"//div[@class='codeSnippetContainerCode']",xmlValue)

booksexact <- bookshtml.xml[1] %>%  str_replace_all("[\r\n]","") %>%  str_trim(side = "both")

books.xml.parse <- xmlParse(booksexact) %>% xmlToDataFrame()

books.json <- toJSON(books.xml.parse)