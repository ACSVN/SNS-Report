getDataReach = function(pageID, token, start_date, end_date){

	# start_date = dmy(strftime(start_date, "%d/%m/%Y")) - days(1)
	# since_start = dmy(strftime(start_date, "%d/%m/%Y")) + days(1)
	# since_start_midnight = strftime(since_start, "%Y-%m-%d %H:%M:%S")
	# until_midnight = strftime(end_date, "%Y-%m-%d 23:59:59")

	requestUrlReach = sprintf(
		"https://graph.facebook.com/%s/%s/insights?pretty=0&metric=page_impressions&since=%s&until=%s",
		"v2.10",
		pageID,
		start_date,
		end_date
	)

	reach = callAPI(url = requestUrlReach, token = token)
	return (reach$data[[1]]$values)
}