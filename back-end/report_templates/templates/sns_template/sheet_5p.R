#define worksheet
outputSheet5P = outputPath

Sheet5P = loadWorkbook(filename =outputSheet5P, create = TRUE)

sheetName = "5P"

title_5p = dataPostDaily$title_sheet5P
date = dataFanMetric$fan_page_month
numberOfFan = dataFanMetric$fan_page_val
previousDay = dataFanMetric$fan_page_pre_month
fanIncrease = dataFanMetric$fan_page_increase
fanAds = dataFanMetric$fan_ads
fanNonAds = dataFanMetric$fan_non_ads
unlike = dataPostDaily$unlike_sheet5P
engagementRate = dataPostDaily$eg_rate_sheet5P
insightEngagementRate = dataPostDaily$ins_eg_rate_sheet5P


dataTitle	<- matrix(title_5p, ncol=9, byrow=TRUE)
writeWorksheet(object = Sheet5P, data = dataTitle, sheet = sheetName, startRow = 1, startCol = 2, header = FALSE)
saveWorkbook(Sheet5P)
removeSheet(Sheet5P,"Sheet1")

dataFacebook = data.frame(
	'col1' = date,
	'col2' = numberOfFan,
	'col3' = previousDay,
	'col4' = fanIncrease,
	'col5' = fanAds,
	'col6' = fanNonAds,
	'col7' = unlike,
	'col8' = engagementRate,
	'col9' = insightEngagementRate
)

bodyRowHeight = 60;
setRowHeight(
	object = Sheet5P,
	sheet = sheetName,
	row = 1:2,
	height = bodyRowHeight
)
bodyColumnWidth = 4000;
setColumnWidth(
	object = Sheet5P,
	sheet = sheetName,
	column = seq_len(ncol(dataFacebook)) + 1,
	width = bodyColumnWidth
)

writeWorksheet(object = Sheet5P, data = dataFacebook, sheet = sheetName, startRow = 3, startCol = 2, header = FALSE)
saveWorkbook(Sheet5P)

color <- createCellStyle(Sheet5P)
setWrapText(color, wrap = TRUE)
setFillForegroundColor(color, color = XLC$"COLOR.GREY_25_PERCENT")
setFillPattern(color, fill = XLC$FILL.SOLID_FOREGROUND)
setBorder(color, side = c("bottom","top", "left", "right"), type = XLC$"BORDER.THIN", color = XLC$"COLOR.BLACK")
setCellStyle(Sheet5P, sheet = sheetName, row = 2, col = 2:(ncol(dataFacebook)+1), cellstyle = color)

#set border
border <- createCellStyle(Sheet5P)
setWrapText(border, wrap = TRUE)
setBorder(border, side = c("bottom","top", "left", "right"), type = XLC$"BORDER.THIN", color = XLC$"COLOR.BLACK")

for(i in 3:(nrow(dataFacebook)+2)){
	setCellStyle(Sheet5P, sheet = sheetName, row = i, col = 2:(ncol(dataFacebook)+1), cellstyle = border)
	setCellStyle(Sheet5P, sheet = sheetName, row = i, col = 2, cellstyle = color)
}

saveWorkbook(Sheet5P)

rm(dataTitle, dataFacebook, color, border)

rm(Sheet5P)
xlcFreeMemory()