
createTitleFromResult = function(result_by_type){
	title = list()
	if(length(result_by_type) > 0){
		for(i in 1:length(result_by_type)){
			if(length(result_by_type[[i]]$value) > 0){
				title_tmp = names(result_by_type[[i]]$value)
				for(j in 1:length(title_tmp)){
					if(!(title_tmp[[j]] %in% title)){
						title = c(title, title_tmp[[j]])
					}
				}
			}
		}
	}
	return (title)
}

addValueNotExists = function(data, title){
	tmp_name = names(data)
	data_tmp = list()
	for(i in 1:length(title)){
		key = title[[i]]
		data_tmp[[key]] = 0
	}
	for(i in 1:length(tmp_name)){
		data_tmp[[tmp_name[i]]] = data[[tmp_name[i]]]
	}
	return (data_tmp)
}

# parseDataToVector = function(data){
# 	result = list()
# 	if(length(data) > 0){
# 		for(i in 1:length(data)){
# 			result = c(result, data[[i]])
# 		}
# 	}
	
# 	return (result)
# }

parseDataWeek = function(result_by_type){
	date_result = list()
	data_result = list()

	if(length(result_by_type) > 0){
		for(i in 1:length(result_by_type)){
			if(length(result_by_type[[i]]$value) > 0){
				date_result = c(date_result, substr(strftime(result_by_type[[i]]$end_time, "%m/%d/%Y"), 0, 10))
				data_result = c(data_result, result_by_type[[i]]$value)
			}
		}
	}
	result = list()
	result[['date']] = date_result
	result[['result']] = data_result

	return (result)
}

parseDataTime = function(result_by_type){
	title = createTitleFromResult(result_by_type)
	date_result = list()
	data_result = list()
	if(length(result_by_type) > 0){
		for(i in 1:length(result_by_type)){
			if(length(result_by_type[[i]]$value) > 0){
				date_result = c(date_result, substr(strftime(result_by_type[[i]]$end_time, "%m/%d/%Y"), 0, 10))
				value = addValueNotExists(result_by_type[[i]]$value, title)
				key = names(value)
				for(j in 1:length(value)){
					data_result[[key[j]]] = c(data_result[[key[j]]], value[[j]])
					# total = c(total, value[[j]])
				}
			}
		}
	}

	result_final = list()
	result_final[['date']] = date_result
	result_final[['result']] = data_result
	return (result_final)
}

parseDataInvoleWeekTime = function(dataResult){
	week = parseDataWeek(dataResult$like_by_week)
	time = parseDataTime(dataResult$like_by_time)

	result = list()

	result[['week_tilte']] = c('日時', '','page_fans_online_per_day:day', '1日: ページについて「いいね！」と言った人で特定の曜日にオンラインの人の数。(ユニークユーザー数)')
	result[['week_row']]  = length(week$date)
	result[['week_date']] = week$date
	result[['like_by_week']] = week$result

	result[['time_tilte']] = c('詳細' ,'日時', names(time$result))
	result[['tilte_by_time_des']] = '1日: ページに「いいね！」した人とその人たちがオンラインの時間帯(太平洋標準時刻/太平洋夏時間)です。(ユニークユーザー)'
	result[['time_row']] = length(time$date)
	result[['time_date']] = time$date
	result[['like_by_time']] = rapply(time$result, c)
	# result[['like_by_time']] = parseDataToVector(time$result)
	
	return (result)
}