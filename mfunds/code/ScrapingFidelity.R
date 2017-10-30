
library(jsonlite) 
library(XML)
library(RCurl)
library(stringr)
library(plyr)

rm(list = ls())

#ETFEI etfs, ITEI investments trust and MFEI (funds) :
url_ETFEI <- "http://lt.morningstar.com/api/rest.svc/9vehuxllxs/security/screener?page=1&pageSize=1000&sortOrder=LegalName%20asc&outputType=json&version=1&languageId=en-GB&currencyId=GBP&universeIds=ETEXG$XLON_3518|ETALL$$ALL_3518&securityDataPoints=SecId|Name|TenforeId|holdingTypeId|isin|sedol|QR_MonthDate|LegalName|Yield_M12|OngoingCharge|StarRatingM255|CustomCategoryId3Name|CollectedSRRI|QR_GBRReturnM12_5|QR_GBRReturnM12_4|QR_GBRReturnM12_3|QR_GBRReturnM12_2|QR_GBRReturnM12_1|CustomMinimumPurchaseAmount|GBRReturnM0|GBRReturnM12|GBRReturnM36|GBRReturnM60|GBRReturnM120&subUniverseId=ETFEI"
url_ITEI <-  "http://lt.morningstar.com/api/rest.svc/9vehuxllxs/security/screener?page=1&pageSize=1000&sortOrder=LegalName%20asc&outputType=json&version=1&languageId=en-GB&currencyId=GBP&universeIds=FCGBR%24%24ALL_3519&securityDataPoints=SecId%7CName%7CTenforeId%7CholdingTypeId%7Cisin%7Csedol%7CQR_MonthDate%7CLegalName%7CYield_M12%7CAnnualReportOngoingCharge%7CStarRatingM255%7CCustomCategoryId3Name%7CQR_GBRReturnM12_5%7CQR_GBRReturnM12_4%7CQR_GBRReturnM12_3%7CQR_GBRReturnM12_2%7CQR_GBRReturnM12_1%7CCustomMinimumPurchaseAmount%7CGBRReturnM0%7CGBRReturnM12%7CGBRReturnM36%7CGBRReturnM60%7CGBRReturnM120&filters=&term=&subUniverseId=ITEI"
url_MFEI <-  "http://lt.morningstar.com/api/rest.svc/9vehuxllxs/security/screener?page=1&pageSize=3000&sortOrder=LegalName%20asc&outputType=json&version=1&languageId=en-GB&currencyId=GBP&universeIds=FOGBR%24%24ALL_3521&securityDataPoints=SecId%7CName%7CTenforeId%7CholdingTypeId%7Cisin%7Csedol%7CCustomAttributes1%7CCustomAttributes2%7CCustomExternalURL1%7CCustomExternalURL2%7CCustomExternalURL3%7CCustomIsClosed%7CCustomIsFavourite%7CCustomIsRecommended%7CQR_MonthDate%7CLegalName%7CCustomBuyFee%7CYield_M12%7COngoingCharge%7CCustomCategoryId3Name%7CStarRatingM255%7CQR_GBRReturnM12_5%7CQR_GBRReturnM12_4%7CQR_GBRReturnM12_3%7CQR_GBRReturnM12_2%7CQR_GBRReturnM12_1%7CCustomMinimumPurchaseAmount%7CCustomValue2%7CCustomAdditionalBuyFee%7CCustomSellFee%7CGBRReturnM0%7CGBRReturnM12%7CGBRReturnM36%7CGBRReturnM60%7CGBRReturnM120&filters=&term=&subUniverseId=MFEI"



ETFEI <- getURL(url_ETFEI) %>% fromJSON()  %>% as.data.frame
ITEI<- getURL(url_ITEI) %>% fromJSON()  %>% as.data.frame
url_MFEI <-getURL(url_MFEI) %>% fromJSON()  %>% as.data.frame



MFEI (Funds)
