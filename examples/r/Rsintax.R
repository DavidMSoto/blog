## Objetivo 
##mapa de calor que muestra los mas sobreromprados y sobrevendidos
# https://plot.ly/r/heatmaps/



#borrar una fila 
Holdings <- Holdings[-c(8), ]

#Borrar  una columna
Holdings <- Holdings[,-c(8) ]

#rename una columna
colnames(AllFundFidelity)[2] <- "isin"


AllFundFidelity = fread('./input/AllFundFidelity.csv')

vectorPictet <- subset(AllFundFidelity, AllFundFidelity$`Fund Manager` == "Pictet")

mylist <- split(AllFundFidelity, AllFundFidelity$`Morningstar category`)

unique(AllFundFidelity$`Morningstar category`)


#############################################heat map 


matrixV<-volcano
rm(list = ls())

p <- plot_ly(z = matrixV, colorscale = "Greys", type = "heatmap")
p


AllFundFidelity = fread('./input/AllFundFidelity.csv')



heatFundF <- select(AllFundFidelity, 1,2,5:7, 12:16)
names(heatFundF) <- c('fundName', 'isin', 'sector', 'mCategory', 'AssetClass', 'y4', 'y3', 'y2', 'y1' ,'y')

heatFundF <-heatFundF[complete.cases(heatFundF), ]

unique (heatFundF$sector)

Technology <-subset(heatFundF, sector == "Technology")

temp <- 
  Technology %>% 
  group_by(AssetClass )%>%   
  summarise(ymean=mean(y), y1mean=mean(y1), y2mean=mean(y2) , y3mean=mean(y3),y4mean=mean(y4))

rnames <- temp[-c(1),1]                            # assign labels in column 1 to "rnames"
mat_data <- data.matrix(temp[-c(1),2:ncol(temp)])  # transform column 2-5 into a matrix
rownames(mat_data) <- rnames               # assign row names





p <- plot_ly(z = mat_data, colorscale = "Greys", type = "heatmap")
p

library(lubridate)




  start.time <- Sys.time()
  end.date <-gsub("-", "/", Sys.Date())
  start.date <-gsub("-", "/", Sys.Date()-years(1))
  
url_ft_base <- paste0("https://markets.ft.com/data/equities/ajax/get-historical-prices?startDate=", start.date, "&endDate=", end.date, "&symbol=IE00BYPLS672" )


ft.xml <- getURL(url_ft_base) %>% fromJSON() %>%  htmlParse(asText = TRUE) 

xmltop = xmlRoot(ft.xml) #gives content of root
ft.df =ldply(xmlToList(xmltop[[1]]), data.frame) 
if (nrow(ft.df) > 2 )
{
  print("bla bla")
  } else {
  print("fuck bla")
  
}

print(products[i,3])

ft.df <- ft.df [-1,c(5,8,9,10,11,12)] # select the columns we need 

