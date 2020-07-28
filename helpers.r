data_dir <- "data"
dir.create(data_dir, showWarnings = FALSE, recursive=TRUE)

output_dir <- "output"
dir.create(output_dir, showWarnings=FALSE, recursive=TRUE)
for (format in c("pdf", "png")) {
  dir.create(paste(output_dir, format, sep="/"), showWarnings=FALSE, recursive=TRUE)
}

output_pdf <- function(output_filename) {
  output_pdf <- paste(output_dir, "pdf", paste0(output_filename, ".pdf"), sep="/")
  pdf(output_pdf, height=6, width=10)
}

daily_data_dir <- function(date) {
  dir <- paste(data_dir, date, sep="/")
  dir.create(dir, showWarnings = FALSE, recursive=TRUE)
  return(dir)
}

state_detail_data <- function() {
  state_detail_csv <- paste(data_dir, "state_detail.csv", sep="/")

  if (!file.exists(state_detail_csv)) {
    download.file("https://www2.census.gov/programs-surveys/popest/datasets/2010-2019/state/detail/SCPRC-EST2019-18+POP-RES.csv", state_detail_csv)
  }

  state_detail <- read.csv(state_detail_csv, header=TRUE)

  return(state_detail)
}

daily_data <- function(date, file, url) {
  daily_csv <- paste(daily_data_dir(date), file, sep="/")

  if (!file.exists(daily_csv)) {
    download.file(url, daily_csv)
  }

  daily <- read.csv(daily_csv, header=TRUE)
  daily$datep <- as.Date(strptime(daily$date, "%Y%m%d", tz="UTC"))
  daily$tpr <- 100.0 * (daily$positive / daily$total)

  return(daily)
}

state_daily_data <- function (date, state) {
  state_daily_csv <- paste0("https://covidtracking.com/api/v1/states/", state, "/daily.csv")
  return(daily_data(date, paste0(state, ".csv"), state_daily_csv))
}

us_daily_data <- function (date) {
  return(daily_data(date, "us.csv", "https://covidtracking.com/api/v1/us/daily.csv"))
}

states_current_data <- function(date) {
  current_csv <- paste(daily_data_dir(date), "states_current.csv", sep="/")

  if (!file.exists(current_csv)) {
    download.file("https://covidtracking.com/api/v1/states/current.csv", current_csv)
  }

  current <- read.csv(current_csv, header=TRUE)

  return(current)
}
