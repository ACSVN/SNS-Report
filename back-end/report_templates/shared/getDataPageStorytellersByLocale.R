getDataPageStorytellersByLocale = function(pageID, token){

	requestUrlPageFanLocaleStorytelers = sprintf(
		"https://graph.facebook.com/%s/%s/insights?pretty=0&metric=page_fans_city",
		"v2.10",
		pageID
	)

	pageFanLocaleStorytelers = callAPI(url = requestUrlPageFanLocaleStorytelers, token = token)

	pageFanLocaleStorytelersValue = c()
	pageFanLocaleStorytelersDate = c()
	totalPageFanLocaleStoryteller = 0
	pageFanLocaleStorytelersTop = c()

	if(length(pageFanLocaleStorytelers$data) > 0){
		pageFanLocaleStorytelers = head(pageFanLocaleStorytelers$data[[1]]$values, n = 1)
		pageFanLocaleStorytelersValue = pageFanLocaleStorytelers[[1]]$value
		pageFanLocaleStorytelersDate = pageFanLocaleStorytelers[[1]]$end_time

		totalPageFanLocaleStoryteller = Reduce('+', pageFanLocaleStorytelersValue)
		pageFanLocaleStorytelersValue = pageFanLocaleStorytelersValue[order(unlist(pageFanLocaleStorytelersValue), decreasing = TRUE)]
		pageFanLocaleStorytelersTop = head(pageFanLocaleStorytelersValue, n = 10)		
	}

	result = list()
	result[['pageFanLocaleStorytelersTop']] = pageFanLocaleStorytelersTop
	result[['totalPageFanLocaleStoryteller']] = totalPageFanLocaleStoryteller

	return (result)
}