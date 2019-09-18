#define worksheet
outputSheetLikeCity = outputPath

SheetLikeCity = loadWorkbook(filename =outputSheetLikeCity, create = TRUE)

sheetName = "Likes by city"
# createSheet(object = SheetLikeCity, name = sheetName)

city_title = dataLifeTimeMetric$city_title
city_title_des = dataLifeTimeMetric$city_title_des
city_date = dataLifeTimeMetric$city_date
city_nrow = dataLifeTimeMetric$city_nrow
like_by_city = list()
if(length(dataLifeTimeMetric$like_by_city) > 0){
	like_by_city = as.numeric(dataLifeTimeMetric$like_by_city)
}

addtitle(SheetLikeCity,sheetName, city_title_des, 2, 1)

dataTitle	<- matrix(city_title, nrow=1)
writeWorksheet(object = SheetLikeCity, data = dataTitle, sheet = sheetName, startRow = 1, startCol = 1, header = FALSE)
saveWorkbook(SheetLikeCity)

date_title 	<- matrix(city_date, ncol=1, byrow=TRUE)
writeWorksheet(object = SheetLikeCity, data = date_title, sheet = sheetName, startRow = 2, startCol = 2, header = FALSE)
saveWorkbook(SheetLikeCity)

if(length(like_by_city) > 0){
	dataFacebook <- matrix(like_by_city, nrow=city_nrow)
	bodyRowHeight = 20;
	setRowHeight(
		object = SheetLikeCity,
		sheet = sheetName,
		row = seq_len(nrow(dataFacebook)+1),
		height = bodyRowHeight
	)

	bodyColumnWidth = 4000;
	setColumnWidth(
		object = SheetLikeCity,
		sheet = sheetName,
		column = seq_len(ncol(dataFacebook)),
		width = bodyColumnWidth
	)
	writeWorksheet(object = SheetLikeCity, data = dataFacebook, sheet = sheetName, startRow = 2, startCol = 3, header = FALSE)
	saveWorkbook(SheetLikeCity)

	wrap_cell <- createCellStyle(SheetLikeCity)
	setWrapText(wrap_cell, wrap = TRUE)
	setCellStyle(SheetLikeCity, sheet = sheetName, row = 1, col =3:ncol(dataFacebook), cellstyle = wrap_cell)
	saveWorkbook(SheetLikeCity)
}

rm(dataTitle, dataFacebook)
gc()
rm(SheetLikeCity)
gc()
xlcFreeMemory()