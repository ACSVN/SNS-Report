#define worksheet
outputSheet14P = outputPath

Sheet14P = loadWorkbook(filename =outputSheet14P, create = TRUE)

sheetName = "S14P"

title_14p = dataPostDaily$title_14P
title_ncol_14p = length(title_14p)/2
number_14p = dataPostDaily$number_row_14P
time_each_post_14p = dataPostDaily$date_time_14P
content_each_post_14p = dataPostDaily$message_14P
img_each_post_14p = dataPostDaily$images_14P
reach_each_post_14p = dataPostDaily$reach_14P
like_each_post_14p = dataPostDaily$like_14P
comment_each_post_14p = dataPostDaily$comment_14P
share_each_post_14p = dataPostDaily$share_14P
count_string_of_content_14p = dataPostDaily$count_of_string_14P
eg_rate_each_post_14p = dataPostDaily$eg_rate_14P
eg_insights_in_post_time_14p = dataPostDaily$eg_insights_14P
eg_rate_insights_in_post_time_14p = dataPostDaily$eg_rate_insights_14P
link_clicked_14p = dataPostDaily$link_clicked_14P
col_back_14p = dataPostDaily$col_back_14P
engagement_number = dataPostDaily$engagement_number_14P
day_14p = dataPostDaily$day_14P
hour_14p = as.numeric(dataPostDaily$time_14P)
type_14p = dataPostDaily$type_14P

dataTitle <- matrix(title_14p, ncol=title_ncol_14p, byrow=TRUE)
writeWorksheet(object = Sheet14P, data = dataTitle, sheet = sheetName, startRow = 1, startCol = 1, header = FALSE)
saveWorkbook(Sheet14P)

message_hiragana_count 	<- countHiragana(content_each_post_14p)
message_katakana_count 	<- countKatakana(content_each_post_14p)
message_kanji_count 	<- countKanji(content_each_post_14p)

content_length			<- count_string_of_content_14p
 
message_hiragana_ratio	<- message_hiragana_count/content_length
message_katakana_ratio	<- message_katakana_count/content_length
message_kanji_ratio		<- message_kanji_count/content_length

list_fill_color 		<- list()
list_fill_color[[1]] 	<- reach_each_post_14p
list_fill_color[[2]] 	<- like_each_post_14p
list_fill_color[[3]] 	<- comment_each_post_14p
list_fill_color[[4]] 	<- share_each_post_14p
list_fill_color[[5]] 	<- count_string_of_content_14p
list_fill_color[[6]] 	<- eg_insights_in_post_time_14p
list_fill_color[[7]] 	<- link_clicked_14p

list_fill_color_per 		<- list()
list_fill_color_per[[1]]	<- message_hiragana_ratio
list_fill_color_per[[2]] 	<- message_katakana_ratio
list_fill_color_per[[3]]	<- message_kanji_ratio
list_fill_color_per[[4]] 	<- eg_rate_each_post_14p
list_fill_color_per[[5]] 	<- eg_rate_insights_in_post_time_14p

list_col <- c(5,6,7,8,9,14,16)
list_col_per <- c(10,11,12,13,15)

dataFacebook = data.frame(
	'col0' = number_14p,
	'col1' = time_each_post_14p,
	'col2' = content_each_post_14p,
	'col3' = col_back_14p,
	'col4' = reach_each_post_14p,
	'col5' = like_each_post_14p,
	'col6' = comment_each_post_14p,
	'col7' = share_each_post_14p,
	'col8' = count_string_of_content_14p,
	'col9' = message_hiragana_ratio,
	'col10' = message_katakana_ratio,
	'col11' = message_kanji_ratio,
	'col12' = eg_rate_each_post_14p,
	'col13' = eg_insights_in_post_time_14p,
	'col14' = eg_rate_insights_in_post_time_14p,
	'col15' = link_clicked_14p,
	'col16' = col_back_14p,
	'col17' = message_hiragana_count,
	'col18' = message_katakana_count,
	'col19' = message_kanji_count,
	'col20' = engagement_number,
	'col21' = day_14p,
	'col22' = hour_14p,
	'col23' = type_14p
)

bodyRowHeight = 40;
setRowHeight(
	object = Sheet14P,
	sheet = sheetName,
	row = seq_len(nrow(dataFacebook))+2,
	height = bodyRowHeight
)

setColumnWidth(object = Sheet14P, sheet = sheetName, column = 1, width = 950)
setColumnWidth(object = Sheet14P, sheet = sheetName, column = 2, width = 4500)
setColumnWidth(object = Sheet14P, sheet = sheetName, column = 3, width = 12500)
setColumnWidth(object = Sheet14P, sheet = sheetName, column = 4, width = 1800)

writeWorksheet(object = Sheet14P, data = dataFacebook, sheet = sheetName, startRow = 3, startCol = 1, header = FALSE)
saveWorkbook(Sheet14P)

wrap_cell <- createCellStyle(Sheet14P)
setWrapText(wrap_cell, wrap = TRUE)
setCellStyle(Sheet14P, sheet = sheetName, row = 1, col = 1:(ncol(dataTitle)), cellstyle = wrap_cell)
setCellStyle(Sheet14P, sheet = sheetName, row = 2, col = 1:(ncol(dataTitle)), cellstyle = wrap_cell)
saveWorkbook(Sheet14P)

color <- createCellStyle(Sheet14P)
setWrapText(color, wrap = TRUE)
setFillForegroundColor(color, color = XLC$"COLOR.GREY_25_PERCENT")
setFillPattern(color, fill = XLC$FILL.SOLID_FOREGROUND)
setBorder(color, side = c("bottom","top", "left", "right"), type = XLC$"BORDER.THIN", color = XLC$"COLOR.BLACK")
# setCellStyle(Sheet14P, sheet = sheetName, row = 2, col = 1:(ncol(dataFacebook)), cellstyle = color)

back_color <- createCellStyle(Sheet14P)
setWrapText(back_color, wrap = TRUE)
setBorder(back_color, side = c("bottom","top", "left", "right"), type = XLC$"BORDER.THIN", color = XLC$"COLOR.BLACK")
setFillBackgroundColor(back_color, color = XLC$"COLOR.CORAL")
setFillForegroundColor(back_color, color = XLC$"COLOR.GREY_25_PERCENT")
setFillPattern(back_color, fill = XLC$FILL.SQUARES)

#set border
border <- createCellStyle(Sheet14P)
setWrapText(border, wrap = TRUE)
# setDataFormat(border, format = "###,###")
setBorder(border, side = c("bottom","top", "left", "right"), type = XLC$"BORDER.THIN", color = XLC$"COLOR.BLACK")
for(i in 3:(nrow(dataFacebook) + 2)){
	setCellStyle(Sheet14P, sheet = sheetName, row = i, col = 1:2, cellstyle = color)
	setCellStyle(Sheet14P, sheet = sheetName, row = i, col = 4:9, cellstyle = border)
	setCellStyle(Sheet14P, sheet = sheetName, row = i, col = 14, cellstyle = border)
	setCellStyle(Sheet14P, sheet = sheetName, row = i, col = 17, cellstyle = color)
	setCellStyle(Sheet14P, sheet = sheetName, row = i, col = 16:21, cellstyle = border)
	setCellStyle(Sheet14P, sheet = sheetName, row = i, col = 23, cellstyle = border)
}


border_per <- createCellStyle(Sheet14P)
setWrapText(border_per, wrap = TRUE)
# setDataFormat(border_per, format = "0.00%")
setBorder(border_per, side = c("bottom","top", "left", "right"), type = XLC$"BORDER.THIN", color = XLC$"COLOR.BLACK")
for(i in 3:(nrow(dataFacebook) + 2)){
	setCellStyle(Sheet14P, sheet = sheetName, row = i, col = 10:13, cellstyle = border_per)
	setCellStyle(Sheet14P, sheet = sheetName, row = i, col = 15, cellstyle = border_per)
}


saveWorkbook(Sheet14P)

#######################################################################################################

#add Image
imageColumnNumber = 4

imageColumnLetter = LETTERS[imageColumnNumber]

for(i in 1:length(img_each_post_14p)){
	if(i < 200){
		if(img_each_post_14p[i] == 'null' || img_each_post_14p[i] == ''){
			next;
		}

		imageRowNumber = i+2;

		imageCellFormula = sprintf("%s!$%s$%d", sheetName, imageColumnLetter, imageRowNumber)

		imageFilePath = tempfile(fileext = ".png")
		download.file(
			url = img_each_post_14p[i],
			destfile = imageFilePath
		)

		cellName = basename(imageFilePath)
		createName(
			object = Sheet14P,
			name = cellName,
			formula = imageCellFormula,
			overwrite = TRUE
		) 

		addImage(
			object = Sheet14P,
			filename = imageFilePath,
			name = cellName,
			originalSize = FALSE
		)
	}
}

bodyRowHeight = 50;
setRowHeight(
	object = Sheet14P,
	sheet = sheetName,
	row = seq_len(nrow(dataFacebook))+2,
	height = bodyRowHeight
)

setRowHeight(
	object = Sheet14P,
	sheet = sheetName,
	row = 2,
	height = 35
)

setColumnWidth(object = Sheet14P, sheet = sheetName, column = 1, width = 950)
setColumnWidth(object = Sheet14P, sheet = sheetName, column = 2, width = 4200)
setColumnWidth(object = Sheet14P, sheet = sheetName, column = 3, width = 12600)
setColumnWidth(object = Sheet14P, sheet = sheetName, column = 4, width = 2100)

bodyColumnWidth = 4200;
setColumnWidth(
	object = Sheet14P,
	sheet = sheetName,
	column = seq_len(ncol(dataFacebook))+4,
	width = bodyColumnWidth
)

renameSheet(object = Sheet14P, sheet = "S14P", newName = "14P")
saveWorkbook(Sheet14P)

rm(list_fill_color, dataFacebook, wrap_cell, color, back_color, border)
gc()
rm(Sheet14P)
gc()
xlcFreeMemory()