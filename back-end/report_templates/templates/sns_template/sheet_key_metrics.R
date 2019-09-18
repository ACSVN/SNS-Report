#define worksheet
outputSheetKeyMetric = outputPath

SheetKeyMetric = loadWorkbook(filename =outputSheetKeyMetric, create = TRUE)

sheetName = "Key Metrics"

key_metrics_date = dataFanMetric$key_metric_date
key_metrics_title = dataFanMetric$key_metrics_title
key_metrics_data = as.numeric(dataFanMetric$key_metrics_data)

dataFacebookHeader = 	matrix(nrow=1,key_metrics_title)

bodyRowHeight = 20;
setRowHeight(
	object = SheetKeyMetric,
	sheet = sheetName,
	row = seq_len(nrow(dataFacebookHeader)),
	height = bodyRowHeight
)
bodyColumnWidth = 4000;
setColumnWidth(
	object = SheetKeyMetric,
	sheet = sheetName,
	column = seq_len(ncol(dataFacebookHeader)),
	width = bodyColumnWidth
)
writeWorksheet(object = SheetKeyMetric, data = dataFacebookHeader, sheet = sheetName, startRow = 1, startCol = 2, header = FALSE)


dataFacebookData = 	matrix(nrow=length(key_metrics_date),key_metrics_data)
writeWorksheet(object = SheetKeyMetric, data = dataFacebookData, sheet = sheetName, startRow = 2, startCol = 2, header = FALSE)

dataFacebookData = 	matrix(nrow=length(key_metrics_date),key_metrics_date)
writeWorksheet(object = SheetKeyMetric, data = dataFacebookData, sheet = sheetName, startRow = 2, startCol = 1, header = FALSE)

saveWorkbook(SheetKeyMetric)

rm(dataFacebookHeader, dataFacebookData)
gc()
rm(SheetKeyMetric)
gc()
xlcFreeMemory()