#define worksheet
outputSheetLikeCountry = outputPath

SheetLikeCountry = loadWorkbook(filename =outputSheetLikeCountry, create = TRUE)

sheetName = "Likes by country"
# createSheet(object = SheetLikeCountry, name = sheetName)

country_title = dataLifeTimeMetric$country_title
country_title_des = dataLifeTimeMetric$country_title_des
country_date = dataLifeTimeMetric$country_date
country_nrow = dataLifeTimeMetric$country_nrow
like_by_country = list()
if(length(dataLifeTimeMetric$like_by_country) > 0){
	like_by_country = as.numeric(dataLifeTimeMetric$like_by_country)
}

# like_by_country = as.numeric(unlist(strsplit(dataLifeTimeMetric$like_by_country, split=",")))

addtitle(SheetLikeCountry,sheetName, country_title_des, 2, 1)

dataTitle	<- matrix(country_title, nrow=1)
writeWorksheet(object = SheetLikeCountry, data = dataTitle, sheet = sheetName, startRow = 1, startCol = 1, header = FALSE)
saveWorkbook(SheetLikeCountry)

date_title 	<- matrix(country_date, ncol=1, byrow=TRUE)
writeWorksheet(object = SheetLikeCountry, data = date_title, sheet = sheetName, startRow = 2, startCol = 2, header = FALSE)
saveWorkbook(SheetLikeCountry)
if(length(like_by_country) > 0){

	dataFacebook <- matrix(like_by_country, nrow=country_nrow)
	bodyRowHeight = 20;
	setRowHeight(
		object = SheetLikeCountry,
		sheet = sheetName,
		row = seq_len(nrow(dataFacebook)+1),
		height = bodyRowHeight
	)

	bodyColumnWidth = 4000;
	setColumnWidth(
		object = SheetLikeCountry,
		sheet = sheetName,
		column = seq_len(ncol(dataFacebook)),
		width = bodyColumnWidth
	)
	writeWorksheet(object = SheetLikeCountry, data = dataFacebook, sheet = sheetName, startRow = 2, startCol = 3, header = FALSE)
	saveWorkbook(SheetLikeCountry)
}

rm(dataTitle, dataFacebook)
gc()
rm(SheetLikeCountry)
gc()
xlcFreeMemory()