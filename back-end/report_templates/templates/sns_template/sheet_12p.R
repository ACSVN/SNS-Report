#define worksheet
outputSheet12P = outputPath

Sheet12P = loadWorkbook(filename =outputSheet12P, create = TRUE)

sheetName = "12P"

title_12p = dataPostDaily$title_12P
date_12p = dataPostDaily$date_full_12P
fan_per_day_val_12p = as.numeric(dataPostDaily$fans_number_12P)
post_count_12p = as.numeric(dataPostDaily$post_count_12P)
reach_count_12p = as.numeric(dataPostDaily$total_reach_12P)
average_reach_12p = as.numeric(dataPostDaily$average_reach_12P)
likes_count_12p = as.numeric(dataPostDaily$total_like_12P)
average_like_12p = as.numeric(dataPostDaily$average_like_12P)
comments_count_12p = as.numeric(dataPostDaily$total_comment_12P)
shares_count_12p = as.numeric(dataPostDaily$total_share_12P)
engagement_num_12p = as.numeric(dataPostDaily$engagement_number_12P)
engagement_rate_12p = as.numeric(dataPostDaily$engagement_rate_12P)
ins_engagement_12p = as.numeric(dataPostDaily$ins_engagement_number_12P)
ins_engagement_rate_12p = as.numeric(dataPostDaily$ins_engagement_rate_12P)

title 	<- c('', '', 'Number of fans', title_12p[1], 'Post count', title_12p[2], 'Total reach', title_12p[3], 
			'Average reach', title_12p[4], 'Total Like', title_12p[5], 'Average Like', title_12p[6], 
			'Total comment', title_12p[7], 'Total share', title_12p[8], 'Engagement number', title_12p[9], 
			'Engagement rate', title_12p[10], 'Insight engagement', title_12p[11], 'Insight Engagement Rate', title_12p[12])

title 	<- matrix(title, nrow=2)

date 	<- matrix(date_12p, ncol=1, byrow=TRUE)

dataFacebook 	<- c(fan_per_day_val_12p, post_count_12p, reach_count_12p, average_reach_12p, likes_count_12p,
						average_like_12p, comments_count_12p, shares_count_12p, engagement_num_12p, engagement_rate_12p,
						ins_engagement_12p, ins_engagement_rate_12p)
dataFacebook 	<- matrix(dataFacebook, nrow=length(fan_per_day_val_12p))

bodyRowHeight = 20;
setRowHeight(
	object = Sheet12P,
	sheet = sheetName,
	row = seq_len(nrow(dataFacebook))+1,
	height = bodyRowHeight
)
bodyColumnWidth = 4000;
setColumnWidth(
	object = Sheet12P,
	sheet = sheetName,
	column = seq_len(ncol(dataFacebook)+1),
	width = bodyColumnWidth
)

setRowHeight(
	object = Sheet12P,
	sheet = sheetName,
	row = 3,
	height = 35
)
writeWorksheet(object = Sheet12P, data = title, sheet = sheetName, startRow = 2, startCol = 1, header = FALSE)
writeWorksheet(object = Sheet12P, data = date, sheet = sheetName, startRow = 4, startCol = 1, header = FALSE)
writeWorksheet(object = Sheet12P, data = dataFacebook, sheet = sheetName, startRow = 4, startCol = 2, header = FALSE)
saveWorkbook(Sheet12P)

color <- createCellStyle(Sheet12P)
setWrapText(color, wrap = TRUE)
setFillForegroundColor(color, color = XLC$"COLOR.GREY_25_PERCENT")
setFillPattern(color, fill = XLC$FILL.SOLID_FOREGROUND)
setBorder(color, side = c("bottom","top", "left", "right"), type = XLC$"BORDER.THIN", color = XLC$"COLOR.BLACK")
setCellStyle(Sheet12P, sheet = sheetName, row = 3, col = 1:(ncol(title)), cellstyle = color)

wrap_cell <- createCellStyle(Sheet12P)
setWrapText(wrap_cell, wrap = TRUE)
setCellStyle(Sheet12P, sheet = sheetName, row = 2, col = 1:(ncol(title)), cellstyle = wrap_cell)

#set border
border <- createCellStyle(Sheet12P)
setWrapText(border, wrap = TRUE)
setBorder(border, side = c("bottom","top", "left", "right"), type = XLC$"BORDER.THIN", color = XLC$"COLOR.BLACK")
for(i in 4:(nrow(dataFacebook) + 3)){
	setCellStyle(Sheet12P, sheet = sheetName, row = i, col = 2:(ncol(dataFacebook)+1), cellstyle = border)
	setCellStyle(Sheet12P, sheet = sheetName, row = i, col = 1, cellstyle = color)
}

# ワークブックをファイルに保存
saveWorkbook(Sheet12P)

rm(dataFacebook, color, wrap_cell, border)
gc()
rm(Sheet12P)
gc()
xlcFreeMemory()