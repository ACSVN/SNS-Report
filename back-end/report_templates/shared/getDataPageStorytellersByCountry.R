getDataPageStorytellersByCountry = function(pageID, token){

	requestUrlPageFanCountryStorytelers = sprintf(
		"https://graph.facebook.com/%s/%s/insights?pretty=0&metric=page_storytellers_by_country&period=days_28",
		"v2.10",
		pageID
	)

	pageFanCountryStotytelers = callAPI(url = requestUrlPageFanCountryStorytelers, token = token)

	pageFanCountryStotytelersValue = c()
	pageFanCountryStotytelersDate = c()
	totalPageFanCountryStotytelers = 0
	pageFanCountryStotytelersTop = c()

	if(length(pageFanCountryStotytelers$data) > 0){
		pageFanCountryStotytelers = head(pageFanCountryStotytelers$data[[1]]$values, n = 1)
		pageFanCountryStotytelersValue = pageFanCountryStotytelers[[1]]$value
		pageFanCountryStotytelersDate = pageFanCountryStotytelers[[1]]$end_time

		totalPageFanCountryStotytelers = Reduce('+', pageFanCountryStotytelersValue)
		pageFanCountryStotytelersValue = pageFanCountryStotytelersValue[order(unlist(pageFanCountryStotytelersValue), decreasing=TRUE)]
		pageFanCountryStotytelersTop = head(pageFanCountryStotytelersValue, n = 10)
	}else{
		pageFanCountryStotytelersTop = list()
	}

	result = list()
	result[['pageFanCountryStotytelersTop']] = pageFanCountryStotytelersTop
	result[['totalPageFanCountryStotytelers']] = totalPageFanCountryStotytelers

	return (result)

}