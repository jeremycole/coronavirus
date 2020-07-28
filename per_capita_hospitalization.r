#!/usr/bin/env R -f

source("helpers.r")

output_dir <- "output"
dir.create(output_dir, showWarnings=FALSE, recursive=TRUE)

min_date <- as.Date("2020-03-15")
max_date <- Sys.Date()
state_highlights <- c("nv", "az", "tx")
state_highlights_str <- paste(state_highlights, collapse="_")

state_detail <- state_detail_data()
current <- states_current_data(max_date)
states <- tolower(current$state)

output_pdf(paste("covid_per_capita_hospitalizations", max_date, state_highlights_str, sep="_"))

plot(min_date + 1:150, 0 * 1:150, type="n", xlim=c(min_date, max_date), ylim=c(0, 100), xlab="Date", ylab="Hospitalization Rate (per 100k)", main=paste("COVID-19 Per-Capita Hospitalization Rate", paste("Highlighted:", paste(toupper(state_highlights), collapse=", ")), sep="\n"))
for(state in states) {
  d <- state_daily_data(max_date, state)
  population <- state_detail$POPESTIMATE20[state_detail$STATE == d$fips[1]]

  if (length(population) > 0) {
    y <- (100000 * (d$hospitalizedCurrently / population))
    lines(d$datep, y, col="lightgray")
  }
}

for(state in state_highlights) {
  d <- state_daily_data(max_date, state)
  population <- state_detail$POPESTIMATE20[state_detail$STATE == d$fips[1]]
  color <- match(state, state_highlights)+1
  
  y <- (100000 * (d$hospitalizedCurrently / population))
  lines(d$datep, (100000 * (d$hospitalizedCurrently / population)), col=color)
  text(max_date+3, y[d$datep == max(d$datep)], toupper(state), cex=0.5, col="black")
}

mtext("Data sources: United States Census Bureau <census.gov> 2019 Population Estimates; The COVID Tracking Project <covidtracking.com>", 1, line=-1.5, outer=TRUE, cex=0.5)
mtext(paste("Compiled by Jeremy Cole <jeremy@jcole.us> / @jeremycole on", Sys.Date()), 1, line=-1.0, outer=TRUE, cex=0.5)

dev.off()
