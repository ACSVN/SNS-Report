#define worksheet
outputSheet7P8P = outputPath

Sheet7P8P = loadWorkbook(filename =outputSheet7P8P, create = TRUE)

sheetName = "7P-8P"
# createSheet(object = Sheet7P8P, name = sheetName)

wrap_cell <- createCellStyle(Sheet7P8P)
setWrapText(wrap_cell, wrap = TRUE)

#set border
border <- createCellStyle(Sheet7P8P)
setWrapText(border, wrap = TRUE)
setBorder(border, side = c("bottom","top", "left", "right"), type = XLC$"BORDER.THIN", color = XLC$"COLOR.BLACK")

###############################################################################################################

# Data like by age

fans_share <- c('fans', 'share')
fans_share <- matrix(fans_share, ncol=2, byrow=TRUE)

like_by_age_fans = rapply(dataDayMetric$like_fans, c)
like_by_age_sum = dataDayMetric$like_sum_gender_all
like_by_age_shares = as.numeric(like_by_age_fans/like_by_age_sum)
like_by_age_gender_name = rapply(dataDayMetric$like_name_gender, c)
like_by_age_gender = rapply(dataDayMetric$like_gender, c)
like_by_age_age = rapply(dataDayMetric$like_age, c)
like_sum_male = dataDayMetric$like_sum_male_gender
like_sum_female = dataDayMetric$like_sum_female_gender
like_sum_unkown = dataDayMetric$like_sum_unkown_gender


dataLike <- c(like_by_age_fans, like_by_age_shares)
dataLike <- matrix(dataLike, nrow=length(like_by_age_fans))

like_title = data.frame(
	'name_gender' 	= c('', like_by_age_gender_name),
	'gender' 		= c('gender', like_by_age_gender),
	'age' 			= c('age', like_by_age_age)
)

liketotal <- c(like_sum_male, like_sum_female, like_sum_unkown)
likepercent <- as.numeric(liketotal/like_by_age_sum)

like_title_total <- matrix(c('gender', 'M', 'F', 'U'), ncol=1, byrow=TRUE)
dataLikeTotal	 <- matrix(c(liketotal, likepercent), nrow=length(liketotal))

bodyRowHeight = 20;
setRowHeight(
	object = Sheet7P8P,
	sheet = sheetName,
	row = seq_len(nrow(like_title)),
	height = bodyRowHeight
)
# bodyColumnWidth = 4000;
# setColumnWidth(
# 	object = Sheet7P8P,
# 	sheet = sheetName,
# 	column = seq_len(ncol(dataLike)),
# 	width = bodyColumnWidth
# )

# Like by age
title <- 'Likes by age'
addtitle(Sheet7P8P,sheetName, title, 1, 1)
setCellStyle(Sheet7P8P, sheet = sheetName, row = 1, col =1, cellstyle = wrap_cell)

writeWorksheet(object = Sheet7P8P, data = like_title, sheet = sheetName, startRow = 2, startCol = 1, header = FALSE)
writeWorksheet(object = Sheet7P8P, data = fans_share, sheet = sheetName, startRow = 2, startCol = ncol(like_title)+1, header = FALSE)
writeWorksheet(object = Sheet7P8P, data = dataLike, sheet = sheetName, startRow = 3, startCol = ncol(like_title)+1, header = FALSE)
saveWorkbook(Sheet7P8P)

nrowcurrent = nrow(like_title)+3
writeWorksheet(object = Sheet7P8P, data = like_title_total, sheet = sheetName, startRow = nrowcurrent, startCol = 3, header = FALSE)
writeWorksheet(object = Sheet7P8P, data = fans_share, sheet = sheetName, startRow = nrowcurrent, startCol = 4, header = FALSE)
writeWorksheet(object = Sheet7P8P, data = dataLikeTotal, sheet = sheetName, startRow = nrowcurrent+1, startCol = 4, header = FALSE)
saveWorkbook(Sheet7P8P)

for(i in 2:(nrow(like_title)+1)){
	setCellStyle(Sheet7P8P, sheet = sheetName, row = i, col = 2:(ncol(like_title)+2), cellstyle = border)
}

for(i in nrowcurrent:(nrowcurrent+nrow(dataLikeTotal))){
	setCellStyle(Sheet7P8P, sheet = sheetName, row = i, col = 3:(ncol(dataLikeTotal)+3), cellstyle = border)
}

saveWorkbook(Sheet7P8P)

nrowcurrent = nrowcurrent + nrow(dataLikeTotal)

###############################################################################################################

# Data reach by age

reach_by_age_fans = rapply(dataDayMetric$reach_fans, c)
reach_by_age_sum = dataDayMetric$reach_sum_gender_all
reach_by_age_shares = as.numeric(reach_by_age_fans/reach_by_age_sum)
reach_by_age_gender_name = rapply(dataDayMetric$reach_name_gender, c)
reach_by_age_gender = rapply(dataDayMetric$reach_gender, c)
reach_by_age_age = rapply(dataDayMetric$reach_age, c)
reach_sum_male = dataDayMetric$reach_sum_male_gender
reach_sum_female = dataDayMetric$reach_sum_female_gender
reach_sum_unkown = dataDayMetric$reach_sum_unkown_gender

reach_title <- data.frame(
	'name_gender' 	= c('', reach_by_age_gender_name),
	'gender' 		= c('gender', reach_by_age_gender),
	'age' 			= c('age', reach_by_age_age)
)

dataReach <- c(reach_by_age_fans, reach_by_age_shares)
dataReach <- matrix(dataReach, nrow=length(reach_by_age_fans))

reachtotal 		<- c(reach_sum_male, reach_sum_female, reach_sum_unkown)
reachpercent 	<- as.numeric(reachtotal/reach_by_age_sum)
dataReachTotal	 <- matrix(c(reachtotal, reachpercent), nrow=length(reachtotal))

bodyRowHeight = 20;
setRowHeight(
	object = Sheet7P8P,
	sheet = sheetName,
	row = seq_len(nrow(reach_title)),
	height = bodyRowHeight
)

nrowcurrent = nrowcurrent + 3

# Reach by age
title <- 'Reach by age'
addtitle(Sheet7P8P,sheetName, title, nrowcurrent, 1)
setCellStyle(Sheet7P8P, sheet = sheetName, row = nrowcurrent, col =1, cellstyle = wrap_cell)

nrowcurrent = nrowcurrent + 1

writeWorksheet(object = Sheet7P8P, data = reach_title, sheet = sheetName, startRow = nrowcurrent, startCol = 1, header = FALSE)
writeWorksheet(object = Sheet7P8P, data = fans_share, sheet = sheetName, startRow = nrowcurrent, startCol = ncol(reach_title)+1, header = FALSE)
writeWorksheet(object = Sheet7P8P, data = dataReach, sheet = sheetName, startRow = nrowcurrent+1, startCol = ncol(reach_title)+1, header = FALSE)

for(i in nrowcurrent:(nrow(reach_title)+nrowcurrent-1)){
	setCellStyle(Sheet7P8P, sheet = sheetName, row = i, col = 2:(ncol(reach_title)+2), cellstyle = border)
}

saveWorkbook(Sheet7P8P)

nrowcurrent = nrowcurrent + nrow(reach_title)+3
writeWorksheet(object = Sheet7P8P, data = like_title_total, sheet = sheetName, startRow = nrowcurrent, startCol = 3, header = FALSE)
writeWorksheet(object = Sheet7P8P, data = fans_share, sheet = sheetName, startRow = nrowcurrent, startCol = 4, header = FALSE)
writeWorksheet(object = Sheet7P8P, data = dataReachTotal, sheet = sheetName, startRow = nrowcurrent+1, startCol = 4, header = FALSE)
saveWorkbook(Sheet7P8P)

for(i in nrowcurrent:(nrowcurrent+nrow(dataLikeTotal))){
	setCellStyle(Sheet7P8P, sheet = sheetName, row = i, col = 3:(ncol(dataReachTotal)+3), cellstyle = border)
}

nrowcurrent = nrowcurrent + nrow(dataReachTotal)+3

###############################################################################################################

# Data action by age

action_by_age_fans = rapply(dataDayMetric$action_fans, c)
action_by_age_sum = dataDayMetric$action_sum_gender_all
action_by_age_shares = as.numeric(action_by_age_fans/action_by_age_sum)
action_by_age_gender_name = rapply(dataDayMetric$action_name_gender, c)
action_by_age_gender = rapply(dataDayMetric$action_gender, c)
action_by_age_age = rapply(dataDayMetric$action_age, c)
action_sum_male = dataDayMetric$action_sum_male_gender
action_sum_female = dataDayMetric$action_sum_female_gender
action_sum_unkown = dataDayMetric$action_sum_unkown_gender

action_title <- data.frame(
	'name_gender' 	= c('', action_by_age_gender_name),
	'gender' 		= c('gender', action_by_age_gender),
	'age' 			= c('age', action_by_age_age)
)

dataAction <- c(action_by_age_fans, action_by_age_shares)
dataAction <- matrix(dataAction, nrow=length(action_by_age_fans))

actiontotal 		<- c(action_sum_male, action_sum_female, action_sum_unkown)
reachpercent 		<- as.numeric(actiontotal/action_by_age_sum)
dataActionTotal	 	<- matrix(c(actiontotal, reachpercent), nrow=length(actiontotal))

bodyRowHeight = 20;
setRowHeight(
	object = Sheet7P8P,
	sheet = sheetName,
	row = seq_len(nrow(action_title)),
	height = bodyRowHeight
)


# action by age
title <- 'Action by age'
addtitle(Sheet7P8P,sheetName, title, nrowcurrent, 1)
setCellStyle(Sheet7P8P, sheet = sheetName, row = nrowcurrent, col =1, cellstyle = wrap_cell)

nrowcurrent = nrowcurrent + 1
writeWorksheet(object = Sheet7P8P, data = action_title, sheet = sheetName, startRow = nrowcurrent, startCol = 1, header = FALSE)
writeWorksheet(object = Sheet7P8P, data = fans_share, sheet = sheetName, startRow = nrowcurrent, startCol = ncol(action_title)+1, header = FALSE)
writeWorksheet(object = Sheet7P8P, data = dataAction, sheet = sheetName, startRow = nrowcurrent+1, startCol = ncol(action_title)+1, header = FALSE)

for(i in nrowcurrent:(nrow(dataAction)+nrowcurrent)){
	setCellStyle(Sheet7P8P, sheet = sheetName, row = i, col = 2:2:(ncol(action_title)+2), cellstyle = border)
}

saveWorkbook(Sheet7P8P)

nrowcurrent = nrowcurrent + nrow(dataAction)+3
writeWorksheet(object = Sheet7P8P, data = like_title_total, sheet = sheetName, startRow = nrowcurrent, startCol = 3, header = FALSE)
writeWorksheet(object = Sheet7P8P, data = fans_share, sheet = sheetName, startRow = nrowcurrent, startCol = 4, header = FALSE)
writeWorksheet(object = Sheet7P8P, data = dataActionTotal, sheet = sheetName, startRow = nrowcurrent+1, startCol = 4, header = FALSE)
saveWorkbook(Sheet7P8P)

for(i in nrowcurrent:(nrowcurrent+nrow(dataActionTotal))){
	setCellStyle(Sheet7P8P, sheet = sheetName, row = i, col = 3:(ncol(dataActionTotal)+3), cellstyle = border)
}
saveWorkbook(Sheet7P8P)
nrowcurrent = nrowcurrent + nrow(action_title)

rm(wrap_cell, border, dataLike, dataLikeTotal, dataReach, dataReachTotal, dataAction, dataActionTotal)
gc()
rm(Sheet7P8P)
gc()
xlcFreeMemory()