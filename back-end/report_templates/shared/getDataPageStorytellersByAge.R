getDataPageStorytellersByAge = function(pageID, token){

	requestUrlFansGenderAgeStorytellers = sprintf(
		"https://graph.facebook.com/%s/%s/insights?pretty=0&metric=page_storytellers_by_age_gender&period=days_28",
		"v2.10",
		pageID
	)

	fansGenderAgeStorytellers = callAPI(url = requestUrlFansGenderAgeStorytellers, token = token)

	fansGenderAgeStorytellersValue = c()
	fansGenderAgeStorytellersDate = c()

	if(length(fansGenderAgeStorytellers$data) > 0){
		fansGenderAgeStorytellers = head(fansGenderAgeStorytellers$data[[1]]$values, n=1)

		fansGenderAgeStorytellersValue = fansGenderAgeStorytellers[[1]]$value
		fansGenderAgeStorytellersDate = fansGenderAgeStorytellers[[1]]$end_time
	}

	malesStorytellers = list()
	femalesStorytellers = list()
	summarizeMalesStorytellers = c()
	summarizeFemalesStorytellers = c()

	if(length(fansGenderAgeStorytellersValue) > 0){
		keyFansGenderAgeStorytellersValue = names(fansGenderAgeStorytellersValue)
		for(i in 1:length(fansGenderAgeStorytellersValue)){
			letter = unlist(strsplit(keyFansGenderAgeStorytellersValue[[i]], "\\."))

			if(letter[1] == 'F'){
				femalesStorytellers[[letter[2]]] = fansGenderAgeStorytellersValue[[i]]
				summarizeFemalesStorytellers = c(summarizeFemalesStorytellers, fansGenderAgeStorytellersValue[[i]])
			}

			if(letter[1] == 'M'){
				malesStorytellers[[letter[2]]] = fansGenderAgeStorytellersValue[[i]]
				summarizeMalesStorytellers = c(summarizeMalesStorytellers, fansGenderAgeStorytellersValue[[i]])
			}
		}
	}

	result = list()
	result[['malesStorytellers']] = malesStorytellers
	result[['summarizeMalesStorytellers']] = sum(summarizeMalesStorytellers)
	result[['femalesStorytellers']] = femalesStorytellers
	result[['summarizeFemalesStorytellers']] = sum(summarizeFemalesStorytellers)

	return (result)
	
}