library(lubridate)

getDataFanOnDayOnTime = function(params){

	pageID 		= params[1]$pageID
	token 		= params[2]$accessToken
	startDate 	= params[3]$since_fdate
	endDate 	= params[4]$until_fdate

	fanOnDay = getDataFanOnDay(pageID, token)
	fanOnTime = getDataFanOnTime(pageID, token)

	result = list()
	result[['fanOnDay']] = fanOnDay
	result[['fanOnTime']] = fanOnTime

	return (result)
}
