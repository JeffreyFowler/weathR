% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/03-station_data.R
\name{.station_data}
\alias{.station_data}
\title{Raw JSON Station Metadata}
\usage{
.station_data(station_id)
}
\arguments{
\item{station_id}{The station identifier (ex: KDEN, KBOS, KNYC, etc).}
}
\value{
Station data provided for the National Weather Service.
}
\description{
Raw JSON Station Metadata
}
\examples{
\donttest{
.station_data("KDEN")
}
}
