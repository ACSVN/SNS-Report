#define worksheet
outputSheetReachAge = outputPath

SheetReachAge = loadWorkbook(filename =outputSheetReachAge, create = TRUE)

sheetName = "Reach by age"

reach_title 		= dataDayMetric$reach_title
reach_date 		= dataDayMetric$reach_date
reach_title_des 	= dataDayMetric$reach_title_des
reach_nrow		= dataDayMetric$reach_nrow
reach_ncol 		= dataDayMetric$reach_ncol
reach_by_age 	= list()
if(length(dataDayMetric$reach_by_age) > 0){
	reach_by_age	= as.numeric(dataDayMetric$reach_by_age)
}

# reach_by_age 	= as.numeric(unlist(strsplit(dataDayMetric$reach_by_age, split=",")))

addtitle(SheetReachAge,sheetName, reach_title_des, 2, 1)

dataTitle	<- matrix(reach_title, nrow=1)
writeWorksheet(object = SheetReachAge, data = dataTitle, sheet = sheetName, startRow = 1, startCol = 1, header = FALSE)
saveWorkbook(SheetReachAge)

date_title 	<- matrix(reach_date, ncol=1, byrow=TRUE)
writeWorksheet(object = SheetReachAge, data = date_title, sheet = sheetName, startRow = 2, startCol = 2, header = FALSE)
saveWorkbook(SheetReachAge)

if(length(reach_by_age) > 0){
	dataFacebook <- matrix(reach_by_age, nrow = length(reach_date))
	bodyRowHeight = 20;
	setRowHeight(
		object = SheetReachAge,
		sheet = sheetName,
		row = seq_len(nrow(dataFacebook)+1),
		height = bodyRowHeight
	)

	bodyColumnWidth = 4000;
	setColumnWidth(
		object = SheetReachAge,
		sheet = sheetName,
		column = 2,
		width = bodyColumnWidth
	)
	writeWorksheet(object = SheetReachAge, data = dataFacebook, sheet = sheetName, startRow = 2, startCol = 3, header = FALSE)
	saveWorkbook(SheetReachAge)
}

rm(dataTitle, dataFacebook)
gc()
rm(SheetReachAge)
gc()
xlcFreeMemory()