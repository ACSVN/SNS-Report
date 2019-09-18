#define worksheet
outputSheetLikeLanguage = outputPath

SheetLikeLanguage = loadWorkbook(filename =outputSheetLikeLanguage, create = TRUE)

sheetName = "Likes by language"

language_title = dataLifeTimeMetric$language_title
language_title_des = dataLifeTimeMetric$language_title_des
language_date = dataLifeTimeMetric$language_date
language_nrow = dataLifeTimeMetric$language_nrow
like_by_language = list()
if(length(dataLifeTimeMetric$like_by_language) > 0){
	like_by_language = as.numeric(dataLifeTimeMetric$like_by_language)
}

addtitle(SheetLikeLanguage,sheetName, language_title_des, 2, 1)

dataTitle	<- matrix(language_title, nrow=1)
writeWorksheet(object = SheetLikeLanguage, data = dataTitle, sheet = sheetName, startRow = 1, startCol = 1, header = FALSE)
saveWorkbook(SheetLikeLanguage)

date_title 	<- matrix(language_date, ncol=1, byrow=TRUE)
writeWorksheet(object = SheetLikeLanguage, data = date_title, sheet = sheetName, startRow = 2, startCol = 2, header = FALSE)
saveWorkbook(SheetLikeLanguage)

if(length(like_by_language) > 0){
	dataFacebook <- matrix(like_by_language, nrow=language_nrow)
	bodyRowHeight = 20;
	setRowHeight(
		object = SheetLikeLanguage,
		sheet = sheetName,
		row = seq_len(nrow(dataFacebook)+1),
		height = bodyRowHeight
	)

	bodyColumnWidth = 4000;
	setColumnWidth(
		object = SheetLikeLanguage,
		sheet = sheetName,
		column = seq_len(ncol(dataFacebook)),
		width = bodyColumnWidth
	)
	writeWorksheet(object = SheetLikeLanguage, data = dataFacebook, sheet = sheetName, startRow = 2, startCol = 3, header = FALSE)
	saveWorkbook(SheetLikeLanguage)
}

rm(dataTitle, dataFacebook)
gc()
rm(SheetLikeLanguage)
gc()
xlcFreeMemory()