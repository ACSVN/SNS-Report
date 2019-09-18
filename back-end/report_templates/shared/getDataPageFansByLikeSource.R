getDataPageFansByLikeSource = function(pageID, token, start_date, end_date){

	since_starts_new = dmy(strftime(start_date, "%d/%m/%Y")) - days(1)
	until_starts_new = dmy(strftime(end_date, "%d/%m/%Y")) + days(1)

	requestUrlPageFansLikeBySource = sprintf(
		"https://graph.facebook.com/%s/%s/insights/page_fans_by_like_source?since=%s&until=%s",
		"v2.10",
		pageID,
		since_starts_new,
		until_starts_new
	)
	pageFansLikeBySource = callAPI(url = requestUrlPageFansLikeBySource, token = token)

	return (pageFansLikeBySource$data[[1]]$values)
}