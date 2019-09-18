getInputParams = function() {
  if (interactive()) {
    params = rjson::fromJSON(file = "../report_templates/test/parameters.json")
  } else {
    args = commandArgs(trailingOnly=TRUE)
    print(args)
    params = rjson::fromJSON(file = args[1])
  }
  return(params)
}
