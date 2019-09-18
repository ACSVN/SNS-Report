getDataPageFansGenderCountry = function(pageID, token){

	requestUrlPageFanGenderCountry = sprintf(
		"https://graph.facebook.com/%s/%s/insights?pretty=0&metric=page_fans_country",
		"v2.10",
		pageID
	)

	pageFanGenderCountry = callAPI(url = requestUrlPageFanGenderCountry, token = token)

	pageFanGenderCountry = tail(pageFanGenderCountry$data[[1]]$values, n=1)

	pageFanGenderCountryValue = pageFanGenderCountry[[1]]$value
	pageFanGenderCountryDate =  pageFanGenderCountry[[1]]$end_time

	totalFanGenderCountry = Reduce("+", pageFanGenderCountryValue)

	pageFanGenderCountryValue = pageFanGenderCountryValue[order(unlist(pageFanGenderCountryValue), decreasing=TRUE)]

	pageFanGenderCountryTop = head(pageFanGenderCountryValue, n = 10)

	result = list()
	result[['pageFanGenderCountryTop']] = pageFanGenderCountryTop
	result[['totalFanGenderCountry']] = totalFanGenderCountry

	return (result)
}