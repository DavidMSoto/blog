
rm(list = ls())

#######################################################
# The Rise of the Robots (Advisors...)
#
# thertrader@gmail.com - August 2015
#######################################################
library(ggplot2)
library(stringr)
library(XML)

#######################################################
# STEP 1: Data gathering
#######################################################
tables <- readHTMLTable("http://investorhome.com/robos.htm")
a <- as.data.frame(tables)
b <- a[,c(1:3)]
colnames(b) <- c("company","aum","type")
c <- b[which(b[,"type"] == "Roboadvisor"),]
d <- b[which(b[,"type"] == "RoboAdvisor"),]
e <- rbind(c,d)
f <- as.numeric(str_replace_all(e[,2], "[[:punct:]]",""))
g <- cbind(e[,c("company","type")],f)
colnames(g) <- c("company","type","aum")

#######################################################
# STEP 2: Chart
#######################################################
globalAum <- 19000000000
h <- cbind(g,g[,"aum"]/globalAum)
colnames(h) <- c("company","type","aum","marketShare")
i <- cbind("Others","Roboadvisor",globalAum-sum(h[,"aum"]),1-sum(h[,"aum"]/globalAum))
colnames(i) <- c("company","type","aum","marketShare")
j <- rbind(h,i)
k <- j[order(j[,"marketShare"],decreasing =TRUE),]
k[,"marketShare"] <- round(100*as.numeric(k[,"marketShare"]),1)

# Bar plot with ggplot2
ggplot(data=k, aes(x=company, y=marketShare, fill=company)) +
  geom_bar(stat="identity") +
  theme(axis.ticks = element_blank(), axis.text.y = element_blank(), text = element_text(size = 20)) +
  coord_flip() +
  labs(title = "Robots Advisors \n Market Shares as of end 2014") +
  ylab("Market Share (%)") +
  xlab(" ") +
  scale_fill_brewer(palette="Spectral")
