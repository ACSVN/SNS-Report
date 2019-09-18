
getLikeCommentsShareReachImageOfPost = function(token, listID){
	
	limit = 50
	list_child = split(listID, ceiling(seq_along(listID)/limit))

	likes = c()
	comments = c()
	shares = c()
	reachs = c()
	images = c()
	egmInss = c()
	countClicks = c()

	for(nloop in 1:length(list_child)){
		listid = list_child[[nloop]]
		listid = paste(listid, collapse = ",")

		likes = c(likes, getDataLikePost(token, listid))
		comments = c(comments, getDataCommentPost(token, listid))
		shares = c(shares, getDataSharePost(token, listid))
		reachs = c(reachs, getDataReachPost(token, listid))
		images = c(images, getDataImagePost(token, listid))
		egmInss = c(egmInss, getDataEgmInsightPost(token, listid))
		countClicks = c(countClicks, getDataCountClickPost(token, listid))
	}

	result = list()
	result[['likes']] = likes
	result[['comments']] = comments
	result[['shares']] = shares
	result[['reachs']] = reachs
	result[['images']] = images
	result[['egmInss']] = egmInss
	result[['countClicks']] = countClicks

	return (result)
}