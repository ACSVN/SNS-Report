getDataPost = function(pageID, token, start_date, end_date){
	
	# start_date = dmy(strftime(start_date, "%d/%m/%Y")) - days(1)
	# since_start = dmy(strftime(start_date, "%d/%m/%Y")) + days(1)
	# since_start_midnight = strftime(since_start, "%Y-%m-%d %H:%M:%S")
	# until_midnight = strftime(end_date, "%Y-%m-%d 23:59:59")


	requestUrlPost = sprintf(
		"https://graph.facebook.com/%s/%s/posts?fields=created_time,message,type&since=%s&until=%s&limit=100",
		"v2.10",
		pageID,
		start_date,
		end_date
	)
	# print(requestUrlPost) 
	posts = callAPI(url = requestUrlPost, token = token)

	posts = posts$data
	if(length(posts) > 0){
		repeat{

			first_post_in_arr = tail(posts, n=1);
			time_loop = gsub('T', ' ', substr(first_post_in_arr[[1]]$created_time, 0, 19))
			
			date_start = strftime(start_date, "%Y/%m/%d %H:%M:%S")
			time_loop = strftime(time_loop, "%Y/%m/%d %H:%M:%S")

			time_start = as.numeric(as.POSIXct(date_start, format="%Y/%m/%d %H:%M:%S", tz="UTC"))
			time_final = as.numeric(as.POSIXct(time_loop, format="%Y/%m/%d %H:%M:%S", tz="UTC"))
			
			if(time_start >= time_final){
				posts = posts[!duplicated(posts)]
				break
			}else{
				requestUrlPostFinal = sprintf(
					"https://graph.facebook.com/%s/%s/posts?fields=created_time,message,type&since=%s&until=%s&limit=100",
					"v2.10",
					pageID,
					start_date,
					time_loop
				)
				# print(requestUrlPostFinal)
				posts_final = callAPI(url = requestUrlPostFinal, token = token)
				if(tail(posts_final$data, n=1) %in% posts){
					posts = c(posts, posts_final$data)
					posts = posts[!duplicated(posts)]
					break
				}
				if(length(posts_final)){
					posts = posts[!duplicated(posts)]
					break
				}
				posts = c(posts, posts_final$data)
			}
		}
	}
	posts = posts[!duplicated(posts)]
	return (posts)
}