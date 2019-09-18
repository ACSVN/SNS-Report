#define worksheet
outputSheet7P = outputPath

Sheet7P = loadWorkbook(filename =outputSheet7P, create = TRUE)

sheetName = "7P"

#set border
border <- createCellStyle(Sheet7P)
setBorder(border, side = c("bottom","top", "left", "right"), type = XLC$"BORDER.THIN", color = XLC$"COLOR.BLACK")

###############################################################################################################

# Data like by country

country_top_ten_name = dataLifeTimeMetric$country_top_ten_name
country_top_ten_fans = as.numeric(dataLifeTimeMetric$country_top_ten_fans/dataLifeTimeMetric$country_total_fans)

dataCountry <- matrix(country_top_ten_name, ncol=1, byrow=TRUE)
country_per <- matrix(country_top_ten_fans, ncol=1, byrow=TRUE)
bodyRowHeight = 20;
setRowHeight(
	object = Sheet7P,
	sheet = sheetName,
	row = seq_len(nrow(dataCountry)+1),
	height = bodyRowHeight
)
bodyColumnWidth = 4000;
setColumnWidth(
	object = Sheet7P,
	sheet = sheetName,
	column = seq_len(ncol(dataCountry))+1,
	width = bodyColumnWidth
)

# Like by age
title <- 'Likes by country'
addtitle(Sheet7P,sheetName, title, 1, 2)

writeWorksheet(object = Sheet7P, data = dataCountry, sheet = sheetName, startRow = 2, startCol = 2, header = FALSE)
writeWorksheet(object = Sheet7P, data = country_per, sheet = sheetName, startRow = 3, startCol = 3, header = FALSE)

title <- '%'
addtitle(Sheet7P,sheetName, title, 2, 3)

saveWorkbook(Sheet7P)

for(i in 2:(nrow(dataCountry)+1)){
	setCellStyle(Sheet7P, sheet = sheetName, row = i, col = 2:(ncol(dataCountry)+2), cellstyle = border)
}

saveWorkbook(Sheet7P)

ncolcurrent = ncol(dataCountry)+4

###############################################################################################################

# Data like by city

city_top_ten_name = dataLifeTimeMetric$city_top_ten_name
city_top_ten_fans = as.numeric(dataLifeTimeMetric$city_top_ten_fans/dataLifeTimeMetric$city_total_fans)

dataCity <- matrix(city_top_ten_name, ncol=1, byrow=TRUE)
city_per <- matrix(city_top_ten_fans, ncol=1, byrow=TRUE)

bodyRowHeight = 20;
setRowHeight(
	object = Sheet7P,
	sheet = sheetName,
	row = seq_len(nrow(dataCity)+1),
	height = bodyRowHeight
)
bodyColumnWidth = 4000;
setColumnWidth(
	object = Sheet7P,
	sheet = sheetName,
	column = seq_len(ncol(dataCity))+ncolcurrent-1,
	width = bodyColumnWidth
)

# Like by age
title <- 'Likes by city'
addtitle(Sheet7P,sheetName, title, 1, ncolcurrent)

writeWorksheet(object = Sheet7P, data = dataCity, sheet = sheetName, startRow = 2, startCol = ncolcurrent, header = FALSE)

addtitle(Sheet7P,sheetName, '%', 2, ncolcurrent+1)

writeWorksheet(object = Sheet7P, data = city_per, sheet = sheetName, startRow = 3, startCol = ncolcurrent+1, header = FALSE)

saveWorkbook(Sheet7P)

for(i in 2:(nrow(dataCity)+1)){
	setCellStyle(Sheet7P, sheet = sheetName, row = i, col = ncolcurrent:(ncolcurrent+ncol(dataCity)), cellstyle = border)
}

saveWorkbook(Sheet7P)

ncolcurrent = ncolcurrent+ncol(dataCity)+2

###############################################################################################################

# Data like by language

language_top_ten_name = dataLifeTimeMetric$language_top_ten_name
language_top_ten_fans = as.numeric(dataLifeTimeMetric$language_top_ten_fans/dataLifeTimeMetric$language_total_fans)

dataLanguage <- matrix(language_top_ten_name, ncol=1, byrow=TRUE)
language_per <- matrix(language_top_ten_fans, ncol=1, byrow=TRUE)

bodyRowHeight = 20;
setRowHeight(
	object = Sheet7P,
	sheet = sheetName,
	row = seq_len(nrow(dataLanguage)+1),
	height = bodyRowHeight
)
bodyColumnWidth = 4000;
setColumnWidth(
	object = Sheet7P,
	sheet = sheetName,
	column = seq_len(ncol(dataLanguage))+ncolcurrent-1,
	width = bodyColumnWidth
)

# Like by age
title <- 'Likes by language'
addtitle(Sheet7P,sheetName, title, 1, ncolcurrent)

writeWorksheet(object = Sheet7P, data = dataLanguage, sheet = sheetName, startRow = 2, startCol = ncolcurrent, header = FALSE)

addtitle(Sheet7P,sheetName, '%', 2, ncolcurrent+1)

writeWorksheet(object = Sheet7P, data = language_per, sheet = sheetName, startRow = 3, startCol = ncolcurrent+1, header = FALSE)

saveWorkbook(Sheet7P)

for(i in 2:(nrow(dataLanguage)+1)){
	setCellStyle(Sheet7P, sheet = sheetName, row = i, col = ncolcurrent:(ncolcurrent+ncol(dataLanguage)), cellstyle = border)
}

saveWorkbook(Sheet7P)

ncolcurrent = ncolcurrent+ncol(dataLanguage)+3

rm(border, dataCountry, dataCity, dataLanguage)
gc()
rm(Sheet7P)
gc()
xlcFreeMemory()