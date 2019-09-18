parseDataInvolePostByMonthly = function(dataResult){

	data_posts = dataResult$posts
	data_fan_add = dataResult$fanAdd
	data_fan_remove = dataResult$fanRemove

	post_id = lapply(data_posts, '[[', 3)
	post_message = lapply(data_posts, '[[', 2)
	post_created_time = lapply(data_posts, '[[', 1)

	fans_add = lapply(data_fan_add, '[[', 1)
	
	data_tmp = data.frame('id' = rapply(post_id, c), 'created_time' = rapply(post_created_time, c), 'message' = rapply(post_message, c))
	data = cbind(data, dateFomat = '', dayMonth = '', monthYear = '', dateFull = '')
	print(post_id)
}