#define worksheet
outputSheetTime = outputPath

SheetTime = loadWorkbook(filename =outputSheetTime, create = TRUE)

sheetName = "Likes by time"

time_tilte = dataWeekTimeMetric$time_tilte
tilte_by_time_des = dataWeekTimeMetric$tilte_by_time_des
time_nrow = dataWeekTimeMetric$time_row
time_date = dataWeekTimeMetric$time_date
like_by_time = list()
if(length(dataWeekTimeMetric$like_by_time) > 0){
	like_by_time = as.numeric(dataWeekTimeMetric$like_by_time)
}

addtitle(SheetTime,sheetName, tilte_by_time_des, 2, 1)

dataTitle	<- matrix(time_tilte, nrow=1)
writeWorksheet(object = SheetTime, data = dataTitle, sheet = sheetName, startRow = 1, startCol = 1, header = FALSE)
saveWorkbook(SheetTime)

date_title 	<- matrix(time_date, ncol=1, byrow=TRUE)
writeWorksheet(object = SheetTime, data = date_title, sheet = sheetName, startRow = 2, startCol = 2, header = FALSE)
saveWorkbook(SheetTime)

if(length(like_by_time) > 0){
	dataFacebook <- matrix(like_by_time, nrow=time_nrow)
	bodyRowHeight = 20;
	setRowHeight(
		object = SheetTime,
		sheet = sheetName,
		row = seq_len(nrow(dataFacebook)+1),
		height = bodyRowHeight
	)

	bodyColumnWidth = 4000;
	setColumnWidth(
		object = SheetTime,
		sheet = sheetName,
		column = seq_len(ncol(dataFacebook)),
		width = bodyColumnWidth
	)
	writeWorksheet(object = SheetTime, data = dataFacebook, sheet = sheetName, startRow = 2, startCol = 3, header = FALSE)
	saveWorkbook(SheetTime)

	wrap_cell <- createCellStyle(SheetTime)
	setWrapText(wrap_cell, wrap = TRUE)
	setCellStyle(SheetTime, sheet = sheetName, row = 1, col =1, cellstyle = wrap_cell)
	setCellStyle(SheetTime, sheet = sheetName, row = 2, col =1, cellstyle = wrap_cell)
	saveWorkbook(SheetTime)
}

rm(dataTitle, dataFacebook, wrap_cell)
gc()
rm(SheetTime)
gc()
xlcFreeMemory()