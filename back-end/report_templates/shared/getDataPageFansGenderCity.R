getDataPageFansGenderCity = function(pageID, token){

	requestUrlPageFanGenderCity = sprintf(
		"https://graph.facebook.com/%s/%s/insights?pretty=0&metric=page_fans_city",
		"v2.10",
		pageID
	)

	pageFanGenderCity = callAPI(url = requestUrlPageFanGenderCity, token = token)

	pageFanGenderCity = tail(pageFanGenderCity$data[[1]]$values,  n = 1)

	pageFanGenderCityValue = pageFanGenderCity[[1]]$value
	pageFanGenderCityDate = pageFanGenderCity[[1]]$end_time

	totalPageFanGenderCity = Reduce('+', pageFanGenderCityValue)

	pageFanGenderCityValue = pageFanGenderCityValue[order(unlist(pageFanGenderCityValue), decreasing= TRUE)]

	pageFanGenderCityTop = head(pageFanGenderCityValue, n = 10)

	result = list()
	result[['pageFanGenderCityTop']] = pageFanGenderCityTop
	result[['totalPageFanGenderCity']] = totalPageFanGenderCity

	return (result)
}