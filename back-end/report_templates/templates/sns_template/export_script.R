library(stringr)
library(XLConnect)

plot2img <- function(expr,slide_name,sheetName, width, height, res, retina = TRUE, 
	device = "auto", contentType = "image/png", ...) {
  
	pngfun <- if (is.function(device)) {
		device
	} else if (!missing(device)) {
		stop("Invalid device argument")
	} else if (capabilities("aqua")) {
		grDevices::png
	} else if (nchar(system.file(package = "Cairo"))) {
		Cairo::CairoPNG
	} else {
		grDevices::png
	}
  
	tmpfile <- tempfile(fileext = ".png")

	if (isTRUE(retina)) {
		retina <- 2
	} else if (identical(retina, FALSE)) {
		retina <- 1
	}
  
	physHeight <- height * retina
	physWidth <- width * retina
	physRes <- res * retina
  
	pngfun(filename = tmpfile, width = width * retina, height = height * retina, res = res * retina, ...)
	op <- graphics::par(mar = rep(0, 4))
	tryCatch(graphics::plot.new(), finally = graphics::par(op))
	dv <- grDevices::dev.cur()
	tryCatch(
		{
			result <- withVisible(expr)
			if (result$visible) {
				utils::capture.output(print(result$value))
			}
		},
		finally = grDevices::dev.off(dv)
	)

  	# Write image to the named region created above
	addImage(slide_name, filename = tmpfile, name=sheetName, originalSize = TRUE)

	# Save workbook (this actually writes the file to disk)
	saveWorkbook(slide_name)
  
  # on.exit(unlink(tmpfile), add = TRUE)
  
	b64data <- base64enc::base64encode(tmpfile, 0)
	htmltools::tags$img(src = paste0("data:", contentType, ";base64,", b64data),
			style = htmltools::css(
			width = htmltools::validateCssUnit(width),
			height = htmltools::validateCssUnit(height)
		)
	)
}

addlogo <- function(slide_name,sheetName){
	logoCol = 1
	logoColLeter = LETTERS[logoCol]

	logoCellFormula = sprintf("%s!$%s$%d", sheetName, logoColLeter, 1)

	logo = tempfile(fileext = ".png")
	download.file(
		url = "https://www.addix.co.jp/wp-content/uploads/2016/10/addix_logo_21.png",
		destfile = logo
	)

	cellLogo = basename(logo)
	createName(
		object = slide_name,
		name = cellLogo,
		formula = logoCellFormula,
		overwrite = TRUE
	) 

	addImage(
		object = slide_name,
		filename = logo,
		name = cellLogo
	)
	file.remove(logo) # cleanup
}

mergecell <- function(slide_name,sheetName){
	startRow = 2
	colFrom = 3
	colLeter = LETTERS[colFrom]
	cellFormulaFrom = sprintf("%s!$%s$%d", sheetName, colLeter, startRow)

	startRow = 2
	colTo = 9
	colLeter = LETTERS[colTo]
	cellFormulaTo = sprintf("%s!$%s$%d", sheetName, colLeter, startRow)

	title_merge = sprintf("%s:%s", cellFormulaFrom, cellFormulaTo)

	startRow = 3
	colFrom = 1
	colLeter = LETTERS[colFrom]
	cellFormulaFrom = sprintf("%s!$%s$%d", sheetName, colLeter, startRow)

	startRow = 3
	colTo = 9
	colLeter = LETTERS[colTo]
	cellFormulaTo = sprintf("%s!$%s$%d", sheetName, colLeter, startRow)

	sub_title_merge = sprintf("%s:%s", cellFormulaFrom, cellFormulaTo)

	startRow = 3
	colFrom = 11
	colLeter = LETTERS[colFrom]
	cellFormulaFrom = sprintf("%s!$%s$%d", sheetName, colLeter, startRow)

	startRow = 3
	colTo = 13
	colLeter = LETTERS[colTo]
	cellFormulaTo = sprintf("%s!$%s$%d", sheetName, colLeter, startRow)

	sub_title_top_lower_merge = sprintf("%s:%s", cellFormulaFrom, cellFormulaTo)

	mergeCells(slide_name, sheet = sheetName, reference = c(title_merge, sub_title_merge, sub_title_top_lower_merge))
}

addtitle <- function(slide_name, sheetName, title, nRow, nCol) {
	writeWorksheet(object = slide_name, title, sheet = sheetName, startRow = nRow, startCol = nCol, header = FALSE)
	saveWorkbook(slide_name)
}

countHiragana <- function (s) {
  str_length(str_replace_all(s, "[^\\p{Block=Hiragana}]", ""))
}

countKatakana <- function (s) {
  str_length(str_replace_all(s, "[^\\p{Block=Katakana}]", ""))
}
countKanji <- function (s) {
  str_length(str_replace_all(s, "[^\\p{Block=CJK Unified Ideographs}]", ""))
}