library(lubridate)

getDataFanOnTime = function(pageID, token){

	Sys.setlocale("LC_TIME", "C")
	time_crrent = as.POSIXlt(Sys.time())
	since_time =  format((dmy(strftime(time_crrent, "%d/%m/%Y")) - days(7)), '%A %Y-%m-%d')
	since_time =  format((dmy(strftime(time_crrent, "%d/%m/%Y")) - days(9)), '%A %Y-%m-%d')
	until_time = format((dmy(strftime(time_crrent, "%d/%m/%Y")) - days(0)), '%A %Y-%m-%d')

	requestUrlFanOnTime = sprintf(
		"https://graph.facebook.com/%s/%s/insights?pretty=0&metric=page_fans_online&since=%s&until=%s",
		"v2.10",
		pageID,
		since_time,
		until_time
	)

	fanOnTime = callAPI(url = requestUrlFanOnTime, token = token)

	fanOnTime = fanOnTime$data[[1]]$values

	fan24hour = c()
	for(i in 1:length(fanOnTime)){
	  fan24hour = append(fan24hour,fanOnTime[[i]]$value)
	}

	fan24hour <- as.numeric(paste(unlist(fan24hour)))
	fanOnTime <- c()
	fanOnTime <- matrix(fan24hour, ncol=24, byrow=TRUE)
	fanOnTime <- round(colMeans(fanOnTime),digits=0)
	fanOnTime <- c(fanOnTime[-(1:8)], fanOnTime[1:8])

	return (fanOnTime)
}