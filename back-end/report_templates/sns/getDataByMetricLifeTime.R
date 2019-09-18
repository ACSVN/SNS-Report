getDataByMetricLifeTime = function(pageID, token, start_date, end_date, list_metric_lifetime){

	requestUrlMetricLifeTime = sprintf(
		"https://graph.facebook.com/%s/%s/insights?pretty=0&metric=%s&since=%s&until=%s",
		"v2.10",
		pageID,
		list_metric_lifetime,
		start_date,
		end_date
	)

	byMetricLifeTime = callAPI(url = requestUrlMetricLifeTime, token = token)

	byMetricLifeTime = byMetricLifeTime$data
	
	# return (byMetricLifeTime)
	like_by_age = list()
	like_by_action = list()
	like_by_country = list()
	like_by_city = list()
	like_by_language = list()

	# metric_lifetime = unlist(strsplit(list_metric_lifetime, split = ','))

	result_metric_lifetime = list()
	if(length(byMetricLifeTime) > 0){
		for(i in 1:length(byMetricLifeTime)){
			if(byMetricLifeTime[[i]]$name == 'page_fans_gender_age'){
				like_by_age = byMetricLifeTime[[i]]$values
			}
			if(byMetricLifeTime[[i]]$name == 'page_storytellers_by_age_gender'){
				like_by_action = byMetricLifeTime[[i]]$values
			}
			if(byMetricLifeTime[[i]]$name == 'page_fans_country'){
				like_by_country = byMetricLifeTime[[i]]$values
			}
			if(byMetricLifeTime[[i]]$name == 'page_fans_city'){
				like_by_city = byMetricLifeTime[[i]]$values
			}
			if(byMetricLifeTime[[i]]$name == 'page_fans_locale'){
				like_by_language = byMetricLifeTime[[i]]$values
			}
		}
	}

	result_metric_lifetime[['like_by_age']] = like_by_age
	result_metric_lifetime[['like_by_action']] = like_by_action
	result_metric_lifetime[['like_by_country']] = like_by_country
	result_metric_lifetime[['like_by_city']] = like_by_city
	result_metric_lifetime[['like_by_language']] = like_by_language

	return (result_metric_lifetime)

}