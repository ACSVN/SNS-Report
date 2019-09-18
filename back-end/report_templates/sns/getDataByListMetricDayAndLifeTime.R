
urlMetricDay = normalizePath("getDataByMetricDay.R")
source(urlMetricDay, chdir = TRUE)

urlMetricLifetime = normalizePath("getDataByMetricLifeTime.R")
source(urlMetricLifetime, chdir = TRUE)

getDataByListMetricDayAndLifeTime = function(pageID, token, start_date, end_date, list_metric_day, list_metric_lifetime){

	metricDayResult = getDataByMetricDay(pageID, token, start_date, end_date, list_metric_day)
	
	metricLifeTimeResult = getDataByMetricLifeTime(pageID, token, start_date, end_date, list_metric_lifetime)

	result = list()
	result[['like_by_reach']] = metricDayResult$like_by_reach
	result[['like_by_week']] = metricDayResult$like_by_week
	result[['like_by_time']] = metricDayResult$like_by_time

	result[['like_by_age']] = metricLifeTimeResult$like_by_age
	result[['like_by_action']] = metricLifeTimeResult$like_by_action
	result[['like_by_country']] = metricLifeTimeResult$like_by_country
	result[['like_by_city']] = metricLifeTimeResult$like_by_city
	result[['like_by_language']] = metricLifeTimeResult$like_by_language

	return (result)
}