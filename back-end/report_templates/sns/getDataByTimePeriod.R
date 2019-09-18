library(lubridate)

urlGetDataMetricDayLifeTime = normalizePath("getDataByListMetricDayAndLifeTime.R")
source(urlGetDataMetricDayLifeTime, chdir = TRUE)


elapsed_months = function(start_date, end_date) {
	ed <- as.POSIXlt(end_date, format="%Y-%m-%d", tz = "UTC")
	sd <- as.POSIXlt(start_date, format="%Y-%m-%d", tz = "UTC")
	12 * (ed$year - sd$year) + (ed$mon - sd$mon)
}

getDataByTimePeriod = function(params){
	
	pageID 		= params[1]$pageID
	token 		= params[2]$accessToken
	startDate 	= params[3]$since_fdate
	endDate 	= params[4]$until_fdate

	num_elapsed_month = elapsed_months(startDate, endDate)
	num_month_add = 2

	start_date = dmy(strftime(startDate, "%d/%m/%Y")) - days(1)
	end_date = strftime(endDate, "%Y-%m-%d 23:59:59")

	date_limit = end_date

	since_start = start_date

	list_metric_day = 'page_impressions_by_age_gender_unique,page_fans_online_per_day,page_fans_online'
	list_metric_lifetime = 'page_fans_gender_age,page_storytellers_by_age_gender,page_fans_country,page_fans_city,page_fans_locale'

	result = list()

    for(i in 1:ceiling(num_elapsed_month/num_month_add)){
    	until_start = dmy(strftime(since_start, "%d/%m/%Y")) + days(60)
    	until_start = paste(format(until_start, format="%Y-%m"),"-", days_in_month(until_start), sep="")
    	if(until_start < date_limit){
    		value_tmp = getDataByListMetricDayAndLifeTime(pageID, token, since_start, until_start, list_metric_day, list_metric_lifetime)
    		result[['like_by_age']] = c(result[['like_by_age']], value_tmp$like_by_age)
			result[['like_by_reach']] = c(result[['like_by_reach']], value_tmp$like_by_reach)
			result[['like_by_action']] = c(result[['like_by_action']], value_tmp$like_by_action)
			result[['like_by_city']] = c(result[['like_by_city']], value_tmp$like_by_city)
			result[['like_by_country']] = c(result[['like_by_country']], value_tmp$like_by_country)
			result[['like_by_language']] = c(result[['like_by_language']], value_tmp$like_by_language)
			result[['like_by_week']] = c(result[['like_by_week']], value_tmp$like_by_week)
			result[['like_by_time']] = c(result[['like_by_time']], value_tmp$like_by_time)
    		since_start = dmy(strftime(until_start, "%d/%m/%Y")) - days(1)
    	}else{
    		until_start = dmy(strftime(end_date, "%d/%m/%Y")) + days(1)
    		value_tmp = getDataByListMetricDayAndLifeTime(pageID, token, since_start, until_start, list_metric_day, list_metric_lifetime)
    		result[['like_by_age']] = c(result[['like_by_age']], value_tmp$like_by_age)
			result[['like_by_reach']] = c(result[['like_by_reach']], value_tmp$like_by_reach)
			result[['like_by_action']] = c(result[['like_by_action']], value_tmp$like_by_action)
			result[['like_by_city']] = c(result[['like_by_city']], value_tmp$like_by_city)
			result[['like_by_country']] = c(result[['like_by_country']], value_tmp$like_by_country)
			result[['like_by_language']] = c(result[['like_by_language']], value_tmp$like_by_language)
			result[['like_by_week']] = c(result[['like_by_week']], value_tmp$like_by_week)
			result[['like_by_time']] = c(result[['like_by_time']], value_tmp$like_by_time)
    		break;
    	}    	
    }
    return (result)

}