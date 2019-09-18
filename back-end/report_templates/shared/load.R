#
# load all *.R files under the working directory
#
# files = setdiff(files, c("fbr_auth.R","load.R","report_templates/shared/fbr_auth.R","report_templates/shared/load.R"))
files = list.files(pattern = "\\.R$", recursive = TRUE)
files = setdiff(files, "load.R")
for(f in files) {
  # message("loading: ", f)
  source(f, chdir = TRUE)
}
