library(lubridate)

getDataFanOnDay = function(pageID, token){

	Sys.setlocale("LC_TIME", "C")
	time_crrent = as.POSIXlt(Sys.time())
	# since_time =  format((dmy(strftime(time_crrent, "%d/%m/%Y")) - days(11)), '%A %Y-%m-%d')
	since_time =  format((dmy(strftime(time_crrent, "%d/%m/%Y")) - days(9)), '%A %Y-%m-%d')
	# until_time = format((dmy(strftime(time_crrent, "%d/%m/%Y")) - days(3)), '%A %Y-%m-%d')
	until_time = format((dmy(strftime(time_crrent, "%d/%m/%Y")) - days(1)), '%A %Y-%m-%d')


	requestUrlFanOnDay = sprintf(
		"https://graph.facebook.com/%s/%s/insights?pretty=0&metric=page_fans_online_per_day&since=%s&until=%s",
		"v2.10",
		pageID,
		since_time,
		until_time
	)

	fanOnDay = callAPI(url = requestUrlFanOnDay, token = token)
	fanOnDay = fanOnDay$data[[1]]$values

	fanDaily = c()
	for(i in 1:length(fanOnDay)){
	  fanDaily = append(fanDaily,fanOnDay[[i]]$value)
	}

	fanOnDay <- as.numeric(paste(unlist(fanDaily)))
	fanOnDay <- c(fanOnDay[-(1:3)], fanOnDay[1:3])

	return (fanOnDay)
}