getDataPageFan = function(pageID, token, start_date, end_date){

	since_starts_new = dmy(strftime(start_date, "%d/%m/%Y")) - days(1)
	until_starts_new = dmy(strftime(end_date, "%d/%m/%Y")) + days(1)

	requestUrlPageFan = sprintf(
		"https://graph.facebook.com/%s/%s/insights?metric=page_fans&since=%s&until=%s",
		"v2.10",
		pageID,
		since_starts_new,
		until_starts_new
	)

	pageFan = callAPI(url = requestUrlPageFan, token = token)

	return (pageFan$data[[1]]$values)
}