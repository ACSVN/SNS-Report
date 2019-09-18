#define worksheet
outputSheetLikeAge = outputPath

SheetLikeAge = loadWorkbook(filename =outputSheetLikeAge, create = TRUE)

sheetName = "Likes by age"
# createSheet(object = SheetLikeAge, name = sheetName)

like_title 		= dataDayMetric$like_title
like_date 		= dataDayMetric$like_date
like_title_des 	= dataDayMetric$like_title_des
like_nrow		= dataDayMetric$like_nrow
like_ncol 		= dataDayMetric$like_ncol
like_by_age 	= list()
if(length(dataDayMetric$like_by_age) > 0){
	like_by_age	= as.numeric(dataDayMetric$like_by_age)
}

# like_by_age 	= as.numeric(unlist(strsplit(dataDayMetric$like_by_age, split=",")))

addtitle(SheetLikeAge,sheetName, like_title_des, 2, 1)

dataTitle	<- matrix(like_title, nrow=1)
writeWorksheet(object = SheetLikeAge, data = dataTitle, sheet = sheetName, startRow = 1, startCol = 1, header = FALSE)
saveWorkbook(SheetLikeAge)

date_title <- matrix(like_date, ncol=1, byrow=TRUE)
writeWorksheet(object = SheetLikeAge, data = date_title, sheet = sheetName, startRow = 2, startCol = 2, header = FALSE)
saveWorkbook(SheetLikeAge)

if(length(like_by_age) > 0){
	dataFacebook <- matrix(like_by_age, nrow = length(like_date))
	bodyRowHeight = 20;
	setRowHeight(
		object = SheetLikeAge,
		sheet = sheetName,
		row = seq_len(nrow(dataFacebook)+1),
		height = bodyRowHeight
	)

	bodyColumnWidth = 4000;
	setColumnWidth(
		object = SheetLikeAge,
		sheet = sheetName,
		column = 2,
		width = bodyColumnWidth
	)
	writeWorksheet(object = SheetLikeAge, data = dataFacebook, sheet = sheetName, startRow = 2, startCol = 3, header = FALSE)
	saveWorkbook(SheetLikeAge)
}

rm(dataTitle, dataFacebook)
gc()
rm(SheetLikeAge)
gc()
xlcFreeMemory()