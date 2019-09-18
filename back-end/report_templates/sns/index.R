suppressWarnings({
  suppressPackageStartupMessages({
    library("Rfacebook")
    library("dotenv")
    library("lubridate")
    library("ReporteRs")
    library("tidyr")
    library("dplyr")
    library("stringr")
    library("ggplot2")
    library("scales")
    library('rjson')
    library ('plyr')
    library('XLConnect')
  })
})

# ロケール
Sys.setlocale("LC_ALL", "ja_JP.UTF-8")
# print(getwd())
# Load shared functions
sharedFunctionsLoader = normalizePath(paste("..","shared", "load.R", sep = .Platform$file.sep))
source(sharedFunctionsLoader, chdir = TRUE)

params = getInputParams()
outputPath = getOutputFilePath()
accessToken = params[2]$accessToken

#
# fetch Data
#
try({
    dataPost = normalizePath(paste('..', 'sns/getDataPostReachFanAddRemove.R', sep = .Platform$file.sep))
    source(dataPost, chdir = TRUE)
    dataPosts = getDataPostReachFanAddRemove(params)

    # print(dataPost)
    dataPageFan = normalizePath(paste('..', 'sns/getDataFanPageLikeSourceMetric.R', sep = .Platform$file.sep))
    source(dataPageFan, chdir = TRUE)
    dataFan = getDataFanPageLikeSourceMetric(params)
    
    dataFanOnDayTime = normalizePath(paste('..', 'sns/getDataFanOnDayOnTime.R', sep = .Platform$file.sep))
    source(dataFanOnDayTime, chdir = TRUE)
    dataOnDayTime = getDataFanOnDayOnTime(params)
    
    parseDataInvolePageFan = normalizePath(paste('..', 'sns/parseDataInvolePageFan.R', sep = .Platform$file.sep))
    source(parseDataInvolePageFan, chdir = TRUE)
    dataFanMetric = parseDataInvolePageFan(dataFan)

    parseDataPostToDaily = normalizePath(paste('..', 'sns/parseDataInvolePostByDaily.R', sep = .Platform$file.sep))
    source(parseDataPostToDaily, chdir = TRUE)
    dataPostDaily = parseDataInvolePostByDaily(dataPosts)

    # get data involve time period
    dataTimePeriod = normalizePath(paste('..', 'sns/getDataByTimePeriod.R', sep = .Platform$file.sep))
    source(dataTimePeriod, chdir = TRUE)
    dataResult = getDataByTimePeriod(params)

    # parse data of time preriod for all sheet involve period = day
    parseDataDayMetric = normalizePath(paste('..', 'sns/parseDataInvolveDayMetric.R', sep = .Platform$file.sep))
    source(parseDataDayMetric, chdir = TRUE)
    dataDayMetric = parseDataInvolveDayMetric(dataResult)

    # parse data of time preriod for all sheet involve period = lifetime
    parseDataLifeTimeMetric = normalizePath(paste('..', 'sns/parseDataInvoleLifeTimeMetric.R', sep = .Platform$file.sep))
    source(parseDataLifeTimeMetric, chdir = TRUE)
    dataLifeTimeMetric = parseDataInvoleLifeTimeMetric(dataResult)

    # parse data of time preriod for all sheet involve week and time
    parseDataWeekTimeMetric = normalizePath(paste('..', 'sns/parseDataInvoleWeekTime.R', sep = .Platform$file.sep))
    source(parseDataWeekTimeMetric, chdir = TRUE)
    dataWeekTimeMetric = parseDataInvoleWeekTime(dataResult)
})

# sheet need export

try({
    #load function are all shared
    export_script = normalizePath(paste('..', 'templates/sns_template', 'export_script.R', sep = .Platform$file.sep))
    source(export_script, chdir = TRUE)
})

try({
    sheet_5p = normalizePath(paste('..', 'templates/sns_template', 'sheet_5p.R', sep = .Platform$file.sep))
    source(sheet_5p, chdir = TRUE)
})

try({
    sheet_6p = normalizePath(paste('..', 'templates/sns_template', 'sheet_6p.R', sep = .Platform$file.sep))
    source(sheet_6p, chdir = TRUE)
})

try({
    sheet_7p = normalizePath(paste('..', 'templates/sns_template', 'sheet_7p.R', sep = .Platform$file.sep))
    source(sheet_7p, chdir = TRUE)
})

try({
    sheet_7p_8p = normalizePath(paste('..', 'templates/sns_template', 'sheet_7p_8p.R', sep = .Platform$file.sep))
    source(sheet_7p_8p, chdir = TRUE)
})

try({
    sheet_10p = normalizePath(paste('..', 'templates/sns_template', 'sheet_10p.R', sep = .Platform$file.sep))
    source(sheet_10p, chdir = TRUE)
})

try({
    sheet_12p = normalizePath(paste('..', 'templates/sns_template', 'sheet_12p.R', sep = .Platform$file.sep))
    source(sheet_12p, chdir = TRUE)
})

try({
    sheet_13p = normalizePath(paste('..', 'templates/sns_template', 'sheet_13p.R', sep = .Platform$file.sep))
    source(sheet_13p, chdir = TRUE)
})

try({
    sheet_14p = normalizePath(paste('..', 'templates/sns_template', 'sheet_14p.R', sep = .Platform$file.sep))
    source(sheet_14p, chdir = TRUE)
})

try({
    sheet_key_metrics = normalizePath(paste('..', 'templates/sns_template', 'sheet_key_metrics.R', sep = .Platform$file.sep))
    source(sheet_key_metrics, chdir = TRUE)
})

try({
    sheet_like_by_age = normalizePath(paste('..', 'templates/sns_template', 'sheet_like_by_age.R', sep = .Platform$file.sep))
    source(sheet_like_by_age, chdir = TRUE)
})

try({
    sheet_like_by_country = normalizePath(paste('..', 'templates/sns_template', 'sheet_like_by_country.R', sep = .Platform$file.sep))
    source(sheet_like_by_country, chdir = TRUE)
})

try({
    sheet_like_by_city = normalizePath(paste('..', 'templates/sns_template', 'sheet_like_by_city.R', sep = .Platform$file.sep))
    source(sheet_like_by_city, chdir = TRUE)
})

try({
    sheet_like_by_language = normalizePath(paste('..', 'templates/sns_template', 'sheet_like_by_language.R', sep = .Platform$file.sep))
    source(sheet_like_by_language, chdir = TRUE)
})

try({
    sheet_like_by_week = normalizePath(paste('..', 'templates/sns_template', 'sheet_like_by_week.R', sep = .Platform$file.sep))
    source(sheet_like_by_week, chdir = TRUE)
})

try({
    sheet_like_by_time = normalizePath(paste('..', 'templates/sns_template', 'sheet_like_by_time.R', sep = .Platform$file.sep))
    source(sheet_like_by_time, chdir = TRUE)
})

try({
    sheet_reach_by_age = normalizePath(paste('..', 'templates/sns_template', 'sheet_reach_by_age.R', sep = .Platform$file.sep))
    source(sheet_reach_by_age, chdir = TRUE)
})

try({
    sheet_action_by_age = normalizePath(paste('..', 'templates/sns_template', 'sheet_action_by_age.R', sep = .Platform$file.sep))
    source(sheet_action_by_age, chdir = TRUE)
})

