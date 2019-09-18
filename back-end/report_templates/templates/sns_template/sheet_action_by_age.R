#define worksheet
outputSheetActionAge = outputPath

SheetActionAge = loadWorkbook(filename =outputSheetActionAge, create = TRUE)

sheetName = "Action by age"
# createSheet(object = SheetActionAge, name = sheetName)

action_title 	= dataDayMetric$action_title
action_date 	= dataDayMetric$action_date
action_title_des = dataDayMetric$action_title_des
action_nrow		= dataDayMetric$action_nrow
action_ncol 	= dataDayMetric$action_ncol
action_by_age 	= list()
if(length(dataDayMetric$action_by_age) > 0){
	action_by_age	= as.numeric(dataDayMetric$action_by_age)
}

# action_by_age 	= as.numeric(unlist(strsplit(dataDayMetric$action_by_age, split=",")))

addtitle(SheetActionAge,sheetName, action_title_des, 2, 1)

dataTitle	<- matrix(action_title, nrow=1)
writeWorksheet(object = SheetActionAge, data = dataTitle, sheet = sheetName, startRow = 1, startCol = 1, header = FALSE)
saveWorkbook(SheetActionAge)

date_title 	<- matrix(action_date, ncol=1, byrow=TRUE)
writeWorksheet(object = SheetActionAge, data = date_title, sheet = sheetName, startRow = 2, startCol = 2, header = FALSE)
saveWorkbook(SheetActionAge)

if(length(action_by_age) > 0){
	dataFacebook <- matrix(action_by_age, nrow = length(action_date))
	bodyRowHeight = 20;
	setRowHeight(
		object = SheetActionAge,
		sheet = sheetName,
		row = seq_len(nrow(dataFacebook)+1),
		height = bodyRowHeight
	)

	bodyColumnWidth = 4000;
	setColumnWidth(
		object = SheetActionAge,
		sheet = sheetName,
		column = 2,
		width = bodyColumnWidth
	)
	writeWorksheet(object = SheetActionAge, data = dataFacebook, sheet = sheetName, startRow = 2, startCol = 3, header = FALSE)
	saveWorkbook(SheetActionAge)
}

rm(dataTitle, dataFacebook)
gc()
rm(SheetActionAge)
gc()
xlcFreeMemory()