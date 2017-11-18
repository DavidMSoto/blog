

setwd('D:\\repos\\blog\\mfunds\\')

url_ETFEI <- "http://lt.morningstar.com/api/rest.svc/9vehuxllxs/security/screener?page=1&pageSize=1000&sortOrder=LegalName%20asc&outputType=json&version=1&languageId=en-GB&currencyId=GBP&universeIds=ETEXG$XLON_3518|ETALL$$ALL_3518&securityDataPoints=SecId|Name|TenforeId|holdingTypeId|isin|sedol|QR_MonthDate|LegalName|Yield_M12|OngoingCharge|StarRatingM255|CustomCategoryId3Name|CollectedSRRI|QR_GBRReturnM12_5|QR_GBRReturnM12_4|QR_GBRReturnM12_3|QR_GBRReturnM12_2|QR_GBRReturnM12_1|CustomMinimumPurchaseAmount|GBRReturnM0|GBRReturnM12|GBRReturnM36|GBRReturnM60|GBRReturnM120&subUniverseId=ETFEI"
ETFEI <- getURL(url_ETFEI) %>% fromJSON()  %>% as.data.frame


#althougt the json gather many fields for this example we just use the below columns
ETFEI <- select (ETFEI,1,6,9,12,14,21)


names(ETFEI) <- c("type", "Name", "isin" , "LegalName", "OngoingCharge" , "category")

knitr::kable(head(select (ETFEI,2, 3,5,6)))



dfe <-getFinancialtimesHistoricalData (ETFEI,1) 

alldata <- readRDS("./input/etfs_20171108.rds")


library(sqldf)


trainf <- sqldf("SELECT * from dfe
                  UNION
                SELECT * from alldata
                ORDER BY Date
                 " )

