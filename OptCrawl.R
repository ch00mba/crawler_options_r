require('quantmod')
require(readr)
require(jsonlite)

#setup for cron 

TimeYear = '2021/2022'



OptCrawl = function(Symbol = 'TQQQ', DateString = '2020/2022', Out = "OptionsDB_15min.csv")
{
  # Symbol = 'TQQQ'
  # DateString = '2020/2022'
  # Out = "OptionsDB_15min.csv"
  
  require('quantmod')
  
  opt = getOptionChain(Symbols = Symbol, Exp = DateString)
  
  spot = getQuote(Symbols = Symbol)[c(2,8)]
  
  #prepare options matrix 
  
  ListOfExps = names(opt)
  
  TimeStamp = Sys.time()
  
  for(i in 1:length(ListOfExps))
  {
    
    assign(x = ListOfExps[i], value = cbind(TimeStamp,ListOfExps[i],Symbol,"C",as.data.frame(opt[[i]]$calls)))
    
    write.table(x = get(x = ListOfExps[i]), file = Out, sep = ',', append = TRUE, na = '0', col.names = FALSE)
    
    #) col.names = c("TimeStamp", "Expiration","Symbol, "Type", "Strike", "Last", "Chng", "Bid", "Ask", "Vol", "OI"))
    
    assign(x = ListOfExps[i], value = cbind(TimeStamp,ListOfExps[i],Symbol,"P",as.data.frame(opt[[i]]$puts)))
    
    write.table(x = get(x = ListOfExps[i]), file = Out, sep = ',', append = TRUE, na = '0', col.names = FALSE)
    
  }
  
}

AlphaVantageCrawl = function()
{
  require(readr)
  
  TQQQ15min = read_csv("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=TQQQ&interval=15min&apikey=2STATJLBRWXBYSHI&datatype=csv")
  
  UVXY15min = read_csv("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=UVXY&interval=15min&apikey=2STATJLBRWXBYSHI&datatype=csv")
  
  TQQQ60min = read_csv("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=TQQQ&interval=60min&apikey=2STATJLBRWXBYSHI&datatype=csv")
  
  UVXY60min = read_csv("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=UVXY&interval=60min&apikey=2STATJLBRWXBYSHI&datatype=csv")
  
  write.table(x = TQQQ15min, file = "TQQQ15min.csv", sep = ',', append = TRUE, na = '0', col.names = FALSE,row.names = FALSE)
  write.table(x = UVXY15min, file = "UVXY15min.csv", sep = ',', append = TRUE, na = '0', col.names = FALSE,row.names = FALSE)
  write.table(x = TQQQ60min, file = "TQQQ60min.csv", sep = ',', append = TRUE, na = '0', col.names = FALSE,row.names = FALSE)
  write.table(x = UVXY60min, file = "UVXY60min.csv", sep = ',', append = TRUE, na = '0', col.names = FALSE,row.names = FALSE)
  
  
}

while(1)
{
  tryCatch(expr = {OptCrawl(Symbol = 'FB', DateString = TimeYear, Out =  "OptionsDB_15min.csv")}, error=function(e){})
  tryCatch(expr = {OptCrawl(Symbol = 'AMZN', DateString = TimeYear, Out =  "OptionsDB_15min.csv")}, error=function(e){})
  tryCatch(expr = {OptCrawl(Symbol = 'NFLX', DateString = TimeYear, Out =  "OptionsDB_15min.csv")}, error=function(e){})
  tryCatch(expr = {OptCrawl(Symbol = 'MSFT', DateString = TimeYear, Out =  "OptionsDB_15min.csv")}, error=function(e){})
  tryCatch(expr = {OptCrawl(Symbol = 'TQQQ', DateString = TimeYear, Out =  "OptionsDB_15min.csv")}, error=function(e){})
  tryCatch(expr = {OptCrawl(Symbol = '^VIX', DateString = TimeYear, Out =  "OptionsDB_15min.csv")}, error=function(e){})  
  tryCatch(expr = {OptCrawl(Symbol = 'AAPL', DateString = TimeYear, Out =  "OptionsDB_15min.csv")}, error=function(e){})  
  tryCatch(expr = {OptCrawl(Symbol = 'NVDA', DateString = TimeYear, Out =  "OptionsDB_15min.csv")}, error=function(e){})
  tryCatch(expr = {OptCrawl(Symbol = 'GOOGL', DateString = TimeYear, Out =  "OptionsDB_15min.csv")}, error=function(e){})
  tryCatch(expr = {OptCrawl(Symbol = 'UVXY', DateString = TimeYear, Out =  "OptionsDB_15min.csv")}, error=function(e){})
  
  #tryCatch(expr = {AlphaVantageCrawl()}, error=function(e){})
  
  
  
  
  Sys.sleep(900)
}




