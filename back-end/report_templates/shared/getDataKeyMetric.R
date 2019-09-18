getDataKeyMetric = function(pageID, token, metric_type, start_date, end_date){

	since_start = dmy(strftime(start_date, "%d/%m/%Y")) - days(1)
	since_end = dmy(strftime(end_date, "%d/%m/%Y")) + days(1)

	requestUrlKeyMetric = sprintf(
		"https://graph.facebook.com/%s/%s/insights?metric=%s&period=day&since=%s&until=%s",
		"v2.10",
		pageID,
		metric_type,
		since_start,
		since_end
	)
	
	metricData = callAPI(url = requestUrlKeyMetric, token = token)
	metricData = metricData$data[[1]]$values

	for(i in 1:length(metricData)){
		if(length(metricData[[i]]$value %in% metricData[[1]]) == 0){
			metricData[[i]][['value']] = ' '
		}
	}
	# print(metricData)
	return (metricData)

}