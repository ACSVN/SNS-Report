#define worksheet
outputSheet6P = outputPath

Sheet6P = loadWorkbook(filename =outputSheet6P, create = TRUE)

sheetName = "6P"

title_6p = dataPostDaily$title_6P
date_6p = dataPostDaily$month_day_6P
like = as.numeric(dataPostDaily$like_6P)
unlike = as.numeric(dataPostDaily$unlike_6P)
count_post = as.numeric(dataPostDaily$count_post_6P)

dataTitle	<- matrix(title_6p, ncol=4, byrow=TRUE)
writeWorksheet(object = Sheet6P, data = dataTitle, sheet = sheetName, startRow = 1, startCol = 1, header = FALSE)
saveWorkbook(Sheet6P)

dataFacebook = data.frame(
	'date' = date_6p,
	'like' = like,
	'unlike' = unlike,
	'post' = count_post
)

bodyRowHeight = 20;
setRowHeight(
	object = Sheet6P,
	sheet = sheetName,
	row = seq_len(nrow(dataFacebook)+2),
	height = bodyRowHeight
)
bodyColumnWidth = 4000;
setColumnWidth(
	object = Sheet6P,
	sheet = sheetName,
	column = seq_len(ncol(dataFacebook)) + 1,
	width = bodyColumnWidth
)

writeWorksheet(object = Sheet6P, data = dataFacebook, sheet = sheetName, startRow = 3, startCol = 1, header = FALSE)
saveWorkbook(Sheet6P)

#set border
border <- createCellStyle(Sheet6P)
setWrapText(border, wrap = TRUE)
setBorder(border, side = c("bottom","top", "left", "right"), type = XLC$"BORDER.THIN", color = XLC$"COLOR.BLACK")
for(i in 2:(nrow(dataFacebook)+2)){
	setCellStyle(Sheet6P, sheet = sheetName, row = i, col = 1:ncol(dataFacebook), cellstyle = border)
}

# ワークブックをファイルに保存
saveWorkbook(Sheet6P)

rm(dataTitle, dataFacebook, border)
gc()
rm(Sheet6P)
gc()
xlcFreeMemory()