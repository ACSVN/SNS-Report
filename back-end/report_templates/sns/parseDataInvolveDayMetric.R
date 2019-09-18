
createTitleFromResult = function(result_by_type){
	title = list()
	if(length(result_by_type) > 0){
		for(i in 1:length(result_by_type)){
			if(length(result_by_type[[i]]$value) > 0){
				title_tmp = names(result_by_type[[i]]$value)
				# print(title_tmp)
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

parseDataWithType = function(data_result){
	males = list()
	females = list()
	unkown = list()
	sum_male_gender = 0
	sum_female_gender = 0
	sum_unkown_gender = 0
	sum_gender_all = 0

	ages = list()
	fans = list()
	genders = list()
	name_genders= list()	
	arr_gender_result = list()
	arr_name_gender = list()
	arr_gender = list()
	arr_age = list()
	arr_fans = list()
	if(length(data_result) > 0){
		titleType = names(data_result)
		titleType = sort(titleType)
		
		data_result = data_result[titleType]
		if(length(data_result) > 0){
			for(i in 1:length(data_result)){
				title_tmp = unlist(strsplit(titleType[i], '\\.'))
				# print(titleType[i])
				# arr_gender_result = c(arr_gender_result, paste(data_result[[titleType[i]]], collapse = ','))
				arr_gender_result = c(arr_gender_result, data_result[[titleType[i]]])
				if(title_tmp[1] == 'F'){
					females[[title_tmp[1]]] = c(females[[title_tmp[1]]], Reduce('+', data_result[[titleType[i]]]))
					females[['name_gender']] = c(females[['name_gender']], 'Female')
					females[['gender']] = c(females[['gender']], title_tmp[1])
					females[['age']] = c(females[['age']], title_tmp[2])
					females[['fans']] = c(females[['fans']], Reduce('+', data_result[[titleType[i]]]))
				}

				if(title_tmp[1] == 'M'){
					males[[title_tmp[1]]] = c(males[[title_tmp[1]]], Reduce('+', data_result[[titleType[i]]]))
					males[['name_gender']] = c(males[['name_gender']], 'Male')
					males[['gender']] = c(males[['gender']], title_tmp[1])
					males[['age']] = c(males[['age']], title_tmp[2])
					males[['fans']] = c(males[['fans']], Reduce('+', data_result[[titleType[i]]]))
				}

				if(title_tmp[1] == 'U'){
					unkown[[title_tmp[1]]] = c(unkown[[title_tmp[1]]], Reduce('+', data_result[[titleType[i]]]))
					unkown[['name_gender']] = c(unkown[['name_gender']], 'Unkown')
					unkown[['gender']] = c(unkown[['gender']], title_tmp[1])
					unkown[['age']] = c(unkown[['age']], title_tmp[2])
					unkown[['fans']] = c(unkown[['fans']], Reduce('+', data_result[[titleType[i]]]))
				}
			}
		}

		if(length(females[['name_gender']]) > 0){
			sum_female_gender = Reduce('+', females[['fans']])
			arr_name_gender = c(arr_name_gender, females[['name_gender']])
			arr_gender = c(arr_gender, females[['gender']])
			arr_age = c(arr_age, females[['age']])
			arr_fans = c(arr_fans, females[['fans']])
		}

		if(length(males[['name_gender']]) > 0){
			sum_male_gender = Reduce('+', males[['fans']])
			arr_name_gender = c(arr_name_gender, males[['name_gender']])
			arr_gender = c(arr_gender, males[['gender']])
			arr_age = c(arr_age, males[['age']])
			arr_fans = c(arr_fans, males[['fans']])
		}

		if(length(unkown[['name_gender']]) > 0){
			sum_unkown_gender = Reduce('+', unkown[['fans']])
			arr_name_gender = c(arr_name_gender, unkown[['name_gender']])
			arr_gender = c(arr_gender, unkown[['gender']])
			arr_age = c(arr_age, unkown[['age']])
			arr_fans = c(arr_fans, unkown[['fans']])
		}

		sum_gender_all = sum(sum_female_gender, sum_male_gender, sum_unkown_gender)
		
		if(length(arr_gender_result) > 0){
			nrow = length(arr_gender_result[[1]][1])
			ncol = length(titleType)
			arr_gender_result = arr_gender_result
		}else{
			nrow = 0
			ncol = 0
			arr_gender_result = list()
		}

		if(length(titleType) > 0){
			titleType = c('詳細', '日時', titleType)
		}else{
			titleType = c('詳細', '日時')
		}
		
	}else{
		titleType = c('詳細', '日時')
	}

	result_final = list()
	result_final[['title']] = titleType
	result_final[['nrow']] = nrow
	result_final[['ncol']] = ncol
	result_final[['name_gender']] = arr_name_gender
	result_final[['gender']] = arr_gender
	result_final[['age']] = arr_age
	result_final[['fans']] = arr_fans
	result_final[['sum_male_gender']] = sum_male_gender
	result_final[['sum_female_gender']] = sum_female_gender
	result_final[['sum_unkown_gender']] = sum_unkown_gender
	result_final[['sum_gender_all']] = sum_gender_all
	result_final[['result']] = arr_gender_result
	return (result_final)
}

addValueNotExists = function(data, title_age){
	tmp_name = names(data)
	# data_tmp = list("F.13-17" = 0, "F.18-24" = 0, "F.25-34" = 0, "F.35-44" = 0, "F.45-54" = 0, "F.55-64" = 0, "F.65+" = 0,
	# 	"M.13-17" = 0, "M.18-24" = 0, "M.25-34" = 0, "M.35-44" = 0, "M.45-54" = 0, "M.55-64" = 0, "M.65+" = 0,
	# 	"U.13-17" = 0, "U.18-24" = 0, "U.25-34" = 0, "U.35-44" = 0, "U.45-54" = 0, "U.55-64" = 0, "U.65+" = 0)
	data_tmp = list()
	for(i in 1:length(title_age)){
		key = title_age[[i]]
		data_tmp[[key]] = 0
	}
	for(i in 1:length(tmp_name)){
		data_tmp[[tmp_name[i]]] = data[[tmp_name[i]]]
	}
	return (data_tmp)
}

parseData = function(result_by_type, title_des){
	title = createTitleFromResult(result_by_type)
	
	date_result = list()
	data_result = list()
	result = list()
	if(length(result_by_type) > 0){
		for(i in 1:length(result_by_type)){
			if(length(result_by_type[[i]]$value) > 0){
				date_result = c(date_result, substr(strftime(result_by_type[[i]]$end_time, "%m/%d/%Y"), 0, 10))
				# value = result_by_type[[i]]$value
				value = addValueNotExists(result_by_type[[i]]$value, title)
				key = names(value)
				for(j in 1:length(value)){
					data_result[[key[j]]] = c(data_result[[key[j]]], value[[j]])
				}
			}
		}

	}

	result = parseDataWithType(data_result)

	result_final = list()
	result_final[['title']] = result$title
	result_final[['date']] = date_result
	result_final[['nrow']] = result$nrow
	result_final[['ncol']] = result$ncol
	result_final[['name_gender']] = result$name_gender
	result_final[['gender']] = result$gender
	result_final[['age']] = result$age
	result_final[['fans']] = result$fans
	result_final[['title_des']] = title_des
	result_final[['sum_male_gender']] = result$sum_male_gender
	result_final[['sum_female_gender']] = result$sum_female_gender
	result_final[['sum_unkown_gender']] = result$sum_unkown_gender
	result_final[['sum_gender_all']] = result$sum_gender_all
	result_final[['result']] = result$result
	# print(result$fans)
	return (result_final)	
}

parseDataInvolveDayMetric = function(dataResult){
	age_title = '通算: ページを「いいね！」した人の性別と年齢の集計データです。ユーザーのプロフィールに記載されている情報に基づいて集計されます。(ユニークユーザー数)'
	like_by_age = parseData(dataResult$like_by_age, age_title)
	
	reach_title = '1日: Facebookページの年齢および性別合計リーチ。(ユニークユーザー数)'
	like_by_reach = parseData(dataResult$like_by_reach, reach_title)
	
	action_title = '1日: 年齢・性別別のFacebookページを話題にしている人の人数(ユニークユーザー)'
	like_by_action = parseData(dataResult$like_by_action, action_title)	
	# print(like_by_action)
	result = list()
	result[['like_title']] = like_by_age$title
	result[['like_date']] = like_by_age$date
	result[['like_nrow']] = like_by_age$nrow
	result[['like_ncol']] = like_by_age$ncol
	result[['like_name_gender']] = like_by_age$name_gender
	result[['like_gender']] = like_by_age$gender
	result[['like_age']] = like_by_age$age
	result[['like_fans']] = like_by_age$fans
	result[['like_title_des']] = like_by_age$title_des
	result[['like_sum_male_gender']] = like_by_age$sum_male_gender
	result[['like_sum_female_gender']] = like_by_age$sum_female_gender
	result[['like_sum_unkown_gender']] = like_by_age$sum_unkown_gender
	result[['like_sum_gender_all']] = like_by_age$sum_gender_all
	result[['like_by_age']] = like_by_age$result

	result[['reach_title']] = like_by_reach$title
	result[['reach_date']] = like_by_reach$date
	result[['reach_nrow']] = like_by_reach$nrow
	result[['reach_ncol']] = like_by_reach$ncol
	result[['reach_name_gender']] = like_by_reach$name_gender
	result[['reach_gender']] = like_by_reach$gender
	result[['reach_age']] = like_by_reach$age
	result[['reach_fans']] = like_by_reach$fans
	result[['reach_title_des']] = like_by_reach$title_des
	result[['reach_sum_male_gender']] = like_by_reach$sum_male_gender
	result[['reach_sum_female_gender']] = like_by_reach$sum_female_gender
	result[['reach_sum_unkown_gender']] = like_by_reach$sum_unkown_gender
	result[['reach_sum_gender_all']] = like_by_reach$sum_gender_all
	result[['reach_by_age']] = like_by_reach$result

	result[['action_title']] = like_by_action$title
	result[['action_date']] = like_by_action$date
	result[['action_nrow']] = like_by_action$nrow
	result[['action_ncol']] = like_by_action$ncol
	result[['action_name_gender']] = like_by_action$name_gender
	result[['action_gender']] = like_by_action$gender
	result[['action_age']] = like_by_action$age
	result[['action_fans']] = like_by_action$fans
	result[['action_title_des']] = like_by_action$title_des
	result[['action_sum_male_gender']] = like_by_action$sum_male_gender
	result[['action_sum_female_gender']] = like_by_action$sum_female_gender
	result[['action_sum_unkown_gender']] = like_by_action$sum_unkown_gender
	result[['action_sum_gender_all']] = like_by_action$sum_gender_all
	result[['action_by_age']] = like_by_action$result

	return (result)
}