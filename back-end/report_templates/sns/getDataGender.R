
getDataGender = function(params){
	pageID 		= params[1]$pageID
	token 		= params[2]$accessToken

	genderAge = getDataPageFansGenderAge(pageID, token)
	storytellersByAge = getDataPageStorytellersByAge(pageID, token)

	genderCity = getDataPageFansGenderCity(pageID, token)
	storytellersByCity = getDataPageStorytellersByCity(pageID, token)

	genderCountry = getDataPageFansGenderCountry(pageID, token)
	storytellersByCountry = getDataPageStorytellersByCountry(pageID, token)

	genderLocale = getDataPageFansGenderLocale(pageID, token)
	storytellersByLocale = getDataPageStorytellersByLocale(pageID, token)

	result = list()
	result[['genderAge']] = genderAge
	result[['storytellersByAge']] = storytellersByAge
	result[['genderCity']] = genderCity
	result[['storytellersByCity']] = storytellersByCity
	result[['genderCountry']] = genderCountry
	result[['storytellersByCountry']] = storytellersByCountry
	result[['genderLocale']] = genderLocale
	result[['storytellersByLocale']] = storytellersByLocale

	return (result)
}