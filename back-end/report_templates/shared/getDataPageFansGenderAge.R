getDataPageFansGenderAge = function(pageID, token){

	requestUrlFansGenderAge = sprintf(
		"https://graph.facebook.com/%s/%s/insights?pretty=0&metric=page_fans_gender_age",
		"v2.10",
		pageID
	)

	fansGenderAge = callAPI(url = requestUrlFansGenderAge, token = token)
	fansGenderAge = tail(fansGenderAge$data[[1]]$values, n = 1)

	fansGenderValue = fansGenderAge[[1]]$value
	fansGenderDate = fansGenderAge[[1]]$end_time

	keyFansGenderValue = names(fansGenderValue)

	males = list()
	females = list()
	summarizeMales = c()
	summarizeFemales = c()

	for(i in 1:length(fansGenderValue)){
		letter = unlist(strsplit(keyFansGenderValue[[i]], "\\."))
		if(letter[1] == 'F'){
			females[[letter[2]]] = fansGenderValue[[i]]
			summarizeFemales = c(summarizeFemales, fansGenderValue[[i]])
		}

		if(letter[1] == 'M'){
			males[[letter[2]]] = fansGenderValue[[i]]
			summarizeMales = c(summarizeMales, fansGenderValue[[i]])
		}
	}

	result = list()
	result[['males']] = males
	result[['summarizeMales']] = sum(summarizeMales)
	result[['females']] = females
	result[['summarizeFemales']] = sum(summarizeFemales)

	return (result)

}