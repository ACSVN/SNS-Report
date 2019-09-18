getDataCountClickPost = function(token, listID){

	requestUrlCountClickPost = sprintf(
		"https://graph.facebook.com/%s?ids=%s&fields=insights.metric(post_consumptions_by_type)",
		"v2.10",
		listID
	)

	countClickPost = callAPI(url = requestUrlCountClickPost, token = token)
	title_id = names(countClickPost)
	countClicks = c()
	for(i in 1:length(countClickPost)){
		if(length(countClickPost[[title_id[i]]]$insights$data[[1]]$values[[1]]$value[['link clicks']]) > 0){
			countClicks = c(countClicks, countClickPost[[title_id[i]]]$insights$data[[1]]$values[[1]]$value[['link clicks']])
		}else{
			countClicks = c(countClicks, 0)
		}
		
	}
	return (countClicks)

	# return (countClickPost)
}