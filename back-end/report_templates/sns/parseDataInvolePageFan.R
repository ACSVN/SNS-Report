
parseDataPageFan = function(result_by_type){
	result_by_type = result_by_type[!duplicated(result_by_type)]
	date = list()
	value = list()
	for(i in 1:length(result_by_type)){
		if(length(result_by_type[[i]]$value) == 0){
			result_by_type[[i]]$value = 0
		}
		date = c(date, result_by_type[[i]]$end_time)
		value = c(value, result_by_type[[i]]$value)
	}
	data = data.frame('date' = rapply(date, c), 'value' = rapply(value, c))
	data = cbind(data, dateFomat = '', dayMonth = '', monthYear = '', dateFull = '')
	data$dateFomat = strftime(substr(data$date, 1, 10), "%m/%d/%Y")
	data$dayMonth = strftime(substr(data$date, 1, 10), "%m/%d")
	data$monthYear = strftime(substr(data$date, 1, 10), "%Y.%m")
	data$dateFull = strftime(substr(data$date, 1, 10), "%Y/%m/%d")

	list_group = aggregate(data$value, by=list(group=data$monthYear), FUN=sum)
	group = list_group$group

	daily_date = c()
	daily_fans = c()
	daily_month = c()
	monthFullDate = c()
	monthValue = c()
	monthValuePreviuos = c()
	monthValueInscrease = c()

	for(i in 1:length(group)){
		data_tmp = data %>% group_by(monthYear) %>% slice(which(group[i] == monthYear)) %>% tail(1)
		monthFullDate = c(monthFullDate, data_tmp$dateFull)
		monthValue = c(monthValue, data_tmp$value)
	}
	month_first = monthFullDate[1]
	month = as.numeric(strftime(month_first, "%m"))

	start_date 	= params[3]$since_fdate
	month_start = as.numeric(strftime(start_date, "%m"))

	# get data previous month for page fans
	if(month == month_start){

		pageID 		= params[1]$pageID
		token 		= params[2]$accessToken
		
		start_date = dmy(strftime(monthFullDate[1], "%d/%m/%Y")) - days(30)
		end_date = paste(format(start_date, format="%Y-%m"),"-", days_in_month(start_date), sep="")
		prvious_month = getDataPageFan(pageID, token, start_date, end_date)

		value_previous = rapply(lapply(prvious_month, '[[', 1), c) %>% tail(1)

		monthFullDate = c(end_date, monthFullDate)
		monthValue = c(value_previous, monthValue)
	}

	for(i in 2:length(monthValue)){
		if(monthValue[i] == 0){
			monthValuePreviuos = c(monthValuePreviuos, 0)
			monthValueInscrease = c(monthValueInscrease, 0)
		}else{
			monthValuePreviuos = c(monthValuePreviuos, as.numeric(monthValue[i]*100/monthValue[i-1]))
			if(monthValue[i] > monthValue[i-1]){
				monthValueInscrease = c(monthValueInscrease, as.numeric(monthValue[i]-monthValue[i-1]))
			}else{
				monthValueInscrease = c(monthValueInscrease, 0)
			}
		}
	}
	monthFullDate = monthFullDate[-1]
	monthValue = monthValue[-1]
	
	daily_date = data$dateFull
	daily_date = daily_date[-1]
	daily_fans = data$value
	daily_fans = daily_fans[-1]
	daily_month = data$dayMonth
	daily_month = daily_month[-1]

	result = list()
	result[['daily_date']] = daily_date
	result[['daily_fans']] = daily_fans
	result[['daily_fans_full']] = data$value
	result[['daily_month']] = daily_month
	result[['monthly_date']] = monthFullDate
	result[['monthly_fans']] = monthValue
	result[['monthly_previous']] = monthValuePreviuos
	result[['monthly_inscrease']] = monthValueInscrease

	return (result)
}

parseDataPageFanLikeBySource = function(result_by_type){

	pageFanLikeBySource = result_by_type[!duplicated(result_by_type)]
	pageFanLikeBySource = pageFanLikeBySource[-1]
	date = list()
	value = list()
	for(i in 1:length(pageFanLikeBySource)){
		if(length(pageFanLikeBySource[[i]]$value) == 0){
			pageFanLikeBySource[[i]]$value = 0
		}
		tmp = pageFanLikeBySource[[i]]$value
		if(tmp != 0){
			for(j in 1:length(tmp)){
				date = c(date, pageFanLikeBySource[[i]]$end_time)
				value = c(value, tmp[j])
			}
		}
	}
	fan_ads = c()
	title = names(value)
	if(length(title) > 0){
		data = data.frame('date' = rapply(date, c), 'value' = rapply(value, c))
		data = cbind(data, monthYear = '', type = '')
		data$type = title
		data$monthYear = strftime(substr(data$date, 1, 10), "%Y.%m")
		list_group = aggregate(data$value, by=list(group=data$monthYear), FUN=sum)
		group = list_group$group

		for(i in 1:length(group)){
			data_group = data %>% group_by(monthYear) %>% slice(which(group[i] == monthYear))

			result = aggregate(data_group$value, by=list(type=data_group$type), FUN=sum)
			indexAds = which(result$type %in% 'ads')
			indexMobileAds = which(result$type %in% 'mobile_ads')
			ads_tmp = c()
			if(length(indexAds) > 0){
				ads_tmp = c(ads_tmp, result$x[indexAds])
			}else{
				ads_tmp = c(ads_tmp, 0)
			}
			if(length(indexMobileAds) > 0){
				ads_tmp = c(ads_tmp, result$x[indexMobileAds])
			}else{
				ads_tmp = c(ads_tmp, 0)
			}
			fan_ads = c(fan_ads, sum(ads_tmp))
		}
	}else{
		fan_ads = 0
	}

	result = list()
	result[['fan_ads']] = fan_ads
	
	return (result)
}

parseDataInsightEngagement = function(result_by_type){
	result_by_type = result_by_type[!duplicated(result_by_type)]

	result = lapply(result_by_type, '[[', 1)
	result = result[-1]
	result = rapply(result, c)

	return (result)
}

parseDataKeyMetric = function(result_by_type){
	name_metric = names(result_by_type)
	data_metric = c()
	for(i in 1:length(name_metric)){
		data_tmp = result_by_type[[name_metric[i]]]
		data_tmp = data_tmp[-1]
		data_tmp = data_tmp[!duplicated(data_tmp)]
		data_tmp = lapply(data_tmp, '[[', 1)
		data_metric = c(data_metric, data_tmp)
	}
	
	title_metric = c('通算: これまでにページを「いいね！」した人の総数。(ユニークユーザー数)', 
		'1日: ページに新しくいいね！した人の数(ユニークユーザー数)', 
		'1日: Facebookページの「いいね！」を取り消した数(ユニークユーザー数)', 
		'1日: Facebookページに何らかのアクションを実行したユーザーの数。アクションにはクリックや記事の作成が含まれます。(ユニークユーザー数)', 
		'1日: ページに関連するコンテンツを見たことのある人の数。(ユニークユーザー数)', 
		'1日: このページを訪れた人、またはニュースフィードまたはリアルタイムフィードでページまたはその投稿を見た人の数。これには、このページに「いいね！」と言った人と言っていない人が含まれます。(ユニークユーザー数)', 
		'1日: このページにリンクするスポンサー記事または広告を見た人の数。(ユニークユーザー数)', 
		'1日: Facebookページに関連するコンテンツのインプレッション数。(合計数)', 
		'1日: ニュースフィードやリアルタイムフィードに、またはFacebookページへの訪問で投稿が表示された回数。このインプレッション数には、Facebookページについて「いいね！」と言った人と言わなかった人の数が含まれます。(合計数)', 
		'1日: Facebookページにリンクするスポンサー記事または広告のインプレッション数。(合計数)', 
		'1日: ページ投稿を見た人の数。(ユニークユーザー数)', 
		'1日: ニュースフィードやリアルタイムフィードまたはページのタイムラインであなたのページ投稿を見た人の数。(ユニークユーザー数)', 
		'1日: 広告またはスポンサー記事でページ投稿を見た人の数。(ユニークユーザー数)', '1日: 全ての投稿からきたインプレッション数(合計数)', 
		'1日: ニュースフィード、ティッカーまたはFacebookページの投稿のインプレッション数。(合計数)', 
		'1日: 広告またはスポンサー記事でのページ投稿のインプレッション数。(合計数)', 
		'1日: あなたのFacebookページを報告している人の数。(ユニークユーザー数)', 
		'1日: あなたのFacebookページが否定的な評価を受けた回数。(合計数)', 
		'1日: Facebookページに関して友達が公開した記事のインプレッション数。これらの記事は、あなたのFacebookページについての「いいね！」や、あなたのFacebookページのウォールへの投稿、あなたのFacebookページの投稿に対する「いいね！」、コメント、またはシェア、あなたが回答したクエスチョン、あなたのイベントへの招待に対する出欠、あなたのFacebookページについての言及、あなたのFacebookページの写真へのタグ付け、あなたのスポットへのチェックインなどについての投稿を含みます。(合計数)', 
		'1日: 友達がシェアした記事からページまたはその投稿を見た人の数。記事には、ページへの「いいね！」、ページのタイムラインへの投稿、投稿への「いいね！」、ページ投稿へのコメントまたはシェア、ページからの質問への回答、ページのイベントへの出欠の返答、ページの言及、ページの写真へのタグ付け、スポットへのチェックインが含まれます。(ユニークユーザー数)'
	)

	result = list()
	result[['title_metric']] = title_metric
	result[['data_metric']] = data_metric

	return (result)
}

parseDataInvolePageFan = function(dataResult){
	fan_non_ads = c()

	insightEngagement = parseDataInsightEngagement(dataResult$insightEngagement)
	
	pageFan = parseDataPageFan(dataResult$pageFan)
	pageFanLikeBySource = parseDataPageFanLikeBySource(dataResult$pageFanLikeBySource)
	pageMetric = parseDataKeyMetric(dataResult$keyMetric)
	
	fan_non_ads = pageFan$monthly_inscrease - pageFanLikeBySource$fan_ads
	fan_non_ads = replace(fan_non_ads, fan_non_ads < 0, 0)

	result = list()
	#data for monthly
	result[['fan_on_day']] = dataOnDayTime$fanOnDay
	result[['fan_on_time']] = dataOnDayTime$fanOnTime
	result[['fan_page_val']] = pageFan$monthly_fans
	result[['fan_page_month']] = pageFan$monthly_date
	result[['fan_page_month_full']] = pageFan$monthly_date
	result[['fan_page_pre_month']] = pageFan$monthly_previous
	result[['fan_page_increase']] = pageFan$monthly_inscrease
	result[['fan_ads']] = pageFanLikeBySource$fan_ads
	result[['fan_non_ads']] = fan_non_ads
	#data for daily
	result[['fan_page_date']] = pageFan$daily_date
	result[['fan_per_day_val']] = pageFan$daily_fans
	result[['fan_per_day_date']] = pageFan$daily_month
	#data for key metric
	result[['key_metric_date']] = pageFan$daily_date
	result[['key_metrics_title']] = pageMetric$title_metric
	result[['key_metrics_data']] = c(pageFan$daily_fans, pageMetric$data_metric)

	#data insight engagement
	result[['insight_engagement']] = insightEngagement
	
	return (result)
}