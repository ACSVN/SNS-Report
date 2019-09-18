#define worksheet
outputSheet13P = outputPath

Sheet13P = loadWorkbook(filename =outputSheet13P, create = TRUE)

sheetName = "13P"

title_13p = dataPostDaily$title_13P
date_13p = dataPostDaily$date_13P
fan_per_day_val_13p = dataPostDaily$fan_per_month_13P
post_count_13p = dataPostDaily$post_count_13P
reach_count_13p = dataPostDaily$reach_count_13P
average_reach_13p = dataPostDaily$average_reach_13P
likes_count_13p = dataPostDaily$likes_count_13P
average_like_13p = dataPostDaily$average_like_13P
comments_count_13p = dataPostDaily$comments_count_13P
shares_count_13p = dataPostDaily$shares_count_13P
engagement_num_13p = dataPostDaily$engagement_num_13P
engagement_rate_13p = dataPostDaily$engagement_rate_13P
ins_engagement_13p = dataPostDaily$ins_engagement_13P
ins_engagement_rate_13p = dataPostDaily$ins_engagement_rate_13P

title   <- c('', '', 'Number of fans', title_13p[1], 'Post count', title_13p[2], 'Total reach', title_13p[3], 
                        'Average reach', title_13p[4], 'Total Like', title_13p[5], 'Average Like', title_13p[6], 
                        'Total comment', title_13p[7], 'Total share', title_13p[8], 'Engagement number', title_13p[9], 
                        'Engagement rate', title_13p[10], 'Insight engagement', title_13p[11], 'Insight Engagement Rate', title_13p[12])

title   <- matrix(title, nrow=2)

date    <- matrix(date_13p, ncol=1, byrow=TRUE)

dataFacebook    <- c(fan_per_day_val_13p, post_count_13p, reach_count_13p, average_reach_13p, likes_count_13p,
                        average_like_13p, comments_count_13p, shares_count_13p, engagement_num_13p, engagement_rate_13p,
                        ins_engagement_13p, ins_engagement_rate_13p)
dataFacebook    <- matrix(dataFacebook, nrow=length(fan_per_day_val_13p))

bodyRowHeight = 20;
setRowHeight(
        object = Sheet13P,
        sheet = sheetName,
        row = seq_len(nrow(dataFacebook))+1,
        height = bodyRowHeight
)
bodyColumnWidth = 4000;
setColumnWidth(
        object = Sheet13P,
        sheet = sheetName,
        column = seq_len(ncol(dataFacebook)+1),
        width = bodyColumnWidth
)
writeWorksheet(object = Sheet13P, data = title, sheet = sheetName, startRow = 2, startCol = 1, header = FALSE)
writeWorksheet(object = Sheet13P, data = date, sheet = sheetName, startRow = 4, startCol = 1, header = FALSE)
writeWorksheet(object = Sheet13P, data = dataFacebook, sheet = sheetName, startRow = 4, startCol = 2, header = FALSE)
saveWorkbook(Sheet13P)

color <- createCellStyle(Sheet13P)
setWrapText(color, wrap = TRUE)
setFillForegroundColor(color, color = XLC$"COLOR.GREY_25_PERCENT")
setFillPattern(color, fill = XLC$FILL.SOLID_FOREGROUND)
setBorder(color, side = c("bottom","top", "left", "right"), type = XLC$"BORDER.THIN", color = XLC$"COLOR.BLACK")
setCellStyle(Sheet13P, sheet = sheetName, row = 3, col = 1:(ncol(title)), cellstyle = color)

wrap_cell <- createCellStyle(Sheet13P)
setWrapText(wrap_cell, wrap = TRUE)
setCellStyle(Sheet13P, sheet = sheetName, row = 2, col = 1:(ncol(title)), cellstyle = wrap_cell)

#set border
border <- createCellStyle(Sheet13P)
setWrapText(border, wrap = TRUE)
setBorder(border, side = c("bottom","top", "left", "right"), type = XLC$"BORDER.THIN", color = XLC$"COLOR.BLACK")
for(i in 4:(nrow(dataFacebook) + 3)){
        setCellStyle(Sheet13P, sheet = sheetName, row = i, col = 2:(ncol(dataFacebook)+1), cellstyle = border)
        setCellStyle(Sheet13P, sheet = sheetName, row = i, col = 1, cellstyle = color)
}

# ワークブックをファイルに保存
saveWorkbook(Sheet13P)

rm(dataFacebook, color, wrap_cell, border)
gc()
rm(Sheet13P)
gc()
xlcFreeMemory()