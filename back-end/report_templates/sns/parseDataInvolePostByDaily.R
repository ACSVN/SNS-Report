getLikeCommentShare = normalizePath("getLikeCommentsShareReachImageOfPost.R")
source(getLikeCommentShare, chdir = TRUE)

parseDataForSheet5P = function(dataframe){

	data_sheet5 = dataframe

	# data like, comment, share
	data_sheet5 = cbind(data_sheet5, month = '')
	data_sheet5$month = strftime(data_sheet5$date_full, "%m")

	unlike = aggregate(data_sheet5$data_fans_remove, by=list(month=data_sheet5$month), FUN=sum)

	like = aggregate(data_sheet5$total_like, by=list(month=data_sheet5$month), FUN=sum)
	comment = aggregate(data_sheet5$total_comment, by=list(month=data_sheet5$month), FUN=sum)
	share = aggregate(data_sheet5$total_share, by=list(month=data_sheet5$month), FUN=sum)
	reach = aggregate(data_sheet5$total_reach, by=list(month=data_sheet5$month), FUN=sum)

	ins_egm = aggregate(data_sheet5$ins_engagement_number, by=list(month=data_sheet5$month), FUN=sum)
	post_count = aggregate(data_sheet5$count_post, by=list(month=data_sheet5$month), FUN=sum)

	eg_rate = (like$x + comment$x + share$x)/as.numeric(dataFanMetric$fan_page_val)/post_count$x
	ins_eg_rate = (ins_egm$x)/reach$x
	eg_rate[which(is.na(eg_rate))] <- 0
	ins_eg_rate[which(!is.finite(ins_eg_rate))] <- 0

	result = list()
	result[['unlike']] = unlike$x
	result[['eg_rate']] = eg_rate
	result[['ins_eg_rate']] = ins_eg_rate

	return (result)
}

parseDataForSheet10P = function(dataframe, data_post){
	data_sheet10 = dataframe
	data_tmp_sheet10 = data_post
	data_tmp_sheet10 = cbind(data_tmp_sheet10, date_hour = '')
	data_tmp_sheet10$date_hour = data_tmp_sheet10$date_create_time

	if(data_tmp_sheet10$date_create_time[1] != ''){

		Sys.setlocale("LC_TIME", "Japan")
		time_format = gsub('T', ' ', data_tmp_sheet10$date_hour)
		time_format = strftime(time_format, "%Y/%m/%d %H:%M:%S")
		time_format = as.POSIXct(time_format,format="%Y/%m/%d %H:%M:%S", tz="UTC")
		time_format_jp = as.POSIXct(time_format, tz = 'UTC', usetz = T)
		time_format_jp = as.POSIXct(format(time_format_jp, tz = 'Japan', usetz = T), tz = 'Japan', usetz = T)

		# data_tmp_sheet10$date_create_time = strftime(substr(time_format_jp, 1, 10), "%Y/%m/%d")
		data_index = which(data_sheet10$date_full %in% data_tmp_sheet10$datefull)
		date = data_sheet10$date_full[data_index]
		eg_rate = data_sheet10$engagement_rate[data_index]
		eg_rate[!is.finite(eg_rate)] = 0
		reach = data_sheet10$total_reach[data_index]
		ins_eg = data_sheet10$ins_engagement_number[data_index]

		df_tmp = data.frame('date_full' = date, 'eg_rate' = eg_rate, 'reach' = reach, 'ins_eg' = ins_eg)
		datetime = strftime(data_tmp_sheet10$date_create_time, "%Y/%m/%d")
		dimensionColumns = data.frame(date_full = datetime)
		df_tmp = merge(dimensionColumns, df_tmp, all.x = TRUE)
		df_tmp[is.na(df_tmp)] = 0
		df_tmp[duplicated(df_tmp$date_full),] = 0
		# df_tmp = df_tmp[!duplicated(df_tmp$date_full),]

		data_tmp_sheet10 = cbind(data_tmp_sheet10, weekday = '', eg_rate_weekday = '', reach_weekday = '', ins_eg_weekday = '')
		data_tmp_sheet10$weekday = weekdays(as.Date(strftime(data_tmp_sheet10$date_create_time, "%d-%m-%Y"),'%d-%m-%Y'))
		data_tmp_sheet10$eg_rate_weekday = df_tmp$eg_rate
		data_tmp_sheet10$reach_weekday = df_tmp$reach
		data_tmp_sheet10$ins_eg_weekday = df_tmp$ins_eg

		data_tmp_sheet10 = cbind(data_tmp_sheet10, hours = '',  eg_rate_hours = '', reach_hours = '', ins_eg_hours = '')
		data_tmp_sheet10$hours = format(time_format_jp,"%H")
		data_tmp_sheet10$eg_rate_hours = df_tmp$eg_rate
		data_tmp_sheet10$reach_hours = df_tmp$reach
		data_tmp_sheet10$ins_eg_hours = df_tmp$ins_eg
		
		# parse data to day of week
		data_eg_weekday = aggregate(data_tmp_sheet10$eg_rate_weekday, by=list(weekday=data_tmp_sheet10$weekday), FUN=mean)
		data_reach_weekday = aggregate(data_tmp_sheet10$reach_weekday, by=list(weekday=data_tmp_sheet10$weekday), FUN=mean)
		data_ins_eg_weekday = aggregate(data_tmp_sheet10$ins_eg_weekday, by=list(weekday=data_tmp_sheet10$weekday), FUN=mean)

		data_date_weekday = data_eg_weekday$weekday
		data_average_eg_rate = (data_eg_weekday$x)*100
		data_average_reach = data_reach_weekday$x
		data_average_ins_eg = data_ins_eg_weekday$x

		weekday_tmp = data.frame('weekday' = data_date_weekday, 'avg_eg_rate' = data_average_eg_rate,
			'avg_reach' = data_average_reach, 'avg_ins_eg' = data_average_ins_eg)

		weekday = c('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday')
		dimensionColumns <- data.frame(weekday = weekday)
		weekday_result = merge(dimensionColumns, weekday_tmp, all.x = TRUE)
		weekday_result[is.na(weekday_result)] <- 0
		weekday_result$weekday <- factor(weekday_result$weekday, levels= c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))
		weekday_result = weekday_result[order(weekday_result$weekday), ]
		# weekday_result = weekday_result[ order(c('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday')), ]

		# parse data to hourly
		data_eg_hours = aggregate(data_tmp_sheet10$eg_rate_hours, by=list(hours=data_tmp_sheet10$hours), FUN=mean)
		data_reach_hours = aggregate(data_tmp_sheet10$reach_hours, by=list(hours=data_tmp_sheet10$hours), FUN=mean)
		data_ins_eg_hours = aggregate(data_tmp_sheet10$ins_eg_hours, by=list(hours=data_tmp_sheet10$hours), FUN=mean)

		data_date_hours = data_eg_hours$hours
		data_average_eg_rate = (data_eg_hours$x)*100
		data_average_reach = data_reach_hours$x
		data_average_ins_eg = data_ins_eg_hours$x

		hourly_tmp = data.frame('hours' = data_date_hours, 'avg_eg_rate' = data_average_eg_rate,
			'avg_reach' = data_average_reach, 'avg_ins_eg' = data_average_ins_eg)

		hourly = c(rep(0:23))
		dimensionColumns <- data.frame(hours = hourly)
		hourly_result = merge(dimensionColumns, hourly_tmp, all.x = TRUE)
		hourly_result[is.na(hourly_result)] <- 0
		hourly_result = hourly_result[order(c(rep(0:23))), ]
	}else{
		weekday_result = data.frame('weekday' = c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"), 
			'avg_eg_rate' = 0, 'avg_reach' = 0, 'avg_ins_eg' = 0)
		
		hourly_result = data.frame('hours' = c(rep(0:23)), 'avg_eg_rate' = 0,'avg_reach' = 0, 'avg_ins_eg' = 0)
	}

	result = list()
	result[['weekday']] = weekday_result$weekday
	result[['avg_eg_rate']] = weekday_result$avg_eg_rate
	result[['avg_reach']] = weekday_result$avg_reach
	result[['avg_ins_eg']] = weekday_result$avg_ins_eg

	result[['hourly']] = hourly_result$hours
	result[['hour_avg_eg_rate']] = hourly_result$avg_eg_rate
	result[['hour_avg_reach']] = hourly_result$avg_reach
	result[['hour_avg_ins_eg']] = hourly_result$avg_ins_eg

	return (result)
}

parseDataForSheet13P = function(dataframe){
	data_sheet13 = dataframe

	# data like, comment, share
	data_sheet13 = cbind(data_sheet13, month = '')
	data_sheet13$month = strftime(data_sheet13$date_full, "%m")

	unlike = aggregate(data_sheet13$data_fans_remove, by=list(date=data_sheet13$month), FUN=sum)

	post_count = aggregate(data_sheet13$count_post, by=list(date=data_sheet13$month), FUN=sum)
	reach = aggregate(data_sheet13$total_reach, by=list(date=data_sheet13$month), FUN=sum)
	like = aggregate(data_sheet13$total_like, by=list(date=data_sheet13$month), FUN=sum)
	comment = aggregate(data_sheet13$total_comment, by=list(date=data_sheet13$month), FUN=sum)
	share = aggregate(data_sheet13$total_share, by=list(date=data_sheet13$month), FUN=sum)
	eg_number = aggregate(data_sheet13$engagement_number, by=list(date=data_sheet13$month), FUN=sum)

	ins_egm = aggregate(data_sheet13$ins_engagement_number, by=list(date=data_sheet13$month), FUN=sum)
	
	average_reach = reach$x/post_count$x
	average_like = like$x/post_count$x

	eg_rate = (like$x + comment$x + share$x)/as.numeric(dataFanMetric$fan_page_val)/post_count$x
	ins_eg_rate = ((ins_egm$x)*100)/reach$x
	ins_eg_rate[which(!is.finite(ins_eg_rate))] <- 0

	result = list()

	result[['date']] = dataFanMetric$fan_page_month
	result[['fans_number']] = dataFanMetric$fan_page_val
	result[['post_count']] = post_count$x
	result[['reach']] = reach$x
	result[['average_reach']] = average_reach
	result[['like']] = like$x
	result[['average_like']] = average_like
	result[['comment']] = comment$x
	result[['share']] = share$x
	result[['eg_number']] = eg_number$x
	result[['eg_rate']] = eg_rate
	result[['ins_eg_number']] = ins_egm$x
	result[['ins_eg_rate']] = ins_eg_rate

	return (result)

}

parseDataForSheet14P = function(dataframe){
	data_sheet14 = dataframe
	if(data_sheet14$date_create_time[1] != ''){
		data_sheet14 = cbind(data_sheet14, date_hour = '')
		data_sheet14$date_hour = data_sheet14$date_create_time
		data_sheet14$date_create_time = strftime(substr(data_sheet14$date_create_time, 1, 10), "%Y/%m/%d")
		fans_page_index = which(dataFanMetric$fan_page_date %in% data_sheet14$date_create_time)
		fans_page_daily = dataFanMetric$fan_per_day_val[fans_page_index]

		Sys.setlocale("LC_TIME", "Japan")
		time_format = gsub('T', ' ', data_sheet14$date_hour)
		time_format = strftime(time_format, "%Y/%m/%d %H:%M:%S")
		time_format = as.POSIXct(time_format,format="%Y/%m/%d %H:%M:%S", tz="UTC")
		time_format_jp = as.POSIXct(time_format, tz = 'UTC', usetz = T)
		time_format_jp = as.POSIXct(format(time_format_jp, tz = 'Japan', usetz = T), tz = 'Japan', usetz = T)
		# print(time_format_jp)
		egmInsight = (data_sheet14$egmIns*100)/data_sheet14$total_reach
		egmInsight[which(!is.finite(egmInsight))] <- 0

		data_sheet14 = cbind(data_sheet14, eg_rate = 0, eg_rate_insights = 0, eg_num = 0, 
			number_row = 0, day = '', time = '', date_time = '')
		data_sheet14$eg_rate = (data_sheet14$total_like + data_sheet14$total_comment + data_sheet14$total_share)/fans_page_daily
		data_sheet14$eg_rate_insights = egmInsight
		data_sheet14$eg_num = (data_sheet14$total_like + data_sheet14$total_comment + data_sheet14$total_share)
		data_sheet14$day = weekdays(as.Date(strftime(data_sheet14$date_hour, "%d-%m-%Y"),'%d-%m-%Y'))
		data_sheet14$time = format(time_format_jp,"%H")
		data_sheet14$date_time = format(time_format_jp, "%Y/%m/%d %H:%M")
		data_sheet14 = data_sheet14 %>% arrange(desc(data_sheet14$eg_rate_insights))
		data_sheet14$number_row = c(1:length(data_sheet14$date_create_time))
		# print(data_sheet14)
	}else{
		data_sheet14 = cbind(data_sheet14, eg_rate = 0, eg_rate_insights = 0, eg_num = 0, 
			number_row = 0, day = '', time = '', date_time = '')
	}

	result = list()
	result[['number_row']] = data_sheet14$number_row
	result[['date_time']] = data_sheet14$date_time
	result[['message']] = data_sheet14$message
	result[['images']] = data_sheet14$image
	result[['reach']] = data_sheet14$total_reach
	result[['like']] = data_sheet14$total_like
	result[['comment']] = data_sheet14$total_comment
	result[['share']] = data_sheet14$total_share
	result[['count_of_string']] = data_sheet14$count_of_string
	result[['eg_rate']] = data_sheet14$eg_rate
	result[['eg_insights']] = data_sheet14$egmIns
	result[['eg_rate_insights']] = data_sheet14$eg_rate_insights
	result[['link_clicked']] = data_sheet14$countClick
	result[['engagement_number']] = data_sheet14$egmIns
	result[['day']] = data_sheet14$day
	result[['time']] = data_sheet14$time
	result[['type']] = data_sheet14$type

	return (result)
}

parseDataInvolePostByDaily = function(dataResult){
	data_posts = ldply (dataResult$posts, data.frame)
	data_fan_add = ldply(dataResult$fanAdd, data.frame)
	data_fan_remove = ldply(dataResult$fanRemove, data.frame)
	# df <- ldply (data_fan_add, data.frame)
	
	# get data invole post
	post_id = data_posts$id
	post_type = data_posts$type
	post_message = data_posts$message
	post_created_time = data_posts$created_time	

	# get data invole fans add
	fans_add = data_fan_add$value
	# fans_add = rapply(fans_add, c)
	fans_date = data_fan_add$end_time

	#get data invole fans remove
	fans_remove = data_fan_remove$value
	# fans_remove = data_fan_remove$end_time

	# parse data post to data frame

	if(length(post_id) > 0){
		data_tmp_post = data.frame('date_create_time' = post_created_time, 
			'datetime' = post_created_time, 'date' = '', 'datefull' = '', 
			'id' = post_id, 'type' = post_type,
			'message' = post_message, 'count' = 1, count_of_string = 0)
		data_tmp_post = data_tmp_post[order(data_tmp_post$date_create_time), ]
		data_tmp_post$date = strftime(data_tmp_post$date_create_time, "%m/%d")
		data_tmp_post$datefull = strftime(data_tmp_post$date_create_time, "%Y/%m/%d")
		data_tmp_post$datetime = strftime(gsub('T', ' ', data_tmp_post$datetime), "%Y/%m/%d %H %M")

		# get data likes, comment, share, reach, image, count click, ...
		data_tmp_lcsricl = getLikeCommentsShareReachImageOfPost(accessToken, data_tmp_post$id)

		data_tmp_post = cbind(data_tmp_post, total_like = 0, total_comment = 0, total_share = 0,
			total_reach = 0, image = '', egmIns = 0, countClick = 0)
		data_tmp_post$total_like = data_tmp_lcsricl$likes
		data_tmp_post$total_comment = data_tmp_lcsricl$comments
		data_tmp_post$total_share = rapply(data_tmp_lcsricl$shares, c)
		data_tmp_post$total_reach = data_tmp_lcsricl$reachs
		data_tmp_post$image = data_tmp_lcsricl$images
		data_tmp_post$egmIns = data_tmp_lcsricl$egmInss
		data_tmp_post$countClick = data_tmp_lcsricl$countClicks
		data_tmp_post$count_of_string = str_length(data_tmp_post$message)

		count_post_daily = aggregate(data_tmp_post$count, by=list(date=data_tmp_post$datefull), FUN=sum)
		# # count_post_daily = count_post_daily %>% arrange(desc(data_tmp_post$date))
	}else{
		data_tmp_post = data.frame('date_create_time' = '', 'datetime' = '', 'date' = '', 
		'id' = '', 'type' = '', 'message' = '', 'count' = 0, 'datefull' = '',
		total_like = 0, total_comment = 0, total_share = 0,total_reach = 0, image = '', 
		egmIns = 0, countClick = 0, count_of_string = 0)

		count_post_daily = aggregate(data_tmp_post$count, by=list(date=data_tmp_post$datefull), FUN=sum)
		# # count_post_daily = count_post_daily %>% arrange(desc(data_tmp_post$date))
	}
	# # create data frame for daily: posts, fans add, fans remove, reach, like, comment, share, ...
	
	date_month_day = strftime(fans_date, "%Y/%m/%d")
	dimensionColumns = data.frame(date = date_month_day)
	count_post_daily = merge(dimensionColumns, count_post_daily, all.x = TRUE)
	count_post_daily[is.na(count_post_daily)] <- 0
	
	# time_post =  strftime(data_tmp_post$date_create_time, "%Y/%m/%d")
	# time_post = time_post[!duplicated(time_post)]

	count_reach_daily = aggregate(data_tmp_post$total_reach, by=list(date=data_tmp_post$datefull), FUN=sum)
	count_like_daily = aggregate(data_tmp_post$total_like, by=list(date=data_tmp_post$datefull), FUN=sum)
	count_comment_daily = aggregate(data_tmp_post$total_comment, by=list(date=data_tmp_post$datefull), FUN=sum)
	count_share_daily = aggregate(data_tmp_post$total_share, by=list(date=data_tmp_post$datefull), FUN=sum)
	
	df_tmp = data.frame('date' = count_reach_daily$date,
						 'reach' = count_reach_daily$x, 'like' = count_like_daily$x, 
						 'comment' = count_comment_daily$x, 'share' = count_share_daily$x)
	
	dimensionColumns = data.frame(date = count_post_daily$date)
	df_tmp = merge(dimensionColumns, df_tmp, all.x = TRUE)
	df_tmp = cbind(df_tmp, count_post = 0)
	df_tmp$count_post = count_post_daily$x
	df_tmp[is.na(df_tmp)] = 0
	
	data_tmp = data.frame('create_time' = df_tmp$date,
		'count_post' = df_tmp$count_post,
		'total_reach' = df_tmp$reach, 'average_reach' = 0,
		'total_like' = df_tmp$like, 'average_like' = 0,
		'total_comment' = df_tmp$comment, 
		'total_share' = df_tmp$share, date_full = '')
	
	data_tmp$average_reach = data_tmp$total_reach/data_tmp$count_post
	data_tmp$average_like = data_tmp$total_like/data_tmp$count_post
	data_tmp$date_full = strftime(data_tmp$create_time, "%Y/%m/%d")
	data_tmp[is.na(data_tmp)] <- 0
	
	date_month_day = strftime(fans_date, "%Y/%m/%d")
	dimensionColumns = data.frame(date_full = date_month_day)
	data_tmp = merge(dimensionColumns, data_tmp, all.x = TRUE)
	data_tmp[is.na(data_tmp)] <- 0
	# data_tmp$date_post = strftime(data_tmp$date_full, "%Y/%m/%d")

	insightEngmRate = (dataFanMetric$insight_engagement*100)/data_tmp$total_reach
	insightEngmRate[which(!is.finite(insightEngmRate))] <- 0

	data_tmp = cbind(data_tmp, fans_number = 0, engagement_number = 0, engagement_rate = 0, 
		ins_engagement_number = 0, ins_engagement_rate = 0)

	date_full_fan = strftime(dataFanMetric$fan_page_date, "%Y/%m/%d")
	dimensionColumns = data.frame(date_full = date_full_fan)
	data_tmp = merge(dimensionColumns, data_tmp, all.x = TRUE)
	data_tmp[is.na(data_tmp)] <- 0

	data_tmp$fans_number = dataFanMetric$fan_per_day_val
	data_tmp$engagement_number = data_tmp$total_like + data_tmp$total_comment + data_tmp$total_share
	data_tmp$engagement_rate = (data_tmp$total_like + data_tmp$total_comment + data_tmp$total_share)/(data_tmp$count_post)/data_tmp$fans_number
	data_tmp$ins_engagement_number = dataFanMetric$insight_engagement
	data_tmp$ins_engagement_rate = insightEngmRate
	data_tmp[is.na(data_tmp)] <- 0

	data_tmp_fan = data.frame('data_fan' = fans_date, data_fans_add = 0, data_fans_remove = 0, 
						date_year_month = '', date_full = '')
	data_tmp_fan$date_full = strftime(fans_date, "%Y/%m/%d")
	data_tmp_fan$data_fans_add = fans_add
	data_tmp_fan$data_fans_remove = fans_remove
	data_tmp_fan$date_year_month = strftime(fans_date, "%Y/%m")
	dimensionColumns = data.frame(date_full = date_full_fan)
	data_tmp_fan = merge(dimensionColumns, data_tmp_fan, all.x = TRUE)
	data_tmp_fan[is.na(data_tmp_fan)] <- 0

	data_tmp = cbind(data_tmp, data_fans_add = 0, data_fans_remove = 0, 
						date_year_month = '', date_post = '')
	# data_tmp$date_full = data_tmp_fan$data_fan
	data_tmp$data_fans_add = data_tmp_fan$data_fans_add
	data_tmp$data_fans_remove = data_tmp_fan$data_fans_remove
	data_tmp$date_year_month = data_tmp_fan$date_year_month
	data_tmp$date_post = strftime(dataFanMetric$fan_page_date, "%m/%d")
	
	sheet5P = parseDataForSheet5P(data_tmp)
	sheet10P = parseDataForSheet10P(data_tmp, data_tmp_post)
	sheet13P = parseDataForSheet13P(data_tmp)
	sheet14P = parseDataForSheet14P(data_tmp_post)
	
	
	##########################################################################################

	result = list()
	# data for sheet 5P
	result[['title_sheet5P']] = c(' ', 'Number of fans', 'Compared with the previous month %', 
		'Fan net increase', 'Number of fans(Via AD)', 'Number of fans(Other than AD)', 'Unlike', 
		'Engagement rate', 'Insight Engagement Rate', ' ', 'ファン数', '対前月比％', 'ファン純増数', 
		'ファン数(AD経由)', 'ファン数(AD以外)', 'いいね取り消し', 'エンゲージメント率', 'インサイトエンゲージメント率')
	result[['unlike_sheet5P']] = sheet5P$unlike
	result[['eg_rate_sheet5P']] = sheet5P$eg_rate
	result[['ins_eg_rate_sheet5P']] = sheet5P$ins_eg_rate

	# data for sheet 6P
	result[['title_6P']] = c(' ', 'Like', 'Unlike', 'Post', 'date', '新規いいね！', 'いいね取り消し', '投稿数')
	result[['month_day_6P']] = data_tmp$date_post
	result[['like_6P']] = data_tmp$data_fans_add
	result[['unlike_6P']] = data_tmp$data_fans_remove
	result[['count_post_6P']] = data_tmp$count_post

	# data for sheet 10P
	result[['title_10P']] = c('平均/エンゲージメント率', '平均/リーチ数', '平均/インサイトエンゲージメント率', 
		'時間', '平均/エンゲージメント率', '平均/リーチ数', '平均/インサイトエンゲージメント率')
	
	result[['eg_rate_day_of_week']] = sheet10P$avg_eg_rate
	result[['reach_day_of_week']] = sheet10P$avg_reach
	result[['ins_egm_rate_day_of_week']] = sheet10P$avg_ins_eg
	result[['eg_rate_day_of_hour']] = sheet10P$hour_avg_eg_rate
	result[['reach_day_of_hour']] = sheet10P$hour_avg_reach
	result[['ins_egm_rate_of_hour']] = sheet10P$hour_avg_ins_eg
	
	# data for sheet 12P
	result[['title_12P']] = c('ファン数', '投稿回数', '合計リーチ', '平均リーチ', '合計Like', '平均Like', '合計comment', '合計share', 'エンゲージメント数', 'エンゲージメント率', 'インサイトエンゲージメント', 'インサイトエンゲージメント率')
	result[['date_full_12P']] = data_tmp$date_full
	result[['fans_number_12P']] = data_tmp$fans_number
	result[['post_count_12P']] = data_tmp$count_post
	result[['total_reach_12P']] = data_tmp$total_reach
	result[['average_reach_12P']] = data_tmp$average_reach
	result[['total_like_12P']] = data_tmp$total_like
	result[['average_like_12P']] = data_tmp$average_like
	result[['total_comment_12P']] = data_tmp$total_comment
	result[['total_share_12P']] = data_tmp$total_share
	result[['engagement_number_12P']] = data_tmp$engagement_number
	result[['engagement_rate_12P']] = data_tmp$engagement_rate
	result[['ins_engagement_number_12P']] = data_tmp$ins_engagement_number
	result[['ins_engagement_rate_12P']] = data_tmp$ins_engagement_rate

	# data for sheet 13P
	result[['title_13P']] = c('ファン数', '投稿回数', '合計リーチ', '平均リーチ', '合計Like', '平均Like', 
		'合計comment', '合計share', 'エンゲージメント数', 'エンゲージメント率', 'インサイトエンゲージメント', 
		'インサイトエンゲージメント率')

	result[['date_13P']] = sheet13P$date
	result[['fan_per_month_13P']] = sheet13P$fans_number
	result[['post_count_13P']] = sheet13P$post_count
	result[['reach_count_13P']] = sheet13P$reach
	result[['average_reach_13P']] = sheet13P$average_reach
	result[['likes_count_13P']] = sheet13P$like
	result[['average_like_13P']] = sheet13P$average_like
	result[['comments_count_13P']] = sheet13P$comment
	result[['shares_count_13P']] = sheet13P$share
	result[['engagement_num_13P']] = sheet13P$eg_number
	result[['engagement_rate_13P']] = sheet13P$eg_rate
	result[['ins_engagement_13P']] = sheet13P$ins_eg_number
	result[['ins_engagement_rate_13P']] = sheet13P$ins_eg_rate
	
	# data for sheet 14P
	result[['title_14P']] = c('', '', '', 'Image', 'Reach', 'LIKE', 'Comment', 
		'Share Each Post Ins', 'Count String Of ContentIns', 'message_hiragana_ratio', 
		'message_katakana_ratio','message_kanji_ratio', 'Rate Each Post Ins', 
		'Insights In Post Time Ins', 'Rate Insighs In Post TimeIns', 'Link Clicke dIns', '', 
		'message_hiragana_count', 'message_katakana_count', 'message_kanji_count', '', '', '', '',
		'No.', '日付', '内容', 'イメージ', 'リーチ数', 'LIKE数', 'コメント数', 'シェア数', '文字数', 
		'ひらがな比率', 'カタカナ比率', '漢字比率', 'エンゲージメント率', 'インサイト エンゲージメント数', 
		'インサイト エンゲージメント率', 'リンクのクリック数', '前回数値', 'ひらがな数', 'カタカナ数', '漢字数', 
		'エンゲージメント数', 'DAY', 'TIME', 'type')

	result[['number_row_14P']] = sheet14P$number_row
	result[['date_time_14P']] = sheet14P$date_time
	result[['message_14P']] = sheet14P$message
	result[['images_14P']] = sheet14P$images
	result[['reach_14P']] = sheet14P$reach
	result[['like_14P']] = sheet14P$like
	result[['comment_14P']] = sheet14P$comment
	result[['share_14P']] = sheet14P$share
	result[['count_of_string_14P']] = sheet14P$count_of_string
	result[['eg_rate_14P']] = sheet14P$eg_rate
	result[['eg_insights_14P']] = sheet14P$eg_insights
	result[['eg_rate_insights_14P']] = sheet14P$eg_rate_insights
	result[['link_clicked_14P']] = sheet14P$link_clicked
	result[['col_back_14P']] = c(rep(" ", length(sheet14P$number_row)))
	result[['engagement_number_14P']] = sheet14P$engagement_number
	result[['day_14P']] = sheet14P$day
	result[['time_14P']] = sheet14P$time
	result[['type_14P']] = sheet14P$type

	return (result)
}