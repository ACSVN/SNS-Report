getDataPageStorytellersByCity = function(pageID, token){

	requestUrlPageStorytellerCity = sprintf(
		"https://graph.facebook.com/%s/%s/insights?pretty=0&metric=page_storytellers_by_city&period=days_28",
		"v2.10",
		pageID
	)

	pageFanStorytellersCity = callAPI(url = requestUrlPageStorytellerCity, token = token)

	pageFanStorytellersCityValue = c()
	pageFanStorytellersCityDate = c()
	totalPageFanCityStorytellers = 0
	pageFanStorytellersCityTop = c()

	if(length(pageFanStorytellersCity$data) > 0){
		pageFanStorytellersCity = head(pageFanStorytellersCity$data[[1]]$values, n = 1)
		pageFanStorytellersCityValue = pageFanStorytellersCity[[1]]$value
		pageFanStorytellersCityDate = pageFanStorytellersCity[[1]]$end_time

		totalPageFanCityStorytellers = Reduce('+', pageFanStorytellersCityValue)
		pageFanStorytellersCityValue = pageFanStorytellersCityValue[order(unlist(pageFanStorytellersCityValue), decreasing = TRUE)]
		pageFanStorytellersCityTop = head(pageFanStorytellersCityValue, n = 10)
	}else{
		pageFanStorytellersCityTop = list()
	}

	result = list()
	result[['pageFanStorytellersCityTop']] = pageFanStorytellersCityTop
	result[['totalPageFanCityStorytellers']] = totalPageFanCityStorytellers

	return (result)
}