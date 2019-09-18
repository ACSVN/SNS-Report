#define worksheet
outputSheet10P = outputPath

Sheet10P = loadWorkbook(filename =outputSheet10P, create = TRUE)

sheetName = "10P"
createSheet(object = Sheet10P, name = sheetName)

###########################################################################################################
# Day of week
# 

bodyRowHeight = 60;
setRowHeight(
	object = Sheet10P,
	sheet = sheetName,
	row = 2,
	height = bodyRowHeight
)

title_10p = dataPostDaily$title_10P
eg_rate_day_of_week = dataPostDaily$eg_rate_day_of_week
reach_day_of_week = dataPostDaily$reach_day_of_week
ins_egm_rate_day_of_week = dataPostDaily$ins_egm_rate_day_of_week

vector_day <- c('', '', 'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday')

nrow_matrix <- length(vector_day)
date_title 	<- matrix(vector_day, nrow=nrow_matrix)
writeWorksheet(object = Sheet10P, data = date_title, sheet = sheetName, startRow = 2, startCol = 1, header = FALSE)
saveWorkbook(Sheet10P)

title 	<- c('By day of week: Average engagement rate', title_10p[1], 'By day of week: Average reach number', title_10p[2], 'By day of week: Insight Engagement Rate', title_10p[3])
title 	<- matrix(title, nrow=2)
writeWorksheet(object = Sheet10P, data = title, sheet = sheetName, startRow = 2, startCol = 2, header = FALSE)
saveWorkbook(Sheet10P)

dataFacebook 	<- c(eg_rate_day_of_week, reach_day_of_week, ins_egm_rate_day_of_week)
dataFacebook 	<- matrix(dataFacebook, nrow=7)
bodyColumnWidth = 4000;
setColumnWidth(
    object = Sheet10P,
    sheet = sheetName,
    column = 1:4,
    width = bodyColumnWidth
)
writeWorksheet(object = Sheet10P, data = dataFacebook, sheet = sheetName, startRow = 4, startCol = 2, header = FALSE)
saveWorkbook(Sheet10P)

color <- createCellStyle(Sheet10P)
setWrapText(color, wrap = TRUE)
setCellStyle(Sheet10P, sheet = sheetName, row = 2, col = 2:4, cellstyle = color)
#set border
border <- createCellStyle(Sheet10P)
setWrapText(border, wrap = TRUE)
setBorder(border, side = c("bottom","top", "left", "right"), type = XLC$"BORDER.THIN", color = XLC$"COLOR.BLACK")
for(i in 2:nrow_matrix+1){
	setCellStyle(Sheet10P, sheet = sheetName, row = i, col = 1:4, cellstyle = border)
}

# ワークブックをファイルに保存
saveWorkbook(Sheet10P)

nrowcurrent = nrow_matrix+5

###########################################################################################################
# Day of hour
# 

vector_hour <- c('', title_10p[4],0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)

eg_rate_day_of_hour = dataPostDaily$eg_rate_day_of_hour
reach_day_of_hour = dataPostDaily$reach_day_of_hour
ins_egm_rate_of_hour = dataPostDaily$ins_egm_rate_of_hour

nrow_matrix <- length(vector_hour)
hour_title 	<- matrix(vector_hour, nrow=nrow_matrix)
writeWorksheet(object = Sheet10P, data = hour_title, sheet = sheetName, startRow = 14, startCol = 1, header = FALSE)
saveWorkbook(Sheet10P)
title 	<- c('By hour: Average engagement rate', title_10p[5], 'By hour: Average reach number', title_10p[6], 'By hour: Insight Engagement Rate', title_10p[7])
title 	<- matrix(title, nrow=2)
writeWorksheet(object = Sheet10P, data = title, sheet = sheetName, startRow = 14, startCol = 2, header = FALSE)
saveWorkbook(Sheet10P)
setCellStyle(Sheet10P, sheet = sheetName, row = 14, col = 2:4, cellstyle = color)
dataOfHour 	<- c(eg_rate_day_of_hour, reach_day_of_hour, ins_egm_rate_of_hour)
dataOfHour 	<- matrix(dataOfHour, nrow=24)
writeWorksheet(object = Sheet10P, data = dataOfHour, sheet = sheetName, startRow = 16, startCol = 2, header = FALSE)
saveWorkbook(Sheet10P)

nrowcurrent = nrowcurrent+1
for(i in nrowcurrent:(length(vector_hour)+nrowcurrent-2)){
	setCellStyle(Sheet10P, sheet = sheetName, row = i, col = 1:4, cellstyle = border)
}
saveWorkbook(Sheet10P)

rm(vector_day, nrow_matrix, dataFacebook)
gc()
rm(vector_hour, eg_rate_day_of_hour, dataOfHour)
gc()
rm(Sheet10P)
gc()
xlcFreeMemory()