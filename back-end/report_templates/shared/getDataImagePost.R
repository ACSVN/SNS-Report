getDataImagePost = function(token, listID){

	requestUrlImagePost = sprintf(
		"https://graph.facebook.com/%s?ids=%s&fields=picture",
		"v2.10",
		listID
	)

	imagePost = callAPI(url = requestUrlImagePost, token = token)
	title_id = names(imagePost)
	images = c()
	for(i in 1:length(imagePost)){
		if(length(imagePost[[title_id[i]]]$picture) > 0){
			images = c(images, imagePost[[title_id[i]]]$picture)
		}else{
			images = c(images, 'null')
		}
		
	}
	return (images)
}