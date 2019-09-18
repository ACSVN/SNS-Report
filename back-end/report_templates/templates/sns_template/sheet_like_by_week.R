#define worksheet
outputSheetWeek = outputPath

SheetWeek = loadWorkbook(filename =outputSheetWeek, create = TRUE)

sheetName = "Likes by week"

week_tilte = dataWeekTimeMetric$week_tilte
week_row = dataWeekTimeMetric$week_row
week_date = dataWeekTimeMetric$week_date
like_by_week = list()
if(length(dataWeekTimeMetric$like_by_week) > 0){
	like_by_week = as.numeric(dataWeekTimeMetric$like_by_week)
}

dataTitle	<- matrix(week_tilte, nrow=2)
writeWorksheet(object = SheetWeek, data = dataTitle, sheet = sheetName, startRow = 1, startCol = 1, header = FALSE)
saveWorkbook(SheetWeek)

date_title 	<- matrix(week_date, ncol=1, byrow=TRUE)
writeWorksheet(object = SheetWeek, data = date_title, sheet = sheetName, startRow = 3, startCol = 1, header = FALSE)
saveWorkbook(SheetWeek)

if(length(like_by_week) > 0){
	dataFacebook = matrix(like_by_week, nrow=week_row)

	bodyRowHeight = 20;
	setRowHeight(
		object = SheetWeek,
		sheet = sheetName,
		row = seq_len(nrow(dataFacebook)+2),
		height = bodyRowHeight
	)
	bodyColumnWidth = 4000;
	setColumnWidth(
		object = SheetWeek,
		sheet = sheetName,
		column = seq_len(ncol(dataFacebook)),
		width = bodyColumnWidth
	)

	writeWorksheet(object = SheetWeek, data = dataFacebook, sheet = sheetName, startRow = 3, startCol = 2, header = FALSE)
	saveWorkbook(SheetWeek)

	wrap_cell <- createCellStyle(SheetWeek)
	setWrapText(wrap_cell, wrap = TRUE)
	setCellStyle(SheetWeek, sheet = sheetName, row = 1, col = 1:(ncol(dataFacebook)+2), cellstyle = wrap_cell)
	setCellStyle(SheetWeek, sheet = sheetName, row = 2, col = 1:(ncol(dataFacebook)+2), cellstyle = wrap_cell)
	saveWorkbook(SheetWeek)
}



rm(dataTitle, dataFacebook)
gc()
rm(SheetWeek)
gc()
xlcFreeMemory()