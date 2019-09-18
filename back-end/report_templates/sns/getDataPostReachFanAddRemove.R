library(lubridate)

editDate = function(start_date, end_date){

	start_date = dmy(strftime(start_date, "%d/%m/%Y")) - days(1)
	since_start = dmy(strftime(start_date, "%d/%m/%Y")) + days(1)
	since_start_midnight = strftime(since_start, "%Y-%m-%d 00:00:00")
	until_midnight = strftime(end_date, "%Y-%m-%d 23:59:59")

	result_date = list()
	result_date[['start_date']] = start_date
	result_date[['end_date']] = end_date
	result_date[['since_start_midnight']] = since_start_midnight
	result_date[['until_midnight']] = until_midnight

	return (result_date)
}

elapsed_months = function(start_date, end_date) {
	ed <- as.POSIXlt(end_date, format="%Y-%m-%d", tz = "UTC")
	sd <- as.POSIXlt(start_date, format="%Y-%m-%d", tz = "UTC")
	12 * (ed$year - sd$year) + (ed$mon - sd$mon)
}

getDataPostReachFanAddRemove = function(params){
	pageID 		= params[1]$pageID
	token 		= params[2]$accessToken
	startDate 	= params[3]$since_fdate
	endDate 	= params[4]$until_fdate

	date_limit = endDate

	num_elapsed_month = elapsed_months(startDate, endDate)
	num_month_add = 2
	
	posts = c()
	reachs = c()
	fanAdds = c()
	fanRemoves = c()

	since_date_post = startDate
	for(mloop in 1:ceiling(num_elapsed_month/num_month_add)){
		until_date_post = dmy(strftime(since_date_post, "%d/%m/%Y")) + days(60)
		
		if(until_date_post < date_limit){
			date_tmp = editDate(since_date_post, until_date_post)

			# print('=====================================if')
			# print(date_tmp$since_start_midnight)
			# print(date_tmp$end_date)

			posts = c(posts, getDataPost(pageID, token, date_tmp$since_start_midnight, date_tmp$end_date))
			reachs = c(reachs, getDataReach(pageID, token, date_tmp$since_start_midnight, date_tmp$end_date))
			fanAdds = c(fanAdds, getDataFanAdd(pageID, token, date_tmp$start_date, date_tmp$end_date))
			fanRemoves = c(fanRemoves, getDataFanRemove(pageID, token, date_tmp$start_date, date_tmp$end_date))
			since_date_post = until_date_post
		}else{
			until_date_post = strftime(endDate, "%Y-%m-%d 23:59:59")
			date_tmp = editDate(since_date_post, until_date_post)
			# print('=====================================else')
			# print(date_tmp$since_start_midnight)
			# print(date_tmp$end_date)
			
			posts = c(posts, getDataPost(pageID, token, date_tmp$since_start_midnight, date_tmp$end_date))
			reachs = c(reachs, getDataReach(pageID, token, date_tmp$since_start_midnight, date_tmp$end_date))
			fanAdds = c(fanAdds, getDataFanAdd(pageID, token, date_tmp$start_date, date_tmp$end_date))
			fanRemoves = c(fanRemoves, getDataFanRemove(pageID, token, date_tmp$start_date, date_tmp$end_date))
			break;
		}
	}
	
	result = list()
	result[['posts']] = posts[!duplicated(posts)]
	result[['reach']] = reachs[!duplicated(reachs)]
	result[['fanAdd']] = fanAdds[!duplicated(fanAdds)]
	result[['fanRemove']] = fanRemoves[!duplicated(fanRemoves)]
	return (result)
}