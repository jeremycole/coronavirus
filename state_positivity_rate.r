#!/usr/bin/env R -f

source("helpers.r")

output_dir <- "output"
dir.create(output_dir, showWarnings=FALSE, recursive=TRUE)

max_date <- Sys.Date()
state_highlights <- c("tn", "tx", "nv")
state_highlights_str <- paste(state_highlights, collapse="_")

current <- states_current_data(max_date)
states <- tolower(current$state)
us <- us_daily_data(max_date)

output_pdf(paste0(paste("covid_state_positivity_rate", max_date, state_highlights_str, sep="_"), ".pdf"))

plot(us$datep, us$tpr, xlim=c(as.Date("2020-05-01"), max_date), ylim=c(0, 20), type="l", ylab="Test Positivity Rate (%)", xlab="Date", main="State Test Positivity Rate over Time")
text(max(us$datep)+2, us$tpr[us$datep == max(us$datep)], "US", cex=0.8, col="black")

for(state in state_highlights) {
  st <- state_daily_data(max_date, state)
  lines(st$datep, st$tpr, col=ifelse(st$tpr[st$datep == max(st$datep)] > us$tpr[us$datep == max(us$datep)], "red", "lightgray"))
  text(max(st$datep)+2, st$tpr[st$datep == max(st$datep)], toupper(state), cex=0.8, col="black")
}

mtext("Data sources: The COVID Tracking Project <covidtracking.com>", 1, line=-1.5, outer=TRUE, cex=0.5)
mtext(paste("Compiled by Jeremy Cole <jeremy@jcole.us> / @jeremycole on", Sys.Date()), 1, line=-1.0, outer=TRUE, cex=0.5)

dev.off()

