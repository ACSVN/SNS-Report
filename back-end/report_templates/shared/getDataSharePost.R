getDataSharePost =function(token, listID){

	requestUrlSharePost = sprintf(
		"https://graph.facebook.com/%s?ids=%s&fields=shares",
		"v2.10",
		listID
	)

	sharePost = callAPI(url = requestUrlSharePost, token = token)
	title_id = names(sharePost)
	shares = list()

	for(i in 1:length(sharePost)){
		if(length(sharePost[[title_id[i]]]$shares$count) > 0){
			shares = c(shares, sharePost[[title_id[i]]]$shares$count)
		}else{
			shares = c(shares, 0)
		}		
	}
	return (shares)
}