getDataCommentPost = function(token, listID){

	requestUrlCommentPost = sprintf(
		"https://graph.facebook.com/%s?ids=%s&fields=comments.summary(true)",
		"v2.10",
		listID
	)

	commentPost = callAPI(url = requestUrlCommentPost, token = token)
	title_id = names(commentPost)
	comments = c()
	for(i in 1:length(commentPost)){
		if(length(commentPost[[title_id[i]]]$comments$summary$total_count) > 0){
			comments = c(comments, commentPost[[title_id[i]]]$comments$summary$total_count)
		}else{
			comments = c(comments, 0)
		}
		
	}
	return (comments)
}