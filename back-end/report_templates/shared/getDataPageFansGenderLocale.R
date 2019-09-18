getDataPageFansGenderLocale = function(pageID, token){

	requestUrlPageFanGenderLocale = sprintf(
		"https://graph.facebook.com/%s/%s/insights?pretty=0&metric=page_fans_city",
		"v2.10",
		pageID
	)

	pageFanGenderLocale = callAPI(url = requestUrlPageFanGenderLocale, token = token)

	pageFanGenderLocale = tail(pageFanGenderLocale$data[[1]]$values, n = 1)

	pageFanGenderLocaleValue = pageFanGenderLocale[[1]]$value
	pageFanGenderLocaleDate = pageFanGenderLocale[[1]]$end_time

	totalPageFanGenderLocale = Reduce('+', pageFanGenderLocaleValue)
	pageFanGenderLocaleValue = pageFanGenderLocaleValue[order(unlist(pageFanGenderLocaleValue), decreasing = TRUE)]
	pageFanGenderLocaleTop = head(pageFanGenderLocaleValue, n = 10)

	result = list()
	result[['pageFanGenderLocaleTop']] = pageFanGenderLocaleTop
	result[['totalPageFanGenderLocale']] = totalPageFanGenderLocale

	return (result)
}