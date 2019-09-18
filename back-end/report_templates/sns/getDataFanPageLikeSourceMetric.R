library(lubridate)

urlKeyMetric = normalizePath("getDataKeyMetrics.R")
source(urlKeyMetric, chdir = TRUE)

elapsed_months = function(start_date, end_date) {
	ed <- as.POSIXlt(end_date, format="%Y-%m-%d", tz = "UTC")
	sd <- as.POSIXlt(start_date, format="%Y-%m-%d", tz = "UTC")
	12 * (ed$year - sd$year) + (ed$mon - sd$mon)
}

temp_key_metric = c('page_fan_adds_unique', 'page_fan_removes_unique', 'page_engaged_users', 'page_impressions_unique', 'page_impressions_organic_unique', 'page_impressions_paid_unique', 'page_impressions', 'page_impressions_organic', 'page_impressions_paid', 'page_posts_impressions_unique', 'page_posts_impressions_organic_unique', 'page_posts_impressions_paid_unique', 'page_posts_impressions', 'page_posts_impressions_organic', 'page_posts_impressions_paid', 'page_negative_feedback_unique', 'page_negative_feedback', 'page_impressions_viral', 'page_impressions_viral_unique')

appendDataToListKeyMetric = function(list_result, list_append){
	title = names(list_append)
	for(i in 1:length(temp_key_metric)){
		list_result[[title[i]]] = c(list_result[[title[i]]], list_append[[title[i]]])		
	}
	return (list_result)
}

getDataFanPageLikeSourceMetric = function(params){

	pageID 		= params[1]$pageID
	token 		= params[2]$accessToken
	startDate 	= params[3]$since_fdate
	endDate 	= params[4]$until_fdate

	since_start = dmy(strftime(startDate, "%d/%m/%Y")) - days(1)

	date_limit = endDate

	num_elapsed_month = elapsed_months(startDate, endDate)
	num_month_add = 2

	pageFan = list()
	pageFanLikeBySource = list()
	keyMetric = list()
	insightEngagement = list()

	for(mloop in 1:ceiling(num_elapsed_month/num_month_add)){

		since_until = dmy(strftime(since_start, "%d/%m/%Y")) + days(60)
		since_until = paste(format(since_until, format="%Y-%m"),"-", days_in_month(since_until), sep="")
		if(since_until < date_limit){
			pageFan = c(pageFan, getDataPageFan(pageID, token, since_start, since_until))
			pageFanLikeBySource = c(pageFanLikeBySource, getDataPageFansByLikeSource(pageID, token, since_start, since_until))
			
			insightEngagement = c(insightEngagement, getDataInsightEngagement(pageID, token, since_start, since_until))

			keyMetricLoop = getDataKeyMetrics(pageID, token, since_start, since_until)
			keyMetric = appendDataToListKeyMetric(keyMetric, keyMetricLoop)

			since_start = dmy(strftime(since_until, "%d/%m/%Y")) - days(1)
		}else{
			since_until = strftime(endDate, "%Y-%m-%d 23:59:59")
			pageFan = c(pageFan, getDataPageFan(pageID, token, since_start, since_until))
			pageFanLikeBySource = c(pageFanLikeBySource, getDataPageFansByLikeSource(pageID, token, since_start, since_until))
			
			insightEngagement = c(insightEngagement, getDataInsightEngagement(pageID, token, since_start, since_until))

			keyMetricLoop = getDataKeyMetrics(pageID, token, since_start, since_until)
			keyMetric = appendDataToListKeyMetric(keyMetric, keyMetricLoop)

			break;
		}
	}

	result = list()
	result[['pageFan']] = pageFan
	result[['pageFanLikeBySource']] = pageFanLikeBySource
	result[['insightEngagement']] = insightEngagement
	result[['keyMetric']] = keyMetric

	return (result)
}