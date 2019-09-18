
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

parseData = function(result_by_type){
	title = createTitleFromResult(result_by_type)
	date_result = list()
	data_result = list()
	total = c()
	if(length(result_by_type) > 0){
		for(i in 1:length(result_by_type)){
			if(length(result_by_type[[i]]$value) > 0){
				date_result = c(date_result, substr(strftime(result_by_type[[i]]$end_time, "%m/%d/%Y"), 0, 10))
				value = addValueNotExists(result_by_type[[i]]$value, title)
				key = names(value)
				for(j in 1:length(value)){
					data_result[[key[j]]] = c(data_result[[key[j]]], value[[j]])
					total = c(total, value[[j]])
				}
			}
		}
	}
	if(length(data_result) > 0){
		titleType = names(data_result)
		titleType = sort(titleType)
		data_result = data_result[titleType]
	}

	result_final = list()
	result_final[['date']] = date_result
	result_final[['result']] = data_result
	result_final[['total']] = total
	return (result_final)
}

convertNameToJP = function(en_name){
	if(en_name == 'DZ'){
	    return ('アルジェリア')
	}
	if (en_name == 'AR') {
	    return ('アルゼンチン')
	}
	if (en_name == 'TH') {
	    return ('タイ')
	}
	if (en_name == 'JP') {
	    return ('日本')
	}
	if (en_name == 'MX') {
	    return ('メキシコ')
	}
	if (en_name == 'BR') {
	    return ('ブラジル')
	}
	if (en_name == 'US') {
	    return ('アメリカ')
	}
	if (en_name == 'IT') {
	    return ('イタリア')
	}
	if (en_name == 'EG') {
	    return ('エジプト')
	}
	if (en_name == 'PH') {
	    return ('フィリピン')
	}
	if (en_name == 'GB') {
	    return ('イギリス')
	}
	if (en_name == 'FR') {
	    return ('フランス')
	}
	if (en_name == 'IQ') {
	    return ('イラク')
	}
	if (en_name == 'ES') {
	    return ('スペイン')
	}
	return (en_name)
}

getTopTenData = function(data){
	value_top_ten = c()
	name_top_ten = c()
	if(length(data$result) > 0){
		df = data.frame(data$result)
		df = df[,order(colSums(-df,na.rm=TRUE))]
		data_top_ten = as.list(df) %>% head(10)
		name_top_ten_tmp = gsub("result.", "", names(data_top_ten))
		for(i in 1:length(name_top_ten_tmp)){
			name_top_ten = c(name_top_ten, convertNameToJP(name_top_ten_tmp[i]))
			value_top_ten = c(value_top_ten, sum(data_top_ten[[name_top_ten_tmp[i]]]))
		}
	}
	result = list()
	result[['name_top_ten']] = name_top_ten
	result[['value_top_ten']] = value_top_ten

	return (result)
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

parseDataInvoleLifeTimeMetric = function(dataResult){
	
	country = parseData(dataResult$like_by_country)
	country_top_ten = getTopTenData(country)
	like_by_country = rapply(country$result, c)
	# like_by_country = parseDataToVector(country$result)

	city = parseData(dataResult$like_by_city)
	city_top_ten = getTopTenData(city)
	like_by_city = rapply(city$result, c)
	# like_by_city = parseDataToVector(city$result)

	language = parseData(dataResult$like_by_language)
	language_top_ten = getTopTenData(language)
	like_by_language = rapply(language$result, c)
	# like_by_language = parseDataToVector(language$result)

	result = list()

	result[['country_title']] = c('詳細', '日時', names(country$result))
	result[['country_date']] = country$date
	result[['country_nrow']] = length(country$date)
	result[['country_title_des']] = '通算: Facebookページに「いいね！」した人の位置データを国別に集計したものです。(ユニークユーザー数)'
	result[['like_by_country']] = like_by_country

	# result[['country_top_ten_title']] = '国'
	result[['country_top_ten_name']] = c('国', country_top_ten$name_top_ten)
	result[['country_top_ten_fans']] = country_top_ten$value_top_ten
	result[['country_total_fans']] = sum(country$total)

	result[['city_title']] = c('詳細', '日時', names(city$result))
	result[['city_date']] = city$date
	result[['city_nrow']] = length(city$date)
	result[['city_title_des']] = '通算: 集計位置データです。ページを「いいね！」した人を都市別に表示しています。(ユニークユーザー数)'
	result[['like_by_city']] = like_by_city

	# result[['city_top_ten_title']] = '市区町村'
	result[['city_top_ten_name']] = c('市区町村', city_top_ten$name_top_ten)
	result[['city_top_ten_fans']] = city_top_ten$value_top_ten
	result[['city_total_fans']] = sum(city$total)

	result[['language_title']] = c('詳細', '日時', names(language$result))
	result[['language_date']] = language$date
	result[['language_nrow']] = length(language$date)
	result[['language_title_des']] = '通算: Facebookページに「いいね！」した人の位置データを国別に集計したものです。(ユニークユーザー数)'
	result[['like_by_language']] = like_by_language

	# result[['language_top_ten_title']] = '言語'
	result[['language_top_ten_name']] = c('言語', language_top_ten$name_top_ten)
	result[['language_top_ten_fans']] = language_top_ten$value_top_ten
	result[['language_total_fans']] = sum(language$total)

	return (result)
}