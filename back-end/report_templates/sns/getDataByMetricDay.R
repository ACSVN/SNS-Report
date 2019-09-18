
getDataByMetricDay = function(pageID, token, start_date, end_date, list_metric_day){

	requestUrlMetricDay = sprintf(
		"https://graph.facebook.com/%s/%s/insights?metric=%s&period=day&since=%s&until=%s",
		"v2.10",
		pageID,
		list_metric_day,
		start_date,
		end_date
	)
	
	byMetricDay = callAPI(url = requestUrlMetricDay, token = token)
	byMetricDay = byMetricDay$data

	# metric_day = unlist(strsplit(list_metric_day, split = ','))

	like_by_reach = list()
	like_by_week = list()
	like_by_time = list()
	result_metric_day = list()
	if(length(byMetricDay) > 0){
		for(i in 1:length(byMetricDay)){
			if(byMetricDay[[i]]$name == 'page_impressions_by_age_gender_unique'){
				like_by_reach = byMetricDay[[i]]$values
			}
			if(byMetricDay[[i]]$name == 'page_fans_online_per_day'){
				like_by_week = byMetricDay[[i]]$values
			}
			if(byMetricDay[[i]]$name == 'page_fans_online'){
				like_by_time = byMetricDay[[i]]$values
			}
		}
	}
	
	result_metric_day[['like_by_reach']] = like_by_reach
	result_metric_day[['like_by_week']] = like_by_week
	result_metric_day[['like_by_time']] = like_by_time

	return (result_metric_day)
}