getDataLikePost = function(token, listID){

	requestUrlLikePost = sprintf(
		"https://graph.facebook.com/%s?ids=%s&fields=reactions.summary(true)",
		"v2.10",
		listID
	)

	likePost = callAPI(url = requestUrlLikePost, token = token)
	title_id = names(likePost)
	likes = c()
	
	for(i in 1:length(title_id)){
		likes = c(likes, likePost[[title_id[i]]]$reactions$summary$total_count)
	}

	return (likes)
}