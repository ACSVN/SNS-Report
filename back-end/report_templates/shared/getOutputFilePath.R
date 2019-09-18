getOutputFilePath = function(CLI = 0) {
  if (interactive()) {
    outputFilePath = "test/output.xlsx"
  } else {
    args = commandArgs(trailingOnly=TRUE)
    outputFilePath = args[2]
  }
  return(outputFilePath)
}
