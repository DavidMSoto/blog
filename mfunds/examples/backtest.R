





# supongo que las estrategias de efts, seran diferentes a los de fondos. 

# los de etfs puede haber varios productos q sean estacionales de los que se podria hacer un sistema

# fundos habria que ver ahora en que momento estamos, 
# supongo que los de renta variable no son el momento ya me metere en robotic, 
# hay que ver que tipos hay . 

rm(list = ls()) 

library(data.table) 
library(bit64)
library(dplyr) 
setwd('D://repos//blog//mfunds//code//')

options(digits=2)
train <- readRDS( file.path(getwd(), "../input/etfs_20171106.rds")) %>% as.data.frame() # SILENCE

