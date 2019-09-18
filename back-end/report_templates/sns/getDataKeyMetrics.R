getDataKeyMetrics = function(pageID, token, start_date, end_date){
	temp_key_metric = c('page_fan_adds_unique', 'page_fan_removes_unique', 'page_engaged_users', 'page_impressions_unique', 'page_impressions_organic_unique', 'page_impressions_paid_unique', 'page_impressions', 'page_impressions_organic', 'page_impressions_paid', 'page_posts_impressions_unique', 'page_posts_impressions_organic_unique', 'page_posts_impressions_paid_unique', 'page_posts_impressions', 'page_posts_impressions_organic', 'page_posts_impressions_paid', 'page_negative_feedback_unique', 'page_negative_feedback', 'page_impressions_viral', 'page_impressions_viral_unique')

	result = list()

	for(i in 1:length(temp_key_metric)){
		tmp = getDataKeyMetric(pageID, token, temp_key_metric[i], start_date, end_date)
		result[[temp_key_metric[i]]] = tmp
	}

	return (result)
}

getDataInsightEngagement = function(pageID, token, start_date, end_date){
	
	result = list()

	tmp = getDataKeyMetric(pageID, token, 'page_engaged_users', start_date, end_date)
	result = c(result, tmp)
	
	return (result)
}